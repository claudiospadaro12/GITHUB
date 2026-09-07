# =====================================================================
#  MARCATORE_RIGA_RITARDO_TESTER_v1
#  RIGA_RITARDO_TESTER.ps1 -- R119: le DUE sedie vive del conto reale
#  rifatte con il RITARDO DEL TESTER acceso, su una scala di 4 livelli.
# ---------------------------------------------------------------------
#  IL CONTRATTO FA FEDE E NON SI RISCRIVE QUI:
#     backtest_pipeline\prove\RITARDO_TESTER_R119.txt
#     (criteri G0-G2 e S1-S4 congelati il 07/09/2026, PRIMA dei numeri)
#  LE DUE CELLE CONGELATE, copiate dai preset del CONTO REALE:
#     prove\ABTG_DAX_Apertura_EU_RITARDO.txt   (770101, D30EUR, LIMIT)
#     prove\ABTG_ORB_Ottimizzato_RITARDO.txt   (770611, U30USD, STOP)
#
# =====================================================================
#  QUESTA RIGA NON TOCCA NESSUNA SEDIA VIVA E NON APRE NESSUN ORDINE.
#  Gira SUL PC DI BACKTEST, non sul VPS. Gli .ini del driver generico
#  hanno AllowLiveTrading=false. Non installa preset, non scrive in
#  nessuna cartella di forward, non cambia nessun parametro.
#
# =====================================================================
#  QUALE TERMINALE: quello di BACKTEST, come tutti i round.
#  Il driver generico sceglie da solo il terminale BCM ESCLUDENDO il
#  -V3 (conto 100k 50504263) e C:\BCM_Reale (conto reale 10105439):
#  quel controllo e' stato chiuso il 07/09 (classe 37-quater) e sta nel
#  driver condiviso, non qui.
#
# =====================================================================
#  PERCHE' ESISTE QUESTO FILE invece di otto righe di
#  walkforward_generico.ps1 incollate a mano.
#
#   1. IL CANCELLO G0 (CANARINO) E' CODICE CHE STA IN MEZZO ALLE CORSE,
#      NON UNA FRASE ALLA FINE.
#      Classe 151, imparata il 07/09/2026 sbagliando: in R118 i criteri
#      promettevano un cancello e nel driver c'era solo una Write-Host
#      DOPO le 170 passate.
#      Qui le prime DUE corse sono ORB a Delay=0 e ORB a Delay=500, e
#      SUBITO DOPO gira CancelloCanarino(), che confronta i due CSV e
#      FERMA TUTTO (exit 2, esito NON MISURATO) se sono identici cifra
#      per cifra: vorrebbe dire che MT5 ignora la chiave Delay scritta
#      da .ini, e le altre sei corse sarebbero macchina buttata.
#      IL CANCELLO E' COLLAUDABILE SENZA MT5:
#         -CollaudoCancello -CsvA <file> -CsvB <file>
#      esegue SOLO quella logica e dice cosa avrebbe fatto. Un cancello
#      che nessuno ha mai visto scattare non e' un cancello dimostrato.
#
#   2. LA SEDIA DEL CANARINO E' SCELTA, NON CASUALE.
#      E' la 770611, quella che entra con BuyStop. Un ordine STOP e' un
#      ordine a mercato differito: se il ritardo morde da qualche parte,
#      deve mordere li'. Farlo sulla 770101 (BuyLimit, immune per
#      costruzione all'ingresso) confonderebbe "riga ignorata da MT5"
#      con "sedia immune al ritardo". Sono due cose diverse e il
#      contratto lo dice al cancello G0.
#
#   3. IL VERDETTO STA SULL'ARTEFATTO, NON SUL CODICE DI USCITA.
#      Classe 154: walkforward_generico.ps1 sul ramo buono non chiama
#      mai 'exit', quindi quello che torna e' il codice dell'ultimo .exe
#      lanciato dentro (metaeditor64 /compile, che esce non-zero anche
#      solo per avvisi). Qui il driver si lancia con Start-Process
#      -PassThru -Wait e il suo ExitCode finisce nei RILIEVI; la corsa
#      si considera avvenuta se il CSV c'e', e' FRESCO (scritto dopo
#      l'avvio di quella corsa) e ha le colonne giuste.
#
#   4. L'ESITO CONTA I FILE LETTI, NON QUELLI SELEZIONATI.
#      Classe 150: un referto che dice PARZIALE avendo letto zero righe
#      e' peggio di uno che dice NON MISURATO.
#
#   5. LO ZIP E' DI QUESTA CORSA, NON DELLA PRECEDENTE.
#      Classe 155/155-bis: la cartella di lavoro viene SVUOTATA dei CSV
#      del round all'avvio, e la raccolta copia solo file scritti DOPO
#      l'istante di partenza. Un file vecchio non entra nello zip.
# =====================================================================

