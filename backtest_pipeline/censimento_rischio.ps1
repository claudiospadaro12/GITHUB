# =====================================================================
#  MARCATORE_CENSIMENTO_V2
#  censimento_rischio.ps1 -- quanto rischia DAVVERO ogni sedia ACCESA
#
#  PERCHE' ESISTE (17/08/2026, notte):
#  confrontando il conto piccolo col dry-run 100k e' venuto fuori che
#  sul PICCOLO le perdite singole arrivano a **-2,19% del conto**
#  (15 perdite su 42 oltre l'1%, sei oltre il 2%), mentre sul 100k la
#  peggiore e' **-0,65%**, cioe' esattamente il rischio di casa.
#  Le sei peggiori sono TUTTE su D30EUR e NASUSD in apertura/Live5m.
#
#  Le spiegazioni possibili sono due e si distinguono da un file:
#    a) quelle sedie hanno InpRiskPercent piu' alto di quanto crediamo;
#    b) il rischio e' giusto ma lo STOP viene saltato (gap/slippage in
#       apertura), e allora la perdita supera il rischio previsto.
#
#  Questo script risponde alla (a): legge i .chr e stampa il rischio
#  dichiarato di OGNI sedia. Se sono tutte a 1.0, la colpa e' della (b)
#  e si guarda altrove. NON tocca niente: legge e basta.
#
#  ---------------------------------------------------------------
#  PERCHE' ESISTE LA v2 (25/08/2026) -- IL DIFETTO PAGATO DUE VOLTE
#  ---------------------------------------------------------------
#  La v1 contava i .chr SU DISCO. Ma un file .chr resta li' anche
#  quando il grafico non esiste piu': sono due incidenti veri, a
#  ventiquattro ore di distanza.
#
#    23/08  ORB_Ottimizzato U30USD 770611 compare DUE volte a 1.0.
#           Verifica a vista di Claudio (menu Finestra, tutti e due i
#           terminali): UN SOLO grafico ORB. La seconda riga era un
#           .chr vecchio del riattacco del 22/08, mai ripulito.
#           (report/PROPOSTA_REVISIONE_ORO_2026-08-23.md)
#
#    24/08  Gold_Ichimoku_TK_ATR_EA (XAUUSD, magic 250604) entra in
#           classifica R103 come sedia viva. Non gira da GIUGNO: due
#           trade e poi rimossa. Anche li': .chr residuo.
#           (risultati_archivio/ERRATA_R103_ICHIMOKU_2026-08-25.md,
#            "rilievo strumento n.1")
#
#  Un fantasma nel totale non e' un refuso: gonfia il rischio di
#  flotta, sposta una classifica e ha fatto scrivere una stima al
#  31/12 che e' stata poi corretta a mano.
#
#  COSA FA LA v2, in una riga: separa il VIVO dal RESIDUO.
#    - trova il PROFILO ATTIVO di ogni terminale (dai file di config
#      se la chiave c'e'; altrimenti ripiega e lo DICHIARA [ASSUNTO]);
#    - TABELLA PRINCIPALE + SOMMA = solo il profilo attivo;
#    - i .chr degli ALTRI profili finiscono in una sezione a parte,
#      "RESIDUI SU DISCO", e NON entrano mai nella somma;
#    - dentro il profilo attivo, i .chr con un orario FUORI
#      dall'ultimo salvataggio vengono marcati [FUORI SALVATAGGIO]:
#      restano nel totale (un rischio vivo non si nasconde mai) ma
#      sono la prima cosa da verificare col menu Finestra.
#
#  LIMITE DICHIARATO: questo strumento legge FILE, non il terminale.
#  Anche la v2 non puo' giurare che un grafico sia aperto: puo' solo
#  dire quali file appartengono al profilo attivo e quali no. La
#  prova che chiude la domanda resta quella del 23/08: menu Finestra
#  sul terminale. Passo successivo gia' in coda (errata R103):
#  incrociare con gli EA che compaiono nei log MQL5\Logs.
#
#  I .chr si aggiornano al salvataggio del profilo: se hai cambiato
#  qualcosa da poco, fai prima File -> Profili -> Salva.
#
#  USO (sul VPS, col terminale APERTO -- non scrive niente):
#      .\censimento_rischio.ps1
#      .\censimento_rischio.ps1 -ToleranzaMin 30
# =====================================================================
param(
  # ampiezza della finestra che definisce "l'ultimo salvataggio del
  # profilo": MT5 riscrive i .chr dei grafici aperti tutti insieme,
  # quindi un file rimasto indietro di piu' di questi minuti e' un
  # sospetto. 10 minuti sono larghi apposta: un falso allarme costa
  # una riga da leggere, un falso silenzio costa un fantasma.
  [int]$ToleranzaMin = 10
)
$ErrorActionPreference = "Stop"

