# =====================================================================
#  MARCATORE_RIGA_R114_v1
#  RIGA_R114_PROVA_LEVA.ps1  --  R114: LA PROVA DELLA LEVA (fase 2
#  della prova della taglia). Con la leva prop (1:15 indici e oro) e il
#  deposito challenge (200k), quali sedie ricevono RIFIUTI DI MARGINE?
#  QUATTRO celle, ognuna col SUO antenato congelato, TRE passate l'una:
#     P0 aggancio  100.000 / leva 100   (il banco dell'antenato)
#     P1 taglia    200.000 / leva 100   (il raddoppio da solo)
#     P2 leva      200.000 / leva  15   (LA DOMANDA DEL ROUND)
#  celle (criteri par. 2, magic 763600 + C*20 + P*2 + G, gemello +1):
#     C0_ORB     ABTG_ORB_Ottimizzato               U30USD M5   tick reali
#     C1_EMADOW  ABTG_EMA200 (metro R112)           U30USD H1   tick reali, 2 gambe IS/OOS
#     C2_MAXMIN  ABTG_MaxMinNotte_DAX_Short_Ott.    D30EUR M15  tick reali
#     C3_ORO     ABTG_SupertrendReversal_Ott.       XAUUSD H4   OHLC M1, 2020-2026
#  piu' il CANARINO G-CAN (deposito 2.000 / leva 15 su C0, magic
#  763690/763691) e la sonda G-SPEC (ABTG_SondaMargine sui 3 simboli).
# ---------------------------------------------------------------------
#  CRITERI:   backtest_pipeline\risultati_archivio\R114_CRITERI.md
#             (FIRMATI: "FIRMO R114", Claudio, 27/08/2026 mattina)
#  ORIGINE:   ANALISI_TAGLIA_FASE1 + RISPOSTA_FUNDEDNEXT del 27/08:
#             "il tester ha il campo Leverage nell'.ini: la FASE 2 puo'
#             girare il banco a Leverage=15 e MISURARE i rifiuti".
#
#  >>> LA FIRMA DEI CRITERI SI LEGGE NEL FILE AL PIN, NON SI RICORDA:
#      il gate a TRE rami (checklist 82) cerca il lucchetto COMPOSTO nel
#      file INTERO. [Alla stesura i criteri risultano FIRMATI -- ma fa
#      fede SOLO cio' che il gate legge al pin.] -CriteriFirmati su un
#      file gia' firmato e' INERTE e il referto lo dice.
#
#  DA DOVE NASCE, dichiarato: e' RIGA_R113_REGIME_NASUSD.ps1
#  (MARCATORE_RIGA_R113_v1, fabbrica .ini propria gia' collaudata)
#  adattata da "prova di regime" a "prova della leva", piu' la
#  ConfrontaG0B e la lettura per-trade di RIGA_R112_EMADOW_CONTRATTO.ps1.
#  Checklist 9: le funzioni di sicurezza dei gemelli sono state
#  riportate TUTTE -- guardia MT5/MetaEditor chiusi, -Pin senza default,
#  [CmdletBinding()], gate della firma a tre rami, AllowLiveTrading=false
#  scritto E verificato, install dell'include, gate delle righe vive,
#  ANTENATO per nome, geometria d'identita' (ridotta e dichiarata),
#  asse unico InpMagic, magic vietati per RANGE, compilazione diretta
#  con verdetto LastWriteTime + backup datato + ripristino, sosta
#  svuotata, raccolta e variabili SOPRA il try, modo nel nome, cultura
#  invariante, \r? sui $ multilinea, raccolta SEMPRE, exit esplicito su
#  ogni ramo, sentinella su TUTTE le colonne, ricontrollo della finestra
#  prima di ogni lancio (checklist 79), rilettura dei gen_*.ini che
#  hanno girato, pulizia PER LANCIO (checklist 88), messaggi coi nomi
#  delle cause (checklist 83/89).
#
#  ------------------------------------------------------------------
#  LE NOVITA' DI R114, e le scelte di costruzione DICHIARATE
#
#  (a)  OGNI CELLA GENERA I SUOI .ini CON Deposit/Leverage PROPRI per
#       passata (decisione D2): il file prova NON li contiene. La
#       fabbrica e' quella di R113 (niente walkforward_generico, che
#       scrive Leverage=100 fisso: nota di costruzione dei criteri).
#       Il giro a vuoto stampa Deposit/Leverage/Currency/Model di OGNI
#       .ini generato (checklist 89).
#
#  (a2) MODELLO E FINESTRA PER CELLA, dall'ANTENATO (criteri par. 2):
#       C0/C1/C2 modello 4 (tick reali) su 2024.09.26-2026.06.30;
#       C3 oro modello 1 (OHLC su M1) su 2020.01.01-2026.06.30.
#       >>> DISALLINEAMENTO TROVATO E DICHIARATO, non nascosto: i
#       criteri par. 2 scrivono "tick reali (4)" come modello antenato
#       di C0/C2, ma la corsa R103 archiviata sugli indici e' OHLC M1
#       (lo switch -TickReali di R103 e' rimasto NON FIRMATO, decisione
#       residua B dei criteri R103). Quindi per C0/C2 i numeri
#       d'archivio sono di un banco DIVERSO da P0: il confronto P0
#       contro archivio esce come INFO con questa etichetta, e il G4
#       su quelle celle si giudica A MANO. Per C1 (R112, tick reali) e
#       C3 (R103 forex, OHLC) banco e archivio COINCIDONO.
#
#  (a3) LA FORMA DELLE PASSATE SEGUE L'ANTENATO: C0/C2/C3 finestra
#       UNICA (il banco R103); C1 EMADOW DUE GAMBE IS/OOS 40/60 (il
#       banco R110/R112, l'unico che renda possibile il G0-B al
#       centesimo sui CSV archiviati). Quindi C1 ha 6 .ini di misura
#       (3 passate x 2 gambe), le altre 3. Il "verdetto sull'intera
#       finestra" per C1 si legge sulle DUE gambe insieme (n e profitto
#       si sommano; PF e DD restano per gamba, dichiarato).
#
#  (b)  IL RILEVATORE DEI RIFIUTI: raccolta del journal del tester per
#       ogni lancio e conteggio delle righe di rifiuto con la stringa
#       IMPARATA dal canarino (mai assunta: VPS in italiano, checklist
#       5). Il conteggio e' PER DELTA: prima di ogni lancio si contano
#       le occorrenze dei pattern candidati nei log del tester
#       (Tester\ ricorsivo, *.log), dopo il lancio si ricontano, e la
#       differenza e' del lancio (i log del tester sono giornalieri e
#       si APPENDONO: contare il file intero attribuirebbe al lancio
#       anche le righe di un lancio precedente dello stesso giorno).
#       Le righe che matchano vengono estratte in sosta
#       (rifiuti_<id>.txt). Il rilevatore n.1 resta il DELTA di n
#       (criteri par. 3-bis punto 4).
#
#  (b2) IL CANARINO G-CAN gira PRIMA delle celle, in coppia gemella
#       COME le celle (deposito 2.000, leva 15, input di C0, magic
#       763690/763691): e' il controllo positivo del rilevatore NEL
#       MODO IN CUI il rilevatore verra' usato (checklist 84-bis: si
#       prova nel verso che morde). Se nel suo journal non compare
#       NESSUN candidato, il driver DISAMBIGUA da solo con un secondo
#       canarino a PASSATA SINGOLA (Optimization=0, journal sempre
#       vivo): due cause con due nomi (checklist 83) --
#         canarino B morde  -> il journal delle corse GEMELLE e' muto
#                              (checklist 34): il rilevatore journal
#                              non puo' leggere le corse del round;
#         canarino B zitto  -> o il tester NON simula Leverage=15, o
#                              la stringa vera non e' fra i candidati.
#       In tutti e due i casi: EXIT 2, ROUND FERMO (niente "zero
#       rifiuti" letto con un rilevatore mai visto mordere). Il
#       canarino non entra in nessuna tabella di verdetto.
#
#  (c)  G0-B: C1_EMADOW P0 (IS e OOS) deve riprodurre AL CENTESIMO i
#       CSV di riferimento prove\R110_CSV_EMADOW\ (la ConfrontaG0B e'
#       quella di R112: 7 colonne statistiche IDENTICHE COME STRINGHE,
#       parametri esclusi -- il magic differisce per costruzione).
#       MISMATCH -> la cella e' NON MISURABILE (G4) e il verdetto leva
#       non si legge; le altre celle continuano (G4 e' per cella).
#       Per C0/C2/C3 il P0 si confronta coi numeri d'archivio R103
#       come INFO (nessun CSV di riferimento congelato esiste per
#       quelle celle: DICHIARATO), verdetto G4 a mano -- con
#       l'etichetta (a2) sul banco per C0/C2.
#
#  (d)  G-SPEC (decisione D5): PRIMA di tutto, ANCHE nel giro a vuoto,
#       la sonda ABTG_SondaMargine gira nel tester sui 3 simboli del
#       perimetro a banco P2 (200k / leva 15) e stampa nel journal le
#       specifiche margine (righe 'GSPEC;'), compreso il margine
#       OSSERVATO per 1 lotto (OrderCalcMargin) accanto all'ATTESO
#       della formula FASE 1. Il driver le estrae e le mette nel
#       referto. >>> DEVIAZIONE DICHIARATA dalla convenzione di casa:
#       il giro a vuoto di R114 APRE IL TESTER (solo per le 3 sonde,
#       pochi secondi l'una) perche' i criteri par. 4 lo esigono.
#       Nessun numero di round esce dalla sonda.
#
#  (e)  PER-TRADE (modello export R112): ORB, EMA200 e MaxMinNotte
#       esportano abtg_trades_* nella cartella COMUNE; da li' escono
#       vol max, quota righe al massimo e RIGHE A VOLUME 100 (il clamp
#       silenzioso, criteri par. 3-bis punto 3). >>> MISURATO NEL
#       SORGENTE: ABTG_SupertrendReversal_Ottimizzato NON HA l'export
#       per-trade -- per C3 vol max e righe a 100 sono n/d PER
#       COSTRUZIONE e il rilevatore e' journal + delta n. DICHIARATO.
#       Nessuno dei 4 EA riduce il lotto sul margine (grep agli atti,
#       criteri par. 3-bis punto 3): un rifiuto e' NETTO (n cala).
#
#  (f)  LETTURA verde/giallo/rosso (criteri par. 6): il driver stampa i
#       METRI come INFO (identita' P2-vs-P1 al centesimo, rifiuti,
#       righe a 100 comparse) -- IL VERDETTO E' A MANO, mai del driver.
#       La LISTA DELLE SEDIE AMMISSIBILI esce STAMPATA VUOTA (G5/D10).
#
#  COSA NON FA, dichiarato:
#    - NON deploya, NON tocca VPS ne' sedie, NON compra (G5 per
#      costruzione); i magic vivi sono VIETATI e controllati.
#    - NON misura il basket multi-sedia (fuori perimetro, par. 1 p.6).
#    - NON giudica il MERITO dei motori (G1) e NON spunta i verdetti.
#    - NON scarica tick/storico e NON tocca bases\.
#    - non ammazza un lavoro in corso allo scadere di -OreMax: smette
#      solo di iniziarne di nuovi (checklist 19).
#
#  QUANTO CI METTE: [STIMA], non una previsione. 12 lanci di misura
#  (9 tick reali + 3 gambe oro OHLC... vedi sotto: 15 lanci fisici
#  perche' C1 ha 2 gambe) + canarino + 3 sonde: 40-90 minuti piu' le
#  5 compilazioni, DA VERIFICARE AL PRIMO GIRO. -OreMax e' 4.
#
#  LA RIGA CHE SI INCOLLA (blocco INTERO, un comando solo - checklist 21).
#  <PIN> = il commit che contiene QUESTO file: e' l'hash dato in chat.
#
#  & { $ErrorActionPreference='Stop'; [Net.ServicePointManager]::SecurityProtocol=[Net.SecurityProtocolType]::Tls12;
#      if(Get-Process terminal64,metaeditor64 -EA SilentlyContinue){ throw 'MT5 O METAEDITOR APERTO: chiudili e rilancia.' };
#      $pin='<PIN>'; $p="$env:USERPROFILE\RIGA_R114.ps1"; Remove-Item $p -EA SilentlyContinue;
#      irm "https://raw.githubusercontent.com/claudiospadaro12/GITHUB/$pin/backtest_pipeline/righe/RIGA_R114_PROVA_LEVA.ps1" -OutFile $p;
#      if(-not (Select-String -Path $p -SimpleMatch -Pattern 'MARCATORE_RIGA_R114_v1' -Quiet)){ throw 'SCRIPT VECCHIO' };
#      $global:LASTEXITCODE=0; & $p -Pin $pin -SoloControllo; if($LASTEXITCODE -ne 0){ Write-Host 'ESITO: PARZIALE O FERMO - leggi il REFERTO' } }
#
#  GIRO A VUOTO: e' quello qui sopra (-SoloControllo). Scrive e verifica
#  GLI STESSI .ini della corsa vera (checklist 33), fa girare SOLO le 3
#  sonde G-SPEC nel tester (deviazione (d), dichiarata) e NON misura
#  nessun numero di round: niente n, niente PF, niente G0-C, niente
#  canarino.
# =====================================================================
[CmdletBinding()]
param(
  # -Pin NON ha default: un default silenzioso ("lavoro") farebbe girare la
  #  punta del branch spacciandola per un commit congelato. Meglio morire.
  [string]$Pin        = "",
  [double]$OreMax     = 4.0,       # oltre questo NON si iniziano nuovi lanci
  [switch]$Rifai,                  # rifa' anche i CSV gia' presenti
  [switch]$SoloControllo,          # giro a vuoto: solo sonde G-SPEC nel tester
  [switch]$CriteriFirmati,         # >>> lo preme CLAUDIO, non l'agente. Senza,
                                   #     la corsa vera non parte (exit 2). Su
                                   #     un file gia' firmato e' INERTE e va
                                   #     detto (checklist 82).
  [string]$SoloCella  = ""         # es. "R114_C2_MAXMIN.txt": UNA cella (le
                                   #     sue 3 passate, tutte le gambe). Il
                                   #     canarino e le sonde girano comunque:
                                   #     il rilevatore si riprova a ogni corsa.
)
$ErrorActionPreference = "Stop"
[Threading.Thread]::CurrentThread.CurrentCulture   = [Globalization.CultureInfo]::InvariantCulture
[Threading.Thread]::CurrentThread.CurrentUICulture = [Globalization.CultureInfo]::InvariantCulture
[Net.ServicePointManager]::SecurityProtocol = [Net.SecurityProtocolType]::Tls12

# =====================================================================
# >>> INIZIO DEFINIZIONI PURE -- da qui al marcatore di FINE non c'e'
#     NESSUN accesso a rete/disco/processi: solo tabelle e funzioni.
#     La prova a secco della fabbrica .ini (fatta alla consegna, e
#     rifattibile) estrae ED ESEGUE esattamente questo blocco.
# =====================================================================
$INV = [Globalization.CultureInfo]::InvariantCulture

#--- IL BANCO DELLE PASSATE (decisioni D2/D3). Il deposito e la leva
#    sono PARAMETRI DI BANCO di questa tabella, MAI dei file prova.
function PassataNuova([int]$p,[string]$nome,[int]$dep,[int]$lev,[string]$cosa){
  return [pscustomobject]@{ P=$p; Nome=$nome; Deposito=$dep; Leva=$lev; Cosa=$cosa }
}
$PASSATE = @(
  (PassataNuova 0 "P0_aggancio" 100000 100 "il banco e' LO STESSO dell'antenato?"),
  (PassataNuova 1 "P1_taglia"   200000 100 "il raddoppio di taglia da solo"),
  (PassataNuova 2 "P2_leva"     200000  15 "LA DOMANDA DEL ROUND")
)
$CanDeposito = 2000; $CanLeva = 15; $CanMagicBase = 763690
$SpecDeposito = 200000; $SpecLeva = 15          # la sonda gira al banco P2
$SpecDa = "2026.06.01"; $SpecA = "2026.06.30"   # finestra corta, dentro tutte
$SpreadIni = 0        # convenzione di casa: spread CORRENTE del simbolo,
                      # scritto nell'ini invece che lasciato allo stato
                      # nascosto del terminale (R100/R102/R103).
$CelleAttese = 2      # le due righe GEMELLE per CSV (G0-C)

#--- LE FINESTRE, coi SECONDI DEPOSITI letterali (checklist 79):
#    ricontrollate un istante prima di OGNI lancio.
$DaIndici = "2024.09.26"; $FinoTutti = "2026.06.30"   # muro feed BCM indici
$DaOro    = "2020.01.01"                              # finestra R103 forex
$FrazioneIS = 0.40   # lo split 40/60 di casa (walkforward_generico) -- SOLO
                     # per C1 EMADOW, che e' l'unica cella con gambe IS/OOS
$dtIni  = [datetime]::ParseExact($DaIndici,"yyyy.MM.dd",$INV)
$dtFine = [datetime]::ParseExact($FinoTutti,"yyyy.MM.dd",$INV)
$dtMeta = $dtIni.AddDays([math]::Floor(($dtFine-$dtIni).TotalDays*$FrazioneIS))
$IS_Da  = $dtIni.ToString("yyyy.MM.dd",$INV)
$IS_A   = $dtMeta.ToString("yyyy.MM.dd",$INV)
$OOS_Da = $dtMeta.AddDays(1).ToString("yyyy.MM.dd",$INV)
$OOS_A  = $dtFine.ToString("yyyy.MM.dd",$INV)
#--- il secondo deposito: la formula qui sopra DEVE dare queste stringhe
#    (calcolate a mano alla stesura: 642 giorni * 0,40 = 256,8 -> 256).
$FinestreLetterali = @{}
$FinestreLetterali["IND"] = "2024.09.26|2026.06.30"
$FinestreLetterali["ORO"] = "2020.01.01|2026.06.30"
$FinestreLetterali["IS"]  = "2024.09.26|2025.06.09"
$FinestreLetterali["OOS"] = "2025.06.10|2026.06.30"
if(($IS_Da + "|" + $IS_A) -ne $FinestreLetterali["IS"]){ throw ("split IS: la formula da' [" + $IS_Da + "|" + $IS_A + "] ma il deposito letterale dice [" + $FinestreLetterali["IS"] + "]. Checklist 79: mi fermo PRIMA di scrivere un .ini.") }
if(($OOS_Da + "|" + $OOS_A) -ne $FinestreLetterali["OOS"]){ throw ("split OOS: la formula da' [" + $OOS_Da + "|" + $OOS_A + "] ma il deposito letterale dice [" + $FinestreLetterali["OOS"] + "]. Checklist 79: mi fermo PRIMA di scrivere un .ini.") }

#--- MAGIC VIETATI (criteri par. 5): i vivi/sorgenti delle 4 sedie e i
#    blocchi bruciati/riservati 7633xx (R110), 7634xx (R112), 7635xx
#    (R113) -- come RANGE, mai come elenco.
$MagicVietati = @(770611, 771531, 771501, 770411, 970901)
function MagicVietato([int]$numeroMagic){
  if($MagicVietati -contains $numeroMagic){ return $true }
  if($numeroMagic -ge 763300 -and $numeroMagic -le 763599){ return $true }
  return $false
}

