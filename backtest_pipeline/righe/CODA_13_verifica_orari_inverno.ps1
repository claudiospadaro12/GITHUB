# =====================================================================
#  MARCATORE_CODA_13_VERIFICA_ORARI_INVERNO_v1
#  RUNNER_SOLA_LETTURA
# ---------------------------------------------------------------------
#  COSA FA: per OGNI sedia del profilo ATTIVO di ogni terminale confronta
#  gli orari in ORA SERVER degli EA ABTG con i valori ATTESI per l'ora
#  SOLARE, e stampa OK / DA CORREGGERE. Non scrive, non copia, non
#  cancella: STAMPA (il runner salva lo stampato come referto).
#
#  PERCHE': il 04/11/2026 Claudio ha confermato che il server BCM e a
#  GMT+1 FISSO: d'estate 1 ora indietro rispetto all'Italia, d'inverno
#  UGUALE (CLAUDE.md, regola aggiornata). Le sedie con orari in ora server
#  messi d'estate vanno spostate di +1 ora; quelle di Asia (Nikkei) no.
#
#  VALORI ATTESI = proposta di C0 del 04/11/2026, nell'ipotesi che l'ora
#  ITALIANA voluta sia rimasta quella messa d'estate. Se Claudio decide
#  un orario diverso per una sedia, si cambia la tabella qui sotto.
#
#  LIMITE DICHIARATO: si legge il .chr, che MT5 riscrive al SALVATAGGIO
#  del profilo. Se un input e stato cambiato e il profilo non e stato
#  salvato, qui esce il valore vecchio (stessa domanda di CODA_05).
#  Da rifare a MARZO 2027 (ora legale) con la tabella dei valori estivi.
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


# --- TABELLA DEI VALORI ATTESI (ora SOLARE: server = ora italiana) -----
#     nome EA ; simbolo (* = qualunque) ; coppie Input=Valore
$ATTESI = @(
  @("ABTG_MaxMinNotte","*",@{InpBoxStartHour="0";InpBoxStartMin="0";InpBoxEndHour="5";InpBoxEndMin="59";InpPlaceHour="8";InpPlaceMin="0";InpEntryCutoffHour="9";InpEntryCutoffMin="30";InpCloseHour="18";InpCloseMin="30"}),
  @("ABTG_MaxMinNotte_DAX_Short_Ottimizzato","*",@{InpBoxStartHour="0";InpBoxEndHour="5";InpBoxEndMin="59";InpPlaceHour="8";InpPlaceMin="59"}),
  @("ABTG_Nasdaq_Apertura_US","*",@{InpSessionHour="15";InpSessionMin="30";InpCloseHour="21";InpCloseMin="45"}),
  @("ABTG_Dow_Apertura_US","*",@{InpSessionHour="15";InpSessionMin="30";InpCloseHour="18";InpCloseMin="30"}),
  @("ABTG_DAX_Apertura_EU","*",@{InpSessionHour="9";InpCloseHour="18";InpCloseMin="30"}),
  @("ABTG_ORB_Ottimizzato","*",@{InpRangeStartHour="15";InpRangeStartMin="30";InpRangeEndHour="15";InpRangeEndMin="45";InpEndHour="22";InpEndMin="0"}),
  @("ABTG_EasyTrend","*",@{InpHourStart="9";InpHourEnd="19"}),
  @("ABTG_PostNews","USDJPY",@{InpActionHour="15";InpActionMin="45";InpExpiryHour="18";InpExpiryMin="59"}),
  @("ABTG_PostNews","EURJPY",@{InpActionHour="16";InpActionMin="0";InpExpiryHour="19";InpExpiryMin="15"}),
  @("ABTG_PostNews","EURUSD",@{InpActionHour="20";InpActionMin="40";InpExpiryHour="21";InpExpiryMin="45"})
)


$root = Join-Path $env:APPDATA "MetaQuotes\Terminal"
Write-Host "=== VERIFICA ORARI INVERNO (server BCM = ora italiana, GMT+1 fisso) v1 ==="
Write-Host ("data lettura: " + (Get-Date -Format "yyyy-MM-dd HH:mm:ss") + "  (ora locale del VPS)")
Write-Host "letti dai .chr del PROFILO ATTIVO. I .chr sono una foto al salvataggio del profilo."
if(-not (Test-Path $root)){ Write-Host "NESSUNA cartella MetaQuotes\Terminal"; exit 1 }
$cart = @(Get-ChildItem $root -Directory -ErrorAction SilentlyContinue | Where-Object { Test-Path (Join-Path $_.FullName "MQL5") })
Write-Host ("cartelle dati: " + $cart.Count)
$nOK = 0; $nKO = 0; $nNV = 0; $nSedie = 0; $nNonGuardato = 0