$MARCATORE = "MARCATORE_CENSIMENTO_V2"

$root = Join-Path $env:APPDATA "MetaQuotes\Terminal"
$dirs = Get-ChildItem $root -Directory -ErrorAction SilentlyContinue |
        Where-Object { Test-Path (Join-Path $_.FullName "MQL5\Experts") }
if(-not $dirs){ Write-Host "Nessuna cartella dati MT5 trovata." -ForegroundColor Red; exit 1 }

$Righe = New-Object System.Collections.ArrayList
function Rec($s,$col){ [void]$Righe.Add($s); if($col){Write-Host $s -ForegroundColor $col}else{Write-Host $s} }

# ---------------------------------------------------------------------
#  Lettura CONDIVISA di un file di testo di MT5.
#  Il terminale tiene i propri file aperti in scrittura: senza
#  FileShare::ReadWrite la lettura fallisce proprio sul VPS, che e'
#  l'unica macchina dove questo script serve. E i config di MT5 sono
#  in UTF-16 (un byte su due a zero): letti come UTF-8 non
#  contengono nessuna chiave riconoscibile.
# ---------------------------------------------------------------------
function Leggi-TestoCondiviso($path){
  $b = $null
  try{
    $fs = [IO.File]::Open($path,[IO.FileMode]::Open,[IO.FileAccess]::Read,[IO.FileShare]::ReadWrite)
    $b  = New-Object byte[] $fs.Length
    [void]$fs.Read($b,0,$b.Length)
    $fs.Close()
  } catch { return "" }
  if($null -eq $b){ return "" }
  if($b.Count -lt 2){ return "" }
  if($b[0] -eq 0xFF -and $b[1] -eq 0xFE){ return [Text.Encoding]::Unicode.GetString($b) }
  $zeri = 0
  $n = [math]::Min(400,$b.Count)
  for($i=1; $i -lt $n; $i+=2){ if($b[$i] -eq 0){ $zeri++ } }
  if($zeri -gt ($n/4)){ return [Text.Encoding]::Unicode.GetString($b) }
  return [Text.Encoding]::UTF8.GetString($b)
}

# ---------------------------------------------------------------------
#  CULTURA INVARIANTE (checklist punto 5).
#  Il VPS e' Windows in ITALIANO: [double]::TryParse("2.0") senza
#  cultura legge il punto come separatore delle MIGLIAIA e restituisce
#  VENTI. Un rischio dell'1% diventerebbe il 10%, o viceversa.
#  Ritorna $null se la stringa non e' un numero: il chiamante decide
#  cosa farne (qui: "n/d", mai 0, checklist punto 66).
# ---------------------------------------------------------------------
function ParseNumInv($s){
  if($null -eq $s){ return $null }
  $t = ([string]$s).Trim()
  if($t.Length -eq 0){ return $null }
  $v = 0.0
  $ok = [double]::TryParse($t,
        [System.Globalization.NumberStyles]::Float,
        [System.Globalization.CultureInfo]::InvariantCulture,
        [ref]$v)
  if($ok){ return $v }
  return $null
}