# =====================================================================
#  LE QUATTRO CELLE (criteri par. 2), CONGELATE. Campi:
#  - Ea/Ver/MagicSorgente : LETTI NEI SORGENTI al pin il 27/08
#  - Vive : righe vive del file prova = dell'antenato, MISURATE con
#    grep -cvE '^\s*(#|$)' il 27/08 (56 / 46 / 55 / 45)
#  - Gambe : "UNICA" (banco R103) o "ISOOS" (banco R110/R112, solo C1)
#  - PerTrade : l'EA esporta abtg_trades_* (MISURATO nel sorgente:
#    C3 NO, vedi novita' (e))
#  - InfoArchivio : i numeri d'archivio per il confronto INFO di P0
#    (fonte citata; per C0/C2 il banco d'archivio e' OHLC: nota (a2))
#  - Lati/Risk/Commento : la geometria d'identita' RIDOTTA pretesa NEI
#    file (il G0-A contro l'antenato al pin copre il resto riga per
#    riga; la geometria piena delle 4 sedie sarebbe ~200 righe di
#    tabella e vivrebbe gia' negli antenati: RIDOTTA E DICHIARATA)
# =====================================================================
function CellaNuova([int]$c,[string]$sigla,[string]$ea,[string]$ver,[string]$magicSrc,
                    [string]$sym,[string]$tf,[int]$modello,[string]$da,[string]$a,[string]$chiaveFin,
                    [string]$gambe,[int]$vive,[string]$risk,[string]$latoL,[string]$latoS,
                    [string]$commento,[bool]$perTrade,[string]$infoArchivio){
  return [pscustomobject]@{
    C=$c; Sigla=$sigla; Id=("C" + $c + "_" + $sigla)
    Prova=("R114_C" + $c + "_" + $sigla + ".txt")
    AntFile=""; Ea=$ea; Ver=$ver; MagicSorgente=$magicSrc
    Sym=$sym; Tf=$tf; Modello=$modello; Da=$da; A=$a; ChiaveFin=$chiaveFin
    Gambe=$gambe; Vive=$vive; Risk=$risk; LatoL=$latoL; LatoS=$latoS
    Commento=$commento; PerTrade=$perTrade; InfoArchivio=$infoArchivio
    MagicBase=(763600 + 20*$c)
    Antenato="NON VERIFICATO"; G0B="NON APPLICABILE (nessun CSV di riferimento congelato: confronto INFO a mano)"
    Misurabile="DA MISURARE"
  }
}
$CELLE = @(
  (CellaNuova 0 "ORB"    "ABTG_ORB_Ottimizzato"                    "1.02" "770611" "U30USD" "M5"  4 $DaIndici $FinoTutti "IND" "UNICA" 56 "0.3"  "true"  "false" "ORB OTT"          $true  "R103 blocco INDICI (BANCO DIVERSO, OHLC M1 -- nota (a2)): prof +17.487, PF 1,67, DD 3,00%, n 190"),
  (CellaNuova 1 "EMADOW" "ABTG_EMA200"                             "1.00" "771501" "U30USD" "H1"  4 $DaIndici $FinoTutti "IND" "ISOOS" 46 "1.0"  "true"  "true"  "EMA200 DOW"       $true  "G0-B AL CENTESIMO contro prove\R110_CSV_EMADOW (stesso banco tick reali, dimostrato due volte in R112)"),
  (CellaNuova 2 "MAXMIN" "ABTG_MaxMinNotte_DAX_Short_Ottimizzato"  "1.10" "770411" "D30EUR" "M15" 4 $DaIndici $FinoTutti "IND" "UNICA" 55 "0.65" "false" "true"  "MAXMIN DAX SHORT" $true  "R103 blocco INDICI (BANCO DIVERSO, OHLC M1 -- nota (a2)): prof +8.445, PF 2,26, DD 1,98%, n 41"),
  (CellaNuova 3 "ORO"    "ABTG_SupertrendReversal_Ottimizzato"     "1.00" "970901" "XAUUSD" "H4"  1 $DaOro    $FinoTutti "ORO" "UNICA" 45 "1.0"  "true"  "true"  "STREV OTT"        $false "R103 forex (STESSO banco OHLC M1): prof +4.792, PF 1,33, DD 3,5%, n 208")
)
$CELLE[0].AntFile = "R103_ABTG_ORB_Ottimizzato_U30USD_770611.txt"
$CELLE[1].AntFile = "R112_00_metro.txt"
$CELLE[2].AntFile = "R103_ABTG_MaxMinNotte_DAX_Short_Ottimizzato_D30EUR_770411.txt"
$CELLE[3].AntFile = "R103_ABTG_SupertrendReversal_Ottimizzato_XAUUSD_970901.txt"

# =====================================================================
#  I LANCI: celle x passate (x gambe per C1) + canarino + sonde.
#  Magic del lancio: MagicBase + P*2, gemello +1 (schema par. 5).
# =====================================================================
function LancioNuovo($cella,$passata,[string]$gamba,[string]$da,[string]$a,[string]$chiaveFin){
  $magicL = 763600
  if($null -ne $cella -and $null -ne $passata){ $magicL = $cella.MagicBase + 2*$passata.P }
  $suff = ""
  if($gamba -ne "UNICA"){ $suff = "_" + $gamba }
  $idL = "canarino"
  if($null -ne $cella -and $null -ne $passata){ $idL = $cella.Id + "_P" + $passata.P + $suff }
  return [pscustomobject]@{
    Id=$idL; Cella=$cella; Passata=$passata; Gamba=$gamba
    Da=$da; A=$a; ChiaveFin=$chiaveFin; Magic=$magicL
    Esito="NON ESEGUITO"; Righe=-1; Min=0.0
    Pf=-1.0; Dd=-1.0; Prof=-999999.0; N=-1
    Gemelli="NON MISURATO"; EtaCsv=""
    Rifiuti=-1; RifiutiNota="NON MISURATI"
    VolMax=-1.0; VolQuota=-1.0; Righe100=-1; PtStato="NON MISURATO"
  }
}
$LANCI = @()
foreach($cellaDef in $CELLE){
  foreach($passataDef in $PASSATE){
    if($cellaDef.Gambe -eq "ISOOS"){
      $LANCI += (LancioNuovo $cellaDef $passataDef "IS"  $IS_Da  $IS_A  "IS")
      $LANCI += (LancioNuovo $cellaDef $passataDef "OOS" $OOS_Da $OOS_A "OOS")
    } else {
      $LANCI += (LancioNuovo $cellaDef $passataDef "UNICA" $cellaDef.Da $cellaDef.A $cellaDef.ChiaveFin)
    }
  }
}
#--- il canarino: input di C0, banco strozzato, magic 763690/763691.
$CanarinoA = LancioNuovo $null $null "UNICA" $DaIndici $FinoTutti "IND"
$CanarinoA.Id = "canarino_A_gemelle"; $CanarinoA.Cella = $CELLE[0]; $CanarinoA.Magic = $CanMagicBase
$CanarinoB = LancioNuovo $null $null "UNICA" $DaIndici $FinoTutti "IND"
$CanarinoB.Id = "canarino_B_singola"; $CanarinoB.Cella = $CELLE[0]; $CanarinoB.Magic = $CanMagicBase

#--- audit dei magic alla costruzione: unici, nel blocco, mai vietati.
$magicAudit = @()
foreach($lancioDef in $LANCI){ $magicAudit += @($lancioDef.Magic, ($lancioDef.Magic+1)) }
$magicAudit += @($CanMagicBase, ($CanMagicBase+1))
$magicAuditUnici = @($magicAudit | Sort-Object -Unique)
#  i lanci IS/OOS della stessa passata CONDIVIDONO la coppia (per
#  costruzione, come le due gambe di walkforward): i duplicati attesi
#  sono ESATTAMENTE quelli. Coppie distinte attese: 12 passate + canarino.
if($magicAuditUnici.Count -ne 26){ throw ("audit magic: " + $magicAuditUnici.Count + " magic distinti invece di 26 (12 coppie di passata + la coppia del canarino).") }
foreach($magicDaVagliare in $magicAuditUnici){
  if(MagicVietato $magicDaVagliare){ throw ("audit magic: " + $magicDaVagliare + " e' VIETATO (sedie vive/sorgenti o blocchi 7633xx-7635xx).") }
  if($magicDaVagliare -lt 763600 -or $magicDaVagliare -gt 763691){ throw ("audit magic: " + $magicDaVagliare + " fuori dal blocco 763600-763665 + 763690/763691 dei criteri par. 5.") }
}

# ---------------------------------------------------------------------
#  Righe vive: nome e valore (identiche a R112/R113).
# ---------------------------------------------------------------------
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
function MappaDi($elencoRighe){
  $mappa = @{}
  foreach($rigaCorr in @($elencoRighe)){
    $nomeChiave = NomeDi $rigaCorr
    if($mappa.ContainsKey($nomeChiave)){ throw ("il file ha DUE righe per '" + $nomeChiave + "': in [TesterInputs] un parametro doppio fa fare a MT5 ZERO passate.") }
    $mappa[$nomeChiave] = (ValoreDi $rigaCorr)
  }
  return $mappa
}

# ---------------------------------------------------------------------
#  LA FABBRICA DEGLI INPUT: la riga InpMagic del file prova (coppia P0)
#  viene RISCRITTA con la coppia della passata; tutto il resto passa
#  INTATTO. E' l'unico punto in cui il driver tocca gli input, ed e'
#  contato: DEVE riscrivere ESATTAMENTE una riga.
# ---------------------------------------------------------------------
function RiscriviMagicSweep($righeInput,[int]$magicBase){
  $fuori = New-Object System.Collections.ArrayList
  $numRiscritte = 0
  foreach($rigaCorr in @($righeInput)){
    if((NomeDi $rigaCorr) -eq "InpMagic"){
      [void]$fuori.Add("InpMagic=" + $magicBase + "||" + $magicBase + "||1||" + ($magicBase+1) + "||Y")
      $numRiscritte++
    } else { [void]$fuori.Add($rigaCorr) }
  }
  if($numRiscritte -ne 1){ throw ("fabbrica input: " + $numRiscritte + " righe InpMagic riscritte invece di 1.") }
  return @($fuori)
}
#  la versione SECCA (canarino B, Optimization=0): niente sweep residui
#  (uno sweep rimasto = ottimizzazione travestita, lezione R103).
function RigheSecche($righeInput,[int]$magicSecco){
  $fuori = New-Object System.Collections.ArrayList
  foreach($rigaCorr in @($righeInput)){
    $nomeChiave = NomeDi $rigaCorr
    if($nomeChiave -eq "InpMagic"){ [void]$fuori.Add("InpMagic=" + $magicSecco) }
    else {
      #  il VALORE di una riga in forma sweep 'v||v||0||v||N' e' il primo
      #  segmento; una riga gia' secca (es. InpNewsFile=...) passa intera.
      $valoreSecco = ValoreDi $rigaCorr
      if($valoreSecco -match '\|\|'){ $valoreSecco = @($valoreSecco -split '\|\|')[0] }
      [void]$fuori.Add($nomeChiave + "=" + $valoreSecco)
    }
  }
  $testoSecco = (@($fuori) -join "`r`n")
  if($testoSecco -match '\|\|'){ throw "fabbrica input secchi: e' rimasto uno sweep '||'. Sarebbe un'ottimizzazione, non una passata singola." }
  return @($fuori)
}

# ---------------------------------------------------------------------
#  LA FABBRICA DEGLI .ini (testo puro; la scrittura e la rilettura su
#  disco stanno fuori, nel corpo). Struttura di R113 (a sua volta
#  copiata campo per campo da walkforward_generico + [Charts] MaxBars).
#  CHECKLIST 79: le date si validano QUI sugli argomenti.
# ---------------------------------------------------------------------
function ControllaData([string]$dataArg,[string]$contesto){
  if($dataArg -notmatch '^\d{4}\.\d{2}\.\d{2}$'){ throw ($contesto + ": data [" + $dataArg + "] non e' yyyy.MM.dd (variabile sporcata?)") }
  $dataParse = [datetime]::MinValue
  if(-not [datetime]::TryParseExact($dataArg,"yyyy.MM.dd",$INV,[Globalization.DateTimeStyles]::None,[ref]$dataParse)){
    throw ($contesto + ": data [" + $dataArg + "] non e' un giorno che esiste")
  }
}
function TestoIni([string]$eaNome,[string]$simbolo,[string]$periodo,[int]$modello,
                  [string]$da,[string]$a,[int]$deposito,[int]$leva,[int]$optimization,
                  [string]$report,$righeInput){
  ControllaData $da ("fabbrica .ini " + $report)
  ControllaData $a  ("fabbrica .ini " + $report)
  $dtDaIni = [datetime]::ParseExact($da,"yyyy.MM.dd",$INV)
  $dtAIni  = [datetime]::ParseExact($a, "yyyy.MM.dd",$INV)
  if($dtAIni -le $dtDaIni){ throw ("fabbrica .ini " + $report + ": ToDate " + $a + " non e' dopo FromDate " + $da) }
  if($deposito -le 0 -or $leva -le 0){ throw ("fabbrica .ini " + $report + ": Deposit " + $deposito + " / Leverage " + $leva + " non validi") }
  $testoInput = (@($righeInput) -join "`r`n")
  $rigaCriterio = ""
  if($optimization -eq 1){ $rigaCriterio = "OptimizationCriterion=6`r`n" }
  return @"
[Charts]
MaxBars=2000000000

[Experts]
AllowLiveTrading=false
AllowDllImport=false

[Tester]
Expert=$eaNome.ex5
Symbol=$simbolo
Period=$periodo
Model=$modello
Spread=$SpreadIni
Optimization=$optimization
${rigaCriterio}FromDate=$da
ToDate=$a
ForwardMode=0
Deposit=$deposito
Currency=EUR
Leverage=$leva
ExecutionMode=0
ReplaceReport=1
ShutdownTerminal=1
Report=$report

[TesterInputs]
$testoInput
"@
}

# ---------------------------------------------------------------------
#  IL GATE SULLO STATO FINALE dell'.ini (checklist 33 e 79): si passa
#  il TESTO RILETTO dal file scritto, e si pretendono le righe esatte.
#  Torna la lista dei guasti (vuota = ok).
# ---------------------------------------------------------------------
function VerificaIniTesto([string]$testoIni,[string]$eaNome,[string]$simbolo,[string]$periodo,
                          [int]$modello,[string]$da,[string]$a,[int]$deposito,[int]$leva,
                          [int]$optimization,[int]$magicBase,[bool]$sweepAtteso){
  $guastiIni = New-Object System.Collections.ArrayList
  foreach($rigaAttesa in @(("Expert=" + $eaNome + ".ex5"),("Symbol=" + $simbolo),("Period=" + $periodo),
                           ("Model=" + $modello),("Spread=" + $SpreadIni),("Optimization=" + $optimization),
                           ("FromDate=" + $da),("ToDate=" + $a),("Deposit=" + $deposito),
                           ("Currency=EUR"),("Leverage=" + $leva),"ShutdownTerminal=1")){
    if($testoIni -notmatch ('(?m)^' + [regex]::Escape($rigaAttesa) + '\r?$')){ [void]$guastiIni.Add("manca la riga '" + $rigaAttesa + "'") }
  }
  $numAllowLive = @([regex]::Matches($testoIni,'(?m)^AllowLiveTrading=false\r?$')).Count
  if($numAllowLive -ne 1){ [void]$guastiIni.Add("AllowLiveTrading=false compare " + $numAllowLive + " volte invece di 1") }
  $assiYIni = @([regex]::Matches($testoIni,'(?m)^(\w+)=[^\r\n]*\|\|\s*[Yy]\s*\r?$') | ForEach-Object { $_.Groups[1].Value })
  if($sweepAtteso){
    if($assiYIni.Count -ne 1 -or $assiYIni[0] -ne "InpMagic"){ [void]$guastiIni.Add("assi Y nell'ini: [" + ($assiYIni -join ", ") + "] invece del solo InpMagic") }
    if($testoIni -notmatch ('(?m)^InpMagic=' + $magicBase + '\|\|' + $magicBase + '\|\|1\|\|' + ($magicBase+1) + '\|\|Y\s*\r?$')){
      [void]$guastiIni.Add("InpMagic nell'ini non e' lo sweep " + $magicBase + "/" + ($magicBase+1) + " a passo 1")
    }
  } else {
    if($assiYIni.Count -ne 0){ [void]$guastiIni.Add("assi Y in un .ini a passata SINGOLA: [" + ($assiYIni -join ", ") + "]") }
    if($magicBase -gt 0 -and $testoIni -notmatch ('(?m)^InpMagic=' + $magicBase + '\s*\r?$')){
      [void]$guastiIni.Add("InpMagic secco non e' " + $magicBase)
    }
  }
  return @($guastiIni)
}

# ---------------------------------------------------------------------
#  LA STELLA DI R114 (adattata e DICHIARATA): non c'e' un metro fra le
#  celle (quattro motori diversi) -- la stella e' FRA LE PASSATE della
#  stessa cella e gamba: i [TesterInputs] dei tre .ini devono essere
#  IDENTICI tranne la riga InpMagic, e il [Tester] identico tranne
#  Deposit / Leverage / Report. Cosi' ogni differenza P1-P0 / P2-P1 e'
#  attribuibile SOLO al banco.
# ---------------------------------------------------------------------
function BloccoDi([string]$testoIni,[string]$nomeBlocco){
  $matchBlocco = [regex]::Match($testoIni,'(?ms)^\[' + $nomeBlocco + '\]\r?\n(.*?)(?=^\[|\z)')
  if(-not $matchBlocco.Success){ return @() }
  return @($matchBlocco.Groups[1].Value -split "\r?\n" | Where-Object { $_ -notmatch '^\s*$' })
}
function VerificaStellaPassate($testiIniCellaGamba){
  #  $testiIniCellaGamba: array di testi .ini della STESSA cella+gamba,
  #  ordinati P0,P1,P2. Torna lista guasti.
  $guastiStella = New-Object System.Collections.ArrayList
  if(@($testiIniCellaGamba).Count -lt 2){ return @($guastiStella) }
  $inputRif  = @(BloccoDi $testiIniCellaGamba[0] "TesterInputs" | Where-Object { $_ -notmatch '^InpMagic=' })
  $testerRif = @(BloccoDi $testiIniCellaGamba[0] "Tester" | Where-Object { $_ -notmatch '^(Deposit|Leverage|Report)=' })
  for($iPass=1; $iPass -lt @($testiIniCellaGamba).Count; $iPass++){
    $inputCorr  = @(BloccoDi $testiIniCellaGamba[$iPass] "TesterInputs" | Where-Object { $_ -notmatch '^InpMagic=' })
    $testerCorr = @(BloccoDi $testiIniCellaGamba[$iPass] "Tester" | Where-Object { $_ -notmatch '^(Deposit|Leverage|Report)=' })
    if((($inputCorr -join "`n")) -cne (($inputRif -join "`n"))){
      [void]$guastiStella.Add("P" + $iPass + ": i [TesterInputs] differiscono da P0 oltre a InpMagic -- ogni differenza P" + $iPass + "-P0 non sarebbe piu' attribuibile al banco")
    }
    if((($testerCorr -join "`n")) -cne (($testerRif -join "`n"))){
      [void]$guastiStella.Add("P" + $iPass + ": il [Tester] differisce da P0 oltre a Deposit/Leverage/Report")
    }
  }
  return @($guastiStella)
}

