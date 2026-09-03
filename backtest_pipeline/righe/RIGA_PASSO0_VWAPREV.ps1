# =====================================================================
#  MARCATORE_RIGA_PASSO0_VWAPREV_v4
#  RIGA_PASSO0_VWAPREV.ps1  --  PASSO 0 DEL MOTORE VWAP REVERT
# ---------------------------------------------------------------------
#  v4 (03/09/2026) -- la v3 era del 28/08, PRIMA delle classi 106-116
#  della CHECKLIST (corollario della classe 111). Rilettura completa,
#  otto correzioni; NESSUN criterio gia' scritto e' cambiato, UNO e'
#  stato AGGIUNTO perche' oggi e' misurabile (S0, vedi sotto):
#   94-ter  'compilazione:' aveva solo lo stato OK: sul ramo fallito
#           restava "NON TENTATA". Ora tre stati timbrati sul ramo che
#           decide (NON TENTATA / FALLITA / OK). E il campo si chiamava
#           $Compilazione mentre nei fratelli e' $Compilato: il
#           censimento della classe 111 (grep sul nome) NON lo vedeva
#           (classe 113). Ora si chiama come nei fratelli.
#   108     codice d'uscita del driver generico a tre stati (0 / N /
#           NON LETTO); decide l'artefatto (CSV freschi, anteprima .ini).
#   115     terminale scelto per FATTO (bases\*BCM*), scansione larga,
#           elenco + manopola -Terminale se ambiguo, e PASSATO al
#           driver generico (-Terminal/-MetaEditor/-DataFolder).
#   116     include con sentinella, backup, ripristino a fine giro
#           (anche nel giro fermato) e all'avvio del giro dopo se
#           interrotto; foto PRIMA/DOPO nel referto.
#   116-bis Desktop cercato, non assunto (OneDrive).
#   25/113  DICIANNOVE input dell'EA NON erano pinnati nei file prova
#           (InpUsaGuardian, InpMaxSpread, InpWickMult, InpBodyPctMax,
#           InpClosePct, ...): MT5 li avrebbe presi dal default compilato
#           O DAL FLAG RICORDATO dall'ultima griglia di questo EA, e il
#           gate della baseline non poteva vederli (il campo che manca
#           del tutto e' invisibile al grep). Ora sono pinnati in forma
#           completa in tutti e quattro i file e nella baseline qui.
#   S0      IL CANCELLO DEL COSTO E' ADJUDICABILE DA OGGI: lo spread di
#           D30EUR e' MISURATO (SPREAD_FLOTTA_MISURA_2026-09-03.md:
#           mediana 1,6-1,7 punti indice nelle ore 8-16 server, notte
#           3,5-3,9; conversione 1 punto indice = 100 punti MT5) e il
#           contract size e' agli atti (R114 GSPEC: 10, profitto in
#           EUR). La riga legge l'export per-trade dell'EA e stampa il
#           verdetto S0 per cella, coi criteri scritti PRIMA dei numeri
#           in testa a prove\ABTG_VwapRevert.txt.
#   +       COMPILAZIONE_FALLITA.log finisce nello zip; il referto
#           stampa il terminale; InpMagic mancante ha un messaggio suo.
#  ABTG_VwapRevert  su  D30EUR  M15, TICK REALI, quattro celle:
#     00_nudo       long + short insieme, flat ON   magic 773400/773401
#     01_long       solo long,            flat ON   magic 773410/773411
#     02_short      solo short,           flat ON   magic 773420/773421
#     03_overnight  long + short,         flat OFF  magic 773430/773431
# ---------------------------------------------------------------------
#  QUESTO NON E' UN ROUND E NON DA' NESSUN VERDETTO.
#  E' il PASSO 0 preteso dal dossier della caccia M5/M15 INDICI del
#  25/08/2026 (caccia_strategie\CACCIA_M5M15_INDICI_2026-08-25.md,
#  par. 6, paletto 2):
#     "PASSO 0 obbligatorio: contare le operazioni prima di leggere il
#      PF. Se n IS < 150 scatta la valvola R59."
#  Il PF che esce dal CSV si LEGGE ma NON si giudica: i criteri di
#  merito della BOZZA (S3/S4/S5/S6) sono [DA FIRMARE], e quattro celle
#  non sono un round.
#
#  LA BOZZA prove\VWAPREVERT_DAX_M15_BOZZA.txt RESTA FERMA. Questo
#  giro non la sblocca: la BOZZA e' una GRIGLIA da 18 celle che sceglie
#  una taratura, e una griglia si lancia dopo la firma. Qui l'unico
#  asse spazzolato e' InpMagic, e il driver SI FERMA se ne trova un
#  secondo.
#
#  L'IPOTESI, i tre esiti A/B/C, il cancello S0 (costo) e l'avvertenza
#  di REGIME stanno scritti in testa a prove\ABTG_VwapRevert.txt e NON
#  si riscrivono qui: un criterio ricopiato in quattro posti e' un
#  criterio che prima o poi diverge.
#
#  ------------------------------------------------------------------
#  PERCHE' ESISTE QUESTO FILE invece di quattro righe di
#  walkforward_generico.ps1 incollate a mano. Gli stessi tre motivi
#  MISURATI del PASSO 0 FVG:
#
#   1. L'INCLUDE. ABTG_VwapRevert.mq5 fa
#        #include <ABTG_PausaGuardian.mqh>
#      e walkforward_generico.ps1 NON lo installa (verificato: nel
#      driver generico la stringa 'PausaGuardian' non compare). Se quel
#      file non e' gia' in MQL5\Include la compilazione fallisce, e il
#      driver generico muore con "compilazione fallita" senza dire
#      perche'.
#
#   2. I GATE SUI FILE PROVA. Il driver generico controlla il formato,
#      non il PERIMETRO: non sa che le quattro celle devono differire
#      di due righe sole, non sa quali magic sono vietati, non sa che
#      @PERIODO deve essere M15, e non sa che il FLAT DI FINE SEDUTA e'
#      il punto di questo giro.
#
#   3. LA RACCOLTA. Regola di casa (CLAUDE.md, regola delle righe di
#      lancio, punto 2): a fine test i risultati finiscono in una
#      cartella sul Desktop e in uno zip pronto da mandare. Sempre,
#      anche quando la corsa si ferma a meta'.
#  ------------------------------------------------------------------
#
#  QUELLO CHE NON FA, dichiarato:
#   - NON GIUDICA e non promuove niente. Conta le operazioni e mette il
#     numero accanto alla soglia dei 150 dell'Emendamento regola A.
#   - NON tocca nessuna sedia viva. Gli otto magic sono VERGINI (blocco
#     7734xx, cercati uno per uno in tutto il repo il 28/08/2026: zero
#     occorrenze operative). I magic delle sedie vive e quelli dei
#     round recenti sono nella lista dei VIETATI qui sotto.
#   - NON scarica storico e non svuota bases\<server>\ticks. I tick di
#     D30EUR dal 2024.09.26 sono agli atti (sonda del 17/08, COMPLETO).
#   - NON misura lo spread: lo LEGGE dalla misura del 03/09 (CSV orario
#     spread_orario_D30EUR.csv, scaricato al pin) e applica il cancello
#     S0 ora per ora sull'export per-trade dell'EA. La conversione
#     (1 punto indice = 100 punti MT5 = 1,00 di prezzo; contract size
#     10, profitto in EUR) e' CITATA da quelle misure, non rifatta qui.
#   - non scrive una riga di MQL5.
#
#  RISCHIO DICHIARATO: l'EA non e' MAI STATO COMPILATO da nessuno --
#  scritto il 25/08/2026, modificato il 28/08 (flat di fine seduta), e
#  in quell'ambiente non esiste MetaEditor. PER QUESTO IL GIRO DI
#  CONTROLLO (-SoloControllo) ADESSO COMPILA DAVVERO: la compilazione e'
#  il primo risultato vero di questo PASSO 0, e si scopre in un minuto,
#  non dopo mezz'ora di tick reali. Se MetaEditor si lamenta, lo script
#  stampa le ultime 40 righe del log e SI FERMA.
#
#  DOVE SI LEGGE SE IL MOTORE RAGIONA: NON nella scheda Esperti.
#  In OTTIMIZZAZIONE le Print girano sugli agent e non le legge nessuno
#  (CHECKLIST punto 34). L'autotest e il flat escono in TRE COLONNE del
#  CSV -- 'Autotest Falliti', 'Flat Giorni', 'Flat Chiusure' -- e questo
#  script ci fa un GATE:
#    Autotest Falliti  = 0   -> i numeri si leggono
#    Autotest Falliti  > 0   -> DIVERGE, i numeri NON si leggono
#    Autotest Falliti  = -1  -> autotest non eseguito: nessun gate
#    Flat Giorni       = 0 con flat ACCESO -> rilievo
#    Flat Giorni       > 0 con flat SPENTO -> problema (non morde)
#
#  QUANTO CI METTE [STIMA, non una previsione]:
#   - GIRO DI CONTROLLO (-SoloControllo): ~1 minuto. NON e' piu' un giro a
#     vuoto: scarica, passa i gate sui file prova, installa l'include E
#     COMPILA DAVVERO. La compilazione e' il primo risultato vero.
#   - CORSA VERA: 8 passate a tick reali (4 celle x 2 finestre) x 2
#     gemelle = 16 passate su 21 mesi di M15. R107 fece 24 passate a tick
#     reali sulla stessa finestra in 9 minuti. Stima 15-40 minuti.
#
#  LA RIGA CHE SI INCOLLA sta in righe\RIGA_PASSO0_VWAPREV_DA_MANDARE.md
# =====================================================================
[CmdletBinding()]
param(
  # -Pin NON ha default: un default silenzioso ("lavoro") farebbe girare
  #  la punta del branch spacciandola per un commit congelato.
  [string]$Pin           = "",
  [switch]$SoloControllo,          # giro a vuoto: NON apre MT5
  [switch]$Rifai,                  # rifa' anche i CSV gia' presenti
  [string]$SoloCella     = "",     # "00_nudo" | "01_long" | "02_short" | "03_overnight"
  [string]$Simbolo       = "D30EUR",
  [string]$Periodo       = "M15",
  [string]$DaQuando      = "2024.09.26",
  [string]$Fino          = "2026.06.30",
  [int]$Deposito         = 100000,
  # -Terminale: si usa SOLO se la scelta automatica si ferma perche' non
  #  ha un FATTO per decidere (classe 115). La riga stampa l'elenco delle
  #  installazioni trovate e il percorso da incollare qui (la cartella
  #  che contiene terminal64.exe).
  [string]$Terminale     = ""
  # -Simbolo/-Periodo/-DaQuando/-Fino sono PASSATI al driver generico e
  #  CONFRONTATI coi valori dichiarati nei file prova: se differiscono
  #  la riga NON si ferma, lo scrive come RILIEVO accanto ai numeri
  #  (punto 96-bis). Non esiste un "gemello U30USD via -Simbolo": il
  #  gemello e' un ALTRO file prova, e S0 e' calcolato solo su D30EUR.
  # NIENTE -Rischio: era un PARAMETRO ORFANO (CHECKLIST punto 97). Non
  # veniva passato a nessuno, veniva solo STAMPATO nel referto -- cioe'
  # un numero mai applicato scritto accanto a numeri veri. Il rischio che
  # morde davvero e' InpRiskPercent, pinnato nei file prova, e il referto
  # lo legge da li' dichiarando la fonte.
)
$ErrorActionPreference = "Stop"
[Threading.Thread]::CurrentThread.CurrentCulture   = [Globalization.CultureInfo]::InvariantCulture
[Threading.Thread]::CurrentThread.CurrentUICulture = [Globalization.CultureInfo]::InvariantCulture
[Net.ServicePointManager]::SecurityProtocol = [Net.SecurityProtocolType]::Tls12
$INV = [Globalization.CultureInfo]::InvariantCulture

