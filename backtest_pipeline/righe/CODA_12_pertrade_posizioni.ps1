# =====================================================================
#  MARCATORE_CODA_12_PERTRADE_POSIZIONI_v1
#  RUNNER_SOLA_LETTURA
# ---------------------------------------------------------------------
#  COSA FA: apre i per-trade che gli EA lasciano in Common\Files e, per
#  ognuno, stampa TRE numeri che nessuno oggi legge:
#     - i DEAL DI USCITA          (= righe meno l'intestazione)
#     - le POSIZIONI              (= position_id DISTINTI)
#     - il RAPPORTO deal/posizione
#  piu' il primo e l'ultimo close_time, la data del file e il confronto
#  fra le celle GEMELLE dello stesso EA e simbolo.
#  Legge e stampa. Non scrive, non duplica, non cancella, non chiude
#  niente, non apre nessun terminale.
#
#  PERCHE' ESISTE -- UN BUCO STRUTTURALE MISURATO IL 12/09/2026
#  La corsia ROUND del runner NON HA NESSUN CANALE PER IL PER-TRADE.
#  Contato sulle occorrenze della stringa 'abtg_trades' nella catena
#  che gira davvero:
#     runner_abtg.ps1                 -> 0
#     righe\RIGA_SOTTILE_ROUND.ps1    -> 0
#     righe\RIGA_ROUND_VPS.ps1        -> 0  (e la cartella 'Common'
#                                        viene SALTATA di proposito)
#     walkforward_generico.ps1        -> 2, e sono due righe di
#                                        Write-Host di consiglio
#  CONTRO-ESEMPIO, perche' un grep a zero da solo non dimostra niente:
#  36 script su 98 in righe\RIGA_*.ps1 quel nome ce l'hanno e i
#  per-trade li raccolgono (RIGA_BREAKIN, RIGA_CRT_*, RIGA_NYRETEST...).
#  Il token esiste nel repo: e' la corsia ROUND che non ce l'ha.
#  La raccolta della corsia ROUND porta a casa SOLO i due CSV di
#  riepilogo + il referto + il file prova. E nei CSV di riepilogo l'unico
#  conteggio e' la colonna Trades, che conta i DEAL DI USCITA, non le
#  posizioni: e' la classe 226, e su ABTG_EMA200 U30USD il fattore
#  misurato e' 2.0117. Chi legge quel numero come "operazioni" sbaglia
#  del doppio, e l'Emendamento A si decide sulle OPERAZIONI.
#
#  E LA REGOLA DI CASA CHIEDE ESATTAMENTE QUESTO, da prima di me:
#  CHECKLIST_RIGA_DI_LANCIO.md, regola tripla:
#    punto 2 -- "gli artefatti si RICONTANO, non si Test-Path. Per un
#      per-trade il conto e' righe - 1 = operazioni, ed e' esattamente
#      il numero che il PASSO 0 sta misurando: va NEL REFERTO, non
#      lasciato a chi apre il CSV. Tre esiti DIVERSI: file assente /
#      file a sola intestazione / N operazioni."
#    punto 3 -- "se il round schiera i GEMELLI, il referto CONFRONTA i
#      due numeri. Due passate identiche che danno conti diversi = banco
#      non deterministico = la misura non si legge."
#  Questa riga fa il punto 2 e il punto 3. Il punto 1 e' una toppa
#  all'EA e NON la fa nessuno script: sta nella checklist, non qui.
#
#  DOVE VA IN CODA: IN FONDO, dopo i round. Non per cortesia: per
#  ORDINE DI CAUSA. I per-trade li scrive il tester, quindi prima
#  devono girare i round. E c'e' un secondo motivo, misurato: nella
#  catena del runner non esiste NESSUN timeout, quindi il codice NUOVO
#  si mette dove, se si piantasse, ha gia' alle spalle tutto il resto.
#  (Il beneficio della POSIZIONE IN TESTA invece e' ZERO, ed e' misurato:
#  classe 274 -- il referto lo scrive il runner DOPO il ciclo, quindi
#  riga 11 e riga 32 si leggono nello stesso istante.)
#
#  LIMITI DICHIARATI, tutti e quattro
#   1. Common\Files e' UNA SOLA cartella, condivisa da TUTTI i terminali
#      di questo utente Windows. Un per-trade non dice da quale
#      terminale viene: dice EA, simbolo e magic. La data del file e'
#      l'unico modo di sapere se e' di stanotte, e la stampo.
#   2. Il nome del file NON contiene la FINESTRA. Due gambe dello stesso
#      walkforward condividono i magic e la seconda sovrascrive la prima
#      (ABTG_EMA200.mq5 r.616-620, FILE_WRITE = troncamento). Quindi il
#      conteggio descrive L'ULTIMA gamba girata, non quella che si
#      voleva: chi legge deve sapere quale gamba gira per ultima.
#   3. Il conteggio delle posizioni e' un conteggio di position_id
#      DISTINTI. Se una posizione fosse aperta in netting da piu'
#      ingressi resterebbe UNA: e' giusto cosi' per l'Emendamento A.
#   4. Tetto dichiarato: file oltre 40 MB o oltre 400000 righe non si
#      leggono per intero, e la riga lo dice invece di fingere. Serve a
#      non piantare una catena che non ha timeout.
#
#  PARAMETRO: -Cartella, opzionale. Serve SOLO a poter collaudare questa
#  riga fuori dal VPS, su una cartella finta con dei per-trade noti
#  (fatto il 12/09/2026: 517 deal / 257 posizioni riprodotti). In coda
#  non si passa nessun argomento e vale il default, cioe' Common\Files.
# =====================================================================
param([string]$Cartella = "")

