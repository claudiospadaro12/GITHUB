# =====================================================================
#  MARCATORE_RIGA_GAPCASH_PASSO0_v1
#  RIGA_GAPCASH_PASSO0.ps1 -- PASSO 0 del candidato "GAP DELLA SESSIONE
#  CASH DEL NASDAQ": compila la sonda, fa girare lo sweep a 8 celle col
#  gate ACCESO, poi a parte la corsa di CONTROLLO col gate SPENTO, e
#  impagina un referto che CALCOLA i verdetti P0-1 ... P0-7.
# ---------------------------------------------------------------------
#  IL CONTRATTO FA FEDE E NON SI RISCRIVE QUI:
#     backtest_pipeline\prove\GAPCASH_NAS_PASSO0.txt
#     (criteri congelati il 06/09/2026, PRIMA di qualunque numero BCM)
#  IL DOSSIER CHE GIUSTIFICA IL PASSO 0:
#     backtest_pipeline\caccia_strategie\CACCIA_NASDAQ_MECCANISMI_2026-09-06.md  par. 2
#  LA SONDA:
#     mql5\Experts\ABTG_SondaGapCash.mq5  -- e' un CONTATORE: nessun
#     ordine, nessun lotto, nessun magic, nessuna sedia.
#
# =====================================================================
#  QUESTA RIGA NON PROMUOVE NIENTE E NON TOCCA NESSUNA SEDIA VIVA.
#  Non apre ordini (la sonda non ne apre), non installa preset, non
#  scrive in nessuna cartella di forward. Gli .ini del driver generico
#  hanno AllowLiveTrading=false.
#
# =====================================================================
#  PERCHE' ESISTE QUESTO FILE, invece di due righe di
#  walkforward_generico.ps1 incollate a mano. CINQUE motivi, tutti
#  verificabili nel codice qui sotto.
#
#   1. -ConControllo NON ESISTE.
#      Il contratto (par. 6) dice che la corsa di controllo "si lancia
#      a parte con -ConControllo". VERIFICATO IL 07/09/2026: quella
#      stringa non compare da nessuna parte nel repo. Il modo che il
#      driver generico ha DAVVERO per far girare la stessa sonda con un
#      input diverso e' -Prova su un file variante, con -Etichetta per
#      il nome del CSV. Qui si fa cosi', e il file variante e'
#      prove\GAPCASH_NAS_PASSO0_CONTROLLO.txt.
#      >>> LA STRADA SCELTA, DICHIARATA: due invocazioni del generico,
#          due file prova, due ETICHETTE diverse (GATE e CTRL). I due
#          CSV finiscono in due nomi distinti e NON POSSONO
#          sovrascriversi, che e' esattamente cio' che il contratto
#          pretende.
#
#   2. LA SONDA NON E' MAI STATA COMPILATA DA NESSUNO.
#      E' stata scritta il 06/09 e in questo ambiente non esiste
#      MetaEditor. "COMPILAZIONE FALLITA" e' l'esito PIU' PROBABILE
#      della prima corsa, quindi qui e' un esito NORMALE E GESTITO:
#      referto chiaro, log del compilatore allegato allo zip, codice di
#      uscita 3, e nessuna mezza installazione. Il driver generico
#      compila anche lui, ma MUORE con "compilazione fallita" senza
#      dire perche' e senza salvare il log.
#      >>> E LO STATO DELLA COMPILAZIONE HA QUATTRO VALORI, MAI DUE
#          (classe 94-ter, recidiva trovata il 07/09/2026):
#             NON TENTATA / TENTATA, esito ignoto /
#             FALLITA (motivo) / OK (dettagli)
#          "TENTATA, esito ignoto" viene scritto PRIMA di lanciare
#          metaeditor64.exe: se il processo esplode a meta', il referto
#          NON puo' dire "NON TENTATA" su una compilazione tentata.
#
#   3. IL CANCELLO IN MEZZO ALLE CORSE, CHE E' CODICE E NON UNA FRASE
#      (classe 151, imparata il 07/09/2026 sbagliando: in R118 i criteri
#      promettevano "il round si ferma prima di spendere macchina" e nel
#      driver non c'era nessun confronto, solo una Write-Host DOPO le
#      170 passate).
#      Qui, FRA la corsa GATE e la corsa di CONTROLLO, gira
#      CancelloDopoGate(): legge il CSV appena prodotto e FERMA LA
#      SPESA se
#         - il CSV non e' leggibile o non ha 8 righe;
#         - l'autotest della sonda dichiara casi falliti, o non ha
#           girato tutti gli 8 blocchi;
#         - l'eco del gate dice "spento" in una corsa a gate acceso;
#         - NESSUNA cella arriva a 25 giornate-evento (cancello P0-1:
#           sotto quella soglia il contratto dice SCARTO, e la corsa di
#           controllo sarebbe macchina spesa per niente).
#      IL CANCELLO E' COLLAUDABILE SENZA MT5: si passa -CollaudoCancello
#      con un CSV qualunque (anche inventato) e il driver esegue SOLO
#      quella logica e dice cosa avrebbe fatto. Un cancello che nessuno
#      ha mai visto scattare non e' un cancello dimostrato.
#
#   4. LA FINESTRA E' UNA SOLA, NON DUE.
#      Il driver generico spacca sempre in IS/OOS (40/60 di default).
#      Su un CONTATORE quella spaccatura e' un danno: il contratto si
#      aspetta ~68 giornate-evento sull'INTERA finestra, e su una meta'
#      il conteggio finirebbe a ridosso del cancello dei 25 per
#      costruzione, non per misura. Qui si passa -FrazioneIS 1 e la
#      gamba "OOS" resta DEGENERE (0 giorni) e si IGNORA -- stessa cosa
#      gia' fatta in casa da RIGA_SONDALONDONFX.ps1 il 31/08.
#      >>> IL ROSSO DEL GENERICO SUI CSV *_OOS E' ATTESO: non si
#          rilancia niente. Il conteggio dei *_OOS trovati (attesi 0)
#          finisce NEL REFERTO, non solo a schermo.
#      >>> [NON MISURATO] a Modello 4 non e' agli atti quanto tempo MT5
#          impieghi a scartare una gamba con FromDate > ToDate. In casa
#          e' successo solo a Modello 2 (secondi). Se il terminale si
#          riapre una seconda volta per pochi istanti, e' quello.
#
#   5. I VERDETTI LI CALCOLA IL CODICE, NON IL LETTORE.
#      P0-1 ... P0-7 escono gia' calcolati dalla sonda (colonne
#      "P01 Esito", "P02 Esito", ...). Questo driver li LEGGE, li
#      impagina, e ci aggiunge i confronti che una corsa sola non puo'
#      fare: gate contro controllo, monotonia della soglia, gemelli di
#      determinismo, eco degli input contro i valori chiesti.
#
# =====================================================================
#  IL NUMERO DA GUARDARE PER PRIMO NON E' IL VERDETTO.
#  Sono due: P0-1 (le giornate-evento, contro le ~68 attese) e la QUOTA
#  DEI LUNEDI' di P0-6. Se i lunedi' fossero oltre il 40%, questo non e'
#  il gap della sessione cash: e' il gap del weekend travestito, gia'
#  misurato e gia' bocciato da R61/R62, e il verdetto va SOSPESO
#  qualunque cosa dicano gli altri criteri.
#
# =====================================================================
#  ATTENZIONE AL NOME "CONTROLLO", CHE IN QUESTO ROUND E' GIA' PRESO.
#  "corsa di CONTROLLO" = la corsa a GATE SPENTO che serve a P0-2.
#  Il giro a vuoto (che non apre MT5 per il tester) qui si chiama
#  -GiroAVuoto, NON -SoloControllo, apposta: due cose diverse non
#  possono avere lo stesso nome nella stessa pagina. Al driver generico
#  viene passato il suo -SoloControllo, che e' un'altra cosa ancora.
#
# =====================================================================
#  SI LANCIA SUL PC DI BACKTEST, MAI SUL VPS.
#  Sul VPS il terminale che verrebbe aperto e chiuso e' quello che
#  tiene su la FLOTTA IN FORWARD. La riga si rifiuta di partire se
#  trova terminal64 o metaeditor64 gia' aperti (col terminale aperto il
#  tester non gira e escono ZERO CSV; con MetaEditor aperto la
#  compilazione torna subito SENZA compilare).
#
#  QUANTO CI METTE [STIMA, non una previsione]: 10 passate a tick reali
#  su ~21 mesi di NASUSD M5 (8 GATE + 2 CONTROLLO), piu' 2 avvii del
#  terminale e 1 compilazione. R107 fece 24 passate a tick reali sulla
#  stessa finestra in 9 minuti; la sonda pero' legge M1 giorno per
#  giorno e i tick del minuto della campana, quindi e' piu' lenta di un
#  EA normale. Stima onesta: 20-60 minuti. NON e' una promessa.
#
#  LA RIGA CHE SI INCOLLA sta in righe\RIGA_GAPCASH_PASSO0_DA_MANDARE.md
# =====================================================================
[CmdletBinding()]
param(
  # -Pin NON ha default: un default silenzioso ("lavoro") farebbe girare
  #  la punta del branch spacciandola per un commit congelato.
  [string]$Pin        = "",
  [switch]$GiroAVuoto,             # giro a vuoto: COMPILA davvero, NON apre MT5 per il tester
  [switch]$Rifai,                  # passato al generico; qui i CSV bersaglio si cancellano comunque
  [string]$SoloCorsa  = "",        # "GATE" | "CTRL" | "" (tutte e due)
  [string]$Simbolo    = "NASUSD",
  [string]$Periodo    = "M5",
  [string]$DaQuando   = "2024.09.26",
  [string]$Fino       = "2026.06.30",
  [int]   $Deposito   = 10000,
  # override del compilatore. Serve se l'autodiscovery non trova
  # metaeditor64.exe, ED E' ANCHE IL GANCIO CON CUI IL RAMO
  # "COMPILAZIONE FALLITA" E' STATO COLLAUDATO A BANCO (si punta a un
  # eseguibile finto che non produce nessun .ex5).
  [string]$MetaEditorPercorso = "",
  # collaudo del cancello SENZA MT5: si passa un CSV (anche inventato),
  # il driver esegue SOLO CancelloDopoGate() su quel file e esce.
  # 0 = il cancello avrebbe fatto passare, 2 = avrebbe fermato.
  [string]$CollaudoCancello   = "",
  [int]   $CollaudoCelleAttese = 8
)
$ErrorActionPreference = "Stop"
[Threading.Thread]::CurrentThread.CurrentCulture   = [Globalization.CultureInfo]::InvariantCulture
[Threading.Thread]::CurrentThread.CurrentUICulture = [Globalization.CultureInfo]::InvariantCulture
[Net.ServicePointManager]::SecurityProtocol = [Net.SecurityProtocolType]::Tls12
$INV = [Globalization.CultureInfo]::InvariantCulture