param(
  [switch]$SoloControllo,          # non apre MT5: scarica, controlla, stampa quante celle
  [switch]$CollaudoCancello,       # esegue SOLO il cancello G0 su due CSV dati, senza MT5
  [string]$CsvA = "",              # (collaudo) CSV della corsa BASE
  [string]$CsvB = "",              # (collaudo) CSV della corsa STRESS
  [switch]$Rifai
)

$ErrorActionPreference = "Stop"
[Net.ServicePointManager]::SecurityProtocol = [Net.SecurityProtocolType]::Tls12
$Branch  = "lavoro"
$RawBase = "https://raw.githubusercontent.com/claudiospadaro12/GITHUB/$Branch"
$Work    = Join-Path $env:USERPROFILE "abtg_ritardo_r119"
$Prove   = Join-Path $Work "prove"
$Avvio   = Get-Date

$MARC_MIO = "MARCATORE_RIGA_RITARDO_TESTER_v1"
$MARC_DRV = "MARCATORE_WALKFORWARD_GENERICO_v2_RITARDO"

# le due sedie e la scala. UNA SOLA VOLTA, qui.
$SEDIE = @(
  @{ Chi="ORB"; EA="ABTG_ORB_Ottimizzato";  Sim="U30USD"; Prova="ABTG_ORB_Ottimizzato_RITARDO.txt";  Ordine="STOP"  },
  @{ Chi="DAX"; EA="ABTG_DAX_Apertura_EU";  Sim="D30EUR"; Prova="ABTG_DAX_Apertura_EU_RITARDO.txt";  Ordine="LIMIT" }
)
$SCALA = @(0,50,100,500)
$RILIEVI = New-Object System.Collections.ArrayList

function Titolo($t){ Write-Host ""; Write-Host ("=== " + $t + " ===") -ForegroundColor Cyan }
function Rilievo($t){ [void]$RILIEVI.Add($t); Write-Host ("    RILIEVO: " + $t) -ForegroundColor DarkYellow }
function Muori($t,$code){ Write-Host ""; Write-Host ("!!! " + $t) -ForegroundColor Red; exit $code }

# ---------------------------------------------------------------------
#  LA FIRMA DI UNA CORSA: solo le colonne che dicono l'esito economico,
#  ordinate per magic. Le colonne di eco degli input NON entrano (sono
#  identiche per costruzione fra le corse: cio' che cambia e' il Delay,
#  che non e' un input dell'EA e quindi non compare nel CSV).
# ---------------------------------------------------------------------
function FirmaCorsa($csv){
  if(-not (Test-Path -LiteralPath $csv)){ return $null }
  $r = @(Import-Csv -LiteralPath $csv -ErrorAction SilentlyContinue)
  if($r.Count -eq 0){ return $null }
  $cols = @("Profit","Profit Factor","Equity DD %","Trades")
  foreach($c in $cols){ if($r[0].PSObject.Properties.Name -notcontains $c){ return $null } }
  $chiave = if($r[0].PSObject.Properties.Name -contains "InpMagic"){ "InpMagic" } else { "Pass" }
  $out = @()
  foreach($x in ($r | Sort-Object { [string]$_.$chiave })){
    $out += ("{0}|{1}|{2}|{3}|{4}" -f $x.$chiave, $x.Profit, $x.'Profit Factor', $x.'Equity DD %', $x.Trades)
  }
  return ($out -join "`n")
}

