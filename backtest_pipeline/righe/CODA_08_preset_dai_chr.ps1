# =====================================================================
#  MARCATORE_CODA_08_PRESET_DAI_CHR_v3
#  RUNNER_SOLA_LETTURA
# ---------------------------------------------------------------------
#  COSA FA: per OGNI sedia del profilo ATTIVO stampa TUTTI i suoi
#  parametri, gia' nella forma di un file .set pronto da salvare.
#  Non scrive, non copia, non cancella: STAMPA.
#
#  PERCHE' ESISTE -- un buco misurato l'08/09/2026
#  Il censimento del rischio ha trovato che sul conto 100k (50504263)
#  NON esiste NESSUN preset nel repo: le taglie con cui girano quelle
#  sedie (0,65 e 0,30) vivono SOLO dentro i file .chr del terminale.
#
#  >>> Se quel terminale si azzera -- disco, reinstallazione, profilo
#      sovrascritto -- la configurazione del dry-run FTMO NON e'
#      ricostruibile da nessuna fonte scritta. Settimane di forward
#      diventano irripetibili, e a tre settimane dalla challenge
#      sarebbe la perdita peggiore possibile.
#
#  Questa riga porta quei parametri FUORI dal terminale e dentro il
#  repo, dove sono versionati, leggibili e ricostruibili. E' l'unico
#  modo che ha Claude di vederli: il perimetro firmato e' di sola
#  lettura, quindi il .set lo scrive lui nel repo DOPO, a mano, da
#  questo stampato -- non lo scrive questa riga sul terminale.
#
#  LIMITE DICHIARATO: si legge il .chr, che MT5 riscrive al SALVATAGGIO
#  del profilo. Se un input e' stato cambiato e il profilo non e' stato
#  salvato, qui esce il valore vecchio. E' la stessa domanda che misura
#  CODA_05: i due referti vanno letti insieme.
#
# =====================================================================
#  PERCHE' ESISTE LA v2 -- il difetto e' mio, ed e' costato un referto
#  La v1 e' girata il 10/09/2026 alle 03:31 e ha stampato una riga sola:
#  "TOTALE SEDIE STAMPATE: 0". Nessun errore, nessun avviso: uno ZERO.
#  La causa e' un pezzo di percorso mancante:
#     v1:  <cartella dati>\profiles\charts\<profilo>      <-- MT4
#     MT5: <cartella dati>\MQL5\Profiles\Charts\<profilo>
#  Il pezzo "MQL5\" in MT4 non esiste, in MT5 si'. La cartella non c'era
#  mai, quindi il ciclo faceva "continue" per tutte e sei le cartelle
#  dati e il totale restava a zero. Stessa identica riga sbagliata anche
#  in CODA_05 (che infatti stampava "la cartella del profilo attivo non
#  esiste" su 6 terminali su 6). CODA_01, che nella stessa notte leggeva
#  40+7+2 sedie, il percorso giusto ce l'aveva gia': la strada esisteva
#  dentro un altro script della stessa coda.
#
#  >>> IL DANNO VERO non e' lo zero: e' che il referto del CANCELLO
#      COSTO FLOTTA del 10/09 ha dovuto leggere TUTTE le geometrie delle
#      40 sedie dal sorgente e dai .set del repo, cioe' da cio' che
#      DOVREBBE girare, non da cio' che GIRA. Finche' questa riga e'
#      muta, quelle misure restano CONDIZIONATE.
#
#  Le due correzioni della v2:
#   C1 - il percorso si RISOLVE e si DICHIARA: si prova MQL5\Profiles\
#        Charts (MT5) e, come ripiego, profiles\charts (MT4), e si
#        stampa QUALE dei due si e' usato. E il profilo attivo lo trova
#        la stessa funzione di CODA_01 (che guarda TUTTI i config\*.ini,
#        non solo common.ini, e dichiara quando sta tirando a indovinare).
#   C2 - UNO ZERO NON E' PIU' UNO ZERO SOLO. Ogni ramo che finiva in
#        "continue" muto adesso stampa un ESITO diverso:
#          ESITO A - cartella dei profili NON TROVATA (non ho guardato)
#          ESITO B - profilo attivo NON DETERMINATO
#          ESITO C - cartella del profilo attivo NON TROVATA
#          ESITO D - cartella TROVATA ma VUOTA (0 file chart*.chr)
#          ESITO E - ZERO SEDIE DAVVERO (.chr letti, nessuno con un EA)
#        Sono cinque fatti diversi che la v1 stampava allo stesso modo:
#        niente. "Uno zero non e' una prova finche' non dimostri di aver
#        guardato nel posto giusto."
# =====================================================================
#  PERCHE' ESISTE LA v3 -- classe 232, trovata l'11/09/2026
#  La v2 stampava OGNI riga "Inp*=" trovata NEL FILE, in qualunque punto
#  del .chr stesse. Ma un .chr non e' una lista piatta: ha BLOCCHI.
#     <chart> ... <expert> ... <inputs> ...gli input dell'EA... </inputs>
#              ...  </expert> <window> <indicator> ... <inputs>
#              ...gli input dell'INDICATORE... </inputs> </indicator>
#  Risultato misurato sul referto del 11/09 03:31:
#     - "ABTG_Dow_Apertura_US" stampava 112 parametri; l'EA ne dichiara 81
#       (100k, col Guardian) / 80 (piccolo). I 32 di troppo sono, NELLO
#       STESSO ORDINE, i 32 input di mql5/Indicators/ABTG_Look.mq5;
#     - "ABTG_TradeExporter" stampava 36 parametri; il sorgente ne ha 4.
#       4 + 32 = 36. Gli stessi 32.
#     - e InpVerbose compariva DUE VOLTE (true dall'EA, false da ABTG_Look):
#       un .set cosi' su un EA NON e' caricabile -- in MQL5 due input con
#       lo stesso nome non esistono.
#
#  >>> IL DANNO: l'11/09 un preset vero e' stato scritto COPIANDO da questo
#      stampato (mql5\Presets\ABTG_Dow_Apertura_US_U30USD_M5_770202_100K.set).
#      Chi copia un blocco senza sapere che e' mescolato ci mette 32 righe
#      false, su una sedia VIVA. Quel preset e' stato verificato riga per
#      riga contro il sorgente ed e' PULITO (81 su 81, stesso ordine) --
#      ma e' pulito perche' chi l'ha scritto si e' accorto del difetto,
#      non perche' lo strumento glielo impedisse. Il prossimo non se ne
#      accorge.
#
#  La correzione della v3:
#   C3 - si ESTRAE prima <expert>...</expert>, poi <inputs>...</inputs>
#        DENTRO quel blocco, e si stampa SOLO quello. Stesso ancoraggio gia'
#        usato da estrai_set_forward.ps1 e verifica_vivaio_r23.ps1 (che nel
#        commento aveva gia' scritto il perche': "sul grafico possono
#        esserci indicatori custom col proprio blocco <inputs>").
#   C4 - cio' che si scarta si DICHIARA, con nome e path dell'indicatore
#        a cui appartiene, piu' il residuo eventuale fuori da ogni blocco.
#        Un numero tolto in silenzio e' lo stesso difetto di un numero
#        aggiunto in silenzio.
#   C5 - si controlla che nel blocco stampato non ci siano NOMI DOPPI: se
#        ce ne sono, il .set non caricherebbe, e va detto sul momento.
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

