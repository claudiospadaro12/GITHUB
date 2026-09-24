# =====================================================================
#  MARCATORE_CODA_12_PERTRADE_POSIZIONI_v3
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
#      E un identificativo VUOTO entra nell'insieme come stringa vuota:
#      tutte le righe senza id valgono UN secchio, cioe' UNA posizione
#      che non esiste. Non lo tolgo (cambierebbe in silenzio i conteggi
#      gia' agli atti dei file per-deal): lo CONTO e lo STAMPO in rosso.
#   4. Tetto dichiarato: file oltre 40 MB o oltre 400000 righe non si
#      leggono per intero, e la riga lo dice invece di fingere. Serve a
#      non piantare una catena che non ha timeout.
#
#  NESSUN PARAMETRO, E NON E' UNA SEMPLIFICAZIONE: E' IL PERIMETRO.
#  La prima stesura aveva un '-Cartella' libero, per potersi collaudare
#  fuori dal VPS. Il cancello di giudizio l'ha tolto il 12/09/2026, e il
#  motivo e' MISURATO, non prudenziale:
#    1. delle 12 righe di sola lettura della coda, questa era l'UNICA con
#       un param(): le altre 11 (CODA_01..CODA_11) non prendono niente.
#    2. in corsia LETTURA il cancello G4 del runner NON ha nessuna lista
#       bianca sui percorsi. La riga "si passa solo roba sotto
#       C:\MT5_Backtest" sta dentro un   if(corsia -eq ROUND)  , quindi
#       in lettura l'unica difesa sarebbe la lista dei divieti TESTUALI.
#    3. e quella lista e' fail-OPEN per costruzione (classe 272): provate
#       le otto grafie del percorso del conto REALE passate come
#       argomento, SETTE vengono bocciate e la grafia 8.3 'BCM_RE~1'
#       PASSA. Una sola che passa basta.
#    4. e quello che questa riga stampa NON resta sul VPS: il runner
#       PUBBLICA referto e log su GitHub, e il repository e' PUBBLICO.
#  Quindi la guardia non e' scritta come "rifiuto cio' che riconosco"
#  (che e' il difetto della classe 272): la cartella non si puo'
#  nominare affatto. E' UNA SOLA, cablata qui sotto.
#  COME SI COLLAUDA FUORI DAL VPS, senza riaprire il buco: si sposta
#  APPDATA, non la cartella. Cosi' il collaudo esercita ESATTAMENTE il
#  ramo di codice che gira in coda, invece di un ramo che esiste solo
#  per il collaudo:
#    APPDATA=<radice finta> pwsh -File CODA_12_pertrade_posizioni.ps1
#    (con dentro <radice finta>\MetaQuotes\Terminal\Common\Files)
# =====================================================================

$ErrorActionPreference = "Continue"

function Titolo($t){ Write-Host ""; Write-Host ("=== " + $t + " ===") -ForegroundColor Cyan }

Write-Host "#####################################################################"
Write-Host "#  CODA_12 -- PER-TRADE: DEAL, POSIZIONI, RAPPORTO                  #"
Write-Host "#  MARCATORE_CODA_12_PERTRADE_POSIZIONI_v3                           #"
Write-Host ("#  ora locale di questa macchina: " + (Get-Date).ToString("yyyy-MM-dd HH:mm:ss"))
Write-Host "#  SOLA LETTURA: apre file e stampa numeri.                          #"
Write-Host "#####################################################################"

