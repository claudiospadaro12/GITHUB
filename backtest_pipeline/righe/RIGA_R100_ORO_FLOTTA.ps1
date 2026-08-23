# =====================================================================
#  MARCATORE_RIGA_R100_v1
#  RIGA_R100_ORO_FLOTTA.ps1  --  R100: la misura del RISCHIO di TUTTA
#  la flotta ORO su 22 anni di storico XAUUSD (2004.06.11 -> 2026.06.30)
# ---------------------------------------------------------------------
#  CRITERI: backtest_pipeline\risultati_archivio\R100_CRITERI.md
#  >>> Sono i criteri FIRMATI di R99 il 23/08/2026, estesi INVARIATI
#      sedia per sedia. L'ORDINE DI CLAUDIO del 23/08 in chat --
#      "FAI PARTIRE R99 SULLE ALTRE SEDIE ORO" -- E' LA FIRMA
#      DELL'ESTENSIONE, ed e' verbalizzato in R100_CRITERI.md par. 0.
#      Questa riga NON cambia i criteri: li traduce in file eseguibili,
#      e ogni traduzione e' DICHIARATA (checklist 57).
#
#  DA DOVE NASCE, dichiarato: e' RIGA_R99_ORO_RISCHIO.ps1 (pin 4627627)
#  GENERALIZZATA A N SEDIE. Il punto 9 della checklist dice che una
#  riscrittura non puo' perdere le funzioni di sicurezza del gemello:
#  sono state riportate TUTTE -- guardia MT5/MetaEditor chiusi, download
#  pinnato col marcatore, install dell'include ABTG_PausaGuardian.mqh,
#  [Charts] MaxBars, compilazione DIRETTA con verdetto LastWriteTime +
#  backup datato + ripristino del .mq5 se fallisce, SOSTA SVUOTATA A
#  OGNI GIRO, artefatti in sosta col nome proprio PRIMA dei gate,
#  funzioni sopra il try, MODO nel nome della cartella, log letti A
#  OFFSET, \r? davanti a ogni $ multilinea, cultura INVARIANTE,
#  raccolta SEMPRE.
#
#  ------------------------------------------------------------------
#  IL BUG CHE QUESTA RIGA NASCE PER NON RIPETERE.
#  Nella corsa R99 del 23/08 il criterio B (PEGGIOR GIORNATA) e' uscito
#  NON MISURATA ed e' stato recuperato A MANO dal report nello zip.
#  DIAGNOSI, misurata sul file vero (passo0_report_singola.htm, UTF-16,
#  terminale in ITALIANO): l'intestazione della tabella dei deal e'
#    Ora | Affare | Simbolo | Tipo | Direzione | Volume | Prezzo |
#    Ordine | Commissioni | Swap | Profitto | Bilancio | Commento
#  Il parser cercava 'profit'/'profitto' (TROVATO) e 'balance'/'saldo'
#  (NON TROVATO: MT5 in italiano scrive **BILANCIO**). Con l'indice del
#  saldo a -1 tornava una lista vuota, e il chiamante scriveva
#  'NON MISURATA' -- il comportamento onesto, su una tabella
#  perfettamente leggibile. UNA PAROLA MANCANTE.
#  E un SECONDO difetto che il primo teneva nascosto: la somma di
#  giornata usava il solo PROFITTO, mentre COMMISSIONI e SWAP sono
#  colonne separate. Il netto e' Profitto+Commissioni+Swap: col solo
#  lordo la peggior giornata usciva MIGLIORE del vero, e in un round di
#  RISCHIO l'errore nella direzione comoda e' il peggiore.
#  Qui sono corretti tutti e due (funzione LeggiDeal), ed e' il calcolo
#  fatto a mano il 23/08, replicato: somma per giornata di
#  Profitto+Commissioni+Swap, percentuale sul Bilancio di inizio
#  giornata, minimo.
#  ------------------------------------------------------------------
#
#  ------------------------------------------------------------------
#  LA COSA CHE COMANDA IL DISEGNO: NESSUNO DI QUESTI EA ESPORTA IL
#  PER-TRADE. L'unico FileWrite e' quello di OnTesterDeinit (blocco
#  OPTFRAME), che scrive OptResults_<EA>_<Simbolo>.csv e SOLO in
#  ottimizzazione. Quindi i numeri si leggono da TRE artefatti diversi,
#  e ognuno e' dichiarato (criteri R99 par. 5.2, estesi):
#    - OptResults (ottimizzazione a 2 celle gemelle) -> n, DD, PF,
#      profitto, e i GEMELLI IDENTICI AL CENTESIMO
#    - log del tester della passata SINGOLA (InpVerbose=true) -> la
#      data della PRIMA OPERAZIONE (marcatore preso DAL SORGENTE di
#      OGNI EA: sono dodici marcatori diversi, tabella $SEDIE)
#    - report .htm della stessa passata -> la PEGGIOR GIORNATA e, come
#      SECONDA misura indipendente, di nuovo la prima data
#  >>> E DUE SEDIE HANNO UN QUARTO STRUMENTO: ABTG_PunteLarry e
#      ABTG_PTE hanno l'OPTFRAME ESTESO, con la colonna
#      'Peggior Giornata %' calcolata DENTRO l'EA. Su quelle due il
#      criterio B esce DUE VOLTE, da due strumenti indipendenti, e il
#      referto le stampa tutte e due. Non e' un doppione: e' l'unico
#      controllo incrociato che abbiamo sul metodo del criterio B.
#  ------------------------------------------------------------------
#
#  COSA FA, in ordine, e DA SOLA:
#    0. si rifiuta di partire se MT5 O MetaEditor sono aperti
#    1. scarica AL PIN report\CONTRATTI_SEDIE.md e scarica_storico.ps1
#    2. PASSO 0-A UNA VOLTA SOLA: barre M1 + H1/H2/H4/D1 di XAUUSD dal
#       2004.06.11, -SenzaTick. Il simbolo e' lo stesso per tutte le
#       dodici sedie: scaricarlo dodici volte sarebbe tempo buttato.
#    3. POI, UNA SEDIA ALLA VOLTA (mai in parallelo), per ognuna:
#       a. scarica il SUO file prova e il SUO sorgente, col gate di
#          versione e la rilettura della cella riga per riga
#       b. estrae il SUO DD promesso da CONTRATTI_SEDIE.md -- PER
#          COLONNA, non con un regex largo (vedi funzione DDPromesso)
#       c. compila il SUO .mq5
#       d. PASSO 0-B: una passata SINGOLA su tutta la finestra
#       e. PASSO 0-C: due passate GEMELLE su tutta la finestra
#       f. i tre gate, e poi le 4 finestre di regime + le 2 diagnostiche
#    4. raccolta SEMPRE: cartella sul Desktop + zip, con LA TABELLA
#       MADRE (sedia | rischio | DD promesso | DD misurato | 2x? |
#       peggior giornata | verdetto corsia RISCHIO).
#
#  RIPRESA ATTIVA: una sedia con tutti i CSV gia' presenti viene
#  SALTATA e DICHIARATA (e la data del file finisce nel referto: un CSV
#  di ieri non e' un risultato di oggi). -Rifai li rifa'.
#  -SoloSedia S03 fa una sedia sola.
#
#  QUELLO CHE NON FA, dichiarato:
#    - non promuove e non boccia niente per MERITO (Emendamento regola
#      B: il VECCHIO giudica il RISCHIO). Nessun PF entra in nessun
#      verdetto.
#    - non tocca nessuna sedia viva: gira su magic VERGINI del blocco
#      78xxxx (verificato: ZERO occorrenze in tutto il repo). Sono
#      vietati e controllati nel codice TUTTI i magic vivi dell'oro,
#      i due di R99 (7799xx) e la collisione 770901.
#    - non scarica tick e non svuota bases\<server>\ticks
#    - non ammazza un lavoro in corso allo scadere di -OreMax: smette
#      solo di iniziarne di nuovi (checklist 19)
#    - NON MISURA LO SPREAD e non inventa nessun numero non letto in un
#      artefatto.
#
#  QUANTO CI METTE: [STIMA] R99 ha fatto UNA sedia (9 passate su 22
#  anni) in pochi minuti, con lo scarico delle barre M1 dentro la prima
#  passata. Qui le sedie sono 12 e le barre si scaricano una volta
#  sola: l'ordine di grandezza atteso e' 2-6 ore, non 20 minuti e non
#  due giorni. -OreMax e' 20 (tetto sull'INIZIO di nuovi lavori), con
#  margine largo apposta: il tetto non deve tagliare il round, deve
#  solo impedirgli di girare per sempre.
#
#  LA RIGA CHE SI INCOLLA (blocco INTERO, un comando solo - checklist 21).
#  <PIN> = il commit che contiene QUESTO file: e' l'hash dato in chat.
#
#  & { $ErrorActionPreference='Stop'; [Net.ServicePointManager]::SecurityProtocol=[Net.SecurityProtocolType]::Tls12;
#      if(Get-Process terminal64,metaeditor64 -EA SilentlyContinue){ throw 'MT5 O METAEDITOR APERTO: chiudili e rilancia.' };
#      $pin='<PIN>'; $p="$env:USERPROFILE\RIGA_R100.ps1"; Remove-Item $p -EA SilentlyContinue;
#      irm "https://raw.githubusercontent.com/claudiospadaro12/GITHUB/$pin/backtest_pipeline/righe/RIGA_R100_ORO_FLOTTA.ps1" -OutFile $p;
#      if(-not (Select-String -Path $p -SimpleMatch -Pattern 'MARCATORE_RIGA_R100_v1' -Quiet)){ throw 'SCRIPT VECCHIO' };
#      $global:LASTEXITCODE=0; & $p -Pin $pin; if($LASTEXITCODE -ne 0){ Write-Host 'ESITO: PARZIALE O FERMO - leggi il REFERTO' } }
#
#  GIRO A VUOTO (pochi minuti, nessuna passata, nessun MT5 che opera):
#    ... & $p -Pin $pin -SoloControllo
#  Il giro a vuoto scrive e verifica GLI STESSI .ini che girano nella
#  corsa vera. Non c'e' un secondo artefatto (checklist 33).
#  >>> E NON MISURA NESSUN NUMERO: senza tester non esiste nessun DD,
#      nessun n, nessuna giornata. Sta scritto anche nel suo referto,
#      perche' non lo si scambi per il round.
# =====================================================================
param(
  # -Pin NON ha default: un default silenzioso ("lavoro") farebbe girare la
  #  punta del branch spacciandola per un commit congelato. Meglio morire.
  [string]$Pin        = "",
  [double]$OreMax     = 20.0,      # oltre questo NON si iniziano nuovi lavori
  [switch]$Rifai,                  # rifa' anche cio' che e' gia' presente
  [switch]$SoloControllo,
  [switch]$SenzaStorico,           # salta SOLO il PASSO 0-A (le barre)
  [string]$SoloSedia  = "",        # es. "S03": fa una sedia sola
  [switch]$SaltaPasso0             # SOLO per riprendere una coda gia' gatata.
                                   #   Se lo usi, il referto lo scrive in rosso
                                   #   E i tre gate NON ci sono.
)
$ErrorActionPreference = "Stop"
[Threading.Thread]::CurrentThread.CurrentCulture   = [Globalization.CultureInfo]::InvariantCulture
[Threading.Thread]::CurrentThread.CurrentUICulture = [Globalization.CultureInfo]::InvariantCulture
[Net.ServicePointManager]::SecurityProtocol = [Net.SecurityProtocolType]::Tls12
$INV = [Globalization.CultureInfo]::InvariantCulture

$Avvio = Get-Date
$Stamp = $Avvio.ToString("yyyyMMdd_HHmm", $INV)
$Dsk   = Join-Path $env:USERPROFILE "Desktop"
$Work  = Join-Path $env:USERPROFILE "abtg_r100"
$Prove = Join-Path $Work "prove"
$Logs  = Join-Path $Work "log_r100"
$SrcDir= Join-Path $Work "src_motori"
$RawPin= "https://raw.githubusercontent.com/claudiospadaro12/GITHUB/$Pin"

$Sym      = "XAUUSD"
$DaQuando = "2004.06.11"      # MISURATO: sonda del 17/08, XAUUSD 22,1 anni
$Fino     = "2026.06.30"      # scritto nel CRITERIO A
$Modello  = 1                 # OHLC M1 -- criterio par. 4 di R99, esteso.
                              #  I tick reali di BCM partono dal 2024.07.05:
                              #  su 22 anni NON ESISTONO. Il numero che esce
                              #  e' un LIMITE INFERIORE del rischio, mai un
                              #  permesso.
$Deposito = 100000            # taglia prop, come R99 e i round per-trade.
                              #  A rischio percentuale il DD% e' ~indipendente
                              #  dal deposito; il deposito grande evita che il
                              #  lotto minimo schiacci il rischio nei primi
                              #  anni, con l'oro a 400 dollari.
$SpreadIni= 0                 # 0 = spread CORRENTE, ma SCRITTO nell'ini invece
                              #  che lasciato allo stato nascosto del terminale.
                              #  NON e' uno stress di spread e NON e' una misura.
$Suffisso = "_ohlc"           # regola di casa: un OHLC non deve nemmeno poter
                              #  finire nella stessa tabella di un tick reale
$CelleAttese = 2              # le due passate GEMELLE di controllo

#--- I GATE DEL PASSO 0 (criteri R99 par. 5 e 5.1, estesi)
$LimiteG2     = "2005.12.31"  # la prima operazione deve cadere entro questa data
$LimiteFatale = "2010.01.01"  # oltre questa la SEDIA si dichiara NON MISURABILE
                              #  e la corsa passa ALLA SEGUENTE: senza il 2008 e
                              #  senza il 2013 la domanda del round non ha piu'
                              #  senso su quella sedia.
                              #  >>> DIFFERENZA DICHIARATA rispetto a R99: li'
                              #      questo caso fermava TUTTO, perche' la sedia
                              #      era una sola. Qui fermare tutto vorrebbe
                              #      dire che una sedia storta porta via anche
                              #      le altre undici. Il FATALE resta FATALE,
                              #      ma e' PER SEDIA. Scritto nei criteri
                              #      R100 par. 3.

#--- I MAGIC VIETATI: TUTTI i magic vivi noti dell'oro, i due blocchi gia'
#    usati e la collisione misurata il 22/08. Il magic non cambia il
#    comportamento dell'EA -- e' l'etichetta degli ordini e qui l'asse
#    gemello -- ma un magic vivo in un ini e' comunque da fermare.
$MagicVietati = @(970901,770901,970301,971001,971501,771501,770801,771301,
                  771401,770301,770401,770402,772343,250604,770921,770922,
                  770923,770924,770925,779910,779911,779912,779001)

# =====================================================================
#  LE DODICI SEDIE ORO. Ogni riga e' UNA sedia, col suo file prova, il
#  suo sorgente, i suoi input, il suo marcatore di log.
#
#  >>> DA DOVE VIENE OGNI COLONNA (criteri R100 par. 2):
#      - Ea / Ver / MarkSrc / MarkLog : LETTI NEL SORGENTE al pin
#      - MagicVivo / Risk / Commento  : GRUPPO 1 = MISURATI nel censimento
#        .chr del 19/08/2026 15:34; GRUPPO 2 = default del sorgente,
#        [DA CONFERMARE] -- e per il GRUPPO 2 il rischio 1,00% e' una
#        TAGLIA DI RIFERIMENTO DICHIARATA, non una misura.
#      - Par / Vive : MISURATI sul file prova, non ricordati
#      - Base       : la base dei magic VERGINI 78xxxx di questa sedia
#      - TipoLog    : MERCATO = l'EA logga l'ESECUZIONE; PENDENTE = logga
#        il PIAZZAMENTO dell'ordine, che PUO' PRECEDERE il deal. Serve al
#        confronto fra le due misure del gate 1: su una sedia PENDENTE
#        "log piu' vecchio del report" non e' un difetto, e' il mestiere.
# =====================================================================
function S($id,$ea,$ver,$tf,$magicVivo,$magicSrc,$risk,$commento,$base,$par,$vive,$grp,$markSrc,$markLog,$tipoLog){
  return [pscustomobject]@{
    Id=$id; Ea=$ea; Ver=$ver; Tf=$tf; MagicVivo=$magicVivo; MagicSrc=$magicSrc; Risk=$risk;
    Commento=$commento; Base=$base; Par=$par; Vive=$vive; Gruppo=$grp;
    MarkSrc=$markSrc; MarkLog=$markLog; TipoLog=$tipoLog;
    # --- i risultati, riempiti durante la corsa
    Esito="NON ESEGUITA"; Minuti=0.0;
    DDLungo=-1.0; N=-1; NReport=-1; Profit=0.0; PF=0.0;
    Gemelli="NON MISURATO"; Finestra="NON MISURATA";
    PrimaDataLog="NON MISURATA"; PrimaDataReport="NON MISURATA";
    PrimaDataUsata="NON MISURATA"; FonteData="nessuna";
    PeggiorGiornata="NON MISURATA"; PeggiorGiornataPct=99.9;
    PeggiorGiornataEA="n/d";
    ContrRiga="NON CERCATA"; ContrDD=-1.0; ContrStato="NON LETTO";
    Verdetto="NON MISURABILE"; Note2=@();
    Fin=@{}
  }
}

