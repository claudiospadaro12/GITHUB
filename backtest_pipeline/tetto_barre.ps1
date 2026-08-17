# =====================================================================
#  tetto_barre.ps1 -- LEGGE (e se richiesto ALZA) il tetto delle barre
#  del terminale MT5, quello che tiene le serie a 100.000 barre esatte.
#
#  PERCHE' ESISTE (17/08/2026, sera):
#  il downloader ha misurato GBPUSD M1 e H1 fermi a **100.000 barre**
#  esatte, con lo storico locale che parte dal 2026.05.11 (M1) e dal
#  2010.07.07 (H1) mentre il server ha dal 1993.05.11. Cento mila e' un
#  numero tondo: e' un tetto, non un dato mancante.
#  Nelle build recenti di MT5 la voce "Max barre nel grafico" NON c'e'
#  piu' in Strumenti -> Opzioni -> Grafici. Ma il valore vive lo stesso
#  nel file di configurazione del terminale, e li' si legge e si scrive.
#
#  USO:
#    .\tetto_barre.ps1               -> LEGGE e basta (sicuro, non tocca)
#    .\tetto_barre.ps1 -Imposta      -> ALZA il tetto (MT5 DEVE essere CHIUSO)
#
#  Fa una copia di sicurezza del file prima di toccarlo.
# =====================================================================
param(
  [switch]$Imposta,
  [int]$Valore = 2000000000     # praticamente illimitato
)
$ErrorActionPreference = "Stop"

$root = Join-Path $env:APPDATA "MetaQuotes\Terminal"
$dirs = Get-ChildItem $root -Directory -ErrorAction SilentlyContinue |
        Where-Object { Test-Path (Join-Path $_.FullName "MQL5\Experts") }
if(-not $dirs){ Write-Host "Nessuna cartella dati MT5 trovata." -ForegroundColor Red; exit 1 }

if($Imposta){
  $mt5 = Get-Process terminal64 -ErrorAction SilentlyContinue
  if($mt5){
    Write-Host "MT5 E' APERTO: chiudilo prima, altrimenti riscrive il file quando esce." -ForegroundColor Red
    exit 1
  }
}

foreach($d in $dirs){
  $ini = Join-Path $d.FullName "config\common.ini"
  Write-Host ""
  Write-Host ("=== " + $d.FullName) -ForegroundColor Cyan
  if(-not (Test-Path $ini)){ Write-Host "  config\common.ini non c'e'." -ForegroundColor Yellow; continue }

  $righe = Get-Content $ini
  $chiavi = $righe | Where-Object { $_ -match "^\s*(MaxBars|MaxCharts|MaxBarsInChart|MaxBarsInHistory)\s*=" }
  if($chiavi){
    Write-Host "  valori trovati adesso:" -ForegroundColor Gray
    foreach($k in $chiavi){ Write-Host ("    " + $k.Trim()) -ForegroundColor White }
  } else {
    Write-Host "  nessuna chiave MaxBars nel file: il tetto sta altrove o e' il default." -ForegroundColor Yellow
  }

  if($Imposta){
    Copy-Item $ini ($ini + ".prima_del_17-08") -Force
    $fatto = $false
    $nuove = foreach($r in $righe){
      if($r -match "^\s*MaxBars\s*="){ $fatto = $true; "MaxBars=$Valore" } else { $r }
    }
    if(-not $fatto){
      # la chiave non c'era: la si aggiunge dentro [Charts], creando la sezione se serve
      if($righe -match "^\s*\[Charts\]"){
        $nuove = foreach($r in $righe){
          $r
          if($r -match "^\s*\[Charts\]"){ "MaxBars=$Valore" }
        }
      } else {
        $nuove = $righe + "" + "[Charts]" + "MaxBars=$Valore"
      }
    }
    $nuove | Set-Content -Path $ini -Encoding ASCII
    Write-Host ("  SCRITTO MaxBars=" + $Valore + "   (copia: common.ini.prima_del_17-08)") -ForegroundColor Green
  }
}

Write-Host ""
if($Imposta){
  Write-Host "FATTO. Adesso: riapri MT5 e rilancia ABTG_HistoryDownloader." -ForegroundColor Green
  Write-Host "Il controllo che dice se e' servito: il downloader NON deve piu'" -ForegroundColor Yellow
  Write-Host "stampare 100000 barre tonde." -ForegroundColor Yellow
} else {
  Write-Host "Questo giro ha solo LETTO. Per alzarlo: chiudi MT5 e rilancia con -Imposta" -ForegroundColor Cyan
}
