# =====================================================================
#  MARCATORE_RIGA_R110_v1
#  RIGA_R110_LATI_VIVI.ps1  --  R110: I LATI MAI MISURATI DEI MOTORI
#  VIVI SUGLI INDICI. Quattro sedie che girano LONG+SHORT insieme, e il
#  cui lato short non ha MAI avuto un numero suo:
#     SUPNAS  ABTG_SupRev_NAS_H1_Ottimizzato    NASUSD H1  (viva 970913)
#     SUPDAX  ABTG_SupRev_DAX_H4_Ottimizzato    D30EUR H4  (viva 970912)
#     SWDOW   ABTG_SuperWave_DOW_H1_Ottimizzato U30USD H1  (viva 770511)
#     EMADOW  ABTG_EMA200                       U30USD H1  (viva 771531)
# ---------------------------------------------------------------------
#  CRITERI:   backtest_pipeline\risultati_archivio\R110_CRITERI.md
#  PERIMETRO: risultati_archivio\CENSIMENTO_LATI_SHORT_2026-08-25.md
#             tabella 1d + par. 5 (proposte 1 e 2)
#    (Claudio, sera del 25/08/2026, dopo i verdetti short di R107:
#     "non si possono provare i vari motori?")
#
#  >>> I CRITERI SONO [DA FIRMARE] (CINQUE decisioni, par. 10). Questo
#      driver LEGGE il file dei criteri al pin e, se ci trova ancora la
#      stringa del lucchetto, la CORSA VERA non parte (exit 2). Il GIRO
#      A VUOTO parte lo stesso: non apre MT5, non produce nessun numero,
#      e serve proprio a far leggere i criteri prima di firmarli.
#      -CriteriFirmati e' la firma IN RIGA di Claudio, e finisce scritta
#      nel referto.
#
#  DA DOVE NASCE, dichiarato: e' RIGA_R107_LATI_SHORT.ps1
#  (MARCATORE_RIGA_R107_v1, girata il 25/08 in 9 minuti con 0 guasti)
#  adattata da TRE famiglie a QUATTRO, da DUE celle per famiglia a TRE,
#  e da un TF unico (M5) a QUATTRO TF PER FAMIGLIA. Il punto 9 della
#  checklist dice che una riscrittura non puo' perdere le funzioni di
#  sicurezza del gemello: sono state riportate TUTTE, una per una --
#  guardia MT5/MetaEditor chiusi, -Pin senza default, gate della firma
#  dei criteri, pin di $EABranch DENTRO il driver generico, [Charts]
#  MaxBars con gate sullo stato finale, install di ABTG_PausaGuardian.mqh,
#  gate delle righe vive, gate della STELLA, gate dei VALORI, gate dei
#  MAGIC, compilazione DIRETTA col verdetto LastWriteTime + backup datato
#  + ripristino del .mq5 se fallisce, SOSTA SVUOTATA A OGNI GIRO,
#  funzioni e variabili della raccolta SOPRA il try, MODO nel nome della
#  cartella e nel referto, pulizia PER NOME e MAI a wildcard, cultura
#  INVARIANTE, \r? davanti a ogni $ multilinea, raccolta SEMPRE, exit
#  ESPLICITO su ogni ramo, sentinella su TUTTE le colonne.
#
#  ------------------------------------------------------------------
#  COSA CAMBIA RISPETTO A R107, e perche'
#
#  (71) [CmdletBinding()] SOPRA param(). E' il difetto trovato su R108 e
#       dichiarato "di FAMIGLIA": in dodici driver di round su dodici
#       mancava. Senza, un refuso in un interruttore (-SoloControlo con
#       una L sola) NON e' un errore: finisce in $args, lo script
#       prosegue, e quella che doveva essere l'anteprima da un minuto
#       diventa LA CORSA VERA. Con [CmdletBinding()] e' un errore di
#       binding TERMINANTE, prima che si tocchi MT5.
#       Prerequisito verificato: questo script non usa $args da nessuna
#       parte.
#
#  (72) IL GATE DELL'ANTENATO, ed e' il gate che in R110 MORDE DAVVERO.
#       Il gate della stella confronta le celle FRA LORO, e "un diff fra
#       A e B non puo' accorgersi di niente che sia uguale in A e in B":
#       una riga storta in TUTTE E TRE le celle di una famiglia
#       passerebbe la stella e cambierebbe il motore. Percio' il
#       00_metro (e anche i due lati) si confronta con l'ANTENATO
#       scaricato al pin -- il file prova che ha girato in R103 su
#       QUESTA STESSA SEDIA -- con la lista dei SOLI delta ammessi.
#       >>> E IL CONFRONTO E' PER NOME, MAI PER POSIZIONE (punto 58
#           applicato alle righe): l'antenato puo' avere una riga in
#           piu' o in meno, e un confronto posizionale sfaserebbe tutto
#           il resto accusando quaranta righe sane.
#
#  (---) IL METRO NUMERICO NON ESISTE, E IL CODICE LO DICE. In R107 il
#       gate G0 confrontava PF/DD/n con i numeri agli atti. QUI NON SI
#       PUO': R103 (l'unico posto con i numeri di queste quattro sedie)
#       girava a MODELLO 1 (OHLC su M1) su UNA FINESTRA UNICA di 21
#       mesi; R110 gira a MODELLO 4 (tick reali) con lo split 40/60. Due
#       banchi diversi e due finestre diverse. Percio' il referto scrive
#       "G0-B NON APPLICABILE" su TUTTE E QUATTRO le famiglie -- e
#       "non applicabile" NON E' "superato". Al suo posto mordono G0-A
#       (l'antenato) e G0-C (i gemelli identici al centesimo).
#
#  (---) LA SOMMA DEI LATI NON RIPRODUCE IL METRO, E NON E' UN DIFETTO.
#       MISURATO NEL SORGENTE: tutti e quattro i motori aprono la
#       funzione di ingresso con "se ho gia' una posizione (o un
#       pendente) esco", e SOLO DOPO guardano il lato. Con un lato
#       spento lo slot resta libero. Il referto stampa i tre n accanto
#       con la frase che spiega perche' non tornano: e' un RILIEVO
#       (risultato), mai un problema.
#
#  (51)  ALLOWLIVETRADING=FALSE VERIFICATO, non sperato. Il driver
#       generico lo scrive nei suoi .ini (righe 507 e 638): qui si
#       CONTA che ci sia due volte nel file scaricato al pin, perche'
#       aprire MT5 per MISURARE non deve poter riarmare la flotta.
#
#  (66)  LA SENTINELLA SU TUTTE LE COLONNE. profitto, PF, DD, n E
#       peggior giornata. E la peggior giornata ha il sentinella IN
#       ALTO (99.9), perche' negli artefatti veri e' SEMPRE negativa.
#
#  (63)  NESSUN HASHTABLE LETTERALE MULTILINEA: le tabelle nascono da
#       funzioni e da assegnazioni separate. E il parse e' stato FATTO,
#       non dichiarato impossibile.
#
#  (68)  IL TERZO STATO. L'esito non e' binario: 0 = OK / COMPLETO CON
#       RILIEVI ; 1 = PARZIALE / FERMATO / CON PROBLEMI / SELETTORE A
#       VUOTO ; 2 = criteri non firmati.
#  ------------------------------------------------------------------
#
#  COSA FA, in ordine, e DA SOLA:
#    0.     si rifiuta di partire se MT5 O MetaEditor sono aperti
#    0-bis. si rifiuta di CORRERE se i criteri non sono firmati
#    1.     scarica AL PIN: walkforward_generico.ps1, i 12 file prova,
#           i 4 file prova ANTENATI di R103, i 4 sorgenti .mq5 e
#           l'include ABTG_PausaGuardian.mqh
#           - GATE DI VERSIONE sui .mq5 + i due input dei lati
#           - GATE DELLE RIGHE VIVE (45 / 45 / 47 / 46)
#           - GATE DELL'ANTENATO (checklist 72)
#           - GATE DELLA STELLA (metro contro i due lati)
#           - GATE DEI VALORI (i lati, e la geometria d'identita')
#           - GATE DELL'ASSE UNICO (un solo Y, ed e' InpMagic)
#           - GATE DEI MAGIC (unici, vergini, mai uno vivo)
#    2.     FASE COMPILA, un EA alla volta, invocazione DIRETTA di
#           metaeditor64.exe, verdetto sul LastWriteTime del .ex5
#    3.     PASSO 0 PER FAMIGLIA = la cella 00_metro. Da li' escono:
#             (a) G0-C IGIENE GEMELLI (fatale per la famiglia)
#             (b) G0-B: NON APPLICABILE, dichiarato (non e' "superato")
#             (c) IL CANARINO: n IS e n OOS. NON BLOCCA (regola B)
#    4.     le celle 01_long e 02_short della famiglia
#    5.     raccolta SEMPRE: cartella sul Desktop + zip + REFERTO con la
#           TABELLA MADRE, la riga della SOMMA DEI LATI e la SPINA
#           DORSALE.
#
#  QUELLO CHE NON FA, dichiarato:
#    - NON GIUDICA. Produce i CSV, li conta, e mette a referto i delta
#      contro il metro. I cancelli G1-G5 li applica il REFERTO del
#      round, non questa riga. In particolare NON applica G3 (coerenza
#      cross-motore): e' un ragionamento su QUATTRO tabelle.
#    - NON promuove niente e NON tocca il forward. Magic VERGINI 763xxx
#      (24 numeri verificati a ZERO occorrenze in tutto il repo il
#      25/08). Sono vietati e controllati i quattro magic VIVI di questo
#      round e anche 970911 (SupRev DAX H1, che NON risulta in nessuno
#      dei due censimenti .chr: un'identita' non in campo resta
#      occupata).
#    - NON scarica i TICK e non svuota bases\<server>\ticks. Sono gia'
#      MISURATI e agli atti per NASUSD, D30EUR e U30USD dal 2024.09.26
#      (REFERTO_SONDA_STORICO_17-08.md, verdetto COMPLETO).
#    - non misura lo spread, non misura i sotto-periodi, non fa la prova
#      di regime, e non inventa nessun numero non letto in un artefatto.
#    - non scrive una riga di MQL5.
#    - non ammazza un lavoro in corso allo scadere di -OreMax: smette
#      solo di iniziarne di nuovi (checklist 19).
#
#  QUANTO CI METTE: [STIMA], non una previsione. 12 file x 2 finestre x
#  2 celle gemelle = 48 passate a tick reali. R107 ne fece 24 sulla
#  STESSA finestra in 9 minuti (21:14-21:23, referto agli atti). Stima
#  20-45 minuti piu' la compilazione di quattro EA. -OreMax e' 10, che
#  e' un tetto sull'INIZIO di nuovi file, con margine largo apposta.
#  >>> IL n ALTO DI EMADOW (712 in R103) NON ALLUNGA LA CORSA: a tick
#      reali il tempo lo fa il NUMERO DI TICK della finestra, non il
#      numero di operazioni.
#
#  LA RIGA CHE SI INCOLLA (blocco INTERO, un comando solo - checklist 21).
#  <PIN> = il commit che contiene QUESTO file: e' l'hash dato in chat.
#
#  & { $ErrorActionPreference='Stop'; [Net.ServicePointManager]::SecurityProtocol=[Net.SecurityProtocolType]::Tls12;
#      if(Get-Process terminal64,metaeditor64 -EA SilentlyContinue){ throw 'MT5 O METAEDITOR APERTO: chiudili e rilancia.' };
#      $pin='<PIN>'; $p="$env:USERPROFILE\RIGA_R110.ps1"; Remove-Item $p -EA SilentlyContinue;
#      irm "https://raw.githubusercontent.com/claudiospadaro12/GITHUB/$pin/backtest_pipeline/righe/RIGA_R110_LATI_VIVI.ps1" -OutFile $p;
#      if(-not (Select-String -Path $p -SimpleMatch -Pattern 'MARCATORE_RIGA_R110_v1' -Quiet)){ throw 'SCRIPT VECCHIO' };
#      $global:LASTEXITCODE=0; & $p -Pin $pin -SoloControllo; if($LASTEXITCODE -ne 0){ Write-Host 'ESITO: PARZIALE O FERMO - leggi il REFERTO' } }
#
#  GIRO A VUOTO: e' quello qui sopra (-SoloControllo). Scrive e verifica
#  GLI STESSI .ini che girano nella corsa vera. Non c'e' un secondo
#  artefatto (checklist 33).
#  >>> E NON MISURA NESSUN NUMERO: senza tester non esiste nessun n,
#      nessun PF, nessun DD, nessun canarino, nessun G0-C. Sta scritto
#      anche nel suo referto, perche' non lo si scambi per il round.
# =====================================================================
[CmdletBinding()]
param(
  # -Pin NON ha default: un default silenzioso ("lavoro") farebbe girare la
  #  punta del branch spacciandola per un commit congelato. Meglio morire.
  [string]$Pin        = "",
  [double]$OreMax     = 10.0,      # oltre questo NON si iniziano nuovi file
  [switch]$Rifai,                  # rifa' anche i CSV gia' presenti
  [switch]$SoloControllo,          # giro a vuoto: NON apre MT5
  [switch]$CriteriFirmati,         # >>> lo preme CLAUDIO, non l'agente. Senza,
                                   #     la corsa vera non parte (exit 2).
  [string]$SoloEa     = "",        # "SUPNAS"|"SUPDAX"|"SWDOW"|"EMADOW", anche
                                   #  in elenco: 'SWDOW,EMADOW'. FRA APICI.
  [string]$SoloCella  = ""         # es. "R110_EMADOW_02_short.txt": una cella
                                   #     sola (il 00_metro della sua famiglia
                                   #      gira lo stesso: e' il denominatore e
                                   #      porta il gate G0-C)
)
$ErrorActionPreference = "Stop"
[Threading.Thread]::CurrentThread.CurrentCulture   = [Globalization.CultureInfo]::InvariantCulture
[Threading.Thread]::CurrentThread.CurrentUICulture = [Globalization.CultureInfo]::InvariantCulture
[Net.ServicePointManager]::SecurityProtocol = [Net.SecurityProtocolType]::Tls12
$INV = [Globalization.CultureInfo]::InvariantCulture

$Avvio  = Get-Date
$Stamp  = $Avvio.ToString("yyyyMMdd_HHmm", $INV)
$Dsk    = Join-Path $env:USERPROFILE "Desktop"
$Work   = Join-Path $env:USERPROFILE "abtg_r110"
$Prove  = Join-Path $Work "prove"
$Anten  = Join-Path $Work "antenati"
$Logs   = Join-Path $Work "log_r110"
$SrcDir = Join-Path $Work "src_motori"
$RawPin = "https://raw.githubusercontent.com/claudiospadaro12/GITHUB/$Pin"

#--- LA FINESTRA. Identica a R88/R97/R98/R101/R107: e' l'unico modo di
#    leggere R110 accanto a R107 senza barare. Criteri R110 par. 4.
#    >>> NIENTE CODA 2026.07-08: allungare $Fino sposterebbe anche il
#        punto di split al 40%, quindi cambierebbe SIA l'IS SIA l'OOS.
#        Qui la regola ha il suo if: questi due valori sono FISSI e
#        @DAQUANDO viene CONFRONTATO in ogni file prova.
$DaQuando = "2024.09.26"      # muro del feed BCM sugli indici, MISURATO
$Fino     = "2026.06.30"
$Modello  = 4                 # 4 = TICK REALI
$Deposito = 100000            # taglia prop, come R46/R54/R101/R107
$SpreadIni= 0                 # 0 = spread CORRENTE, ma SCRITTO nell'ini invece
                              #  che lasciato allo stato nascosto del terminale.
                              #  NON e' uno stress e NON e' una misura.
$FrazioneIS  = 0.40           # default di walkforward_generico.ps1
$CelleAttese = 2              # le due passate GEMELLE di controllo, per CSV

#--- I MAGIC VIETATI: i QUATTRO VIVI di questo round, il magic della
#    sedia SupRev DAX H1 (che NON risulta in nessuno dei due censimenti
#    .chr: un'identita' non in campo resta occupata), il default del
#    sorgente EMA200, le sedie confinanti sugli stessi motori e sugli
#    stessi simboli, e i blocchi dei round recenti.
$MagicVietati = @(970913,970912,770511,771531,   # <<< LE QUATTRO SEDIE VIVE
                  970911,                        # SupRev DAX H1: non in campo
                  970914,                        # SupRev DOW H4: REVOCATA
                  771501,                        # default del sorgente EMA200
                  770901,770923,770924,770925,   # SupertrendReversal nativi
                  770512,770531,770532,          # SuperWave DAX H4 / H2
                  771511,771512,771513,771514,771515,971501,   # famiglia EMA200
                  970901,                        # SupRev oro
                  770101,770202,770611,770601,770411,          # aperture/ORB/notte
                  771321,771322,771323,771332,772341,          # PTE / Larry
                  772601,772602,772611,772612,   # R54
                  772800,772890,772891,          # R98
                  773200,773201,773300,773301,   # R101
                  750010,750011)                 # R104

