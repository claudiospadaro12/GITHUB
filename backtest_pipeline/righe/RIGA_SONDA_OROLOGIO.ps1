# =====================================================================
#  MARCATORE_RIGA_SONDA_OROLOGIO_v3
#  RIGA_SONDA_OROLOGIO.ps1  --  LA SONDA DELL'OROLOGIO
#  ABTG_SondaOrologio su EURUSD / GBPUSD / XAUUSD, H1, TICK REALI,
#  finestra 2011.01.01 -> 2026.06.30, sette celle:
#     00_gemelli        EURUSD long, ora e durata INCHIODATE, magic
#                       gemelli 777290/777291 -> DETERMINISMO + CRONOMETRO
#     01_eurusd_long    EURUSD  LONG    magic 777201
#     02_eurusd_short   EURUSD  SHORT   magic 777202
#     03_gbpusd_long    GBPUSD  LONG    magic 777203
#     04_gbpusd_short   GBPUSD  SHORT   magic 777204
#     05_xauusd_long    XAUUSD  LONG    magic 777205
#     06_xauusd_short   XAUUSD  SHORT   magic 777206
# ---------------------------------------------------------------------
#  QUESTO NON E' UN ROUND E NON DA' NESSUN VERDETTO.
#  E' il PASSO 0 -- di MISURA -- del candidato P1 della caccia intraday
#  forex/oro del 28/08/2026. Produce una TABELLA, non un P/L.
#  Criterio C7, congelato prima di vedere i numeri:
#     "Nessuna promozione da questa corsa. Questa sonda non promuove
#      niente e non tocca nessuna sedia viva: produce una tabella."
#
#  L'IPOTESI e i CRITERI C1-C7 stanno in testa a
#  prove\SONDA_OROLOGIO_FX.txt e NON si riscrivono qui: un criterio
#  ricopiato in tre posti e' un criterio che prima o poi diverge.
#
#  ------------------------------------------------------------------
#  PERCHE' ESISTE QUESTO FILE invece di sette righe di
#  walkforward_generico.ps1 incollate a mano. Quattro motivi:
#
#   1. I GATE SUL PERIMETRO. Il driver generico controlla il FORMATO,
#      non il PERIMETRO: non sa che i sette file devono differire solo
#      per simbolo, lato e magic; non sa quali magic sono vietati; non
#      sa che @PERIODO deve essere H1 e @DAQUANDO 2011.01.01; e
#      soprattutto NON SA che una riga pinnata con QUATTRO campi
#      (Nome=1||||||N) viene riscritta storta e MT5 la ignora in
#      silenzio. Qui si controlla tutto PRIMA di aprire MT5.
#
#   2. LA COMPILAZIONE. ABTG_SondaOrologio.mq5 NON E' MAI STATO
#      COMPILATO DA NESSUNO (scritto il 28/08 in un ambiente senza
#      MetaEditor). Il giro di controllo COMPILA DAVVERO: e' il primo
#      risultato vero di questo PASSO 0, e costa un minuto invece di
#      scoprirlo dopo ore di tester.
#
#   3. LA TABELLA. La misura NON e' una riga per cella: sono 72 righe
#      per cella (24 ore x 3 durate). Il referto le rende leggibili e
#      calcola il rapporto del cancello C1 dalle colonne che l'EA
#      esporta, senza che nessuno debba rifarlo in un foglio.
#
#   4. LA RACCOLTA. Regola di casa (CLAUDE.md, righe di lancio punto 2):
#      a fine test i risultati finiscono in una cartella sul Desktop e
#      in uno zip pronto da mandare. Sempre, anche a corsa fermata.
#  ------------------------------------------------------------------
#
#  IL COSTO DELLA CORSA, DETTO PRIMA -- e' la ragione dei tre modi.
#   Una cella di misura = 72 celle x 2 finestre = 144 passate a TICK
#   REALI su 15,5 anni di H1. Sei celle = 864 passate. E' un ordine di
#   grandezza sopra qualunque round di casa (R107: 24 passate a tick
#   reali su 21 mesi in 9 minuti).
#   >>> NON E' UNA STIMA, E' UN'IGNOTA: quanto costi una passata su
#       15,5 anni di tick forex in casa NON E' MAI STATO MISURATO.
#   Per questo il modo di default e' la RICOGNIZIONE: gira solo la
#   cella 00_gemelli (4 passate), che serve a due cose insieme --
#   collaudare il determinismo del banco E CRONOMETRARE una passata.
#   Il referto stampa il tempo per passata e la moltiplicazione, cosi'
#   la decisione di lanciare le sei celle si prende su un numero.
#
#  QUELLO CHE NON FA, dichiarato:
#   - NON GIUDICA e NON PROMUOVE niente (C7). Nessuna sedia viva viene
#     toccata: i magic 7772xx sono VERGINI (cercati uno per uno in
#     tutto il repo il 28/08/2026: zero occorrenze) e il driver
#     generico scrive AllowLiveTrading=false in ogni .ini.
#   - NON adjudica i criteri C2 (l'ora dev'essere quella che la TESI
#     aveva indicato prima) e C3 (altopiano, non picco): quelli si
#     leggono sulla tabella, e sono giudizi, non conti. Il referto
#     stampa i dati che servono e lo DICE.
#   - NON scarica storico. La profondita' del feed su EURUSD/GBPUSD/
#     XAUUSD e' agli atti (R100/R102); che i TICK REALI arrivino
#     davvero fino al 2011 NON lo e': lo dira' il numero di operazioni
#     per cella, e il referto lo mette accanto alla soglia C5.
#   - non scrive una riga di MQL5.
#
#  LA RIGA CHE SI INCOLLA sta in righe\RIGA_SONDA_OROLOGIO_DA_MANDARE.md
#  ed e' l'UNICO posto in cui esiste (CHECKLIST punto 100).
#
#  ------------------------------------------------------------------
#  CHE COSA CAMBIA NELLA v3 (31/08/2026, verifica pre-invio contro le
#  classi nuove della checklist). Sono SEI cose, e tutte e sei nascono
#  da difetti gia' pagati altrove:
#
#   A. "-Rifai" STA SEMPRE NELL'argv del driver generico (classe
#      zombie-run del 31/08, saga CRT: quattro corse dichiarate
#      "eseguite" e mai partite). Un wrapper di MISURA non "riprende":
#      rifa'. La v2 lo passava solo se glielo si chiedeva, e la corsa
#      di ricomposizione si REGGEVA sul salto: cioe' la trappola era
#      diventata il metodo.
#
#   B. LA RICOMPOSIZIONE HA UN MODO SUO, "-Ricomponi", che NON apre il
#      tester e NON compila: rilegge i CSV gia' prodotti e ricalcola il
#      cancello C1 d'insieme. Cosi' la rilettura e' DICHIARATA invece
#      che dedotta da un salto grigio in console (CHECKLIST 101-bis:
#      cronometrare una rilettura di file da' un numero plausibile e
#      falso -- qui il cronometro in quel modo non parte proprio).
#
#   C. Tester\cache SI SVUOTA, coi DUE CONTEGGI nel referto (punto 46 +
#      classe cache-hit-per-costruzione del 31/08). Qui morde davvero:
#      i CSV nascono dai FRAME, e un pass ripescato dalla cache non
#      chiama OnTester(), quindi non manda nessun frame e non ha
#      nessuna riga nel CSV. Con -Rifai il generico rifa' la passata,
#      ma se MT5 la ripesca dalla sua cache il CSV torna MONCO.
#
#   D. LA FINESTRA NON E' PIU' UN DEFAULT EREDITATO (classe del 31/08):
#      @FINOA e' scritta NUDA nei sette file prova, accanto a
#      @DAQUANDO, e il driver la gatta. "2026.06.30" era anche il
#      default di walkforward_generico.ps1: una geometria che coincide
#      con un default e' una geometria che nessuno ha mai deciso.
#
#   E. IL CANCELLO C1 SI CONTA NELLA LETTURA SEVERA (classe del 31/08,
#      "l'ambiguita' del criterio congelato sciolta nel verso che
#      PROMUOVE"). Il criterio dice "per almeno UNA fascia oraria, su
#      almeno DUE dei tre simboli": la v2 contava i simboli che avevano
#      una fascia QUALSIASI, cioe' ammetteva DUE ORE DIVERSE su due
#      simboli diversi. Misurato sul banco: con EURUSD verde alle 8 e
#      GBPUSD verde alle 15 la v2 scriveva "C1 PASSATO". Adesso il
#      verdetto e' la lettura SEVERA (la STESSA fascia su >=2 simboli)
#      e la lettura larga si stampa accanto, ETICHETTATA.
#
#   F. IL CSV SI CONTA E SI GUARDA DENTRO: non basta il numero di
#      righe, si verifica che l'asse chiesto ci sia tutto (24 ore x 3
#      durate) e che la colonna "Lato" sia quella della cella.
#
#  E UN RILIEVO CHE IL DRIVER ALZA DA SOLO, PERCHE' TOCCA IL METRO:
#   il tick NATIVO BCM agli atti parte dal 2024.09.26 (R109 par. D2,
#   R97). Da 2011.01.01 a quella data il Modello 4 NON si ferma: MT5
#   ripiega e genera i tick dalle barre M1. Il LORDO regge (e' deriva
#   bid->bid), ma lo SPREAD -- che e' META' del cancello C1 -- in quel
#   tratto NON e' lo spread del tick. Non si corregge: si DICHIARA, in
#   console e nel referto, come prescrive il criterio C6 per il fuso.
# =====================================================================
[CmdletBinding()]
param(
  # -Pin NON ha default: un default silenzioso ("lavoro") farebbe girare
  #  la punta del branch spacciandola per un commit congelato.
  [string]$Pin           = "",
  [switch]$SoloControllo,          # giro a vuoto: NON apre il tester (ma COMPILA)
  [switch]$TutteLeCelle,           # le sette celle di fila: e' la corsa LUNGA
  [switch]$Ricomponi,              # NON gira niente: rilegge i CSV gia' fatti e ricalcola C1
  # NON esiste piu' un interruttore "-Rifai": il driver generico viene
  # SEMPRE chiamato con -Rifai (classe zombie-run del 31/08). Una corsa
  # di misura non riprende mai a meta': o rifa', o dichiara di rileggere
  # (ed e' quello che fa -Ricomponi).
  [string]$SoloCella     = "",     # una cella sola, per Id
  [string]$Periodo       = "H1",
  # LE DUE DATE SONO DICHIARATE NEI SETTE FILE PROVA (@DAQUANDO e @FINOA
  # NUDE) e GATTATE qui sotto: nessuna delle due e' ereditata dal default
  # di walkforward_generico.ps1 (classe del 31/08). Che "2026.06.30" sia
  # anche il suo default e' una coincidenza, e da oggi e' una coincidenza
  # VERIFICATA contro il prova.
  [string]$DaQuando      = "2011.01.01",
  [string]$Fino          = "2026.06.30",
  [int]$Deposito         = 100000,
  [int]$Modello          = 4       # 4 = TICK REALI. Vedi il RILIEVO nel referto se lo si cambia.
)
$ErrorActionPreference = "Stop"
[Threading.Thread]::CurrentThread.CurrentCulture   = [Globalization.CultureInfo]::InvariantCulture
[Threading.Thread]::CurrentThread.CurrentUICulture = [Globalization.CultureInfo]::InvariantCulture
[Net.ServicePointManager]::SecurityProtocol = [Net.SecurityProtocolType]::Tls12
$INV = [Globalization.CultureInfo]::InvariantCulture

