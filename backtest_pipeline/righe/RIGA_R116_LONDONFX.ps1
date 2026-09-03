# =====================================================================
#  MARCATORE_RIGA_R116_LONDONFX_v1
#  RIGA_R116_LONDONFX.ps1 -- ROUND R116: ABTG_LondonFx a TICK REALI
#  (Modello 4) su M15, EURUSD + GBPUSD, UN simbolo per giro (-Simbolo).
#  Criteri FIRMATI il 03/09/2026 ~09:45 ("FIRMO TUTTO, ANCHE LA A SU F5"):
#    backtest_pipeline\risultati_archivio\LONDONFX_TICK_CRITERI.md
#  Prova principale: prove\LONDONFX_R116_TICK.txt (3 motori x 2 magic)
#  Prova FASE 2:     prove\LONDONFX_R116_FASE2_SLIPPAGE.txt (slip 2/5)
#  Finestra 2024.07.05 (pavimento TICK misurato il 01/09) -> 2026.06.30,
#  split 40/60 come lo calcola il generico. Rischio 0,65%, ora 8 SERVER.
# ---------------------------------------------------------------------
#  COSA FA, IN ORDINE (ogni passo timbra il SUO campo del referto PRIMA
#  di poter fermarsi: classe 94-ter -- gli stati sono tanti quanti i rami):
#   0. guardie: -Pin 40-hex obbligatorio, whitelist EURUSD/GBPUSD, MT5 e
#      MetaEditor CHIUSI, sentinella di un giro precedente interrotto;
#   1. scarico AL PIN: generico (pinnato con replace di $EABranch), i 2
#      prova, l'EA .mq5, l'include ABTG_PausaGuardian.mqh (censito dal
#      sorgente, non indovinato);
#   2. gate sul sorgente: #property version "1.01" (ancorato), i due
#      #define dell'autotest (18 blocchi / 118 casi, ancorati -- v1.01,
#      commit 35c940e: export per-trade + blocco 18), InpMagic
#      default 774001, hedge-safe (zero PositionSelect(_Symbol) fuori dai
#      commenti), la guardia ABTG_GuardiaIngresso( nell'include (ancorata
#      a destra, classe 116-ter);
#   3. gate sui due prova: direttive nude (@SIMBOLO = il LEAD anche nella
#      corsa GBPUSD), assi esatti, celle ricontate dai pin ||Y, fissi
#      nome per nome, gemellaggio principale/fase 2 (SOLO le 3 differenze
#      dichiarate);
#   4. terminale BCM di backtest (non -V3) + cartella dati da origin.txt;
#      -Terminale come manopola (classe 115), elenco stampato se non unico;
#   5. FOTO PRIMA dei 3 file del terminale (Experts\.mq5, .ex5,
#      Include\.mqh), SENTINELLA scritta PRIMA di toccare il terminale
#      (classe 116), include installato con backup, EA copiato e
#      COMPILATO con metaeditor64 diretto, .ex5 vecchio cancellato prima,
#      log letto qualunque sia la codifica (Result: N errors);
#   6. Tester\cache svuotata (SOLO quella, mai bases\ticks: classe 38),
#      log del tester FOTOGRAFATI (5 radici) per leggere solo cio' che cresce;
#   7. CORSA PRINCIPALE col generico (-Rifai SEMPRE, Modello 4, Spread 0
#      dichiarato, deposito 100000): 6 celle x 2 finestre. CSV DATATI
#      prima di leggerli (piu' vecchi dell'avvio della corsa = NON LETTI);
#   8. collaudi sulle colonne (autotest 0/18/118, Canarino Torna, notti 0,
#      eco dei fissi), GEMELLI identici per motore e finestra, cancelli
#      A/B con le fasce disgiunte dei criteri, ablazione S1/S2/S3,
#      dichiarazioni del canarino (tetto > 20%, flat > 40%);
#   9. FASE 2 (slippage 2/5, solo motore 2) SOLO se il motore 2 passa
#      TUTTI i cancelli A su questa gamba -- oppure forzata con -SoloFase2;
#  10. log del tester letti (righe "ticks data begins from", "no memory",
#      "generat"), Model=4 letto dall'.ini VERO del generico;
#  RIPRISTINO -- SEMPRE, anche nel giro morto a meta': include del
#      terminale rimesso com'era (backup) o rimosso, sentinella tolta,
#      FOTO DOPO dei 3 file. L'EA (.mq5/.ex5) RESTA in MQL5\Experts come
#      ogni EA della pipeline (il tester lo richiede): dichiarato nel
#      referto con la foto, non nascosto.
#  RACCOLTA -- SEMPRE: cartella + zip sul Desktop VERO (GetFolderPath,
#      poi %USERPROFILE%\Desktop, poi OneDrive\Desktop: classe 116-bis),
#      referto + CSV + ini veri + log + prova. Exit 0 / 1, e la riga di
#      chat legge il codice a TRE stati (classe 108).
# ---------------------------------------------------------------------
#  LE SCELTE CHE I CRITERI NON FISSAVANO (clausola SEVERA, dichiarate):
#   - GEMELLI: asse InpMagic nel prova principale (pattern di casa
#     R103/R115/CRT): 3 coppie per finestra invece delle "2 passate" dei
#     criteri. 24 passate a tick invece di 14 (+4 a gamba se fase 2).
#   - FASE 2 automatica: la decide il driver dal CSV OOS con le
#     disuguaglianze ricopiate; -SoloFase2 la forza (misura di
#     fragilita', non puo' promuovere).
#   - Deposito 100000 (taglia prop, come la sonda del passo 0).
#   - Spread=0 nell'.ini (spread corrente DICHIARATO, R84-bis).
#   - Modello letto dall'.ini VERO (gen_*.ini) + Diario: il report
#     .htm del tester NON e' letto a macchina (NON COPERTO, dichiarato).
#   - PER-TRADE (v1.01, commit 35c940e): l'EA lo scrive in Common\Files
#     (ExportTrades, formato di casa), e il driver lo RACCOGLIE nello
#     zip, FRESCO rispetto all'avvio della corsa/fase-2 (assente o
#     vecchio = "cella non girata per cache, non zero trade": MAI
#     letto come zero). Il nome del file (motore+magic+simbolo) NON
#     porta la finestra ne' lo slippage: rappresenta SEMPRE l'ULTIMA
#     cella scritta (corsa principale -> OOS; fase 2 -> slip 5).
#     Punto 5.0.5 (prima data del per-trade, che vuole la copertura
#     dall'INIZIO della finestra IS): NON verificabile da questo file
#     (e' l'OOS) -- resta SEGNALATO, non corretto (il generico e la
#     forma del nome non si toccano da una riga di lancio).
#     Punto S4 (correlazione dei P&L giornalieri fra i tre motori,
#     informativa, non un cancello): ORA ESEGUIBILE A MANO dai 3 CSV
#     magic 774001 (motori 1/2/3) allegati allo zip -- si raggruppano
#     i "net_profit" per data di "close_time", si sommano per giorno,
#     si allineano le tre serie sulle date comuni (giorni mancanti =
#     0) e si calcola la correlazione di Pearson a coppie: >= 0,80 e'
#     un secondo indizio che i motori siano lo stesso oggetto. NON
#     automatizzato qui (S4 non decide da sola, criteri par. 3.2).
#
#  QUANTO CI METTE [STIMA, non una previsione]: compilazione + 12
#  passate a TICK REALI su ~2 anni di M15 forex con max 4 agenti (+4 di
#  fase 2 se dovuta) + 2-3 avvii del terminale: 20-60 minuti a gamba.
#  Nessuna corsa di casa a tick reali su 2 anni di forex e' mai stata
#  cronometrata: il numero vero lo dice questo giro.
#
#  LA RIGA CHE SI INCOLLA sta in righe\RIGA_R116_LONDONFX_DA_MANDARE.md
# =====================================================================
[CmdletBinding()]
param(
  # -Pin NON ha default: un default silenzioso ("lavoro") farebbe girare
  #  la punta del branch spacciandola per un commit congelato.
  [string]$Pin          = "",
  # -Simbolo: il simbolo di QUESTO giro. Default EURUSD (il lead,
  #  dichiarato nel prova). GBPUSD = gamba gemella con override
  #  DICHIARATO. Whitelist gattata sotto: USDJPY VIETATO qui.
  [string]$Simbolo      = "EURUSD",
  [switch]$SoloControllo,                # giro a vuoto: scarica, gatta, COMPILA, generico -SoloControllo, MT5 NON gira
  [switch]$SoloFase2,                    # NON rifa' la corsa principale: forza la sola FASE 2 (slippage 2/5, motore 2)
  [string]$Terminale    = "",            # manopola (classe 115): cartella dell'installazione MT5 di backtest
  [string]$DaQuando     = "2024.07.05",  # pavimento TICK REALI forex BCM, MISURATO il 01/09
  [string]$Fino         = "2026.06.30",
  [double]$FrazioneIS   = 0.40,          # split 40/60 (firma F1)
  [int]$Deposito        = 100000         # taglia prop: il DD si legge contro il muro senza scalature
)
$ErrorActionPreference = "Stop"
[Threading.Thread]::CurrentThread.CurrentCulture   = [Globalization.CultureInfo]::InvariantCulture
[Threading.Thread]::CurrentThread.CurrentUICulture = [Globalization.CultureInfo]::InvariantCulture
[Net.ServicePointManager]::SecurityProtocol = [Net.SecurityProtocolType]::Tls12
$INV = [Globalization.CultureInfo]::InvariantCulture

$EA          = "ABTG_LondonFx"
$INC         = "ABTG_PausaGuardian.mqh"
$SimboloLead = "EURUSD"
$SIMBOLI_AMMESSI = @("EURUSD","GBPUSD")
if($null -eq $Simbolo){ $Simbolo = "" }
$Simbolo  = $Simbolo.Trim().ToUpperInvariant()
$Prefisso = $Simbolo
if($Simbolo.Length -ge 3){ $Prefisso = $Simbolo.Substring(0,3) }
$OverrideSimbolo = ($Simbolo -ne $SimboloLead)
$Etichetta   = "R116_" + $Prefisso           # entra nel NOME dei CSV: due simboli non si sovrascrivono
$EtichettaF2 = "R116_" + $Prefisso + "_SLIP"

$Avvio = Get-Date
$Stamp = $Avvio.ToString("yyyyMMdd_HHmm", $INV)
# IL DESKTOP SI CERCA, NON SI ASSUME (classe 116-bis): con OneDrive il
# Desktop vero non e' %USERPROFILE%\Desktop. La riga di chat usa le
# STESSE tre righe.
function TrovaDesktop(){
  foreach($p in @([Environment]::GetFolderPath("Desktop"),
                  (Join-Path $env:USERPROFILE "Desktop"),
                  (Join-Path $env:USERPROFILE "OneDrive\Desktop"))){
    if($p -and (Test-Path -LiteralPath $p)){ return $p }
  }
  return $env:USERPROFILE
}
$Dsk    = TrovaDesktop
$Work   = Join-Path $env:USERPROFILE "abtg_r116_londonfx"
$Prove  = Join-Path $Work "prove"
$Sentinella = Join-Path $Work "R116_IN_CORSO.txt"
$RawPin = "https://raw.githubusercontent.com/claudiospadaro12/GITHUB/$Pin"

# --- IDENTITA' DELL'EA (gate sul sorgente scaricato al pin)
# v1.01 (03/09, commit 35c940e): AGGIUNTO l'export per-trade
# (NomeFilePerTrade_Calc + ExportTrades, formato di casa) e il blocco
# 18 dell'autotest (6 casi) che ne prova il nome. Nessuna riga di
# segnale/gestione/stop/input/magic toccata: v1.01 fa gli STESSI trade
# di v1.00, in piu' li scrive su file (N15 nel sorgente).
$VERSIONE_ATTESA = "1.01"
$BLOCCHI_ATTESI  = 18
$CASI_ATTESI     = 118
$MAGIC1 = 774001
$MAGIC2 = 774002
# --- IL PER-TRADE (v1.01): Common\Files e' UNA sola cartella per tutti
#     gli agent, e il nome dell'EA NON porta la finestra (IS/OOS) ne'
#     lo slippage: dentro UNA corsa (IS+OOS in un solo invio al
#     generico) l'OOS e' l'ultima a scrivere e SOVRASCRIVE l'IS sullo
#     stesso motore/magic (stesso limite gia' di casa su
#     RIGA_R112_EMADOW_CONTRATTO.ps1). Quindi il per-trade raccolto qui
#     rappresenta SEMPRE E SOLO l'ultima finestra/cella scritta:
#     corsa principale -> OOS; fase 2 -> slip 5 (l'ultima cella
#     dell'asse). Dichiarato nel referto, non nascosto.
$CommonFiles = Join-Path $env:APPDATA "MetaQuotes\Terminal\Common\Files"
function NomePerTrade([int]$motore,[long]$magic){ return ("abtg_trades_" + $EA + "_" + $Simbolo + "_" + $magic + "_m" + $motore + ".csv") }
# Raccoglie i per-trade di una lista di coppie (Motore,Magic): FRESCHI
# rispetto a $tRif (LastWriteTime -ge $tRif), o dichiarati ASSENTE /
# VECCHIO con la formula di casa (checklist: "file assente o non
# fresco = cella non girata per cache, non zero trade" -- mai zero).
# $tag = etichetta CORTA per il nome del file di lavoro (mai lo stesso
# testo lungo di $et, per non produrre nomi file assurdi); $et = frase
# completa per RILIEVI/referto.
function RaccogliPerTrade($coppie,[datetime]$tRif,[string]$tag,[string]$et){
  $righe = New-Object System.Collections.ArrayList
  $copie = New-Object System.Collections.ArrayList
  foreach($c in $coppie){
    $nome = NomePerTrade $c.Motore $c.Magic
    $pt = Join-Path $CommonFiles $nome
    if(-not (Test-Path -LiteralPath $pt)){
      [void]$righe.Add("  motore " + $c.Motore + " magic " + $c.Magic + ": ASSENTE (" + $nome + ")")
      [void]$Rilievi.Add($et + ": per-trade motore " + $c.Motore + " magic " + $c.Magic + " ASSENTE in Common\Files -- file assente o non fresco = cella non girata per cache, non zero trade.")
      continue
    }
    $it = Get-Item -LiteralPath $pt
    if($it.LastWriteTime -lt $tRif){
      [void]$righe.Add("  motore " + $c.Motore + " magic " + $c.Magic + ": VECCHIO (" + $nome + ", " + $it.LastWriteTime.ToString("yyyy-MM-dd HH:mm:ss",$INV) + " < avvio " + $tRif.ToString("yyyy-MM-dd HH:mm:ss",$INV) + ")")
      [void]$Rilievi.Add($et + ": per-trade motore " + $c.Motore + " magic " + $c.Magic + " VECCHIO (di un giro precedente) -- file assente o non fresco = cella non girata per cache, non zero trade.")
      continue
    }
    $nRighe = @(Get-Content -LiteralPath $pt).Count - 1; if($nRighe -lt 0){ $nRighe = 0 }
    [void]$righe.Add("  motore " + $c.Motore + " magic " + $c.Magic + ": presente e FRESCO (" + $nome + "), " + $nRighe + " chiusure")
    $dest = Join-Path $Work ("pertrade_" + $tag + "_m" + $c.Motore + "_" + $c.Magic + ".csv")
    Copy-Item -LiteralPath $pt -Destination $dest -Force
    [void]$copie.Add($dest)
  }
  return @{ Righe=$righe; Copie=$copie }
}
$PerTradeRighe = New-Object System.Collections.ArrayList
$PerTradeCopie = New-Object System.Collections.ArrayList
$PerTradeTxt   = "NON RACCOLTO: nessuna corsa che scrive per-trade e' arrivata al punto della raccolta"

