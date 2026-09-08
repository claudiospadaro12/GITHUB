# =====================================================================
#  VERIFICA_SW_DAX_770512  --  RUNNER_SOLA_LETTURA
# ---------------------------------------------------------------------
#  COSA FA: dopo l'accensione manuale, STAMPA se la sedia
#  ABTG_SuperWave_DAX_H4_Ottimizzato (magic 770512) e' attaccata,
#  SU QUALE TERMINALE, su che simbolo/TF e CON CHE RISCHIO.
#  Non scrive, non copia, non cancella, non tocca nessun EA: STAMPA.
#
#  PERCHE' ESISTE: la scheda report/CORSIA_DEMO_SUPERWAVE_DAX_2026-09-08.md
#  chiede una prova STAMPATA che la sedia sia finita sul conto giusto
#  (piccolo 50503392) e non su uno degli altri due terminali. La regola
#  dei terminali multipli del 06/09 vieta di riconoscere la finestra
#  "a occhio": questa riga trasforma il riconoscimento in un fatto letto.
#
#  E' UNA COSTOLA DI backtest_pipeline/righe/CODA_01_sedie_attaccate.ps1
#  (v2): stessa lettura condivisa dei .chr, stessa separazione fra
#  PROFILO ATTIVO e RESIDUI SU DISCO, stessa funzione TF. Cambia solo il
#  filtro (un magic solo) e l'aggiunta del blocco PROCESSI.
#
#  ATTENZIONE, IL LIMITE, DICHIARATO (identico alla CODA_01): i .chr si
#  aggiornano SOLO quando MT5 salva il profilo. Un grafico appena aperto
#  e MAI SALVATO NON COMPARE. Prima di lanciare questa riga:
#      in MT5 -> File -> Profili -> Salva
#  Se non compare niente, la prima ipotesi e' "profilo non salvato",
#  non "EA non attaccato".
#
#  NIENTE EMOJI: ASCII puro (regola CLAUDE.md del 17/08, i .ps1 sono
#  letti da Windows PowerShell 5.1 come ANSI).
# =====================================================================

$MAGIC_CERCATO = "770512"
$EA_CERCATO    = "ABTG_SuperWave_DAX_H4_Ottimizzato"

# --- lettura CONDIVISA: un .chr tenuto aperto da MT5 non deve far morire
#     la lettura (stessa funzione della CODA_01 v2).
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

Write-Host "=== VERIFICA SEDIA SuperWave DAX H4 -- magic $MAGIC_CERCATO (SOLA LETTURA) ==="
Write-Host ("data lettura: " + (Get-Date -Format "yyyy-MM-dd HH:mm:ss") + "  (ora LOCALE del PC = ora italiana; il server BCM e' 1 ora indietro)")
Write-Host ""

# --- BLOCCO 1: QUALI TERMINALI STANNO GIRANDO (regola terminali multipli 06/09)
Write-Host "--- TERMINALI IN ESECUZIONE (PID + titolo + cartella programma) ---"
$proc = @(Get-Process terminal64 -ErrorAction SilentlyContinue)
if($proc.Count -eq 0){
  Write-Host "    nessun terminal64 in esecuzione"
} else {
  foreach($p in $proc){
    $t = ""; $pa = ""
    try{ $t = $p.MainWindowTitle } catch {}
    try{ $pa = $p.Path } catch {}
    Write-Host ("    PID " + $p.Id + "  |  " + $t + "  |  " + $pa)
  }
}
Write-Host "    ATTESO: la sedia 770512 deve stare nel terminale del PICCOLO 50503392,"
Write-Host "            cartella 'C:\Program Files\BCM Markets MT5 Terminal' (SENZA -V3)."
Write-Host "            NON sul 100k 50504263 ('... -V3'), NON sul reale 10105439 ('C:\BCM_Reale')."
Write-Host ""

# --- BLOCCO 2: DOVE E' ATTACCATA
$root = Join-Path $env:APPDATA "MetaQuotes\Terminal"
if(-not (Test-Path $root)){ Write-Host "NESSUNA cartella MetaQuotes\Terminal"; exit 1 }
$cart = @(Get-ChildItem $root -Directory -ErrorAction SilentlyContinue | Where-Object { Test-Path (Join-Path $_.FullName "MQL5") })
Write-Host ("--- CARTELLE DATI ESAMINATE: " + $cart.Count + " ---")

