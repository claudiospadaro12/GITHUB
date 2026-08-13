# =====================================================================
#  verifica_vivaio_r23.ps1 -- controlla campo-per-campo i 12 grafici del
#  VIVAIO (R23 + EMA200 + BB + GAP) leggendo i .chr del VECCHIO MT5 (50503392).
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
  $o -like "*BCM*MT5*" -and $o -notlike "*-V3*" -and $o -notlike "*MT4*" } |
  Sort-Object LastWriteTime -Descending | Select-Object -First 1
if (-not $old) { Write-Host "Vecchio MT5 non trovato." -ForegroundColor Red; exit 1 }

# atteso: EA -> simbolo -> @{input=valore} (numerici confrontati come numeri)
$Attesi = @(
  @{ea="ABTG_PTE";       sym="U30USD"; tf="H1"; magic=771321; be="0.5"; comm="PTE DOW"},
  @{ea="ABTG_PTE";       sym="GBPUSD"; tf="H1"; magic=771322; be="0.5"; comm="PTE GBPUSD"},
  @{ea="ABTG_PTE";       sym="USDJPY"; tf="H1"; magic=771323; be="0.5"; comm="PTE USDJPY"},
  @{ea="ABTG_SuperWave"; sym="U30USD"; tf="H2"; magic=770531; be=$null; comm="SW DOW H2"},
  @{ea="ABTG_SuperWave"; sym="GBPUSD"; tf="H2"; magic=770532; be=$null; comm="SW GBPUSD H2"},
  # sedia 12 (12/08): EMA200 Dow, cella centro R29 (O1/O2/TP verificati sotto)
  @{ea="ABTG_EMA200";    sym="U30USD"; tf="H1"; magic=771531; be=$null; comm="EMA200 DOW"},
  # sedie 13-15 (13/08): Breaking Band R33/R34 (pattern e taratura sotto)
  @{ea="ABTG_BreakingBand"; sym="GBPUSD"; tf="H1"; magic=772161; be=$null; comm="BB GBPUSD"; pat="2"},
  @{ea="ABTG_BreakingBand"; sym="EURUSD"; tf="H1"; magic=772162; be=$null; comm="BB EURUSD"; pat="0"},
  @{ea="ABTG_BreakingBand"; sym="AUDUSD"; tf="H1"; magic=772163; be=$null; comm="BB AUDUSD"; pat="1"},
  # sedie 16-18 (13/08): Gap-fill R36/R37 (fill e taratura sotto)
  @{ea="ABTG_GapFill"; sym="GBPUSD"; tf="H1"; magic=772231; be=$null; comm="GAP GBPUSD"; fill="100"},
  @{ea="ABTG_GapFill"; sym="EURUSD"; tf="H1"; magic=772232; be=$null; comm="GAP EURUSD"; fill="50"},
  @{ea="ABTG_GapFill"; sym="AUDUSD"; tf="H1"; magic=772233; be=$null; comm="GAP AUDUSD"; fill="100"},
  # sedie 19-20 (13/08): Gap indici in OSSERVAZIONE (R37: fuori dal portafoglio)
  @{ea="ABTG_GapFill"; sym="U30USD"; tf="H1"; magic=772234; be=$null; comm="GAP DOW"; fill="100"},
  @{ea="ABTG_GapFill"; sym="225JPY"; tf="H1"; magic=772235; be=$null; comm="GAP NIKKEI"; fill="75"},
  # sedie 21-26 (13/08): Punte di Larry R38/R39 (pattern/exit/lati sotto)
  @{ea="ABTG_PunteLarry"; sym="U30USD"; tf="H1"; magic=772341; be=$null; comm="LARRY DOW";    pat="1"; ex="1"; al="1"; ash="1"},
  @{ea="ABTG_PunteLarry"; sym="EURAUD"; tf="H1"; magic=772342; be=$null; comm="LARRY EURAUD"; pat="1"; ex="1"; al="1"; ash="1"},
  @{ea="ABTG_PunteLarry"; sym="XAUUSD"; tf="H1"; magic=772343; be=$null; comm="LARRY ORO";    pat="0"; ex="1"; al="1"; ash="0"},
  @{ea="ABTG_PunteLarry"; sym="GBPJPY"; tf="H1"; magic=772344; be=$null; comm="LARRY GBPJPY"; pat="1"; ex="1"; al="1"; ash="0"},
  @{ea="ABTG_PunteLarry"; sym="GBPUSD"; tf="H1"; magic=772345; be=$null; comm="LARRY GBPUSD"; pat="0"; ex="0"; al="0"; ash="1"},
  @{ea="ABTG_PunteLarry"; sym="EURCAD"; tf="H1"; magic=772346; be=$null; comm="LARRY EURCAD"; pat="1"; ex="0"; al="1"; ash="0"}
)
$TFnum = @{ "H1"="16385"; "H2"="16386" }

$Righe = New-Object System.Collections.ArrayList
function Rec($s,$col){ [void]$Righe.Add($s); Write-Host $s -ForegroundColor $col }

# ordinati dal piu' vecchio al piu' recente: a parita' di chiave vince l'ultimo salvataggio
$chrs = Get-ChildItem $old.FullName -Recurse -Filter "*.chr" -ErrorAction SilentlyContinue |
  Sort-Object LastWriteTime