# --- I CANCELLI, ricopiati dai criteri firmati (par. 5.1, 5.7, 5.8) con
#     le DISUGUAGLIANZE. Le fasce sono DISGIUNTE: nessun valore cade in
#     due clausole. Il referto stampa ANCHE le soglie.
$E_PASSA  = 0.075;  $E_MORTA  = 0.050
$PF_PASSA = 1.15;   $PF_MORTA = 1.10
$DD_PASSA = 8.0;    $DD_MORTA = 10.0
$PG_PASSA = -4.0;   $PG_MORTA = -5.0
$N_PASSA  = 150;    $N_MIN    = 30
$S1_SOGLIA = 0.05                        # ablazione: 2/3 del cancello H8
$TETTO_PCT = 20.0;  $FLAT_PCT = 40.0     # dichiarazioni del canarino (par. 4.3)

$PROVA_MAIN = "LONDONFX_R116_TICK.txt"
$PROVA_F2   = "LONDONFX_R116_FASE2_SLIPPAGE.txt"
$NCELLE_MAIN = 6      # 3 InpMotore x 2 InpMagic, RICONTATE dai pin ||Y
$NCELLE_F2   = 2      # InpSlippagePts 2 e 5

# I FISSI del prova principale, nome per nome (18) + i 2 assi.
$FissiMain = [ordered]@{ "InpUsaGuardian"="true"; "InpSmaPeriodo"="5"; "InpRsiPeriodo"="5"; "InpRsiSoglia"="80.0";
  "InpSmma1"="3"; "InpSmma2"="6"; "InpSmma3"="9"; "InpSmma4"="50"; "InpEmaLenta"="200";
  "InpOraInizioServer"="8"; "InpOreSessione"="8"; "InpRiskPercent"="0.65"; "InpMaxSpread"="0";
  "InpSlippagePts"="0"; "InpPipSize"="0.0001"; "InpWarmupBarre"="300"; "InpComment"="LONDONFX";
  "InpVerbose"="true"; "InpAutoTest"="true" }
$AssiMain  = [ordered]@{ "InpMotore"="2||1||1||3||Y"; "InpMagic"=("" + $MAGIC1 + "||" + $MAGIC1 + "||1||" + $MAGIC2 + "||Y") }
# La FASE 2: stessi fissi, ma InpMotore e InpMagic PINNATI e
# InpSlippagePts in ASSE. Le tre differenze dichiarate.
$FissiF2 = [ordered]@{}
foreach($k in @($FissiMain.Keys)){ if($k -ne "InpSlippagePts"){ $FissiF2[$k] = $FissiMain[$k] } }
$FissiF2["InpMotore"] = "2"
$FissiF2["InpMagic"]  = "" + $MAGIC1
$AssiF2 = [ordered]@{ "InpSlippagePts"="2||2||3||5||Y" }

# --- tutto cio' che la raccolta usa nasce QUI, prima del try: ogni campo
#     parte da uno stato VERO ("non ci siamo arrivati"), mai da uno che
#     somigli a un risultato.
$Problemi   = New-Object System.Collections.ArrayList
$Rilievi    = New-Object System.Collections.ArrayList
$RigheLog   = New-Object System.Collections.ArrayList
$Fatale     = ""
$TermTxt    = "NON SCELTO"
$DataFolder = ""
$InstDir    = ""
$Compilato  = "NON TENTATA"
$ResultTxt  = "NON LETTA"
$VersTxt    = "NON LETTA"
$DefineTxt  = "NON LETTI"
$MagicTxt   = "NON LETTO"
$HedgeTxt   = "NON ESEGUITO"
$IncTxt     = "NON CENSITO"
$IncGuardia = "NON VERIFICATA"
$CacheTxt   = "NON SVUOTATA"
$CelleTxt   = "NON CONTATE"
$GemProva   = "NON VERIFICATO"
$ModelTxt   = "NON LETTO"
$TickTxt    = "NON LETTA"
$LogLetti   = -1
$CorsaMain  = "NON TENTATA"
$Fase2Txt   = "NON TENTATA"
$Ripristino = "NON NECESSARIO (il terminale non e' mai stato scritto)"
$FotoPrese  = $false
$IncInstallato = $false
$IncEraLi   = $false
$IncBackup  = ""
$TExpMq5 = ""; $TExpEx5 = ""; $TIncMqh = ""
$F1Prima = $null; $F2Prima = $null; $F3Prima = $null
$RigheFotoDopo = New-Object System.Collections.ArrayList
$logC = Join-Path $Work "COMPILAZIONE.log"   # definito QUI: la raccolta lo cerca anche nel giro morto prima della compilazione
$residui = @()
$Modo = "CORSA"
if($SoloControllo){ $Modo = "CONTROLLO" }
elseif($SoloFase2){ $Modo = "FASE2" }
$ZipNome = "R116_LONDONFX_" + $Simbolo + "_" + $Stamp
if($Modo -ne "CORSA"){ $ZipNome = "R116_LONDONFX_" + $Modo + "_" + $Simbolo + "_" + $Stamp }

# --- le finestre, calcolate ESATTAMENTE come le calcola il generico
$WinIS  = "n/d"; $WinOOS = "n/d"
try{
  $dIni = [datetime]::ParseExact($DaQuando,"yyyy.MM.dd",$INV)
  $dFin = [datetime]::ParseExact($Fino,"yyyy.MM.dd",$INV)
  $dMeta = $dIni.AddDays([math]::Floor(($dFin-$dIni).TotalDays*$FrazioneIS))
  $WinIS  = $dIni.ToString("yyyy.MM.dd",$INV) + " -> " + $dMeta.ToString("yyyy.MM.dd",$INV)
  $WinOOS = $dMeta.AddDays(1).ToString("yyyy.MM.dd",$INV) + " -> " + $dFin.ToString("yyyy.MM.dd",$INV)
}catch{ $WinIS = "DATE NON PARSABILI: " + $DaQuando + " / " + $Fino }

# Le finestre come OGGETTI: ognuna sa il suo CSV, le sue righe, i suoi
# verdetti. IS e OOS della corsa principale + IS e OOS della fase 2.
function W([string]$tag,[string]$et,[int]$celle){
  return [pscustomobject]@{ Tag=$tag; Etichetta=$et; CelleAttese=$celle; Csv=""; CsvOra="n/d"; Letto=$false
    Righe=$null; NRighe=-1; Gemelli="NON VERIFICATI"; PerMotore=@{} }
}
$WIN = @{ "IS"=(W "IS" $Etichetta $NCELLE_MAIN); "OOS"=(W "OOS" $Etichetta $NCELLE_MAIN);
          "F2_IS"=(W "IS" $EtichettaF2 $NCELLE_F2); "F2_OOS"=(W "OOS" $EtichettaF2 $NCELLE_F2) }
$VerdettiA = @{}     # motore -> testo del verdetto (cancelli A/B, letto in OOS con IS per A3)
$Ablazione = "NON CALCOLATA"
$Fase2Verdetto = "n/d"
$SpreadTxt = "NON MISURATO (nessun CSV letto)"
$NomiMotore = @{ 1="CANALE NUDO (controllo)"; 2="CANALE + RSI (BASELINE, l'unico promuovibile)"; 3="ALLINEAMENTO 5 MEDIE (controllo)" }

function Ora(){ return (Get-Date).ToString("HH:mm:ss", $INV) }
function Dico([string]$t,[string]$c="Gray"){ Write-Host ("[" + (Ora) + "] " + $t) -ForegroundColor $c }
function Titolo([string]$t){ Write-Host ""; Write-Host ("=== " + $t + " ===") -ForegroundColor Cyan }
function Num([string]$s){ return [double]::Parse($s.Trim(), $INV) }
function FmtN($v){ if($null -eq $v){ return "n/d" }; return ([long]$v).ToString($INV) }
function Fmt2($v){ if($null -eq $v){ return "n/d" }; return ([double]$v).ToString("0.00",$INV) }
function Fmt3($v){ if($null -eq $v){ return "n/d" }; return ([double]$v).ToString("0.000",$INV) }
function Fmt4($v){ if($null -eq $v){ return "n/d" }; return ([double]$v).ToString("0.0000",$INV) }

function Scarica([string]$url,[string]$dest){
  Remove-Item -LiteralPath $dest -Force -ErrorAction SilentlyContinue
  try{ Invoke-WebRequest -Uri $url -OutFile $dest -UseBasicParsing -ErrorAction Stop }
  catch{
    throw ("SCARICO FALLITO da " + $url + " -- " + $_.Exception.Message +
           " | se e' un 404 su un pin appena creato: la cache di raw.githubusercontent dura qualche minuto, si aspetta e si rilancia LA STESSA riga (il pin non si cambia).")
  }
  if(-not (Test-Path -LiteralPath $dest)){ throw ("SCARICO FALLITO (nessun file scritto): " + $url) }
  if((Get-Item -LiteralPath $dest).Length -le 0){ throw ("SCARICO FALLITO (file vuoto): " + $url) }
}

# Legge un file di testo qualunque sia la codifica (il log di MetaEditor
# e i log del tester escono in UTF-16LE col BOM).
function LeggiTesto([string]$path){
  if(-not (Test-Path -LiteralPath $path)){ return @() }
  $b = [System.IO.File]::ReadAllBytes($path)
  if($b.Length -eq 0){ return @() }
  $txt = ""
  if($b.Length -ge 2 -and $b[0] -eq 255 -and $b[1] -eq 254){ $txt = [System.Text.Encoding]::Unicode.GetString($b,2,$b.Length-2) }
  elseif($b.Length -ge 2 -and $b[0] -eq 254 -and $b[1] -eq 255){ $txt = [System.Text.Encoding]::BigEndianUnicode.GetString($b,2,$b.Length-2) }
  elseif($b.Length -ge 3 -and $b[0] -eq 239 -and $b[1] -eq 187 -and $b[2] -eq 191){ $txt = [System.Text.Encoding]::UTF8.GetString($b,3,$b.Length-3) }
  else{
    $zeri = 0; $fin = [math]::Min($b.Length,400)
    for($i=1; $i -lt $fin; $i=$i+2){ if($b[$i] -eq 0){ $zeri++ } }
    if($zeri -gt ($fin/4)){ $txt = [System.Text.Encoding]::Unicode.GetString($b) } else { $txt = [System.Text.Encoding]::UTF8.GetString($b) }
  }
  return @($txt -split "`r`n|`n|`r")
}

# FOTO di un file del terminale: esiste? quanti byte? che data? Presa
# PRIMA e RIFATTA DOPO, stampata riga per riga (classe 116, pezzo 2).
function Foto([string]$path){
  if($path -eq "" -or $null -eq $path -or -not (Test-Path -LiteralPath $path)){ return [pscustomobject]@{ Esiste=$false; Len=-1; Ora="ASSENTE" } }
  $i = Get-Item -LiteralPath $path
  return [pscustomobject]@{ Esiste=$true; Len=$i.Length; Ora=$i.LastWriteTime.ToString("yyyy-MM-dd HH:mm:ss",$INV) }
}
function FotoTxt($f){ if(-not $f.Esiste){ return "ASSENTE" }; return ("presente, " + $f.Len + " byte, " + $f.Ora) }

function RigheVive([string]$p){ return @(Get-Content -LiteralPath $p | Where-Object { $_ -notmatch '^\s*#' -and $_ -notmatch '^\s*$' }) }

# legge un prova in una mappa @{nome=valore} + lista assi Y. Riga DOPPIA
# = FATALE (in [TesterInputs] un parametro doppio fa fare a MT5 ZERO passate).
function LeggiProva([string]$percorso,[string]$nome){
  $mappa = @{}
  $assi  = New-Object System.Collections.ArrayList
  foreach($r in (RigheVive $percorso)){
    if($r -match '^@'){
      $parti = ($r -split '\s+',2)
      if($parti.Count -lt 2){ throw ($nome + ": la direttiva '" + $r + "' non ha un valore.") }
      if($mappa.ContainsKey($parti[0])){ throw ($nome + ": direttiva doppia '" + $parti[0] + "'.") }
      $mappa[$parti[0]] = $parti[1].Trim()
      continue
    }
    $i = $r.IndexOf("=")
    if($i -lt 0){ continue }
    $n = $r.Substring(0,$i).Trim(); $v = $r.Substring($i+1).Trim()
    if($mappa.ContainsKey($n)){ throw ($nome + ": DUE righe per '" + $n + "'. In [TesterInputs] un parametro doppio fa fare a MT5 ZERO passate.") }
    $mappa[$n] = $v
    if($v -match '\|\|Y\s*$'){ [void]$assi.Add($n) }
  }
  return @{ Mappa=$mappa; Assi=$assi }
}

# conta le celle di UN asse ESATTAMENTE come le conta il generico
# (Floor(|stop-start|/|step| + 1e-9) + 1; true->1, false->0).
function CelleAsse([string]$valore,[string]$nome){
  $campi = $valore -split '\|\|'
  if($campi.Count -lt 5){ throw ($nome + ": pin '" + $valore + "' non ha 5 campi: non e' un asse.") }
  $conv = New-Object System.Collections.ArrayList
  foreach($ix in @(1,2,3)){
    $t = $campi[$ix].Trim()
    if($t -ieq "true"){ $t = "1" }; if($t -ieq "false"){ $t = "0" }
    if($t -notmatch '^-?\d+(\.\d+)?$'){ throw ($nome + ": campo '" + $campi[$ix] + "' non numerico nell'asse.") }
    [void]$conv.Add([double]::Parse($t,$INV))
  }
  $start = $conv[0]; $step = $conv[1]; $stop = $conv[2]
  if($step -eq 0 -or $start -eq $stop){ throw ($nome + ": asse DEGENERE (start==stop o step==0).") }
  return ([int]([math]::Floor([math]::Abs($stop-$start)/[math]::Abs($step) + 1e-9)) + 1)
}

