# =====================================================================
#  MARCATORE_CODA_05_FOTO_FRESCA_v2
#  RUNNER_SOLA_LETTURA
# ---------------------------------------------------------------------
#  COSA FA: dice se la FOTO delle sedie (i file .chr) e' FRESCA oppure
#  VECCHIA, confrontando la data dei .chr con la data dell'ultimo log
#  scritto dal terminale. E stampa il CALENDARIO delle news che gli EA
#  leggono da Common\Files, riga per riga.
#  Non scrive, non copia, non cancella: STAMPA.
#
#  PERCHE' ESISTE -- una contraddizione misurata l'08/09/2026 alle 03:30
#  CODA_01 legge le sedie dai .chr. CODA_02 legge chi ha scritto nei log.
#  Sul terminale del conto reale le due cose NON dicono la stessa cosa:
#    - CODA_01: profilo attivo = 3 sedie, NESSUN Guardian;
#    - CODA_02: ABTG_Guardian ha scritto 464 righe, ultima alle 23:56.
#  Un EA che scrive nei log STA GIRANDO. Quindi o il Guardian non e' nei
#  .chr, o i .chr sono una FOTO SALVATA e non lo stato vivo.
#
#  >>> E' LA DOMANDA CHE CONTA PIU' DI TUTTE, perche' se i .chr sono
#      vecchi allora OGNI censimento fatto finora ha descritto il
#      terminale com'era l'ultima volta che il profilo e' stato salvato,
#      non com'e' adesso. Sette censimenti si leggerebbero diversamente.
#      MT5 riscrive i .chr quando il profilo viene salvato (cambio di
#      profilo, chiusura del terminale), NON a ogni tick: quindi la
#      vecchiaia della foto e' un fatto misurabile, e questa riga lo
#      misura invece di ragionarci sopra.
#
#  IL SECONDO PEZZO: il calendario del PostNews.
#  L'08/09 i log dicono che su USDJPY il calendario ha 3 righe e degli
#  UTILI, mentre su EURUSD e EURJPY il canarino e' ROSSO (si legge ma
#  per quel simbolo non c'e' niente). Il collaudo del 10/09 e' sulla
#  BCE, che e' un evento in EURO: se le righe utili stanno solo su
#  USDJPY, il collaudo non parte sui simboli giusti. Qui si legge il
#  file invece di dedurlo dai messaggi troncati.
#
#  LIMITE DICHIARATO: si stampa cio' che c'e' su disco adesso. Un .chr
#  fresco non garantisce che l'EA sia ATTIVO (potrebbe essere stato
#  tolto e il profilo non salvato): dice solo quando quella foto e'
#  stata scattata.
#
# =====================================================================
#  PERCHE' ESISTE LA v2 -- la v1 non ha mai guardato dove doveva
#  Corsa del 10/09/2026 alle 03:30: su SEI cartelle dati su sei la v1 ha
#  stampato "la cartella del profilo attivo non esiste" e non ha
#  misurato NIENTE. Non era il VPS: era un pezzo di percorso mancante.
#     v1:  <cartella dati>\profiles\charts\<profilo>      <-- MT4
#     MT5: <cartella dati>\MQL5\Profiles\Charts\<profilo>
#  Il pezzo "MQL5\" in MT4 non esiste, in MT5 si'. Identico difetto in
#  CODA_08 (che infatti stampava "TOTALE SEDIE STAMPATE: 0"), mentre
#  CODA_01 -- stessa coda, stessa notte -- leggeva 49 sedie perche' il
#  percorso giusto ce l'aveva gia'. La strada esisteva in casa.
#
#  Le tre correzioni della v2:
#   C1 - il percorso si RISOLVE e si DICHIARA (MT5 prima, MT4 come
#        ripiego), e il profilo attivo lo trova la stessa funzione di
#        CODA_01: guarda TUTTI i config\*.ini, non il solo common.ini, e
#        quando tira a indovinare lo SCRIVE.
#   C2 - ogni "non misuro" stampa un ESITO DIVERSO (A: cartella profili
#        non trovata . B: profilo attivo non determinato . C: cartella
#        del profilo attivo non trovata . D: trovata ma senza .chr .
#        F: foto trovata ma nessun log da confrontare), e in fondo c'e'
#        il conto di dove ho guardato. Nella v1 erano cinque fatti
#        diversi con la stessa faccia: nessuna faccia.
#   C3 - IL DIVARIO HA UN SEGNO, e la v1 lo leggeva come se fosse una
#        distanza. Se il profilo viene salvato DOPO l'ultimo log (per
#        esempio: terminale chiuso a mano ieri e mai riacceso), il
#        divario e' NEGATIVO e "-100 ore" e' minore di 2: la v1 avrebbe
#        risposto "FOTO FRESCA" su un terminale MORTO da quattro giorni.
#        La v2 tratta il caso negativo per quello che e': foto recente,
#        terminale MUTO -- che e' una notizia peggiore, non migliore.
# =====================================================================