$EA     = "ABTG_VwapRevert"
$Avvio  = Get-Date
$Stamp  = $Avvio.ToString("yyyyMMdd_HHmm", $INV)
# IL DESKTOP SI CERCA, NON SI ASSUME (classe 116-bis): con OneDrive il
# Desktop vero non e' %USERPROFILE%\Desktop. La riga di chat lo cerca
# con le STESSE tre righe.
function TrovaDesktop(){
  foreach($p in @([Environment]::GetFolderPath("Desktop"),
                  (Join-Path $env:USERPROFILE "Desktop"),
                  (Join-Path $env:USERPROFILE "OneDrive\Desktop"))){
    if($p -and (Test-Path -LiteralPath $p)){ return $p }
  }
  return $env:USERPROFILE
}
$Dsk    = TrovaDesktop
$Work   = Join-Path $env:USERPROFILE "abtg_passo0_vwaprev"
$Prove  = Join-Path $Work "prove"
$BackupDir  = Join-Path $Work "backup"
$Sentinella = Join-Path $Work "INCLUDE_IN_CORSO.txt"
$IncNostro  = "ABTG_PausaGuardian.mqh"
$RawPin = "https://raw.githubusercontent.com/claudiospadaro12/GITHUB/$Pin"
# un log di compilazione fallita di un giro PRECEDENTE non deve finire
# nello zip di oggi (classi 23/106)
Remove-Item -LiteralPath (Join-Path $Work "COMPILAZIONE_FALLITA.log") -Force -ErrorAction SilentlyContinue

# --- I VALORI DICHIARATI, contro cui i gate confrontano i file prova
#     (non i parametri: punto 96-bis).
$SimboloDichiarato  = "D30EUR"
$PeriodoDichiarato  = "M15"
$DaQuandoDichiarato = "2024.09.26"

# --- IL CANCELLO S0 (COSTO): i numeri FISSATI PRIMA della corsa.
#     Fonti: SPREAD_FLOTTA_MISURA_2026-09-03.md (spread orario reale dai
#     tick BCM, D30EUR: mediana 1,6-1,7 punti indice nelle ore 8-16
#     server, 2,6-2,7 nelle ore 17-20, 2,8-4,0 la notte; 1 punto indice
#     = 100 punti MT5 = 1,00 di prezzo) e R114 (GSPEC D30EUR:
#     CONTRACT_SIZE 10, CURRENCY_PROFIT EUR, conto EUR).
#     La regola completa sta in testa a prove\ABTG_VwapRevert.txt.
$S0_ContractSize    = 10.0    # EUR per punto indice per lotto = 10 (R114 GSPEC, calc mode CFD)
$S0_SpreadMinimo    = 1.7     # clausola severa: MAI sotto la mediana dell'ora peggiore della sessione 8-16
$S0_SpreadIgnoto    = 4.0     # trade senza ora leggibile: la mediana oraria PEGGIORE della giornata (ora 22)
$S0_SogliaPassa     = 3.5     # rapporto (punti/trade) / (spread mediano) >= 3,5 -> PASSA
$S0_SogliaBoccia    = 2.5     # < 2,5 -> NON PASSA; in mezzo il verdetto NON si da' (banda della misura del 03/09)
$S0_CsvSpread       = "spread_orario_" + $SimboloDichiarato + ".csv"
$S0_UrlSpread       = "/backtest_pipeline/risultati_archivio/spread_flotta/" + $S0_CsvSpread
$S0_Disponibile     = "NON DISPONIBILE (CSV dello spread non scaricato)"
$S0_Mappa           = @{}

# --- TUTTO CIO' CHE LA RACCOLTA USA NASCE QUI, PRIMA DEL try.
#     In PowerShell una `function` non e' dichiarativa, e' un'ISTRUZIONE:
#     se il flusso non ci passa sopra il nome non esiste, e la raccolta
#     esploderebbe proprio nella corsa fermata da un gate, cioe' l'unica
#     in cui il referto serve davvero.
$Problemi = New-Object System.Collections.ArrayList
$Rilievi  = New-Object System.Collections.ArrayList
$Fatale   = ""
$Include  = "NON INSTALLATO"
$Compilato = "NON TENTATA"
$TermScelto = "NON SCELTO"
$TermCrit   = "n/d"
$DataFolder = ""
$IncInstallato = $false
$IncBackup     = ""
$IncDest       = ""
$Ripristino    = "NON NECESSARIO"
$FotoPrima     = @{}
$FotoDopo      = @{}
$Fine          = $null
$Modo     = "CORSA"
if($SoloControllo){ $Modo = "CONTROLLO" }

function Foto([string]$percorso){
  if($percorso -eq "" -or $null -eq $percorso){ return "ASSENTE" }
  if(-not (Test-Path -LiteralPath $percorso)){ return "ASSENTE" }
  $i = Get-Item -LiteralPath $percorso
  return ("presente, " + $i.Length + " byte, " + $i.LastWriteTime.ToString("yyyy-MM-dd HH:mm:ss",$INV))
}
function HashFile([string]$percorso){
  if(-not (Test-Path -LiteralPath $percorso)){ return "" }
  try{ return (Get-FileHash -LiteralPath $percorso -Algorithm SHA256).Hash }catch{ return "" }
}
function RipristinaInclude([string]$dest,[string]$backup){
  try{
    if($dest -eq "" -or -not (Test-Path -LiteralPath $dest)){ return "niente da ripristinare (il file nostro non c'e' piu')" }
    if($backup -ne "" -and (Test-Path -LiteralPath $backup)){
      Copy-Item -LiteralPath $backup -Destination $dest -Force
      return ("RIPRISTINATO dal backup " + $backup)
    }
    Remove-Item -LiteralPath $dest -Force
    return "RIMOSSO (prima di questo giro non c'era)"
  }catch{ return ("RIPRISTINO FALLITO: " + $_.Exception.Message + " -- il file nostro e' ancora in " + $dest) }
}

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

# --- LA CONVENZIONE DI SENTINELLA, e vale per TUTTE le colonne.
#     Un numero non misurato non deve MAI uscire come numero plausibile:
#     in R103 il PF non misurato usciva "0.000", che si legge "ha perso
#     tutto". Qui esce "n/d".
function FmtN($v){ if($null -eq $v){ return "n/d" }; if([int]$v -lt 0){ return "n/d" }; return ([int]$v).ToString($INV) }
function Fmt2($v){ if($null -eq $v){ return "n/d" }; if([double]$v -lt 0){ return "n/d" }; return ([double]$v).ToString("0.00",$INV) }
function FmtE($v){ if($null -eq $v){ return "n/d" }; if([double]$v -le -999998.0){ return "n/d" }; return ([double]$v).ToString("+0;-0;0",$INV) }
function FmtPg($v){ if($null -eq $v){ return "n/d" }; if([double]$v -ge 99.0){ return "n/d" }; return ([double]$v).ToString("0.00",$INV) }
# --- LE COLONNE DI COLLAUDO hanno una sentinella DIVERSA: qui il -1 e'
#     un'INFORMAZIONE ("autotest non eseguito"), non un buco. Se lo
#     passassi a FmtN uscirebbe "n/d" e si confonderebbe col caso
#     "colonna assente", che e' un'altra cosa e va detta.
function FmtCol($v){ if($null -eq $v){ return "assente" }; if([int]$v -lt 0){ return "non-eseg" }; return ([int]$v).ToString($INV) }
function Fmt1S($v){ if($null -eq $v){ return "n/d" }; return ([double]$v).ToString("+0.00;-0.00;0.00",$INV) }

# =====================================================================
#  IL CANCELLO S0, letto dall'EXPORT PER-TRADE dell'EA (OnTester ->
#  ExportTrades: Common\Files\abtg_trades_ABTG_VwapRevert_<sim>_<magic>.csv,
#  ';' come separatore, SOLO i deal di USCITA, con close_time, volume e
#  net_profit). Tre limiti, DICHIARATI e tutti nel verso severo:
#   1. l'export NON porta il prezzo d'ingresso: i punti indice si
#      ricavano da net_profit / (volume x contract size), con contract
#      size 10 (R114 GSPEC D30EUR) -- net_profit e' NETTO di swap e
#      commissioni, quindi <= lordo (severo);
#   2. l'export porta l'ORA DI CHIUSURA, non quella d'ingresso: lo spread
#      dell'ora si legge sulla chiusura; un trade entrato di notte e
#      chiuso in sessione e' giudicato a 1,7 (dichiarato, NON severo: e'
#      il limite dell'EA, segnalato);
#   3. il file porta il MAGIC nel nome, non la finestra: la gamba OOS
#      (che gira per ultima) SOVRASCRIVE la IS. S0 si legge sull'OOS.
# =====================================================================
function LeggiMappaSpread([string]$percorso){
  $m = @{}
  if(-not (Test-Path -LiteralPath $percorso)){ return $m }
  foreach($r in @(Get-Content -LiteralPath $percorso)){
    $p = $r -split ','
    if($p.Count -lt 6){ continue }
    if($p[0] -notmatch '^\d{1,2}$'){ continue }
    $med = NumInv $p[5]
    if($null -ne $med){ $m[[int]$p[0]] = [double]$med }
  }
  return $m
}
function LeggiExport([string]$percorso){
  if(-not (Test-Path -LiteralPath $percorso)){ return $null }
  $out = New-Object System.Collections.ArrayList
  foreach($r in @(Get-Content -LiteralPath $percorso)){
    if($r -match '^\s*close_time'){ continue }
    $p = $r -split ';'
    if($p.Count -lt 8){ continue }
    $vol = NumInv $p[5]; $net = NumInv $p[7]
    if($null -eq $vol -or $null -eq $net -or [double]$vol -le 0){ continue }
    $ora = -1
    if(("" + $p[0]) -match '^\d{4}\.\d{2}\.\d{2} (\d{2}):'){ $ora = [int]$Matches[1] }
    [void]$out.Add([pscustomobject]@{ Ora=$ora; Punti=([double]$net / ([double]$vol * $S0_ContractSize)) })
  }
  return @($out)
}
function CalcolaS0($trades){
  $s0 = [pscustomobject]@{ N=0; Media=$null; Mediana=$null; SpreadMedio=$null; Rapporto=$null; Fuori=0; SenzaOra=0; Verdetto="NON MISURABILE" }
  if($null -eq $trades){ $s0.Verdetto = "NON MISURABILE (export per-trade assente)"; return $s0 }
  $n = @($trades).Count
  $s0.N = $n
  if($n -eq 0){ $s0.Verdetto = "NON MISURABILE (0 operazioni chiuse nell'export)"; return $s0 }
  $somma = 0.0; $sommaSp = 0.0
  $valori = New-Object System.Collections.ArrayList
  foreach($t in $trades){
    $somma += [double]$t.Punti
    [void]$valori.Add([double]$t.Punti)
    $sp = $S0_SpreadIgnoto
    if($t.Ora -ge 0 -and $S0_Mappa.ContainsKey([int]$t.Ora)){ $sp = [double]$S0_Mappa[[int]$t.Ora] } else { $s0.SenzaOra++ }
    if($sp -lt $S0_SpreadMinimo){ $sp = $S0_SpreadMinimo }
    $sommaSp += $sp
    if($t.Ora -lt 8 -or $t.Ora -gt 16){ $s0.Fuori++ }
  }
  $ord = @($valori | Sort-Object)
  $s0.Media = $somma / $n
  if($n % 2 -eq 1){ $s0.Mediana = $ord[[int][math]::Floor($n/2)] } else { $s0.Mediana = ($ord[$n/2 - 1] + $ord[$n/2]) / 2.0 }
  $s0.SpreadMedio = $sommaSp / $n
  if($s0.SpreadMedio -gt 0){ $s0.Rapporto = $s0.Media / $s0.SpreadMedio }
  if($null -eq $s0.Rapporto){ $s0.Verdetto = "NON MISURABILE (spread medio non leggibile)" }
  elseif($s0.Rapporto -ge $S0_SogliaPassa){ $s0.Verdetto = "PASSA (rapporto >= 3,5)" }
  elseif($s0.Rapporto -lt $S0_SogliaBoccia){ $s0.Verdetto = "NON PASSA (rapporto < 2,5)" }
  else{ $s0.Verdetto = "NON SI DA' (rapporto fra 2,5 e 3,5: banda della misura del 03/09)" }
  return $s0
}

