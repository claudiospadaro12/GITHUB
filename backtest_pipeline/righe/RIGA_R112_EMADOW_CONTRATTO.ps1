# =====================================================================
#  MARCATORE_RIGA_R112_v1
#  RIGA_R112_EMADOW_CONTRATTO.ps1  --  R112: IL CONTRATTO DELL'EMADOW.
#  SHORT-ONLY, E A QUALE DIAL? Una sola famiglia (ABTG_EMA200 su U30USD
#  H1, sedia viva 771531) e QUATTRO celle:
#     00_metro     L+S  rischio 1.0   magic 763400/763401  (denominatore)
#     01_short_r1  S    rischio 1.0   magic 763410/763411  (lo short di R110)
#     02_short_r2  S    rischio 2.0   magic 763420/763421  (scala del dial)
#     03_short_r3  S    rischio 3.0   magic 763430/763431  (pari-DD atteso)
# ---------------------------------------------------------------------
#  CRITERI:   backtest_pipeline\risultati_archivio\R112_CRITERI.md
#  ORIGINE:   Claudio, 26/08/2026 sera: "PREPARA IL ROUND CONTRATTO
#             EMADOW SHORT" -- dopo il titolo di R110 (EMADOW short:
#             OOS PF 1,891 su n 302, DD 2,66% contro 7,83% della sedia).
#
#  >>> I CRITERI SONO DA FIRMARE (SEI decisioni, par. 10). Questo driver
#      LEGGE il file dei criteri al pin e, se ci trova ancora la stringa
#      del lucchetto (composta nel codice, MAI scritta per esteso qui:
#      checklist 82), la CORSA VERA non parte (exit 2). Il GIRO A VUOTO
#      parte lo stesso. -CriteriFirmati e' la firma IN RIGA di Claudio;
#      su un file gia' firmato e' INERTE e il referto lo dice.
#
#  DA DOVE NASCE, dichiarato: e' RIGA_R110_LATI_VIVI.ps1
#  (MARCATORE_RIGA_R110_v1, girata il 25-26/08, 12 celle 0 guasti)
#  ridotta da QUATTRO famiglie a UNA e adattata da "lati" a "contratto":
#  l'asse non e' piu' il LATO, e' il DIAL DI RISCHIO (InpRiskPercent)
#  sul solo lato short. Il punto 9 della checklist dice che una
#  riscrittura non puo' perdere le funzioni di sicurezza del gemello:
#  sono state riportate TUTTE -- guardia MT5/MetaEditor chiusi, -Pin
#  senza default, gate della firma a tre rami (checklist 82), pin di
#  $EABranch DENTRO il driver generico, [Charts] MaxBars con gate sullo
#  stato finale, AllowLiveTrading=false CONTATO, install dell'include,
#  gate delle righe vive, ANTENATO per nome, STELLA, VALORI e geometria
#  d'identita', asse unico InpMagic, magic vietati (con RANGE 7633xx),
#  compilazione diretta con verdetto LastWriteTime + backup datato +
#  ripristino, sosta svuotata, raccolta e variabili SOPRA il try, modo
#  nel nome, pulizia per nome, cultura invariante, \r? sui $ multilinea,
#  raccolta SEMPRE, exit esplicito su ogni ramo, sentinella su TUTTE le
#  colonne, ricontrollo della finestra prima di ogni lancio (checklist
#  79), rilettura dei gen_*.ini che hanno girato.
#
#  ------------------------------------------------------------------
#  COSA CAMBIA RISPETTO A R110, e perche'
#
#  (D3)  G0-B STAVOLTA E' APPLICABILE, ED E' FATALE. R110 e R112 girano
#        su STESSO banco (modello 4, tick reali), STESSA finestra,
#        STESSO split, STESSI input (il magic non tocca la logica).
#        Quindi c'e' QUALCOSA DA RIPRODURRE: 00_metro e 01_short_r1
#        devono riprodurre AL CENTESIMO i CSV di R110 archiviati al pin
#        in prove\R110_CSV_EMADOW\. Confronto: per ciascuna delle 2
#        righe (ordinate per la colonna Pass) le 7 colonne statistiche
#        devono essere IDENTICHE COME STRINGHE -- stesso banco
#        deterministico -> stesse stringhe. Le colonne dei PARAMETRI
#        NON si confrontano: il magic e' diverso per costruzione.
#        TRE esiti (checklist 68): OK / MISMATCH (FATALE) /
#        NON ESEGUITO (CSV mancante: guasto, NON "superato").
#        >>> IL MISMATCH NON FERMA LA RACCOLTA: si raccoglie tutto e
#            si dichiara. Ferma pero' il LANCIO delle celle successive:
#            se il banco non riproduce, i numeri nuovi non si leggono.
#
#  (D4)  LA PEGGIOR GIORNATA ESISTE, E VIENE DAI PER-TRADE. In R110 la
#        colonna usciva n/d PER COSTRUZIONE (OPTFRAME a 8 colonne,
#        checklist 80). Qui la misura c'e' perche' ABTG_EMA200 scrive a
#        OGNI fine test un CSV per-trade nella cartella COMUNE
#        (abtg_trades_ABTG_EMA200_U30USD_<magic>.csv, separatore ';',
#        una riga per ogni DEAL DI USCITA, close_time in ORA SERVER
#        BCM). Il driver: pulisce i file dei magic 7634xx PRIMA,
#        pretende file FRESCHI dopo ogni cella, MISURA che il file
#        superstite sia la gamba OOS (le gambe girano IS poi OOS e ogni
#        gamba SOVRASCRIVE: sopravvive l'ultima -- ma lo si misura
#        sulle close_time, non lo si assume), confronta i DUE file
#        gemelli riga per riga tranne la colonna magic (G0-C-bis),
#        RICONCILIA i position_id distinti col n OOS dell'OPTFRAME
#        (le RIGHE sono deal di uscita: con TP1 al 50% + trailing una
#        posizione chiude in DUE deal, righe > n e' NORMALE), e calcola
#        le giornate come somma dei net_profit per DATA SERVER.
#        >>> La peggior giornata IS e' n/d PER COSTRUZIONE su tutto il
#            round, e il referto lo dice una volta in testa.
#        >>> DUE denominatori, tutti e due: % sul deposito FISSO 100k e
#            % sull'equity di inizio giornata (100k + cumulato giorni
#            OOS precedenti).
#        >>> E IL LIMITE, dichiarato in ogni tabella: e' la peggior
#            giornata dei CHIUSI. Il muro delle prop guarda il
#            FLOTTANTE: questa e' un PAVIMENTO, non il numero del muro.
#
#  (81)  NIENTE Sort-Object SU CHIAVI CON PARI: il raggruppamento per
#        giornata e' per chiave DISTINTA (la data yyyy.MM.dd) e
#        l'ordinamento cronologico su chiavi tutte distinte e'
#        lessicografico -- zero pari, zero instabilita'. Le top-3
#        peggiori giornate usano lo spareggio UNIVOCO (somma, poi data).
#
#  (66)  SENTINELLA SU TUTTE LE COLONNE, comprese le due nuove
#        (PeggGio%fisso e PeggGio%eq, sentinella IN ALTO 99.9 perche'
#        dove esiste la peggior giornata e' quasi sempre negativa).
#        File per-trade mancante o vecchio -> n/d CON IL MOTIVO, mai 0.
#
#  (---) IL CANCELLO DI PORTAFOGLIO (criteri par. 6) NON LO APPLICA
#        QUESTO DRIVER. Stampa i numeri e le letture (a)(b)(c)(d) per
#        dial come righe INFO: il verdetto lo da' il referto del round,
#        a mano. Nessun deploy esce da qui (G5).
#  ------------------------------------------------------------------
#
#  COSA FA, in ordine, e DA SOLA:
#    0.     si rifiuta di partire se MT5 O MetaEditor sono aperti
#    0-bis. si rifiuta di CORRERE se i criteri non sono firmati
#    1.     scarica AL PIN: walkforward_generico.ps1, i 4 file prova,
#           i 2 ANTENATI di R110, i 4 CSV DI RIFERIMENTO G0-B,
#           il sorgente ABTG_EMA200.mq5 e l'include PausaGuardian
#           - gate di versione + i due lati + InpRiskPercent + export
#             per-trade PRESENTE NEL SORGENTE (misurato, non sperato)
#           - gate delle righe vive (46 per file, antenati compresi)
#           - gate dell'ANTENATO per nome (checklist 72)
#           - gate della STELLA (metro contro le tre short)
#           - gate dei VALORI e della geometria d'identita'
#           - gate dell'asse unico (un solo Y, ed e' InpMagic)
#           - gate dei MAGIC (vergini 7634xx; vietati 771531, 771501 e
#             TUTTO il blocco 7633xx bruciato da R110)
#    2.     FASE COMPILA (un solo EA), invocazione DIRETTA di
#           metaeditor64.exe, verdetto sul LastWriteTime del .ex5
#    3.     pulizia per-trade 7634xx dalla cartella comune, poi la
#           CATENA: 00_metro -> 01_short_r1 -> 02_short_r2 ->
#           03_short_r3. Dal metro escono G0-C (fatale) e G0-B metro
#           (fatale); da 01_short_r1 esce G0-B short (fatale).
#           Dopo OGNI cella: raccolta per-trade + peggior giornata.
#    4.     raccolta SEMPRE: cartella sul Desktop + zip + REFERTO con
#           la tabella madre (con le DUE colonne nuove), i per-trade,
#           i gen_*.ini riletti e le letture INFO del cancello.
#
#  QUELLO CHE NON FA, dichiarato:
#    - NON GIUDICA e NON applica il cancello di portafoglio (par. 6):
#      stampa le letture (a)(b)(c)(d) come INFO, il verdetto e' del
#      referto del round, a mano.
#    - NON promuove niente e NON tocca il forward (G5): la sedia 771531
#      non si tocca, nessun .set nuovo va sul VPS.
#    - NON scarica i TICK e non svuota bases\<server>\ticks.
#    - non misura il flottante intragiornata: la peggior giornata e'
#      dei CHIUSI, ed e' un pavimento (dichiarato ovunque).
#    - non scrive una riga di MQL5.
#    - non ammazza un lavoro in corso allo scadere di -OreMax: smette
#      solo di iniziarne di nuovi (checklist 19).
#
#  QUANTO CI METTE: [STIMA], non una previsione. 4 celle x 2 finestre =
#  8 gambe a tick reali su U30USD (~3-4 min l'una in R110): 30-45
#  minuti piu' la compilazione. -OreMax e' 10, tetto sull'INIZIO.
#
#  LA RIGA CHE SI INCOLLA (blocco INTERO, un comando solo - checklist 21).
#  <PIN> = il commit che contiene QUESTO file: e' l'hash dato in chat.
#
#  & { $ErrorActionPreference='Stop'; [Net.ServicePointManager]::SecurityProtocol=[Net.SecurityProtocolType]::Tls12;
#      if(Get-Process terminal64,metaeditor64 -EA SilentlyContinue){ throw 'MT5 O METAEDITOR APERTO: chiudili e rilancia.' };
#      $pin='<PIN>'; $p="$env:USERPROFILE\RIGA_R112.ps1"; Remove-Item $p -EA SilentlyContinue;
#      irm "https://raw.githubusercontent.com/claudiospadaro12/GITHUB/$pin/backtest_pipeline/righe/RIGA_R112_EMADOW_CONTRATTO.ps1" -OutFile $p;
#      if(-not (Select-String -Path $p -SimpleMatch -Pattern 'MARCATORE_RIGA_R112_v1' -Quiet)){ throw 'SCRIPT VECCHIO' };
#      $global:LASTEXITCODE=0; & $p -Pin $pin -SoloControllo; if($LASTEXITCODE -ne 0){ Write-Host 'ESITO: PARZIALE O FERMO - leggi il REFERTO' } }
#
#  GIRO A VUOTO: e' quello qui sopra (-SoloControllo). Scrive e verifica
#  GLI STESSI .ini che girano nella corsa vera (checklist 33) e NON
#  misura nessun numero: senza tester non esiste nessun n, nessun PF,
#  nessun G0-B, nessun G0-C, nessuna peggior giornata.
# =====================================================================
[CmdletBinding()]
param(
  # -Pin NON ha default: un default silenzioso ("lavoro") farebbe girare la
  #  punta del branch spacciandola per un commit congelato. Meglio morire.
  [string]$Pin        = "",
  [double]$OreMax     = 10.0,      # oltre questo NON si iniziano nuove celle
  [switch]$Rifai,                  # rifa' anche i CSV gia' presenti
  [switch]$SoloControllo,          # giro a vuoto: NON apre MT5
  [switch]$CriteriFirmati,         # >>> lo preme CLAUDIO, non l'agente. Senza,
                                   #     la corsa vera non parte (exit 2). Su
                                   #     un file gia' firmato e' INERTE e va
                                   #     detto (checklist 82).
  [string]$SoloCella  = ""         # es. "R112_02_short_r2.txt": una cella sola
                                   #     (il 00_metro gira lo stesso: e' il
                                   #      denominatore e porta G0-B e G0-C)
)
$ErrorActionPreference = "Stop"
[Threading.Thread]::CurrentThread.CurrentCulture   = [Globalization.CultureInfo]::InvariantCulture
[Threading.Thread]::CurrentThread.CurrentUICulture = [Globalization.CultureInfo]::InvariantCulture
[Net.ServicePointManager]::SecurityProtocol = [Net.SecurityProtocolType]::Tls12
$INV = [Globalization.CultureInfo]::InvariantCulture

