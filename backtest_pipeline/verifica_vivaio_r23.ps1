# =====================================================================
#  verifica_vivaio_r23.ps1 -- controlla campo-per-campo i 6 grafici del
#  VIVAIO (R23 + EMA200) leggendo i .chr del VECCHIO MT5 (demo 50503392).
#  ⚠️ I .chr si aggiornano al SALVATAGGIO del profilo: prima di lanciare
#  fai File -> Profili -> Salva (sovrascrivi), poi esegui.
#  Scrive anche Desktop\verifica_vivaio.txt da mandare a Claude.
# =====================================================================
$ErrorActionPreference = "Stop"

$root = Join-Path $env:APPDATA "MetaQuotes\Terminal"
$folders = Get-ChildItem $root -Directory -ErrorAction SilentlyContinue | Where-Object {
  Test-Path (Join-Path $_.FullName "origin.txt") }
$old = $folders | Where-Object {
  $o = (Get-Content (Join-Path $_.FullName "origin.txt") -Raw).Trim()
  $o -like "*BCM*MT5*" -and $o -notlike "*-V3*" -and $o -notlike "*MT4*" } | Select-Object -First 1
if (-not $old) { Write-Host "Vecchio MT5 non trovato." -ForegroundColor Red; exit 1 }

# atteso: EA -> simbolo -> @{input=valore} (numerici confrontati come numeri)
$Attesi = @(
  @{ea="ABTG_PTE";       sym="U30USD"; tf="H1"; magic=771321; be="0.5"; comm="PTE DOW"},
  @{ea="ABTG_PTE";       sym="GBPUSD"; tf="H1"; magic=771322; be="0.5"; comm="PTE GBPUSD"},
  @{ea="ABTG_PTE";       sym="USDJPY"; tf="H1"; magic=771323; be="0.5"; comm="PTE USDJPY"},
  @{ea="ABTG_SuperWave"; sym="U30USD"; tf="H2"; magic=770531; be=$null; comm="SW DOW H2"},
  @{ea="ABTG_SuperWave"; sym="GBPUSD"; tf="H2"; magic=770532; be=$null; comm="SW GBPUSD H2"},
  # sedia 12 (12/08): EMA200 Dow, cella centro R29 (O1/O2/TP verificati sotto)
  @{ea="ABTG_EMA200";    sym="U30USD"; tf="H1"; magic=771531; be=$null; comm="EMA200 DOW"}
)
$TFnum = @{ "H1"="16385"; "H2"="16386" }

$Righe = New-Object System.Collections.ArrayList
function Rec($s,$col){ [void]$Righe.Add($s); Write-Host $s -ForegroundColor $col }

$chrs = Get-ChildItem $old.FullName -Recurse -Filter "*.chr" -ErrorAction SilentlyContinue
$trovati = @{}
foreach ($chr in $chrs) {
  $txt = Get-Content $chr.FullName -Raw
  $em = [regex]::Match($txt, "(?s)<expert>.*?path=Experts\\([^\r\n]+)\.ex5")
  if (-not $em.Success) { continue }
  $ea = $em.Groups[1].Value.Trim()
  if ($ea -ne "ABTG_PTE" -and $ea -ne "ABTG_SuperWave" -and $ea -ne "ABTG_EMA200") { continue }
  $sm = [regex]::Match($txt, "symbol=([A-Za-z0-9#\.]+)"); $sym = if($sm.Success){$sm.Groups[1].Value}else{"?"}
  $ins = @{}
  $im = [regex]::Match($txt, "(?s)<inputs>(.*?)</inputs>")
  if ($im.Success) {
    foreach ($l in ($im.Groups[1].Value -split "\r?\n")) {
      if ($l -match "^\s*([A-Za-z0-9_]+)=(.*)$") { $ins[$Matches[1]]=$Matches[2].Trim() }
    }
  }
  $magic = $ins["InpMagic"]
  $trovati["$ea|$sym|$magic"] = @{ea=$ea; sym=$sym; ins=$ins; file=$chr.Name}
}

