# =====================================================================
#  notte_05-08.ps1  --  la coda di lavoro mentre Claudio e' via
#
#  Il backtest del 05/08 ha chiuso una porta: su DAX e Nasdaq la
#  GESTIONE e' stata portata al meglio noto e il risultato e' zero
#  (24 combinazioni, 700 trade, PF sempre sotto 1; il migliore e'
#  0,994). Non ha senso continuare a limarla.
#
#  Il problema e' a monte, nell'INGRESSO. E' quello che Claudio aveva
#  detto il 04/08 ("dobbiamo anche verificare la logica di ingresso se
#  sia quella + corretta") prima che i dati gli dessero ragione.
#
#  Questa coda attacca l'ingresso da tre lati, in ordine di
#  decisivita' per tempo speso:
#
#   1) OPENCONFIRM sul TF del grafico (8 pass)
#      Inseguire la rottura con un pendente, o aspettare che la candela
#      APRA gia' oltre il livello? Una candela che apre oltre non puo'
#      essere prodotta da uno sweep: lo sweep e' intra-candela. E' la
#      risposta candidata ai tre Live5m spazzati in 61 s, 20 s e 2m32s.
#
#   2) OPENCONFIRM su M15 (8 pass)
#      Come lo guardano nelle live ("mi apre la candela sotto e c'e' un
#      incremento dei volumi, io li' lo shorto"). Stesso confronto, ma
#      la candela e' quella che guarda un umano.
#
#   3) GEOMETRIA DELL'INGRESSO (40 pass)
#      InpRangeMinutes 5/15/25/35/45 x InpBufferPoints 100/300/500/700.
#      I due numeri su cui poggia TUTTO il sistema delle aperture e che
#      non sono MAI stati misurati: il 15 viene dal PDF di Emiliano, il
#      200 fu scelto a occhio.
#
#  56 pass a TICK REALI su 2,5 anni. E' roba da notte.
#
#  La gestione e' fissata a quella validata: TP 1,5R, trailing a base
#  candela M5, niente parziale ne' BE. Cosi' l'unica cosa che cambia e'
#  DOVE e QUANDO si entra.
#
#  PC di backtest, MetaTrader CHIUSO. Se qualcosa fallisce, gli altri
#  proseguono: ogni fase e' indipendente e salva in una cartella sua.
#
#  Uso:
#    powershell -ExecutionPolicy Bypass -File .\notte_05-08.ps1
# =====================================================================
param([switch]$UseSpare,[switch]$Force)
$ErrorActionPreference="Continue"    # una fase che salta non deve fermare le altre
[Net.ServicePointManager]::SecurityProtocol=[Net.SecurityProtocolType]::Tls12

$Sha="0a2502f26d8971fefb6c8592e115e2d7e71ce62c"
$RawBase="https://raw.githubusercontent.com/claudiospadaro12/GITHUB/$Sha/backtest_pipeline"
$Work= if($PSScriptRoot){$PSScriptRoot}else{(Get-Location).Path}
Set-Location $Work

Write-Host ""
Write-Host "=============================================================" -ForegroundColor Cyan
Write-Host "  CODA DELLA NOTTE 05/08 - l'INGRESSO, non piu' la gestione" -ForegroundColor Cyan
Write-Host "=============================================================" -ForegroundColor Cyan
Write-Host "  56 pass a tick reali. Lascia il PC acceso e vai pure." -ForegroundColor Gray
Write-Host ""

if((Get-Process -Name "terminal64" -ErrorAction SilentlyContinue) -and -not $Force){
  Write-Host "!!! MetaTrader e' APERTO. Chiudilo e rilancia, altrimenti 0 CSV." -ForegroundColor Red
  exit 1
}

# --- scarico gli script della coda (pinnati allo SHA: niente cache della CDN) ---
foreach($s in @("aperture_openconfirm.ps1","aperture_ingresso.ps1")){
  try{
    Invoke-WebRequest -Uri "$RawBase/$s" -OutFile (Join-Path $Work $s) -UseBasicParsing
    Write-Host "  scaricato $s" -ForegroundColor Green
  }catch{
    Write-Host "  ERRORE download $s - la coda si ferma qui." -ForegroundColor Red
    exit 1
  }
}

$extra=@(); if($UseSpare){$extra+="-UseSpare"}; if($Force){$extra+="-Force"}

$Fasi=@(
  @{ N=1; Titolo="OPENCONFIRM sul TF del grafico (8 pass)";
     File="aperture_openconfirm.ps1"; Args=@("-OCTimeframe","0","-TrailTF","5","-UseTrailing","1") },
  @{ N=2; Titolo="OPENCONFIRM su M15, come nelle live (8 pass)";
     File="aperture_openconfirm.ps1"; Args=@("-OCTimeframe","15","-TrailTF","5","-UseTrailing","1") },
  @{ N=3; Titolo="GEOMETRIA DELL'INGRESSO: durata range x buffer (40 pass)";
     File="aperture_ingresso.ps1";    Args=@("-TrailTF","5","-UseTrailing","1") }
)

$inizio=Get-Date
foreach($f in $Fasi){
  Write-Host ""
  Write-Host "-------------------------------------------------------------" -ForegroundColor Yellow
  Write-Host ("  FASE {0}/{1} - {2}" -f $f.N,$Fasi.Count,$f.Titolo) -ForegroundColor Yellow
  Write-Host "-------------------------------------------------------------" -ForegroundColor Yellow
  $t0=Get-Date
  try{
    $argomenti = @($f.Args) + $extra
    & powershell -ExecutionPolicy Bypass -File (Join-Path $Work $f.File) $argomenti
  }catch{
    Write-Host ("  fase {0} interrotta: {1}" -f $f.N,$_.Exception.Message) -ForegroundColor Red
  }
  Write-Host ("  fase {0} chiusa in {1:hh\:mm\:ss}" -f $f.N,((Get-Date)-$t0)) -ForegroundColor Gray
}

Write-Host ""
Write-Host "=============================================================" -ForegroundColor White
Write-Host ("  CODA FINITA in {0:hh\:mm\:ss}" -f ((Get-Date)-$inizio)) -ForegroundColor White
Write-Host "=============================================================" -ForegroundColor White
Write-Host "  Zippa e mandami QUESTE DUE cartelle:" -ForegroundColor Gray
Write-Host "    $Work\risultati_openconfirm" -ForegroundColor Gray
Write-Host "    $Work\risultati_aperture_ingresso" -ForegroundColor Gray