function Campo($txt,$nome){
  # 11/09/2026: "\s" comprende l'A-CAPO. Con "\s*=\s*(.*)$" un campo VUOTO
  #   path=
  #   apply=1
  # restituiva "apply=1", cioe' il valore della riga DOPO. Su un .chr i campi
  # vuoti sono normali (path= dell'indicatore Main, InpNewsCurrencies= dell'EA):
  # qui si resta sulla RIGA, spazi e tabulazioni e basta.
  # stessa forma gia' in uso in CODA_01 v2, che questo difetto non l'aveva
  $m = [regex]::Match($txt, "(?im)^[ \t]*" + [regex]::Escape($nome) + "[ \t]*=[ \t]*(.*?)[ \t]*$")
  if($m.Success -and $m.Groups[1].Value.Trim().Length -gt 0){ return $m.Groups[1].Value.Trim() }
  return "-"
}

# --- C3: I BLOCCHI DEL .chr. Un .chr NON e' una lista piatta di Inp*.
#     <expert> ... <inputs> input DELL'EA </inputs> ... </expert>
#     <window> <indicator> ... <inputs> input DELL'INDICATORE </inputs> ...
#     Si estrae PRIMA il blocco, POI gli <inputs> DENTRO quel blocco: mai
#     "<expert>.*?<inputs>" in un colpo solo, perche' se l'EA non ha input
#     quella ricerca scavalca </expert> e pesca gli input del primo
#     indicatore -- cioe' rifarebbe lo stesso difetto in forma piu' subdola.
function Blocco-Expert($txt){
  $m = [regex]::Match($txt, "(?s)<expert>(.*?)</expert>")
  if($m.Success){ return $m.Groups[1].Value }
  return ""
}