$EA     = "ABTG_SondaOrologio"
$Avvio  = Get-Date
$Stamp  = $Avvio.ToString("yyyyMMdd_HHmm", $INV)
$Dsk    = Join-Path $env:USERPROFILE "Desktop"
$Work   = Join-Path $env:USERPROFILE "abtg_sonda_orologio"
$Prove  = Join-Path $Work "prove"
$RawPin = "https://raw.githubusercontent.com/claudiospadaro12/GITHUB/$Pin"

# --- TUTTO CIO' CHE LA RACCOLTA USA NASCE QUI, PRIMA DEL try.
#     In PowerShell una `function` non e' dichiarativa, e' un'ISTRUZIONE:
#     se il flusso non ci passa sopra il nome non esiste, e la raccolta
#     esploderebbe proprio nella corsa fermata da un gate, cioe' l'unica
#     in cui il referto serve davvero.
$Problemi  = New-Object System.Collections.ArrayList
$Rilievi   = New-Object System.Collections.ArrayList
$Fatale    = ""
$Terminale = "n/d"
$Compilato = "NON TENTATA"
$Cronometro= "non misurato"
$CacheTxt  = "NON SVUOTATA"

$Modo = "CORSA"
if($SoloControllo){ $Modo = "CONTROLLO" }
if($Ricomponi){ $Modo = "RICOMPOSIZIONE" }

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

# --- LA CONVENZIONE DI SENTINELLA. Un numero non misurato non deve MAI
#     uscire come numero plausibile: in R103 il PF non misurato usciva
#     "0.000", che si legge "ha perso tutto". Qui esce "n/d".
# FmtN: CONTEGGI. Non esiste un conteggio negativo, quindi un negativo e'
#   la sentinella "non misurato" e deve uscire "n/d", non "-1".
function FmtN($v){ if($null -eq $v){ return "n/d" }; if([int]$v -lt 0){ return "n/d" }; return ([int]$v).ToString($INV) }
# Fmt2: GRANDEZZE CON SEGNO. E QUI IL NEGATIVO NON SI TOCCA, ed e' il
#   contrario di quello che fanno i driver gemelli: il LORDO puo' essere
#   legittimamente negativo (una fascia in cui il prezzo scende e' la
#   meta' della tesi: "la valuta si deprezza nelle proprie ore"), e la
#   PEGGIOR GIORNATA e' negativa SEMPRE. Applicare qui la stessa
#   sentinella di FmtN cancellerebbe meta' della misura scambiandola per
#   un dato mancante (e' il difetto del punto 66, al rovescio).
function Fmt2($v){ if($null -eq $v){ return "n/d" }; return ([double]$v).ToString("0.00",$INV) }

# =====================================================================
#  IL PARSER DEL CSV DI OTTIMIZZAZIONE.
#  Le colonne si cercano PER NOME, mai per posizione. Se non le
#  riconosce torna $null E DICE quali intestazioni ha visto, invece di
#  indovinare (punto 80: una colonna che la famiglia non esporta non
#  deve diventare un sentinella "onesto" che camuffa un criterio
#  impossibile -- qui l'assenza e' un PROBLEMA, non un trattino).
#  L'intestazione VERA di questo EA, LETTA NEL SORGENTE (OnTesterDeinit),
#  e' a 28 colonne piu' quelle dei parametri.
# =====================================================================
$script:CsvIntestazioni = @()
$ColonneObbligatorie = @("Ora Ingresso","Ore Durata","Lato","Giornate Operate",
                         "Lordo Medio Punti","Lordo Medio Valuta",
                         "Spread Mediano Ingresso","Spread P95 Ingresso",
                         "Rapporto Lordo Su Spread","Giornate Positive %",
                         "Ore Medie Tenuta","Uscite Ora","Uscite Flat",
                         "Uscite Stop O Orfane","Notti Attraversate",
                         "Lotti Al Minimo","Autotest Falliti",
                         "Giorni Saltati Spread","Peggior Giornata %",
                         "Profit","Trades")

function LeggiOpt([string]$path){
  # AZZERARE QUI NON E' PULIZIA, E' UN GATE. Senza, un CSV MANCANTE
  # lasciava in piedi le intestazioni dell'ULTIMO file letto bene, e il
  # referto scriveva "Intestazioni viste: ..." elencando colonne che in
  # quella cella nessuno aveva mai visto: un valore vecchio che racconta
  # un fatto mai accaduto.
  $script:CsvIntestazioni = @()
  if(-not (Test-Path -LiteralPath $path)){ return $null }
  $righe = @()
  try{ $righe = @(Import-Csv -LiteralPath $path) }catch{ return $null }
  if($righe.Count -eq 0){ return $null }
  $cols = @($righe[0].PSObject.Properties.Name)
  $script:CsvIntestazioni = $cols
  foreach($c in $ColonneObbligatorie){
    if(-not ($cols -contains $c)){ return $null }
  }
  $out = New-Object System.Collections.ArrayList
  foreach($r in $righe){
    [void]$out.Add([pscustomobject]@{
      Ora      = (NumInv $r."Ora Ingresso")
      Durata   = (NumInv $r."Ore Durata")
      Lato     = (NumInv $r."Lato")
      N        = (NumInv $r."Giornate Operate")
      LordoPt  = (NumInv $r."Lordo Medio Punti")
      LordoVal = (NumInv $r."Lordo Medio Valuta")
      SprMed   = (NumInv $r."Spread Mediano Ingresso")
      SprP95   = (NumInv $r."Spread P95 Ingresso")
      C1       = (NumInv $r."Rapporto Lordo Su Spread")
      PctPos   = (NumInv $r."Giornate Positive %")
      OreTen   = (NumInv $r."Ore Medie Tenuta")
      UscOra   = (NumInv $r."Uscite Ora")
      UscFlat  = (NumInv $r."Uscite Flat")
      UscStop  = (NumInv $r."Uscite Stop O Orfane")
      Notti    = (NumInv $r."Notti Attraversate")
      LotMin   = (NumInv $r."Lotti Al Minimo")
      Autotest = (NumInv $r."Autotest Falliti")
      SprSalt  = (NumInv $r."Giorni Saltati Spread")
      PegGio   = (NumInv $r."Peggior Giornata %")
      Profit   = (NumInv $r."Profit")
      Trades   = (NumInv $r."Trades")
    })
  }
  return @($out)
}

# --- I GEMELLI: le due righe devono essere IDENTICHE AL CENTESIMO.
#     E' l'unico controllo d'igiene del banco, ed e' il motivo per cui
#     la cella 00_gemelli esiste. "Una riga sola" NON e' "gemelli ok":
#     e' uno sweep che non ha spazzolato, e va detto come tale.
$TolGemelli = 0.005
function Gemelli($righe){
  if($null -eq $righe){ return "NON MISURATO (CSV non letto)" }
  if(@($righe).Count -ne 2){ return ("NON VALIDO: " + @($righe).Count + " righe invece di 2") }
  $a = $righe[0]; $b = $righe[1]
  # DUE CORSE VUOTE SONO IDENTICHE PER COSTRUZIONE: zero contro zero non e'
  # "banco deterministico", e' "banco che non ha misurato niente". CHECKLIST
  # punto 93: la sentinella e' onesta quando la si STAMPA e bugiarda quando
  # la si CONFRONTA -- qui la variante zero-contro-zero.
  if($null -eq $a.N -or $null -eq $b.N){ return "NON MISURATO (giornate operate illeggibili)" }
  if([double]$a.N -le 0 -and [double]$b.N -le 0){
    return "NON MISURATO (ZERO operazioni in tutte e due le passate: due corse vuote escono identiche per costruzione e non dicono niente sul determinismo. Storico a TICK mancante sul simbolo, oppure cella mai girata)"
  }
  $coppie = @(
    @("profitto",        $a.Profit,  $b.Profit),
    @("operazioni",      $a.N,       $b.N),
    @("lordo in punti",  $a.LordoPt, $b.LordoPt),
    @("spread mediano",  $a.SprMed,  $b.SprMed),
    @("peggior giornata",$a.PegGio,  $b.PegGio)
  )
  foreach($ch in $coppie){
    if($null -eq $ch[1] -or $null -eq $ch[2]){ return ("NON MISURATO (" + $ch[0] + " illeggibile)") }
    if([math]::Abs([double]$ch[1] - [double]$ch[2]) -gt $TolGemelli){
      return ("DIVERSI su " + $ch[0] + ": " + $ch[1] + " contro " + $ch[2])
    }
  }
  return "IDENTICI"
}

# =====================================================================
#  LE SETTE CELLE.
#  'AssiY' = i nomi degli assi con flag Y che quel file DEVE avere,
#  esattamente quelli e nessun altro. E' il gate che impedisce a una
#  griglia di rientrare dalla finestra o a un asse di sparire.
# =====================================================================
# ATTENZIONE al nome del parametro: NON si chiama $celle. In PowerShell
# le variabili sono CASE-INSENSITIVE (punto 79), e $celle sarebbe LA
# STESSA variabile di $CELLE, l'elenco delle sette celle. Qui e' solo
# uno scope diverso e funzionerebbe lo stesso, ma e' esattamente la
# classe di difetto che il 25/08 e' arrivata fino al PC di Claudio.
function C([string]$id,[string]$file,[string]$sym,[string]$lato,[string]$desc,
          [int[]]$magic,[string[]]$assiY,[int]$nCelle){
  return [pscustomobject]@{
    Id=$id; Prova=$file; Sym=$sym; Lato=$lato; Desc=$desc;
    Magic=@($magic); AssiY=@($assiY); Celle=$nCelle;
    Esito="NON ESEGUITA"; Gemelli="NON PERTINENTE";
    Fresca="NON PERTINENTE (cella non eseguita in questo giro)";
    RigheIS=-1; RigheOOS=-1; Secondi=-1.0;
    DatiIS=$null; DatiOOS=$null }
}
$CELLE = @()
$CELLE += (C "00_gemelli"      "SONDA_OROLOGIO_00_GEMELLI.txt"      "EURUSD" "LONG"  "DETERMINISMO DEL BANCO + CRONOMETRO (ora e durata inchiodate: NON e' una misura dell'orologio)" @(777290,777291) @("InpMagic") 2)
$CELLE += (C "01_eurusd_long"  "SONDA_OROLOGIO_01_EURUSD_LONG.txt"  "EURUSD" "LONG"  "EURUSD lato LONG  -- la tabella 24 ore x 3 durate" @(777201) @("InpOraIngresso","InpOreDurata") 72)
$CELLE += (C "02_eurusd_short" "SONDA_OROLOGIO_02_EURUSD_SHORT.txt" "EURUSD" "SHORT" "EURUSD lato SHORT -- regola dei due lati (25/08)" @(777202) @("InpOraIngresso","InpOreDurata") 72)
$CELLE += (C "03_gbpusd_long"  "SONDA_OROLOGIO_03_GBPUSD_LONG.txt"  "GBPUSD" "LONG"  "GBPUSD lato LONG" @(777203) @("InpOraIngresso","InpOreDurata") 72)
$CELLE += (C "04_gbpusd_short" "SONDA_OROLOGIO_04_GBPUSD_SHORT.txt" "GBPUSD" "SHORT" "GBPUSD lato SHORT" @(777204) @("InpOraIngresso","InpOreDurata") 72)
$CELLE += (C "05_xauusd_long"  "SONDA_OROLOGIO_05_XAUUSD_LONG.txt"  "XAUUSD" "LONG"  "XAUUSD lato LONG" @(777205) @("InpOraIngresso","InpOreDurata") 72)
$CELLE += (C "06_xauusd_short" "SONDA_OROLOGIO_06_XAUUSD_SHORT.txt" "XAUUSD" "SHORT" "XAUUSD lato SHORT" @(777206) @("InpOraIngresso","InpOreDurata") 72)