#  >>> ATTENZIONE ALLA COLONNA 'magicSrc', ED E' UN DIFETTO TROVATO
#      VERIFICANDO LA TABELLA CONTRO I SORGENTI PRIMA DI LANCIARE.
#      Il gate di versione controlla che il sorgente dichiari il magic
#      giusto. Ma su DUE sedie il magic VIVO **non e'** il default del
#      sorgente, e non e' un errore: e' il segno che quella sedia e' un
#      SECONDO grafico dello stesso EA.
#        S02 ABTG_MaxMinNotte : sorgente 770401 (= MAXMIN EURUSD), vivo 770402
#            -- e report/VIVAIO_ORO_DEPLOY.md lo scrive a caratteri cubitali:
#            "MAI 770401 (e' del MAXMIN EURUSD!)"
#        S03 ABTG_PunteLarry  : sorgente 772301, vivo 772343 (LARRY ORO,
#            una delle sei sedie del vivaio R38/R39)
#      Col magic VIVO nel gate, quelle due sedie sarebbero morte al
#      controllo su un sorgente sano. Il gate usa 'magicSrc'; 'magicVivo'
#      resta l'identita' della sedia (nome del file prova, riga del
#      contratto, referto). E DOVE I DUE DIFFERISCONO il referto lo dice:
#      e' anche il motivo per cui quelle due celle NON possono essere i
#      default del sorgente, e infatti sono MISURATE su un artefatto di
#      deploy.
$SEDIE = @(
  #   id     EA                                          ver    TF   magicVivo magicSrc risk  commento          base   par vive g  markSrc                                    markLog                                         tipoLog
  (S "S01" "ABTG_EMA200_Ottimizzato"                   "1.00" "H4" "971501" "971501" "1.0" "EMA200 OTT"        780100  43  46 1 '%s LIMIT %s @ %s SL %s TP %s lot %.2f'     '\[EMA200\]\s+(BUY|SELL)\s+LIMIT'               "PENDENTE"),
  (S "S02" "ABTG_MaxMinNotte"                          "1.10" "H2" "770402" "770401" "1.0" "MAXMIN ORO"        780200  52  55 1 'BUY STOP @ %.2f SL %.2f TP %.2f lot %.2f'  '\[MaxMinNotte\]\s+(BUY|SELL)\s+STOP\s+@'       "PENDENTE"),
  (S "S03" "ABTG_PunteLarry"                           "1.00" "H1" "772343" "772301" "1.0" "LARRY ORO"         780300  20  23 1 'PENDENTE %s %s @ %s'                       '\[LARRY\]\s+PENDENTE\s'                        "PENDENTE"),
  (S "S04" "ABTG_SupertrendReversal_Multi_Ottimizzato" "1.00" "H4" "971001" "971001" "1.0" "STREV MULTI OTT"   780400  42  45 2 '%s mercato %.2f lot'                       '\[STReversal\]\s+(LONG|SHORT)\s+mercato'       "MERCATO"),
  (S "S05" "ABTG_GoldenCross_Ottimizzato"              "2.00" "H1" "970301" "970301" "1.0" "GOLDENCROSS OTT"   780500  53  56 2 '%s a mercato @ %.2f SL %.2f TP %.2f lot'   '\[GoldenCross\]\s+(LONG|SHORT)\s+a mercato @'  "MERCATO"),
  (S "S06" "ABTG_SupertrendReversal"                   "1.00" "H4" "770901" "770901" "1.0" "STREV"             780600  44  47 2 '%s mercato %.2f lot'                       '\[STReversal\]\s+(LONG|SHORT)\s+mercato'       "MERCATO"),
  (S "S07" "ABTG_SupertrendReversal_Multi"             "1.00" "H4" "771001" "771001" "1.0" "STREV MULTI"       780700  42  45 2 '%s mercato %.2f lot'                       '\[STReversal\]\s+(LONG|SHORT)\s+mercato'       "MERCATO"),
  (S "S08" "ABTG_EMA200"                               "1.00" "H4" "771501" "771501" "1.0" "EMA200"            780800  43  46 2 '%s LIMIT %s @ %s SL %s TP %s lot %.2f'     '\[EMA200\]\s+(BUY|SELL)\s+LIMIT'               "PENDENTE"),
  (S "S09" "ABTG_GoldenCross"                          "2.00" "H1" "770301" "770301" "1.0" "GOLDENCROSS"       780900  59  62 2 '%s a mercato @ %.2f SL %.2f TP %.2f lot'   '\[GoldenCross\]\s+(LONG|SHORT)\s+a mercato @'  "MERCATO"),
  (S "S10" "ABTG_SupertrendInvert"                     "1.00" "H1" "770801" "770801" "1.0" "STINVERT"          781000  46  49 2 '%s @ %s SL %s lot %.2f'                    '\[STInvert\]\s+(LONG|SHORT)\s+@'               "MERCATO"),
  (S "S11" "ABTG_PTE"                                  "1.01" "H4" "771301" "771301" "1.0" "PTE"               781100  44  47 2 '%s @ %s SL %s TP %s lot %.2f'              '\[PTE\]\s+(LONG|SHORT)\s+@'                    "MERCATO"),
  (S "S12" "ABTG_WOL"                                  "1.00" "D1" "771401" "771401" "1.0" "WOL"               781200  40  43 2 '%s @ %s SL %s TP %s lot %.2f'              '\[WOL\]\s+(LONG|SHORT)\s+@'                    "MERCATO")
)

# --- LE FINESTRE. Le quattro di regime sono AGLI ATTI: prova_regime.ps1
#     righe 69-75, le stesse di R50/R56/R59 e di R99. Le due dell'oro
#     sono DIAGNOSTICHE e NON sono criteri (R99 par. 8.1).
#     Lo scarto sul magic (+0, +10, ...) si somma alla Base della sedia.
$FINESTRE = @(
  @("ORSO",     "2022.01.01","2022.10.31", 20, $true,  "CRITERIO C - finestra ORSO (R50/R56/R59)"),
  @("CROLLO",   "2020.02.01","2020.04.30", 30, $true,  "CRITERIO C - finestra CROLLO (3 mesi: e' la meta' che l'Emendamento 2 assegna al RISCHIO)"),
  @("TORO",     "2021.01.01","2021.12.31", 40, $true,  "CRITERIO C - finestra TORO (R50/R56/R59)"),
  @("LATERALE", "2019.01.01","2019.12.31", 50, $true,  "CRITERIO C - finestra LATERALE (R50/R56/R59)"),
  @("ORO2008",  "2008.07.01","2008.12.31", 60, $false, "DIAGNOSTICA - il crollo dell'ottobre 2008   <<< NON E' UN CRITERIO"),
  @("ORO2013",  "2013.03.01","2013.06.30", 70, $false, "DIAGNOSTICA - il crollo dell'aprile 2013    <<< NON E' UN CRITERIO")
)

# =====================================================================
#  TUTTO CIO' CHE LA RACCOLTA USA NASCE QUI, PRIMA DEL try
#  (checklist 41-bis), FUNZIONI COMPRESE (checklist 48: in PowerShell una
#  `function` non e' dichiarativa, e' un'istruzione: se il flusso non ci
#  passa sopra, il nome non esiste e la raccolta esplode proprio nella
#  corsa fermata da un gate).
# =====================================================================
$Risultati = Join-Path $Work "risultati_prove"
$Sosta     = Join-Path $Work "sosta"
$Problemi  = New-Object System.Collections.ArrayList
$Note      = New-Object System.Collections.ArrayList
$Fatale    = ""
$Storico   = @{ Eseguito=$false; Esito="NON ESEGUITO" }
$ContrTesto= ""
$script:DealIntestazioni = @()
$script:DealColonne      = "NON LETTE"

function Ora(){ return (Get-Date).ToString("HH:mm:ss", $INV) }
function Dico($t,$c="Gray"){ Write-Host ("[" + (Ora) + "] " + $t) -ForegroundColor $c }
function Titolo($t){ Write-Host ""; Write-Host ("=== " + $t + " ===") -ForegroundColor Cyan }

function Scarica($url,$dest,$marcatore){
  Remove-Item -LiteralPath $dest -Force -ErrorAction SilentlyContinue
  Invoke-WebRequest -Uri $url -OutFile $dest -UseBasicParsing -ErrorAction Stop
  if(-not (Test-Path -LiteralPath $dest)){ throw ("scarico fallito: " + $url) }
  if($marcatore -ne "" -and -not (Select-String -LiteralPath $dest -SimpleMatch -Pattern $marcatore -Quiet)){
    throw ("file scaricato SENZA il marcatore '" + $marcatore + "': " + $url)
  }
}

function RigheVive($p){
  return @(Get-Content -LiteralPath $p | Where-Object { $_ -notmatch '^\s*#' -and $_ -notmatch '^\s*$' })
}
function ValoreDi($riga){
  $resto = $riga.Substring($riga.IndexOf("=")+1)
  return (($resto -split '\|\|')[0]).Trim()
}
function NomeDi($riga){
  if($riga -match '^@'){ return ($riga -split '\s+')[0] }
  return (($riga -split '=')[0]).Trim()
}
#  un numero NON MISURATO si scrive "n/d", non "-1.00": un meno uno in una
#  colonna di percentuali si legge come un numero (checklist 47, il lato del
#  rumore) e nel referto di un round di RISCHIO sarebbe il peggior refuso
#  possibile.
function Fmt2($v){
  if($v -eq $null){ return "n/d" }
  if([double]$v -lt 0){ return "n/d" }
  return ([double]$v).ToString("0.00",$INV)
}
function NumInv($s){
  $v = 0.0
  #  MISURATO sul report vero: MT5 scrive le migliaia con lo SPAZIO
  #  ("9 005.54"). Si tolgono tutti gli spazi, compresi i tipografici
  #  (nbsp 160, narrow-nbsp 8239, thin space 8201).
  $t = ("" + $s).Replace([string][char]160,"").Replace([string][char]8239,"").Replace([string][char]8201,"").Replace(" ","").Replace("&nbsp;","").Trim()
  if($t -eq ""){ return $null }
  if([double]::TryParse($t,[Globalization.NumberStyles]::Float,$INV,[ref]$v)){ return $v }
  return $null
}

#  LETTURA DEI LOG A OFFSET (checklist 23-bis): si legge SOLO cio' che e'
#  stato scritto dopo la fotografia. Un file NON cresciuto non si rilegge da
#  capo, altrimenti il "=== FINITO" di ieri sera passa per quello di adesso.
function LeggiNuovo($path,$da){
  $b = $null
  try{
    $fs = [IO.File]::Open($path,[IO.FileMode]::Open,[IO.FileAccess]::Read,[IO.FileShare]::ReadWrite)
    $len = $fs.Length
    if($da % 2 -ne 0){ $da = $da - 1 }
    if($da -ge $len){ $fs.Close(); return "" }
    if($da -gt 0){ [void]$fs.Seek($da,[IO.SeekOrigin]::Begin) }
    $n = [int]($len - $da); $b = New-Object byte[] $n; $letti = 0
    while($letti -lt $n){ $q = $fs.Read($b,$letti,$n-$letti); if($q -le 0){ break }; $letti += $q }
    $fs.Close()
  }catch{ return "" }
  if($b -eq $null -or $b.Count -lt 4){ return "" }
  #  ENCODING SCELTO DAI BYTE, mai per decreto: i log MT5 sono UTF-16LE ma
  #  non sempre col BOM (e leggendo a offset il BOM non c'e' proprio). Un
  #  -Encoding fisso legge byte a caso e la ricerca esce verde per ASSENZA
  #  (checklist 28-bis).
  $utf16 = ($b[0] -eq 0xFF -and $b[1] -eq 0xFE)
  if(-not $utf16){
    $zeri = 0; $n2 = [math]::Min(400,$b.Count)
    for($i=1;$i -lt $n2;$i+=2){ if($b[$i] -eq 0){ $zeri++ } }
    $utf16 = ($zeri -gt ($n2/4))
  }
  if($utf16){ return [Text.Encoding]::Unicode.GetString($b) }
  return [Text.Encoding]::UTF8.GetString($b)
}

#  --- LA DATA SIMULATA DENTRO UNA RIGA DI LOG ---------------------------
#  Le righe dei log agente hanno DUE date nello stesso formato: quella
#  dell'OROLOGIO REALE (con i MILLESIMI) e quella del TESTER (senza).
#  Prendere la prima che capita vorrebbe dire leggere il 2026 di adesso
#  come "prima operazione del 2004". Qui si scartano quelle coi millesimi
#  e si prende l'ULTIMA rimasta prima del marcatore dell'EA.
function DataSimulata($riga,$marcatore){
  $pre = $riga
  $i = $riga.IndexOf($marcatore)
  if($i -gt 0){ $pre = $riga.Substring(0,$i) }
  $best = $null
  foreach($m in [regex]::Matches($pre,'(\d{4}\.\d{2}\.\d{2})\s+(\d{2}:\d{2}:\d{2})(\.\d+)?')){
    if($m.Groups[3].Success){ continue }          # coi millesimi = orologio reale
    $d = [datetime]::MinValue
    if([datetime]::TryParseExact(($m.Groups[1].Value + " " + $m.Groups[2].Value),"yyyy.MM.dd HH:mm:ss",$INV,[Globalization.DateTimeStyles]::None,[ref]$d)){
      $best = $d
    }
  }
  return $best
}

# =====================================================================
#  --- I DEAL DEL REPORT .htm --- LA FUNZIONE CORRETTA
#  Vedi l'intestazione di questo file per la diagnosi del bug di R99.
#  L'intestazione MISURATA (MT5 italiano) e':
#    Ora | Affare | Simbolo | Tipo | Direzione | Volume | Prezzo |
#    Ordine | Commissioni | Swap | Profitto | Bilancio | Commento
#  Il CONTROLLO POSITIVO e' dentro: una riga vale solo se ha una data
#  vera nella colonna Ora E 'in'/'out' nella colonna Direzione. Se non
#  ne riconosce nessuna torna VUOTO, chi chiama scrive "NON MISURATA"
#  -- e adesso dice anche QUALI intestazioni ha visto.
# =====================================================================
function LeggiDeal($path){
  $out = New-Object System.Collections.ArrayList
  $txt = ""
  try{
    $by = [IO.File]::ReadAllBytes($path)
    #  MISURATO: il report della corsa R99 e' UTF-16. Il tentativo UTF8
    #  su byte UTF-16 produce "<\0t\0r\0" e il match su '<t[dr]' fallisce
    #  correttamente, quindi si passa a Unicode. L'ordine NON si cambia.
    $txt = [Text.Encoding]::UTF8.GetString($by)
    if($txt -notmatch '<t[dr]'){ $txt = [Text.Encoding]::Unicode.GetString($by) }
    if($txt -notmatch '<t[dr]'){ $txt = [Text.Encoding]::GetEncoding(1252).GetString($by) }
  }catch{ return @() }
  #  --- 1. tutte le righe ridotte a celle, una volta sola
  $righe = New-Object System.Collections.ArrayList
  foreach($tr in [regex]::Matches($txt,'(?s)<tr[^>]*>(.*?)</tr>')){
    $celle = New-Object System.Collections.ArrayList
    foreach($td in [regex]::Matches($tr.Groups[1].Value,'(?s)<t[dh][^>]*>(.*?)</t[dh]>')){
      $c = $td.Groups[1].Value
      $c = [regex]::Replace($c,'<[^>]+>','')
      $c = $c.Replace("&nbsp;"," ").Replace([string][char]160," ").Trim()
      [void]$celle.Add($c)
    }
    [void]$righe.Add(@($celle))
  }
  #  --- 2. LE COLONNE SI TROVANO NELL'INTESTAZIONE, MAI PER POSIZIONE,
  #      e i sinonimi sono COMPLETI (era 'bilancio' la parola mancante).
  $iOra = -1; $iDir = -1; $iProf = -1; $iSald = -1; $iComm = -1; $iSwap = -1
  $viste = New-Object System.Collections.ArrayList
  foreach($celle in $righe){
    if($celle.Count -lt 8){ continue }
    $o = -1; $dz = -1; $p = -1; $s = -1; $c = -1; $w = -1
    for($i=0; $i -lt $celle.Count; $i++){
      $h = ("" + $celle[$i]).ToLower().Trim()
      if($h -eq "time" -or $h -eq "ora" -or $h -eq "orario"){ $o = $i }
      if($h -eq "direction" -or $h -eq "direzione"){ $dz = $i }
      if($h -eq "profit" -or $h -eq "profitto" -or $h -eq "utile"){ $p = $i }
      if($h -eq "balance" -or $h -eq "saldo" -or $h -eq "bilancio"){ $s = $i }
      if($h -eq "commission" -or $h -eq "commissione" -or $h -eq "commissioni"){ $c = $i }
      if($h -eq "swap"){ $w = $i }
    }
    if($p -ge 0 -or $s -ge 0){ [void]$viste.Add(($celle -join " | ")) }
    if($p -ge 0 -and $s -ge 0){ $iOra=$o; $iDir=$dz; $iProf=$p; $iSald=$s; $iComm=$c; $iSwap=$w; break }
  }
  #  CONTROLLO POSITIVO (checklist 55): senza intestazione riconosciuta NON
  #  si tira a indovinare la posizione. Si torna VUOTO -- e si dice cosa si
  #  e' visto, perche' il 23/08 per scoprire la parola mancante e' servito
  #  aprire lo zip a mano.
  $script:DealIntestazioni = @($viste | Select-Object -First 6)
  if($iProf -lt 0 -or $iSald -lt 0){ return @() }
  if($iOra -lt 0){ $iOra = 0 }        # MISURATO: 'Ora' e' la prima colonna
  $script:DealColonne = ("Ora=" + $iOra + " Direzione=" + $iDir + " Profitto=" + $iProf +
                         " Bilancio=" + $iSald + " Commissioni=" + $iComm + " Swap=" + $iSwap)
  #  --- 3. le righe dei deal, lette PER INDICE DI COLONNA
  $maxi = @($iOra,$iDir,$iProf,$iSald,$iComm,$iSwap | Measure-Object -Maximum).Maximum
  foreach($celle in $righe){
    if($celle.Count -le $maxi){ continue }
    #  MISURATO: la colonna Ora e' 'YYYY.MM.DD HH:MM:SS'
    if($celle[$iOra] -notmatch '^\d{4}\.\d{2}\.\d{2} \d{2}:\d{2}:\d{2}$'){ continue }
    #  la direzione si legge NELLA SUA COLONNA, non scandendo tutte le
    #  celle: un 'in' dentro la colonna COMMENTO farebbe passare per deal
    #  una riga qualunque. MISURATO: i valori sono 'in'/'out' MINUSCOLI e
    #  NON localizzati, anche col terminale in italiano.
    $dir = ""
    if($iDir -ge 0){ $dir = ("" + $celle[$iDir]).ToLower().Trim() }
    else {
      foreach($c in $celle){
        $lc = ("" + $c).ToLower().Trim()
        if($lc -eq "in" -or $lc -eq "out" -or $lc -eq "in/out"){ $dir = $lc }
      }
    }
    if($dir -ne "in" -and $dir -ne "out" -and $dir -ne "in/out"){ continue }
    $d = [datetime]::MinValue
    if(-not [datetime]::TryParseExact($celle[$iOra],"yyyy.MM.dd HH:mm:ss",$INV,[Globalization.DateTimeStyles]::None,[ref]$d)){ continue }
    $pr = (NumInv $celle[$iProf])
    $cm = $null; if($iComm -ge 0){ $cm = (NumInv $celle[$iComm]) }
    $sw = $null; if($iSwap -ge 0){ $sw = (NumInv $celle[$iSwap]) }
    #  IL NETTO: Profitto + Commissioni + Swap. E' il calcolo fatto a mano
    #  il 23/08 per recuperare il criterio B, replicato qui.
    $netto = $null
    if($pr -ne $null){
      $netto = [double]$pr
      if($cm -ne $null){ $netto = $netto + [double]$cm }
      if($sw -ne $null){ $netto = $netto + [double]$sw }
    }
    [void]$out.Add([pscustomobject]@{ Q=$d; Dir=$dir; Profit=$pr; Comm=$cm; Swap=$sw;
                                      Netto=$netto; Saldo=(NumInv $celle[$iSald]) })
  }
  return @($out)
}