$Avvio  = Get-Date
$Stamp  = $Avvio.ToString("yyyyMMdd_HHmm", $INV)
$Dsk    = Join-Path $env:USERPROFILE "Desktop"
$Work   = Join-Path $env:USERPROFILE "abtg_r112"
$Prove  = Join-Path $Work "prove"
$Anten  = Join-Path $Work "antenati"
$RifG0B = Join-Path $Work "riferimenti_g0b"
$Logs   = Join-Path $Work "log_r112"
$SrcDir = Join-Path $Work "src_motori"
$RawPin = "https://raw.githubusercontent.com/claudiospadaro12/GITHUB/$Pin"

#--- LA FINESTRA. IDENTICA A R110, dichiaratamente (criteri par. 1): e'
#    l'unico modo di leggere R112 accanto a R110, ed e' cio' che rende
#    G0-B possibile. Questi due valori sono FISSI e @DAQUANDO viene
#    CONFRONTATO in ogni file prova.
$DaQuando = "2024.09.26"      # muro del feed BCM sugli indici, MISURATO
$Fino     = "2026.06.30"
$Modello  = 4                 # 4 = TICK REALI (lo stesso banco di R110)
$Deposito = 100000            # taglia prop, come R110
$SpreadIni= 0                 # 0 = spread CORRENTE, scritto nell'ini invece
                              #  che lasciato allo stato nascosto del terminale.
