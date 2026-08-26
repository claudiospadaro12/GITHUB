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
#  >>> LA FIRMA DEI CRITERI SI LEGGE NEL FILE AL PIN, NON SI RICORDA:
#      se il driver ci trova ancora la stringa del lucchetto (composta
#      nel codice, MAI scritta per esteso qui: checklist 82), la CORSA
#      VERA non parte (exit 2); il GIRO A VUOTO parte lo stesso.
#      [Alla stesura di questa riga i criteri risultano FIRMATI: "FIRMO
#      R112", Claudio 26/08/2026 sera, lucchetto tolto da tutto il file
#      -- ma fa fede SOLO cio' che il gate legge al pin, non questa
#      nota.] -CriteriFirmati e' la firma IN RIGA di Claudio; su un
#      file gia' firmato e' INERTE e il referto lo dice.
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
#  L'euro della peggior giornata si stampa COI CENTESIMI (le top-3 li
#  portano gia': due formati diversi per lo stesso numero sarebbero il
#  difetto 83 in miniatura). Sentinella come FmtE (-999999 -> n/d).
function FmtEuroCent($valore){
  if($null -eq $valore){ return "n/d" }
  if([double]$valore -le -999998.0){ return "n/d" }
  return ([double]$valore).ToString("+0.00;-0.00;0.00",$INV)
}
function NumInv($testoNumero){
  $valoreParse = 0.0
  $testoPulito = ("" + $testoNumero).Replace([string][char]160,"").Replace([string][char]8239,"").Replace([string][char]8201,"").Replace(" ","").Trim()
  if($testoPulito -eq ""){ return $null }
  if([double]::TryParse($testoPulito,[Globalization.NumberStyles]::Float,$INV,[ref]$valoreParse)){ return $valoreParse }
  return $null
}

# =====================================================================
#  IL PARSER DEL CSV DI OTTIMIZZAZIONE -- con il CONTROLLO POSITIVO.
#  Colonne PER NOME, sinonimi completi, e se non riconosce le colonne
#  torna $null E DICE QUALI INTESTAZIONI HA VISTO.
#  >>> L'INTESTAZIONE VERA, LETTA NEL SORGENTE AL PIN (checklist 80):
#        Pass,Profit,Expected Payoff,Profit Factor,Recovery Factor,
#        Sharpe Ratio,Equity DD %,Trades,<gli input>
#      OTTO colonne statistiche. 'Peggior Giornata %' NON C'E' e non
#      ci sara' MAI da questo EA: in R112 la peggior giornata viene
#      dai PER-TRADE (decisione D4), non dall'OPTFRAME.
# =====================================================================
$script:CsvIntestazioni = @()
function LeggiOpt([string]$percorsoCsv){
  if(-not (Test-Path -LiteralPath $percorsoCsv)){ return $null }
  $righeCsv = @()
  try{ $righeCsv = @(Import-Csv -LiteralPath $percorsoCsv) }catch{ return $null }
  if($righeCsv.Count -eq 0){ return $null }
  $nomiColonne = @($righeCsv[0].PSObject.Properties.Name)
  $script:CsvIntestazioni = $nomiColonne
  function TrovaColonna($candidati){
    foreach($candidato in $candidati){
      foreach($nomeCol in $nomiColonne){ if(("" + $nomeCol).Trim().ToLower() -eq $candidato){ return $nomeCol } }
    }
    return $null
  }
  $colProf = TrovaColonna @("profit","profitto","utile")
  $colPf   = TrovaColonna @("profit factor","fattore di profitto")
  $colDd   = TrovaColonna @("equity dd %","drawdown equity %","equity drawdown %","drawdown %")
  $colN    = TrovaColonna @("trades","operazioni","trade")
  $colMg   = TrovaColonna @("inpmagic")
  if($null -eq $colProf -or $null -eq $colPf -or $null -eq $colDd -or $null -eq $colN){ return $null }
  $elencoLetture = New-Object System.Collections.ArrayList
  foreach($rigaCsv in $righeCsv){
    [void]$elencoLetture.Add([pscustomobject]@{
      Profit = (NumInv $rigaCsv.$colProf)
      Pf     = (NumInv $rigaCsv.$colPf)
      Dd     = (NumInv $rigaCsv.$colDd)
      N      = (NumInv $rigaCsv.$colN)
      Magic  = $(if($null -ne $colMg){ ("" + $rigaCsv.$colMg).Trim() } else { "" })
    })
  }
  return @($elencoLetture)
}

#  I GEMELLI (G0-C): le due righe identiche al centesimo su profitto,
#  PF, DD e n. E SI PRETENDE CHE SIANO DUE: "una riga sola" e' uno
#  sweep che non ha spazzolato (checklist 55).
function Gemelli($lettureCsv){
  if($null -eq $lettureCsv){ return "NON MISURATO (CSV non letto)" }
  if(@($lettureCsv).Count -ne 2){ return ("NON VALIDO: " + @($lettureCsv).Count + " righe invece di 2") }
  $gemA = $lettureCsv[0]; $gemB = $lettureCsv[1]
  foreach($confronto in @(@("profitto",$gemA.Profit,$gemB.Profit),@("PF",$gemA.Pf,$gemB.Pf),
                          @("DD",$gemA.Dd,$gemB.Dd),@("n",$gemA.N,$gemB.N))){
    if($null -eq $confronto[1] -or $null -eq $confronto[2]){ return ("NON MISURATO (" + $confronto[0] + " illeggibile)") }
    if([math]::Abs([double]$confronto[1] - [double]$confronto[2]) -gt $TolGemelli){
      return ("DIVERSI su " + $confronto[0] + ": " + $confronto[1] + " contro " + $confronto[2])
    }
  }
  return "IDENTICI"
}

# =====================================================================
#  G0-B: LA RIPRODUZIONE DI R110 (decisione D3). Stesso banco, stessa
#  finestra, stessi input -> le 7 colonne statistiche delle 2 righe
#  devono essere IDENTICHE COME STRINGHE. TRE esiti (checklist 68):
#  "OK" / "MISMATCH: ..." (FATALE) / "NON ESEGUITO (...)" (guasto,
#  NON "superato").
#  >>> Il confronto e' -cne (case sensitive, da stringa a stringa):
#      niente parse numerico, niente tolleranze. Un banco deterministico
#      scrive le STESSE stringhe; se non le scrive, la notizia e' quella.
#  >>> Sort-Object sulla colonna Pass: DUE valori interi DISTINTI per
#      costruzione (lo sweep InpMagic fa pass 1 e 2), zero pari,
#      checklist 81 non ha presa.
# =====================================================================
function ConfrontaG0B([string]$csvNuovo,[string]$csvRiferimento){
  if(-not (Test-Path -LiteralPath $csvNuovo)){ return ("NON ESEGUITO (manca il CSV nuovo: " + (Split-Path -Leaf $csvNuovo) + ")") }
  if(-not (Test-Path -LiteralPath $csvRiferimento)){ return ("NON ESEGUITO (manca il CSV di riferimento: " + (Split-Path -Leaf $csvRiferimento) + ")") }
  $tabNuova = @(); $tabRif = @()
  try{
    $tabNuova = @(Import-Csv -LiteralPath $csvNuovo)
    $tabRif   = @(Import-Csv -LiteralPath $csvRiferimento)
  }catch{ return ("NON ESEGUITO (CSV illeggibile: " + $_.Exception.Message + ")") }
  if($tabNuova.Count -ne 2 -or $tabRif.Count -ne 2){
    return ("NON ESEGUITO (righe dati: nuovo " + $tabNuova.Count + ", riferimento " + $tabRif.Count + " -- attese 2 e 2)")
  }
  foreach($colAttesa in (@("Pass") + $ColonneStatG0B)){
    if(@($tabNuova[0].PSObject.Properties.Name) -notcontains $colAttesa){ return ("NON ESEGUITO (nel CSV nuovo manca la colonna '" + $colAttesa + "')") }
    if(@($tabRif[0].PSObject.Properties.Name)   -notcontains $colAttesa){ return ("NON ESEGUITO (nel CSV di riferimento manca la colonna '" + $colAttesa + "')") }
  }
  $ordNuova = @($tabNuova | Sort-Object { [int]$_.Pass })
  $ordRif   = @($tabRif   | Sort-Object { [int]$_.Pass })
  $diffTrovate = New-Object System.Collections.ArrayList
  for($iRiga=0; $iRiga -lt 2; $iRiga++){
    foreach($colStat in $ColonneStatG0B){
      $valNuovo = ("" + $ordNuova[$iRiga].$colStat).Trim()
      $valRif   = ("" + $ordRif[$iRiga].$colStat).Trim()
      if($valNuovo -cne $valRif){
        [void]$diffTrovate.Add("riga " + ($iRiga+1) + " '" + $colStat + "': nuovo [" + $valNuovo + "] contro R110 [" + $valRif + "]")
      }
    }
  }
  if($diffTrovate.Count -gt 0){ return ("MISMATCH: " + ($diffTrovate -join " ; ")) }
  return "OK"
}

