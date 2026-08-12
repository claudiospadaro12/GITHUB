# =====================================================================
#  verifica_nasdaq_volumi.ps1 -- controlla dai .chr salvati che il
#  Nasdaq base (NASUSD M5, magic 770201) abbia il filtro volumi ON,
#  conferma AND, rischio 0.25, VolMult 1.5. Vecchio MT5 (50503392).
#  I .chr si aggiornano SOLO al Salva Profilo: farlo prima di lanciare.
#  Scrive anche Desktop\verifica_nasdaq.txt.
# =====================================================================
$ErrorActionPreference = "Stop"

$root = Join-Path $env:APPDATA "MetaQuotes\Terminal"
$folders = Get-ChildItem $root -Directory -ErrorAction SilentlyContinue | Where-Object {
  Test-Path (Join-Path $_.FullName "origin.txt") }
$old = $folders | Where-Object {
  $o = (Get-Content (Join-Path $_.FullName "origin.txt") -Raw).Trim()
  $o -like "*BCM*MT5*" -and $o -notlike "*-V3*" -and $o -notlike "*MT4*" } |
  Sort-Object LastWriteTime -Descending | Select-Object -First 1
if (-not $old) { Write-Host "Vecchio MT5 non trovato." -ForegroundColor Red; exit 1 }

$Righe = New-Object System.Collections.ArrayList
function Rec($s,$col){ [void]$Righe.Add($s); Write-Host $s -ForegroundColor $col }

Rec "=== VERIFICA NASDAQ VOLUMI v1 (dai .chr salvati) ===" White
Rec ("terminal letto: {0}" -f $old.Name) Gray

# tutti i .chr, dal piu' vecchio al piu' recente: l'ultimo salvataggio vince
$chrs = Get-ChildItem $old.FullName -Recurse -Filter "*.chr" -ErrorAction SilentlyContinue |
  Sort-Object LastWriteTime
$best = $null
foreach ($chr in $chrs) {
  $txt = Get-Content $chr.FullName -Raw
  $em = [regex]::Match($txt, "(?s)<expert>.*?path=Experts\\([^\r\n]+)\.ex5")
  if (-not $em.Success) { continue }
  $ea = ($em.Groups[1].Value.Trim() -split '\\')[-1]
  if ($ea -ne "ABTG_Nasdaq_Apertura_US") { continue }
  $sm = [regex]::Match($txt, "symbol=([A-Za-z0-9#\.]+)")
  $sym = if($sm.Success){$sm.Groups[1].Value -replace '[\.#].*$',''}else{"?"}
  if ($sym -ne "NASUSD") { continue }
  $ins = @{}
  $im = [regex]::Match($txt, "(?s)<expert>.*?<inputs>(.*?)</inputs>")
  if ($im.Success) {
    foreach ($l in ($im.Groups[1].Value -split "\r?\n")) {
      if ($l -match "^\s*([A-Za-z0-9_]+)=(.*)$") { $ins[$Matches[1]]=$Matches[2].Trim() }
    }
  }
  if ($ins["InpMagic"] -ne "770201") {
    Rec ("nota: grafico Nasdaq con magic {0} ignorato ({1})" -f $ins["InpMagic"],$chr.Name) Cyan
    continue
  }
  $best = @{ins=$ins; file=$chr.Name; quando=$chr.LastWriteTime}
}

if (-not $best) {
  Rec "MANCA: nessun grafico NASUSD con ABTG_Nasdaq_Apertura_US magic 770201 nei .chr. Hai fatto Salva Profilo?" Red
} else {
  $ins = $best.ins; $errori = 0
  Rec ("grafico trovato: {0} (salvato {1})" -f $best.file,$best.quando) Gray
  function AccesoSpento($v){ if ($v -eq "true" -or $v -eq "1") {"ON"} elseif ($v -eq "false" -or $v -eq "0") {"OFF"} else {"?($v)"} }
  # 1) filtro volumi ON
  $v = $ins["InpUseVolumeFilter"]
  if ($v -eq "true" -or $v -eq "1") { Rec "OK      filtro volumi: ON" Green }
  else { Rec ("ERRORE  filtro volumi: {0} (atteso ON)" -f (AccesoSpento $v)) Red; $errori++ }
  # 2) conferma AND
  if ($ins["InpConfirmMode"] -eq "1") { Rec "OK      conferma: AND (1)" Green }
  else { Rec ("ERRORE  conferma: {0} (atteso 1 = AND)" -f $ins["InpConfirmMode"]) Red; $errori++ }
  # 3) moltiplicatore volumi 1.5
  if ([double]$ins["InpVolMult"] -eq 1.5) { Rec "OK      volume rottura >= 1.5 x media" Green }
  else { Rec ("ERRORE  InpVolMult={0} (atteso 1.5)" -f $ins["InpVolMult"]) Red; $errori++ }
  # 4) rischio 0.25
  if ([double]$ins["InpRiskPercent"] -eq 0.25) { Rec "OK      rischio per trade: 0.25" Green }
  else { Rec ("ERRORE  rischio={0} (atteso 0.25)" -f $ins["InpRiskPercent"]) Red; $errori++ }
  # 5) filtro ATR resta spento
  $v = $ins["InpUseAtrFilter"]
  if ($v -eq "false" -or $v -eq "0") { Rec "OK      filtro ATR: OFF (come da misura)" Green }
  else { Rec ("ERRORE  filtro ATR: {0} (atteso OFF)" -f (AccesoSpento $v)) Red; $errori++ }
  Rec "" White
  if ($errori -eq 0) { Rec "TUTTO OK: Nasdaq allineato alla config misurata. Volumi in campo." Green }
  else { Rec ("{0} PROBLEMI: correggi e rilancia." -f $errori) Red }
}

$out = Join-Path $env:USERPROFILE "Desktop\verifica_nasdaq.txt"
$Righe -join "`r`n" | Set-Content -Path $out -Encoding ASCII
Write-Host ("Report scritto in: " + $out) -ForegroundColor Gray