# IL GATE DI UN PROVA: direttive nude, assi esatti, celle ricontate,
# fissi nome per nome, nessuna riga estranea. Torna @{ Lettura; Celle }.
function GateProva([string]$percorso,[string]$pf,$fissi,$assiAttesi,[int]$celleAttese){
  $lettura = LeggiProva $percorso $pf
  $h = $lettura.Mappa; $assi = $lettura.Assi
  if($h["@SIMBOLO"]  -ne $SimboloLead){ throw ($pf + ": @SIMBOLO e' '" + $h["@SIMBOLO"] + "', atteso il lead " + $SimboloLead + " (il prova si dichiara SEMPRE sul lead; il simbolo di questa corsa e' " + $Simbolo + " e passa dall'override -Simbolo, che nel generico vince sulla direttiva)") }
  if($h["@PERIODO"]  -ne "M15"){        throw ($pf + ": @PERIODO e' '" + $h["@PERIODO"] + "', atteso M15 (firma F1: il round e' M15 e basta)") }
  if($h["@DAQUANDO"] -ne $DaQuando){    throw ($pf + ": @DAQUANDO e' '" + $h["@DAQUANDO"] + "', atteso " + $DaQuando + " (pavimento TICK REALI misurato il 01/09)") }
  if($h["@FINOA"]    -ne $Fino){        throw ($pf + ": @FINOA e' '" + $h["@FINOA"] + "', atteso " + $Fino) }
  if(@($assi).Count -ne @($assiAttesi.Keys).Count){ throw ($pf + ": deve avere ESATTAMENTE " + @($assiAttesi.Keys).Count + " assi Y (" + (@($assiAttesi.Keys) -join ", ") + "). Trovati: " + @($assi).Count + " {" + (@($assi) -join ", ") + "}.") }
  foreach($k in @($assiAttesi.Keys)){
    if(@($assi) -notcontains $k){ throw ($pf + ": manca l'asse Y '" + $k + "'.") }
    if($h[$k] -ne $assiAttesi[$k]){ throw ($pf + ": " + $k + " e' '" + $h[$k] + "', atteso '" + $assiAttesi[$k] + "'.") }
  }
  $nc = 1
  foreach($k in @($assiAttesi.Keys)){ $nc = $nc * (CelleAsse $h[$k] $k) }
  if($nc -ne $celleAttese){ throw ($pf + ": i pin ||Y danno " + $nc + " celle, attese " + $celleAttese + ". Un asse e' cambiato.") }
  foreach($k in @($fissi.Keys)){
    if(-not $h.ContainsKey($k)){ throw ($pf + ": manca la riga '" + $k + "' (fisso dichiarato: va verificabile nell'.ini).") }
    if($h[$k] -match '\|\|Y\s*$'){ throw ($pf + ": " + $k + " e' SWEEPATO ma qui e' un fisso: questo round NON ha una griglia (F11).") }
    $v = ($h[$k] -split '\|\|')[0].Trim()
    if($v -ne $fissi[$k]){ throw ($pf + ": " + $k + " e' '" + $v + "', atteso '" + $fissi[$k] + "'.") }
  }
  $attese = 4 + @($fissi.Keys).Count + @($assiAttesi.Keys).Count
  if(@($h.Keys).Count -ne $attese){ throw ($pf + ": " + @($h.Keys).Count + " righe vive invece di " + $attese + ": c'e' una riga estranea o ne manca una.") }
  return @{ Lettura=$lettura; Celle=$nc }
}

# GEMELLAGGIO principale / fase 2: stesse chiavi, e differiscono SOLO
# per InpMotore, InpMagic, InpSlippagePts (le 3 differenze dichiarate).
function GateGemellaggio($hA,$hB){
  foreach($k in @($hA.Keys)){ if(-not $hB.ContainsKey($k)){ throw ("GEMELLAGGIO NON VALIDO: il prova principale ha la riga '" + $k + "' che la fase 2 non ha.") } }
  foreach($k in @($hB.Keys)){ if(-not $hA.ContainsKey($k)){ throw ("GEMELLAGGIO NON VALIDO: la fase 2 ha la riga '" + $k + "' che il principale non ha.") } }
  $diffAttese = @("InpMotore","InpMagic","InpSlippagePts")
  foreach($k in @($hA.Keys)){
    if($diffAttese -contains $k){
      if($hA[$k] -eq $hB[$k]){ throw ("GEMELLAGGIO NON VALIDO: '" + $k + "' DOVEVA differire fra principale e fase 2 e invece e' identico ('" + $hA[$k] + "').") }
      continue
    }
    if($hA[$k] -ne $hB[$k]){ throw ("GEMELLAGGIO NON VALIDO: '" + $k + "' differisce ('" + $hA[$k] + "' contro '" + $hB[$k] + "') e NON e' una delle 3 differenze dichiarate (InpMotore, InpMagic, InpSlippagePts): la fase 2 misurerebbe un altro contenitore.") }
  }
  return "VALIDO: le righe vive differiscono SOLO per le 3 differenze dichiarate (InpMotore asse->pin 2, InpMagic asse->pin " + $MAGIC1 + ", InpSlippagePts pin 0->asse 2/5)"
}

# UNA COMPILAZIONE con metaeditor64 (invocazione diretta, MAI
# Start-Process con la stringa montata a mano: 22/08). L'attesa finisce
# con l'.ex5 fresco o con la riga Result nel log; MUTO = niente log e
# niente .ex5 dopo 20 s (il rc=0 muto del 22/08).
function Compila([string]$exe,[string]$mq5,[string]$ex5,[string]$log,[int]$tetto){
  Remove-Item -LiteralPath $ex5 -Force -ErrorAction SilentlyContinue
  Remove-Item -LiteralPath $log -Force -ErrorAction SilentlyContinue
  $t0 = Get-Date
  Dico ("metaeditor64: /compile:" + $mq5 + " /log:" + $log) "Yellow"
  $global:LASTEXITCODE = $null
  & $exe ("/compile:" + $mq5) ("/log:" + $log) | Out-Null
  $grezzo = $LASTEXITCODE
  $muto = $false; $battito = 0
  while($true){
    if((Test-Path -LiteralPath $ex5) -and ((Get-Item -LiteralPath $ex5).LastWriteTime -ge $t0)){ break }
    $r = LeggiTesto $log
    if(@($r).Count -gt 0 -and (@($r) -match 'Result:').Count -gt 0){ break }
    $sec = (New-TimeSpan -Start $t0 -End (Get-Date)).TotalSeconds
    if(@($r).Count -eq 0 -and $sec -ge 20){ $muto = $true; break }
    if($sec -ge $tetto){ break }
    if($sec -ge ($battito + 10)){ $battito = [int]$sec; Dico ("   ... aspetto l'.ex5 da " + $battito + "s (tetto " + $tetto + "s): NON interrompere, la riga si ferma da sola") }
    Start-Sleep -Seconds 2
  }
  $fresco = ((Test-Path -LiteralPath $ex5) -and ((Get-Item -LiteralPath $ex5).LastWriteTime -ge $t0))
  return @{ Ex5=$fresco; Rc=$grezzo; Log=(LeggiTesto $log); Muto=$muto }
}

# I LOG DEL TESTER: cinque radici (gli agent NON stanno sotto la cartella
# dati). Si fotografa la lunghezza PRIMA e si legge SOLO cio' che e'
# cresciuto: un file non cresciuto e' il log di ieri.
$script:RadiciLog = @(); $script:LenPrima = @{}
function FotografaLog(){
  $script:RadiciLog = @()
  if($env:APPDATA){ $script:RadiciLog += (Join-Path $env:APPDATA "MetaQuotes\Tester") }
  if($DataFolder){  $script:RadiciLog += (Join-Path $DataFolder "Tester"); $script:RadiciLog += (Join-Path $DataFolder "Logs"); $script:RadiciLog += (Join-Path $DataFolder "MQL5\Logs") }
  if($InstDir){     $script:RadiciLog += (Join-Path $InstDir "Tester") }
  $script:LenPrima = @{}
  foreach($rad in $script:RadiciLog){
    if(-not (Test-Path -LiteralPath $rad)){ continue }
    foreach($f in @(Get-ChildItem -LiteralPath $rad -Recurse -File -Filter "*.log" -ErrorAction SilentlyContinue)){ $script:LenPrima[$f.FullName] = $f.Length }
  }
  Dico ("log gia' presenti nelle radici del tester, fotografati: " + $script:LenPrima.Count) "DarkGray"
}
function RaccogliLog(){
  $n = 0
  $pattern = 'ticks data begins|real tick|no memory|generat|not exist|cannot|error|\[AUTOTEST\]'
  foreach($rad in $script:RadiciLog){
    if(-not (Test-Path -LiteralPath $rad)){ continue }
    foreach($f in @(Get-ChildItem -LiteralPath $rad -Recurse -File -Filter "*.log" -ErrorAction SilentlyContinue)){
      $da = 0
      if($script:LenPrima.ContainsKey($f.FullName)){ $da = [int64]$script:LenPrima[$f.FullName] }
      if($f.Length -le $da){ continue }
      $n++
      foreach($l in (LeggiTesto $f.FullName)){
        if($l -match $pattern){ [void]$RigheLog.Add(($f.Name + ": " + $l.Trim())) }
      }
      try{ Copy-Item -LiteralPath $f.FullName -Destination (Join-Path $Work ("log_" + $f.Name)) -Force -ErrorAction SilentlyContinue }catch{}
    }
  }
  return $n
}

# --- LE FASCE, ricopiate segno per segno (criteri par. 5.8). Parametri TIPIZZATI:
#     un -4.01 passato come stringa farebbe un confronto di STRINGHE e direbbe
#     PASSA (classe 64 della checklist, riprodotta sul banco il 03/09).
function FasciaE([double]$e){  if($e -ge $E_PASSA){ return "PASSA" }; if($e -ge $E_MORTA){ return "NON PASSA (zona morta)" }; return "BOCCIATA" }
function FasciaPF([double]$p){ if($p -ge $PF_PASSA){ return "PASSA" }; if($p -ge $PF_MORTA){ return "NON PASSA (zona morta)" }; return "BOCCIATA" }
function FasciaDD([double]$d){ if($d -le $DD_PASSA){ return "PASSA" }; if($d -le $DD_MORTA){ return "NON PASSA (zona morta)" }; return "BOCCIATA PER RISCHIO" }
function FasciaPG([double]$g){ if($g -ge $PG_PASSA){ return "PASSA" }; if($g -ge $PG_MORTA){ return "NON PASSA (zona morta)" }; return "BOCCIATA PER RISCHIO" }
function FasciaN([int]$n){  if($n -ge $N_PASSA){ return "PASSA" }; if($n -ge $N_MIN){ return "MERITO SOSPESO" }; return "NON MISURABILE" }

# IL VERDETTO DI UN MOTORE su una gamba (OOS + IS per A3/A6). Ordine
# congelato: rischio a qualunque n -> non misurabile -> bocciatura
# secca -> merito sospeso -> tutte le A -> altrimenti NON PASSA.
function VerdettoMotore($is,$oos){
  $fE = FasciaE $oos.EInR; $fPF = FasciaPF $oos.PF; $fDD = FasciaDD $oos.DD; $fPG = FasciaPG $oos.PG
  $fNo = FasciaN $oos.N; $fNi = FasciaN $is.N
  $a3 = (($is.Profit -gt 0 -and $oos.Profit -gt 0) -or ($is.Profit -lt 0 -and $oos.Profit -lt 0)) -and ($is.PF -gt 1.0)
  $dettagli = "A1 E=" + (Fmt4 $oos.EInR) + "R " + $fE + " | A2 PF=" + (Fmt3 $oos.PF) + " " + $fPF + " | A3 segno IS/OOS coerente e PF IS>1: " + $(if($a3){"PASSA"}else{"NON PASSA"}) + " (IS profit " + (Fmt2 $is.Profit) + ", PF IS " + (Fmt3 $is.PF) + ") | A4 DD=" + (Fmt2 $oos.DD) + "% " + $fDD + " | A5 PG=" + (Fmt2 $oos.PG) + "% " + $fPG + " | A6 n OOS=" + (FmtN $oos.N) + " " + $fNo + ", n IS=" + (FmtN $is.N) + " " + $fNi
  if($fDD -like "BOCCIATA*" -or $fPG -like "BOCCIATA*"){ return @{ Esito="BOCCIATA PER RISCHIO (a qualunque n: il giudizio di rischio non si sospende mai)"; Passa=$false; Dettagli=$dettagli } }
  if($oos.N -lt $N_MIN -or $is.N -lt $N_MIN){ return @{ Esito="NON MISURABILE (n < " + $N_MIN + "): la conclusione NON e' sull'edge"; Passa=$false; Dettagli=$dettagli } }
  if($fE -eq "BOCCIATA" -or $fPF -eq "BOCCIATA" -or $is.Profit -lt 0){ return @{ Esito="BOCCIATA SECCA (cancello B)"; Passa=$false; Dettagli=$dettagli } }
  if($fNo -ne "PASSA" -or $fNi -ne "PASSA"){ return @{ Esito="MERITO SOSPESO (30 <= n < 150, valvola R59): si legge SOLO il rischio"; Passa=$false; Dettagli=$dettagli } }
  if($fE -eq "PASSA" -and $fPF -eq "PASSA" -and $a3 -and $fDD -eq "PASSA" -and $fPG -eq "PASSA"){ return @{ Esito="PASSA TUTTI I CANCELLI A (non e' una promozione: e' il permesso di chiedere la fase 2 e poi la prova di rischio sul vecchio)"; Passa=$true; Dettagli=$dettagli } }
  return @{ Esito="NON PASSA (zona morta su almeno un cancello: nessuna proposta, nessuna bocciatura del meccanismo)"; Passa=$false; Dettagli=$dettagli }
}

# LEGGE UN CSV OPTFRAME in una lista di oggetti (una riga = una passata),
# colonne per NOME. Torna $null se manca una colonna (PROBLEMA gia' scritto).
$ColonneServono = @("Pass","Segnali Generati","Segnali Soppressi Posizione Aperta","Segnali Soppressi Tetto Giorno",
  "Giorni Col Tetto Colpito","Giorni Fermati Dal Cap","Trade Chiusi Dal Flat Pct","Spread Mediano Ingresso Pip","Spread P95 Ingresso Pip",
  "Profit","Expected Payoff","Profit Factor","Recovery Factor","Equity DD Pct","Trades","Peggior Giornata Pct","E In R","Rischio Medio Valuta",
  "Ingressi Totali","Ingressi Long","Ingressi Short","Uscite Flat","Uscite Cap","Uscite Mercato","Notti Attraversate",
  "Segnali Soppressi Fine Sessione","Segnali Soppressi Cap","Segnali Soppressi Spread","Ingressi Falliti","Lotti Al Minimo","Stop Allargato",
  "Barre Sessione Valutate","Barre Saltate Dati","Giorni Contati","Spread Campioni","Canarino Torna",
  "Motore","Ora Inizio Server","Ore Sessione","Tp Pip","Sl Pip","Slippage Pts","Risk Pct","Max Trades Giorno","Cap Giornaliero Pct",
  "Rsi Soglia Long","Rsi Soglia Short","Pip Size Prezzo","Pip In Punti Mt5","Max Spread Pts","Autotest Falliti","Autotest Blocchi","Autotest Casi","InpMagic")