function Blocco-Inputs($blocco){
  if(-not $blocco){ return "" }
  $m = [regex]::Match($blocco, "(?s)<inputs>(.*?)</inputs>")
  if($m.Success){ return $m.Groups[1].Value }
  return ""
}

# righe "Inp*=..." di un pezzo di testo, nell'ordine in cui stanno
function Righe-Inp($blocco){
  $out = @()
  if(-not $blocco){ return $out }
  foreach($riga in ($blocco -split "`r?`n")){
    $r = $riga.Trim()
    if($r -match "^(Inp[A-Za-z0-9_]+)\s*=\s*(.*)$"){
      $out += (New-Object psobject -Property @{ Nome=$matches[1]; Valore=$matches[2].Trim() })
    }
  }
  return $out
}

# --- C4: DI CHI SONO I PARAMETRI CHE NON STAMPO. Nome e path, non "altri".
function Indicatori-Con-Input($txt){
  $out = @()
  foreach($m in [regex]::Matches($txt, "(?s)<indicator>(.*?)</indicator>")){
    $b    = $m.Groups[1].Value
    $ins  = Blocco-Inputs $b
    $n    = @(Righe-Inp $ins).Count
    if($n -eq 0){ continue }   # un indicatore senza input non e' una notizia
    $nome = Campo $b "name"
    $path = Campo $b "path"
    $out += (New-Object psobject -Property @{ Nome=$nome; Path=$path; Quanti=$n })
  }
  return $out
}

# --- C1: DOVE stanno i profili. Si prova, non si assume, e si dichiara.
#     MT5 -> <dati>\MQL5\Profiles\Charts   MT4 -> <dati>\profiles\charts
function Radice-Profili($dataFolder){
  foreach($c in @((Join-Path $dataFolder "MQL5\Profiles\Charts"), (Join-Path $dataFolder "profiles\charts"))){
    if(Test-Path -LiteralPath $c){ return $c }
  }
  return ""
}

# --- QUALE PROFILO E' QUELLO CARICATO. Stessa funzione di CODA_01 v2
#     (che a sua volta la prende da censimento_rischio.ps1 v2): guarda
#     TUTTI i config\*.ini, non il solo common.ini, e quando tira a
#     indovinare lo SCRIVE invece di far finta di saperlo.
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

$root = Join-Path $env:APPDATA "MetaQuotes\Terminal"
Write-Host "=== I PARAMETRI DI OGNI SEDIA, IN FORMA DI .set (v3) ==="
Write-Host ("data lettura: " + (Get-Date -Format "yyyy-MM-dd HH:mm:ss") + "  (ora locale)")
Write-Host "letti dai .chr del PROFILO ATTIVO. I .chr sono una foto al salvataggio del profilo."
Write-Host "v2: percorso dei profili RISOLTO e dichiarato; ogni zero dice PERCHE' e' zero."
Write-Host "v3: si stampano SOLO gli input del blocco <expert>. Quelli degli INDICATORI"
Write-Host "    appesi al grafico sono esclusi e contati a parte, indicatore per indicatore."
if(-not (Test-Path $root)){ Write-Host "NESSUNA cartella MetaQuotes\Terminal"; exit 1 }

$cart = @(Get-ChildItem $root -Directory -ErrorAction SilentlyContinue | Where-Object { Test-Path (Join-Path $_.FullName "MQL5") })
Write-Host ("cartelle dati: " + $cart.Count)

$totSedie   = 0
$esitoA = 0; $esitoB = 0; $esitoC = 0; $esitoD = 0; $esitoE = 0; $conSedie = 0