$ErrorActionPreference = "Continue"

function Titolo($t){ Write-Host ""; Write-Host ("=== " + $t + " ===") -ForegroundColor Cyan }

Write-Host "#####################################################################"
Write-Host "#  CODA_12 -- PER-TRADE: DEAL, POSIZIONI, RAPPORTO                  #"
Write-Host "#  MARCATORE_CODA_12_PERTRADE_POSIZIONI_v1                           #"
Write-Host ("#  ora locale di questa macchina: " + (Get-Date).ToString("yyyy-MM-dd HH:mm:ss"))
Write-Host "#  SOLA LETTURA: apre file e stampa numeri.                          #"
Write-Host "#####################################################################"

$cart = $Cartella
if([string]::IsNullOrWhiteSpace($cart)){
  $cart = Join-Path $env:APPDATA "MetaQuotes\Terminal\Common\Files"
}
Write-Host ""
Write-Host ("cartella letta : " + $cart)

if(-not (Test-Path -LiteralPath $cart)){
  Write-Host "ESITO: la cartella NON ESISTE. Nessun per-trade da contare." -ForegroundColor Yellow
  Write-Host "       Non e' un guasto di questa riga: e' un fatto, e va letto come tale."
  return
}

# ---------------------------------------------------------------------
#  IL CONTEGGIO, in streaming. Non carico il file in memoria: un
#  per-trade di una griglia larga puo' essere grosso, e questa catena
#  non ha timeout. La condivisione e' ReadWrite perche' MT5 puo' avere
#  il file ancora aperto (lo stesso accorgimento di CODA_05).
# ---------------------------------------------------------------------
function ContaPerTrade([string]$path){
  $r = @{ ok=$false; motivo=""; deal=0; posizioni=0; rapporto=0.0; primo=""; ultimo=""; tagliato=$false }
  $fi = $null
  try{ $fi = Get-Item -LiteralPath $path -ErrorAction Stop }catch{ $r.motivo = "non leggibile"; return $r }
  if($fi.Length -gt 41943040){ $r.motivo = ("TETTO: " + [math]::Round($fi.Length/1MB,1) + " MB, oltre i 40 MB dichiarati. NON contato."); return $r }

  $sr = $null
  try{
    $fs = [IO.File]::Open($path,[IO.FileMode]::Open,[IO.FileAccess]::Read,[IO.FileShare]::ReadWrite)
    $sr = New-Object IO.StreamReader($fs)
  }catch{ $r.motivo = "aperto da qualcun altro in modo esclusivo"; return $r }

  $iPid = -1; $iClose = -1; $n = 0; $righe = 0
  $visti = New-Object 'System.Collections.Generic.HashSet[string]'
  try{
    $intest = $sr.ReadLine()
    if($null -eq $intest){ $r.motivo = "file VUOTO (zero byte utili)"; return $r }
    $hh = $intest.Split(';')
    for($i=0; $i -lt $hh.Length; $i++){
      $k = $hh[$i].Trim().Trim('"')
      if($k -eq "position_id"){ $iPid = $i }
      if($k -eq "close_time"){  $iClose = $i }
    }
    if($iPid -lt 0){
      $r.motivo = ("intestazione senza colonna position_id: [" + $intest + "]")
      return $r
    }
    while($true){
      $l = $sr.ReadLine()
      if($null -eq $l){ break }
      $righe++
      if($righe -gt 400000){ $r.tagliato = $true; break }
      if($l.Trim() -eq ""){ continue }
      $c = $l.Split(';')
      if($c.Length -le $iPid){ continue }
      $n++
      [void]$visti.Add($c[$iPid].Trim())
      if($iClose -ge 0 -and $c.Length -gt $iClose){
        $t = $c[$iClose].Trim()
        if($r.primo -eq ""){ $r.primo = $t }
        $r.ultimo = $t
      }
    }
  }catch{
    $r.motivo = ("lettura interrotta: " + $_.Exception.Message)
    return $r
  }finally{
    if($null -ne $sr){ $sr.Close() }
  }

  $r.deal = $n
  $r.posizioni = $visti.Count
  if($visti.Count -gt 0){ $r.rapporto = [math]::Round($n / $visti.Count, 4) }
  $r.ok = $true
  return $r
}