# --- IL PARSER DEL CSV DI OTTIMIZZAZIONE.
#     Le colonne si cercano PER NOME, mai per posizione. Se non le
#     riconosce torna $null E DICE quali intestazioni ha visto, invece di
#     indovinare.
#     L'intestazione VERA di questo EA, LETTA NEL SORGENTE (OnTester,
#     'double stats[13]'), e' a QUATTORDICI colonne e CONTIENE
#     'Peggior Giornata %' piu' le tre di COLLAUDO ('Autotest Falliti',
#     'Flat Giorni', 'Flat Chiusure'). Non e' ereditata da un round
#     gemello.
#     Le tre di collaudo si leggono PER NOME come le altre, e sono
#     FACOLTATIVE nel parser: se mancano, il ciclo delle celle lo
#     dichiara come PROBLEMA ("autotest non eseguito"), invece di far
#     fallire la lettura di tutto il CSV.
$script:CsvIntestazioni = @()
function LeggiOpt([string]$path){
  if(-not (Test-Path -LiteralPath $path)){ return $null }
  $righe = @()
  try{ $righe = @(Import-Csv -LiteralPath $path) }catch{ return $null }
  if($righe.Count -eq 0){ return $null }
  $cols = @($righe[0].PSObject.Properties.Name)
  $script:CsvIntestazioni = $cols
  $kProf = $null; $kPf = $null; $kDd = $null; $kN = $null; $kPg = $null; $kMg = $null
  $kAt = $null; $kFg = $null; $kFc = $null
  foreach($k in $cols){
    $l = ("" + $k).Trim().ToLower()
    if($l -eq "profit" -or $l -eq "profitto"){ $kProf = $k }
    if($l -eq "profit factor" -or $l -eq "fattore di profitto"){ $kPf = $k }
    if($l -eq "equity dd %" -or $l -eq "drawdown equity %"){ $kDd = $k }
    if($l -eq "trades" -or $l -eq "operazioni"){ $kN = $k }
    if($l -eq "peggior giornata %" -or $l -eq "worst day %"){ $kPg = $k }
    if($l -eq "inpmagic"){ $kMg = $k }
    if($l -eq "autotest falliti"){ $kAt = $k }
    if($l -eq "flat giorni"){ $kFg = $k }
    if($l -eq "flat chiusure"){ $kFc = $k }
  }
  if($null -eq $kProf -or $null -eq $kPf -or $null -eq $kDd -or $null -eq $kN){ return $null }
  $out = New-Object System.Collections.ArrayList
  foreach($r in $righe){
    $pg = $null
    if($null -ne $kPg){ $pg = (NumInv $r.$kPg) }
    $mg = ""
    if($null -ne $kMg){ $mg = ("" + $r.$kMg).Trim() }
    $at = $null; $fg = $null; $fc = $null
    if($null -ne $kAt){ $at = (NumInv $r.$kAt) }
    if($null -ne $kFg){ $fg = (NumInv $r.$kFg) }
    if($null -ne $kFc){ $fc = (NumInv $r.$kFc) }
    [void]$out.Add([pscustomobject]@{
      Profit = (NumInv $r.$kProf); Pf = (NumInv $r.$kPf); Dd = (NumInv $r.$kDd)
      N = (NumInv $r.$kN); Pg = $pg; Magic = $mg
      Autotest = $at; FlatGiorni = $fg; FlatChiusure = $fc })
  }
  return @($out)
}

# --- I GEMELLI: le due righe devono essere IDENTICHE AL CENTESIMO.
#     E' il cancello S2 della BOZZA, ed e' il motivo per cui l'unico
#     asse spazzolato e' InpMagic.
#     "Una riga sola" NON e' "gemelli ok": e' uno sweep che non ha
#     spazzolato.
$TolGemelli = 0.005
function Gemelli($righe){
  if($null -eq $righe){ return "NON MISURATO (CSV non letto)" }
  if(@($righe).Count -ne 2){ return ("NON VALIDO: " + @($righe).Count + " righe invece di 2") }
  $a = $righe[0]; $b = $righe[1]
  foreach($ch in @(@("profitto",$a.Profit,$b.Profit),@("PF",$a.Pf,$b.Pf),@("DD",$a.Dd,$b.Dd),@("n",$a.N,$b.N))){
    if($null -eq $ch[1] -or $null -eq $ch[2]){ return ("NON MISURATO (" + $ch[0] + " illeggibile)") }
    if([math]::Abs([double]$ch[1] - [double]$ch[2]) -gt $TolGemelli){
      return ("DIVERSI su " + $ch[0] + ": " + $ch[1] + " contro " + $ch[2])
    }
  }
  return "IDENTICI"
}

# =====================================================================
#  LE QUATTRO CELLE. 'Diff' = gli input che DEVONO differire dal
#  00_nudo, e NESSUN ALTRO. Contare "due righe diverse" non basterebbe:
#  DUE righe SBAGLIATE darebbero lo stesso conteggio. 'VLong'/'VShort'/
#  'VFlat' dicono quanto devono VALERE quei tre interruttori IN QUEL
#  FILE: se due file fossero SCAMBIATI il diff resterebbe verde e
#  questo no.
# =====================================================================
function C([string]$id,[string]$file,[string]$desc,[int]$m1,[int]$m2,
          [string]$vLong,[string]$vShort,[string]$vFlat,$diff){
  return [pscustomobject]@{
    Id=$id; Prova=$file; Desc=$desc; M1=$m1; M2=$m2;
    VLong=$vLong; VShort=$vShort; VFlat=$vFlat; Diff=@($diff);
    Esito="NON ESEGUITA"; Gemelli="NON MISURATO";
    NIS=-1; NOOS=-1; PfIS=-1.0; PfOOS=-1.0; DdIS=-1.0; DdOOS=-1.0;
    ProfIS=-999999.0; ProfOOS=-999999.0; PgOOS=99.9;
    Autotest=$null; FlatGiorni=$null; FlatChiusure=$null;
    S0=$null; S0Gem=$null; S0Fonte="NON LETTO" }
}
$CELLE = @()
$CELLE += (C "00_nudo"      "ABTG_VwapRevert.txt"                "IL MOTORE, due lati insieme, INTRADAY -- porta i gemelli" 773400 773401 "1" "1" "1" @())
$CELLE += (C "01_long"      "PASSO0_VWAPREV_01_long.txt"         "SOLO LONG -- la frequenza del lato long"                  773410 773411 "1" "0" "1" @("InpAllowShort"))
$CELLE += (C "02_short"     "PASSO0_VWAPREV_02_short.txt"        "SOLO SHORT -- la frequenza del lato short"                773420 773421 "0" "1" "1" @("InpAllowLong"))
$CELLE += (C "03_overnight" "PASSO0_VWAPREV_03_overnight.txt"    "FLAT SPENTO -- quanto costa la regola intraday"           773430 773431 "1" "1" "0" @("InpFlatFineSeduta"))

# --- LA BASELINE ASSOLUTA. Il gate della stella confronta ogni cella
#     col 00_nudo: NON puo' accorgersi di niente che sia storto ALLO
#     STESSO MODO in tutti e quattro i file (lezione R110). Questi
#     valori sono dichiarati QUI, in assoluto, e prendono proprio quel
#     caso. Sono i default d'autore del porting piu' le due regole di
#     casa (cap giornaliero, flat di fine seduta).
$Baseline = @{
  "InpSigmaMult"             = "1.0"
  "InpTpR"                   = "2.0"
  "InpSlAtrFloor"            = "0.2"
  "InpLookback"              = "20"
  "InpAtrPeriod"             = "10"
  "InpAtrMult"               = "1.5"
  "InpOrderLifeBars"         = "3"
  "InpSlFloorMode"           = "0"
  "InpUsePartial"            = "0"
  "InpUseTrailAtr"           = "0"
  "InpMinSessionBars"        = "0"
  "InpSessionStartHour"      = "-1"
  "InpUseHourFilter"         = "0"
  "InpEngulfingOnly"         = "0"
  "InpFridayClose"           = "0"
  "InpRiskPercent"           = "1.0"
  "InpMaxTradesPerDay"       = "2"
  "InpFlatOra"               = "20"
  "InpFlatMinuto"            = "45"
  "InpStopNuoviMinPrimaFlat" = "0"
  # --- i DICIANNOVE che la v3 lasciava al default compilato (classi
  #     25/113, 03/09): default d'autore/di casa letti dal .mq5, e
  #     InpUsaGuardian pinnato a 0 come nel fratello AllineaLondra (nel
  #     tester e' fail-open comunque; 0 toglie una dipendenza NON
  #     MISURATA da GlobalVariable rimaste sul PC di backtest).
  "InpBodyPctMax"            = "0.30"
  "InpWickMult"              = "2.0"
  "InpDojiBodyPct"           = "0.20"
  "InpClosePct"              = "0.30"
  "InpPartialR"              = "1.0"
  "InpPartialPercent"        = "50.0"
  "InpBreakEven"             = "1"
  "InpTrailAtrMult"          = "2.0"
  "InpHourStart"             = "10"
  "InpHourEnd"               = "16"
  "InpFridayCloseHour"       = "20"
  "InpNewsMinImpact"         = "3"
  "InpNewsBeforeMin"         = "30"
  "InpNewsAfterMin"          = "30"
  "InpNewsShiftMinutes"      = "0"
  "InpMaxSpread"             = "0"
  "InpUsaGuardian"           = "0"
  "InpVerbose"               = "1"
  "InpAutoTest"              = "1"
}

# --- I MAGIC VIETATI: i magic delle sedie vive, dei round recenti e
#     del PASSO 0 gemello (FVG, blocco 776xxx). Un'identita' non in
#     campo resta comunque occupata.
$MagicVietati = @(775501, 776000, 776001, 776100, 776101, 776200, 776201, 776400, 776401,
                  763000,763010,763020,763100,763110,763120,
                  763200,763210,763220,763300,763310,763320,
                  773200,773201,773230,773231,773300,773301,
                  770101,770511,771531,970911,970912,970913)

$Ordinati = @($CELLE)
if($SoloCella -ne ""){
  $Ordinati = @($CELLE | Where-Object { $_.Id -eq $SoloCella })
}