$EA          = "ABTG_SondaGapCash"
$FileGate    = "GAPCASH_NAS_PASSO0.txt"
$FileCtrl    = "GAPCASH_NAS_PASSO0_CONTROLLO.txt"
$MarcatoreEA = "ABTG_SondaGapCash v1.00 - PASSO 0 GAPCASH_NAS"
$BlocchiAtt  = 8      # ABTG_GAPCASH_AUTOTEST_BLOCCHI_ATTESI, riletto NEL sorgente
$CasiAtt     = 74     # ABTG_GAPCASH_AUTOTEST_CASI_ATTESI,    riletto NEL sorgente
$CelleGate   = 8      # lo sweep del contratto: otto celle, e si contano
$CelleCtrl   = 2      # asse tecnico a due celle (classe 134)
$P01Cancello = 25     # GC_P01_EVENTI_MINIMI
$AttesiEventi= 68     # atteso del contratto alla soglia -0,50% su 503 feriali

$Avvio = Get-Date
$Stamp = $Avvio.ToString("yyyyMMdd_HHmm", $INV)
$Dsk   = [Environment]::GetFolderPath("Desktop")
if([string]::IsNullOrWhiteSpace($Dsk)){ $Dsk = Join-Path $env:USERPROFILE "Desktop" }
$Work   = Join-Path $env:USERPROFILE "abtg_gapcash_passo0"
$Prove  = Join-Path $Work "prove"
$RawPin = "https://raw.githubusercontent.com/claudiospadaro12/GITHUB/$Pin"

# --- TUTTO CIO' CHE LA RACCOLTA USA NASCE QUI, PRIMA DEL try.
#     In PowerShell una `function` non e' dichiarativa, e' un'ISTRUZIONE:
#     se il flusso non ci passa sopra, il nome non esiste, e la raccolta
#     esploderebbe proprio nella corsa fermata da un cancello, cioe'
#     l'unica in cui il referto serve davvero.
$Problemi   = New-Object System.Collections.ArrayList
$Rilievi    = New-Object System.Collections.ArrayList
$Fatale     = ""
$Compilazione = "NON TENTATA"      # <-- I QUATTRO STATI, classe 94-ter
$Terminale    = "n/d"
$SondaVersione= "n/d"
$RigaTick     = "NON RILETTA in questa corsa"
$CancelloStato= "NON VALUTATO"
$CancelloPerche = ""
$StatoGate    = "NON ESEGUITA"
$StatoCtrl    = "NON ESEGUITA"
$RigheGate    = $null
$RigheCtrl    = $null
$OosTrovati   = 0
$Modo = "CORSA"
if($GiroAVuoto){ $Modo = "GIRO A VUOTO" }
$EsitoNum = 0

function Ora(){ return (Get-Date).ToString("HH:mm:ss", $INV) }
function Dico([string]$t,[string]$c="Gray"){ Write-Host ("[" + (Ora) + "] " + $t) -ForegroundColor $c }
function Titolo([string]$t){ Write-Host ""; Write-Host ("=== " + $t + " ===") -ForegroundColor Cyan }

function Scarica([string]$url,[string]$dest){
  Remove-Item -LiteralPath $dest -Force -ErrorAction SilentlyContinue
  Invoke-WebRequest -Uri $url -OutFile $dest -UseBasicParsing -ErrorAction Stop
  if(-not (Test-Path -LiteralPath $dest)){ throw ("scarico fallito: " + $url) }
}

function RigheVive([string]$p){
  return @(Get-Content -LiteralPath $p | Where-Object { $_ -notmatch '^\s*#' -and $_ -notmatch '^\s*$' })
}

function NumInv($s){
  $v = 0.0
  $t = ("" + $s).Replace([string][char]160,"").Replace(" ","").Trim()
  if($t -eq ""){ return $null }
  if([double]::TryParse($t,[Globalization.NumberStyles]::Float,$INV,[ref]$v)){ return $v }
  return $null
}

# --- LA CONVENZIONE DI SENTINELLA: un numero non misurato non esce mai
#     come numero plausibile. In R103 un PF non misurato usciva "0.000",
#     che si legge "ha perso tutto". Qui esce "n/d".
function F0($v){ if($null -eq $v){ return "n/d" }; return ([double]$v).ToString("0",$INV) }
function F2($v){ if($null -eq $v){ return "n/d" }; return ([double]$v).ToString("0.00",$INV) }
function F4($v){ if($null -eq $v){ return "n/d" }; return ([double]$v).ToString("0.0000",$INV) }
function FS($v){ if($null -eq $v){ return "n/d" }; return ([double]$v).ToString("+0.0000;-0.0000;0.0000",$INV) }

function NomeEsito($v){
  if($null -eq $v){ return "NON LETTO" }
  $n = [int]$v
  if($n -eq 2){ return "PASSA" }
  if($n -eq 1){ return "SOSPESO" }
  if($n -eq 0){ return "SCARTO" }
  return "NON MISURATO"
}

# --- LE COLONNE SI CERCANO PER NOME, MAI PER POSIZIONE. Se il nome non
#     c'e' si torna $null (che stampa "n/d"), non un numero indovinato.
$script:Intestazioni = @()
function V($riga,[string]$nome){
  if($null -eq $riga){ return $null }
  $p = $riga.PSObject.Properties[$nome]
  if($null -eq $p){
    foreach($q in $riga.PSObject.Properties){
      if(("" + $q.Name).Trim() -ieq $nome){ $p = $q; break }
    }
  }
  if($null -eq $p){ return $null }
  return (NumInv $p.Value)
}

function LeggiOptCsv([string]$path){
  if(-not (Test-Path -LiteralPath $path)){ return $null }
  $righe = @()
  try{ $righe = @(Import-Csv -LiteralPath $path) }catch{ return $null }
  if($righe.Count -eq 0){ return $null }
  $script:Intestazioni = @($righe[0].PSObject.Properties.Name)
  # una colonna che DEVE esserci: se manca, il CSV non e' di questa sonda
  $ok = $false
  foreach($k in $script:Intestazioni){ if(("" + $k).Trim() -ieq "P01 Eventi Long"){ $ok = $true } }
  if(-not $ok){ return $null }
  return @($righe)
}

# =====================================================================
#  IL CANCELLO. E' CODICE, gira FRA le due corse, e si puo' far
#  fallire da riga di comando con -CollaudoCancello.
#  Torna @{ Ok; Motivo; Note }.
# =====================================================================
function CancelloDopoGate($righe,[int]$celleAttese){
  $note = New-Object System.Collections.ArrayList
  if($null -eq $righe){
    return [pscustomobject]@{ Ok=$false; Motivo="CSV della corsa GATE non letto: mancante, vuoto, o senza la colonna 'P01 Eventi Long' (non e' il CSV di questa sonda)"; Note=$note }
  }
  $n = @($righe).Count
  [void]$note.Add("righe nel CSV: " + $n + " (attese " + $celleAttese + ")")
  if($n -ne $celleAttese){
    return [pscustomobject]@{ Ok=$false; Motivo=("il CSV GATE ha " + $n + " righe invece di " + $celleAttese + ": o lo sweep non ha spazzolato, o la CACHE del tester ha ripescato passate vecchie. I numeri non si leggono."); Note=$note }
  }
  # --- l'autotest della sonda, letto IN COLONNA (in ottimizzazione le
  #     Print girano sugli agent e non le legge nessuno).
  $maxFall = 0; $blocchiMin = 999999
  foreach($r in $righe){
    $af = V $r "Autotest Falliti"
    $ab = V $r "Autotest Blocchi"
    if($null -eq $af -or $null -eq $ab){
      return [pscustomobject]@{ Ok=$false; Motivo="colonne 'Autotest Falliti' / 'Autotest Blocchi' non trovate nel CSV: il collaudo della sonda non e' agli atti e i numeri non si leggono."; Note=$note }
    }
    if($af -gt $maxFall){ $maxFall = [int]$af }
    if($ab -lt $blocchiMin){ $blocchiMin = [int]$ab }
  }
  [void]$note.Add("autotest: falliti max " + $maxFall + ", blocchi min " + $blocchiMin)
  if($maxFall -gt 0){
    return [pscustomobject]@{ Ok=$false; Motivo=("l'AUTOTEST della sonda dichiara " + $maxFall + " casi FALLITI: le funzioni di misura non fanno quello che dicono, e nessun numero di questo PASSO 0 si legge."); Note=$note }
  }
  if($blocchiMin -ne $BlocchiAtt){
    return [pscustomobject]@{ Ok=$false; Motivo=("l'autotest ha girato " + $blocchiMin + " blocchi invece di " + $BlocchiAtt + ": il sorgente che ha girato NON e' quello che questa riga si aspetta."); Note=$note }
  }
  # --- l'eco del gate: in una corsa a gate ACCESO deve valere 0.
  #     E' la trappola del "nome inesistente" (LEGGIMI.md): se la riga
  #     InpGateSpento non fosse arrivata all'EA, la fase risponderebbe a
  #     un'altra domanda.
  foreach($r in $righe){
    $eg = V $r "Eco Gate Spento"
    if($null -eq $eg){
      return [pscustomobject]@{ Ok=$false; Motivo="colonna 'Eco Gate Spento' non trovata: non si puo' dimostrare che la corsa GATE avesse il gate acceso."; Note=$note }
    }
    if([int]$eg -ne 0){
      return [pscustomobject]@{ Ok=$false; Motivo="la corsa GATE dichiara il gate SPENTO (Eco Gate Spento = 1): ha misurato la corsa di controllo due volte, non il gate."; Note=$note }
    }
  }
  [void]$note.Add("eco gate: ACCESO in tutte le righe (Eco Gate Spento = 0)")
  # --- P0-1, il cancello del contratto: >= 25 giornate-evento.
  $max = $null; $cellaMax = "n/d"
  foreach($r in $righe){
    $ev = V $r "P01 Eventi Long"
    if($null -eq $ev){
      return [pscustomobject]@{ Ok=$false; Motivo="colonna 'P01 Eventi Long' illeggibile: il conteggio delle giornate-evento non c'e'."; Note=$note }
    }
    if($null -eq $max -or $ev -gt $max){ $max = $ev; $cellaMax = (F4 (V $r "Eco Soglia Gap Long")) }
  }
  [void]$note.Add("P0-1: cella piu' ricca " + (F0 $max) + " giornate-evento (soglia " + $cellaMax + "), cancello " + $P01Cancello)
  if($max -lt $P01Cancello){
    return [pscustomobject]@{ Ok=$false; Motivo=("P0-1 SCARTO: la cella piu' ricca ha " + (F0 $max) + " giornate-evento, sotto il cancello di " + $P01Cancello + ". Il contratto dice che il fenomeno non esiste sul nostro feed e che non c'e' round: la corsa di CONTROLLO sarebbe macchina spesa per niente."); Note=$note }
  }
  return [pscustomobject]@{ Ok=$true; Motivo=""; Note=$note }
}