$FrazioneIS  = 0.40           # default di walkforward_generico.ps1 (40/60)
$CelleAttese = 2              # le due passate GEMELLE di controllo, per CSV

# =====================================================================
#  LA SEDIA. Una sola famiglia: ABTG_EMA200 su U30USD H1.
#  - EaVersione / MagicSorgente : LETTI NEL SORGENTE al pin (26/08)
#  - MagicVivoSedia             : censimento .chr (771531). Il magic del
#    SORGENTE (771501) NON e' quello della SEDIA: sono numeri diversi,
#    e qui girano magic VERGINI 7634xx (blocco verificato sul repo il
#    26/08, criteri par. 2).
#  - RigheViveAttese            : MISURATE sui 4 file prova E sui 2
#    antenati con grep -cvE '^\s*(#|$)' il 26/08: 46 per tutti.
# =====================================================================
$EaNome          = "ABTG_EMA200"
$EaVersione      = "1.00"
$SimboloRound    = "U30USD"
$PeriodoRound    = "H1"
$MagicSorgente   = "771501"
$MagicVivoSedia  = "771531"
$RigheViveAttese = 46

#--- MAGIC VIETATI (criteri par. 2): la sedia viva, il default del
#    sorgente, e TUTTO il blocco 7633xx bruciato da R110. Il blocco
#    7633xx si vieta come RANGE, non come elenco: elencare 100 numeri a
#    mano e' il modo di dimenticarne uno.
$MagicVietati = @(771531, 771501)
function MagicVietato([int]$numeroMagic){
  if($MagicVietati -contains $numeroMagic){ return $true }
  if($numeroMagic -ge 763300 -and $numeroMagic -le 763399){ return $true }
  return $false
}

