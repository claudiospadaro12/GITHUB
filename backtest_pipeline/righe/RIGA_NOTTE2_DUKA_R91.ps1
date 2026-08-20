# =====================================================================
#  MARCATORE_RIGA_NOTTE2_v1
#  RIGA_NOTTE2_DUKA_R91.ps1  --  la notte del 20/08/2026 (NOTTE #2)
# ---------------------------------------------------------------------
#  E' la SORELLA di RIGA_NOTTE_R88_R87_R89_R86.ps1 (27 file su 27, 2h16
#  la notte del 19/08). Stessa ossatura: pin, scarico al pin, driver
#  PINNATO, fase compila, sequenza uno alla volta, STATO riscritto dopo
#  OGNI passo, raccolta Desktop + zip, referto scritto SEMPRE, -OreMax
#  che non ammazza mai un lavoro in corso, ripresa.
#
#  COSA FA, IN ORDINE E DA SOLA:
#
#   PARTE 1 - DUKASCOPY, I DUE PASSI MANCANTI  (Python, niente MT5)
#     1a. trova python VERO (non lo stub del Microsoft Store, checklist 17)
#     1b. scarica dukascopy_m1.py AL PIN (marcatore DUKA-M1-v3)
#     1c. un giorno di Dow 2025-06-16  -> MISURA i secondi
#     1d. un giorno di Dow 2015-06-15  -> MISURA i secondi
#         (referto cancellato PRIMA e preteso riscritto ADESSO; referto,
#          console e CSV raccolti con NOME PROPRIO subito dopo ogni
#          chiamata -- checklist 26: lo strumento raccoglie da solo
#          sempre sullo stesso nome, la seconda chiamata cancella la prima)
#     1e. LA PROIEZIONE, il canarino di R90:
#           ore = secondi_del_passo_2025 * 2505 / 3600
#         2505 = i giorni che lo script ITERA davvero su 8 anni
#         (2012-2022 escluso il solo sabato: 2922 - 417 = 2505). Non e'
#         un numero tirato: coincide col conto dei giorni feriali.
#
#   PARTE 2 - IL DOWNLOAD LUNGO DEL DOW, SOLO SE IL CANARINO E' VERDE
#     proiezione <= -SogliaCanarinoOre (20 di default) -> si scaricano le
#     QUATTRO finestre di R90, lette dai file prova R90a/b/c/d (NON
#     scritte a mano qui dentro), una chiamata per finestra, in sequenza,
#     ognuna col suo CSV rinominato subito.
#     proiezione > soglia -> NON si scarica NIENTE e nel referto va la
#     riga "CANARINO ROSSO: la strada Dukascopy per il Dow costa X ore,
#     R90 va ripensato". E' un CANCELLO, non un'opinione.
#
#   PARTE 3 - R91 AL TESTER (l'unico round FIRMATO oggi)
#     3a. compila ABTG_BreakingBand v1.03: preteso InpMinRR nel sorgente,
#         .ex5 SCRITTO ADESSO, 0 errori nel log
#     3b. i tre file prova R91a/b/c, 24 passate, deposito 100000,
#         ETICHETTE DISTINTE (r91a / r91b / r91c: difetto 26)
#     3c. RIGA DI SANITA' su OGNI simbolo, subito dopo il suo file: la
#         cella InpMinRR=0 deve riprodurre R91_CRITERI.md par. 4.0.
#         Se non torna, R91 SI FERMA e lo dice forte.
#     3d. il LOG del tester della cella InpMinRR=0 + la distribuzione
#         del RR estratta. Vedi il LIMITE DICHIARATO qui sotto.
#
#  IL LIMITE DICHIARATO DELLA 3d  (letto nel codice, non supposto)
#    ABTG_BreakingBand logga il RR con Print() (riga ~1146, dentro Log()).
#    walkforward_generico.ps1 gira SEMPRE con Optimization=1, e in
#    ottimizzazione MT5 NON esegue le Print degli agent. Quindi i CSV
#    del round NON possono, per costruzione, contenere il log del RR.
#    Percio' questa riga aggiunge un PASSO IN PIU', dichiarato: rilegge
#    l'.ini gia' generato dal driver per la finestra OOS, lo trasforma in
#    UNA SOLA passata (Optimization=0) con InpMinRR pinnato a 0, la fa
#    girare e raccoglie i log freschi. E' la STESSA cella dei CSV: se il
#    Profit della passata singola non coincide con la riga InpMinRR=0 del
#    CSV, e' un problema e va scritto. Si spegne con -SaltaLogRR.
#
#  QUELLO CHE NON FA, DICHIARATO:
#    - non giudica nessun numero di R90/R91: produce artefatti e li conta.
#      L'unico giudizio automatico e' la SANITA' (riproduci o fermati) e
#      il CANARINO (soglia oraria decisa PRIMA).
#    - non ammazza MAI un lavoro in corso allo scadere delle ore: smette
#      solo di INIZIARNE di nuovi (checklist 19).
#    - non tocca nessuna sedia viva, nessun .set, nessun grafico, nessun
#      conto: il tester gira con AllowLiveTrading=false (lo mette il driver).
#    - NON importa i CSV Dukascopy in MT5 e non crea U30USD_EXT: quello
#      e' un altro passo, con altri controlli (shift +5, canarino di
#      riproduzione) e non si fa di notte senza guardare.
#
#  LA RIGA CHE SI INCOLLA (blocco INTERO, un comando solo -- checklist 21).
#  <PIN> = il commit che contiene QUESTO file: e' l'hash dato in chat.
#
#  & { $ErrorActionPreference='Stop'; [Net.ServicePointManager]::SecurityProtocol=[Net.SecurityProtocolType]::Tls12;
#      if(Get-Process terminal64 -EA SilentlyContinue){ throw 'MT5 APERTO: chiudilo e rilancia.' };
#      $pin='<PIN>'; $p="$env:USERPROFILE\RIGA_NOTTE2.ps1"; Remove-Item $p -EA SilentlyContinue;
#      irm "https://raw.githubusercontent.com/claudiospadaro12/GITHUB/$pin/backtest_pipeline/righe/RIGA_NOTTE2_DUKA_R91.ps1" -OutFile $p;
#      if(-not (Select-String -Path $p -SimpleMatch -Pattern 'MARCATORE_RIGA_NOTTE2_v1' -Quiet)){ throw 'SCRIPT VECCHIO' };
#      $global:LASTEXITCODE=0; & $p -Pin $pin; if($LASTEXITCODE -ne 0){ Write-Host 'ESITO: PARZIALE - leggi il REFERTO' } }
#
#  -Pin NON HA DEFAULT, apposta. Nella riga sorella il default era un
#  hash vecchio: se qualcuno lanciava lo script a mano girava codice di
#  ieri senza accorgersene. Qui senza -Pin valido lo script si ferma.
# =====================================================================
param(
  [string]$Pin        = "",         # OBBLIGATORIO: sha40. Lo passa la riga.
  [double]$OreMax     = 12.0,       # tetto della NOTTE: oltre non si inizia niente di nuovo
  [double]$OreMaxDuka = 8.0,        # tetto della sola PARTE 2: serve a NON far morire R91,
                                    #   che e' l'unico round firmato oggi. Oltre questo tetto
                                    #   non si INIZIANO nuove finestre Dukascopy.
  [double]$SogliaCanarinoOre = 20.0,# il CANCELLO della parte 2, deciso PRIMA di misurare
  [int]$PausaMs       = 250,        # respiro fra richieste: default MISURATO il 15/08 (503 in raffica)
  [switch]$CorteInTesta,            # finestre R90 dalla piu' corta alla piu' lunga (CROLLO per primo)
  [switch]$SaltaScaricoLungo,       # fa solo i due passi da 1 giorno + la proiezione, poi R91
  [switch]$SoloDuka,                # solo parte 1 e 2
  [switch]$SoloR91,                 # solo parte 3
  [switch]$PrimaR91,                # inverte l'ordine: R91 PRIMA del download lungo
  [switch]$SaltaLogRR,              # niente passata singola per il log del RR
  [switch]$Rifai,                   # rifa' anche i CSV di R91 gia' presenti (default: riprende)
  [switch]$SoloControllo,           # giro a vuoto su R91: nessun MT5, solo controlli + anteprime
  [switch]$ProsegueDopoSanita       # la sanita' fallita non ferma R91.
                                    #   NON serve a leggere R91 lo stesso: in quel caso R91 NON VALE.
)
$ErrorActionPreference = "Stop"
[Threading.Thread]::CurrentThread.CurrentCulture   = [Globalization.CultureInfo]::InvariantCulture
[Threading.Thread]::CurrentThread.CurrentUICulture = [Globalization.CultureInfo]::InvariantCulture
[Net.ServicePointManager]::SecurityProtocol = [Net.SecurityProtocolType]::Tls12
$INV = [Globalization.CultureInfo]::InvariantCulture

if($Pin -notmatch '^[0-9a-fA-F]{40}$'){
  Write-Host ""
  Write-Host "!!! PIN MANCANTE O NON VALIDO." -ForegroundColor Red
  Write-Host "    Questo script NON ha un pin di ripiego: girare al pin sbagliato" -ForegroundColor Yellow
  Write-Host "    vuol dire girare codice di ieri senza accorgersene." -ForegroundColor Yellow
  Write-Host "    Usa il blocco di lancio scritto in testa al file, con l'hash dato in chat." -ForegroundColor Yellow
  exit 1
}
$Pin = $Pin.ToLower()

$Avvio   = Get-Date
$Stamp   = $Avvio.ToString("yyyyMMdd_HHmm", $INV)
$Dsk     = Join-Path $env:USERPROFILE "Desktop"
$Work    = Join-Path $env:USERPROFILE "abtg_notte2"
$Prove   = Join-Path $Work "prove"
$Logs    = Join-Path $Work "log_notte2"
$SrcDir  = Join-Path $Work "src_motori"
$DukaLav = Join-Path $env:USERPROFILE "dukascopy_lavoro"
$DukaM1  = Join-Path $DukaLav "m1"
$RefDuka = Join-Path $DukaM1  "referto_dukascopy_m1.txt"
$CsvDuka = Join-Path $DukaM1  "U30USD_M1.csv"
$RawPin  = "https://raw.githubusercontent.com/claudiospadaro12/GITHUB/$Pin"