# ---------------------------------------------------------------------
#  G1 -- GEMELLI DI DETERMINISMO: le 2 celle dell'asse magic devono
#  dare la stessa riga economica. Torna $true/$false/$null(illeggibile).
# ---------------------------------------------------------------------
function GemelliOk($csv){
  if(-not (Test-Path -LiteralPath $csv)){ return $null }
  $r = @(Import-Csv -LiteralPath $csv -ErrorAction SilentlyContinue)
  if($r.Count -lt 2){ return $null }
  $f = @()
  foreach($x in $r){ $f += ("{0}|{1}|{2}|{3}" -f $x.Profit, $x.'Profit Factor', $x.'Equity DD %', $x.Trades) }
  return (($f | Select-Object -Unique).Count -eq 1)
}

# =====================================================================
#  IL CANCELLO G0. E' UNA FUNZIONE, GIRA FRA LE CORSE, E FERMA LA SPESA.
# =====================================================================
function CancelloCanarino($csvBase,$csvStress){
  Titolo "CANCELLO G0 -- IL RITARDO MORDE?"
  Write-Host ("    BASE   (Delay=0)   : " + $csvBase)
  Write-Host ("    STRESS (Delay=500) : " + $csvStress)
  $a = FirmaCorsa $csvBase
  $b = FirmaCorsa $csvStress
  if($null -eq $a -or $null -eq $b){
    Write-Host "    ESITO G0: NON MISURATO -- uno dei due CSV manca, e' vuoto o non ha le colonne attese." -ForegroundColor Red
    return "ILLEGGIBILE"
  }
  Write-Host ""
  Write-Host "    firma BASE:"   -ForegroundColor Gray; $a.Split("`n") | ForEach-Object { Write-Host ("      " + $_) }
  Write-Host "    firma STRESS:" -ForegroundColor Gray; $b.Split("`n") | ForEach-Object { Write-Host ("      " + $_) }
  Write-Host ""
  if($a -eq $b){
    Write-Host "    ESITO G0: IDENTICI CIFRA PER CIFRA." -ForegroundColor Red
    Write-Host "    -> MT5 IGNORA la chiave Delay scritta nell'.ini." -ForegroundColor Red
    Write-Host "    -> L'esito del round e' NON MISURATO." -ForegroundColor Red
    Write-Host "    -> NON vuol dire 'immune al ritardo': vuol dire che la leva" -ForegroundColor Red
    Write-Host "       non e' utilizzabile da riga di comando, e va cercata un'altra strada." -ForegroundColor Red
    return "IGNORATA"
  }
  Write-Host "    ESITO G0: DIVERSI -> il ritardo MORDE. Si prosegue con le altre corse." -ForegroundColor Green
  return "MORDE"
}

# =====================================================================
#  RAMO DI COLLAUDO: il cancello G0 senza MT5.
# =====================================================================
if($CollaudoCancello){
  Titolo "COLLAUDO DEL CANCELLO G0 (nessun MT5, nessuna corsa)"
  if(-not $CsvA -or -not $CsvB){ Muori "servono -CsvA e -CsvB con due file CSV." 1 }
  $esito = CancelloCanarino $CsvA $CsvB
  Write-Host ""
  Write-Host ("    IL CANCELLO AVREBBE DETTO: " + $esito) -ForegroundColor Cyan
  Write-Host ("    e il round si sarebbe: " + $(if($esito -eq "MORDE"){"PROSEGUITO"}else{"FERMATO (exit 2)"})) -ForegroundColor Cyan
  exit 0
}

# =====================================================================
#  1. PREPARAZIONE
# =====================================================================
Titolo "R119 -- RITARDO DEL TESTER SULLE DUE SEDIE VIVE"
Write-Host ("    " + $MARC_MIO) -ForegroundColor DarkGray
Write-Host "    PC DI BACKTEST. Non e' il VPS. Non tocca nessuna sedia viva." -ForegroundColor Gray

$mt5 = @(Get-Process terminal64 -ErrorAction SilentlyContinue)
if($mt5.Count -gt 0){
  Write-Host ""
  Write-Host "    MT5 E' APERTO. Il driver lancia il terminale con /config: va CHIUSO prima." -ForegroundColor Red
  $mt5 | ForEach-Object { Write-Host ("      PID " + $_.Id + "  " + $_.Path) -ForegroundColor Red }
  Muori "chiudi MetaTrader 5 e rilancia." 1
}