function Leggi-Condiviso($path){
  $b = $null
  try{
    $fs = [IO.File]::Open($path,[IO.FileMode]::Open,[IO.FileAccess]::Read,[IO.FileShare]::ReadWrite)
    $b  = New-Object byte[] $fs.Length
    [void]$fs.Read($b,0,$b.Length)
    $fs.Close()
  } catch { return "" }
  if($null -eq $b -or $b.Count -lt 2){ return "" }
  if($b[0] -eq 0xFF -and $b[1] -eq 0xFE){ return [Text.Encoding]::Unicode.GetString($b) }
  $zeri = 0; $n = [math]::Min(400,$b.Count)
  for($i=1; $i -lt $n; $i+=2){ if($b[$i] -eq 0){ $zeri++ } }
  if($zeri -gt ($n/4)){ return [Text.Encoding]::Unicode.GetString($b) }
  return [Text.Encoding]::UTF8.GetString($b)
}

function Eta($t){
  if($null -eq $t){ return "?" }
  $h = [math]::Round(((Get-Date) - $t).TotalHours, 1)
  return ("" + $t.ToString("yyyy-MM-dd HH:mm") + "  (vecchia di " + $h + " ore)")
}

# --- C1: DOVE stanno i profili. Si prova, non si assume, e si dichiara.
#     MT5 -> <dati>\MQL5\Profiles\Charts   MT4 -> <dati>\profiles\charts
function Radice-Profili($dataFolder){
  foreach($c in @((Join-Path $dataFolder "MQL5\Profiles\Charts"), (Join-Path $dataFolder "profiles\charts"))){
    if(Test-Path -LiteralPath $c){ return $c }
  }
  return ""
}