# --- LA BASELINE ASSOLUTA: i valori che ogni file prova DEVE pinnare.
#     Si confronta con QUESTI, dichiarati nel driver, e non con un file
#     gemello: una corruzione SIMMETRICA (la stessa riga storta in tutti
#     e sette) passerebbe un diff a mani basse (lezione R108/R110).
$Baseline = [ordered]@{
  "InpRiskPercent"     = "1.0"
  "InpSLatrMult"       = "10.0"
  "InpATRPeriod"       = "14"
  "InpTPatrMult"       = "0.0"
  "InpMaxPositions"    = "1"
  "InpMaxTradesPerDay" = "1"
  "InpMaxSpreadPts"    = "0"
  "InpFlatAnticipoMin" = "30"
}

# --- LA GRIGLIA LETTERALE delle sei celle di misura. Non "due assi Y":
#     ESATTAMENTE questi due assi con ESATTAMENTE questi estremi. Se
#     qualcuno stringesse la griglia a 8 ore la tabella cambierebbe
#     forma senza che nessuno se ne accorga.
$GrigliaAttesa = [ordered]@{
  "InpOraIngresso" = "0||0||1||23||Y"
  "InpOreDurata"   = "4||4||4||12||Y"
}

# --- I MAGIC VIETATI: sedie vive e round recenti. Un'identita' non in
#     campo resta comunque occupata.
$MagicVietati = @(775501, 776000,776001, 776100,776101, 776200,776201, 776400,776401,
                  773400,773401, 773410,773411, 773420,773421, 773430,773431,
                  763000,763010,763020,763100,763110,763120,
                  763200,763210,763220,763300,763310,763320,
                  773200,773201,773230,773231,773300,773301,
                  770101,770511,771531,970912,970913)

# --- L'ELENCO CHIUSO DEI PARAMETRI AMMESSI in un file prova di questa
#     sonda. Serve a una cosa sola, ed e' LA cosa: impedire che entri
#     una condizione di PREZZO. Un nome fuori da questa lista ferma
#     tutto, anche se l'EA quel parametro ce l'ha.
$ParametriAmmessi = @("InpOraIngresso","InpOreDurata","InpAllowLong","InpAllowShort",
                      "InpRiskPercent","InpSLatrMult","InpATRPeriod","InpTPatrMult",
                      "InpMaxPositions","InpMaxTradesPerDay","InpMaxSpreadPts",
                      "InpFlatAnticipoMin","InpMagic")

# =====================================================================
#  QUALI CELLE GIRANO -- e perche' il default e' UNA SOLA.
#  Vedi "IL COSTO DELLA CORSA" in testa: 864 passate a tick reali su
#  15,5 anni non si lanciano al buio.
# =====================================================================
$Ordinate = @()
if($Ricomponi){
  # RICOMPOSIZIONE: non gira niente, rilegge TUTTO quello che c'e'.
  $Ordinate = @($CELLE)
}elseif($SoloCella -ne ""){
  $Ordinate = @($CELLE | Where-Object { $_.Id -eq $SoloCella })
}elseif($TutteLeCelle){
  $Ordinate = @($CELLE)
}else{
  $Ordinate = @($CELLE | Where-Object { $_.Id -eq "00_gemelli" })
  if(-not $SoloControllo){ $Modo = "RICOGNIZIONE" }
}