# =====================================================================
#  IL DD PROMESSO, ESTRATTO DALL'ARTEFATTO -- PER COLONNA.
#  >>> PERCHE' NON IL REGEX DI R99. R99 cercava la sigla "DD" prima del
#      numero. Sulla riga della SUA sedia funzionava; sulle righe delle
#      altre NO: nella tabella di CONTRATTI_SEDIE.md la colonna si chiama
#      "DD promesso" nell'INTESTAZIONE, e nelle celle c'e' solo il numero
#      ("**5,3%** (R17, cella 250/H2, PF 1,91)"). Un regex ancorato a "DD"
#      su quelle righe NON TROVA NIENTE e stampa "denominatore assente"
#      su un contratto che il numero ce l'ha: sarebbe un rilievo FALSO.
#      Qui si trova l'INDICE della colonna "DD promesso" nell'intestazione
#      della tabella e si legge QUELLA cella.
#  >>> E si prende il PRIMO numero-percentuale della cella, perche' i
#      numeri dopo sono altre cose (PF, Recovery, "superficie 100%
#      positiva"): un regex goloso prenderebbe il 100%.
#  >>> E SE LA CELLA CONTIENE UNA RISCALATURA ("a rischio 0,3%", "a 0,5%
#      = 7,3%") il numero NON si prende: si dichiara AMBIGUO e il 2x
#      resta NON CALCOLABILE, con la riga verbatim nel referto. E' il
#      caso misurato di Gold_Ichimoku. Un denominatore letto alla taglia
#      sbagliata e' peggio di un denominatore mancante.
# =====================================================================
function DDPromesso($testoContratti,$ea,$magicVivo){
  $r = @{ Riga="RIGA NON TROVATA"; DD=-1.0; Stato="RIGA NON TROVATA"; Cella="" }
  $iDD = -1
  foreach($riga in ($testoContratti -split "`r?`n")){
    if($riga -notmatch '^\s*\|'){ continue }
    $celle = @($riga.Trim().Trim('|') -split '\|' | ForEach-Object { $_.Trim() })
    #  --- l'intestazione: da qui in poi l'indice della colonna DD e' noto
    for($i=0;$i -lt $celle.Count;$i++){
      if(("" + $celle[$i]).ToLower() -eq "dd promesso"){ $iDD = $i }
    }
    if($iDD -lt 0){ continue }
    if($celle.Count -le $iDD){ continue }
    #  --- la riga della sedia: nome EA in prima colonna, CON CONFINE
    #      (senza confine "ABTG_EMA200" pescherebbe la riga di
    #      "ABTG_EMA200_Ottimizzato": due sedie diverse), e magic vivo
    #      nella sua colonna quando c'e'.
    $primo = ("" + $celle[0]).Replace("*","").Trim()
    if($primo -notmatch ('^' + [regex]::Escape($ea) + '(\s|\(|$)')){ continue }
    #  >>> IL SIMBOLO, e NON e' un dettaglio. Difetto TROVATO PROVANDO
    #      questa funzione sul file vero prima di scriverla nel driver:
    #      col solo vincolo EA+magic, la sedia S06 (ABTG_SupertrendReversal
    #      XAUUSD, magic di sorgente 770901) pescava la riga del
    #      **SupertrendReversal Nikkei H2 su 225JPY**, che porta lo STESSO
    #      magic 770901 -- la COLLISIONE misurata il 22/08
    #      (CENSIMENTO_FREQUENZA_FLOTTA par. 5). Sarebbe stato un DD
    #      promesso di un ALTRO STRUMENTO usato come denominatore di un
    #      verdetto firmato. La colonna Simbolo (indice 1) chiude il buco.
    if($celle.Count -lt 2 -or ("" + $celle[1]).Trim().ToUpper() -ne "XAUUSD"){ continue }
    if($magicVivo -ne "" -and ($riga -notmatch ('\|\s*' + [regex]::Escape($magicVivo) + '\s*\|'))){ continue }
    $r.Riga  = ([regex]::Replace($riga.Trim(),'[^\x20-\x7E]','.'))
    $r.Cella = ([regex]::Replace(("" + $celle[$iDD]),'[^\x20-\x7E]','.'))
    $r.Stato = "RIGA TROVATA"
    #  --- la riscalatura: se la cella parla di un'ALTRA taglia, il numero
    #      non e' confrontabile e non si prende.
    if($r.Cella -match '(?i)a rischio|a 0,\d|a 0\.\d'){
      $r.Stato = "DD PROMESSO AMBIGUO (la cella contiene una riscalatura di taglia)"
      return $r
    }
    $mm = [regex]::Match($r.Cella,'(\d+[.,]\d+)\s*%')
    if(-not $mm.Success){ $mm = [regex]::Match($r.Cella,'(\d+)\s*%') }
    if($mm.Success){
      $v = NumInv ($mm.Groups[1].Value.Replace(",","."))
      if($v -ne $null -and $v -gt 0){ $r.DD = $v; $r.Stato = "DD PROMESSO ESTRATTO" }
      else { $r.Stato = "DD PROMESSO NON NUMERICO" }
    } else { $r.Stato = "DD PROMESSO NON NUMERICO" }
    return $r
  }
  return $r
}

Write-Host ""
Write-Host "#####################################################################" -ForegroundColor Cyan
Write-Host "#  R100 - LA FLOTTA ORO SU 22 ANNI: LA MISURA DEL RISCHIO           #" -ForegroundColor Cyan
Write-Host "#  XAUUSD, 12 sedie, modello OHLC M1, 2004.06.11 -> 2026.06.30      #" -ForegroundColor Cyan
Write-Host "#####################################################################" -ForegroundColor Cyan
Dico ("pin      : " + $Pin)
Dico ("cartella : " + $Work)

# =====================================================================
#  I NUMERI ATTESI, DICHIARATI PRIMA. Se a fine corsa non tornano,
#  il round non si legge.
# =====================================================================
$Lavoro = @($SEDIE)
if($SoloSedia -ne ""){
  $Lavoro = @($SEDIE | Where-Object { $_.Id -eq $SoloSedia })
  if($Lavoro.Count -eq 0){ Write-Host ("!!! -SoloSedia " + $SoloSedia + " non esiste. Id validi: " + (($SEDIE | ForEach-Object { $_.Id }) -join ", ")) -ForegroundColor Red; exit 1 }
}
$nCrit = @($FINESTRE | Where-Object { $_[4] }).Count
$nDiag = @($FINESTRE | Where-Object { -not $_[4] }).Count
Titolo "NUMERI ATTESI (dichiarati PRIMA della corsa)"
Write-Host ("    sedie ........................  " + $Lavoro.Count + "   (di cui GRUPPO 1 censite: " + @($Lavoro | Where-Object { $_.Gruppo -eq 1 }).Count + ", GRUPPO 2 non censite: " + @($Lavoro | Where-Object { $_.Gruppo -eq 2 }).Count + ")") -ForegroundColor White
Write-Host ("    finestre per sedia ...........  " + $FINESTRE.Count + "   (" + $nCrit + " di REGIME = criterio C, + " + $nDiag + " DIAGNOSTICHE dell'oro)") -ForegroundColor White
Write-Host  "    piu' la finestra INTERA 2004.06.11 -> 2026.06.30 (criterio A), nel PASSO 0" -ForegroundColor White
Write-Host ("    passate per sedia ............  " + (2*$FINESTRE.Count + 3) + "   (" + (2*$FINESTRE.Count) + " di finestra + 2 gemelle intere + 1 SINGOLA intera)") -ForegroundColor White
Write-Host ("    passate TOTALI ...............  " + ($Lavoro.Count * (2*$FINESTRE.Count + 3))) -ForegroundColor White
Write-Host ("    modello ......................  " + $Modello + " = OHLC su M1   <<< i tick su 22 anni NON ESISTONO.") -ForegroundColor White
Write-Host  "                                    Il numero che esce e' un LIMITE INFERIORE del rischio, mai un permesso." -ForegroundColor White
Write-Host ("    deposito .....................  " + $Deposito) -ForegroundColor White
Write-Host ("    spread .......................  Spread=" + $SpreadIni + " nell'ini = spread CORRENTE, dichiarato. NON e' una misura.") -ForegroundColor White
Write-Host ""
Write-Host  "    I TRE NUMERI PER OGNI SEDIA (criteri R99 par. 3, estesi INVARIATI):" -ForegroundColor Yellow
Write-Host  "      A. DD massimo dell'equity su 2004.06.11 -> 2026.06.30, alla taglia di rischio della sedia" -ForegroundColor Yellow
Write-Host  "      B. la PEGGIOR GIORNATA in %  (il muro prop giornaliero e' 5%)" -ForegroundColor Yellow
Write-Host  "      C. il DD massimo dentro ciascuna delle QUATTRO finestre di regime" -ForegroundColor Yellow
Write-Host  "    E UNA SOLA DECISIONE MECCANICA per sedia: se il DD lungo supera il DOPPIO" -ForegroundColor Yellow
Write-Host  "    del DD promesso in CONTRATTI_SEDIE.md -> REVISIONE (corsia RISCHIO, firma" -ForegroundColor Yellow
Write-Host  "    18/08). Il DD promesso lo ESTRAE questa riga dall'artefatto, per colonna." -ForegroundColor Yellow
Write-Host ""
Write-Host  "    >>> QUESTO ROUND NON PROMUOVE E NON BOCCIA NIENTE PER MERITO." -ForegroundColor Yellow
Write-Host  "        Emendamento regola B: il VECCHIO giudica il RISCHIO." -ForegroundColor Yellow
Write-Host ""
Write-Host  "    >>> E UNA SEDIA DICHIARATA E NON MISURATA: Gold_Ichimoku_TK_ATR_EA" -ForegroundColor Yellow
Write-Host  "        XAUUSD 250604 (rischio vivo 0,5%). NON ha il blocco OPTFRAME: non" -ForegroundColor Yellow
Write-Host  "        scrive nessun OptResults, quindi non esistono ne' il DD, ne' il n," -ForegroundColor Yellow
Write-Host  "        ne' il gate dei gemelli. NON e' un via libera: e' un rilievo, ed e'" -ForegroundColor Yellow
Write-Host  "        l'ULTIMA sedia a contratto PARZIALE della flotta." -ForegroundColor Yellow

if($Pin -eq ""){
  Write-Host ""
  Write-Host "!!! MANCA -Pin. Questa riga gira SOLO su un commit congelato." -ForegroundColor Red
  Write-Host "    Rilancia col blocco intero, che passa -Pin <hash>." -ForegroundColor Yellow
  exit 1
}