# =====================================================================
#  -CollaudoCancello: gira SOLO il cancello, su un CSV qualunque, senza
#  MT5 e senza pin. Serve a FAR FALLIRE il cancello a comando: un
#  cancello che nessuno ha mai visto scattare non e' dimostrato.
# =====================================================================
if($CollaudoCancello -ne ""){
  Write-Host ""
  Write-Host "=== COLLAUDO DEL CANCELLO (nessun MT5, nessuna corsa) ===" -ForegroundColor Cyan
  Write-Host ("    CSV in prova : " + $CollaudoCancello)
  Write-Host ("    celle attese : " + $CollaudoCelleAttese)
  $rr = LeggiOptCsv $CollaudoCancello
  $gg = CancelloDopoGate $rr $CollaudoCelleAttese
  foreach($nn in $gg.Note){ Write-Host ("    . " + $nn) -ForegroundColor DarkGray }
  if($gg.Ok){
    Write-Host "    ESITO: IL CANCELLO AVREBBE FATTO PASSARE (la corsa di CONTROLLO partirebbe)." -ForegroundColor Green
    exit 0
  }
  Write-Host ("    ESITO: IL CANCELLO AVREBBE FERMATO -- " + $gg.Motivo) -ForegroundColor Red
  exit 2
}

# =====================================================================
#  LA MAPPA DI UN FILE PROVA: direttive, parametri, asse Y.
#  Un parametro DOPPIO in [TesterInputs] fa fare a MT5 ZERO passate:
#  qui e' un errore, non un avviso.
# =====================================================================
function MappaProva([string]$path){
  $h = @{}
  $nY = 0; $nomeY = ""
  foreach($r in (RigheVive $path)){
    $t = $r.Trim()
    if($t.StartsWith("@")){
      $parti = ($t -split '\s+',2)
      if($parti.Count -eq 2){ $h[$parti[0].ToUpper()] = $parti[1].Trim() }
      continue
    }
    $i = $t.IndexOf("=")
    if($i -lt 0){ continue }
    $nome = $t.Substring(0,$i).Trim()
    $val  = $t.Substring($i+1).Trim()
    if($h.ContainsKey($nome)){ throw ((Split-Path -Leaf $path) + ": DUE righe per '" + $nome + "'. In [TesterInputs] un parametro doppio fa fare a MT5 ZERO passate.") }
    $h[$nome] = $val
    if($val -match '\|\|\s*[Yy]\s*$'){ $nY++; $nomeY = $nome }
  }
  return [pscustomobject]@{ H=$h; NY=$nY; NomeY=$nomeY; File=(Split-Path -Leaf $path) }
}

# --- IL CONTEGGIO DELLE CELLE, CON LA STESSA FORMULA DEL GENERICO.
#     Se un giorno il generico cambia formula, questa cambia con lui:
#     si toccano insieme, altrimenti la pagina promette 8 celle e ne
#     girano altre.
function CelleAsse([string]$riga){
  $campi = $riga -split '\|\|'
  if($campi.Count -lt 5){ return 0 }
  $a = NumInv $campi[1]; $s = NumInv $campi[2]; $b = NumInv $campi[3]
  if($null -eq $a -or $null -eq $s -or $null -eq $b){ return 0 }
  if($a -eq $b -or $s -eq 0){ return 0 }     # sweep degenere, trappola del 07/08
  return [int]([math]::Floor([math]::Abs($b-$a)/[math]::Abs($s)+1e-9)+1)
}

function FerialiFra([datetime]$da,[datetime]$a){
  $n = 0; $d = $da
  while($d -le $a){
    if($d.DayOfWeek -ne [DayOfWeek]::Saturday -and $d.DayOfWeek -ne [DayOfWeek]::Sunday){ $n++ }
    $d = $d.AddDays(1)
  }
  return $n
}

function LeggiLogTesto([string]$p){
  if(-not (Test-Path -LiteralPath $p)){ return "" }
  $b = [IO.File]::ReadAllBytes($p)
  if($b.Length -lt 2){ return "" }
  if($b[0] -eq 0xFF -and $b[1] -eq 0xFE){ return [Text.Encoding]::Unicode.GetString($b,2,$b.Length-2) }
  $zeri = 0; $lim = [math]::Min($b.Length, 400)
  for($i=0; $i -lt $lim; $i++){ if($b[$i] -eq 0){ $zeri++ } }
  if($lim -gt 0 -and (($zeri*100)/$lim) -gt 30){ return [Text.Encoding]::Unicode.GetString($b) }
  return [Text.Encoding]::ASCII.GetString($b)
}

$CorseVolute = @("GATE","CTRL")
if($SoloCorsa -ne ""){ $CorseVolute = @($SoloCorsa.ToUpper()) }