# ---------------------------------------------------------------------
#  IL RILEVATORE DEI RIFIUTI. I candidati sono la CLASSE della riga
#  ("not enough money" e le sue possibili localizzazioni): quale morda
#  DAVVERO lo decide il canarino, mai questa lista da sola (criteri
#  par. 3-bis punto 2). L'ordine conta: si impara il PRIMO che morde.
# ---------------------------------------------------------------------
$PatternRifiutoCandidati = @("not enough money","no money","insufficient funds","insufficient money",
                             "denaro insufficiente","fondi insufficienti","margine insufficiente","soldi insufficienti")
function ContaOccorrenze($righeTesto,[string]$pattern){
  $conta = 0
  $patternRegex = [regex]::Escape($pattern)
  foreach($rigaCorr in @($righeTesto)){
    if($rigaCorr -imatch $patternRegex){ $conta++ }
  }
  return $conta
}
function ImparaRifiuto($righeTesto){
  foreach($patternCorr in $PatternRifiutoCandidati){
    $contaCorr = ContaOccorrenze $righeTesto $patternCorr
    if($contaCorr -gt 0){
      $esempioCorr = ""
      $patternRegex = [regex]::Escape($patternCorr)
      foreach($rigaCorr in @($righeTesto)){ if($rigaCorr -imatch $patternRegex){ $esempioCorr = $rigaCorr; break } }
      return [pscustomobject]@{ Pattern=$patternCorr; Conta=$contaCorr; Esempio=$esempioCorr }
    }
  }
  return $null
}

# ---------------------------------------------------------------------
#  SENTINELLE E FORMATI (checklist 66): non misurato -> 'n/d', mai -1,
#  mai 0.000. Il profitto usa -999999 (puo' essere negativo).
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
function FmtDelta($valA,$valB){
  # differenza A-B con segno, n/d se uno dei due non e' misurato
  if($null -eq $valA -or $null -eq $valB){ return "n/d" }
  if([double]$valA -le -999998.0 -or [double]$valB -le -999998.0){ return "n/d" }
  return ([double]$valA - [double]$valB).ToString("+0.00;-0.00;0.00",$INV)
}
function NumInv($testoNumero){
  $valoreParse = 0.0
  $testoPulito = ("" + $testoNumero).Replace([string][char]160,"").Replace([string][char]8239,"").Replace([string][char]8201,"").Replace(" ","").Trim()
  if($testoPulito -eq ""){ return $null }
  if([double]::TryParse($testoPulito,[Globalization.NumberStyles]::Float,$INV,[ref]$valoreParse)){ return $valoreParse }
  return $null
}
#  ~POSIZIONI dalla n in USCITE (convenzione R112, e' una STIMA).
function FmtPos($valoreN){
  if($null -eq $valoreN){ return "n/d" }
  if([int]$valoreN -lt 0){ return "n/d" }
  return ("~" + [math]::Floor([int]$valoreN/2).ToString($INV))
}
# =====================================================================
# <<< FINE DEFINIZIONI PURE
# =====================================================================

$Avvio  = Get-Date
$Stamp  = $Avvio.ToString("yyyyMMdd_HHmm", $INV)
$Dsk    = Join-Path $env:USERPROFILE "Desktop"
$Work   = Join-Path $env:USERPROFILE "abtg_r114"
$Prove  = Join-Path $Work "prove"
$Anten  = Join-Path $Work "antenati"
$RifG0B = Join-Path $Work "riferimenti_g0b"
$SrcDir = Join-Path $Work "src_motori"
$JrnDir = Join-Path $Work "journals"
$RawPin = "https://raw.githubusercontent.com/claudiospadaro12/GITHUB/$Pin"

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
$daFirmare = $true
#  >>> IL LUCCHETTO SI COMPONE, NON SI SCRIVE (checklist 82, regola 1).
$LucchettoFirma = '[DA ' + 'FIRMARE]'
$Terminal  = ""; $MetaEditor = ""; $DataFolder = ""; $CommonFiles = ""
$Ordinati  = @()      # checklist 41-bis: la raccolta lo scorre SEMPRE
$Vive      = @{}
$SelettoreAVuoto = $false
$CanarinoKo = $false          # true -> ROUND FERMO, exit 2
$PatternImparato = $null      # il verdetto del canarino (stringa journal)
$SpecEstratte = @{}           # simbolo -> righe GSPEC estratte
$G0BEsiti = @{}               # "IS"/"OOS" -> esito ConfrontaG0B
#  >>> CHECKLIST 41-bis: la RACCOLTA usa anche questi tre -- nascono QUI.
$SimboliSonda = @("U30USD","D30EUR","XAUUSD")
$RifG0BIS  = Join-Path $RifG0B "ABTG_EMA200_U30USD_IS_00_metro.csv"
$RifG0BOOS = Join-Path $RifG0B "ABTG_EMA200_U30USD_OOS_00_metro.csv"

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
function CsvDi($lancio){ return (Join-Path $Risultati ("R114_" + $lancio.Id + ".csv")) }
function IniDi($lancio){ return (Join-Path $Work ("gen_R114_" + $lancio.Id + ".ini")) }

# =====================================================================
#  IL PARSER DEL CSV DI OTTIMIZZAZIONE -- STRETTO (checklist 80).
#  Tutti e 4 gli EA scrivono la STESSA intestazione a 8 colonne
#  (MISURATO nei sorgenti al pin, OnTesterDeinit): se le prime 8 non
#  sono queste, il CSV non e' di questi EA e NON si legge.
# =====================================================================
$ColonneOptAttese = @("Pass","Profit","Expected Payoff","Profit Factor","Recovery Factor","Sharpe Ratio","Equity DD %","Trades")
$script:CsvIntestazioni = @()
function LeggiOpt([string]$percorsoCsv){
  if(-not (Test-Path -LiteralPath $percorsoCsv)){ return $null }
  $righeCsv = @()
  try{ $righeCsv = @(Import-Csv -LiteralPath $percorsoCsv) }catch{ return $null }
  if($righeCsv.Count -eq 0){ return $null }
  $nomiColonne = @($righeCsv[0].PSObject.Properties.Name)
  $script:CsvIntestazioni = $nomiColonne
  if($nomiColonne.Count -lt $ColonneOptAttese.Count){ return $null }
  for($iCol=0; $iCol -lt $ColonneOptAttese.Count; $iCol++){
    if(("" + $nomiColonne[$iCol]).Trim() -cne $ColonneOptAttese[$iCol]){ return $null }
  }
  if($nomiColonne.Count -gt $ColonneOptAttese.Count){
    if(("" + $nomiColonne[$ColonneOptAttese.Count]).Trim() -notlike 'Inp*'){ return $null }
  }
  $elencoLetture = New-Object System.Collections.ArrayList
  foreach($rigaCsv in $righeCsv){
    [void]$elencoLetture.Add([pscustomobject]@{
      Profit = (NumInv $rigaCsv.'Profit')
      Pf     = (NumInv $rigaCsv.'Profit Factor')
      Dd     = (NumInv $rigaCsv.'Equity DD %')
      N      = (NumInv $rigaCsv.'Trades')
    })
  }
  return @($elencoLetture)
}
$TolGemelli = 0.005
function Gemelli($lettureCsv){
  if($null -eq $lettureCsv){ return "NON MISURATO (CSV non letto o intestazione non a 8 colonne attese)" }
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
#  G0-B -- LA RIPRODUZIONE (RIUSATA DA R112, decisione D3 di la'): le 7
#  colonne statistiche delle 2 righe IDENTICHE COME STRINGHE (-cne),
#  parametri esclusi (il magic differisce per costruzione). TRE esiti:
#  OK / MISMATCH / NON ESEGUITO (checklist 68).
# =====================================================================
$ColonneStatG0B = @("Profit","Expected Payoff","Profit Factor","Recovery Factor","Sharpe Ratio","Equity DD %","Trades")
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
        [void]$diffTrovate.Add("riga " + ($iRiga+1) + " '" + $colStat + "': nuovo [" + $valNuovo + "] contro riferimento [" + $valRif + "]")
      }
    }
  }
  if($diffTrovate.Count -gt 0){ return ("MISMATCH: " + ($diffTrovate -join " ; ")) }
  return "OK"
}

# =====================================================================
#  IL JOURNAL DEL TESTER. I log stanno sotto <dati>\Tester\ (logs\ del
#  tester e Agent-*\logs\ degli agenti), sono GIORNALIERI e si
#  appendono; l'encoding e' storicamente ballerino (Unicode o ANSI):
#  si leggono TUTTI E DUE i modi e vince quello con piu' caratteri
#  stampabili (euristica dichiarata, stessa classe del log del
#  compilatore in R112/R113). ORA DEI LOG = ORA LOCALE del PC
#  (checklist 86), e il referto lo dichiara.
# =====================================================================
function LeggiLogRighe([string]$percorsoLog){
  $righeU = @(); $righeD = @()
  try{ $righeU = @([IO.File]::ReadAllLines($percorsoLog,[Text.Encoding]::Unicode)) }catch{}
  try{ $righeD = @([IO.File]::ReadAllLines($percorsoLog,[Text.Encoding]::Default)) }catch{}
  function QuotaStampabile($righeQ){
    $campione = (($righeQ | Select-Object -First 5) -join "")
    if($campione.Length -eq 0){ return 0.0 }
    $buoni = 0
    foreach($ch in $campione.ToCharArray()){ $codice = [int]$ch; if($codice -ge 32 -and $codice -le 126){ $buoni++ } }
    return ($buoni / [double]$campione.Length)
  }
  if((QuotaStampabile $righeU) -ge (QuotaStampabile $righeD)){ return $righeU }
  return $righeD
}
$script:JournalCache = @{}   # percorso -> @{Len=..; Conte=@{pattern->n}; Righe=n}
function ElencoLogTester(){
  if($DataFolder -eq ""){ return @() }
  $radiceTester = Join-Path $DataFolder "Tester"
  if(-not (Test-Path -LiteralPath $radiceTester)){ return @() }
  return @(Get-ChildItem -LiteralPath $radiceTester -Recurse -Filter "*.log" -File -ErrorAction SilentlyContinue)
}
function SnapshotJournal($patternElenco){
  #  torna hashtable percorso -> @{pattern->conteggio} usando la cache
  #  (i log gia' visti e NON cresciuti non si rileggono).
  $fotografia = @{}
  foreach($fileLog in (ElencoLogTester)){
    $chiave = $fileLog.FullName
    $inCache = $script:JournalCache[$chiave]
    if($null -ne $inCache -and [long]$inCache.Len -eq [long]$fileLog.Length){
      $fotografia[$chiave] = $inCache.Conte
      continue
    }
    $righeLog = LeggiLogRighe $chiave
    $conte = @{}
    foreach($patternCorr in @($patternElenco)){ $conte[$patternCorr] = (ContaOccorrenze $righeLog $patternCorr) }
    $script:JournalCache[$chiave] = @{ Len=[long]$fileLog.Length; Conte=$conte }
    $fotografia[$chiave] = $conte
  }
  return $fotografia
}
function DeltaJournal($fotoPrima,$fotoDopo,[string]$pattern){
  $delta = 0
  foreach($chiave in @($fotoDopo.Keys)){
    $dopoN = 0; $primaN = 0
    if($null -ne $fotoDopo[$chiave] -and $fotoDopo[$chiave].ContainsKey($pattern)){ $dopoN = [int]$fotoDopo[$chiave][$pattern] }
    if($null -ne $fotoPrima -and $fotoPrima.ContainsKey($chiave) -and $fotoPrima[$chiave].ContainsKey($pattern)){ $primaN = [int]$fotoPrima[$chiave][$pattern] }
    if($dopoN -gt $primaN){ $delta += ($dopoN - $primaN) }
  }
  return $delta
}
function EstraiRigheNuove($fotoPrima,[string]$pattern,[int]$quanteNuove){
  #  estrae le ULTIME occorrenze (le nuove stanno in coda: i log si
  #  appendono). Serve come EVIDENZA in sosta, il conteggio resta il delta.
  $estratte = New-Object System.Collections.ArrayList
  foreach($fileLog in (ElencoLogTester)){
    $chiave = $fileLog.FullName
    $primaN = 0
    if($null -ne $fotoPrima -and $fotoPrima.ContainsKey($chiave) -and $fotoPrima[$chiave].ContainsKey($pattern)){ $primaN = [int]$fotoPrima[$chiave][$pattern] }
    $righeLog = LeggiLogRighe $chiave
    $patternRegex = [regex]::Escape($pattern)
    $viste = 0
    foreach($rigaCorr in $righeLog){
      if($rigaCorr -imatch $patternRegex){
        $viste++
        if($viste -gt $primaN){ [void]$estratte.Add((Split-Path -Leaf $chiave) + ": " + $rigaCorr) }
      }
    }
  }
  return @($estratte | Select-Object -First ([math]::Max($quanteNuove,200)))
}

# =====================================================================
#  IL PER-TRADE (modello export R112): vol max, quota righe al massimo
#  e RIGHE A VOLUME >= 100 (il clamp, criteri par. 3-bis punto 3).
#  8 campi ';' con volume in colonna 6 (indice 5), net in colonna 8.
#  G0-C-bis: i due gemelli identici tranne la colonna magic (indice 2).
# =====================================================================
function AnalisiPerTrade($lancio,[datetime]$avvioLancio){
  if(-not $lancio.Cella.PerTrade){
    $lancio.PtStato = "n/d PER COSTRUZIONE (l'EA " + $lancio.Cella.Ea + " NON esporta i per-trade: misurato nel sorgente al pin)"
    return
  }
  $magPrimo = [int]$lancio.Magic; $magSecondo = $magPrimo + 1
  $fileGemelli = @{}
  foreach($magCorrente in @($magPrimo,$magSecondo)){
    $percorsoPt = Join-Path $CommonFiles ("abtg_trades_" + $lancio.Cella.Ea + "_" + $lancio.Cella.Sym + "_" + $magCorrente + ".csv")
    if(-not (Test-Path -LiteralPath $percorsoPt)){
      $lancio.PtStato = "n/d (il file per-trade del magic " + $magCorrente + " NON esiste in Common\Files)"
      [void]$Problemi.Add($lancio.Id + ": " + $lancio.PtStato + ". Vol max e righe a 100 NON misurati per questo lancio.")
      return
    }
    $etaFile = (Get-Item -LiteralPath $percorsoPt).LastWriteTime
    if($etaFile -lt $avvioLancio){
      $lancio.PtStato = "n/d (per-trade del magic " + $magCorrente + " VECCHIO: LastWriteTime " + $etaFile.ToString("yyyy-MM-dd HH:mm:ss",$INV) + " ora del PC, lancio avviato " + $avvioLancio.ToString("yyyy-MM-dd HH:mm:ss",$INV) + ")"
      [void]$Problemi.Add($lancio.Id + ": " + $lancio.PtStato)
      return
    }
    $fileGemelli[$magCorrente] = $percorsoPt
    Copy-Item -LiteralPath $percorsoPt -Destination (Join-Path $Work ("pertrade_" + $lancio.Id + "_" + $magCorrente + ".csv")) -Force
  }
  $righePtA = @(Get-Content -LiteralPath $fileGemelli[$magPrimo])
  $righePtB = @(Get-Content -LiteralPath $fileGemelli[$magSecondo])
  if($righePtA.Count -ne $righePtB.Count){
    $lancio.PtStato = "n/d (G0-C-bis: i per-trade gemelli hanno " + $righePtA.Count + " contro " + $righePtB.Count + " righe)"
    [void]$Problemi.Add($lancio.Id + ": G0-C-bis FALLITO -- " + $lancio.PtStato)
    return
  }
  $righeDiverse = 0
  for($iRigaPt=0; $iRigaPt -lt $righePtA.Count; $iRigaPt++){
    $campiA = @($righePtA[$iRigaPt] -split ';')
    $campiB = @($righePtB[$iRigaPt] -split ';')
    if($campiA.Count -gt 2){ $campiA[2] = "" }
    if($campiB.Count -gt 2){ $campiB[2] = "" }
    if(($campiA -join ';') -cne ($campiB -join ';')){ $righeDiverse++ }
  }
  if($righeDiverse -gt 0){
    $lancio.PtStato = "n/d (G0-C-bis: " + $righeDiverse + " righe su " + $righePtA.Count + " differiscono oltre la colonna magic)"
    [void]$Problemi.Add($lancio.Id + ": G0-C-bis FALLITO -- " + $lancio.PtStato)
    return
  }
  if($righePtA.Count -lt 1 -or $righePtA[0] -notlike 'close_time;*'){
    $lancio.PtStato = "n/d (il per-trade non inizia con 'close_time;...': formato non riconosciuto, non indovino)"
    [void]$Problemi.Add($lancio.Id + ": " + $lancio.PtStato)
    return
  }
  $volMassimo = 0.0; $righeDati = 0; $righeCento = 0
  for($iRigaPt=1; $iRigaPt -lt $righePtA.Count; $iRigaPt++){
    $rigaGrezza = $righePtA[$iRigaPt]
    if(("" + $rigaGrezza).Trim() -eq ""){ continue }
    $campiRiga = @($rigaGrezza -split ';')
    if($campiRiga.Count -ne 8){
      $lancio.PtStato = "n/d (riga " + ($iRigaPt+1) + " ha " + $campiRiga.Count + " campi invece di 8)"
      [void]$Problemi.Add($lancio.Id + ": " + $lancio.PtStato)
      return
    }
    $volumeRiga = NumInv $campiRiga[5]
    if($null -eq $volumeRiga){
      $lancio.PtStato = "n/d (riga " + ($iRigaPt+1) + ": volume illeggibile in cultura invariante)"
      [void]$Problemi.Add($lancio.Id + ": " + $lancio.PtStato)
      return
    }
    $righeDati++
    if([double]$volumeRiga -gt $volMassimo){ $volMassimo = [double]$volumeRiga }
    if([double]$volumeRiga -ge 99.995){ $righeCento++ }
  }
  if($righeDati -eq 0){
    $lancio.PtStato = "n/d (il per-trade ha SOLO l'intestazione: zero chiusure -- con n atteso > 0 e' un guasto)"
    [void]$Problemi.Add($lancio.Id + ": " + $lancio.PtStato)
    return
  }
  $righeAlMassimo = 0
  for($iRigaPt=1; $iRigaPt -lt $righePtA.Count; $iRigaPt++){
    if(("" + $righePtA[$iRigaPt]).Trim() -eq ""){ continue }
    $volumeRiga = NumInv (@($righePtA[$iRigaPt] -split ';')[5])
    if($null -ne $volumeRiga -and [math]::Abs([double]$volumeRiga - $volMassimo) -lt 0.005){ $righeAlMassimo++ }
  }
  $lancio.VolMax   = $volMassimo
  $lancio.VolQuota = [math]::Round(100.0 * $righeAlMassimo / $righeDati, 2)
  $lancio.Righe100 = $righeCento
  $lancio.PtStato  = "MISURATO (" + $righeDati + " deal di uscita; la soglia 100 e' SYMBOL_VOLUME_MAX atteso, la sonda G-SPEC lo stampa)"
}