$trovati = @{}
foreach ($chr in $chrs) {
  $txt = Get-Content $chr.FullName -Raw
  $em = [regex]::Match($txt, "(?s)<expert>.*?path=Experts\\([^\r\n]+)\.ex5")
  if (-not $em.Success) { continue }
  # solo il nome file: l'ex5 puo' stare in una sottocartella del Navigatore
  $ea = ($em.Groups[1].Value.Trim() -split '\\')[-1]
  if ($ea -ne "ABTG_PTE" -and $ea -ne "ABTG_SuperWave" -and $ea -ne "ABTG_EMA200" -and $ea -ne "ABTG_BreakingBand" -and $ea -ne "ABTG_GapFill" -and $ea -ne "ABTG_PunteLarry") { continue }
  $sm = [regex]::Match($txt, "symbol=([A-Za-z0-9#\.]+)"); $sym = if($sm.Success){$sm.Groups[1].Value}else{"?"}
  $sym = $sym -replace '[\.#].*$',''   # via eventuali suffissi broker (U30USD.i, U30USD#)
  $ins = @{}
  # ancorato a <expert>: sul grafico possono esserci indicatori custom col proprio blocco <inputs>
  $im = [regex]::Match($txt, "(?s)<expert>.*?<inputs>(.*?)</inputs>")
  if ($im.Success) {
    foreach ($l in ($im.Groups[1].Value -split "\r?\n")) {
      if ($l -match "^\s*([A-Za-z0-9_]+)=(.*)$") { $ins[$Matches[1]]=$Matches[2].Trim() }
    }
  }
  $magic = $ins["InpMagic"]
  $trovati["$ea|$sym|$magic"] = @{ea=$ea; sym=$sym; ins=$ins; file=$chr.Name}
}

Rec "=== VERIFICA VIVAIO v8 (20 grafici: R23 + EMA200 + BB + GAP + LARRY) ===" White
Rec ("terminal letto: {0}" -f $old.Name) Gray
$errori = 0
foreach ($a in $Attesi) {
  $key = "$($a.ea)|$($a.sym)|$($a.magic)"
  $t = $trovati[$key]
  if (-not $t) {
    # cerca lo stesso EA+simbolo con magic diverso (errore tipico)
    $alt = @($trovati.Values | Where-Object { $_.ea -eq $a.ea -and $_.sym -eq $a.sym })
    if ($alt.Count -gt 0) {
      $magics = ($alt | ForEach-Object { $_.ins["InpMagic"] }) -join ", "
      Rec ("ERRORE  {0} @ {1}: trovato ma MAGIC={2} (atteso {3})" -f $a.ea,$a.sym,$magics,$a.magic) Red }
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
  if ($a.ea -eq "ABTG_BreakingBand") {
    if ($ins["InpPatternMode"] -ne $a.pat)               { $ok=$false; $note += ("InpPatternMode={0} atteso {1}" -f $ins["InpPatternMode"],$a.pat) }
    if ([double]$ins["InpBulgeWidthMult"] -ne 1.35)      { $ok=$false; $note += ("InpBulgeWidthMult={0} atteso 1.35" -f $ins["InpBulgeWidthMult"]) }
    if ([double]$ins["InpBulgeNetMoveATR"] -ne 1.0)      { $ok=$false; $note += ("InpBulgeNetMoveATR={0} atteso 1.0" -f $ins["InpBulgeNetMoveATR"]) }
    if ($ins["InpTPMode"] -ne "0")                       { $ok=$false; $note += ("InpTPMode={0} atteso 0 (Leonardo)" -f $ins["InpTPMode"]) }
  }
  if ($a.ea -eq "ABTG_PunteLarry") {
    if ($ins["InpPatternMode"] -ne $a.pat)        { $ok=$false; $note += ("InpPatternMode={0} atteso {1}" -f $ins["InpPatternMode"],$a.pat) }
    if ($ins["InpExitMode"] -ne $a.ex)            { $ok=$false; $note += ("InpExitMode={0} atteso {1}" -f $ins["InpExitMode"],$a.ex) }
    if ($ins["InpAllowLong"] -ne $a.al)           { $ok=$false; $note += ("InpAllowLong={0} atteso {1}" -f $ins["InpAllowLong"],$a.al) }
    if ($ins["InpAllowShort"] -ne $a.ash)         { $ok=$false; $note += ("InpAllowShort={0} atteso {1}" -f $ins["InpAllowShort"],$a.ash) }
    if ([double]$ins["InpMaxSpreadPts"] -ne 300)  { $ok=$false; $note += ("InpMaxSpreadPts={0} atteso 300" -f $ins["InpMaxSpreadPts"]) }
    if ([double]$ins["InpMaxDaysHold"] -ne 5)     { $ok=$false; $note += ("InpMaxDaysHold={0} atteso 5" -f $ins["InpMaxDaysHold"]) }
  }
  if ($a.ea -eq "ABTG_GapFill") {
    if ([double]$ins["InpFillPct"] -ne [double]$a.fill)  { $ok=$false; $note += ("InpFillPct={0} atteso {1}" -f $ins["InpFillPct"],$a.fill) }
    if ([double]$ins["InpGapMinATR"] -ne 0.3)            { $ok=$false; $note += ("InpGapMinATR={0} atteso 0.3" -f $ins["InpGapMinATR"]) }
    if ([double]$ins["InpGapMaxATR"] -ne 2.0)            { $ok=$false; $note += ("InpGapMaxATR={0} atteso 2.0" -f $ins["InpGapMaxATR"]) }
    if ([double]$ins["InpMaxHours"] -ne 48)              { $ok=$false; $note += ("InpMaxHours={0} atteso 48" -f $ins["InpMaxHours"]) }
    if ([double]$ins["InpMaxSpreadPts"] -ne 300)         { $ok=$false; $note += ("InpMaxSpreadPts={0} atteso 300 (ACCESO: trappola riapertura)" -f $ins["InpMaxSpreadPts"]) }
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