# la cartella di raccolta E' la cartella di sosta: nome proprio subito,
# UN solo zip in fondo (checklist 26).
$Cart    = Join-Path $Dsk ("NOTTE2_" + $Stamp)
$CartDuk = Join-Path $Cart "duka"
$CartR91 = Join-Path $Cart "r91"
$CartLog = Join-Path $Cart "log_tester"
$Referto = Join-Path $Cart "REFERTO_NOTTE2.txt"
$StatoFile = Join-Path $Dsk "STATO_NOTTE2.txt"

$Problemi = New-Object System.Collections.ArrayList
$Note     = New-Object System.Collections.ArrayList
$Passi    = New-Object System.Collections.ArrayList
$Fatale   = ""
$Python   = ""
$Sec2025  = -1.0
$Sec2015  = -1.0
$Proiezione = -1.0
$Canarino = "NON MISURATO"
$RigaCanarino = "CANARINO NON MISURATO: il passo da un giorno del 2025 non ha prodotto un tempo."

function Ora(){ return (Get-Date).ToString("HH:mm:ss", $INV) }
function Dico($t,$c="Gray"){ Write-Host ("[" + (Ora) + "] " + $t) -ForegroundColor $c }
function Titolo($t){ Write-Host ""; Write-Host ("=== " + $t + " ===") -ForegroundColor Cyan }
function Num($s){ $d=0.0; if([double]::TryParse([string]$s,[Globalization.NumberStyles]::Float,$INV,[ref]$d)){ return $d }; return [double]::NaN }
function Trascorse(){ return (New-TimeSpan -Start $Avvio -End (Get-Date)).TotalHours }

# --- scarico blindato: niente copia vecchia, errore terminante, marcatore
function Scarica($url,$dest,$marcatore){
  Remove-Item -LiteralPath $dest -Force -ErrorAction SilentlyContinue
  Invoke-WebRequest -Uri $url -OutFile $dest -UseBasicParsing -ErrorAction Stop
  if(-not (Test-Path -LiteralPath $dest)){ throw ("scarico fallito: " + $url) }
  if($marcatore -ne "" -and -not (Select-String -Path $dest -SimpleMatch -Pattern $marcatore -Quiet)){
    throw ("file scaricato SENZA il marcatore '" + $marcatore + "': " + $url)
  }
}

