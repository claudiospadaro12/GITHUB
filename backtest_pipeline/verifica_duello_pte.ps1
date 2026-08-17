# =====================================================================
#  verifica_duello_pte.ps1 -- controlla dai FILE (.chr) il duello GBPUSD
#  771322 (storica) contro 771332 (candidata R78), e verifica che le
#  ALTRE due sedie PTE non siano state toccate per sbaglio.
#
#  ⚠️ I .chr si aggiornano SOLO al salvataggio del profilo:
#     PRIMA di lanciare -> MT5 -> File -> Profili -> Salva
#
#  Perche' dai file e non dagli screenshot: al deploy R23 la verifica dai
#  .chr trovo' un grafico non salvato che gli screenshot non mostravano.
#  Scrive Desktop\verifica_duello.txt da mandare a Claude.
# =====================================================================
$ErrorActionPreference = "Stop"

$root = Join-Path $env:APPDATA "MetaQuotes\Terminal"
$folders = Get-ChildItem $root -Directory -ErrorAction SilentlyContinue | Where-Object {
  Test-Path (Join-Path $_.FullName "origin.txt") }
$old = $folders | Where-Object {
  $o = (Get-Content (Join-Path $_.FullName "origin.txt") -Raw).Trim()
  $o -like "*BCM*MT5*" -and $o -notlike "*-V3*" -and $o -notlike "*MT4*" } |
  Sort-Object LastWriteTime -Descending | Select-Object -First 1
if (-not $old) { $old = $folders | Select-Object -First 1 }
if (-not $old) { Write-Host "MT5 non trovato." -ForegroundColor Red; exit 1 }

$Righe = New-Object System.Collections.ArrayList
function Rec($s,$col){ [void]$Righe.Add($s); if($col){Write-Host $s -ForegroundColor $col}else{Write-Host $s} }

Rec "=== VERIFICA DUELLO PTE GBPUSD (dai .chr) ===" White
Rec ("terminal: " + (Get-Content (Join-Path $old.FullName "origin.txt") -Raw).Trim()) Gray
Rec ("data     : " + (Get-Date -Format "yyyy.MM.dd HH:mm")) Gray
Rec ""

# --- raccolta di TUTTI i grafici con ABTG_PTE -------------------------
$trovati = @{}
$chrs = Get-ChildItem $old.FullName -Recurse -Filter "*.chr" -ErrorAction SilentlyContinue | Sort-Object LastWriteTime
foreach ($chr in $chrs) {
  $txt = Get-Content $chr.FullName -Raw
  $em = [regex]::Match($txt, "(?s)<expert>.*?path=Experts\\([^\r\n]+)\.ex5")
  if (-not $em.Success) { continue }
  $ea = ($em.Groups[1].Value.Trim() -split '\\')[-1]
  if ($ea -ne "ABTG_PTE") { continue }
  $sm = [regex]::Match($txt, "symbol=([A-Za-z0-9#\.]+)")
  $sym = if($sm.Success){ $sm.Groups[1].Value -replace '[\.#].*$','' } else {"?"}
  $ins = @{}
  $im = [regex]::Match($txt, "(?s)<expert>.*?<inputs>(.*?)</inputs>")
  if ($im.Success) {
    foreach ($l in ($im.Groups[1].Value -split "\r?\n")) {
      if ($l -match "^\s*([A-Za-z0-9_]+)=(.*)$") { $ins[$Matches[1]] = $Matches[2].Trim() }
    }
  }
  $trovati["$sym|$($ins['InpMagic'])"] = @{sym=$sym; ins=$ins; file=$chr.Name; ora=$chr.LastWriteTime}
}

Rec ("grafici ABTG_PTE salvati trovati: " + $trovati.Count) Gray
foreach ($k in ($trovati.Keys | Sort-Object)) {
  $t = $trovati[$k]
  Rec ("   {0,-18} magic {1,-8} buf {2,-6} TP2 {3,-5} TP1 {4,-5} risk {5,-5} '{6}'  [{7}]" -f `
       $t.sym, $t.ins["InpMagic"], $t.ins["InpSLbufferPips"], $t.ins["InpTP2_ATRmult"], `
       $t.ins["InpTP1_ATRmult"], $t.ins["InpRiskPercent"], $t.ins["InpComment"], $t.ora.ToString("dd/MM HH:mm")) Gray
}
Rec ""