try{
  Titolo ("PASSO 0 -- GAP DELLA SESSIONE CASH DEL NASDAQ -- modo " + $Modo)

  # -------------------------------------------------------------------
  #  0. LE GUARDIE, PRIMA DI TOCCARE QUALUNQUE COSA
  # -------------------------------------------------------------------
  if($Pin -eq ""){ throw "-Pin obbligatorio: senza, girerebbe la punta del branch spacciandola per un commit congelato." }
  if($Pin -notmatch '^[0-9a-fA-F]{40}$'){ throw ("-Pin deve essere un commit di 40 caratteri esadecimali, ricevuto: " + $Pin) }
  $Pin = $Pin.ToLower()
  $RawPin = "https://raw.githubusercontent.com/claudiospadaro12/GITHUB/$Pin"
  if(Get-Process terminal64,metaeditor64 -ErrorAction SilentlyContinue){
    throw "MT5 O METAEDITOR APERTO: col terminale aperto il tester non gira (zero CSV), con MetaEditor aperto la compilazione torna subito SENZA compilare. Chiudili e rilancia."
  }
  foreach($c in $CorseVolute){
    if($c -ne "GATE" -and $c -ne "CTRL"){ throw ("-SoloCorsa '" + $c + "' non esiste. Valide: GATE, CTRL.") }
  }
  $DaDt = [datetime]::ParseExact($DaQuando,"yyyy.MM.dd",$INV)
  $AlDt = [datetime]::ParseExact($Fino,"yyyy.MM.dd",$INV)
  if($AlDt -le $DaDt){ throw ("-Fino (" + $Fino + ") non e' dopo -DaQuando (" + $DaQuando + ").") }
  $Feriali = FerialiFra $DaDt $AlDt

  Dico ("pin ......... " + $Pin)
  Dico ("sonda ....... " + $EA + "  (CONTATORE: nessun ordine, nessun magic, nessuna sedia)")
  Dico ("corse ....... " + ($CorseVolute -join " + ") + "   (GATE = gate acceso, 8 celle | CTRL = gate SPENTO, 2 celle)")
  Dico ("finestra .... " + $DaQuando + " -> " + $Fino + "   UNA TRANCHE (-FrazioneIS 1): la gamba OOS del generico e' DEGENERE e si ignora")
  Dico ("feriali ..... " + $Feriali + " giorni feriali di CALENDARIO nella finestra (non giorni di borsa: i festivi li toglie P0-6, non questo conto)")
  Dico ("banco ....... Modello 4 (TICK REALI), deposito " + $Deposito + " (irrilevante: la sonda non apre ordini)")
  Dico ("campana ..... 14:30 ORA SERVER BCM = 15:30 italiane = 09:30 New York. NON si converte.")

  # -------------------------------------------------------------------
  #  1. SCARICO AL PIN
  # -------------------------------------------------------------------
  Titolo "1. SCARICO AL PIN"
  New-Item -ItemType Directory -Force -Path $Work,$Prove | Out-Null

  $drv = Join-Path $Work "walkforward_generico.ps1"
  Scarica ($RawPin + "/backtest_pipeline/walkforward_generico.ps1") $drv
  # Il driver generico riscarica da solo il .mq5 dalla PUNTA del branch.
  # Senza questa sostituzione il pin varrebbe per il driver e NON per la
  # sonda misurata.
  $tDrv = Get-Content -LiteralPath $drv -Raw
  if($tDrv -notmatch '\$EABranch\s*=\s*"lavoro"'){ throw 'walkforward_generico.ps1 non ha la riga $EABranch = "lavoro" attesa: non lo posso pinnare, e senza quel pin la sonda misurata sarebbe la punta del branch.' }
  $tDrv = $tDrv -replace '\$EABranch\s*=\s*"lavoro"', ('$EABranch="' + $Pin + '"')
  Set-Content -LiteralPath $drv -Value $tDrv -Encoding ASCII
  Dico "walkforward_generico.ps1 scaricato e PINNATO (riscarichera' la sonda AL PIN)" "Green"

  Scarica ($RawPin + "/backtest_pipeline/prove/" + $FileGate) (Join-Path $Prove $FileGate)
  Scarica ($RawPin + "/backtest_pipeline/prove/" + $FileCtrl) (Join-Path $Prove $FileCtrl)
  Dico ("file prova scaricati: " + $FileGate + " + " + $FileCtrl) "Green"

  $mq5 = Join-Path $Work ($EA + ".mq5")
  Scarica ($RawPin + "/mql5/Experts/" + $EA + ".mq5") $mq5
  $src = Get-Content -LiteralPath $mq5 -Raw
  Dico ("sonda scaricata: " + [int]((Get-Item -LiteralPath $mq5).Length/1024) + " KB, " + (($src -split "`n").Count) + " righe") "Green"

  # --- LA PROFONDITA' DEI TICK, CITATA DALLA MISURA GIUSTA.
  #     CLASSE 153 (07/09/2026): un altro driver prometteva "tick nativi
  #     su tutta la finestra" citando un referto che aveva misurato le
  #     BARRE. Qui si rilegge il CSV della misura DEI TICK, al pin, e si
  #     stampa la riga TICK COSI' COM'E'. Se il file non c'e', si
  #     dichiara l'assenza: non si promette niente a memoria.
  #     Serve a P0-3, che misura lo spread tick per tick dentro il minuto
  #     della campana: se i tick non fossero nativi, quel criterio
  #     misurerebbe un'altra cosa.
  $tickCsv = Join-Path $Work "misura_tick_NASUSD.csv"
  try{
    Scarica ($RawPin + "/backtest_pipeline/risultati_archivio/misura_tick/misura_tick_" + $Simbolo + ".csv") $tickCsv
    $tr = @(Import-Csv -LiteralPath $tickCsv | Where-Object { ("" + $_.Timeframe).Trim() -eq "TICK" })
    if($tr.Count -gt 0){
      $RigaTick = ($tr[0].Simbolo + " TICK  prima data " + $tr[0].PrimaDataLocale + "  conteggio " + $tr[0].Barre + "  verdetto '" + $tr[0].Verdetto + "'")
    } else {
      $RigaTick = "il CSV della misura tick esiste ma NON ha una riga TICK per " + $Simbolo
      [void]$Rilievi.Add("profondita' a tick di " + $Simbolo + ": nessuna riga TICK nel CSV della misura. P0-3 misura lo spread TICK PER TICK: senza quella riga non e' agli atti che i tick siano nativi.")
    }
  }catch{
    $RigaTick = "NON RILETTA (scarico fallito: " + $_.Exception.Message + ")"
    [void]$Rilievi.Add("profondita' a tick di " + $Simbolo + " NON RILETTA in questa corsa. Non si promette che i tick siano nativi: e' un'assenza, non un verde.")
  }
  Dico ("tick ........ " + $RigaTick) "Yellow"

  # -------------------------------------------------------------------
  #  2. I CANCELLI DI PRE-VOLO -- girano PRIMA di aprire qualunque cosa
  # -------------------------------------------------------------------
  Titolo "2. CANCELLI DI PRE-VOLO (nessuna macchina spesa fin qui)"

  # 2a. il marcatore e i numeri dell'autotest, LETTI NEL SORGENTE.
  if($src -notmatch [regex]::Escape($MarcatoreEA)){
    throw ("il sorgente scaricato al pin NON contiene il marcatore atteso '" + $MarcatoreEA + "': al pin non c'e' la sonda che questa riga si aspetta.")
  }
  $mv = [regex]::Match($src,'#property\s+version\s+"([^"]+)"')
  if($mv.Success){ $SondaVersione = $mv.Groups[1].Value }
  $mb = [regex]::Match($src,'#define\s+ABTG_GAPCASH_AUTOTEST_BLOCCHI_ATTESI\s+(\d+)')
  $mc = [regex]::Match($src,'#define\s+ABTG_GAPCASH_AUTOTEST_CASI_ATTESI\s+(\d+)')
  if(-not $mb.Success -or -not $mc.Success){ throw "nel sorgente non trovo i #define ABTG_GAPCASH_AUTOTEST_BLOCCHI_ATTESI / _CASI_ATTESI: non posso confrontare il collaudo dichiarato con quello atteso." }
  $bl = [int]$mb.Groups[1].Value; $ca = [int]$mc.Groups[1].Value
  if($bl -ne $BlocchiAtt -or $ca -ne $CasiAtt){
    throw ("l'autotest dichiarato nel sorgente e' " + $bl + " blocchi / " + $ca + " casi, questa riga si aspetta " + $BlocchiAtt + " / " + $CasiAtt + ". Il file al pin non e' quello che credo: mi fermo.")
  }
  Dico ("sorgente .... v" + $SondaVersione + ", marcatore OK, autotest dichiarato " + $bl + " blocchi / " + $ca + " casi") "Green"

  # 2b. i NOMI VINCOLANTI del contratto esistono davvero nel sorgente.
  #     Un nome che l'EA non ha viene ignorato IN SILENZIO da MT5 e la
  #     fase risponde a un'altra domanda (LEGGIMI.md).
  $Vincolanti = @("InpSogliaGapPct","InpOraAperturaServer","InpMinAperturaServer","InpMinutiUscita",
                  "InpLato","InpGateSpento","InpMisuraSpreadCampana","InpVerbose","InpAutoTest")
  foreach($nome in $Vincolanti){
    if($src -notmatch ('(?m)^\s*s?input\s+\w+\s+' + [regex]::Escape($nome) + '\s*=')){
      throw ("il contratto pinna l'input '" + $nome + "' ma la sonda NON ce l'ha: MT5 lo ignorerebbe in silenzio e questo PASSO 0 risponderebbe a un'altra domanda.")
    }
  }
  Dico ("i 9 nomi vincolanti del contratto esistono tutti nel sorgente") "Green"

  # 2c. i due file prova: direttive, assi, celle, e la STELLA fra i due.
  $mG = MappaProva (Join-Path $Prove $FileGate)
  $mC = MappaProva (Join-Path $Prove $FileCtrl)
  foreach($m in @($mG,$mC)){
    if($m.NY -ne 1){ throw ($m.File + ": deve avere ESATTAMENTE un asse con flag Y, trovati " + $m.NY + ".") }
    if($m.NomeY -ne "InpSogliaGapPct"){ throw ($m.File + ": l'unico asse Y deve essere InpSogliaGapPct, invece e' " + $m.NomeY + ".") }
    if($m.H["@SIMBOLO"]  -ne $Simbolo){  throw ($m.File + ": @SIMBOLO e' '"  + $m.H["@SIMBOLO"]  + "', atteso " + $Simbolo) }
    if($m.H["@PERIODO"]  -ne $Periodo){  throw ($m.File + ": @PERIODO e' '"  + $m.H["@PERIODO"]  + "', atteso " + $Periodo) }
    if($m.H["@DAQUANDO"] -ne $DaQuando){ throw ($m.File + ": @DAQUANDO e' '" + $m.H["@DAQUANDO"] + "', atteso " + $DaQuando) }
  }
  $nG = CelleAsse $mG.H["InpSogliaGapPct"]
  $nC = CelleAsse $mC.H["InpSogliaGapPct"]
  if($nG -ne $CelleGate){ throw ($FileGate + ": lo sweep del contratto deve fare " + $CelleGate + " celle, ne conto " + $nG + " (riga: " + $mG.H["InpSogliaGapPct"] + ").") }
  if($nC -ne $CelleCtrl){ throw ($FileCtrl + ": l'asse tecnico deve fare " + $CelleCtrl + " celle, ne conto " + $nC + " (riga: " + $mC.H["InpSogliaGapPct"] + "). Con UNA sola cella MT5 non esegue nessuna passata e il CSV esce da zero byte -- classe 134.") }
  Dico ("celle ....... GATE " + $nG + "  |  CTRL " + $nC + "   (contate con la formula del driver generico)") "Green"

  # il GATE dei VALORI: prende il caso che il diff non puo' vedere, cioe'
  # i due file SCAMBIATI.
  $vG = ($mG.H["InpGateSpento"] -split '\|\|')[0].Trim()
  $vC = ($mC.H["InpGateSpento"] -split '\|\|')[0].Trim()
  if($vG -ne "false"){ throw ($FileGate + ": InpGateSpento vale '" + $vG + "', la corsa GATE lo vuole 'false' (gate ACCESO).") }
  if($vC -ne "true" ){ throw ($FileCtrl + ": InpGateSpento vale '" + $vC + "', la corsa di CONTROLLO lo vuole 'true' (gate SPENTO).") }

  # il GATE della STELLA: fra i due file cambiano SOLO due righe.
  $Ammessi = @("InpGateSpento","InpSogliaGapPct")
  $chiavi = New-Object System.Collections.ArrayList
  foreach($k in $mG.H.Keys){ if(-not $k.StartsWith("@")){ [void]$chiavi.Add($k) } }
  foreach($k in $mC.H.Keys){ if(-not $k.StartsWith("@") -and -not $chiavi.Contains($k)){ [void]$chiavi.Add($k) } }
  foreach($k in $chiavi){
    if($Ammessi -contains $k){ continue }
    if($mG.H[$k] -ne $mC.H[$k]){
      throw ("'" + $k + "' differisce fra " + $FileGate + " e " + $FileCtrl + " e NON e' una differenza dichiarata. Le sole ammesse sono InpGateSpento e InpSogliaGapPct.")
    }
  }
  foreach($k in $Ammessi){
    if($mG.H[$k] -eq $mC.H[$k]){ throw ("'" + $k + "' DOVEVA differire fra i due file prova e non differisce.") }
  }
  Dico ("stella ...... i due file prova differiscono SOLO su InpGateSpento e InpSogliaGapPct") "Green"

  # -------------------------------------------------------------------
  #  3. IL TERMINALE E LA COMPILAZIONE
  #     LO STATO DELLA COMPILAZIONE HA QUATTRO VALORI, MAI DUE.
  # -------------------------------------------------------------------
  Titolo "3. COMPILAZIONE DELLA SONDA (prima volta in assoluto)"
  # IL SELETTORE E' LO STESSO, RIGA PER RIGA, DI walkforward_generico.ps1.
  # Su una macchina con DUE istanze BCM (la -V3 del 100k esiste) i due
  # script potevano scegliere TERMINALI DIVERSI: compilazione in uno,
  # corsa nell'altro. Se cambia il selettore del generico, cambia anche
  # questo: si toccano insieme.
  $allTerm = @(Get-ChildItem "C:\Program Files","C:\Program Files (x86)" -Recurse -Filter "terminal64.exe" -ErrorAction SilentlyContinue)
  $cand = $allTerm | Where-Object { $_.DirectoryName -like "*BCM Markets MT5 Terminal*" -and $_.DirectoryName -notlike "*-V3*" } | Select-Object -First 1
  if(-not $cand){ $cand = $allTerm | Where-Object { $_.DirectoryName -like "*BCM Markets*" } | Select-Object -First 1 }
  if(-not $cand){ throw "terminale BCM non trovato: e' lo stesso selettore di walkforward_generico.ps1." }
  $instDir = $cand.DirectoryName
  $Terminale = $instDir
  $MetaEditor = Join-Path $instDir "metaeditor64.exe"
  if($MetaEditorPercorso -ne ""){
    $MetaEditor = $MetaEditorPercorso
    [void]$Rilievi.Add("compilatore FORZATO da riga di comando (-MetaEditorPercorso " + $MetaEditorPercorso + "): non e' il metaeditor64.exe del terminale scelto. Va detto accanto ai numeri.")
  }
  $termRoot = Join-Path $env:APPDATA "MetaQuotes\Terminal"
  $dataFolder = (Get-ChildItem $termRoot -Directory -ErrorAction SilentlyContinue | Where-Object { $o = Join-Path $_.FullName "origin.txt"; (Test-Path $o) -and ((Get-Content $o -Raw).Trim() -ieq $instDir) } | Select-Object -First 1 -ExpandProperty FullName)
  if(-not $dataFolder){ throw ("cartella dati MT5 non trovata per " + $instDir) }
  Dico ("terminale ... " + $instDir + "   (DEVE contenere 'BCM Markets MT5 Terminal' e NON contenere '-V3')") "Yellow"

  $dstExp = Join-Path $dataFolder "MQL5\Experts"
  New-Item -ItemType Directory -Force -Path $dstExp | Out-Null
  $dstMq5 = Join-Path $dstExp ($EA + ".mq5")
  Copy-Item -LiteralPath $mq5 -Destination $dstMq5 -Force
  $ex5    = Join-Path $dstExp ($EA + ".ex5")
  $logMe  = Join-Path $dstExp ($EA + ".log")
  $logMio = Join-Path $Work   ("COMPILAZIONE_" + $EA + ".log")
  Remove-Item -LiteralPath $ex5   -Force -ErrorAction SilentlyContinue
  Remove-Item -LiteralPath $logMe -Force -ErrorAction SilentlyContinue
  Remove-Item -LiteralPath $logMio -Force -ErrorAction SilentlyContinue
  if(Test-Path -LiteralPath $ex5){
    $Compilazione = "FALLITA (l'.ex5 precedente non si lascia cancellare: " + $ex5 + " -- un binario vecchio farebbe passare per riuscita una compilazione fallita)"
    throw $Compilazione
  }

  $t0 = Get-Date
  # >>> LO STATO SI TIMBRA PRIMA DELLA CHIAMATA, NON DOPO. <<<
  $Compilazione = "TENTATA, esito ignoto (metaeditor lanciato alle " + $t0.ToString("HH:mm:ss",$INV) + ", nessun esito raccolto)"
  if(-not (Test-Path -LiteralPath $MetaEditor)){
    $Compilazione = "FALLITA (metaeditor64.exe non trovato: " + $MetaEditor + ")"
    throw $Compilazione
  }
  try{
    & $MetaEditor ("/compile:" + $dstMq5) "/log" | Out-Null
  }catch{
    $Compilazione = "FALLITA (eccezione lanciando il compilatore: " + $_.Exception.Message + ")"
    throw $Compilazione
  }
  # metaeditor torna prima di aver finito di scrivere: si aspetta l'.ex5.
  while((-not (Test-Path -LiteralPath $ex5)) -and ((New-TimeSpan -Start $t0 -End (Get-Date)).TotalSeconds -lt 180)){ Start-Sleep -Seconds 2 }

  $testoLog = LeggiLogTesto $logMe
  if($testoLog -ne ""){ Set-Content -LiteralPath $logMio -Value $testoLog -Encoding ASCII }
  $sintesi = "esito non deducibile dal log"
  $me = [regex]::Match($testoLog,'(\d+)\s+error')
  $mw = [regex]::Match($testoLog,'(\d+)\s+warning')
  if($me.Success){
    $sintesi = $me.Groups[1].Value + " errori"
    if($mw.Success){ $sintesi = $sintesi + ", " + $mw.Groups[1].Value + " avvisi" }
  }

  $ex5Ok = $false
  if(Test-Path -LiteralPath $ex5){
    $fi = Get-Item -LiteralPath $ex5
    # L'.EX5 DEVE ESSERE FRESCO. Senza questo, un binario di un'altra
    # corsa farebbe timbrare "OK" a una compilazione mai riuscita.
    if($fi.LastWriteTime -ge $t0.AddSeconds(-5)){ $ex5Ok = $true }
    else{
      $Compilazione = "FALLITA (c'e' un .ex5 ma e' VECCHIO: scritto alle " + $fi.LastWriteTime.ToString("yyyy-MM-dd HH:mm:ss",$INV) + ", la compilazione e' partita alle " + $t0.ToString("yyyy-MM-dd HH:mm:ss",$INV) + " -- non e' il binario di questa corsa)"
    }
  }
  if(-not $ex5Ok){
    if($Compilazione -notlike "FALLITA*"){
      $Compilazione = "FALLITA (nessun .ex5 prodotto entro 180 s; log del compilatore: " + $sintesi + ")"
    }
    if($testoLog -ne ""){
      Write-Host ""
      Write-Host "--- ultime righe del log del compilatore ---" -ForegroundColor Red
      $righeLog = @($testoLog -split "`r?`n")
      $daQui = [math]::Max(0, $righeLog.Count - 40)
      for($i=$daQui; $i -lt $righeLog.Count; $i++){ Write-Host $righeLog[$i] -ForegroundColor Red }
    }
    throw ($Compilazione + " -- la sonda non era MAI stata compilata da nessuno: questo E' il risultato del PASSO 0, si manda cosi' com'e' (log dentro lo zip).")
  }
  $fi = Get-Item -LiteralPath $ex5
  $Compilazione = "OK (" + [int]($fi.Length/1024) + " KB, scritto alle " + $fi.LastWriteTime.ToString("HH:mm:ss",$INV) + ", log: " + $sintesi + ")"
  Dico ("compilata la sonda: " + $Compilazione) "Green"

  # -------------------------------------------------------------------
  #  4. LA CORSA CON IL GATE ACCESO -- 8 celle
  # -------------------------------------------------------------------
  $Risultati = Join-Path $Work ("risultati_prove\" + $EA)
  $csvGate = Join-Path $Risultati ($EA + "_" + $Simbolo + "_IS_GATE.csv")
  $csvCtrl = Join-Path $Risultati ($EA + "_" + $Simbolo + "_IS_CTRL.csv")

  function LanciaGenerico([string]$provaPath,[string]$etichetta,[string]$bersaglio){
    # il CSV bersaglio si CANCELLA prima: cosi' "esiste" vuol dire
    # "prodotto adesso", e il generico non puo' saltare la corsa
    # dicendo "gia' fatto" (difetto pagato il 31/08 sulla LondonFX).
    Remove-Item -LiteralPath $bersaglio -Force -ErrorAction SilentlyContinue
    $argv = @("-ExecutionPolicy","Bypass","-File",$drv,
              "-Expert",$EA,
              "-Prova",$provaPath,
              "-Etichetta",$etichetta,
              "-Simbolo",$Simbolo,
              "-Periodo",$Periodo,
              "-DaQuando",$DaQuando,
              "-Fino",$Fino,
              "-Modello","4",
              "-FrazioneIS","1",
              "-Deposito",("" + $Deposito))
    if($GiroAVuoto){ $argv += "-SoloControllo" }
    if($Rifai){ $argv += "-Rifai" }
    $global:LASTEXITCODE = 0
    & powershell $argv
    return $LASTEXITCODE
  }

  $tGate = Get-Date
  if($CorseVolute -contains "GATE"){
    Titolo ("4. CORSA GATE ACCESO -- " + $CelleGate + " celle, tick reali")
    $rc = LanciaGenerico (Join-Path $Prove $FileGate) "GATE" $csvGate
    if($rc -ne 0){
      $StatoGate = "FERMATA (il driver generico e' uscito con codice " + $rc + ")"
      [void]$Problemi.Add("corsa GATE: il driver generico e' uscito con codice " + $rc + ". Il rosso sul CSV *_OOS invece e' ATTESO (gamba degenere con -FrazioneIS 1): non e' quello.")
    }
    elseif($GiroAVuoto){ $StatoGate = "GIRO A VUOTO OK (nessuna passata, nessun CSV)" }
    else{
      if(Test-Path -LiteralPath $csvGate){
        $lw = (Get-Item -LiteralPath $csvGate).LastWriteTime
        if($lw -lt $tGate.AddMinutes(-1)){
          $StatoGate = "CSV SCARTATO PERCHE' VECCHIO (scritto " + $lw.ToString("yyyy-MM-dd HH:mm",$INV) + ", corsa partita " + $tGate.ToString("yyyy-MM-dd HH:mm",$INV) + ")"
          [void]$Problemi.Add("corsa GATE: il CSV trovato e' PIU' VECCHIO dell'avvio della corsa. Non e' la misura di adesso e non si legge.")
        } else {
          $RigheGate = LeggiOptCsv $csvGate
          if($null -eq $RigheGate){
            $StatoGate = "CSV NON LEGGIBILE"
            [void]$Problemi.Add("corsa GATE: CSV vuoto o senza le colonne della sonda. Intestazioni viste: " + ($script:Intestazioni -join " | "))
          } else { $StatoGate = "MISURATA (" + @($RigheGate).Count + " righe)" }
        }
      } else {
        $StatoGate = "NESSUN CSV PRODOTTO"
        [void]$Problemi.Add("corsa GATE: nessun CSV. Storico mancante su " + $Simbolo + "? MT5 gia' aperto? Cache del tester?")
      }
    }
    Dico ("corsa GATE .. " + $StatoGate) "Cyan"
  }

  # -------------------------------------------------------------------
  #  5. IL CANCELLO -- QUI, FRA LE DUE CORSE, PRIMA DI SPENDERE ANCORA
  #     (classe 151: un cancello promesso e non scritto e' una bugia
  #      col timbro verde)
  # -------------------------------------------------------------------
  $FaiCtrl = ($CorseVolute -contains "CTRL")
  if($GiroAVuoto){
    $CancelloStato = "NON VALUTABILE (giro a vuoto: nessun CSV da leggere)"
  }
  elseif($CorseVolute -contains "GATE"){
    Titolo "5. IL CANCELLO DOPO LA CORSA GATE (si spende solo se passa)"
    $gg = CancelloDopoGate $RigheGate $CelleGate
    foreach($nn in $gg.Note){ Dico ("  . " + $nn) "DarkGray" }
    if($gg.Ok){
      $CancelloStato = "PASSATO"
      Dico "cancello .... PASSATO: la corsa di CONTROLLO si puo' spendere" "Green"
    } else {
      $CancelloStato  = "FERMATO"
      $CancelloPerche = $gg.Motivo
      $FaiCtrl = $false
      $StatoCtrl = "NON ESEGUITA -- fermata dal cancello dopo la corsa GATE"
      [void]$Problemi.Add("CANCELLO: " + $gg.Motivo)
      Write-Host ""
      Write-Host ("!!! CANCELLO: " + $gg.Motivo) -ForegroundColor Red
      Write-Host "    La corsa di CONTROLLO NON viene lanciata: e' macchina risparmiata," -ForegroundColor Yellow
      Write-Host "    non un guasto. Il referto e lo zip escono lo stesso." -ForegroundColor Yellow
    }
  }
  else{
    $CancelloStato = "NON VALUTATO (-SoloCorsa CTRL: la corsa GATE non e' stata fatta in questo giro)"
  }

  # -------------------------------------------------------------------
  #  6. LA CORSA DI CONTROLLO -- gate SPENTO, 2 celle
  # -------------------------------------------------------------------
  if($FaiCtrl){
    Titolo ("6. CORSA DI CONTROLLO -- GATE SPENTO, " + $CelleCtrl + " celle, tick reali")
    $tCtrl = Get-Date
    $rc2 = LanciaGenerico (Join-Path $Prove $FileCtrl) "CTRL" $csvCtrl
    if($rc2 -ne 0){
      $StatoCtrl = "FERMATA (il driver generico e' uscito con codice " + $rc2 + ")"
      [void]$Problemi.Add("corsa di CONTROLLO: il driver generico e' uscito con codice " + $rc2 + ".")
    }
    elseif($GiroAVuoto){ $StatoCtrl = "GIRO A VUOTO OK (nessuna passata, nessun CSV)" }
    else{
      if(Test-Path -LiteralPath $csvCtrl){
        $lw2 = (Get-Item -LiteralPath $csvCtrl).LastWriteTime
        if($lw2 -lt $tCtrl.AddMinutes(-1)){
          $StatoCtrl = "CSV SCARTATO PERCHE' VECCHIO (scritto " + $lw2.ToString("yyyy-MM-dd HH:mm",$INV) + ")"
          [void]$Problemi.Add("corsa di CONTROLLO: il CSV trovato e' PIU' VECCHIO dell'avvio della corsa.")
        } else {
          $RigheCtrl = LeggiOptCsv $csvCtrl
          if($null -eq $RigheCtrl){
            $StatoCtrl = "CSV NON LEGGIBILE"
            [void]$Problemi.Add("corsa di CONTROLLO: CSV vuoto o senza le colonne della sonda.")
          } else { $StatoCtrl = "MISURATA (" + @($RigheCtrl).Count + " righe)" }
        }
      } else {
        $StatoCtrl = "NESSUN CSV PRODOTTO"
        [void]$Problemi.Add("corsa di CONTROLLO: nessun CSV prodotto.")
      }
    }
    Dico ("corsa CTRL .. " + $StatoCtrl) "Cyan"
  }

  # --- i CSV *_OOS: attesi ZERO (gamba degenere). Si CONTANO, e il
  #     numero finisce nel referto, non solo a schermo.
  if(Test-Path -LiteralPath $Risultati){
    $OosTrovati = @(Get-ChildItem -LiteralPath $Risultati -Filter "*_OOS_*.csv" -ErrorAction SilentlyContinue).Count
  }
}
catch{
  $Fatale = ("" + $_.Exception.Message)
  Write-Host ""
  Write-Host ("!!! FERMATO: " + $Fatale) -ForegroundColor Red
}

# =====================================================================
#  IL REFERTO -- SEMPRE, anche (soprattutto) quando la corsa si e'
#  fermata a meta'.
# =====================================================================
Titolo "REFERTO E RACCOLTA"
$Cart = Join-Path $Dsk ("GAPCASH_PASSO0_" + ($Modo -replace '\s','') + "_" + $Stamp)
New-Item -ItemType Directory -Force -Path $Cart | Out-Null

$R = New-Object System.Collections.ArrayList
function L([string]$t){ [void]$R.Add($t) }

L "====================================================================="
L (" PASSO 0 -- GAP DELLA SESSIONE CASH DEL NASDAQ (" + $Simbolo + " " + $Periodo + ")")
L "====================================================================="
L ("modo ........: " + $Modo + "   <- GIRO A VUOTO non e' un risultato")
L ("data ........: " + $Avvio.ToString("yyyy-MM-dd HH:mm:ss",$INV) + "  (referto chiuso alle " + (Get-Date).ToString("HH:mm:ss",$INV) + ")")
L ("pin .........: " + $Pin)
L ("sonda .......: " + $EA + " v" + $SondaVersione + "  -- CONTATORE: nessun ordine, nessun magic, nessuna sedia")
L ("contratto ...: prove\" + $FileGate + "   (criteri congelati il 06/09/2026)")
L ("controllo ...: prove\" + $FileCtrl + "   (variante: cambia SOLO InpGateSpento e l'asse tecnico)")
L ("finestra ....: " + $DaQuando + " -> " + $Fino + "   UNA TRANCHE (-FrazioneIS 1)")
L ("giorni feriali di CALENDARIO nella finestra: " + $Feriali)
L ("banco .......: Modello 4 (TICK REALI), deposito " + $Deposito + " -- irrilevante, la sonda non apre ordini")
L ("terminale ...: " + $Terminale)
L ("compilazione : " + $Compilazione)
L ("profondita' tick (misura riletta al pin, misura_tick_" + $Simbolo + ".csv):")
L ("   " + $RigaTick)
L ("   COSA DICE : i tick reali di questo simbolo partono dalla data qui sopra.")
L ("   COSA NON DICE: 'PARZIALI' e' riferito alla richiesta della misura (2022.01.01),")
L ("   NON alla finestra di questo round. E NON e' stato misurato se dentro la")
L ("   finestra ci siano buchi. P0-3 misura lo spread TICK PER TICK: se i tick non")
L ("   fossero nativi, quel criterio misurerebbe un'altra cosa.")
L ("corsa GATE ..: " + $StatoGate)
L ("corsa CTRL ..: " + $StatoCtrl)
L ("cancello ....: " + $CancelloStato + $(if($CancelloPerche -ne ""){ " -- " + $CancelloPerche }else{ "" }))
L ("CSV *_OOS trovati: " + $OosTrovati + "   (attesi 0: con -FrazioneIS 1 la gamba OOS del driver generico e' DEGENERE e si ignora)")
L ""
L "QUESTA CORSA NON DICE SE IL MOTORE GUADAGNA."
L "Non apre ordini, non c'e' profit factor, non c'e' equity, non c'e' drawdown,"
L "e non promuove nessuna cella. Una frequenza alta NON e' un edge: e' una"
L "frequenza. (contratto, par. 4)"
L ""

if($null -ne $RigheGate){
  # ordina per soglia crescente in valore assoluto: dalla piu' larga
  # (-0,30) alla piu' stretta (-1,00). Si stampa come e' spazzolata.
  $ord = @($RigheGate | Sort-Object -Property @{ Expression = { $v = V $_ "Eco Soglia Gap Long"; if($null -eq $v){ 0 } else { [double]$v } } } -Descending)

  L "---------------------------------------------------------------------"
  L "  P0-1  FREQUENZA  --  cancello: >= 25 giornate-evento PASSA, < 25 SCARTO"
  L "  P0-2  SEGNO E SEPARAZIONE  --  PASSA se media evento > 0 E >= 3x media di TUTTE"
  L "---------------------------------------------------------------------"
  L ("atteso dal contratto alla soglia -0,50%: ~" + $AttesiEventi + " giornate-evento su 503 feriali.")
  L ("questa finestra ha " + $Feriali + " feriali di calendario: riscalato, l'atteso e' ~" + [int]([math]::Round($AttesiEventi*$Feriali/503.0)) + ".")
  L "IL CANCELLO RESTA 25, che e' quello congelato: il riscalo serve a leggere, non a giudicare."
  L ""
  L "soglia%   valide  eventi  P0-1     mediaEv%   mediaTutti%  sep.x   P0-2     medianaEv%  winEv%  winTutti%"
  foreach($r in $ord){
    L ("{0,7}  {1,6}  {2,6}  {3,-7}  {4,9}  {5,11}  {6,6}  {7,-7}  {8,10}  {9,6}  {10,9}" -f `
        (F2 (V $r "Eco Soglia Gap Long")), (F0 (V $r "Giornate Valide")), (F0 (V $r "P01 Eventi Long")),
        (NomeEsito (V $r "P01 Esito")), (FS (V $r "P02 Media Evento Pct")), (FS (V $r "P02 Media Tutti Pct")),
        (F2 (V $r "P02 Separazione X")), (NomeEsito (V $r "P02 Esito")), (FS (V $r "Mediana Evento Pct")),
        (F2 (V $r "Win Evento Pct")), (F2 (V $r "Win Tutti Pct")))
  }
  $deg = 0
  foreach($r in $ord){ $d = V $r "P02 Controllo Degenere"; if($null -ne $d -and $d -gt 0){ $deg++ } }
  if($deg -gt 0){
    L ""
    L ("*** " + $deg + " celle hanno la media di CONTROLLO <= 0. In quel caso il '3x' e' vero per")
    L "    ARITMETICA e non vuol dire piu' niente: la separazione va letta come NON"
    L "    DIMOSTRATA, e il numero che conta e' il SEGNO della media evento."
  }
  L ""
  L "---------------------------------------------------------------------"
  L "  P0-3  COSTO -- spread del minuto 14:30:00-14:31:00 SERVER, DA SOLO,"
  L "        misurato TICK PER TICK. Cancello: take mediano >= 3x spread"
  L "        mediano PASSA, 2-3x SOSPESO, < 2x SCARTO."
  L "---------------------------------------------------------------------"
  L "soglia%   take med.   spread med.  spread P95   take/spread  P0-3      tick nel minuto  scartati  oltre tetto"
  foreach($r in $ord){
    L ("{0,7}  {1,10}  {2,11}  {3,11}  {4,11}  {5,-8}  {6,15}  {7,8}  {8,11}" -f `
        (F2 (V $r "Eco Soglia Gap Long")), (F4 (V $r "P03 Take Mediano Unita")),
        (F4 (V $r "P03 Spread Campana Mediano Unita")), (F4 (V $r "P03 Spread Campana P95 Unita")),
        (F2 (V $r "P03 Rapporto Take Su Spread")), (NomeEsito (V $r "P03 Esito")),
        (F0 (V $r "P03 Tick Campana Eventi")), (F0 (V $r "P03 Tick Campana Scartati")),
        (F0 (V $r "P03 Spread Oltre Tetto")))
  }
  L "le unita' sono UNITA' DI PREZZO del simbolo (punti indice), non punti MT5."
  L ""
  L "---------------------------------------------------------------------"
  L "  P0-4  GEOMETRIA -- NESSUN CANCELLO: SI LEGGE."
  L "        Lo stop del round successivo lo fissa il p75 di |MAE|,"
  L "        arrotondato, e NON si spazzola cercando il picco."
  L "---------------------------------------------------------------------"
  L "soglia%   MAE p50%  MAE p75%  MAE p90%  MFE p50%  MFE p75%  MAE p75 (unita' di prezzo)"
  foreach($r in $ord){
    L ("{0,7}  {1,8}  {2,8}  {3,8}  {4,8}  {5,8}  {6,12}" -f `
        (F2 (V $r "Eco Soglia Gap Long")), (F4 (V $r "P04 MAE p50 Pct")), (F4 (V $r "P04 MAE p75 Pct")),
        (F4 (V $r "P04 MAE p90 Pct")), (F4 (V $r "P04 MFE p50 Pct")), (F4 (V $r "P04 MFE p75 Pct")),
        (F4 (V $r "P04 MAE p75 Unita")))
  }
  L "atteso dallo storico ESTERNO (non da BCM): |MAE15| p50 0,196% p75 0,356% p90 0,534%;"
  L "MFE15 p50 0,277% p75 0,454%. Se i numeri di BCM fossero molto diversi, e' il DATO"
  L "che va guardato prima del motore."
  L ""
  L "---------------------------------------------------------------------"
  L "  P0-5  DUE LATI -- lo SHORT sui gap >= +0,50%."
  L "        PREVISIONE SCRITTA PRIMA, nel contratto: NULLA."
  L "        Se uscisse VIVO sarebbe una sorpresa da scrivere, non da"
  L "        festeggiare: vorrebbe dire che feed esterno e BCM non"
  L "        raccontano la stessa storia, e il problema e' il DATO."
  L "---------------------------------------------------------------------"
  $rs = $ord[0]
  L ("il lato short NON dipende dalla soglia long (soglia fissa +0,50%): si legge una volta.")
  L ("eventi short ...............: " + (F0 (V $rs "P05 Eventi Short")))
  L ("media short ................: " + (FS (V $rs "P05 Media Short Pct")) + " %   (mediana " + (FS (V $rs "P05 Mediana Short Pct")) + " %)")
  L ("win short ..................: " + (F2 (V $rs "P05 Win Short Pct")) + " %   contro un controllo di " + (F2 (V $rs "Win Tutti Pct")) + " %")
  L ("separazione short ..........: " + (F2 (V $rs "P05 Separazione Short X")) + " x")
  L ("esito frequenza / separaz. .: " + (NomeEsito (V $rs "P05 Esito Frequenza")) + " / " + (NomeEsito (V $rs "P05 Esito Separazione")))
  L ("MAE short p75 / MFE short p50: " + (F4 (V $rs "P05 MAE Short p75 Pct")) + " % / " + (F4 (V $rs "P05 MFE Short p50 Pct")) + " %")
  L "atteso sull'esterno: media +0,0076%, win 51,0% contro un controllo di 50,8% -> NULLO."
  L ""
  L "---------------------------------------------------------------------"
  L "  P0-6  IGIENE -- festivi e mezze sedute fuori, e la QUOTA DEI LUNEDI'."
  L "        Oltre il 40% di lunedi' questo e' il gap del WEEKEND"
  L "        travestito (gia' misurato da R61/R62): verdetto SOSPESO."
  L "---------------------------------------------------------------------"
  L "soglia%   eventi  lunedi  quota%   P0-6      barre M1 1a ora (mediana)  aperture non esatte"
  foreach($r in $ord){
    L ("{0,7}  {1,6}  {2,6}  {3,6}  {4,-8}  {5,24}  {6,19}" -f `
        (F2 (V $r "Eco Soglia Gap Long")), (F0 (V $r "P01 Eventi Long")), (F0 (V $r "P06 Eventi Lunedi")),
        (F2 (V $r "P06 Quota Lunedi Pct")), (NomeEsito (V $r "P06 Esito")),
        (F2 (V $r "P06 Barre Prima Ora Mediana")), (F0 (V $r "P06 Aperture Non Esatte")))
  }
  $r0 = $ord[0]
  L ("giornate scartate per IGIENE (poche barre M1): " + (F0 (V $r0 "Giornate Scartate Igiene")) + "   per DATI: " + (F0 (V $r0 "Giornate Scartate Dati")))
  L ("letture M1 fallite: " + (F0 (V $r0 "Letture M1 Fallite")) + "   giornate troncate: " + (F0 (V $r0 "Giornate Troncate")))
  L ""

  # --- LA CELLA DI RIFERIMENTO, DICHIARATA PRIMA: -0,50%.
  #     Il verdetto si legge LI'. Le altre sette servono a vedere se la
  #     soglia e' MONOTONA, non a scegliere la piu' bella: scegliere il
  #     picco di una griglia e' esattamente il difetto che questa casa
  #     non fa (centro dell'altopiano, mai il picco).
  $rif = $null
  foreach($r in $ord){
    $s = V $r "Eco Soglia Gap Long"
    if($null -ne $s -and [math]::Abs([double]$s + 0.50) -lt 0.0001){ $rif = $r }
  }
  L "---------------------------------------------------------------------"
  L "  IL VERDETTO -- si legge SULLA CELLA -0,50%, dichiarata prima."
  L "---------------------------------------------------------------------"
  if($null -eq $rif){
    L "CELLA -0,50% NON TROVATA nel CSV: il verdetto non si legge."
    [void]$Problemi.Add("la cella di riferimento -0,50% non e' nel CSV: il verdetto del PASSO 0 non e' leggibile.")
  } else {
    L ("P0-1 frequenza .....: " + (NomeEsito (V $rif "P01 Esito")) + "   (" + (F0 (V $rif "P01 Eventi Long")) + " giornate-evento, cancello " + $P01Cancello + ")")
    L ("P0-2 separazione ...: " + (NomeEsito (V $rif "P02 Esito")) + "   (" + (FS (V $rif "P02 Media Evento Pct")) + "% contro " + (FS (V $rif "P02 Media Tutti Pct")) + "% = " + (F2 (V $rif "P02 Separazione X")) + "x, cancello 3x)")
    L ("P0-3 costo .........: " + (NomeEsito (V $rif "P03 Esito")) + "   (take " + (F4 (V $rif "P03 Take Mediano Unita")) + " contro spread " + (F4 (V $rif "P03 Spread Campana Mediano Unita")) + " = " + (F2 (V $rif "P03 Rapporto Take Su Spread")) + "x)")
    L ("P0-4 geometria .....: NESSUN CANCELLO -- si legge. Lo stop del round dopo e' il p75 di |MAE| = " + (F4 (V $rif "P04 MAE p75 Pct")) + "% (" + (F4 (V $rif "P04 MAE p75 Unita")) + " in unita' di prezzo).")
    L ("P0-5 due lati ......: frequenza " + (NomeEsito (V $rif "P05 Esito Frequenza")) + ", separazione " + (NomeEsito (V $rif "P05 Esito Separazione")) + " sul lato SHORT")
    L ("P0-6 lunedi' .......: " + (NomeEsito (V $rif "P06 Esito")) + "   (" + (F0 (V $rif "P06 Eventi Lunedi")) + " su " + (F0 (V $rif "P01 Eventi Long")) + " = " + (F2 (V $rif "P06 Quota Lunedi Pct")) + "%, cancello 40%)")
    L ""
    L ("VERDETTO COMPLESSIVO (catena calcolata dalla sonda: uno SCARTO domina tutto,")
    L ("un SOSPESO o un NON MISURATO domina un PASSA): " + (NomeEsito (V $rif "Verdetto Complessivo")))
  }
  L ""
  L "--- LA MONOTONIA DELLA SOGLIA (si LEGGE, non e' un cancello) ---"
  L "sull'esterno la media cresceva al crescere della soglia, in modo MONOTONO."
  $prec = $null; $rotture = 0
  foreach($r in $ord){
    $m = V $r "P02 Media Evento Pct"
    if($null -ne $prec -and $null -ne $m -and $m -lt $prec){ $rotture++ }
    if($null -ne $m){ $prec = $m }
  }
  L ("rotture della monotonia (soglia da -0,30 verso -1,00): " + $rotture + " su " + ([math]::Max(0,@($ord).Count-1)))
  L "una monotonia rotta NON boccia niente da sola: dice che il gate non e' una"
  L "manopola pulita su questo feed, e va scritto accanto al verdetto."
  L ""
}
else {
  L "--- NESSUNA TABELLA: il CSV della corsa GATE non e' stato letto. ---"
  L "Il motivo sta nella riga 'corsa GATE' qui sopra e nei PROBLEMI in fondo."
  L ""
}

# --- IL CONFRONTO GATE / CONTROLLO: e' il motivo per cui la corsa di
#     controllo esiste, e sono tre fatti verificabili.
L "---------------------------------------------------------------------"
L "  LA CORSA DI CONTROLLO (gate SPENTO) -- tre verifiche, non un verdetto"
L "---------------------------------------------------------------------"
if($null -eq $RigheCtrl){
  L "NON LETTA. " + $StatoCtrl
  L "Senza questa corsa, la media di controllo di P0-2 resta quella calcolata"
  L "DENTRO la corsa a gate acceso: e' lo stesso numero, ma non e' stato"
  L "verificato da una seconda misura indipendente. Va detto, non nascosto."
}
else{
  $c0 = $RigheCtrl[0]
  $egc = V $c0 "Eco Gate Spento"
  L ("1. il gate e' davvero SPENTO in questa corsa: Eco Gate Spento = " + (F0 $egc) + (if($null -ne $egc -and [int]$egc -eq 1){ "  -> SI" }else{ "  -> NO, e allora la riga InpGateSpento NON e' arrivata all'EA" }))
  $ev = V $c0 "P01 Eventi Long"; $va = V $c0 "Giornate Valide"
  $ug = "n/d"
  if($null -ne $ev -and $null -ne $va){ if([int]$ev -eq [int]$va){ $ug = "SI" } else { $ug = "NO" } }
  L ("2. a gate spento ogni giornata valida e' evento: eventi " + (F0 $ev) + " contro valide " + (F0 $va) + "  -> " + $ug)
  if($ug -eq "NO"){ [void]$Problemi.Add("corsa di CONTROLLO: eventi (" + (F0 $ev) + ") diversi dalle giornate valide (" + (F0 $va) + ") a gate spento. La riga InpGateSpento non ha fatto quello che doveva.") }
  if($null -ne $RigheGate){
    $mg = V $RigheGate[0] "P02 Media Tutti Pct"
    $mc = V $c0 "P02 Media Tutti Pct"
    $dd = "n/d"
    if($null -ne $mg -and $null -ne $mc){
      if([math]::Abs([double]$mg - [double]$mc) -lt 0.0000005){ $dd = "COINCIDONO" }
      else { $dd = "DIVERSE (differenza " + ([double]$mg - [double]$mc).ToString("0.000000",$INV) + ")" }
    }
    L ("3. la media di CONTROLLO misurata due volte: gate " + (FS $mg) + "% contro controllo " + (FS $mc) + "%  -> " + $dd)
    if($dd -like "DIVERSE*"){
      [void]$Problemi.Add("la media su TUTTE le giornate e' diversa fra la corsa GATE e la corsa di CONTROLLO: e' la STESSA popolazione misurata due volte. Il problema e' il BANCO, non il motore, e nessun numero del PASSO 0 si legge.")
    }
  } else {
    L "3. confronto con la corsa GATE: NON FATTO (il CSV GATE non e' stato letto)."
  }
  # gemelli di determinismo: le due righe del controllo sono identiche
  # per costruzione (a gate spento la soglia e' inerte).
  if(@($RigheCtrl).Count -eq 2){
    $a = $RigheCtrl[0]; $b = $RigheCtrl[1]
    $diverse = New-Object System.Collections.ArrayList
    foreach($col in @("P01 Eventi Long","P02 Media Evento Pct","P02 Media Tutti Pct","P03 Take Mediano Unita","P03 Spread Campana Mediano Unita","P04 MAE p75 Pct","P05 Eventi Short","P06 Eventi Lunedi","Giornate Valide")){
      $x = V $a $col; $y = V $b $col
      if($null -eq $x -or $null -eq $y){ [void]$diverse.Add($col + " (illeggibile)"); continue }
      if([math]::Abs([double]$x - [double]$y) -gt 0.0000005){ [void]$diverse.Add($col) }
    }
    if($diverse.Count -eq 0){
      L "4. gemelli di determinismo (le due celle a gate spento sono identiche per"
      L "   costruzione, la soglia li' e' inerte): IDENTICI."
    } else {
      L ("4. gemelli di determinismo: DIVERSI su -> " + ($diverse -join ", "))
      [void]$Problemi.Add("gemelli di determinismo DIVERSI nella corsa di controllo (" + ($diverse -join ", ") + "): il banco non e' deterministico e i numeri non si leggono.")
    }
  } else {
    L ("4. gemelli di determinismo: NON VALUTABILI (" + @($RigheCtrl).Count + " righe invece di 2).")
  }
}
L ""

# --- P0-7: OBBLIGO DI REFERTO. Non e' un cancello: e' un elenco che
#     DEVE comparire, e che va sciolto PRIMA di qualunque deploy.
L "---------------------------------------------------------------------"
L "  P0-7  COLLISIONE -- cosa gira gia' su " + $Simbolo + " alle 14:30:00 SERVER"
L "        (obbligo di referto del contratto, non un cancello)"
L "---------------------------------------------------------------------"
L "  1. ABTG_ORB                       magic 770601   NASUSD M5"
L "  2. Nasdaq_Apertura_US_Ottimizzato (vedi FLOTTA_ATTIVA.md)  NASUSD M5"
L "  3. GATED SHORT                    magic 770250   NASUSD M15"
L "     -> SHORT sulla rottura al ribasso dell'apertura, forward dal 30/08,"
L "        conto PICCOLO 50503392, rischio 0,35%."
L ""
L "  *** IL CONFLITTO, SCRITTO PRIMA DI AVERE I NUMERI ***"
L "  Su una mattina di GAP IN GIU' la sedia GATED SHORT 770250 VENDE e questo"
L "  motore COMPREREBBE: opposti, stesso simbolo, stesso minuto. Non e' una"
L "  sovrapposizione di orario: e' una posizione contro l'altra dentro lo"
L "  stesso conto. VA SCIOLTO PRIMA DI QUALUNQUE DEPLOY, e questo PASSO 0"
L "  non lo scioglie: lo mette agli atti."
L ""
L "  QUESTA CORSA NON MISURA LO STATO acceso/spento di quelle tre sedie."
L "  Lo stato si legge in FLOTTA_ATTIVA.md e sul VPS, non qui. [DA VERIFICARE"
L "  al momento del deploy: report/M27_SEGNO_ASPETTATIVA_2026-08-31.md dice che"
L "  l'ORB nativo 770601 e' stato spento a inizio agosto -- se e' cosi', il"
L "  conflitto vivo resta quello con la 770250.]"
L ""

L "---------------------------------------------------------------------"
L "  IL NUMERO DA GUARDARE PER PRIMO NON E' IL VERDETTO"
L "---------------------------------------------------------------------"
L ("  a) P0-1: le giornate-evento alla soglia -0,50%, contro le ~" + $AttesiEventi + " attese")
L "     dallo storico esterno. Molto meno = il fenomeno su BCM e' un'altra cosa."
L "  b) la QUOTA DEI LUNEDI' di P0-6. Oltre il 40% non stiamo misurando quello"
L "     che crediamo di misurare."
L ""
L "SE PASSA, cosa succede dopo (contratto par. 7): si scrive l'EA vero con lo"
L "stop dimensionato sul p75 di |MAE| letto qui, si fa un round di merito a tick"
L "con il MERITO gia' dichiarato SOSPESO per n insufficiente (0,14 eventi/giorno"
L "e' UN OTTAVO del pavimento di frequenza di casa: questo motore NON PUO'"
L "essere portata, al massimo un CECCHINO), e SOLO dopo si apre la cassaforte"
L "2021-2026 dello storico esterno. Vale solo se nessuno la apre prima."
L ""

if($Fatale -ne ""){
  L ("!!! FERMATO: " + $Fatale)
  L ""
}
L ("PROBLEMI: " + $Problemi.Count)
foreach($p in $Problemi){ L ("  - " + $p) }
L ("RILIEVI: " + $Rilievi.Count)
foreach($p in $Rilievi){ L ("  - " + $p) }
L ""
L "COME SI RIPRENDE: si riparte dalla pagina righe\RIGA_GAPCASH_PASSO0_DA_MANDARE.md,"
L "NON da questa riga: $p e $pin nascono dentro il blocco di lancio e non"
L "sopravvivono alla fine del blocco."

$refPath = Join-Path $Cart "REFERTO_GAPCASH_PASSO0.txt"
Set-Content -LiteralPath $refPath -Value ($R -join "`r`n") -Encoding ASCII
Write-Host ($R -join "`r`n")

# --- gli artefatti, copiati PER NOME: solo cio' che esiste davvero.
foreach($f in @(("COMPILAZIONE_" + $EA + ".log"), "misura_tick_NASUSD.csv")){
  $s1 = Join-Path $Work $f
  if(Test-Path -LiteralPath $s1){ Copy-Item -LiteralPath $s1 -Destination $Cart -Force }
}
foreach($f in @($FileGate,$FileCtrl)){
  $s2 = Join-Path $Prove $f
  if(Test-Path -LiteralPath $s2){ Copy-Item -LiteralPath $s2 -Destination $Cart -Force }
}
$Ris2 = Join-Path $Work ("risultati_prove\" + $EA)
if(Test-Path -LiteralPath $Ris2){
  foreach($f in @(Get-ChildItem -LiteralPath $Ris2 -Filter "*.csv" -ErrorAction SilentlyContinue)){
    Copy-Item -LiteralPath $f.FullName -Destination $Cart -Force
  }
}

$zip = $Cart + ".zip"
Remove-Item -LiteralPath $zip -Force -ErrorAction SilentlyContinue
try{ Compress-Archive -Path (Join-Path $Cart "*") -DestinationPath $zip -Force }catch{ }
Write-Host ""
Write-Host ("CARTELLA: " + $Cart) -ForegroundColor Green
Write-Host ("ZIP DA MANDARE: " + $zip) -ForegroundColor Green
Write-Host "FILE ATTESI NELLO ZIP:" -ForegroundColor Gray
Write-Host "   - REFERTO_GAPCASH_PASSO0.txt          <- e' questo che conta" -ForegroundColor Gray
Write-Host ("   - " + $EA + "_" + $Simbolo + "_IS_GATE.csv    (8 righe, gate acceso)") -ForegroundColor Gray
Write-Host ("   - " + $EA + "_" + $Simbolo + "_IS_CTRL.csv    (2 righe, gate SPENTO)") -ForegroundColor Gray
Write-Host ("   - " + $FileGate + " + " + $FileCtrl) -ForegroundColor Gray
Write-Host ("   - COMPILAZIONE_" + $EA + ".log        (se il compilatore ha lasciato un log)") -ForegroundColor Gray

# =====================================================================
#  CODICI DI USCITA -- e nessuno di questi vuol dire "il motore va bene"
#    0 = tutto girato, referto completo
#    2 = PARZIALE: il cancello ha fermato la spesa, oppure ci sono
#        PROBLEMI. NON e' un guasto: lo zip e' valido e si manda.
#    3 = COMPILAZIONE FALLITA: e' un esito normale e gestito. Il log e'
#        nello zip, ed e' quello il risultato del PASSO 0.
#    1 = fermato prima, da un cancello di pre-volo o da un'eccezione.
# =====================================================================
if($Compilazione -like "FALLITA*"){
  Write-Host ""
  Write-Host "ESITO: COMPILAZIONE FALLITA -- e' un esito, non un guasto della riga." -ForegroundColor Red
  Write-Host ("   " + $Compilazione) -ForegroundColor Red
  Write-Host "   Manda lo zip cosi' com'e': il log del compilatore E' il risultato." -ForegroundColor Yellow
  exit 3
}
if($Fatale -ne ""){ Write-Host "ESITO: FERMATO" -ForegroundColor Red; exit 1 }
if($CancelloStato -eq "FERMATO"){
  Write-Host ""
  Write-Host "ESITO: FERMATO DAL CANCELLO -- macchina risparmiata, zip valido." -ForegroundColor Yellow
  exit 2
}
if($Problemi.Count -gt 0){ Write-Host "ESITO: COMPLETATO CON PROBLEMI" -ForegroundColor Yellow; exit 2 }
Write-Host ("ESITO: " + $Modo + " COMPLETATO") -ForegroundColor Green
exit 0