# =====================================================================
#  LE QUATTRO CELLE (criteri par. 1 e 2). Per ogni cella:
#  - DiffStella : gli input che DEVONO differire dal 00_metro (oltre a
#    InpMagic, che differisce sempre): e' il gate della STELLA.
#  - AntFile / DeltaAnt : l'ANTENATO R110 scaricato al pin e i SOLI
#    delta ammessi contro di lui, PER NOME (checklist 72). La catena e'
#    R103 -> R110 -> R112: controlli, non frasi.
#  - RifG0BTag : quale coppia di CSV R110 questa cella deve RIPRODURRE
#    (G0-B, decisione D3). Vuoto = la cella non ha riferimento (r2/r3:
#    il loro dial non e' mai stato misurato, e' la misura nuova).
#  - Val : i valori che i gate pretendono NEL FILE (lati + dial).
#  >>> NIENTE HASHTABLE LETTERALE MULTILINEA (checklist 63): Val nasce
#      da una funzione.
# =====================================================================
function ValoriCella([string]$latoLungo,[string]$latoCorto,[string]$dialRischio){
  $tabella = @{}
  $tabella["InpAllowLong"]   = $latoLungo
  $tabella["InpAllowShort"]  = $latoCorto
  $tabella["InpRiskPercent"] = $dialRischio
  return $tabella
}
function CellaNuova([string]$idCella,[string]$fileProva,[string]$descrizione,[int]$magicBase,
                    $diffStella,$deltaAnt,[string]$antFile,[string]$rifG0BTag,$valori,[bool]$eMetro){
  return [pscustomobject]@{
    Id=$idCella; Prova=$fileProva; Desc=$descrizione; Magic=$magicBase;
    DiffStella=@($diffStella); DeltaAnt=@($deltaAnt); AntFile=$antFile;
    RifG0BTag=$rifG0BTag; Val=$valori; Metro=$eMetro;
    Esito="NON ESEGUITA"; IS=-1; OOS=-1; Min=0.0;
    PfOOS=-1.0; DdOOS=-1.0; ProfOOS=-999999.0; NOOS=-1;
    PfIS=-1.0;  DdIS=-1.0;  ProfIS=-999999.0;  NIS=-1;
    Gemelli="NON MISURATO"; Antenato="NON VERIFICATO"; G0B="NON ESEGUITO";
    # --- la macchina per-trade (decisione D4)
    PtStato="NON MISURATA"; PgData=""; PgEuro=-999999.0;
    PgPctFisso=99.9; PgPctEq=99.9; PgGiorni=-1; PgTop3="";
    VolMax=-1.0; VolQuota=-1.0; Riconc="NON ESEGUITA"; GemPt="NON MISURATO"
  }
}
$CELLE = @()
$CELLE += (CellaNuova "00_metro"    "R112_00_metro.txt"    "LA SEDIA VIVA COM'E' (L+S, dial 1,0) -- denominatore, G0-C, G0-B contro R110, e la SUA peggior giornata (mai misurata)" 763400 `
            @() @() "R110_EMADOW_00_metro.txt" "00_metro" (ValoriCella "true" "true" "1.0") $true)
$CELLE += (CellaNuova "01_short_r1" "R112_01_short_r1.txt" "SOLO SHORT, dial 1,0 -- lo short di R110 riprodotto: il gate del banco (G0-B)" 763410 `
            @("InpAllowLong") @() "R110_EMADOW_02_short.txt" "02_short" (ValoriCella "false" "true" "1.0") $false)