# --- gli attesi -------------------------------------------------------
$Attesi = @(
  @{n="DUELLO storica ";sym="GBPUSD";magic="771322";buf="5";tp2="2";tp1="0.5";risk="0.5";tf="16385";comm="PTE GBPUSD"},
  @{n="DUELLO candidata";sym="GBPUSD";magic="771332";buf="25";tp2="3";tp1="0.5";risk="0.5";tf="16385";comm="PTE GBPUSD B25"},
  @{n="NON TOCCATA Dow";sym="U30USD";magic="771321";buf="5";tp2="2";tp1="0.5";risk="1";tf="16385";comm="PTE DOW"},
  @{n="NON TOCCATA JPY";sym="USDJPY";magic="771323";buf="5";tp2="2";tp1="0.5";risk="1";tf="16385";comm="PTE USDJPY"}
)
$errori = 0
foreach ($a in $Attesi) {
  $t = $trovati["$($a.sym)|$($a.magic)"]
  if (-not $t) {
    Rec ("MANCA   {0} -> {1} magic {2}: nessun grafico salvato. Hai fatto File->Profili->Salva?" -f $a.n,$a.sym,$a.magic) Red
    $errori++; continue
  }
  $i = $t.ins; $note = @()
  if ([double]$i["InpSLbufferPips"] -ne [double]$a.buf ) { $note += "InpSLbufferPips=$($i['InpSLbufferPips']) atteso $($a.buf)" }
  if ([double]$i["InpTP2_ATRmult"]  -ne [double]$a.tp2 ) { $note += "InpTP2_ATRmult=$($i['InpTP2_ATRmult']) atteso $($a.tp2)" }
  if ([double]$i["InpTP1_ATRmult"]  -ne [double]$a.tp1 ) { $note += "InpTP1_ATRmult=$($i['InpTP1_ATRmult']) atteso $($a.tp1)" }
  if ([double]$i["InpRiskPercent"]  -ne [double]$a.risk) { $note += "InpRiskPercent=$($i['InpRiskPercent']) atteso $($a.risk)" }
  if ($i["InpTF"] -ne $a.tf)                             { $note += "InpTF=$($i['InpTF']) atteso $($a.tf) (H1)" }
  if ($i["InpComment"] -ne $a.comm)                      { $note += "InpComment='$($i['InpComment'])' atteso '$($a.comm)'" }
  if ($note.Count -eq 0) { Rec ("OK      {0} -> {1} magic {2}" -f $a.n,$a.sym,$a.magic) Green }
  else { Rec ("ERRORE  {0} -> {1} magic {2}: {3}" -f $a.n,$a.sym,$a.magic,($note -join " | ")) Red; $errori++ }
}

# --- il controllo che vale piu' di tutti: magic diversi ---------------
Rec ""
$g = @($trovati.Values | Where-Object { $_.sym -eq "GBPUSD" })
$mg = @($g | ForEach-Object { $_.ins["InpMagic"] })
if ($g.Count -ne 2) {
  Rec ("ATTENZIONE: su GBPUSD ci sono {0} grafici PTE salvati, ne servono 2." -f $g.Count) Red; $errori++
} elseif (($mg | Select-Object -Unique).Count -ne 2) {
  Rec ("🔴 MAGIC UGUALI ({0}): le due sedie si bloccherebbero a vicenda. Il duello NON esisterebbe." -f ($mg -join ", ")) Red; $errori++
} else {
  Rec ("OK      magic DIVERSI su GBPUSD: {0}" -f ($mg -join " / ")) Green
}

Rec ""
if ($errori -eq 0) { Rec "=== TUTTO A POSTO. Il duello e' in campo. ===" Green }
else { Rec ("=== $errori PROBLEMI: NON lasciare cosi'. ===") Red }
Rec ""
Rec "Ultimo passo a mano: Algo Trading VERDE e faccina sorridente sui due grafici GBPUSD."

$dest = Join-Path ([Environment]::GetFolderPath("Desktop")) "verifica_duello.txt"
$Righe | Set-Content -Path $dest -Encoding UTF8
Write-Host ""
Write-Host "Referto scritto in: $dest" -ForegroundColor Cyan
