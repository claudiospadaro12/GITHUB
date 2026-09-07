# =====================================================================
#  MARCATORE_CODA_01_SEDIE_ATTACCATE_v2
#  RUNNER_SOLA_LETTURA
# ---------------------------------------------------------------------
#  COSA FA: legge i .chr di TUTTE le cartelle dati e STAMPA che cosa e'
#  attaccato dove, SEPARANDO il PROFILO ATTIVO dai RESIDUI SU DISCO.
#  Non scrive, non copia, non cancella: STAMPA. Il runner cattura lo
#  standard output e lo pubblica.
#
# =====================================================================
#  PERCHE' ESISTE LA v2 -- ed e' un difetto mio, pagato al primo giro
#  La v1 (07/09, prima corsa del runner alle 22:59) contava i .chr di
#  TUTTI i profili come se fossero sedie vive. Risultato: 132 "sedie",
#  con 770101 / 770202 / 770411 / 770901 / 770611 che comparivano DUE
#  VOLTE sul 100k -- quasi certamente profili non caricati.
#
#  >>> ED E' ESATTAMENTE IL DIFETTO DELLA v1 DI censimento_rischio.ps1,
#      GIA' PAGATO CON DUE INCIDENTI VERI:
#        23/08 - ORB_Ottimizzato U30USD 770611 contato DUE VOLTE;
#        24/08 - Gold_Ichimoku 250604, che non girava da giugno, entrato
#                in classifica R103 e nella somma della flotta.
#      Avevo riscritto una ruota che esisteva gia', rimettendoci dentro
#      il bug che quella ruota era stata costruita per togliere.
#      La v2 qui sotto RIUSA la logica di censimento_rischio.ps1 v2.
#      Regola per la coda, da qui: PRIMA SI GUARDA SE LO STRUMENTO C'E'.
#
#  Gli altri tre difetti del primo giro, corretti:
#   D1 - 'name=Main' non e' un EA, e' la finestra del grafico: si salta.
#        (era il grosso del 132 gonfiato)
#   D2 - un campo mancante stampava 'System.Object[]': adesso stampa '-'.
#   D3 - il timeframe si legge da period_type + period_size, non dal
#        solo period_size (uscivano 'p4', 'p24', 'p2' al posto di H4,
#        H24, M2).
#
#  ATTENZIONE, IL LIMITE, DICHIARATO: i .chr si aggiornano SOLO quando
#  MT5 salva il profilo. Un grafico aperto e mai salvato NON compare.
#  Per una foto fedele: in MT5 File -> Profili -> Salva.
#
#  ENUMERA TUTTE LE CARTELLE DATI, senza puntarne nessuna: e' una
#  LETTURA generica, e serve proprio a vedere se qualcosa compare dove
#  non dovrebbe.
# =====================================================================

# --- lettura CONDIVISA: un .chr tenuto aperto da MT5 non deve far
#     morire tutto il censimento (nota del verificatore, 19/08).
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

# --- QUALE PROFILO E' QUELLO CARICATO. Tre strade, in ordine, e la
#     terza DICHIARA di essere un ripiego (portata da censimento_rischio v2).
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
  if($conChr.Count -eq 0){ $ris.Fonte = "nessun profilo con grafici salvati"; return $ris }
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
        $chiaviIgnote += ("config\" + $f.Name + " -> " + $m.Groups[1].Value + "=" + $val)
      }
    }
  }
  if($conChr.Count -eq 1){
    $ris.Nome=$conChr[0].Nome; $ris.Certo=$true
    $ris.Fonte="[UNICO] e' l'unico profilo con grafici salvati"
    return $ris
  }
  $piu = $conChr | Sort-Object Ultimo -Descending | Select-Object -First 1
  $ris.Nome=$piu.Nome; $ris.Certo=$false
  $perche = if($chiaviIgnote.Count -gt 0){ "chiave di profilo TROVATA ma nomina un profilo inesistente (" + ($chiaviIgnote -join "; ") + ")" }
            else { "nessuna chiave di profilo nei config" }
  $ris.Fonte = "[ASSUNTO] " + $perche + ": preso il profilo col .chr piu' recente (" + $piu.Ultimo.ToString("yyyy.MM.dd HH:mm") + ")"
  return $ris
}