$CELLE += (CellaNuova "02_short_r2" "R112_02_short_r2.txt" "SOLO SHORT, dial 2,0 -- la scala del dial, primo gradino (misura NUOVA)" 763420 `
            @("InpAllowLong","InpRiskPercent") @("InpRiskPercent") "R110_EMADOW_02_short.txt" "" (ValoriCella "false" "true" "2.0") $false)
$CELLE += (CellaNuova "03_short_r3" "R112_03_short_r3.txt" "SOLO SHORT, dial 3,0 -- il gradino di pari-DD atteso (7,83/2,66 ~ 2,9; misura NUOVA)" 763430 `
            @("InpAllowLong","InpRiskPercent") @("InpRiskPercent") "R110_EMADOW_02_short.txt" "" (ValoriCella "false" "true" "3.0") $false)

# =====================================================================
#  LA GEOMETRIA D'IDENTITA', pretesa riga per riga in OGNI file. Non e'
#  ridondanza col gate dell'antenato: l'antenato garantisce che i file
#  di R112 siano uguali a quelli di R110, QUESTO garantisce che siano
#  la cella che i criteri descrivono, anche se qualcuno corrompesse
#  ANCHE gli antenati in repo.
#  >>> InpAllowLong, InpAllowShort e InpRiskPercent NON SONO QUI: sono
#      GLI ASSI DEL ROUND (lato e dial), e il loro valore lo pretende
#      il gate 'Val' della singola cella.
#  >>> NIENTE HASHTABLE LETTERALE MULTILINEA (checklist 63).
#  Fonte: prove\R110_EMADOW_00_metro.txt, letto riga per riga il 26/08.
# =====================================================================
$GeometriaViva = @(@("InpTF","16385"),@("InpEmaPeriod","200"),@("InpEma14Period","14"),
                   @("InpAtrPeriod","14"),@("InpMinDistAtr","0.3"),@("InpMaxDistAtr","1.5"),
                   @("InpUseEma14Bias","true"),@("InpUseAdrFilter","false"),
                   @("InpOrder1Atr","0.2"),@("InpOrder2Atr","0.3"),@("InpUseOrder2","true"),
                   @("InpSLatr","1.0"),@("InpMinRR","1.0"),@("InpTP_RR","2.0"),
                   @("InpBreakeven","true"),@("InpUseTrailing","true"),
                   @("InpUseCutoff","false"),@("InpUseNewsFilter","false"),
                   @("InpFridayClose","false"),@("InpMaxSpread","0"))