# ---------------------------------------------------------------------
Titolo "I PER-TRADE PRESENTI, dal piu' fresco al piu' vecchio"
$tutti = @(Get-ChildItem -LiteralPath $cart -File -Filter "abtg_trades_*.csv" -ErrorAction SilentlyContinue | Sort-Object LastWriteTime -Descending)
Write-Host ("file abtg_trades_*.csv trovati: " + $tutti.Count)
if($tutti.Count -eq 0){
  Write-Host "ESITO: NESSUN per-trade in questa cartella." -ForegroundColor Yellow
  Write-Host "       Se stanotte e' girato un round che doveva produrne, questo e' il"
  Write-Host "       primo numero da guardare: o il pass non e' stato rieseguito (cache"
  Write-Host "       del tester), o l'EA non esporta, o il magic non e' quello."
  return
}

$esiti = @()
foreach($f in $tutti){
  $c = ContaPerTrade $f.FullName
  $riga = @{ nome=$f.Name; kb=[math]::Round($f.Length/1KB,1); data=$f.LastWriteTime.ToString("yyyy-MM-dd HH:mm:ss"); c=$c }
  $esiti += $riga
  Write-Host ""
  Write-Host ("  " + $f.Name)
  Write-Host ("     data file  : " + $riga.data + "   dimensione: " + $riga.kb + " KB")
  if(-not $c.ok){
    Write-Host ("     ESITO      : NON CONTATO -- " + $c.motivo) -ForegroundColor Yellow
    continue
  }
  if($c.deal -eq 0){
    Write-Host "     ESITO      : SOLA INTESTAZIONE (zero deal di uscita)." -ForegroundColor Yellow
    Write-Host "                  Sono DUE cose diverse e non si confondono: la passata"
    Write-Host "                  ha girato e non ha chiuso niente, OPPURE una gamba"
    Write-Host "                  successiva ha troncato il file di quella buona."
    continue
  }
  Write-Host ("     deal uscita: " + $c.deal)
  Write-Host ("     POSIZIONI  : " + $c.posizioni + "   <<< e' questa l'unita' dell'Emendamento A")
  Write-Host ("     rapporto   : " + $c.rapporto + "   (deal per posizione)")
  Write-Host ("     close_time : dal " + $c.primo + "  al  " + $c.ultimo)
  if($c.tagliato){
    Write-Host "     ATTENZIONE : TETTO DI RIGHE RAGGIUNTO (400000): i numeri sopra sono PARZIALI." -ForegroundColor Red
  }
}