$trovateVive = 0; $trovateResidue = 0; $altreSedieStessoEA = 0
foreach($d in $cart){
  $orig = Join-Path $d.FullName "origin.txt"
  $programma = "(origin.txt assente)"
  if(Test-Path -LiteralPath $orig){
    $o = Leggi-Condiviso $orig
    if($o){ $programma = ($o -replace "[^\x20-\x7E]","").Trim() }
  }
  $chartsRoot = Join-Path $d.FullName "MQL5\Profiles\Charts"
  $profili = @()
  if(Test-Path -LiteralPath $chartsRoot){ $profili = @(Get-ChildItem -LiteralPath $chartsRoot -Directory -ErrorAction SilentlyContinue) }
  if($profili.Count -eq 0){ continue }
  $att = Trova-ProfiloAttivo $d.FullName $profili

  $righe = @()
  foreach($p in $profili){
    $attivo = ($att.Nome -and ($p.Name -ieq $att.Nome))
    foreach($x in @(Get-ChildItem -LiteralPath $p.FullName -Filter "chart*.chr" -ErrorAction SilentlyContinue)){
      $txt = Leggi-Condiviso $x.FullName
      if(-not $txt){ continue }
      $ea = Campo $txt "name"
      if($ea -eq "-" -or $ea -ieq "Main"){ continue }
      if($txt -notmatch "<expert>"){ continue }
      $magic = Campo $txt "InpMagic"
      $eaMatch    = ($ea -ieq $EA_CERCATO)
      $magicMatch = ($magic -eq $MAGIC_CERCATO)
      if(-not ($eaMatch -or $magicMatch)){ continue }
      $stato = if($attivo){ "PROFILO ATTIVO" } else { "RESIDUO SU DISCO (profilo NON caricato)" }
      $flag  = ""
      if($eaMatch -and -not $magicMatch){ $flag = "  <<< ATTENZIONE: EA giusto ma MAGIC DIVERSO da " + $MAGIC_CERCATO }
      if($magicMatch -and -not $eaMatch){ $flag = "  <<< ATTENZIONE: magic giusto ma EA DIVERSO" }
      $righe += ("    [" + $stato + "] " + $ea + "  " + (Campo $txt "symbol") + "  " +
                 (TF (Campo $txt "period_type") (Campo $txt "period_size")) +
                 "  magic " + $magic +
                 "  InpRiskPercent " + (Campo $txt "InpRiskPercent") +
                 "  InpStMult " + (Campo $txt "InpStMult") +
                 "  InpTP_RR " + (Campo $txt "InpTP_RR") +
                 "  InpAllowLong " + (Campo $txt "InpAllowLong") +
                 "  InpAllowShort " + (Campo $txt "InpAllowShort") +
                 "  [" + $p.Name + "\" + $x.Name + "]" + $flag)
      if($attivo){ if($magicMatch){ $trovateVive++ } else { $altreSedieStessoEA++ } }
      else { $trovateResidue++ }
    }
  }
  if($righe.Count -eq 0){ continue }
  Write-Host ""
  Write-Host ("=== CARTELLA DATI " + $d.Name)
  Write-Host ("    programma: " + $programma)
  Write-Host ("    profilo ATTIVO: '" + $att.Nome + "'   " + $att.Fonte)
  if(-not $att.Certo -and $att.Nome){ Write-Host "    ATTENZIONE: il profilo attivo e' un RIPIEGO, non un fatto letto dai config." }
  foreach($r in $righe){ Write-Host $r }
}

Write-Host ""
Write-Host "=== ESITO ==="
Write-Host ("sedie con magic " + $MAGIC_CERCATO + " nel PROFILO ATTIVO : " + $trovateVive)
Write-Host ("residui su disco con lo stesso EA/magic (NON contati) : " + $trovateResidue)
Write-Host ("istanze dello stesso EA con un ALTRO magic            : " + $altreSedieStessoEA)
Write-Host ""
Write-Host "COME SI LEGGE:"
Write-Host ("  0 nel profilo attivo -> la sedia NON e' attaccata, oppure il profilo non e' stato salvato.")
Write-Host ("  1 nel profilo attivo -> giusto. Controllare a occhio le tre cose:")
Write-Host ("      simbolo D30EUR, TF H4, InpRiskPercent = la taglia firmata da Claudio.")
Write-Host ("  2 o piu' -> ci sono DUE istanze sullo stesso magic: e' un errore, si spegne una.")
Write-Host ""
Write-Host "IL RISCHIO STAMPATO QUI E' QUELLO CHE C'E' NEL PRESET, NON QUELLO VERO PER TRADE."
Write-Host "Il rischio VERO si legge nella scheda Esperti, nella riga"
Write-Host "  [SuperWave] LONG mercato X.XX lot @ ... SL ... TP ..."
Write-Host "Se X.XX vale 0.10 (lotto MINIMO di D30EUR, misurato in R114), il lotto e'"
Write-Host "stato PORTATO SU al minimo e il rischio per trade NON e' quello dichiarato."
Write-Host "Vedi la pre-condizione bloccante in report/CORSIA_DEMO_SUPERWAVE_DAX_2026-09-08.md"
Write-Host ""
Write-Host "Questa riga LEGGE E STAMPA: non ha scritto, copiato o modificato niente."
exit 0