# =====================================================================
#  LE QUATTRO FAMIGLIE. Ogni riga e' una SEDIA VIVA, col suo TF, il suo
#  ANTENATO R103 e il suo numero R103 -- che NON e' un metro.
#
#  >>> DA DOVE VIENE OGNI COLONNA (criteri R110 par. 2):
#      - Ea / Ver / MagicSrc : LETTI NEL SORGENTE al pin (25/08)
#      - MagicVivo           : censimento .chr del 25/08/2026 07:31
#                              (censimento_rischio_2026-08-25_0731.txt)
#      - Per                 : il TF DEL GRAFICO, che NON si deriva da
#                              InpTF e viceversa (trappola pagata in
#                              R102). Fonte: il file prova R103, riga
#                              @PERIODO, piu' FLOTTA_ATTIVA.md
#      - Antenato            : il file prova che ha girato in R103
#      - R103                : il numero R103, che sta qui come CONTESTO
#                              DICHIARATO NON CONFRONTABILE (par. 5,
#                              G0-B). MAI come gate.
#      - RigheVive           : MISURATE sui file il 25/08 con
#                              grep -cvE '^\s*(#|$)', non a memoria
#
#  >>> CHECKLIST 64: OGNI parametro e' TIPIZZATO. Senza il tipo, un
#      argomento posizionale negativo arriva come STRINGA, e
#      "stringa -gt 0" e' un confronto culture-aware: VERO su Windows
#      PowerShell 5.1 e FALSO sul pwsh/Linux del verificatore. E' il
#      difetto che il 23/08 fermo' la famiglia DAX di R101 al gate G0
#      CON IL METRO RIPRODOTTO.
# =====================================================================
function F([string]$id,[string]$ea,[string]$ver,[string]$sym,[string]$per,
           [string]$magicSrc,[string]$magicVivo,[int]$righe,
           [string]$antenato,[string]$r103,[string]$nota){
  return [pscustomobject]@{
    Id=$id; Ea=$ea; Ver=$ver; Sym=$sym; Per=$per; MagicSrc=$magicSrc;
    MagicVivo=$magicVivo; RigheVive=$righe; Antenato=$antenato; R103=$r103; Nota=$nota;
    # --- riempiti durante la corsa
    Compilato=$false; Antenati="NON VERIFICATO"; Metro="NON MISURATO"; Gemelli="NON MISURATO";
    NIS=-1; NOOS=-1; PfOOS=-1.0; DdOOS=-1.0; ProfOOS=-999999.0;
    Esito="NON ESEGUITA"
  }
}
$FAMIGLIE = @(
  (F "SUPNAS" "ABTG_SupRev_NAS_H1_Ottimizzato"    "1.00" "NASUSD" "H1" "970913" "970913" 45 `
      "R103_ABTG_SupRev_NAS_H1_Ottimizzato_NASUSD_970913.txt" `
      "+6.765 | PF 1,65 | DD 1,48% | n 172   (R103, OHLC M1, 21 mesi pieni)" `
      "LA PROP-FRIENDLY: il DD piu' basso del parco indici."),
  (F "SUPDAX" "ABTG_SupRev_DAX_H4_Ottimizzato"    "1.00" "D30EUR" "H4" "970912" "970912" 45 `
      "R103_ABTG_SupRev_DAX_H4_Ottimizzato_D30EUR_970912.txt" `
      "+7.856 | PF 2,05 | DD 4,22% | n 99   (R103, OHLC M1, 21 mesi pieni)" `
      "IL CAMPIONE PIU' SOTTILE del round: n 99 su 21 mesi INTERI. Un lato solo, sul solo OOS, puo' finire sotto G1."),
  (F "SWDOW"  "ABTG_SuperWave_DOW_H1_Ottimizzato" "1.00" "U30USD" "H1" "770511" "770511" 47 `
      "R103_ABTG_SuperWave_DOW_H1_Ottimizzato_U30USD_770511.txt" `
      "+7.280 | PF 1,28 | DD 4,14% | n 290   (R103, OHLC M1, 21 mesi pieni)" `
      "Il secondo campione piu' grasso degli indici."),
  (F "EMADOW" "ABTG_EMA200"                       "1.00" "U30USD" "H1" "771501" "771531" 46 `
      "R103_ABTG_EMA200_U30USD_771531.txt" `
      "+30.647 | PF 1,42 | DD 6,48% | n 712   (R103, OHLC M1, 21 mesi pieni)" `
      "IL CAMPIONE PIU' GRASSO DI CASA: 712 operazioni. L'unico posto del parco dove un LATO DA SOLO puo' arrivare a n>=150 su questa finestra. >>> E il magic del SORGENTE (771501) NON e' quello della SEDIA (771531): sono tre numeri diversi col magic del file prova.")
)

# =====================================================================
#  LE DODICI CELLE. Tre per famiglia, e cambia UN LATO PER VOLTA.
#  'Diff' = gli input che DEVONO differire dal 00_metro della stessa
#  famiglia, e NESSUN ALTRO. Contare "2 righe diverse" non basterebbe:
#  DUE righe SBAGLIATE darebbero lo stesso conteggio.
#  'Val' = quanto valgono i due lati IN QUESTO FILE: il diff dice CHE
#  cambia, questo dice CHE COSA vale. Se due file di una famiglia
#  fossero SCAMBIATI, il diff resterebbe verde e questo no (34-bis).
#  >>> V2 e' una FUNZIONE apposta per non scrivere hashtable letterali
#      multilinea: e' la classe di difetto 63, che non e' un errore di
#      runtime ma di PARSE, e nessuna guardia interna la intercetta.
#  >>> I VALORI SONO 'true'/'false', NON 1/0: e' cosi' che li scrivono i
#      file prova di questa famiglia di motori (input di tipo bool).
# =====================================================================
function V2([string]$lungo,[string]$corto){
  $h = @{}
  $h["InpAllowLong"]  = $lungo
  $h["InpAllowShort"] = $corto
  return $h
}
function C([string]$fam,[string]$id,[string]$file,[string]$desc,[int]$magic,
           $diff,$val,[bool]$metro){
  return [pscustomobject]@{ Fam=$fam; Id=$id; Prova=$file; Desc=$desc; Magic=$magic;
                            Diff=@($diff); Val=$val; Metro=$metro;
                            Esito="NON ESEGUITO"; IS=-1; OOS=-1; Min=0.0;
                            PfOOS=-1.0; DdOOS=-1.0; ProfOOS=-999999.0; NOOS=-1; PgOOS=99.9;
                            PfIS=-1.0;  DdIS=-1.0;  ProfIS=-999999.0;  NIS=-1;
                            Gemelli="NON MISURATO"; Antenato="NON VERIFICATO" }
}
$SOLOL = @("InpAllowShort")   # cio' che 01_long muove rispetto al metro
$SOLOS = @("InpAllowLong")    # cio' che 02_short muove rispetto al metro
$CELLE = @()
$CELLE += (C "SUPNAS" "00_metro" "R110_SUPNAS_00_metro.txt" "LA CELLA VIVA COM'E' (L+S) -- porta il gate dell'ANTENATO e i gemelli"         763000 @()    (V2 "true" "true")  $true)
$CELLE += (C "SUPNAS" "01_long"  "R110_SUPNAS_01_long.txt"  "SOLO LONG -- il denominatore del lato short"                                   763010 $SOLOL (V2 "true" "false") $false)
$CELLE += (C "SUPNAS" "02_short" "R110_SUPNAS_02_short.txt" "SOLO SHORT -- LA MISURA NUOVA (mai fatta su questa sedia)"                     763020 $SOLOS (V2 "false" "true") $false)
$CELLE += (C "SUPDAX" "00_metro" "R110_SUPDAX_00_metro.txt" "LA CELLA VIVA COM'E' (L+S) -- porta il gate dell'ANTENATO e i gemelli"         763100 @()    (V2 "true" "true")  $true)
$CELLE += (C "SUPDAX" "01_long"  "R110_SUPDAX_01_long.txt"  "SOLO LONG -- il denominatore del lato short"                                   763110 $SOLOL (V2 "true" "false") $false)
$CELLE += (C "SUPDAX" "02_short" "R110_SUPDAX_02_short.txt" "SOLO SHORT -- campione atteso il piu' sottile del round (H4)"                  763120 $SOLOS (V2 "false" "true") $false)
$CELLE += (C "SWDOW"  "00_metro" "R110_SWDOW_00_metro.txt"  "LA CELLA VIVA COM'E' (L+S) -- porta il gate dell'ANTENATO e i gemelli"         763200 @()    (V2 "true" "true")  $true)
$CELLE += (C "SWDOW"  "01_long"  "R110_SWDOW_01_long.txt"   "SOLO LONG -- il denominatore del lato short"                                   763210 $SOLOL (V2 "true" "false") $false)
$CELLE += (C "SWDOW"  "02_short" "R110_SWDOW_02_short.txt"  "SOLO SHORT -- LA MISURA NUOVA (mai fatta su questa sedia)"                     763220 $SOLOS (V2 "false" "true") $false)
$CELLE += (C "EMADOW" "00_metro" "R110_EMADOW_00_metro.txt" "LA CELLA VIVA COM'E' (L+S) -- porta il gate dell'ANTENATO e i gemelli"         763300 @()    (V2 "true" "true")  $true)
$CELLE += (C "EMADOW" "01_long"  "R110_EMADOW_01_long.txt"  "SOLO LONG -- il denominatore del lato short"                                   763310 $SOLOL (V2 "true" "false") $false)
$CELLE += (C "EMADOW" "02_short" "R110_EMADOW_02_short.txt" "SOLO SHORT -- L'UNICA CELLA DEL ROUND che puo' arrivare a n>=150"              763320 $SOLOS (V2 "false" "true") $false)

# =====================================================================
#  LA GEOMETRIA D'IDENTITA', PRETESA RIGA PER RIGA IN OGNI FILE della
#  famiglia. Non e' ridondanza col gate dell'antenato: l'antenato
#  garantisce che i file di R110 siano uguali a quelli di R103, QUESTO
#  garantisce che siano la cella che i criteri descrivono. Se qualcuno
#  corrompesse ANCHE gli antenati in repo, l'antenato resterebbe verde
#  e questo no.
#
#  >>> InpAllowLong e InpAllowShort NON SONO IN QUESTE LISTE: sono
#      L'ASSE DEL ROUND, e il loro valore lo pretende il gate 'Val'
#      della singola cella.
#  >>> InpTF E' IL TF CHE L'EA LEGGE, @PERIODO E' IL TF DEL GRAFICO NEL
#      TESTER. Sono due cose diverse e qui si controllano TUTTE E DUE:
#      e' la trappola di R102 (ABTG_SuperWave GBPUSD gira su un grafico
#      H4 con InpTF = H2).
#
#  >>> NIENTE HASHTABLE LETTERALE MULTILINEA (checklist 63): quattro
#      assegnazioni separate, cosi' non esiste nessuna virgola a fine
#      riga che possa continuare l'espressione.
#
#  Fonti: i quattro file prova R103, letti riga per riga il 25/08.
# =====================================================================
$VIVA = @{}
$VIVA["SUPNAS"] = @(@("InpTF","16385"),@("InpStMult","3.0"),@("InpStAtrPeriod","10"),
                    @("InpNearAtr","1.0"),@("InpRequireConfirmBody","true"),
                    @("InpUseConfluence","true"),@("InpConflAtr","1.5"),
                    @("InpSLLookback","5"),@("InpTP1_R","1.0"),@("InpTP_RR","3.0"),
                    @("InpTrailOnST","true"),@("InpExitOnFlip","true"),
                    @("InpRiskPercent","1.0"),@("InpUseTimeWindow","false"),
                    @("InpUseNewsFilter","false"),@("InpMaxSpread","0"))
$VIVA["SUPDAX"] = @(@("InpTF","16388"),@("InpStMult","3.0"),@("InpStAtrPeriod","9"),
                    @("InpNearAtr","1.0"),@("InpRequireConfirmBody","true"),
                    @("InpUseConfluence","true"),@("InpConflAtr","1.5"),
                    @("InpSLLookback","5"),@("InpTP1_R","1.0"),@("InpTP_RR","3.0"),
                    @("InpTrailOnST","true"),@("InpExitOnFlip","true"),
                    @("InpRiskPercent","1.0"),@("InpUseTimeWindow","false"),
                    @("InpUseNewsFilter","false"),@("InpMaxSpread","0"))
$VIVA["SWDOW"]  = @(@("InpTF","16385"),@("InpStMult","2.5"),@("InpStAtrPeriod","10"),
                    @("InpNearAtr","1.0"),@("InpRequireConfirmBody","true"),
                    @("InpUseConfluence","false"),@("InpSLLookback","5"),
                    @("InpTP1_R","1.0"),@("InpTP_RR","3.0"),
                    @("InpTrailOnST","true"),@("InpExitOnFlip","true"),
                    @("InpRiskPercent","1.0"),@("InpUseTimeWindow","false"),
                    @("InpUseNewsFilter","false"),@("InpMaxSpread","0"))
$VIVA["EMADOW"] = @(@("InpTF","16385"),@("InpEmaPeriod","200"),@("InpEma14Period","14"),
                    @("InpAtrPeriod","14"),@("InpMinDistAtr","0.3"),@("InpMaxDistAtr","1.5"),
                    @("InpUseEma14Bias","true"),@("InpUseAdrFilter","false"),
                    @("InpOrder1Atr","0.2"),@("InpOrder2Atr","0.3"),@("InpUseOrder2","true"),
                    @("InpSLatr","1.0"),@("InpMinRR","1.0"),@("InpTP_RR","2.0"),
                    @("InpBreakeven","true"),@("InpUseTrailing","true"),
                    @("InpUseCutoff","false"),@("InpRiskPercent","1.0"),
                    @("InpUseNewsFilter","false"),@("InpFridayClose","false"),
                    @("InpMaxSpread","0"))

#--- I DELTA AMMESSI CONTRO L'ANTENATO (checklist 72). Per il 00_metro
#    e' SOLO InpMagic; per le celle dei lati e' InpMagic piu' l'UNICO
#    lato che quella cella muove. Tutto il resto deve essere IDENTICO
#    all'artefatto che ha girato in R103.
$DeltaBase = @("InpMagic")

#--- LE TOLLERANZE (restano per il confronto fra gemelli e per ogni
#    futuro confronto numerico). In R110 NON esiste nessun G0 numerico:
#    vedi criteri par. 5, G0-B.
$TolGemelli = 0.005

# =====================================================================
#  TUTTO CIO' CHE LA RACCOLTA USA NASCE QUI, PRIMA DEL try
#  (checklist 41-bis), FUNZIONI COMPRESE (checklist 48: in PowerShell una
#  `function` non e' dichiarativa, e' un'ISTRUZIONE: se il flusso non ci
#  passa sopra, il nome non esiste e la raccolta esplode proprio nella
#  corsa fermata da un gate -- cioe' l'unica in cui il referto serve).
# =====================================================================
$Risultati = Join-Path $Work "risultati_prove"
$Sosta     = Join-Path $Work "sosta"
$Problemi  = New-Object System.Collections.ArrayList
$Rilievi   = New-Object System.Collections.ArrayList
$Fatale    = ""
$nAnt      = -1
$Firma     = "NON LETTA"
$Terminal  = ""; $MetaEditor = ""; $DataFolder = ""
$Ordinati  = @()      # checklist 41-bis: la raccolta lo scorre SEMPRE
$Vive      = @{}
$FamFerme  = @()
$SelettoreAVuoto = $false

function Ora(){ return (Get-Date).ToString("HH:mm:ss", $INV) }
function Dico([string]$t,[string]$c="Gray"){ Write-Host ("[" + (Ora) + "] " + $t) -ForegroundColor $c }
function Titolo([string]$t){ Write-Host ""; Write-Host ("=== " + $t + " ===") -ForegroundColor Cyan }

function Scarica([string]$url,[string]$dest,[string]$marcatore){
  Remove-Item -LiteralPath $dest -Force -ErrorAction SilentlyContinue
  Invoke-WebRequest -Uri $url -OutFile $dest -UseBasicParsing -ErrorAction Stop
  if(-not (Test-Path -LiteralPath $dest)){ throw ("scarico fallito: " + $url) }
  if($marcatore -ne "" -and -not (Select-String -LiteralPath $dest -SimpleMatch -Pattern $marcatore -Quiet)){
    throw ("file scaricato SENZA il marcatore '" + $marcatore + "': " + $url)
  }
}