# =====================================================================
#  LA MACCHINA PER-TRADE (decisione D4, criteri par. 4). Per una cella
#  appena girata:
#   1. pretende i DUE file gemelli abtg_trades_* FRESCHI (LastWriteTime
#      >= avvio della cella): mancante o vecchio -> n/d COL MOTIVO,
#      mai zero (checklist 66);
#   2. li copia nella cartella di lavoro come pertrade_<cella>_<magic>.csv;
#   3. G0-C-bis: identici riga per riga TRANNE la colonna magic
#      (indice 2 dopo lo split su ';');
#   4. IDENTITA' DI GAMBA, MISURATA: le gambe girano IS poi OOS e ogni
#      gamba SOVRASCRIVE il file del magic, quindi deve sopravvivere
#      l'OOS -- ma lo si MISURA: se anche UNA close_time cade prima
#      dell'inizio OOS, il file non e' la gamba OOS pura -> n/d;
#   5. RICONCILIAZIONE (dichiarata, non fatale): position_id DISTINTI
#      contro il n OOS dell'OPTFRAME. Le RIGHE sono deal di USCITA:
#      con TP1 al 50% + trailing una posizione chiude in DUE deal,
#      righe > n e' NORMALE. Scarto -> "SCARTO DICHIARATO";
#   6. CALCOLO (solo OOS): giornata = somma dei net_profit per DATA
#      SERVER. Raggruppamento per chiave DISTINTA e ordinamento
#      lessicografico su date tutte distinte: checklist 81 non ha
#      presa. Top-3 con spareggio UNIVOCO (somma, poi data).
#  Tutto il parsing numerico e di data e' INVARIANT CULTURE.
# =====================================================================
function AnalisiPerTrade($cella,[datetime]$avvioCella){
  $magPrimo   = [int]$cella.Magic
  $magSecondo = $magPrimo + 1
  $fileGemelli = @{}
  foreach($magCorrente in @($magPrimo,$magSecondo)){
    $percorsoPt = Join-Path $CommonFiles ("abtg_trades_" + $EaNome + "_" + $SimboloRound + "_" + $magCorrente + ".csv")
    if(-not (Test-Path -LiteralPath $percorsoPt)){
      $cella.PtStato = "n/d (il file per-trade del magic " + $magCorrente + " NON esiste in Common\Files: o il pass non e' girato -- cache del tester? -- o l'export non ha scritto)"
      [void]$Problemi.Add($cella.Prova + ": " + $cella.PtStato + ". La peggior giornata di questa cella NON e' misurata.")
      return
    }
    $etaFile = (Get-Item -LiteralPath $percorsoPt).LastWriteTime
    if($etaFile -lt $avvioCella){
      $cella.PtStato = "n/d (il file per-trade del magic " + $magCorrente + " e' VECCHIO: LastWriteTime " + $etaFile.ToString("yyyy-MM-dd HH:mm:ss",$INV) + ", cella avviata " + $avvioCella.ToString("yyyy-MM-dd HH:mm:ss",$INV) + " -- e' di un giro precedente)"
      [void]$Problemi.Add($cella.Prova + ": " + $cella.PtStato + ". La peggior giornata di questa cella NON e' misurata.")
      return
    }
    $fileGemelli[$magCorrente] = $percorsoPt
    Copy-Item -LiteralPath $percorsoPt -Destination (Join-Path $Work ("pertrade_" + $cella.Id + "_" + $magCorrente + ".csv")) -Force
  }
  # --- G0-C-bis: i due gemelli identici tranne la colonna magic (indice 2)
  $righePtA = @(Get-Content -LiteralPath $fileGemelli[$magPrimo])
  $righePtB = @(Get-Content -LiteralPath $fileGemelli[$magSecondo])
  if($righePtA.Count -ne $righePtB.Count){
    $cella.GemPt = "DIVERSI (righe: " + $righePtA.Count + " contro " + $righePtB.Count + ")"
    $cella.PtStato = "n/d (G0-C-bis fallito: i due file per-trade gemelli hanno un numero diverso di righe)"
    [void]$Problemi.Add($cella.Prova + ": G0-C-bis FALLITO -- " + $cella.GemPt + ". Due passate a parametri identici devono chiudere gli stessi trade: questa cella non si legge, peggior giornata n/d.")
    return
  }
  $righeDiverse = 0
  for($iRigaPt=0; $iRigaPt -lt $righePtA.Count; $iRigaPt++){
    $campiA = @($righePtA[$iRigaPt] -split ';')
    $campiB = @($righePtB[$iRigaPt] -split ';')
    if($campiA.Count -gt 2){ $campiA[2] = "" }   # la colonna magic si azzera
    if($campiB.Count -gt 2){ $campiB[2] = "" }   # prima del confronto
    if(($campiA -join ';') -cne ($campiB -join ';')){ $righeDiverse++ }
  }
  if($righeDiverse -gt 0){
    $cella.GemPt = "DIVERSI (" + $righeDiverse + " righe su " + $righePtA.Count + " differiscono oltre la colonna magic)"
    $cella.PtStato = "n/d (G0-C-bis fallito: i per-trade gemelli non sono identici a meno del magic)"
    [void]$Problemi.Add($cella.Prova + ": G0-C-bis FALLITO -- " + $cella.GemPt + ". E' il G0-C portato al livello del singolo trade: questa cella non si legge, peggior giornata n/d.")
    return
  }
  $cella.GemPt = "IDENTICI (a meno della colonna magic, " + $righePtA.Count + " righe)"
  # --- intestazione e parsing (dal file del PRIMO magic: sono identici)
  if($righePtA.Count -lt 1 -or $righePtA[0] -notlike 'close_time;*'){
    $cella.PtStato = "n/d (il per-trade non inizia con l'intestazione 'close_time;...': formato non riconosciuto, non indovino)"
    [void]$Problemi.Add($cella.Prova + ": " + $cella.PtStato)
    return
  }
  if($righePtA.Count -lt 2){
    $cella.PtStato = "n/d (il per-trade ha SOLO l'intestazione: zero chiusure. Con n OOS atteso > 0 e' un guasto, non un risultato)"
    [void]$Problemi.Add($cella.Prova + ": " + $cella.PtStato)
    return
  }
  $chiusure = New-Object System.Collections.ArrayList
  for($iRigaPt=1; $iRigaPt -lt $righePtA.Count; $iRigaPt++){
    $rigaGrezza = $righePtA[$iRigaPt]
    if(("" + $rigaGrezza).Trim() -eq ""){ continue }
    $campiRiga = @($rigaGrezza -split ';')
    if($campiRiga.Count -ne 8){
      $cella.PtStato = "n/d (riga " + ($iRigaPt+1) + " del per-trade ha " + $campiRiga.Count + " campi invece di 8: file corrotto o formato cambiato)"
      [void]$Problemi.Add($cella.Prova + ": " + $cella.PtStato)
      return
    }
    $dataChiusura = [datetime]::MinValue
    if(-not [datetime]::TryParseExact($campiRiga[0],"yyyy.MM.dd HH:mm:ss",$INV,[Globalization.DateTimeStyles]::None,[ref]$dataChiusura)){
      $cella.PtStato = "n/d (riga " + ($iRigaPt+1) + ": close_time [" + $campiRiga[0] + "] non e' 'yyyy.MM.dd HH:mm:ss'. Non indovino il formato)"
      [void]$Problemi.Add($cella.Prova + ": " + $cella.PtStato)
      return
    }
    $nettoRiga = NumInv $campiRiga[7]
    $volumeRiga = NumInv $campiRiga[5]
    if($null -eq $nettoRiga -or $null -eq $volumeRiga){
      $cella.PtStato = "n/d (riga " + ($iRigaPt+1) + ": net_profit o volume illeggibile in cultura invariante)"
      [void]$Problemi.Add($cella.Prova + ": " + $cella.PtStato)
      return
    }
    [void]$chiusure.Add([pscustomobject]@{ Quando=$dataChiusura; PosId=("" + $campiRiga[3]).Trim(); Volume=[double]$volumeRiga; Netto=[double]$nettoRiga })
  }
  # --- 4) IDENTITA' DI GAMBA, MISURATA NON ASSUNTA
  $fuoriOOS = @($chiusure | Where-Object { $_.Quando -lt $DtOOSInizio })
  if($fuoriOOS.Count -gt 0){
    $cella.PtStato = "n/d (il file NON e' la gamba OOS pura: " + $fuoriOOS.Count + " chiusure su " + $chiusure.Count + " cadono PRIMA dell'inizio OOS " + $OOS_Da + " -- la prima e' del " + ($fuoriOOS[0].Quando.ToString("yyyy.MM.dd HH:mm:ss",$INV)) + ". La gamba sopravvissuta non e' quella attesa)"
    [void]$Problemi.Add($cella.Prova + ": " + $cella.PtStato + " La peggior giornata NON si calcola su una gamba non identificata.")
    return
  }
  # --- 5) RICONCILIAZIONE position_id distinti contro n OOS (dichiarata, non fatale)
  $posDistinti = @{}
  foreach($chiusuraCorr in $chiusure){ $posDistinti[$chiusuraCorr.PosId] = $true }
  $numPosizioni = $posDistinti.Keys.Count
  $scartoRiconc = $false
  if([int]$cella.NOOS -lt 0){
    $cella.Riconc = "NON ESEGUITA (il n OOS dell'OPTFRAME non e' stato letto: non c'e' il termine di confronto)"
  } elseif($numPosizioni -eq [int]$cella.NOOS){
    $cella.Riconc = "OK (" + $numPosizioni + " position_id distinti = n OOS " + $cella.NOOS + "; righe deal di uscita: " + $chiusure.Count + " -- righe > n e' NORMALE con TP1 al 50% + trailing: una posizione chiude in DUE deal)"
  } else {
    $scartoRiconc = $true
    $cella.Riconc = "SCARTO DICHIARATO: " + $numPosizioni + " position_id distinti contro n OOS " + $cella.NOOS + " dell'OPTFRAME (righe deal: " + $chiusure.Count + "). Il confronto giusto e' sui position_id, NON sulle righe (deal di uscita: con TP1+trailing righe > n e' normale). La peggior giornata qui sotto e' calcolata lo stesso ma va letta con questa bandiera."
    [void]$Rilievi.Add($cella.Prova + ": riconciliazione per-trade -- " + $cella.Riconc)
  }
  # --- 6) LE GIORNATE. Chiave = data server yyyy.MM.dd (dalla data GIA'
  #        validata dal ParseExact). Chiavi DISTINTE per costruzione.
  $sommaGiorno = @{}
  foreach($chiusuraCorr in $chiusure){
    $chiaveGiorno = $chiusuraCorr.Quando.ToString("yyyy.MM.dd",$INV)
    if(-not $sommaGiorno.ContainsKey($chiaveGiorno)){ $sommaGiorno[$chiaveGiorno] = 0.0 }
    $sommaGiorno[$chiaveGiorno] = [double]$sommaGiorno[$chiaveGiorno] + $chiusuraCorr.Netto
  }
  #  ordinamento CRONOLOGICO = lessicografico su yyyy.MM.dd, e le chiavi
  #  sono TUTTE DISTINTE (sono le chiavi di un hashtable): niente pari,
  #  checklist 81 non ha presa. Serve per l'equity di inizio giornata.
  $giorniOrdinati = @($sommaGiorno.Keys | Sort-Object)
  $cumulato = 0.0
  $peggioreEuro = [double]::MaxValue
  $peggioreData = ""; $peggioreEquityInizio = [double]$Deposito
  foreach($giornoCorr in $giorniOrdinati){
    $equityInizioGiorno = [double]$Deposito + $cumulato
    $sommaCorr = [double]$sommaGiorno[$giornoCorr]
    if($sommaCorr -lt $peggioreEuro){
      $peggioreEuro = $sommaCorr; $peggioreData = $giornoCorr; $peggioreEquityInizio = $equityInizioGiorno
    }
    $cumulato += $sommaCorr
  }
  $cella.PgData     = $peggioreData
  $cella.PgEuro     = $peggioreEuro
  $cella.PgPctFisso = [math]::Round(100.0 * $peggioreEuro / [double]$Deposito, 4)
  $cella.PgPctEq    = [math]::Round(100.0 * $peggioreEuro / $peggioreEquityInizio, 4)
  $cella.PgGiorni   = $giorniOrdinati.Count
  #  top-3 peggiori: spareggio UNIVOCO (somma, poi data -- le date sono
  #  distinte, quindi la chiave composta non ha pari: checklist 81).
  $terne = New-Object System.Collections.ArrayList
  foreach($giornoCorr in $giorniOrdinati){ [void]$terne.Add([pscustomobject]@{ Data=$giornoCorr; Somma=[double]$sommaGiorno[$giornoCorr] }) }
  $peggiori3 = @($terne | Sort-Object Somma, Data | Select-Object -First 3)
  $cella.PgTop3 = (@($peggiori3 | ForEach-Object { $_.Data + " " + $_.Somma.ToString("+0.00;-0.00;0.00",$INV) }) -join " | ")
  # --- tetto di volume (lettura R109): volume massimo e quota di righe al massimo
  $volMassimo = 0.0
  foreach($chiusuraCorr in $chiusure){ if($chiusuraCorr.Volume -gt $volMassimo){ $volMassimo = $chiusuraCorr.Volume } }
  $righeAlMassimo = @($chiusure | Where-Object { [math]::Abs($_.Volume - $volMassimo) -lt 0.005 }).Count
  $cella.VolMax   = $volMassimo
  $cella.VolQuota = [math]::Round(100.0 * $righeAlMassimo / $chiusure.Count, 2)
  $cella.PtStato = $(if($scartoRiconc){ "MISURATA (con SCARTO DICHIARATO nella riconciliazione)" } else { "MISURATA" })
}

#--- LE DUE FINESTRE, calcolate con la STESSA formula del driver generico.
$DtInizio = [datetime]::ParseExact($DaQuando,"yyyy.MM.dd",$INV)
$DtFine   = [datetime]::ParseExact($Fino,"yyyy.MM.dd",$INV)
$DtMeta   = $DtInizio.AddDays([math]::Floor(($DtFine-$DtInizio).TotalDays*$FrazioneIS))
$IS_Da    = $DtInizio.ToString("yyyy.MM.dd",$INV)
$IS_A     = $DtMeta.ToString("yyyy.MM.dd",$INV)
$OOS_Da   = $DtMeta.AddDays(1).ToString("yyyy.MM.dd",$INV)
$OOS_A    = $DtFine.ToString("yyyy.MM.dd",$INV)
$DtOOSInizio = $DtMeta.AddDays(1)   # mezzanotte del primo giorno OOS

# =====================================================================
#  LA LISTA DEI LAVORI, dopo il filtro -SoloCella.
#  >>> CHECKLIST 68: se il selettore non corrisponde a nulla NON e'
#      "zero problemi": e' il refuso piu' comune che esista.
#  >>> Il 00_metro gira SEMPRE: e' il denominatore del cancello e porta
#      G0-C e G0-B. Costa 2 CSV, non una passata sprecata.
# =====================================================================
$Lavori = @($CELLE)
if($SoloCella -ne ""){
  $celleScelte = @($Lavori | Where-Object { $_.Prova -eq $SoloCella })
  if($celleScelte.Count -eq 0){
    Write-Host ("!!! -SoloCella " + $SoloCella + " non e' nella lista. Nomi validi:") -ForegroundColor Red
    foreach($cellaElenco in $CELLE){ Write-Host ("      " + $cellaElenco.Prova) -ForegroundColor Yellow }
    exit 1
  }
  $Lavori = @($Lavori | Where-Object { $_.Prova -eq $SoloCella -or $_.Metro })
}
if($Lavori.Count -eq 0){ $SelettoreAVuoto = $true }

Write-Host ""
Write-Host "#####################################################################" -ForegroundColor Cyan
Write-Host "#  R112 - IL CONTRATTO DELL'EMADOW: SHORT-ONLY, E A QUALE DIAL?     #" -ForegroundColor Cyan
Write-Host "#  ABTG_EMA200 / U30USD H1, TICK REALI, 2024.09.26 -> 2026.06.30    #" -ForegroundColor Cyan
Write-Host "#####################################################################" -ForegroundColor Cyan
Dico ("pin      : " + $Pin)
Dico ("cartella : " + $Work)

if($SelettoreAVuoto){
  Write-Host ""
  Write-Host "ESITO: SELETTORE A VUOTO -- nessuna cella selezionata, nessun artefatto prodotto." -ForegroundColor Red
  exit 1
}

Titolo "NUMERI ATTESI (dichiarati PRIMA della corsa)"
Write-Host ("    celle ........................  " + $Lavori.Count + "   (di cui METRO: " + @($Lavori | Where-Object { $_.Metro }).Count + ")") -ForegroundColor White
Write-Host ("    CSV attesi ...................  " + (2*$Lavori.Count) + "   (IS + OOS per cella)") -ForegroundColor White
Write-Host ("    righe per CSV ................  " + $CelleAttese + "   (le due gemelle di controllo)") -ForegroundColor White
Write-Host ("    passate ......................  " + (4*$Lavori.Count)) -ForegroundColor White
Write-Host ("    file per-trade attesi ........  " + (2*$Lavori.Count) + "   (2 magic gemelli per cella, dalla cartella comune)") -ForegroundColor White
Write-Host ("    IS  " + $IS_Da + " -> " + $IS_A) -ForegroundColor White
Write-Host ("    OOS " + $OOS_Da + " -> " + $OOS_A) -ForegroundColor White
Write-Host ""
Write-Host  "    >>> LA DICHIARAZIONE D'ONESTA' DEL ROUND (criteri par. 0): I NUMERI DI" -ForegroundColor Yellow
Write-Host  "    R110 SONO GIA' STATI VISTI. Le protezioni: cancello di portafoglio" -ForegroundColor Yellow
Write-Host  "    CONGELATO prima dei numeri nuovi, dial {1,2,3} congelati con derivazione" -ForegroundColor Yellow
Write-Host  "    dichiarata, divieto di dial intermedi a risultati visti (D5)." -ForegroundColor Yellow
Write-Host ""
Write-Host  "    >>> G0-B STAVOLTA E' APPLICABILE, ED E' FATALE (decisione D3): 00_metro" -ForegroundColor Yellow
Write-Host  "    e 01_short_r1 devono RIPRODURRE AL CENTESIMO i CSV di R110 archiviati" -ForegroundColor Yellow
Write-Host  "    al pin (prove\R110_CSV_EMADOW\). Se non riproducono, il banco non e'" -ForegroundColor Yellow
Write-Host  "    riproducibile fra corse: una notizia piu' grossa del round." -ForegroundColor Yellow
Write-Host ""
Write-Host  "    >>> LA MISURA NUOVA: LA PEGGIOR GIORNATA (decisione D4), dai per-trade" -ForegroundColor Yellow
Write-Host  "    della cartella comune. SOLO OOS: la gamba IS viene SOVRASCRITTA dalla" -ForegroundColor Yellow
Write-Host  "    OOS per costruzione (e lo si MISURA sulle close_time, non lo si assume)." -ForegroundColor Yellow
Write-Host  "    E' la peggior giornata dei CHIUSI: il muro delle prop guarda il" -ForegroundColor Yellow
Write-Host  "    FLOTTANTE, questa e' un PAVIMENTO." -ForegroundColor Yellow
Write-Host ""
Write-Host  "    >>> QUESTO ROUND NON PROMUOVE NIENTE E NON TOCCA IL FORWARD (G5)." -ForegroundColor Yellow
Write-Host  "        La sedia 771531 resta com'e'. Il cancello di portafoglio (par. 6)" -ForegroundColor Yellow
Write-Host  "        lo applica il referto del round, A MANO: qui escono i numeri." -ForegroundColor Yellow

if($Pin -eq ""){
  Write-Host ""
  Write-Host "!!! MANCA -Pin. Questa riga gira SOLO su un commit congelato." -ForegroundColor Red
  Write-Host "    Rilancia col blocco intero, che passa -Pin <hash>." -ForegroundColor Yellow
  exit 1
}