if([string]::IsNullOrWhiteSpace($env:APPDATA)){
  Write-Host ""
  Write-Host "ESITO: APPDATA non e' valorizzato, quindi la cartella comune NON si sa" -ForegroundColor Yellow
  Write-Host "       calcolare. Mi fermo invece di leggere un percorso relativo: un"
  Write-Host "       percorso relativo dipende dalla cartella di lavoro di chi mi ha"
  Write-Host "       lanciato, e questa riga ha UN SOLO bersaglio ammesso."
  return
}
$cart = Join-Path $env:APPDATA "MetaQuotes\Terminal\Common\Files"
Write-Host ""
Write-Host ("cartella letta : " + $cart)
Write-Host  "               (unico bersaglio ammesso: Common\Files di questo utente."
Write-Host  "                Non e' la cartella dati di NESSUN terminale, e non si puo'"
Write-Host  "                cambiare da riga di comando: questa riga non ha parametri.)"

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
  $r = @{ ok=$false; motivo=""; deal=0; posizioni=0; rapporto=0.0; primo=""; ultimo=""; tagliato=$false; famiglia=""; vuoti=0; minimo=""; massimo="" }
  $fi = $null
  try{ $fi = Get-Item -LiteralPath $path -ErrorAction Stop }catch{ $r.motivo = "non leggibile"; return $r }
  if($fi.Length -gt 41943040){ $r.motivo = ("TETTO: " + [math]::Round($fi.Length/1MB,1) + " MB, oltre i 40 MB dichiarati. NON contato."); return $r }

  $sr = $null
  try{
    $fs = [IO.File]::Open($path,[IO.FileMode]::Open,[IO.FileAccess]::Read,[IO.FileShare]::ReadWrite)
    $sr = New-Object IO.StreamReader($fs)
  }catch{ $r.motivo = "aperto da qualcun altro in modo esclusivo"; return $r }

  $iPid = -1; $iClose = -1; $n = 0; $righe = 0; $nVuoti = 0
  $visti = New-Object 'System.Collections.Generic.HashSet[string]'
  try{
    $intest = $sr.ReadLine()
    if($null -eq $intest){ $r.motivo = "file VUOTO (zero byte utili)"; return $r }
    $hh = $intest.Split(';')
    for($i=0; $i -lt $hh.Length; $i++){
      $k = $hh[$i].Trim().Trim('"')
      #  DUE FAMIGLIE DI PER-TRADE, e vanno lette in modo DIVERSO.
      #  'position_id' = file PER-DEAL: piu' righe possono condividere la
      #  stessa posizione, e il rapporto deal/posizione si MISURA.
      #  'pid'         = file PER-POSIZIONE (lo scrive ABTG_TradeExporter):
      #  una riga = una posizione chiusa, e il rapporto vale 1 PER
      #  COSTRUZIONE, non per misura. Scriverlo come se fosse misurato
      #  sarebbe un numero finto.
      if($k -eq "position_id"){ $iPid = $i; $r.famiglia = "per-deal" }
      if($k -eq "pid" -and $iPid -lt 0){ $iPid = $i; $r.famiglia = "per-posizione" }
      if($k -eq "close_time"){  $iClose = $i }
    }
    if($iPid -lt 0){
      $r.motivo = ("intestazione senza colonna position_id NE' pid: [" + $intest + "]")
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
      #  UN ID VUOTO NON E' UNA POSIZIONE, ma nella HashSet ci entra lo
      #  stesso come stringa vuota e diventa UN SECCHIO. Non lo tolgo --
      #  toglierlo cambierebbe in silenzio i conteggi gia' agli atti --
      #  ma lo CONTO, cosi' chi legge sa di quanto e' gonfio il numero.
      $id = $c[$iPid].Trim()
      if($id -eq ""){ $nVuoti++ }
      [void]$visti.Add($id)
      if($iClose -ge 0 -and $c.Length -gt $iClose){
        $t = $c[$iClose].Trim()
        if($r.primo -eq ""){ $r.primo = $t }
        $r.ultimo = $t
        #  PRIMA/ULTIMA RIGA NON SONO IL PRIMO/ULTIMO ISTANTE. Nei
        #  per-trade da tester le righe escono in ordine di chiusura e le
        #  due cose coincidono; nel per-posizione dell'esportatore NO: le
        #  righe seguono l'ordine del deal di APERTURA (ABTG_TradeExporter
        #  r.136-145) e portano la chiusura, quindi si scavalcano. Il
        #  formato 'aaaa.mm.gg hh:mm:ss' e' ordinabile come testo, quindi
        #  gli ESTREMI VERI si tengono da parte senza costare niente.
        if($t -ne ""){
          if($r.minimo -eq "" -or $t -lt $r.minimo){ $r.minimo = $t }
          if($r.massimo -eq "" -or $t -gt $r.massimo){ $r.massimo = $t }
        }
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
  $r.vuoti = $nVuoti
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
  if($c.famiglia -eq "per-posizione"){
    Write-Host ("     POSIZIONI  : " + $c.posizioni + "   <<< e' questa l'unita' dell'Emendamento A")
    Write-Host ("     righe      : " + $c.deal + "   (file PER-POSIZIONE: una riga = una posizione chiusa)")
    #  L'INVARIANTE SI VERIFICA, NON SI DICHIARA. "una riga = una
    #  posizione" e' vero per come scrive ABTG_TradeExporter (aggrega
    #  per pid, r.136-145, e pid==0 lo salta a r.131). Ma se il file
    #  arrivasse da un'altra penna, o fosse troncato a meta' riga, i due
    #  numeri divergerebbero e la didascalia direbbe una cosa FALSA
    #  accanto a un numero vero. Qui si CONFRONTANO.
    if($c.deal -eq $c.posizioni){
      Write-Host  "     rapporto   : non si applica -- vale 1 per COSTRUZIONE, e su questo file e' VERIFICATO (righe = pid distinti)"
    } else {
      Write-Host ("     rapporto   : ATTENZIONE -- l'invariante NON REGGE su questo file: " + $c.deal + " righe ma " + $c.posizioni + " pid distinti.") -ForegroundColor Red
      Write-Host  "                  Un per-posizione con pid RIPETUTI o VUOTI non e' un per-posizione:"
      Write-Host  "                  il numero POSIZIONI qui sopra NON si puo' usare come operazioni."
    }
  } else {
    Write-Host ("     deal uscita: " + $c.deal)
    Write-Host ("     POSIZIONI  : " + $c.posizioni + "   <<< e' questa l'unita' dell'Emendamento A")
    Write-Host ("     rapporto   : " + $c.rapporto + "   (deal per posizione)")
  }
  if($c.famiglia -eq "per-posizione"){
    #  Qui si stampano gli ESTREMI, non la prima e l'ultima riga: su
    #  questo formato le righe non sono in ordine di chiusura.
    Write-Host ("     close_time : dal " + $c.minimo + "  al  " + $c.massimo + "   (estremi; le righe NON sono in ordine di chiusura)")
  } else {
    Write-Host ("     close_time : dal " + $c.primo + "  al  " + $c.ultimo)
    if($c.minimo -ne $c.primo -or $c.massimo -ne $c.ultimo){
      Write-Host ("     ATTENZIONE : le righe NON sono in ordine di chiusura. Estremi veri: dal " + $c.minimo + " al " + $c.massimo) -ForegroundColor Red
    }
  }
  if($c.vuoti -gt 0){
    Write-Host ("     ATTENZIONE : " + $c.vuoti + " righe hanno l'identificativo di posizione VUOTO.") -ForegroundColor Red
    Write-Host  "                  Tutte insieme valgono UN secchio solo dentro POSIZIONI, quindi"
    Write-Host  "                  quel numero contiene UNA posizione che non esiste. Vale per"
    Write-Host  "                  tutte e due le famiglie."
  }
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
  if($e.c.ok){
    $d = "" + $e.c.deal; $p = "" + $e.c.posizioni; $rr = "" + $e.c.rapporto
    #  IL NUMERO RIFIUTATO NEL DETTAGLIO NON PUO' RIENTRARE DALLA
    #  TABELLA. Su un file PER-POSIZIONE il rapporto non e' una misura:
    #  o vale 1 per costruzione, o l'invariante e' rotta. Stamparci il
    #  quoziente sarebbe lo stesso numero finto, dieci righe piu' sotto.
    if($e.c.famiglia -eq "per-posizione"){
      if($e.c.deal -eq $e.c.posizioni){ $rr = "1cost" } else { $rr = "ROTTO" }
    }
  }
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
Write-Host "DUE FAMIGLIE, e la colonna rapporto lo dice: '1cost' = file PER-POSIZIONE"
Write-Host "(una riga = una posizione, VERIFICATO su quel file: non e' una misura, e'"
Write-Host "un'identita'); 'ROTTO' = per-posizione con identificativi ripetuti o vuoti,"
Write-Host "e li' la colonna posizioni NON si legge come operazioni; un NUMERO = file"
Write-Host "PER-DEAL, e li' il rapporto e' misurato davvero."
Write-Host ""
Write-Host "Questa riga HA SOLO LETTO E STAMPATO."
