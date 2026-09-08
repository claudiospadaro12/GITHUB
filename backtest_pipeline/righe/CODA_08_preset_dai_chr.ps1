# =====================================================================
#  MARCATORE_CODA_08_PRESET_DAI_CHR_v1
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
  $m = [regex]::Match($txt, "(?im)^\s*" + [regex]::Escape($nome) + "\s*=\s*(.*)$")
  if($m.Success){ return $m.Groups[1].Value.Trim() }
  return "-"
}

$root = Join-Path $env:APPDATA "MetaQuotes\Terminal"
Write-Host "=== I PARAMETRI DI OGNI SEDIA, IN FORMA DI .set ==="
Write-Host ("data lettura: " + (Get-Date -Format "yyyy-MM-dd HH:mm:ss") + "  (ora locale)")
Write-Host "letti dai .chr del PROFILO ATTIVO. I .chr sono una foto al salvataggio del profilo."
if(-not (Test-Path $root)){ Write-Host "NESSUNA cartella MetaQuotes\Terminal"; exit 1 }

$cart = @(Get-ChildItem $root -Directory -ErrorAction SilentlyContinue | Where-Object { Test-Path (Join-Path $_.FullName "MQL5") })
$totSedie = 0

foreach($d in $cart){
  $orig = Join-Path $d.FullName "origin.txt"
  $prog = "(programma sconosciuto)"
  if(Test-Path -LiteralPath $orig){
    $o = Leggi-Condiviso $orig
    if($o){ $prog = ($o -replace "[^\x20-\x7E]","").Trim() }
  }

  $attivo = ""
  $cini = Join-Path $d.FullName "config\common.ini"
  if(Test-Path -LiteralPath $cini){
    $t = Leggi-Condiviso $cini
    $m = [regex]::Match($t, "(?im)^\s*ProfileLast\s*=\s*(.+?)\s*$")
    if($m.Success){ $attivo = $m.Groups[1].Value }
  }
  if(-not $attivo){ continue }

  $dirP = Join-Path $d.FullName ("profiles\charts\" + $attivo)
  if(-not (Test-Path -LiteralPath $dirP)){ continue }
  $chr = @(Get-ChildItem -LiteralPath $dirP -Filter "chart*.chr" -ErrorAction SilentlyContinue | Sort-Object Name)
  if($chr.Count -eq 0){ continue }

  Write-Host ""
  Write-Host "====================================================================="
  Write-Host ("=== " + $prog)
  Write-Host ("=== profilo attivo: '" + $attivo + "'   .chr: " + $chr.Count)
  Write-Host "====================================================================="

  foreach($x in $chr){
    $txt = Leggi-Condiviso $x.FullName
    if(-not $txt){ continue }
    $ea = Campo $txt "name"
    if($ea -eq "-" -or $ea -ieq "Main"){ continue }
    if($txt -notmatch "<expert>"){ continue }
    $totSedie++

    $sym   = Campo $txt "symbol"
    $magic = Campo $txt "InpMagic"
    if($magic -eq "-"){ $magic = Campo $txt "InpMagicNumber" }

    Write-Host ""
    Write-Host ("--- SEDIA: " + $ea + "  su " + $sym + "   magic " + $magic + "   [" + $x.Name + "] ---")
    Write-Host ("; preset ricostruito da " + $x.Name + " il " + (Get-Date -Format "yyyy-MM-dd") + " -- LETTO, non scritto")
    Write-Host ("; EA: " + $ea + " . simbolo del grafico: " + $sym)
    Write-Host ("; .chr modificato il: " + $x.LastWriteTime.ToString("yyyy-MM-dd HH:mm"))

    # tutte le righe Inp* dentro il file, nell'ordine in cui stanno
    $n = 0
    foreach($riga in ($txt -split "`r?`n")){
      $r = $riga.Trim()
      if($r -match "^(Inp[A-Za-z0-9_]+)\s*=\s*(.*)$"){
        $n++
        Write-Host ($matches[1] + "=" + $matches[2].Trim())
      }
    }
    if($n -eq 0){
      Write-Host "; NESSUN parametro Inp* trovato in questo .chr: l'EA usa altri nomi, oppure il profilo non e' mai stato salvato dopo l'attacco."
    } else {
      Write-Host ("; parametri stampati: " + $n)
    }
  }
}

Write-Host ""
Write-Host ("TOTALE SEDIE STAMPATE: " + $totSedie)
Write-Host "COME SI USA: si copiano le righe Inp* di una sedia in un file .set del repo."
Write-Host "Quel .set va poi CONFRONTATO col preset gia' esistente, se c'e': se differiscono,"
Write-Host "vince cio' che GIRA, ma la differenza va dichiarata, non appianata in silenzio."
Write-Host "Questa riga LEGGE E STAMPA: non ha scritto, copiato o modificato niente."
exit 0