try{

# =====================================================================
#  0. MT5 E METAEDITOR CHIUSI. Prima di qualunque altra cosa.
#     MT5 aperto = il tester non parte e escono ZERO CSV (checklist 7).
#     MetaEditor e' SINGLE-INSTANCE: il /compile tornerebbe subito senza
#     compilare (checklist 39).
# =====================================================================
$processiVivi = @(Get-Process -Name "terminal64","metaeditor64" -ErrorAction SilentlyContinue)
if($processiVivi.Count -gt 0){
  Write-Host ""
  Write-Host ("!!! APERTO: " + (($processiVivi | ForEach-Object { $_.ProcessName } | Sort-Object -Unique) -join ", ")) -ForegroundColor Red
  Write-Host "    Non parto: col terminale aperto il tester non gira (zero CSV), e con" -ForegroundColor Red
  Write-Host "    MetaEditor aperto la compilazione torna subito senza compilare." -ForegroundColor Red
  Write-Host "    Chiudi MetaTrader E MetaEditor (tutte le istanze) e rilancia." -ForegroundColor Yellow
  #  DICHIARATO: questo exit sta DENTRO il try e SALTA la raccolta. Siamo a
  #  due secondi dal lancio, non e' stato prodotto NIENTE: il messaggio a
  #  schermo E' il referto.
  exit 1
}

New-Item -ItemType Directory -Force -Path $Work,$Prove,$Anten,$RifG0B,$Logs,$SrcDir | Out-Null

# =====================================================================
#  0-BIS. LA FIRMA DEI CRITERI. Si LEGGE nell'artefatto, non si ricorda.
#     TRE rami (checklist 82):
#       FIRMATI nel file          -> la corsa parte; -CriteriFirmati, se
#                                    passato, e' INERTE e va detto;
#       NON firmati + switch      -> la corsa parte con la dichiarazione
#                                    "firma data a voce" scritta agli atti;
#       NON firmati senza switch  -> la CORSA VERA esce 2 (il giro a
#                                    vuoto -SoloControllo parte comunque).
#     Il lucchetto si cerca in TUTTO il file (oggi ce ne sono 2: titolo
#     e par. 10), con la stringa COMPOSTA, mai scritta per esteso qui.
# =====================================================================
Titolo "0-BIS. LA FIRMA DEI CRITERI"
$critFile = Join-Path $Work "R112_CRITERI.md"
$daFirmare = $true
try{
  Scarica ("$RawPin/backtest_pipeline/risultati_archivio/R112_CRITERI.md") $critFile 'R112'
  $daFirmare = (Select-String -LiteralPath $critFile -SimpleMatch -Pattern $LucchettoFirma -Quiet)
  $Firma = if($daFirmare){ "NON FIRMATI (il file porta ancora il lucchetto della firma)" } else { "FIRMATI (nessun lucchetto nel file al pin)" }
}catch{
  $Firma = "NON LETTI (" + $_.Exception.Message + ")"
  $daFirmare = $true
}
Dico ("criteri: " + $Firma) $(if($Firma -like "FIRMATI*"){"Green"}else{"Yellow"})
if($daFirmare -and -not $SoloControllo -and -not $CriteriFirmati){
  Write-Host ""
  Write-Host "#####################################################################" -ForegroundColor Red
  Write-Host "#  NON PARTO: I CRITERI DI R112 NON SONO FIRMATI.                   #" -ForegroundColor Red
  Write-Host "#####################################################################" -ForegroundColor Red
  Write-Host "  R112_CRITERI.md porta ancora il lucchetto. Sono SEI decisioni (par. 10):" -ForegroundColor Yellow
  Write-Host "   D1  il perimetro: 4 celle, magic 7634xx, finestra/split/banco di R110" -ForegroundColor Yellow
  Write-Host "   D2  il cancello di portafoglio (a)+(b)+(c)+(d); D2-bis: vince il dial" -ForegroundColor Yellow
  Write-Host "       PIU' BASSO fra quelli che passano" -ForegroundColor Yellow
  Write-Host "   D3  G0-B riproduzione di R110: APPLICABILE e FATALE" -ForegroundColor Yellow
  Write-Host "   D4  la peggior giornata: chiusi per data server, doppio denominatore," -ForegroundColor Yellow
  Write-Host "       limite del flottante dichiarato, IS n/d per costruzione" -ForegroundColor Yellow
  Write-Host "   D5  anti-pesca: i dial sono {1,2,3}, niente dial aggiunti a risultati visti" -ForegroundColor Yellow
  Write-Host "   D6  esito e uso: nessun deploy; candidatura -> proposta di delibera separata" -ForegroundColor Yellow
  Write-Host "" -ForegroundColor Yellow
  Write-Host "  COSA PUOI FARE ADESSO, in ordine:" -ForegroundColor Yellow
  Write-Host "   1. il GIRO A VUOTO gira lo stesso: rilancia con -SoloControllo." -ForegroundColor Yellow
  Write-Host "   2. leggi R112_CRITERI.md par. 10 e rispondi alle sei decisioni." -ForegroundColor Yellow
  Write-Host "   3. quando hai firmato: si toglie il lucchetto dal file (da TUTTO il" -ForegroundColor Yellow
  Write-Host "      file: oggi sta in DUE punti), oppure si rilancia aggiungendo" -ForegroundColor Yellow
  Write-Host "      -CriteriFirmati (la firma in riga, che finisce scritta nel referto)." -ForegroundColor Yellow
  Write-Host ""
  exit 2
}
if($daFirmare -and $CriteriFirmati){
  [void]$Rilievi.Add("I criteri portano ancora il lucchetto nel file, ma la corsa e' partita con -CriteriFirmati: la firma e' quella data in riga da Claudio. VA SCRITTO NEL REFERTO DEL ROUND.")
  Dico "corsa autorizzata da -CriteriFirmati (il file porta ancora il lucchetto)" "Yellow"
}
if(-not $daFirmare -and $CriteriFirmati){
  Dico "-CriteriFirmati e' INERTE: i criteri risultano gia' FIRMATI NEL FILE al pin. La firma agli atti e' quella del documento, non una firma in riga." "Yellow"
}

# =====================================================================
#  1. SCARICO AL PIN
# =====================================================================
Titolo "1. SCARICO AL PIN"
$Driver = Join-Path $Work "walkforward_generico.ps1"
Scarica ("$RawPin/backtest_pipeline/walkforward_generico.ps1") $Driver 'RigaSpread'

# --- 1a. IL PIN DEL MOTORE. walkforward_generico.ps1 ha $EABranch="lavoro"
#     scritto FISSO e riscarica il .mq5 dalla PUNTA del branch: senza
#     questa riscrittura un pin pinnerebbe gli script e NON il motore.
$testoDriverGen = Get-Content -LiteralPath $Driver -Raw
$testoDriverNuovo = $testoDriverGen -replace '\$EABranch\s*=\s*"lavoro"', ('$EABranch="' + $Pin + '"')
if($testoDriverNuovo -eq $testoDriverGen){ throw "non sono riuscito a pinnare EABranch nel driver generico: riga non trovata" }

# --- 1b. IL TETTO DELLE BARRE (checklist 36). [INFERITO] che il tester
#     onori questa riga: NON e' misurato.
$testoDriverNuovo = $testoDriverNuovo -replace '(?m)^\[Experts\]\r?$', "[Charts]`r`nMaxBars=2000000000`r`n`r`n[Experts]"
Set-Content -LiteralPath $Driver -Value $testoDriverNuovo -Encoding ASCII
# --- gate sullo STATO FINALE, non sul replace (checklist 33)
if(-not (Select-String -LiteralPath $Driver -SimpleMatch -Pattern ('$EABranch="' + $Pin + '"') -Quiet)){ throw "pin di EABranch NON verificato nel driver generico" }
$numMaxBars = @(Select-String -LiteralPath $Driver -SimpleMatch -Pattern 'MaxBars=2000000000').Count
if($numMaxBars -ne 2){ throw ("MaxBars scritto " + $numMaxBars + " volte nel driver generico invece di 2 (anteprima + corsa vera): il driver e' cambiato, mi fermo.") }
# --- 1b-bis. ALLOWLIVETRADING=FALSE, CONTATO A INIZIO RIGA (checklist 51
#     e 40-quater: la stringa compare anche in un COMMENTO del driver
#     generico, il conteggio a testo libero darebbe 3).
$numAllowLive = @(Select-String -LiteralPath $Driver -Pattern '^AllowLiveTrading=false\s*$').Count
if($numAllowLive -ne 2){ throw ("nel driver generico le RIGHE 'AllowLiveTrading=false' sono " + $numAllowLive + " invece di 2 (una nell'anteprima, una nella corsa vera). NON apro MT5 su un conto vivo con un .ini che non lo disarma.") }
Dico ("driver generico PINNATO (" + $Pin.Substring(0,[math]::Min(7,$Pin.Length)) + "), MaxBars alzato, AllowLiveTrading=false x2") "Green"

# --- 1c. I FILE PROVA, GLI ANTENATI E I RIFERIMENTI G0-B, e le righe vive
foreach($cellaCorr in $Lavori){
  Scarica ("$RawPin/backtest_pipeline/prove/" + $cellaCorr.Prova) (Join-Path $Prove $cellaCorr.Prova) '@SIMBOLO'
}
$antenatiUnici = @($Lavori | ForEach-Object { $_.AntFile } | Sort-Object -Unique)
foreach($nomeAntenato in $antenatiUnici){
  Scarica ("$RawPin/backtest_pipeline/prove/" + $nomeAntenato) (Join-Path $Anten $nomeAntenato) '@SIMBOLO'
}
#  i 4 CSV di riferimento per G0-B (decisione D3): sono l'archivio dei
#  numeri di R110 e si scaricano AL PIN, sempre -- anche in una ripresa
#  che non fara' girare 01_short_r1, perche' il metro il suo G0-B lo fa
#  comunque. Marcatore: l'intestazione OPTFRAME.
foreach($tagRif in @("00_metro","02_short")){
  foreach($gambaRif in @("IS","OOS")){
    $nomeRif = $EaNome + "_" + $SimboloRound + "_" + $gambaRif + "_" + $tagRif + ".csv"
    Scarica ("$RawPin/backtest_pipeline/prove/R110_CSV_EMADOW/" + $nomeRif) (Join-Path $RifG0B $nomeRif) 'Profit Factor'
  }
}
foreach($cellaCorr in $Lavori){
  $righeViveProva = RigheVive (Join-Path $Prove $cellaCorr.Prova)
  if($righeViveProva.Count -ne $RigheViveAttese){
    throw ($cellaCorr.Prova + " ha " + $righeViveProva.Count + " righe vive invece di " + $RigheViveAttese + ": artefatto cambiato, mi fermo.")
  }
  $Vive[$cellaCorr.Prova] = $righeViveProva
}
foreach($nomeAntenato in $antenatiUnici){
  $righeViveAnt = RigheVive (Join-Path $Anten $nomeAntenato)
  if($righeViveAnt.Count -ne $RigheViveAttese){
    throw ("l'antenato " + $nomeAntenato + " ha " + $righeViveAnt.Count + " righe vive invece di " + $RigheViveAttese + ": artefatto cambiato, mi fermo.")
  }
}
Dico ($Lavori.Count.ToString() + " file prova + " + $antenatiUnici.Count + " antenati R110 + 4 CSV riferimento G0-B scaricati al pin, righe vive verificate (46 ovunque)") "Green"

# --- 1c-bis. IL GATE DELL'ANTENATO (checklist 72). La catena e'
#     R103 -> R110 -> R112: gli antenati di R110 erano a loro volta
#     gatati contro R103. Confronto PER NOME, mai per posizione.
foreach($cellaCorr in $Lavori){
  $mappaAntenato = MappaDi (RigheVive (Join-Path $Anten $cellaCorr.AntFile))
  $mappaCella    = MappaDi $Vive[$cellaCorr.Prova]
  $deltaAmmessi  = @($DeltaBase) + @($cellaCorr.DeltaAnt)
  $guastiAntenato = New-Object System.Collections.ArrayList
  foreach($chiaveAnt in @($mappaAntenato.Keys)){
    if(-not $mappaCella.ContainsKey($chiaveAnt)){ [void]$guastiAntenato.Add("manca la riga '" + $chiaveAnt + "' che l'antenato ha") ; continue }
    if($mappaAntenato[$chiaveAnt] -ne $mappaCella[$chiaveAnt] -and $deltaAmmessi -notcontains $chiaveAnt){
      [void]$guastiAntenato.Add("'" + $chiaveAnt + "' vale [" + $mappaCella[$chiaveAnt] + "] ma nell'antenato vale [" + $mappaAntenato[$chiaveAnt] + "]")
    }
  }
  foreach($chiaveCella in @($mappaCella.Keys)){
    if(-not $mappaAntenato.ContainsKey($chiaveCella)){ [void]$guastiAntenato.Add("ha la riga '" + $chiaveCella + "' che l'antenato NON ha") }
  }
  #  e i delta ammessi devono ESSERCI DAVVERO: un InpRiskPercent che NON
  #  differisce vorrebbe dire che la cella del dial misura il dial vecchio.
  foreach($chiaveDelta in @($cellaCorr.DeltaAnt)){
    if($mappaAntenato.ContainsKey($chiaveDelta) -and $mappaCella.ContainsKey($chiaveDelta) -and $mappaAntenato[$chiaveDelta] -eq $mappaCella[$chiaveDelta]){
      [void]$guastiAntenato.Add("'" + $chiaveDelta + "' e' UGUALE all'antenato ([" + $mappaCella[$chiaveDelta] + "]) ma questa cella deve muoverlo: senza, misurerebbe una cella gia' misurata")
    }
  }
  if($guastiAntenato.Count -gt 0){
    throw ("GATE DELL'ANTENATO FALLITO su " + $cellaCorr.Prova + " contro prove\" + $cellaCorr.AntFile + ": " + ($guastiAntenato -join " ; ") +
           ". La frase 'il corpo e' copiato riga per riga da R110' e' un GATE, non un commento: se non torna, questo round girerebbe su un motore diverso da quello che sta sui soldi.")
  }
  #  >>> CHECKLIST 70-bis: l'elenco dei delta si ORDINA alla fonte prima
  #      di stamparlo (i nomi vengono da liste, non da hashtable, ma
  #      l'ordine si impone lo stesso: e' promesso a schermo).
  $cellaCorr.Antenato = "OK contro " + $cellaCorr.AntFile + " (delta: " + (($deltaAmmessi | Sort-Object) -join " + ") + ")"
}
Dico "gate dell'ANTENATO: ogni cella e' la copia riga per riga del suo file prova R110, salvo i delta dichiarati (catena R103 -> R110 -> R112)" "Green"

# --- 1d. IL GATE DELLA STELLA. Le tre celle short si confrontano col
#     00_metro: devono differire ESATTAMENTE su DiffStella + InpMagic.
#     Confronto POSIZIONALE, e regge perche' i file sono generati con lo
#     stesso ordine di input (righe vive gia' contate).
$cellaMetro = @($Lavori | Where-Object { $_.Metro })
if($cellaMetro.Count -ne 1){ throw ("trovate " + $cellaMetro.Count + " celle 00_metro invece di 1. Senza il metro non girano G0-B, G0-C e i delta.") }
$righeMetro = $Vive[$cellaMetro[0].Prova]
foreach($cellaCorr in @($Lavori | Where-Object { -not $_.Metro })){
  $righeCella = $Vive[$cellaCorr.Prova]
  if($righeMetro.Count -ne $righeCella.Count){ throw ($cellaCorr.Prova + ": " + $righeCella.Count + " righe vive contro " + $righeMetro.Count + " del 00_metro. Non sono confrontabili.") }
  $nomiDiversi = New-Object System.Collections.ArrayList
  for($iRigaViva=0; $iRigaViva -lt $righeMetro.Count; $iRigaViva++){
    if($righeMetro[$iRigaViva] -ne $righeCella[$iRigaViva]){ [void]$nomiDiversi.Add((NomeDi $righeMetro[$iRigaViva])) }
  }
  $diffAttesi = @($cellaCorr.DiffStella) + @("InpMagic")
  $diffMancanti = @($diffAttesi   | Where-Object { $nomiDiversi -notcontains $_ })
  $diffExtra    = @($nomiDiversi  | Where-Object { $diffAttesi  -notcontains $_ })
  if($diffMancanti.Count -gt 0 -or $diffExtra.Count -gt 0){
    throw ($cellaCorr.Prova + " contro " + $cellaMetro[0].Prova + ": differiscono su [" + ($nomiDiversi -join ", ") +
           "] invece che su [" + ($diffAttesi -join ", ") + "]. R112 pretende che cambino SOLO lato e dial (piu' il magic): cosi' il numero e' attribuibile al CONTRATTO e a nient'altro.")
  }
}
Dico "gate della STELLA: ogni cella short differisce dal 00_metro SOLO su lato/dial dichiarati (+ magic)" "Green"

# --- 1e. I VALORI, letti NELL'ARTEFATTO CHE GIRA (checklist 34-bis):
#     geometria d'identita' + i valori PROPRI della cella (lati e dial)
#     + @SIMBOLO/@PERIODO/@DAQUANDO + asse unico + magic.
#     >>> OGNI $ DI UNA REGEX MULTILINEA SI SCRIVE \r?$ (checklist 40).
$magicVisti = @()
foreach($cellaCorr in $Lavori){
  $testoProva = Get-Content -LiteralPath (Join-Path $Prove $cellaCorr.Prova) -Raw
  foreach($vincolo in $GeometriaViva){
    $regexVincolo = '(?m)^' + $vincolo[0] + '=' + [regex]::Escape($vincolo[1]) + '\|\|'
    if($testoProva -notmatch $regexVincolo){
      throw ($cellaCorr.Prova + ": non trovo '" + $vincolo[0] + "=" + $vincolo[1] + "'. Questa NON e' la cella dei criteri par. 1: il round girerebbe sopra un motore che non e' quello della sedia.")
    }
  }
  foreach($chiaveVal in $cellaCorr.Val.Keys){
    $regexVal = '(?m)^' + $chiaveVal + '=' + [regex]::Escape($cellaCorr.Val[$chiaveVal]) + '\|\|'
    if($testoProva -notmatch $regexVal){ throw ($cellaCorr.Prova + ": " + $chiaveVal + " non vale " + $cellaCorr.Val[$chiaveVal] + ". La cella non e' quella che credo -- e su un round sul CONTRATTO questo e' l'errore che rende il referto una bugia.") }
  }
  $matchDaQuando = [regex]::Match($testoProva,'(?m)^@DAQUANDO\s+([0-9]{4}\.[0-9]{2}\.[0-9]{2})')
  if(-not $matchDaQuando.Success -or $matchDaQuando.Groups[1].Value -ne $DaQuando){ throw ($cellaCorr.Prova + ": @DAQUANDO non e' " + $DaQuando) }
  $matchSimbolo = [regex]::Match($testoProva,'(?m)^@SIMBOLO\s+(\S+)')
  if(-not $matchSimbolo.Success -or $matchSimbolo.Groups[1].Value -ne $SimboloRound){ throw ($cellaCorr.Prova + ": @SIMBOLO non e' " + $SimboloRound) }
  $matchPeriodo = [regex]::Match($testoProva,'(?m)^@PERIODO\s+(\S+)')
  if(-not $matchPeriodo.Success -or $matchPeriodo.Groups[1].Value -ne $PeriodoRound){ throw ($cellaCorr.Prova + ": @PERIODO non e' " + $PeriodoRound + " (il TF del GRAFICO nel tester, che NON si deriva da InpTF: trappola di R102).") }
  $assiY = @([regex]::Matches($testoProva,'(?m)^(\w+)=[^\r\n]*\|\|\s*[Yy]\s*\r?$') | ForEach-Object { $_.Groups[1].Value })
  if($assiY.Count -ne 1 -or $assiY[0] -ne "InpMagic"){
    throw ($cellaCorr.Prova + ": gli assi spazzolati sono [" + ($assiY -join ", ") + "] invece del solo InpMagic. R112 NON ottimizza niente: il dial cambia FRA le celle, mai DENTRO una cella.")
  }
  $matchMagic = [regex]::Match($testoProva,'(?m)^InpMagic=(\d+)\|\|(\d+)\|\|1\|\|(\d+)\|\|Y')
  if(-not $matchMagic.Success){ throw ($cellaCorr.Prova + ": InpMagic non e' nella forma sweep 'v||v||1||v+1||Y'. Senza almeno un asse Y il driver generico si rifiuta di partire (checklist punto 5).") }
  $magicBaseLetto = [int]$matchMagic.Groups[1].Value; $magicGemLetto = [int]$matchMagic.Groups[3].Value
  if($magicBaseLetto -ne [int]$cellaCorr.Magic){ throw ($cellaCorr.Prova + ": InpMagic e' " + $magicBaseLetto + " ma questa cella deve girare su " + $cellaCorr.Magic) }
  if($magicGemLetto -ne ($magicBaseLetto+1)){ throw ($cellaCorr.Prova + ": il gemello e' " + $magicGemLetto + " invece di " + ($magicBaseLetto+1)) }
  foreach($magicDaVagliare in @($magicBaseLetto,$magicGemLetto)){
    if($magicVisti -contains $magicDaVagliare){ throw ($cellaCorr.Prova + ": magic " + $magicDaVagliare + " gia' usato da un altro file prova. Due file con lo stesso magic non sono distinguibili nel CSV.") }
    if(MagicVietato $magicDaVagliare){ throw ($cellaCorr.Prova + ": il magic " + $magicDaVagliare + " e' VIETATO (sedia viva 771531, sorgente 771501, o blocco 7633xx bruciato da R110). Fermo tutto.") }
    $magicVisti += $magicDaVagliare
  }
}
Dico ("geometria d'identita', TF del grafico, LATI, DIAL, asse unico e " + $magicVisti.Count + " magic vergini verificati NEI FILE") "Green"

# --- 1f. IL SORGENTE E IL GATE DI VERSIONE. E in R112 c'e' un pezzo in
#     piu': l'EXPORT PER-TRADE deve esistere NEL SORGENTE AL PIN
#     (misurato, non sperato: tutta la decisione D4 poggia li').
$srcMq5 = Join-Path $SrcDir ($EaNome + ".mq5")
Scarica ("$RawPin/mql5/Experts/" + $EaNome + ".mq5") $srcMq5 'ABTG_GuardiaIngresso'
$testoSorgente = Get-Content -LiteralPath $srcMq5 -Raw
$matchVersione = [regex]::Match($testoSorgente,'#property\s+version\s+"([^"]+)"')
if(-not $matchVersione.Success){ throw ($EaNome + ".mq5 scaricato senza #property version: non e' il sorgente che credo.") }
if($matchVersione.Groups[1].Value -ne $EaVersione){
  throw ($EaNome + ".mq5 dichiara version '" + $matchVersione.Groups[1].Value + "' invece di '" + $EaVersione + "'. O la cache di raw.githubusercontent serve una copia vecchia, o il pin e' sbagliato: mi fermo.")
}
if($testoSorgente -notmatch ('(?m)^input\s+long\s+InpMagic\s*=\s*' + $MagicSorgente + '\s*;')){
  throw ($EaNome + ".mq5 non dichiara 'input long InpMagic = " + $MagicSorgente + ";': non e' il motore di questa sedia. (Il magic del SORGENTE non e' quello della SEDIA 771531: sono numeri diversi, ed e' normale.)")
}
foreach($inputAtteso in @("InpAllowLong","InpAllowShort")){
  if($testoSorgente -notmatch ('(?m)^input\s+bool\s+' + $inputAtteso + '\s*=')){ throw ($EaNome + ".mq5 non ha l'input " + $inputAtteso + ": senza i due lati non c'e' contratto da misurare, e questo round NON tocca il codice degli EA.") }
}
if($testoSorgente -notmatch '(?m)^input\s+double\s+InpRiskPercent\s*='){
  throw ($EaNome + ".mq5 non ha l'input InpRiskPercent: senza il dial non c'e' la scala del rischio, cioe' meta' del round.")
}
#  l'export per-trade: nome file, cartella COMUNE e intestazione a 8 campi
if($testoSorgente -notmatch 'abtg_trades_'){ throw ($EaNome + ".mq5 non compone il nome 'abtg_trades_...': l'export per-trade NON c'e', e la decisione D4 non e' eseguibile su questo sorgente.") }
if($testoSorgente -notmatch 'FILE_COMMON'){ throw ($EaNome + ".mq5 non apre il CSV per-trade con FILE_COMMON: il file non finirebbe nella cartella comune dove questo driver lo cerca.") }
if($testoSorgente -notmatch '"close_time","symbol","magic","position_id","deal_type","volume","price","net_profit"'){
  throw ($EaNome + ".mq5 non scrive l'intestazione per-trade attesa (close_time;symbol;magic;position_id;deal_type;volume;price;net_profit): il parser di questo driver leggerebbe un formato diverso (checklist 83).")
}
Dico ($EaNome + ".mq5 al pin, version " + $matchVersione.Groups[1].Value + ", InpMagic sorgente " + $MagicSorgente + " (la sedia gira su " + $MagicVivoSedia + "), lati + dial + export per-trade VERIFICATI NEL SORGENTE") "Green"

# =====================================================================
#  2. TERMINALE, CARTELLA DATI E CARTELLA COMUNE (per NOME, mai il
#     primo che capita -- checklist 37)
# =====================================================================
Titolo "2. TERMINALE E CARTELLA DATI"
$terminaliTrovati = @(Get-ChildItem "C:\Program Files","C:\Program Files (x86)" -Recurse -Filter "terminal64.exe" -ErrorAction SilentlyContinue)
$terminaliBcm  = @($terminaliTrovati | Where-Object { $_.DirectoryName -like "*BCM Markets MT5 Terminal*" -and $_.DirectoryName -notlike "*-V3*" })
if($terminaliBcm.Count -eq 0){ throw "non trovo il terminale 'BCM Markets MT5 Terminal' (quello NON -V3). Non tiro a indovinare." }
if($terminaliBcm.Count -gt 1){ throw ("trovati " + $terminaliBcm.Count + " terminali che corrispondono: ambiguo, mi fermo.") }
$InstDir    = $terminaliBcm[0].DirectoryName
$Terminal   = Join-Path $InstDir "terminal64.exe"
$MetaEditor = Join-Path $InstDir "metaeditor64.exe"
if(-not (Test-Path -LiteralPath $MetaEditor)){ throw ("manca metaeditor64.exe in " + $InstDir) }
$TermRoot = Join-Path $env:APPDATA "MetaQuotes\Terminal"
$DataFolder = Get-ChildItem $TermRoot -Directory -ErrorAction SilentlyContinue | Where-Object {
    $originFile = Join-Path $_.FullName "origin.txt"
    (Test-Path $originFile) -and ((Get-Content $originFile -Raw).Trim() -ieq $InstDir)
  } | Select-Object -First 1 -ExpandProperty FullName
if(-not $DataFolder){ throw "cartella dati MT5 non trovata (origin.txt non punta a nessuna cartella)." }
$MqlExperts = Join-Path $DataFolder "MQL5\Experts"
$MqlInclude = Join-Path $DataFolder "MQL5\Include"
$MqlFiles   = Join-Path $DataFolder "MQL5\Files"
#  la CARTELLA COMUNE, come nei driver R108/R109: (radice terminal) +
#  Common\Files. E' li' che ABTG_EMA200 scrive i per-trade (FILE_COMMON).
$CommonFiles = Join-Path $TermRoot "Common\Files"
New-Item -ItemType Directory -Force -Path $MqlExperts,$MqlInclude,$Sosta | Out-Null
Dico ("terminale : " + $Terminal)
Dico ("dati      : " + $DataFolder + "   (DEVE restare lo stesso in tutti i passi)")
Dico ("comune    : " + $CommonFiles + "   (da qui arrivano i per-trade)")

# --- 2a. LA SOSTA SI SVUOTA A OGNI GIRO (checklist 56), contando PRIMA
#     e DOPO (checklist 69).
$numSostaPrima = @(Get-ChildItem -LiteralPath $Sosta -File -ErrorAction SilentlyContinue).Count
if($numSostaPrima -gt 0){
  Get-ChildItem -LiteralPath $Sosta -File -ErrorAction SilentlyContinue | Remove-Item -Force -ErrorAction SilentlyContinue
  $numSostaDopo = @(Get-ChildItem -LiteralPath $Sosta -File -ErrorAction SilentlyContinue).Count
  if($numSostaDopo -gt 0){
    [void]$Problemi.Add("sosta: " + $numSostaDopo + " file su " + $numSostaPrima + " di un giro PRECEDENTE non sono stati cancellati. Possono finire nello zip di questo round spacciandosi per artefatti di adesso: controllare le date dentro lo zip prima di leggerlo.")
  }
  Dico ("sosta svuotata: " + $numSostaPrima + " file di un giro precedente rimossi (rimasti: " + $numSostaDopo + ")") "Green"
}

# --- 2b. L'INCLUDE CHE NESSUN DRIVER INSTALLA (checklist 33-bis).
#     ABTG_EMA200 fa #include <ABTG_PausaGuardian.mqh>: senza questa
#     riga la compilazione fallisce. Nel tester la guardia e' fail-open.
$includeGuardian = Join-Path $MqlInclude "ABTG_PausaGuardian.mqh"
Scarica ("$RawPin/mql5/Include/ABTG_PausaGuardian.mqh") $includeGuardian 'ABTG_GuardiaIngresso'
$includeInfo = Get-Item -LiteralPath $includeGuardian
if($includeInfo.PSIsContainer){ throw "ABTG_PausaGuardian.mqh: in Include c'e' una CARTELLA con quel nome (checklist 27-ter)." }
if($includeInfo.Length -lt 4000){ throw ("ABTG_PausaGuardian.mqh e' lungo " + $includeInfo.Length + " byte: troppo poco, scarico monco.") }
Dico ("include installato: ABTG_PausaGuardian.mqh (" + $includeInfo.Length + " byte)") "Green"

# --- 2c. PULIZIA DEGLI ARTEFATTI VECCHI, PRIMA (checklist 14, 53 e 69).
#     SOLO se si corre davvero. OptResults e cache PER NOME; i per-trade
#     del blocco 7634xx con il filtro DEL BLOCCO (il blocco e' riservato
#     a R112 dai criteri par. 2, quindi il filtro non puo' prendere file
#     di sedie vive o di altri round), contati prima e dopo.
if($SoloControllo){
  Dico "SoloControllo: NON cancello niente." "Yellow"
} else {
  $optCsvVecchio = Join-Path $MqlFiles ("OptResults_" + $EaNome + "_" + $SimboloRound + ".csv")
  if(Test-Path -LiteralPath $optCsvVecchio){
    Remove-Item -LiteralPath $optCsvVecchio -Force -ErrorAction SilentlyContinue
    if(Test-Path -LiteralPath $optCsvVecchio){
      [void]$Problemi.Add("NON sono riuscito a cancellare " + $optCsvVecchio + " (qualcuno lo tiene aperto). Il file di appoggio dell'OPTFRAME e' di un giro PRECEDENTE: i CSV di questo round vanno confrontati con la loro data prima di leggerli.")
      Dico ("OptResults NON cancellato: " + $optCsvVecchio) "Red"
    }
  }
  # --- i per-trade 7634xx dalla cartella comune (decisione D4, punto 2):
  #     un file avanzato da un giro precedente passerebbe per fresco.
  #     Get-ChildItem -Path con -Filter: il wildcard DEVE lavorare qui
  #     (con -LiteralPath non lavorerebbe: checklist 46).
  if(Test-Path -LiteralPath $CommonFiles){
    $perTradeVecchi = @(Get-ChildItem -Path $CommonFiles -Filter ("abtg_trades_" + $EaNome + "_" + $SimboloRound + "_7634*.csv") -File -ErrorAction SilentlyContinue)
    $numPerTradeTolti = 0
    foreach($fileVecchio in $perTradeVecchi){
      Remove-Item -LiteralPath $fileVecchio.FullName -Force -ErrorAction SilentlyContinue
      if(Test-Path -LiteralPath $fileVecchio.FullName){
        [void]$Problemi.Add("per-trade VECCHIO non cancellato: " + $fileVecchio.FullName + ". Se ricompare 'fresco' non e' detto che sia di adesso: la data va guardata (il gate di freschezza per cella lo fa comunque).")
      } else { $numPerTradeTolti++ }
    }
    Dico ("per-trade 7634xx in cartella comune: trovati " + $perTradeVecchi.Count + ", tolti " + $numPerTradeTolti) $(if($perTradeVecchi.Count -eq $numPerTradeTolti){"Green"}else{"Red"})
  } else {
    Dico ("la cartella comune " + $CommonFiles + " non esiste ancora: niente per-trade vecchi da togliere.") "Gray"
  }
  # --- la CACHE del tester, e SOLO quella. MAI bases\<server>\ticks.
  $cacheTester = Join-Path $DataFolder "Tester\cache"
  if(Test-Path -LiteralPath $cacheTester){
    $numCachePrima = @(Get-ChildItem -LiteralPath $cacheTester -Force -Recurse -File -ErrorAction SilentlyContinue).Count
    Get-ChildItem -LiteralPath $cacheTester -Force -ErrorAction SilentlyContinue | Remove-Item -Recurse -Force -ErrorAction SilentlyContinue
    $numCacheDopo = @(Get-ChildItem -LiteralPath $cacheTester -Force -Recurse -File -ErrorAction SilentlyContinue).Count
    if($numCacheDopo -gt 0){
      [void]$Problemi.Add("Tester\cache NON svuotata: " + $numCacheDopo + " file su " + $numCachePrima + " sono rimasti. MT5 puo' ripescare passate gia' calcolate (punto 38) -- e un pass ripescato NON scrive il per-trade.")
      Dico ("Tester\cache: " + $numCachePrima + " file prima, " + $numCacheDopo + " RIMASTI.") "Red"
    } else {
      Dico ("Tester\cache svuotata: " + $numCachePrima + " file prima, 0 dopo. bases\<server>\ticks NON toccata.") "Green"
    }
  } else { Dico "Tester\cache non esiste: niente da svuotare." "Gray" }
}

# =====================================================================
#  3. FASE COMPILA (un solo EA). Si fa ANCHE in -SoloControllo
#     (checklist 39). Invocazione DIRETTA di metaeditor64.exe, verdetto
#     sul LastWriteTime del .ex5, backup datato, ripristino se fallisce.
# =====================================================================
Titolo "3. FASE COMPILA"
$mq5Destinazione = Join-Path $MqlExperts ($EaNome + ".mq5")
$ex5Destinazione = Join-Path $MqlExperts ($EaNome + ".ex5")
$logCompilatore  = Join-Path $MqlExperts ($EaNome + ".log")
$backupMq5 = $mq5Destinazione + ".prima_r112_" + $Stamp
$backupEx5 = $ex5Destinazione + ".prima_r112_" + $Stamp
if((Test-Path -LiteralPath $mq5Destinazione) -and -not (Test-Path -LiteralPath $backupMq5)){ Copy-Item -LiteralPath $mq5Destinazione -Destination $backupMq5 -Force }
if((Test-Path -LiteralPath $ex5Destinazione) -and -not (Test-Path -LiteralPath $backupEx5)){ Copy-Item -LiteralPath $ex5Destinazione -Destination $backupEx5 -Force }
Copy-Item -LiteralPath $srcMq5 -Destination $mq5Destinazione -Force
$lunghezzaSorgente = (Get-Item -LiteralPath $srcMq5).Length
$copiaVerifica = Get-Item -LiteralPath $mq5Destinazione -ErrorAction SilentlyContinue
if(-not $copiaVerifica -or $copiaVerifica.PSIsContainer -or $copiaVerifica.Length -ne $lunghezzaSorgente){ throw ("copia di " + $EaNome + ".mq5 in MQL5\Experts NON verificata (lunghezza diversa o e' una cartella).") }
$ex5Prima = (Get-Date).AddYears(-100)
if(Test-Path -LiteralPath $ex5Destinazione){ $ex5Prima = (Get-Item -LiteralPath $ex5Destinazione).LastWriteTime }
Remove-Item -LiteralPath $logCompilatore -Force -ErrorAction SilentlyContinue
& $MetaEditor "/compile:$mq5Destinazione" "/log:$logCompilatore" | Out-Null
$rcMetaEditor = $LASTEXITCODE
$ex5Dopo = $null
if(Test-Path -LiteralPath $ex5Destinazione){ $ex5Dopo = (Get-Item -LiteralPath $ex5Destinazione).LastWriteTime }
$compilazioneOk = ($null -ne $ex5Dopo) -and ($ex5Dopo -gt $ex5Prima)
$testoLogCompilatore = ""
if(Test-Path -LiteralPath $logCompilatore){
  try{ $testoLogCompilatore = (Get-Content -LiteralPath $logCompilatore -Raw -Encoding Unicode) }catch{ $testoLogCompilatore = "" }
  if($testoLogCompilatore -notmatch '(?i)error'){ try{ $testoLogCompilatore = (Get-Content -LiteralPath $logCompilatore -Raw) }catch{} }
  Copy-Item -LiteralPath $logCompilatore -Destination (Join-Path $Sosta ("compile_EMADOW.log")) -Force -ErrorAction SilentlyContinue
}
if(-not $compilazioneOk){
  if($testoLogCompilatore -ne ""){
    Write-Host "--- log del compilatore (ultime righe) ---" -ForegroundColor DarkYellow
    foreach($rigaLog in @($testoLogCompilatore -split "\r?\n" | Select-Object -Last 20)){ Write-Host ("   " + $rigaLog) -ForegroundColor DarkYellow }
  } else { Write-Host "   (nessun log prodotto da MetaEditor)" -ForegroundColor DarkYellow }
  #  sorgente e binario devono restare la STESSA versione (checklist 54):
  #  qui il .ex5 e' quello di una SEDIA VIVA sul 100k.
  if(Test-Path -LiteralPath $backupMq5){ Copy-Item -LiteralPath $backupMq5 -Destination $mq5Destinazione -Force }
  throw ("COMPILAZIONE FALLITA per " + $EaNome + " (metaeditor rc=" + $rcMetaEditor + ", .ex5 NON riscritto). Il .mq5 e' stato rimesso com'era e il log e' nello zip. Sospetto n.1: include mancante o MetaEditor gia' aperto.")
}
$matchWarning = [regex]::Match($testoLogCompilatore,'(?i)(\d+)\s+warning')
if($matchWarning.Success -and [int]$matchWarning.Groups[1].Value -gt 0){
  [void]$Rilievi.Add("compilazione " + $EaNome + ": " + $matchWarning.Groups[1].Value + " warning (0 errori). Non fermano il round, ma vanno letti nel log dello zip.")
}
$EaCompilato = $true
Dico ("COMPILATO " + $EaNome + " v" + $EaVersione + " (.ex5 riscritto adesso, rc=" + $rcMetaEditor + ")") "Green"

# =====================================================================
#  4. LA CATENA. Una cella alla volta, mai in parallelo. L'ORDINE CONTA:
#     il 00_metro gira PER PRIMO (porta G0-C e G0-B metro), poi
#     01_short_r1 (G0-B short), poi la scala del dial (r2, r3).
#     Se G0-C fallisce o G0-B esce MISMATCH, le celle successive NON si
#     lanciano (il banco non si legge) MA LA RACCOLTA SI FA LO STESSO.
# =====================================================================
Titolo ("4. LA CATENA - " + $Lavori.Count + " celle, una alla volta")
$Ordinati = @()
$Ordinati += @($Lavori | Where-Object { $_.Metro })
$Ordinati += @($Lavori | Where-Object { -not $_.Metro })
$indiceCella = 0
foreach($cellaCorr in $Ordinati){
  $indiceCella++
  if($CatenaFerma -ne ""){
    $cellaCorr.Esito = "NON INIZIATA (" + $CatenaFerma + ")"
    continue
  }
  $oreTrascorse = (New-TimeSpan -Start $Avvio -End (Get-Date)).TotalHours
  if($oreTrascorse -ge $OreMax){
    $cellaCorr.Esito = "NON INIZIATA (tetto ore raggiunto)"
    [void]$Problemi.Add("TEMPO SCADUTO prima di " + $cellaCorr.Prova + ": il round NON e' completo. Riprendi con -SoloCella " + $cellaCorr.Prova + " (il 00_metro rigira da solo).")
    continue
  }
  Write-Host ""
  Write-Host "------------------------------------------------------------------" -ForegroundColor Cyan
  Write-Host ("  [" + $indiceCella + "/" + $Ordinati.Count + "]  " + $cellaCorr.Prova + $(if($cellaCorr.Metro){ "   <<< IL METRO (G0-C + G0-B)" }else{ "" })) -ForegroundColor Cyan
  Write-Host ("           " + $cellaCorr.Desc) -ForegroundColor Cyan
  Write-Host "------------------------------------------------------------------" -ForegroundColor Cyan
  $avvioCella = Get-Date
  #  >>> CHECKLIST 79: LA FINESTRA SI RICONTROLLA QUI, UN ISTANTE PRIMA
  #      DI PASSARLA. E il valore sporco si TRONCA prima di stamparlo.
  if($DaQuando -ne "2024.09.26" -or $Fino -ne "2026.06.30"){
    $finestraSporcaDa = ("" + $DaQuando); $finestraSporcaA = ("" + $Fino)
    if($finestraSporcaDa.Length -gt 60){ $finestraSporcaDa = $finestraSporcaDa.Substring(0,60) + " ...[+" + ($finestraSporcaDa.Length-60) + " caratteri: la variabile e' diventata un ARRAY]" }
    if($finestraSporcaA.Length  -gt 60){ $finestraSporcaA  = $finestraSporcaA.Substring(0,60)  + " ...[+" + ($finestraSporcaA.Length-60)  + " caratteri: la variabile e' diventata un ARRAY]" }
    throw ("LA FINESTRA E' STATA SPORCATA prima di " + $cellaCorr.Prova + ": DaQuando=[" + $finestraSporcaDa + "] Fino=[" + $finestraSporcaA +
           "] invece di [2024.09.26] e [2026.06.30]. NON lancio: MT5 non protesta per una data storta e produrrebbe numeri PLAUSIBILI su una finestra NON DICHIARATA (checklist 79).")
  }
  Write-Host ("           finestra: " + $DaQuando + " -> " + $Fino + "   (ricontrollata adesso, non solo dichiarata in testa)") -ForegroundColor Gray
  $argomentiDriver = @("-ExecutionPolicy","Bypass","-File",$Driver,
           "-Expert",$EaNome,"-Prova",(Join-Path $Prove $cellaCorr.Prova),
           "-Simbolo",$SimboloRound,"-Periodo",$PeriodoRound,
           "-DaQuando",$DaQuando,"-Fino",$Fino,
           "-Etichetta",$cellaCorr.Id,"-Modello",("" + $Modello),
           "-Deposito",("" + $Deposito),"-Spread",("" + $SpreadIni),
           "-Terminal",$Terminal,"-MetaEditor",$MetaEditor,"-DataFolder",$DataFolder)
  if($Rifai){ $argomentiDriver += "-Rifai" }
  if($SoloControllo){ $argomentiDriver += "-SoloControllo" }
  $global:LASTEXITCODE = 0
  try{
    & powershell.exe $argomentiDriver 2>&1 | Tee-Object -FilePath (Join-Path $Logs ("EMADOW_" + $cellaCorr.Id + ".txt")) | Out-Host
  }catch{
    [void]$Problemi.Add($cellaCorr.Prova + ": il driver generico e' uscito con eccezione - " + $_.Exception.Message)
  }
  if($LASTEXITCODE -ne 0){
    [void]$Problemi.Add($cellaCorr.Prova + ": il driver generico e' uscito con codice " + $LASTEXITCODE)
  }
  $cellaCorr.Min = [math]::Round((New-TimeSpan -Start $avvioCella -End (Get-Date)).TotalMinutes,1)

  if(-not $SoloControllo){
    # ---------- UN CSV VECCHIO NON E' UN CSV OK: SI GUARDA LA DATA.
    #  walkforward_generico.ps1 salta la finestra il cui CSV esiste gia',
    #  e gli stati sono TRE, non due (checklist 49): salta per FINESTRA.
    $gambeVecchie = @()
    foreach($tagGamba in @("IS","OOS")){
      $percorsoCsvGamba = CsvDi $cellaCorr $tagGamba
      $numRigheCsv = -1
      if(Test-Path -LiteralPath $percorsoCsvGamba){
        $numRigheCsv = (@(Get-Content -LiteralPath $percorsoCsvGamba).Count) - 1
        if((Get-Item -LiteralPath $percorsoCsvGamba).LastWriteTime -lt $avvioCella){ $gambeVecchie += $tagGamba }
      }
      if($tagGamba -eq "IS"){ $cellaCorr.IS = $numRigheCsv } else { $cellaCorr.OOS = $numRigheCsv }
    }

    # ---------- GLI .ini CHE HANNO GIRATO DAVVERO (checklist 79): si
    #  rileggono FromDate/ToDate dai gen_*.ini che MT5 ha consumato, su
    #  tutte e due le gambe, e i file finiscono nello zip. Le gambe
    #  SALTATE si escludono: il loro .ini e' di un altro giro (punto 44).
    foreach($tagGamba in @("IS","OOS")){
      if($gambeVecchie -contains $tagGamba){ continue }
      $percorsoGenIni = Join-Path $Work ("gen_" + $EaNome + "_" + $SimboloRound + "_" + $tagGamba + "_" + $cellaCorr.Id + ".ini")
      if(-not (Test-Path -LiteralPath $percorsoGenIni)){
        [void]$Problemi.Add($cellaCorr.Prova + " / " + $tagGamba + ": non trovo l'.ini che ha girato (" + (Split-Path -Leaf $percorsoGenIni) +
                            "): la finestra di questa gamba NON e' stata verificata sull'artefatto.")
        continue
      }
      $testoGenIni = Get-Content -LiteralPath $percorsoGenIni -Raw
      $matchFrom = [regex]::Match($testoGenIni,'(?m)^FromDate=([0-9.]+)\r?$')
      $matchTo   = [regex]::Match($testoGenIni,'(?m)^ToDate=([0-9.]+)\r?$')
      $attesoDa = $(if($tagGamba -eq "IS"){ $IS_Da } else { $OOS_Da })
      $attesoA  = $(if($tagGamba -eq "IS"){ $IS_A  } else { $OOS_A  })
      if(-not $matchFrom.Success -or -not $matchTo.Success -or $matchFrom.Groups[1].Value -ne $attesoDa -or $matchTo.Groups[1].Value -ne $attesoA){
        [void]$Problemi.Add($cellaCorr.Prova + " / " + $tagGamba + ": l'.ini CHE HA GIRATO porta FromDate=[" + $matchFrom.Groups[1].Value + "] ToDate=[" + $matchTo.Groups[1].Value +
                            "] invece di [" + $attesoDa + "] e [" + $attesoA + "]. I numeri di questa gamba NON sono della finestra dichiarata: non si leggono.")
      }
      Copy-Item -LiteralPath $percorsoGenIni -Destination (Join-Path $Sosta ("gen_EMADOW_" + $cellaCorr.Id + "_" + $tagGamba + ".ini")) -Force -ErrorAction SilentlyContinue
    }

    if($gambeVecchie.Count -eq 2){
      $cellaCorr.Esito = "SALTATA DAL DRIVER (IS+OOS gia' presenti da un lancio precedente)"
      [void]$Problemi.Add($cellaCorr.Prova + ": " + $cellaCorr.Esito + ". Le righe tornano ma i file NON sono di questo lancio: rilancia con -Rifai.")
    }
    elseif($gambeVecchie.Count -eq 1){
      $cellaCorr.Esito = "A META' (" + $gambeVecchie[0] + " e' di un lancio PRECEDENTE, l'altra gamba e' di adesso)"
      [void]$Problemi.Add($cellaCorr.Prova + ": " + $cellaCorr.Esito + ". Le due gambe vengono da due giri diversi: rilancia questa cella con -Rifai.")
    }
    elseif([int]$cellaCorr.IS -eq $CelleAttese -and [int]$cellaCorr.OOS -eq $CelleAttese){ $cellaCorr.Esito = "OK" }
    else{
      #  sentinella anche NELLE FRASI (checklist 66): -1 crudo si legge
      #  "meno una riga", che non vuol dire niente.
      $cellaCorr.Esito = "RIGHE SBAGLIATE (IS " + (FmtN $cellaCorr.IS) + " / OOS " + (FmtN $cellaCorr.OOS) + ", attese " + $CelleAttese + "; 'n/d' = il CSV non e' stato prodotto)"
      [void]$Problemi.Add($cellaCorr.Prova + ": " + $cellaCorr.Esito + ". Cache del tester, oppure lo sweep dei magic non ha spazzolato: il file NON si legge.")
    }

    # ---------- LE MISURE, lette dai CSV (parser col controllo positivo)
    $lettureOOS = LeggiOpt (CsvDi $cellaCorr "OOS")
    $cellaCorr.Gemelli = Gemelli $lettureOOS
    if($null -eq $lettureOOS){
      [void]$Problemi.Add($cellaCorr.Prova + ": CSV OOS non letto o colonne non riconosciute. Intestazioni viste: [" + (($script:CsvIntestazioni | Select-Object -First 12) -join " | ") + "]")
    } elseif(@($lettureOOS).Count -ge 1){
      if($null -ne $lettureOOS[0].Pf){     $cellaCorr.PfOOS   = [double]$lettureOOS[0].Pf }
      if($null -ne $lettureOOS[0].Dd){     $cellaCorr.DdOOS   = [double]$lettureOOS[0].Dd }
      if($null -ne $lettureOOS[0].N){      $cellaCorr.NOOS    = [int]$lettureOOS[0].N }
      if($null -ne $lettureOOS[0].Profit){ $cellaCorr.ProfOOS = [double]$lettureOOS[0].Profit }
    }
    $lettureIS = LeggiOpt (CsvDi $cellaCorr "IS")
    if($null -eq $lettureIS){
      [void]$Problemi.Add($cellaCorr.Prova + ": CSV IS non letto o colonne non riconosciute.")
    } elseif(@($lettureIS).Count -ge 1){
      if($null -ne $lettureIS[0].Pf){     $cellaCorr.PfIS   = [double]$lettureIS[0].Pf }
      if($null -ne $lettureIS[0].Dd){     $cellaCorr.DdIS   = [double]$lettureIS[0].Dd }
      if($null -ne $lettureIS[0].N){      $cellaCorr.NIS    = [int]$lettureIS[0].N }
      if($null -ne $lettureIS[0].Profit){ $cellaCorr.ProfIS = [double]$lettureIS[0].Profit }
    }

    # ---------- G0-C: I GEMELLI. Sul metro e' FATALE per la catena; sulle
    #  celle short e' igiene che finisce nei PROBLEMI. TRE stati
    #  (checklist 68): FALLITO (misurato e storto) e NON ESEGUITO (il CSV
    #  non c'e') mandano a cercare il guasto in posti OPPOSTI.
    if($cellaCorr.Gemelli -ne "IDENTICI"){
      $gemelliMisurati = -not ($cellaCorr.Gemelli -like "NON MISURATO*")
      if($cellaCorr.Metro){
        if($gemelliMisurati){
          [void]$Problemi.Add("GATE G0-C FALLITO sul 00_metro: gemelli " + $cellaCorr.Gemelli +
                              ". Due passate a parametri IDENTICI hanno dato numeri diversi: il banco non e' deterministico e su questo round NON si legge niente. Le celle successive NON sono state lanciate.")
          $CatenaFerma = "G0-C FALLITO sul 00_metro: banco non deterministico"
        } else {
          [void]$Problemi.Add("GATE G0-C NON ESEGUITO sul 00_metro: il CSV non e' stato prodotto o non si legge (" + $cellaCorr.Gemelli +
                              "). NON e' dimostrato che il banco sia storto: NON e' stato possibile misurarlo. Cause possibili, TUTTE: MT5 rimasto aperto, Tester\cache, storico mancante, tester uscito male. Si rilancia con -Rifai. Le celle successive NON sono state lanciate.")
          $CatenaFerma = "G0-C NON ESEGUITO sul 00_metro (CSV mancante)"
        }
        Dico ("G0-C sul 00_metro: " + $cellaCorr.Gemelli) "Red"
      } else {
        if($gemelliMisurati -or $cellaCorr.Gemelli -ne "NON MISURATO (CSV non letto)"){
          [void]$Problemi.Add($cellaCorr.Prova + ": gemelli " + $cellaCorr.Gemelli + ". Le due righe dovevano essere identiche al centesimo: questa cella non si legge.")
        }
      }
    } elseif($cellaCorr.Metro) {
      Dico ("G0-C sul 00_metro: IDENTICI (banco deterministico). Metro misurato: PF " + (Fmt3 $cellaCorr.PfOOS) + " | DD " + (Fmt2 $cellaCorr.DdOOS) + "% | n " + (FmtN $cellaCorr.NOOS)) "Green"
    }

    # ---------- G0-B: LA RIPRODUZIONE DI R110 (decisione D3). Solo per
    #  le celle che hanno un riferimento (00_metro e 01_short_r1). Il
    #  MISMATCH e' FATALE: ferma il lancio delle celle successive, NON
    #  la raccolta. NON ESEGUITO e' un guasto, non un "superato".
    if($cellaCorr.RifG0BTag -ne ""){
      $esitiG0B = New-Object System.Collections.ArrayList
      foreach($tagGamba in @("IS","OOS")){
        $csvRifG0B = Join-Path $RifG0B ($EaNome + "_" + $SimboloRound + "_" + $tagGamba + "_" + $cellaCorr.RifG0BTag + ".csv")
        $esitoGamba = ConfrontaG0B (CsvDi $cellaCorr $tagGamba) $csvRifG0B
        [void]$esitiG0B.Add($tagGamba + ": " + $esitoGamba)
        if($esitoGamba -like "MISMATCH*"){
          [void]$Problemi.Add("G0-B FALLITO su " + $cellaCorr.Prova + " (" + $tagGamba + " contro R110 " + $cellaCorr.RifG0BTag + "): " + $esitoGamba +
                              ". Il banco NON ha riprodotto R110 a parita' di tutto (criteri par. 5, decisione D3: FATALE). Se il banco non e' riproducibile fra corse, e' una notizia piu' grossa del round e va nel suo referto. Le celle successive NON sono state lanciate; la raccolta si fa lo stesso.")
        } elseif($esitoGamba -like "NON ESEGUITO*"){
          [void]$Problemi.Add("G0-B NON ESEGUITO su " + $cellaCorr.Prova + " (" + $tagGamba + "): " + $esitoGamba + ". 'NON ESEGUITO' NON e' 'superato': e' un guasto (il confronto non e' stato possibile).")
        }
      }
      $cellaCorr.G0B = ($esitiG0B -join " | ")
      if($cellaCorr.G0B -like "*MISMATCH*"){
        if($CatenaFerma -eq ""){ $CatenaFerma = "G0-B MISMATCH su " + $cellaCorr.Id + ": il banco non riproduce R110" }
        Dico ("G0-B su " + $cellaCorr.Id + ": " + $cellaCorr.G0B) "Red"
      } elseif($cellaCorr.G0B -like "*NON ESEGUITO*"){
        Dico ("G0-B su " + $cellaCorr.Id + ": " + $cellaCorr.G0B) "Yellow"
      } else {
        Dico ("G0-B su " + $cellaCorr.Id + ": RIPRODOTTO AL CENTESIMO (14 stringhe su 14 identiche a R110, IS+OOS)") "Green"
      }
    } else {
      $cellaCorr.G0B = "NON APPLICABILE (dial mai misurato prima: e' la misura nuova, non c'e' niente da riprodurre)"
    }

    # ---------- LA MACCHINA PER-TRADE (decisione D4): raccolta,
    #  G0-C-bis, identita' di gamba, riconciliazione, peggior giornata.
    AnalisiPerTrade $cellaCorr $avvioCella
    if($cellaCorr.PtStato -like "MISURATA*"){
      Dico ("peggior giornata OOS " + $cellaCorr.Id + ": " + $cellaCorr.PgData + "  " + (FmtEuroCent $cellaCorr.PgEuro) + " EUR  (" + (FmtPg $cellaCorr.PgPctFisso) + "% su 100k fisso, " + (FmtPg $cellaCorr.PgPctEq) + "% su equity inizio giornata; " + (FmtN $cellaCorr.PgGiorni) + " giorni con chiusure)") "Yellow"
      Dico ("   dei CHIUSI: il muro delle prop guarda il FLOTTANTE, questa e' un pavimento. IS: n/d per costruzione.") "Yellow"
    } else {
      Dico ("peggior giornata OOS " + $cellaCorr.Id + ": " + $cellaCorr.PtStato) "Yellow"
    }

    # ---------- G1 MISURABILITA' (rilievo, non gate)
    if(-not $cellaCorr.Metro){
      if([int]$cellaCorr.NOOS -ge 0 -and [int]$cellaCorr.NOOS -lt 30){
        [void]$Rilievi.Add($cellaCorr.Prova + ": n OOS = " + $cellaCorr.NOOS + ", sotto la soglia G1 di 30. Il verdetto su questa cella e' NON MISURABILE, NON 'non funziona' (criteri par. 5, G1). E' una risposta del round.")
      }
      elseif([int]$cellaCorr.NOOS -ge 150){
        [void]$Rilievi.Add($cellaCorr.Prova + ": n OOS = " + $cellaCorr.NOOS + ", SOPRA i 150 dell'Emendamento regola A: il giudizio di MERITO si puo' dare per intero.")
      }
    }
  } else { $cellaCorr.Esito = "SOLO CONTROLLO" }

  # --- L'ANTEPRIMA del giro a vuoto: si LEGGE (finestra IS calcolata,
  #     asse unico, magic, e LATO+DIAL nell'ini che MT5 leggerebbe),
  #     poi va in sosta subito (il nome non porta l'etichetta e la
  #     successiva la sovrascriverebbe, checklist 31).
  if($SoloControllo){
    $percorsoAnteprima = Join-Path $Work ("anteprima_" + $EaNome + "_" + $SimboloRound + ".ini")
    if(Test-Path -LiteralPath $percorsoAnteprima){
      $testoAnteprima = Get-Content -LiteralPath $percorsoAnteprima -Raw
      $matchAntFrom = [regex]::Match($testoAnteprima,'(?m)^FromDate=([0-9.]+)\r?$')
      $matchAntTo   = [regex]::Match($testoAnteprima,'(?m)^ToDate=([0-9.]+)\r?$')
      if(-not $matchAntFrom.Success -or -not $matchAntTo.Success){ [void]$Problemi.Add("giro a vuoto / " + $cellaCorr.Id + ": nell'anteprima non trovo FromDate/ToDate.") }
      elseif($matchAntFrom.Groups[1].Value -ne $IS_Da -or $matchAntTo.Groups[1].Value -ne $IS_A){
        [void]$Problemi.Add("giro a vuoto / " + $cellaCorr.Id + ": il driver generico calcola la finestra IS " + $matchAntFrom.Groups[1].Value + " - " + $matchAntTo.Groups[1].Value +
                            ", ma questa riga (e i criteri par. 1) dicono " + $IS_Da + " - " + $IS_A + ". O e' cambiata la FrazioneIS del driver, o e' cambiata la finestra: le due cose NON possono divergere.")
      }
      $assiYAnteprima = @([regex]::Matches($testoAnteprima,'(?m)^(\w+)=[^\r\n]*\|\|\s*[Yy]\s*\r?$') | ForEach-Object { $_.Groups[1].Value })
      if($assiYAnteprima.Count -ne 1 -or $assiYAnteprima[0] -ne "InpMagic"){
        [void]$Problemi.Add("giro a vuoto / " + $cellaCorr.Id + ": gli assi spazzolati nell'anteprima sono [" + ($assiYAnteprima -join ", ") + "] invece del solo InpMagic.")
      }
      if($testoAnteprima -notmatch ('(?m)^InpMagic=' + $cellaCorr.Magic + '\|\|')){
        [void]$Problemi.Add("giro a vuoto / " + $cellaCorr.Id + ": nell'anteprima InpMagic non parte da " + $cellaCorr.Magic + ".")
      }
      #  LATO E DIAL, NELL'INI CHE GIRA DAVVERO: e' l'unica cosa che
      #  questo round misura.
      foreach($chiaveVal in $cellaCorr.Val.Keys){
        if($testoAnteprima -notmatch ('(?m)^' + $chiaveVal + '=' + [regex]::Escape($cellaCorr.Val[$chiaveVal]) + '\s*\r?$') -and
           $testoAnteprima -notmatch ('(?m)^' + $chiaveVal + '=' + [regex]::Escape($cellaCorr.Val[$chiaveVal]) + '\|\|')){
          [void]$Problemi.Add("giro a vuoto / " + $cellaCorr.Id + ": nell'anteprima " + $chiaveVal + " non vale " + $cellaCorr.Val[$chiaveVal] + ". E' il CONTRATTO, cioe' l'unica cosa che questo round misura.")
        }
      }
      Copy-Item -LiteralPath $percorsoAnteprima -Destination (Join-Path $Sosta ("anteprima_EMADOW_" + $cellaCorr.Id + ".ini")) -Force
      Remove-Item -LiteralPath $percorsoAnteprima -Force -ErrorAction SilentlyContinue
    } else { [void]$Problemi.Add("giro a vuoto: nessuna anteprima .ini per " + $cellaCorr.Prova) }
  }
  Write-Host ("    esito: " + $cellaCorr.Esito + "   [" + $cellaCorr.Min.ToString("0.0",$INV) + " min]") -ForegroundColor Gray
}

if($SoloControllo){
  $numAnteprime = @(Get-ChildItem -LiteralPath $Sosta -Filter "anteprima_*.ini" -ErrorAction SilentlyContinue).Count
  if($numAnteprime -ne $Ordinati.Count){ [void]$Problemi.Add("giro a vuoto: " + $numAnteprime + " anteprime .ini invece di " + $Ordinati.Count + ".") }
  Write-Host ""
  Write-Host ("    anteprime .ini in sosta: " + $numAnteprime + " su " + $Ordinati.Count + "   -> " + $Sosta) -ForegroundColor White
  Write-Host  "    >>> IL GIRO A VUOTO NON MISURA NESSUN NUMERO: niente n, niente PF," -ForegroundColor Yellow
  Write-Host  "        niente DD, niente G0-B, niente G0-C, NESSUNA peggior giornata." -ForegroundColor Yellow
  Write-Host  "        Conferma gli ARTEFATTI (e G0-A, l'antenato, che gira prima di MT5)." -ForegroundColor Yellow
  Write-Host  "        'Model=4' nell'anteprima e' una COSTANTE del ramo di prova del" -ForegroundColor Yellow
  Write-Host  "        driver generico: stavolta COINCIDE con la corsa vera (-Modello 4)." -ForegroundColor Yellow
}

}catch{
  $Fatale = $_.Exception.Message
  Write-Host ""
  Write-Host ("!!! FERMATO: " + $Fatale) -ForegroundColor Red
}