New-Item -ItemType Directory -Force -Path $Work,$Prove | Out-Null

# 155/155-bis: i CSV del round precedente NON devono finire nello zip di oggi.
$Ris = Join-Path $Work "risultati_prove"
if((Test-Path $Ris) -and $Rifai){ Remove-Item $Ris -Recurse -Force; Write-Host "    -Rifai: risultati_prove SVUOTATA." -ForegroundColor DarkYellow }

Titolo "2. SCARICO DAL BRANCH '$Branch' (regola delle righe di lancio, punto 1)"
$daScaricare = @(
  @{ url="$RawBase/backtest_pipeline/walkforward_generico.ps1"; dst=(Join-Path $Work "walkforward_generico.ps1") },
  @{ url="$RawBase/backtest_pipeline/prove/RITARDO_TESTER_R119.txt"; dst=(Join-Path $Prove "RITARDO_TESTER_R119.txt") }
)
foreach($s in $SEDIE){
  $daScaricare += @{ url="$RawBase/backtest_pipeline/prove/$($s.Prova)"; dst=(Join-Path $Prove $s.Prova) }
}
foreach($d in $daScaricare){
  $u = $d.url + "?cb=" + [Guid]::NewGuid().ToString("N")   # cache di GitHub raw
  try   { Invoke-WebRequest -Uri $u -OutFile $d.dst -UseBasicParsing -TimeoutSec 90 }
  catch { Muori ("scarico fallito: " + $d.url + " -- " + $_.Exception.Message) 1 }
  Write-Host ("    ok  " + (Split-Path $d.dst -Leaf) + "  (" + (Get-Item $d.dst).Length + " byte)") -ForegroundColor Gray
}

$drv = Join-Path $Work "walkforward_generico.ps1"
if(-not (Select-String -LiteralPath $drv -SimpleMatch $MARC_DRV -Quiet)){
  Muori ("il driver scaricato NON ha il marcatore " + $MARC_DRV + ": e' una copia vecchia, senza il parametro -Ritardo. Non si prosegue.") 1
}
Write-Host ("    driver: " + $MARC_DRV + " PRESENTE.") -ForegroundColor Green