try{
  Titolo ("SONDA DELL'OROLOGIO (" + $EA + ") -- modo " + $Modo)

  # -------------------------------------------------------------------
  #  0. LE GUARDIE, PRIMA DI TOCCARE QUALUNQUE COSA
  # -------------------------------------------------------------------
  if($Pin -eq ""){ throw "-Pin obbligatorio: senza, girerebbe la punta del branch spacciandola per un commit congelato." }
  if($Pin -notmatch '^[0-9a-f]{40}$'){ throw ("-Pin deve essere un commit di 40 caratteri esadecimali, ricevuto: " + $Pin) }
  if(Get-Process terminal64,metaeditor64 -ErrorAction SilentlyContinue){
    throw "MT5 O METAEDITOR APERTO: col terminale aperto il tester non gira (zero CSV), con MetaEditor aperto la compilazione torna subito senza compilare."
  }
  if($SoloCella -ne "" -and @($Ordinate).Count -eq 0){
    throw ("-SoloCella '" + $SoloCella + "' non esiste. Validi: " + ((@($CELLE | ForEach-Object { $_.Id })) -join ", "))
  }
  if($SoloCella -ne "" -and $TutteLeCelle){
    throw "-SoloCella e -TutteLeCelle insieme non vogliono dire niente: scegline uno."
  }
  # -Ricomponi e' un modo A SE': non gira, rilegge. Mescolarlo con gli
  # altri interruttori produrrebbe una corsa che dice di essere una
  # rilettura o una rilettura che dice di essere una corsa -- ed e'
  # esattamente la confusione che la classe zombie-run e' costata.
  if($Ricomponi -and ($SoloControllo -or $TutteLeCelle -or $SoloCella -ne "")){
    throw "-Ricomponi non si mescola con -SoloControllo / -TutteLeCelle / -SoloCella: rilegge SEMPRE tutte le celle gia' girate e non apre mai il tester. Lanciala da sola."
  }
  if($Periodo -ne "H1"){
    throw ("-Periodo e' " + $Periodo + ": i sette file prova dichiarano @PERIODO H1 e il gate li confronta. La sonda entra all'apertura di una barra H1: su un altro TF misurerebbe un'altra cosa.")
  }
  if($Modello -ne 4){
    [void]$Rilievi.Add("MODELLO " + $Modello + " invece di 4 (TICK REALI). Lo SPREAD e' meta' di questa misura, e fuori dai tick reali lo spread NON e' quello del feed: la colonna 'Spread Mediano Ingresso' smette di voler dire cio' che il criterio C1 le chiede. Il numero si legge SOLO come screening.")
  }
  # --- LA PROFONDITA' DEI TICK: rilievo AUTOMATICO, e non e' una nota a
  #     pie' di pagina. Il tick NATIVO BCM agli atti parte dal 2024.09.26
  #     (R109 par. D2, R97). Prima di quella data il Modello 4 NON si
  #     ferma: MT5 genera i tick dalle barre M1. Il LORDO (deriva
  #     bid->bid) regge; lo SPREAD MEDIANO -- META' del cancello C1 --
  #     no. Non e' misurato su questi tre simboli, e proprio per questo
  #     va detto: "non ho misurato" non e' "va bene" (punto 40).
  $TickNativoBCM = "2024.09.26"
  if($Modello -eq 4 -and ([datetime]::ParseExact($DaQuando,"yyyy.MM.dd",$INV) -lt [datetime]::ParseExact($TickNativoBCM,"yyyy.MM.dd",$INV))){
    [void]$Rilievi.Add("PROFONDITA' DEI TICK NON MISURATA su EURUSD/GBPUSD/XAUUSD. Il tick NATIVO BCM agli atti parte dal " + $TickNativoBCM + " (R109 par. D2, R97), la finestra parte dal " + $DaQuando + ". A Modello 4 senza tick reali MT5 NON si ferma: ripiega e genera i tick dalle barre M1. Il LORDO in punti (deriva bid->bid) regge; la colonna 'Spread Mediano Ingresso' nel tratto pre-" + $TickNativoBCM + " NON e' lo spread del tick, ed e' META' del cancello C1. Il rapporto C1 letto sulla gamba IS (la piu' vecchia) va letto con questa etichetta attaccata: e' un rapporto su spread RICOSTRUITO.")
  }

  $passate = 0
  foreach($c in $Ordinate){ $passate += $c.Celle*2 }

  Dico ("pin ......... " + $Pin)
  Dico ("celle ....... " + @($Ordinate).Count + " su 7   [" + ((@($Ordinate | ForEach-Object { $_.Id })) -join ", ") + "]")
  Dico ("finestra .... " + $DaQuando + " -> " + $Fino + " (split 40/60 del driver generico)")
  Dico ("banco ....... Modello " + $Modello + ", deposito " + $Deposito + ", periodo " + $Periodo)
  if($Ricomponi){
    Dico ("passate ..... ZERO: -Ricomponi NON apre il tester e NON compila, rilegge i CSV gia' prodotti") "Yellow"
    Write-Host ""
    Write-Host "###################################################################" -ForegroundColor Yellow
    Write-Host "#  MODO RICOMPOSIZIONE: qui NON gira NIENTE, per costruzione.     #" -ForegroundColor Yellow
    Write-Host "#  Rilegge i CSV delle celle gia' girate (stesso pin) e ricalcola #" -ForegroundColor Yellow
    Write-Host "#  il cancello C1, che e' un criterio D'INSIEME e su un referto   #" -ForegroundColor Yellow
    Write-Host "#  parziale non si puo' leggere.                                  #" -ForegroundColor Yellow
    Write-Host "#  Nessun cronometro: cronometrare una rilettura di file darebbe  #" -ForegroundColor Yellow
    Write-Host "#  un numero plausibile e falso (CHECKLIST 101-bis).              #" -ForegroundColor Yellow
    Write-Host "###################################################################" -ForegroundColor Yellow
  }else{
    Dico ("passate ..... " + $passate + " a tick reali su 15,5 anni di H1, e si RIFANNO tutte (-Rifai sempre)") "Yellow"
  }
  if($Modo -eq "RICOGNIZIONE"){
    Write-Host ""
    Write-Host "###################################################################" -ForegroundColor Yellow
    Write-Host "#  MODO RICOGNIZIONE: gira SOLO la cella 00_gemelli (4 passate).  #" -ForegroundColor Yellow
    Write-Host "#  Serve a DUE cose insieme:                                      #" -ForegroundColor Yellow
    Write-Host "#    - collaudare il DETERMINISMO del banco (le due righe gemelle #" -ForegroundColor Yellow
    Write-Host "#      devono uscire identiche al centesimo);                     #" -ForegroundColor Yellow
    Write-Host "#    - CRONOMETRARE una passata su 15,5 anni di tick, che in casa #" -ForegroundColor Yellow
    Write-Host "#      NON e' mai stato misurato.                                 #" -ForegroundColor Yellow
    Write-Host "#  Il referto stampa il tempo e la moltiplicazione x144. La corsa #" -ForegroundColor Yellow
    Write-Host "#  vera si lancia DOPO, una cella per volta, con -SoloCella.      #" -ForegroundColor Yellow
    Write-Host "###################################################################" -ForegroundColor Yellow
  }

  # -------------------------------------------------------------------
  #  1. SCARICO AL PIN
  # -------------------------------------------------------------------
  Titolo "1. SCARICO AL PIN"
  New-Item -ItemType Directory -Force -Path $Work,$Prove | Out-Null

  # --- se il pin cambia, la cache va via: senza, il gate di idempotenza
  #     del driver generico riproporrebbe i CSV di ieri come se fossero
  #     di oggi (e i file prova vecchi passerebbero i gate nuovi).
  $pinFile = Join-Path $Work "pin_corrente.txt"
  $pinVecchio = ""
  if(Test-Path -LiteralPath $pinFile){ $pinVecchio = (Get-Content -LiteralPath $pinFile -Raw).Trim() }
  if($pinVecchio -ne $Pin){
    Remove-Item -LiteralPath $Prove -Recurse -Force -ErrorAction SilentlyContinue
    Remove-Item -LiteralPath (Join-Path $Work "risultati_prove") -Recurse -Force -ErrorAction SilentlyContinue
    New-Item -ItemType Directory -Force -Path $Prove | Out-Null
    if($pinVecchio -ne ""){ Dico ("pin cambiato (" + $pinVecchio + " -> " + $Pin + "): cache dei file prova e dei CSV CANCELLATA.") "Yellow" }
    Set-Content -LiteralPath $pinFile -Value $Pin -Encoding ASCII
  }

  $drv = Join-Path $Work "walkforward_generico.ps1"
  Scarica ($RawPin + "/backtest_pipeline/walkforward_generico.ps1") $drv
  # il driver generico pinna il branch da cui riscarica il .mq5: senza
  # questo, il pin varrebbe per il driver e NON per l'EA misurato.
  $testoDrv = Get-Content -LiteralPath $drv -Raw
  if($testoDrv -notmatch '\$EABranch\s*=\s*"lavoro"'){ throw "walkforward_generico.ps1 non ha la riga \$EABranch attesa: non lo posso pinnare." }
  $testoDrv = $testoDrv -replace '\$EABranch\s*=\s*"lavoro"', ('$EABranch="' + $Pin + '"')
  Set-Content -LiteralPath $drv -Value $testoDrv -Encoding ASCII
  Dico "driver generico scaricato e PINNATO (riscarica l'EA al pin, non dalla punta del branch)" "Green"

  # TUTTI E SETTE i file prova si scaricano SEMPRE, anche quando gira una
  # cella sola: i gate del perimetro (magic unici, valori dei lati) sono
  # gate DI INSIEME, e su un file solo non direbbero niente.
  foreach($c in $CELLE){
    Scarica ($RawPin + "/backtest_pipeline/prove/" + $c.Prova) (Join-Path $Prove $c.Prova)
  }
  Dico ("file prova scaricati: " + @(Get-ChildItem $Prove -Filter SONDA_OROLOGIO_*.txt).Count + " su 7") "Green"

  # -------------------------------------------------------------------
  #  2. I GATE SUI FILE PROVA -- girano PRIMA di aprire MT5
  # -------------------------------------------------------------------
  Titolo "2. GATE SUI FILE PROVA"
  $mappe = @{}
  foreach($c in $CELLE){
    $f = Join-Path $Prove $c.Prova
    $righe = RigheVive $f
    $h = @{}
    $assiTrovati = New-Object System.Collections.ArrayList
    foreach($r in $righe){
      if($r -match '^@'){
        $parti = ($r -split '\s+',2)
        if($h.ContainsKey($parti[0])){ throw ($c.Prova + ": DUE direttive '" + $parti[0] + "'.") }
        $h[$parti[0]] = $parti[1].Trim()
        continue
      }
      $i = $r.IndexOf("=")
      if($i -lt 0){ throw ($c.Prova + ": riga senza '=' e senza '#': '" + $r + "'.") }
      $nome = $r.Substring(0,$i).Trim()
      $val  = $r.Substring($i+1).Trim()
      if($h.ContainsKey($nome)){ throw ($c.Prova + ": DUE righe per '" + $nome + "'. In [TesterInputs] un parametro doppio fa fare a MT5 ZERO passate.") }

      # GATE DELLA SINTASSI DEI CINQUE CAMPI -- e' il difetto trovato nel
      # file congelato SONDA_OROLOGIO_FX.txt. Una riga con quattro campi
      # (Nome=1||||||N) viene trattata dal driver generico come "pin
      # secco" e riscritta storta: MT5 la ignora IN SILENZIO.
      $campi = $val -split '\|\|'
      if($campi.Count -ne 5){
        throw ($c.Prova + ": '" + $nome + "' ha " + $campi.Count + " campi invece di 5. La forma di casa e' 'Nome=valore||valore||0||valore||N'. Con quattro campi il driver generico la riscrive storta e MT5 la ignora senza dire niente.")
      }
      if($campi[4].Trim() -ne "N" -and $campi[4].Trim() -ne "Y"){
        throw ($c.Prova + ": '" + $nome + "' ha flag '" + $campi[4] + "' invece di N o Y.")
      }

      # GATE DELL'ELENCO CHIUSO: nessuna condizione di prezzo puo' entrare.
      if(-not ($ParametriAmmessi -contains $nome)){
        throw ($c.Prova + ": '" + $nome + "' NON e' nell'elenco chiuso dei parametri della sonda. La sonda misura l'OROLOGIO: se entra un parametro che non e' in elenco, smette di misurare l'orologio e comincia a misurare un motore -- che e' un altro round.")
      }

      $h[$nome] = $val
      if($campi[4].Trim() -eq "Y"){ [void]$assiTrovati.Add($nome) }
    }

    # GATE GEOMETRIA
    if($h["@SIMBOLO"]  -ne $c.Sym){     throw ($c.Prova + ": @SIMBOLO e' " + $h["@SIMBOLO"] + ", la cella " + $c.Id + " lo vuole " + $c.Sym) }
    if($h["@PERIODO"]  -ne $Periodo){   throw ($c.Prova + ": @PERIODO e' " + $h["@PERIODO"] + ", atteso " + $Periodo) }
    if($h["@DAQUANDO"] -ne $DaQuando){  throw ($c.Prova + ": @DAQUANDO e' " + $h["@DAQUANDO"] + ", atteso " + $DaQuando) }
    # @FINOA STA ACCANTO A @DAQUANDO, NUDA, e si gatta: una finestra che
    # vive solo nel param() del wrapper non ha nessuno che la controlli,
    # e "2026.06.30" e' anche il default di walkforward_generico.ps1
    # (classe del 31/08: la finestra ereditata dal default del generico).
    if(-not $h.ContainsKey("@FINOA")){  throw ($c.Prova + ": manca la direttiva @FINOA. La fine della finestra si DICHIARA nel prova accanto a @DAQUANDO, non si eredita dal default del driver generico.") }
    if($h["@FINOA"]    -ne $Fino){      throw ($c.Prova + ": @FINOA e' " + $h["@FINOA"] + ", atteso " + $Fino) }

    # GATE DEGLI ASSI: esattamente quelli dichiarati, nessuno in piu'.
    $attesi = @($c.AssiY | Sort-Object)
    $visti  = @($assiTrovati | Sort-Object)
    if(($attesi -join ",") -ne ($visti -join ",")){
      throw ($c.Prova + ": gli assi con flag Y sono [" + ($visti -join ",") + "], la cella " + $c.Id + " li vuole [" + ($attesi -join ",") + "].")
    }

    # GATE DELLA GRIGLIA LETTERALE (solo per le celle di misura)
    if($c.Id -ne "00_gemelli"){
      foreach($k in $GrigliaAttesa.Keys){
        if($h[$k] -ne $GrigliaAttesa[$k]){
          throw ($c.Prova + ": '" + $k + "' vale '" + $h[$k] + "', la griglia congelata vuole '" + $GrigliaAttesa[$k] + "'. Stringere la griglia cambia la forma della tabella senza che si veda.")
        }
      }
    }

    # GATE DEI VALORI DEI LATI: prende il caso che nessun diff vede, cioe'
    # due file SCAMBIATI fra loro.
    $vl = ($h["InpAllowLong"]  -split '\|\|')[0]
    $vs = ($h["InpAllowShort"] -split '\|\|')[0]
    $wl = "0"; $ws = "1"
    if($c.Lato -eq "LONG"){ $wl = "1"; $ws = "0" }
    if($vl -ne $wl){ throw ($c.Prova + ": InpAllowLong vale "  + $vl + ", la cella " + $c.Id + " (" + $c.Lato + ") lo vuole " + $wl) }
    if($vs -ne $ws){ throw ($c.Prova + ": InpAllowShort vale " + $vs + ", la cella " + $c.Id + " (" + $c.Lato + ") lo vuole " + $ws) }

    # GATE DELLA BASELINE ASSOLUTA: contro valori DICHIARATI QUI, non
    # contro un file gemello. Una corruzione simmetrica passerebbe un
    # diff e non passa questo.
    foreach($k in $Baseline.Keys){
      if(-not $h.ContainsKey($k)){ throw ($c.Prova + ": manca il pin di '" + $k + "': la baseline dev'essere verificabile nell'.ini, non dedotta.") }
      $v0 = ($h[$k] -split '\|\|')[0]
      if($v0 -ne $Baseline[$k]){
        throw ($c.Prova + ": '" + $k + "' vale " + $v0 + ", la baseline dichiarata di questa sonda lo vuole " + $Baseline[$k])
      }
    }

    $mappe[$c.Id] = $h
  }

  # GATE DEI MAGIC: unici in tutto l'insieme, mai uno vietato.
  $magicVisti = @{}
  foreach($c in $CELLE){
    $h = $mappe[$c.Id]
    $mg = $h["InpMagic"] -split '\|\|'
    $lista = @()
    if($mg[4].Trim() -eq "Y"){
      $da = [int]$mg[1]; $passo = [int]$mg[2]; $a = [int]$mg[3]
      if($passo -le 0){ throw ($c.Prova + ": InpMagic e' un asse Y con passo " + $passo + ".") }
      for($m = $da; $m -le $a; $m += $passo){ $lista += $m }
    }else{
      $lista = @([int]$mg[0])
    }
    if(@($lista).Count -ne @($c.Magic).Count){
      throw ($c.Prova + ": la cella " + $c.Id + " vuole " + @($c.Magic).Count + " magic, il file ne produce " + @($lista).Count + ".")
    }
    # L'ORDINE DI QUESTI TRE CONTROLLI E' PARTE DEL GATE, e ci e' voluta
    # una prova per capirlo: con l'identita' PER PRIMA, i controlli
    # "VIETATO" e "DUPLICATO" non potevano scattare MAI (un magic che
    # differisce da quello atteso viene fermato prima), cioe' erano
    # decorazione. Prima si nomina il PERICOLO -- toccare una sedia viva,
    # incrociare due celle -- e solo dopo lo scostamento innocuo.
    for($i = 0; $i -lt @($lista).Count; $i++){
      $n = [int]$lista[$i]
      if($MagicVietati -contains $n){ throw ($c.Prova + ": magic " + $n + " e' VIETATO (sedia viva o round recente). Un'identita' non in campo resta comunque occupata.") }
      if($magicVisti.ContainsKey($n)){ throw ("magic " + $n + " usato in due celle: " + $magicVisti[$n] + " e " + $c.Prova) }
      if($n -ne [int]$c.Magic[$i]){ throw ($c.Prova + ": magic " + $n + ", la cella " + $c.Id + " vuole " + $c.Magic[$i] + ".") }
      $magicVisti[$n] = $c.Prova
    }
  }
  Dico "geometria, assi, griglia letterale, lati, baseline assoluta, elenco chiuso e magic: TUTTI PASSATI su 7 file su 7" "Green"

  # -------------------------------------------------------------------
  #  3. LA COMPILAZIONE -- il pezzo che il driver generico fa troppo
  #     tardi e senza dire perche'.
  # -------------------------------------------------------------------
  if($Ricomponi){
    # RICOMPOSIZIONE: niente terminale, niente compilazione, niente cache.
    # Non e' pigrizia: e' la garanzia che questo giro NON possa produrre
    # un numero nuovo. Rilegge e basta, e lo dice in ogni riga del referto.
    Titolo "3. COMPILAZIONE, TERMINALE E CACHE: SALTATI (modo RICOMPOSIZIONE)"
    $Terminale  = "non pertinente (-Ricomponi non apre MT5)"
    $Compilato  = "NON TENTATA (-Ricomponi non compila: rilegge soltanto)"
    $CacheTxt   = "non pertinente (-Ricomponi non apre il tester)"
    $Cronometro = "non pertinente: in RICOMPOSIZIONE non gira nessuna passata"
    Dico "nessun terminale aperto, nessuna compilazione, nessuna passata: si rileggono i CSV gia' prodotti." "Yellow"
  }else{
    Titolo "3. COMPILO L'EA"
    # IL SELETTORE E' LO STESSO, RIGA PER RIGA, DI walkforward_generico.ps1
    # (punti 26/27): su una macchina con DUE istanze i due script potrebbero
    # scegliere TERMINALI DIVERSI. Se il selettore del driver generico
    # cambia, cambia anche questo: si toccano insieme.
    $allTerm = @(Get-ChildItem "C:\Program Files","C:\Program Files (x86)" -Recurse -Filter "terminal64.exe" -ErrorAction SilentlyContinue)
    $cand = $allTerm | Where-Object { $_.DirectoryName -like "*BCM Markets MT5 Terminal*" -and $_.DirectoryName -notlike "*-V3*" } | Select-Object -First 1
    if(-not $cand){ $cand = $allTerm | Where-Object { $_.DirectoryName -like "*BCM Markets*" } | Select-Object -First 1 }
    if(-not $cand){ throw "terminale BCM non trovato: e' lo stesso selettore di walkforward_generico.ps1." }
    $instDir    = $cand.DirectoryName
    $MetaEditor = Join-Path $instDir "metaeditor64.exe"
    $termRoot   = Join-Path $env:APPDATA "MetaQuotes\Terminal"
    $dataFolder = (Get-ChildItem $termRoot -Directory -ErrorAction SilentlyContinue | Where-Object { $o = Join-Path $_.FullName "origin.txt"; (Test-Path $o) -and ((Get-Content $o -Raw).Trim() -ieq $instDir) } | Select-Object -First 1 -ExpandProperty FullName)
    if(-not $dataFolder){ throw ("cartella dati non trovata per " + $instDir) }
    $Terminale = $instDir
    Dico ("terminale scelto: " + $instDir + "  (DEVE essere lo stesso che stampa il driver generico)") "Yellow"

    # QUESTO EA NON E' MAI STATO COMPILATO DA NESSUNO: un giro di controllo
    # che non compila non controlla la cosa PIU' PROBABILE che vada storta.
    # L'.ex5 si CANCELLA prima: senza, un binario vecchio farebbe passare
    # per riuscita una compilazione fallita (punto 23).
    $mq5 = Join-Path $Work ($EA + ".mq5")
    Scarica ($RawPin + "/mql5/Experts/" + $EA + ".mq5") $mq5
    $dstExp = Join-Path $dataFolder "MQL5\Experts"
    New-Item -ItemType Directory -Force -Path $dstExp | Out-Null
    $dstMq5 = Join-Path $dstExp ($EA + ".mq5")
    Copy-Item $mq5 -Destination $dstMq5 -Force
    $ex5 = Join-Path $dstExp ($EA + ".ex5")
    Remove-Item -LiteralPath $ex5 -Force -ErrorAction SilentlyContinue
    $t0 = Get-Date
    & $MetaEditor ("/compile:" + $dstMq5) "/log" | Out-Null
    while((-not (Test-Path -LiteralPath $ex5)) -and ((New-TimeSpan -Start $t0 -End (Get-Date)).TotalSeconds -lt 180)){ Start-Sleep -Seconds 2 }
    if(-not (Test-Path -LiteralPath $ex5)){
      $logC = Join-Path $dstExp ($EA + ".log")
      if(Test-Path -LiteralPath $logC){
        Copy-Item $logC -Destination (Join-Path $Work "COMPILAZIONE_FALLITA.log") -Force
        Get-Content -LiteralPath $logC -Tail 40 | ForEach-Object { Write-Host $_ -ForegroundColor Red }
      }
      throw ("COMPILAZIONE FALLITA: " + $EA + " non era MAI stato compilato da nessuno. Gli errori sono qui sopra e in COMPILAZIONE_FALLITA.log dentro lo zip.")
    }
    $Compilato = "OK (" + [int]((Get-Item -LiteralPath $ex5).Length/1024) + " KB, " + (Get-Item -LiteralPath $ex5).LastWriteTime.ToString("HH:mm:ss",$INV) + ")"
    Dico ("compilato " + $EA + ": " + $Compilato) "Green"

    # -----------------------------------------------------------------
    #  3-bis. LA CACHE DEL TESTER, COI DUE CONTEGGI (punto 46 + classe
    #  cache-hit-per-costruzione del 31/08). Qui NON e' una precauzione
    #  generica: il CSV di questa famiglia nasce dai FRAME, e un pass
    #  ripescato dalla cache non chiama OnTester(), quindi non manda
    #  nessun frame e non ha nessuna riga nel CSV. Il risultato non
    #  sarebbe un numero vecchio: sarebbe una RIGA CHE SPARISCE, con la
    #  corsa verde. Si svuota SOLO Tester\cache, MAI bases\<server>\ticks
    #  (quello e' lo storico, e riscaricarlo costa ore).
    # -----------------------------------------------------------------
    $cacheT = Join-Path $dataFolder "Tester\cache"
    if(Test-Path -LiteralPath $cacheT){
      $ncPrima = @(Get-ChildItem -LiteralPath $cacheT -Recurse -File -ErrorAction SilentlyContinue).Count
      Remove-Item (Join-Path $cacheT "*") -Recurse -Force -ErrorAction SilentlyContinue
      $ncDopo  = @(Get-ChildItem -LiteralPath $cacheT -Recurse -File -ErrorAction SilentlyContinue).Count
      $CacheTxt = "prima " + $ncPrima + " file, dopo " + $ncDopo
      if($ncDopo -gt 0){
        [void]$Problemi.Add("Tester\cache NON si e' svuotata (prima " + $ncPrima + ", dopo " + $ncDopo + "): un pass ripescato dalla cache non chiama OnTester(), non manda il frame e SPARISCE dal CSV. Le righe attese per cella vanno ricontate a mano prima di leggere qualunque numero.")
        Dico ("Tester\cache NON SVUOTATA: " + $CacheTxt) "Red"
      }
      else{ Dico ("Tester\cache svuotata: " + $CacheTxt) "Green" }
    }
    else{
      $CacheTxt = "cartella assente (" + $cacheT + "): niente da svuotare"
      Dico ("Tester\cache: " + $CacheTxt) "Yellow"
    }
  }

  # -------------------------------------------------------------------
  #  4. LE CORSE
  # -------------------------------------------------------------------
  # NIENTE '(if(...))' come argomento: parsa pulito e muore a runtime
  # (classe del 29/08). Il titolo si calcola prima, in una variabile.
  $titolo4 = "4. LE CORSE"
  if($Ricomponi){ $titolo4 = "4. RILETTURA DEI CSV GIA' PRODOTTI (nessuna corsa, per costruzione)" }
  Titolo $titolo4
  $Risultati = Join-Path $Work ("risultati_prove\" + $EA)
  foreach($c in $Ordinate){
    Dico ("cella " + $c.Id + " -- " + $c.Desc) "Cyan"
    $tCella = Get-Date
    if($Ricomponi){
      # NON si chiama il driver generico: in RICOMPOSIZIONE il tester non
      # si apre per costruzione, e $tCella serve solo a datare la lettura.
      $c.Secondi = -1.0
    }else{
      # NON si chiama $args: e' una VARIABILE AUTOMATICA di PowerShell
      # (punto 71). Questo script non usa $args da nessuna parte.
      # E "-Rifai" STA SEMPRE DENTRO L'ARGV, non e' un'opzione: senza, il
      # driver generico trova i CSV del giro prima, stampa "gia' fatto,
      # salto" in grigio, esce 0, e questo wrapper impacchetta numeri
      # VECCHI come freschi. E' la classe che nella saga CRT ha prodotto
      # quattro corse dichiarate eseguite e mai partite (31/08). Chi vuole
      # rileggere usa -Ricomponi, che lo DICE in ogni riga del referto.
      $argv = @("-ExecutionPolicy","Bypass","-File",$drv,
                "-Expert",$EA,
                "-Prova",(Join-Path $Prove $c.Prova),
                "-Etichetta",$c.Id,
                "-Simbolo",$c.Sym,
                "-Periodo",$Periodo,
                "-DaQuando",$DaQuando,
                "-Fino",$Fino,
                "-Modello",("" + $Modello),
                "-Rifai",
                "-Deposito",("" + $Deposito))
      if($SoloControllo){ $argv += "-SoloControllo" }
      $global:LASTEXITCODE = 0
      & powershell $argv
      $rc = $LASTEXITCODE
      $c.Secondi = (New-TimeSpan -Start $tCella -End (Get-Date)).TotalSeconds
      if($rc -ne 0){
        $c.Esito = "FERMATA (codice " + $rc + ")"
        [void]$Problemi.Add("cella " + $c.Id + ": il driver generico e' uscito con codice " + $rc)
        continue
      }
      if($SoloControllo){ $c.Esito = "CONTROLLO OK"; continue }
    }

    $csvIS  = Join-Path $Risultati ($EA + "_" + $c.Sym + "_IS_"  + $c.Id + ".csv")
    $csvOOS = Join-Path $Risultati ($EA + "_" + $c.Sym + "_OOS_" + $c.Id + ".csv")
    $rIS  = LeggiOpt $csvIS
    $rOOS = LeggiOpt $csvOOS
    if($null -eq $rIS -or $null -eq $rOOS){
      # DUE CAUSE DIVERSE, DUE MESSAGGI DIVERSI: "il file non c'e'" e "il
      # file c'e' ma non ha le colonne della sonda" si riparano in due
      # posti opposti, e confonderli fa perdere il giro dopo.
      $mancanti = @()
      foreach($f in @($csvIS,$csvOOS)){ if(-not (Test-Path -LiteralPath $f)){ $mancanti += (Split-Path $f -Leaf) } }
      if(@($mancanti).Count -gt 0){
        $c.Esito = "CSV MANCANTE"
        $perche = ". Storico mancante sul simbolo, MT5 gia' aperto, oppure la cella non e' girata."
        if($Ricomponi){ $perche = ". In RICOMPOSIZIONE vuol dire una cosa sola: QUESTA CELLA NON E' ANCORA STATA GIRATA (o e' stata girata con un PIN diverso, e allora e' stata cancellata). Il cancello C1 d'insieme NON si legge finche' mancano celle." }
        [void]$Problemi.Add("cella " + $c.Id + ": CSV NON PRODOTTO dal tester: " + ($mancanti -join ", ") + $perche)
      }else{
        $c.Esito = "CSV SENZA LE COLONNE DELLA SONDA"
        [void]$Problemi.Add("cella " + $c.Id + ": il CSV c'e' ma NON ha le colonne della sonda (l'.ex5 che ha girato non e' questo EA?). Intestazioni viste: " + ($script:CsvIntestazioni -join " | "))
      }
      continue
    }
    $c.DatiIS  = $rIS
    $c.DatiOOS = $rOOS
    $c.RigheIS  = @($rIS).Count
    $c.RigheOOS = @($rOOS).Count
    $c.Esito = "MISURATA"

    # HA GIRATO IL TESTER, O I CSV ERANO GIA' LI'?
    # In CORSA/RICOGNIZIONE il generico e' chiamato con -Rifai: un CSV
    # piu' VECCHIO dell'inizio della cella non e' piu' una sfumatura da
    # annotare, e' un PROBLEMA -- vuol dire che la passata non e' partita
    # e che questi numeri vengono da un altro giro (classe zombie-run).
    # In RICOMPOSIZIONE la rilettura e' il mestiere, e si DICHIARA con
    # la data del file, che va confrontata con la riga 'data:'.
    $freschi = $true
    $etaCsv = ""
    foreach($f in @($csvIS,$csvOOS)){
      $lw = (Get-Item -LiteralPath $f).LastWriteTime
      if($lw -lt $tCella){ $freschi = $false }
      $etaCsv = $lw.ToString("yyyy-MM-dd HH:mm",$INV)
    }
    if($Ricomponi){
      $c.Fresca = "NO, ED E' IL MESTIERE DI QUESTO MODO: CSV riletti, scritti il " + $etaCsv
      $c.Esito  = "RILETTA (CSV del " + $etaCsv + ")"
    }
    elseif($freschi){ $c.Fresca = "SI (il tester ha girato in questo giro)" }
    else{
      $c.Fresca = "NO (CSV del " + $etaCsv + ": RILETTI, non rimisurati)"
      $c.Esito  = "RILETTA DA CSV GIA' PRESENTI (il tester NON ha girato in questo giro)"
      [void]$Problemi.Add("cella " + $c.Id + ": i CSV sono del " + $etaCsv + ", cioe' PRECEDENTI a questa corsa, e il driver generico e' stato chiamato con -Rifai. La passata NON e' partita (MT5 gia' aperto? terminale sbagliato?) e questi numeri vengono da un ALTRO giro: non si leggono.")
    }

    if($c.RigheIS -ne $c.Celle -or $c.RigheOOS -ne $c.Celle){
      [void]$Problemi.Add("cella " + $c.Id + ": righe nel CSV " + $c.RigheIS + " (IS) / " + $c.RigheOOS + " (OOS), attese " + $c.Celle + " per finestra. E' la CACHE del tester (un pass ripescato non chiama OnTester, non manda il frame e la riga SPARISCE), oppure celle mute.")
    }

    # --- IL CSV NON SI CONTA SOLTANTO: SI GUARDA DENTRO.
    #     Le righe giuste con l'asse sbagliato sono la stessa bugia di
    #     prima, scritta meglio (classe del 31/08, ablazione: "un CSV si
    #     CONTA e deve portare i VALORI dell'asse che ha chiesto").
    foreach($tag in @("IS","OOS")){
      $dati = $rIS
      if($tag -eq "OOS"){ $dati = $rOOS }
      $latoAtteso = 1
      if($c.Lato -eq "SHORT"){ $latoAtteso = -1 }
      $latoStorto = @($dati | Where-Object { $null -eq $_.Lato -or [int]$_.Lato -ne $latoAtteso }).Count
      if($latoStorto -gt 0){
        [void]$Problemi.Add("cella " + $c.Id + " (" + $tag + "): la colonna 'Lato' non vale " + $latoAtteso + " su " + $latoStorto + " passate, ma la cella e' " + $c.Lato + ". Il file prova che ha girato NON e' quello di questa cella, oppure l'.ex5 non e' questo EA.")
      }
      if($c.Id -ne "00_gemelli"){
        $mancano = New-Object System.Collections.ArrayList
        for($h2 = 0; $h2 -le 23; $h2++){
          foreach($d2 in @(4,8,12)){
            $q = @($dati | Where-Object { $null -ne $_.Ora -and [int]$_.Ora -eq $h2 -and $null -ne $_.Durata -and [int]$_.Durata -eq $d2 }).Count
            if($q -ne 1){ [void]$mancano.Add(("" + $h2 + "h/" + $d2 + "h x" + $q)) }
          }
        }
        if(@($mancano).Count -gt 0){
          [void]$Problemi.Add("cella " + $c.Id + " (" + $tag + "): l'asse chiesto (24 ore x 3 durate) NON e' tutto nel CSV. Celle mancanti o doppie: " + (($mancano | Select-Object -First 12) -join ", ") + " (in tutto " + @($mancano).Count + " su 72). Righe giuste con l'asse sbagliato sono numeri di un'altra griglia.")
        }
      }
    }

    # --- I GATE DI COLLAUDO, letti DALLE COLONNE (in ottimizzazione le
    #     Print degli agent non le legge nessuno -- punto 99).
    foreach($tag in @("IS","OOS")){
      $dati = $rIS
      if($tag -eq "OOS"){ $dati = $rOOS }
      $atFail = @($dati | Where-Object { $null -eq $_.Autotest -or [double]$_.Autotest -ne 0 }).Count
      if($atFail -gt 0){
        [void]$Problemi.Add("cella " + $c.Id + " (" + $tag + "): 'Autotest Falliti' diverso da 0 su " + $atFail + " passate. I numeri di questa cella NON si leggono: si guarda il codice.")
      }
      $notti = @($dati | Where-Object { $null -ne $_.Notti -and [double]$_.Notti -gt 0 }).Count
      if($notti -gt 0){
        [void]$Problemi.Add("cella " + $c.Id + " (" + $tag + "): 'Notti Attraversate' > 0 su " + $notti + " passate. La chiusura forzata di fine giornata NON e' stata ermetica su questo simbolo: il mandato 'mai overnight' non e' rispettato e va detto.")
      }
      $salti = @($dati | Where-Object { $null -ne $_.SprSalt -and [double]$_.SprSalt -gt 0 }).Count
      if($salti -gt 0){
        [void]$Problemi.Add("cella " + $c.Id + " (" + $tag + "): 'Giorni Saltati Spread' > 0 su " + $salti + " passate, ma il filtro di spread e' pinnato a 0. Il file prova che ha girato NON e' quello che credevamo.")
      }
      $sotto = @($dati | Where-Object { $null -ne $_.N -and [double]$_.N -lt 150 }).Count
      if($sotto -gt 0){
        [void]$Rilievi.Add("cella " + $c.Id + " (" + $tag + "): " + $sotto + " fasce su " + @($dati).Count + " hanno MENO di 150 giornate operate. Criterio C5: su quelle fasce il MERITO resta sospeso (il RISCHIO no).")
      }
      $stop = @($dati | Where-Object { $null -ne $_.UscStop -and $null -ne $_.N -and [double]$_.N -gt 0 -and ([double]$_.UscStop/[double]$_.N) -gt 0.01 }).Count
      if($stop -gt 0){
        [void]$Rilievi.Add("cella " + $c.Id + " (" + $tag + "): su " + $stop + " fasce lo stop di protezione (10 ATR) o una posizione orfana ha chiuso piu' dell'1% delle operazioni. Lo stop doveva essere un paracadute mai aperto: se morde, la sonda sta misurando anche lo stop.")
      }
    }

    # --- I GEMELLI: solo per la cella 00_gemelli, ed e' li' che il
    #     determinismo del banco si misura. "Una riga sola" NON e'
    #     "gemelli ok": e' uno sweep che non ha spazzolato.
    if($c.Id -eq "00_gemelli"){
      $c.Gemelli = Gemelli $rOOS
      if($c.Gemelli -ne "IDENTICI"){
        [void]$Problemi.Add("cella 00_gemelli: gemelli " + $c.Gemelli + " -- il banco NON e' deterministico, e nessun numero delle altre sei celle si legge.")
      }
      if($Ricomponi){
        $Cronometro = "non pertinente: in RICOMPOSIZIONE non gira nessuna passata, e cronometrare una rilettura di file darebbe un numero plausibile e falso (CHECKLIST 101-bis)."
      }
      elseif($freschi -and $c.Secondi -gt 0){
        $perPassata = $c.Secondi/4.0
        $Cronometro = ([double]$c.Secondi).ToString("0",$INV) + " s per 4 passate = " + ([double]$perPassata).ToString("0",$INV) + " s per passata -> una cella di misura (144 passate) costerebbe circa " + ([double]($perPassata*144.0/60.0)).ToString("0",$INV) + " minuti, e le SEI celle circa " + ([double]($perPassata*864.0/3600.0)).ToString("0.0",$INV) + " ore"
      }elseif(-not $freschi){
        $Cronometro = "NON MISURATO in questo giro: i CSV dei gemelli erano gia' presenti e il driver generico ha saltato il tester. Cronometrare una rilettura di file darebbe un numero plausibile e falso (CHECKLIST punti 50 e 101-bis)."
      }
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
$Cart = Join-Path $Dsk ("SONDA_OROLOGIO_" + $Modo + "_" + $Stamp)
New-Item -ItemType Directory -Force -Path $Cart | Out-Null

$RefTxt = New-Object System.Collections.ArrayList
[void]$RefTxt.Add("=====================================================================")
[void]$RefTxt.Add(" SONDA DELL'OROLOGIO -- " + $EA + " -- EURUSD / GBPUSD / XAUUSD " + $Periodo)
[void]$RefTxt.Add("=====================================================================")
[void]$RefTxt.Add("modo: " + $Modo + "   <- CONTROLLO = giro a vuoto (NON e' il risultato)")
[void]$RefTxt.Add("                      RICOGNIZIONE = solo determinismo e cronometro")
[void]$RefTxt.Add("                      CORSA = la misura")
[void]$RefTxt.Add("                      RICOMPOSIZIONE = NESSUNA corsa: rilettura dei CSV gia' fatti")
[void]$RefTxt.Add("data: " + $Avvio.ToString("yyyy-MM-dd HH:mm:ss",$INV))
[void]$RefTxt.Add("pin:  " + $Pin)
[void]$RefTxt.Add("finestra: " + $DaQuando + " -> " + $Fino + "  (split 40/60)")
[void]$RefTxt.Add("banco: Modello " + $Modello + ", deposito " + $Deposito + ", rischio 1,0% (pinnato nei file prova)")
[void]$RefTxt.Add("terminale: " + $Terminale)
[void]$RefTxt.Add("compilazione: " + $Compilato)
[void]$RefTxt.Add("cache tester: " + $CacheTxt)
[void]$RefTxt.Add("rifai: il driver generico e' chiamato SEMPRE con -Rifai (mai una passata saltata e spacciata per fresca)")
[void]$RefTxt.Add("cronometro: " + $Cronometro)
[void]$RefTxt.Add("")
[void]$RefTxt.Add("QUESTO NON E' UN ROUND E NON DA' NESSUN VERDETTO (criterio C7).")
[void]$RefTxt.Add("La sonda non promuove niente e non tocca nessuna sedia viva:")
[void]$RefTxt.Add("produce la TABELLA qui sotto. Ipotesi e criteri C1-C7 stanno in")
[void]$RefTxt.Add("prove/SONDA_OROLOGIO_FX.txt e si leggono PRIMA della tabella.")
[void]$RefTxt.Add("")
[void]$RefTxt.Add("LE TRE COSE DA SAPERE PRIMA DI LEGGERE UN NUMERO:")
[void]$RefTxt.Add(" 1. ORA SERVER FISSA (criterio C6, scelta FIRMATA). Gli uffici di")
[void]$RefTxt.Add("    Londra e New York si spostano rispetto all'ora server per ~4")
[void]$RefTxt.Add("    settimane l'anno (ora legale USA e UE non coincidenti; il")
[void]$RefTxt.Add("    Giappone non cambia). L'errore c'e', e' noto, NON e' corretto.")
[void]$RefTxt.Add(" 2. IL LORDO E' LA DERIVA SUL BID, non il risultato eseguito: bid")
[void]$RefTxt.Add("    all'ingresso contro bid all'uscita, nei due versi. Lo spread")
[void]$RefTxt.Add("    resta FUORI dalla misura, apposta, perche' il cancello C1 lo")
[void]$RefTxt.Add("    confronta a parte. La media e' sulle GIORNATE OPERATE, non")
[void]$RefTxt.Add("    sulle giornate di calendario.")
[void]$RefTxt.Add(" 3. LA PEGGIOR GIORNATA IN % E' CONDIZIONATA ALLA TAGLIA: il lotto")
[void]$RefTxt.Add("    esce da un rischio dell'1% su uno stop di 10 ATR, quindi e'")
[void]$RefTxt.Add("    piccolo e la percentuale e' piccola con lui. NON e' il rischio")
[void]$RefTxt.Add("    di una versione operabile: quella avrebbe uno stop diverso.")
[void]$RefTxt.Add("")

# --- LA TABELLA. Una per cella e per finestra: 24 ore x 3 durate.
function RigaTabella($dati,[int]$ora){
  $s = ("{0,3} |" -f $ora)
  foreach($d in @(4,8,12)){
    $r = @($dati | Where-Object { $null -ne $_.Ora -and [int]$_.Ora -eq $ora -and $null -ne $_.Durata -and [int]$_.Durata -eq $d })
    if(@($r).Count -ne 1){ $s += "   n/d    n/d  n/d   n/d|"; continue }
    $x = $r[0]
    $s += ("{0,5}{1,8}{2,6}{3,7}|" -f (FmtN $x.N), (Fmt2 $x.LordoPt), (Fmt2 $x.C1), (Fmt2 $x.PegGio))
  }
  return $s
}

foreach($c in $CELLE){
  [void]$RefTxt.Add("---------------------------------------------------------------------")
  [void]$RefTxt.Add("CELLA " + $c.Id + "  --  " + $c.Sym + " " + $c.Lato + "  --  magic " + (($c.Magic) -join "/"))
  [void]$RefTxt.Add("  " + $c.Desc)
  [void]$RefTxt.Add("  esito: " + $c.Esito + "   righe CSV: " + (FmtN $c.RigheIS) + " (IS) / " + (FmtN $c.RigheOOS) + " (OOS), attese " + $c.Celle)
  [void]$RefTxt.Add("  il tester ha girato in questo giro: " + $c.Fresca)
  if($c.Id -eq "00_gemelli"){ [void]$RefTxt.Add("  gemelli: " + $c.Gemelli) }
  if($null -eq $c.DatiIS -and $null -eq $c.DatiOOS){
    [void]$RefTxt.Add("  (nessuna tabella: la cella non ha prodotto CSV in questo giro)")
    [void]$RefTxt.Add("")
    continue
  }
  if($c.Id -eq "00_gemelli"){
    [void]$RefTxt.Add("  (nessuna tabella oraria: qui l'ora e' inchiodata. Questa cella")
    [void]$RefTxt.Add("   collauda il BANCO, non l'orologio.)")
    [void]$RefTxt.Add("")
    continue
  }
  foreach($tag in @("IS","OOS")){
    $dati = $c.DatiIS
    if($tag -eq "OOS"){ $dati = $c.DatiOOS }
    if($null -eq $dati){ continue }
    [void]$RefTxt.Add("")
    [void]$RefTxt.Add("  finestra " + $tag + "   (n = giornate operate | lordo = punti MT5 sul bid | C1 = |lordo|/spread mediano | pegg = peggior giornata %)")
    [void]$RefTxt.Add("  ora |     4 ORE                |     8 ORE                |    12 ORE")
    [void]$RefTxt.Add("      |    n   lordo    C1   pegg|    n   lordo    C1   pegg|    n   lordo    C1   pegg")
    for($h = 0; $h -le 23; $h++){ [void]$RefTxt.Add("  " + (RigaTabella $dati $h)) }
    $sopra = @($dati | Where-Object { $null -ne $_.C1 -and [double]$_.C1 -ge 3.0 })
    [void]$RefTxt.Add("  fasce con C1 >= 3 in questa finestra: " + @($sopra).Count + " su " + @($dati).Count)
    if(@($sopra).Count -gt 0){
      foreach($x in @($sopra | Sort-Object -Property @{Expression={[double]$_.C1}} -Descending | Select-Object -First 6)){
        [void]$RefTxt.Add(("    ora {0,2}  durata {1,2}h  n={2,5}  lordo={3,8}  spread mediano={4,6}  C1={5,5}  giornate positive={6,6}%  ore medie tenuta={7,5}" -f `
          [int]$x.Ora, [int]$x.Durata, (FmtN $x.N), (Fmt2 $x.LordoPt), (Fmt2 $x.SprMed), (Fmt2 $x.C1), (Fmt2 $x.PctPos), (Fmt2 $x.OreTen)))
      }
    }
  }
  [void]$RefTxt.Add("")
}

# --- IL CANCELLO C1, CONTATO E NON GIUDICATO.
[void]$RefTxt.Add("=====================================================================")
[void]$RefTxt.Add(" IL CANCELLO C1 -- contato dal driver, NON adjudicato")
[void]$RefTxt.Add("=====================================================================")
[void]$RefTxt.Add("C1 (congelato): per almeno UNA fascia oraria, su almeno DUE dei tre")
[void]$RefTxt.Add("simboli, |lordo medio per giornata| >= 3 x spread mediano DELLA")
[void]$RefTxt.Add("STESSA ORA. Il rapporto lo calcola l'EA e lo scrive in colonna, cosi'")
[void]$RefTxt.Add("nessuno lo puo' rifare storto in un foglio.")
[void]$RefTxt.Add("")
[void]$RefTxt.Add(">>> IL CRITERIO CONGELATO NON DICE SU QUALE FINESTRA SI LEGGE C1.")
[void]$RefTxt.Add("    Il conto e' riportato per tutte e tre le letture, e la scelta di")
[void]$RefTxt.Add("    quale vale e' di chi firma, non di questo script.")
[void]$RefTxt.Add("")
[void]$RefTxt.Add(">>> E IL CRITERIO E' AMBIGUO SU UN'ALTRA COSA, dichiarata qui invece")
[void]$RefTxt.Add("    che sciolta di nascosto: 'per almeno UNA fascia oraria, su almeno")
[void]$RefTxt.Add("    DUE dei tre simboli' si puo' leggere in due modi.")
[void]$RefTxt.Add("      SEVERA: la STESSA fascia (stessa ora E stessa durata) sopra")
[void]$RefTxt.Add("              soglia su >= 2 simboli. E' un fatto d'insieme.")
[void]$RefTxt.Add("      LARGA : due simboli qualsiasi, ciascuno con una fascia SUA.")
[void]$RefTxt.Add("              Due ore diverse su due simboli diversi passerebbero.")
[void]$RefTxt.Add("    IL VERDETTO QUI SOTTO E' LA LETTURA SEVERA, ed e' una scelta")
[void]$RefTxt.Add("    DICHIARATA: quando un criterio congelato copre lo stesso caso con")
[void]$RefTxt.Add("    due clausole, in questa casa vince la piu' severa -- muovere un")
[void]$RefTxt.Add("    criterio verso il permissivo dopo averlo scritto e' la mossa che")
[void]$RefTxt.Add("    il progetto ha vietato a se stesso (CHECKLIST 31/08).")
[void]$RefTxt.Add("    La lettura LARGA e' stampata accanto, etichettata, perche' e' un")
[void]$RefTxt.Add("    dato utile -- ma NON e' il verdetto.")
$sim = @("EURUSD","GBPUSD","XAUUSD")
# --- QUANTE CELLE DI MISURA HANNO DAVVERO PRODOTTO DATI.
#     Serve al TERZO STATO del cancello, e non e' un dettaglio: senza,
#     una corsa che non ha misurato NIENTE stampava "C1 NON PASSATO",
#     cioe' l'affermazione piu' forte possibile ricavata da zero dati
#     (CHECKLIST punti 68 e 94). "Non ho misurato" e "ho misurato e non
#     passa" sono due cose diverse, e la seconda chiude una pista.
$celleMisurate = @($CELLE | Where-Object { $_.Id -ne "00_gemelli" -and $null -ne $_.DatiIS -and $null -ne $_.DatiOOS }).Count
$simMancanti = New-Object System.Collections.ArrayList
foreach($s in $sim){
  $q = @($CELLE | Where-Object { $_.Sym -eq $s -and $_.Id -ne "00_gemelli" -and $null -ne $_.DatiOOS }).Count
  if($q -eq 0){ [void]$simMancanti.Add($s) }
}
[void]$RefTxt.Add("  celle di misura con dati in questa corsa: " + $celleMisurate + " su 6")
if(@($simMancanti).Count -gt 0){
  [void]$RefTxt.Add("  simboli senza NESSUNA cella misurata: " + ($simMancanti -join ", "))
}
# --- LA FUNZIONE CHE DICE SE UNA FASCIA E' SOPRA SOGLIA IN UNA LETTURA.
#     Sta qui, in un posto solo, perche' la lettura severa e quella larga
#     devono usare LA STESSA regola: due copie della stessa disuguaglianza
#     e' esattamente come divergono i criteri (checklist punto 104).
function FasciaSopra($cella,[int]$ora,[int]$dur,[string]$lettura){
  $xs = @($cella.DatiOOS | Where-Object { $null -ne $_.Ora -and [int]$_.Ora -eq $ora -and $null -ne $_.Durata -and [int]$_.Durata -eq $dur })
  $ys = @($cella.DatiIS  | Where-Object { $null -ne $_.Ora -and [int]$_.Ora -eq $ora -and $null -ne $_.Durata -and [int]$_.Durata -eq $dur })
  $okOos = ($xs.Count -eq 1 -and $null -ne $xs[0].C1 -and [double]$xs[0].C1 -ge 3.0)
  $okIs  = ($ys.Count -eq 1 -and $null -ne $ys[0].C1 -and [double]$ys[0].C1 -ge 3.0)
  if($lettura -eq "IS"){ return $okIs }
  if($lettura -eq "OOS"){ return $okOos }
  return ($okIs -and $okOos)
}

foreach($lettura in @("IS","OOS","ENTRAMBE")){
  # --- LETTURA SEVERA: la STESSA fascia su almeno DUE simboli. E' il
  #     verdetto. Si scorre l'asse (24 ore x 3 durate) e per ogni fascia
  #     si contano i SIMBOLI DISTINTI che la superano.
  $simSevera = New-Object System.Collections.ArrayList
  $fasciaSevera = ""
  for($h3 = 0; $h3 -le 23; $h3++){
    foreach($d3 in @(4,8,12)){
      $qui = New-Object System.Collections.ArrayList
      foreach($s in $sim){
        foreach($c in @($CELLE | Where-Object { $_.Sym -eq $s -and $_.Id -ne "00_gemelli" })){
          if($null -eq $c.DatiIS -or $null -eq $c.DatiOOS){ continue }
          if(FasciaSopra $c $h3 $d3 $lettura){ if(-not $qui.Contains($s)){ [void]$qui.Add($s) } }
        }
      }
      if(@($qui).Count -gt @($simSevera).Count){
        $simSevera = $qui
        $fasciaSevera = "ora " + $h3 + ", durata " + $d3 + "h"
      }
    }
  }
  # --- LETTURA LARGA: quella della v2. Si stampa, NON decide.
  $simLarga = New-Object System.Collections.ArrayList
  foreach($s in $sim){
    $trovato = $false
    foreach($c in @($CELLE | Where-Object { $_.Sym -eq $s -and $_.Id -ne "00_gemelli" })){
      if($null -eq $c.DatiIS -or $null -eq $c.DatiOOS){ continue }
      foreach($x in @($c.DatiOOS)){
        if($null -eq $x.Ora -or $null -eq $x.Durata){ continue }
        if(FasciaSopra $c ([int]$x.Ora) ([int]$x.Durata) $lettura){ $trovato = $true }
      }
    }
    if($trovato){ [void]$simLarga.Add($s) }
  }
  # TRE STATI, non due. "NON MISURATO" non e' una sfumatura: e' la
  # differenza fra "la pista si chiude" e "la corsa non e' finita".
  # Con due simboli gia' sopra soglia il PASSATO e' un fatto anche se
  # manca il terzo -- il criterio ne chiede DUE. Il NON PASSATO invece
  # pretende che tutte e sei le celle abbiano dati.
  $esito = "NON PASSATO"
  if(@($simSevera).Count -ge 2){ $esito = "PASSATO" }
  elseif($celleMisurate -lt 6){ $esito = "NON MISURATO PER INTERO (celle con dati " + $celleMisurate + " su 6: qui NON si legge un 'no')" }
  $elenco = "nessuno"
  if(@($simSevera).Count -gt 0){ $elenco = ($simSevera -join ", ") + " sulla fascia migliore (" + $fasciaSevera + ")" }
  [void]$RefTxt.Add("  lettura " + $lettura.PadRight(8) + " SEVERA (stessa fascia): simboli = " + @($simSevera).Count + " (" + $elenco + ")  ->  C1 " + $esito)
  $elencoL = "nessuno"
  if(@($simLarga).Count -gt 0){ $elencoL = ($simLarga -join ", ") }
  [void]$RefTxt.Add("  lettura " + $lettura.PadRight(8) + " larga  (fasce diverse ammesse, NON e' il verdetto): simboli = " + @($simLarga).Count + " (" + $elencoL + ")")
}
[void]$RefTxt.Add("")
[void]$RefTxt.Add("ATTENZIONE, e vale piu' del conto qui sopra: C1 e' il CANCELLO ZERO,")
[void]$RefTxt.Add("non il verdetto. Restano DUE criteri che questo script NON adjudica")
[void]$RefTxt.Add("e non puo' adjudicare, perche' sono giudizi e non conti:")
[void]$RefTxt.Add("  C2 - LA CELLA NON VALE PERCHE' E' LA PIU' VERDE. Vale solo se e'")
[void]$RefTxt.Add("       quella che la TESI aveva indicato PRIMA: ore europee per EUR,")
[void]$RefTxt.Add("       ore londinesi per GBP, ore americane per USD. Se l'ora verde")
[void]$RefTxt.Add("       NON e' quella prevista, il round e' NEGATIVO anche col numero")
[void]$RefTxt.Add("       positivo. 24 ore x 3 simboli x 2 lati = 144 celle: a caso")
[void]$RefTxt.Add("       qualcuna e' verde.")
[void]$RefTxt.Add("  C3 - ALTOPIANO, NON PICCO: la fascia buona deve avere accanto ORE")
[void]$RefTxt.Add("       ADIACENTI dello stesso segno. Un'ora verde isolata fra due")
[void]$RefTxt.Add("       rosse e' rumore. Si legge scorrendo la colonna 'lordo' delle")
[void]$RefTxt.Add("       tabelle qui sopra, riga per riga.")
[void]$RefTxt.Add("E se la tabella e' PIATTA, l'esito e' VALIDO e va scritto cosi': il")
[void]$RefTxt.Add("caduto D7 (l'ora del fix, chiuso il 22/08) esce CONFERMATO ED ESTESO")
[void]$RefTxt.Add("e la pista dell'orologio si chiude con un numero NOSTRO.")
[void]$RefTxt.Add("")
[void]$RefTxt.Add('IL VERDETTO C1 SI LEGGE SOLO A CELLE COMPLETE. Il criterio congelato')
[void]$RefTxt.Add('chiede DUE DEI TRE SIMBOLI: e'' un criterio DI INSIEME, e questo referto')
[void]$RefTxt.Add('riporta solo le celle di QUESTO giro. Quando le sei celle di misura sono')
[void]$RefTxt.Add('girate, si lancia il blocco 4 della pagina: -Ricomponi (LO STESSO PIN).')
[void]$RefTxt.Add('Quel modo NON apre il tester e NON compila: rilegge i CSV gia'' prodotti,')
[void]$RefTxt.Add('lo dichiara cella per cella con la data del file, e ricalcola C1 sui tre')
[void]$RefTxt.Add('simboli. NON si usa -TutteLeCelle per ricomporre: da oggi -TutteLeCelle')
[void]$RefTxt.Add('RIFA'' DAVVERO tutte le passate (-Rifai sta sempre nell''argv), e sono ore.')
[void]$RefTxt.Add('ATTENZIONE: con un PIN DIVERSO la riga cancella risultati_prove\ e le celle')
[void]$RefTxt.Add('gia'' girate SONO PERSE. Un ri-pin a meta'' round = si ricomincia da capo.')
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
[void]$RefTxt.Add('COME SI RIPRENDE: si riparte dalla pagina righe/RIGA_SONDA_OROLOGIO_DA_MANDARE.md,')
[void]$RefTxt.Add('che e'' l''UNICO posto in cui la riga di lancio esiste (CHECKLIST punto 100).')

$refPath = Join-Path $Cart "REFERTO_SONDA_OROLOGIO.txt"
Set-Content -LiteralPath $refPath -Value ($RefTxt -join "`r`n") -Encoding ASCII
Write-Host ($RefTxt -join "`r`n")

# --- gli artefatti: solo cio' che ha girato, copiato PER NOME.
foreach($f in @("COMPILAZIONE_FALLITA.log")){
  $src = Join-Path $Work $f
  if(Test-Path -LiteralPath $src){ Copy-Item $src -Destination $Cart -Force }
}
foreach($c in $Ordinate){
  $src = Join-Path $Prove $c.Prova
  if(Test-Path -LiteralPath $src){ Copy-Item $src -Destination $Cart -Force }
  foreach($tag in @("IS","OOS")){
    $f = Join-Path $Work ("risultati_prove\" + $EA + "\" + $EA + "_" + $c.Sym + "_" + $tag + "_" + $c.Id + ".csv")
    if(Test-Path -LiteralPath $f){ Copy-Item $f -Destination $Cart -Force }
  }
}
$zip = $Cart + ".zip"
Remove-Item -LiteralPath $zip -Force -ErrorAction SilentlyContinue
Compress-Archive -Path (Join-Path $Cart "*") -DestinationPath $zip -Force
Write-Host ""
Write-Host ("CARTELLA: " + $Cart) -ForegroundColor Green
Write-Host ("ZIP DA MANDARE: " + $zip) -ForegroundColor Green
# L'ELENCO DEGLI "ATTESI" SI GENERA DAI FILE CHE ESISTONO DAVVERO IN
# QUESTO RAMO, mai da una lista costante scritta per il ramo piu' ricco:
# una lista a mano esce rossa su un giro perfettamente verde (classe del
# 31/08, e famiglia 89-ter).
$dentro = @(Get-ChildItem -LiteralPath $Cart -File | Sort-Object Name)
Write-Host ("FILE NELLO ZIP: " + @($dentro).Count) -ForegroundColor Gray
foreach($f in $dentro){ Write-Host ("   " + $f.Name + "   (" + [int]($f.Length/1024) + " KB)") -ForegroundColor Gray }

if($Fatale -ne ""){ Write-Host "ESITO: FERMATO" -ForegroundColor Red; exit 1 }
if($Problemi.Count -gt 0){ Write-Host "ESITO: COMPLETATO CON PROBLEMI" -ForegroundColor Yellow; exit 1 }
Write-Host ("ESITO: " + $Modo + " COMPLETATO") -ForegroundColor Green
exit 0