function LeggiCsv([string]$path,[string]$et){
  $lin = @(Get-Content -LiteralPath $path | Where-Object { $_.Trim() -ne "" })
  if($lin.Count -lt 1){ [void]$Problemi.Add($et + ": CSV vuoto (nemmeno l'header)."); return $null }
  $head = $lin[0] -split ','
  $ix = @{}
  for($i=0;$i -lt $head.Count;$i++){ $ix[$head[$i].Trim()] = $i }
  $manca = @($ColonneServono | Where-Object { -not $ix.ContainsKey($_) })
  if($manca.Count -gt 0){ [void]$Problemi.Add($et + ": nel CSV mancano le colonne: " + ($manca -join ", ") + " (header OPTFRAME cambiato nell'EA?)."); return $null }
  $righe = New-Object System.Collections.ArrayList
  for($i=1;$i -lt $lin.Count;$i++){
    $cols = $lin[$i] -split ','
    if($cols.Count -lt $head.Count){ [void]$Problemi.Add($et + ": riga " + $i + " del CSV ha meno colonne dell'header: non la leggo."); continue }
    $g = @{}
    foreach($k in $ix.Keys){ $g[$k] = $cols[$ix[$k]].Trim() }
    $r = [pscustomobject]@{ Grezzo=$g; Motore=[int](Num $g["Motore"]); Magic=[long](Num $g["InpMagic"])
      Profit=(Num $g["Profit"]); PF=(Num $g["Profit Factor"]); DD=(Num $g["Equity DD Pct"]); N=[int](Num $g["Trades"]); PG=(Num $g["Peggior Giornata Pct"]); EInR=(Num $g["E In R"])
      Payoff=(Num $g["Expected Payoff"]); RischioMedio=(Num $g["Rischio Medio Valuta"])
      SegGen=[int](Num $g["Segnali Generati"]); SoppPos=[int](Num $g["Segnali Soppressi Posizione Aperta"]); SoppTetto=[int](Num $g["Segnali Soppressi Tetto Giorno"])
      GgTetto=[int](Num $g["Giorni Col Tetto Colpito"]); GgCap=[int](Num $g["Giorni Fermati Dal Cap"]); FlatPct=(Num $g["Trade Chiusi Dal Flat Pct"])
      SprMed=(Num $g["Spread Mediano Ingresso Pip"]); SprP95=(Num $g["Spread P95 Ingresso Pip"]); SprN=[int](Num $g["Spread Campioni"])
      Giorni=[int](Num $g["Giorni Contati"]); Notti=[int](Num $g["Notti Attraversate"]); StopAll=[int](Num $g["Stop Allargato"]); Canarino=[int](Num $g["Canarino Torna"])
      IngL=[int](Num $g["Ingressi Long"]); IngS=[int](Num $g["Ingressi Short"]); SoppFine=[int](Num $g["Segnali Soppressi Fine Sessione"]); LottiMin=[int](Num $g["Lotti Al Minimo"])
      AutoKo=[int](Num $g["Autotest Falliti"]); AutoBl=[int](Num $g["Autotest Blocchi"]); AutoCasi=[int](Num $g["Autotest Casi"]) }
    [void]$righe.Add($r)
  }
  return $righe
}

# COLLAUDI per riga: autotest, canarino, eco dei fissi.
function CollaudaRighe($righe,[string]$et,[int]$slipAtteso){
  foreach($r in $righe){
    $tag = $et + " (motore " + $r.Motore + ", magic " + $r.Magic + ", slip " + $r.Grezzo["Slippage Pts"] + ")"
    if($r.AutoKo -eq -1){ [void]$Problemi.Add($tag + ": Autotest Falliti = -1 (NON girato): il file non vale.") }
    elseif($r.AutoKo -gt 0){ [void]$Problemi.Add($tag + ": Autotest Falliti = " + $r.AutoKo + ": l'EA DIVERGE dalla spec, i numeri NON si leggono.") }
    if($r.AutoBl -ne $BLOCCHI_ATTESI -or $r.AutoCasi -ne $CASI_ATTESI){ [void]$Problemi.Add($tag + ": autotest " + $r.AutoBl + " blocchi / " + $r.AutoCasi + " casi invece di " + $BLOCCHI_ATTESI + " / " + $CASI_ATTESI + ": EA diverso da quello atteso.") }
    if($r.Canarino -ne 1){ [void]$Problemi.Add($tag + ": Canarino Torna = " + $r.Canarino + " (atteso 1): l'identita' di N11 NON torna, le colonne del canarino NON si leggono.") }
    if($r.Notti -ne 0){ [void]$Problemi.Add($tag + ": Notti Attraversate = " + $r.Notti + " (atteso 0): il flat NON e' stato ermetico, il rischio overnight non e' quello dichiarato.") }
    if($r.StopAll -ne 0){ [void]$Rilievi.Add($tag + ": Stop Allargato = " + $r.StopAll + " ingressi con la geometria allargata dallo STOPS_LEVEL: quella cella NON ha girato TP 15,0 / SL 8,0 su quegli ingressi.") }
    if($r.LottiMin -gt 0){ [void]$Rilievi.Add($tag + ": Lotti Al Minimo = " + $r.LottiMin + ": su quegli ingressi il rischio NON e' 0,65% (lotto minimo del broker).") }
    $eco = @{ "Ora Inizio Server"="8"; "Ore Sessione"="8"; "Tp Pip"="15.0"; "Sl Pip"="8.0"; "Slippage Pts"=("" + $slipAtteso); "Risk Pct"="0.65"; "Max Trades Giorno"="6"; "Cap Giornaliero Pct"="2.0"; "Rsi Soglia Long"="80.0"; "Rsi Soglia Short"="20.0"; "Pip Size Prezzo"="0.00010"; "Pip In Punti Mt5"="10.00"; "Max Spread Pts"="0" }
    foreach($k in $eco.Keys){
      $v = $r.Grezzo[$k]
      $ok = $false
      try{ $ok = ([math]::Abs((Num $v) - (Num $eco[$k])) -lt 0.000001) }catch{ $ok = $false }
      if(-not $ok -and $slipAtteso -lt 0 -and $k -eq "Slippage Pts"){ $ok = $true }
      if(-not $ok){ [void]$Problemi.Add($tag + ": eco '" + $k + "' = " + $v + " invece di " + $eco[$k] + ": il pin NON e' passato, l'EA ha girato con un altro contenitore.") }
    }
    if($r.Magic -eq $MAGIC2){ continue }   # le dichiarazioni una volta per motore: i gemelli sono identici (gate a parte)
    if($r.Giorni -gt 0 -and (100.0*$r.GgTetto/$r.Giorni) -gt $TETTO_PCT){ [void]$Rilievi.Add($tag + ": Giorni col Tetto Colpito " + $r.GgTetto + "/" + $r.Giorni + " = " + (Fmt2 (100.0*$r.GgTetto/$r.Giorni)) + "% > " + (Fmt2 $TETTO_PCT) + "%: motore STROZZATO DAL CONTENITORE, il suo posto nel confronto S1 e' CONTAMINATO (confronto operativo, non segnale-contro-contenitore). Atteso sul motore 1.") }
    if($r.FlatPct -gt $FLAT_PCT){ [void]$Rilievi.Add($tag + ": Trade Chiusi dal Flat " + (Fmt2 $r.FlatPct) + "% > " + (Fmt2 $FLAT_PCT) + "%: il round sta misurando l'OROLOGIO, non il motore, e va scritto in quei termini.") }
  }
}

# I GEMELLI: per ogni motore, le righe magic1 e magic2 devono essere
# IDENTICHE su TUTTE le colonne tranne Pass e InpMagic.
function GateGemelli($righe,[string]$et){
  $ok = $true; $coppie = 0
  foreach($m in @(1,2,3)){
    $a = @($righe | Where-Object { $_.Motore -eq $m -and $_.Magic -eq $MAGIC1 })
    $b = @($righe | Where-Object { $_.Motore -eq $m -and $_.Magic -eq $MAGIC2 })
    if($a.Count -ne 1 -or $b.Count -ne 1){ [void]$Problemi.Add($et + ": motore " + $m + " non ha ESATTAMENTE una passata per magic (" + $a.Count + "/" + $b.Count + "): griglia incompleta o cache, gemelli non verificabili."); $ok = $false; continue }
    $coppie++
    $diff = New-Object System.Collections.ArrayList
    foreach($k in $a[0].Grezzo.Keys){
      if($k -eq "Pass" -or $k -eq "InpMagic"){ continue }
      if($a[0].Grezzo[$k] -ne $b[0].Grezzo[$k]){ [void]$diff.Add($k) }
    }
    if($diff.Count -gt 0){ $ok = $false; [void]$Problemi.Add($et + ": GEMELLI DIVERGONO sul motore " + $m + " (" + $MAGIC1 + " contro " + $MAGIC2 + "): " + ($diff -join ", ") + ". Banco sporco: il round e' FERMO (sanita' 5.0.1).") }
  }
  if($ok -and $coppie -eq 3){ return "IDENTICI al centesimo su 3 coppie (un motore, due magic)" }
  return "ROTTI O NON VERIFICABILI (vedi PROBLEMI)"
}