# =====================================================================
#  3. LA CORSA
# =====================================================================
function Corri($sedia,$ritardo){
  $et  = "R119_" + $sedia.Chi + "_D" + ("{0:0000}" -f $ritardo)
  $pr  = Join-Path $Prove $sedia.Prova
  $arg = @("-NoProfile","-ExecutionPolicy","Bypass","-File",$drv,
           "-Expert",$sedia.EA,"-Prova",$pr,"-Ritardo",$ritardo,
           "-Etichetta",$et,"-Modello","4","-Rifai")
  if($SoloControllo){ $arg += "-SoloControllo" }
  Write-Host ""
  Write-Host ("--- " + $sedia.Chi + " (" + $sedia.EA + " " + $sedia.Sim + ", ingresso " + $sedia.Ordine + ")  Delay=" + $ritardo + " ms ---") -ForegroundColor Cyan
  $t0 = Get-Date
  $p  = Start-Process -FilePath "powershell.exe" -ArgumentList $arg -NoNewWindow -PassThru -Wait
  $csvIS  = Join-Path $Work ("risultati_prove\" + $sedia.EA + "\" + $sedia.EA + "_" + $sedia.Sim + "_IS_"  + $et + ".csv")
  $csvOOS = Join-Path $Work ("risultati_prove\" + $sedia.EA + "\" + $sedia.EA + "_" + $sedia.Sim + "_OOS_" + $et + ".csv")
  # 154: il codice d'uscita del driver e' quello di metaeditor, non un verdetto.
  if($p.ExitCode -ne 0){ Rilievo ("driver uscito con codice " + $p.ExitCode + " su " + $et + " (classe 154: e' l'ultimo .exe lanciato dentro, NON un verdetto). Il verdetto sta sui CSV.") }
  $fresco = { param($f) (Test-Path -LiteralPath $f) -and ((Get-Item -LiteralPath $f).LastWriteTime -ge $t0) }
  return @{ Et=$et; IS=$csvIS; OOS=$csvOOS; IsFresco=(& $fresco $csvIS); OosFresco=(& $fresco $csvOOS); Exit=$p.ExitCode }
}

$ORB = $SEDIE[0]; $DAX = $SEDIE[1]
$esiti = @{}

# -SoloControllo: si controllano TUTTE E DUE le sedie, non solo quella del
# canarino. Un file prova del DAX malformato, controllando solo l'ORB, si
# scoprirebbe dopo QUATTRO corse a tick reali gia' spese.
if($SoloControllo){
  Titolo "4. GIRO A VUOTO -- TUTTE E DUE LE SEDIE (MT5 non viene aperto)"
  foreach($s in $SEDIE){ [void](Corri $s 100) }
  Write-Host ""
  Write-Host ("    corse totali che il round vero farebbe: " + ($SEDIE.Count * $SCALA.Count) + "  (2 sedie x 4 livelli di ritardo: " + ($SCALA -join ", ") + " ms)") -ForegroundColor White
  Write-Host  "    ogni corsa = 2 finestre (IS/OOS) x 2 celle magic = 4 passate a tick reali." -ForegroundColor White
  Write-Host  "    CONTROLLA DUE COSE QUI SOPRA, PER TUTTE E DUE LE SEDIE:" -ForegroundColor Yellow
  Write-Host  "      a) il conto delle celle deve dire 2. Se dice altro, FERMATI e dillo." -ForegroundColor Yellow
  Write-Host  "      b) nell'anteprima dell'.ini ci deve essere la riga  Delay=100" -ForegroundColor Yellow
  Write-Host  "         Se quella riga NON c'e', il driver e' una copia vecchia e il round" -ForegroundColor Yellow
  Write-Host  "         girerebbe SENZA ritardo dicendo di averlo messo." -ForegroundColor Yellow
  exit 0
}

Titolo "4. LE DUE CORSE DEL CANARINO (sedia 770611, ordine STOP)"
$esiti["ORB_0"]   = Corri $ORB 0
$esiti["ORB_500"] = Corri $ORB 500

$G0 = CancelloCanarino $esiti["ORB_0"].IS $esiti["ORB_500"].IS
if($G0 -ne "MORDE"){
  Titolo "ROUND FERMATO DAL CANCELLO G0"
  Write-Host ("    esito: " + $G0) -ForegroundColor Red
  Write-Host  "    le altre SEI corse NON sono state lanciate: sarebbero macchina buttata." -ForegroundColor Red
  Write-Host  "    Manda comunque lo zip: il referto serve lo stesso." -ForegroundColor Yellow
  $esitoRound = "NON MISURATO -- cancello G0: " + $G0
} else {
  $esitoRound = "MISURATO"
  Titolo "5. LE ALTRE SEI CORSE"
  $esiti["ORB_50"]  = Corri $ORB 50
  $esiti["ORB_100"] = Corri $ORB 100
  foreach($d in $SCALA){ $esiti["DAX_$d"] = Corri $DAX $d }
}

# =====================================================================
#  6. IL REFERTO. I FILE LETTI, NON QUELLI SELEZIONATI (classe 150).
# =====================================================================
Titolo "6. REFERTO"
$ref = Join-Path $Work "REFERTO_RITARDO_R119.txt"
$R = New-Object System.Collections.ArrayList
function W($t){ [void]$R.Add($t); Write-Host $t }

W ("REFERTO R119 -- RITARDO DEL TESTER SULLE DUE SEDIE VIVE DEL CONTO REALE")
W ("marcatore riga : " + $MARC_MIO)
W ("marcatore driver: " + $MARC_DRV)
W ("branch          : " + $Branch)
W ("avvio           : " + $Avvio.ToString("yyyy-MM-dd HH:mm:ss"))
W ("contratto       : prove\RITARDO_TESTER_R119.txt (criteri G0-G2, S1-S4 congelati il 07/09/2026)")
W ("")
W ("CANCELLO G0 (il ritardo morde?): " + $G0)
W ("")
W ("--- LE CORSE ---")
$letti = 0; $attese = 0
foreach($k in ($esiti.Keys | Sort-Object)){
  $e = $esiti[$k]; $attese += 2
  $gIS  = GemelliOk $e.IS
  $gOOS = GemelliOk $e.OOS
  $sIS  = if($e.IsFresco){ $letti++; "LETTO" } else { "MANCANTE/VECCHIO" }
  $sOOS = if($e.OosFresco){ $letti++; "LETTO" } else { "MANCANTE/VECCHIO" }
  W ("  " + $e.Et)
  W ("     IS  : " + $sIS  + "   gemelli G1: " + $(if($null -eq $gIS){"NON LEGGIBILE"}elseif($gIS){"IDENTICI (ok)"}else{"DIVERSI -- BANCO NON DETERMINISTICO"}))
  W ("     OOS : " + $sOOS + "   gemelli G1: " + $(if($null -eq $gOOS){"NON LEGGIBILE"}elseif($gOOS){"IDENTICI (ok)"}else{"DIVERSI -- BANCO NON DETERMINISTICO"}))
  if($null -ne $gIS  -and -not $gIS ){ Rilievo ($e.Et + " IS: i due gemelli magic NON coincidono. Cancello G1 FALLITO.") }
  if($null -ne $gOOS -and -not $gOOS){ Rilievo ($e.Et + " OOS: i due gemelli magic NON coincidono. Cancello G1 FALLITO.") }
}
W ("")
W ("file CSV attesi: " + $attese + "   file CSV LETTI: " + $letti)

$esitoFinale = $esitoRound
if($letti -le 0){ $esitoFinale = "NON MISURATO -- ZERO file CSV letti" }
elseif($letti -lt $attese -and $G0 -eq "MORDE"){ $esitoFinale = "PARZIALE -- " + ($attese-$letti) + " CSV su " + $attese + " non letti" }

W ("")
W ("RILIEVI: " + $RILIEVI.Count)
foreach($x in $RILIEVI){ W ("  - " + $x) }
W ("")
W ("ESITO: " + $esitoFinale)
W ("")
W ("COSA NON DICE QUESTO REFERTO: non giudica. I criteri S1-S4 si applicano")
W ("ai numeri dei CSV e il verdetto lo scrive la chat, contro il contratto.")
$R -join "`r`n" | Set-Content -LiteralPath $ref -Encoding ASCII

# =====================================================================
#  7. RACCOLTA SUL DESKTOP + ZIP (regola delle righe di lancio, punto 2)
# =====================================================================
Titolo "7. RACCOLTA"
$Cart = Join-Path ([Environment]::GetFolderPath("Desktop")) "RITARDO_R119"
if(Test-Path $Cart){ Remove-Item $Cart -Recurse -Force }
New-Item -ItemType Directory -Force -Path $Cart | Out-Null
Copy-Item $ref $Cart -Force
$n = 0
if(Test-Path $Ris){
  foreach($f in (Get-ChildItem $Ris -Recurse -Filter "*R119*.csv" -ErrorAction SilentlyContinue |
                 Where-Object { $_.LastWriteTime -ge $Avvio })){    # 155: solo file di QUESTA corsa
    Copy-Item $f.FullName $Cart -Force; $n++
  }
}
Copy-Item (Join-Path $Prove "RITARDO_TESTER_R119.txt") $Cart -Force
foreach($s in $SEDIE){ Copy-Item (Join-Path $Prove $s.Prova) $Cart -Force }

$zip = Join-Path ([Environment]::GetFolderPath("Desktop")) "RITARDO_R119.zip"
if(Test-Path $zip){ Remove-Item $zip -Force }
Compress-Archive -Path (Join-Path $Cart "*") -DestinationPath $zip -Force

Write-Host ""
Write-Host ("    CSV di QUESTA corsa copiati: " + $n) -ForegroundColor White
Write-Host  "    file nella cartella:" -ForegroundColor Gray
Get-ChildItem $Cart | ForEach-Object { Write-Host ("      " + $_.Name + "   (" + $_.Length + " byte)") }
Write-Host ""
Write-Host ("    ZIP DA MANDARE A CLAUDE:  " + $zip) -ForegroundColor Green
Write-Host ("    ESITO: " + $esitoFinale) -ForegroundColor $(if($esitoFinale -eq "MISURATO"){"Green"}else{"Yellow"})
Write-Host ""

if($esitoFinale -eq "MISURATO"){ exit 0 }
if($G0 -ne "MORDE"){ exit 2 }
exit 3