try{

# =====================================================================
#  0. MT5 E METAEDITOR CHIUSI. Prima di qualunque altra cosa.
#     MT5 aperto = il tester non parte e escono ZERO risultati (checklist 7).
#     MetaEditor e' SINGLE-INSTANCE: se ne gira gia' una copia, il nostro
#     metaeditor64.exe /compile torna SUBITO senza aver compilato
#     (checklist 39).
# =====================================================================
$vivi = @(Get-Process -Name "terminal64","metaeditor64" -ErrorAction SilentlyContinue)
if($vivi.Count -gt 0){
  Write-Host ""
  Write-Host ("!!! APERTO: " + (($vivi | ForEach-Object { $_.ProcessName } | Sort-Object -Unique) -join ", ")) -ForegroundColor Red
  Write-Host "    Non parto: col terminale aperto il tester non gira, e con MetaEditor" -ForegroundColor Red
  Write-Host "    aperto la compilazione torna subito senza compilare." -ForegroundColor Red
  Write-Host "    Chiudi MetaTrader E MetaEditor (tutte le istanze) e rilancia." -ForegroundColor Yellow
  #  DICHIARATO AD ALTA VOCE: questo exit 1 sta DENTRO il try e quindi SALTA
  #  LA RACCOLTA - niente cartella, niente referto, niente zip. Qui e'
  #  accettabile: siamo a due secondi dal lancio, non e' stato prodotto
  #  NIENTE, e non c'e' niente da raccogliere. Il messaggio a schermo E' il
  #  referto di questo caso.
  exit 1
}

# =====================================================================
#  1. TERMINALE E CARTELLA DATI (per NOME, mai il primo che capita)
# =====================================================================
Titolo "1. TERMINALE E CARTELLA DATI"
New-Item -ItemType Directory -Force -Path $Work,$Prove,$Logs,$SrcDir,$Risultati,$Sosta | Out-Null
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
$MqlInclude = Join-Path $DataFolder "MQL5\Include"
$MqlFiles   = Join-Path $DataFolder "MQL5\Files"
New-Item -ItemType Directory -Force -Path $MqlExperts,$MqlInclude,$MqlFiles | Out-Null
Dico ("terminale : " + $Terminal)
Dico ("dati      : " + $DataFolder + "   (DEVE restare lo stesso in tutti i passi)")

# --- 1-bis. LA SOSTA SI SVUOTA A OGNI GIRO (checklist 56). Il documento
#     PRESCRIVE il giro a vuoto PRIMA della corsa vera: senza questa
#     pulizia gli .ini del giro a vuoto finirebbero nello zip della corsa
#     vera, indistinguibili da quelli veri. Non si perde niente: la sosta
#     e' una copia di lavoro, l'archivio e' la cartella datata sul
#     Desktop, che non si sovrascrive mai (checklist 12).
$nSosta = @(Get-ChildItem -LiteralPath $Sosta -File -ErrorAction SilentlyContinue).Count
if($nSosta -gt 0){
  Get-ChildItem -LiteralPath $Sosta -File -ErrorAction SilentlyContinue | Remove-Item -Force -ErrorAction SilentlyContinue
  $nSostaDopo = @(Get-ChildItem -LiteralPath $Sosta -File -ErrorAction SilentlyContinue).Count
  if($nSostaDopo -gt 0){
    [void]$Problemi.Add("sosta: " + $nSostaDopo + " file su " + $nSosta + " di un giro PRECEDENTE non sono stati cancellati. Possono finire nello zip di questo round spacciandosi per artefatti di adesso: controllare le date dentro lo zip prima di leggerlo.")
  }
  Dico ("sosta svuotata: " + $nSosta + " file di un giro precedente rimossi (rimasti: " + $nSostaDopo + ")") "Green"
}

# --- 1a. L'INCLUDE CHE NESSUN DRIVER INSTALLA (checklist 33-bis).
#     TUTTI E DODICI gli EA fanno #include <ABTG_PausaGuardian.mqh>
#     (verificato negli #include di ognuno): senza questa riga la
#     compilazione fallisce e il round muore alla prima passata.
#     Pagato due volte (21/08 e 22/08).
#     NOTA: nel tester il Guardian e' FAIL-OPEN TOTALE (le sue
#     GlobalVariable non esistono li'): non cambia una virgola del backtest.
$mqh = Join-Path $MqlInclude "ABTG_PausaGuardian.mqh"
Scarica ("$RawPin/mql5/Include/ABTG_PausaGuardian.mqh") $mqh 'ABTG_GuardiaIngresso'
$vfy = Get-Item -LiteralPath $mqh
if($vfy.PSIsContainer){ throw "ABTG_PausaGuardian.mqh: in Include c'e' una CARTELLA con quel nome (checklist 27-ter)." }
if($vfy.Length -lt 4000){ throw ("ABTG_PausaGuardian.mqh e' lungo " + $vfy.Length + " byte: troppo poco, scarico monco.") }
Dico ("include installato: ABTG_PausaGuardian.mqh (" + $vfy.Length + " byte)") "Green"

# --- 1b. IL CENSIMENTO DEI CONTRATTI, scaricato AL PIN: il DD promesso
#     si ESTRAE dall'artefatto, non si scrive a memoria (criteri R99
#     par. 3.1, esteso).
$Contr = Join-Path $Work "CONTRATTI_SEDIE.md"
Scarica ("$RawPin/report/CONTRATTI_SEDIE.md") $Contr 'DD promesso'
$ContrTesto = Get-Content -LiteralPath $Contr -Raw
Copy-Item -LiteralPath $Contr -Destination (Join-Path $Sosta "CONTRATTI_SEDIE_al_pin.md") -Force -ErrorAction SilentlyContinue
Dico ("CONTRATTI_SEDIE.md al pin: " + $ContrTesto.Length + " byte") "Green"

# =====================================================================
#  2. PASSO 0-A -- LE BARRE. UNA VOLTA SOLA PER TUTTE LE SEDIE.
#     Il simbolo e' XAUUSD per tutte e dodici: il tester costruisce le
#     barre H1/H2/H4/D1 dalle M1, quindi la profondita' che MORDE e'
#     quella dell'M1 (checklist 18).
#     >>> NIENTE TICK: il round e' a modello OHLC M1, i tick su 22 anni
#         NON ESISTONO e non si scaricano.
#     >>> E IL M1 QUASI CERTAMENTE NON SARA' "COMPLETO", ed e' ATTESO:
#         scarica_storico.ps1 scrive InpTimeoutSec=120 nel preset, cioe'
#         due minuti per timeframe, e 22 anni di M1 non ci stanno. Per
#         questo il verdetto non-COMPLETO sulla riga M1 finisce nelle
#         NOTE e non nei PROBLEMI (checklist 47): una spia che non puo'
#         che essere rossa non la legge piu' nessuno. Il tester completa
#         da solo mentre gira, e la misura che DECIDE resta la data della
#         prima operazione.
# =====================================================================
if(-not $SoloControllo -and -not $SaltaPasso0 -and -not $SenzaStorico){
  Titolo "2. PASSO 0-A - LE BARRE M1 + H1/H2/H4/D1 DI XAUUSD DAL 2004 (una volta per tutte)"
  $ScStorico = Join-Path $Work "scarica_storico.ps1"
  $t0A = Get-Date
  try{
    Scarica ("$RawPin/backtest_pipeline/scarica_storico.ps1") $ScStorico 'REFERTO STORICO'
    #  >>> ANCHE QUESTO GEMELLO VA PINNATO (difetto 24). <<<
    $stTxt = Get-Content -LiteralPath $ScStorico -Raw
    $stNew = $stTxt -replace '\$EABranch\s*=\s*"lavoro"', ('$EABranch="' + $Pin + '"')
    if($stNew -eq $stTxt){ throw "non sono riuscito a pinnare EABranch in scarica_storico.ps1: riga non trovata" }
    Set-Content -LiteralPath $ScStorico -Value $stNew -Encoding ASCII
    if(-not (Select-String -LiteralPath $ScStorico -SimpleMatch -Pattern ('$EABranch="' + $Pin + '"') -Quiet)){ throw "pin di EABranch NON verificato in scarica_storico.ps1" }
    #  checklist 51: l'ini che quello script passa a terminal64 /config deve
    #  avere [Experts] AllowLiveTrading=false, o aprire MT5 per MISURARE
    #  riarma il profilo del conto vivo.
    if(-not (Select-String -LiteralPath $ScStorico -SimpleMatch -Pattern 'AllowLiveTrading=false' -Quiet)){
      throw "scarica_storico.ps1 NON scrive [Experts] AllowLiveTrading=false nell'ini: aprirebbe il terminale riarmando la flotta sul conto vivo (checklist 51). Mi fermo."
    }
    Dico ("scarica_storico.ps1 PINNATO e con AllowLiveTrading=false verificato") "Green"
    $global:LASTEXITCODE = 0
    & powershell.exe -ExecutionPolicy Bypass -File $ScStorico -Simboli $Sym -Da $DaQuando -Timeframes "M1,H1,H2,H4,D1" -SenzaTick -Auto -TimeoutMin 120 2>&1 |
      Tee-Object -FilePath (Join-Path $Logs "passo0a_storico.txt") | Out-Host
    $Storico.Eseguito = $true
    $Storico.Esito = "eseguito, uscita " + $LASTEXITCODE
    if($LASTEXITCODE -ne 0){
      $che = "errore"
      if($LASTEXITCODE -eq 2){ $che = "TIMEOUT dei 120 minuti: MT5 fermato a meta', il referto storico e' PARZIALE (ma c'e', e lo leggo lo stesso)" }
      [void]$Problemi.Add("PASSO 0-A: scarica_storico.ps1 e' uscito con codice " + $LASTEXITCODE + " -> " + $che + ". Il gate sulla PRIMA OPERAZIONE, sedia per sedia, resta la misura che decide.")
    }
    #  >>> E ANCHE QUI SI GUARDA LA DATA (checklist 23). <<<
    $csvSt = Join-Path $MqlFiles "ABTG_StoricoScaricato.csv"
    if((Test-Path -LiteralPath $csvSt) -and ((Get-Item -LiteralPath $csvSt).LastWriteTime -lt $t0A)){
      [void]$Problemi.Add("PASSO 0-A: il referto storico e' del " +
                          (Get-Item -LiteralPath $csvSt).LastWriteTime.ToString("yyyy-MM-dd HH:mm",$INV) +
                          ", PRIMA dell'avvio di questo passo: e' STANTIO e NON descrive questa corsa. Non lo leggo.")
      $csvSt = ""
    }
    if($csvSt -ne "" -and (Test-Path -LiteralPath $csvSt)){
      Copy-Item -LiteralPath $csvSt -Destination (Join-Path $Sosta "passo0a_storico.csv") -Force -ErrorAction SilentlyContinue
      #  LE COLONNE VERE le scrive ABTG_HistoryDownloader.mq5:
      #    Simbolo,Timeframe,Barre,PrimaDataLocale,PrimaDataServer,Verdetto
      #  'Stato' NON esiste: PowerShell risponderebbe $null in silenzio
      #  (checklist 46-bis).
      $vistoSym = $false
      foreach($r in (Import-Csv -LiteralPath $csvSt)){
        $sy = ("" + $r.Simbolo).Trim().ToUpper()
        if($sy -ne $Sym){ continue }
        $vistoSym = $true
        $verd = ("" + $r.Verdetto).Trim()
        $vv = $verd; if($vv -eq ""){ $vv = "VERDETTO VUOTO" }
        [void]$Note.Add("PASSO 0-A: " + $sy + " " + $r.Timeframe + " | barre " + $r.Barre +
                        " | disco " + $r.PrimaDataLocale + " | broker " + $r.PrimaDataServer + " -> " + $vv)
        #  >>> LA GUARDIA SI SCRIVE AL POSITIVO (checklist 40-ter e 47). <<<
        if($verd -like "MANCA STORICO LOCALE*"){
          [void]$Note.Add("PASSO 0-A: " + $sy + " " + $r.Timeframe + " -> '" + $verd + "' (BENIGNO: c'e' sul server, non ancora sul disco. Il tester si scarica il resto da solo -- ed e' anche il motivo per cui la PRIMA passata puo' durare molto piu' delle altre.)")
        }
        elseif($verd -ne "COMPLETO"){
          $che = "'" + $verd + "'"
          if($verd -eq ""){ $che = "VUOTO (formato del referto cambiato: NON e' stato letto)" }
          $testo = "PASSO 0-A: verdetto NON 'COMPLETO' su " + $sy + " " + $r.Timeframe + " -> " + $che +
                   " | barre " + $r.Barre + " | broker " + $r.PrimaDataServer + " | chiesto dal " + $DaQuando +
                   ".  Il gate sulla PRIMA OPERAZIONE e' la misura che decide."
          if(("" + $r.Timeframe).Trim().ToUpper() -eq "M1"){
            [void]$Note.Add($testo + "  ATTESO: scarica_storico.ps1 da' 120 secondi per timeframe (InpTimeoutSec=120 nel preset) e 22 anni di M1 non ci stanno. NON e' un guasto del round: il tester completa da solo.")
          } else {
            [void]$Problemi.Add($testo)
          }
        }
      }
      if(-not $vistoSym){ [void]$Problemi.Add("PASSO 0-A: nessuna riga per " + $Sym + " nel referto storico.") }
    } else { [void]$Note.Add("PASSO 0-A: ABTG_StoricoScaricato.csv non trovato, referto storico NON letto.") }
  }catch{
    $Storico.Esito = "NON ESEGUITO (" + $_.Exception.Message + ")"
    [void]$Problemi.Add("PASSO 0-A NON ESEGUITO: " + $_.Exception.Message + ". Il gate sulla PRIMA OPERAZIONE resta l'unica misura sulla copertura.")
  }
  Dico ("PASSO 0-A: " + $Storico.Esito) "Gray"
} else {
  $Storico.Esito = "SALTATO (SoloControllo / SaltaPasso0 / SenzaStorico)"
}

#  --- le radici dei log del tester, fotografate a OFFSET
$RadiciLog = @(
  (Join-Path $DataFolder "Tester"),
  (Join-Path $InstDir    "Tester"),
  (Join-Path $env:APPDATA "MetaQuotes\Tester"),
  (Join-Path $DataFolder "MQL5\Logs")
)
function FotografaLog(){
  $h = @{}
  foreach($rad in $RadiciLog){
    if(-not (Test-Path -LiteralPath $rad)){ continue }
    foreach($f in @(Get-ChildItem -LiteralPath $rad -Recurse -Filter "*.log" -File -ErrorAction SilentlyContinue)){ $h[$f.FullName] = $f.Length }
  }
  return $h
}

# =====================================================================
#  3. LA CATENA DELLE SEDIE. UNA ALLA VOLTA. MAI IN PARALLELO.
# =====================================================================
Titolo ("3. LA CATENA - " + $Lavoro.Count + " sedie oro, " + ($FINESTRE.Count + 1) + " finestre ciascuna")
$iS = 0
foreach($sd in $Lavoro){
  $iS++
  $trascorse = (New-TimeSpan -Start $Avvio -End (Get-Date)).TotalHours
  if($trascorse -ge $OreMax -and -not $SoloControllo){
    $sd.Esito = "NON INIZIATA (tetto ore raggiunto)"
    [void]$Problemi.Add("TEMPO SCADUTO prima di " + $sd.Id + " " + $sd.Ea + ": il round NON e' completo. Rilancia: la ripresa salta le sedie gia' fatte.")
    continue
  }
  $tSedia = Get-Date
  Write-Host ""
  Write-Host "==================================================================" -ForegroundColor Cyan
  Write-Host ("  [" + $iS + "/" + $Lavoro.Count + "]  " + $sd.Id + "  " + $sd.Ea) -ForegroundColor Cyan
  Write-Host ("           XAUUSD " + $sd.Tf + "  |  magic vivo " + $sd.MagicVivo + "  |  rischio " + $sd.Risk + "%  |  GRUPPO " + $sd.Gruppo) -ForegroundColor Cyan
  Write-Host "==================================================================" -ForegroundColor Cyan

  $sdFatale = ""
  try{
    # -----------------------------------------------------------------
    #  3a. IL FILE PROVA DI QUESTA SEDIA
    # -----------------------------------------------------------------
    $ProvaFile = Join-Path $Prove ("R100_" + $sd.Ea + "_" + $sd.MagicVivo + ".txt")
    Scarica ("$RawPin/backtest_pipeline/prove/R100_" + $sd.Ea + "_" + $sd.MagicVivo + ".txt") $ProvaFile '@SIMBOLO'
    $Vive = RigheVive $ProvaFile
    if($Vive.Count -ne $sd.Vive){ throw ("file prova: " + $Vive.Count + " righe vive invece di " + $sd.Vive + ": artefatto cambiato.") }
    $ProvaPar = @($Vive | Where-Object { $_ -notmatch '^@' })
    if($ProvaPar.Count -ne $sd.Par){ throw ("file prova: " + $ProvaPar.Count + " parametri invece di " + $sd.Par + ".") }
    $txtProva = Get-Content -LiteralPath $ProvaFile -Raw
    #  --- le tre direttive scritte in DUE posti si CONFRONTANO, non ci si
    #      fida del commento "se cambi qui cambia anche li'" (checklist 33).
    #      >>> OGNI $ DI UNA REGEX MULTILINEA SI SCRIVE \r?$ (checklist 40):
    #          i file arrivano da GitHub con CRLF.
    $m = [regex]::Match($txtProva,'(?m)^@DAQUANDO\s+([0-9]{4}\.[0-9]{2}\.[0-9]{2})')
    if(-not $m.Success -or $m.Groups[1].Value -ne $DaQuando){ throw ("@DAQUANDO non e' " + $DaQuando) }
    $s1 = [regex]::Match($txtProva,'(?m)^@SIMBOLO\s+(\S+)')
    if(-not $s1.Success -or $s1.Groups[1].Value -ne $Sym){ throw ("@SIMBOLO non e' " + $Sym) }
    $p1 = [regex]::Match($txtProva,'(?m)^@PERIODO\s+(\S+)')
    if(-not $p1.Success -or $p1.Groups[1].Value -ne $sd.Tf){ throw ("@PERIODO non e' " + $sd.Tf + " (la sedia gira su quel timeframe)") }
    #  --- il rischio: e' il CRITERIO A, non un dettaglio
    if($txtProva -notmatch ('(?m)^InpRiskPercent=' + [regex]::Escape($sd.Risk) + '\|\|')){ throw ("file prova: InpRiskPercent non e' " + $sd.Risk + ". Con un rischio diverso il numero non e' quello del criterio A.") }
    #  --- il commento della sedia viva
    if($txtProva -notmatch ('(?m)^InpComment=' + [regex]::Escape($sd.Commento) + '\r?$')){ throw ("file prova: InpComment non e' '" + $sd.Commento + "'.") }
    #  --- il magic: coppia VERGINE, e MAI una sedia viva
    $mg = [regex]::Match($txtProva,'(?m)^InpMagic=(\d+)\|\|(\d+)\|\|1\|\|(\d+)\|\|Y\r?$')
    if(-not $mg.Success){ throw "file prova: InpMagic non e' nella forma gemella 'm||m||1||m+1||Y'. Senza quell'asse non esistono le due passate gemelle, e il gate 3 non ha niente da confrontare." }
    $magA = [int]$mg.Groups[2].Value; $magB = [int]$mg.Groups[3].Value
    if($magA -ne ($sd.Base + 10) -or $magB -ne ($sd.Base + 11)){ throw ("file prova: coppia gemella " + $magA + "/" + $magB + " invece di " + ($sd.Base+10) + "/" + ($sd.Base+11)) }
    foreach($v in $MagicVietati){
      if($txtProva -match ('(?m)^InpMagic=' + $v + '\|\|')){ throw ("file prova: usa il magic " + $v + ", che e' di una SEDIA VIVA o di un blocco gia' speso. Fermo tutto.") }
    }
    #  --- e nessun ALTRO asse Y: questa e' UNA cella, non una griglia
    $assiY = @([regex]::Matches($txtProva,'(?m)^(\w+)=[^\r\n]*\|\|\s*[Yy]\s*\r?$') | ForEach-Object { $_.Groups[1].Value })
    if($assiY.Count -ne 1 -or $assiY[0] -ne "InpMagic"){
      throw ("file prova: gli assi spazzolati sono [" + ($assiY -join ", ") + "] invece del solo InpMagic. Piu' di un asse vorrebbe dire una GRIGLIA, e questa e' UNA cella.")
    }
    Dico ("file prova: " + $Vive.Count + " righe vive (" + $ProvaPar.Count + " parametri + 3 direttive), rischio " + $sd.Risk + "%, asse Y = InpMagic " + $magA + "/" + $magB) "Green"

    # -----------------------------------------------------------------
    #  3b. IL SORGENTE E I GATE DI VERSIONE
    # -----------------------------------------------------------------
    $srcMq5 = Join-Path $SrcDir ($sd.Ea + ".mq5")
    Scarica ("$RawPin/mql5/Experts/" + $sd.Ea + ".mq5") $srcMq5 'OptResults_'
    $txtSrc = Get-Content -LiteralPath $srcMq5 -Raw
    $mv = [regex]::Match($txtSrc,'#property\s+version\s+"([^"]+)"')
    if(-not $mv.Success){ throw ($sd.Ea + ".mq5 scaricato senza #property version: non e' il sorgente che credo.") }
    if($mv.Groups[1].Value -ne $sd.Ver){ throw ($sd.Ea + ".mq5 dichiara version '" + $mv.Groups[1].Value + "' invece di '" + $sd.Ver + "'. O la cache di raw.githubusercontent serve una copia vecchia, o il pin e' sbagliato.") }
    #  >>> IL MAGIC DEL SORGENTE, non quello vivo (vedi la nota sulla
    #      tabella $SEDIE): su S02 e S03 il magic vivo e' quello di un
    #      SECONDO grafico dello stesso EA, e col magic vivo qui dentro
    #      quelle due sedie morirebbero al gate su un sorgente sano.
    if($txtSrc -notmatch ('InpMagic\s*=\s*' + $sd.MagicSrc)){ throw ($sd.Ea + ".mq5 non dichiara InpMagic = " + $sd.MagicSrc + " (il default del sorgente): non e' il motore che credo.") }
    if($sd.MagicSrc -ne $sd.MagicVivo){
      [void]$Note.Add($sd.Id + ": il magic VIVO (" + $sd.MagicVivo + ") NON e' il default del sorgente (" + $sd.MagicSrc + "). Non e' un errore: e' il segno che questa sedia e' un SECONDO grafico dello stesso EA, e quindi la sua cella NON PUO' essere quella dei default. Per questo la cella di R100 e' presa da un artefatto di DEPLOY (S02: report/VIVAIO_ORO_DEPLOY.md; S03: preset VIVAIO_LARRY_ORO di deploy_vivaio_larry.ps1) e non dal sorgente.")
    }
    if($txtSrc -notmatch 'ABTG_PausaGuardian\.mqh'){ throw ($sd.Ea + ".mq5 non include ABTG_PausaGuardian.mqh: il sorgente non e' quello che credo.") }
    #  >>> L'OPTFRAME: e' il solo strumento del criterio A. Se sparisse,
    #      non ci sarebbe nessun DD da leggere (checklist 55).
    if($txtSrc -notmatch 'OnTesterDeinit'){ throw ($sd.Ea + ".mq5 non ha OnTesterDeinit: senza OPTFRAME non scrive nessun OptResults e il CRITERIO A non ha strumento.") }
    #  >>> IL MARCATORE DELLA RIGA D'INGRESSO, PRESO DAL SORGENTE CHE LA
    #      PRODUCE (checklist 55): e' da quella riga che il gate 1 legge la
    #      data della prima operazione. Se il testo cambiasse, il gate
    #      resterebbe muto e questo throw lo dice PRIMA della macchina.
    if($txtSrc -notmatch [regex]::Escape($sd.MarkSrc)){ throw ($sd.Ea + ".mq5 non contiene piu' la Log() d'ingresso ('" + $sd.MarkSrc + "'): il gate 1 non avrebbe niente da leggere nel log.") }
    if($txtSrc -match 'abtg_trades_'){
      [void]$Note.Add($sd.Id + ": IL SORGENTE ORA ESPORTA UN PER-TRADE ('abtg_trades_'): il disegno di R100 e' costruito sul fatto che NON lo faccia. La corsa prosegue e i numeri restano validi, ma il prossimo round su questo EA puo' usare uno strumento migliore.")
    }
    Dico ($sd.Ea + ".mq5 al pin, version " + $mv.Groups[1].Value + " (magic sorgente " + $sd.MagicVivo + ", include Guardian, OPTFRAME e Log d'ingresso presenti)") "Green"

    # -----------------------------------------------------------------
    #  3c. IL DD PROMESSO DI QUESTA SEDIA, dall'artefatto
    # -----------------------------------------------------------------
    $dd = DDPromesso $ContrTesto $sd.Ea $sd.MagicVivo
    $sd.ContrRiga = $dd.Riga; $sd.ContrDD = $dd.DD; $sd.ContrStato = $dd.Stato
    if($sd.ContrDD -gt 0){
      Dico ("DD promesso ESTRATTO: " + $sd.ContrDD.ToString("0.00",$INV) + "%  -> soglia 2x = " + (2*$sd.ContrDD).ToString("0.00",$INV) + "%") "Green"
    } else {
      Dico ("DD promesso: " + $sd.ContrStato + " -> il confronto 2x sara' NON CALCOLABILE. NON e' un via libera.") "Yellow"
    }

    # -----------------------------------------------------------------
    #  3d. FASE COMPILA. .ex5 SCRITTO ADESSO.
    #     >>> INVOCAZIONE DIRETTA di metaeditor64.exe (checklist 54 e bug
    #         del 22/08): con Start-Process -ArgumentList a stringhe
    #         pre-quotate, sui path con spazi ("Program Files") torna rc=0
    #         SENZA compilare.
    #     >>> E IL VERDETTO E' IL LastWriteTime DEL .ex5 PRIMA/DOPO, non
    #         "esiste" e non "e' recente": il file c'era gia'.
    #     >>> ATTENZIONE: questi EA sono SEDIE VIVE e il terminale di
    #         backtest e' collegato al conto vero. Per questo il .mq5 E il
    #         .ex5 vanno in un backup DATATO prima di essere toccati, e se
    #         la compilazione fallisce il .mq5 viene RIMESSO com'era:
    #         sorgente e binario devono restare la stessa versione, sempre.
    # -----------------------------------------------------------------
    if(-not $SoloControllo){
      $mq5 = Join-Path $MqlExperts ($sd.Ea + ".mq5")
      $ex5 = Join-Path $MqlExperts ($sd.Ea + ".ex5")
      $logC= Join-Path $MqlExperts ($sd.Ea + ".log")
      $bakMq5 = $mq5 + ".prima_r100_" + $Stamp
      $bakEx5 = $ex5 + ".prima_r100_" + $Stamp
      if((Test-Path -LiteralPath $mq5) -and -not (Test-Path -LiteralPath $bakMq5)){ Copy-Item -LiteralPath $mq5 -Destination $bakMq5 -Force }
      if((Test-Path -LiteralPath $ex5) -and -not (Test-Path -LiteralPath $bakEx5)){ Copy-Item -LiteralPath $ex5 -Destination $bakEx5 -Force }
      Copy-Item -LiteralPath $srcMq5 -Destination $mq5 -Force
      $lenSrc = (Get-Item -LiteralPath $srcMq5).Length
      $vc = Get-Item -LiteralPath $mq5 -ErrorAction SilentlyContinue
      if(-not $vc -or $vc.PSIsContainer -or $vc.Length -ne $lenSrc){ throw "copia del .mq5 in MQL5\Experts NON verificata (lunghezza diversa o e' una cartella)." }
      $ex5Prima = (Get-Date).AddYears(-100)
      if(Test-Path -LiteralPath $ex5){ $ex5Prima = (Get-Item -LiteralPath $ex5).LastWriteTime }
      Remove-Item -LiteralPath $logC -Force -ErrorAction SilentlyContinue
      & $MetaEditor "/compile:$mq5" "/log:$logC" | Out-Null
      $rcMe = $LASTEXITCODE
      $ex5Dopo = $null
      if(Test-Path -LiteralPath $ex5){ $ex5Dopo = (Get-Item -LiteralPath $ex5).LastWriteTime }
      $compileOk = ($ex5Dopo -ne $null) -and ($ex5Dopo -gt $ex5Prima)
      $testoLog = ""
      if(Test-Path -LiteralPath $logC){
        try{ $testoLog = (Get-Content -LiteralPath $logC -Raw -Encoding Unicode) }catch{ $testoLog = "" }
        if($testoLog -notmatch '(?i)error'){ try{ $testoLog = (Get-Content -LiteralPath $logC -Raw) }catch{} }
        Copy-Item -LiteralPath $logC -Destination (Join-Path $Sosta ("compile_" + $sd.Id + ".log")) -Force -ErrorAction SilentlyContinue
      }
      if(-not $compileOk){
        if($testoLog -ne ""){
          Write-Host "--- log del compilatore (ultime righe) ---" -ForegroundColor DarkYellow
          foreach($r in @($testoLog -split "\r?\n" | Select-Object -Last 20)){ Write-Host ("   " + $r) -ForegroundColor DarkYellow }
        } else { Write-Host "   (nessun log prodotto da MetaEditor)" -ForegroundColor DarkYellow }
        if(Test-Path -LiteralPath $bakMq5){ Copy-Item -LiteralPath $bakMq5 -Destination $mq5 -Force }
        throw ("COMPILAZIONE FALLITA per " + $sd.Ea + " (metaeditor rc=" + $rcMe + ", .ex5 NON riscritto). Il .mq5 e' stato RIMESSO com'era dal backup. Sospetto n.1: MetaEditor gia' aperto, oppure l'include ABTG_PausaGuardian.mqh.")
      }
      $mw = [regex]::Match($testoLog,'(?i)(\d+)\s+warning')
      if($mw.Success -and [int]$mw.Groups[1].Value -gt 0){
        [void]$Note.Add($sd.Id + ": compilazione con " + $mw.Groups[1].Value + " warning (0 errori). Non fermano il round, ma vanno letti in compile_" + $sd.Id + ".log dello zip.")
      }
      Dico ("COMPILATO " + $sd.Ea + " v" + $mv.Groups[1].Value + " (.ex5 riscritto adesso, rc=" + $rcMe + ")") "Green"
    }

    # -----------------------------------------------------------------
    #  LE DUE FABBRICHE DI .ini DI QUESTA SEDIA. Un solo artefatto: le
    #  righe le detta il FILE PROVA, non questa riga (checklist 33).
    # -----------------------------------------------------------------
    $OptCsv = Join-Path $MqlFiles ("OptResults_" + $sd.Ea + "_" + $Sym + ".csv")
    #  (a) OTTIMIZZAZIONE a due celle gemelle. Le righe restano in FORMA
    #      COMPLETA v||v||0||v||N: un pin scritto "Nome=v" secco imposta il
    #      valore ma NON spegne il flag di ottimizzazione che MT5 ricorda
    #      dall'ultima griglia di quell'EA (checklist 5), e qui
    #      Optimization=1 lo renderebbe letale.
    $sdRef = $sd; $parRef = $ProvaPar
    $iniOtt = {
      param($da,$a,$magic,$dest,$report)
      $out = New-Object System.Collections.ArrayList
      foreach($r in $parRef){
        if((NomeDi $r) -eq "InpMagic"){ [void]$out.Add("InpMagic=" + $magic + "||" + $magic + "||1||" + ($magic+1) + "||Y") }
        else { [void]$out.Add($r) }
      }
      $inputs = ($out -join "`r`n")
      # --- gate sullo STATO FINALE, non sul replace (checklist 33)
      if(@($out).Count -ne $sdRef.Par){ throw ("ini OTT: " + @($out).Count + " parametri invece di " + $sdRef.Par) }
      $yy = @([regex]::Matches($inputs,'(?m)^(\w+)=[^\r\n]*\|\|\s*[Yy]\s*\r?$') | ForEach-Object { $_.Groups[1].Value })
      if($yy.Count -ne 1 -or $yy[0] -ne "InpMagic"){ throw ("ini OTT: assi Y = [" + ($yy -join ", ") + "] invece del solo InpMagic.") }
      if($inputs -notmatch ('(?m)^InpMagic=' + $magic + '\|\|' + $magic + '\|\|1\|\|' + ($magic+1) + '\|\|Y\r?$')){ throw ("ini OTT: InpMagic non pinnato a " + $magic + "/" + ($magic+1)) }
      if($inputs -notmatch ('(?m)^InpRiskPercent=' + [regex]::Escape($sdRef.Risk) + '\|\|')){ throw ("ini OTT: InpRiskPercent non e' " + $sdRef.Risk + " (CRITERIO A).") }
      $testo = @"
[Charts]
MaxBars=2000000000

[Experts]
AllowLiveTrading=false
AllowDllImport=false

[Tester]
Expert=$($sdRef.Ea).ex5
Symbol=$Sym
Period=$($sdRef.Tf)
Model=$Modello
Spread=$SpreadIni
Optimization=1
OptimizationCriterion=6
FromDate=$da
ToDate=$a
ForwardMode=0
Deposit=$Deposito
Currency=EUR
Leverage=100
ExecutionMode=0
ReplaceReport=1
ShutdownTerminal=1
Report=$report

[TesterInputs]
$inputs
"@
      Set-Content -LiteralPath $dest -Value $testo -Encoding ASCII
    }
    #  (b) PASSATA SINGOLA -> log (righe d'ingresso) e report .htm (i deal).
    #      Qui i valori si scrivono SECCHI e Optimization=0: e' una passata
    #      sola, e un "||" rimasto vorrebbe dire un'ottimizzazione
    #      travestita -- e in ottimizzazione le Print non le legge nessuno
    #      (checklist 34), cioe' il gate 1 resterebbe muto.
    $iniSingola = {
      param($da,$a,$magic,$dest,$report)
      $out = New-Object System.Collections.ArrayList
      foreach($r in $parRef){
        $nome = NomeDi $r
        if($nome -eq "InpMagic"){ [void]$out.Add("InpMagic=" + $magic) }
        else { [void]$out.Add($nome + "=" + (ValoreDi $r)) }
      }
      $inputs = ($out -join "`r`n")
      if(@($out).Count -ne $sdRef.Par){ throw ("ini SINGOLA: " + @($out).Count + " parametri invece di " + $sdRef.Par) }
      if($inputs -match '\|\|'){ throw "ini SINGOLA: e' rimasto uno sweep '||'. Sarebbe un'ottimizzazione, non una passata singola." }
      if($inputs -notmatch '(?m)^InpVerbose=true\r?$'){ throw "ini SINGOLA: InpVerbose non e' true: l'EA non stamperebbe le righe d'ingresso e la PRIMA OPERAZIONE non sarebbe leggibile dal log." }
      if($inputs -notmatch ('(?m)^InpRiskPercent=' + [regex]::Escape($sdRef.Risk) + '\r?$')){ throw ("ini SINGOLA: InpRiskPercent non e' " + $sdRef.Risk) }
      if($inputs -notmatch ('(?m)^InpMagic=' + $magic + '\r?$')){ throw ("ini SINGOLA: InpMagic non pinnato a " + $magic) }
      $testo = @"
[Charts]
MaxBars=2000000000

[Experts]
AllowLiveTrading=false
AllowDllImport=false

[Tester]
Expert=$($sdRef.Ea).ex5
Symbol=$Sym
Period=$($sdRef.Tf)
Model=$Modello
Spread=$SpreadIni
Optimization=0
FromDate=$da
ToDate=$a
ForwardMode=0
Deposit=$Deposito
Currency=EUR
Leverage=100
ExecutionMode=0
ReplaceReport=1
ShutdownTerminal=1
Report=$report

[TesterInputs]
$inputs
"@
      Set-Content -LiteralPath $dest -Value $testo -Encoding ASCII
    }

    $iniSing = Join-Path $Work ($sd.Id + "_passo0_singola.ini")
    $iniInt  = Join-Path $Work ($sd.Id + "_passo0_intera.ini")
    & $iniSingola $DaQuando $Fino ($sd.Base + 12) $iniSing ("R100_" + $sd.Id + "_singola")
    & $iniOtt     $DaQuando $Fino ($sd.Base + 10) $iniInt  ("R100_" + $sd.Id + "_intera")
    Copy-Item -LiteralPath $iniSing -Destination (Join-Path $Sosta ($sd.Id + "_passo0_singola.ini")) -Force
    Copy-Item -LiteralPath $iniInt  -Destination (Join-Path $Sosta ($sd.Id + "_passo0_intera.ini"))  -Force

    if($SoloControllo){
      $sd.Esito = "SOLO CONTROLLO"
      Write-Host ("    ini del PASSO 0 scritti e verificati; " + $FINESTRE.Count + " ini di finestra a seguire") -ForegroundColor DarkGray
    }
    elseif($SaltaPasso0){
      [void]$Problemi.Add($sd.Id + ": PASSO 0 SALTATO SU RICHIESTA. I TRE GATE (prima operazione entro il " + $LimiteG2 + ", n totale, gemelli identici al centesimo) NON SONO STATI ESEGUITI, e con loro il CRITERIO A e il CRITERIO B. Questa corsa non ha guardato.")
      Write-Host "    !! PASSO 0 SALTATO. Il referto lo scrive in rosso." -ForegroundColor Red
    }
    else{
      # ---------------------------------------------------------------
      #  3e. LA PASSATA SINGOLA (gate 1 misura 1 + criterio B)
      # ---------------------------------------------------------------
      Write-Host ("  -- PASSO 0-B: passata SINGOLA su tutta la finestra (magic " + ($sd.Base+12) + ")") -ForegroundColor White
      if($iS -eq 1){
        Write-Host  "     ATTENZIONE alla durata: e' la PRIMA passata del round, e MT5 puo'" -ForegroundColor Yellow
        Write-Host  "     scaricarsi le barre M1 di 22 anni MENTRE gira." -ForegroundColor Yellow
      }
      $tPasso0 = Get-Date
      $primaLen = FotografaLog
      $tp = Get-Date
      (Start-Process -FilePath $Terminal -ArgumentList ("/config:`"" + $iniSing + "`"") -PassThru).WaitForExit()
      $minSing = [math]::Round((New-TimeSpan -Start $tp -End (Get-Date)).TotalMinutes,1)
      Dico ("  ... passata singola: " + $minSing.ToString("0.0",$INV) + " minuti") "Gray"

      # --- (1) IL LOG: la data della PRIMA OPERAZIONE, misura n.1
      $righeIN = New-Object System.Collections.ArrayList
      $letti = 0
      foreach($rad in $RadiciLog){
        if(-not (Test-Path -LiteralPath $rad)){ continue }
        foreach($lg in @(Get-ChildItem -LiteralPath $rad -Recurse -Filter "*.log" -File -ErrorAction SilentlyContinue | Sort-Object LastWriteTime)){
          $da = 0
          if($primaLen.ContainsKey($lg.FullName)){ $da = $primaLen[$lg.FullName] }
          $tx = LeggiNuovo $lg.FullName $da
          if($tx -eq ""){ continue }
          $letti++
          foreach($r in ($tx -split "`r?`n")){
            if($r -match $sd.MarkLog){
              $pref = "[" + (($sd.MarkLog -replace '^\\\[','') -split '\\\]')[0] + "]"
              $q = DataSimulata $r $pref
              [void]$righeIN.Add([pscustomobject]@{ Riga=$r.Trim(); Q=$q })
            }
          }
        }
      }
      $conData = @($righeIN | Where-Object { $_.Q -ne $null })
      if($conData.Count -gt 0){
        $sd.PrimaDataLog = ($conData | Sort-Object Q | Select-Object -First 1).Q.ToString("yyyy.MM.dd",$INV)
      }
      #  la prova cartacea del gate va al sicuro APPENA prodotta
      #  (checklist 41), cosi' esiste anche quando il gate esce ROSSO.
      if($righeIN.Count -gt 0){
        $dump = New-Object System.Collections.ArrayList
        [void]$dump.Add("R100 " + $sd.Id + " " + $sd.Ea + " - righe d'ingresso lette nel log della passata singola (magic " + ($sd.Base+12) + ")")
        [void]$dump.Add("marcatore: " + $sd.MarkLog + "   tipo: " + $sd.TipoLog)
        [void]$dump.Add("log letti: " + $letti + "   righe trovate: " + $righeIN.Count)
        [void]$dump.Add("")
        foreach($x in @($righeIN | Select-Object -First 40)){ [void]$dump.Add($x.Riga) }
        Set-Content -LiteralPath (Join-Path $Sosta ($sd.Id + "_ingressi_log.txt")) -Value $dump -Encoding ASCII
      }

      # --- (2) IL REPORT: i DEAL. Da qui la PEGGIOR GIORNATA (criterio B)
      #     e la SECONDA misura indipendente della prima data.
      #     >>> QUESTA MISURA SI FA SEMPRE, fuori dal ramo della prima
      #         (checklist 56-bis): serve a DIAGNOSTICARE il fallimento
      #         dell'altra, non a sostituirla.
      $repFile = ""
      foreach($rad in @($InstDir,$DataFolder,$Work,$MqlFiles)){
        if(-not (Test-Path -LiteralPath $rad)){ continue }
        $c = @(Get-ChildItem -LiteralPath $rad -Filter ("R100_" + $sd.Id + "_singola*.htm*") -File -ErrorAction SilentlyContinue |
               Where-Object { $_.LastWriteTime -ge $tPasso0 } | Sort-Object LastWriteTime -Descending)
        if($c.Count -gt 0){ $repFile = $c[0].FullName; break }
      }
      if($repFile -ne ""){
        Copy-Item -LiteralPath $repFile -Destination (Join-Path $Sosta ($sd.Id + "_report_singola.htm")) -Force -ErrorAction SilentlyContinue
        $deal = @(LeggiDeal $repFile)
        if($deal.Count -eq 0){
          $diag = "nessuna intestazione candidata trovata"
          if($script:DealIntestazioni.Count -gt 0){ $diag = "intestazioni candidate viste: [ " + ($script:DealIntestazioni -join " ]  [ ") + " ]" }
          [void]$Problemi.Add($sd.Id + " CRITERIO B: il report esiste (" + $repFile + ") ma NON ci ho riconosciuto nessuna riga di DEAL (Ora con data + Direzione in/out + Profitto + Bilancio). La PEGGIOR GIORNATA resta NON MISURATA: nessun numero inventato. DIAGNOSTICA -> " + $diag)
        } else {
          [void]$Note.Add($sd.Id + " CRITERIO B: tabella deal riconosciuta, colonne " + $script:DealColonne + " (indici a base 0). Netto di giornata = Profitto+Commissioni+Swap.")
          $sd.PrimaDataReport = $deal[0].Q.ToString("yyyy.MM.dd",$INV)
          $sd.NReport = @($deal | Where-Object { $_.Dir -eq "out" -or $_.Dir -eq "in/out" }).Count
          #  --- LA PEGGIOR GIORNATA, per giorno di calendario.
          #  [APPROSSIMATO, e il referto lo dice]: e' la peggior giornata
          #  sulle CHIUSURE REALIZZATE, non sull'equity intraday. E' la
          #  stessa approssimazione della peggior giornata di portafoglio
          #  di R51 e del criterio B di R99.
          #  CONTROLLO POSITIVO (checklist 55): se NESSUN deal ha un netto
          #  leggibile la somma sarebbe zero ovunque e la peggior giornata
          #  uscirebbe "0,00%" -- un VERDE FALSO. Zero netti letti e zero
          #  giornate perdenti devono essere DISTINGUIBILI.
          $conNetto = @($deal | Where-Object { $_.Netto -ne $null }).Count
          if($conNetto -eq 0){
            [void]$Problemi.Add($sd.Id + " CRITERIO B: riconosciuti " + $deal.Count + " deal ma NESSUNO ha un netto leggibile (" + $script:DealColonne + "). PEGGIOR GIORNATA NON MISURATA.")
          } else {
            $perGiorno = @{}; $saldoFine = @{}
            $ordine = New-Object System.Collections.ArrayList
            foreach($d in $deal){
              $g = $d.Q.ToString("yyyy.MM.dd",$INV)
              if(-not $perGiorno.ContainsKey($g)){ $perGiorno[$g] = 0.0; [void]$ordine.Add($g) }
              if($d.Netto -ne $null){ $perGiorno[$g] = $perGiorno[$g] + [double]$d.Netto }
              if($d.Saldo -ne $null){ $saldoFine[$g] = [double]$d.Saldo }
            }
            #  IL SALDO DI INIZIO DELLA PRIMISSIMA GIORNATA si RICAVA dal
            #  primo deal (Bilancio dopo il deal meno il netto del deal),
            #  invece di dare per scontato il deposito nominale.
            $saldoPrec = [double]$Deposito
            if($deal[0].Saldo -ne $null -and $deal[0].Netto -ne $null){
              $sIni = [double]$deal[0].Saldo - [double]$deal[0].Netto
              if($sIni -gt 0){ $saldoPrec = $sIni }
            }
            #  >>> NIENTE PAVIMENTO A ZERO. Partendo da 0.0 una storia senza
            #      giornate perdenti stampa "0,00%" con la DATA VUOTA, che
            #      si legge come una misura ed e' invece un "non ho trovato
            #      niente". Si prende il MINIMO VERO.
            $peggio = $null; $peggioG = ""
            foreach($g in $ordine){
              $base = $saldoPrec
              if($base -le 0){ $base = [double]$Deposito }
              $pct = 100.0 * $perGiorno[$g] / $base
              if($peggio -eq $null -or $pct -lt $peggio){ $peggio = $pct; $peggioG = $g }
              if($saldoFine.ContainsKey($g)){ $saldoPrec = $saldoFine[$g] }
            }
            if($peggio -eq $null){
              [void]$Problemi.Add($sd.Id + " CRITERIO B: nessuna giornata operativa ricavata dai deal. PEGGIOR GIORNATA NON MISURATA.")
            } else {
              $sd.PeggiorGiornataPct = [math]::Round($peggio,2)
              $coda = ""
              if($peggio -ge 0){ $coda = "   <<< NESSUNA giornata in perdita: e' il giorno MENO buono, non una perdita" }
              $sd.PeggiorGiornata = $sd.PeggiorGiornataPct.ToString("0.00",$INV) + "%  (il " + $peggioG + ", su " + $ordine.Count + " giornate operative, " + $conNetto + " deal col netto letto)" + $coda
            }
          }
        }
      } else {
        [void]$Problemi.Add($sd.Id + " CRITERIO B: NON ho trovato nessun report 'R100_" + $sd.Id + "_singola*.htm' scritto dopo l'avvio della passata (cercato in " + $InstDir + ", " + $DataFolder + ", " + $Work + ", " + $MqlFiles + "). La PEGGIOR GIORNATA resta NON MISURATA e NON si inventa. COME AVERLA: aprire MT5, Strategy Tester, ricaricare " + $sd.Id + "_passo0_singola.ini (e' nello zip) in test singolo, tasto destro sul risultato -> Report, e leggere la tabella dei Deal.")
      }

      # ---------------------------------------------------------------
      #  3f. LE DUE PASSATE GEMELLE (criterio A + gate 2 + gate 3)
      # ---------------------------------------------------------------
      Write-Host ("  -- PASSO 0-C: due passate GEMELLE su tutta la finestra (magic " + ($sd.Base+10) + "/" + ($sd.Base+11) + ")") -ForegroundColor White
      $csvInt = Join-Path $Risultati ("R100_" + $sd.Id + "_" + $sd.Ea + "_INTERA" + $Suffisso + ".csv")
      #  >>> SI CANCELLA PRIMA, TUTTI E DUE (checklist 23 e 14). Se la
      #      passata non producesse niente, un file di IERI resterebbe li'
      #      e verrebbe letto come il risultato di ADESSO.
      Remove-Item -LiteralPath $OptCsv -Force -ErrorAction SilentlyContinue
      Remove-Item -LiteralPath $csvInt -Force -ErrorAction SilentlyContinue
      $tp = Get-Date
      (Start-Process -FilePath $Terminal -ArgumentList ("/config:`"" + $iniInt + "`"") -PassThru).WaitForExit()
      $minOtt = [math]::Round((New-TimeSpan -Start $tp -End (Get-Date)).TotalMinutes,1)
      Dico ("  ... due gemelle: " + $minOtt.ToString("0.0",$INV) + " minuti") "Gray"
      if(Test-Path -LiteralPath $OptCsv){
        if((Get-Item -LiteralPath $OptCsv).LastWriteTime -lt $tp){
          [void]$Problemi.Add($sd.Id + " PASSO 0-C: l'OptResults e' PIU' VECCHIO dell'avvio delle gemelle: NON e' di questa corsa, non lo leggo.")
        } else {
          Copy-Item -LiteralPath $OptCsv -Destination $csvInt -Force
          Copy-Item -LiteralPath $OptCsv -Destination (Join-Path $Sosta ($sd.Id + "_intera_optresults.csv")) -Force
          Remove-Item -LiteralPath $OptCsv -Force -ErrorAction SilentlyContinue
        }
      }
      if(-not (Test-Path -LiteralPath $csvInt)){
        $sdFatale = "PASSO 0-C: nessun OptResults sulla finestra intera. O lo storico M1 non copre " + $DaQuando + ", o MT5 non e' partito, o la cache ha ripescato passate vecchie senza riscrivere i frame. NON e' un via libera: senza questo file non esistono ne' il n, ne' il DD lungo (CRITERIO A), ne' il gate dei gemelli."
      } else {
        $rows = @(Import-Csv -LiteralPath $csvInt)
        if($rows.Count -ne $CelleAttese){
          $sdFatale = "PASSO 0-C: l'OptResults ha " + $rows.Count + " righe invece di " + $CelleAttese + " (le due gemelle). O la cache del tester ha ripescato passate gia' calcolate senza riscrivere i frame, o l'asse InpMagic non ha spazzolato. Il gate 3 non ha niente da confrontare."
        } else {
          #  IL CONTROLLO POSITIVO SUL PARSER (checklist 55): prima si
          #  verifica che le COLONNE esistano, coi loro nomi veri. Senza,
          #  una colonna rinominata darebbe $null in silenzio e il DD
          #  uscirebbe "non leggibile" senza dire perche'.
          $cols = @($rows | Get-Member -MemberType NoteProperty | ForEach-Object { $_.Name })
          $manca = @()
          foreach($c in @("Profit","Profit Factor","Equity DD %","Trades")){ if($cols -notcontains $c){ $manca += $c } }
          if($manca.Count -gt 0){
            $sdFatale = "PASSO 0-C: nell'OptResults mancano le colonne [" + ($manca -join ", ") + "]. Le scrive l'OPTFRAME dell'EA (OnTesterDeinit): se sono cambiate, e' cambiato il motore. IL GATE NON E' STATO ESEGUITO. Colonne trovate: " + ($cols -join ", ")
          } else {
            $ddv=@(); $pfv=@(); $prv=@(); $trv=@()
            foreach($r in $rows){
              $ddv += (NumInv $r.'Equity DD %'); $pfv += (NumInv $r.'Profit Factor')
              $prv += (NumInv $r.'Profit');      $trv += (NumInv $r.'Trades')
            }
            if(($ddv -contains $null) -or ($prv -contains $null) -or ($trv -contains $null)){
              $sdFatale = "PASSO 0-C: le colonne ci sono ma i VALORI non sono numeri leggibili. IL GATE NON E' STATO ESEGUITO: non e' un via libera."
            } else {
              $sd.DDLungo = [math]::Round([double]$ddv[0],2)
              $sd.PF      = [math]::Round([double]$pfv[0],3)
              $sd.Profit  = [math]::Round([double]$prv[0],2)
              $sd.N       = [int]$trv[0]
              #  >>> IL QUARTO STRUMENTO, dove c'e': PunteLarry e PTE hanno
              #      la colonna 'Peggior Giornata %' calcolata DENTRO l'EA.
              #      E' un controllo incrociato indipendente sul criterio B.
              if($cols -contains "Peggior Giornata %"){
                $pg = (NumInv $rows[0].'Peggior Giornata %')
                if($pg -ne $null){
                  $sd.PeggiorGiornataEA = ([double]$pg).ToString("0.00",$INV) + "%  (colonna 'Peggior Giornata %' dell'OPTFRAME di questo EA -- misura INDIPENDENTE da quella del report)"
                }
              }
              #  --- GATE 3: GEMELLI IDENTICI AL CENTESIMO
              $div = New-Object System.Collections.ArrayList
              if([math]::Round([double]$prv[0],2) -ne [math]::Round([double]$prv[1],2)){ [void]$div.Add("Profit") }
              if([math]::Round([double]$ddv[0],2) -ne [math]::Round([double]$ddv[1],2)){ [void]$div.Add("Equity DD %") }
              if([math]::Round([double]$pfv[0],2) -ne [math]::Round([double]$pfv[1],2)){ [void]$div.Add("Profit Factor") }
              if([int]$trv[0] -ne [int]$trv[1]){ [void]$div.Add("Trades") }
              if($div.Count -gt 0){
                $sd.Gemelli = "DIVERGONO su " + ($div -join ", ")
                $sdFatale = "GATE 3: le due passate gemelle divergono su [" + ($div -join ", ") + "]. Banco sporco: la stessa cella ha risposto in modo diverso a se stessa, e nessun numero di questa sedia si legge."
              } else { $sd.Gemelli = "IDENTICI al centesimo" }
            }
          }
        }
      }

      # ---------------------------------------------------------------
      #  3g. I GATE DEL PASSO 0 DI QUESTA SEDIA
      # ---------------------------------------------------------------
      $dLog = [datetime]::MinValue; $okLog = $false
      $dRep = [datetime]::MinValue; $okRep = $false
      if($sd.PrimaDataLog    -ne "NON MISURATA"){ $okLog = [datetime]::TryParseExact($sd.PrimaDataLog,   "yyyy.MM.dd",$INV,[Globalization.DateTimeStyles]::None,[ref]$dLog) }
      if($sd.PrimaDataReport -ne "NON MISURATA"){ $okRep = [datetime]::TryParseExact($sd.PrimaDataReport,"yyyy.MM.dd",$INV,[Globalization.DateTimeStyles]::None,[ref]$dRep) }
      $dUsata = [datetime]::MinValue
      if($okLog -and $okRep){
        $dUsata = $dLog; if($dRep -lt $dLog){ $dUsata = $dRep }
        $sd.FonteData = "log e report CONCORDI"
        $scarto = ($dRep - $dLog).TotalDays
        #  >>> IL CONFRONTO E' DIVERSO A SECONDA DEL TIPO DI LOG, ed e'
        #      dichiarato: su una sedia PENDENTE l'EA logga il
        #      PIAZZAMENTO dell'ordine, che PRECEDE legittimamente il
        #      primo deal. Li' "log piu' vecchio del report" e' il
        #      mestiere, non un difetto; il contrario no.
        if($sd.TipoLog -eq "PENDENTE"){
          if($scarto -lt -1){
            [void]$Problemi.Add($sd.Id + " GATE 1: il report (" + $sd.PrimaDataReport + ") e' PIU' VECCHIO del log (" + $sd.PrimaDataLog + ") di " + [int](-$scarto) + " giorni. Su una sedia che logga il PIAZZAMENTO dei pendenti questo non dovrebbe succedere: un deal non puo' precedere il suo ordine. Va capito prima di firmare qualunque conclusione.")
            $sd.FonteData = "log e report INCOERENTI (report prima del log su sedia PENDENTE)"
          } elseif($scarto -gt 60){
            [void]$Note.Add($sd.Id + " GATE 1: fra il primo ordine piazzato (" + $sd.PrimaDataLog + ") e il primo deal eseguito (" + $sd.PrimaDataReport + ") passano " + [int]$scarto + " giorni. E' possibile su una sedia a pendenti che scadono, ma vale la pena saperlo: la sedia ha piazzato a lungo senza mai essere eseguita.")
            $sd.FonteData = "log = primo ORDINE, report = primo DEAL (sedia PENDENTE)"
          } else { $sd.FonteData = "log (primo ordine) e report (primo deal) coerenti - sedia PENDENTE" }
        } else {
          if([math]::Abs($scarto) -gt 1){
            [void]$Problemi.Add($sd.Id + " GATE 1: le due misure indipendenti della prima operazione NON coincidono -- log " + $sd.PrimaDataLog + " contro report " + $sd.PrimaDataReport + " (" + [int][math]::Abs($scarto) + " giorni). Uso la PIU' VECCHIA (la piu' prudente sul tetto delle barre) e lo dichiaro, ma lo scarto va capito.")
            $sd.FonteData = "log e report DIVERGENTI: uso la piu' vecchia"
          }
        }
      }
      elseif($okLog){ $dUsata = $dLog; $sd.FonteData = "SOLO il log (il report non e' stato letto)" }
      elseif($okRep){ $dUsata = $dRep; $sd.FonteData = "SOLO il report (il log non e' stato letto)" }

      if($sdFatale -eq ""){
        if(-not $okLog -and -not $okRep){
          $sdFatale = "GATE 1: la data della PRIMA OPERAZIONE non e' leggibile NE' dal log NE' dal report. Il gate NON HA GUARDATO NIENTE, e un gate che non legge non e' un gate verde. Cause da distinguere: (1) l'EA non ha operato affatto su 22 anni; (2) i log stanno in una radice che non guardo; (3) InpVerbose non e' arrivato acceso; (4) il report non e' stato scritto dove lo cerco; (5) il marcatore di log di QUESTA sedia (" + $sd.MarkLog + ") non corrisponde piu'. In tutti i casi NON e' un via libera."
        } else {
          $sd.PrimaDataUsata = $dUsata.ToString("yyyy.MM.dd",$INV)
          $lim  = [datetime]::ParseExact($LimiteG2,"yyyy.MM.dd",$INV)
          $limF = [datetime]::ParseExact($LimiteFatale,"yyyy.MM.dd",$INV)
          if($dUsata -le $lim){
            $sd.Finestra = "PIENA (prima op. " + $sd.PrimaDataUsata + ")"
          } elseif($dUsata -lt $limF){
            $sd.Finestra = "ACCORCIATA (prima op. " + $sd.PrimaDataUsata + ", oltre il " + $LimiteG2 + ")"
            [void]$Problemi.Add($sd.Id + " FINESTRA ACCORCIATA: la prima operazione e' del " + $sd.PrimaDataUsata + ", oltre il " + $LimiteG2 + ". Il tetto delle 100.000 barre HA MORSO, oppure lo storico M1 non arriva davvero al " + $DaQuando + ". La corsa PROSEGUE -- il criterio dice 'si dichiara accorciata', non 'ci si ferma' -- ma questa riga va scritta ACCANTO A OGNI NUMERO di questa sedia: il DD lungo NON copre 22 anni, ne copre meno.")
          } else {
            $sdFatale = "GATE 1: la prima operazione e' del " + $sd.PrimaDataUsata + ", dopo il " + $LimiteFatale + ". La finestra non contiene piu' ne' il crollo dell'ottobre 2008 ne' quello dell'aprile 2013, cioe' i due eventi che l'IPOTESI del round vuole misurare: i tre numeri descriverebbero un'altra finestra. (Soglia dichiarata come TRADUZIONE, non come firma.)"
          }
        }
      }
      if($sd.N -ge 0 -and $sd.NReport -ge 0 -and $sd.N -ne $sd.NReport){
        [void]$Problemi.Add($sd.Id + " GATE 2: il n dell'ottimizzazione (" + $sd.N + ", colonna Trades) e il n del report della passata singola (" + $sd.NReport + ", deal 'out') NON coincidono. Sono la STESSA cella su magic diversi: dovrebbero. Va capito prima di leggere la peggior giornata, che e' calcolata sui deal del report.")
      }
      if($sd.N -eq 0){
        [void]$Problemi.Add($sd.Id + " GATE 2: n = 0 operazioni su 22 anni. Non c'e' niente da misurare: o lo storico non c'e', o la cella non opera su questo simbolo. NON e' un DD basso, e' un DD ASSENTE.")
      }
      Write-Host ("     prima op: log " + $sd.PrimaDataLog + " | report " + $sd.PrimaDataReport + " -> usata " + $sd.PrimaDataUsata) -ForegroundColor White
      Write-Host ("     FINESTRA " + $sd.Finestra + " | n " + $sd.N + " | gemelli " + $sd.Gemelli) -ForegroundColor Yellow
      Write-Host ("     A. DD LUNGO " + (Fmt2 $sd.DDLungo) + "%   B. PEGGIOR GIORNATA " + $sd.PeggiorGiornata) -ForegroundColor Yellow
      if($sdFatale -ne ""){ throw $sdFatale }
    }

    # -----------------------------------------------------------------
    #  3h. LE SEI FINESTRE DI QUESTA SEDIA
    # -----------------------------------------------------------------
    foreach($f in $FINESTRE){
      $nome = $f[0]; $fda = $f[1]; $fa = $f[2]; $off = $f[3]; $crit = $f[4]
      $sd.Fin[$nome] = @{ DD=-1.0; N=-1; Righe=-1; Gemelli="-"; Esito="NON ESEGUITA"; Criterio=$crit; Da=$fda; A=$fa }
      $dest = Join-Path $Risultati ("R100_" + $sd.Id + "_" + $sd.Ea + "_" + $nome + $Suffisso + ".csv")
      $ini  = Join-Path $Work ($sd.Id + "_" + $nome + ".ini")
      & $iniOtt $fda $fa ($sd.Base + $off) $ini ("R100_" + $sd.Id + "_" + $nome)
      Copy-Item -LiteralPath $ini -Destination (Join-Path $Sosta ($sd.Id + "_" + $nome + ".ini")) -Force
      if($SoloControllo){ $sd.Fin[$nome].Esito = "SOLO CONTROLLO"; continue }
      if((Test-Path -LiteralPath $dest) -and -not $Rifai){
        #  >>> UN CSV VECCHIO NON E' UN CSV OK: SI GUARDA LA DATA. La
        #      ripresa e' utile, ma un file di un lancio precedente non e'
        #      un risultato di questo lancio, e se fra i due lanci fosse
        #      cambiato il pin META' ROUND VERREBBE DA UN ALTRO MOTORE
        #      (checklist 15 e 53).
        $sd.Fin[$nome].Esito = "SALTATA (CSV gia' presente del " + (Get-Item -LiteralPath $dest).LastWriteTime.ToString("yyyy-MM-dd HH:mm",$INV) + ")"
        [void]$Problemi.Add($sd.Id + " " + $nome + ": " + $sd.Fin[$nome].Esito + ". Le righe tornano ma il file NON e' di questo lancio: rilancia con -Rifai.")
        continue
      }
      $tl = Get-Date
      Remove-Item -LiteralPath $OptCsv -Force -ErrorAction SilentlyContinue
      Remove-Item -LiteralPath $dest   -Force -ErrorAction SilentlyContinue
      (Start-Process -FilePath $Terminal -ArgumentList ("/config:`"" + $ini + "`"") -PassThru).WaitForExit()
      $mn = [math]::Round((New-TimeSpan -Start $tl -End (Get-Date)).TotalMinutes,1)
      if(Test-Path -LiteralPath $OptCsv){
        if((Get-Item -LiteralPath $OptCsv).LastWriteTime -lt $tl){
          [void]$Problemi.Add($sd.Id + " " + $nome + ": l'OptResults e' piu' vecchio dell'avvio della passata: NON e' di questa finestra, non lo leggo.")
        } else {
          Copy-Item -LiteralPath $OptCsv -Destination $dest -Force
          Remove-Item -LiteralPath $OptCsv -Force -ErrorAction SilentlyContinue
        }
      }
      if(-not (Test-Path -LiteralPath $dest)){
        $sd.Fin[$nome].Esito = "NESSUN CSV"
        [void]$Problemi.Add($sd.Id + " " + $nome + ": nessun OptResults prodotto. Storico mancante su quella finestra, oppure MT5 non e' partito.")
      } else {
        $rows = @(Import-Csv -LiteralPath $dest)
        $sd.Fin[$nome].Righe = $rows.Count
        if($rows.Count -ne $CelleAttese){
          $sd.Fin[$nome].Esito = "RIGHE SBAGLIATE (" + $rows.Count + " invece di " + $CelleAttese + ")"
          [void]$Problemi.Add($sd.Id + " " + $nome + ": " + $sd.Fin[$nome].Esito + ". E' la CACHE del tester (passate ripescate senza riscrivere i frame) oppure l'asse InpMagic che non ha spazzolato: la finestra NON si legge.")
        } else {
          $ddw=@(); $trw=@()
          foreach($r in $rows){ $ddw += (NumInv $r.'Equity DD %'); $trw += (NumInv $r.'Trades') }
          if(($ddw -contains $null) -or ($trw -contains $null)){
            $sd.Fin[$nome].Esito = "COLONNE NON LETTE"
            [void]$Problemi.Add($sd.Id + " " + $nome + ": non riesco a leggere 'Equity DD %' / 'Trades'. Il DD di questa finestra NON e' misurato.")
          } else {
            $sd.Fin[$nome].DD = [math]::Round([double]$ddw[0],2)
            $sd.Fin[$nome].N  = [int]$trw[0]
            if([math]::Round([double]$ddw[0],2) -ne [math]::Round([double]$ddw[1],2) -or [int]$trw[0] -ne [int]$trw[1]){
              $sd.Fin[$nome].Gemelli = "DIVERGONO"
              $sd.Fin[$nome].Esito   = "GEMELLI DIVERGENTI"
              [void]$Problemi.Add($sd.Id + " " + $nome + ": le due gemelle divergono. Banco sporco su questa finestra: il suo DD non si legge.")
            } else { $sd.Fin[$nome].Gemelli = "IDENTICI"; $sd.Fin[$nome].Esito = "OK" }
          }
        }
      }
      Write-Host ("     " + $nome.PadRight(9) + " DD " + (Fmt2 $sd.Fin[$nome].DD) + "%  n " + $sd.Fin[$nome].N + "  [" + $mn.ToString("0.0",$INV) + " min]  " + $sd.Fin[$nome].Esito) -ForegroundColor Gray
    }

    if($SoloControllo){ $sd.Esito = "SOLO CONTROLLO" }
    else {
      $ko = @($FINESTRE | Where-Object { $sd.Fin[$_[0]].Esito -ne "OK" })
      if($ko.Count -eq 0 -and $sd.DDLungo -ge 0){ $sd.Esito = "OK" }
      else { $sd.Esito = "PARZIALE (" + $ko.Count + " finestre non OK)" }
    }

  }catch{
    $sd.Esito = "FERMATA -- " + $_.Exception.Message
    [void]$Problemi.Add($sd.Id + " " + $sd.Ea + " FERMATA: " + $_.Exception.Message + "  >>> La sedia si dichiara NON MISURATA e la corsa PASSA ALLA SEGUENTE: una sedia storta non porta via le altre undici.")
    Write-Host ("  !! " + $sd.Id + " FERMATA: " + $_.Exception.Message) -ForegroundColor Red
  }
  $sd.Minuti = [math]::Round((New-TimeSpan -Start $tSedia -End (Get-Date)).TotalMinutes,1)

  # -------------------------------------------------------------------
  #  3i. IL VERDETTO DELLA CORSIA RISCHIO DI QUESTA SEDIA -- MECCANICO
  # -------------------------------------------------------------------
  if($SoloControllo){ $sd.Verdetto = "GIRO A VUOTO: nessun numero" }
  elseif($sd.DDLungo -lt 0){ $sd.Verdetto = "NON MISURABILE (DD lungo non misurato)" }
  elseif($sd.Gruppo -eq 2){ $sd.Verdetto = "NON MISURABILE (rischio vivo NON censito: il DD e' un DD-per-1%, riscalabile)" }
  elseif($sd.ContrDD -le 0){ $sd.Verdetto = "NON MISURABILE (2x senza denominatore: " + $sd.ContrStato + ")" }
  elseif($sd.DDLungo -gt (2.0 * $sd.ContrDD)){ $sd.Verdetto = "REVISIONE (DD " + (Fmt2 $sd.DDLungo) + "% > 2x " + $sd.ContrDD.ToString("0.00",$INV) + "% = " + (2*$sd.ContrDD).ToString("0.00",$INV) + "%)" }
  else { $sd.Verdetto = "OK (DD " + (Fmt2 $sd.DDLungo) + "% <= 2x " + $sd.ContrDD.ToString("0.00",$INV) + "% = " + (2*$sd.ContrDD).ToString("0.00",$INV) + "%)" }
  Write-Host ("  => " + $sd.Id + " " + $sd.Esito + "   [" + $sd.Minuti.ToString("0.0",$INV) + " min]   VERDETTO RISCHIO: " + $sd.Verdetto) -ForegroundColor Yellow
}

}catch{
  $Fatale = $_.Exception.Message
  Write-Host ""
  Write-Host ("!!! FERMATO: " + $Fatale) -ForegroundColor Red
}

# =====================================================================
#  4. RACCOLTA. Si fa SEMPRE, anche a esito parziale o fermato.
# =====================================================================
Titolo "4. RACCOLTA SUL DESKTOP"
#  >>> OGNI ARTEFATTO DICE IN QUALE MODO E' STATO PRODOTTO (checklist 50). <<<
$Modo = "CORSA"
if($SoloControllo){ $Modo = "CONTROLLO" } elseif($SaltaPasso0){ $Modo = "SENZAPASSO0" }
$Cart = Join-Path $Dsk ("R100_ORO_FLOTTA_" + $Modo + "_" + $Stamp)
$Zip  = Join-Path $Dsk ("R100_ORO_FLOTTA_" + $Modo + "_" + $Stamp + ".zip")
$Referto = Join-Path $Cart "REFERTO_R100.txt"
try{
  New-Item -ItemType Directory -Force -Path $Cart | Out-Null
  foreach($f in @(Get-ChildItem -LiteralPath $Risultati -Filter "R100_*.csv" -File -ErrorAction SilentlyContinue)){
    Copy-Item -LiteralPath $f.FullName -Destination (Join-Path $Cart $f.Name) -Force
  }
  if(Test-Path -LiteralPath $Sosta){
    foreach($f in @(Get-ChildItem -LiteralPath $Sosta -File -ErrorAction SilentlyContinue)){
      Copy-Item -LiteralPath $f.FullName -Destination (Join-Path $Cart $f.Name) -Force
    }
  }

  $R = New-Object System.Collections.ArrayList
  [void]$R.Add("REFERTO R100 - LA FLOTTA ORO SU 22 ANNI: LA MISURA DEL RISCHIO")
  [void]$R.Add("XAUUSD, " + $Lavoro.Count + " sedie, modello OHLC M1, " + $DaQuando + " -> " + $Fino)
  $coda = ""
  if($SoloControllo){ $coda = "   <<< GIRO A VUOTO: NESSUNA passata, NESSUN numero di round qui dentro" }
  [void]$R.Add("modo: " + $Modo + $coda)
  $sw = @()
  if($SoloControllo){ $sw += "-SoloControllo (nessuna passata)" }
  if($SaltaPasso0)  { $sw += "-SaltaPasso0 (I TRE GATE NON ESEGUITI: i criteri chiedono il contrario)" }
  if($SenzaStorico) { $sw += "-SenzaStorico (barre NON scaricate: il tester si arrangia, e puo' volerci molto di piu')" }
  if($Rifai)        { $sw += "-Rifai (rifatto anche cio' che era gia' presente)" }
  if($SoloSedia -ne ""){ $sw += ("-SoloSedia " + $SoloSedia + " (UNA SOLA SEDIA: questo NON e' il round intero)") }
  if($sw.Count -eq 0){ $sw += "nessuno (corsa piena, PASSO 0 eseguito, ripresa attiva)" }
  [void]$R.Add("switch di questo giro: " + ($sw -join " | "))
  [void]$R.Add("data: " + (Get-Date).ToString("yyyy-MM-dd HH:mm:ss",$INV) + "   (questa data deve essere di ADESSO)")
  [void]$R.Add("     ATTENZIONE: la data fresca NON distingue un giro a vuoto da una corsa.")
  [void]$R.Add("     Lo distinguono la riga 'modo:' qui sopra e il NOME della cartella.")
  [void]$R.Add("avvio: " + $Avvio.ToString("yyyy-MM-dd HH:mm:ss",$INV) + "   durata: " + ((New-TimeSpan -Start $Avvio -End (Get-Date)).TotalHours).ToString("0.0",$INV) + " ore")
  [void]$R.Add("pin: " + $Pin)
  [void]$R.Add("criteri: risultati_archivio\R100_CRITERI.md   (estensione INVARIATA dei criteri R99")
  [void]$R.Add("         firmati il 23/08/2026; l'ordine di Claudio 'FAI PARTIRE R99 SULLE ALTRE")
  [void]$R.Add("         SEDIE ORO' e' la firma dell'estensione, verbalizzata in R100_CRITERI par. 0)")
  [void]$R.Add("modello: " + $Modello + " = OHLC su M1.  I TICK REALI SU 22 ANNI NON ESISTONO")
  [void]$R.Add("         (partono dal 2024.07.05): ogni numero qui sotto e' un LIMITE INFERIORE")
  [void]$R.Add("         del rischio, MAI UN PERMESSO.")
  [void]$R.Add("")
  [void]$R.Add("=====================================================================")
  [void]$R.Add(" LA TABELLA MADRE - la fotografia del rischio di TUTTA la flotta oro")
  [void]$R.Add("=====================================================================")
  [void]$R.Add("")
  [void]$R.Add(("{0,-4} {1,-42} {2,-3} {3,-6} {4,9} {5,9} {6,6} {7,9}  {8}" -f "ID","EA","TF","RISCH","DDPROM%","DD22ANNI","2x?","PEGGGIOR","VERDETTO CORSIA RISCHIO"))
  [void]$R.Add(("-"*175))
  foreach($sd in $Lavoro){
    $ddp = "n/d"; if($sd.ContrDD -gt 0){ $ddp = $sd.ContrDD.ToString("0.00",$INV) }
    $due = "n/d"
    if($sd.ContrDD -gt 0 -and $sd.DDLungo -ge 0){ if($sd.DDLungo -gt (2*$sd.ContrDD)){ $due = "SI" } else { $due = "no" } }
    $pgg = "n/d"; if($sd.PeggiorGiornata -ne "NON MISURATA"){ $pgg = ($sd.PeggiorGiornata -split "%")[0] + "%" }
    [void]$R.Add(("{0,-4} {1,-42} {2,-3} {3,-6} {4,9} {5,9} {6,6} {7,9}  {8}" -f `
       $sd.Id,$sd.Ea,$sd.Tf,($sd.Risk + "%"),$ddp,(Fmt2 $sd.DDLungo),$due,$pgg,$sd.Verdetto))
  }
  [void]$R.Add("")
  [void]$R.Add("  RISCH   = la taglia con cui il numero e' stato MISURATO. GRUPPO 1 = e' la")
  [void]$R.Add("            taglia VIVA, misurata nel censimento .chr del 19/08/2026 15:34.")
  [void]$R.Add("            GRUPPO 2 = e' una TAGLIA DI RIFERIMENTO dichiarata (1,00%), perche'")
  [void]$R.Add("            di quelle sedie NON esiste nessuna misura del rischio vivo: il DD")
  [void]$R.Add("            e' un DD-per-1%, da riscalare linearmente [APPROSSIMATO] appena un")
  [void]$R.Add("            censimento .chr misurera' il rischio vero.")
  [void]$R.Add("  DDPROM% = il DD promesso, ESTRATTO da report/CONTRATTI_SEDIE.md AL PIN, per")
  [void]$R.Add("            colonna. 'n/d' vuol dire che la sedia NON HA un DD promesso")
  [void]$R.Add("            numerico -- e quello NON e' un via libera: e' un rilievo, perche'")
  [void]$R.Add("            senza denominatore la corsia RISCHIO su quella sedia non puo'")
  [void]$R.Add("            nemmeno scattare.")
  [void]$R.Add("  2x?     = la sola decisione MECCANICA del round: SI = il DD misurato supera")
  [void]$R.Add("            il DOPPIO del promesso -> REVISIONE, senza altre discussioni.")
  [void]$R.Add("  PEGGGIOR= la peggior giornata sulle CHIUSURE REALIZZATE [APPROSSIMATO], da")
  [void]$R.Add("            confrontare col muro prop giornaliero del 5%.")
  [void]$R.Add("")
  [void]$R.Add("=====================================================================")
  [void]$R.Add(" SEDIA PER SEDIA - i tre numeri, i tre gate e il contratto")
  [void]$R.Add("=====================================================================")
  foreach($sd in $Lavoro){
    [void]$R.Add("")
    [void]$R.Add("---------------------------------------------------------------------")
    [void]$R.Add($sd.Id + "  " + $sd.Ea + "   XAUUSD " + $sd.Tf + "   GRUPPO " + $sd.Gruppo)
    [void]$R.Add("     magic vivo " + $sd.MagicVivo + " | magic del sorgente " + $sd.MagicSrc + " | rischio " + $sd.Risk + "% | commento '" + $sd.Commento + "' | version attesa " + $sd.Ver)
    if($sd.MagicSrc -ne $sd.MagicVivo){
      [void]$R.Add("     >>> magic vivo DIVERSO dal default del sorgente: questa sedia e' un SECONDO")
      [void]$R.Add("         grafico dello stesso EA, quindi la sua cella NON puo' essere quella dei")
      [void]$R.Add("         default. La cella di R100 viene da un artefatto di DEPLOY, non dal sorgente.")
    }
    [void]$R.Add("     magic della corsa: gemelle " + ($sd.Base+10) + "/" + ($sd.Base+11) + ", singola " + ($sd.Base+12) + " (blocco 78xxxx VERGINE)")
    [void]$R.Add("     esito: " + $sd.Esito + "   durata " + $sd.Minuti.ToString("0.0",$INV) + " min")
    [void]$R.Add("")
    [void]$R.Add("  A. DD MASSIMO EQUITY " + $DaQuando + " -> " + $Fino + " al rischio " + $sd.Risk + "%")
    if($sd.DDLungo -ge 0){ [void]$R.Add("     ->  " + (Fmt2 $sd.DDLungo) + " %      (n = " + $sd.N + " operazioni)") }
    else                 { [void]$R.Add("     ->  NON MISURATO") }
    [void]$R.Add("  B. PEGGIOR GIORNATA IN %   (il muro prop giornaliero e' 5%)")
    [void]$R.Add("     ->  " + $sd.PeggiorGiornata)
    [void]$R.Add("     [APPROSSIMATO]: chiusure REALIZZATE, non equity intraday; percentuale")
    [void]$R.Add("     sul saldo a inizio giornata; netto = Profitto+Commissioni+Swap.")
    if($sd.PeggiorGiornataEA -ne "n/d"){
      [void]$R.Add("     -> SECONDA MISURA INDIPENDENTE (dall'OPTFRAME dell'EA): " + $sd.PeggiorGiornataEA)
      [void]$R.Add("        Le due misure vengono da strumenti diversi: se divergono molto,")
      [void]$R.Add("        e' il metodo del criterio B che va guardato, non la sedia.")
    }
    [void]$R.Add("  C. DD DENTRO LE QUATTRO FINESTRE DI REGIME")
    [void]$R.Add("     (date agli atti: prova_regime.ps1 righe 69-75, le stesse di R50/R56/R59)")
    [void]$R.Add(("     {0,-10} {1,-24} {2,8}  {3,6}  {4}" -f "FINESTRA","PERIODO","DD %","n","ESITO"))
    foreach($f in $FINESTRE){
      if(-not $f[4]){ continue }
      $x = $sd.Fin[$f[0]]
      if($x -eq $null){ [void]$R.Add(("     {0,-10} {1,-24} {2,8}  {3,6}  {4}" -f $f[0],($f[1]+" - "+$f[2]),"n/d","-","NON ESEGUITA")); continue }
      [void]$R.Add(("     {0,-10} {1,-24} {2,8}  {3,6}  {4}" -f $f[0],($f[1]+" - "+$f[2]),(Fmt2 $x.DD),$x.N,$x.Esito))
    }
    [void]$R.Add("  + LE DUE DIAGNOSTICHE DELL'ORO -- NON SONO CRITERI")
    [void]$R.Add("     Le quattro finestre di casa NON contengono i due eventi che l'IPOTESI")
    [void]$R.Add("     nomina (ottobre 2008 e aprile 2013): il criterio A li copre, ma annegati")
    [void]$R.Add("     in vent'anni. Queste due li isolano. DICHIARANO, non decidono.")
    foreach($f in $FINESTRE){
      if($f[4]){ continue }
      $x = $sd.Fin[$f[0]]
      if($x -eq $null){ [void]$R.Add(("     {0,-10} {1,-24} {2,8}  {3,6}  {4}" -f $f[0],($f[1]+" - "+$f[2]),"n/d","-","NON ESEGUITA")); continue }
      [void]$R.Add(("     {0,-10} {1,-24} {2,8}  {3,6}  {4}" -f $f[0],($f[1]+" - "+$f[2]),(Fmt2 $x.DD),$x.N,$x.Esito))
    }
    [void]$R.Add("")
    [void]$R.Add("  I TRE GATE DEL PASSO 0")
    [void]$R.Add("    1 prima operazione .. " + $sd.PrimaDataUsata + "   (limite: " + $LimiteG2 + ")")
    [void]$R.Add("        misura 1, log del tester ... " + $sd.PrimaDataLog + "   (marcatore " + $sd.MarkLog + ", tipo " + $sd.TipoLog + ")")
    [void]$R.Add("        misura 2, report .htm ...... " + $sd.PrimaDataReport)
    [void]$R.Add("        fonte usata ................ " + $sd.FonteData)
    [void]$R.Add("        >>> FINESTRA: " + $sd.Finestra)
    [void]$R.Add("    2 n totale .......... " + $sd.N + "   (controllo incrociato dal report: " + $sd.NReport + ")")
    [void]$R.Add("    3 gemelli ........... " + $sd.Gemelli)
    [void]$R.Add("")
    [void]$R.Add("  IL CONTRATTO DI QUESTA SEDIA, letto ADESSO dall'artefatto e non a memoria")
    [void]$R.Add("    fonte: report/CONTRATTI_SEDIE.md al pin " + $Pin)
    [void]$R.Add("    stato: " + $sd.ContrStato)
    [void]$R.Add("    riga VERBATIM: " + $sd.ContrRiga)
    if($sd.ContrDD -gt 0){
      [void]$R.Add("    DD promesso " + $sd.ContrDD.ToString("0.00",$INV) + " %   -> soglia 2x = " + (2*$sd.ContrDD).ToString("0.00",$INV) + " %")
    } else {
      [void]$R.Add("    >>> 2x NON CALCOLABILE: il contratto di questa sedia non da' un DD")
      [void]$R.Add("        promesso numerico e confrontabile. IL CRITERIO NON E' STATO TOCCATO:")
      [void]$R.Add("        si dichiara che il DENOMINATORE non esiste. E NON E' UN VIA LIBERA:")
      [void]$R.Add("        una sedia viva sull'oro senza DD promesso non ha NESSUN metro, e la")
      [void]$R.Add("        C3 del 18/08 su di lei non puo' scattare. I numeri A/B/C qui sopra")
      [void]$R.Add("        sono CANDIDATI a riempire quel contratto: riempirlo e' UNA FIRMA")
      [void]$R.Add("        NUOVA di Claudio, non un esito automatico di questo round.")
    }
    [void]$R.Add("    VERDETTO CORSIA RISCHIO: " + $sd.Verdetto)
    if($sd.Gruppo -eq 2){
      [void]$R.Add("    >>> GRUPPO 2: questa sedia e' dichiarata viva su XAUUSD in")
      [void]$R.Add("        FLOTTA_ATTIVA.md (mappa dei 52 grafici del 02/08) ma NON compare in")
      [void]$R.Add("        nessuno dei sette censimenti .chr del 17-19/08, e il censimento")
      [void]$R.Add("        frequenza del 22/08 le misura ZERO trade nello statement")
      [void]$R.Add("        30/03->21/08. Il suo rischio vivo NON ESISTE COME MISURA: il")
      [void]$R.Add("        numero A qui sopra e' un DD-per-1%, non il DD della sedia.")
    }
  }
  [void]$R.Add("")
  [void]$R.Add("=====================================================================")
  [void]$R.Add(" LA SEDIA DICHIARATA E NON MISURATA")
  [void]$R.Add("=====================================================================")
  [void]$R.Add("  Gold_Ichimoku_TK_ATR_EA  XAUUSD  magic 250604  rischio vivo 0,5%")
  [void]$R.Add("  >>> NON MISURABILE con questa macchina, e il motivo e' MISURATO nel")
  [void]$R.Add("      sorgente: l'EA NON HA IL BLOCCO OPTFRAME (zero occorrenze di")
  [void]$R.Add("      'OptResults' in mql5/Experts/Gold_Ichimoku_TK_ATR_EA.mq5). Non scrive")
  [void]$R.Add("      nessun OptResults_*.csv, quindi non esistono ne' il DD (criterio A),")
  [void]$R.Add("      ne' il n, ne' il gate dei gemelli. Non ha nemmeno InpVerbose, quindi")
  [void]$R.Add("      il gate 1 non avrebbe una seconda misura.")
  [void]$R.Add("  >>> NON E' UN VIA LIBERA. E' l'ULTIMA sedia a contratto PARZIALE della")
  [void]$R.Add("      flotta (CONTRATTI_SEDIE.md), i suoi numeri vengono da un ALTRO BROKER")
  [void]$R.Add("      (Tickmill PF 1,54; su BCM lo stesso test dava PF 1,01 / DD 28%) e il")
  [void]$R.Add("      censimento frequenza del 22/08 le misura 63 GIORNI DI SILENZIO.")
  [void]$R.Add("  >>> COME SI MISURA: aggiungere l'OPTFRAME all'EA e' una modifica a una")
  [void]$R.Add("      SEDIA VIVA e vuole una firma. In alternativa si legge il DD dalla")
  [void]$R.Add("      riga 'Drawdown massimo dell'equity' del report .htm di una passata")
  [void]$R.Add("      singola -- ma e' uno strumento nuovo, non validato in nessun round:")
  [void]$R.Add("      va costruito e verificato, non improvvisato dentro questo.")
  [void]$R.Add("")
  [void]$R.Add("=====================================================================")
  [void]$R.Add(" COME SI LEGGE, E IN CHE ORDINE")
  [void]$R.Add("=====================================================================")
  [void]$R.Add("  1. LA TABELLA MADRE per prima. E' la fotografia del rischio di tutta la")
  [void]$R.Add("     concentrazione oro alla data di oggi.")
  [void]$R.Add("  2. IL PASSO 0 DI OGNI SEDIA. Se la FINESTRA e' 'ACCORCIATA', quella riga")
  [void]$R.Add("     va scritta ACCANTO A OGNI NUMERO di quella sedia. Se i GEMELLI")
  [void]$R.Add("     divergono, di quella sedia non si legge niente: banco sporco.")
  [void]$R.Add("  3. IL 2x. E' l'unica decisione del round, ed e' MECCANICA.")
  [void]$R.Add("  4. LA PEGGIOR GIORNATA contro il muro prop giornaliero del 5%.")
  [void]$R.Add("  5. I QUATTRO DD DI REGIME. Qui si guarda se una finestra sola fa il DD di")
  [void]$R.Add("     tutta la storia: sarebbe il segno che il rischio e' concentrato in un")
  [void]$R.Add("     regime -- e su dodici sedie sullo STESSO simbolo quella e' la domanda")
  [void]$R.Add("     che conta di piu'.")
  [void]$R.Add("  6. LE DIAGNOSTICHE 2008/2013: si DICHIARANO. Non decidono niente.")
  [void]$R.Add("  7. IL PROFITTO E IL PF NON SI USANO. Emendamento regola B: il VECCHIO")
  [void]$R.Add("     giudica il RISCHIO, il RECENTE giudica il MERITO. Stanno nei CSV perche'")
  [void]$R.Add("     il CSV e' quello che l'EA scrive, non perche' entrino in un verdetto.")
  [void]$R.Add("  8. QUESTO ROUND NON PROMUOVE E NON BOCCIA NIENTE. Al massimo manda una")
  [void]$R.Add("     sedia in REVISIONE sulla corsia RISCHIO, o propone di riempire un")
  [void]$R.Add("     contratto -- e quella proposta va FIRMATA a parte.")
  [void]$R.Add("  9. QUELLO CHE R100 **NON** PUO' DIRE, ed e' importante: la SOMMA. Dodici")
  [void]$R.Add("     sedie sullo stesso simbolo non fanno un drawdown pari alla somma dei")
  [void]$R.Add("     loro, ne' pari al massimo: dipende da QUANTO SI SOVRAPPONGONO nel")
  [void]$R.Add("     tempo, e questo round misura le sedie UNA PER UNA, mai insieme. Il")
  [void]$R.Add("     drawdown di PORTAFOGLIO dell'oro e' un round diverso (la macchina e'")
  [void]$R.Add("     quella dei round di portafoglio, R16/R34/R37/R41), e su una")
  [void]$R.Add("     concentrazione come questa e' la domanda successiva ovvia.")
  [void]$R.Add("")
  [void]$R.Add("--- CHE COSA E' [DA CONFERMARE] DELLE CELLE ---")
  [void]$R.Add("  GRUPPO 1: del grafico vivo il censimento .chr misura TRE cose -- magic,")
  [void]$R.Add("  rischio e commento -- e su tutte e tre le celle di R100 coincidono. Gli")
  [void]$R.Add("  ALTRI input sono i DEFAULT DEL SORGENTE al pin, tranne dove esiste un")
  [void]$R.Add("  artefatto di deploy: MAXMIN ORO (report/VIVAIO_ORO_DEPLOY.md, cella")
  [void]$R.Add("  campo per campo) e LARRY ORO (preset VIVAIO_LARRY_ORO di")
  [void]$R.Add("  deploy_vivaio_larry.ps1). Se sul VPS qualcuno ha toccato un input a mano,")
  [void]$R.Add("  questo round misura IL SORGENTE e non LA SEDIA. La conferma vera e'")
  [void]$R.Add("  leggere i .chr dei grafici, input per input.")
  [void]$R.Add("  GRUPPO 2: TUTTO e' default del sorgente, rischio compreso. Vedi sopra.")
  [void]$R.Add("")
  [void]$R.Add("--- PASSO 0-A (le barre, una volta per tutte le sedie) ---")
  [void]$R.Add("  " + $Storico.Esito + "   (chieste dal " + $DaQuando + ", TF M1,H1,H2,H4,D1)")
  [void]$R.Add("  NIENTE TICK: il round e' OHLC M1 per criterio. Le barre M1 servono davvero:")
  [void]$R.Add("  il tester costruisce H1/H2/H4/D1 dalle M1, quindi la profondita' che MORDE")
  [void]$R.Add("  e' quella dell'M1.")
  [void]$R.Add("")
  [void]$R.Add("--- NOTE ---")
  if($Note.Count -eq 0){ [void]$R.Add("  (nessuna)") }
  foreach($n in $Note){ [void]$R.Add("  - " + $n) }
  [void]$R.Add("")
  [void]$R.Add("--- PROBLEMI ---")
  if($Problemi.Count -eq 0){ [void]$R.Add("  (nessuno)") }
  foreach($p in $Problemi){ [void]$R.Add("  - " + $p) }
  [void]$R.Add("")
  if($Fatale -ne ""){ [void]$R.Add("ESITO: FERMATO -- " + $Fatale) }
  elseif($SoloControllo){
    if($Problemi.Count -gt 0){
      [void]$R.Add("ESITO: GIRO A VUOTO CON PROBLEMI -- " + $Problemi.Count + " problemi nell'elenco qui sopra.")
      [void]$R.Add("       NESSUNA passata, NESSUN numero. IL CONTROLLO NON E' PASSATO: la")
      [void]$R.Add("       corsa vera NON si lancia finche' l'elenco dei PROBLEMI non e' vuoto.")
    } else {
      [void]$R.Add("ESITO: GIRO A VUOTO COMPLETATO -- NESSUNA passata, NESSUN numero di round")
      [void]$R.Add("       in questo file. QUESTO ZIP NON E' IL ROUND: non va mandato come risultato.")
    }
  }
  else{
    $ko = @($Lavoro | Where-Object { $_.Esito -ne "OK" })
    if($ko.Count -gt 0 -or $Problemi.Count -gt 0){
      [void]$R.Add("ESITO: PARZIALE -- " + $ko.Count + " sedie su " + $Lavoro.Count + " non sono OK, e " + $Problemi.Count + " problemi in elenco. NON e' un round completo.")
    }
    else{ [void]$R.Add("ESITO: OK -- tutte le sedie hanno prodotto i numeri attesi, nessun problema in elenco.") }
  }
  Set-Content -LiteralPath $Referto -Value $R -Encoding ASCII

  Remove-Item -LiteralPath $Zip -Force -ErrorAction SilentlyContinue
  Compress-Archive -Path (Join-Path $Cart "*") -DestinationPath $Zip -Force
  Dico ("zip pronto: " + $Zip) "Green"
}catch{
  Write-Host ("!! raccolta incompleta: " + $_.Exception.Message) -ForegroundColor Red
}

# =====================================================================
#  5. COSA DEVE VEDERE CLAUDIO SULLO SCHERMO
# =====================================================================
Write-Host ""
Write-Host "=====================================================================" -ForegroundColor White
Write-Host "  FINITO. File da verificare, uno per uno:" -ForegroundColor White
#  >>> NON SI ANNUNCIA UN ARTEFATTO CHE NON ESISTE (checklist 22). <<<
function Riga3($path,$coda){
  if(Test-Path -LiteralPath $path){ Write-Host ("   " + $path + "   " + $coda) -ForegroundColor White }
  else                            { Write-Host ("   " + $path + "   <<< NON ESISTE") -ForegroundColor Red }
}
Riga3 $Cart    ""
Riga3 $Zip     "<- e' questo che mi mandi"
Riga3 $Referto "<- la riga 'data:' deve essere di ADESSO, la riga 'modo:' dice se e' il round o un giro a vuoto"
Write-Host "=====================================================================" -ForegroundColor White
if($SoloControllo){
  Write-Host ("  MODO: " + $Modo + " -- GIRO A VUOTO. NESSUNA passata, NESSUN numero di round.") -ForegroundColor Yellow
  Write-Host  "        QUESTO ZIP NON E' IL ROUND." -ForegroundColor Yellow
} else {
  Write-Host ("  MODO: " + $Modo) -ForegroundColor White
  Write-Host  "  LA TABELLA MADRE:" -ForegroundColor White
  Write-Host  ("   " + ("{0,-4} {1,-42} {2,-6} {3,8} {4,9} {5,5}  {6}" -f "ID","EA","RISCH","DDPROM","DD22ANNI","2x?","VERDETTO")) -ForegroundColor White
  foreach($sd in $Lavoro){
    $ddp = "n/d"; if($sd.ContrDD -gt 0){ $ddp = $sd.ContrDD.ToString("0.00",$INV) }
    $due = "n/d"
    if($sd.ContrDD -gt 0 -and $sd.DDLungo -ge 0){ if($sd.DDLungo -gt (2*$sd.ContrDD)){ $due = "SI" } else { $due = "no" } }
    $c = "White"; if($due -eq "SI"){ $c = "Red" } elseif($sd.Esito -ne "OK"){ $c = "Yellow" }
    Write-Host ("   " + ("{0,-4} {1,-42} {2,-6} {3,8} {4,9} {5,5}  {6}" -f $sd.Id,$sd.Ea,($sd.Risk+"%"),$ddp,(Fmt2 $sd.DDLungo),$due,$sd.Verdetto)) -ForegroundColor $c
  }
  Write-Host ""
  Write-Host  "  + 1 sedia DICHIARATA E NON MISURATA: Gold_Ichimoku_TK_ATR_EA 250604" -ForegroundColor Yellow
  Write-Host  "    (nessun OPTFRAME nel sorgente -> nessun OptResults -> nessun DD)." -ForegroundColor Yellow
  Write-Host  "  >>> E R100 NON dice il DD di PORTAFOGLIO dell'oro: misura le sedie una" -ForegroundColor Yellow
  Write-Host  "      per una. La somma e' un round diverso." -ForegroundColor Yellow
}
if($Problemi.Count -gt 0){
  Write-Host ""
  Write-Host "   PROBLEMI DA LEGGERE:" -ForegroundColor Red
  foreach($p in $Problemi){ Write-Host ("    - " + $p) -ForegroundColor Red }
}
Write-Host ""
#  L'ESITO IN CONSOLE DEVE DIRE LE STESSE PAROLE DEL REFERTO, o i due si
#  contraddicono: chi legge lo schermo e manda lo zip non ha visto il referto.
if($Fatale -ne ""){ Write-Host ("ESITO: FERMATO -- " + $Fatale) -ForegroundColor Red; exit 1 }
$ko = @($Lavoro | Where-Object { $_.Esito -ne "OK" -and $_.Esito -ne "SOLO CONTROLLO" })
if($SoloControllo){
  if($ko.Count -gt 0 -or $Problemi.Count -gt 0){
    Write-Host ("ESITO: GIRO A VUOTO CON PROBLEMI (" + $Problemi.Count + ") -- NESSUNA passata, e c'e' da leggere il referto") -ForegroundColor Yellow; exit 1
  }
  Write-Host "ESITO: GIRO A VUOTO COMPLETATO -- NESSUNA passata, NESSUN numero. QUESTO ZIP NON E' IL ROUND." -ForegroundColor Green
  exit 0
}
if($ko.Count -gt 0 -or $Problemi.Count -gt 0){
  Write-Host ("ESITO: PARZIALE (" + $ko.Count + " sedie non OK, " + $Problemi.Count + " problemi)") -ForegroundColor Yellow; exit 1
}
Write-Host "ESITO: OK" -ForegroundColor Green