#--- I DELTA AMMESSI CONTRO L'ANTENATO (checklist 72): InpMagic sempre,
#    piu' i DeltaAnt della cella (InpRiskPercent solo su r2/r3).
$DeltaBase = @("InpMagic")

#--- Tolleranza per il confronto fra gemelli (G0-C). G0-B invece e'
#    IDENTITA' DI STRINGA: stesso banco deterministico -> stesse stringhe.
$TolGemelli = 0.005

#--- Le 7 colonne statistiche del confronto G0-B (decisione D3). Le
#    colonne dei PARAMETRI non si confrontano: il magic differisce per
#    costruzione.
$ColonneStatG0B = @("Profit","Expected Payoff","Profit Factor","Recovery Factor","Sharpe Ratio","Equity DD %","Trades")

# =====================================================================
#  TUTTO CIO' CHE LA RACCOLTA USA NASCE QUI, PRIMA DEL try (checklist
#  41-bis), FUNZIONI COMPRESE (checklist 48).
# =====================================================================
$Risultati = Join-Path $Work "risultati_prove"
$Sosta     = Join-Path $Work "sosta"
$Problemi  = New-Object System.Collections.ArrayList
$Rilievi   = New-Object System.Collections.ArrayList
$Fatale    = ""
$Firma     = "NON LETTA"
#  >>> CHECKLIST 41-bis e 82: $daFirmare lo LEGGE la raccolta, che sta
#      FUORI dal try. Il valore prudente e' $true: "non ho letto" non e'
#      "e' firmato".
$daFirmare = $true
#  >>> IL LUCCHETTO SI COMPONE, NON SI SCRIVE (checklist 82, regola 1):
#      se questo file portasse la stringa per esteso, un grep sul repo
#      per spegnere lo stato troverebbe anche noi.
$LucchettoFirma = '[DA ' + 'FIRMARE]'
$Terminal  = ""; $MetaEditor = ""; $DataFolder = ""; $CommonFiles = ""
$Ordinati  = @()      # checklist 41-bis: la raccolta lo scorre SEMPRE
$Vive      = @{}
$CatenaFerma = ""     # motivo per cui le celle successive NON partono
$SelettoreAVuoto = $false
$EaCompilato = $false

function Ora(){ return (Get-Date).ToString("HH:mm:ss", $INV) }
function Dico([string]$testo,[string]$colore="Gray"){ Write-Host ("[" + (Ora) + "] " + $testo) -ForegroundColor $colore }
function Titolo([string]$testo){ Write-Host ""; Write-Host ("=== " + $testo + " ===") -ForegroundColor Cyan }