try{
  Titolo "PASSO 0 -- VWAP REVERT (ABTG_VwapRevert) -- modo $Modo"

  # -------------------------------------------------------------------
  #  0. LE GUARDIE, PRIMA DI TOCCARE QUALUNQUE COSA
  # -------------------------------------------------------------------
  if($Pin -eq ""){ throw "-Pin obbligatorio: senza, girerebbe la punta del branch spacciandola per un commit congelato." }
  if($Pin -notmatch '^[0-9a-f]{40}$'){ throw ("-Pin deve essere un commit di 40 caratteri esadecimali, ricevuto: " + $Pin) }
  if($Pin -eq ("0"*40)){ throw "-Pin e' il SEGNAPOSTO di 40 zeri: la pagina non e' ancora stata pinnata col commit vero. Non parte niente." }
  if(Get-Process terminal64,metaeditor64 -ErrorAction SilentlyContinue){
    throw "MT5 O METAEDITOR APERTO: col terminale aperto il tester non gira (zero CSV), con MetaEditor aperto la compilazione torna subito senza compilare."
  }
  if($SoloCella -ne "" -and @($Ordinati).Count -eq 0){
    throw ("-SoloCella '" + $SoloCella + "' non esiste. Validi: 00_nudo, 01_long, 02_short, 03_overnight.")
  }
  if($Terminale -ne "" -and -not (Test-Path -LiteralPath (Join-Path $Terminale "terminal64.exe"))){
    throw ("-Terminale '" + $Terminale + "' non contiene terminal64.exe: va passata la cartella di INSTALLAZIONE del terminale.")
  }
  # I PARAMETRI MOSSI A MANO non fermano: si dichiarano accanto ai numeri
  # (punto 96-bis: il gate confronta i file coi valori DICHIARATI, non
  # col parametro che serve a cambiarli).
  if($Periodo -ne $PeriodoDichiarato){
    [void]$Rilievi.Add("PERIODO diverso da " + $PeriodoDichiarato + " (" + $Periodo + "): i file prova dichiarano @PERIODO " + $PeriodoDichiarato + ". Questo EA usa PERIOD_CURRENT: il TF del tester E' la strategia, la misura risponde a un'altra domanda.")
  }
  if($Simbolo -ne $SimboloDichiarato){
    [void]$Rilievi.Add("SIMBOLO diverso da " + $SimboloDichiarato + " (" + $Simbolo + "): i file prova dichiarano @SIMBOLO " + $SimboloDichiarato + ". Il cancello S0 e' tarato su D30EUR e su un altro simbolo NON viene adjudicato.")
  }
  if($DaQuando -ne $DaQuandoDichiarato -or $Fino -ne "2026.06.30"){
    [void]$Rilievi.Add("finestra " + $DaQuando + " -> " + $Fino + " invece di " + $DaQuandoDichiarato + " -> 2026.06.30 dichiarata: cambiata a mano, va scritto accanto ai numeri.")
  }

  # LA SENTINELLA DI UN GIRO PRECEDENTE INTERROTTO (classe 116, regola 1):
  # se un giro e' stato ucciso fra la copia dell'include e la raccolta,
  # nel terminale e' rimasto un include NOSTRO. Si rimedia PRIMA di ogni
  # altra cosa e lo si dichiara.
  if(Test-Path -LiteralPath $Sentinella){
    $righeS = @(Get-Content -LiteralPath $Sentinella -ErrorAction SilentlyContinue)
    $sDest = ""; $sBack = ""
    if(@($righeS).Count -ge 1){ $sDest = ("" + $righeS[0]).Trim() }
    if(@($righeS).Count -ge 2){ $sBack = ("" + $righeS[1]).Trim() }
    if($sBack -eq "NESSUNO"){ $sBack = "" }
    $esitoS = RipristinaInclude $sDest $sBack
    Remove-Item -LiteralPath $Sentinella -Force -ErrorAction SilentlyContinue
    [void]$Rilievi.Add("UN GIRO PRECEDENTE ERA STATO INTERROTTO fra l'installazione dell'include e la raccolta: " + $IncNostro + " in " + $sDest + " -> " + $esitoS + " (fatto adesso, all'avvio di questo giro).")
    Dico ("sentinella di un giro interrotto: include " + $esitoS) "Yellow"
  }

  Dico ("pin ......... " + $Pin)
  Dico ("celle ....... " + @($Ordinati).Count + " su 4")
  Dico ("finestra .... " + $DaQuando + " -> " + $Fino + " (split 40/60 del driver generico)")
  Dico ("banco ....... Modello 4 (TICK REALI), deposito " + $Deposito + ", rischio " + $Baseline["InpRiskPercent"] + "% (letto dal file prova, non da un parametro)")
  Dico ("cancello S0 . soglia severa 3 x " + $S0_SpreadMinimo.ToString("0.0",$INV) + " = " + (3*$S0_SpreadMinimo).ToString("0.0",$INV) + " punti indice/trade nelle ore 8-16, ora per ora fuori; contract size " + $S0_ContractSize.ToString("0",$INV) + " (R114); si legge sull'export OOS") "Yellow"

  # -------------------------------------------------------------------
  #  1. SCARICO AL PIN
  # -------------------------------------------------------------------
  Titolo "1. SCARICO AL PIN"
  # --- LA CACHE SI BUTTA QUANDO CAMBIA IL PIN (CHECKLIST punti 14 e 23).
  #     $Work sopravvive fra un lancio e l'altro: senza questo, i CSV e i
  #     file prova del pin VECCHIO resterebbero sul disco e il gate di
  #     idempotenza del driver generico ("il CSV c'e' gia', salto") li
  #     riproporrebbe come se fossero del pin nuovo. E' il referto stantio
  #     del 17/08 travestito da ripresa di corsa.
  $pinFile = Join-Path $Work "pin_corrente.txt"
  $pinVecchio = ""
  if(Test-Path -LiteralPath $pinFile){ $pinVecchio = (Get-Content -LiteralPath $pinFile -Raw).Trim() }
  if($pinVecchio -ne $Pin){
    Remove-Item -LiteralPath $Prove -Recurse -Force -ErrorAction SilentlyContinue
    Remove-Item -LiteralPath (Join-Path $Work "risultati_prove") -Recurse -Force -ErrorAction SilentlyContinue
    Dico ("pin cambiato (" + $pinVecchio + " -> " + $Pin + "): artefatti del pin vecchio CANCELLATI") "Yellow"
  }
  New-Item -ItemType Directory -Force -Path $Work,$Prove | Out-Null
  Set-Content -LiteralPath $pinFile -Value $Pin -Encoding ASCII

  $drv = Join-Path $Work "walkforward_generico.ps1"
  Scarica ($RawPin + "/backtest_pipeline/walkforward_generico.ps1") $drv
  # il driver generico pinna il branch da cui riscarica il .mq5: senza
  # questo, il pin varrebbe per il driver e NON per l'EA misurato.
  $t = Get-Content -LiteralPath $drv -Raw
  if($t -notmatch '\$EABranch\s*=\s*"lavoro"'){ throw "walkforward_generico.ps1 non ha la riga \$EABranch attesa: non lo posso pinnare." }
  $t = $t -replace '\$EABranch\s*=\s*"lavoro"', ('$EABranch="' + $Pin + '"')
  Set-Content -LiteralPath $drv -Value $t -Encoding ASCII
  Dico "driver generico scaricato e PINNATO (riscarica l'EA al pin, non dalla punta del branch)" "Green"

  foreach($c in $Ordinati){
    Scarica ($RawPin + "/backtest_pipeline/prove/" + $c.Prova) (Join-Path $Prove $c.Prova)
  }
  # il 00_nudo serve SEMPRE: e' il termine di paragone del gate della
  # stella, anche quando gira una cella sola. E si riscarica SEMPRE, non
  # "solo se non c'e'": una copia rimasta da un pin precedente farebbe
  # confrontare le celle di oggi con la baseline di ieri, e il gate
  # direbbe verde a un delta che nessuno ha dichiarato.
  $fNudo = Join-Path $Prove "ABTG_VwapRevert.txt"
  Scarica ($RawPin + "/backtest_pipeline/prove/ABTG_VwapRevert.txt") $fNudo
  Dico ("file prova scaricati: " + @(Get-ChildItem $Prove -Filter *.txt).Count) "Green"

  $incSrc = Join-Path $Work "ABTG_PausaGuardian.mqh"
  Scarica ($RawPin + "/mql5/Include/ABTG_PausaGuardian.mqh") $incSrc
  Dico ("include scaricato: ABTG_PausaGuardian.mqh (" + (Get-Item $incSrc).Length + " byte)") "Green"

  # IL CSV DELLO SPREAD ORARIO (misura del 03/09), al pin. Se manca, S0
  # NON si adjudica e lo si dice: non e' un motivo per fermare il conteggio.
  $spreadCsv = Join-Path $Work $S0_CsvSpread
  try{
    Scarica ($RawPin + $S0_UrlSpread) $spreadCsv
    $S0_Mappa = LeggiMappaSpread $spreadCsv
    if($S0_Mappa.Count -ge 20){ $S0_Disponibile = "DISPONIBILE (" + $S0_Mappa.Count + " ore lette da " + $S0_CsvSpread + " al pin)" }
    else{ $S0_Disponibile = "NON DISPONIBILE (" + $S0_CsvSpread + " scaricato ma con " + $S0_Mappa.Count + " ore leggibili)" }
  }catch{
    $S0_Disponibile = "NON DISPONIBILE (" + $S0_CsvSpread + " non scaricato al pin: " + $_.Exception.Message + ")"
  }
  if($Simbolo -ne $SimboloDichiarato){ $S0_Disponibile = "NON ADJUDICABILE su " + $Simbolo + " (spread e contract size fissati solo per " + $SimboloDichiarato + ")" }
  if($S0_Disponibile -notlike "DISPONIBILE*"){ [void]$Rilievi.Add("cancello S0: " + $S0_Disponibile) }
  Dico ("spread orario per S0: " + $S0_Disponibile) $(if($S0_Disponibile -like "DISPONIBILE*"){"Green"}else{"Yellow"})

  # -------------------------------------------------------------------
  #  2. I GATE SUI FILE PROVA -- girano PRIMA di aprire MT5
  # -------------------------------------------------------------------
  Titolo "2. GATE SUI FILE PROVA"
  $mappe = @{}
  $magicVisti = @{}
  foreach($f in @(Get-ChildItem $Prove -Filter *.txt)){
    $righe = RigheVive $f.FullName
    $h = @{}
    $nY = 0
    $nomeY = ""
    foreach($r in $righe){
      if($r -match '^@'){
        $parti = ($r -split '\s+',2)
        $h[$parti[0]] = $parti[1].Trim()
        continue
      }
      $i = $r.IndexOf("=")
      if($i -lt 0){ continue }
      $nome = $r.Substring(0,$i).Trim()
      $val  = $r.Substring($i+1).Trim()
      if($h.ContainsKey($nome)){ throw ($f.Name + ": DUE righe per '" + $nome + "'. In [TesterInputs] un parametro doppio fa fare a MT5 ZERO passate.") }
      $h[$nome] = $val
      if($val -match '\|\|Y\s*$'){ $nY++; $nomeY = $nome }
    }
    if($nY -ne 1){ throw ($f.Name + ": deve avere ESATTAMENTE un asse con flag Y, trovati " + $nY + ".") }
    if($nomeY -ne "InpMagic"){ throw ($f.Name + ": l'unico asse Y deve essere InpMagic, invece e' " + $nomeY + ". Questo e' un PASSO 0, non la griglia della BOZZA.") }
    $mappe[$f.Name] = $h
  }

  $hNudo = $mappe["ABTG_VwapRevert.txt"]
  if($null -eq $hNudo){ throw "manca la mappa del 00_nudo: senza, il gate della stella non e' eseguibile." }

  foreach($c in $Ordinati){
    $h = $mappe[$c.Prova]
    if($null -eq $h){ throw ("mappa mancante per " + $c.Prova) }

    # GATE GEOMETRIA: contro i valori DICHIARATI, non contro i parametri
    # (punto 96-bis: -Simbolo mosso a mano e' un rilievo, non un gate
    # che si sbarra da solo con un messaggio rovesciato).
    if($h["@SIMBOLO"]  -ne $SimboloDichiarato){  throw ($c.Prova + ": @SIMBOLO e' " + $h["@SIMBOLO"] + ", atteso " + $SimboloDichiarato) }
    if($h["@PERIODO"]  -ne $PeriodoDichiarato){  throw ($c.Prova + ": @PERIODO e' " + $h["@PERIODO"] + ", atteso " + $PeriodoDichiarato + " (trappola R102: questo EA usa PERIOD_CURRENT, il TF del tester E' la strategia)") }
    if($h["@DAQUANDO"] -ne $DaQuandoDichiarato){ throw ($c.Prova + ": @DAQUANDO e' " + $h["@DAQUANDO"] + ", atteso " + $DaQuandoDichiarato + " (misurato: sonda storico 17/08)") }
    if(-not $h.ContainsKey("InpMagic")){ throw ($c.Prova + ": manca la riga InpMagic, che e' l'UNICO asse spazzolato (i due gemelli).") }
    foreach($kInt in @("InpAllowLong","InpAllowShort","InpFlatFineSeduta")){
      if(-not $h.ContainsKey($kInt)){ throw ($c.Prova + ": manca la riga '" + $kInt + "', che e' un interruttore dichiarato e va verificabile nell'.ini.") }
    }

    # GATE DEI VALORI: quanto valgono i tre interruttori IN QUESTO FILE.
    # Prende il caso che il diff non puo' vedere: due file SCAMBIATI.
    $vl = ($h["InpAllowLong"]      -split '\|\|')[0]
    $vs = ($h["InpAllowShort"]     -split '\|\|')[0]
    $vf = ($h["InpFlatFineSeduta"] -split '\|\|')[0]
    if($vl -ne $c.VLong){  throw ($c.Prova + ": InpAllowLong vale "      + $vl + ", la cella " + $c.Id + " lo vuole " + $c.VLong) }
    if($vs -ne $c.VShort){ throw ($c.Prova + ": InpAllowShort vale "     + $vs + ", la cella " + $c.Id + " lo vuole " + $c.VShort) }
    if($vf -ne $c.VFlat){  throw ($c.Prova + ": InpFlatFineSeduta vale " + $vf + ", la cella " + $c.Id + " lo vuole " + $c.VFlat) }

    # GATE DELLA BASELINE ASSOLUTA. E' quello che prende la corruzione
    # SIMMETRICA: una riga storta UGUALE in tutti e quattro i file
    # passerebbe il gate della stella a mani basse.
    foreach($k in @($Baseline.Keys)){
      if(-not $h.ContainsKey($k)){ throw ($c.Prova + ": manca il pin di '" + $k + "'. Senza il pin in forma completa MT5 rispazzola il flag che ricorda dall'ultima griglia di questo EA.") }
      $v = ($h[$k] -split '\|\|')[0]
      if($v -ne $Baseline[$k] -and -not (@($c.Diff) -contains $k)){
        throw ($c.Prova + ": '" + $k + "' vale " + $v + ", la baseline dichiarata di questo PASSO 0 lo vuole " + $Baseline[$k] + ".")
      }
    }

    # GATE DELLA STELLA: contro il 00_nudo cambia SOLO cio' che e'
    # dichiarato in Diff, piu' InpMagic. Confronto PER NOME, mai per
    # posizione: un file con una riga in piu' sfaserebbe tutto il resto.
    $ammessi = @("InpMagic") + @($c.Diff)
    foreach($k in @($h.Keys)){
      if($k -match '^@'){ continue }
      if($ammessi -contains $k){ continue }
      if($hNudo[$k] -ne $h[$k]){ throw ($c.Prova + ": '" + $k + "' differisce dal 00_nudo e NON e' un delta dichiarato.") }
    }
    foreach($k in @($c.Diff)){
      if($hNudo[$k] -eq $h[$k]){ throw ($c.Prova + ": '" + $k + "' DOVEVA differire dal 00_nudo e non differisce.") }
    }

    # GATE DEI MAGIC: vergini, unici, mai uno vietato.
    $mg = $h["InpMagic"] -split '\|\|'
    foreach($v in @($mg[1],$mg[3])){
      $n = [int]$v
      if($MagicVietati -contains $n){ throw ($c.Prova + ": magic " + $n + " e' VIETATO (sedia viva, round recente o PASSO 0 gemello).") }
      if($magicVisti.ContainsKey($n)){ throw ("magic " + $n + " usato in due celle: " + $magicVisti[$n] + " e " + $c.Prova) }
      $magicVisti[$n] = $c.Prova
    }
    if([int]$mg[1] -ne $c.M1 -or [int]$mg[3] -ne $c.M2){
      throw ($c.Prova + ": i magic gemelli sono " + $mg[1] + "/" + $mg[3] + ", la cella " + $c.Id + " li vuole " + $c.M1 + "/" + $c.M2)
    }
  }
  Dico "geometria, valori dei tre interruttori, baseline assoluta, stella e magic: TUTTI PASSATI" "Green"

  # -------------------------------------------------------------------
  #  3. L'INCLUDE E LA COMPILAZIONE -- i due pezzi che il driver
  #     generico non fa (l'include) o fa troppo tardi (la compilazione).
  # -------------------------------------------------------------------
  Titolo "3. IL TERMINALE (per FATTI), L'INCLUDE (con sentinella) E LA COMPILAZIONE"
  # IL TERMINALE SI SCEGLIE PER UN FATTO, NON PER NOME (classe 115). La
  # v3 copiava il selettore per nome di walkforward_generico.ps1: qui si
  # scandisce LARGO (origin.txt, Program Files, portable) e si sceglie
  # STRETTO col fatto piu' forte, la cartella dati con bases\*BCM* (il
  # feed). Con ZERO o DUE candidati non si indovina: elenco + -Terminale.
  # Il terminale scelto viene PASSATO al driver generico: stesso
  # terminale per costruzione (punti 27/37).
  $termRoot = ""
  if($env:APPDATA){ $termRoot = Join-Path $env:APPDATA "MetaQuotes\Terminal" }
  $mappaInst = @{}
  if($termRoot -ne "" -and (Test-Path -LiteralPath $termRoot)){
    foreach($dCart in @(Get-ChildItem -LiteralPath $termRoot -Directory -ErrorAction SilentlyContinue)){
      if($dCart.Name -ieq "Common"){ continue }
      $oTxt = Join-Path $dCart.FullName "origin.txt"
      if(-not (Test-Path -LiteralPath $oTxt)){ continue }
      $instOrigin = (Get-Content -LiteralPath $oTxt -Raw -ErrorAction SilentlyContinue)
      if($null -eq $instOrigin){ continue }
      $instOrigin = $instOrigin.Trim().TrimEnd("\")
      if($instOrigin -ne "" -and -not $mappaInst.ContainsKey($instOrigin)){ $mappaInst[$instOrigin] = $dCart.FullName }
    }
  }
  foreach($radiceP in @("C:\Program Files","C:\Program Files (x86)")){
    if(-not (Test-Path -LiteralPath $radiceP)){ continue }
    foreach($tExe in @(Get-ChildItem -LiteralPath $radiceP -Recurse -Filter "terminal64.exe" -ErrorAction SilentlyContinue)){
      $kInst = $tExe.DirectoryName.TrimEnd("\")
      if(-not $mappaInst.ContainsKey($kInst)){
        $dfPort = ""
        if(Test-Path -LiteralPath (Join-Path $kInst "MQL5\Experts")){ $dfPort = $kInst }
        $mappaInst[$kInst] = $dfPort
      }
    }
  }
  $candidati = New-Object System.Collections.ArrayList
  foreach($kInst in @($mappaInst.Keys)){
    if(-not (Test-Path -LiteralPath (Join-Path $kInst "terminal64.exe"))){ continue }
    if(-not (Test-Path -LiteralPath (Join-Path $kInst "metaeditor64.exe"))){ continue }
    $dfCand = $mappaInst[$kInst]
    $fatto = ""
    if($dfCand -ne ""){
      $basi = @(Get-ChildItem -LiteralPath (Join-Path $dfCand "bases") -Directory -ErrorAction SilentlyContinue | Where-Object { $_.Name -like "*BCM*" })
      if($basi.Count -gt 0){ $fatto = "cartella dati con bases\" + $basi[0].Name + " (il feed)" }
    }
    if($fatto -eq "" -and $kInst -like "*BCM*"){ $fatto = "solo il percorso di installazione contiene BCM (fatto DEBOLE)" }
    [void]$candidati.Add([pscustomobject]@{ Inst=$kInst; Data=$dfCand; Fatto=$fatto })
  }
  Write-Host "  installazioni MT5 trovate (terminal64.exe + metaeditor64.exe):" -ForegroundColor Gray
  foreach($cCand in $candidati){
    $fTxt = $cCand.Fatto; if($fTxt -eq ""){ $fTxt = "nessun fatto BCM" }
    $dTxt = $cCand.Data;  if($dTxt -eq ""){ $dTxt = "cartella dati NON trovata" }
    Write-Host ("    " + $cCand.Inst + "   [" + $fTxt + "]   dati: " + $dTxt) -ForegroundColor Gray
  }
  $scelto = $null
  if($Terminale -ne ""){
    $tNorm = $Terminale.TrimEnd("\")
    $scelto = @($candidati | Where-Object { $_.Inst -ieq $tNorm }) | Select-Object -First 1
    if($null -eq $scelto){
      $dfMan = ""
      if($mappaInst.ContainsKey($tNorm)){ $dfMan = $mappaInst[$tNorm] }
      if($dfMan -eq "" -and (Test-Path -LiteralPath (Join-Path $tNorm "MQL5\Experts"))){ $dfMan = $tNorm }
      $scelto = [pscustomobject]@{ Inst=$tNorm; Data=$dfMan; Fatto="SCELTO A MANO con -Terminale" }
    }
    $TermCrit = "SCELTO A MANO con -Terminale (i gate sul terminale girano lo stesso)"
  }
  else{
    $conFeed  = @($candidati | Where-Object { $_.Fatto -like "cartella dati con bases*" })
    $conFatto = @($candidati | Where-Object { $_.Fatto -ne "" })
    $feedNoV3 = @($conFeed | Where-Object { $_.Inst -notlike "*-V3*" })
    if($feedNoV3.Count -eq 1){
      $scelto = $feedNoV3[0]; $TermCrit = "FATTO: " + $scelto.Fatto + "; scartate le installazioni -V3 (il 100k non e' il banco di backtest)"
    }
    elseif($feedNoV3.Count -gt 1){
      $elenco = (@($feedNoV3 | ForEach-Object { $_.Inst }) -join " | ")
      throw ("NON SO QUALE TERMINALE USARE (classe 115: l'ambiente non si indovina): " + $feedNoV3.Count + " installazioni con feed BCM e senza -V3: " + $elenco + ". Rilancia lo stesso blocco aggiungendo al driver: -Terminale ""<cartella di installazione>"".")
    }
    elseif($conFeed.Count -ge 1){
      $scelto = $conFeed[0]; $TermCrit = "FATTO: " + $scelto.Fatto + " -- ma e' un'installazione -V3 (l'unica col feed BCM): DICHIARATO"
      [void]$Rilievi.Add("l'unica installazione col feed BCM e' una -V3 (" + $scelto.Inst + "): il banco gira li'. Se non e' quello voluto, rilancia con -Terminale.")
    }
    elseif($conFatto.Count -eq 1){
      $scelto = $conFatto[0]; $TermCrit = "FATTO DEBOLE: " + $scelto.Fatto + " (nessuna cartella dati con bases\*BCM* trovata)"
      [void]$Rilievi.Add("il terminale e' stato scelto per il solo PERCORSO che contiene BCM (" + $scelto.Inst + "): nessuna cartella dati con bases\*BCM* trovata. Dichiarato, non indovinato.")
    }
    else{
      $elenco = "nessuna"
      if($candidati.Count -gt 0){ $elenco = (@($candidati | ForEach-Object { $_.Inst + " [" + $(if($_.Fatto -ne ""){$_.Fatto}else{"nessun fatto BCM"}) + "]" }) -join " | ") }
      throw ("NON SO QUALE TERMINALE USARE (classe 115: l'ambiente non si indovina dal nome). Installazioni viste: " + $elenco + ". Rilancia lo stesso blocco aggiungendo al driver: -Terminale ""<cartella che contiene terminal64.exe>"".")
    }
  }
  $instDir    = $scelto.Inst
  $TermExe    = Join-Path $instDir "terminal64.exe"
  $MetaEditor = Join-Path $instDir "metaeditor64.exe"
  $cartDati = $scelto.Data
  if($cartDati -eq "" -or $null -eq $cartDati){ throw ("cartella dati non trovata per " + $instDir + ": nessun origin.txt in " + $termRoot + " la nomina e non e' portable (manca MQL5\Experts dentro l'installazione). Il terminale va aperto almeno una volta.") }
  $TermScelto = $instDir
  $DataFolder = $cartDati
  Dico ("terminale scelto: " + $instDir) "Yellow"
  Dico ("criterio ........ " + $TermCrit) "Yellow"
  Dico ("cartella dati ... " + $cartDati) "Yellow"

  # LA FOTO PRIMA dei tre file del terminale che questo giro tocca
  # (classe 116, regola 2). Il .mq5 e l'.ex5 in Experts sono SCRITTI
  # apposta (e' il banco); l'include viene messo e poi RIMESSO COM'ERA.
  $incDir  = Join-Path $cartDati "MQL5\Include"
  $dstExp  = Join-Path $cartDati "MQL5\Experts"
  $IncDest = Join-Path $incDir $IncNostro
  $dstMq5  = Join-Path $dstExp ($EA + ".mq5")
  $ex5     = Join-Path $dstExp ($EA + ".ex5")
  $FotoPrima["include"] = Foto $IncDest
  $FotoPrima["mq5"]     = Foto $dstMq5
  $FotoPrima["ex5"]     = Foto $ex5
  Dico ("foto PRIMA -- Include\" + $IncNostro + ": " + $FotoPrima["include"])
  Dico ("foto PRIMA -- Experts\" + $EA + ".mq5: " + $FotoPrima["mq5"])
  Dico ("foto PRIMA -- Experts\" + $EA + ".ex5: " + $FotoPrima["ex5"])
  $residui = @(Get-ChildItem -LiteralPath $BackupDir -Filter ($IncNostro + ".prima_*") -ErrorAction SilentlyContinue)
  if($residui.Count -gt 0){
    [void]$Rilievi.Add("in " + $BackupDir + " ci sono " + $residui.Count + " backup " + $IncNostro + ".prima_* di giri precedenti (il primo: " + $residui[0].Name + "). Non li tocco: sono copie di cio' che il terminale aveva PRIMA, si cancellano a mano.")
  }

  # L'INCLUDE: sentinella PRIMA della scrittura, backup se c'era gia'
  # un file DIVERSO, niente da fare se c'e' gia' ed e' IDENTICO.
  New-Item -ItemType Directory -Force -Path $incDir,$BackupDir | Out-Null
  $hashPin = HashFile $incSrc
  $hashTerm = HashFile $IncDest
  if($hashTerm -ne "" -and $hashTerm -eq $hashPin -and -not (Get-Item -LiteralPath $IncDest).PSIsContainer){
    $Include = $IncNostro + " GIA' PRESENTE E IDENTICO al pin: non toccato (" + $IncDest + ")"
  }
  else{
    $IncBackup = ""
    if(Test-Path -LiteralPath $IncDest){
      $IncBackup = Join-Path $BackupDir ($IncNostro + ".prima_" + $Stamp)
      Copy-Item -LiteralPath $IncDest -Destination $IncBackup -Force
      if(-not (Test-Path -LiteralPath $IncBackup)){ throw ("backup dell'include NON riuscito in " + $IncBackup + ": non tocco il terminale.") }
    }
    $sBackTxt = $IncBackup; if($sBackTxt -eq ""){ $sBackTxt = "NESSUNO" }
    Set-Content -LiteralPath $Sentinella -Value @($IncDest, $sBackTxt, ("pin " + $Pin), ("avvio " + $Avvio.ToString("yyyy-MM-dd HH:mm:ss",$INV))) -Encoding ASCII
    # LA COPIA SI VERIFICA SUL CONTENUTO, NON SUL NOME (punto 27-ter).
    $lenInc = (Get-Item -LiteralPath $incSrc).Length
    Copy-Item -LiteralPath $incSrc -Destination $incDir -Force
    $IncInstallato = $true
    $vInc = Get-Item -LiteralPath $IncDest -ErrorAction Stop
    if($vInc.PSIsContainer -or $vInc.Length -ne $lenInc){ throw ($IncNostro + " copiato ma NON verificato in " + $incDir + " (lunghezza diversa o e' una cartella).") }
    $Include = $IncNostro + " INSTALLATO e VERIFICATO (" + $lenInc + " byte)"
    if($IncBackup -ne ""){ $Include += ", il file DIVERSO che c'era prima e' in " + $IncBackup } else { $Include += ", prima non c'era" }
    $Include += " -- viene RIMESSO COM'ERA a fine giro"
  }
  Dico $Include "Green"

  # --- LA COMPILAZIONE, IN ENTRAMBI I RAMI (controllo E corsa vera).
  #     QUESTO EA NON E' MAI STATO COMPILATO DA NESSUNO. L'.ex5 si
  #     CANCELLA prima (punto 23). IL CAMPO 'compilazione:' HA TRE STATI
  #     e si timbra sul ramo che DECIDE (classe 94-ter).
  $mq5 = Join-Path $Work ($EA + ".mq5")
  Scarica ($RawPin + "/mql5/Experts/" + $EA + ".mq5") $mq5
  New-Item -ItemType Directory -Force -Path $dstExp | Out-Null
  Copy-Item -LiteralPath $mq5 -Destination $dstMq5 -Force
  Remove-Item -LiteralPath $ex5 -Force -ErrorAction SilentlyContinue
  $logC = Join-Path $dstExp ($EA + ".log")
  Remove-Item -LiteralPath $logC -Force -ErrorAction SilentlyContinue
  $t0 = Get-Date
  $Compilato = "FALLITA (MetaEditor lanciato, nessun .ex5 entro 180 s)"
  & $MetaEditor ("/compile:" + $dstMq5) "/log" | Out-Null
  $battito = 0
  while((-not (Test-Path -LiteralPath $ex5)) -and ((New-TimeSpan -Start $t0 -End (Get-Date)).TotalSeconds -lt 180)){
    $sec = [int](New-TimeSpan -Start $t0 -End (Get-Date)).TotalSeconds
    if($sec -ge ($battito + 10)){ $battito = $sec; Dico ("   ... aspetto l'.ex5 da " + $sec + "s (tetto 180 s): NON interrompere, la riga si ferma da sola") }
    Start-Sleep -Seconds 2
  }
  if(-not (Test-Path -LiteralPath $ex5)){
    if(Test-Path -LiteralPath $logC){
      Copy-Item -LiteralPath $logC -Destination (Join-Path $Work "COMPILAZIONE_FALLITA.log") -Force
      Get-Content -LiteralPath $logC -Tail 40 | ForEach-Object { Write-Host $_ -ForegroundColor Red }
      $Compilato = "FALLITA (MetaEditor lanciato, nessun .ex5; il log e' in COMPILAZIONE_FALLITA.log dentro lo zip)"
    }
    else{
      $Compilato = "FALLITA -- METAEDITOR MUTO (nessun .ex5 e NESSUN log entro 180 s: editor aperto, percorso o permessi; NON e' un verdetto sul codice)"
    }
    throw ("COMPILAZIONE " + $Compilato + ". L'EA non era mai stato compilato: SE LA COMPILAZIONE FALLISCE, IL RISULTATO DEL PASSO 0 E' QUESTO.")
  }
  $Compilato = "OK (" + [int]((Get-Item -LiteralPath $ex5).Length/1024) + " KB, " + (Get-Item -LiteralPath $ex5).LastWriteTime.ToString("HH:mm:ss",$INV) + ")"
  Dico ("compilato " + $EA + ": " + $Compilato) "Green"

  # -------------------------------------------------------------------
  #  4. LE CORSE
  # -------------------------------------------------------------------
  Titolo "4. LE CORSE"
  $Risultati = Join-Path $Work ("risultati_prove\" + $EA)
  foreach($c in $Ordinati){
    Dico ("cella " + $c.Id + " -- " + $c.Desc) "Cyan"
    # NON si chiama $args: e' una VARIABILE AUTOMATICA di PowerShell, e
    # riusarla come nome proprio e' la classe di difetto che la checklist
    # di casa vieta.
    $argv = @("-ExecutionPolicy","Bypass","-File",$drv,
              "-Expert",$EA,
              "-Prova",(Join-Path $Prove $c.Prova),
              "-Etichetta",$c.Id,
              "-Simbolo",$Simbolo,
              "-Periodo",$Periodo,
              "-DaQuando",$DaQuando,
              "-Fino",$Fino,
              "-Modello","4",
              "-Deposito",("" + $Deposito),
              # LO STESSO TERMINALE PER COSTRUZIONE (classi 37/115)
              "-Terminal",$TermExe,
              "-MetaEditor",$MetaEditor,
              "-DataFolder",$cartDati)
    if($SoloControllo){ $argv += "-SoloControllo" }
    if($Rifai){ $argv += "-Rifai" }
    $tLancio = Get-Date
    $global:LASTEXITCODE = $null
    & powershell $argv
    # CODICE DI USCITA A TRE STATI (classe 108): 0 / N / NON LETTO. Quando
    # non c'e', decide l'ARTEFATTO: i CSV in corsa, l'anteprima .ini nel
    # controllo.
    $rcGrezzo = $LASTEXITCODE
    $rcLetto  = ($null -ne $rcGrezzo -and (("" + $rcGrezzo).Trim()) -match '^-?\d+$')
    $rcTxt    = "NON LETTO"
    if($rcLetto){ $rcTxt = ("" + [int]$rcGrezzo) }
    if($rcLetto -and [int]$rcGrezzo -ne 0){
      $c.Esito = "FERMATA (codice " + $rcTxt + ")"
      [void]$Problemi.Add("cella " + $c.Id + ": il driver generico e' uscito con codice " + $rcTxt + " (il suo messaggio rosso e' qui sopra in console)")
      continue
    }
    if(-not $rcLetto){
      [void]$Rilievi.Add("cella " + $c.Id + ": codice di uscita del driver generico NON LETTO (capita su PS 5.1). NON e' un fallimento: decide l'artefatto.")
    }
    if($SoloControllo){
      $anteprima = Join-Path $Work ("anteprima_" + $EA + "_" + $Simbolo + ".ini")
      if((Test-Path -LiteralPath $anteprima) -and ((Get-Item -LiteralPath $anteprima).LastWriteTime -ge $tLancio)){
        $c.Esito = "CONTROLLO OK (anteprima .ini fresca; codice " + $rcTxt + ")"
      }
      else{
        $c.Esito = "CONTROLLO SENZA ARTEFATTO (nessuna anteprima .ini fresca; codice " + $rcTxt + ")"
        [void]$Problemi.Add("cella " + $c.Id + ": il giro di controllo NON ha lasciato l'anteprima .ini fresca (" + $anteprima + "): il driver generico si e' fermato prima. Il suo messaggio e' in console.")
      }
      continue
    }

    $csvIS  = Join-Path $Risultati ($EA + "_" + $Simbolo + "_IS_"  + $c.Id + ".csv")
    $csvOOS = Join-Path $Risultati ($EA + "_" + $Simbolo + "_OOS_" + $c.Id + ".csv")
    $rIS  = LeggiOpt $csvIS
    $rOOS = LeggiOpt $csvOOS
    if($null -eq $rIS -or $null -eq $rOOS){
      $c.Esito = "CSV NON LEGGIBILE"
      [void]$Problemi.Add("cella " + $c.Id + ": CSV mancante o intestazioni non riconosciute. Viste: " + ($script:CsvIntestazioni -join " | "))
      continue
    }
    $c.Gemelli = Gemelli $rOOS
    $c.NIS   = $rIS[0].N;   $c.NOOS   = $rOOS[0].N
    $c.PfIS  = $rIS[0].Pf;  $c.PfOOS  = $rOOS[0].Pf
    $c.DdIS  = $rIS[0].Dd;  $c.DdOOS  = $rOOS[0].Dd
    $c.ProfIS= $rIS[0].Profit; $c.ProfOOS = $rOOS[0].Profit
    if($null -ne $rOOS[0].Pg){ $c.PgOOS = $rOOS[0].Pg }
    $c.Autotest     = $rOOS[0].Autotest
    $c.FlatGiorni   = $rOOS[0].FlatGiorni
    $c.FlatChiusure = $rOOS[0].FlatChiusure
    $c.Esito = "MISURATA"
    if($c.Gemelli -ne "IDENTICI"){
      [void]$Problemi.Add("cella " + $c.Id + ": gemelli " + $c.Gemelli + " -- il banco non e' deterministico, il numero non si legge (cancello S2).")
    }

    # --- I GATE DI COLLAUDO. Sono la ragione per cui l'autotest e il
    #     flat sono usciti in colonna: in ottimizzazione le Print degli
    #     agent non le legge nessuno (CHECKLIST punto 34), quindi
    #     "l'autotest e' verde" non era MAI stato verificato da niente.
    if($null -eq $c.Autotest -or $c.Autotest -lt 0){
      [void]$Problemi.Add("cella " + $c.Id + ": AUTOTEST NON ESEGUITO (colonna assente o -1): i numeri non hanno gate.")
    }
    elseif($c.Autotest -gt 0){
      [void]$Problemi.Add("cella " + $c.Id + ": AUTOTEST DIVERGE (" + $c.Autotest + " blocchi falliti): i numeri NON si leggono.")
    }
    # la gamba IS gira con lo stesso binario: se li' l'autotest diverge,
    # e' lo stesso codice a essere rotto, e va detto anche se l'OOS tace.
    if($null -ne $rIS[0].Autotest -and $rIS[0].Autotest -gt 0){
      [void]$Problemi.Add("cella " + $c.Id + ": AUTOTEST DIVERGE nella gamba IS (" + $rIS[0].Autotest + " blocchi falliti).")
    }
    if($c.VFlat -eq "1" -and $c.FlatGiorni -eq 0){
      [void]$Rilievi.Add("cella " + $c.Id + ": flat ACCESO ma scattato in ZERO giornate.")
    }
    if($c.VFlat -eq "0" -and $c.FlatGiorni -gt 0){
      [void]$Problemi.Add("cella " + $c.Id + ": flat SPENTO eppure scattato: l'interruttore non morde.")
    }
    # HA GIRATO IL TESTER, O I CSV ERANO GIA' LI'? (punti 50/92): il
    # generico salta le finestre gia' fatte, e allora i numeri sono
    # RILETTI, non misurati -- e l'export per-trade e' quello di ieri.
    $freschi = $true
    foreach($fCsv in @($csvIS,$csvOOS)){ if((Get-Item -LiteralPath $fCsv).LastWriteTime -lt $tLancio){ $freschi = $false } }
    if(-not $freschi){ $c.Esito = "RILETTA DA CSV GIA' PRESENTI (il tester NON ha girato in questo giro: serve -Rifai)" }

    # --- IL CANCELLO S0, dall'export per-trade (gamba OOS: e' l'ultima
    #     scritta, il file porta il magic e non la finestra).
    $cartComune = ""
    if($env:APPDATA){ $cartComune = Join-Path $env:APPDATA "MetaQuotes\Terminal\Common\Files" }
    $expM1 = ""; $expM2 = ""
    if($cartComune -ne ""){
      $expM1 = Join-Path $cartComune ("abtg_trades_" + $EA + "_" + $Simbolo + "_" + $c.M1 + ".csv")
      $expM2 = Join-Path $cartComune ("abtg_trades_" + $EA + "_" + $Simbolo + "_" + $c.M2 + ".csv")
    }
    if($S0_Disponibile -notlike "DISPONIBILE*"){
      $c.S0Fonte = $S0_Disponibile
    }
    elseif($expM1 -eq "" -or -not (Test-Path -LiteralPath $expM1)){
      $c.S0Fonte = "export per-trade NON TROVATO: " + $(if($expM1 -ne ""){$expM1}else{"Common\Files non individuabile (APPDATA vuoto)"})
      [void]$Problemi.Add("cella " + $c.Id + ": S0 NON MISURABILE, export per-trade assente (" + $c.S0Fonte + "). L'EA lo scrive in OnTester con FILE_COMMON: se manca, o l'OnTester non e' girato o Common\Files e' altrove.")
    }
    else{
      $expFresco = ((Get-Item -LiteralPath $expM1).LastWriteTime -ge $tLancio)
      $c.S0 = CalcolaS0 (LeggiExport $expM1)
      $c.S0Fonte = (Split-Path $expM1 -Leaf) + " (gamba OOS, " + $(if($expFresco){"FRESCO"}else{"STANTIO: scritto prima di questo giro"}) + ")"
      if(Test-Path -LiteralPath $expM2){ $c.S0Gem = CalcolaS0 (LeggiExport $expM2) }
      if(-not $expFresco){ [void]$Rilievi.Add("cella " + $c.Id + ": l'export per-trade e' STANTIO (scritto prima di questo giro): S0 letto su una corsa precedente allo stesso pin.") }
      if($null -ne $c.S0Gem -and $null -ne $c.S0.Media -and $null -ne $c.S0Gem.Media -and ([math]::Abs($c.S0.Media - $c.S0Gem.Media) -gt 0.005 -or $c.S0.N -ne $c.S0Gem.N)){
        [void]$Problemi.Add("cella " + $c.Id + ": i due export gemelli (" + $c.M1 + "/" + $c.M2 + ") NON coincidono su S0 (n " + $c.S0.N + "/" + $c.S0Gem.N + ", media " + (Fmt1S $c.S0.Media) + "/" + (Fmt1S $c.S0Gem.Media) + "): il banco non e' deterministico anche per-trade.")
      }
      foreach($fExp in @($expM1,$expM2)){ if(Test-Path -LiteralPath $fExp){ Copy-Item -LiteralPath $fExp -Destination (Join-Path $Work ("EXPORT_" + $c.Id + "_" + (Split-Path $fExp -Leaf))) -Force } }
    }
  }
}
catch{
  $Fatale = ("" + $_.Exception.Message)
  Write-Host ""
  Write-Host ("!!! FERMATO: " + $Fatale) -ForegroundColor Red
}

# =====================================================================
#  RACCOLTA -- SEMPRE, anche quando la corsa si e' fermata a meta'.
#  Regola di casa: i risultati finiscono sul Desktop e in uno zip.
# =====================================================================
Titolo "RACCOLTA"
# IL RIPRISTINO DELL'INCLUDE, SEMPRE (classe 116): vive QUI, fuori dal
# ramo felice, cosi' gira anche nel giro fermato. Il Ctrl+C lo copre la
# sentinella, al giro dopo.
if($IncInstallato){
  $Ripristino = RipristinaInclude $IncDest $IncBackup
  if($Ripristino -like "RIPRISTINATO*" -or $Ripristino -like "RIMOSSO*"){ Remove-Item -LiteralPath $Sentinella -Force -ErrorAction SilentlyContinue }
  else{ [void]$Problemi.Add("include NON rimesso a posto nel terminale: " + $Ripristino + ". La sentinella " + $Sentinella + " resta: il prossimo giro riprova all'avvio.") }
  Dico ("include nel terminale: " + $Ripristino) "Yellow"
}
if($IncDest -ne ""){
  $FotoDopo["include"] = Foto $IncDest
  $FotoDopo["mq5"]     = Foto (Join-Path $DataFolder ("MQL5\Experts\" + $EA + ".mq5"))
  $FotoDopo["ex5"]     = Foto (Join-Path $DataFolder ("MQL5\Experts\" + $EA + ".ex5"))
}
$Fine = Get-Date
$Cart = Join-Path $Dsk ("PASSO0_VWAPREV_" + $Modo + "_" + $Stamp)
New-Item -ItemType Directory -Force -Path $Cart | Out-Null

$RefTxt = New-Object System.Collections.ArrayList
[void]$RefTxt.Add("=====================================================================")
[void]$RefTxt.Add(" PASSO 0 -- VWAP REVERT (ABTG_VwapRevert) su " + $Simbolo + " " + $Periodo)
[void]$RefTxt.Add("=====================================================================")
[void]$RefTxt.Add("modo: " + $Modo + "   <- CONTROLLO = giro a vuoto, NON e' il risultato")
[void]$RefTxt.Add("data: " + $Avvio.ToString("yyyy-MM-dd HH:mm:ss",$INV) + "   <- e' l'ORA DI AVVIO del giro, NON l'ora attuale (classe 110)")
[void]$RefTxt.Add("fine: " + $Fine.ToString("yyyy-MM-dd HH:mm:ss",$INV) + "   <- ora della raccolta: 'adesso' si confronta con QUESTA")
[void]$RefTxt.Add("pin:  " + $Pin)
[void]$RefTxt.Add("finestra: " + $DaQuando + " -> " + $Fino + "  (split 40/60)")
[void]$RefTxt.Add("banco: Modello 4 TICK REALI, deposito " + $Deposito + ", rischio " + $Baseline["InpRiskPercent"] + "% (letto dal file prova, non da un parametro)")
[void]$RefTxt.Add("terminale: " + $TermScelto)
[void]$RefTxt.Add("criterio di scelta: " + $TermCrit + "   <- scelto per un FATTO e PASSATO al driver generico (classe 115)")
[void]$RefTxt.Add("cartella dati: " + $(if($DataFolder -ne ""){$DataFolder}else{"n/d"}))
[void]$RefTxt.Add("include: " + $Include)
[void]$RefTxt.Add("include a fine giro: " + $Ripristino)
[void]$RefTxt.Add("compilazione: " + $Compilato + "   <- tre stati: NON TENTATA / FALLITA / OK (classe 94-ter)")
[void]$RefTxt.Add("spread orario per S0: " + $S0_Disponibile)
[void]$RefTxt.Add("")
[void]$RefTxt.Add("FOTO DEL TERMINALE, PRIMA e DOPO (classe 116: la prova sta nella foto):")
foreach($kF in @("include","mq5","ex5")){
  $etF = @{ "include"=("Include\" + $IncNostro); "mq5"=("Experts\" + $EA + ".mq5"); "ex5"=("Experts\" + $EA + ".ex5") }[$kF]
  $pF = "NON FOTOGRAFATO (il giro si e' fermato prima di scegliere il terminale)"; if($FotoPrima.ContainsKey($kF)){ $pF = $FotoPrima[$kF] }
  $dF = "NON FOTOGRAFATO"; if($FotoDopo.ContainsKey($kF)){ $dF = $FotoDopo[$kF] }
  $notaF = ""
  if($kF -eq "include" -and $FotoPrima.ContainsKey($kF) -and $FotoDopo.ContainsKey($kF)){
    if($pF -eq $dF){ $notaF = "   -> INVARIATO (com'era prima)" } else { $notaF = "   -> DIVERSO: vedi 'include a fine giro' e i PROBLEMI" }
  }
  if($kF -ne "include" -and $FotoDopo.ContainsKey($kF)){ $notaF = "   -> scritto apposta da questo giro (e' il banco: lo scrive anche il driver generico)" }
  [void]$RefTxt.Add("  " + $etF)
  [void]$RefTxt.Add("     prima: " + $pF)
  [void]$RefTxt.Add("     dopo:  " + $dF + $notaF)
}
[void]$RefTxt.Add("")
[void]$RefTxt.Add("QUESTO NON E' UN ROUND E NON DA' NESSUN VERDETTO.")
[void]$RefTxt.Add("E' un CONTA-OPERAZIONI: misura la FREQUENZA del motore VWAP REVERT")
[void]$RefTxt.Add("e il COSTO della regola intraday. Il PF qui sotto si LEGGE ma NON si")
[void]$RefTxt.Add("giudica: i criteri di merito della BOZZA sono [DA FIRMARE], e quattro")
[void]$RefTxt.Add("celle non sono un round.")
[void]$RefTxt.Add("")
[void]$RefTxt.Add("LA DOMANDA DEL PASSO 0 (dossier P1): quante operazioni per lato?")
[void]$RefTxt.Add("  A. n per lato >= 150 IS -> campione c'e', il round si puo' disegnare")
[void]$RefTxt.Add("  B. n per lato <  150 IS -> MERITO SOSPESO (valvola R59 / regola B),")
[void]$RefTxt.Add("                             il RISCHIO si giudica lo stesso")
[void]$RefTxt.Add("  C. n enorme             -> alzare InpSigmaMult (banda piu' selettiva),")
[void]$RefTxt.Add("                             NON il rischio e NON un filtro nuovo")
[void]$RefTxt.Add("")
[void]$RefTxt.Add("--- LA TABELLA ---")
[void]$RefTxt.Add("cella         n IS   n OOS   PF IS   PF OOS  DD OOS%  Prof OOS  PeggGio%  gemelli")
foreach($c in $CELLE){
  $riga = ("{0,-12} {1,6} {2,7} {3,7} {4,8} {5,8} {6,9} {7,9}  {8}" -f `
           $c.Id, (FmtN $c.NIS), (FmtN $c.NOOS), (Fmt2 $c.PfIS), (Fmt2 $c.PfOOS),
           (Fmt2 $c.DdOOS), (FmtE $c.ProfOOS), (FmtPg $c.PgOOS), $c.Gemelli)
  [void]$RefTxt.Add($riga)
  # LE TRE COLONNE DI COLLAUDO, lette dal CSV (gamba OOS). Non sono
  # metriche di merito: dicono se le altre si possono leggere.
  [void]$RefTxt.Add(("              collaudo: autotest falliti = {0} (atteso 0) | flat giorni = {1} | flat chiusure = {2}   [flat dichiarato: {3}]" -f `
                     (FmtCol $c.Autotest), (FmtCol $c.FlatGiorni), (FmtCol $c.FlatChiusure), $c.VFlat))
  [void]$RefTxt.Add("              esito: " + $c.Esito + "  |  " + $c.Desc)
  # IL CANCELLO S0 PER CELLA (criteri in testa a prove\ABTG_VwapRevert.txt)
  if($null -ne $c.S0){
    [void]$RefTxt.Add(("              S0 (costo): {0}  |  n = {1}, media = {2} punti indice/trade, mediana = {3}, spread mediano orario medio = {4}, rapporto = {5}  |  chiusi fuori 8-16: {6}, senza ora: {7}" -f `
                       $c.S0.Verdetto, $c.S0.N, (Fmt1S $c.S0.Media), (Fmt1S $c.S0.Mediana), (Fmt1S $c.S0.SpreadMedio), $(if($null -ne $c.S0.Rapporto){([double]$c.S0.Rapporto).ToString("0.00",$INV)}else{"n/d"}), $c.S0.Fuori, $c.S0.SenzaOra))
    [void]$RefTxt.Add("              S0 fonte: " + $c.S0Fonte)
  }
  else{
    [void]$RefTxt.Add("              S0 (costo): NON MISURATO in questo giro  |  " + $c.S0Fonte)
  }
}
[void]$RefTxt.Add("")
[void]$RefTxt.Add("--- COME SI LEGGE, e sono quattro avvertenze, non quattro note ---")
[void]$RefTxt.Add("1. n(01_long) + n(02_short) NON FA n(00_nudo), e NON e' un guasto.")
[void]$RefTxt.Add("   MISURATO NEL SORGENTE (OnNewBar): il giro esce con")
[void]$RefTxt.Add("   'if(CountPositions()>0) return' PRIMA di guardare il lato, e dopo")
[void]$RefTxt.Add("   un PiazzaOrdine long fa 'return' senza valutare lo short (una sola")
[void]$RefTxt.Add("   decisione per barra). Con un lato spento lo slot resta libero.")
[void]$RefTxt.Add("2. LA FINESTRA E' UN SOLO REGIME RIALZISTA (21 mesi di feed BCM sugli")
[void]$RefTxt.Add("   indici). Il lato SHORT parte svantaggiato PER REGIME, non per")
[void]$RefTxt.Add("   merito del motore. Un 'niente edge short' letto qui chiude la")
[void]$RefTxt.Add("   domanda per QUESTA EPOCA, non in assoluto.")
[void]$RefTxt.Add("3. LA CELLA 03_overnight NON PUO' VINCERE. Anche se facesse meglio del")
[void]$RefTxt.Add("   00_nudo NON diventa la cella da mandare in campo: tenere posizioni")
[void]$RefTxt.Add("   overnight e' incompatibile con FTMO Standard (leva 1:100) sul conto")
[void]$RefTxt.Add("   finanziato, che e' il posto per cui questo candidato esiste. Serve a")
[void]$RefTxt.Add("   sapere QUANTO stiamo pagando per restare a 1:100. Se il divario")
[void]$RefTxt.Add("   fosse enorme, la conseguenza e' 'questo non e' un motore intraday',")
[void]$RefTxt.Add("   non 'accendiamo l'overnight'.")
[void]$RefTxt.Add("   E IL COSTO NON E' UN COSTO PURO: il costo si legge come delta di Prof")
[void]$RefTxt.Add("   OOS e di n fra 00_nudo e 03_overnight. Non e' un costo puro: col flat")
[void]$RefTxt.Add("   spento la posizione notturna tiene occupato lo slot")
[void]$RefTxt.Add("   (if(CountPositions()>0) return) e blocca gli ingressi del giorno dopo")
[void]$RefTxt.Add("   -- un n piu' basso qui e' anche meccanica dello slot, non solo")
[void]$RefTxt.Add("   mercato. Il P&L delle sole posizioni che attraversano la notte questo")
[void]$RefTxt.Add("   giro non lo misura.")
[void]$RefTxt.Add("4. IL CANCELLO S0 (il costo) E' ADJUDICABILE DAL 03/09/2026, coi numeri")
[void]$RefTxt.Add("   FISSATI PRIMA di questa corsa (testa di prove\ABTG_VwapRevert.txt):")
[void]$RefTxt.Add("   spread REALE dai tick BCM (SPREAD_FLOTTA_MISURA_2026-09-03.md): D30EUR")
[void]$RefTxt.Add("   mediana 1,6-1,7 punti indice nelle ore 8-16 server, 2,6-2,7 alle 17-20,")
[void]$RefTxt.Add("   2,8-4,0 la notte; 1 punto indice = 100 punti MT5 = 1,00 di prezzo.")
[void]$RefTxt.Add("   Regola (C2 di casa): media dei punti indice per operazione >= 3x lo")
[void]$RefTxt.Add("   spread MEDIANO dell'ORA in cui il trade lavora. CLAUSOLA SEVERA: lo")
[void]$RefTxt.Add("   spread di riferimento non scende MAI sotto 1,7 (l'ora peggiore della")
[void]$RefTxt.Add("   sessione) -> soglia minima 5,1 punti/trade; fuori dalle 8-16 vale la")
[void]$RefTxt.Add("   mediana dell'ora di chiusura (fino a 12,0 di notte). Verdetto sul")
[void]$RefTxt.Add("   RAPPORTO media punti / media spread: >= 3,5 PASSA, < 2,5 NON PASSA,")
[void]$RefTxt.Add("   in mezzo NON SI DA' (banda della misura del 03/09).")
[void]$RefTxt.Add("   COME SI LEGGE IL NUMERO, e tre limiti dichiarati:")
[void]$RefTxt.Add("   - punti = net_profit / (volume x 10): contract size 10 e profitto in")
[void]$RefTxt.Add("     EUR (R114 GSPEC D30EUR). L'export NON porta il prezzo d'ingresso, e")
[void]$RefTxt.Add("     net_profit e' al netto di swap e commissioni: <= lordo, verso severo;")
[void]$RefTxt.Add("   - l'ORA e' quella di CHIUSURA (l'export non ha quella d'ingresso): un")
[void]$RefTxt.Add("     trade entrato di notte e chiuso in sessione e' giudicato a 1,7. E' il")
[void]$RefTxt.Add("     limite dell'EA (segnalato), NON e' severo;")
[void]$RefTxt.Add("   - l'export porta il MAGIC nel nome, non la finestra: la gamba OOS")
[void]$RefTxt.Add("     SOVRASCRIVE la IS. S0 e' letto sull'OOS e basta.")
[void]$RefTxt.Add("   Sulla 03_overnight net_profit contiene anche gli swap notturni: e' il")
[void]$RefTxt.Add("   costo VERO di quella cella, non un artefatto.")
[void]$RefTxt.Add("   Un S0 NON PASSA sulla 00_nudo chiude il capitolo VWAP anche come motore")
[void]$RefTxt.Add("   (falsificazione gia' dichiarata nella BOZZA): non si cerca un'altra")
[void]$RefTxt.Add("   taratura per farlo passare.")
[void]$RefTxt.Add("")
[void]$RefTxt.Add("--- LE TRE COLONNE DI COLLAUDO, e non si guardano nella scheda Esperti ---")
[void]$RefTxt.Add("In OTTIMIZZAZIONE le Print girano sugli agent e NON LE LEGGE NESSUNO.")
[void]$RefTxt.Add("Percio' l'autotest e il flat escono in COLONNA nel CSV, e questo referto")
[void]$RefTxt.Add("le stampa sotto ogni cella:")
[void]$RefTxt.Add("  'autotest falliti' = 0  -> la riga 'esito motore:' dell'EA dice DIECI")
[void]$RefTxt.Add("                            BLOCCHI SU DIECI: i numeri si leggono.")
[void]$RefTxt.Add("  'autotest falliti' > 0  -> DIVERGE: i numeri di questa tabella NON si")
[void]$RefTxt.Add("                            leggono, c'e' da guardare il codice.")
[void]$RefTxt.Add("  'autotest falliti' non-eseg / assente -> nessun gate: il numero e'")
[void]$RefTxt.Add("                            senza collaudo, e va detto.")
[void]$RefTxt.Add("  'flat giorni' = giornate in cui il flat e' scattato. Col flat ACCESO")
[void]$RefTxt.Add("                  uno zero e' un rilievo; col flat SPENTO un valore >0 e'")
[void]$RefTxt.Add("                  un problema: l'interruttore non morde.")
[void]$RefTxt.Add("  'flat chiusure' = posizioni davvero chiuse dal flat, in totale.")
[void]$RefTxt.Add("")
if($Fatale -ne ""){
  [void]$RefTxt.Add("!!! FERMATO: " + $Fatale)
  [void]$RefTxt.Add("")
}
[void]$RefTxt.Add("PROBLEMI: " + $Problemi.Count)
foreach($p in $Problemi){ [void]$RefTxt.Add("  - " + $p) }
[void]$RefTxt.Add("RILIEVI: " + $Rilievi.Count)
foreach($p in $Rilievi){ [void]$RefTxt.Add("  - " + $p) }
[void]$RefTxt.Add("")
[void]$RefTxt.Add('COME SI RIPRENDE: si riparte dalla pagina righe/RIGA_PASSO0_VWAPREV_DA_MANDARE.md,')
[void]$RefTxt.Add('NON da questa riga: $p e $pin nascono dentro il blocco e non sopravvivono.')

$refPath = Join-Path $Cart "REFERTO_PASSO0_VWAPREV.txt"
Set-Content -LiteralPath $refPath -Value ($RefTxt -join "`r`n") -Encoding ASCII
Write-Host ($RefTxt -join "`r`n")

# --- gli artefatti: solo cio' che ha girato, copiato PER NOME.
foreach($c in $Ordinati){
  $src = Join-Path $Prove $c.Prova
  if(Test-Path -LiteralPath $src){ Copy-Item $src -Destination $Cart -Force }
  foreach($tag in @("IS","OOS")){
    $f = Join-Path $Work ("risultati_prove\" + $EA + "\" + $EA + "_" + $Simbolo + "_" + $tag + "_" + $c.Id + ".csv")
    if(Test-Path -LiteralPath $f){ Copy-Item $f -Destination $Cart -Force }
  }
  foreach($fExp in @(Get-ChildItem -LiteralPath $Work -Filter ("EXPORT_" + $c.Id + "_*.csv") -ErrorAction SilentlyContinue)){ Copy-Item -LiteralPath $fExp.FullName -Destination $Cart -Force }
}
foreach($nomeF in @("COMPILAZIONE_FALLITA.log", $S0_CsvSpread)){
  $srcF = Join-Path $Work $nomeF
  if(Test-Path -LiteralPath $srcF){ Copy-Item -LiteralPath $srcF -Destination $Cart -Force }
}
$zip = $Cart + ".zip"
Remove-Item -LiteralPath $zip -Force -ErrorAction SilentlyContinue
Compress-Archive -Path (Join-Path $Cart "*") -DestinationPath $zip -Force
Write-Host ""
Write-Host ("CARTELLA: " + $Cart) -ForegroundColor Green
Write-Host ("ZIP DA MANDARE: " + $zip) -ForegroundColor Green
Write-Host "FILE ATTESI NELLO ZIP: REFERTO_PASSO0_VWAPREV.txt + i file prova girati + i CSV IS/OOS + gli EXPORT_<cella>_abtg_trades_*.csv (S0) + spread_orario_D30EUR.csv; COMPILAZIONE_FALLITA.log solo se la compilazione e' fallita" -ForegroundColor Gray

if($Fatale -ne ""){ Write-Host "ESITO: FERMATO" -ForegroundColor Red; exit 1 }
if($Problemi.Count -gt 0){ Write-Host "ESITO: COMPLETATO CON PROBLEMI" -ForegroundColor Yellow; exit 1 }
Write-Host ("ESITO: " + $Modo + " COMPLETATO") -ForegroundColor Green
exit 0