foreach($d in $cart){
  $orig = Join-Path $d.FullName "origin.txt"
  $prog = "(programma sconosciuto)"
  if(Test-Path -LiteralPath $orig){
    $o = Leggi-Condiviso $orig
    if($o){ $prog = ($o -replace "[^\x20-\x7E]","").Trim() }
  }
  Write-Host ""
  Write-Host ("=== " + $prog + "   [cartella dati " + $d.Name + "]")
  $chartsRoot = Radice-Profili $d.FullName
  if(-not $chartsRoot){ $nNonGuardato++; Write-Host "    NON GUARDATO: cartella dei profili non trovata."; continue }
  $profili = @(Get-ChildItem -LiteralPath $chartsRoot -Directory -ErrorAction SilentlyContinue)
  $att = Trova-ProfiloAttivo $d.FullName $profili
  Write-Host ("    profilo attivo: '" + $att.Nome + "'   " + $att.Fonte)
  if(-not $att.Nome){ $nNonGuardato++; Write-Host "    NON GUARDATO: profilo attivo non determinato."; continue }
  $dirP = Join-Path $chartsRoot $att.Nome
  if(-not (Test-Path -LiteralPath $dirP)){ $nNonGuardato++; Write-Host "    NON GUARDATO: cartella del profilo attivo non trovata."; continue }
  $chr = @(Get-ChildItem -LiteralPath $dirP -Filter "chart*.chr" -ErrorAction SilentlyContinue | Sort-Object Name)
  foreach($x in $chr){
    $txt = Leggi-Condiviso $x.FullName
    if(-not $txt){ continue }
    $bloccoEa = Blocco-Expert $txt
    if(-not $bloccoEa){ continue }
    $ea = Campo $bloccoEa "name"
    if($ea -eq "-" -or $ea -ieq "Main"){ continue }
    $nSedie++
    $sym = Campo $txt "symbol"
    $inp = @(Righe-Inp (Blocco-Inputs $bloccoEa))
    $val = @{}
    foreach($p in $inp){ $val[$p.Nome] = $p.Valore }
    $trovata = $false
    foreach($a in $ATTESI){
      if($a[0] -ne $ea){ continue }
      if(-not ($sym -like $a[1])){ continue }
      $trovata = $true
      $dif = @()
      foreach($k in $a[2].Keys){
        $v = "(assente)"
        if($val.ContainsKey($k)){ $v = $val[$k] }
        if($v -ne $a[2][$k]){ $dif += ($k + ": trovato " + $v + ", atteso " + $a[2][$k]) }
      }
      if($dif.Count -eq 0){
        $nOK++
        Write-Host ("    OK               " + $ea + "  " + $sym)
      } else {
        $nKO++
        Write-Host ("    DA CORREGGERE    " + $ea + "  " + $sym + "   ->   " + ($dif -join " | "))
      }
    }
    if($ea -eq "ABTG_Guardian"){
      $rh = "(assente)"
      if($val.ContainsKey("InpDailyResetHour")){ $rh = $val["InpDailyResetHour"] }
      Write-Host ("    INFO             ABTG_Guardian  " + $sym + "  InpDailyResetHour=" + $rh + "  (ora SERVER: d'inverno = ora italiana)")
    } elseif((-not $trovata) -and ($ea -like "ABTG_*")){
      $nNV++
    }
  }
}

Write-Host ""
Write-Host "====================================================================="
Write-Host ("SEDIE LETTE: " + $nSedie + "   OK: " + $nOK + "   DA CORREGGERE: " + $nKO + "   ABTG senza orario previsto: " + $nNV + "   terminali NON GUARDATI: " + $nNonGuardato)
if($nKO -eq 0 -and $nOK -gt 0){ Write-Host "ESITO: tutti gli orari previsti sono a ora solare." }
if($nKO -gt 0){ Write-Host "ESITO: ci sono sedie da correggere (righe DA CORREGGERE qui sopra)." }
if($nOK -eq 0 -and $nKO -eq 0){ Write-Host "ESITO: nessuna sedia della tabella trovata: NON e un OK, e un posto dove non ho trovato niente." }
Write-Host "====================================================================="
Write-Host "Questa riga LEGGE E STAMPA: non ha scritto, copiato o modificato niente."
exit 0