# LEGGE la finestra di una corsa: data il CSV, conta le righe, collauda.
function LeggiFinestra($w,[datetime]$tCorsa,[int]$slipAtteso,[bool]$conGemelli){
  $w.Csv = Join-Path $Work ("risultati_prove\" + $EA + "\" + $EA + "_" + $Simbolo + "_" + $w.Tag + "_" + $w.Etichetta + ".csv")
  $et = $w.Etichetta + "/" + $w.Tag
  if(-not (Test-Path -LiteralPath $w.Csv)){ [void]$Problemi.Add($et + ": CSV OPTFRAME NON prodotto: " + $w.Csv); return }
  $itm = Get-Item -LiteralPath $w.Csv
  $w.CsvOra = $itm.LastWriteTime.ToString("yyyy-MM-dd HH:mm:ss",$INV)
  if($itm.LastWriteTime -lt $tCorsa){
    [void]$Problemi.Add($et + ": CSV STANTIO, NON LETTO. Scritto alle " + $w.CsvOra + ", PRIMA dell'avvio di questa corsa (" + $tCorsa.ToString("yyyy-MM-dd HH:mm:ss",$INV) + "): e' il reperto di una corsa precedente (il generico e' MORTO prima di rifarlo: -Rifai copre chi salta, non chi muore). Questa finestra NON ha numeri.")
    return
  }
  $righe = LeggiCsv $w.Csv $et
  if($null -eq $righe){ return }
  $w.NRighe = $righe.Count
  if($w.NRighe -ne $w.CelleAttese){ [void]$Problemi.Add($et + ": " + $w.NRighe + " righe nel CSV, " + $w.CelleAttese + " passate chieste (cache del tester? storico?). Sanita' 5.0.3: il round NON si legge.") }
  if($w.NRighe -le 0){ return }
  $w.Righe = $righe; $w.Letto = $true
  CollaudaRighe $righe $et $slipAtteso
  if($conGemelli){ $w.Gemelli = GateGemelli $righe $et }
  foreach($r in $righe){
    if($conGemelli -and $r.Magic -ne $MAGIC1){ continue }
    $chiave = "" + $r.Motore
    if(-not $conGemelli){ $chiave = "" + $r.Motore + "_slip" + $r.Grezzo["Slippage Pts"] }
    $w.PerMotore[$chiave] = $r
  }
}

# LANCIA IL GENERICO una volta (una corsa = IS + OOS) e legge il codice a
# TRE stati (classe 108). Torna l'ora di avvio della corsa.
function LanciaGenerico([string]$drv,[string]$prova,[string]$et){
  $argv = @("-ExecutionPolicy","Bypass","-File",$drv,
            "-Expert",$EA, "-Prova",$prova, "-Etichetta",$et,
            "-Simbolo",$Simbolo, "-Periodo","M15",
            "-DaQuando",$DaQuando, "-Fino",$Fino,
            "-FrazioneIS",("" + $FrazioneIS), "-Modello","4", "-Spread","0",
            "-Rifai", "-Deposito",("" + $Deposito))
  if($Terminale -ne ""){ $argv += @("-Terminal",(Join-Path $Terminale "terminal64.exe"),"-MetaEditor",(Join-Path $Terminale "metaeditor64.exe")) }
  if($SoloControllo){ $argv += "-SoloControllo" }
  Dico ("argv generico: " + ($argv -join " "))
  $global:LASTEXITCODE = $null
  & powershell $argv
  $rc = $LASTEXITCODE
  $rcLetto = ($null -ne $rc -and (("" + $rc).Trim()) -match '^-?\d+$')
  if($rcLetto -and [int]$rc -ne 0){ [void]$Problemi.Add("corsa " + $et + ": il generico e' uscito con codice " + $rc + " (storico mancante? CSV non prodotto? MT5 aperto?).") }
  elseif(-not $rcLetto){ [void]$Rilievi.Add("corsa " + $et + ": codice di uscita del generico NON LETTO (capita su PS 5.1): NON e' un fallimento, fanno fede i CSV datati.") }
}

try{
  Titolo ("R116 -- LONDONFX A TICK REALI (" + $EA + ") -- " + $Simbolo + " M15 -- modo " + $Modo)

  # -------------------------------------------------------------------
  #  0. LE GUARDIE, PRIMA DI TOCCARE QUALUNQUE COSA
  # -------------------------------------------------------------------
  if($Pin -eq ""){ throw "-Pin obbligatorio: senza, girerebbe la punta del branch spacciandola per un commit congelato." }
  if($Pin -notmatch '^[0-9a-f]{40}$'){ throw ("-Pin deve essere un commit di 40 caratteri esadecimali, ricevuto: " + $Pin) }
  if($SIMBOLI_AMMESSI -notcontains $Simbolo){
    throw ("-Simbolo '" + $Simbolo + "' NON e' ammesso in questo round. Ammessi: " + ($SIMBOLI_AMMESSI -join ", ") + " (le due gambe che hanno passato il PASSO 0; " + $SimboloLead + " e' il lead). USDJPY e' VIETATO ed e' VOLUTO: il prova pinna InpPipSize=0.0001 e l'EA RIFIUTEREBBE di partire (init fallito), meglio cosi' che una geometria sbagliata di 100 volte letta come buona.")
  }
  if($SoloControllo -and $SoloFase2){ throw "-SoloControllo e -SoloFase2 insieme non hanno senso: uno o l'altro." }
  if(Get-Process terminal64,metaeditor64 -ErrorAction SilentlyContinue){
    throw "MT5 O METAEDITOR APERTO: col terminale aperto il tester non gira (zero CSV), con MetaEditor aperto la compilazione torna subito senza compilare. Chiudili e rilancia."
  }
  New-Item -ItemType Directory -Force -Path $Work,$Prove | Out-Null
  # LA SENTINELLA DEL GIRO PRECEDENTE (classe 116): se un giro e' stato
  # interrotto fra l'installazione dell'include e il ripristino, qui si
  # rimette a posto PRIMA di tutto e lo si dichiara.
  if(Test-Path -LiteralPath $Sentinella){
    $rigaS = @(Get-Content -LiteralPath $Sentinella -ErrorAction SilentlyContinue)
    $sDest = ""; $sBack = ""
    if(@($rigaS).Count -ge 1){ $sDest = ("" + $rigaS[0]).Trim() }
    if(@($rigaS).Count -ge 2){ $sBack = ("" + $rigaS[1]).Trim() }
    $esitoS = "niente da fare"
    if($sDest -ne "" -and (Test-Path -LiteralPath $sDest)){
      if($sBack -ne "" -and (Test-Path -LiteralPath $sBack)){
        Copy-Item -LiteralPath $sBack -Destination $sDest -Force
        Remove-Item -LiteralPath $sBack -Force -ErrorAction SilentlyContinue
        $esitoS = "include ripristinato dal backup " + $sBack
      } else { Remove-Item -LiteralPath $sDest -Force -ErrorAction SilentlyContinue; $esitoS = "include rimosso (non c'era prima di quel giro)" }
    }
    Remove-Item -LiteralPath $Sentinella -Force -ErrorAction SilentlyContinue
    [void]$Rilievi.Add("UN GIRO PRECEDENTE ERA STATO INTERROTTO prima del ripristino: " + $esitoS + ", adesso, all'avvio di questo giro. L'EA .mq5/.ex5 di quel giro in MQL5\Experts viene comunque ricompilato qui.")
    Dico ("sentinella di un giro interrotto: " + $esitoS) "Yellow"
  }
  $residui = @(Get-ChildItem -LiteralPath $Work -Filter "*.prima_r116_*" -Recurse -ErrorAction SilentlyContinue)
  Dico ("pin ......... " + $Pin)
  if($OverrideSimbolo){ Dico ("simbolo ..... " + $Simbolo + "  <- OVERRIDE DICHIARATO (-Simbolo). I prova restano dichiarati sul LEAD " + $SimboloLead + " (@SIMBOLO " + $SimboloLead + ", e il gate lo PRETENDE): il parametro -Simbolo del generico VINCE sulla direttiva (walkforward_generico.ps1 righe 303-305). Etichetta " + $Etichetta + ": i CSV NON si sovrascrivono fra simboli.") "Yellow" }
  else{ Dico ("simbolo ..... " + $Simbolo + "  <- il LEAD, nessun override. Etichetta " + $Etichetta + ".") }
  Dico ("finestra .... IS " + $WinIS + " | OOS " + $WinOOS + " (split " + $FrazioneIS + ", come lo calcola il generico) -- UN SOLO REGIME, tick reali dal " + $DaQuando)
  Dico ("banco ....... MODELLO 4 (TICK REALI) | Spread=0 dichiarato | deposito " + $Deposito + " | rischio 0,65% | ora 8 SERVER = Londra 08:00-16:00 | max 4 agenti locali (nota 01/09)") "Yellow"
  Dico ("cancelli .... A1 E>=" + (Fmt3 $E_PASSA) + "R | A2 PF>=" + (Fmt2 $PF_PASSA) + " | A3 segno IS/OOS + PF IS>1 | A4 DD<=" + (Fmt2 $DD_PASSA) + "% | A5 PG>=" + (Fmt2 $PG_PASSA) + "% | A6 n>=" + $N_PASSA + " | B: E<" + (Fmt3 $E_MORTA) + " PF<" + (Fmt2 $PF_MORTA) + " IS<0 DD>" + (Fmt2 $DD_MORTA) + " PG<" + (Fmt2 $PG_MORTA) + " | S1 <= " + (Fmt2 $S1_SOGLIA) + "R") "Yellow"

  # -------------------------------------------------------------------
  #  1. SCARICO AL PIN
  # -------------------------------------------------------------------
  Titolo "1. SCARICO AL PIN (generico pinnato, 2 prova, EA, include)"
  $drv = Join-Path $Work "walkforward_generico.ps1"
  Scarica ($RawPin + "/backtest_pipeline/walkforward_generico.ps1") $drv
  $t = Get-Content -LiteralPath $drv -Raw
  if($t -notmatch '\$EABranch\s*=\s*"lavoro"'){ throw 'walkforward_generico.ps1 non ha la riga $EABranch = "lavoro" attesa: non lo posso pinnare (il pin varrebbe per il driver e NON per l''EA misurato).' }
  $t = $t -replace '\$EABranch\s*=\s*"lavoro"', ('$EABranch="' + $Pin + '"')
  Set-Content -LiteralPath $drv -Value $t -Encoding ASCII
  Dico "driver generico scaricato e PINNATO (riscarica l'EA al pin, non dalla punta del branch)" "Green"
  Remove-Item -Path (Join-Path $Prove "LONDONFX_R116_*.txt") -Force -ErrorAction SilentlyContinue
  foreach($f in @($PROVA_MAIN,$PROVA_F2)){ Scarica ($RawPin + "/backtest_pipeline/prove/" + $f) (Join-Path $Prove $f) }
  $mq5 = Join-Path $Work ($EA + ".mq5")
  $mqh = Join-Path $Work $INC
  Scarica ($RawPin + "/mql5/Experts/" + $EA + ".mq5") $mq5
  Dico ("scaricati: 2 prova + " + $EA + ".mq5 (" + (Get-Item -LiteralPath $mq5).Length + " byte)") "Green"

  # -------------------------------------------------------------------
  #  2. GATE SUL SORGENTE (identita' dell'EA al pin)
  # -------------------------------------------------------------------
  Titolo "2. GATE SUL SORGENTE: versione, autotest, magic, hedge-safe, include censiti"
  $srcRighe = @(LeggiTesto $mq5)
  $vers = @($srcRighe | Where-Object { $_ -match '^\s*#property\s+version\s+"([^"]+)"' } | ForEach-Object { [regex]::Match($_,'"([^"]+)"').Groups[1].Value })
  if($vers.Count -ne 1){ $VersTxt = "NON TROVATA (o doppia): " + $vers.Count + " righe #property version"; throw ("#property version non trovata (o doppia) in " + $EA + ".mq5: " + $vers.Count + " righe.") }
  $VersTxt = $vers[0]
  if($VersTxt -ne $VERSIONE_ATTESA){ throw ("versione letta '" + $VersTxt + "', attesa '" + $VERSIONE_ATTESA + "': il file al pin NON e' l'EA firmato. Un OK su un altro file sarebbe una misura vera su un oggetto sbagliato.") }
  $bl = @($srcRighe | Where-Object { $_ -match ('^\s*#define\s+LONDONFX_AUTOTEST_BLOCCHI_ATTESI\s+' + $BLOCCHI_ATTESI + '\b') }).Count
  $ca = @($srcRighe | Where-Object { $_ -match ('^\s*#define\s+LONDONFX_AUTOTEST_CASI_ATTESI\s+' + $CASI_ATTESI + '\b') }).Count
  $DefineTxt = "LONDONFX_AUTOTEST_BLOCCHI_ATTESI " + $BLOCCHI_ATTESI + " (" + $bl + " riga), LONDONFX_AUTOTEST_CASI_ATTESI " + $CASI_ATTESI + " (" + $ca + " riga)"
  if($bl -ne 1 -or $ca -ne 1){ throw ("i #define dell'autotest non sono quelli attesi (" + $BLOCCHI_ATTESI + " blocchi / " + $CASI_ATTESI + " casi): " + $DefineTxt) }
  $mg = @($srcRighe | Where-Object { $_ -match ('^\s*input\s+long\s+InpMagic\s*=\s*' + $MAGIC1 + '\s*;') }).Count
  $MagicTxt = "InpMagic default " + $MAGIC1 + " (" + $mg + " riga) -- gemello " + $MAGIC2 + " dal prova"
  if($mg -ne 1){ throw ("InpMagic default " + $MAGIC1 + " non trovato nel sorgente: " + $MagicTxt) }
  $hedge = 0
  foreach($riga in $srcRighe){ $viva = ($riga -replace '//.*$',''); if($viva -match 'Position(Select|Close|Modify|ClosePartial)\s*\(\s*_Symbol\s*[\),]'){ $hedge++ } }
  $HedgeTxt = "" + $hedge + " chiamate Position*(_Symbol) fuori dai commenti (attese 0: N1, hedge-safe dalla nascita)"
  if($hedge -gt 0){ throw ("L'EA NON e' hedge-safe: " + $HedgeTxt + ". Sul conto HEDGING chiuderebbe o modificherebbe la posizione del vicino.") }
  $incl = New-Object System.Collections.ArrayList
  foreach($riga in $srcRighe){ $viva = ($riga -replace '//.*$',''); $m = [regex]::Match($viva,'^\s*#include\s*[<"]([^>"]+)[>"]'); if($m.Success){ [void]$incl.Add($m.Groups[1].Value.Trim()) } }
  $IncTxt = "" + $incl.Count + " (" + ($incl -join ", ") + ")"
  $inattesi = @($incl | Where-Object { $_ -ne "Trade/Trade.mqh" -and $_ -ne $INC })
  if($inattesi.Count -gt 0){ throw ("include NON previsti nel sorgente: " + ($inattesi -join ", ") + ". La riga installa SOLO " + $INC + ": un terzo include va censito prima, non scoperto da una compilazione fallita.") }
  if(-not ($incl -contains $INC)){ [void]$Rilievi.Add("il sorgente NON include " + $INC + ": l'include non viene installato (la firma diceva Guardian acceso: da rileggere).") }
  Dico ("versione " + $VersTxt + " | " + $DefineTxt + " | " + $MagicTxt + " | " + $HedgeTxt + " | include " + $IncTxt) "Green"
  if($incl -contains $INC){
    Scarica ($RawPin + "/mql5/Include/" + $INC) $mqh
    $ng = @((LeggiTesto $mqh) | Where-Object { $_ -match '^\s*bool\s+ABTG_GuardiaIngresso\s*\(' }).Count
    $vinc = @((LeggiTesto $mqh) | Where-Object { $_ -match 'ABTG_PausaGuardian v(\d+\.\d+)' } | ForEach-Object { [regex]::Match($_,'ABTG_PausaGuardian v(\d+\.\d+)').Groups[1].Value } | Select-Object -Unique)
    $IncGuardia = "bool ABTG_GuardiaIngresso( trovata " + $ng + " volta (ancorata a destra); marcatore versione nell'include: " + $(if($vinc.Count -gt 0){ "v" + ($vinc -join ", v") } else { "NON TROVATO" }) + "; " + (Get-Item -LiteralPath $mqh).Length + " byte"
    if($ng -ne 1){ throw ("l'include al pin non definisce ESATTAMENTE una 'bool ABTG_GuardiaIngresso(' (" + $ng + "): l'EA non compilerebbe con la guardia attesa.") }
    Dico ("include scaricato al pin: " + $IncGuardia) "Green"
  }

  # -------------------------------------------------------------------
  #  3. GATE SUI DUE PROVA
  # -------------------------------------------------------------------
  Titolo "3. GATE SUI DUE PROVA (direttive nude, assi esatti, celle ricontate, fissi nome per nome, gemellaggio)"
  $gM = GateProva (Join-Path $Prove $PROVA_MAIN) $PROVA_MAIN $FissiMain $AssiMain $NCELLE_MAIN
  $gF = GateProva (Join-Path $Prove $PROVA_F2)   $PROVA_F2   $FissiF2   $AssiF2   $NCELLE_F2
  $CelleTxt = "" + $gM.Celle + " a finestra nella corsa principale (3 InpMotore x 2 InpMagic) + " + $gF.Celle + " a finestra in FASE 2 (InpSlippagePts 2/5), ricontate dai pin ||Y al pin"
  $GemProva = GateGemellaggio $gM.Lettura.Mappa $gF.Lettura.Mappa
  Dico ("gate prova: PASSATI. celle " + $CelleTxt) "Green"
  Dico ("gemellaggio principale/fase 2: " + $GemProva) "Green"

  # -------------------------------------------------------------------
  #  4. IL TERMINALE DI BACKTEST
  # -------------------------------------------------------------------
  Titolo "4. TERMINALE BCM DI BACKTEST (non -V3) e cartella dati"
  $allTerm = @(Get-ChildItem "C:\Program Files","C:\Program Files (x86)" -Recurse -Filter "terminal64.exe" -ErrorAction SilentlyContinue)
  if($Terminale -ne ""){
    if(-not (Test-Path -LiteralPath (Join-Path $Terminale "terminal64.exe"))){ throw ("-Terminale '" + $Terminale + "' non contiene terminal64.exe.") }
    $InstDir = $Terminale
    $TermTxt = $InstDir + " (imposto con -Terminale)"
  } else {
    $cand = @($allTerm | Where-Object { $_.DirectoryName -like "*BCM Markets MT5 Terminal*" -and $_.DirectoryName -notlike "*-V3*" })
    if($cand.Count -eq 0){ $cand = @($allTerm | Where-Object { $_.DirectoryName -like "*BCM Markets*" -and $_.DirectoryName -notlike "*-V3*" }) }
    if($cand.Count -ne 1){
      Write-Host "  installazioni MT5 con terminal64.exe trovate:" -ForegroundColor Gray
      foreach($tt in $allTerm){ Write-Host ("    " + $tt.DirectoryName) -ForegroundColor Gray }
      if($allTerm.Count -eq 0){ Write-Host "    (nessuna)" -ForegroundColor Gray }
      throw ("NON SO QUALE TERMINALE USARE: candidate BCM non -V3 = " + $cand.Count + ". Rilancia lo stesso blocco aggiungendo al driver: -Terminale '<cartella dell'installazione di backtest, copiata dall'elenco qui sopra>'.")
    }
    $InstDir = $cand[0].DirectoryName
    $TermTxt = $InstDir + " (selettore: BCM Markets, non -V3 -- lo stesso della sonda del passo 0)"
  }
  $MetaEditor = Join-Path $InstDir "metaeditor64.exe"
  if(-not (Test-Path -LiteralPath $MetaEditor)){ throw ("metaeditor64.exe non trovato in " + $InstDir) }
  $termRoot = Join-Path $env:APPDATA "MetaQuotes\Terminal"
  $DataFolder = (Get-ChildItem $termRoot -Directory -ErrorAction SilentlyContinue | Where-Object { $o = Join-Path $_.FullName "origin.txt"; (Test-Path $o) -and ((Get-Content $o -Raw).Trim() -ieq $InstDir) } | Select-Object -First 1 -ExpandProperty FullName)
  if(-not $DataFolder){
    $portable = Join-Path $InstDir "MQL5"
    if(Test-Path -LiteralPath $portable){ $DataFolder = $InstDir; [void]$Rilievi.Add("cartella dati PORTABLE (dentro l'installazione): nessun origin.txt la puntava.") }
    else{ throw ("cartella dati non trovata per " + $InstDir + " (nessun origin.txt in " + $termRoot + " la punta, e non e' portable).") }
  }
  Dico ("terminale: " + $TermTxt) "Yellow"
  Dico ("cartella dati: " + $DataFolder)

  # -------------------------------------------------------------------
  #  5. FOTO PRIMA, SENTINELLA, INCLUDE, COMPILAZIONE
  # -------------------------------------------------------------------
  Titolo "5. FOTO PRIMA -> sentinella -> include installato -> EA compilato (metaeditor64 diretto)"
  $dstExp = Join-Path $DataFolder "MQL5\Experts"
  $dstInc = Join-Path $DataFolder "MQL5\Include"
  New-Item -ItemType Directory -Force -Path $dstExp,$dstInc | Out-Null
  $TExpMq5 = Join-Path $dstExp ($EA + ".mq5")
  $TExpEx5 = Join-Path $dstExp ($EA + ".ex5")
  $TIncMqh = Join-Path $dstInc $INC
  $F1Prima = Foto $TExpMq5; $F2Prima = Foto $TExpEx5; $F3Prima = Foto $TIncMqh
  $FotoPrese = $true
  Dico ("foto PRIMA -- Experts\" + $EA + ".mq5: " + (FotoTxt $F1Prima))
  Dico ("foto PRIMA -- Experts\" + $EA + ".ex5: " + (FotoTxt $F2Prima))
  Dico ("foto PRIMA -- Include\" + $INC + ": " + (FotoTxt $F3Prima))
  if($incl -contains $INC){
    $IncEraLi = $F3Prima.Esiste
    $bkTxt = "nessun backup: l'include NON c'era"
    if($IncEraLi){ $IncBackup = $TIncMqh + ".prima_r116_" + $Stamp; Copy-Item -LiteralPath $TIncMqh -Destination $IncBackup -Force; $bkTxt = "backup " + $IncBackup }
    # LA SENTINELLA PRIMA DELLA SCRITTURA (classe 116, pezzo 1).
    Set-Content -LiteralPath $Sentinella -Value @($TIncMqh, $IncBackup) -Encoding ASCII
    Copy-Item -LiteralPath $mqh -Destination $TIncMqh -Force
    $IncInstallato = $true
    Dico ("include " + $INC + " installato AL PIN in MQL5\Include (" + $bkTxt + "); ripristinato a fine giro, foto DOPO nel referto") "Yellow"
  }
  Copy-Item -LiteralPath $mq5 -Destination $TExpMq5 -Force
  $esito = Compila $MetaEditor $TExpMq5 $TExpEx5 $logC 240
  $nErr = -1; $nWar = -1
  foreach($r in @($esito.Log)){
    $m = [regex]::Match($r, '(?i)(\d+)\s+error[s]?\s*,\s*(\d+)\s+warning')
    if($m.Success){ $nErr = [int]::Parse($m.Groups[1].Value,$INV); $nWar = [int]::Parse($m.Groups[2].Value,$INV); $ResultTxt = $r.Trim() }
  }
  if($nErr -lt 0){ $ResultTxt = "NON TROVATA nel log (fa fede l'.ex5 fresco)" }
  if($esito.Ex5 -and $nErr -le 0){
    $itm = Get-Item -LiteralPath $TExpEx5
    $Compilato = "OK (" + [int]($itm.Length/1024) + " KB, " + $itm.Length + " byte, " + $itm.LastWriteTime.ToString("HH:mm:ss",$INV) + "), errori 0, warning " + $(if($nWar -ge 0){ "" + $nWar } else { "NON LETTI" })
    Dico ("COMPILATO: " + $Compilato) "Green"
    if($nWar -gt 0){ foreach($r in @($esito.Log)){ if($r -match '(?i):\s*warning'){ [void]$Rilievi.Add("warning di compilazione: " + $r.Trim()) } } }
  }
  else{
    if($esito.Muto -or @($esito.Log).Count -eq 0){
      $Compilato = "FALLITA -- METAEDITOR MUTO: lanciato ed e' tornato SENZA scrivere ne' log ne' .ex5 (il rc=0 muto del 22/08: editor aperto, percorso, permessi). NON e' un verdetto sul codice."
    } else {
      $Compilato = "FALLITA (MetaEditor lanciato, nessun .ex5 fresco; errori dal log: " + $(if($nErr -ge 0){ "" + $nErr } else { "NON LETTI" }) + ") -- EA MAI COMPILATO PRIMA: QUESTO E' IL RISULTATO DEL PASSO. Le prime 30 righe del log sono nel referto, il log intero nello zip."
    }
    $k = 0
    foreach($r in @($esito.Log)){ if($r.Trim() -eq ""){ continue }; Write-Host ("      " + $r) -ForegroundColor Red; $k++; if($k -ge 30){ break } }
    throw ("COMPILAZIONE FALLITA: " + $Compilato)
  }

  # -------------------------------------------------------------------
  #  6. CACHE DEL TESTER (classe 38) e FOTO DEI LOG
  # -------------------------------------------------------------------
  Titolo "6. Tester\cache svuotata (SOLO quella) e log del tester fotografati"
  $cacheT = Join-Path $DataFolder "Tester\cache"
  if(Test-Path -LiteralPath $cacheT){
    $ncPrima = @(Get-ChildItem -LiteralPath $cacheT -Recurse -File -ErrorAction SilentlyContinue).Count
    Remove-Item (Join-Path $cacheT "*") -Recurse -Force -ErrorAction SilentlyContinue
    $ncDopo  = @(Get-ChildItem -LiteralPath $cacheT -Recurse -File -ErrorAction SilentlyContinue).Count
    $CacheTxt = "prima " + $ncPrima + " file, dopo " + $ncDopo
    if($ncDopo -gt 0){ [void]$Problemi.Add("Tester\cache NON si e' svuotata (" + $CacheTxt + "): un pass ripescato non chiama OnTester e lascia il CSV monco (classe 38)."); Dico ("Tester\cache NON SVUOTATA: " + $CacheTxt) "Red" }
    else{ Dico ("Tester\cache svuotata: " + $CacheTxt) "Green" }
  } else { $CacheTxt = "cartella assente (" + $cacheT + "): niente da svuotare"; Dico ("Tester\cache: " + $CacheTxt) "Yellow" }
  FotografaLog

  # -------------------------------------------------------------------
  #  7. LA CORSA PRINCIPALE (6 celle x IS + OOS)
  # -------------------------------------------------------------------
  Titolo ("7. CORSA PRINCIPALE: " + $NCELLE_MAIN + " celle x 2 finestre a TICK REALI (generico, -Rifai)")
  $motore2Passa = $false
  if(-not $SoloFase2){
    $tCorsa = Get-Date
    LanciaGenerico $drv (Join-Path $Prove $PROVA_MAIN) $Etichetta
    if($SoloControllo){
      $CorsaMain = "CONTROLLO (generico -SoloControllo: MT5 NON aperto, anteprima .ini scritta -- NON e' l'.ini che girera', classe 96)"
    } else {
      $CorsaMain = "LANCIATA alle " + $tCorsa.ToString("HH:mm:ss",$INV)
      LeggiFinestra $WIN["IS"]  $tCorsa 0 $true
      LeggiFinestra $WIN["OOS"] $tCorsa 0 $true
      if($WIN["IS"].Letto -and $WIN["OOS"].Letto){
        $CorsaMain = $CorsaMain + " -- CSV IS e OOS LETTI (freschi), " + $WIN["IS"].NRighe + " + " + $WIN["OOS"].NRighe + " righe"
        # VERDETTI per motore (cancelli A/B) e ABLAZIONE S1/S2/S3 in OOS
        foreach($m in @(1,2,3)){
          if($WIN["IS"].PerMotore.ContainsKey("" + $m) -and $WIN["OOS"].PerMotore.ContainsKey("" + $m)){
            $VerdettiA["" + $m] = VerdettoMotore $WIN["IS"].PerMotore["" + $m] $WIN["OOS"].PerMotore["" + $m]
          } else { $VerdettiA["" + $m] = @{ Esito="SENZA NUMERI (riga mancante in IS o OOS)"; Passa=$false; Dettagli="" } }
        }
        if($VerdettiA["2"].Passa){ $motore2Passa = $true }
        $eOos = @{}; $sospesi = New-Object System.Collections.ArrayList; $segni = @{}
        foreach($m in @(1,2,3)){
          if($WIN["OOS"].PerMotore.ContainsKey("" + $m)){
            $r = $WIN["OOS"].PerMotore["" + $m]
            $eOos["" + $m] = $r.EInR; $segni["" + $m] = [math]::Sign($r.Profit)
            if($r.N -lt $N_PASSA){ [void]$sospesi.Add("motore " + $m + " (n OOS " + $r.N + " < " + $N_PASSA + ")") }
          }
        }
        if(@($eOos.Keys).Count -eq 3){
          $vals = @($eOos.Values | ForEach-Object { [double]$_ })
          $mx = ($vals | Measure-Object -Maximum).Maximum; $mn = ($vals | Measure-Object -Minimum).Minimum
          $s1 = (($mx - $mn) -le $S1_SOGLIA)
          $s2 = ($segni["1"] -eq $segni["2"] -and $segni["2"] -eq $segni["3"])
          $s3 = ($sospesi.Count -eq 0)
          $testo = "E OOS in R: motore 1 " + (Fmt4 $eOos["1"]) + " | motore 2 " + (Fmt4 $eOos["2"]) + " | motore 3 " + (Fmt4 $eOos["3"]) + " -> max-min " + (Fmt4 ($mx-$mn)) + "R (S1 soglia " + (Fmt2 $S1_SOGLIA) + "R: " + $(if($s1){"VERO"}else{"FALSO"}) + ") | S2 stesso segno: " + $(if($s2){"VERO"}else{"FALSO"}) + " | S3 n>=150 tutti: " + $(if($s3){"VERO"}else{"FALSO: " + ($sospesi -join ", ")}) + " -> "
          if(-not $s3){ $testo = $testo + "CONFRONTO SOSPESO sui motori sotto 150 (valvola R59): non si conclude ne' uguale ne' diverso" }
          elseif($s1 -and $s2){ $testo = $testo + "I TRE MOTORI VANNO UGUALE: IL CONTENITORE E' L'EDGE, IL SEGNALE NON CONTA. Nessuna sedia sul segnale LondonFx; oggetto di studio = il contenitore, round nuovo" }
          elseif(($eOos["2"] - [math]::Max($eOos["1"],$eOos["3"])) -gt $S1_SOGLIA){ $testo = $testo + "IL MOTORE 2 STACCA gli altri due di piu' di " + (Fmt2 $S1_SOGLIA) + "R: il segnale guadagna il suo posto" }
          elseif($eOos["1"] -ge $eOos["2"] -and $eOos["1"] -ge $eOos["3"]){ $testo = $testo + "IL MOTORE 1 (NUDO) E' IL MIGLIORE: conferma della lezione di casa (filtro appiccicato = 0/5). NON si promuove il nudo (e' il controllo): tesi di un round successivo" }
          else{ $testo = $testo + "differenze sopra " + (Fmt2 $S1_SOGLIA) + "R senza che il motore 2 stacchi entrambi i controlli: si scrive cosi', nessuna promozione" }
          $Ablazione = $testo
        } else { $Ablazione = "NON CALCOLABILE (manca la riga OOS di almeno un motore)" }
        # LO SPREAD MISURATO (H12): dal motore 2 in OOS e IS
        $r2o = $WIN["OOS"].PerMotore["2"]; $r2i = $WIN["IS"].PerMotore["2"]
        if($null -ne $r2o -and $null -ne $r2i){
          $SpreadTxt = $Simbolo + " sessione di Londra, motore 2 -- IS: mediana " + (Fmt3 $r2i.SprMed) + " pip, P95 " + (Fmt3 $r2i.SprP95) + " pip (campione " + $r2i.SprN + ") | OOS: mediana " + (Fmt3 $r2o.SprMed) + " pip, P95 " + (Fmt3 $r2o.SprP95) + " pip (campione " + $r2o.SprN + "). SI ARCHIVIA ANCHE SE IL ROUND BOCCIA TUTTO (chiude H12). Prudenziale se la misura mancasse: 1,50 pip EURUSD / 2,00 pip GBPUSD [ASSUNTO]."
          if($r2o.SprN -le 0){ $SpreadTxt = "MISURA MANCANTE (campione 0): si rilegge con lo spread PRUDENZIALE 1,50 pip EURUSD / 2,00 pip GBPUSD [ASSUNTO, NON MISURATO], criteri par. 5.5." }
        }
        # PER-TRADE (v1.01): raccolta nello zip, 6 file (3 motori x 2
        # magic), FRESCHI rispetto all'avvio DI QUESTA corsa ($tCorsa).
        # Rappresentano SOLO l'OOS (l'IS e' stato sovrascritto: vedi
        # nota sopra $CommonFiles). Assente/vecchio = dichiarato nei
        # RILIEVI con la formula di casa, MAI letto come zero trade.
        $coppiePT = @()
        foreach($m in @(1,2,3)){ foreach($mg in @($MAGIC1,$MAGIC2)){ $coppiePT += [pscustomobject]@{ Motore=$m; Magic=$mg } } }
        $esitoPT = RaccogliPerTrade $coppiePT $tCorsa "main" "corsa principale (rappresenta SOLO l'OOS)"
        $PerTradeCopie = @($PerTradeCopie) + @($esitoPT.Copie)
        $PerTradeRighe = @($PerTradeRighe) + @("corsa principale (finestra OOS, avvio " + $tCorsa.ToString("yyyy-MM-dd HH:mm:ss",$INV) + "):") + @($esitoPT.Righe)
        $PerTradeTxt = "raccolti " + @($esitoPT.Copie).Count + "/6 file freschi -- rappresentano SOLO l'OOS (il nome del file non porta la finestra, e l'OOS e' l'ultima a scrivere: l'IS non e' recuperabile da qui, stesso limite di RIGA_R112_EMADOW_CONTRATTO.ps1). Righe per motore/magic sotto."
      } else { $CorsaMain = $CorsaMain + " -- CSV NON LETTI (vedi PROBLEMI)" }
    }
  } else {
    $CorsaMain = "SALTATA (-SoloFase2): i CSV della corsa principale NON vengono riletti qui; il verdetto A del motore 2 si legge dal referto della corsa principale"
    $motore2Passa = $true
    [void]$Rilievi.Add("-SoloFase2: la fase 2 gira FORZATA senza il cancello A letto a macchina. E' una misura di fragilita', non una selezione: NON puo' promuovere niente.")
  }

  # -------------------------------------------------------------------
  #  8. FASE 2 (slippage 2/5, motore 2) -- SOLO se dovuta
  # -------------------------------------------------------------------
  Titolo "8. FASE 2 (R55-bis): slippage 2 e 5 punti sul motore 2"
  if($SoloControllo){
    $tF2 = Get-Date
    LanciaGenerico $drv (Join-Path $Prove $PROVA_F2) $EtichettaF2
    $Fase2Txt = "CONTROLLO (generico -SoloControllo sul prova di fase 2: gate e conteggio celle eseguiti, MT5 NON aperto)"
  }
  elseif($motore2Passa){
    $tF2 = Get-Date
    LanciaGenerico $drv (Join-Path $Prove $PROVA_F2) $EtichettaF2
    LeggiFinestra $WIN["F2_IS"]  $tF2 -1 $false
    LeggiFinestra $WIN["F2_OOS"] $tF2 -1 $false
    if($WIN["F2_OOS"].Letto){
      $Fase2Txt = "GIRATA alle " + $tF2.ToString("HH:mm:ss",$INV) + " (" + $WIN["F2_IS"].NRighe + " + " + $WIN["F2_OOS"].NRighe + " righe)"
      $r5 = $WIN["F2_OOS"].PerMotore["2_slip5"]; $r2 = $WIN["F2_OOS"].PerMotore["2_slip2"]
      if($null -ne $r5){
        $Fase2Verdetto = "E OOS a slip 2 = " + $(if($null -ne $r2){ Fmt4 $r2.EInR } else { "n/d" }) + "R, a slip 5 = " + (Fmt4 $r5.EInR) + "R (PF " + (Fmt3 $r5.PF) + ", DD " + (Fmt2 $r5.DD) + "%, n " + $r5.N + ") -> "
        if($r5.EInR -ge $E_PASSA){ $Fase2Verdetto = $Fase2Verdetto + "REGGE A 5 PUNTI (E >= " + (Fmt3 $E_PASSA) + "R): il diritto di chiedere la prova di rischio sul vecchio (round separato R-C) resta in piedi. NESSUNA SEDIA da qui." }
        else{ $Fase2Verdetto = $Fase2Verdetto + "VIVE SOLO A TAGLIA PICCOLA (E < " + (Fmt3 $E_PASSA) + "R a 5 punti, etichetta R55 dell'ORB): NON si propone." }
      } else { $Fase2Verdetto = "riga slip 5 MANCANTE nel CSV OOS di fase 2: verdetto NON leggibile" }
      # PER-TRADE FASE 2 (v1.01): UN solo file possibile (motore 2,
      # magic 774001 fisso nel prova F2): rappresenta SOLO l'ultima
      # cella scritta (slip 5, l'ultima dell'asse 2||2||3||5||Y), MAI
      # slip 2 (stesso nome, sovrascritto). Dichiarato, non nascosto.
      $esitoPTF2 = RaccogliPerTrade @([pscustomobject]@{ Motore=2; Magic=$MAGIC1 }) $tF2 "f2" "fase 2 (rappresenta SOLO l'ultima cella scritta, slip 5: slip 2 ha lo STESSO nome file e viene sovrascritto)"
      $PerTradeCopie = @($PerTradeCopie) + @($esitoPTF2.Copie)
      $PerTradeRighe = @($PerTradeRighe) + @("fase 2 (motore 2 magic " + $MAGIC1 + ", rappresenta SOLO slip 5, avvio " + $tF2.ToString("yyyy-MM-dd HH:mm:ss",$INV) + "):") + @($esitoPTF2.Righe)
      if($SoloFase2){ $PerTradeTxt = "raccolti " + @($esitoPTF2.Copie).Count + "/1 file freschi dalla FASE 2 (-SoloFase2: la corsa principale non e' stata rifatta qui, nessun per-trade raccolto da essa in questo giro). Rappresenta SOLO slip 5 (slip 2 ha lo stesso nome file e viene sovrascritto)." }
      else{ $PerTradeTxt = $PerTradeTxt + " + fase 2: " + @($esitoPTF2.Copie).Count + "/1 file fresco (slip 5, slip 2 sovrascritto)." }
    } else { $Fase2Txt = "LANCIATA alle " + $tF2.ToString("HH:mm:ss",$INV) + " ma CSV OOS NON LETTO (vedi PROBLEMI)" }
  }
  else{
    $Fase2Txt = "NON DOVUTA: il motore 2 NON passa tutti i cancelli A su " + $Simbolo + " (criteri par. 5.6: la fase 2 si fa SOLO sulle celle che passano). Nessuna passata spesa."
    Dico $Fase2Txt "Yellow"
  }

  # -------------------------------------------------------------------
  #  9. I LOG DEL TESTER e il MODELLO letto dall'.ini VERO
  # -------------------------------------------------------------------
  Titolo "9. LOG DEL TESTER (righe 'ticks data begins from') e Model= dall'.ini vero"
  if(-not $SoloControllo){
    $LogLetti = RaccogliLog
    $tickR = @($RigheLog | Where-Object { $_ -match 'ticks data begins' -and $_ -match $Simbolo })
    if($tickR.Count -gt 0){ $TickTxt = ($tickR | Select-Object -Last 1) } else { $TickTxt = "NON TROVATA nei log cresciuti (" + $LogLetti + " log letti): 'non l'ho letta' NON vuol dire 'i tick c'erano'. Da cercare a mano nel Diario del tester." ; [void]$Rilievi.Add("riga 'ticks data begins from' per " + $Simbolo + " NON trovata nei log del tester letti a macchina: la copertura tick della finestra resta DA VERIFICARE nel Diario.") }
    $mem = @($RigheLog | Where-Object { $_ -match 'no memory' })
    if($mem.Count -gt 0){ [void]$Problemi.Add("'no memory for ticks generating' nei log del tester (" + $mem.Count + " righe): pass falliti per RAM. Riavvio del PC, max 4 agenti, e si rilancia (nota 01/09).") }
    $inis = @(Get-ChildItem -LiteralPath $Work -Filter ("gen_" + $EA + "_" + $Simbolo + "_*" + $Etichetta + ".ini") -ErrorAction SilentlyContinue | Where-Object { $_.LastWriteTime -ge $Avvio })
    $mods = @()
    foreach($ini in $inis){ $mods += @((Get-Content -LiteralPath $ini.FullName) | Where-Object { $_ -match '^Model=' } | ForEach-Object { $ini.Name + ": " + $_.Trim() }) }
    if($mods.Count -gt 0){ $ModelTxt = ($mods -join " | ") + "  (dall'.ini VERO scritto dal generico per QUESTA corsa, non dall'anteprima)"; if(@($mods | Where-Object { $_ -notmatch 'Model=4$' }).Count -gt 0){ [void]$Problemi.Add("un .ini vero della corsa NON ha Model=4: " + ($mods -join " | ")) } }
    else{ $ModelTxt = "NESSUN gen_*.ini fresco trovato nella cartella di lavoro: Model NON verificato a macchina" ; if(-not $SoloFase2){ [void]$Problemi.Add("Model=4 NON verificabile: nessun .ini vero della corsa principale trovato (" + $Work + ").") } }
  } else { $LogLetti = 0; $TickTxt = "n/d (giro a vuoto)"; $ModelTxt = "n/d (giro a vuoto: l'anteprima scrive Model=4 hardcoded e NON fa da prova, classe 96)" }
}
catch{
  $Fatale = ("" + $_.Exception.Message)
  Write-Host ""
  Write-Host ("!!! FERMATO: " + $Fatale) -ForegroundColor Red
}

# =====================================================================
#  RIPRISTINO -- SEMPRE, anche se il giro e' morto a meta' (classe 116).
# =====================================================================
if($IncInstallato){
  try{
    if($IncEraLi -and $IncBackup -ne "" -and (Test-Path -LiteralPath $IncBackup)){
      Copy-Item -LiteralPath $IncBackup -Destination $TIncMqh -Force
      Remove-Item -LiteralPath $IncBackup -Force -ErrorAction SilentlyContinue
      $Ripristino = "include del terminale RIPRISTINATO dal backup (c'era gia' prima di questo giro)"
    } else {
      Remove-Item -LiteralPath $TIncMqh -Force -ErrorAction SilentlyContinue
      $Ripristino = "include del terminale RIMOSSO (non c'era prima di questo giro)"
    }
    Remove-Item -LiteralPath $Sentinella -Force -ErrorAction SilentlyContinue
  }
  catch{ $Ripristino = "RIPRISTINO FALLITO: " + $_.Exception.Message; [void]$Problemi.Add("RIPRISTINO FALLITO dell'include nel terminale (" + $TIncMqh + "): controllalo a mano. La sentinella resta e il prossimo giro ci riprova.") }
}
if($FotoPrese){
  try{
    $F1Dopo = Foto $TExpMq5; $F2Dopo = Foto $TExpEx5; $F3Dopo = Foto $TIncMqh
    foreach($t in @(@{N=("Experts\" + $EA + ".mq5"); A=$F1Prima; B=$F1Dopo; Atteso="SCRITTO (l'EA al pin: resta, come ogni EA della pipeline)"},
                    @{N=("Experts\" + $EA + ".ex5"); A=$F2Prima; B=$F2Dopo; Atteso="SCRITTO (compilato qui: resta, il tester lo richiede)"},
                    @{N=("Include\" + $INC);          A=$F3Prima; B=$F3Dopo; Atteso="INVARIATO (installato al pin e RIMESSO com'era)"})){
      $stato = "INVARIATO"
      if($t.A.Esiste -ne $t.B.Esiste -or $t.A.Len -ne $t.B.Len){ $stato = "CAMBIATO" } elseif($t.A.Ora -ne $t.B.Ora){ $stato = "stessa dimensione, data diversa" }
      [void]$RigheFotoDopo.Add("  " + $t.N + ": prima [" + (FotoTxt $t.A) + "] dopo [" + (FotoTxt $t.B) + "] -> " + $stato + "   atteso: " + $t.Atteso)
      if($t.N -like "Include*" -and $stato -eq "CAMBIATO"){ [void]$Problemi.Add("l'include del terminale RISULTA CAMBIATO dopo il ripristino: controlla la foto prima/dopo e rimettilo a mano.") }
    }
  } catch { [void]$Problemi.Add("non ho potuto rifare la foto dei file del terminale: il ripristino resta DICHIARATO e non MISURATO.") }
}

# =====================================================================
#  RACCOLTA -- SEMPRE, anche quando la corsa si e' fermata a meta'.
# =====================================================================
Titolo "RACCOLTA"
$Cart = Join-Path $Dsk $ZipNome
if(Test-Path -LiteralPath $Cart){ Remove-Item -LiteralPath $Cart -Recurse -Force -ErrorAction SilentlyContinue }
New-Item -ItemType Directory -Force -Path $Cart | Out-Null
if($residui.Count -gt 0){ [void]$Rilievi.Add("" + $residui.Count + " backup *.prima_r116_* di giri passati nella cartella di lavoro (primo: " + $residui[0].Name + "): NON cancellati da soli, li decide chi legge.") }

$R = New-Object System.Collections.ArrayList
[void]$R.Add("=====================================================================")
[void]$R.Add(" R116 -- LONDONFX A TICK REALI (" + $EA + " v" + $VERSIONE_ATTESA + ") -- " + $Simbolo + " M15")
[void]$R.Add(" UN contenitore, TRE motori (ablazione) x 2 magic gemelli -- criteri FIRMATI 03/09")
[void]$R.Add("=====================================================================")
[void]$R.Add("modo: " + $Modo + "   <- CONTROLLO = giro a vuoto, NON e' il risultato; FASE2 = sola fase 2 forzata")
[void]$R.Add("data: " + $Avvio.ToString("yyyy-MM-dd HH:mm:ss",$INV) + "   <- ORA DI AVVIO del giro (non l'ora in cui leggi: la corsa dura decine di minuti)")
[void]$R.Add("pin:  " + $Pin)
if($OverrideSimbolo){
  [void]$R.Add("simbolo di questa corsa: " + $Simbolo + ", OVERRIDE DICHIARATO da riga di comando (-Simbolo " + $Simbolo + "); prova dichiarati sul lead " + $SimboloLead)
  [void]$R.Add("  come funziona: i prova portano '@SIMBOLO " + $SimboloLead + "' e il gate lo PRETENDE; il generico legge la direttiva SOLO se -Simbolo e' vuoto (righe 303-305), qui vince " + $Simbolo + ". Etichette " + $Etichetta + " / " + $EtichettaF2 + " nei nomi dei CSV.")
} else { [void]$R.Add("simbolo di questa corsa: " + $Simbolo + ", il LEAD -- nessun override. Etichette " + $Etichetta + " / " + $EtichettaF2 + ".") }
[void]$R.Add("finestra: IS " + $WinIS + " | OOS " + $WinOOS + "  (split " + $FrazioneIS + " come lo calcola il generico) -- UN SOLO REGIME, tick reali dal " + $DaQuando + " (pavimento misurato il 01/09)")
[void]$R.Add("  regime contenuto [DICHIARATO]: IS = seconda meta' 2024 + primo trimestre 2025 (dollaro forte fino a gennaio 2025, poi inversione); OOS = da aprile 2025 (risalita dell'euro 2025 e quello che e' venuto dopo, da leggere sul grafico, non assunto). Nessuna prova di regime: da qui NON esce una sedia (F12).")
[void]$R.Add("banco: MODELLO 4 = tick REALI | Spread=0 nell'.ini (corrente, DICHIARATO) | deposito " + $Deposito + " | leva 100 | rischio 0,65% | sessione 08:00-16:00 ORA SERVER (= Londra) | TP 15,0 / SL 8,0 pip su ENTRAMBE le gambe | slippage 0 (fase 2: 2/5)")
[void]$R.Add("terminale: " + $TermTxt)
[void]$R.Add("cartella dati: " + $DataFolder)
[void]$R.Add("compilazione: " + $Compilato + "   <- EA MAI COMPILATO PRIMA: se e' FALLITA, QUESTO e' il risultato del passo")
[void]$R.Add("riga Result del log: " + $ResultTxt)
[void]$R.Add("versione letta dal #property: " + $VersTxt + "   (attesa " + $VERSIONE_ATTESA + ")")
[void]$R.Add("autotest dichiarato nel sorgente: " + $DefineTxt)
[void]$R.Add("magic: " + $MagicTxt)
[void]$R.Add("hedge-safe (N1): " + $HedgeTxt)
[void]$R.Add("include censiti nel sorgente: " + $IncTxt)
[void]$R.Add("include al pin: " + $IncGuardia)
[void]$R.Add("ripristino del terminale: " + $Ripristino)
[void]$R.Add("foto PRIMA/DOPO dei file del terminale (classe 116: la prova sta nella foto, non nella frase):")
if($RigheFotoDopo.Count -eq 0){ [void]$R.Add("  NON PRESE: il giro si e' fermato prima di guardare il terminale, niente e' stato scritto") }
foreach($l in $RigheFotoDopo){ [void]$R.Add($l) }
[void]$R.Add("cache tester: " + $CacheTxt)
[void]$R.Add("celle: " + $CelleTxt)
[void]$R.Add("gemellaggio prova principale/fase 2: " + $GemProva)
[void]$R.Add("corsa principale: " + $CorsaMain)
[void]$R.Add("fase 2 (slippage 2/5, motore 2): " + $Fase2Txt)
[void]$R.Add("Model letto: " + $ModelTxt)
[void]$R.Add("riga del Diario 'ticks data begins from' (" + $Simbolo + "): " + $TickTxt)
[void]$R.Add("log del tester letti a macchina (cresciuti in questo giro): " + $(if($LogLetti -ge 0){ "" + $LogLetti } else { "NON LETTI" }))
[void]$R.Add("per-trade (v1.01): " + $PerTradeTxt)
foreach($l in $PerTradeRighe){ [void]$R.Add("  " + $l) }
[void]$R.Add("  punto 5.0.5 (prima data del per-trade DALL'INIZIO della finestra IS): NON verificabile dal file raccolto (rappresenta l'OOS, non l'IS) -- SEGNALATO; la copertura tick si legge dalla riga del Diario qui sopra")
[void]$R.Add("  punto S4 (correlazione P&L giornalieri fra i tre motori, informativa): ESEGUIBILE A MANO dai CSV magic " + $MAGIC1 + " allegati -- raggruppa 'net_profit' per data di 'close_time', somma per giorno, allinea le tre serie sulle date comuni (mancanti = 0), correlazione di Pearson a coppie; >= 0,80 e' un secondo indizio che i motori siano lo stesso oggetto. NON calcolata qui: non decide da sola (criteri par. 3.2).")
[void]$R.Add("")
[void]$R.Add("--- I CANCELLI (congelati PRIMA dei numeri, criteri par. 5; fasce DISGIUNTE par. 5.8) ---")
[void]$R.Add("  A1 E OOS >= " + (Fmt3 $E_PASSA) + "R (zona morta " + (Fmt3 $E_MORTA) + "-" + (Fmt3 $E_PASSA) + ", bocciata < " + (Fmt3 $E_MORTA) + ") | A2 PF OOS >= " + (Fmt2 $PF_PASSA) + " (zona " + (Fmt2 $PF_MORTA) + "-" + (Fmt2 $PF_PASSA) + ", bocciata < " + (Fmt2 $PF_MORTA) + ")")
[void]$R.Add("  A3 segno IS/OOS coerente e PF IS > 1,00 (IS negativo = bocciata) | A4 DD OOS <= " + (Fmt2 $DD_PASSA) + "% (zona fino a " + (Fmt2 $DD_MORTA) + ", bocciata PER RISCHIO oltre)")
[void]$R.Add("  A5 Peggior Giornata >= " + (Fmt2 $PG_PASSA) + "% (zona fino a " + (Fmt2 $PG_MORTA) + ", bocciata PER RISCHIO sotto) | A6 n >= " + $N_PASSA + " IS e OOS (30-149 merito sospeso, < 30 non misurabile)")
[void]$R.Add("  Il RISCHIO boccia a QUALUNQUE n. Ambiguita' -> clausola PIU' SEVERA, dichiarata. Promuovibile SOLO il motore 2, gamba per gamba. Vietato nominare 'la cella migliore'.")
[void]$R.Add("")
[void]$R.Add("--- IL CANARINO, PRIMA DEL CONTO ECONOMICO (par. 4.3) -- per motore, per finestra (riga magic " + $MAGIC1 + ") ---")
[void]$R.Add(("{0,-4} {1,-3} {2,7} {3,7} {4,7} {5,6} {6,6} {7,7} {8,8} {9,8} {10,6} {11,6}" -f "fin","mot","SegGen","SoppPos","SoppTet","GgTet","GgCap","Flat%","SprMed","SprP95","Notti","Canar"))
foreach($wk in @("IS","OOS")){
  $w = $WIN[$wk]
  if(-not $w.Letto){ [void]$R.Add(("{0,-4} " -f $wk) + "SENZA NUMERI (CSV non letto: " + $w.CsvOra + ")"); continue }
  foreach($m in @(1,2,3)){
    if(-not $w.PerMotore.ContainsKey("" + $m)){ [void]$R.Add(("{0,-4} {1,-3} " -f $wk,$m) + "riga mancante"); continue }
    $rg = $w.PerMotore["" + $m]
    [void]$R.Add(("{0,-4} {1,-3} {2,7} {3,7} {4,7} {5,6} {6,6} {7,7} {8,8} {9,8} {10,6} {11,6}" -f $wk,$m,$rg.SegGen,$rg.SoppPos,$rg.SoppTetto,$rg.GgTetto,$rg.GgCap,(Fmt2 $rg.FlatPct),(Fmt3 $rg.SprMed),(Fmt3 $rg.SprP95),$rg.Notti,$rg.Canarino))
  }
}
[void]$R.Add("  (Giorni col Tetto Colpito > " + (Fmt2 $TETTO_PCT) + "% dei giorni contati = motore STROZZATO, confronto S1 contaminato; Flat > " + (Fmt2 $FLAT_PCT) + "% = si misura l'OROLOGIO. Le dichiarazioni, se scattano, stanno nei RILIEVI.)")
[void]$R.Add("")
[void]$R.Add("--- IL CONTO ECONOMICO, per motore e finestra (riga magic " + $MAGIC1 + "; n IS e n OOS accanto a OGNI numero) ---")
[void]$R.Add(("{0,-4} {1,-3} {2,6} {3,5} {4,5} {5,11} {6,7} {7,8} {8,8} {9,8} {10,8}" -f "fin","mot","n","nL","nS","profitto","PF","E in R","DD%","PegGg%","giorni"))
foreach($wk in @("IS","OOS")){
  $w = $WIN[$wk]
  if(-not $w.Letto){ [void]$R.Add(("{0,-4} " -f $wk) + "SENZA NUMERI"); continue }
  foreach($m in @(1,2,3)){
    if(-not $w.PerMotore.ContainsKey("" + $m)){ continue }
    $rg = $w.PerMotore["" + $m]
    [void]$R.Add(("{0,-4} {1,-3} {2,6} {3,5} {4,5} {5,11} {6,7} {7,8} {8,8} {9,8} {10,8}" -f $wk,$m,$rg.N,$rg.IngL,$rg.IngS,(Fmt2 $rg.Profit),(Fmt3 $rg.PF),(Fmt4 $rg.EInR),(Fmt2 $rg.DD),(Fmt2 $rg.PG),$rg.Giorni))
  }
  [void]$R.Add("  " + $wk + ": CSV scritto alle " + $w.CsvOra + " (FRESCO: piu' recente dell'avvio della corsa) | righe " + $w.NRighe + " (attese " + $w.CelleAttese + ") | gemelli: " + $w.Gemelli)
}
[void]$R.Add("  motori: 1 = " + $NomiMotore[1] + " | 2 = " + $NomiMotore[2] + " | 3 = " + $NomiMotore[3])
[void]$R.Add("  E in R = payoff medio / rischio medio DICHIARATO all'apertura (colonna dell'EA, esatta al primo ordine). Profitti in EURO a deposito " + $Deposito + ": NON confrontabili con i round a 1,00%.")
[void]$R.Add("")
[void]$R.Add("--- I VERDETTI PER MOTORE (cancelli A/B, letti in OOS con IS per A3/A6) ---")
foreach($m in @(1,2,3)){
  if($VerdettiA.ContainsKey("" + $m)){
    [void]$R.Add("  motore " + $m + " (" + $NomiMotore[$m] + "): " + $VerdettiA["" + $m].Esito)
    if($VerdettiA["" + $m].Dettagli -ne ""){ [void]$R.Add("     " + $VerdettiA["" + $m].Dettagli) }
    if($m -ne 2 -and $VerdettiA["" + $m].Passa){ [void]$R.Add("     >>> E' UN RAMO DI CONTROLLO: anche se passa, NON si promuove (F11). Si scrive, e basta.") }
  } else { [void]$R.Add("  motore " + $m + ": SENZA VERDETTO (corsa non letta)") }
}
[void]$R.Add("  A5 e il cap del 2%: se A5 passa, passa ANCHE grazie a un cap che sta nella fonte, non a un merito del segnale (par. 5.4). Se A5 fallisce LO STESSO, il cap non funziona come crediamo: si indaga il CONTENITORE prima del merito.")
[void]$R.Add("  F5: lo short gira con soglia RSI 20 (simmetrica, firmata), PIU' PERMISSIVA del 10 dell'autore. Se lo short passa e il long no, va scritto cosi'.")
[void]$R.Add("")
[void]$R.Add("--- L'ABLAZIONE S1/S2/S3 (par. 3.2, OOS, soglia S1 = " + (Fmt2 $S1_SOGLIA) + "R = 2/3 del cancello H8) ---")
[void]$R.Add("  " + $Ablazione)
[void]$R.Add("")
[void]$R.Add("--- FASE 2 (par. 5.6): il verdetto si legge a 5 PUNTI ---")
[void]$R.Add("  stato: " + $Fase2Txt)
[void]$R.Add("  verdetto: " + $Fase2Verdetto)
foreach($wk in @("F2_IS","F2_OOS")){
  $w = $WIN[$wk]
  if(-not $w.Letto){ continue }
  foreach($k in @("2_slip2","2_slip5")){
    if(-not $w.PerMotore.ContainsKey($k)){ continue }
    $rg = $w.PerMotore[$k]
    [void]$R.Add("  " + $w.Tag + " " + $k + ": n " + $rg.N + " | profitto " + (Fmt2 $rg.Profit) + " | PF " + (Fmt3 $rg.PF) + " | E in R " + (Fmt4 $rg.EInR) + " | DD " + (Fmt2 $rg.DD) + "% | PG " + (Fmt2 $rg.PG) + "% | eco Slippage Pts " + $rg.Grezzo["Slippage Pts"] + " | CSV " + $w.CsvOra)
  }
}
[void]$R.Add("")
[void]$R.Add("--- LO SPREAD MISURATO (F9, chiude H12 anche se il round boccia) ---")
[void]$R.Add("  " + $SpreadTxt)
[void]$R.Add("")
[void]$R.Add("--- COSA NON SI PUO' DIRE con questi dati (par. 5.10, ricopiato) ---")
[void]$R.Add("  1. 'regge nel tempo' (un solo regime, 24 mesi) | 2. 'il DD sara' quello' (un broker, un feed, un regime) | 3. 'il forex BCM ha questi spread' in generale")
[void]$R.Add("  4. promuovere il motore 1 o 3, SOPRATTUTTO se sono i piu' belli | 5. 'basta cambiare l'ora' se la 8 muore | 6. 'su GBPUSD serve uno stop piu' largo' e rilanciare | 7. passare al forward senza la prova di rischio sul vecchio (par. 6) e il contratto della sedia")
[void]$R.Add("  Previsione dichiarata PRIMA (par. 0.2): NO probabile (MAE mediana 11,8 pip sopra lo stop di 8,0; costo 1,7-3,3x l'edge). Da giudicare qui: avevo detto NO -- cos'e' successo?")
[void]$R.Add("")
if($RigheLog.Count -gt 0){
  [void]$R.Add("--- RIGHE INTERESSANTI DAI LOG DEL TESTER (tick, memoria, autotest) ---")
  $k = 0
  foreach($l in $RigheLog){ [void]$R.Add("  " + $l); $k++; if($k -ge 60){ [void]$R.Add("  ... (" + ($RigheLog.Count - 60) + " altre righe nei log_*.log dentro lo zip)"); break } }
  [void]$R.Add("")
}
if($Fatale -ne ""){ [void]$R.Add("!!! FERMATO: " + $Fatale); [void]$R.Add("") }
[void]$R.Add("PROBLEMI: " + $Problemi.Count)
foreach($p in $Problemi){ [void]$R.Add("  - " + $p) }
[void]$R.Add("RILIEVI: " + $Rilievi.Count)
foreach($p in $Rilievi){ [void]$R.Add("  - " + $p) }
[void]$R.Add("")
[void]$R.Add('COME SI RIPRENDE: dalla pagina righe/RIGA_R116_LONDONFX_DA_MANDARE.md, NON da questa')
[void]$R.Add('riga: $Pin nasce dentro il blocco e non sopravvive. Un giro morto a meta'' si rilancia')
[void]$R.Add('INTERO (il generico ha -Rifai: i CSV vecchi finiscono in vecchi\). Solo la fase 2: -SoloFase2.')

$refPath = Join-Path $Cart ("REFERTO_R116_LONDONFX_" + $Simbolo + ".txt")
Set-Content -LiteralPath $refPath -Value ($R -join "`r`n") -Encoding ASCII
Write-Host ($R -join "`r`n")

if(Test-Path -LiteralPath $logC){
  Copy-Item -LiteralPath $logC -Destination $Cart -Force
  Set-Content -LiteralPath (Join-Path $Cart "COMPILAZIONE_leggibile.txt") -Value ((LeggiTesto $logC) -join "`r`n") -Encoding ASCII
}
foreach($pf in @($PROVA_MAIN,$PROVA_F2)){ $s = Join-Path $Prove $pf; if(Test-Path -LiteralPath $s){ Copy-Item -LiteralPath $s -Destination $Cart -Force } }
$Results = Join-Path $Work ("risultati_prove\" + $EA)
foreach($et in @($Etichetta,$EtichettaF2)){
  foreach($leg in @("IS","OOS")){
    $f = Join-Path $Results ($EA + "_" + $Simbolo + "_" + $leg + "_" + $et + ".csv")
    if(Test-Path -LiteralPath $f){ Copy-Item -LiteralPath $f -Destination $Cart -Force }
  }
  foreach($f in @(Get-ChildItem -LiteralPath $Work -Filter ("gen_" + $EA + "_" + $Simbolo + "_*" + $et + ".ini") -ErrorAction SilentlyContinue)){ Copy-Item -LiteralPath $f.FullName -Destination $Cart -Force }
}
foreach($f in @(Get-ChildItem -LiteralPath $Work -Filter ("anteprima_" + $EA + "_*.ini") -ErrorAction SilentlyContinue | Where-Object { $_.LastWriteTime -ge $Avvio })){ Copy-Item -LiteralPath $f.FullName -Destination $Cart -Force }
foreach($f in @(Get-ChildItem -LiteralPath $Work -Filter "log_*.log" -ErrorAction SilentlyContinue | Where-Object { $_.LastWriteTime -ge $Avvio })){ Copy-Item -LiteralPath $f.FullName -Destination $Cart -Force }
foreach($f in @($PerTradeCopie)){ if($f -and (Test-Path -LiteralPath $f)){ Copy-Item -LiteralPath $f -Destination $Cart -Force } }
$zip = $Cart + ".zip"
Remove-Item -LiteralPath $zip -Force -ErrorAction SilentlyContinue
Compress-Archive -Path (Join-Path $Cart "*") -DestinationPath $zip -Force
Write-Host ""
Write-Host ("CARTELLA: " + $Cart) -ForegroundColor Green
Write-Host ("ZIP DA MANDARE: " + $zip) -ForegroundColor Green
Write-Host ("FILE ATTESI NELLO ZIP: REFERTO_R116_LONDONFX_" + $Simbolo + ".txt + COMPILAZIONE.log (+ _leggibile.txt) + i 2 prova + i CSV " + $EA + "_" + $Simbolo + "_IS_" + $Etichetta + ".csv e _OOS_ (6 righe l'uno) + gli .ini veri gen_*.ini + i log del tester cresciuti + i per-trade pertrade_*.csv freschi (" + @($PerTradeCopie).Count + " raccolti in questo giro, rappresentano SOLO l'ultima cella scritta: vedi 'per-trade' nel referto); se la fase 2 e' girata anche i CSV *_" + $EtichettaF2 + ".csv (2 righe l'uno)") -ForegroundColor Gray
Write-Host "NOTA: per-trade v1.01 raccolto FRESCO (assente/vecchio = cella non girata per cache, MAI zero trade: vedi referto). L'EA .mq5/.ex5 RESTA in MQL5\Experts del terminale di backtest (foto nel referto)." -ForegroundColor Gray

if($Fatale -ne ""){ Write-Host "ESITO: FERMATO" -ForegroundColor Red; exit 1 }
if($Problemi.Count -gt 0){ Write-Host "ESITO: COMPLETATO CON PROBLEMI" -ForegroundColor Yellow; exit 1 }
Write-Host ("ESITO: " + $Modo + " COMPLETATO") -ForegroundColor Green
exit 0