# --- QUALE PROFILO E' QUELLO CARICATO. Stessa funzione di CODA_01 v2:
#     TUTTI i config\*.ini, e il ripiego si dichiara ripiego.
function Trova-ProfiloAttivo($dataFolder,$profili){
  $ris = New-Object psobject -Property @{ Nome=""; Fonte=""; Certo=$false }
  $conChr = @()
  foreach($p in $profili){
    $c = @(Get-ChildItem -LiteralPath $p.FullName -Filter "chart*.chr" -ErrorAction SilentlyContinue)
    if($c.Count -gt 0){
      $ultimo = ($c | Sort-Object LastWriteTime -Descending | Select-Object -First 1).LastWriteTime
      $conChr += (New-Object psobject -Property @{ Nome=$p.Name; Ultimo=$ultimo; Quanti=$c.Count })
    }
  }
  $chiaviIgnote = @()
  $cfg = Join-Path $dataFolder "config"
  if(Test-Path -LiteralPath $cfg){
    $chiavi = "ProfileLast|LastProfile|CurrentProfile|ProfileName|Profile"
    foreach($f in @(Get-ChildItem -LiteralPath $cfg -Filter "*.ini" -ErrorAction SilentlyContinue | Sort-Object Name)){
      $t = Leggi-Condiviso $f.FullName
      if(-not $t){ continue }
      foreach($m in [regex]::Matches($t,"(?im)^[ \t]*($chiavi)[ \t]*=[ \t]*(.+?)[ \t]*$")){
        $val = $m.Groups[2].Value.Trim()
        if($val.Length -eq 0){ continue }
        foreach($c in $conChr){
          if($c.Nome -ieq $val){
            $ris.Nome=$c.Nome; $ris.Certo=$true
            $ris.Fonte="[CONFIG] config\" + $f.Name + " -> " + $m.Groups[1].Value + "=" + $val
            return $ris
          }
        }
        # 10/09/2026: il profilo dichiarato dai config puo' ESISTERE ed
        # essere SENZA grafici salvati. Prima finiva fra le "chiavi che
        # nominano un profilo inesistente" e si ripiegava sul .chr piu'
        # recente -- cioe' si spacciava per attivo un RESIDUO. Adesso il
        # profilo dichiarato vince lo stesso, e il fatto che sia vuoto lo
        # dice il chiamante ("cartella trovata ma vuota"), che e' un'altra
        # notizia.
        foreach($p in $profili){
          if($p.Name -ieq $val){
            $ris.Nome=$p.Name; $ris.Certo=$true
            $ris.Fonte="[CONFIG] config\" + $f.Name + " -> " + $m.Groups[1].Value + "=" + $val + "   (profilo SENZA grafici salvati)"
            return $ris
          }
        }
        $chiaviIgnote += ("config\" + $f.Name + " -> " + $m.Groups[1].Value + "=" + $val)
      }
    }
  }
  if($conChr.Count -eq 0){
    if($chiaviIgnote.Count -gt 0){ $ris.Fonte = "nessun profilo con grafici salvati, e la chiave dei config nomina un profilo che non c'e' (" + ($chiaviIgnote -join "; ") + ")" }
    else { $ris.Fonte = "nessun profilo con grafici salvati, e nessuna chiave di profilo nei config" }
    return $ris
  }
  if($conChr.Count -eq 1){
    $ris.Nome=$conChr[0].Nome; $ris.Certo=$true
    $ris.Fonte="[UNICO] e' l'unico profilo con grafici salvati"
    return $ris
  }
  $piu = $conChr | Sort-Object Ultimo -Descending | Select-Object -First 1
  $ris.Nome=$piu.Nome; $ris.Certo=$false
  if($chiaviIgnote.Count -gt 0){
    $perche = "chiave di profilo TROVATA ma nomina un profilo inesistente (" + ($chiaviIgnote -join "; ") + ")"
  } else {
    $perche = "nessuna chiave di profilo nei config"
  }
  $ris.Fonte = "[ASSUNTO] " + $perche + ": preso il profilo col .chr piu' recente (" + $piu.Ultimo.ToString("yyyy.MM.dd HH:mm") + ")"
  return $ris
}

$adesso = Get-Date
$root = Join-Path $env:APPDATA "MetaQuotes\Terminal"
Write-Host "=== LA FOTO DELLE SEDIE E' FRESCA O VECCHIA? ==="
Write-Host ("data lettura: " + $adesso.ToString("yyyy-MM-dd HH:mm:ss") + "  (ora locale)")
Write-Host "confronto: data dei .chr  contro  data dell'ultimo log del terminale."
if(-not (Test-Path $root)){ Write-Host "NESSUNA cartella MetaQuotes\Terminal"; exit 1 }

$cart = @(Get-ChildItem $root -Directory -ErrorAction SilentlyContinue | Where-Object { Test-Path (Join-Path $_.FullName "MQL5") })
Write-Host ("cartelle dati: " + $cart.Count)

# C2: i conti dei "non misuro", che nella v1 erano tutti muti allo stesso modo
$esitoA = 0; $esitoB = 0; $esitoC = 0; $esitoD = 0; $senzaLog = 0
$misurate = 0    # foto TROVATA
$verdetti = 0    # foto CONFRONTATA col log: le uniche misure vere

foreach($d in $cart){
  Write-Host ""
  Write-Host ("=== CARTELLA " + $d.Name)
  $orig = Join-Path $d.FullName "origin.txt"
  if(Test-Path -LiteralPath $orig){
    $o = Leggi-Condiviso $orig
    if($o){ Write-Host ("    programma: " + ($o -replace "[^\x20-\x7E]","").Trim()) }
  }

  # --- C1: la cartella dei profili si risolve e si dichiara
  $chartsRoot = Radice-Profili $d.FullName
  if(-not $chartsRoot){
    $esitoA++
    Write-Host "    ESITO A -- CARTELLA DEI PROFILI NON TROVATA: non ho potuto guardare."
    Write-Host ("        cercata in: " + (Join-Path $d.FullName "MQL5\Profiles\Charts"))
    Write-Host ("                e : " + (Join-Path $d.FullName "profiles\charts"))
    continue
  }
  Write-Host ("    cartella profili: " + $chartsRoot)

  $profili = @(Get-ChildItem -LiteralPath $chartsRoot -Directory -ErrorAction SilentlyContinue)
  $att = Trova-ProfiloAttivo $d.FullName $profili
  Write-Host ("    profili sul disco: " + $profili.Count + "   ATTIVO: '" + $att.Nome + "'   " + $att.Fonte)
  if(-not $att.Nome){
    $esitoB++
    Write-Host "    ESITO B -- PROFILO ATTIVO NON DETERMINATO: salto il confronto, e non concludo niente."
    continue
  }
  if(-not $att.Certo){ Write-Host "    ATTENZIONE: il profilo attivo e' un RIPIEGO, non un fatto letto dai config." }
  $attivo = $att.Nome

  $dirP = Join-Path $chartsRoot $attivo
  if(-not (Test-Path -LiteralPath $dirP)){
    $esitoC++
    Write-Host ("    ESITO C -- CARTELLA DEL PROFILO ATTIVO NON TROVATA: " + $dirP)
    continue
  }
  $chr = @(Get-ChildItem -LiteralPath $dirP -Filter *.chr -ErrorAction SilentlyContinue)
  if($chr.Count -eq 0){
    $esitoD++
    Write-Host "    ESITO D -- CARTELLA TROVATA ma VUOTA: nessun .chr nel profilo attivo (profilo senza grafici salvati)."
    continue
  }
  $misurate++
  $piuNuovo = ($chr | Sort-Object LastWriteTime -Descending | Select-Object -First 1)
  $piuVecchio = ($chr | Sort-Object LastWriteTime | Select-Object -First 1)
  Write-Host ("    .chr: " + $chr.Count)
  Write-Host ("      il piu' RECENTE : " + (Eta $piuNuovo.LastWriteTime) + "   [" + $piuNuovo.Name + "]")
  Write-Host ("      il piu' VECCHIO : " + (Eta $piuVecchio.LastWriteTime) + "   [" + $piuVecchio.Name + "]")

  # --- ultimo log della scheda Esperti: dice se il terminale e' VIVO
  $ultimoLog = $null
  $dirL = Join-Path $d.FullName "MQL5\Logs"
  if(Test-Path -LiteralPath $dirL){
    $lf = @(Get-ChildItem -LiteralPath $dirL -Filter *.log -ErrorAction SilentlyContinue |
            Sort-Object LastWriteTime -Descending | Select-Object -First 1)
    if($lf.Count -gt 0){ $ultimoLog = $lf[0].LastWriteTime }
  }
  if($null -eq $ultimoLog){
    $senzaLog++
    Write-Host "      ESITO F -- ultimo log Esperti: NESSUNO. La foto c'e', il metro di paragone no: non si conclude niente."
    continue
  }
  Write-Host ("      ultimo log Esperti: " + (Eta $ultimoLog))
  $verdetti++

  # C3: il divario HA UN SEGNO. Positivo = il terminale ha scritto DOPO
  #     l'ultimo salvataggio (la foto invecchia). Negativo = il profilo e'
  #     stato salvato DOPO l'ultimo log, cioe' il terminale non scrive piu':
  #     la v1 lo leggeva come "minore di 2" e cantava FOTO FRESCA su un
  #     terminale muto da giorni.
  $divario = [math]::Round(($ultimoLog - $piuNuovo.LastWriteTime).TotalHours, 1)
  $mutoDa  = [math]::Round(((Get-Date) - $ultimoLog).TotalHours, 1)
  if($divario -lt -2){
    Write-Host ("      VERDETTO: TERMINALE MUTO. Il profilo e' stato salvato " + [math]::Abs($divario) + " ore DOPO l'ultimo log.")
    Write-Host ("                La foto e' recente, ma il terminale non scrive da " + $mutoDa + " ore: chiuso, o con gli EA fermi.")
    Write-Host "                Non e' una buona notizia travestita da foto fresca: e' l'opposto."
  } elseif($divario -lt 2){
    Write-Host ("      VERDETTO: FOTO FRESCA. Il profilo e' stato salvato quasi insieme all'ultimo log (divario " + $divario + " ore).")
    if($mutoDa -gt 24){ Write-Host ("                MA ATTENZIONE: l'ultimo log ha " + $mutoDa + " ore. Fresca rispetto al log, vecchia rispetto a ORA.") }
  } elseif($divario -lt 48){
    Write-Host ("      VERDETTO: FOTO TIEPIDA. Il terminale ha scritto " + $divario + " ore DOPO l'ultimo salvataggio del profilo.")
    Write-Host "                Una sedia aggiunta o tolta in quelle ore NON si vede nei .chr."
  } else {
    Write-Host ("      VERDETTO: FOTO VECCHIA. Divario di " + $divario + " ore fra l'ultimo log e l'ultimo .chr salvato.")
    Write-Host "                I censimenti fatti sui .chr descrivono questo terminale com'era ALLORA."
  }
}

Write-Host ""
Write-Host "--- DOVE HO GUARDATO (senza questo riquadro, un 'niente' non si sa leggere) ---"
Write-Host ("    cartelle dati esaminate                           : " + $cart.Count)
Write-Host ("    terminali con la FOTO trovata                      : " + $misurate)
Write-Host ("    terminali MISURATI (foto CONFRONTATA col log)      : " + $verdetti)
Write-Host ("    ESITO A -- cartella dei profili NON TROVATA        : " + $esitoA)
Write-Host ("    ESITO B -- profilo attivo NON DETERMINATO          : " + $esitoB)
Write-Host ("    ESITO C -- cartella del profilo attivo NON TROVATA : " + $esitoC)
Write-Host ("    ESITO D -- cartella trovata ma VUOTA (0 .chr)      : " + $esitoD)
Write-Host ("    ESITO F -- foto trovata ma NESSUN log da confrontare: " + $senzaLog)
if($verdetti -eq 0){
  Write-Host "    >>> NESSUN TERMINALE MISURATO: questo referto non dice che le foto sono vecchie."
  Write-Host "        Dice che non ho trovato le foto. Sono due cose diverse."
}

# =====================================================================
#  IL CALENDARIO DELLE NEWS, letto invece che dedotto
# =====================================================================
Write-Host ""
Write-Host "=== COMMON\FILES -- cosa leggono davvero gli EA ==="
$common = Join-Path $env:APPDATA "MetaQuotes\Terminal\Common\Files"
if(-not (Test-Path -LiteralPath $common)){
  Write-Host "    Common\Files non esiste."
} else {
  $ff = @(Get-ChildItem -LiteralPath $common -File -ErrorAction SilentlyContinue | Sort-Object Name)
  Write-Host ("    file: " + $ff.Count)
  foreach($f in $ff){
    $kb = [math]::Round($f.Length/1KB, 1)
    Write-Host ("      " + $f.Name.PadRight(40) + " " + ("" + $kb + " KB").PadLeft(12) + "   " + $f.LastWriteTime.ToString("yyyy-MM-dd HH:mm"))
  }
  Write-Host ""
  Write-Host "    --- CONTENUTO dei file che sembrano calendari (news/calend/event) ---"
  $cal = @($ff | Where-Object { $_.Name -match "(?i)news|calend|event" })
  if($cal.Count -eq 0){
    Write-Host "      NESSUN file col nome da calendario. Il PostNews legge un file che non c'e'."
  }
  foreach($f in $cal){
    Write-Host ""
    Write-Host ("      >>> " + $f.Name + "   (" + $f.LastWriteTime.ToString("yyyy-MM-dd HH:mm") + ")")
    $t = Leggi-Condiviso $f.FullName
    if(-not $t){ Write-Host "          (illeggibile o vuoto)"; continue }
    $righe = @($t -split "`r?`n" | Where-Object { $_.Trim() -ne "" })
    Write-Host ("          righe non vuote: " + $righe.Count)
    $n = 0
    foreach($r in $righe){
      $n++
      if($n -gt 30){ Write-Host "          ... (altre righe non stampate)"; break }
      Write-Host ("          | " + ($r -replace "[^\x20-\x7E]","").Trim())
    }
  }
}

Write-Host ""
Write-Host "PROMEMORIA: un .chr fresco dice quando la foto e' stata scattata, non che l'EA sia attivo."
Write-Host "Questa riga LEGGE E STAMPA: non ha scritto, copiato o modificato niente."
exit 0