#--- pattern unico per TUTTI gli snapshot journal (cache uniforme):
#    i candidati rifiuto + il prefisso della sonda.
$PatternTutti = @($PatternRifiutoCandidati) + @("GSPEC;")

# =====================================================================
#  LA LISTA DEI LAVORI, dopo il filtro -SoloCella (checklist 68).
#  P0 e' il denominatore di P1/P2 DENTRO la cella: -SoloCella prende
#  la cella INTERA (3 passate, tutte le gambe). Canarino e sonde girano
#  comunque nella corsa vera: il rilevatore si prova a OGNI corsa.
# =====================================================================
$CelleScelte = @($CELLE)
if($SoloCella -ne ""){
  $CelleScelte = @($CELLE | Where-Object { $_.Prova -eq $SoloCella })
  if($CelleScelte.Count -eq 0){
    Write-Host ("!!! -SoloCella " + $SoloCella + " non e' nella lista. Nomi validi:") -ForegroundColor Red
    foreach($cellaElenco in $CELLE){ Write-Host ("      " + $cellaElenco.Prova) -ForegroundColor Yellow }
    exit 1
  }
}
$Ordinati = @($LANCI | Where-Object { $lancioW = $_; @($CelleScelte | Where-Object { $_.C -eq $lancioW.Cella.C }).Count -gt 0 })
if($Ordinati.Count -eq 0){ $SelettoreAVuoto = $true }

Write-Host ""
Write-Host "#####################################################################" -ForegroundColor Cyan
Write-Host "#  R114 - LA PROVA DELLA LEVA (fase 2 della prova della taglia)     #" -ForegroundColor Cyan
Write-Host "#  4 celle x 3 passate (P0 100k/100, P1 200k/100, P2 200k/15)       #" -ForegroundColor Cyan
Write-Host "#  + canarino G-CAN (2.000/15) + sonda G-SPEC sui 3 simboli         #" -ForegroundColor Cyan
Write-Host "#####################################################################" -ForegroundColor Cyan
Dico ("pin      : " + $Pin)
Dico ("cartella : " + $Work)

if($SelettoreAVuoto){
  Write-Host ""
  Write-Host "ESITO: SELETTORE A VUOTO -- nessun lancio selezionato, nessun artefatto prodotto." -ForegroundColor Red
  exit 1
}

Titolo "NUMERI ATTESI (dichiarati PRIMA della corsa)"
Write-Host ("    lanci di misura ..............  " + $Ordinati.Count + "   (su 15 del round pieno: C0/C2/C3 finestra unica, C1 due gambe IS/OOS)") -ForegroundColor White
Write-Host ("    CSV attesi ...................  " + $Ordinati.Count + "   + 1 del canarino (fuori tabella)") -ForegroundColor White
Write-Host ("    righe per CSV ................  " + $CelleAttese + "   (le due gemelle di controllo, magic +1)") -ForegroundColor White
Write-Host ("    passate ......................  " + (2*$Ordinati.Count) + "   + 2 del canarino") -ForegroundColor White
Write-Host ("    sonde G-SPEC .................  3   (U30USD / D30EUR / XAUUSD, banco 200k / leva 15)") -ForegroundColor White
foreach($cellaCorr in $CelleScelte){
  Write-Host ("    C" + $cellaCorr.C + " " + $cellaCorr.Sigla.PadRight(7) + $cellaCorr.Ea.PadRight(40) + $cellaCorr.Sym + " " + $cellaCorr.Tf.PadRight(4) + " modello " + $cellaCorr.Modello + "  " + $cellaCorr.Da + " -> " + $cellaCorr.A + "  [" + $cellaCorr.Gambe + "]") -ForegroundColor White
}
Write-Host ""
Write-Host  "    >>> LE ATTESE PRE-DICHIARATE (criteri par. 3): P1 = n identico a P0;" -ForegroundColor Yellow
Write-Host  "    P2 = IDENTICA a P1 AL CENTESIMO se il margine non morde. QUALUNQUE" -ForegroundColor Yellow
Write-Host  "    differenza P2-P1 e' margine che ha morso e va spiegata riga per riga." -ForegroundColor Yellow
Write-Host  "    Il driver stampa i METRI: il VERDETTO verde/giallo/rosso e' A MANO." -ForegroundColor Yellow
Write-Host ""
Write-Host  "    >>> IL RILEVATORE DEI RIFIUTI viene PROVATO dal canarino PRIMA delle" -ForegroundColor Yellow
Write-Host  "    celle (checklist 84-bis): se non morde, ROUND FERMO (exit 2)." -ForegroundColor Yellow
Write-Host ""
Write-Host  "    >>> C3 ORO: l'EA non esporta per-trade (misurato nel sorgente): vol max" -ForegroundColor Yellow
Write-Host  "    e righe a 100 sono n/d PER COSTRUZIONE; rilevatore = journal + delta n." -ForegroundColor Yellow
Write-Host ""
Write-Host  "    >>> G5: NESSUN DEPLOY. Il round produce la LISTA DELLE SEDIE AMMISSIBILI" -ForegroundColor Yellow
Write-Host  "    STAMPATA VUOTA: si compila a mano nella delibera, non qui." -ForegroundColor Yellow

if($Pin -eq ""){
  Write-Host ""
  Write-Host "!!! MANCA -Pin. Questa riga gira SOLO su un commit congelato." -ForegroundColor Red
  Write-Host "    Rilancia col blocco intero, che passa -Pin <hash>." -ForegroundColor Yellow
  exit 1
}