function RigheVive([string]$p){
  return @(Get-Content -LiteralPath $p | Where-Object { $_ -notmatch '^\s*#' -and $_ -notmatch '^\s*$' })
}
function NomeDi([string]$riga){
  if($riga -match '^@'){ return ($riga -split '\s+')[0] }
  return (($riga -split '=')[0]).Trim()
}
function ValoreDi([string]$riga){
  if($riga -match '^@'){ return (($riga -split '\s+',2)[1]).Trim() }
  $i = $riga.IndexOf("=")
  if($i -lt 0){ return "" }
  return $riga.Substring($i+1).Trim()
}
#  MAPPA NOME -> VALORE. E' cosi' che si confronta con l'ANTENATO:
#  PER NOME, mai per posizione (checklist 72 e 58). Un doppione di nome
#  e' un guasto in se': in [TesterInputs] un parametro ripetuto fa fare
#  a MT5 ZERO passate.
function MappaDi($righe){
  $h = @{}
  foreach($r in @($righe)){
    $n = NomeDi $r
    if($h.ContainsKey($n)){ throw ("il file ha DUE righe per '" + $n + "': in [TesterInputs] un parametro doppio fa fare a MT5 ZERO passate.") }
    $h[$n] = (ValoreDi $r)
  }
  return $h
}
function CsvDi($c,[string]$tag){
  $fam = @($FAMIGLIE | Where-Object { $_.Id -eq $c.Fam })[0]
  #  A Modello 4 il driver generico NON aggiunge il suffisso "_ohlc": lo
  #  aggiunge solo ai modelli diversi da 4 (cercare '$Suffisso =' in
  #  walkforward_generico.ps1).
  return (Join-Path $Risultati ($fam.Ea + "\" + $fam.Ea + "_" + $fam.Sym + "_" + $tag + "_" + $c.Id + ".csv"))
}

# ---------------------------------------------------------------------
#  LA CONVENZIONE DI SENTINELLA, E VALE PER TUTTE LE COLONNE.
#  checklist 66: in R103 era applicata a META' delle colonne, e il PF
#  non misurato usciva "0.000" -- un numero PLAUSIBILE che si legge
#  "ha perso tutto". Qui:
#    - i decimali NON MISURATI valgono -1.0   -> Fmt2/Fmt3 -> "n/d"
#    - gli interi NON MISURATI valgono -1     -> FmtN      -> "n/d"
#    - il PROFITTO non misurato vale -999999  -> FmtE      -> "n/d"
#    - la PEGGIOR GIORNATA non misurata vale 99.9 -> FmtPg -> "n/d"
#
#  >>> LE DUE COLONNE CHE NON POSSONO USARE IL SENTINELLA -1:
#      * PROFITTO: e' negativo ogni volta che la cella perde. Un
#        sentinella a -1 sarebbe indistinguibile da una perdita di 1 euro.
#      * PEGGIOR GIORNATA %: e' negativa SEMPRE (MISURATO negli artefatti
#        veri: 'Peggior Giornata %' = -0.9971). Con Fmt2, che rende "n/d"
#        per ogni valore < 0, TUTTA la colonna sarebbe uscita "n/d" --
#        una colonna dichiarata non misurata mentre era misurata.
# ---------------------------------------------------------------------
function Fmt2($v){
  if($null -eq $v){ return "n/d" }
  if([double]$v -lt 0){ return "n/d" }
  return ([double]$v).ToString("0.00",$INV)
}
function Fmt3($v){
  if($null -eq $v){ return "n/d" }
  if([double]$v -lt 0){ return "n/d" }
  return ([double]$v).ToString("0.000",$INV)
}
function FmtN($v){
  if($null -eq $v){ return "n/d" }
  if([int]$v -lt 0){ return "n/d" }
  return ([int]$v).ToString($INV)
}
function FmtE($v){
  if($null -eq $v){ return "n/d" }
  if([double]$v -le -999998.0){ return "n/d" }
  #  NIENTE separatore delle migliaia, ed e' voluto: sotto cultura
  #  invariante "+2,812" si scrive con la VIRGOLA, e un lettore italiano
  #  lo legge "due virgola otto".
  return ([double]$v).ToString("+0;-0;0",$INV)
}
function FmtPg($v){
  if($null -eq $v){ return "n/d" }
  if([double]$v -ge 99.0){ return "n/d" }
  return ([double]$v).ToString("0.00",$INV)
}
function NumInv($s){
  $v = 0.0
  $t = ("" + $s).Replace([string][char]160,"").Replace([string][char]8239,"").Replace([string][char]8201,"").Replace(" ","").Trim()
  if($t -eq ""){ return $null }
  if([double]::TryParse($t,[Globalization.NumberStyles]::Float,$INV,[ref]$v)){ return $v }
  return $null
}

# =====================================================================
#  IL PARSER DEL CSV DI OTTIMIZZAZIONE -- con il CONTROLLO POSITIVO.
#   1. le colonne si cercano PER NOME nell'intestazione, mai per posizione;
#   2. i sinonimi sono COMPLETI, italiano e inglese, ed elencati qui;
#   3. se NON riconosce le colonne torna $null E DICE QUALI INTESTAZIONI
#      HA VISTO -- perche' il 23/08, per scoprire la parola mancante, e'
#      servito aprire lo zip a mano.
#  L'intestazione VERA e' MISURATA sugli artefatti (OPTFRAME esteso):
#    Pass,Profit,Expected Payoff,Profit Factor,Recovery Factor,
#    Sharpe Ratio,Equity DD %,Trades,Peggior Giornata %,...
# =====================================================================
$script:CsvIntestazioni = @()
function LeggiOpt([string]$path){
  if(-not (Test-Path -LiteralPath $path)){ return $null }
  $righe = @()
  try{ $righe = @(Import-Csv -LiteralPath $path) }catch{ return $null }
  if($righe.Count -eq 0){ return $null }
  $cols = @($righe[0].PSObject.Properties.Name)
  $script:CsvIntestazioni = $cols
  function Trova($cands){
    foreach($c in $cands){
      foreach($k in $cols){ if(("" + $k).Trim().ToLower() -eq $c){ return $k } }
    }
    return $null
  }
  $kProf = Trova @("profit","profitto","utile")
  $kPf   = Trova @("profit factor","fattore di profitto")
  $kDd   = Trova @("equity dd %","drawdown equity %","equity drawdown %","drawdown %")
  $kN    = Trova @("trades","operazioni","trade")
  $kPg   = Trova @("peggior giornata %","worst day %")
  $kMg   = Trova @("inpmagic")
  if($null -eq $kProf -or $null -eq $kPf -or $null -eq $kDd -or $null -eq $kN){ return $null }
  $out = New-Object System.Collections.ArrayList
  foreach($r in $righe){
    [void]$out.Add([pscustomobject]@{
      Profit = (NumInv $r.$kProf)
      Pf     = (NumInv $r.$kPf)
      Dd     = (NumInv $r.$kDd)
      N      = (NumInv $r.$kN)
      Pg     = $(if($null -ne $kPg){ (NumInv $r.$kPg) } else { $null })
      Magic  = $(if($null -ne $kMg){ ("" + $r.$kMg).Trim() } else { "" })
    })
  }
  return @($out)
}

#  I GEMELLI (G0-C): le due righe devono essere IDENTICHE AL CENTESIMO
#  su profitto, PF, DD e n. E' l'igiene di casa, ed e' il motivo per cui
#  l'unico asse spazzolato e' InpMagic.
#  >>> E SI PRETENDE CHE SIANO DUE. "Una riga sola" non e' "gemelli ok":
#      e' uno sweep che non ha spazzolato (checklist 55).
#  >>> IN R110 E' UNO DEI DUE SOLI GATE CHE POSSONO MORDERE (l'altro e'
#      l'antenato): il metro NUMERICO non esiste, criteri par. 5 G0-B.
function Gemelli($righe){
  if($null -eq $righe){ return "NON MISURATO (CSV non letto)" }
  if(@($righe).Count -ne 2){ return ("NON VALIDO: " + @($righe).Count + " righe invece di 2") }
  $a = $righe[0]; $b = $righe[1]
  foreach($ch in @(@("profitto",$a.Profit,$b.Profit),@("PF",$a.Pf,$b.Pf),
                   @("DD",$a.Dd,$b.Dd),@("n",$a.N,$b.N))){
    if($null -eq $ch[1] -or $null -eq $ch[2]){ return ("NON MISURATO (" + $ch[0] + " illeggibile)") }
    if([math]::Abs([double]$ch[1] - [double]$ch[2]) -gt $TolGemelli){
      return ("DIVERSI su " + $ch[0] + ": " + $ch[1] + " contro " + $ch[2])
    }
  }
  return "IDENTICI"
}

#--- LE DUE FINESTRE, calcolate con la STESSA formula del driver generico.
#    Nel giro a vuoto vengono CONFRONTATE con le FromDate/ToDate scritte
#    davvero nelle anteprime .ini: se il driver generico cambiasse la sua
#    FrazioneIS, il confronto se ne accorge.
$DtInizio = [datetime]::ParseExact($DaQuando,"yyyy.MM.dd",$INV)
$DtFine   = [datetime]::ParseExact($Fino,"yyyy.MM.dd",$INV)
$DtMeta   = $DtInizio.AddDays([math]::Floor(($DtFine-$DtInizio).TotalDays*$FrazioneIS))
$IS_Da    = $DtInizio.ToString("yyyy.MM.dd",$INV)
$IS_A     = $DtMeta.ToString("yyyy.MM.dd",$INV)
$OOS_Da   = $DtMeta.AddDays(1).ToString("yyyy.MM.dd",$INV)
$OOS_A    = $DtFine.ToString("yyyy.MM.dd",$INV)

# =====================================================================
#  LA LISTA DEI LAVORI, dopo i filtri -SoloEa / -SoloCella
#
#  >>> CHECKLIST 65: -SoloEa si splitta su '[,\s]+', mai su ','. In
#      argument mode 'SWDOW,EMADOW' senza apici diventa un ARRAY, e il
#      binder [string] lo unisce con uno SPAZIO: chi splitta su ',' trova
#      un token solo e il filtro non corrisponde a niente. Cosi'
#      funzionano tutte e due le forme.
#  >>> CHECKLIST 68: se dopo i filtri non resta NESSUNA cella, non e'
#      "zero problemi": e' IL SELETTORE CHE NON HA CORRISPOSTO A NULLA,
#      cioe' il refuso piu' comune che esista. Ha un esito suo (exit 1).
# =====================================================================
$Lavori = @($CELLE)
if($SoloEa -ne ""){
  $se = @(($SoloEa.ToUpper() -split '[,\s]+') | Where-Object { $_ -ne "" })
  #  gli id validi si prendono DALLA TABELLA, non da un elenco scritto a
  #  mano qui: se un giorno si aggiungesse una quinta famiglia, un elenco
  #  duplicato resterebbe indietro in silenzio.
  $idValidi = @($FAMIGLIE | ForEach-Object { $_.Id })
  $ignoti   = @($se | Where-Object { $idValidi -notcontains $_ })
  if($ignoti.Count -gt 0){
    Write-Host ("!!! -SoloEa contiene famiglie che non esistono: " + ($ignoti -join ", ")) -ForegroundColor Red
    Write-Host ("    Valide: " + ($idValidi -join ", ") + ". Elenchi FRA APICI: -SoloEa 'SWDOW,EMADOW'") -ForegroundColor Yellow
    exit 1
  }
  $Lavori = @($Lavori | Where-Object { $se -contains $_.Fam })
}
if($SoloCella -ne ""){
  $sc = @($Lavori | Where-Object { $_.Prova -eq $SoloCella })
  if($sc.Count -eq 0){
    Write-Host ("!!! -SoloCella " + $SoloCella + " non e' nella lista (dopo -SoloEa). Nomi validi:") -ForegroundColor Red
    foreach($c in $CELLE){ Write-Host ("      " + $c.Prova + "   [" + $c.Fam + "]") -ForegroundColor Yellow }
    exit 1
  }
  #  >>> IL 00_metro DELLA SUA FAMIGLIA GIRA LO STESSO. E' la ripresa
  #      "vera": senza il denominatore i delta non esistono, e senza il
  #      metro non gira nemmeno il gate G0-C (i gemelli). Costa 2 CSV.
  $famSc = $sc[0].Fam
  $Lavori = @($Lavori | Where-Object { $_.Prova -eq $SoloCella -or ($_.Fam -eq $famSc -and $_.Metro) })
}
$FamAttive = @($Lavori | ForEach-Object { $_.Fam } | Sort-Object -Unique)
$FamLavoro = @($FAMIGLIE | Where-Object { $FamAttive -contains $_.Id })
if($Lavori.Count -eq 0){ $SelettoreAVuoto = $true }

Write-Host ""
Write-Host "#####################################################################" -ForegroundColor Cyan
Write-Host "#  R110 - I LATI MAI MISURATI DEI MOTORI VIVI SUGLI INDICI          #" -ForegroundColor Cyan
Write-Host "#  NASUSD H1 + D30EUR H4 + U30USD H1 x2, TICK REALI, 24.09.26>26.06.30 #" -ForegroundColor Cyan
Write-Host "#####################################################################" -ForegroundColor Cyan
Dico ("pin      : " + $Pin)
Dico ("cartella : " + $Work)

if($SelettoreAVuoto){
  Write-Host ""
  Write-Host "#####################################################################" -ForegroundColor Red
  Write-Host "#  IL SELETTORE NON HA CORRISPOSTO A NESSUNA CELLA.                 #" -ForegroundColor Red
  Write-Host "#####################################################################" -ForegroundColor Red
  Write-Host ("  -SoloEa    = '" + $SoloEa + "'") -ForegroundColor Yellow
  Write-Host ("  -SoloCella = '" + $SoloCella + "'") -ForegroundColor Yellow
  Write-Host  "  Non ho niente da fare, e questo NON e' 'tutto a posto': e' il refuso" -ForegroundColor Yellow
  Write-Host  "  piu' comune che esista (un nome storto nel selettore). Le dodici celle:" -ForegroundColor Yellow
  foreach($c in $CELLE){ Write-Host ("      " + $c.Fam.PadRight(7) + " " + $c.Prova) -ForegroundColor Yellow }
  Write-Host ""
  Write-Host "ESITO: SELETTORE A VUOTO -- nessuna cella selezionata, nessun artefatto prodotto." -ForegroundColor Red
  exit 1
}

Titolo "NUMERI ATTESI (dichiarati PRIMA della corsa)"
Write-Host ("    famiglie .....................  " + $FamLavoro.Count + "   (" + ($FamAttive -join ", ") + ")") -ForegroundColor White
Write-Host ("    celle ........................  " + $Lavori.Count + "   (di cui METRO: " + @($Lavori | Where-Object { $_.Metro }).Count + ")") -ForegroundColor White
Write-Host ("    CSV attesi ...................  " + (2*$Lavori.Count) + "   (IS + OOS per cella)") -ForegroundColor White
Write-Host ("    righe per CSV ................  " + $CelleAttese + "   (le due gemelle di controllo)") -ForegroundColor White
Write-Host ("    passate ......................  " + (4*$Lavori.Count)) -ForegroundColor White
Write-Host ("    IS  " + $IS_Da + " -> " + $IS_A) -ForegroundColor White
Write-Host ("    OOS " + $OOS_Da + " -> " + $OOS_A) -ForegroundColor White
Write-Host ""
Write-Host  "    >>> IL METRO NUMERICO NON ESISTE, E VA SAPUTO PRIMA (criteri par. 5, G0-B)." -ForegroundColor Yellow
Write-Host  "    R103 e' l'unico posto con i numeri di queste quattro sedie, ma girava a" -ForegroundColor Yellow
Write-Host  "    MODELLO 1 (OHLC su M1) su UNA FINESTRA UNICA di 21 mesi; qui si gira a" -ForegroundColor Yellow
Write-Host  "    MODELLO 4 (TICK REALI) con lo split 40/60. Due banchi e due finestre" -ForegroundColor Yellow
Write-Host  "    diverse: NON C'E' NIENTE DA RIPRODURRE, e 'non applicabile' NON e'" -ForegroundColor Yellow
Write-Host  "    'superato'. Quello che morde qui e':" -ForegroundColor Yellow
Write-Host  "      G0-A  IL GATE DELL'ANTENATO: ogni cella e' la copia riga per riga del" -ForegroundColor Yellow
Write-Host  "            file prova R103 di quella sedia, salvo i delta DICHIARATI." -ForegroundColor Yellow
Write-Host  "      G0-C  I GEMELLI: le due righe del CSV identiche al centesimo." -ForegroundColor Yellow
Write-Host  "    Se uno dei due fallisce, quella FAMIGLIA si ferma e le altre vanno avanti." -ForegroundColor Yellow
Write-Host ""
foreach($fam in $FamLavoro){
  Write-Host ("      " + $fam.Id.PadRight(7) + " " + $fam.Ea + " / " + $fam.Sym + " " + $fam.Per + "   sedia viva " + $fam.MagicVivo) -ForegroundColor White
  Write-Host ("              antenato : prove\" + $fam.Antenato) -ForegroundColor Gray
  Write-Host ("              R103     : " + $fam.R103 + "   <<< CONTESTO, NON UN METRO") -ForegroundColor Gray
}
Write-Host ""
Write-Host  "    LA SOMMA DEI DUE LATI NON RIPRODUCE IL METRO, ED E' PER COSTRUZIONE:" -ForegroundColor Yellow
Write-Host  "    tutti e quattro i motori escono dalla funzione di ingresso se hanno gia'" -ForegroundColor Yellow
Write-Host  "    una posizione (o un pendente) PRIMA di guardare il lato. Con un lato" -ForegroundColor Yellow
Write-Host  "    spento lo slot resta libero. n(long)+n(short) != n(metro) e' un FATTO." -ForegroundColor Yellow
Write-Host ""
Write-Host  "    IL CANARINO (criteri par. 5, G4) NON E' UN GATE. Il campione sottile" -ForegroundColor Yellow
Write-Host  "    sospende il giudizio sul MERITO, mai sul RISCHIO (Emendamento reg. B)." -ForegroundColor Yellow
Write-Host ""
Write-Host  "    >>> QUESTO ROUND NON PROMUOVE NIENTE E NON TOCCA IL FORWARD." -ForegroundColor Yellow
Write-Host  "        Le QUATTRO sedie girano sul 100k adesso. Il deploy e' una firma" -ForegroundColor Yellow
Write-Host  "        separata, con referto suo (G5)." -ForegroundColor Yellow

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
#     MetaEditor e' SINGLE-INSTANCE: se ne gira gia' una copia, il nostro
#     metaeditor64.exe /compile torna SUBITO senza aver compilato, e la
#     fase 3 dichiarerebbe "COMPILAZIONE FALLITA" su un sorgente sano
#     (checklist 39).
# =====================================================================
$vivi = @(Get-Process -Name "terminal64","metaeditor64" -ErrorAction SilentlyContinue)
if($vivi.Count -gt 0){
  Write-Host ""
  Write-Host ("!!! APERTO: " + (($vivi | ForEach-Object { $_.ProcessName } | Sort-Object -Unique) -join ", ")) -ForegroundColor Red
  Write-Host "    Non parto: col terminale aperto il tester non gira (zero CSV), e con" -ForegroundColor Red
  Write-Host "    MetaEditor aperto la compilazione torna subito senza compilare." -ForegroundColor Red
  Write-Host "    Chiudi MetaTrader E MetaEditor (tutte le istanze) e rilancia." -ForegroundColor Yellow
  #  DICHIARATO: questo exit sta DENTRO il try e SALTA la raccolta. Qui e'
  #  accettabile ed e' una scelta: siamo a due secondi dal lancio, non e'
  #  stato prodotto NIENTE, e il messaggio a schermo E' il referto.
  exit 1
}

New-Item -ItemType Directory -Force -Path $Work,$Prove,$Anten,$Logs,$SrcDir | Out-Null

# =====================================================================
#  0-BIS. LA FIRMA DEI CRITERI. Si LEGGE nell'artefatto, non si ricorda.
# =====================================================================
Titolo "0-BIS. LA FIRMA DEI CRITERI"
$critFile = Join-Path $Work "R110_CRITERI.md"
$daFirmare = $true
try{
  Scarica ("$RawPin/backtest_pipeline/risultati_archivio/R110_CRITERI.md") $critFile 'R110'
  $daFirmare = (Select-String -LiteralPath $critFile -SimpleMatch -Pattern '[DA FIRMARE]' -Quiet)
  $Firma = if($daFirmare){ "NON FIRMATI (il file porta ancora [DA FIRMARE])" } else { "FIRMATI (nessun [DA FIRMARE] nel file)" }
}catch{
  $Firma = "NON LETTI (" + $_.Exception.Message + ")"
  $daFirmare = $true
}
Dico ("criteri: " + $Firma) $(if($Firma -like "FIRMATI*"){"Green"}else{"Yellow"})
if($daFirmare -and -not $SoloControllo -and -not $CriteriFirmati){
  Write-Host ""
  Write-Host "#####################################################################" -ForegroundColor Red
  Write-Host "#  NON PARTO: I CRITERI DI R110 NON SONO FIRMATI.                   #" -ForegroundColor Red
  Write-Host "#####################################################################" -ForegroundColor Red
  Write-Host "  R110_CRITERI.md porta ancora [DA FIRMARE]. Sono CINQUE decisioni (par. 10):" -ForegroundColor Yellow
  Write-Host "   D1  quali famiglie entrano (proposta: 4, senza SupRev DAX H1)" -ForegroundColor Yellow
  Write-Host "   D2  il cancello di merito sui lati (proposta: quello di R54)" -ForegroundColor Yellow
  Write-Host "   D3  il metro numerico che NON c'e' -- G0-B non applicabile e dichiarato" -ForegroundColor Yellow
  Write-Host "   D4  tre celle per famiglia (metro + long + short), o solo due?" -ForegroundColor Yellow
  Write-Host "   D5  cosa si fa se una famiglia non passa G0-A o G0-C" -ForegroundColor Yellow
  Write-Host "" -ForegroundColor Yellow
  Write-Host "  COSA PUOI FARE ADESSO, in ordine:" -ForegroundColor Yellow
  Write-Host "   1. il GIRO A VUOTO gira lo stesso: rilancia con -SoloControllo." -ForegroundColor Yellow
  Write-Host "      Non apre MT5, non produce nessun numero, e verifica tutti i file." -ForegroundColor Yellow
  Write-Host "   2. leggi R110_CRITERI.md par. 10 e rispondi alle cinque decisioni." -ForegroundColor Yellow
  Write-Host "   3. quando hai firmato: si toglie il [DA FIRMARE] dal file, oppure" -ForegroundColor Yellow
  Write-Host "      si rilancia questa riga aggiungendo  -CriteriFirmati" -ForegroundColor Yellow
  Write-Host ""
  exit 2
}
if($daFirmare -and $CriteriFirmati){
  [void]$Rilievi.Add("I criteri portano ancora [DA FIRMARE] nel file, ma la corsa e' partita con -CriteriFirmati: la firma e' quella data in riga da Claudio. VA SCRITTO NEL REFERTO DEL ROUND.")
  Dico "corsa autorizzata da -CriteriFirmati (il file porta ancora [DA FIRMARE])" "Yellow"
}

# =====================================================================
#  1. SCARICO AL PIN
# =====================================================================
Titolo "1. SCARICO AL PIN"
$Driver = Join-Path $Work "walkforward_generico.ps1"
Scarica ("$RawPin/backtest_pipeline/walkforward_generico.ps1") $Driver 'RigaSpread'

# --- 1a. IL PIN DEL MOTORE. walkforward_generico.ps1 ha $EABranch="lavoro"
#     scritto FISSO e riscarica il .mq5 dalla PUNTA del branch: senza
#     questa riscrittura un pin pinnerebbe gli script e NON il motore. Su
#     un round che confronta dodici file fra loro, un push a meta' corsa
#     cambierebbe il motore fra un file e l'altro.
$dTxt = Get-Content -LiteralPath $Driver -Raw
$dNew = $dTxt -replace '\$EABranch\s*=\s*"lavoro"', ('$EABranch="' + $Pin + '"')
if($dNew -eq $dTxt){ throw "non sono riuscito a pinnare EABranch nel driver generico: riga non trovata" }

# --- 1b. IL TETTO DELLE BARRE. Se il tester ereditasse il tetto "Max barre
#     nel grafico" del terminale, le serie verrebbero TRONCATE IN SILENZIO
#     (checklist 36) e i CSV uscirebbero pieni di numeri coerenti e falsi.
#     [INFERITO] che il tester onori questa riga: NON e' misurato.
$dNew = $dNew -replace '(?m)^\[Experts\]\r?$', "[Charts]`r`nMaxBars=2000000000`r`n`r`n[Experts]"
Set-Content -LiteralPath $Driver -Value $dNew -Encoding ASCII
# --- gate sullo STATO FINALE, non sul replace (checklist 33)
if(-not (Select-String -LiteralPath $Driver -SimpleMatch -Pattern ('$EABranch="' + $Pin + '"') -Quiet)){ throw "pin di EABranch NON verificato nel driver generico" }
$nMax = @(Select-String -LiteralPath $Driver -SimpleMatch -Pattern 'MaxBars=2000000000').Count
if($nMax -ne 2){ throw ("MaxBars scritto " + $nMax + " volte nel driver generico invece di 2 (anteprima + corsa vera): il driver e' cambiato, mi fermo.") }
# --- 1b-bis. ALLOWLIVETRADING=FALSE, CONTATO (checklist 51). Aprire MT5
#     per MISURARE non deve poter riarmare la flotta: il terminale del PC
#     di backtest e' collegato al conto vivo.
#     >>> E SI CONTA SOLO A INIZIO RIGA, non a testo libero. MISURATO
#         ESEGUENDO il gate sul file vero il 25/08: la stringa compare
#         TRE volte -- due sono le righe degli .ini e la terza e' un
#         COMMENTO ("AllowLiveTrading=false: NON e' cosmetica", riga
#         627). Un gate tarato su 3 sarebbe passato anche se una delle
#         due righe vere fosse sparita e il commento fosse rimasto; uno
#         tarato su 2 col match a testo libero si ferma su un driver
#         sano. E' il difetto 40-quater: il numero atteso si MISURA
#         eseguendo, non si conta a occhio nel sorgente.
$nAlt = @(Select-String -LiteralPath $Driver -Pattern '^AllowLiveTrading=false\s*$').Count
if($nAlt -ne 2){ throw ("nel driver generico le RIGHE 'AllowLiveTrading=false' sono " + $nAlt + " invece di 2 (una nell'anteprima, una nella corsa vera). NON apro MT5 su un conto vivo con un .ini che non lo disarma.") }
Dico ("driver generico PINNATO (" + $Pin.Substring(0,[math]::Min(7,$Pin.Length)) + "), MaxBars alzato, AllowLiveTrading=false x2") "Green"

# --- 1c. I FILE PROVA E GLI ANTENATI, e le righe vive
foreach($c in $Lavori){
  Scarica ("$RawPin/backtest_pipeline/prove/" + $c.Prova) (Join-Path $Prove $c.Prova) '@SIMBOLO'
}
foreach($fam in $FamLavoro){
  Scarica ("$RawPin/backtest_pipeline/prove/" + $fam.Antenato) (Join-Path $Anten $fam.Antenato) '@SIMBOLO'
}
foreach($c in $Lavori){
  $fam = @($FAMIGLIE | Where-Object { $_.Id -eq $c.Fam })[0]
  $rv  = RigheVive (Join-Path $Prove $c.Prova)
  if($rv.Count -ne [int]$fam.RigheVive){
    throw ($c.Prova + " ha " + $rv.Count + " righe vive invece di " + $fam.RigheVive + ": artefatto cambiato, mi fermo.")
  }
  $Vive[$c.Prova] = $rv
}
Dico ($Lavori.Count.ToString() + " file prova + " + $FamLavoro.Count + " antenati scaricati al pin, righe vive verificate (SUPNAS 45 / SUPDAX 45 / SWDOW 47 / EMADOW 46)") "Green"

# --- 1c-bis. IL GATE DELL'ANTENATO (checklist 72). E' il gate che in
#     R110 morde davvero, perche' il metro NUMERICO non esiste.
#     >>> IL CONFRONTO E' PER NOME, MAI PER POSIZIONE: l'antenato puo'
#         avere una riga in piu' o in meno, e un confronto posizionale
#         sfaserebbe tutto il resto accusando quaranta righe sane (e' il
#         punto 58 applicato alle righe).
#     >>> E PRENDE LA CORRUZIONE SIMMETRICA, quella che il gate della
#         stella non puo' vedere: "un diff fra A e B non puo' accorgersi
#         di niente che sia uguale in A e in B".
foreach($c in $Lavori){
  $fam = @($FAMIGLIE | Where-Object { $_.Id -eq $c.Fam })[0]
  $mA  = MappaDi (RigheVive (Join-Path $Anten $fam.Antenato))
  $mC  = MappaDi $Vive[$c.Prova]
  $ammessi = @($DeltaBase) + @($c.Diff)
  $guasti  = New-Object System.Collections.ArrayList
  foreach($k in @($mA.Keys)){
    if(-not $mC.ContainsKey($k)){ [void]$guasti.Add("manca la riga '" + $k + "' che l'antenato ha") ; continue }
    if($mA[$k] -ne $mC[$k] -and $ammessi -notcontains $k){
      [void]$guasti.Add("'" + $k + "' vale [" + $mC[$k] + "] ma nell'antenato vale [" + $mA[$k] + "]")
    }
  }
  foreach($k in @($mC.Keys)){
    if(-not $mA.ContainsKey($k)){ [void]$guasti.Add("ha la riga '" + $k + "' che l'antenato NON ha") }
  }
  #  e i delta ammessi devono ESSERCI DAVVERO: un 'InpAllowShort' che
  #  NON differisce vorrebbe dire che la cella dei lati e' identica al
  #  metro, cioe' che il round non misura niente.
  foreach($k in @($c.Diff)){
    if($mA.ContainsKey($k) -and $mC.ContainsKey($k) -and $mA[$k] -eq $mC[$k]){
      [void]$guasti.Add("'" + $k + "' e' UGUALE all'antenato ([" + $mC[$k] + "]) ma questa cella deve muoverlo: senza, misurerebbe il metro un'altra volta")
    }
  }
  if($guasti.Count -gt 0){
    throw ("GATE DELL'ANTENATO FALLITO su " + $c.Prova + " contro prove\" + $fam.Antenato + ": " + ($guasti -join " ; ") +
           ". La frase 'il corpo e' copiato riga per riga da R103' e' un GATE, non un commento: se non torna, questo round girerebbe su un motore diverso da quello che sta sui soldi.")
  }
  $c.Antenato = "OK (delta: " + (($ammessi | Sort-Object) -join " + ") + ")"
}
foreach($fam in $FamLavoro){ $fam.Antenati = "OK (3 celle contro prove\" + $fam.Antenato + ")" }
Dico "gate dell'ANTENATO: ogni cella e' la copia riga per riga del suo file prova R103, salvo i delta dichiarati" "Green"

# --- 1d. IL GATE DELLA STELLA. Le celle dei lati si confrontano col
#     00_metro della loro famiglia. Non basta contare le righe diverse:
#     si pretende QUALI righe, e SOLO quelle.
#     >>> Il confronto e' POSIZIONALE e regge perche' i file sono
#         generati con lo stesso ordine di input: se le righe vive sono
#         in ordine diverso il gate se ne accorge (esce un diff enorme),
#         e in quel caso ci si ferma -- come deve.
foreach($fam in $FamLavoro){
  $rif = @($Lavori | Where-Object { $_.Fam -eq $fam.Id -and $_.Metro })
  if($rif.Count -ne 1){ throw ("famiglia " + $fam.Id + ": trovate " + $rif.Count + " celle 00_metro invece di 1. Senza il metro non gira il gate dei gemelli e i delta non esistono.") }
  $a = $Vive[$rif[0].Prova]
  foreach($c in @($Lavori | Where-Object { $_.Fam -eq $fam.Id -and -not $_.Metro })){
    $b = $Vive[$c.Prova]
    if($a.Count -ne $b.Count){ throw ($c.Prova + ": " + $b.Count + " righe vive contro " + $a.Count + " del 00_metro. Non sono confrontabili.") }
    $d = New-Object System.Collections.ArrayList
    for($i=0;$i -lt $a.Count;$i++){ if($a[$i] -ne $b[$i]){ [void]$d.Add((NomeDi $a[$i])) } }
    #  InpMagic differisce SEMPRE ed e' voluto: e' l'asse gemello.
    $attese = @($c.Diff) + @("InpMagic")
    $manca  = @($attese | Where-Object { $d -notcontains $_ })
    $extra  = @($d      | Where-Object { $attese -notcontains $_ })
    if($manca.Count -gt 0 -or $extra.Count -gt 0){
      throw ($c.Prova + " contro " + $rif[0].Prova + ": differiscono su [" + ($d -join ", ") +
             "] invece che su [" + ($attese -join ", ") + "]. R110 pretende CHE CAMBI UN LATO SOLO (piu' il magic): cosi' il numero e' attribuibile alla DIREZIONE e a nient'altro.")
    }
  }
}
Dico "gate della STELLA: ogni cella dei lati differisce dal suo 00_metro SOLO sul lato che deve muovere" "Green"

# --- 1e. I VALORI, letti NELL'ARTEFATTO CHE GIRA (checklist 34-bis).
#     Il diff dice CHE cambiano; questo dice CHE COSA valgono: se due
#     file di una famiglia fossero SCAMBIATI, il diff resterebbe verde.
#     >>> OGNI $ DI UNA REGEX MULTILINEA SI SCRIVE \r?$ (checklist 40): i
#         file arrivano da GitHub con CRLF, e senza \r? il match non
#         avviene MAI e il gate accuserebbe un file sano.
$magicVisti = @()
foreach($c in $Lavori){
  $fam = @($FAMIGLIE | Where-Object { $_.Id -eq $c.Fam })[0]
  $tx  = Get-Content -LiteralPath (Join-Path $Prove $c.Prova) -Raw
  # --- la GEOMETRIA D'IDENTITA', riga per riga, in OGNI file della famiglia
  foreach($chk in $VIVA[$c.Fam]){
    $rx = '(?m)^' + $chk[0] + '=' + [regex]::Escape($chk[1]) + '\|\|'
    if($tx -notmatch $rx){
      throw ($c.Prova + ": non trovo '" + $chk[0] + "=" + $chk[1] + "'. Questa NON e' la cella dichiarata nei criteri par. 2 per la famiglia " +
             $c.Fam + ": il round girerebbe sopra un motore che non e' quello della sedia.")
    }
  }
  # --- e i valori PROPRI di questa cella: I DUE LATI.
  foreach($k in $c.Val.Keys){
    $rx = '(?m)^' + $k + '=' + [regex]::Escape($c.Val[$k]) + '\|\|'
    if($tx -notmatch $rx){ throw ($c.Prova + ": " + $k + " non vale " + $c.Val[$k] + ". La cella non e' quella che credo -- e su un round sui LATI questo e' l'errore che rende il referto una bugia.") }
  }
  # --- @SIMBOLO / @PERIODO / @DAQUANDO, confrontati e non creduti.
  #     >>> E' qui che la regola "niente coda 2026.07-08" (criteri par. 4)
  #         diventa un if invece di una frase.
  $m = [regex]::Match($tx,'(?m)^@DAQUANDO\s+([0-9]{4}\.[0-9]{2}\.[0-9]{2})')
  if(-not $m.Success -or $m.Groups[1].Value -ne $DaQuando){ throw ($c.Prova + ": @DAQUANDO non e' " + $DaQuando) }
  $s = [regex]::Match($tx,'(?m)^@SIMBOLO\s+(\S+)')
  if(-not $s.Success -or $s.Groups[1].Value -ne $fam.Sym){ throw ($c.Prova + ": @SIMBOLO non e' " + $fam.Sym) }
  # --- IL TF DEL GRAFICO. NON si deriva da InpTF e viceversa: e' la
  #     trappola pagata in R102 (SuperWave GBPUSD gira su un grafico H4
  #     con InpTF = H2). Qui il round ha DUE TF diversi fra le famiglie
  #     (H1 e H4), e scambiarli darebbe numeri plausibili e falsi.
  $p = [regex]::Match($tx,'(?m)^@PERIODO\s+(\S+)')
  if(-not $p.Success -or $p.Groups[1].Value -ne $fam.Per){ throw ($c.Prova + ": @PERIODO non e' " + $fam.Per + " (il TF del GRAFICO nel tester). Sulla famiglia " + $c.Fam + " il grafico e' " + $fam.Per + " e InpTF e' un'altra cosa: si controllano tutti e due.") }
  # --- L'ASSE UNICO. La prosa dei criteri dice "zero parametri
  #     spazzolati, l'unico asse Y e' InpMagic": la regola ha il suo if,
  #     e lo ha QUI NEL FILE -- non solo nell'anteprima del giro a vuoto,
  #     che nella corsa vera non viene nemmeno prodotta.
  $assiY = @([regex]::Matches($tx,'(?m)^(\w+)=[^\r\n]*\|\|\s*[Yy]\s*\r?$') | ForEach-Object { $_.Groups[1].Value })
  if($assiY.Count -ne 1 -or $assiY[0] -ne "InpMagic"){
    throw ($c.Prova + ": gli assi spazzolati sono [" + ($assiY -join ", ") + "] invece del solo InpMagic. R110 NON ottimizza niente: piu' di un asse sarebbe una griglia, cioe' un altro round.")
  }
  # --- i magic
  $mg = [regex]::Match($tx,'(?m)^InpMagic=(\d+)\|\|(\d+)\|\|1\|\|(\d+)\|\|Y')
  if(-not $mg.Success){ throw ($c.Prova + ": InpMagic non e' nella forma sweep 'v||v||1||v+1||Y'. Senza almeno un asse Y il driver generico si rifiuta di partire e MT5 rispazzola la griglia vecchia (checklist punto 5).") }
  $m0 = [int]$mg.Groups[1].Value; $m1 = [int]$mg.Groups[3].Value
  if($m0 -ne [int]$c.Magic){ throw ($c.Prova + ": InpMagic e' " + $m0 + " ma questa cella deve girare su " + $c.Magic) }
  if($m1 -ne ($m0+1)){ throw ($c.Prova + ": il gemello e' " + $m1 + " invece di " + ($m0+1)) }
  foreach($mm in @($m0,$m1)){
    if($magicVisti -contains $mm){ throw ($c.Prova + ": magic " + $mm + " gia' usato da un altro file prova. Due file con lo stesso magic non sono distinguibili nel CSV.") }
    if($MagicVietati -contains $mm){ throw ($c.Prova + ": il magic " + $mm + " e' di una SEDIA VIVA (o di un'identita' occupata, o di un round precedente). Fermo tutto: il tester non deve poter incrociare i deal del forward.") }
    $magicVisti += $mm
  }
}
Dico ("geometria d'identita', TF del grafico, LATI, asse unico e " + $magicVisti.Count + " magic vergini verificati NEI FILE") "Green"

# --- 1f. I SORGENTI E IL GATE DI VERSIONE. I marcatori sono presi DAL
#     SORGENTE, e sono DUE per EA: la versione dichiarata e il magic
#     dichiarato. Una cache CDN o un branch sbagliato darebbero un altro
#     motore, e il round misurerebbe un'altra cosa.
#     >>> IL MAGIC DEL SORGENTE NON E' SEMPRE QUELLO DELLA SEDIA:
#         ABTG_EMA200.mq5 dichiara 771501 e la sedia Dow gira su 771531
#         (impostato sul grafico). Sono TRE numeri diversi contando anche
#         quello del file prova. Confonderli e' il difetto che R100
#         dovette correggere a mano su due sedie.
foreach($fam in $FamLavoro){
  $srcMq5 = Join-Path $SrcDir ($fam.Ea + ".mq5")
  Scarica ("$RawPin/mql5/Experts/" + $fam.Ea + ".mq5") $srcMq5 'ABTG_GuardiaIngresso'
  $txtSrc = Get-Content -LiteralPath $srcMq5 -Raw
  $mv = [regex]::Match($txtSrc,'#property\s+version\s+"([^"]+)"')
  if(-not $mv.Success){ throw ($fam.Ea + ".mq5 scaricato senza #property version: non e' il sorgente che credo.") }
  if($mv.Groups[1].Value -ne $fam.Ver){
    throw ($fam.Ea + ".mq5 dichiara version '" + $mv.Groups[1].Value + "' invece di '" + $fam.Ver +
           "'. O la cache di raw.githubusercontent serve una copia vecchia, o il pin e' sbagliato: mi fermo.")
  }
  if($txtSrc -notmatch ('(?m)^input\s+long\s+InpMagic\s*=\s*' + $fam.MagicSrc + '\s*;')){
    throw ($fam.Ea + ".mq5 non dichiara 'input long InpMagic = " + $fam.MagicSrc + ";': non e' il motore di questa sedia.")
  }
  #  >>> I DUE INPUT DEI LATI DEVONO ESISTERE, o il round non ha oggetto.
  #      E' il controllo che il censimento chiedeva per primo: "se non
  #      esiste un InpAllowLong/Short, la famiglia NON E' MISURABILE
  #      senza toccare il codice".
  foreach($inp in @("InpAllowLong","InpAllowShort")){
    if($txtSrc -notmatch ('(?m)^input\s+bool\s+' + $inp + '\s*=')){ throw ($fam.Ea + ".mq5 non ha l'input " + $inp + ": senza i due lati non c'e' niente da misurare, e questo round NON tocca il codice degli EA.") }
  }
  Dico ($fam.Ea + ".mq5 al pin, version " + $mv.Groups[1].Value + ", InpMagic del sorgente " + $fam.MagicSrc + " (la sedia gira su " + $fam.MagicVivo + ")") "Green"
}

# =====================================================================
#  2. TERMINALE E CARTELLA DATI (per NOME, mai il primo che capita)
# =====================================================================
Titolo "2. TERMINALE E CARTELLA DATI"
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
New-Item -ItemType Directory -Force -Path $MqlExperts,$MqlInclude,$Sosta | Out-Null
#  OGNI PASSO STAMPA IL BERSAGLIO CHE HA SCELTO (checklist 37).
Dico ("terminale : " + $Terminal)
Dico ("dati      : " + $DataFolder + "   (DEVE restare lo stesso in tutti i passi)")

# --- 2a. LA SOSTA SI SVUOTA A OGNI GIRO (checklist 56). Il giro a vuoto
#     lascia in sosta le anteprima_*.ini; la corsa vera NON le riproduce e
#     la raccolta copia in blocco tutta la sosta nello zip: dentro il
#     risultato del round finirebbero .ini CHE NON HANNO GIRATO.
#     >>> E SI CONTA PRIMA E DOPO (checklist 69).
$nSosta = @(Get-ChildItem -LiteralPath $Sosta -File -ErrorAction SilentlyContinue).Count
if($nSosta -gt 0){
  Get-ChildItem -LiteralPath $Sosta -File -ErrorAction SilentlyContinue | Remove-Item -Force -ErrorAction SilentlyContinue
  $nDopo = @(Get-ChildItem -LiteralPath $Sosta -File -ErrorAction SilentlyContinue).Count
  if($nDopo -gt 0){
    [void]$Problemi.Add("sosta: " + $nDopo + " file su " + $nSosta + " di un giro PRECEDENTE non sono stati cancellati. Possono finire nello zip di questo round spacciandosi per artefatti di adesso: controllare le date dentro lo zip prima di leggerlo.")
  }
  Dico ("sosta svuotata: " + $nSosta + " file di un giro precedente rimossi (rimasti: " + $nDopo + ")") "Green"
}

# --- 2b. L'INCLUDE CHE NESSUN DRIVER INSTALLA (checklist 33-bis).
#     Tutti e quattro gli EA fanno #include <ABTG_PausaGuardian.mqh> e
#     chiamano ABTG_GuardiaIngresso(). walkforward_generico.ps1 scarica
#     SOLO il .mq5: senza questa riga la compilazione fallisce e il round
#     muore alla prima passata. Pagato due volte (21/08 e 22/08).
#     >>> NEL TESTER LA GUARDIA E' FAIL-OPEN TOTALE (le GlobalVariable del
#         Guardian non esistono): non cambia il comportamento.
$mqh = Join-Path $MqlInclude "ABTG_PausaGuardian.mqh"
Scarica ("$RawPin/mql5/Include/ABTG_PausaGuardian.mqh") $mqh 'ABTG_GuardiaIngresso'
$vfy = Get-Item -LiteralPath $mqh
if($vfy.PSIsContainer){ throw "ABTG_PausaGuardian.mqh: in Include c'e' una CARTELLA con quel nome (checklist 27-ter)." }
if($vfy.Length -lt 4000){ throw ("ABTG_PausaGuardian.mqh e' lungo " + $vfy.Length + " byte: troppo poco, scarico monco.") }
Dico ("include installato: ABTG_PausaGuardian.mqh (" + $vfy.Length + " byte)") "Green"

# --- 2c. PULIZIA DEGLI ARTEFATTI VECCHI, PRIMA (checklist 14, 53 e 69).
#     >>> SOLO se si corre davvero: un giro a vuoto che cancella gli
#         artefatti di una corsa vera fatta ieri e' un danno.
#     >>> E SI CANCELLA PER NOME: un filtro a wildcard prenderebbe anche i
#         CSV delle sedie vive e degli altri round.
#     >>> E SE UN FILE SOPRAVVIVE, LO SI DICE RUMOROSAMENTE (checklist 69).
if($SoloControllo){
  Dico "SoloControllo: NON cancello niente." "Yellow"
} else {
  foreach($fam in $FamLavoro){
    $optCsv = Join-Path $MqlFiles ("OptResults_" + $fam.Ea + "_" + $fam.Sym + ".csv")
    if(Test-Path -LiteralPath $optCsv){
      Remove-Item -LiteralPath $optCsv -Force -ErrorAction SilentlyContinue
      if(Test-Path -LiteralPath $optCsv){
        [void]$Problemi.Add("NON sono riuscito a cancellare " + $optCsv + " (qualcuno lo tiene aperto). Il file di appoggio dell'OPTFRAME e' di un giro PRECEDENTE: i CSV di questo round vanno confrontati con la loro data prima di leggerli.")
        Dico ("OptResults NON cancellato: " + $optCsv) "Red"
      }
    }
  }
  # --- la CACHE del tester, e SOLO quella. MAI bases\<server>\ticks: li'
  #     dentro c'e' lo storico a tick reali di NASUSD, D30EUR e U30USD, e
  #     ributtarlo giu' e' una nottata.
  #  >>> CON -LiteralPath IL * NON E' UN WILDCARD (checklist 46).
  #  >>> E NON SI CREDE ALL'INTENZIONE: si conta PRIMA e DOPO.
  $cache = Join-Path $DataFolder "Tester\cache"
  if(Test-Path -LiteralPath $cache){
    $nc = @(Get-ChildItem -LiteralPath $cache -Force -Recurse -File -ErrorAction SilentlyContinue).Count
    Get-ChildItem -LiteralPath $cache -Force -ErrorAction SilentlyContinue | Remove-Item -Recurse -Force -ErrorAction SilentlyContinue
    $nr = @(Get-ChildItem -LiteralPath $cache -Force -Recurse -File -ErrorAction SilentlyContinue).Count
    if($nr -gt 0){
      [void]$Problemi.Add("Tester\cache NON svuotata: " + $nr + " file su " + $nc + " sono rimasti. MT5 puo' ripescare passate gia' calcolate (punto 38).")
      Dico ("Tester\cache: " + $nc + " file prima, " + $nr + " RIMASTI.") "Red"
    } else {
      Dico ("Tester\cache svuotata: " + $nc + " file prima, 0 dopo. bases\<server>\ticks NON toccata.") "Green"
    }
  } else { Dico "Tester\cache non esiste: niente da svuotare." "Gray" }
}

# =====================================================================
#  3. FASE COMPILA, un EA alla volta. .ex5 SCRITTO ADESSO.
#     Si fa ANCHE in -SoloControllo: il -SoloControllo del driver generico
#     esce PRIMA della compilazione (checklist 39), quindi un giro a vuoto
#     che non compilasse non direbbe niente sulla compilabilita'.
#     >>> INVOCAZIONE DIRETTA di metaeditor64.exe (checklist 54 e bug del
#         22/08): con Start-Process -ArgumentList a stringhe pre-quotate,
#         sui path con spazi ("Program Files") torna rc=0 SENZA compilare.
#     >>> E IL VERDETTO E' IL LastWriteTime DEL .ex5 PRIMA/DOPO, non
#         "esiste" e non "e' recente": i file c'erano gia'.
# =====================================================================
Titolo "3. FASE COMPILA"
foreach($fam in $FamLavoro){
  $srcMq5 = Join-Path $SrcDir ($fam.Ea + ".mq5")
  $mq5 = Join-Path $MqlExperts ($fam.Ea + ".mq5")
  $ex5 = Join-Path $MqlExperts ($fam.Ea + ".ex5")
  $logC= Join-Path $MqlExperts ($fam.Ea + ".log")
  #  backup DATATO e MAI sovrascritto (checklist 12): il .ex5 vecchio e'
  #  l'unica prova di cosa girava prima su questa macchina -- e qui sono
  #  i binari di QUATTRO SEDIE VIVE.
  $bakMq5 = $mq5 + ".prima_r110_" + $Stamp
  $bakEx5 = $ex5 + ".prima_r110_" + $Stamp
  if((Test-Path -LiteralPath $mq5) -and -not (Test-Path -LiteralPath $bakMq5)){ Copy-Item -LiteralPath $mq5 -Destination $bakMq5 -Force }
  if((Test-Path -LiteralPath $ex5) -and -not (Test-Path -LiteralPath $bakEx5)){ Copy-Item -LiteralPath $ex5 -Destination $bakEx5 -Force }
  Copy-Item -LiteralPath $srcMq5 -Destination $mq5 -Force
  #  verifica della copia sul CONTENUTO, non sul nome (checklist 27-ter)
  $lenSrc = (Get-Item -LiteralPath $srcMq5).Length
  $vc = Get-Item -LiteralPath $mq5 -ErrorAction SilentlyContinue
  if(-not $vc -or $vc.PSIsContainer -or $vc.Length -ne $lenSrc){ throw ("copia di " + $fam.Ea + ".mq5 in MQL5\Experts NON verificata (lunghezza diversa o e' una cartella).") }
  $ex5Prima = (Get-Date).AddYears(-100)
  if(Test-Path -LiteralPath $ex5){ $ex5Prima = (Get-Item -LiteralPath $ex5).LastWriteTime }
  Remove-Item -LiteralPath $logC -Force -ErrorAction SilentlyContinue
  & $MetaEditor "/compile:$mq5" "/log:$logC" | Out-Null
  $rcMe = $LASTEXITCODE
  $ex5Dopo = $null
  if(Test-Path -LiteralPath $ex5){ $ex5Dopo = (Get-Item -LiteralPath $ex5).LastWriteTime }
  $compileOk = ($null -ne $ex5Dopo) -and ($ex5Dopo -gt $ex5Prima)
  $testoLog = ""
  if(Test-Path -LiteralPath $logC){
    try{ $testoLog = (Get-Content -LiteralPath $logC -Raw -Encoding Unicode) }catch{ $testoLog = "" }
    if($testoLog -notmatch '(?i)error'){ try{ $testoLog = (Get-Content -LiteralPath $logC -Raw) }catch{} }
    Copy-Item -LiteralPath $logC -Destination (Join-Path $Sosta ("compile_" + $fam.Id + ".log")) -Force -ErrorAction SilentlyContinue
  }
  if(-not $compileOk){
    if($testoLog -ne ""){
      Write-Host "--- log del compilatore (ultime righe) ---" -ForegroundColor DarkYellow
      foreach($r in @($testoLog -split "\r?\n" | Select-Object -Last 20)){ Write-Host ("   " + $r) -ForegroundColor DarkYellow }
    } else { Write-Host "   (nessun log prodotto da MetaEditor)" -ForegroundColor DarkYellow }
    #  sorgente e binario devono restare la STESSA versione (checklist 54):
    #  una compilazione fallita in produzione NON e' un no-op, lascia il
    #  .ex5 VECCHIO che opera sotto un .mq5 NUOVO che mente.
    if(Test-Path -LiteralPath $bakMq5){ Copy-Item -LiteralPath $bakMq5 -Destination $mq5 -Force }
    throw ("COMPILAZIONE FALLITA per " + $fam.Ea + " (metaeditor rc=" + $rcMe + ", .ex5 NON riscritto). Il .mq5 e' stato rimesso com'era e il log e' nello zip. Sospetto n.1: include mancante o MetaEditor gia' aperto.")
  }
  $mw = [regex]::Match($testoLog,'(?i)(\d+)\s+warning')
  if($mw.Success -and [int]$mw.Groups[1].Value -gt 0){
    [void]$Rilievi.Add("compilazione " + $fam.Ea + ": " + $mw.Groups[1].Value + " warning (0 errori). Non fermano il round, ma vanno letti nel log dello zip.")
  }
  $fam.Compilato = $true
  Dico ("COMPILATO " + $fam.Ea + " v" + $fam.Ver + " (.ex5 riscritto adesso, rc=" + $rcMe + ")") "Green"
}

# =====================================================================
#  4. LA CATENA. Una cella alla volta. Mai in parallelo.
#     L'ORDINE CONTA: dentro ogni famiglia il 00_metro gira PER PRIMO,
#     perche' il gate G0-C di quella famiglia sta li' -- e se i gemelli
#     non sono identici, le celle dei lati non si lanciano nemmeno.
#     >>> E le ALTRE famiglie vanno avanti lo stesso: una sedia storta
#         non porta via anche le altre (decisione D5).
# =====================================================================
Titolo ("4. LA CATENA - " + $Lavori.Count + " celle, una alla volta")
$Ordinati = @()
foreach($fam in $FamLavoro){
  $Ordinati += @($Lavori | Where-Object { $_.Fam -eq $fam.Id -and $_.Metro })
  $Ordinati += @($Lavori | Where-Object { $_.Fam -eq $fam.Id -and -not $_.Metro })
}
$idx = 0
foreach($c in $Ordinati){
  $idx++
  $fam = @($FAMIGLIE | Where-Object { $_.Id -eq $c.Fam })[0]
  if($FamFerme -contains $c.Fam){
    $c.Esito = "NON INIZIATA (la famiglia " + $c.Fam + " si e' fermata al gate G0-C)"
    continue
  }
  $trascorse = (New-TimeSpan -Start $Avvio -End (Get-Date)).TotalHours
  if($trascorse -ge $OreMax){
    $c.Esito = "NON INIZIATA (tetto ore raggiunto)"
    [void]$Problemi.Add("TEMPO SCADUTO prima di " + $c.Prova + ": il round NON e' completo. Riprendi con -SoloCella " + $c.Prova + " (il 00_metro della sua famiglia rigira da solo).")
    continue
  }
  Write-Host ""
  Write-Host "------------------------------------------------------------------" -ForegroundColor Cyan
  Write-Host ("  [" + $idx + "/" + $Ordinati.Count + "]  " + $c.Prova + $(if($c.Metro){ "   <<< IL METRO (gate G0-C)" }else{ "" })) -ForegroundColor Cyan
  Write-Host ("           " + $c.Desc) -ForegroundColor Cyan
  Write-Host ("           " + $fam.Sym + " " + $fam.Per + "   (il TF del GRAFICO: non tutte le famiglie girano sullo stesso)") -ForegroundColor Cyan
  Write-Host "------------------------------------------------------------------" -ForegroundColor Cyan
  $tl = Get-Date
  #  >>> CHECKLIST 79: LA FINESTRA SI RICONTROLLA QUI, UN ISTANTE PRIMA DI
  #      PASSARLA -- non basta averla dichiarata in testa.
  #      Il 25/08, sul PC di Claudio, in R109 una variabile di comodo di un
  #      gate ($a) ha DISTRUTTO la variabile della finestra ($A): in
  #      PowerShell i nomi sono CASE-INSENSITIVE, il maiuscolo non esiste.
  #      Il ToDate dell'.ini e' diventato un array di input unito dagli
  #      spazi -- e il giro a vuoto usci' "ESITO: OK", codice 0, perche'
  #      NESSUN gate guardava LE DATE. La finestra e' meta' di quello che
  #      un backtest MISURA. Qui costa due confronti.
  #      (Su questo file l'audit case-insensitive e' stato fatto -- vedi
  #       la nota in fondo -- ma un gate che costa nulla si mette lo stesso:
  #       il difetto di R109 non era nella funzione, era nel FLUSSO DELLE
  #       VARIABILI, e domani questo script puo' crescere.)
  if($DaQuando -ne "2024.09.26" -or $Fino -ne "2026.06.30"){
    throw ("LA FINESTRA E' STATA SPORCATA prima di " + $c.Prova + ": DaQuando=[" + $DaQuando + "] Fino=[" + $Fino +
           "] invece di [2024.09.26] e [2026.06.30]. NON lancio: MT5 non protesta per una data storta e produrrebbe numeri PLAUSIBILI su una finestra NON DICHIARATA (checklist 79).")
  }
  Write-Host ("           finestra: " + $DaQuando + " -> " + $Fino + "   (ricontrollata adesso, non solo dichiarata in testa)") -ForegroundColor Gray
  #  -Terminal e -DataFolder passati ESPLICITI (checklist 37): il driver
  #  generico altrimenti ri-cerca il terminale per conto suo, e potrebbe
  #  trovarne uno diverso da quello su cui abbiamo compilato.
  $arg = @("-ExecutionPolicy","Bypass","-File",$Driver,
           "-Expert",$fam.Ea,"-Prova",(Join-Path $Prove $c.Prova),
           "-Simbolo",$fam.Sym,"-Periodo",$fam.Per,
           "-DaQuando",$DaQuando,"-Fino",$Fino,
           "-Etichetta",$c.Id,"-Modello",("" + $Modello),
           "-Deposito",("" + $Deposito),"-Spread",("" + $SpreadIni),
           "-Terminal",$Terminal,"-MetaEditor",$MetaEditor,"-DataFolder",$DataFolder)
  if($Rifai){ $arg += "-Rifai" }
  if($SoloControllo){ $arg += "-SoloControllo" }
  $global:LASTEXITCODE = 0
  try{
    & powershell.exe $arg 2>&1 | Tee-Object -FilePath (Join-Path $Logs ($c.Fam + "_" + $c.Id + ".txt")) | Out-Host
  }catch{
    [void]$Problemi.Add($c.Prova + ": il driver generico e' uscito con eccezione - " + $_.Exception.Message)
  }
  if($LASTEXITCODE -ne 0){
    [void]$Problemi.Add($c.Prova + ": il driver generico e' uscito con codice " + $LASTEXITCODE)
  }
  $c.Min = [math]::Round((New-TimeSpan -Start $tl -End (Get-Date)).TotalMinutes,1)

  if(-not $SoloControllo){
    #  >>> UN CSV VECCHIO NON E' UN CSV OK: SI GUARDA LA DATA.
    #  walkforward_generico.ps1 SALTA la finestra il cui CSV esiste gia'
    #  ("gia' fatto, salto"), e questa riga PRESCRIVE quel percorso
    #  (-OreMax che ferma a meta', -SoloCella per riprendere). Contando
    #  solo le righe, un file di un lancio precedente passerebbe per OK -
    #  e se fra i due lanci fosse cambiato il pin, META' ROUND VERREBBE DA
    #  UN ALTRO MOTORE.
    #  >>> E GLI STATI SONO TRE, NON DUE (checklist 49): il driver
    #      generico salta per FINESTRA, non per cella.
    $vecchie = @()
    foreach($tag in @("IS","OOS")){
      $pth = CsvDi $c $tag
      $nn = -1
      if(Test-Path -LiteralPath $pth){
        $nn = (@(Get-Content -LiteralPath $pth).Count) - 1
        if((Get-Item -LiteralPath $pth).LastWriteTime -lt $tl){ $vecchie += $tag }
      }
      if($tag -eq "IS"){ $c.IS = $nn } else { $c.OOS = $nn }
    }
    if($vecchie.Count -eq 2){
      $c.Esito = "SALTATA DAL DRIVER (IS+OOS gia' presenti da un lancio precedente)"
      [void]$Problemi.Add($c.Prova + ": " + $c.Esito + ". Le righe tornano ma i file NON sono di questo lancio: rilancia con -Rifai.")
    }
    elseif($vecchie.Count -eq 1){
      $c.Esito = "A META' (" + $vecchie[0] + " e' di un lancio PRECEDENTE, l'altra gamba e' di adesso)"
      [void]$Problemi.Add($c.Prova + ": " + $c.Esito + ". Le due gambe vengono da due giri diversi: rilancia questa cella con -Rifai.")
    }
    elseif([int]$c.IS -eq $CelleAttese -and [int]$c.OOS -eq $CelleAttese){ $c.Esito = "OK" }
    else{
      #  >>> ANCHE QUI LA SENTINELLA (checklist 66). Il -1 vuol dire "il CSV
      #      non c'e'", e scritto crudo in una frase si legge "meno una riga",
      #      che non vuol dire niente. La convenzione vale in TUTTE le
      #      colonne E in tutte le FRASI: in R103 era applicata a meta'.
      $c.Esito = "RIGHE SBAGLIATE (IS " + (FmtN $c.IS) + " / OOS " + (FmtN $c.OOS) + ", attese " + $CelleAttese + "; 'n/d' = il CSV non e' stato prodotto)"
      [void]$Problemi.Add($c.Prova + ": " + $c.Esito + ". Cache del tester, oppure lo sweep dei magic non ha spazzolato: il file NON si legge.")
    }

    # ---------- LE MISURE, lette dai CSV (parser col controllo positivo)
    $rOOS = LeggiOpt (CsvDi $c "OOS")
    $c.Gemelli = Gemelli $rOOS
    if($null -eq $rOOS){
      [void]$Problemi.Add($c.Prova + ": CSV OOS non letto o colonne non riconosciute. Intestazioni viste: [" + (($script:CsvIntestazioni | Select-Object -First 12) -join " | ") + "]")
    } elseif(@($rOOS).Count -ge 1){
      if($null -ne $rOOS[0].Pf){     $c.PfOOS   = [double]$rOOS[0].Pf }
      if($null -ne $rOOS[0].Dd){     $c.DdOOS   = [double]$rOOS[0].Dd }
      if($null -ne $rOOS[0].N){      $c.NOOS    = [int]$rOOS[0].N }
      if($null -ne $rOOS[0].Profit){ $c.ProfOOS = [double]$rOOS[0].Profit }
      if($null -ne $rOOS[0].Pg){     $c.PgOOS   = [double]$rOOS[0].Pg }
    }
    $rIS = LeggiOpt (CsvDi $c "IS")
    if($null -eq $rIS){
      [void]$Problemi.Add($c.Prova + ": CSV IS non letto o colonne non riconosciute.")
    } elseif(@($rIS).Count -ge 1){
      if($null -ne $rIS[0].Pf){     $c.PfIS   = [double]$rIS[0].Pf }
      if($null -ne $rIS[0].Dd){     $c.DdIS   = [double]$rIS[0].Dd }
      if($null -ne $rIS[0].N){      $c.NIS    = [int]$rIS[0].N }
      if($null -ne $rIS[0].Profit){ $c.ProfIS = [double]$rIS[0].Profit }
    }

    # ---------- I GATE, SOLO SULLA CELLA 00_metro
    if($c.Metro){
      $fam.Gemelli = $c.Gemelli
      $fam.NOOS = $c.NOOS; $fam.NIS = $c.NIS
      $fam.PfOOS = $c.PfOOS; $fam.DdOOS = $c.DdOOS; $fam.ProfOOS = $c.ProfOOS
      #  >>> G0-C: L'UNICO GATE NUMERICO CHE ESISTE IN QUESTO ROUND.
      #      Il metro NUMERICO (G0-B) non c'e' e non puo' esserci: R103
      #      girava a OHLC M1 su finestra unica, qui si gira a tick reali
      #      con lo split. Quello che si puo' ancora dimostrare e' che il
      #      banco e' DETERMINISTICO: due passate a parametri identici
      #      devono dare lo stesso numero al centesimo.
      if($c.Gemelli -ne "IDENTICI"){
        $fam.Metro = "IGIENE FALLITA (G0-C) -- gemelli: " + $c.Gemelli
        $FamFerme += $c.Fam
        [void]$Problemi.Add("GATE G0-C FALLITO sulla famiglia " + $c.Fam + ": gemelli " + $c.Gemelli +
                            ". Due passate a parametri identici hanno dato numeri diversi: il banco non e' deterministico e su questa famiglia NON si legge niente. Le celle dei lati NON sono state lanciate; le altre famiglie proseguono.")
        Dico ("GATE G0-C FALLITO su " + $c.Fam + ": " + $fam.Metro) "Red"
      } else {
        $fam.Metro = "G0-A OK (antenato) + G0-C OK (gemelli identici). G0-B NON APPLICABILE: misurato adesso PF " + (Fmt3 $c.PfOOS) + ", DD " + (Fmt2 $c.DdOOS) + "%, n " + (FmtN $c.NOOS)
        [void]$Rilievi.Add("G0-B sulla famiglia " + $c.Fam + ": NON APPLICABILE, e NON e' 'superato'. Il numero R103 di questa sedia (" + $fam.R103 +
                           ") viene da un ALTRO banco (modello 1 = OHLC su M1) e da un'ALTRA finestra (21 mesi pieni, senza split): non c'e' niente da riprodurre. Quello che e' dimostrato qui e' che i FILE sono quelli giusti (G0-A) e che il banco e' DETERMINISTICO (G0-C).")
        Dico ("G0-A + G0-C OK su " + $c.Fam + ". G0-B NON APPLICABILE (e non e' 'superato'). Metro misurato: PF " + (Fmt3 $c.PfOOS) + " | DD " + (Fmt2 $c.DdOOS) + "% | n " + (FmtN $c.NOOS)) "Yellow"
      }
      Dico ("   CANARINO " + $c.Fam + ": n IS " + (FmtN $c.NIS) + " / n OOS " + (FmtN $c.NOOS) + "   (NON e' un gate: Emendamento regola B)") "Yellow"
      if([int]$c.NOOS -ge 0 -and [int]$c.NOOS -lt 150){
        [void]$Rilievi.Add("CANARINO " + $c.Fam + ": il 00_metro fa n OOS = " + $c.NOOS + ", gia' sotto i 150 dell'Emendamento regola A. Le celle dei LATI faranno di meno per costruzione: su questa famiglia il giudizio di MERITO nasce SOSPESO (criteri par. 5, G4). E' un risultato, non un guasto.")
      }
    }
    else {
      #  ---------- LE CELLE DEI LATI
      #  sui lati il gemello e' comunque igiene, e va nei PROBLEMI
      if($c.Gemelli -ne "IDENTICI" -and $c.Gemelli -ne "NON MISURATO (CSV non letto)"){
        [void]$Problemi.Add($c.Prova + ": gemelli " + $c.Gemelli + ". Le due righe dovevano essere identiche al centesimo: questa cella non si legge.")
      }
      #  ---------- G1: la MISURABILITA'. Sotto 30 il verdetto e' "NON
      #  MISURABILE", MAI "non funziona" (criteri par. 5, G1). E' un
      #  RILIEVO, cioe' un risultato del round, non un guasto.
      if([int]$c.NOOS -ge 0 -and [int]$c.NOOS -lt 30){
        [void]$Rilievi.Add($c.Prova + ": n OOS = " + $c.NOOS + ", sotto la soglia G1 di 30. Il verdetto su questa cella e' NON MISURABILE, NON 'non funziona' (criteri par. 5, G1). E' una risposta del round.")
      }
      elseif([int]$c.NOOS -ge 150){
        [void]$Rilievi.Add($c.Prova + ": n OOS = " + $c.NOOS + ", SOPRA i 150 dell'Emendamento regola A. Su questa cella il giudizio di MERITO si puo' dare per intero -- ed e' raro su un lato solo di un motore di indici.")
      }
    }
  } else { $c.Esito = "SOLO CONTROLLO" }

  # --- L'ANTEPRIMA del giro a vuoto. Il driver generico la scrive sempre
  #     con lo stesso nome (anteprima_<EA>_<Simbolo>.ini, SENZA etichetta) e
  #     qui le celle di una famiglia girano TUTTE sullo stesso simbolo:
  #     senza metterla in sosta subito, ne resterebbe UNA sola e sarebbe
  #     l'ultima (checklist 31).
  if($SoloControllo){
    $ant = Join-Path $Work ("anteprima_" + $fam.Ea + "_" + $fam.Sym + ".ini")
    if(Test-Path -LiteralPath $ant){
      #  >>> E SI LEGGE, non si archivia soltanto. Quattro cose, che sono
      #      ESATTAMENTE quelle che il giro a vuoto puo' dire:
      #      (1) la finestra IS che il driver generico ha CALCOLATO davvero;
      #      (2) che l'unico asse spazzolato e' InpMagic (2 celle);
      #      (3) che il magic e' quello di QUESTA cella;
      #      (4) i DUE LATI, nell'ini che MT5 leggerebbe davvero.
      $atx = Get-Content -LiteralPath $ant -Raw
      $mf = [regex]::Match($atx,'(?m)^FromDate=([0-9.]+)\r?$')
      $mt = [regex]::Match($atx,'(?m)^ToDate=([0-9.]+)\r?$')
      if(-not $mf.Success -or -not $mt.Success){ [void]$Problemi.Add("giro a vuoto / " + $c.Fam + " " + $c.Id + ": nell'anteprima non trovo FromDate/ToDate.") }
      elseif($mf.Groups[1].Value -ne $IS_Da -or $mt.Groups[1].Value -ne $IS_A){
        [void]$Problemi.Add("giro a vuoto / " + $c.Fam + " " + $c.Id + ": il driver generico calcola la finestra IS " + $mf.Groups[1].Value + " - " + $mt.Groups[1].Value +
                            ", ma questa riga (e i criteri par. 4) dicono " + $IS_Da + " - " + $IS_A + ". O e' cambiata la FrazioneIS del driver, o e' cambiata la finestra: le due cose NON possono divergere.")
      }
      $assiY2 = @([regex]::Matches($atx,'(?m)^(\w+)=[^\r\n]*\|\|\s*[Yy]\s*\r?$') | ForEach-Object { $_.Groups[1].Value })
      if($assiY2.Count -ne 1 -or $assiY2[0] -ne "InpMagic"){
        [void]$Problemi.Add("giro a vuoto / " + $c.Fam + " " + $c.Id + ": gli assi spazzolati nell'anteprima sono [" + ($assiY2 -join ", ") + "] invece del solo InpMagic. Piu' di un asse = piu' di 2 celle per finestra, cioe' un altro round.")
      }
      if($atx -notmatch ('(?m)^InpMagic=' + $c.Magic + '\|\|')){
        [void]$Problemi.Add("giro a vuoto / " + $c.Fam + " " + $c.Id + ": nell'anteprima InpMagic non parte da " + $c.Magic + ".")
      }
      #  >>> E I DUE LATI, NELL'INI CHE GIRA DAVVERO. E' il controllo che
      #      un round sui LATI non puo' non fare: il file prova e' gia'
      #      stato verificato, ma quello che MT5 legge e' l'ini.
      foreach($k in $c.Val.Keys){
        if($atx -notmatch ('(?m)^' + $k + '=' + [regex]::Escape($c.Val[$k]) + '\s*\r?$') -and
           $atx -notmatch ('(?m)^' + $k + '=' + [regex]::Escape($c.Val[$k]) + '\|\|')){
          [void]$Problemi.Add("giro a vuoto / " + $c.Fam + " " + $c.Id + ": nell'anteprima " + $k + " non vale " + $c.Val[$k] + ". E' il LATO, cioe' l'unica cosa che questo round misura.")
        }
      }
      Copy-Item -LiteralPath $ant -Destination (Join-Path $Sosta ("anteprima_" + $c.Fam + "_" + $c.Id + ".ini")) -Force
      Remove-Item -LiteralPath $ant -Force -ErrorAction SilentlyContinue
    } else { [void]$Problemi.Add("giro a vuoto: nessuna anteprima .ini per " + $c.Prova) }
  }
  Write-Host ("    esito: " + $c.Esito + "   [" + $c.Min.ToString("0.0",$INV) + " min]") -ForegroundColor Gray
}

# --- LA RIGA DELLA SOMMA DEI LATI, per famiglia. NON e' un gate: e' un
#     RILIEVO, ed e' una delle due righe obbligatorie del referto
#     (criteri par. 5.1). Serve a impedire la lettura sbagliata che
#     chiunque farebbe guardando la tabella.
if(-not $SoloControllo){
  foreach($fam in $FamLavoro){
    $cm = @($Ordinati | Where-Object { $_.Fam -eq $fam.Id -and $_.Metro })
    $cl = @($Ordinati | Where-Object { $_.Fam -eq $fam.Id -and $_.Id -eq "01_long" })
    $cs = @($Ordinati | Where-Object { $_.Fam -eq $fam.Id -and $_.Id -eq "02_short" })
    if($cm.Count -eq 1 -and $cl.Count -eq 1 -and $cs.Count -eq 1){
      [void]$Rilievi.Add("SOMMA DEI LATI " + $fam.Id + " (OOS): metro n " + (FmtN $cm[0].NOOS) + " | long n " + (FmtN $cl[0].NOOS) + " | short n " + (FmtN $cs[0].NOOS) +
                         ". CHE LA SOMMA NON TORNI E' PER COSTRUZIONE: " + $fam.Ea + " esce dalla funzione di ingresso se ha gia' una posizione (o un pendente) PRIMA di guardare il lato, quindi con un lato spento lo slot resta libero e passano operazioni che nel metro erano bloccate. Non e' un difetto del banco.")
    }
  }
}

if($SoloControllo){
  $nAnt = @(Get-ChildItem -LiteralPath $Sosta -Filter "anteprima_*.ini" -ErrorAction SilentlyContinue).Count
  if($nAnt -ne $Ordinati.Count){ [void]$Problemi.Add("giro a vuoto: " + $nAnt + " anteprime .ini invece di " + $Ordinati.Count + ".") }
  Write-Host ""
  Write-Host ("    anteprime .ini in sosta: " + $nAnt + " su " + $Ordinati.Count + "   -> " + $Sosta) -ForegroundColor White
  Write-Host  "    >>> COSA SI LEGGE NELL'ANTEPRIMA, e cosa no:" -ForegroundColor Yellow
  Write-Host  "        SI LEGGE: FromDate/ToDate (la finestra IS vera, calcolata dal" -ForegroundColor Yellow
  Write-Host  "          driver generico: questa riga la CONFRONTA da sola con la sua)," -ForegroundColor Yellow
  Write-Host  "          il blocco [TesterInputs], l'unico asse Y (InpMagic), il magic," -ForegroundColor Yellow
  Write-Host  "          e I DUE LATI di questa cella." -ForegroundColor Yellow
  Write-Host  "        NON SI LEGGE: 'Model=4' e' una COSTANTE scritta a mano nel ramo" -ForegroundColor Yellow
  Write-Host  "          di prova del driver generico (cercare 'Model=4' li' dentro)." -ForegroundColor Yellow
  Write-Host  "          Stavolta COINCIDE con la corsa vera (-Modello 4), quindi non" -ForegroundColor Yellow
  Write-Host  "          mente -- ma resta una costante, non una conferma." -ForegroundColor Yellow
  Write-Host  "        E NON SI LEGGE NESSUN NUMERO DI ROUND: niente n, niente PF," -ForegroundColor Yellow
  Write-Host  "          niente DD, niente canarino, niente G0-C, niente somma dei lati." -ForegroundColor Yellow
}

}catch{
  $Fatale = $_.Exception.Message
  Write-Host ""
  Write-Host ("!!! FERMATO: " + $Fatale) -ForegroundColor Red
}

# =====================================================================
#  5. RACCOLTA. Si fa SEMPRE, anche a esito parziale o fermato.
# =====================================================================
Titolo "5. RACCOLTA SUL DESKTOP"
#  >>> OGNI ARTEFATTO DICE IN QUALE MODO E' STATO PRODOTTO (checklist 50). <<<
$Modo = if($SoloControllo){ "CONTROLLO" } elseif($SoloCella -ne ""){ "RIPRESA" } elseif($SoloEa -ne ""){ ("SOLO" + ($SoloEa.ToUpper() -replace '[,\s]+','')) } else { "CORSA" }
$Cart = Join-Path $Dsk ("R110_LATI_VIVI_" + $Modo + "_" + $Stamp)
$Zip  = Join-Path $Dsk ("R110_LATI_VIVI_" + $Modo + "_" + $Stamp + ".zip")
$Referto = Join-Path $Cart "REFERTO_R110.txt"
try{
  New-Item -ItemType Directory -Force -Path $Cart | Out-Null
  foreach($c in $Lavori){
    foreach($tag in @("IS","OOS")){
      $src = CsvDi $c $tag
      if(Test-Path -LiteralPath $src){ Copy-Item -LiteralPath $src -Destination (Join-Path $Cart (Split-Path -Leaf $src)) -Force }
    }
  }
  #  i file prova che HANNO GIRATO **e gli ANTENATI**, cosi' lo zip e'
  #  autosufficiente: chi lo apre fra un mese puo' rifare il gate G0-A a
  #  mano senza tornare in repo.
  foreach($dir in @($Prove,$Anten,$Sosta)){
    if($dir -and (Test-Path -LiteralPath $dir)){
      foreach($f in @(Get-ChildItem -LiteralPath $dir -File -ErrorAction SilentlyContinue)){
        Copy-Item -LiteralPath $f.FullName -Destination (Join-Path $Cart $f.Name) -Force
      }
    }
  }

  $RefTxt = New-Object System.Collections.ArrayList
  [void]$RefTxt.Add("REFERTO R110 - I LATI MAI MISURATI DEI MOTORI VIVI SUGLI INDICI")
  [void]$RefTxt.Add("SupRev NAS H1 (NASUSD) - SupRev DAX H4 (D30EUR) - SuperWave DOW H1 (U30USD) - EMA200 Dow (U30USD)")
  [void]$RefTxt.Add("modo: " + $Modo + $(if($SoloControllo){ "   <<< GIRO A VUOTO: NESSUNA passata, NESSUN CSV, NESSUN numero di round qui dentro" } else { "" }))
  $sw = @()
  if($SoloControllo){ $sw += "-SoloControllo (nessuna passata)" }
  if($CriteriFirmati){ $sw += "-CriteriFirmati (FIRMA IN RIGA di Claudio: il file dei criteri portava ancora [DA FIRMARE])" }
  if($SoloEa -ne ""){ $sw += "-SoloEa " + $SoloEa }
  if($SoloCella -ne ""){ $sw += "-SoloCella " + $SoloCella + " (il 00_metro della sua famiglia e' girato lo stesso: e' il denominatore e porta il gate G0-C)" }
  if($Rifai){ $sw += "-Rifai (i CSV precedenti sono stati rifatti)" }
  if($sw.Count -eq 0){ $sw += "nessuno (corsa piena, ripresa dei CSV gia' presenti ATTIVA)" }
  [void]$RefTxt.Add("switch di questo giro: " + ($sw -join " | "))
  [void]$RefTxt.Add("     Senza -Rifai il driver generico SALTA le finestre gia' presenti. I file saltati")
  [void]$RefTxt.Add("     sono marcati 'SALTATA DAL DRIVER' o 'A META'' e finiscono nei PROBLEMI, non in OK.")
  [void]$RefTxt.Add("stato dei criteri: " + $Firma)
  [void]$RefTxt.Add("data: " + (Get-Date).ToString("yyyy-MM-dd HH:mm:ss",$INV) + "   (questa data deve essere di ADESSO)")
  [void]$RefTxt.Add("     ATTENZIONE: la data fresca NON distingue un giro a vuoto da una corsa.")
  [void]$RefTxt.Add("     Quello che lo distingue e' la riga 'modo:' qui sopra e il NOME della cartella.")
  [void]$RefTxt.Add("avvio: " + $Avvio.ToString("yyyy-MM-dd HH:mm:ss",$INV) + "   durata: " + ((New-TimeSpan -Start $Avvio -End (Get-Date)).TotalHours).ToString("0.0",$INV) + " ore")
  [void]$RefTxt.Add("pin: " + $Pin)
  [void]$RefTxt.Add("criteri: risultati_archivio\R110_CRITERI.md   perimetro: CENSIMENTO_LATI_SHORT_2026-08-25.md (tab. 1d, par. 5 punti 1-2)")
  [void]$RefTxt.Add("finestra: " + $DaQuando + " -> " + $Fino + "   split 40/60   modello " + $Modello + " (tick reali)   deposito " + $Deposito)
  [void]$RefTxt.Add("     IS  " + $IS_Da + " - " + $IS_A)
  [void]$RefTxt.Add("     OOS " + $OOS_Da + " - " + $OOS_A)
  [void]$RefTxt.Add("     (le stesse di R88, R97, R98, R101 e R107: e' l'unico modo di leggere R110 accanto a R107)")
  [void]$RefTxt.Add("spread: Spread=" + $SpreadIni + " scritto NELL'INI = spread CORRENTE del feed BCM, dichiarato.")
  [void]$RefTxt.Add("     NON e' uno stress di spread e NON e' una misura dello spread.")
  [void]$RefTxt.Add("rischio: 1,00% nei file prova. IN CAMPO SUL 100K E' 0,65%.")
  [void]$RefTxt.Add("     >>> OGNI DD DI QUESTO REFERTO E' ALL'1%. Per confrontarlo col forward del")
  [void]$RefTxt.Add("     100k si MOLTIPLICA PER 0,65 (criteri par. 2.6). Chi salta la conversione")
  [void]$RefTxt.Add("     confronta due cose diverse.")
  [void]$RefTxt.Add("")
  [void]$RefTxt.Add("--- CONVENZIONE DI SENTINELLA (checklist 66) ---")
  [void]$RefTxt.Add("  Un numero NON MISURATO si scrive 'n/d'. MAI -1, MAI 0.000. Vale per TUTTE le")
  [void]$RefTxt.Add("  colonne: profitto, PF, DD, n e peggior giornata. Un '0.000' su un PF sarebbe un")
  [void]$RefTxt.Add("  numero PLAUSIBILE, e si leggerebbe 'ha perso tutto'.")
  [void]$RefTxt.Add("")
  [void]$RefTxt.Add("--- I GATE, E QUALE DI LORO PUO' MORDERE (criteri par. 5) ---")
  [void]$RefTxt.Add("  G0-A  ANTENATO : ogni cella e' la copia riga per riga del file prova R103 di")
  [void]$RefTxt.Add("                   quella sedia, salvo i delta DICHIARATI. Gira PRIMA di MT5.")
  [void]$RefTxt.Add("  G0-B  NUMERICO : NON APPLICABILE su tutte e quattro le famiglie, e NON e'")
  [void]$RefTxt.Add("                   'superato'. R103 e' l'unico posto coi numeri di queste sedie,")
  [void]$RefTxt.Add("                   ma girava a MODELLO 1 (OHLC su M1) su UNA FINESTRA UNICA di")
  [void]$RefTxt.Add("                   21 mesi; qui e' MODELLO 4 (tick reali) con lo split 40/60.")
  [void]$RefTxt.Add("                   Due banchi, due finestre: non c'e' niente da riprodurre.")
  [void]$RefTxt.Add("                   E che OHLC e tick reali NON diano lo stesso numero sugli")
  [void]$RefTxt.Add("                   indici e' MISURATO: SupRev_DOW_H4 fece PF 2,77 in OHLC e")
  [void]$RefTxt.Add("                   PF 0,79 a tick reali (revalidation 30/07, contratto REVOCATO).")
  [void]$RefTxt.Add("  G0-C  GEMELLI  : le due righe del CSV identiche al centesimo. E' l'unico gate")
  [void]$RefTxt.Add("                   NUMERICO del round: dimostra che il banco e' DETERMINISTICO,")
  [void]$RefTxt.Add("                   non che e' giusto.")
  foreach($fam in $FamLavoro){
    [void]$RefTxt.Add("")
    [void]$RefTxt.Add("  " + $fam.Id + " (" + $fam.Ea + " / " + $fam.Sym + " " + $fam.Per + ", sedia viva " + $fam.MagicVivo + ", sorgente " + $fam.MagicSrc + ")")
    [void]$RefTxt.Add("     antenato         : prove\" + $fam.Antenato)
    [void]$RefTxt.Add("     G0-A             : " + $fam.Antenati)
    [void]$RefTxt.Add("     numero R103      : " + $fam.R103)
    [void]$RefTxt.Add("                        ^^^ CONTESTO DICHIARATO, NON UN METRO (G0-B).")
    [void]$RefTxt.Add("     metro misurato   : PF " + (Fmt3 $fam.PfOOS) + " | DD " + (Fmt2 $fam.DdOOS) + "% | n " + (FmtN $fam.NOOS) + "   (OOS, tick reali)")
    [void]$RefTxt.Add("     gemelli (G0-C)   : " + $fam.Gemelli)
    [void]$RefTxt.Add("     VERDETTO         : " + $fam.Metro)
    [void]$RefTxt.Add("     CANARINO         : n IS " + (FmtN $fam.NIS) + " / n OOS " + (FmtN $fam.NOOS) + "   (NON e' un gate - Emendamento regola B)")
    [void]$RefTxt.Add("     nota             : " + $fam.Nota)
  }
  [void]$RefTxt.Add("")
  [void]$RefTxt.Add("  NOTA: 'NON MISURATO' NON e' 'va bene', e 'NON APPLICABILE' NON e' 'superato'.")
  [void]$RefTxt.Add("  Se i gemelli di una famiglia non sono identici, le sue celle dei lati non sono")
  [void]$RefTxt.Add("  state nemmeno lanciate -- e le altre famiglie sono andate avanti (decisione D5).")
  [void]$RefTxt.Add("")
  [void]$RefTxt.Add("--- LA TABELLA MADRE ---   (attese: " + $CelleAttese + " righe per CSV, " + (2*$Lavori.Count) + " CSV, " + (4*$Lavori.Count) + " passate)")
  [void]$RefTxt.Add("  IS e OOS accanto, perche' su un round sui LATI la differenza fra le due finestre")
  [void]$RefTxt.Add("  E' il risultato (vedi LA SPINA DORSALE in fondo). dPF e dDD sono il DELTA OOS")
  [void]$RefTxt.Add("  contro il 00_metro della stessa famiglia -- cioe' contro LA SEDIA, non contro")
  [void]$RefTxt.Add("  l'altro lato.")
  [void]$RefTxt.Add(("  {0,-7} {1,-9} {2,-9} {3,-7} {4,-7} {5,-6} {6,-9} {7,-7} {8,-7} {9,-6} {10,-8} {11,-7} {12,-8} {13}" -f `
                "FAM","CELLA","ISprof","ISpf","ISdd","ISn","OOSprof","OOSpf","OOSdd","OOSn","dPF","dDD%","PeggGio%","ESITO"))
  foreach($fam in $FamLavoro){
    foreach($c in @($Ordinati | Where-Object { $_.Fam -eq $fam.Id })){
      $dpf = "n/d"; $ddd = "n/d"
      if([double]$c.PfOOS -ge 0 -and [double]$fam.PfOOS -ge 0){ $dpf = ([double]$c.PfOOS - [double]$fam.PfOOS).ToString("+0.000;-0.000;0.000",$INV) }
      if([double]$c.DdOOS -ge 0 -and [double]$fam.DdOOS -ge 0){ $ddd = ([double]$c.DdOOS - [double]$fam.DdOOS).ToString("+0.00;-0.00;0.00",$INV) }
      [void]$RefTxt.Add(("  {0,-7} {1,-9} {2,-9} {3,-7} {4,-7} {5,-6} {6,-9} {7,-7} {8,-7} {9,-6} {10,-8} {11,-7} {12,-8} {13}" -f `
                    $c.Fam,$c.Id,(FmtE $c.ProfIS),(Fmt3 $c.PfIS),(Fmt2 $c.DdIS),(FmtN $c.NIS),
                    (FmtE $c.ProfOOS),(Fmt3 $c.PfOOS),(Fmt2 $c.DdOOS),(FmtN $c.NOOS),
                    $dpf,$ddd,(FmtPg $c.PgOOS),$c.Esito))
    }
  }
  [void]$RefTxt.Add("")
  [void]$RefTxt.Add("--- LA SOMMA DEI LATI: PERCHE' NON TORNA, E NON E' UN DIFETTO ---")
  [void]$RefTxt.Add("  MISURATO NEL SORGENTE, non dedotto: tutti e quattro i motori aprono la funzione")
  [void]$RefTxt.Add("  di ingresso con 'se ho gia' una posizione (o un pendente) esco', e SOLO DOPO")
  [void]$RefTxt.Add("  guardano il lato. Nel 00_metro un segnale short che arriva mentre e' aperta una")
  [void]$RefTxt.Add("  posizione LONG viene buttato via; nella cella 02_short quello slot e' libero e")
  [void]$RefTxt.Add("  quel segnale ENTRA.")
  [void]$RefTxt.Add("  >>> n(01_long) + n(02_short) NON deve fare n(00_metro). Chi lo pretende sta")
  [void]$RefTxt.Add("      leggendo il banco, non il motore. E il corollario che conta per il verdetto:")
  [void]$RefTxt.Add("      IL LATO LONG DA SOLO NON E' LA SEDIA VIVA, e nemmeno il lato short.")
  foreach($fam in $FamLavoro){
    $cm = @($Ordinati | Where-Object { $_.Fam -eq $fam.Id -and $_.Metro })
    $cl = @($Ordinati | Where-Object { $_.Fam -eq $fam.Id -and $_.Id -eq "01_long" })
    $cs = @($Ordinati | Where-Object { $_.Fam -eq $fam.Id -and $_.Id -eq "02_short" })
    $nm = $(if($cm.Count -eq 1){ FmtN $cm[0].NOOS } else { "n/d" })
    $nl = $(if($cl.Count -eq 1){ FmtN $cl[0].NOOS } else { "n/d" })
    $ns = $(if($cs.Count -eq 1){ FmtN $cs[0].NOOS } else { "n/d" })
    [void]$RefTxt.Add(("  {0,-7} OOS:  metro n {1,-6} long n {2,-6} short n {3,-6}" -f $fam.Id,$nm,$nl,$ns))
  }
  [void]$RefTxt.Add("")
  [void]$RefTxt.Add("--- LE CELLE, COME SONO SCRITTE NEI FILE CHE HANNO GIRATO ---")
  foreach($c in $Ordinati){
    $dd2 = $(if(@($c.Diff).Count -eq 0){ "(niente: e' la cella VIVA tale e quale)" } else { ($c.Diff -join " + ") })
    $lati = "InpAllowLong=" + $c.Val["InpAllowLong"] + " / InpAllowShort=" + $c.Val["InpAllowShort"]
    [void]$RefTxt.Add(("  {0,-7} {1,-9} magic {2}/{3}   {4}   muove: {5}" -f $c.Fam,$c.Id,$c.Magic,($c.Magic+1),$lati,$dd2))
    [void]$RefTxt.Add("       " + $c.Desc)
    [void]$RefTxt.Add("       G0-A: " + $c.Antenato)
  }
  [void]$RefTxt.Add("")
  [void]$RefTxt.Add("--- LA SPINA DORSALE: DOVE STANNO LE DISCESE (criteri par. 4.2) ---")
  [void]$RefTxt.Add("  FATTO DI CALENDARIO: la discesa documentata dentro questa finestra e' la")
  [void]$RefTxt.Add("  correzione di FEBBRAIO-APRILE 2025, e cade DENTRO L'IS (l'IS finisce il")
  [void]$RefTxt.Add("  " + $IS_A + "). L'OOS e' quasi tutto salita.")
  [void]$RefTxt.Add("  >>> COME SI LEGGE UNO SHORT VERDE IN IS E ROSSO IN OOS: la prima ipotesi NON e'")
  [void]$RefTxt.Add("      'il lato e' rumore', e' che L'EDGE DELLO SHORT VIVA NELLE DISCESE e che l'IS")
  [void]$RefTxt.Add("      ne contenga una mentre l'OOS quasi no.")
  [void]$RefTxt.Add("  >>> E C'E' UN FATTO NUOVO CHE PUNTA LI', ED E' DI IERI: R107 ha misurato il NAS")
  [void]$RefTxt.Add("      short a PF IS 3,220 e PF OOS 0,460 -- l'IS con la discesa dentro, l'OOS")
  [void]$RefTxt.Add("      senza. E' il segnale piu' forte che l'archivio abbia su questa ipotesi.")
  [void]$RefTxt.Add("  >>> [INFERITO], E RESTA [INFERITO]: questo round NON misura i sotto-periodi.")
  [void]$RefTxt.Add("      Non sa quanto del profitto IS venga da febbraio-aprile, e NON sa se l'OOS")
  [void]$RefTxt.Add("      contenga discese di ampiezza paragonabile. Non lo assuma nessuno.")
  [void]$RefTxt.Add("      La misura vera e' un round di PROVA DI REGIME fatto apposta -- che oggi e'")
  [void]$RefTxt.Add("      BLOCCATO dal frigo dei dati esterni sugli indici.")
  [void]$RefTxt.Add("")
  [void]$RefTxt.Add("--- QUELLO CHE QUESTO REFERTO NON DICE, DICHIARATO ---")
  [void]$RefTxt.Add("  * NON APPLICA I CANCELLI. G1 (n>=30), G2 (PF OOS >= 1,10 E positivo in IS),")
  [void]$RefTxt.Add("    G3 (coerenza cross-motore) e G4 (campione) li applica il REFERTO DEL ROUND,")
  [void]$RefTxt.Add("    a mano, sopra questa tabella. Qui ci sono i numeri, non i verdetti.")
  [void]$RefTxt.Add("  * G3 in particolare NON e' meccanizzabile qui: e' il confronto fra QUATTRO")
  [void]$RefTxt.Add("    tabelle, su tre mercati e due logiche diverse. Ed e' il cancello che in R46")
  [void]$RefTxt.Add("    fermo' un candidato che faceva +31%.")
  [void]$RefTxt.Add("  * NON RIPRODUCE R103 e non pretende di farlo (G0-B). I numeri R103 in questo")
  [void]$RefTxt.Add("    referto sono CONTESTO, e sono di un altro banco.")
  [void]$RefTxt.Add("  * SE UN 01_long PASSA G2 E IL SUO 02_short E' ROSSO, la lettura NON e' 'lo short")
  [void]$RefTxt.Add("    non serve': e' 'questa sedia POTREBBE essere long-only', che e' una PROPOSTA")
  [void]$RefTxt.Add("    DI MODIFICA DI CONTRATTO -- cioe' un round successivo con la sua firma")
  [void]$RefTxt.Add("    (regola R52: non si spegne un lato guardando i risultati).")
  [void]$RefTxt.Add("  * NON PROMUOVE NIENTE (G5). Tutte e QUATTRO le sedie stanno sul conto 100k: un")
  [void]$RefTxt.Add("    cambio al forward e' una firma successiva, con il suo referto.")
  [void]$RefTxt.Add("  * NON misura lo spread, non misura i sotto-periodi, non fa la prova di regime.")
  [void]$RefTxt.Add("  * NON ESTENDE NIENTE agli altri CINQUE motori simmetrici mai smontati del")
  [void]$RefTxt.Add("    censimento (PTE Dow, PunteLarry, GapFill, SuperWave H2, SupRev Nikkei):")
  [void]$RefTxt.Add("    restano NON MISURATI, e vanno detti tali.")
  [void]$RefTxt.Add("  * LA FINESTRA E' UN SOLO REGIME (21 mesi di indici che salgono) e IL LATO SHORT")
  [void]$RefTxt.Add("    PARTE SVANTAGGIATO PER REGIME. Un 'niente edge short' qui NON chiude la")
  [void]$RefTxt.Add("    domanda per sempre: la chiude PER QUESTA EPOCA e per questi quattro motori.")
  [void]$RefTxt.Add("")
  if($Rilievi.Count -gt 0){
    [void]$RefTxt.Add("--- RILIEVI (NON sono guasti: sono RISULTATI del round) ---   (" + $Rilievi.Count + ")")
    foreach($n in $Rilievi){ [void]$RefTxt.Add("  - " + $n) }
    [void]$RefTxt.Add("")
  }
  [void]$RefTxt.Add("--- PROBLEMI (questi SI sono guasti) ---   (" + $Problemi.Count + ")")
  if($Problemi.Count -eq 0){ [void]$RefTxt.Add("  nessuno.") }
  foreach($p in $Problemi){ [void]$RefTxt.Add("  - " + $p) }
  if($Fatale -ne ""){
    [void]$RefTxt.Add("")
    [void]$RefTxt.Add("--- FERMATO ---")
    [void]$RefTxt.Add("  " + $Fatale)
  }
  [void]$RefTxt.Add("")
  # --- L'ESITO SCRITTO NEL REFERTO DICE LE STESSE PAROLE DELLO SCHERMO.
  #     E DISTINGUE 'PARZIALE' da 'COMPLETO CON RILIEVI'.
  $koR = @($Ordinati | Where-Object { $_.Esito -ne "OK" -and $_.Esito -ne "SOLO CONTROLLO" })
  if($Fatale -ne ""){
    [void]$RefTxt.Add("ESITO: FERMATO -- " + $Fatale)
  }
  elseif($SoloControllo){
    if($koR.Count -gt 0 -or $Problemi.Count -gt 0){
      [void]$RefTxt.Add("ESITO: GIRO A VUOTO CON PROBLEMI (" + $Problemi.Count + ") -- NESSUNA passata. NON lanciare la corsa vera prima di aver letto i PROBLEMI.")
    } else {
      [void]$RefTxt.Add("ESITO: GIRO A VUOTO COMPLETATO -- NESSUNA passata, NESSUN CSV, NESSUN numero. QUESTO ZIP NON E' IL ROUND.")
    }
  }
  elseif($koR.Count -gt 0){
    [void]$RefTxt.Add("ESITO: PARZIALE -- " + $koR.Count + " celle su " + $Ordinati.Count + " NON hanno prodotto i numeri (elenco qui sopra), piu' " + $Problemi.Count + " problemi. NON e' un round completo.")
  }
  elseif($Problemi.Count -gt 0){
    [void]$RefTxt.Add("ESITO: COMPLETO CON PROBLEMI -- tutte e " + $Ordinati.Count + " le celle hanno prodotto i numeri attesi, ma ci sono " + $Problemi.Count + " problemi. I numeri ci sono: si leggono ACCANTO ai problemi, non invece dei problemi.")
  }
  elseif($Rilievi.Count -gt 0){
    [void]$RefTxt.Add("ESITO: COMPLETO CON RILIEVI -- tutte e " + $Ordinati.Count + " le celle hanno prodotto i numeri attesi. I " + $Rilievi.Count + " rilievi sono RISULTATI del round (canarino, G1 non misurabile, G0-B non applicabile, somma dei lati), non guasti.")
  }
  else{
    [void]$RefTxt.Add("ESITO: OK -- tutte le celle hanno prodotto i numeri attesi, nessun problema e nessun rilievo in elenco.")
  }
  [void]$RefTxt.Add("")
  [void]$RefTxt.Add("--- COME SI RIPRENDE ---")
  [void]$RefTxt.Add('  una famiglia sola  : ... & $p -Pin <PIN> -CriteriFirmati -SoloEa ''EMADOW''')
  [void]$RefTxt.Add('  due famiglie       : ... & $p -Pin <PIN> -CriteriFirmati -SoloEa ''SWDOW,EMADOW''   <-- FRA APICI (checklist 65)')
  [void]$RefTxt.Add('  una cella sola     : ... & $p -Pin <PIN> -CriteriFirmati -SoloCella R110_EMADOW_02_short.txt')
  [void]$RefTxt.Add("  >>> in tutti i casi il 00_metro della famiglia rigira: e' il denominatore e")
  [void]$RefTxt.Add("      porta il gate G0-C. Costa 2 CSV, non una passata sprecata.")
  [void]$RefTxt.Add("  >>> e i tre puntini stanno per IL BLOCCO INTERO della riga di lancio, con il")
  [void]$RefTxt.Add("      suo irm e la sua guardia: si riprende da RIGA_R110_DA_MANDARE.md.")
  [void]$RefTxt.Add("  rifare cio' che c'e' gia' : aggiungi -Rifai")

  Set-Content -LiteralPath $Referto -Value ($RefTxt -join "`r`n") -Encoding UTF8
  if(Test-Path -LiteralPath $Zip){ Remove-Item -LiteralPath $Zip -Force -ErrorAction SilentlyContinue }
  Compress-Archive -Path (Join-Path $Cart "*") -DestinationPath $Zip -Force
}catch{
  Write-Host ("!!! RACCOLTA PARZIALE: " + $_.Exception.Message) -ForegroundColor Red
}

Write-Host ""
Write-Host "=====================================================================" -ForegroundColor White
Write-Host "  R110 - FINE" -ForegroundColor White
function Riga3([string]$path,[string]$coda){
  if(Test-Path -LiteralPath $path){ Write-Host ("   " + $path + "   " + $coda) -ForegroundColor White }
  else                            { Write-Host ("   " + $path + "   <<< NON ESISTE") -ForegroundColor Red }
}
Riga3 $Cart    ""
Riga3 $Zip     "<- e' questo che mi mandi"
Riga3 $Referto "<- la riga 'data:' deve essere di ADESSO, la riga 'modo:' dice se e' il round o un giro a vuoto"
Write-Host "=====================================================================" -ForegroundColor White
#  >>> L'ETICHETTA NON PUO' DIRE "PASSATO" QUANDO NON E' STATO ESEGUITO
#      (checklist 47 e 50).
if($SoloControllo){
  Write-Host ("  MODO: " + $Modo + " -- GIRO A VUOTO. NESSUNA passata, NESSUN CSV, NESSUN") -ForegroundColor Yellow
  Write-Host ("        numero di round. Anteprime .ini attese: " + $Ordinati.Count + ".") -ForegroundColor Yellow
  Write-Host  "        GATE G0-C e SOMMA DEI LATI: NON ESEGUITI, ed e' giusto cosi'." -ForegroundColor Yellow
  Write-Host  "        (G0-A l'antenato, quello SI: gira PRIMA di MT5 ed e' gia' passato.)" -ForegroundColor Yellow
  Write-Host  "        QUESTO ZIP NON E' IL ROUND e non va mandato come risultato." -ForegroundColor Yellow
} else {
  Write-Host ("  MODO: " + $Modo) -ForegroundColor White
  Write-Host ("  ATTESI:  " + (2*$Lavori.Count) + " CSV (" + $Lavori.Count + " celle x IS/OOS), " + $CelleAttese + " righe l'uno, " + (4*$Lavori.Count) + " passate.") -ForegroundColor White
  foreach($fam in $FamLavoro){
    $col = if($fam.Metro -like "G0-A OK*"){ "Green" } elseif($fam.Metro -eq "NON MISURATO"){ "Yellow" } else { "Red" }
    Write-Host ("  METRO " + $fam.Id + ": " + $fam.Metro) -ForegroundColor $col
    Write-Host ("     CANARINO " + $fam.Id + ": n IS " + (FmtN $fam.NIS) + " / n OOS " + (FmtN $fam.NOOS) + "   (NON e' un gate: regola B)") -ForegroundColor White
  }
}
foreach($c in $Ordinati){
  $col = "Green"; if($c.Esito -ne "OK" -and $c.Esito -ne "SOLO CONTROLLO"){ $col = "Yellow" }
  Write-Host ("   " + ($c.Fam + " " + $c.Id).PadRight(20) + " " + $c.Esito) -ForegroundColor $col
}
if($Rilievi.Count -gt 0){
  Write-Host ""
  Write-Host "   RILIEVI (risultati del round, NON guasti):" -ForegroundColor Yellow
  foreach($n in $Rilievi){ Write-Host ("    - " + $n) -ForegroundColor Yellow }
}
if($Problemi.Count -gt 0){
  Write-Host ""
  Write-Host "   PROBLEMI DA LEGGERE:" -ForegroundColor Red
  foreach($p in $Problemi){ Write-Host ("    - " + $p) -ForegroundColor Red }
}
Write-Host ""
# =====================================================================
#  L'ESITO IN CONSOLE DICE LE STESSE PAROLE DEL REFERTO, o i due si
#  contraddicono: chi legge lo schermo e manda lo zip non ha visto il
#  referto.
#  >>> E OGNI RAMO FINISCE CON UN exit ESPLICITO. Senza, il codice di
#      uscita e' quello dell'ULTIMO comando eseguito e il blocco che si
#      incolla in chat (che guarda $LASTEXITCODE) puo' annunciare
#      "PARZIALE O FERMO" su un round perfetto.
#  >>> E GLI STATI SONO PIU' DI DUE (checklist 68): "COMPLETO CON
#      RILIEVI" e' un successo e esce 0.
#      CODICI: 0 = OK / COMPLETO CON RILIEVI
#              1 = parziale, fermato, con problemi, o selettore a vuoto
#              2 = criteri non firmati
# =====================================================================
if($Fatale -ne ""){ Write-Host ("ESITO: FERMATO -- " + $Fatale) -ForegroundColor Red; exit 1 }
$ko = @($Ordinati | Where-Object { $_.Esito -ne "OK" -and $_.Esito -ne "SOLO CONTROLLO" })
if($SoloControllo){
  if($ko.Count -gt 0 -or $Problemi.Count -gt 0){
    Write-Host ("ESITO: GIRO A VUOTO CON PROBLEMI (" + $Problemi.Count + ") -- NESSUNA passata, e c'e' da leggere il referto") -ForegroundColor Yellow
    exit 1
  }
  Write-Host "ESITO: GIRO A VUOTO COMPLETATO -- NESSUNA passata, NESSUN CSV. QUESTO ZIP NON E' IL ROUND." -ForegroundColor Green
  exit 0
}
if($ko.Count -gt 0){
  Write-Host ("ESITO: PARZIALE (" + $ko.Count + " celle su " + $Ordinati.Count + " non hanno prodotto i numeri, " + $Problemi.Count + " problemi) -- lo zip esiste: mandalo") -ForegroundColor Yellow
  exit 1
}
if($Problemi.Count -gt 0){
  Write-Host ("ESITO: COMPLETO CON PROBLEMI (" + $Problemi.Count + ") -- i numeri ci sono TUTTI, ma vanno letti ACCANTO ai problemi. Lo zip esiste: mandalo.") -ForegroundColor Yellow
  exit 1
}
if($Rilievi.Count -gt 0){
  #  Solo rilievi dichiarativi (canarino, G1 non misurabile, G0-B non
  #  applicabile, somma dei lati): NON e' un fallimento, e quindi NON esce 1.
  Write-Host ("ESITO: COMPLETO CON RILIEVI (" + $Rilievi.Count + " rilievi da leggere nel referto, nessuna cella mancante e nessun guasto)") -ForegroundColor Green
  exit 0
}
Write-Host "ESITO: OK" -ForegroundColor Green
exit 0