# ---------------------------------------------------------------------
Titolo "IL CONFRONTO DEI GEMELLI (regola tripla, punto 3)"
Write-Host "Due celle identiche tranne il magic DEVONO dare gli stessi conti."
Write-Host "Se non li danno, il banco non e' deterministico e la misura NON si legge."
$gruppi = @{}
foreach($e in $esiti){
  if(-not $e.c.ok){ continue }
  $base = $e.nome -replace '_[0-9]+\.csv$', ''
  if(-not $gruppi.ContainsKey($base)){ $gruppi[$base] = @() }
  $gruppi[$base] += $e
}
$divergenti = 0
foreach($k in ($gruppi.Keys | Sort-Object)){
  $g = @($gruppi[$k])
  if($g.Count -lt 2){
    Write-Host ("  " + $k + " : una sola cella, nessun gemello da confrontare.")
    continue
  }
  $dd = @($g | ForEach-Object { $_.c.deal } | Sort-Object -Unique)
  $pp = @($g | ForEach-Object { $_.c.posizioni } | Sort-Object -Unique)
  if($dd.Count -eq 1 -and $pp.Count -eq 1){
    Write-Host ("  " + $k + " : " + $g.Count + " celle, TUTTE a " + $dd[0] + " deal / " + $pp[0] + " posizioni -- GEMELLI COERENTI") -ForegroundColor Green
  } else {
    $divergenti++
    Write-Host ("  " + $k + " : " + $g.Count + " celle, GEMELLI DIVERGENTI -- deal " + ($dd -join "/") + " e posizioni " + ($pp -join "/")) -ForegroundColor Red
    foreach($e in $g){ Write-Host ("        " + $e.nome + "  " + $e.c.deal + " deal  " + $e.c.posizioni + " posizioni  (" + $e.data + ")") }
  }
}

# ---------------------------------------------------------------------
Titolo "RIEPILOGO IN UNA TABELLA SOLA"
Write-Host "nome                                                        deal  posizioni  rapporto  data file"
foreach($e in ($esiti | Sort-Object { $_.nome })){
  $d = "-"; $p = "-"; $rr = "-"
  if($e.c.ok){ $d = "" + $e.c.deal; $p = "" + $e.c.posizioni; $rr = "" + $e.c.rapporto }
  Write-Host ($e.nome.PadRight(58) + $d.PadLeft(6) + $p.PadLeft(11) + $rr.PadLeft(10) + "  " + $e.data)
}
Write-Host ""
Write-Host ("per-trade contati: " + @($esiti | Where-Object { $_.c.ok }).Count + " su " + $esiti.Count + "   gruppi di gemelli divergenti: " + $divergenti)
Write-Host ""
Write-Host "COME SI LEGGE: la colonna POSIZIONI e' l'unita' dei cancelli di casa"
Write-Host "(Emendamento A del 16/08: >= 150 OPERAZIONI per parte). La colonna deal"
Write-Host "e' quella che i CSV di riepilogo chiamano Trades, e NON e' la stessa cosa:"
Write-Host "il rapporto stampato qui accanto dice di quanto sbaglierebbe chi le"
Write-Host "confondesse. Il nome del file NON dice la FINESTRA: per sapere quale"
Write-Host "finestra descrive, si guarda la gamba che ha girato PER ULTIMA."
Write-Host ""
Write-Host "Questa riga HA SOLO LETTO E STAMPATO."