function TF($tipo,$size){
  $s = [int]$size
  switch([int]$tipo){
    0 { if($s -eq 0){ return "M?" } ; return ("M" + $s) }
    1 { return ("H" + $s) }
    2 { return ("D" + $s) }
    3 { return ("W" + $s) }
    4 { return ("MN" + $s) }
    default { return ("t" + $tipo + "s" + $s) }
  }
}
function Campo($txt,$chiave){
  $m = [regex]::Match($txt, "(?im)^[ \t]*" + [regex]::Escape($chiave) + "[ \t]*=[ \t]*(.*?)[ \t]*$")
  if($m.Success -and $m.Groups[1].Value.Trim().Length -gt 0){ return $m.Groups[1].Value.Trim() }
  return "-"
}

$root = Join-Path $env:APPDATA "MetaQuotes\Terminal"
Write-Host "=== SEDIE ATTACCATE (v2) -- profilo ATTIVO separato dai RESIDUI ==="
Write-Host ("data lettura: " + (Get-Date -Format "yyyy-MM-dd HH:mm:ss") + "  (ora locale)")
if(-not (Test-Path $root)){ Write-Host "NESSUNA cartella MetaQuotes\Terminal"; exit 1 }
$cart = @(Get-ChildItem $root -Directory -ErrorAction SilentlyContinue | Where-Object { Test-Path (Join-Path $_.FullName "MQL5") })
Write-Host ("cartelle dati: " + $cart.Count)

$totVive = 0; $totResidui = 0
foreach($d in $cart){
  Write-Host ""
  Write-Host ("=== CARTELLA " + $d.Name)
  $orig = Join-Path $d.FullName "origin.txt"
  if(Test-Path -LiteralPath $orig){
    $o = Leggi-Condiviso $orig
    if($o){ Write-Host ("    programma: " + ($o -replace "[^\x20-\x7E]","").Trim()) }
  }
  $chartsRoot = Join-Path $d.FullName "MQL5\Profiles\Charts"
  $profili = @()
  if(Test-Path -LiteralPath $chartsRoot){ $profili = @(Get-ChildItem -LiteralPath $chartsRoot -Directory -ErrorAction SilentlyContinue) }
  $att = Trova-ProfiloAttivo $d.FullName $profili
  Write-Host ("    profili: " + $profili.Count + "   ATTIVO: '" + $att.Nome + "'   " + $att.Fonte)
  if(-not $att.Certo -and $att.Nome){ Write-Host "    ATTENZIONE: il profilo attivo e' un RIPIEGO, non un fatto letto dai config." }

  $vive = @(); $resid = @()
  foreach($p in $profili){
    $attivo = ($att.Nome -and ($p.Name -ieq $att.Nome))
    foreach($x in @(Get-ChildItem -LiteralPath $p.FullName -Filter "chart*.chr" -ErrorAction SilentlyContinue)){
      $txt = Leggi-Condiviso $x.FullName
      if(-not $txt){ continue }
      $ea = Campo $txt "name"
      # D1: 'Main' e' la finestra del grafico, non un EA. E un grafico
      #     senza <expert> non ha nessuna sedia sopra.
      if($ea -eq "-" -or $ea -ieq "Main"){ continue }
      if($txt -notmatch "<expert>"){ continue }
      $r = ("{0,-38} {1,-8} {2,-5} magic {3,-9} rischio {4,-7} [{5}\{6}]" -f `
            $ea, (Campo $txt "symbol"), (TF (Campo $txt "period_type") (Campo $txt "period_size")), `
            (Campo $txt "InpMagic"), (Campo $txt "InpRiskPercent"), $p.Name, $x.Name)
      if($attivo){ $vive += $r } else { $resid += $r }
    }
  }
  Write-Host ("    --- PROFILO ATTIVO: " + $vive.Count + " sedie ---")
  if($vive.Count -eq 0){ Write-Host "        (nessuna)" } else { foreach($r in $vive){ Write-Host ("        " + $r) } }
  if($resid.Count -gt 0){
    Write-Host ("    --- RESIDUI SU DISCO (altri profili, NON contati): " + $resid.Count + " ---")
    foreach($r in $resid){ Write-Host ("        " + $r) }
  }
  $totVive += $vive.Count; $totResidui += $resid.Count
}

Write-Host ""
Write-Host ("TOTALE SEDIE NEL PROFILO ATTIVO : " + $totVive)
Write-Host ("residui su disco (NON nel totale): " + $totResidui)
Write-Host "Questa riga LEGGE E STAMPA: non ha scritto, copiato o modificato niente."
exit 0