function Scarica([string]$urlSorgente,[string]$destinazione,[string]$marcatore){
  Remove-Item -LiteralPath $destinazione -Force -ErrorAction SilentlyContinue
  Invoke-WebRequest -Uri $urlSorgente -OutFile $destinazione -UseBasicParsing -ErrorAction Stop
  if(-not (Test-Path -LiteralPath $destinazione)){ throw ("scarico fallito: " + $urlSorgente) }
  if($marcatore -ne "" -and -not (Select-String -LiteralPath $destinazione -SimpleMatch -Pattern $marcatore -Quiet)){
    throw ("file scaricato SENZA il marcatore '" + $marcatore + "': " + $urlSorgente)
  }
}

function RigheVive([string]$percorso){
  return @(Get-Content -LiteralPath $percorso | Where-Object { $_ -notmatch '^\s*#' -and $_ -notmatch '^\s*$' })
}
function NomeDi([string]$rigaViva){
  if($rigaViva -match '^@'){ return ($rigaViva -split '\s+')[0] }
  return (($rigaViva -split '=')[0]).Trim()
}
function ValoreDi([string]$rigaViva){
  if($rigaViva -match '^@'){ return (($rigaViva -split '\s+',2)[1]).Trim() }
  $posUguale = $rigaViva.IndexOf("=")
  if($posUguale -lt 0){ return "" }
  return $rigaViva.Substring($posUguale+1).Trim()
}
#  MAPPA NOME -> VALORE: e' cosi' che si confronta con l'ANTENATO, per
#  NOME e mai per posizione (checklist 72 e 58). Un doppione di nome e'
#  un guasto in se' (in [TesterInputs] fa fare a MT5 ZERO passate).
function MappaDi($elencoRighe){
  $mappa = @{}
  foreach($rigaCorr in @($elencoRighe)){
    $nomeChiave = NomeDi $rigaCorr
    if($mappa.ContainsKey($nomeChiave)){ throw ("il file ha DUE righe per '" + $nomeChiave + "': in [TesterInputs] un parametro doppio fa fare a MT5 ZERO passate.") }
    $mappa[$nomeChiave] = (ValoreDi $rigaCorr)
  }
  return $mappa
}
function CsvDi($cella,[string]$tagFinestra){
  #  A Modello 4 il driver generico NON aggiunge il suffisso "_ohlc".
  return (Join-Path $Risultati ($EaNome + "\" + $EaNome + "_" + $SimboloRound + "_" + $tagFinestra + "_" + $cella.Id + ".csv"))
}

# ---------------------------------------------------------------------
#  LA CONVENZIONE DI SENTINELLA, E VALE PER TUTTE LE COLONNE (checklist
#  66): decimali non misurati -1.0 -> "n/d"; interi -1 -> "n/d";
#  profitto -999999 -> "n/d" (il profitto puo' essere negativo, -1 non
#  va bene); peggior giornata 99.9 -> "n/d" (dove esiste e' quasi
#  sempre NEGATIVA: il sentinella sta IN ALTO).
# ---------------------------------------------------------------------
function Fmt2($valore){
  if($null -eq $valore){ return "n/d" }
  if([double]$valore -lt 0){ return "n/d" }
  return ([double]$valore).ToString("0.00",$INV)
}
function Fmt3($valore){
  if($null -eq $valore){ return "n/d" }
  if([double]$valore -lt 0){ return "n/d" }
  return ([double]$valore).ToString("0.000",$INV)
}
function FmtN($valore){
  if($null -eq $valore){ return "n/d" }
  if([int]$valore -lt 0){ return "n/d" }
  return ([int]$valore).ToString($INV)
}
function FmtE($valore){
  if($null -eq $valore){ return "n/d" }
  if([double]$valore -le -999998.0){ return "n/d" }
  return ([double]$valore).ToString("+0;-0;0",$INV)
}
function FmtPg($valore){
  if($null -eq $valore){ return "n/d" }
  if([double]$valore -ge 99.0){ return "n/d" }
  return ([double]$valore).ToString("+0.00;-0.00;0.00",$INV)
}
function NumInv($testoNumero){
  $valoreParse = 0.0
  $testoPulito = ("" + $testoNumero).Replace([string][char]160,"").Replace([string][char]8239,"").Replace([string][char]8201,"").Replace(" ","").Trim()
  if($testoPulito -eq ""){ return $null }
  if([double]::TryParse($testoPulito,[Globalization.NumberStyles]::Float,$INV,[ref]$valoreParse)){ return $valoreParse }
  return $null
}
