# =====================================================================
#  abbassa_rischio.ps1 -- porta le sedie col rischio SBAGLIATO al valore
#  giusto, scrivendo direttamente nei .chr (con copia di sicurezza).
#
#  PERCHE' ESISTE (17/08/2026, notte):
#  il censimento ha trovato TRE sedie con InpRiskPercent=2.0 --
#  770101 (DAX Apertura), 770203 (Nasdaq Live5m), 970901 (STREV OTT oro)
#  -- e le prime due sono esattamente quelle delle perdite oltre il 2%
#  sul conto piccolo. Vanno riportate alla taglia di casa.
#
#  COME FUNZIONA:
#  - tocca SOLO i grafici dei magic indicati E SOLO se il rischio vale
#    esattamente il valore -Da (default 2.0). Le copie del 100k a 0.65
#    non vengono nemmeno sfiorate.
#  - di ogni file toccato fa prima una copia .prima_rischio
#  - MT5 DEVE ESSERE CHIUSO: alla chiusura riscrive i .chr e
#    cancellerebbe la correzione.
#
#  USO (sul VPS, con MT5 CHIUSO):
#    .\abbassa_rischio.ps1              -> porta le tre sedie a 1.0
#    .\abbassa_rischio.ps1 -A 0.65      -> le porta a 0.65
# =====================================================================
param(
  [double]$Da = 2.0,
  [double]$A  = 1.0,
  [string[]]$Magics = @("770101","770203","970901")
)
$ErrorActionPreference = "Stop"

$mt5 = Get-Process terminal64 -ErrorAction SilentlyContinue
if($mt5){
  Write-Host "MT5 E' APERTO: chiudilo prima. Alla chiusura riscrive i .chr" -ForegroundColor Red
  Write-Host "e cancellerebbe la correzione. Chiudi MT5 e rilancia." -ForegroundColor Red
  exit 1
}

$root = Join-Path $env:APPDATA "MetaQuotes\Terminal"
$dirs = Get-ChildItem $root -Directory -ErrorAction SilentlyContinue |
        Where-Object { Test-Path (Join-Path $_.FullName "MQL5\Experts") }
if(-not $dirs){ Write-Host "Nessuna cartella dati MT5 trovata." -ForegroundColor Red; exit 1 }

$Righe = New-Object System.Collections.ArrayList
function Rec($s,$col){ [void]$Righe.Add($s); if($col){Write-Host $s -ForegroundColor $col}else{Write-Host $s} }

Rec "=== ABBASSA RISCHIO: da $Da a $A sui magic $($Magics -join ', ') ===" White
Rec ("data: " + (Get-Date -Format "yyyy.MM.dd HH:mm")) Gray
Rec ""

$toccati = 0; $visti = 0
foreach($d in $dirs){
  $chrs = Get-ChildItem $d.FullName -Recurse -Filter "*.chr" -ErrorAction SilentlyContinue
  foreach($chr in $chrs){
    $sr = New-Object System.IO.StreamReader($chr.FullName, $true)
    $txt = $sr.ReadToEnd()
    $enc = $sr.CurrentEncoding
    $sr.Close()

    $em = [regex]::Match($txt, "(?s)<expert>.*?path=Experts\\([^\r\n]+)\.ex5")
    if(-not $em.Success){ continue }
    $ea = ($em.Groups[1].Value.Trim() -split '\\')[-1]

    $im = [regex]::Match($txt, "(?s)<expert>.*?<inputs>(.*?)</inputs>")
    if(-not $im.Success){ continue }
    $ins = @{}
    foreach($l in ($im.Groups[1].Value -split "\r?\n")){
      if($l -match "^\s*([A-Za-z0-9_]+)=(.*)$"){ $ins[$Matches[1]] = $Matches[2].Trim() }
    }
    if(-not $ins.ContainsKey("InpMagic")){ continue }
    if($Magics -notcontains $ins["InpMagic"]){ continue }
    if(-not $ins.ContainsKey("InpRiskPercent")){ continue }
    $visti++

    $val = 0.0
    if(-not [double]::TryParse($ins["InpRiskPercent"], [ref]$val)){ continue }
    if([math]::Abs($val - $Da) -gt 0.0001){
      Rec ("  lasciato  {0,-36} magic {1}  rischio {2}  ({3})" -f $ea, $ins["InpMagic"], $ins["InpRiskPercent"], $chr.Name) Gray
      continue
    }

    Copy-Item $chr.FullName ($chr.FullName + ".prima_rischio") -Force
    $vecchio = "InpRiskPercent=" + $ins["InpRiskPercent"]
    $nuovo   = "InpRiskPercent=" + $A.ToString([System.Globalization.CultureInfo]::InvariantCulture)
    $rx = New-Object System.Text.RegularExpressions.Regex ("(?m)^\s*" + [regex]::Escape($vecchio) + "\s*$")
    $txt2 = $rx.Replace($txt, $nuovo, 1)
    if($txt2 -eq $txt){
      Rec ("  ATTENZIONE: riga rischio non trovata in {0}, file NON toccato" -f $chr.Name) Yellow
      continue
    }
    [System.IO.File]::WriteAllText($chr.FullName, $txt2, $enc)
    $toccati++
    Rec ("  CORRETTO  {0,-36} magic {1}  {2} -> {3}  ({4})" -f $ea, $ins["InpMagic"], $ins["InpRiskPercent"], $nuovo.Split('=')[1], $chr.Name) Green
  }
}

Rec ""
Rec ("grafici dei magic bersaglio visti: {0}   corretti: {1}" -f $visti, $toccati) White
if($toccati -eq 0){
  Rec "Nessun file corretto: o erano gia' a posto, o il valore non era $Da." Yellow
} else {
  Rec "Copie di sicurezza: accanto a ogni file, estensione .prima_rischio" Gray
}
Rec ""
Rec "ADESSO: riapri MT5 e rilancia il censimento per la controprova." Cyan
Rec "Le righe rosse a 2.0 devono essere sparite." Cyan

$dest = Join-Path ([Environment]::GetFolderPath("Desktop")) "abbassa_rischio.txt"
$Righe | Set-Content -Path $dest -Encoding UTF8
Write-Host ""
Write-Host "Referto scritto in: $dest" -ForegroundColor Cyan