foreach($d in $cart){
  $orig = Join-Path $d.FullName "origin.txt"
  $prog = "(programma sconosciuto)"
  if(Test-Path -LiteralPath $orig){
    $o = Leggi-Condiviso $orig
    if($o){ $prog = ($o -replace "[^\x20-\x7E]","").Trim() }
  }

  Write-Host ""
  Write-Host "====================================================================="
  Write-Host ("=== " + $prog)
  Write-Host ("=== cartella dati: " + $d.Name)
  Write-Host "====================================================================="

  $chartsRoot = Radice-Profili $d.FullName
  if(-not $chartsRoot){
    $esitoA++
    Write-Host "    ESITO A -- CARTELLA DEI PROFILI NON TROVATA."
    Write-Host ("        cercata in: " + (Join-Path $d.FullName "MQL5\Profiles\Charts"))
    Write-Host ("                e : " + (Join-Path $d.FullName "profiles\charts"))
    Write-Host "        NON e' 'zero sedie': e' un posto dove non ho potuto guardare."
    continue
  }
  Write-Host ("    cartella profili: " + $chartsRoot)

  $profili = @(Get-ChildItem -LiteralPath $chartsRoot -Directory -ErrorAction SilentlyContinue)
  $att = Trova-ProfiloAttivo $d.FullName $profili
  Write-Host ("    profili sul disco: " + $profili.Count + "   ATTIVO: '" + $att.Nome + "'   " + $att.Fonte)
  if(-not $att.Nome){
    $esitoB++
    Write-Host "    ESITO B -- PROFILO ATTIVO NON DETERMINATO: nessuna sedia stampata, e non e' uno zero misurato."
    continue
  }
  if(-not $att.Certo){ Write-Host "    ATTENZIONE: il profilo attivo e' un RIPIEGO, non un fatto letto dai config." }

  $dirP = Join-Path $chartsRoot $att.Nome
  if(-not (Test-Path -LiteralPath $dirP)){
    $esitoC++
    Write-Host ("    ESITO C -- CARTELLA DEL PROFILO ATTIVO NON TROVATA: " + $dirP)
    continue
  }
  $chr = @(Get-ChildItem -LiteralPath $dirP -Filter "chart*.chr" -ErrorAction SilentlyContinue | Sort-Object Name)
  if($chr.Count -eq 0){
    $esitoD++
    Write-Host "    ESITO D -- CARTELLA TROVATA ma VUOTA: 0 file chart*.chr nel profilo attivo."
    Write-Host "        Il profilo esiste ma non ha grafici salvati: non e' 'nessuna sedia', e' 'nessuna foto'."
    continue
  }
  Write-Host ("    file chart*.chr nel profilo attivo: " + $chr.Count)

  $sedieQui = 0; $scartMain = 0; $scartNoExpert = 0; $illeggibili = 0
  foreach($x in $chr){
    $txt = Leggi-Condiviso $x.FullName
    if(-not $txt){ $illeggibili++; continue }

    # v3: il blocco <expert> PRIMA di ogni altra cosa. Senza quel blocco
    #     non c'e' nessuna sedia, e il 'name=' del file sarebbe quello
    #     della finestra del grafico ('Main') o di un indicatore.
    $bloccoEa = Blocco-Expert $txt
    if(-not $bloccoEa){ $scartNoExpert++; continue }

    $ea = Campo $bloccoEa "name"
    if($ea -eq "-"){
      $mp = [regex]::Match($bloccoEa, "(?i)path\s*=\s*Experts\\(.+?)\.ex5")
      if($mp.Success){ $ea = [IO.Path]::GetFileNameWithoutExtension($mp.Groups[1].Value) }
    }
    if($ea -eq "-" -or $ea -ieq "Main"){ $scartMain++; continue }

    $totSedie++
    $sedieQui++

    $inputsEa = Blocco-Inputs $bloccoEa
    $pEa      = @(Righe-Inp $inputsEa)
    $indic    = @(Indicatori-Con-Input $txt)
    $totFile  = @(Righe-Inp $txt).Count
    $totInd   = 0
    foreach($i in $indic){ $totInd += $i.Quanti }
    $altrove  = $totFile - $pEa.Count - $totInd

    $sym   = Campo $txt "symbol"
    $magic = Campo $inputsEa "InpMagic"
    if($magic -eq "-"){ $magic = Campo $inputsEa "InpMagicNumber" }

    Write-Host ""
    Write-Host ("--- SEDIA: " + $ea + "  su " + $sym + "   magic " + $magic + "   [" + $x.Name + "] ---")
    Write-Host ("; preset ricostruito da " + $x.Name + " il " + (Get-Date -Format "yyyy-MM-dd") + " -- LETTO, non scritto")
    Write-Host ("; terminale: " + $prog + " . profilo: " + $att.Nome)
    Write-Host ("; EA: " + $ea + " . simbolo del grafico: " + $sym)
    Write-Host ("; .chr modificato il: " + $x.LastWriteTime.ToString("yyyy-MM-dd HH:mm"))
    Write-Host "; v3: sotto ci sono SOLO gli input del blocco <expert>. Copiabile in un .set."

    foreach($p in $pEa){ Write-Host ($p.Nome + "=" + $p.Valore) }

    if($pEa.Count -eq 0){
      if(-not $inputsEa){
        Write-Host "; NESSUN blocco <inputs> dentro <expert>: l'EA e' attaccato ma il profilo non e' mai stato salvato dopo, oppure l'EA non ha input."
      } else {
        Write-Host "; blocco <inputs> dell'EA TROVATO ma VUOTO di righe Inp*: l'EA usa nomi diversi da 'Inp...'."
      }
    } else {
      Write-Host ("; parametri dell'EA stampati: " + $pEa.Count)
    }

    # C5: due input con lo stesso nome = .set che non carica. Si dice subito.
    $dupl = @($pEa | Group-Object Nome | Where-Object { $_.Count -gt 1 })
    if($dupl.Count -gt 0){
      Write-Host ("; [!!] NOMI DOPPI nel blocco dell'EA (" + (($dupl | ForEach-Object { $_.Name }) -join ", ") + "): un .set cosi' NON carica. Va capito prima di usarlo.")
    }

    # C4: cio' che NON ho stampato, e di chi era. Mai un taglio muto.
    Write-Host ("; SCARTATI perche' NON dell'EA: " + ($totInd + [math]::Max(0,$altrove)) + " su " + $totFile + " righe Inp* presenti nel .chr")
    if($indic.Count -eq 0){
      Write-Host ";   nessun indicatore con input sul grafico"
    } else {
      foreach($i in $indic){
        Write-Host (";   INDICATORE '" + $i.Nome + "' (" + $i.Path + "): " + $i.Quanti + " input scartati")
      }
    }
    if($altrove -gt 0){
      Write-Host ("; [!] " + $altrove + " righe Inp* stanno FUORI da <expert> e fuori da ogni <indicator>: non so di chi sono, e NON le ho stampate.")
    }
  }

  Write-Host ""
  if($sedieQui -eq 0){
    $esitoE++
    Write-Host ("    ESITO E -- ZERO SEDIE DAVVERO: " + $chr.Count + " file .chr letti nel profilo attivo, nessuno con un EA sopra.")
    Write-Host ("        scartati: 'Main'/senza nome " + $scartMain + " . senza blocco <expert> " + $scartNoExpert + " . illeggibili " + $illeggibili)
    Write-Host "        Questo SI' e' uno zero misurato: ho guardato nel posto giusto e non c'era niente."
  } else {
    $conSedie++
    Write-Host ("    sedie stampate su questo terminale: " + $sedieQui + "   (su " + $chr.Count + " file .chr: 'Main'/senza nome " + $scartMain + ", senza <expert> " + $scartNoExpert + ", illeggibili " + $illeggibili + ")")
  }
}