# =====================================================================
#  5. RACCOLTA. Si fa SEMPRE, anche a esito parziale o fermato -- e
#     anche con G0-B in MISMATCH (il mismatch non ferma la raccolta:
#     si raccoglie tutto e si dichiara).
# =====================================================================
Titolo "5. RACCOLTA SUL DESKTOP"
$Modo = if($SoloControllo){ "CONTROLLO" } elseif($SoloCella -ne ""){ "RIPRESA" } else { "CORSA" }
$Cart = Join-Path $Dsk ("R112_EMADOW_CONTRATTO_" + $Modo + "_" + $Stamp)
$Zip  = Join-Path $Dsk ("R112_EMADOW_CONTRATTO_" + $Modo + "_" + $Stamp + ".zip")
$Referto = Join-Path $Cart "REFERTO_R112.txt"
try{
  New-Item -ItemType Directory -Force -Path $Cart | Out-Null
  foreach($cellaRacc in $Lavori){
    foreach($tagGamba in @("IS","OOS")){
      $csvDaCopiare = CsvDi $cellaRacc $tagGamba
      if(Test-Path -LiteralPath $csvDaCopiare){ Copy-Item -LiteralPath $csvDaCopiare -Destination (Join-Path $Cart (Split-Path -Leaf $csvDaCopiare)) -Force }
    }
    #  i per-trade della cella, PER NOME (solo cio' che ha girato: 56)
    foreach($magRacc in @([int]$cellaRacc.Magic, ([int]$cellaRacc.Magic + 1))){
      $ptDaCopiare = Join-Path $Work ("pertrade_" + $cellaRacc.Id + "_" + $magRacc + ".csv")
      if(Test-Path -LiteralPath $ptDaCopiare){
        if((Get-Item -LiteralPath $ptDaCopiare).LastWriteTime -ge $Avvio){
          Copy-Item -LiteralPath $ptDaCopiare -Destination (Join-Path $Cart (Split-Path -Leaf $ptDaCopiare)) -Force
        }
      }
    }
    #  il file prova che ha girato
    $provaDaCopiare = Join-Path $Prove $cellaRacc.Prova
    if(Test-Path -LiteralPath $provaDaCopiare){ Copy-Item -LiteralPath $provaDaCopiare -Destination (Join-Path $Cart $cellaRacc.Prova) -Force }
  }
  #  gli ANTENATI e i RIFERIMENTI G0-B: lo zip e' autosufficiente, chi lo
  #  apre fra un mese rifa' G0-A e G0-B a mano senza tornare in repo.
  foreach($nomeAntenato in @($Lavori | ForEach-Object { $_.AntFile } | Sort-Object -Unique)){
    $antDaCopiare = Join-Path $Anten $nomeAntenato
    if(Test-Path -LiteralPath $antDaCopiare){ Copy-Item -LiteralPath $antDaCopiare -Destination (Join-Path $Cart $nomeAntenato) -Force }
  }
  foreach($rifDaCopiare in @(Get-ChildItem -LiteralPath $RifG0B -Filter "*.csv" -ErrorAction SilentlyContinue)){
    Copy-Item -LiteralPath $rifDaCopiare.FullName -Destination (Join-Path $Cart ("RIF_R110_" + $rifDaCopiare.Name)) -Force
  }
  #  la SOSTA si copia intera: e' svuotata a ogni giro (56) e contiene
  #  solo artefatti di ADESSO (anteprime, log compilatore, gen_*.ini).
  if(Test-Path -LiteralPath $Sosta){
    foreach($fileSosta in @(Get-ChildItem -LiteralPath $Sosta -File -ErrorAction SilentlyContinue)){
      Copy-Item -LiteralPath $fileSosta.FullName -Destination (Join-Path $Cart $fileSosta.Name) -Force
    }
  }

  $RefTxt = New-Object System.Collections.ArrayList
  [void]$RefTxt.Add("REFERTO R112 - IL CONTRATTO DELL'EMADOW: SHORT-ONLY, E A QUALE DIAL?")
  [void]$RefTxt.Add("ABTG_EMA200 / U30USD H1 - sedia viva 771531 (0,65% in campo sul 100k)")
  [void]$RefTxt.Add("modo: " + $Modo + $(if($SoloControllo){ "   <<< GIRO A VUOTO: NESSUNA passata, NESSUN CSV, NESSUN numero di round qui dentro" } else { "" }))
  $switchGiro = @()
  if($SoloControllo){ $switchGiro += "-SoloControllo (nessuna passata)" }
  #  >>> CHECKLIST 82: la frase sulla firma si costruisce sul VALORE
  #      LETTO, mai su un ramo solo. Lo switch inerte va detto inerte.
  if($CriteriFirmati -and $daFirmare){ $switchGiro += "-CriteriFirmati (FIRMA IN RIGA di Claudio: il file dei criteri portava ancora il lucchetto)" }
  elseif($CriteriFirmati){ $switchGiro += "-CriteriFirmati (INERTE, e va bene: i criteri risultano gia' FIRMATI NEL FILE al pin -- la firma e' quella del documento, non una firma in riga)" }
  if($SoloCella -ne ""){ $switchGiro += "-SoloCella " + $SoloCella + " (il 00_metro e' girato lo stesso: e' il denominatore e porta G0-B e G0-C)" }
  if($Rifai){ $switchGiro += "-Rifai (i CSV precedenti sono stati rifatti)" }
  if($switchGiro.Count -eq 0){ $switchGiro += "nessuno (corsa piena, ripresa dei CSV gia' presenti ATTIVA)" }
  [void]$RefTxt.Add("switch di questo giro: " + ($switchGiro -join " | "))
  [void]$RefTxt.Add("stato dei criteri: " + $Firma)
  [void]$RefTxt.Add("data: " + (Get-Date).ToString("yyyy-MM-dd HH:mm:ss",$INV) + "   (questa data deve essere di ADESSO)")
  [void]$RefTxt.Add("avvio: " + $Avvio.ToString("yyyy-MM-dd HH:mm:ss",$INV) + "   durata: " + ((New-TimeSpan -Start $Avvio -End (Get-Date)).TotalHours).ToString("0.0",$INV) + " ore")
  [void]$RefTxt.Add("pin: " + $Pin)
  [void]$RefTxt.Add("criteri: risultati_archivio\R112_CRITERI.md (sei decisioni, par. 10)")
  [void]$RefTxt.Add("finestra: " + $DaQuando + " -> " + $Fino + "   split 40/60   modello " + $Modello + " (tick reali)   deposito " + $Deposito)
  [void]$RefTxt.Add("     IS  " + $IS_Da + " - " + $IS_A)
  [void]$RefTxt.Add("     OOS " + $OOS_Da + " - " + $OOS_A)
  [void]$RefTxt.Add("     (LE STESSE DI R110, dichiaratamente: e' cio' che rende G0-B possibile)")
  [void]$RefTxt.Add("spread: Spread=" + $SpreadIni + " scritto NELL'INI = spread CORRENTE del feed BCM, dichiarato.")
  [void]$RefTxt.Add("rischio: il dial nei file e' 1,0 / 2,0 / 3,0. IN CAMPO SUL 100K SI MOLTIPLICA PER 0,65:")
  [void]$RefTxt.Add("     dial 1,0 -> 0,65% per trade in campo (la sedia com'e' oggi)")
  [void]$RefTxt.Add("     dial 2,0 -> 1,30% per trade in campo")
  [void]$RefTxt.Add("     dial 3,0 -> 1,95% per trade in campo  <<< un solo SL vivo impegna il 60% del cap C1 (3,25%)")
  [void]$RefTxt.Add("     Ogni DD di questo referto e' al dial dichiarato della sua riga: per il campo x0,65.")
  [void]$RefTxt.Add("")
  [void]$RefTxt.Add("--- CONVENZIONE DI SENTINELLA (checklist 66) ---")
  [void]$RefTxt.Add("  Un numero NON MISURATO si scrive 'n/d'. MAI -1, MAI 0.000. Vale per TUTTE le")
  [void]$RefTxt.Add("  colonne, comprese le due nuove PeggGio%fisso e PeggGio%eq.")
  [void]$RefTxt.Add("")
  [void]$RefTxt.Add("--- LA PEGGIOR GIORNATA: LA CONVENZIONE, CONGELATA PRIMA (decisione D4) ---")
  [void]$RefTxt.Add("  * giornata = somma dei net_profit CHIUSI nella stessa DATA SERVER BCM.")
  [void]$RefTxt.Add("    >>> L'OROLOGIO E' L'ORA SERVER BCM (ora italiana - 1 in questo periodo:")
  [void]$RefTxt.Add("        checklist 86): le close_time dei per-trade sono scritte cosi' dall'EA.")
  [void]$RefTxt.Add("  * DUE denominatori, tutti e due: % sul deposito FISSO 100k e % sull'equity")
  [void]$RefTxt.Add("    di inizio giornata (100k + cumulato dei giorni OOS precedenti).")
  [void]$RefTxt.Add("  * SOLO OOS. LA PEGGIOR GIORNATA IS E' n/d PER COSTRUZIONE SU TUTTO IL ROUND:")
  [void]$RefTxt.Add("    il driver generico corre gamba IS poi gamba OOS nella stessa chiamata e")
  [void]$RefTxt.Add("    l'export sovrascrive il file del magic a ogni gamba -- sopravvive l'ultima.")
  [void]$RefTxt.Add("    E NON lo si assume: lo si MISURA (tutte le close_time devono cadere in OOS;")
  [void]$RefTxt.Add("    se una sola cade prima, la cella esce n/d, mai un numero sbagliato).")
  [void]$RefTxt.Add("  * RICONCILIAZIONE: i position_id DISTINTI del file devono combaciare col n OOS")
  [void]$RefTxt.Add("    dell'OPTFRAME. ATTENZIONE: le RIGHE sono i DEAL DI USCITA e con TP1 al 50% +")
  [void]$RefTxt.Add("    trailing una posizione chiude in DUE deal, quindi righe > n e' NORMALE; il")
  [void]$RefTxt.Add("    confronto giusto e' sui position_id distinti. Scarto -> dichiarato, mai zitto.")
  [void]$RefTxt.Add("  * >>> IL LIMITE PIU' IMPORTANTE: questa e' la peggior giornata dei CHIUSI.")
  [void]$RefTxt.Add("    Il muro giornaliero delle prop (e il Guardian) guardano l'equity FLOTTANTE,")
  [void]$RefTxt.Add("    che qui non c'e' (R109 ha misurato quanto pesa la differenza). Questa misura")
  [void]$RefTxt.Add("    SOTTOSTIMA ed e' un PAVIMENTO, non il numero del muro.")
  [void]$RefTxt.Add("")
  [void]$RefTxt.Add("--- I GATE (criteri par. 5) ---")
  [void]$RefTxt.Add("  G0-A  ANTENATO  : copia riga per riga del file prova R110, salvo i delta")
  [void]$RefTxt.Add("                    dichiarati. Catena R103 -> R110 -> R112. Gira PRIMA di MT5.")
  [void]$RefTxt.Add("  G0-B  RIPRODUZIONE DI R110: APPLICABILE, per la prima volta, e FATALE (D3).")
  [void]$RefTxt.Add("                    Stesso banco + stessa finestra + stessi input -> le 7 colonne")
  [void]$RefTxt.Add("                    statistiche delle 2 righe IDENTICHE COME STRINGHE, IS e OOS.")
  [void]$RefTxt.Add("                    TRE esiti: OK / MISMATCH (fatale) / NON ESEGUITO (guasto,")
  [void]$RefTxt.Add("                    NON 'superato'). Riguarda 00_metro e 01_short_r1; r2 e r3")
  [void]$RefTxt.Add("                    sono la misura NUOVA: per loro G0-B e' NON APPLICABILE.")
  [void]$RefTxt.Add("  G0-C  GEMELLI   : le due righe del CSV identiche al centesimo (determinismo).")
  [void]$RefTxt.Add("  G0-C-bis        : i DUE file per-trade gemelli identici riga per riga tranne")
  [void]$RefTxt.Add("                    la colonna magic. E' il G0-C al livello del singolo trade.")
  [void]$RefTxt.Add("  G1 MISURABILITA': n OOS >= 30 per cella (atteso: largamente superato).")
  [void]$RefTxt.Add("")
  [void]$RefTxt.Add("--- LA TABELLA MADRE ---   (attese: " + $CelleAttese + " righe per CSV, " + (2*$Lavori.Count) + " CSV, " + (4*$Lavori.Count) + " passate)")
  [void]$RefTxt.Add("  dPF e dDD sono il DELTA OOS contro il 00_metro. PeggGio = peggior giornata OOS")
  [void]$RefTxt.Add("  dei CHIUSI: il muro delle prop guarda il FLOTTANTE, questa e' un pavimento.")
  [void]$RefTxt.Add(("  {0,-12} {1,-9} {2,-7} {3,-7} {4,-6} {5,-9} {6,-7} {7,-7} {8,-6} {9,-8} {10,-7} {11,-13} {12,-11} {13}" -f `
                "CELLA","ISprof","ISpf","ISdd","ISn","OOSprof","OOSpf","OOSdd","OOSn","dPF","dDD%","PeggGio%fisso","PeggGio%eq","ESITO"))
  $rifMetro = @($Ordinati | Where-Object { $_.Metro })[0]
  foreach($cellaRef in $Ordinati){
    $deltaPf = "n/d"; $deltaDd = "n/d"
    if([double]$cellaRef.PfOOS -ge 0 -and [double]$rifMetro.PfOOS -ge 0){ $deltaPf = ([double]$cellaRef.PfOOS - [double]$rifMetro.PfOOS).ToString("+0.000;-0.000;0.000",$INV) }
    if([double]$cellaRef.DdOOS -ge 0 -and [double]$rifMetro.DdOOS -ge 0){ $deltaDd = ([double]$cellaRef.DdOOS - [double]$rifMetro.DdOOS).ToString("+0.00;-0.00;0.00",$INV) }
    [void]$RefTxt.Add(("  {0,-12} {1,-9} {2,-7} {3,-7} {4,-6} {5,-9} {6,-7} {7,-7} {8,-6} {9,-8} {10,-7} {11,-13} {12,-11} {13}" -f `
                  $cellaRef.Id,(FmtE $cellaRef.ProfIS),(Fmt3 $cellaRef.PfIS),(Fmt2 $cellaRef.DdIS),(FmtN $cellaRef.NIS),
                  (FmtE $cellaRef.ProfOOS),(Fmt3 $cellaRef.PfOOS),(Fmt2 $cellaRef.DdOOS),(FmtN $cellaRef.NOOS),
                  $deltaPf,$deltaDd,(FmtPg $cellaRef.PgPctFisso),(FmtPg $cellaRef.PgPctEq),$cellaRef.Esito))
  }
  [void]$RefTxt.Add("  (la colonna 'Peggior Giornata %' NON esiste nell'OPTFRAME di questo EA -- 8")
  [void]$RefTxt.Add("   colonne, misurato nel sorgente al pin: qui viene dai PER-TRADE, decisione D4.")
  [void]$RefTxt.Add("   PeggGio IS: n/d PER COSTRUZIONE, vedi la convenzione in testa.)")
  [void]$RefTxt.Add("")
  [void]$RefTxt.Add("--- LE CELLE, GATE PER GATE ---")
  foreach($cellaRef in $Ordinati){
    [void]$RefTxt.Add(("  {0,-12} magic {1}/{2}   InpAllowLong={3} InpAllowShort={4} InpRiskPercent={5}" -f `
                  $cellaRef.Id,$cellaRef.Magic,($cellaRef.Magic+1),$cellaRef.Val["InpAllowLong"],$cellaRef.Val["InpAllowShort"],$cellaRef.Val["InpRiskPercent"]))
    [void]$RefTxt.Add("       " + $cellaRef.Desc)
    [void]$RefTxt.Add("       G0-A antenato : " + $cellaRef.Antenato)
    [void]$RefTxt.Add("       G0-B          : " + $cellaRef.G0B)
    [void]$RefTxt.Add("       G0-C gemelli  : " + $cellaRef.Gemelli)
    [void]$RefTxt.Add("       G0-C-bis (pt) : " + $cellaRef.GemPt)
    [void]$RefTxt.Add("       per-trade     : " + $cellaRef.PtStato)
    [void]$RefTxt.Add("       riconciliaz.  : " + $cellaRef.Riconc)
    if($cellaRef.PtStato -like "MISURATA*"){
      [void]$RefTxt.Add("       peggior giornata OOS : " + $cellaRef.PgData + "  " + (FmtEuroCent $cellaRef.PgEuro) + " EUR = " + (FmtPg $cellaRef.PgPctFisso) + "% su 100k fisso | " + (FmtPg $cellaRef.PgPctEq) + "% su equity inizio giornata")
      [void]$RefTxt.Add("       giorni con chiusure  : " + (FmtN $cellaRef.PgGiorni) + "   le 3 peggiori: " + $cellaRef.PgTop3)
      [void]$RefTxt.Add("       tetto volume (R109)  : volume max " + (Fmt2 $cellaRef.VolMax) + " lotti, " + (Fmt2 $cellaRef.VolQuota) + "% delle righe al massimo")
      [void]$RefTxt.Add("       (peggior giornata dei CHIUSI: il muro delle prop guarda il FLOTTANTE, questa e' un pavimento)")
    }
  }
  [void]$RefTxt.Add("")
  [void]$RefTxt.Add("--- IL CANCELLO DI PORTAFOGLIO (criteri par. 6): I NUMERI, NON IL VERDETTO ---")
  [void]$RefTxt.Add("  INFO: il verdetto lo da' il REFERTO DEL ROUND, a mano. Un dial e' CANDIDATO se")
  [void]$RefTxt.Add("  in OOS: (a) profitto > metro, (b) DD <= metro, (c) peggior giornata <= metro")
  [void]$RefTxt.Add("  (denominatore FISSO; con un n/d il criterio (c) e' NON VALUTABILE e la")
  [void]$RefTxt.Add("  candidatura resta SOSPESA), (d) profitto IS > 0. Fra i dial che passano vince")
  [void]$RefTxt.Add("  il PIU' BASSO (D2-bis). Vietato aggiungere dial a risultati visti (D5).")
  [void]$RefTxt.Add("  (peggior giornata dei CHIUSI: il muro delle prop guarda il FLOTTANTE, questa")
  [void]$RefTxt.Add("   e' un pavimento -- vale per ogni riga (c) qui sotto)")
  foreach($cellaRef in @($Ordinati | Where-Object { -not $_.Metro })){
    [void]$RefTxt.Add("  INFO " + $cellaRef.Id + " (dial " + $cellaRef.Val["InpRiskPercent"] + "):")
    [void]$RefTxt.Add("     (a) profitto OOS : " + (FmtE $cellaRef.ProfOOS) + "  contro metro " + (FmtE $rifMetro.ProfOOS))
    [void]$RefTxt.Add("     (b) DD OOS       : " + (Fmt2 $cellaRef.DdOOS) + "%  contro metro " + (Fmt2 $rifMetro.DdOOS) + "%")
    [void]$RefTxt.Add("     (c) pegg.giornata: " + (FmtPg $cellaRef.PgPctFisso) + "% (fisso)  contro metro " + (FmtPg $rifMetro.PgPctFisso) + "%")
    [void]$RefTxt.Add("     (d) profitto IS  : " + (FmtE $cellaRef.ProfIS))
    [void]$RefTxt.Add("     >>> il verdetto lo da' il referto del round, a mano.")
  }
  [void]$RefTxt.Add("")
  [void]$RefTxt.Add("--- QUELLO CHE QUESTO REFERTO NON DICE, DICHIARATO ---")
  [void]$RefTxt.Add("  * NON APPLICA IL CANCELLO DI PORTAFOGLIO e non promuove niente (G5): nessun")
  [void]$RefTxt.Add("    deploy esce da qui. La sedia 771531 resta com'e'. Se un dial passa, il")
  [void]$RefTxt.Add("    referto del round produce la PROPOSTA DI DELIBERA (atto separato di Claudio,")
  [void]$RefTxt.Add("    col check del cap C1 = 3,25% di rischio aperto).")
  [void]$RefTxt.Add("  * G3 NON APPLICABILE (un solo motore, un solo mercato): il contesto")
  [void]$RefTxt.Add("    cross-motore resta quello di R110 e non viene rimisurato.")
  [void]$RefTxt.Add("  * UN SOLO REGIME: 21 mesi di indici in salita. Ogni verdetto vale PER QUESTA")
  [void]$RefTxt.Add("    EPOCA (criteri par. 9). La prova di regime lunga sul Dow resta BLOCCATA.")
  [void]$RefTxt.Add("  * NON misura il flottante intragiornata, non misura i sotto-periodi, non fa")
  [void]$RefTxt.Add("    la prova di regime, non scrive una riga di MQL5.")
  [void]$RefTxt.Add("  * Il COMPOUNDING e' il motivo per cui si MISURA invece di moltiplicare: al")
  [void]$RefTxt.Add("    2-3% l'equity si muove, PF e DD NON scalano lineari. E il TETTO DI VOLUME")
  [void]$RefTxt.Add("    (R109: morde all'8,9% delle operazioni) puo' rendere 'gentile' il DD ai dial")
  [void]$RefTxt.Add("    alti: la lettura del volume massimo sta nella sezione delle celle.")
  [void]$RefTxt.Add("")
  if($Rilievi.Count -gt 0){
    [void]$RefTxt.Add("--- RILIEVI (NON sono guasti: sono RISULTATI del round) ---   (" + $Rilievi.Count + ")")
    foreach($rilievoRef in $Rilievi){ [void]$RefTxt.Add("  - " + $rilievoRef) }
    [void]$RefTxt.Add("")
  }
  [void]$RefTxt.Add("--- PROBLEMI (questi SI sono guasti) ---   (" + $Problemi.Count + ")")
  if($Problemi.Count -eq 0){ [void]$RefTxt.Add("  nessuno.") }
  foreach($problemaRef in $Problemi){ [void]$RefTxt.Add("  - " + $problemaRef) }
  if($Fatale -ne ""){
    [void]$RefTxt.Add("")
    [void]$RefTxt.Add("--- FERMATO ---")
    [void]$RefTxt.Add("  " + $Fatale)
  }
  [void]$RefTxt.Add("")
  # --- L'ESITO DEL REFERTO DICE LE STESSE PAROLE DELLO SCHERMO, e i
  #     gate ARRIVANO al codice d'uscita: la lista che decide e' LA
  #     STESSA che finisce nel testo (checklist 84).
  $celleKoRef = @($Ordinati | Where-Object { $_.Esito -ne "OK" -and $_.Esito -ne "SOLO CONTROLLO" })
  $mismatchG0B = @($Ordinati | Where-Object { $_.G0B -like "*MISMATCH*" })
  if($Fatale -ne ""){
    [void]$RefTxt.Add("ESITO: FERMATO -- " + $Fatale)
  }
  elseif($SoloControllo){
    if($celleKoRef.Count -gt 0 -or $Problemi.Count -gt 0){
      [void]$RefTxt.Add("ESITO: GIRO A VUOTO CON PROBLEMI (" + $Problemi.Count + ") -- NESSUNA passata. NON lanciare la corsa vera prima di aver letto i PROBLEMI.")
    } else {
      [void]$RefTxt.Add("ESITO: GIRO A VUOTO COMPLETATO -- NESSUNA passata, NESSUN CSV, NESSUN numero. QUESTO ZIP NON E' IL ROUND.")
    }
  }
  elseif($mismatchG0B.Count -gt 0){
    [void]$RefTxt.Add("ESITO: FERMATO SUL BANCO -- G0-B MISMATCH su " + (@($mismatchG0B | ForEach-Object { $_.Id }) -join ", ") + ": il banco NON ha riprodotto R110 a parita' di tutto (criteri D3, FATALE). I numeri di questo giro NON si leggono come round; la raccolta c'e' tutta e il mismatch e' dichiarato riga per riga nei PROBLEMI. E' una notizia piu' grossa del round: referto suo.")
  }
  elseif($celleKoRef.Count -gt 0){
    [void]$RefTxt.Add("ESITO: PARZIALE -- " + $celleKoRef.Count + " celle su " + $Ordinati.Count + " NON hanno prodotto i numeri (elenco qui sopra), piu' " + $Problemi.Count + " problemi. NON e' un round completo.")
  }
  elseif($Problemi.Count -gt 0){
    [void]$RefTxt.Add("ESITO: COMPLETO CON PROBLEMI -- tutte e " + $Ordinati.Count + " le celle hanno prodotto i numeri attesi, ma ci sono " + $Problemi.Count + " problemi. I numeri si leggono ACCANTO ai problemi, non invece dei problemi.")
  }
  elseif($Rilievi.Count -gt 0){
    [void]$RefTxt.Add("ESITO: COMPLETO CON RILIEVI -- tutte e " + $Ordinati.Count + " le celle hanno prodotto i numeri attesi. I " + $Rilievi.Count + " rilievi sono RISULTATI del round, non guasti.")
  }
  else{
    [void]$RefTxt.Add("ESITO: OK -- tutte le celle hanno prodotto i numeri attesi, nessun problema e nessun rilievo in elenco.")
  }
  [void]$RefTxt.Add("")
  [void]$RefTxt.Add("--- COME SI RIPRENDE ---")
  [void]$RefTxt.Add('  una cella sola : ... & $p -Pin <PIN> -SoloCella R112_02_short_r2.txt')
  [void]$RefTxt.Add('  rifare cio'' che c''e'' gia'' : aggiungi -Rifai')
  [void]$RefTxt.Add("  >>> il 00_metro rigira SEMPRE: e' il denominatore e porta G0-B e G0-C.")
  [void]$RefTxt.Add("  >>> i tre puntini stanno per IL BLOCCO INTERO della riga di lancio, con il")
  [void]$RefTxt.Add("      suo irm e la sua guardia: si riprende da RIGA_R112_DA_MANDARE.md.")
  [void]$RefTxt.Add('  >>> senza -CriteriFirmati: se una ripresa esce con codice 2, il file dei')
  [void]$RefTxt.Add('      criteri al pin porta (ancora, o di nuovo) il lucchetto: si legge il')
  [void]$RefTxt.Add('      documento, NON si aggira lo switch.')

  Set-Content -LiteralPath $Referto -Value ($RefTxt -join "`r`n") -Encoding UTF8
  if(Test-Path -LiteralPath $Zip){ Remove-Item -LiteralPath $Zip -Force -ErrorAction SilentlyContinue }
  Compress-Archive -Path (Join-Path $Cart "*") -DestinationPath $Zip -Force
}catch{
  Write-Host ("!!! RACCOLTA PARZIALE: " + $_.Exception.Message) -ForegroundColor Red
}

Write-Host ""
Write-Host "=====================================================================" -ForegroundColor White
Write-Host "  R112 - FINE" -ForegroundColor White
function RigaFinale([string]$percorsoFinale,[string]$codaFinale){
  if(Test-Path -LiteralPath $percorsoFinale){ Write-Host ("   " + $percorsoFinale + "   " + $codaFinale) -ForegroundColor White }
  else                                      { Write-Host ("   " + $percorsoFinale + "   <<< NON ESISTE") -ForegroundColor Red }
}
RigaFinale $Cart    ""
RigaFinale $Zip     "<- e' questo che mi mandi"
RigaFinale $Referto "<- la riga 'data:' deve essere di ADESSO, la riga 'modo:' dice se e' il round o un giro a vuoto"
Write-Host "=====================================================================" -ForegroundColor White
if($SoloControllo){
  Write-Host ("  MODO: " + $Modo + " -- GIRO A VUOTO. NESSUNA passata, NESSUN CSV, NESSUN numero") -ForegroundColor Yellow
  Write-Host ("        di round. Anteprime .ini attese: " + $Ordinati.Count + ". G0-B, G0-C e peggior") -ForegroundColor Yellow
  Write-Host  "        giornata: NON ESEGUITI, ed e' giusto cosi'. (G0-A l'antenato SI:" -ForegroundColor Yellow
  Write-Host  "        gira PRIMA di MT5 ed e' gia' passato.) QUESTO ZIP NON E' IL ROUND." -ForegroundColor Yellow
} else {
  Write-Host ("  MODO: " + $Modo) -ForegroundColor White
  Write-Host ("  ATTESI:  " + (2*$Lavori.Count) + " CSV (" + $Lavori.Count + " celle x IS/OOS), " + $CelleAttese + " righe l'uno, " + (4*$Lavori.Count) + " passate, " + (2*$Lavori.Count) + " per-trade.") -ForegroundColor White
}
foreach($cellaFinale in $Ordinati){
  $coloreFinale = "Green"; if($cellaFinale.Esito -ne "OK" -and $cellaFinale.Esito -ne "SOLO CONTROLLO"){ $coloreFinale = "Yellow" }
  Write-Host ("   " + $cellaFinale.Id.PadRight(14) + " " + $cellaFinale.Esito) -ForegroundColor $coloreFinale
  if(-not $SoloControllo){
    $coloreG0B = if($cellaFinale.G0B -like "*MISMATCH*"){ "Red" } elseif($cellaFinale.G0B -like "*NON ESEGUITO*"){ "Yellow" } elseif($cellaFinale.G0B -like "IS: OK*"){ "Green" } else { "Gray" }
    Write-Host ("     G0-B: " + $cellaFinale.G0B) -ForegroundColor $coloreG0B
    Write-Host ("     peggior giornata OOS: " + $(if($cellaFinale.PtStato -like "MISURATA*"){ $cellaFinale.PgData + " " + (FmtPg $cellaFinale.PgPctFisso) + "% fisso / " + (FmtPg $cellaFinale.PgPctEq) + "% eq (pavimento dei CHIUSI)" } else { $cellaFinale.PtStato })) -ForegroundColor Gray
  }
}
if($Rilievi.Count -gt 0){
  Write-Host ""
  Write-Host "   RILIEVI (risultati del round, NON guasti):" -ForegroundColor Yellow
  foreach($rilievoFin in $Rilievi){ Write-Host ("    - " + $rilievoFin) -ForegroundColor Yellow }
}
if($Problemi.Count -gt 0){
  Write-Host ""
  Write-Host "   PROBLEMI DA LEGGERE:" -ForegroundColor Red
  foreach($problemaFin in $Problemi){ Write-Host ("    - " + $problemaFin) -ForegroundColor Red }
}
Write-Host ""
# =====================================================================
#  L'ESITO IN CONSOLE DICE LE STESSE PAROLE DEL REFERTO, ogni ramo
#  finisce con un exit ESPLICITO, e i gate ARRIVANO al codice d'uscita
#  (checklist 84: la lista dei problemi che decide e' la stessa scritta
#  nel referto). CODICI: 0 = OK / COMPLETO CON RILIEVI; 1 = parziale,
#  fermato, con problemi, G0-B mismatch, o selettore a vuoto;
#  2 = criteri non firmati.
# =====================================================================
if($Fatale -ne ""){ Write-Host ("ESITO: FERMATO -- " + $Fatale) -ForegroundColor Red; exit 1 }
$celleKoFinali = @($Ordinati | Where-Object { $_.Esito -ne "OK" -and $_.Esito -ne "SOLO CONTROLLO" })
$mismatchFinali = @($Ordinati | Where-Object { $_.G0B -like "*MISMATCH*" })
if($SoloControllo){
  if($celleKoFinali.Count -gt 0 -or $Problemi.Count -gt 0){
    Write-Host ("ESITO: GIRO A VUOTO CON PROBLEMI (" + $Problemi.Count + ") -- NESSUNA passata, e c'e' da leggere il referto") -ForegroundColor Yellow
    exit 1
  }
  Write-Host "ESITO: GIRO A VUOTO COMPLETATO -- NESSUNA passata, NESSUN CSV. QUESTO ZIP NON E' IL ROUND." -ForegroundColor Green
  exit 0
}
if($mismatchFinali.Count -gt 0){
  Write-Host ("ESITO: FERMATO SUL BANCO -- G0-B MISMATCH (il banco non riproduce R110, criteri D3). Lo zip esiste: mandalo, e' la notizia del giro.") -ForegroundColor Red
  exit 1
}
if($celleKoFinali.Count -gt 0){
  Write-Host ("ESITO: PARZIALE (" + $celleKoFinali.Count + " celle su " + $Ordinati.Count + " non hanno prodotto i numeri, " + $Problemi.Count + " problemi) -- lo zip esiste: mandalo") -ForegroundColor Yellow
  exit 1
}
if($Problemi.Count -gt 0){
  Write-Host ("ESITO: COMPLETO CON PROBLEMI (" + $Problemi.Count + ") -- i numeri ci sono TUTTI, ma vanno letti ACCANTO ai problemi. Lo zip esiste: mandalo.") -ForegroundColor Yellow
  exit 1
}
if($Rilievi.Count -gt 0){
  Write-Host ("ESITO: COMPLETO CON RILIEVI (" + $Rilievi.Count + " rilievi da leggere nel referto, nessuna cella mancante e nessun guasto)") -ForegroundColor Green
  exit 0
}
Write-Host "ESITO: OK" -ForegroundColor Green
exit 0