Rec "=== VERIFICA VIVAIO R23 (dai .chr salvati) ===" White
$errori = 0
foreach ($a in $Attesi) {
  $key = "$($a.ea)|$($a.sym)|$($a.magic)"
  $t = $trovati[$key]
  if (-not $t) {
    # cerca lo stesso EA+simbolo con magic diverso (errore tipico)
    $alt = $trovati.Values | Where-Object { $_.ea -eq $a.ea -and $_.sym -eq $a.sym } | Select-Object -First 1
    if ($alt) { Rec ("ERRORE  {0} @ {1}: trovato ma MAGIC={2} (atteso {3})" -f $a.ea,$a.sym,$alt.ins["InpMagic"],$a.magic) Red }
    else { Rec ("MANCA   {0} @ {1} (magic {2}): nessun grafico salvato. Hai fatto Salva profilo?" -f $a.ea,$a.sym,$a.magic) Red }
    $errori++; continue
  }
  $ins = $t.ins; $ok = $true; $note = @()
  if ($ins["InpTF"] -ne $TFnum[$a.tf]) { $ok=$false; $note += ("InpTF={0} atteso {1} ({2})" -f $ins["InpTF"],$TFnum[$a.tf],$a.tf) }
  if ($a.be -ne $null -and [double]$ins["InpTP1_ATRmult"] -ne [double]$a.be) { $ok=$false; $note += ("InpTP1_ATRmult={0} atteso {1}" -f $ins["InpTP1_ATRmult"],$a.be) }
  if ($a.ea -eq "ABTG_EMA200") {
    if ([double]$ins["InpOrder1Atr"] -ne 0.20) { $ok=$false; $note += ("InpOrder1Atr={0} atteso 0.20" -f $ins["InpOrder1Atr"]) }
    if ([double]$ins["InpOrder2Atr"] -ne 0.3)  { $ok=$false; $note += ("InpOrder2Atr={0} atteso 0.3" -f $ins["InpOrder2Atr"]) }
    if ([double]$ins["InpTP_RR"] -ne 2.0)      { $ok=$false; $note += ("InpTP_RR={0} atteso 2.0" -f $ins["InpTP_RR"]) }
  }
  if ([double]$ins["InpRiskPercent"] -ne 1.0) { $ok=$false; $note += ("InpRiskPercent={0} atteso 1.0" -f $ins["InpRiskPercent"]) }
  if ($ins["InpComment"] -ne $a.comm) { $ok=$false; $note += ("InpComment='{0}' atteso '{1}'" -f $ins["InpComment"],$a.comm) }
  if ($ok) { Rec ("OK      {0} @ {1}  magic {2}  TF {3}  rischio {4}  '{5}'" -f $a.ea,$a.sym,$a.magic,$a.tf,$ins["InpRiskPercent"],$ins["InpComment"]) Green }
  else { Rec ("ERRORE  {0} @ {1}: {2}" -f $a.ea,$a.sym,($note -join "; ")) Red; $errori++ }
}
# grafici PTE/SuperWave inattesi (doppioni, magic sbagliati)
foreach ($k in $trovati.Keys) {
  $parts = $k -split '\|'
  $atteso = $Attesi | Where-Object { $_.ea -eq $parts[0] -and $_.sym -eq $parts[1] -and "$($_.magic)" -eq $parts[2] }
  if (-not $atteso) { Rec ("FUORI LISTA: {0} @ {1} magic {2} ({3})" -f $parts[0],$parts[1],$parts[2],$trovati[$k].file) Cyan }
}
Rec "" White
if ($errori -eq 0) { Rec ("TUTTO OK: {0}/{0}. Vivaio in campo." -f $Attesi.Count) Green } else { Rec ("{0} PROBLEMI: correggi e rilancia." -f $errori) Red }

$out = Join-Path $env:USERPROFILE "Desktop\verifica_vivaio.txt"
$Righe -join "`r`n" | Set-Content -Path $out -Encoding ASCII
Write-Host ("Report scritto in: " + $out) -ForegroundColor Gray