try{

# =====================================================================
#  0. MT5 E METAEDITOR CHIUSI. Prima di qualunque altra cosa.
# =====================================================================
$processiVivi = @(Get-Process -Name "terminal64","metaeditor64" -ErrorAction SilentlyContinue)
if($processiVivi.Count -gt 0){
  Write-Host ""
  Write-Host ("!!! APERTO: " + (($processiVivi | ForEach-Object { $_.ProcessName } | Sort-Object -Unique) -join ", ")) -ForegroundColor Red
  Write-Host "    Non parto: col terminale aperto il tester non gira (zero CSV), e con" -ForegroundColor Red
  Write-Host "    MetaEditor aperto la compilazione torna subito senza compilare." -ForegroundColor Red
  Write-Host "    Chiudi MetaTrader E MetaEditor (tutte le istanze) e rilancia." -ForegroundColor Yellow
  #  DICHIARATO: questo exit sta DENTRO il try e SALTA la raccolta. Siamo a
  #  due secondi dal lancio, non e' stato prodotto NIENTE.
  exit 1
}

New-Item -ItemType Directory -Force -Path $Work,$Prove,$Anten,$RifG0B,$SrcDir,$JrnDir,$Risultati,$Sosta | Out-Null

# =====================================================================
#  0-BIS. LA FIRMA DEI CRITERI. Si LEGGE nell'artefatto al pin, non si
#  ricorda (TRE rami, checklist 82). I criteri risultano GIA' firmati
#  ("FIRMO R114", 27/08 mattina) ma fa fede SOLO il file al pin.
# =====================================================================
Titolo "0-BIS. LA FIRMA DEI CRITERI"
$critFile = Join-Path $Work "R114_CRITERI.md"
$daFirmare = $true
try{
  Scarica ("$RawPin/backtest_pipeline/risultati_archivio/R114_CRITERI.md") $critFile 'R114'
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
  Write-Host "#  NON PARTO: I CRITERI DI R114 NON RISULTANO FIRMATI AL PIN.       #" -ForegroundColor Red
  Write-Host "#####################################################################" -ForegroundColor Red
  Write-Host "  Sono DIECI decisioni (par. 10, firmate il 27/08 mattina): se questo" -ForegroundColor Yellow
  Write-Host "  gate scatta, il file al pin e' TORNATO col lucchetto -- si legge il" -ForegroundColor Yellow
  Write-Host "  documento, NON si aggira lo switch. Il giro a vuoto (-SoloControllo)" -ForegroundColor Yellow
  Write-Host "  parte comunque." -ForegroundColor Yellow
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
#  1. SCARICO AL PIN + I GATE SENZA MT5. I gate girano su TUTTI i 4
#     file anche con -SoloCella: la corruzione non aspetta.
# =====================================================================
Titolo "1. SCARICO AL PIN"
foreach($cellaCorr in $CELLE){
  Scarica ("$RawPin/backtest_pipeline/prove/" + $cellaCorr.Prova) (Join-Path $Prove $cellaCorr.Prova) '@SIMBOLO'
  Scarica ("$RawPin/backtest_pipeline/prove/" + $cellaCorr.AntFile) (Join-Path $Anten $cellaCorr.AntFile) '@SIMBOLO'
}
#--- i 2 CSV di riferimento G0-B (metro EMADOW R110, gambe IS e OOS;
#    i percorsi nascono PRIMA del try, checklist 41-bis)
Scarica ("$RawPin/backtest_pipeline/prove/R110_CSV_EMADOW/ABTG_EMA200_U30USD_IS_00_metro.csv")  $RifG0BIS  'Pass'
Scarica ("$RawPin/backtest_pipeline/prove/R110_CSV_EMADOW/ABTG_EMA200_U30USD_OOS_00_metro.csv") $RifG0BOOS 'Pass'
foreach($cellaCorr in $CELLE){
  $righeViveProva = RigheVive (Join-Path $Prove $cellaCorr.Prova)
  if($righeViveProva.Count -ne $cellaCorr.Vive){
    throw ($cellaCorr.Prova + " ha " + $righeViveProva.Count + " righe vive invece di " + $cellaCorr.Vive + ": artefatto cambiato, mi fermo.")
  }
  $Vive[$cellaCorr.Prova] = $righeViveProva
  $righeViveAnt = RigheVive (Join-Path $Anten $cellaCorr.AntFile)
  if($righeViveAnt.Count -ne $cellaCorr.Vive){
    throw ("l'antenato " + $cellaCorr.AntFile + " ha " + $righeViveAnt.Count + " righe vive invece di " + $cellaCorr.Vive + ": artefatto cambiato, mi fermo.")
  }
}
Dico "4 file prova R114 + 4 antenati + 2 CSV riferimento G0-B scaricati al pin, righe vive verificate (56/46/55/45)" "Green"

# --- 1a. G0-A, L'ANTENATO (checklist 72): copia riga per riga, delta
#     ammesso UNO SOLO (InpMagic), preteso PER NOME. E il delta deve
#     ESSERCI: un InpMagic uguale all'antenato girerebbe coi magic di
#     un altro round.
foreach($cellaCorr in $CELLE){
  $mappaAntenato = MappaDi (RigheVive (Join-Path $Anten $cellaCorr.AntFile))
  $mappaCella    = MappaDi $Vive[$cellaCorr.Prova]
  $guastiAntenato = New-Object System.Collections.ArrayList
  foreach($chiaveAnt in @($mappaAntenato.Keys)){
    if(-not $mappaCella.ContainsKey($chiaveAnt)){ [void]$guastiAntenato.Add("manca la riga '" + $chiaveAnt + "' che l'antenato ha") ; continue }
    if($mappaAntenato[$chiaveAnt] -ne $mappaCella[$chiaveAnt] -and $chiaveAnt -ne "InpMagic"){
      [void]$guastiAntenato.Add("'" + $chiaveAnt + "' vale [" + $mappaCella[$chiaveAnt] + "] ma nell'antenato vale [" + $mappaAntenato[$chiaveAnt] + "]")
    }
  }
  foreach($chiaveCella in @($mappaCella.Keys)){
    if(-not $mappaAntenato.ContainsKey($chiaveCella)){
      [void]$guastiAntenato.Add("ha la riga '" + $chiaveCella + "' che l'antenato NON ha (in R114 non sono ammesse righe nuove)")
    }
  }
  if($mappaAntenato.ContainsKey("InpMagic") -and $mappaCella.ContainsKey("InpMagic") -and $mappaAntenato["InpMagic"] -eq $mappaCella["InpMagic"]){
    [void]$guastiAntenato.Add("'InpMagic' e' UGUALE all'antenato ([" + $mappaCella["InpMagic"] + "]) ma questa cella deve muoverlo (blocco 7636xx)")
  }
  if($guastiAntenato.Count -gt 0){
    throw ("GATE DELL'ANTENATO FALLITO su " + $cellaCorr.Prova + " contro prove\" + $cellaCorr.AntFile + ": " + ($guastiAntenato -join " ; ") +
           ". La frase 'il corpo e' copiato riga per riga dall'antenato' e' un GATE, non un commento: se non torna, P0 non aggancerebbe niente e P2 misurerebbe un motore che non e' quello sui soldi.")
  }
  $cellaCorr.Antenato = "OK contro " + $cellaCorr.AntFile + " (delta: il solo InpMagic)"
}
Dico "G0-A: ogni file prova e' la copia riga per riga del suo antenato, delta il solo InpMagic (per nome, checklist 72)" "Green"

# --- 1b. I VALORI NELL'ARTEFATTO CHE GIRA: geometria d'identita'
#     RIDOTTA E DICHIARATA (lati, rischio, commento, tag) + asse unico
#     + magic. Il grosso dell'identita' lo porta G0-A contro l'antenato
#     al pin; questo gate para il caso 'antenato corrotto INSIEME al
#     file' sui campi che decidono la lettura del round.
$magicVisti = @()
foreach($cellaCorr in $CELLE){
  $testoProva = Get-Content -LiteralPath (Join-Path $Prove $cellaCorr.Prova) -Raw
  $matchSimbolo = [regex]::Match($testoProva,'(?m)^@SIMBOLO\s+(\S+)')
  if(-not $matchSimbolo.Success -or $matchSimbolo.Groups[1].Value -ne $cellaCorr.Sym){ throw ($cellaCorr.Prova + ": @SIMBOLO non e' " + $cellaCorr.Sym) }
  $matchPeriodo = [regex]::Match($testoProva,'(?m)^@PERIODO\s+(\S+)')
  if(-not $matchPeriodo.Success -or $matchPeriodo.Groups[1].Value -ne $cellaCorr.Tf){ throw ($cellaCorr.Prova + ": @PERIODO non e' " + $cellaCorr.Tf + " (il TF del GRAFICO nel tester, che NON si deriva da InpTF: trappola di R102).") }
  $matchDaQuando = [regex]::Match($testoProva,'(?m)^@DAQUANDO\s+([0-9]{4}\.[0-9]{2}\.[0-9]{2})')
  if(-not $matchDaQuando.Success -or $matchDaQuando.Groups[1].Value -ne $cellaCorr.Da){ throw ($cellaCorr.Prova + ": @DAQUANDO e' [" + $matchDaQuando.Groups[1].Value + "] invece di " + $cellaCorr.Da + " (la finestra dell'ANTENATO, criteri par. 2)") }
  foreach($vincolo in @(@("InpRiskPercent",$cellaCorr.Risk),@("InpAllowLong",$cellaCorr.LatoL),@("InpAllowShort",$cellaCorr.LatoS))){
    $regexVincolo = '(?m)^' + $vincolo[0] + '=' + [regex]::Escape($vincolo[1]) + '\|\|'
    if($testoProva -notmatch $regexVincolo){
      throw ($cellaCorr.Prova + ": non trovo '" + $vincolo[0] + "=" + $vincolo[1] + "'. Questa NON e' la cella dei criteri par. 2 (rischio e lati sono l'identita' della sedia).")
    }
  }
  $regexCommento = '(?m)^InpComment=' + [regex]::Escape($cellaCorr.Commento) + '\s*\r?$'
  if($testoProva -notmatch $regexCommento){ throw ($cellaCorr.Prova + ": la riga 'InpComment=" + $cellaCorr.Commento + "' non c'e' o e' cambiata.") }
  $assiY = @([regex]::Matches($testoProva,'(?m)^(\w+)=[^\r\n]*\|\|\s*[Yy]\s*\r?$') | ForEach-Object { $_.Groups[1].Value })
  if($assiY.Count -ne 1 -or $assiY[0] -ne "InpMagic"){
    throw ($cellaCorr.Prova + ": gli assi spazzolati sono [" + ($assiY -join ", ") + "] invece del solo InpMagic. R114 NON ottimizza niente: fra le passate cambia solo il BANCO (Deposit/Leverage), mai un input.")
  }
  $matchMagic = [regex]::Match($testoProva,'(?m)^InpMagic=(\d+)\|\|(\d+)\|\|1\|\|(\d+)\|\|Y')
  if(-not $matchMagic.Success){ throw ($cellaCorr.Prova + ": InpMagic non e' nella forma sweep 'v||v||1||v+1||Y' (gemello +1, criteri par. 5).") }
  $magicBaseLetto = [int]$matchMagic.Groups[1].Value; $magicGemLetto = [int]$matchMagic.Groups[3].Value
  if($magicBaseLetto -ne [int]$cellaCorr.MagicBase){ throw ($cellaCorr.Prova + ": InpMagic e' " + $magicBaseLetto + " ma questa cella deve girare su " + $cellaCorr.MagicBase + " (schema 763600 + C*20 + P*2 + G; nel file sta la coppia di P0)") }
  if($magicGemLetto -ne ($magicBaseLetto+1)){ throw ($cellaCorr.Prova + ": il gemello e' " + $magicGemLetto + " invece di " + ($magicBaseLetto+1)) }
  foreach($magicDaVagliare in @($magicBaseLetto,$magicGemLetto)){
    if($magicVisti -contains $magicDaVagliare){ throw ($cellaCorr.Prova + ": magic " + $magicDaVagliare + " gia' usato da un altro file prova.") }
    if(MagicVietato $magicDaVagliare){ throw ($cellaCorr.Prova + ": il magic " + $magicDaVagliare + " e' VIETATO (sedie vive/sorgenti o blocchi bruciati 7633xx-7635xx). Fermo tutto.") }
    $magicVisti += $magicDaVagliare
  }
}
Dico "geometria d'identita' (ridotta e dichiarata), TF del grafico, finestre @DAQUANDO, asse unico e magic vergini verificati NEI FILE" "Green"

# --- 1c. I SORGENTI E I LORO GATE (checklist 80): versione, magic del
#     sorgente, intestazione OPTFRAME a 8 colonne, export per-trade
#     dove l'EA lo dichiara (C3 NO: dichiarato, non sperato).
foreach($cellaCorr in $CELLE){
  $srcMq5 = Join-Path $SrcDir ($cellaCorr.Ea + ".mq5")
  Scarica ("$RawPin/mql5/Experts/" + $cellaCorr.Ea + ".mq5") $srcMq5 'ABTG_PausaGuardian'
  $testoSorgente = Get-Content -LiteralPath $srcMq5 -Raw
  $matchVersione = [regex]::Match($testoSorgente,'#property\s+version\s+"([^"]+)"')
  if(-not $matchVersione.Success){ throw ($cellaCorr.Ea + ".mq5 scaricato senza #property version: non e' il sorgente che credo.") }
  if($matchVersione.Groups[1].Value -ne $cellaCorr.Ver){
    throw ($cellaCorr.Ea + ".mq5 dichiara version '" + $matchVersione.Groups[1].Value + "' invece di '" + $cellaCorr.Ver + "'. O la cache di raw.githubusercontent serve una copia vecchia, o il pin e' sbagliato: mi fermo.")
  }
  if($testoSorgente -notmatch ('(?m)^input\s+long\s+InpMagic\s*=\s*' + $cellaCorr.MagicSorgente + '\s*;')){
    throw ($cellaCorr.Ea + ".mq5 non dichiara 'input long InpMagic = " + $cellaCorr.MagicSorgente + ";': non e' il motore di questa sedia.")
  }
  if($testoSorgente -notmatch [regex]::Escape('"Pass,Profit,Expected Payoff,Profit Factor,Recovery Factor,Sharpe Ratio,Equity DD %,Trades"')){
    throw ($cellaCorr.Ea + ".mq5 non scrive l'intestazione OPTFRAME a 8 colonne attesa (checklist 80). Mi fermo PRIMA di produrre CSV illeggibili.")
  }
  $haPerTrade = ($testoSorgente -match 'abtg_trades_')
  if($cellaCorr.PerTrade -and -not $haPerTrade){ throw ($cellaCorr.Ea + ".mq5 NON ha l'export per-trade che questa cella dichiara: la tabella lo pretendeva (criteri par. 3-bis).") }
  if(-not $cellaCorr.PerTrade -and $haPerTrade){ [void]$Rilievi.Add($cellaCorr.Ea + ".mq5 HA l'export per-trade ma la cella era dichiarata senza: il vol max si misurera' comunque, e la dichiarazione va corretta nel referto del round.") }
  Dico ($cellaCorr.Ea + ".mq5 al pin, version " + $cellaCorr.Ver + ", InpMagic sorgente " + $cellaCorr.MagicSorgente + ", OPTFRAME 8 colonne" + $(if($cellaCorr.PerTrade){ ", export per-trade PRESENTE" } else { ", export per-trade ASSENTE (dichiarato)" })) "Green"
}
#--- la sonda G-SPEC (nuova di R114) e l'include di casa
$srcSonda = Join-Path $SrcDir "ABTG_SondaMargine.mq5"
Scarica ("$RawPin/mql5/Experts/ABTG_SondaMargine.mq5") $srcSonda 'GSPEC'
Dico "ABTG_SondaMargine.mq5 al pin (la sonda G-SPEC: stampa e basta, non piazza ordini)" "Green"

# =====================================================================
#  2. TERMINALE E CARTELLA DATI, PER NOME (checklist 37).
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
$CommonFiles = Join-Path $env:APPDATA "MetaQuotes\Terminal\Common\Files"
New-Item -ItemType Directory -Force -Path $MqlExperts,$MqlInclude,$MqlFiles,$CommonFiles | Out-Null
Dico ("terminale : " + $Terminal)
Dico ("dati      : " + $DataFolder + "   (DEVE restare lo stesso in tutti i passi)")
Dico ("comune    : " + $CommonFiles + "   (i per-trade abtg_trades_* stanno qui)")

# --- 2a. LA SOSTA SI SVUOTA A OGNI GIRO (checklist 56), contando (69).
$numSostaPrima = @(Get-ChildItem -LiteralPath $Sosta -File -ErrorAction SilentlyContinue).Count
if($numSostaPrima -gt 0){
  Get-ChildItem -LiteralPath $Sosta -File -ErrorAction SilentlyContinue | Remove-Item -Force -ErrorAction SilentlyContinue
  $numSostaDopo = @(Get-ChildItem -LiteralPath $Sosta -File -ErrorAction SilentlyContinue).Count
  if($numSostaDopo -gt 0){
    [void]$Problemi.Add("sosta: " + $numSostaDopo + " file su " + $numSostaPrima + " di un giro PRECEDENTE non cancellati: controllare le date dentro lo zip.")
  }
  Dico ("sosta svuotata: " + $numSostaPrima + " file di un giro precedente rimossi") "Green"
}

# --- 2b. LA MEMORIA DEL TESTER per i 4 EA + sonda (trappola n.1 di
#     prova_regime): Profiles\Tester\<EA>.set ricorda i flag della
#     ultima griglia. Buttarla costa zero.
foreach($nomeEaCorr in (@($CELLE | ForEach-Object { $_.Ea }) + @("ABTG_SondaMargine"))){
  $ricordoTester = Join-Path $DataFolder ("MQL5\Profiles\Tester\" + $nomeEaCorr + ".set")
  if(Test-Path -LiteralPath $ricordoTester){
    Remove-Item -LiteralPath $ricordoTester -Force -ErrorAction SilentlyContinue
    Dico ("buttata la memoria del tester per " + $nomeEaCorr) "DarkYellow"
  }
}

# --- 2c. L'INCLUDE CHE NESSUN DRIVER INSTALLA (checklist 33-bis).
$includeGuardian = Join-Path $MqlInclude "ABTG_PausaGuardian.mqh"
Scarica ("$RawPin/mql5/Include/ABTG_PausaGuardian.mqh") $includeGuardian 'ABTG_GuardiaIngresso'
$includeInfo = Get-Item -LiteralPath $includeGuardian
if($includeInfo.PSIsContainer){ throw "ABTG_PausaGuardian.mqh: in Include c'e' una CARTELLA con quel nome (checklist 27-ter)." }
if($includeInfo.Length -lt 4000){ throw ("ABTG_PausaGuardian.mqh e' lungo " + $includeInfo.Length + " byte: troppo poco, scarico monco.") }
Dico ("include installato: ABTG_PausaGuardian.mqh (" + $includeInfo.Length + " byte)") "Green"

# =====================================================================
#  3. FASE COMPILA: i 4 EA delle celle + la sonda. Si fa ANCHE in
#     -SoloControllo (checklist 39). Invocazione DIRETTA di
#     metaeditor64.exe, verdetto sul LastWriteTime del .ex5, backup
#     datato mai sovrascritto, ripristino se fallisce (qui si
#     ricompilano .ex5 di SEDIE VIVE sul 100k).
# =====================================================================
Titolo "3. FASE COMPILA (4 EA + sonda)"
foreach($nomeEaCorr in (@($CELLE | ForEach-Object { $_.Ea } | Sort-Object -Unique) + @("ABTG_SondaMargine"))){
  $srcMq5 = Join-Path $SrcDir ($nomeEaCorr + ".mq5")
  $mq5Destinazione = Join-Path $MqlExperts ($nomeEaCorr + ".mq5")
  $ex5Destinazione = Join-Path $MqlExperts ($nomeEaCorr + ".ex5")
  $logCompilatore  = Join-Path $MqlExperts ($nomeEaCorr + ".log")
  $backupMq5 = $mq5Destinazione + ".prima_r114_" + $Stamp
  $backupEx5 = $ex5Destinazione + ".prima_r114_" + $Stamp
  if((Test-Path -LiteralPath $mq5Destinazione) -and -not (Test-Path -LiteralPath $backupMq5)){ Copy-Item -LiteralPath $mq5Destinazione -Destination $backupMq5 -Force }
  if((Test-Path -LiteralPath $ex5Destinazione) -and -not (Test-Path -LiteralPath $backupEx5)){ Copy-Item -LiteralPath $ex5Destinazione -Destination $backupEx5 -Force }
  Copy-Item -LiteralPath $srcMq5 -Destination $mq5Destinazione -Force
  $lunghezzaSorgente = (Get-Item -LiteralPath $srcMq5).Length
  $copiaVerifica = Get-Item -LiteralPath $mq5Destinazione -ErrorAction SilentlyContinue
  if(-not $copiaVerifica -or $copiaVerifica.PSIsContainer -or $copiaVerifica.Length -ne $lunghezzaSorgente){ throw ("copia di " + $nomeEaCorr + ".mq5 in MQL5\Experts NON verificata.") }
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
    Copy-Item -LiteralPath $logCompilatore -Destination (Join-Path $Sosta ("compile_" + $nomeEaCorr + ".log")) -Force -ErrorAction SilentlyContinue
  }
  if(-not $compilazioneOk){
    if($testoLogCompilatore -ne ""){
      Write-Host "--- log del compilatore (ultime righe) ---" -ForegroundColor DarkYellow
      foreach($rigaLog in @($testoLogCompilatore -split "\r?\n" | Select-Object -Last 20)){ Write-Host ("   " + $rigaLog) -ForegroundColor DarkYellow }
    }
    if(Test-Path -LiteralPath $backupMq5){ Copy-Item -LiteralPath $backupMq5 -Destination $mq5Destinazione -Force }
    throw ("COMPILAZIONE FALLITA per " + $nomeEaCorr + " (rc=" + $rcMetaEditor + ", .ex5 NON riscritto). Il .mq5 e' stato rimesso com'era, il log e' nello zip. Sospetto n.1: include mancante o MetaEditor gia' aperto.")
  }
  $matchWarning = [regex]::Match($testoLogCompilatore,'(?i)(\d+)\s+warning')
  if($matchWarning.Success -and [int]$matchWarning.Groups[1].Value -gt 0){
    [void]$Rilievi.Add("compilazione " + $nomeEaCorr + ": " + $matchWarning.Groups[1].Value + " warning (0 errori). Da leggere nel log dello zip.")
  }
  Dico ("COMPILATO " + $nomeEaCorr + " (.ex5 riscritto adesso, rc=" + $rcMetaEditor + ")") "Green"
}

# =====================================================================
#  3-BIS. LA FABBRICA DEGLI .ini -- TUTTI, SUBITO, VERIFICATI (33/79) +
#  LA STELLA FRA LE PASSATE. Il giro a vuoto verifica GLI STESSI .ini
#  della corsa vera e li stampa con Deposit/Leverage/Currency/Model
#  (checklist 89).
# =====================================================================
Titolo "3-BIS. LA FABBRICA DEGLI .ini (misura + canarino + sonde)"
$IniTesti = @{}
foreach($lancioCorr in $LANCI){
  $righeInputCella = @($Vive[$lancioCorr.Cella.Prova] | Where-Object { $_ -notmatch '^@' })
  $inputAttesi = $lancioCorr.Cella.Vive - 3
  if($righeInputCella.Count -ne $inputAttesi){ throw ($lancioCorr.Cella.Prova + ": " + $righeInputCella.Count + " righe di input invece di " + $inputAttesi + ".") }
  $righeInputLancio = RiscriviMagicSweep $righeInputCella $lancioCorr.Magic
  $testoIniLancio = TestoIni $lancioCorr.Cella.Ea $lancioCorr.Cella.Sym $lancioCorr.Cella.Tf $lancioCorr.Cella.Modello `
                             $lancioCorr.Da $lancioCorr.A $lancioCorr.Passata.Deposito $lancioCorr.Passata.Leva 1 `
                             ("OptReport_R114_" + $lancioCorr.Id) $righeInputLancio
  $percorsoIni = IniDi $lancioCorr
  Set-Content -LiteralPath $percorsoIni -Value $testoIniLancio -Encoding ASCII
  $testoRiletto = Get-Content -LiteralPath $percorsoIni -Raw
  $guastiIni = VerificaIniTesto $testoRiletto $lancioCorr.Cella.Ea $lancioCorr.Cella.Sym $lancioCorr.Cella.Tf $lancioCorr.Cella.Modello `
                                $lancioCorr.Da $lancioCorr.A $lancioCorr.Passata.Deposito $lancioCorr.Passata.Leva 1 $lancioCorr.Magic $true
  if(@($guastiIni).Count -gt 0){
    throw ("l'.ini scritto per " + $lancioCorr.Id + " NON e' quello dichiarato: " + ($guastiIni -join " ; ") + ". NON lancio (checklist 79).")
  }
  $IniTesti[$lancioCorr.Id] = $testoRiletto
  Copy-Item -LiteralPath $percorsoIni -Destination (Join-Path $Sosta ("gen_R114_" + $lancioCorr.Id + ".ini")) -Force
  Dico ("ini " + $lancioCorr.Id.PadRight(18) + " Deposit=" + $lancioCorr.Passata.Deposito + " Leverage=" + $lancioCorr.Passata.Leva + " Currency=EUR Model=" + $lancioCorr.Cella.Modello + " " + $lancioCorr.Da + " -> " + $lancioCorr.A + " magic " + $lancioCorr.Magic + "/" + ($lancioCorr.Magic+1)) "Gray"
}
#--- la STELLA fra le passate (per cella e gamba): input identici
#    tranne InpMagic, [Tester] identico tranne Deposit/Leverage/Report.
foreach($cellaCorr in $CELLE){
  $gambeCella = @("UNICA")
  if($cellaCorr.Gambe -eq "ISOOS"){ $gambeCella = @("IS","OOS") }
  foreach($gambaCorr in $gambeCella){
    $suffCorr = ""
    if($gambaCorr -ne "UNICA"){ $suffCorr = "_" + $gambaCorr }
    $testiGamba = @()
    foreach($passataCorr in $PASSATE){ $testiGamba += $IniTesti[($cellaCorr.Id + "_P" + $passataCorr.P + $suffCorr)] }
    $guastiStella = VerificaStellaPassate $testiGamba
    if(@($guastiStella).Count -gt 0){
      throw ("STELLA FRA LE PASSATE fallita su " + $cellaCorr.Id + $suffCorr + ": " + ($guastiStella -join " ; "))
    }
  }
}
Dico "STELLA fra le passate: dentro ogni cella e gamba i tre .ini differiscono SOLO su Deposit/Leverage/Report e InpMagic" "Green"
#--- canarino A (gemelle come le celle) e B (singola, per la diagnosi)
$righeInputC0 = @($Vive[$CELLE[0].Prova] | Where-Object { $_ -notmatch '^@' })
$testoCanA = TestoIni $CELLE[0].Ea $CELLE[0].Sym $CELLE[0].Tf $CELLE[0].Modello $DaIndici $FinoTutti $CanDeposito $CanLeva 1 "OptReport_R114_canarino_A" (RiscriviMagicSweep $righeInputC0 $CanMagicBase)
$testoCanB = TestoIni $CELLE[0].Ea $CELLE[0].Sym $CELLE[0].Tf $CELLE[0].Modello $DaIndici $FinoTutti $CanDeposito $CanLeva 0 "OptReport_R114_canarino_B" (RigheSecche $righeInputC0 $CanMagicBase)
$iniCanA = Join-Path $Work "gen_R114_canarino_A.ini"; Set-Content -LiteralPath $iniCanA -Value $testoCanA -Encoding ASCII
$iniCanB = Join-Path $Work "gen_R114_canarino_B.ini"; Set-Content -LiteralPath $iniCanB -Value $testoCanB -Encoding ASCII
$guastiCanA = VerificaIniTesto (Get-Content -LiteralPath $iniCanA -Raw) $CELLE[0].Ea $CELLE[0].Sym $CELLE[0].Tf $CELLE[0].Modello $DaIndici $FinoTutti $CanDeposito $CanLeva 1 $CanMagicBase $true
$guastiCanB = VerificaIniTesto (Get-Content -LiteralPath $iniCanB -Raw) $CELLE[0].Ea $CELLE[0].Sym $CELLE[0].Tf $CELLE[0].Modello $DaIndici $FinoTutti $CanDeposito $CanLeva 0 $CanMagicBase $false
if(@($guastiCanA).Count -gt 0){ throw ("canarino A: .ini non conforme: " + ($guastiCanA -join " ; ")) }
if(@($guastiCanB).Count -gt 0){ throw ("canarino B: .ini non conforme: " + ($guastiCanB -join " ; ")) }
Copy-Item -LiteralPath $iniCanA -Destination (Join-Path $Sosta "gen_R114_canarino_A.ini") -Force
Copy-Item -LiteralPath $iniCanB -Destination (Join-Path $Sosta "gen_R114_canarino_B.ini") -Force
Dico ("ini canarino A/B: Deposit=" + $CanDeposito + " Leverage=" + $CanLeva + " Currency=EUR Model=" + $CELLE[0].Modello + " magic " + $CanMagicBase + "/" + ($CanMagicBase+1) + " (B: singola, solo diagnosi)") "Gray"
#--- le 3 sonde G-SPEC (banco P2: 200k / leva 15; $SimboliSonda nasce
#    PRIMA del try, checklist 41-bis)
foreach($simboloSonda in $SimboliSonda){
  $testoSonda = TestoIni "ABTG_SondaMargine" $simboloSonda "H1" 1 $SpecDa $SpecA $SpecDeposito $SpecLeva 0 ("OptReport_R114_sonda_" + $simboloSonda) @()
  $iniSonda = Join-Path $Work ("gen_R114_sonda_" + $simboloSonda + ".ini")
  Set-Content -LiteralPath $iniSonda -Value $testoSonda -Encoding ASCII
  $guastiSonda = VerificaIniTesto (Get-Content -LiteralPath $iniSonda -Raw) "ABTG_SondaMargine" $simboloSonda "H1" 1 $SpecDa $SpecA $SpecDeposito $SpecLeva 0 0 $false
  if(@($guastiSonda).Count -gt 0){ throw ("sonda " + $simboloSonda + ": .ini non conforme: " + ($guastiSonda -join " ; ")) }
  Copy-Item -LiteralPath $iniSonda -Destination (Join-Path $Sosta ("gen_R114_sonda_" + $simboloSonda + ".ini")) -Force
  Dico ("ini sonda " + $simboloSonda + ": Deposit=" + $SpecDeposito + " Leverage=" + $SpecLeva + " Currency=EUR Model=1 " + $SpecDa + " -> " + $SpecA) "Gray"
}

# =====================================================================
#  3-TER. G-SPEC: LE TRE SONDE NEL TESTER (ANCHE nel giro a vuoto --
#  deviazione (d), dichiarata). Estrazione per DELTA delle righe GSPEC.
# =====================================================================
Titolo "3-TER. G-SPEC: la sonda delle specifiche margine (3 simboli, banco 200k/leva 15)"
foreach($simboloSonda in $SimboliSonda){
  $fotoPrimaSonda = SnapshotJournal $PatternTutti
  $iniSonda = Join-Path $Work ("gen_R114_sonda_" + $simboloSonda + ".ini")
  (Start-Process -FilePath $Terminal -ArgumentList "/config:`"$iniSonda`"" -PassThru).WaitForExit()
  $fotoDopoSonda = SnapshotJournal $PatternTutti
  $deltaGspec = DeltaJournal $fotoPrimaSonda $fotoDopoSonda "GSPEC;"
  if($deltaGspec -le 0){
    $SpecEstratte[$simboloSonda] = @()
    [void]$Problemi.Add("G-SPEC " + $simboloSonda + ": la sonda NON ha stampato righe GSPEC nel journal del tester. Due nomi (checklist 83): (1) il tester non e' partito (log in " + $DataFolder + "\Tester\logs); (2) il simbolo non ha dati nella finestra " + $SpecDa + " -> " + $SpecA + ". Le specifiche margine di questo simbolo restano NON MISURATE.")
    Dico ("G-SPEC " + $simboloSonda + ": NESSUNA riga GSPEC (vedi PROBLEMI)") "Red"
  } else {
    $righeGspec = EstraiRigheNuove $fotoPrimaSonda "GSPEC;" $deltaGspec
    $righeGspecPulite = @()
    foreach($rigaGs in $righeGspec){
      $posGs = $rigaGs.IndexOf("GSPEC;")
      if($posGs -ge 0){ $righeGspecPulite += $rigaGs.Substring($posGs) }
    }
    $SpecEstratte[$simboloSonda] = @($righeGspecPulite | Where-Object { $_ -like ("GSPEC;" + $simboloSonda + ";*") })
    Set-Content -LiteralPath (Join-Path $Sosta ("gspec_" + $simboloSonda + ".txt")) -Value ($SpecEstratte[$simboloSonda] -join "`r`n") -Encoding ASCII
    Dico ("G-SPEC " + $simboloSonda + ": " + @($SpecEstratte[$simboloSonda]).Count + " righe estratte (in sosta e nel referto)") "Green"
    foreach($rigaGs in @($SpecEstratte[$simboloSonda] | Select-Object -First 30)){ Write-Host ("      " + $rigaGs) -ForegroundColor Gray }
  }
}

if(-not $SoloControllo){

# =====================================================================
#  3-QUATER. IL CANARINO G-CAN (checklist 84-bis: il rilevatore si
#  prova nel verso che morde, PRIMA di leggere qualunque "zero").
# =====================================================================
Titolo ("3-QUATER. IL CANARINO (C0 a deposito " + $CanDeposito + " / leva " + $CanLeva + ", magic " + $CanMagicBase + "/" + ($CanMagicBase+1) + ")")
$stagingCanarino = Join-Path $MqlFiles ("OptResults_" + $CELLE[0].Ea + "_" + $CELLE[0].Sym + ".csv")
Remove-Item -LiteralPath $stagingCanarino -Force -ErrorAction SilentlyContinue
foreach($magCan in @($CanMagicBase,($CanMagicBase+1))){
  Remove-Item -LiteralPath (Join-Path $CommonFiles ("abtg_trades_" + $CELLE[0].Ea + "_" + $CELLE[0].Sym + "_" + $magCan + ".csv")) -Force -ErrorAction SilentlyContinue
}
$cacheTester = Join-Path $DataFolder "Tester\cache"
if(Test-Path -LiteralPath $cacheTester){ Get-ChildItem -LiteralPath $cacheTester -Force -ErrorAction SilentlyContinue | Remove-Item -Recurse -Force -ErrorAction SilentlyContinue }
$avvioCanarino = Get-Date
$fotoPrimaCan = SnapshotJournal $PatternTutti
(Start-Process -FilePath $Terminal -ArgumentList "/config:`"$iniCanA`"" -PassThru).WaitForExit()
$fotoDopoCan = SnapshotJournal $PatternTutti
#--- il CSV del canarino: fuori dalle tabelle di verdetto, ma agli atti
if(Test-Path -LiteralPath $stagingCanarino){
  Move-Item -LiteralPath $stagingCanarino -Destination (Join-Path $Risultati "R114_canarino_A.csv") -Force
  $lettureCanarino = LeggiOpt (Join-Path $Risultati "R114_canarino_A.csv")
  $CanarinoA.Gemelli = Gemelli $lettureCanarino
  if($null -ne $lettureCanarino -and @($lettureCanarino).Count -ge 1){
    $CanarinoA.Righe = @($lettureCanarino).Count
    if($null -ne $lettureCanarino[0].N){ $CanarinoA.N = [int]$lettureCanarino[0].N }
    if($null -ne $lettureCanarino[0].Profit){ $CanarinoA.Prof = [double]$lettureCanarino[0].Profit }
  }
  $CanarinoA.Esito = "ESEGUITO"
} else {
  $CanarinoA.Esito = "NESSUN CSV"
  [void]$Problemi.Add("canarino A: il tester non ha scritto l'OptResults. Il canarino deve GIRARE per poter mordere: round fermo.")
}
#--- il verdetto del canarino: quale candidato ha morso?
$rifiutoCanA = $null
foreach($patternCorr in $PatternRifiutoCandidati){
  $deltaCorr = DeltaJournal $fotoPrimaCan $fotoDopoCan $patternCorr
  if($deltaCorr -gt 0){ $rifiutoCanA = [pscustomobject]@{ Pattern=$patternCorr; Conta=$deltaCorr }; break }
}
if($null -ne $rifiutoCanA){
  $PatternImparato = $rifiutoCanA.Pattern
  $CanarinoA.Rifiuti = $rifiutoCanA.Conta
  $CanarinoA.RifiutiNota = "IL CANARINO MORDE"
  $righeEvidenza = EstraiRigheNuove $fotoPrimaCan $PatternImparato $rifiutoCanA.Conta
  Set-Content -LiteralPath (Join-Path $Sosta "rifiuti_canarino_A.txt") -Value (@("pattern imparato: '" + $PatternImparato + "'  (occorrenze nuove: " + $rifiutoCanA.Conta + ")") + $righeEvidenza -join "`r`n") -Encoding UTF8
  Dico ("CANARINO: MORDE. Stringa imparata dal journal: '" + $PatternImparato + "' (" + $rifiutoCanA.Conta + " righe nuove). E' LEI che il rilevatore cerchera' in tutte le passate.") "Green"
} else {
  #--- DISAMBIGUAZIONE (checklist 83): canarino B a passata SINGOLA.
  Dico "CANARINO A (gemelle): ZERO righe di rifiuto nel journal. Provo il canarino B a passata SINGOLA per dare un NOME alla causa..." "Yellow"
  $fotoPrimaCanB = SnapshotJournal $PatternTutti
  (Start-Process -FilePath $Terminal -ArgumentList "/config:`"$iniCanB`"" -PassThru).WaitForExit()
  $fotoDopoCanB = SnapshotJournal $PatternTutti
  $rifiutoCanB = $null
  foreach($patternCorr in $PatternRifiutoCandidati){
    $deltaCorr = DeltaJournal $fotoPrimaCanB $fotoDopoCanB $patternCorr
    if($deltaCorr -gt 0){ $rifiutoCanB = [pscustomobject]@{ Pattern=$patternCorr; Conta=$deltaCorr }; break }
  }
  $CanarinoKo = $true
  if($null -ne $rifiutoCanB){
    $CanarinoB.Rifiuti = $rifiutoCanB.Conta
    [void]$Problemi.Add("CANARINO: il rifiuto ESISTE ma solo a passata SINGOLA ('" + $rifiutoCanB.Pattern + "', " + $rifiutoCanB.Conta + " righe): il journal delle corse GEMELLE (Optimization=1) e' MUTO (checklist 34). Il rilevatore journal NON puo' leggere le corse di questo round cosi' come sono disegnate: ROUND FERMO (exit 2). La strada: aggiungere una passata journal SINGOLA per cella (revisione del disegno, da firmare).")
  } else {
    [void]$Problemi.Add("CANARINO: NESSUN rifiuto nel journal NE' in gemelle NE' in singola, a deposito " + $CanDeposito + " / leva " + $CanLeva + ". Due nomi (checklist 83): (1) il tester NON sta simulando Leverage=15 nel calcolo margine (criteri par. 1 punto 4: il banco non simula la leva, il round si ferma qui); (2) la stringa vera del journal non e' fra i candidati [" + ($PatternRifiutoCandidati -join " | ") + "] -- si apre il log del tester in " + $DataFolder + "\Tester e si legge COSA scrive su un ordine rifiutato. ROUND FERMO (exit 2).")
  }
}
$CanarinoA.Min = [math]::Round((New-TimeSpan -Start $avvioCanarino -End (Get-Date)).TotalMinutes,1)

# =====================================================================
#  4. LA CATENA -- solo se il canarino ha morso.
# =====================================================================
if(-not $CanarinoKo){
Titolo ("4. LA CATENA - " + $Ordinati.Count + " lanci, uno alla volta")
$indiceLancio = 0
foreach($lancioCorr in $Ordinati){
  $indiceLancio++
  $oreTrascorse = (New-TimeSpan -Start $Avvio -End (Get-Date)).TotalHours
  if($oreTrascorse -ge $OreMax){
    $lancioCorr.Esito = "NON INIZIATO (tetto ore raggiunto)"
    [void]$Problemi.Add("TEMPO SCADUTO prima di " + $lancioCorr.Id + ": il round NON e' completo. Riprendi con -SoloCella " + $lancioCorr.Cella.Prova + ".")
    continue
  }
  Write-Host ""
  Write-Host "------------------------------------------------------------------" -ForegroundColor Cyan
  Write-Host ("  [" + $indiceLancio + "/" + $Ordinati.Count + "]  " + $lancioCorr.Id + "   " + $lancioCorr.Cella.Ea + " su " + $lancioCorr.Cella.Sym + " " + $lancioCorr.Cella.Tf) -ForegroundColor Cyan
  Write-Host ("           " + $lancioCorr.Passata.Nome + " (Deposit " + $lancioCorr.Passata.Deposito + " / Leverage " + $lancioCorr.Passata.Leva + "): " + $lancioCorr.Passata.Cosa) -ForegroundColor Cyan
  Write-Host "------------------------------------------------------------------" -ForegroundColor Cyan
  $avvioLancio = Get-Date
  #--- CHECKLIST 79: la finestra si ricontrolla QUI, contro il SECONDO
  #    deposito letterale, un istante prima di usarla.
  $finestraAttesa = $FinestreLetterali[$lancioCorr.ChiaveFin]
  $finestraLetta  = ("" + $lancioCorr.Da + "|" + $lancioCorr.A)
  if($finestraLetta -ne $finestraAttesa){
    if($finestraLetta.Length -gt 60){ $finestraLetta = $finestraLetta.Substring(0,60) + " ...[+" + ($finestraLetta.Length-60) + " caratteri: la variabile e' diventata un ARRAY]" }
    throw ("LA FINESTRA E' STATA SPORCATA prima di " + $lancioCorr.Id + ": [" + $finestraLetta + "] invece di [" + $finestraAttesa + "]. NON lancio (checklist 79).")
  }
  Write-Host ("           finestra: " + $lancioCorr.Da + " -> " + $lancioCorr.A + "   (ricontrollata adesso sul secondo deposito)") -ForegroundColor Gray

  $percorsoCsv = CsvDi $lancioCorr
  # ---------- LANCIO GIA' FATTO (checklist 88): si RACCOGLIE con l'eta'
  #  dichiarata, si rifa' solo con -Rifai. I rifiuti journal di un giro
  #  precedente NON sono rimisurabili: n/d dichiarato.
  if((Test-Path -LiteralPath $percorsoCsv) -and -not $Rifai){
    $etaCsvVecchio = (Get-Item -LiteralPath $percorsoCsv).LastWriteTime
    $lancioCorr.EtaCsv = $etaCsvVecchio.ToString("yyyy-MM-dd HH:mm:ss",$INV)
    $lancioCorr.Esito = "GIA' FATTO (CSV del " + $lancioCorr.EtaCsv + " ora del PC, NON di questo lancio)"
    $lancioCorr.RifiutiNota = "n/d (lancio saltato: i rifiuti journal si misurano solo su un lancio fresco)"
    [void]$Rilievi.Add($lancioCorr.Id + ": " + $lancioCorr.Esito + ". Raccolto con l'eta' dichiarata; per rifarlo: -Rifai.")
    $lettureVecchie = LeggiOpt $percorsoCsv
    $lancioCorr.Gemelli = Gemelli $lettureVecchie
    if($null -ne $lettureVecchie -and @($lettureVecchie).Count -ge 1){
      $lancioCorr.Righe = @($lettureVecchie).Count
      if($null -ne $lettureVecchie[0].Pf){     $lancioCorr.Pf   = [double]$lettureVecchie[0].Pf }
      if($null -ne $lettureVecchie[0].Dd){     $lancioCorr.Dd   = [double]$lettureVecchie[0].Dd }
      if($null -ne $lettureVecchie[0].N){      $lancioCorr.N    = [int]$lettureVecchie[0].N }
      if($null -ne $lettureVecchie[0].Profit){ $lancioCorr.Prof = [double]$lettureVecchie[0].Profit }
    }
    Write-Host ("    esito: " + $lancioCorr.Esito) -ForegroundColor DarkYellow
    continue
  }
  # ---------- PULIZIA PER LANCIO (checklist 88): staging OptResults di
  #  QUESTO EA+simbolo, Tester\cache, per-trade dei 2 magic del lancio.
  $csvStaging = Join-Path $MqlFiles ("OptResults_" + $lancioCorr.Cella.Ea + "_" + $lancioCorr.Cella.Sym + ".csv")
  if(Test-Path -LiteralPath $csvStaging){
    Remove-Item -LiteralPath $csvStaging -Force -ErrorAction SilentlyContinue
    if(Test-Path -LiteralPath $csvStaging){ [void]$Problemi.Add($lancioCorr.Id + ": staging " + $csvStaging + " NON cancellabile (file aperto?).") }
  }
  if(Test-Path -LiteralPath $cacheTester){
    $numCachePrima = @(Get-ChildItem -LiteralPath $cacheTester -Force -Recurse -File -ErrorAction SilentlyContinue).Count
    Get-ChildItem -LiteralPath $cacheTester -Force -ErrorAction SilentlyContinue | Remove-Item -Recurse -Force -ErrorAction SilentlyContinue
    $numCacheDopo = @(Get-ChildItem -LiteralPath $cacheTester -Force -Recurse -File -ErrorAction SilentlyContinue).Count
    if($numCacheDopo -gt 0){ [void]$Problemi.Add($lancioCorr.Id + ": Tester\cache NON svuotata (" + $numCacheDopo + " su " + $numCachePrima + "). MT5 puo' ripescare passate gia' calcolate.") }
  }
  if($lancioCorr.Cella.PerTrade){
    foreach($magLancio in @($lancioCorr.Magic,($lancioCorr.Magic+1))){
      Remove-Item -LiteralPath (Join-Path $CommonFiles ("abtg_trades_" + $lancioCorr.Cella.Ea + "_" + $lancioCorr.Cella.Sym + "_" + $magLancio + ".csv")) -Force -ErrorAction SilentlyContinue
    }
  }
  # ---------- L'INI: gia' scritto e verificato in 3-BIS; si RILEGGE il
  #  file che sta per girare (stesso artefatto, checklist 33).
  $percorsoIni = IniDi $lancioCorr
  if(-not (Test-Path -LiteralPath $percorsoIni)){ throw ($lancioCorr.Id + ": l'.ini della fabbrica e' SPARITO fra il passo 3-BIS e adesso.") }

  # ---------- IL LANCIO
  Write-Host ("    avvio 2 passate gemelle (modello " + $lancioCorr.Cella.Modello + ")...") -ForegroundColor Cyan
  $fotoPrimaLancio = SnapshotJournal $PatternTutti
  (Start-Process -FilePath $Terminal -ArgumentList "/config:`"$percorsoIni`"" -PassThru).WaitForExit()
  $fotoDopoLancio = SnapshotJournal $PatternTutti
  $lancioCorr.Min = [math]::Round((New-TimeSpan -Start $avvioLancio -End (Get-Date)).TotalMinutes,1)

  # ---------- I RIFIUTI DI QUESTO LANCIO (delta della stringa imparata)
  if($null -ne $PatternImparato){
    $lancioCorr.Rifiuti = DeltaJournal $fotoPrimaLancio $fotoDopoLancio $PatternImparato
    $lancioCorr.RifiutiNota = "misurati col pattern del canarino ('" + $PatternImparato + "')"
    if($lancioCorr.Rifiuti -gt 0){
      $righeEvidenza = EstraiRigheNuove $fotoPrimaLancio $PatternImparato $lancioCorr.Rifiuti
      Set-Content -LiteralPath (Join-Path $Sosta ("rifiuti_" + $lancioCorr.Id + ".txt")) -Value ($righeEvidenza -join "`r`n") -Encoding UTF8
    } else {
      Set-Content -LiteralPath (Join-Path $Sosta ("rifiuti_" + $lancioCorr.Id + ".txt")) -Value ("0 righe nuove col pattern '" + $PatternImparato + "' in questo lancio.") -Encoding UTF8
    }
  }

  # ---------- IL CSV: fresco, righe giuste, spostato per nome.
  $csvTrovato = ""
  if(Test-Path -LiteralPath $csvStaging){ $csvTrovato = $csvStaging }
  if($csvTrovato -eq ""){
    $lancioCorr.Esito = "NESSUN CSV (il tester non ha scritto niente)"
    [void]$Problemi.Add($lancioCorr.Id + ": NESSUN CSV prodotto. Il log del tester in " + $DataFolder + "\Tester\logs dice perche' (MT5 rimasto aperto? tester uscito male?).")
    Write-Host ("    esito: " + $lancioCorr.Esito + "   [" + $lancioCorr.Min.ToString("0.0",$INV) + " min]") -ForegroundColor Red
    continue
  }
  if((Get-Item -LiteralPath $csvTrovato).LastWriteTime -lt $avvioLancio){
    $lancioCorr.Esito = "CSV VECCHIO (LastWriteTime prima dell'avvio del lancio)"
    [void]$Problemi.Add($lancioCorr.Id + ": il CSV in MQL5\Files e' VECCHIO (di un giro precedente): NON si legge.")
    Write-Host ("    esito: " + $lancioCorr.Esito) -ForegroundColor Red
    continue
  }
  Move-Item -LiteralPath $csvTrovato -Destination $percorsoCsv -Force
  $lancioCorr.EtaCsv = (Get-Item -LiteralPath $percorsoCsv).LastWriteTime.ToString("yyyy-MM-dd HH:mm:ss",$INV)

  # ---------- RILETTURA DELL'INI CHE HA GIRATO (checklist 79).
  $testoIniGirato = Get-Content -LiteralPath $percorsoIni -Raw
  $matchFromGirato = [regex]::Match($testoIniGirato,'(?m)^FromDate=([0-9.]+)\r?$')
  $matchToGirato   = [regex]::Match($testoIniGirato,'(?m)^ToDate=([0-9.]+)\r?$')
  $matchDepGirato  = [regex]::Match($testoIniGirato,'(?m)^Deposit=([0-9]+)\r?$')
  $matchLevGirato  = [regex]::Match($testoIniGirato,'(?m)^Leverage=([0-9]+)\r?$')
  if(-not $matchFromGirato.Success -or -not $matchToGirato.Success -or $matchFromGirato.Groups[1].Value -ne $lancioCorr.Da -or $matchToGirato.Groups[1].Value -ne $lancioCorr.A){
    [void]$Problemi.Add($lancioCorr.Id + ": l'.ini CHE HA GIRATO porta FromDate=[" + $matchFromGirato.Groups[1].Value + "] ToDate=[" + $matchToGirato.Groups[1].Value + "] invece di [" + $lancioCorr.Da + "] e [" + $lancioCorr.A + "]: i numeri NON sono della finestra dichiarata.")
  }
  if(-not $matchDepGirato.Success -or -not $matchLevGirato.Success -or $matchDepGirato.Groups[1].Value -ne ("" + $lancioCorr.Passata.Deposito) -or $matchLevGirato.Groups[1].Value -ne ("" + $lancioCorr.Passata.Leva)){
    [void]$Problemi.Add($lancioCorr.Id + ": l'.ini CHE HA GIRATO porta Deposit=[" + $matchDepGirato.Groups[1].Value + "] Leverage=[" + $matchLevGirato.Groups[1].Value + "] invece di [" + $lancioCorr.Passata.Deposito + "] e [" + $lancioCorr.Passata.Leva + "]: la passata NON e' quella dichiarata (checklist 89).")
  }

  # ---------- LE MISURE (parser stretto a 8 colonne), G0-C, per-trade.
  $lettureCsv = LeggiOpt $percorsoCsv
  $lancioCorr.Gemelli = Gemelli $lettureCsv
  if($null -eq $lettureCsv){
    $lancioCorr.Esito = "CSV ILLEGGIBILE (intestazione non a 8 colonne attese)"
    [void]$Problemi.Add($lancioCorr.Id + ": CSV non letto o intestazione diversa (checklist 80). Viste: [" + (($script:CsvIntestazioni | Select-Object -First 10) -join " | ") + "]")
    Write-Host ("    esito: " + $lancioCorr.Esito) -ForegroundColor Red
    continue
  }
  $lancioCorr.Righe = @($lettureCsv).Count
  if(@($lettureCsv).Count -ge 1){
    if($null -ne $lettureCsv[0].Pf){     $lancioCorr.Pf   = [double]$lettureCsv[0].Pf }
    if($null -ne $lettureCsv[0].Dd){     $lancioCorr.Dd   = [double]$lettureCsv[0].Dd }
    if($null -ne $lettureCsv[0].N){      $lancioCorr.N    = [int]$lettureCsv[0].N }
    if($null -ne $lettureCsv[0].Profit){ $lancioCorr.Prof = [double]$lettureCsv[0].Profit }
  }
  AnalisiPerTrade $lancioCorr $avvioLancio
  if($lancioCorr.Righe -ne $CelleAttese){
    $lancioCorr.Esito = "RIGHE SBAGLIATE (" + (FmtN $lancioCorr.Righe) + " invece di " + $CelleAttese + ")"
    [void]$Problemi.Add($lancioCorr.Id + ": " + $lancioCorr.Esito + ". Cache del tester o sweep che non ha spazzolato: il file NON si legge.")
  }
  elseif($lancioCorr.Gemelli -ne "IDENTICI"){
    $lancioCorr.Esito = "G0-C FALLITO"
    [void]$Problemi.Add($lancioCorr.Id + ": gemelli " + $lancioCorr.Gemelli + ". Due passate a parametri identici devono dare numeri identici: questo lancio non si legge.")
  }
  else {
    $lancioCorr.Esito = "OK"
    Dico ("G0-C: IDENTICI. " + $lancioCorr.Id + ": profitto " + (FmtE $lancioCorr.Prof) + " | PF " + (Fmt3 $lancioCorr.Pf) + " | DD " + (Fmt2 $lancioCorr.Dd) + "% | n " + (FmtN $lancioCorr.N) + " uscite (" + (FmtPos $lancioCorr.N) + " posizioni) | rifiuti journal " + (FmtN $lancioCorr.Rifiuti) + " | vol max " + (Fmt2 $lancioCorr.VolMax) + " | righe a 100: " + (FmtN $lancioCorr.Righe100)) "Green"
  }
  Write-Host ("    esito: " + $lancioCorr.Esito + "   [" + $lancioCorr.Min.ToString("0.0",$INV) + " min]") -ForegroundColor Gray
}
} else {
  Dico "LA CATENA NON PARTE: il canarino non ha morso (round fermo, exit 2). I lanci restano NON ESEGUITI, la raccolta si fa comunque." "Red"
}

# =====================================================================
#  4-BIS. G0-B: l'aggancio di C1_EMADOW P0 sui CSV R110 (al centesimo).
# =====================================================================
if(@($CelleScelte | Where-Object { $_.C -eq 1 }).Count -gt 0 -and -not $CanarinoKo){
  Titolo "4-BIS. G0-B: C1_EMADOW P0 contro i CSV di riferimento R110"
  $G0BEsiti["IS"]  = ConfrontaG0B (Join-Path $Risultati "R114_C1_EMADOW_P0_IS.csv")  $RifG0BIS
  $G0BEsiti["OOS"] = ConfrontaG0B (Join-Path $Risultati "R114_C1_EMADOW_P0_OOS.csv") $RifG0BOOS
  $cellaEmadow = @($CELLE | Where-Object { $_.C -eq 1 })[0]
  if($G0BEsiti["IS"] -eq "OK" -and $G0BEsiti["OOS"] -eq "OK"){
    $cellaEmadow.G0B = "OK: P0 riproduce AL CENTESIMO i CSV R110 (IS e OOS)"
    $cellaEmadow.Misurabile = "MISURABILE (aggancio dimostrato)"
    Dico $cellaEmadow.G0B "Green"
  } else {
    $cellaEmadow.G0B = "IS: " + $G0BEsiti["IS"] + " | OOS: " + $G0BEsiti["OOS"]
    $cellaEmadow.Misurabile = "NON MISURABILE (G4: P0 non riproduce gli atti -- prima si spiega P0, poi si legge il resto)"
    [void]$Problemi.Add("G0-B C1_EMADOW: " + $cellaEmadow.G0B + ". La cella e' NON MISURABILE in questo round (G4): niente verdetto leva su un aggancio rotto. I numeri di P1/P2 restano agli atti SOLO per la diagnosi.")
    Dico ("G0-B: " + $cellaEmadow.G0B) "Red"
  }
}
#--- il confronto INFO di P0 per le celle senza CSV di riferimento
foreach($cellaCorr in $CelleScelte){
  if($cellaCorr.C -eq 1){ continue }
  $cellaCorr.Misurabile = "G4 A MANO (P0 contro archivio: confronto INFO, vedi referto -- nessun CSV di riferimento congelato)"
}

} # fine if -not SoloControllo

if($SoloControllo){
  foreach($lancioCorr in $Ordinati){ $lancioCorr.Esito = "SOLO CONTROLLO" }
  $numIniSosta = @(Get-ChildItem -LiteralPath $Sosta -Filter "gen_R114_*.ini" -ErrorAction SilentlyContinue).Count
  $numIniAttesi = $LANCI.Count + 2 + 3
  if($numIniSosta -ne $numIniAttesi){ [void]$Problemi.Add("giro a vuoto: " + $numIniSosta + " .ini in sosta invece di " + $numIniAttesi + " (15 misura + 2 canarino + 3 sonde).") }
  Write-Host ""
  Write-Host ("    .ini scritti e verificati in sosta: " + $numIniSosta + " su " + $numIniAttesi + "   -> " + $Sosta) -ForegroundColor White
  Write-Host  "    >>> IL GIRO A VUOTO NON MISURA NESSUN NUMERO DI ROUND: niente n," -ForegroundColor Yellow
  Write-Host  "        niente PF, niente G0-C, niente canarino. Ha fatto girare SOLO le" -ForegroundColor Yellow
  Write-Host  "        3 sonde G-SPEC nel tester (deviazione dichiarata: i criteri par. 4" -ForegroundColor Yellow
  Write-Host  "        esigono le specifiche margine NEL giro a vuoto). Gli .ini sono GLI" -ForegroundColor Yellow
  Write-Host  "        STESSI della corsa vera (checklist 33)." -ForegroundColor Yellow
}

}catch{
  $Fatale = $_.Exception.Message
  Write-Host ""
  Write-Host ("!!! FERMATO: " + $Fatale) -ForegroundColor Red
}

# =====================================================================
#  5. RACCOLTA. Si fa SEMPRE, anche a esito parziale, fermato o a
#     canarino KO (checklist 41-bis).
# =====================================================================
Titolo "5. RACCOLTA SUL DESKTOP"
$Modo = if($SoloControllo){ "CONTROLLO" } elseif($SoloCella -ne ""){ "RIPRESA" } else { "CORSA" }
$Cart = Join-Path $Dsk ("R114_LEVA_" + $Modo + "_" + $Stamp)
$Zip  = Join-Path $Dsk ("R114_LEVA_" + $Modo + "_" + $Stamp + ".zip")
$Referto = Join-Path $Cart "REFERTO_R114.txt"
function TrovaLancio([string]$idCercato){
  foreach($lancioF in $LANCI){ if($lancioF.Id -eq $idCercato){ return $lancioF } }
  return $null
}
#  identita' al centesimo fra due lanci (profitto/PF/DD/n, tolleranza
#  0,005 come i gemelli): e' il metro del VERDE, il verdetto e' a mano.
function IdentitaAlCentesimo($lancioA,$lancioB){
  if($null -eq $lancioA -or $null -eq $lancioB){ return "n/d" }
  if($lancioA.Esito -notlike "OK*" -and $lancioA.Esito -notlike "GIA' FATTO*"){ return "n/d (lancio A senza numeri leggibili)" }
  if($lancioB.Esito -notlike "OK*" -and $lancioB.Esito -notlike "GIA' FATTO*"){ return "n/d (lancio B senza numeri leggibili)" }
  $diffTrovate = @()
  if([math]::Abs($lancioA.Prof - $lancioB.Prof) -gt 0.005){ $diffTrovate += "profitto" }
  if([math]::Abs($lancioA.Pf   - $lancioB.Pf)   -gt 0.005){ $diffTrovate += "PF" }
  if([math]::Abs($lancioA.Dd   - $lancioB.Dd)   -gt 0.005){ $diffTrovate += "DD" }
  if($lancioA.N -ne $lancioB.N){ $diffTrovate += "n" }
  if($diffTrovate.Count -eq 0){ return "SI (identici al centesimo su profitto/PF/DD/n)" }
  return ("NO (differiscono su: " + ($diffTrovate -join ", ") + ")")
}
try{
  New-Item -ItemType Directory -Force -Path $Cart | Out-Null
  $AttesiTrovati = New-Object System.Collections.ArrayList
  foreach($lancioRacc in $Ordinati){
    $csvDaCopiare = CsvDi $lancioRacc
    $trovatoRacc = "MANCA"
    if(Test-Path -LiteralPath $csvDaCopiare){
      Copy-Item -LiteralPath $csvDaCopiare -Destination (Join-Path $Cart (Split-Path -Leaf $csvDaCopiare)) -Force
      $trovatoRacc = "trovato (" + (Get-Item -LiteralPath $csvDaCopiare).LastWriteTime.ToString("yyyy-MM-dd HH:mm",$INV) + ")"
    } elseif($SoloControllo){ $trovatoRacc = "non atteso (giro a vuoto)" }
    elseif($CanarinoKo){ $trovatoRacc = "non atteso (round fermo dal canarino)" }
    [void]$AttesiTrovati.Add((Split-Path -Leaf $csvDaCopiare).PadRight(32) + " " + $trovatoRacc)
  }
  $csvCanarino = Join-Path $Risultati "R114_canarino_A.csv"
  if(Test-Path -LiteralPath $csvCanarino){ Copy-Item -LiteralPath $csvCanarino -Destination (Join-Path $Cart "R114_canarino_A.csv") -Force }
  foreach($cellaRacc in $CELLE){
    foreach($fileRacc in @((Join-Path $Prove $cellaRacc.Prova),(Join-Path $Anten $cellaRacc.AntFile))){
      if(Test-Path -LiteralPath $fileRacc){ Copy-Item -LiteralPath $fileRacc -Destination (Join-Path $Cart (Split-Path -Leaf $fileRacc)) -Force }
    }
  }
  foreach($fileRif in @($RifG0BIS,$RifG0BOOS)){
    if(Test-Path -LiteralPath $fileRif){ Copy-Item -LiteralPath $fileRif -Destination (Join-Path $Cart ("RIF_" + (Split-Path -Leaf $fileRif))) -Force }
  }
  #  la SOSTA si copia intera (svuotata a ogni giro: solo roba di ADESSO)
  if(Test-Path -LiteralPath $Sosta){
    foreach($fileSosta in @(Get-ChildItem -LiteralPath $Sosta -File -ErrorAction SilentlyContinue)){
      Copy-Item -LiteralPath $fileSosta.FullName -Destination (Join-Path $Cart $fileSosta.Name) -Force
    }
  }
  #  i per-trade copiati in Work
  foreach($filePt in @(Get-ChildItem -LiteralPath $Work -Filter "pertrade_*.csv" -File -ErrorAction SilentlyContinue)){
    Copy-Item -LiteralPath $filePt.FullName -Destination (Join-Path $Cart $filePt.Name) -Force
  }

  $RefTxt = New-Object System.Collections.ArrayList
  [void]$RefTxt.Add("REFERTO R114 - LA PROVA DELLA LEVA (fase 2 della prova della taglia)")
  [void]$RefTxt.Add("4 celle x 3 passate: P0 aggancio 100k/lev100, P1 taglia 200k/lev100, P2 leva 200k/lev15")
  [void]$RefTxt.Add("")
  [void]$RefTxt.Add("modo: " + $Modo + $(if($SoloControllo){ "   <<< GIRO A VUOTO: solo sonde G-SPEC, NESSUN numero di round qui dentro" } else { "" }))
  $switchGiro = @()
  if($SoloControllo){ $switchGiro += "-SoloControllo (sonde G-SPEC nel tester, nessuna passata di misura)" }
  if($CriteriFirmati -and $daFirmare){ $switchGiro += "-CriteriFirmati (FIRMA IN RIGA di Claudio: il file dei criteri portava ancora il lucchetto)" }
  elseif($CriteriFirmati){ $switchGiro += "-CriteriFirmati (INERTE, e va bene: i criteri risultano gia' FIRMATI NEL FILE al pin)" }
  if($SoloCella -ne ""){ $switchGiro += "-SoloCella " + $SoloCella + " (la cella intera: P0 e' il denominatore di P1/P2)" }
  if($Rifai){ $switchGiro += "-Rifai (i CSV precedenti sono stati rifatti)" }
  if($switchGiro.Count -eq 0){ $switchGiro += "nessuno (corsa piena; un lancio con CSV gia' presente viene RACCOLTO con l'eta' dichiarata, checklist 88)" }
  [void]$RefTxt.Add("switch di questo giro: " + ($switchGiro -join " | "))
  [void]$RefTxt.Add("stato dei criteri: " + $Firma)
  [void]$RefTxt.Add("data: " + (Get-Date).ToString("yyyy-MM-dd HH:mm:ss",$INV) + " ora del PC   (questa data deve essere di ADESSO)")
  [void]$RefTxt.Add("avvio: " + $Avvio.ToString("yyyy-MM-dd HH:mm:ss",$INV) + " ora del PC   durata: " + ((New-TimeSpan -Start $Avvio -End (Get-Date)).TotalMinutes).ToString("0.0",$INV) + " minuti")
  [void]$RefTxt.Add("pin: " + $Pin)
  [void]$RefTxt.Add("criteri: risultati_archivio\R114_CRITERI.md (dieci decisioni, par. 10, FIRMATE 27/08 mattina)")
  [void]$RefTxt.Add("")
  [void]$RefTxt.Add("--- IL BANCO E LE SUE APPROSSIMAZIONI (criteri par. 1, ristampate qui) ---")
  [void]$RefTxt.Add("  * la leva dell'.ini e' UNA leva per tutto il conto; la prop la dichiara PER")
  [void]$RefTxt.Add("    CLASSE. Qui non mescola: ogni corsa e' MONO-simbolo, quindi Leverage=15 su")
  [void]$RefTxt.Add("    una corsa U30USD/D30EUR/XAUUSD E' la leva di quello strumento.")
  [void]$RefTxt.Add("  * il margine del tester passa dalle specifiche del SIMBOLO BCM: la sonda")
  [void]$RefTxt.Add("    G-SPEC qui sotto stampa cio' che il tester VEDE (margin rate compresi).")
  [void]$RefTxt.Add("    Se atteso e osservato divergono, FA FEDE L'OSSERVATO e la FASE 1 si corregge.")
  [void]$RefTxt.Add("  * margin call/stop-out del tester: ACCOUNT_MARGIN_SO_CALL/SO_SO stampati")
  [void]$RefTxt.Add("    dalla sonda, da leggere accanto al 100% scritto di FundedNext.")
  [void]$RefTxt.Add("  * valuta: banco EUR, challenge in USD -- approssimazione dichiarata.")
  [void]$RefTxt.Add("  * questo round misura il margine PER SEDIA, non il basket (buco dichiarato).")
  [void]$RefTxt.Add("  * gli EA del perimetro NON riducono il lotto sul margine (grep agli atti,")
  [void]$RefTxt.Add("    criteri par. 3-bis punto 3): un rifiuto e' NETTO (il trade manca, n cala);")
  [void]$RefTxt.Add("    l'unica riduzione silenziosa e' il clamp a SYMBOL_VOLUME_MAX, contato dal")
  [void]$RefTxt.Add("    per-trade (colonna 'righe a 100'). C3 ORO: niente per-trade (dichiarato).")
  [void]$RefTxt.Add("orologi (checklist 86): le finestre sono DATE DI CALENDARIO server BCM;")
  [void]$RefTxt.Add("     i log del tester e 'data:'/'avvio:' qui sopra sono ORA LOCALE del PC")
  [void]$RefTxt.Add("     (sul VPS = ora italiana). Il grafico del tester e' in ora server.")
  [void]$RefTxt.Add("")
  [void]$RefTxt.Add("--- CONVENZIONE DI SENTINELLA (checklist 66) ---")
  [void]$RefTxt.Add("  Un numero NON MISURATO si scrive 'n/d'. MAI -1, MAI 0.000.")
  [void]$RefTxt.Add("")
  [void]$RefTxt.Add("--- G-SPEC: LE SPECIFICHE MARGINE VISTE DAL TESTER (banco 200k / leva 15) ---")
  [void]$RefTxt.Add("  MARGINE_OSSERVATO_1LOTTO_* = OrderCalcMargin del tester (fa fede questo);")
  [void]$RefTxt.Add("  MARGINE_ATTESO_FORMULA_FASE1 = prezzo x contratto / leva, in valuta margine")
  [void]$RefTxt.Add("  del simbolo NON convertita (etichetta dichiarata). VOLUME_MAX chiude il")
  [void]$RefTxt.Add("  buco FASE 1 par. 0c su XAUUSD.")
  foreach($simboloSonda in $SimboliSonda){
    $righeSpec = @()
    if($SpecEstratte.ContainsKey($simboloSonda)){ $righeSpec = @($SpecEstratte[$simboloSonda]) }
    if($righeSpec.Count -eq 0){
      [void]$RefTxt.Add("  " + $simboloSonda + ": NON MISURATE (la sonda non ha stampato: vedi PROBLEMI)")
    } else {
      foreach($rigaSpec in $righeSpec){ [void]$RefTxt.Add("  " + $rigaSpec) }
    }
  }
  [void]$RefTxt.Add("")
  [void]$RefTxt.Add("--- G-CAN: IL CANARINO DEL RILEVATORE (checklist 84-bis) ---")
  if($SoloControllo){
    [void]$RefTxt.Add("  NON ESEGUITO nel giro a vuoto (il canarino vive solo nella corsa vera).")
  } else {
    [void]$RefTxt.Add("  banco strozzato: deposito " + $CanDeposito + " / leva " + $CanLeva + " sugli input di C0, magic " + $CanMagicBase + "/" + ($CanMagicBase+1))
    [void]$RefTxt.Add("  esito lancio: " + $CanarinoA.Esito + "   gemelli: " + $CanarinoA.Gemelli + "   n: " + (FmtN $CanarinoA.N) + " uscite   [" + $CanarinoA.Min.ToString("0.0",$INV) + " min]")
    if($null -ne $PatternImparato){
      [void]$RefTxt.Add("  RILEVATORE: MORDE. Stringa imparata dal journal: '" + $PatternImparato + "' (" + (FmtN $CanarinoA.Rifiuti) + " righe nuove; evidenza in rifiuti_canarino_A.txt).")
      [void]$RefTxt.Add("  E' QUESTA stringa che il conteggio rifiuti usa su tutte le passate.")
    } else {
      [void]$RefTxt.Add("  RILEVATORE: NON MORDE -> ROUND FERMO (exit 2). La diagnosi col nome della")
      [void]$RefTxt.Add("  causa sta nei PROBLEMI qui sotto (canarino B a passata singola compreso).")
    }
    [void]$RefTxt.Add("  Il canarino NON entra in nessuna tabella di verdetto (criteri par. 4).")
  }
  [void]$RefTxt.Add("")
  [void]$RefTxt.Add("--- I GATE ---")
  [void]$RefTxt.Add("  G0-A ANTENATO   : copia riga per riga, delta il SOLO InpMagic (checklist 72).")
  foreach($cellaRef in $CELLE){ [void]$RefTxt.Add("       " + $cellaRef.Id.PadRight(10) + " " + $cellaRef.Antenato) }
  [void]$RefTxt.Add("  G0-B AGGANCIO   : al centesimo SOLO su C1_EMADOW (CSV R110 congelati);")
  [void]$RefTxt.Add("       per C0/C2/C3 il P0 si confronta con l'ARCHIVIO come INFO (G4 a mano):")
  foreach($cellaRef in $CELLE){ [void]$RefTxt.Add("       " + $cellaRef.Id.PadRight(10) + " " + $cellaRef.G0B) }
  [void]$RefTxt.Add("  G0-C GEMELLI    : 2 righe identiche al centesimo per CSV (magic +1).")
  [void]$RefTxt.Add("  G-SPEC / G-CAN  : sezioni sopra.")
  [void]$RefTxt.Add("  G1 CAMPIONE     : n in DEAL DI USCITA (~2 uscite = 1 posizione, convenzione")
  [void]$RefTxt.Add("       R112). Il round non giudica il MERITO dei motori: giudica il banco.")
  [void]$RefTxt.Add("  G4 ORDINE       : P0 rotto -> cella NON MISURABILE; i tagli a 100 lotti si")
  [void]$RefTxt.Add("       dichiarano come effetto TAGLIA (P1) PRIMA di leggere P2.")
  [void]$RefTxt.Add("  G5              : NESSUN deploy, per costruzione.")
  [void]$RefTxt.Add("")
  [void]$RefTxt.Add("--- LA TABELLA MADRE ---   (VERSI dichiarati, checklist 87: PROF col SEGNO;")
  [void]$RefTxt.Add("  PF piu' ALTO = meglio; DD% MAGNITUDINE POSITIVA, piu' BASSO = meglio; n in")
  [void]$RefTxt.Add("  USCITE; rifiuti = righe journal nuove del lancio col pattern del canarino;")
  [void]$RefTxt.Add("  vol max e righe a 100 dal per-trade CSV, n/d per C3 PER COSTRUZIONE.)")
  [void]$RefTxt.Add(("  {0,-22} {1,8} {2,5} {3,-10} {4,8} {5,8} {6,8} {7,6} {8,8} {9,8} {10,8}  {11}" -f `
                "LANCIO","DEPOSITO","LEVA","GAMBA","PROF","PF","DD%","n","RIFIUTI","VOLMAX","RIGHE100","ESITO"))
  foreach($lancioRef in $Ordinati){
    [void]$RefTxt.Add(("  {0,-22} {1,8} {2,5} {3,-10} {4,8} {5,8} {6,8} {7,6} {8,8} {9,8} {10,8}  {11}" -f `
                  $lancioRef.Id,$lancioRef.Passata.Deposito,$lancioRef.Passata.Leva,$lancioRef.Gamba,
                  (FmtE $lancioRef.Prof),(Fmt3 $lancioRef.Pf),(Fmt2 $lancioRef.Dd),(FmtN $lancioRef.N),
                  (FmtN $lancioRef.Rifiuti),(Fmt2 $lancioRef.VolMax),(FmtN $lancioRef.Righe100),$lancioRef.Esito))
  }
  [void]$RefTxt.Add("")
  [void]$RefTxt.Add("--- I DELTA CHE DECIDONO (criteri par. 3): P1-P0 = TAGLIA, P2-P1 = LEVA ---")
  [void]$RefTxt.Add("  (delta col segno; DD confrontati come magnitudini col verso dichiarato;")
  [void]$RefTxt.Add("   'identita' al centesimo' = profitto/PF/DD/n entro 0,005, n esatto)")
  foreach($cellaRef in $CelleScelte){
    $gambeCella = @("UNICA")
    if($cellaRef.Gambe -eq "ISOOS"){ $gambeCella = @("IS","OOS") }
    [void]$RefTxt.Add("  " + $cellaRef.Id + "   [" + $cellaRef.Misurabile + "]")
    [void]$RefTxt.Add("     archivio P0 (INFO): " + $cellaRef.InfoArchivio)
    foreach($gambaRef in $gambeCella){
      $suffRef = ""
      if($gambaRef -ne "UNICA"){ $suffRef = "_" + $gambaRef }
      $lancioP0 = TrovaLancio ($cellaRef.Id + "_P0" + $suffRef)
      $lancioP1 = TrovaLancio ($cellaRef.Id + "_P1" + $suffRef)
      $lancioP2 = TrovaLancio ($cellaRef.Id + "_P2" + $suffRef)
      if($null -eq $lancioP0 -or $null -eq $lancioP1 -or $null -eq $lancioP2){ continue }
      $etichettaGamba = ""
      if($gambaRef -ne "UNICA"){ $etichettaGamba = " (" + $gambaRef + ")" }
      [void]$RefTxt.Add("     P1-P0 (taglia)" + $etichettaGamba + ": dProf " + (FmtDelta $lancioP1.Prof $lancioP0.Prof) + "  dn " + $(if($lancioP1.N -ge 0 -and $lancioP0.N -ge 0){ ($lancioP1.N - $lancioP0.N).ToString("+0;-0;0",$INV) } else { "n/d" }) + "  PF " + (Fmt3 $lancioP0.Pf) + "->" + (Fmt3 $lancioP1.Pf) + "  DD% " + (Fmt2 $lancioP0.Dd) + "->" + (Fmt2 $lancioP1.Dd) + "  righe100 " + (FmtN $lancioP0.Righe100) + "->" + (FmtN $lancioP1.Righe100))
      [void]$RefTxt.Add("     P2-P1 (leva)  " + $etichettaGamba + ": dProf " + (FmtDelta $lancioP2.Prof $lancioP1.Prof) + "  dn " + $(if($lancioP2.N -ge 0 -and $lancioP1.N -ge 0){ ($lancioP2.N - $lancioP1.N).ToString("+0;-0;0",$INV) } else { "n/d" }) + "  PF " + (Fmt3 $lancioP1.Pf) + "->" + (Fmt3 $lancioP2.Pf) + "  DD% " + (Fmt2 $lancioP1.Dd) + "->" + (Fmt2 $lancioP2.Dd) + "  righe100 " + (FmtN $lancioP1.Righe100) + "->" + (FmtN $lancioP2.Righe100) + "  rifiuti P2: " + (FmtN $lancioP2.Rifiuti))
      [void]$RefTxt.Add("     INFO 'verdetto a mano': P2 identica a P1 al centesimo? " + (IdentitaAlCentesimo $lancioP2 $lancioP1) + "; P1 identica a P0 (attesa: n identico, resto scala con la taglia)? " + (IdentitaAlCentesimo $lancioP1 $lancioP0))
    }
  }
  [void]$RefTxt.Add("")
  [void]$RefTxt.Add("--- LA LETTURA PRE-DICHIARATA (criteri par. 6) - IL VERDETTO E' A MANO ---")
  [void]$RefTxt.Add("  [VERDE]  P2 IDENTICA a P1 al centesimo E zero rifiuti journal E zero righe")
  [void]$RefTxt.Add("           a 100 comparse in P2 che in P1 non c'erano -> sale senza riserve")
  [void]$RefTxt.Add("  [GIALLO] rifiuti su <= 5% degli INGRESSI di P1 (posizioni, ~n/2) E profitto")
  [void]$RefTxt.Add("           di finestra positivo E DD% entro il DD promesso -> sale SOLO")
  [void]$RefTxt.Add("           RIDOTTA (riduzione al 20% del conto, formula FASE 1 par. 3a, D7)")
  [void]$RefTxt.Add("  [ROSSO]  rifiuti > 5% degli ingressi O profitto che cambia segno O DD%")
  [void]$RefTxt.Add("           oltre il promesso -> NON sale a questa leva")
  [void]$RefTxt.Add("  [BIANCO] P0 non riproduce l'antenato (G4) -> NON MISURABILE")
  [void]$RefTxt.Add("  >>> non esiste un 'quasi verde': P2 diversa da P1 con ZERO rifiuti trovati")
  [void]$RefTxt.Add("      e' un'ANOMALIA da spiegare prima del verdetto, non un giallo d'ufficio.")
  [void]$RefTxt.Add("")
  [void]$RefTxt.Add("--- LISTA DELLE SEDIE AMMISSIBILI ALLA PROP (D10) - STAMPATA VUOTA, SI ---")
  [void]$RefTxt.Add("--- COMPILA A MANO NELLA DELIBERA D'ACQUISTO (cancello 6), NON QUI      ---")
  [void]$RefTxt.Add("  sedia (magic vivo)              verdetto        riduzione calcolata   note")
  [void]$RefTxt.Add("  ORB Dow (770611)                [        ]      [              ]      [                    ]")
  [void]$RefTxt.Add("  EMA200 Dow (771531)             [        ]      [              ]      [il metro gira a 1%: a fini margine e' PIU' severo della sedia a 0,65%]")
  [void]$RefTxt.Add("  MaxMinNotte DAX Short (770411)  [        ]      [              ]      [                    ]")
  [void]$RefTxt.Add("  SupRev oro (970901)             [        ]      [              ]      [                    ]")
  [void]$RefTxt.Add("  le altre ~27 sedie senza volumi agli atti: NON MISURATO per costruzione --")
  [void]$RefTxt.Add("  mai un verdetto per analogia (criteri par. 7).")
  [void]$RefTxt.Add("")
  [void]$RefTxt.Add("--- FILE ATTESI vs TROVATI ---")
  foreach($rigaAtteso in $AttesiTrovati){ [void]$RefTxt.Add("  " + $rigaAtteso) }
  [void]$RefTxt.Add("")
  if($Rilievi.Count -gt 0){
    [void]$RefTxt.Add("--- RILIEVI (NON sono guasti: sono RISULTATI o note del giro) ---   (" + $Rilievi.Count + ")")
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
  # --- L'ESITO DEL REFERTO DICE LE STESSE PAROLE DELLO SCHERMO e i gate
  #     ARRIVANO al codice d'uscita (checklist 84).
  $lanciKoRef = @($Ordinati | Where-Object { $_.Esito -ne "OK" -and $_.Esito -ne "SOLO CONTROLLO" -and $_.Esito -notlike "GIA' FATTO*" })
  if($Fatale -ne ""){
    [void]$RefTxt.Add("ESITO: FERMATO -- " + $Fatale)
  }
  elseif($CanarinoKo){
    [void]$RefTxt.Add("ESITO: ROUND FERMO DAL CANARINO (exit 2) -- il rilevatore dei rifiuti non ha")
    [void]$RefTxt.Add("morso sul controllo positivo: NESSUN 'zero rifiuti' delle celle e' leggibile.")
    [void]$RefTxt.Add("La diagnosi con la causa nominata sta nei PROBLEMI. Non e' un guasto del PC:")
    [void]$RefTxt.Add("e' il gate 84-bis che fa il suo mestiere.")
  }
  elseif($SoloControllo){
    if($lanciKoRef.Count -gt 0 -or $Problemi.Count -gt 0){
      [void]$RefTxt.Add("ESITO: GIRO A VUOTO CON PROBLEMI (" + $Problemi.Count + ") -- NON lanciare la corsa vera prima di aver letto i PROBLEMI.")
    } else {
      [void]$RefTxt.Add("ESITO: GIRO A VUOTO COMPLETATO -- .ini verificati e sonde G-SPEC stampate. NESSUN numero di round: QUESTO ZIP NON E' IL ROUND.")
    }
  }
  elseif($lanciKoRef.Count -gt 0){
    [void]$RefTxt.Add("ESITO: PARZIALE -- " + $lanciKoRef.Count + " lanci su " + $Ordinati.Count + " senza numeri leggibili, piu' " + $Problemi.Count + " problemi. NON e' un round completo.")
  }
  elseif($Problemi.Count -gt 0){
    [void]$RefTxt.Add("ESITO: COMPLETO CON PROBLEMI -- tutti i " + $Ordinati.Count + " lanci hanno numeri, ma ci sono " + $Problemi.Count + " problemi. I numeri si leggono ACCANTO ai problemi.")
  }
  elseif($Rilievi.Count -gt 0){
    [void]$RefTxt.Add("ESITO: COMPLETO CON RILIEVI -- tutti i " + $Ordinati.Count + " lanci hanno numeri. I " + $Rilievi.Count + " rilievi vanno letti.")
  }
  else{
    [void]$RefTxt.Add("ESITO: OK -- tutti i lanci hanno prodotto i numeri attesi, canarino morso, nessun problema.")
  }
  [void]$RefTxt.Add("")
  [void]$RefTxt.Add("--- COME SI RIPRENDE ---")
  [void]$RefTxt.Add('  una cella sola : ... & $p -Pin <PIN> -SoloCella R114_C2_MAXMIN.txt')
  [void]$RefTxt.Add('  rifare cio'' che c''e'' gia'' : aggiungi -Rifai')
  [void]$RefTxt.Add("  >>> -SoloCella prende la cella INTERA (P0 e' il denominatore di P1/P2).")
  [void]$RefTxt.Add("      Canarino e sonde girano a OGNI corsa vera: il rilevatore si riprova.")
  [void]$RefTxt.Add("  >>> un lancio con CSV gia' presente viene RACCOLTO con l'eta' dichiarata")
  [void]$RefTxt.Add("      (checklist 88); i suoi rifiuti journal restano n/d (non rimisurabili).")
  [void]$RefTxt.Add("  >>> i tre puntini stanno per IL BLOCCO INTERO della riga di lancio:")
  [void]$RefTxt.Add("      si riprende da RIGA_R114_DA_MANDARE.md.")

  Set-Content -LiteralPath $Referto -Value ($RefTxt -join "`r`n") -Encoding UTF8
  if(Test-Path -LiteralPath $Zip){ Remove-Item -LiteralPath $Zip -Force -ErrorAction SilentlyContinue }
  Compress-Archive -Path (Join-Path $Cart "*") -DestinationPath $Zip -Force
}catch{
  Write-Host ("!!! RACCOLTA PARZIALE: " + $_.Exception.Message) -ForegroundColor Red
}

Write-Host ""
Write-Host "=====================================================================" -ForegroundColor White
Write-Host "  R114 - FINE" -ForegroundColor White
function RigaFinale([string]$percorsoFinale,[string]$codaFinale){
  if(Test-Path -LiteralPath $percorsoFinale){ Write-Host ("   " + $percorsoFinale + "   " + $codaFinale) -ForegroundColor White }
  else                                      { Write-Host ("   " + $percorsoFinale + "   <<< NON ESISTE") -ForegroundColor Red }
}
RigaFinale $Cart    ""
RigaFinale $Zip     "<- e' questo che mi mandi"
RigaFinale $Referto "<- la riga 'data:' deve essere di ADESSO, la riga 'modo:' dice se e' il round o un giro a vuoto"
Write-Host "=====================================================================" -ForegroundColor White
foreach($lancioFinale in $Ordinati){
  $coloreFinale = "Green"
  if($lancioFinale.Esito -ne "OK" -and $lancioFinale.Esito -ne "SOLO CONTROLLO"){ $coloreFinale = "Yellow" }
  Write-Host ("   " + $lancioFinale.Id.PadRight(22) + " " + $lancioFinale.Esito) -ForegroundColor $coloreFinale
}
if($Rilievi.Count -gt 0){
  Write-Host ""
  Write-Host "   RILIEVI (risultati o note del giro, NON guasti):" -ForegroundColor Yellow
  foreach($rilievoFin in $Rilievi){ Write-Host ("    - " + $rilievoFin) -ForegroundColor Yellow }
}
if($Problemi.Count -gt 0){
  Write-Host ""
  Write-Host "   PROBLEMI DA LEGGERE:" -ForegroundColor Red
  foreach($problemaFin in $Problemi){ Write-Host ("    - " + $problemaFin) -ForegroundColor Red }
}
Write-Host ""
# =====================================================================
#  CODICI D'USCITA (checklist 84: la lista che decide e' la stessa del
#  referto): 0 = OK / COMPLETO CON RILIEVI; 1 = parziale, fermato, con
#  problemi o selettore a vuoto; 2 = criteri non firmati O CANARINO CHE
#  NON MORDE (round fermo, checklist 84-bis).
# =====================================================================
if($Fatale -ne ""){ Write-Host ("ESITO: FERMATO -- " + $Fatale) -ForegroundColor Red; exit 1 }
if($CanarinoKo){
  Write-Host "ESITO: ROUND FERMO DAL CANARINO (il rilevatore non morde: exit 2). Lo zip esiste: mandalo, la diagnosi e' nei PROBLEMI." -ForegroundColor Red
  exit 2
}
$lanciKoFinali = @($Ordinati | Where-Object { $_.Esito -ne "OK" -and $_.Esito -ne "SOLO CONTROLLO" -and $_.Esito -notlike "GIA' FATTO*" })
if($SoloControllo){
  if($lanciKoFinali.Count -gt 0 -or $Problemi.Count -gt 0){
    Write-Host ("ESITO: GIRO A VUOTO CON PROBLEMI (" + $Problemi.Count + ") -- c'e' da leggere il referto") -ForegroundColor Yellow
    exit 1
  }
  Write-Host "ESITO: GIRO A VUOTO COMPLETATO -- .ini verificati, sonde G-SPEC stampate. QUESTO ZIP NON E' IL ROUND." -ForegroundColor Green
  exit 0
}
if($lanciKoFinali.Count -gt 0){
  Write-Host ("ESITO: PARZIALE (" + $lanciKoFinali.Count + " lanci su " + $Ordinati.Count + " senza numeri leggibili, " + $Problemi.Count + " problemi) -- lo zip esiste: mandalo") -ForegroundColor Yellow
  exit 1
}
if($Problemi.Count -gt 0){
  Write-Host ("ESITO: COMPLETO CON PROBLEMI (" + $Problemi.Count + ") -- i numeri ci sono TUTTI, ma vanno letti ACCANTO ai problemi. Lo zip esiste: mandalo." ) -ForegroundColor Yellow
  exit 1
}
if($Rilievi.Count -gt 0){
  Write-Host ("ESITO: COMPLETO CON RILIEVI (" + $Rilievi.Count + " rilievi da leggere nel referto)") -ForegroundColor Green
  exit 0
}
Write-Host "ESITO: OK" -ForegroundColor Green
exit 0
