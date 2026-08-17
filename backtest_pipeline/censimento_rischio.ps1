# =====================================================================
#  censimento_rischio.ps1 -- quanto rischia DAVVERO ogni sedia accesa
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
#  I .chr si aggiornano al salvataggio del profilo: se hai cambiato
#  qualcosa da poco, fai prima File -> Profili -> Salva.
#
#  USO (sul VPS):  .\censimento_rischio.ps1
# =====================================================================
$ErrorActionPreference = "Stop"

$root = Join-Path $env:APPDATA "MetaQuotes\Terminal"
$dirs = Get-ChildItem $root -Directory -ErrorAction SilentlyContinue |
        Where-Object { Test-Path (Join-Path $_.FullName "MQL5\Experts") }
if(-not $dirs){ Write-Host "Nessuna cartella dati MT5 trovata." -ForegroundColor Red; exit 1 }

$Righe = New-Object System.Collections.ArrayList
function Rec($s,$col){ [void]$Righe.Add($s); if($col){Write-Host $s -ForegroundColor $col}else{Write-Host $s} }

Rec "=== CENSIMENTO DEL RISCHIO DICHIARATO (dai .chr) ===" White
Rec ("data: " + (Get-Date -Format "yyyy.MM.dd HH:mm")) Gray
Rec ""

$tutte = @()
foreach($d in $dirs){
  $chrs = Get-ChildItem $d.FullName -Recurse -Filter "*.chr" -ErrorAction SilentlyContinue
  foreach($chr in $chrs){
    $txt = Get-Content $chr.FullName -Raw
    $em = [regex]::Match($txt, "(?s)<expert>.*?path=Experts\\([^\r\n]+)\.ex5")
    if(-not $em.Success){ continue }
    $ea = ($em.Groups[1].Value.Trim() -split '\\')[-1]
    $sm = [regex]::Match($txt, "symbol=([A-Za-z0-9#\.]+)")
    $sym = if($sm.Success){ $sm.Groups[1].Value -replace '[\.#].*$','' } else { "?" }
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
    $tutte += [pscustomobject]@{
      EA=$ea; Sym=$sym; Magic=$ins["InpMagic"]; Risk=$risk; NomeRisk=$nomeRisk
      Lotto=$lotto; Comm=$ins["InpComment"]; File=$chr.Name; Ora=$chr.LastWriteTime
    }
  }
}

if($tutte.Count -eq 0){ Rec "Nessun grafico con EA salvato. Hai fatto File -> Profili -> Salva?" Red; exit 1 }

Rec ("sedie trovate: " + $tutte.Count) Gray
Rec ""
Rec ("{0,-36} {1,-8} {2,-8} {3,6}  {4}" -f "EA","simbolo","magic","rischio","commento") White
Rec ("-" * 92) Gray

$sospette = 0
foreach($t in ($tutte | Sort-Object @{e={ if($_.Risk){[double]$_.Risk}else{-1} }; Descending=$true}, EA)){
  $r = if($t.Risk){ $t.Risk } else { "n/d" }
  $riga = ("{0,-36} {1,-8} {2,-8} {3,6}  {4}" -f $t.EA, $t.Sym, $t.Magic, $r, $t.Comm)
  if($t.Risk -and [double]$t.Risk -gt 1.0){ Rec $riga Red; $sospette++ }
  elseif(-not $t.Risk){ Rec ($riga + "   <- nessun input di rischio trovato" + $(if($t.Lotto){" ("+$t.Lotto+")"}else{""})) Yellow }
  else{ Rec $riga Gray }
}

Rec ""
Rec ("=== TOTALE RISCHIO DICHIARATO ===") White
$somma = ($tutte | Where-Object { $_.Risk } | ForEach-Object { [double]$_.Risk } | Measure-Object -Sum).Sum
Rec ("  somma dei rischi di tutte le sedie: {0:N2}% del conto" -f $somma) $(if($somma -gt 10){"Red"}else{"Green"})
Rec "  (non e' il rischio simultaneo: e' quanto si rischierebbe se aprissero tutte insieme)"
Rec ""
if($sospette -gt 0){
  Rec ("{0} sedie hanno rischio DICHIARATO sopra l'1%: sono in rosso qui sopra." -f $sospette) Red
} else {
  Rec "Nessuna sedia dichiara piu' dell'1%." Green
  Rec "Allora le perdite da -2% del conto NON vengono dal rischio impostato:" Yellow
  Rec "vengono dallo STOP SALTATO (gap/slippage in apertura). Si guarda li'." Yellow
}

$dest = Join-Path ([Environment]::GetFolderPath("Desktop")) "censimento_rischio.txt"
$Righe | Set-Content -Path $dest -Encoding UTF8
Write-Host ""
Write-Host "Referto scritto in: $dest" -ForegroundColor Cyan