# --- il registro dei passi. ScriviStato lo riversa su Desktop DOPO OGNI passo.
function NuovoPasso($fase,$nome){
  $p = [pscustomobject]@{ Fase=$fase; Nome=$nome; Esito="NON ESEGUITO"; Inizio=""; Fine=""; Min=0.0; Nota="" }
  [void]$Passi.Add($p)
  return $p
}
function ScriviStato(){
  try{
    Remove-Item -LiteralPath $StatoFile -Force -ErrorAction SilentlyContinue
    $o = New-Object System.Collections.ArrayList
    [void]$o.Add("STATO DELLA NOTTE #2  --  DUKASCOPY (parte 1-2) + R91 (parte 3)")
    [void]$o.Add("data: " + (Get-Date).ToString("yyyy-MM-dd HH:mm:ss",$INV) + "   (questa data deve essere di ADESSO)")
    [void]$o.Add("avvio: " + $Avvio.ToString("yyyy-MM-dd HH:mm:ss",$INV) + "   pin: " + $Pin)
    [void]$o.Add("trascorse: " + (Trascorse).ToString("0.00",$INV) + " h   su -OreMax " + $OreMax.ToString("0.0",$INV) +
                 "   (tetto parte 2: " + $OreMaxDuka.ToString("0.0",$INV) + " h)")
    [void]$o.Add("")
    [void]$o.Add("CANARINO R90: " + $Canarino)
    if($Sec2025 -ge 0){ [void]$o.Add("  1 giorno di Dow 2025 = " + $Sec2025.ToString("0.0",$INV) + " s") }
    if($Sec2015 -ge 0){ [void]$o.Add("  1 giorno di Dow 2015 = " + $Sec2015.ToString("0.0",$INV) + " s") }
    if($Proiezione -ge 0){ [void]$o.Add("  proiezione Dow 2015-2022 (2505 giorni) = " + $Proiezione.ToString("0.0",$INV) + " ore") }
    [void]$o.Add("")
    [void]$o.Add(("{0,-6} {1,-34} {2,-9} {3,-9} {4,-8} {5}" -f "FASE","PASSO","INIZIO","FINE","MIN","ESITO"))
    foreach($p in $Passi){
      [void]$o.Add(("{0,-6} {1,-34} {2,-9} {3,-9} {4,-8} {5}" -f `
        $p.Fase,$p.Nome,$p.Inizio,$p.Fine,$p.Min.ToString("0.0",$INV),($p.Esito + $(if($p.Nota -ne ""){ "  -- " + $p.Nota }else{ "" }))))
    }
    Set-Content -LiteralPath $StatoFile -Value $o -Encoding ASCII
  }catch{ Write-Host ("   (stato non scritto: " + $_.Exception.Message + ")") -ForegroundColor DarkYellow }
}

# --- lancio di un eseguibile ESTERNO con log e codice d'uscita onesto.
#     $ErrorActionPreference='Stop' + '2>&1' su un processo nativo fa
#     esplodere PowerShell 5.1 alla PRIMA riga di stderr (NativeCommandError):
#     una traccia python su stderr ucciderebbe la notte. Qui si abbassa la
#     guardia SOLO intorno alla chiamata, e si giudica sul codice d'uscita.
function EseguiNativo($exe,$argv,$logfile){
  $vecchio = $ErrorActionPreference
  $ErrorActionPreference = "Continue"
  $global:LASTEXITCODE = 0
  try{
    & $exe @argv 2>&1 | Tee-Object -FilePath $logfile | Out-Host
    $rc = $LASTEXITCODE
  }catch{
    $rc = 99
    Write-Host ("    eccezione lanciando " + $exe + ": " + $_.Exception.Message) -ForegroundColor Red
  }finally{
    $ErrorActionPreference = $vecchio
  }
  if($null -eq $rc){ $rc = 0 }
  return [int]$rc
}

# --- i giorni che dukascopy_m1.py ITERA davvero: tutti tranne il SABATO
#     (funzione giorni(), riga ~545 del .py). Non "i giorni di borsa".
function GiorniIterati($da,$a){
  $n=0; $d=$da
  while($d -le $a){ if($d.DayOfWeek -ne [DayOfWeek]::Saturday){ $n++ }; $d=$d.AddDays(1) }
  return $n
}

Write-Host ""
Write-Host "#####################################################################" -ForegroundColor Cyan
Write-Host "#  NOTTE #2   DUKASCOPY (canarino R90) + R91 al tester              #" -ForegroundColor Cyan
Write-Host "#  una macchina, un lavoro. Tutto in sequenza.                      #" -ForegroundColor Cyan
Write-Host "#####################################################################" -ForegroundColor Cyan
Dico ("pin      : " + $Pin)
Dico ("cartella : " + $Work)
Dico ("raccolta : " + $Cart)

# =====================================================================
#  0. MT5 CHIUSO (checklist 7). La parte 3 lo usa; le parti 1-2 no, ma
#     tenerlo chiuso toglie ogni dubbio (e la parte 3 arriva DOPO ore).
# =====================================================================
if(Get-Process -Name "terminal64" -ErrorAction SilentlyContinue){
  Write-Host ""
  Write-Host "!!! MT5 E' APERTO. Non parto: la parte 3 non produrrebbe nessun CSV." -ForegroundColor Red
  Write-Host "    Chiudi MetaTrader (tutte le istanze) e rilancia la stessa riga." -ForegroundColor Yellow
  exit 1
}

New-Item -ItemType Directory -Force -Path $Work,$Prove,$Logs,$SrcDir,$Cart,$CartDuk,$CartR91,$CartLog | Out-Null

# =====================================================================
#  LA TABELLA DI R91. Etichette DIVERSE per file: difetto 26.
# =====================================================================
function L($prova,$sym,$et,$att,$dep,$rifP,$rifF,$rifD,$rifT){
  return [pscustomobject]@{ Prova=$prova; Sym=$sym; Et=$et; Att=$att; Dep=$dep
                            RifP=$rifP; RifF=$rifF; RifD=$rifD; RifT=$rifT
                            Esito="NON ESEGUITO"; IS=-1; OOS=-1; Min=0.0; Sanita="NON FATTA" }
}
$EAR91 = "ABTG_BreakingBand"
# i riferimenti vengono da R91_CRITERI.md par. 4.0 (CSV di R34, deposito 100000)
$LavR91 = @(
  (L "R91a_rr_GBPUSD.txt" "GBPUSD" "r91a" 4 100000  3160.10 1.73020 3.4801 26),
  (L "R91b_rr_EURUSD.txt" "EURUSD" "r91b" 4 100000  2069.82 3.86266 1.2722 13),
  (L "R91c_rr_AUDUSD.txt" "AUDUSD" "r91c" 4 100000  1840.67 2.74743 1.2695 11)
)

Titolo "QUANTO CI METTE  (STIMA, non misura -- il ritmo vero lo misura la parte 1)"
Write-Host "    PARTE 1  due giorni singoli di Dow (Python)         2-10 min" -ForegroundColor White
Write-Host "    PARTE 2  4 finestre R90 (SOLO se canarino verde)    1-12 ore, tetto -OreMaxDuka" -ForegroundColor White
Write-Host "    PARTE 3  R91: compila + 24 passate + sanita'        30-90 min" -ForegroundColor White
Write-Host "    PARTE 3d passata singola per il log del RR (x3)     5-20 min" -ForegroundColor Gray
Write-Host ("    Tetto notte -OreMax = " + $OreMax.ToString("0.0",$INV) + " h. Nessun lavoro in corso viene mai interrotto.") -ForegroundColor Yellow
Write-Host ("    Ordine: " + $(if($PrimaR91){ "PARTE 1 -> PARTE 3 (R91) -> PARTE 2 (download lungo)" }else{ "PARTE 1 -> PARTE 2 -> PARTE 3 (come da missione)" })) -ForegroundColor Yellow
if(-not $PrimaR91 -and -not $SoloR91){
  Write-Host "    NOTA: il tetto -OreMaxDuka esiste per questo. Se il download lungo prendesse" -ForegroundColor Yellow
  Write-Host "    tutta la notte, R91 -- l'unico round FIRMATO oggi -- non partirebbe mai." -ForegroundColor Yellow
}
ScriviStato

# =====================================================================
#  UNA CHIAMATA A DUKASCOPY, fatta come si deve:
#   - referto e CSV CANCELLATI prima
#   - artefatti pretesi SCRITTI ADESSO
#   - artefatti copiati SUBITO con un nome PROPRIO (checklist 26)
#   - i secondi MISURATI
# =====================================================================
function ChiamaDuka($nomePasso,$tag,$da,$a,$scriptPy){
  $p = NuovoPasso "DUKA" $nomePasso
  $p.Inizio = (Ora)
  ScriviStato
  Write-Host ""
  Write-Host "------------------------------------------------------------------" -ForegroundColor Cyan
  Write-Host ("  DUKASCOPY  " + $nomePasso + "   USA30IDXUSD  " + $da + " -> " + $a) -ForegroundColor Cyan
  Write-Host ("  giorni iterati (sabato escluso): " + (GiorniIterati ([datetime]::ParseExact($da,"yyyy-MM-dd",$INV)) ([datetime]::ParseExact($a,"yyyy-MM-dd",$INV)))) -ForegroundColor DarkGray
  Write-Host "------------------------------------------------------------------" -ForegroundColor Cyan

  Remove-Item -LiteralPath $RefDuka -Force -ErrorAction SilentlyContinue
  Remove-Item -LiteralPath $CsvDuka -Force -ErrorAction SilentlyContinue
  $t0 = Get-Date
  $console = Join-Path $Logs ("console_" + $tag + ".txt")
  $argv = @("-u",$scriptPy,"--simboli","USA30IDXUSD","--da",$da,"--a",$a,
            "--pausa-ms",("" + $PausaMs),"--cartella",$DukaLav)
  $rc = EseguiNativo $Python $argv $console
  $sec = (New-TimeSpan -Start $t0 -End (Get-Date)).TotalSeconds
  $p.Fine = (Ora)
  $p.Min  = [math]::Round($sec/60.0,1)

  # --- gate sull'ARTEFATTO, non solo sul codice d'uscita (checklist 26-bis)
  $refOk = $false
  if(Test-Path -LiteralPath $RefDuka){ $refOk = ((Get-Item -LiteralPath $RefDuka).LastWriteTime -ge $t0) }
  $esitoRef = "(referto assente)"
  if($refOk){
    $mm = [regex]::Match((Get-Content -LiteralPath $RefDuka -Raw),'(?m)^ESITO\s*:\s*(.+)$')
    if($mm.Success){ $esitoRef = $mm.Groups[1].Value.Trim() }
  }

  # --- raccolta col NOME PROPRIO, SUBITO. La raccolta automatica dello
  #     strumento scrive sempre sugli stessi nomi: alla chiamata dopo
  #     sparisce. Qui la prima copia e' gia' al sicuro.
  $csvRighe = -1
  try{
    if($refOk){ Copy-Item -LiteralPath $RefDuka -Destination (Join-Path $CartDuk ("referto_" + $tag + ".txt")) -Force }
    if(Test-Path -LiteralPath $console){ Copy-Item -LiteralPath $console -Destination (Join-Path $CartDuk ("console_" + $tag + ".txt")) -Force }
    if(Test-Path -LiteralPath $CsvDuka){
      if((Get-Item -LiteralPath $CsvDuka).LastWriteTime -ge $t0){
        $righe = @(Get-Content -LiteralPath $CsvDuka)
        $csvRighe = $righe.Count
        Copy-Item -LiteralPath $CsvDuka -Destination (Join-Path $CartDuk ("U30USD_M1_" + $tag + ".csv")) -Force
        # --- CHECKLIST 32: L'ORDINE DI GRANDEZZA SI GUARDA, SEMPRE.
        #     La banda del Dow nella tabella dello strumento e' 8000-70000
        #     (rapporto 8,75 < 10: uno sfondamento si ferma pulito). Ma il
        #     controllo "a occhio" che il referto raccomanda qui lo si fa
        #     a macchina: se il Close della prima barra non e' un Dow, e'
        #     il divisore sbagliato e il CSV e' spazzatura silenziosa.
        if($righe.Count -ge 2){
          $campi = ("" + $righe[1]) -split ","
          if($campi.Count -ge 5){
            $close = Num $campi[4]
            $p.Nota = "primo Close " + $campi[4]
            if([double]::IsNaN($close) -or $close -lt 8000.0 -or $close -gt 70000.0){
              [void]$Problemi.Add("DUKA " + $tag + ": ORDINE DI GRANDEZZA SBAGLIATO. Il primo Close del CSV e' " +
                                  $campi[4] + ", che NON e' un Dow (banda 8000-70000). Divisore sbagliato: il CSV NON si importa.")
              Write-Host ("    !! primo Close = " + $campi[4] + " : NON e' un Dow. Guarda la riga 'divisore usato' nel referto.") -ForegroundColor Red
            } else {
              Write-Host ("    ordine di grandezza OK: primo Close = " + $campi[4]) -ForegroundColor Green
            }
          }
        }
      } else {
        [void]$Note.Add("DUKA " + $tag + ": trovato un CSV NON scritto adesso, NON raccolto (era di una corsa precedente).")
      }
    }
  }catch{ [void]$Note.Add("DUKA " + $tag + ": raccolta parziale (" + $_.Exception.Message + ")") }

  $p.Nota = ("rc=" + $rc + " esito='" + $esitoRef + "' righeCSV=" + $csvRighe +
             $(if($p.Nota -ne ""){ " " + $p.Nota }else{ "" }) + " " + [math]::Round($sec,1) + " s")
  if(-not $refOk){
    $p.Esito = "NON PARTITA (nessun referto di adesso)"
    [void]$Problemi.Add("DUKA " + $tag + ": nessun referto scritto adesso. rc=" + $rc + ". Guarda " + $console)
  }
  elseif($rc -eq 0){ $p.Esito = "OK" }
  elseif($rc -eq 3){
    $p.Esito = "CON BUCHI (rilanciabile)"
    [void]$Problemi.Add("DUKA " + $tag + ": corsa COMPLETA MA CON BUCHI (rc 3). Rilanciare la stessa riga: la cache non riscarica quello che c'e' gia'.")
  }
  else{
    $p.Esito = "FALLITA (rc " + $rc + ")"
    [void]$Problemi.Add("DUKA " + $tag + ": rc " + $rc + " -- esito nel referto: " + $esitoRef)
  }
  Dico ("DUKA " + $tag + " -> " + $p.Esito + "   " + [math]::Round($sec,1) + " s   (" + $esitoRef + ")") $(if($p.Esito -eq "OK"){"Green"}else{"Yellow"})
  ScriviStato
  return $sec
}

# --- una PARTE che muore non porta giu' le altre. E' la regola della
#     missione: se R91 non compila, le parti 1-2 restano valide; se manca
#     python, R91 -- che python non lo usa -- deve girare lo stesso.
function Fallita($nome,$err){
  Write-Host ""
  Write-Host ("!!! " + $nome + " SI E' FERMATA: " + $err) -ForegroundColor Red
  Write-Host "    Le altre parti proseguono. Il referto lo scrive comunque." -ForegroundColor Yellow
  [void]$Problemi.Add($nome + " FERMATA: " + $err)
  ScriviStato
}

try{

# =====================================================================
#  PARTE 1 - DUKASCOPY: PYTHON, SCRIPT AL PIN, DUE GIORNI, LA PROIEZIONE
# =====================================================================
if(-not $SoloR91){
 try{
  Titolo "PARTE 1 - DUKASCOPY: i due passi mancanti"

  # --- 1a. PYTHON VERO (checklist 17). Misurato, mai dedotto.
  $pp = NuovoPasso "P1" "python trovato e >= 3.8"
  $pp.Inizio = (Ora)
  $Python = (Get-Command python.exe -ErrorAction SilentlyContinue |
             Where-Object { $_.Source -notlike "*\WindowsApps\*" } |
             Select-Object -First 1 -ExpandProperty Source)
  if(-not $Python){ $Python = (Get-Command py.exe -ErrorAction SilentlyContinue | Select-Object -First 1 -ExpandProperty Source) }
  if(-not $Python){ throw "PYTHON ASSENTE: installalo da python.org spuntando 'Add python.exe to PATH'. Le parti 1 e 2 non sono eseguibili." }
  $rcv = EseguiNativo $Python @("-c","import sys; print(sys.version); sys.exit(0 if sys.version_info>=(3,8) else 1)") (Join-Path $Logs "python_versione.txt")
  if($rcv -ne 0){ throw ("PYTHON TROPPO VECCHIO O NON FUNZIONANTE: " + $Python) }
  $pp.Fine = (Ora); $pp.Esito = "OK"; $pp.Nota = $Python
  Dico ("python: " + $Python) "Green"
  ScriviStato

  # --- 1b. lo script AL PIN, col marcatore
  $ps = NuovoPasso "P1" "dukascopy_m1.py al pin"
  $ps.Inizio = (Ora)
  $DukaPy = Join-Path $Work "dukascopy_m1.py"
  Scarica ("$RawPin/backtest_pipeline/dukascopy/dukascopy_m1.py") $DukaPy 'DUKA-M1-v3'
  $ps.Fine = (Ora); $ps.Esito = "OK"; $ps.Nota = "marcatore DUKA-M1-v3 verificato"
  Dico "dukascopy_m1.py scaricato al pin (DUKA-M1-v3)" "Green"
  New-Item -ItemType Directory -Force -Path $DukaLav,$DukaM1 | Out-Null
  ScriviStato

  # --- 1c/1d. i due giorni. In sequenza, mai in parallelo.
  # NB: si prende l'ULTIMO valore emesso dalla funzione. In PowerShell qualunque
  # riga che "stampa" dentro una funzione finisce nel valore di ritorno: cosi' una
  # eventuale fuga non trasforma i secondi in un array e non fa esplodere il conto.
  $rit = @(ChiamaDuka "Dow 1 giorno 2025-06-16" "prova_2025_06_16" "2025-06-16" "2025-06-16" $DukaPy)
  $Sec2025 = [double]$rit[$rit.Count-1]
  $rit = @(ChiamaDuka "Dow 1 giorno 2015-06-15" "prova_2015_06_15" "2015-06-15" "2015-06-15" $DukaPy)
  $Sec2015 = [double]$rit[$rit.Count-1]

  # --- 1e. LA PROIEZIONE: il canarino di R90
  Titolo "PARTE 1e - LA PROIEZIONE (il canarino di R90)"
  $pc = NuovoPasso "P1" "proiezione / canarino"
  $pc.Inizio = (Ora)
  if($Sec2025 -gt 0){
    $Proiezione = $Sec2025 * 2505.0 / 3600.0
    Write-Host ("    1 giorno di Dow 2025 = " + $Sec2025.ToString("0.0",$INV) + " s   (comprende il controllo positivo EURUSD: stima CONSERVATIVA)") -ForegroundColor White
    if($Sec2015 -gt 0){
      Write-Host ("    1 giorno di Dow 2015 = " + $Sec2015.ToString("0.0",$INV) + " s   (il 2015 e' piu' rado: se e' molto diverso, dillo nel referto)") -ForegroundColor White
    }
    Write-Host ("    PROIEZIONE Dow 2015-2022 = " + $Sec2025.ToString("0.0",$INV) + " x 2505 / 3600 = " +
                $Proiezione.ToString("0.0",$INV) + " ORE") -ForegroundColor White
    if($Proiezione -le $SogliaCanarinoOre){
      $Canarino = "VERDE (" + $Proiezione.ToString("0.0",$INV) + " ore <= " + $SogliaCanarinoOre.ToString("0.0",$INV) + ")"
      $RigaCanarino = "CANARINO VERDE: la strada Dukascopy per il Dow costa " + $Proiezione.ToString("0.0",$INV) +
                      " ore su 8 anni (soglia " + $SogliaCanarinoOre.ToString("0.0",$INV) + "). Le 4 finestre di R90 si scaricano."
      Dico $Canarino "Green"
    } else {
      $Canarino = "ROSSO (" + $Proiezione.ToString("0.0",$INV) + " ore > " + $SogliaCanarinoOre.ToString("0.0",$INV) + ")"
      $RigaCanarino = "CANARINO ROSSO: la strada Dukascopy per il Dow costa " + $Proiezione.ToString("0.0",$INV) +
                      " ore, R90 va ripensato."
      Write-Host ""
      Write-Host ("    !!! " + $RigaCanarino) -ForegroundColor Red
      [void]$Problemi.Add($RigaCanarino)
    }
    $pc.Esito = "OK"; $pc.Nota = $Canarino
  } else {
    [void]$Problemi.Add("PROIEZIONE IMPOSSIBILE: il passo da un giorno del 2025 non ha prodotto un tempo utile. La parte 2 NON si lancia (canarino non misurato = rosso per prudenza).")
    $pc.Esito = "IMPOSSIBILE"; $pc.Nota = "nessun tempo dal passo 2025"
  }
  $pc.Fine = (Ora)
  ScriviStato
 }catch{
  Fallita "PARTE 1 (Dukascopy)" $_.Exception.Message
  [void]$Problemi.Add("Senza la PARTE 1 il canarino resta NON MISURATO: la PARTE 2 non parte (prudenza). La PARTE 3 (R91) non usa python e gira lo stesso.")
 }
}

# =====================================================================
#  LA PARTE 2, in una funzione: cosi' l'ordine (-PrimaR91) si sceglie
#  senza duplicare una riga di codice.
# =====================================================================
function Parte2(){
  if($SoloR91){ return }
  Titolo "PARTE 2 - IL DOWNLOAD LUNGO DEL DOW (le 4 finestre di R90)"
  if($SaltaScaricoLungo){
    [void]$Note.Add("PARTE 2 saltata su richiesta (-SaltaScaricoLungo).")
    Dico "PARTE 2 saltata su richiesta (-SaltaScaricoLungo)." "Yellow"
    $x = NuovoPasso "P2" "download lungo"; $x.Esito = "SALTATA (-SaltaScaricoLungo)"; ScriviStato; return
  }
  if($Canarino -notlike "VERDE*"){
    $x = NuovoPasso "P2" "download lungo"
    $x.Esito = "NON LANCIATA (canarino non verde)"
    $x.Nota  = $Canarino
    Write-Host ""
    Write-Host ("    " + $RigaCanarino) -ForegroundColor Red
    Write-Host "    Il cancello e' stato deciso PRIMA di misurare: non si scarica niente." -ForegroundColor Yellow
    Write-Host "    Si passa alla PARTE 3 (R91)." -ForegroundColor Yellow
    ScriviStato
    return
  }

  # --- le finestre si LEGGONO dai file prova di R90, non si scrivono qui
  $Fin = New-Object System.Collections.ArrayList
  foreach($fp in @("R90a_toro_U30USD.txt","R90b_orso_U30USD.txt","R90c_laterale_U30USD.txt","R90d_crollo_U30USD.txt")){
    $dst = Join-Path $Prove $fp
    try{ Scarica ("$RawPin/backtest_pipeline/prove/" + $fp) $dst '@FINESTRA' }
    catch{ [void]$Problemi.Add("R90: file prova " + $fp + " non scaricato (" + $_.Exception.Message + "): finestra SALTATA."); continue }
    $t = Get-Content -LiteralPath $dst -Raw
    $mN = [regex]::Match($t,'(?m)^#\s*@FINESTRA\s+(\S+)')
    $mD = [regex]::Match($t,'(?m)^#\s*@DA\s+([0-9]{4}\.[0-9]{2}\.[0-9]{2})')
    $mA = [regex]::Match($t,'(?m)^#\s*@A\s+([0-9]{4}\.[0-9]{2}\.[0-9]{2})')
    if(-not ($mN.Success -and $mD.Success -and $mA.Success)){
      [void]$Problemi.Add("R90: in " + $fp + " non trovo @FINESTRA/@DA/@A: finestra SALTATA (non invento le date).")
      continue
    }
    $d1 = [datetime]::ParseExact($mD.Groups[1].Value,"yyyy.MM.dd",$INV)
    $d2 = [datetime]::ParseExact($mA.Groups[1].Value,"yyyy.MM.dd",$INV)
    if($d2 -le $d1){ [void]$Problemi.Add("R90: in " + $fp + " la data @A non e' dopo @DA: finestra SALTATA."); continue }
    [void]$Fin.Add([pscustomobject]@{
      Nome = $mN.Groups[1].Value
      Tag  = ($mN.Groups[1].Value.ToLower() + "_" + $d1.ToString("yyyy",$INV))
      Da   = $d1.ToString("yyyy-MM-dd",$INV)
      A    = $d2.ToString("yyyy-MM-dd",$INV)
      Gg   = (GiorniIterati $d1 $d2)
      File = $fp })
  }
  if($Fin.Count -eq 0){
    [void]$Problemi.Add("R90: nessuna finestra leggibile dai file prova. PARTE 2 non eseguita.")
    $x = NuovoPasso "P2" "download lungo"; $x.Esito = "NON ESEGUITA (nessuna finestra letta)"; ScriviStato; return
  }

  $ordinate = @($Fin)
  if($CorteInTesta){ $ordinate = @($Fin | Sort-Object Gg) }
  $secGiorno = $Sec2025
  Write-Host "    finestre lette dai file prova di R90 (non scritte a mano qui):" -ForegroundColor Gray
  $ggTot = 0
  foreach($f in $ordinate){
    $ggTot += $f.Gg
    $stima = ($secGiorno * $f.Gg)/3600.0
    Write-Host ("      {0,-9} {1} -> {2}   {3,5} giorni   stima ~{4} h   [{5}]" -f `
      $f.Nome,$f.Da,$f.A,$f.Gg,$stima.ToString("0.0",$INV),$f.File) -ForegroundColor White
  }
  $stimaTot = ($secGiorno * $ggTot)/3600.0
  Write-Host ("    TOTALE: " + $ggTot + " giorni  ->  stima ~" + $stimaTot.ToString("0.0",$INV) +
              " ore   (tetto parte 2: " + $OreMaxDuka.ToString("0.0",$INV) + " h)") -ForegroundColor Yellow
  [void]$Note.Add("PARTE 2: " + $ordinate.Count + " finestre, " + $ggTot + " giorni iterati, stima " +
                  $stimaTot.ToString("0.0",$INV) + " ore col ritmo misurato (" + $secGiorno.ToString("0.0",$INV) + " s/giorno).")

  foreach($f in $ordinate){
    $tr = Trascorse
    $stima = ($secGiorno * $f.Gg)/3600.0
    if($tr -ge $OreMax -or $tr -ge $OreMaxDuka){
      $x = NuovoPasso "P2" ("finestra " + $f.Nome)
      $x.Esito = "NON INIZIATA (tetto ore)"
      $x.Nota  = ("trascorse " + $tr.ToString("0.0",$INV) + " h")
      [void]$Problemi.Add("PARTE 2: finestra " + $f.Nome + " NON INIZIATA (tetto ore). Rilancia la stessa riga: la cache Dukascopy riprende da dove era.")
      ScriviStato
      continue
    }
    if(($tr + $stima) -gt ($OreMaxDuka + 2.0)){
      # non si ammazza mai un lavoro: quindi non si INIZIA un lavoro che,
      # col ritmo GIA' MISURATO, sfonderebbe il tetto di due ore piene.
      $x = NuovoPasso "P2" ("finestra " + $f.Nome)
      $x.Esito = "NON INIZIATA (non ci sta nel tetto)"
      $x.Nota  = ("stima " + $stima.ToString("0.0",$INV) + " h, trascorse " + $tr.ToString("0.0",$INV) + " h")
      [void]$Problemi.Add("PARTE 2: finestra " + $f.Nome + " NON INIZIATA: stimata " + $stima.ToString("0.0",$INV) +
                          " h, non ci sta nel tetto. Rilancia la stessa riga (la cache riprende).")
      ScriviStato
      continue
    }
    [void](ChiamaDuka ("R90 finestra " + $f.Nome) ("R90_" + $f.Tag) $f.Da $f.A (Join-Path $Work "dukascopy_m1.py"))
  }
}

# =====================================================================
#  LA PARTE 3, in una funzione, per lo stesso motivo.
# =====================================================================
function Parte3(){
  if($SoloDuka){ return }
  Titolo "PARTE 3 - R91 AL TESTER (l'unico round FIRMATO oggi)"

  if(Get-Process -Name "terminal64" -ErrorAction SilentlyContinue){
    $x = NuovoPasso "P3" "R91"
    $x.Esito = "NON ESEGUITA (MT5 aperto)"
    [void]$Problemi.Add("PARTE 3: MT5 risulta APERTO adesso (non lo era all'avvio). Non lancio il tester: uscirebbero 0 CSV. Non ammazzo il terminale, potrebbe essere Claudio.")
    ScriviStato
    return
  }
  if((Trascorse) -ge $OreMax){
    $x = NuovoPasso "P3" "R91"
    $x.Esito = "NON INIZIATA (tetto ore)"
    [void]$Problemi.Add("PARTE 3: tetto ore raggiunto prima di R91. R91 NON e' stato eseguito: rilancia con -SoloR91.")
    ScriviStato
    return
  }

  # --- 3.0 il driver AL PIN, e PINNATO (la cura del 20/08)
  $pd = NuovoPasso "P3" "driver al pin + PINNATO"
  $pd.Inizio = (Ora)
  $Driver = Join-Path $Work "walkforward_generico.ps1"
  Scarica ("$RawPin/backtest_pipeline/walkforward_generico.ps1") $Driver 'RigaSpread'
  # CURA DEFINITIVA (20/08): il driver ha $EABranch="lavoro" scritto fisso e
  # riscarica l'EA dalla PUNTA del branch, ignorando il pin. Qui lo si PINNA:
  # da adesso il driver scarica l'EA dallo STESSO commit dei file prova.
  $dTxt = Get-Content -LiteralPath $Driver -Raw
  $dNew = $dTxt -replace '\$EABranch\s*=\s*"lavoro"', ('$EABranch="' + $Pin + '"')
  if($dNew -eq $dTxt){ throw "non sono riuscito a pinnare EABranch nel driver: riga non trovata (il driver e' cambiato?)" }
  Set-Content -LiteralPath $Driver -Value $dNew -Encoding ASCII
  if(-not (Select-String -LiteralPath $Driver -SimpleMatch -Pattern ('$EABranch="' + $Pin + '"') -Quiet)){ throw "pin di EABranch non verificato nel driver" }
  Dico ("driver PINNATO al commit " + $Pin.Substring(0,7) + " (non piu' HEAD)") "Green"
  $pd.Fine = (Ora); $pd.Esito = "OK"
  ScriviStato

  # --- 3.0b i file prova al pin.
  #     ATTENZIONE: i file di R91 NON hanno la riga @SIMBOLO (hanno solo
  #     @PERIODO e @DAQUANDO): il marcatore da pretendere e' @DAQUANDO, e
  #     il simbolo lo passa la riga con -Simbolo. Nella riga sorella il
  #     marcatore era '@SIMBOLO' e qui avrebbe fatto fallire lo scarico.
  foreach($l in $LavR91){
    Scarica ("$RawPin/backtest_pipeline/prove/" + $l.Prova) (Join-Path $Prove $l.Prova) '@DAQUANDO'
  }
  Dico "3 file prova di R91 scaricati al pin (marcatore @DAQUANDO)" "Green"

  # --- 3.0c il sorgente: DEVE essere la v1.03 con InpMinRR
  $srcR91 = Join-Path $SrcDir ($EAR91 + ".mq5")
  Scarica ("$RawPin/mql5/Experts/" + $EAR91 + ".mq5") $srcR91 'OnTester'
  $sTxt = Get-Content -LiteralPath $srcR91 -Raw
  if($sTxt -notmatch 'input\s+double\s+InpMinRR'){
    throw ($EAR91 + ".mq5 al pin NON contiene l'input InpMinRR: non e' la v1.03. R91 non ha senso.")
  }
  Dico "ABTG_BreakingBand: InpMinRR presente (v1.03)" "Green"

  # --- 3.0d terminale e cartella dati, PER NOME (checklist 26.3)
  $tutti = @(Get-ChildItem "C:\Program Files","C:\Program Files (x86)" -Recurse -Filter "terminal64.exe" -ErrorAction SilentlyContinue)
  $cand  = @($tutti | Where-Object { $_.DirectoryName -like "*BCM Markets MT5 Terminal*" -and $_.DirectoryName -notlike "*-V3*" })
  if($cand.Count -eq 0){ throw "non trovo il terminale 'BCM Markets MT5 Terminal' (quello NON -V3). Non tiro a indovinare." }
  if($cand.Count -gt 1){ throw ("trovati " + $cand.Count + " terminali che corrispondono: ambiguo, mi fermo.") }
  $InstDir    = $cand[0].DirectoryName
  $Terminal   = Join-Path $InstDir "terminal64.exe"
  $MetaEditor = Join-Path $InstDir "metaeditor64.exe"
  if(-not (Test-Path -LiteralPath $MetaEditor)){ throw ("manca metaeditor64.exe in " + $InstDir) }
  $termRoot = Join-Path $env:APPDATA "MetaQuotes\Terminal"
  $DataFolder = Get-ChildItem $termRoot -Directory -ErrorAction SilentlyContinue | Where-Object {
      $o = Join-Path $_.FullName "origin.txt"
      (Test-Path $o) -and ((Get-Content $o -Raw).Trim() -ieq $InstDir)
    } | Select-Object -First 1 -ExpandProperty FullName
  if(-not $DataFolder){ throw "cartella dati MT5 non trovata (origin.txt non punta a nessuna cartella)." }
  $MqlExperts = Join-Path $DataFolder "MQL5\Experts"
  Dico ("terminale : " + $Terminal)
  Dico ("dati      : " + $DataFolder)

  # --- 3a. FASE COMPILA: .ex5 SCRITTO ADESSO + 0 errori nel log
  Titolo "3a. FASE COMPILA  (ABTG_BreakingBand v1.03)"
  $pcm = NuovoPasso "P3" "compila ABTG_BreakingBand"
  $pcm.Inizio = (Ora)
  $t0  = Get-Date
  $mq5 = Join-Path $MqlExperts ($EAR91 + ".mq5")
  $ex5 = Join-Path $MqlExperts ($EAR91 + ".ex5")
  $lg  = Join-Path $MqlExperts ($EAR91 + ".log")
  Copy-Item -LiteralPath $srcR91 -Destination $mq5 -Force
  Remove-Item -LiteralPath $ex5 -Force -ErrorAction SilentlyContinue
  Remove-Item -LiteralPath $lg  -Force -ErrorAction SilentlyContinue
  & $MetaEditor "/compile:$mq5" "/log" | Out-Null
  $errori = -1; $warn = -1
  if(Test-Path -LiteralPath $lg){
    $testo = ""
    try{ $testo = (Get-Content -LiteralPath $lg -Raw -Encoding Unicode) }catch{ $testo = "" }
    if($testo -notmatch 'error'){ try{ $testo = (Get-Content -LiteralPath $lg -Raw) }catch{} }
    $mm = [regex]::Match($testo,'(?i)(\d+)\s+error');   if($mm.Success){ $errori = [int]$mm.Groups[1].Value }
    $mw = [regex]::Match($testo,'(?i)(\d+)\s+warning'); if($mw.Success){ $warn   = [int]$mw.Groups[1].Value }
    try{ Copy-Item -LiteralPath $lg -Destination (Join-Path $CartR91 "compilazione_ABTG_BreakingBand.log") -Force }catch{}
  }
  $fresco = $false
  if(Test-Path -LiteralPath $ex5){ $fresco = ((Get-Item -LiteralPath $ex5).LastWriteTime -ge $t0) }
  $pcm.Fine = (Ora)
  if(-not ($fresco -and $errori -le 0)){
    $perche = "nessun .ex5 scritto adesso"
    if($fresco){ $perche = ($errori.ToString() + " errori nel log") }
    $pcm.Esito = "FALLITA"; $pcm.Nota = $perche
    [void]$Problemi.Add("R91: COMPILAZIONE FALLITA di " + $EAR91 + " (" + $perche + "). R91 esce dalla coda; le parti 1-2 restano valide.")
    Write-Host ("    !! COMPILAZIONE FALLITA: " + $perche) -ForegroundColor Red
    foreach($l in $LavR91){ $l.Esito = "ANNULLATO (compilazione fallita)" }
    ScriviStato
    return
  }
  $q = "0 errori nel log"; if($errori -lt 0){ $q = "log non leggibile, .ex5 fresco" }
  $pcm.Esito = "OK"; $pcm.Nota = ($q + $(if($warn -ge 0){ ", " + $warn + " warning" }else{ "" }))
  Dico ("COMPILATO " + $EAR91 + "  (" + $pcm.Nota + ")") "Green"
  if($warn -gt 0){ [void]$Note.Add("R91: la compilazione ha " + $warn + " warning (0 errori). I criteri chiedevano 0 e 0: DICHIARATO.") }
  ScriviStato

  # --- 3b/3c. i tre file, uno alla volta, con la SANITA' subito dopo
  $Risultati = Join-Path $Work ("risultati_prove\" + $EAR91)
  $idx = 0
  foreach($l in $LavR91){
    $idx++
    if((Trascorse) -ge $OreMax){
      $l.Esito = "NON INIZIATO (tetto ore)"
      [void]$Problemi.Add("R91 / " + $l.Prova + ": tetto ore raggiunto, NON eseguito. Il round NON e' completo.")
      ScriviStato
      continue
    }
    if($l.Esito -like "ANNULLATO*"){ continue }
    $pl = NuovoPasso "P3" ($l.Prova)
    $pl.Inizio = (Ora)
    $t1 = Get-Date
    Write-Host ""
    Write-Host "------------------------------------------------------------------" -ForegroundColor Cyan
    Write-Host ("  R91 [" + $idx + "/3]  " + $l.Prova + "   (" + $l.Sym + " / " + ($l.Att*2) + " passate / deposito " + $l.Dep + " / etichetta " + $l.Et + ")") -ForegroundColor Cyan
    Write-Host ("  ore " + (Ora) + "   trascorse " + (Trascorse).ToString("0.0",$INV) + " h su " + $OreMax.ToString("0.0",$INV)) -ForegroundColor DarkGray
    Write-Host "------------------------------------------------------------------" -ForegroundColor Cyan

    $arg = @("-ExecutionPolicy","Bypass","-File",$Driver,
             "-Expert",$EAR91,"-Prova",(Join-Path $Prove $l.Prova),
             "-Simbolo",$l.Sym,"-Etichetta",$l.Et,"-Modello","4",
             "-Deposito",("" + $l.Dep))
    if($Rifai){ $arg += "-Rifai" }
    if($SoloControllo){ $arg += "-SoloControllo" }
    $jl = Join-Path $Logs ($l.Et + ".txt")
    $rc = EseguiNativo "powershell.exe" $arg $jl

    $csvIS  = Join-Path $Risultati ($EAR91 + "_" + $l.Sym + "_IS_"  + $l.Et + ".csv")
    $csvOOS = Join-Path $Risultati ($EAR91 + "_" + $l.Sym + "_OOS_" + $l.Et + ".csv")
    $l.IS  = $(if(Test-Path -LiteralPath $csvIS ){ (@(Get-Content -LiteralPath $csvIS ).Count - 1) }else{ -1 })
    $l.OOS = $(if(Test-Path -LiteralPath $csvOOS){ (@(Get-Content -LiteralPath $csvOOS).Count - 1) }else{ -1 })
    $l.Min = [math]::Round((New-TimeSpan -Start $t1 -End (Get-Date)).TotalMinutes,1)
    $pl.Fine = (Ora); $pl.Min = $l.Min

    if($SoloControllo){
      $ant = Join-Path $Work ("anteprima_" + $EAR91 + "_" + $l.Sym + ".ini")
      $antOk = $false
      if(Test-Path -LiteralPath $ant){ $antOk = ((Get-Item -LiteralPath $ant).LastWriteTime -ge $t1) }
      if($rc -eq 0 -and $antOk){ $l.Esito = "OK (giro a vuoto)" }
      else{
        $l.Esito = "GIRO A VUOTO FALLITO (rc " + $rc + ", anteprima " + $antOk + ")"
        [void]$Problemi.Add("R91: giro a vuoto FALLITO su " + $l.Prova + " (rc " + $rc + ", anteprima fresca: " + $antOk + ")")
      }
    }
    elseif($rc -ne 0){
      $l.Esito = "FALLITO (rc " + $rc + ")"
      [void]$Problemi.Add("R91 / " + $l.Prova + ": driver uscito con codice " + $rc)
    }
    elseif($l.IS -lt 0 -or $l.OOS -lt 0){
      $l.Esito = "CSV MANCANTE"
      [void]$Problemi.Add("R91 / " + $l.Prova + ": manca un CSV (IS=" + $l.IS + " OOS=" + $l.OOS + ")")
    }
    elseif($l.IS -ne $l.Att -or $l.OOS -ne $l.Att){
      $l.Esito = "RIGHE DIVERSE DALLE ATTESE"
      [void]$Problemi.Add("R91 / " + $l.Prova + ": attese " + $l.Att + " righe per finestra, ottenute IS=" + $l.IS + " OOS=" + $l.OOS + " (cache del tester? celle mute?)")
    }
    else{ $l.Esito = "OK" }
    $pl.Esito = $l.Esito
    $pl.Nota  = ("IS=" + $l.IS + " OOS=" + $l.OOS + " attese=" + $l.Att)
    Dico ("R91 [" + $idx + "/3] " + $l.Prova + " -> " + $l.Esito + "   " + $l.Min.ToString("0.0",$INV) + " min") $(if($l.Esito -like "OK*"){"Green"}else{"Yellow"})

    # copia SUBITO i CSV nella cartella di raccolta: nome proprio, gia' al sicuro
    foreach($c in @($csvIS,$csvOOS)){
      if(Test-Path -LiteralPath $c){ try{ Copy-Item -LiteralPath $c -Destination (Join-Path $CartR91 (Split-Path -Leaf $c)) -Force }catch{} }
    }
    ScriviStato

    # ---------------- LA RIGA DI SANITA' (R91_CRITERI.md par. 4.0) -------------
    if(-not $SoloControllo -and (Test-Path -LiteralPath $csvOOS)){
      Titolo ("3c. RIGA DI SANITA' - " + $l.Sym + "  (la cella InpMinRR=0 deve riprodurre R34)")
      # checklist 23: l'artefatto STANTIO. Senza -Rifai il driver SALTA la finestra
      # se il CSV c'e' gia': la sanita' girerebbe su numeri di un'altra corsa e
      # passerebbe senza aver provato niente. Si guarda la data, sempre.
      if((Get-Item -LiteralPath $csvOOS).LastWriteTime -lt $t1){
        [void]$Note.Add("R91 " + $l.Sym + ": il CSV OOS NON e' stato prodotto adesso (riuso di una corsa precedente). La sanita' e' girata su quello: DICHIARATO. Con -Rifai si rifa' davvero.")
        Write-Host "    ATTENZIONE: CSV OOS preesistente, non prodotto adesso (vedi note del referto)." -ForegroundColor Yellow
      }
      $rows = @(Import-Csv -LiteralPath $csvOOS)
      $cols = @($rows | Get-Member -MemberType NoteProperty | ForEach-Object { $_.Name })
      $manca = @()
      foreach($c in @("Profit","Profit Factor","Equity DD %","Trades","InpMinRR")){ if($cols -notcontains $c){ $manca += $c } }
      if($manca.Count -gt 0){
        $l.Sanita = "IMPOSSIBILE (colonne mancanti: " + ($manca -join ", ") + ")"
        [void]$Problemi.Add("R91 " + $l.Sym + ": SANITA' IMPOSSIBILE, nel CSV OOS mancano le colonne " + ($manca -join ", "))
      } else {
        $base = @($rows | Where-Object { (Num $_.InpMinRR) -eq 0 })
        if($base.Count -eq 0){
          $l.Sanita = "IMPOSSIBILE (nessuna riga con InpMinRR=0)"
          [void]$Problemi.Add("R91 " + $l.Sym + ": SANITA' IMPOSSIBILE, nel CSV OOS non c'e' nessuna riga con InpMinRR=0.")
        } else {
          $vP=(Num $base[0].Profit); $vF=(Num $base[0].'Profit Factor'); $vD=(Num $base[0].'Equity DD %'); $vT=(Num $base[0].Trades)
          $dP=[math]::Abs($vP-$l.RifP); $dF=[math]::Abs($vF-$l.RifF); $dD=[math]::Abs($vD-$l.RifD)
          Write-Host ("    riferimento R91_CRITERI 4.0 : Profit " + $l.RifP.ToString("0.00",$INV) + "   PF " + $l.RifF.ToString("0.00000",$INV) +
                      "   DD " + $l.RifD.ToString("0.0000",$INV) + "   n " + $l.RifT) -ForegroundColor Gray
          Write-Host ("    misurato ora                : Profit " + $vP.ToString("0.00",$INV) + "   PF " + $vF.ToString("0.00000",$INV) +
                      "   DD " + $vD.ToString("0.0000",$INV) + "   n " + [int]$vT) -ForegroundColor White
          # TOLLERANZA DICHIARATA, a due gradini (lo stesso schema che ha
          # validato R88 la notte scorsa). Non si BLOCCA sul gradino fine:
          # un ultimo decimale ballerino fermerebbe l'unico round firmato
          # per un arrotondamento, e sarebbe un cancello sbagliato.
          #   STRETTO : Profit +/-0,01  PF +/-0,00005  DD +/-0,00005  n esatto
          #   LARGO   : Profit +/-0,01  PF +/-0,005    DD +/-0,005    n esatto
          # Si ferma R91 solo se salta il LARGO. Se passa il largo ma non lo
          # stretto, si PROSEGUE e lo si SCRIVE nel referto.
          $okStretto = ($dP -le 0.01 -and $dF -le 0.00005 -and $dD -le 0.00005 -and [int]$vT -eq $l.RifT)
          $okLargo   = ($dP -le 0.01 -and $dF -le 0.005   -and $dD -le 0.005   -and [int]$vT -eq $l.RifT)
          if($okLargo){
            if($okStretto){
              $l.Sanita = "OK"
              Dico ("SANITA' OK su " + $l.Sym + ": InpMinRR=0 e' un no-op, il round e' leggibile.") "Green"
            } else {
              $l.Sanita = "OK (2 dec)"
              Dico ("SANITA' OK ai 2 decimali su " + $l.Sym + " ma NON ai 5: DICHIARATO, si prosegue.") "Yellow"
              [void]$Note.Add("SANITA' " + $l.Sym + ": dentro la tolleranza larga ma non quella stretta (dProfit=" +
                              $dP.ToString("0.0000",$INV) + " dPF=" + $dF.ToString("0.000000",$INV) +
                              " dDD=" + $dD.ToString("0.000000",$INV) + "). Dichiarato.")
            }
          } else {
            $l.Sanita = "FALLITA"
            $msg = ("SANITA' FALLITA su " + $l.Sym + ": la cella InpMinRR=0 NON riproduce R34.`n" +
                    "    atteso   Profit " + $l.RifP.ToString("0.00",$INV) + "  PF " + $l.RifF.ToString("0.00000",$INV) +
                    "  DD " + $l.RifD.ToString("0.0000",$INV) + "  n " + $l.RifT + "`n" +
                    "    ottenuto Profit " + $vP.ToString("0.00",$INV) + "  PF " + $vF.ToString("0.00000",$INV) +
                    "  DD " + $vD.ToString("0.0000",$INV) + "  n " + [int]$vT + "`n" +
                    "    InpMinRR=0 NON e' un no-op, oppure e' cambiato altro: R91 NON VALE.")
            Write-Host ""
            Write-Host ("!!! " + $msg) -ForegroundColor Red
            [void]$Problemi.Add($msg)
            if(-not $ProsegueDopoSanita){
              foreach($x in $LavR91){ if($x.Esito -eq "NON ESEGUITO"){ $x.Esito = "ANNULLATO (sanita' fallita su " + $l.Sym + ")" } }
              Write-Host "    R91 SI FERMA QUI (regola dei criteri 4.0). Le parti 1-2 restano valide." -ForegroundColor Red
              Write-Host "    Per proseguire lo stesso: -ProsegueDopoSanita (ma R91 NON VALE)." -ForegroundColor Yellow
              ScriviStato
              break
            }
          }
        }
      }
      ScriviStato
    }
  }

  # --- 3d. IL LOG DEL TESTER DELLA CELLA InpMinRR=0 (la distribuzione del RR)
  #     PERCHE' un passo in piu': in OTTIMIZZAZIONE MT5 non esegue le Print
  #     degli agent, e il driver gira SEMPRE con Optimization=1. Senza questa
  #     passata singola il log del RR NON ESISTE, per costruzione.
  if($SaltaLogRR -or $SoloControllo){
    [void]$Note.Add("3d (log del RR) saltata su richiesta.")
  } else {
    Titolo "3d. IL LOG DEL TESTER DELLA CELLA InpMinRR=0 (passata SINGOLA, per il RR)"
    foreach($l in $LavR91){
      if($l.Esito -notlike "OK*"){ continue }
      if((Trascorse) -ge $OreMax){ [void]$Problemi.Add("3d: tetto ore, log del RR non prodotto per " + $l.Sym); break }
      $pr = NuovoPasso "P3d" ("log RR " + $l.Sym)
      $pr.Inizio = (Ora)
      $t2 = Get-Date
      $iniOrig = Join-Path $Work ("gen_" + $EAR91 + "_" + $l.Sym + "_OOS_" + $l.Et + ".ini")
      if(-not (Test-Path -LiteralPath $iniOrig)){
        $pr.Esito = "IMPOSSIBILE"; $pr.Nota = "manca " + (Split-Path -Leaf $iniOrig)
        [void]$Problemi.Add("3d " + $l.Sym + ": non trovo l'.ini generato dal driver (" + (Split-Path -Leaf $iniOrig) +
                            "): niente log del RR. Causa piu' probabile: il driver ha SALTATO la finestra perche' il CSV c'era gia' (rilancia con -Rifai).")
        $pr.Fine=(Ora); ScriviStato; continue
      }
      $txt = Get-Content -LiteralPath $iniOrig -Raw
      # una sola passata, cella InpMinRR=0 pinnata secca in forma completa
      $txt = $txt -replace '(?m)^Optimization=1\s*$', 'Optimization=0'
      $txt = $txt -replace '(?m)^Report=.*$', ('Report=SingleReport_' + $EAR91 + '_' + $l.Sym + '_rr0')
      $txt = $txt -replace '(?m)^InpMinRR=.*$', 'InpMinRR=0||0||0||0||N'
      if($txt -notmatch '(?m)^Optimization=0\s*$'){ [void]$Note.Add("3d " + $l.Sym + ": non ho trovato la riga Optimization=1 da spegnere.") }
      $iniSing = Join-Path $Work ("single_" + $EAR91 + "_" + $l.Sym + "_rr0.ini")
      Set-Content -LiteralPath $iniSing -Value $txt -Encoding ASCII
      Dico ("passata singola " + $l.Sym + " (OOS, InpMinRR=0): avvio MT5...") "Gray"
      (Start-Process -FilePath $Terminal -ArgumentList ("/config:`"" + $iniSing + "`"") -PassThru).WaitForExit()

      # raccolta dei log SCRITTI ADESSO (tester + agent, ovunque stiano)
      $radici = @((Join-Path $DataFolder "Tester"), (Join-Path $InstDir "Tester"), (Join-Path $env:APPDATA "MetaQuotes\Tester"))
      $presi = 0; $rr = New-Object System.Collections.ArrayList
      foreach($r in $radici){
        if(-not (Test-Path -LiteralPath $r)){ continue }
        $files = @(Get-ChildItem -LiteralPath $r -Recurse -Filter "*.log" -ErrorAction SilentlyContinue |
                   Where-Object { $_.LastWriteTime -ge $t2 -and $_.Length -gt 0 -and $_.Length -lt 60MB })
        foreach($f in $files){
          $t = ""
          try{ $t = Get-Content -LiteralPath $f.FullName -Raw -Encoding UTF8 }catch{}
          if($t -notmatch '\[BB\]'){ try{ $t2b = Get-Content -LiteralPath $f.FullName -Raw -Encoding Unicode }catch{ $t2b="" }
                                     if($t2b -match '\[BB\]'){ $t = $t2b } }
          if($t -eq ""){ continue }
          if($t -match '\[BB\]' -or $t -match 'BB-FUNNEL'){
            $nonno = "x"
            if($f.Directory -and $f.Directory.Parent){ $nonno = $f.Directory.Parent.Name }
            $dest = Join-Path $CartLog ($l.Sym + "_" + $nonno + "_" + $f.Directory.Name + "_" + $f.Name)
            try{ Set-Content -LiteralPath $dest -Value $t -Encoding UTF8; $presi++ }catch{}
            foreach($m in [regex]::Matches($t,'(?m)^.*\[BB\]\s+(CONTINUAZIONE|INVERSIONE).*?RR\s+([0-9]+\.[0-9]+).*$')){
              [void]$rr.Add($m.Groups[2].Value)
            }
          }
        }
      }
      $pr.Fine = (Ora); $pr.Min = [math]::Round((New-TimeSpan -Start $t2 -End (Get-Date)).TotalMinutes,1)
      if($presi -eq 0){
        $pr.Esito = "NESSUN LOG CON [BB]"
        [void]$Problemi.Add("3d " + $l.Sym + ": nessun log del tester con righe [BB] scritte adesso. La distribuzione del RR NON e' stata raccolta (InpVerbose spento? Print soppresse?).")
      } else {
        $pr.Esito = "OK"; $pr.Nota = ($presi + " log, " + $rr.Count + " RR estratti")
        $out = New-Object System.Collections.ArrayList
        [void]$out.Add("DISTRIBUZIONE DEL RR ALL'INGRESSO  --  " + $l.Sym + "  (cella InpMinRR=0, finestra OOS)")
        [void]$out.Add("da: passata SINGOLA (Optimization=0) sullo stesso .ini della finestra OOS del round.")
        [void]$out.Add("data: " + (Get-Date).ToString("yyyy-MM-dd HH:mm:ss",$INV))
        [void]$out.Add("ingressi con RR loggato: " + $rr.Count + "   (atteso ~ n del CSV OOS = " + $l.RifT + ")")
        [void]$out.Add("")
        if($rr.Count -gt 0){
          $vals = @($rr | ForEach-Object { Num $_ } | Sort-Object)
          [void]$out.Add("min " + $vals[0].ToString("0.000",$INV) +
                         "   centrale " + $vals[[int]([math]::Floor($vals.Count/2))].ToString("0.000",$INV) +
                         "   max " + $vals[$vals.Count-1].ToString("0.000",$INV))
          foreach($s in @(0.5,1.0,1.5)){
            $sotto = @($vals | Where-Object { $_ -lt $s }).Count
            [void]$out.Add(("sotto " + $s.ToString("0.0",$INV) + ": " + $sotto + " su " + $vals.Count +
                            "  (= i trade che InpMinRR=" + $s.ToString("0.0",$INV) + " avrebbe TAGLIATO)"))
          }
          [void]$out.Add("")
          [void]$out.Add("--- tutti i valori, ordinati ---")
          foreach($v in $vals){ [void]$out.Add($v.ToString("0.000",$INV)) }
        }
        [void]$out.Add("")
        [void]$out.Add("NON E' UN VERDETTO: e' il conteggio grezzo. Il cancello A1 dei criteri si")
        [void]$out.Add("legge sui CSV (aspettativa dei trade tagliati), non su questa lista.")
        Set-Content -LiteralPath (Join-Path $CartLog ("RR_distribuzione_" + $l.Sym + ".txt")) -Value $out -Encoding ASCII
        Dico ("log RR " + $l.Sym + ": " + $presi + " log raccolti, " + $rr.Count + " RR estratti") "Green"
      }
      ScriviStato
    }
  }
}

# =====================================================================
#  L'ORDINE. Di default quello della missione: 1 -> 2 -> 3.
# =====================================================================
if($PrimaR91){
  try{ Parte3 }catch{ Fallita "PARTE 3 (R91)" $_.Exception.Message }
  try{ Parte2 }catch{ Fallita "PARTE 2 (download lungo)" $_.Exception.Message }
} else {
  try{ Parte2 }catch{ Fallita "PARTE 2 (download lungo)" $_.Exception.Message }
  try{ Parte3 }catch{ Fallita "PARTE 3 (R91)" $_.Exception.Message }
}

}catch{
  $Fatale = $_.Exception.Message
  Write-Host ""
  Write-Host "#####################################################################" -ForegroundColor Red
  Write-Host "!!! LA NOTTE SI E' FERMATA DA SOLA" -ForegroundColor Red
  Write-Host $Fatale -ForegroundColor Red
  Write-Host "#####################################################################" -ForegroundColor Red
  [void]$Problemi.Add("STOP: " + $Fatale)
}

# =====================================================================
#  RACCOLTA E REFERTO. Si fanno SEMPRE, anche a esito parziale o fermato.
# =====================================================================
Titolo "RACCOLTA SUL DESKTOP"
try{
  New-Item -ItemType Directory -Force -Path $Cart,$CartDuk,$CartR91,$CartLog | Out-Null

  # lo zip che dukascopy_m1.py si fa da solo sul Desktop e' quello dell'ULTIMA
  # chiamata e SOLO di quella: se resta li', Claudio rischia di mandare la foto
  # sbagliata (checklist 26). Lo si toglie di mezzo, senza distruggerlo.
  $Sgombero = Join-Path $Work "_raccolta_automatica_ultima_chiamata"
  New-Item -ItemType Directory -Force -Path $Sgombero | Out-Null
  foreach($auto in @((Join-Path $Dsk "dukascopy_m1.zip"), (Join-Path $Dsk "dukascopy_m1"))){
    if(Test-Path -LiteralPath $auto){
      try{
        Move-Item -LiteralPath $auto -Destination (Join-Path $Sgombero (Split-Path -Leaf $auto)) -Force
        [void]$Note.Add("tolto dal Desktop " + (Split-Path -Leaf $auto) + " (raccolta automatica dello strumento: contiene SOLO l'ultima chiamata). Sta in " + $Sgombero + ", non nello zip.")
      }
      catch{ [void]$Note.Add("non ho potuto spostare " + $auto + ": NON mandarlo, contiene solo l'ULTIMA chiamata.") }
    }
  }

  Remove-Item -LiteralPath $Referto -Force -ErrorAction SilentlyContinue
  $R = New-Object System.Collections.ArrayList
  [void]$R.Add("REFERTO DELLA NOTTE #2  --  DUKASCOPY (canarino R90) + R91 al tester")
  [void]$R.Add("data: " + (Get-Date).ToString("yyyy-MM-dd HH:mm:ss",$INV) + "   (questa data deve essere di ADESSO)")
  [void]$R.Add("avvio: " + $Avvio.ToString("yyyy-MM-dd HH:mm:ss",$INV))
  [void]$R.Add("durata: " + (Trascorse).ToString("0.00",$INV) + " ore   (tetti: notte " + $OreMax.ToString("0.0",$INV) +
               " h, parte 2 " + $OreMaxDuka.ToString("0.0",$INV) + " h)")
  [void]$R.Add("pin: " + $Pin)
  [void]$R.Add("python: " + $(if($Python){ $Python }else{ "NON TROVATO" }))
  [void]$R.Add("")
  [void]$R.Add("=== IL CANARINO DI R90 (parte 1) ===")
  [void]$R.Add("  1 giorno di Dow 2025-06-16 : " + $(if($Sec2025 -ge 0){ $Sec2025.ToString("0.0",$INV) + " s" }else{ "NON MISURATO" }))
  [void]$R.Add("  1 giorno di Dow 2015-06-15 : " + $(if($Sec2015 -ge 0){ $Sec2015.ToString("0.0",$INV) + " s" }else{ "NON MISURATO" }))
  [void]$R.Add("  proiezione = secondi(2025) x 2505 / 3600 = " + $(if($Proiezione -ge 0){ $Proiezione.ToString("0.0",$INV) + " ore" }else{ "NON CALCOLABILE" }))
  [void]$R.Add("  soglia decisa PRIMA: " + $SogliaCanarinoOre.ToString("0.0",$INV) + " ore")
  [void]$R.Add("  >>> " + $RigaCanarino)
  [void]$R.Add("")
  [void]$R.Add("  2505 = i giorni che dukascopy_m1.py ITERA su 8 anni (tutti tranne il sabato:")
  [void]$R.Add("  2922 giorni - 417 sabati = 2505). Il tempo di un giorno COMPRENDE il controllo")
  [void]$R.Add("  positivo EURUSD, che si paga una volta per corsa: la proiezione e' quindi")
  [void]$R.Add("  CONSERVATIVA (sovrastima). E' una STIMA, non una misura.")
  [void]$R.Add("")
  [void]$R.Add("=== I PASSI, IN ORDINE ===")
  [void]$R.Add(("{0,-6} {1,-34} {2,-9} {3,-9} {4,-8} {5}" -f "FASE","PASSO","INIZIO","FINE","MIN","ESITO"))
  foreach($p in $Passi){
    [void]$R.Add(("{0,-6} {1,-34} {2,-9} {3,-9} {4,-8} {5}" -f `
      $p.Fase,$p.Nome,$p.Inizio,$p.Fine,$p.Min.ToString("0.0",$INV),($p.Esito + $(if($p.Nota -ne ""){ "  -- " + $p.Nota }else{ "" }))))
  }
  [void]$R.Add("")
  [void]$R.Add("=== R91 (parte 3) ===")
  [void]$R.Add(("{0,-24} {1,-8} {2,-7} {3,-5} {4,-5} {5,-10} {6}" -f "FILE","SIMBOLO","ETICH","IS","OOS","SANITA'","ESITO"))
  foreach($l in $LavR91){
    [void]$R.Add(("{0,-24} {1,-8} {2,-7} {3,-5} {4,-5} {5,-10} {6}" -f `
      $l.Prova,$l.Sym,$l.Et,$l.IS,$l.OOS,$l.Sanita,($l.Esito + " [" + $l.Min.ToString("0.0",$INV) + " min]")))
  }
  [void]$R.Add("")
  [void]$R.Add("  IS/OOS = righe vere nel CSV (attese 4 per finestra: InpMinRR 0 / 0,5 / 1,0 / 1,5).")
  [void]$R.Add("  SANITA' = la cella InpMinRR=0 riproduce R91_CRITERI.md par. 4.0? Se FALLITA,")
  [void]$R.Add("  R91 NON VALE: l'input nuovo non e' un no-op e i numeri non si leggono.")
  [void]$R.Add("")
  [void]$R.Add("=== NOTE DICHIARATE ===")
  if($Note.Count -eq 0){ [void]$R.Add("  (nessuna)") }
  foreach($n in $Note){ [void]$R.Add("  - " + $n) }
  [void]$R.Add("")
  [void]$R.Add("=== PROBLEMI ===")
  if($Problemi.Count -eq 0){ [void]$R.Add("  (nessuno)") }
  foreach($p in $Problemi){ [void]$R.Add("  - " + $p) }
  [void]$R.Add("")
  [void]$R.Add("=== COSA NON E' STATO FATTO, DICHIARATO ===")
  [void]$R.Add("  - i CSV Dukascopy NON sono stati importati in MT5 e U30USD_EXT NON esiste:")
  [void]$R.Add("    l'import vuole shift +5 misurato e canarino di riproduzione, non si fa di notte.")
  [void]$R.Add("  - nessun numero di R90/R91 e' stato GIUDICATO qui dentro: si contano righe.")
  [void]$R.Add("  - il log del RR viene da una passata SINGOLA (Optimization=0): stessa cella,")
  [void]$R.Add("    stessa finestra OOS, ma NON e' la passata che ha scritto il CSV.")
  [void]$R.Add("")
  $koR91 = @($LavR91 | Where-Object { $_.Esito -notlike "OK*" })
  if($Fatale -ne ""){ [void]$R.Add("ESITO: FERMATO -- " + $Fatale) }
  elseif($Problemi.Count -gt 0){ [void]$R.Add("ESITO: PARZIALE -- ci sono " + $Problemi.Count + " problemi da leggere qui sopra.") }
  else{ [void]$R.Add("ESITO: OK -- tutti i passi in coda hanno prodotto gli artefatti attesi.") }
  Set-Content -LiteralPath $Referto -Value $R -Encoding ASCII

  ScriviStato
  try{ Copy-Item -LiteralPath $StatoFile -Destination (Join-Path $Cart "STATO_NOTTE2.txt") -Force }catch{}

  $zip = Join-Path $Dsk ("NOTTE2_" + $Stamp + ".zip")
  Remove-Item -LiteralPath $zip -Force -ErrorAction SilentlyContinue
  Compress-Archive -Path (Join-Path $Cart "*") -DestinationPath $zip -Force
  Dico ("zip pronto: " + $zip) "Green"
}catch{
  Write-Host ("!! raccolta incompleta: " + $_.Exception.Message) -ForegroundColor Red
  [void]$Problemi.Add("raccolta: " + $_.Exception.Message)
}

# =====================================================================
#  COSA DEVE VEDERE CLAUDIO SULLO SCHERMO
# =====================================================================
Write-Host ""
Write-Host "=====================================================================" -ForegroundColor White
Write-Host "  FINITO. File da verificare, uno per uno:" -ForegroundColor White
Write-Host ("   " + $Cart) -ForegroundColor White
Write-Host ("     duka\      referto_*.txt  console_*.txt  U30USD_M1_*.csv") -ForegroundColor Gray
Write-Host ("     r91\       ABTG_BreakingBand_*_IS/OOS_r91a|b|c.csv + il log di compilazione") -ForegroundColor Gray
Write-Host ("     log_tester\ i log del tester + RR_distribuzione_*.txt") -ForegroundColor Gray
Write-Host ("   " + (Join-Path $Dsk ("NOTTE2_" + $Stamp + ".zip")) + "   <- QUESTO si manda in chat") -ForegroundColor White
Write-Host ("   " + $StatoFile + "   <- la riga 'data:' deve essere di ADESSO") -ForegroundColor White
Write-Host "=====================================================================" -ForegroundColor White
Write-Host ("  CANARINO R90: " + $Canarino) -ForegroundColor $(if($Canarino -like "VERDE*"){"Green"}else{"Red"})
Write-Host ("  " + $RigaCanarino) -ForegroundColor $(if($Canarino -like "VERDE*"){"Green"}else{"Red"})
Write-Host ""
foreach($p in $Passi){
  $c = "Green"; if($p.Esito -notlike "OK*"){ $c = "Yellow" }
  Write-Host ("   " + $p.Fase.PadRight(5) + " " + $p.Nome.PadRight(34) + " " + $p.Esito) -ForegroundColor $c
}
if($Problemi.Count -gt 0){
  Write-Host ""
  Write-Host "   PROBLEMI DA LEGGERE:" -ForegroundColor Red
  foreach($p in $Problemi){ Write-Host ("    - " + $p) -ForegroundColor Red }
}
Write-Host ""
Write-Host "  MANDA LO ZIP COMUNQUE. 'PARZIALE' non vuol dire corsa fallita: un CANARINO" -ForegroundColor Yellow
Write-Host "  ROSSO e' gia' una RISPOSTA (la piu' importante della notte), e una sanita'" -ForegroundColor Yellow
Write-Host "  fallita e' un fatto da leggere, non un errore da nascondere." -ForegroundColor Yellow
Write-Host ""
if($Fatale -ne ""){ Write-Host "ESITO: FERMATO" -ForegroundColor Red; exit 1 }
if($Problemi.Count -gt 0){ Write-Host ("ESITO: PARZIALE (" + $Problemi.Count + " problemi)") -ForegroundColor Yellow; exit 1 }
Write-Host "ESITO: OK" -ForegroundColor Green
exit 0