# ---------------------------------------------------------------------
#  QUAL E' IL PROFILO ATTIVO DI QUESTO TERMINALE?
#  Tre strade, in ordine di forza, e quale sia stata usata finisce
#  SEMPRE nel referto: un numero senza la sua provenienza non si
#  puo' rileggere fra un mese.
#    1) [CONFIG]  una chiave nei .ini di config\ che nomina un
#       profilo esistente (ProfileLast / LastProfile / ...);
#    2) [UNICO]   c'e' un solo profilo con dei grafici salvati:
#       non c'e' niente da scegliere;
#    3) [ASSUNTO] il profilo il cui .chr piu' recente e' il piu'
#       recente di tutti. E' un'ASSUNZIONE, ed e' etichettata come
#       tale in ogni riga del referto.
# ---------------------------------------------------------------------
function Trova-ProfiloAttivo($dataFolder, $profili){
  $ris = New-Object psobject -Property @{ Nome=""; Fonte=""; Certo=$false }

  $conChr = @()
  foreach($p in $profili){
    $c = @(Get-ChildItem -LiteralPath $p.FullName -Filter "chart*.chr" -ErrorAction SilentlyContinue)
    if($c.Count -gt 0){
      $ultimo = ($c | Sort-Object LastWriteTime -Descending | Select-Object -First 1).LastWriteTime
      $conChr += (New-Object psobject -Property @{ Nome=$p.Name; Ultimo=$ultimo; Quanti=$c.Count })
    }
  }
  if($conChr.Count -eq 0){ $ris.Fonte = "nessun profilo con grafici salvati"; return $ris }

  # --- 1) la chiave nei config -------------------------------------
  #  Le chiavi trovate ma che nominano un profilo INESISTENTE si
  #  ricordano: dire "nessuna chiave nei config" quando la chiave c'era
  #  ed era scaduta e' una bugia nel referto, e chi lo rilegge fra un
  #  mese cercherebbe nel posto sbagliato.
  $chiaviIgnote = @()
  $cfg = Join-Path $dataFolder "config"
  if(Test-Path -LiteralPath $cfg){
    $chiavi = "ProfileLast|LastProfile|CurrentProfile|ProfileName|Profile"
    foreach($f in @(Get-ChildItem -LiteralPath $cfg -Filter "*.ini" -ErrorAction SilentlyContinue | Sort-Object Name)){
      $t = Leggi-TestoCondiviso $f.FullName
      if(-not $t){ continue }
      foreach($m in [regex]::Matches($t,"(?im)^[ \t]*($chiavi)[ \t]*=[ \t]*(.+?)[ \t]*$")){
        $val = $m.Groups[2].Value.Trim()
        if($val.Length -eq 0){ continue }
        foreach($c in $conChr){
          if($c.Nome -ieq $val){
            $ris.Nome  = $c.Nome
            $ris.Certo = $true
            $ris.Fonte = "[CONFIG] config\" + $f.Name + " -> " + $m.Groups[1].Value + "=" + $val
            return $ris
          }
        }
        $chiaviIgnote += ("config\" + $f.Name + " -> " + $m.Groups[1].Value + "=" + $val)
      }
    }
  }

  # --- 2) ce n'e' uno solo ------------------------------------------
  if($conChr.Count -eq 1){
    $ris.Nome  = $conChr[0].Nome
    $ris.Certo = $true
    $ris.Fonte = "[UNICO] e' l'unico profilo con grafici salvati"
    return $ris
  }

  # --- 3) ripiego dichiarato ----------------------------------------
  $piu = $conChr | Sort-Object Ultimo -Descending | Select-Object -First 1
  $ris.Nome  = $piu.Nome
  $ris.Certo = $false
  if($chiaviIgnote.Count -gt 0){
    $perche = "chiave di profilo TROVATA ma nomina un profilo che non esiste (" + ($chiaviIgnote -join "; ") + ")"
  } else {
    $perche = "nessuna chiave di profilo nei file di config"
  }
  $ris.Fonte = "[ASSUNTO] " + $perche + ": preso il profilo col .chr piu' recente (" +
               $piu.Ultimo.ToString("yyyy.MM.dd HH:mm") + ")"
  return $ris
}

# =====================================================================
#  RACCOLTA
# =====================================================================
Rec "=== CENSIMENTO DEL RISCHIO DICHIARATO (dai .chr) ===" White
Rec ("versione: " + $MARCATORE + "   (v2: separa il VIVO dal RESIDUO)") Gray
Rec ("data: " + (Get-Date -Format "yyyy.MM.dd HH:mm")) Gray
Rec ("macchina: " + $env:COMPUTERNAME + "   utente: " + $env:USERNAME) Gray
Rec ""

$tutte    = @()
$illeggib = 0
$profAttivi = @()

foreach($d in $dirs){
  $chartsRoot = Join-Path $d.FullName "MQL5\Profiles\Charts"
  $profili = @()
  if(Test-Path -LiteralPath $chartsRoot){
    $profili = @(Get-ChildItem -LiteralPath $chartsRoot -Directory -ErrorAction SilentlyContinue)
  }
  $att = Trova-ProfiloAttivo $d.FullName $profili
  $profAttivi += (New-Object psobject -Property @{
    Terminale = $d.Name
    Profilo   = $att.Nome
    Fonte     = $att.Fonte
    Certo     = $att.Certo
  })

  # --- l'ora dell'ULTIMO SALVATAGGIO del profilo attivo -------------
  #  MT5 riscrive insieme i .chr di tutti i grafici aperti: il file
  #  rimasto indietro non e' stato riscritto, cioe' quel grafico non
  #  c'era piu'. E' il meccanismo che ha prodotto le due righe ORB.
  $oraSalv = $null
  if($att.Nome){
    $dirAtt = Join-Path $chartsRoot $att.Nome
    $cc = @(Get-ChildItem -LiteralPath $dirAtt -Filter "chart*.chr" -ErrorAction SilentlyContinue)
    if($cc.Count -gt 0){ $oraSalv = ($cc | Sort-Object LastWriteTime -Descending | Select-Object -First 1).LastWriteTime }
  }

  $chrs = @(Get-ChildItem $d.FullName -Recurse -Filter "*.chr" -ErrorAction SilentlyContinue)
  foreach($chr in $chrs){
    # LETTURA CONDIVISA anche qui (nota del verificatore del 19/08, in
    # coda da allora): la v1 usava Get-Content -Raw SENZA FileShare e con
    # $ErrorActionPreference="Stop" -- con MT5 aperto UN file bloccato
    # faceva morire TUTTO il censimento. Adesso il file illeggibile si
    # conta e si dichiara (checklist 10 + 28-bis), non fa cadere la corsa
    # e non sparisce in silenzio.
    $txt = Leggi-TestoCondiviso $chr.FullName
    if(-not $txt){ $illeggib++; continue }

    $em = [regex]::Match($txt, "(?s)<expert>.*?path=Experts\\([^\r\n]+)\.ex5")
    if(-not $em.Success){ continue }
    $ea = ($em.Groups[1].Value.Trim() -split '\\')[-1]
    $sm = [regex]::Match($txt, "symbol=([A-Za-z0-9#\.]+)")
    if($sm.Success){ $sym = $sm.Groups[1].Value -replace '[\.#].*$','' } else { $sym = "?" }
    $ins = @{}
    $im = [regex]::Match($txt, "(?s)<expert>.*?<inputs>(.*?)</inputs>")
    if($im.Success){
      foreach($l in ($im.Groups[1].Value -split "\r?\n")){
        if($l -match "^\s*([A-Za-z0-9_]+)=(.*)$"){ $ins[$Matches[1]] = $Matches[2].Trim() }
      }
    }
    if($ins.Count -eq 0){ continue }

    # il nome dell'input del rischio non e' uguale in tutti gli EA
    $risk = $null; $nomeRisk = ""
    foreach($k in @("InpRiskPercent","InpRisk","InpRischioPercent","InpRiskPct")){
      if($ins.ContainsKey($k)){ $risk = $ins[$k]; $nomeRisk = $k; break }
    }
    $lotto = ""
    foreach($k in @("InpLotFisso","InpLots","InpLotto","InpFixedLot")){
      if($ins.ContainsKey($k)){ $lotto = ($k + "=" + $ins[$k]); break }
    }

    # --- DOVE sta questo file: profilo attivo, altro profilo, fuori --
    $rel = $chr.FullName
    if($chr.FullName.Length -gt ($d.FullName.Length+1)){ $rel = $chr.FullName.Substring($d.FullName.Length+1) }
    $prof = ""
    $dentroCharts = $false
    if((Test-Path -LiteralPath $chartsRoot) -and $chr.FullName.StartsWith(($chartsRoot + "\"), [System.StringComparison]::OrdinalIgnoreCase)){
      $resto = $chr.FullName.Substring($chartsRoot.Length+1)
      $pezzi = @($resto -split '\\')
      # ESATTAMENTE due pezzi: <profilo>\<file>.chr. Un file annidato piu'
      # in fondo non e' un grafico del profilo, e' spazzatura: va nei
      # residui, non nel totale.
      if($pezzi.Count -eq 2){ $prof = $pezzi[0]; $dentroCharts = $true }
    }

    $vivo = $false
    if($dentroCharts -and $att.Nome -and ($prof -ieq $att.Nome)){ $vivo = $true }

    # ETICHETTA DI GRUPPO: deve raggruppare, quindi e' la CARTELLA, mai
    # il nome del file (con il file ogni gruppo avrebbe una riga sola e
    # la sezione dei residui diventerebbe illeggibile).
    #  E porta dentro il TERMINALE: con due istanze sulla stessa macchina
    #  due profili 'Default' diversi finirebbero nello stesso gruppo, ed e'
    #  il perimetro mescolato del punto 28.
    $relDir = Split-Path -Parent $rel
    if(-not $relDir){ $relDir = "(radice della cartella dati)" }
    $term8 = $d.Name.Substring(0,[math]::Min(8,$d.Name.Length))
    $dove = "term " + $term8 + " - fuori da Profiles\Charts -> " + $relDir
    if($vivo){ $dove = "term " + $term8 + " - profilo attivo: " + $prof }
    elseif($dentroCharts){ $dove = "term " + $term8 + " - profilo '" + $prof + "' (NON attivo)" }

    # --- fuori dall'ultimo salvataggio? (solo dentro il profilo attivo)
    $fuoriSalv = $false
    if($vivo -and ($null -ne $oraSalv)){
      $scarto = (New-TimeSpan -Start $chr.LastWriteTime -End $oraSalv).TotalMinutes
      if([double]$scarto -gt [double]$ToleranzaMin){ $fuoriSalv = $true }
    }

    $tutte += [pscustomobject]@{
      EA=$ea; Sym=$sym; Magic=$ins["InpMagic"]; Risk=$risk; NomeRisk=$nomeRisk
      Lotto=$lotto; Comm=$ins["InpComment"]; File=$chr.Name; Ora=$chr.LastWriteTime
      Terminale=$d.Name; Profilo=$prof; Vivo=$vivo; FuoriSalv=$fuoriSalv; Dove=$dove
    }
  }
}

# --- il perimetro, dichiarato prima dei numeri (checklist punto 28) ---
Rec "--- PROFILO ATTIVO, terminale per terminale ---" White
foreach($p in $profAttivi){
  $etichetta = "OK"
  if(-not $p.Certo){ $etichetta = "DA VERIFICARE" }
  $nome = $p.Profilo
  if(-not $nome){ $nome = "(nessuno)" }
  Rec ("  terminale " + $p.Terminale.Substring(0,[math]::Min(8,$p.Terminale.Length)) +
       "   profilo attivo: " + $nome + "   [" + $etichetta + "]")
  Rec ("      fonte: " + $p.Fonte) Gray
}
Rec ""
if(@($profAttivi | Where-Object { -not $_.Certo }).Count -gt 0){
  Rec "!! ALMENO UN PROFILO ATTIVO E' [ASSUNTO], non letto da un file di config." Yellow
  Rec "   La tabella qui sotto regge su quell'assunzione: se il profilo non e'" Yellow
  Rec "   quello, le righe stanno nella sezione sbagliata. Controllo in 5 secondi:" Yellow
  Rec "   in MT5 il nome del profilo si legge in File -> Profili." Yellow
  Rec ""
}
if($illeggib -gt 0){
  Rec ("!! " + $illeggib + " file .chr non si sono lasciati leggere (bloccati da MT5?): NON sono nei conteggi.") Yellow
  Rec ""
}

if($tutte.Count -eq 0){ Rec "Nessun grafico con EA salvato. Hai fatto File -> Profili -> Salva?" Red; exit 1 }

$vive    = @($tutte | Where-Object { $_.Vivo })
$residue = @($tutte | Where-Object { -not $_.Vivo })

Rec ("sedie trovate nel PROFILO ATTIVO: " + $vive.Count + "    (file .chr letti in tutto: " + $tutte.Count + ")") Gray
Rec ""

# =====================================================================
#  TABELLA PRINCIPALE -- SOLO IL PROFILO ATTIVO
# =====================================================================
Rec ("{0,-36} {1,-8} {2,-8} {3,6}  {4}" -f "EA","simbolo","magic","rischio","commento") White
Rec ("-" * 92) Gray

$sospette = 0
$fuoriSalvN = 0
if($vive.Count -eq 0){
  Rec "  NESSUNA SEDIA NEL PROFILO ATTIVO." Red
  Rec "  Se il terminale sta operando, il profilo non e' mai stato salvato:" Yellow
  Rec "  fai File -> Profili -> Salva e rilancia. Le righe trovate sul disco" Yellow
  Rec "  sono elencate qui sotto come RESIDUI, e NON vanno sommate." Yellow
} else {
  foreach($t in ($vive | Sort-Object @{e={ $v=ParseNumInv $_.Risk; if($null -ne $v){$v}else{-1} }; Descending=$true}, EA)){
    if($t.Risk){ $r = $t.Risk } else { $r = "n/d" }
    $comm = $t.Comm
    if($t.FuoriSalv){
      $fuoriSalvN++
      $comm = $comm + "   [FUORI SALVATAGGIO: .chr del " + $t.Ora.ToString("yyyy.MM.dd HH:mm") + " - verifica col menu Finestra]"
    }
    $riga = ("{0,-36} {1,-8} {2,-8} {3,6}  {4}" -f $t.EA, $t.Sym, $t.Magic, $r, $comm)
    $rv = ParseNumInv $t.Risk
    if($null -ne $rv -and $rv -gt 1.0){ Rec $riga Red; $sospette++ }
    elseif($null -eq $rv){
      $agg = ""
      if($t.Lotto){ $agg = " (" + $t.Lotto + ")" }
      Rec ($riga + "   <- nessun input di rischio trovato" + $agg) Yellow
    }
    elseif($t.FuoriSalv){ Rec $riga Magenta }
    else{ Rec $riga Gray }
  }
}

# =====================================================================
#  IL TOTALE -- e l'aritmetica per esteso (checklist punto 28)
# =====================================================================
function SommaRischi($righe){
  $s = 0.0
  foreach($x in $righe){
    $v = ParseNumInv $x.Risk
    if($null -ne $v){ $s = $s + $v }
  }
  return $s
}
$sommaVive    = SommaRischi $vive
$sommaResidue = SommaRischi $residue
$sommaTutto   = $sommaVive + $sommaResidue
$senzaRisk    = @($vive | Where-Object { $null -eq (ParseNumInv $_.Risk) }).Count

Rec ""
Rec ("=== TOTALE RISCHIO DICHIARATO ===") White
if($sommaVive -gt 10){ $colTot = "Red" } else { $colTot = "Green" }
Rec ("  somma dei rischi delle sedie del PROFILO ATTIVO: {0:N2}% del conto" -f $sommaVive) $colTot
Rec "  (non e' il rischio simultaneo: e' quanto si rischierebbe se aprissero tutte insieme)"
Rec ""
Rec "  l'aritmetica, per esteso:" Gray
Rec ("    righe del PROFILO ATTIVO ......... {0,3}   somma {1,7:N2}%   <== IL NUMERO" -f $vive.Count, $sommaVive)
Rec ("    righe RESIDUE su disco ........... {0,3}   somma {1,7:N2}%   (NON entra nel totale)" -f $residue.Count, $sommaResidue)
Rec ("    somma se si sommasse tutto ....... {0,3}   somma {1,7:N2}%   <-- e' il numero che stampava la v1" -f $tutte.Count, $sommaTutto)
if($senzaRisk -gt 0){
  Rec ("    di cui SENZA input di rischio .... {0,3}   contano 0 nella somma: sono 'n/d', non 0,00" -f $senzaRisk) Yellow
}
Rec ""
if($sospette -gt 0){
  Rec ("{0} sedie hanno rischio DICHIARATO sopra l'1%: sono in rosso qui sopra." -f $sospette) Red
} else {
  Rec "Nessuna sedia dichiara piu' dell'1%." Green
  Rec "Allora le perdite da -2% del conto NON vengono dal rischio impostato:" Yellow
  Rec "vengono dallo STOP SALTATO (gap/slippage in apertura). Si guarda li'." Yellow
}

# =====================================================================
#  SEZIONE A PARTE: I RESIDUI. Non si sommano, si guardano.
# =====================================================================
Rec ""
Rec "=== RESIDUI SU DISCO (grafici NON attivi - probabile spazzatura da pulire) ===" White
if($residue.Count -eq 0){
  Rec "  nessuno: tutti i .chr con un EA stanno nel profilo attivo." Green
} else {
  Rec "  Queste righe NON sono nel totale qui sopra. Un .chr resta sul disco" Yellow
  Rec "  anche quando il grafico non esiste piu': e' cosi' che il 23/08 l'ORB" Yellow
  Rec "  e' comparso due volte e il 24/08 Gold_Ichimoku e' entrato in una" Yellow
  Rec "  classifica pur non girando da giugno." Yellow
  Rec ""
  foreach($g in ($residue | Group-Object Dove | Sort-Object Name)){
    Rec ("  --- " + $g.Name + "   (" + $g.Count + " righe) ---") DarkYellow
    foreach($t in ($g.Group | Sort-Object EA)){
      if($t.Risk){ $r = $t.Risk } else { $r = "n/d" }
      Rec ("  " + ("{0,-36} {1,-8} {2,-8} {3,6}  {4}" -f $t.EA, $t.Sym, $t.Magic, $r, ($t.File + "  " + $t.Ora.ToString("yyyy.MM.dd HH:mm")))) DarkGray
    }
  }
}

if($fuoriSalvN -gt 0){
  Rec ""
  Rec ("!! " + $fuoriSalvN + " righe del PROFILO ATTIVO hanno un .chr FUORI dall'ultimo salvataggio") Magenta
  Rec ("   (tolleranza usata: " + $ToleranzaMin + " minuti). Restano nel totale, perche' un rischio") Magenta
  Rec "   vivo non si nasconde mai - ma sono le prime da verificare a vista:" Magenta
  Rec "   in MT5, menu Finestra: quel grafico c'e' o no?" Magenta
}

$dest = Join-Path ([Environment]::GetFolderPath("Desktop")) "censimento_rischio.txt"
$Righe | Set-Content -Path $dest -Encoding UTF8
Write-Host ""
Write-Host "Referto scritto in: $dest" -ForegroundColor Cyan