Write-Host ""
Write-Host "====================================================================="
Write-Host ("TOTALE SEDIE STAMPATE: " + $totSedie)
Write-Host "--- DOVE HO GUARDATO, cartella per cartella (un totale senza questo e' cieco) ---"
Write-Host ("    cartelle dati esaminate                          : " + $cart.Count)
Write-Host ("    con sedie stampate                               : " + $conSedie)
Write-Host ("    ESITO A -- cartella dei profili NON TROVATA      : " + $esitoA)
Write-Host ("    ESITO B -- profilo attivo NON DETERMINATO        : " + $esitoB)
Write-Host ("    ESITO C -- cartella del profilo attivo NON TROVATA: " + $esitoC)
Write-Host ("    ESITO D -- cartella trovata ma VUOTA (0 .chr)    : " + $esitoD)
Write-Host ("    ESITO E -- zero sedie DAVVERO (.chr letti, 0 EA) : " + $esitoE)
if($totSedie -eq 0){
  Write-Host "    >>> IL TOTALE E' ZERO: si legge la riga di ESITO qui sopra che e' maggiore di zero."
  Write-Host "        A, B, C e D vogliono dire 'non ho potuto guardare'. Solo la E e' una misura."
}
Write-Host "====================================================================="
Write-Host "COME SI USA: si copiano le righe Inp* di una sedia in un file .set del repo."
Write-Host "v3: le righe stampate sono SOLO quelle del blocco <expert>, quindi il blocco e'"
Write-Host "copiabile cosi' com'e'. Le righe '; SCARTATI' dicono quante ne ho tolte e di CHI"
Write-Host "erano: se quel numero non e' zero, il vecchio referto della v2 era contaminato."
Write-Host "CONTROLLO FINALE CHE RESTA A CHI SCRIVE IL .set: i nomi stampati devono coincidere"
Write-Host "con le dichiarazioni 'input' del sorgente dell'EA. Lo strumento separa i blocchi,"
Write-Host "non certifica il sorgente."
Write-Host "Quel .set va poi CONFRONTATO col preset gia' esistente, se c'e': se differiscono,"
Write-Host "vince cio' che GIRA, ma la differenza va dichiarata, non appianata in silenzio."
Write-Host "Questa riga LEGGE E STAMPA: non ha scritto, copiato o modificato niente."
exit 0
