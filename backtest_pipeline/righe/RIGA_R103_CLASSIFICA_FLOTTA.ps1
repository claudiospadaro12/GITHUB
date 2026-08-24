# =====================================================================
#  MARCATORE_RIGA_R103_v1
#  RIGA_R103_CLASSIFICA_FLOTTA.ps1  --  R103: LA CLASSIFICA DELLA FLOTTA.
#  TUTTE E 40 le sedie di trading dei due conti, ognuna sulla sua cella
#  VIVA, misurate su una finestra RECENTE e COMUNE al loro gruppo.
# ---------------------------------------------------------------------
#  CRITERI: backtest_pipeline\risultati_archivio\R103_CRITERI.md
#  PROPOSTA FIRMATA: risultati_archivio\R103_PROPOSTA_CLASSIFICA_FLOTTA.md
#    >>> Claudio, 24/08/2026: "FIRMO TUTTE E TRE, PARTIAMO"
#        1. finestra COMUNE 2020.01.01 -> 2026.06.30 (6,5 anni, col covid)
#        2. le 15 sedie INDICI in tabella SEPARATA a 21 mesi, etichettate
#        3. due colonne di profitto (taglia viva + normalizzato 1%),
#           E SI ORDINA SUL NORMALIZZATO
#    >>> e il CHIARIMENTO della stessa mattina, che e' un REQUISITO:
#        "vorrei capire se esistono anni negativi x qualcuno"
#        -> LA SPINA DORSALE PERIODO PER PERIODO E' OBBLIGATORIA PER
#           TUTTE E 40 LE SEDIE, e ogni riga della classifica porta la
#           colonna PERIODI NEGATIVI / PERIODI OPERATI.
#
#  DA DOVE NASCE, dichiarato: e' RIGA_R102_CLASSIFICA_LUNGA.ps1 (pin
#  fd23d4a) SEMPLIFICATA (una finestra per sedia invece di sei) e
#  ALLARGATA (due gruppi con due finestre, la normalizzazione, la sedia
#  senza OPTFRAME). Il punto 9 della checklist dice che una riscrittura
#  non puo' perdere le funzioni di sicurezza del gemello: sono state
#  riportate TUTTE -- guardia MT5/MetaEditor chiusi, download pinnato
#  col marcatore, install dell'include ABTG_PausaGuardian.mqh, [Charts]
#  MaxBars, compilazione DIRETTA col verdetto LastWriteTime + backup
#  datato + ripristino del .mq5 se fallisce, SOSTA SVUOTATA A OGNI GIRO,
#  artefatti in sosta col nome proprio PRIMA dei gate, funzioni sopra il
#  try, MODO nel nome della cartella, log letti A OFFSET, \r? davanti a
#  ogni $ multilinea, cultura INVARIANTE, parametri numerici TIPIZZATI
#  (checklist 64), -SoloSedia con split '[,\s]+' (checklist 65), filtro
#  $idBlocco nella raccolta, raccolta SEMPRE, esiti PARZIALE vs COMPLETO
#  CON RILIEVI, exit 0 esplicito in fondo, parser dei deal corretto
#  ('Bilancio' fra i sinonimi + netto = Profitto+Commissioni+Swap).
#
#  ------------------------------------------------------------------
#  LA DOMANDA DEL ROUND, ed e' di Claudio (24/08, in chat):
#    "IO VOLEVO LA CLASSIFICA DI TUTTI I NOSTRI EA. DI TUTTI QUELLI TRA
#     CONTO PICCOLO E CONTO GRANDE. NON MI INTERESSA LA CLASSIFICA DAL
#     1999, MI INTERESSA UNA CLASSIFICA GIUSTA, + RECENTE, DI ALMENO 5
#     ANNI"
#  ------------------------------------------------------------------
#
#  ------------------------------------------------------------------
#  QUELLO CHE QUESTO ROUND NON FA, e sta PRIMA dei numeri:
#    - NON PROMUOVE E NON BOCCIA NIENTE. Una classifica e'
#      un'informazione per decidere, non un verdetto automatico. Le
#      uscite restano quelle della C3 del 18/08, che girano sul
#      FORWARD, non su un backtest.
#    - NON ottimizza: una cella per sedia, quella VIVA. L'unico asse Y
#      e' InpMagic, che e' la coppia gemella di controllo.
#    - NON tocca nessuna sedia viva: magic VERGINI del blocco 76xxxx
#      (verificato magic per magic, tutti e 120: zero occorrenze nel
#      repo). Vietati e controllati nel codice tutti i magic vivi del
#      censimento .chr del 23/08 e i blocchi gia' spesi 7799xx (R99),
#      78xxxx (R100), 79xxxx (R102), 7732xx/7733xx (R101) e 750xxx
#      (R104, preso il 24/08).
#    - NON da' il DD di PORTAFOGLIO. 40 sedie non fanno un DD pari alla
#      somma dei loro ne' pari al massimo: dipende da QUANTO SI
#      SOVRAPPONGONO, e questo round le misura UNA PER UNA. Sette sedie
#      stanno su GBPUSD e otto su U30USD: e' la domanda successiva
#      ovvia, ed e' un round diverso (macchina R16/R34).
#    - NON scarica tick (salvo -TickReali, che e' [DA FIRMARE] e vale
#      SOLO per il gruppo INDICI) e non svuota bases\<server>\ticks.
#  ------------------------------------------------------------------
#
#  ------------------------------------------------------------------
#  IL LIMITE PIU' GRANDE, SCRITTO QUI E NON IN FONDO: IL MODELLO.
#  Modello 1 = OHLC su M1, per tutte e 40. Conseguenza, in due
#  direzioni diverse:
#    - il DD e la peggior giornata sono un LIMITE INFERIORE del rischio
#      (l'OHLC non vede i percorsi dentro la barra);
#    - il PROFITTO e' una STIMA DEL LORDO, e generosa: spread corrente,
#      nessuno slippage, nessun requote, riempimenti ideali.
#  >>> UN NUMERO DI PROFITTO DI QUESTO ROUND NON E' UN GUADAGNO. E' un
#      ordine di grandezza per confrontare le sedie FRA LORO.
#  >>> E SUGLI INDICI L'OHLC HA GIA' MENTITO, ed e' MISURATO: il 30/07
#      la revalidation a tick reali ha ribaltato SupRev_DOW_H4 da PF
#      2,77 (OHLC) a PF 0,79 (tick reali), "illusione OHLC", contratto
#      REVOCATO. Sulla finestra degli indici i tick reali ESISTONO
#      (BCM li ha dal 2024.07.05) e R101 li ha usati: qui si gira in
#      OHLC perche' e' quello che dice la proposta FIRMATA, e lo switch
#      -TickReali sta li' pronto per la seconda corsa, se Claudio firma.
#  ------------------------------------------------------------------
#
#  COSA FA, in ordine, e DA SOLA:
#    0. si rifiuta di partire se MT5 O MetaEditor sono aperti
#    1. scarica AL PIN report\CONTRATTI_SEDIE.md e scarica_storico.ps1
#    2. PASSO 0-A: per OGNI SIMBOLO DISTINTO barre M1 + i TF di grafico
#       che servono, dalla data della FINESTRA DEL SUO GRUPPO,
#       -SenzaTick, col VERDETTO confrontato con la data chiesta
#    3. POI, UNA SEDIA ALLA VOLTA (mai in parallelo), per ognuna:
#       a. il SUO file prova e il SUO sorgente, coi gate di versione
#       b. il SUO DD promesso da CONTRATTI_SEDIE.md, PER COLONNA e col
#          vincolo su SIMBOLO e MAGIC
#       c. compila il SUO .mq5 (una volta per EA: 20 EA, 40 sedie)
#       d. una passata SINGOLA -> log (prima operazione) + report .htm
#          (deal -> spina dorsale, peggior giornata, SECONDA MISURA)
#       e. due passate GEMELLE -> OptResults (profitto, PF, DD, n) e il
#          gate dei gemelli identici
#    4. raccolta SEMPRE: cartella sul Desktop + zip, con LE DUE TABELLE
#       (FOREX 6,5 anni e INDICI 21 mesi) ordinate sul NORMALIZZATO.
#
#  QUANTO CI METTE: [STIMA] in DURATA SIMULATA. FOREX 25 x 3 x 6,5 =
#  ~488 anni-sedia; INDICI 15 x 3 x 1,76 = ~79. Totale ~567, contro gli
#  ~886 di R100 (stimato 2-6 ore) e i ~2.280 di R102.
#  >>> ORDINE DI GRANDEZZA ATTESO: 1,5-4 ORE DI TESTER, PIU' LO SCARICO
#      DELLE BARRE M1 DI 17 SIMBOLI, che e' il collo di bottiglia vero.
#      -OreMax e' 12 (tetto sull'INIZIO di nuovi lavori).
#
#  LA RIGA CHE SI INCOLLA (blocco INTERO, un comando solo - checklist 21).
#  <PIN> = il commit che contiene QUESTO file: e' l'hash dato in chat.
#
#  & { $ErrorActionPreference='Stop'; [Net.ServicePointManager]::SecurityProtocol=[Net.SecurityProtocolType]::Tls12;
#      if(Get-Process terminal64,metaeditor64 -EA SilentlyContinue){ throw 'MT5 O METAEDITOR APERTO: chiudili e rilancia.' };
#      $pin='<PIN>'; $p="$env:USERPROFILE\RIGA_R103.ps1"; Remove-Item $p -EA SilentlyContinue;
#      irm "https://raw.githubusercontent.com/claudiospadaro12/GITHUB/$pin/backtest_pipeline/righe/RIGA_R103_CLASSIFICA_FLOTTA.ps1" -OutFile $p;
#      if(-not (Select-String -Path $p -SimpleMatch -Pattern 'MARCATORE_RIGA_R103_v1' -Quiet)){ throw 'SCRIPT VECCHIO' };
#      $global:LASTEXITCODE=0; & $p -Pin $pin; if($LASTEXITCODE -ne 0){ Write-Host 'ESITO: PARZIALE O FERMO - leggi il REFERTO' } }
#
#  GIRO A VUOTO (pochi minuti, nessuna passata, nessun MT5 che opera):
#    ... & $p -Pin $pin -SoloControllo
#  Il giro a vuoto scrive e verifica GLI STESSI .ini che girano nella
#  corsa vera. Non c'e' un secondo artefatto (checklist 33).
#  >>> E NON MISURA NESSUN NUMERO: senza tester non esiste nessun DD,
#      nessun profitto, nessun n, nessuna spina dorsale, nessuna
#      classifica. Sta scritto anche nel suo referto, perche' non lo si
#      scambi per il round (checklist 57).
# =====================================================================
param(
  # -Pin NON ha default: un default silenzioso ("lavoro") farebbe girare la
  #  punta del branch spacciandola per un commit congelato. Meglio morire.
  [string]$Pin        = "",
  [double]$OreMax     = 12.0,      # oltre questo NON si iniziano nuovi lavori
  [switch]$Rifai,                  # rifa' anche cio' che e' gia' presente
  [switch]$SoloControllo,
  [switch]$SenzaStorico,           # salta SOLO il PASSO 0-A (le barre)
  [string]$SoloSedia  = "",        # es. "F01" oppure "F01,F02,F03": un BLOCCO.
                                   #   E' il modo previsto di lanciare questo
                                   #   round. L'elenco VA FRA APICI nella riga
                                   #   di chat (checklist 65).
  [string]$SoloGruppo = "",        # "FOREX" oppure "INDICI". Si combina con
                                   #   -SoloSedia (intersezione). Serve per la
                                   #   corsa piu' comoda di tutte: il gruppo
                                   #   INDICI e' 21 mesi x 15 sedie.
  [switch]$TickReali               # [DA FIRMARE] SOLO per il gruppo INDICI:
                                   #   modello 4 invece di 1. Sulla finestra
                                   #   degli indici i tick reali ESISTONO e
                                   #   l'OHLC e' MISURATAMENTE ottimista
                                   #   (SupRev_DOW_H4: PF 2,77 -> 0,79). NON
                                   #   e' il default perche' la proposta
                                   #   firmata dice OHLC: si accende solo su
                                   #   firma, e allora cambia UNA cosa sola.
)
$ErrorActionPreference = "Stop"
[Threading.Thread]::CurrentThread.CurrentCulture   = [Globalization.CultureInfo]::InvariantCulture
[Threading.Thread]::CurrentThread.CurrentUICulture = [Globalization.CultureInfo]::InvariantCulture
[Net.ServicePointManager]::SecurityProtocol = [Net.SecurityProtocolType]::Tls12
$INV = [Globalization.CultureInfo]::InvariantCulture

$Avvio = Get-Date
$Stamp = $Avvio.ToString("yyyyMMdd_HHmm", $INV)
$Dsk   = Join-Path $env:USERPROFILE "Desktop"
$Work  = Join-Path $env:USERPROFILE "abtg_r103"
$Prove = Join-Path $Work "prove"
$Logs  = Join-Path $Work "log_r103"
$SrcDir= Join-Path $Work "src_motori"
$RawPin= "https://raw.githubusercontent.com/claudiospadaro12/GITHUB/$Pin"

$Fino      = "2026.06.30"     # scritto nella proposta FIRMATA, uguale a R99/R100/R102
$DaForex   = "2020.01.01"     # DECISIONE 1 firmata: 6,5 anni, col crollo covid dentro
$DaIndici  = "2024.09.26"     # DECISIONE 2 firmata: NON e' una scelta, e' il muro del
                              #  broker (sonda 17/08: verdetto COMPLETO a questa data)
$Modello   = 1                # OHLC M1. Vedi l'intestazione.
$ModelloIx = 1                # gli INDICI: 1 di default, 4 con -TickReali
$Deposito  = 100000           # la taglia dei round per-trade di casa
$SpreadIni = 0                # 0 = spread CORRENTE, ma SCRITTO nell'ini invece
                              #  che lasciato allo stato nascosto del terminale.
                              #  NON e' uno stress di spread e NON e' una misura.
$Suffisso  = "_ohlc"          # regola di casa: un OHLC non deve nemmeno poter
                              #  finire nella stessa tabella di un tick reale
$SuffissoIx= "_ohlc"
$CelleAttese = 2              # le due passate GEMELLE di controllo
if($TickReali){ $ModelloIx = 4; $SuffissoIx = "_tick" }

#--- I GATE (criteri R103 par. 5)
$MesiPrimaOp = 6              # prima operazione entro i primi 6 mesi della
                              #  finestra -> FINESTRA PIENA. Oltre: RILIEVO, e
                              #  il referto stampa la durata EFFETTIVA.
$NMinimo     = 30             # sotto: etichetta [CAMPIONE SOTTILE], MAI
                              #  esclusione. Il 30 e' il minimo di casa (R5) e
                              #  la valvola di R59: "il campione sottile
                              #  sospende il giudizio sul MERITO, mai sul
                              #  RISCHIO".

#--- I MAGIC VIETATI: TUTTI i magic vivi del censimento .chr del 23/08/2026
#    15:49, piu' i blocchi gia' spesi. Il magic non cambia il comportamento
#    dell'EA -- e' l'etichetta degli ordini e qui l'asse gemello -- ma un
#    magic vivo in un ini e' comunque da fermare.
$MagicVietati = @(
  772161,772162,772163, 772361,772362,772363, 770101,770202,
  772421,772422,772423, 771531, 772231,772232,772233,772234,772235,
  770411,770611, 771321,771322,771323,771332,
  772341,772342,772343,772344,772345,772346,
  770901,770924,970901, 770511,770531,770532, 970912,970913,
  770402,971501,250604, 779001, 774101, 770201, 970914,
  970301,971001,771001,771501,770801,771301,771401,770301,770401,
  770921,770922,770923,770925,
  779910,779911,779912,
  780110,780111,780112,781210,781211,781212,
  773200,773201,773300,773301,
  750010,750011)

# =====================================================================
#  LE 40 SEDIE. Ogni riga e' UNA sedia, col suo SIMBOLO, il TF del suo
#  GRAFICO, il suo GRUPPO (= la sua finestra), il suo file prova, il suo
#  sorgente, il suo marcatore di log.
#
#  >>> DA DOVE VIENE OGNI COLONNA (criteri R103 par. 2):
#      - Ea / Ver / MarkSrc / MarkLog : LETTI NEL SORGENTE al pin
#      - Sym / MagicVivo / Risk / Commento : MISURATI nel censimento .chr
#        del 23/08/2026 15:49
#      - Tf : il TF del GRAFICO, con FONTE PROPRIA sedia per sedia
#        (scritta nel file prova). NON si deriva da InpTF: e' la trappola
#        pagata in R102, dove SuperWave GBPUSD gira su grafico H4 con
#        InpTF H2. Le tre sedie in cui i due differiscono sono F21, I12,
#        I15, ed e' dichiarato.
#      - Da : la finestra del GRUPPO, non del simbolo
#      - Par / Vive : MISURATI sul file prova dal generatore
#      - Base : la base dei magic VERGINI 76xxxx (760000 + indice*10)
#      - TipoLog : MERCATO = l'EA logga l'ESECUZIONE; PENDENTE = logga
#        anche il PIAZZAMENTO, che PUO' PRECEDERE il deal.
#      - Strumento : OPTFRAME (39 sedie) oppure REPORT (Gold_Ichimoku,
#        che l'OPTFRAME NON CE L'HA: criteri par. 7.1)
#      - Commento "" = questo EA NON HA l'input InpComment (MISURATO:
#        DAX_Apertura_EU, Dow_Apertura_US, Gold_Ichimoku). Il gate sul
#        commento su quelle tre NON esiste, e va detto invece di
#        lasciarlo passare zitto.
# =====================================================================
function S([string]$id,[string]$ea,[string]$sym,[string]$tf,[string]$gruppo,
           [string]$magicVivo,[string]$magicSrc,[string]$risk,[string]$commento,
           [int]$base,[int]$par,[int]$vive,[string]$ver,
           [string]$markSrc,[string]$markLog,[string]$tipoLog,[string]$strumento){
  $da = $DaForex; if($gruppo -eq "INDICI"){ $da = $DaIndici }
  return [pscustomobject]@{
    Id=$id; Ea=$ea; Sym=$sym; Tf=$tf; Gruppo=$gruppo; Da=$da; Ver=$ver;
    MagicVivo=$magicVivo; MagicSrc=$magicSrc; Risk=$risk;
    Commento=$commento; Base=$base; Par=$par; Vive=$vive;
    MarkSrc=$markSrc; MarkLog=$markLog; TipoLog=$tipoLog; Strumento=$strumento;
    # --- i risultati, riempiti durante la corsa
    Esito="NON ESEGUITA"; Minuti=0.0;
    DD=-1.0; N=-1; NReport=-1; Profit=0.0; PF=0.0; Misurata=$false;
    ProfitNorm=0.0; DDNorm=-1.0; Molt=1.0;
    Gemelli="NON MISURATO";
    PrimaDataLog="NON MISURATA"; PrimaDataReport="NON MISURATA";
    PrimaDataUsata="NON MISURATA"; FonteData="nessuna";
    Finestra="NON MISURATA"; MesiOperati=-1.0;
    PeggiorGiornata="NON MISURATA"; PeggiorGiornataPct=99.9;
    PeggiorGiornataEA="n/d";
    ContrRiga="NON CERCATA"; ContrDD=-1.0; ContrStato="NON LETTO";
    RapportoDD="NON CALCOLABILE";
    PerPeriodo=@(); PeriodiVuoti=@(); PerMese=@();
    PeriodiNeg=-1; PeriodiOperati=-1; PeriodiTot=-1;
    DealN=-1; DealNetto=0.0; DealPF=-1.0; DealDDSaldo=-1.0; DealMisurate=$false;
    Campione="NON MISURATO"
  }
}

$SEDIE = @(
  # ---------------- GRUPPO FOREX + METALLI (25) --------------------
  #   id    EA                                    sym      TF   gruppo  magicVivo magicSrc risk   commento           base   par vive ver    markSrc                                                markLog                                                  tipoLog    strumento
  (S "F01" "ABTG_BreakingBand"                   "GBPUSD" "H1" "FOREX" "772161" "772101" "1.0"  "BB GBPUSD"        760010  71  74 "1.03" '@ %s SL %s TP(%s) %s RR %.3f lot %.2f'                '\[BB\]\s+(CONTINUAZIONE|INVERSIONE)\s+(LONG|SHORT)\s+@'  "MERCATO"  "OPTFRAME"),
  (S "F02" "ABTG_BreakingBand"                   "EURUSD" "H1" "FOREX" "772162" "772101" "1.0"  "BB EURUSD"        760020  71  74 "1.03" '@ %s SL %s TP(%s) %s RR %.3f lot %.2f'                '\[BB\]\s+(CONTINUAZIONE|INVERSIONE)\s+(LONG|SHORT)\s+@'  "MERCATO"  "OPTFRAME"),
  (S "F03" "ABTG_BreakingBand"                   "AUDUSD" "H1" "FOREX" "772163" "772101" "1.0"  "BB AUDUSD"        760030  71  74 "1.03" '@ %s SL %s TP(%s) %s RR %.3f lot %.2f'                '\[BB\]\s+(CONTINUAZIONE|INVERSIONE)\s+(LONG|SHORT)\s+@'  "MERCATO"  "OPTFRAME"),
  (S "F04" "ABTG_CostToCost"                     "EURJPY" "H4" "FOREX" "772361" "772311" "1.0"  "COST EURJPY"      760040  17  20 "1.00" '%s a mercato @ %s  SL %s  TP %s  lot %.2f  (punta %s' '\[COST\]\s+(LONG|SHORT)\s+a mercato @'                   "MERCATO"  "OPTFRAME"),
  (S "F05" "ABTG_CostToCost"                     "GBPCAD" "H4" "FOREX" "772362" "772311" "1.0"  "COST GBPCAD"      760050  17  20 "1.00" '%s a mercato @ %s  SL %s  TP %s  lot %.2f  (punta %s' '\[COST\]\s+(LONG|SHORT)\s+a mercato @'                   "MERCATO"  "OPTFRAME"),
  (S "F06" "ABTG_CostToCost"                     "XAGUSD" "H4" "FOREX" "772363" "772311" "1.0"  "COST XAGUSD"      760060  17  20 "1.00" '%s a mercato @ %s  SL %s  TP %s  lot %.2f  (punta %s' '\[COST\]\s+(LONG|SHORT)\s+a mercato @'                   "MERCATO"  "OPTFRAME"),
  (S "F07" "ABTG_EasyTrend"                      "CHFJPY" "H1" "FOREX" "772421" "772401" "1.0"  "EASYTREND CHFJPY" 760070  27  30 "1.00" '%s a MERCATO @ %s  SL %s  TP %s  lot %.2f'            '\[EZ\]\s+(BUY|SELL|LONG|SHORT)\s+(LIMIT|a MERCATO)\s+@'  "PENDENTE" "OPTFRAME"),
  (S "F08" "ABTG_EasyTrend"                      "GBPUSD" "H1" "FOREX" "772422" "772401" "1.0"  "EASYTREND GBPUSD" 760080  27  30 "1.00" '%s a MERCATO @ %s  SL %s  TP %s  lot %.2f'            '\[EZ\]\s+(BUY|SELL|LONG|SHORT)\s+(LIMIT|a MERCATO)\s+@'  "PENDENTE" "OPTFRAME"),
  (S "F09" "ABTG_EasyTrend"                      "AUDJPY" "H1" "FOREX" "772423" "772401" "1.0"  "EASYTREND AUDJPY" 760090  27  30 "1.00" '%s a MERCATO @ %s  SL %s  TP %s  lot %.2f'            '\[EZ\]\s+(BUY|SELL|LONG|SHORT)\s+(LIMIT|a MERCATO)\s+@'  "PENDENTE" "OPTFRAME"),
  (S "F10" "ABTG_GapFill"                        "GBPUSD" "H1" "FOREX" "772231" "772201" "1.0"  "GAP GBPUSD"       760100  16  19 "1.00" 'GAP-FILL %s @ %s  SL %s  TP %s  lot %.2f'             '\[GAP\]\s+GAP-FILL\s+(BUY|SELL)\s+@'                     "MERCATO"  "OPTFRAME"),
  (S "F11" "ABTG_GapFill"                        "EURUSD" "H1" "FOREX" "772232" "772201" "1.0"  "GAP EURUSD"       760110  16  19 "1.00" 'GAP-FILL %s @ %s  SL %s  TP %s  lot %.2f'             '\[GAP\]\s+GAP-FILL\s+(BUY|SELL)\s+@'                     "MERCATO"  "OPTFRAME"),
  (S "F12" "ABTG_GapFill"                        "AUDUSD" "H1" "FOREX" "772233" "772201" "1.0"  "GAP AUDUSD"       760120  16  19 "1.00" 'GAP-FILL %s @ %s  SL %s  TP %s  lot %.2f'             '\[GAP\]\s+GAP-FILL\s+(BUY|SELL)\s+@'                     "MERCATO"  "OPTFRAME"),
  (S "F13" "ABTG_PTE"                            "GBPUSD" "H1" "FOREX" "771322" "771301" "0.5"  "PTE GBPUSD"       760130  44  47 "1.01" '%s @ %s SL %s TP %s lot %.2f'                         '\[PTE\]\s+(LONG|SHORT)\s+@'                              "MERCATO"  "OPTFRAME"),
  (S "F14" "ABTG_PTE"                            "GBPUSD" "H1" "FOREX" "771332" "771301" "0.5"  "PTE GBPUSD B25"   760140  44  47 "1.01" '%s @ %s SL %s TP %s lot %.2f'                         '\[PTE\]\s+(LONG|SHORT)\s+@'                              "MERCATO"  "OPTFRAME"),
  (S "F15" "ABTG_PTE"                            "USDJPY" "H1" "FOREX" "771323" "771301" "1.0"  "PTE USDJPY"       760150  44  47 "1.01" '%s @ %s SL %s TP %s lot %.2f'                         '\[PTE\]\s+(LONG|SHORT)\s+@'                              "MERCATO"  "OPTFRAME"),
  (S "F16" "ABTG_PunteLarry"                     "EURAUD" "H1" "FOREX" "772342" "772301" "1.0"  "LARRY EURAUD"     760160  20  23 "1.00" 'PENDENTE %s %s @ %s'                                  '\[LARRY\]\s+PENDENTE\s'                                  "PENDENTE" "OPTFRAME"),
  (S "F17" "ABTG_PunteLarry"                     "EURCAD" "H1" "FOREX" "772346" "772301" "1.0"  "LARRY EURCAD"     760170  20  23 "1.00" 'PENDENTE %s %s @ %s'                                  '\[LARRY\]\s+PENDENTE\s'                                  "PENDENTE" "OPTFRAME"),
  (S "F18" "ABTG_PunteLarry"                     "GBPJPY" "H1" "FOREX" "772344" "772301" "1.0"  "LARRY GBPJPY"     760180  20  23 "1.00" 'PENDENTE %s %s @ %s'                                  '\[LARRY\]\s+PENDENTE\s'                                  "PENDENTE" "OPTFRAME"),
  (S "F19" "ABTG_PunteLarry"                     "GBPUSD" "H1" "FOREX" "772345" "772301" "1.0"  "LARRY GBPUSD"     760190  20  23 "1.00" 'PENDENTE %s %s @ %s'                                  '\[LARRY\]\s+PENDENTE\s'                                  "PENDENTE" "OPTFRAME"),
  (S "F20" "ABTG_PunteLarry"                     "XAUUSD" "H1" "FOREX" "772343" "772301" "0.3"  "LARRY ORO"        760200  20  23 "1.00" 'PENDENTE %s %s @ %s'                                  '\[LARRY\]\s+PENDENTE\s'                                  "PENDENTE" "OPTFRAME"),
  (S "F21" "ABTG_SuperWave"                      "GBPUSD" "H4" "FOREX" "770532" "770501" "1.0"  "SW GBPUSD H2"     760210  44  47 "1.00" '%s mercato %.2f lot @ %s SL %s TP %s'                 '\[SuperWave\]\s+(LONG|SHORT)\s+mercato'                  "MERCATO"  "OPTFRAME"),
  (S "F22" "ABTG_EMA200_Ottimizzato"             "XAUUSD" "H4" "FOREX" "971501" "971501" "0.25" "EMA200 OTT"       760220  43  46 "1.00" '%s LIMIT %s @ %s SL %s TP %s lot %.2f'                '\[EMA200\]\s+(BUY|SELL)\s+LIMIT'                         "PENDENTE" "OPTFRAME"),
  (S "F23" "ABTG_MaxMinNotte"                    "XAUUSD" "H2" "FOREX" "770402" "770401" "0.5"  "MAXMIN ORO"       760230  52  55 "1.10" 'BUY STOP @ %.2f SL %.2f TP %.2f lot %.2f'             '\[MaxMinNotte\]\s+(BUY|SELL)\s+STOP\s+@'                 "PENDENTE" "OPTFRAME"),
  (S "F24" "ABTG_SupertrendReversal_Ottimizzato" "XAUUSD" "H4" "FOREX" "970901" "970901" "1.0"  "STREV OTT"        760240  42  45 "1.00" '%s mercato %.2f lot @ %s SL %s TP %s'                 '\[STReversal\]\s+(LONG|SHORT)\s+mercato'                 "MERCATO"  "OPTFRAME"),
  (S "F25" "Gold_Ichimoku_TK_ATR_EA"             "XAUUSD" "H1" "FOREX" "250604" "250604" "0.5"  ""                 760250  24  27 "3.00" ''                                                     ''                                                        "MERCATO"  "REPORT"),
  # -------------------- GRUPPO INDICI (15) -------------------------
  (S "I01" "ABTG_DAX_Apertura_EU"                "D30EUR" "M5" "INDICI" "770101" "ABTG_DEF_MAGIC" "0.65" ""        760260  82  85 "1.01" 'BUY LIMIT (retest) @ %.5f  SL %.5f  lot %.2f'         '\[DAX Apertura EU\]\s+(BUY|SELL)\s+(STOP|LIMIT)'         "PENDENTE" "OPTFRAME"),
  (S "I02" "ABTG_Dow_Apertura_US"                "U30USD" "M5" "INDICI" "770202" "ABTG_DEF_MAGIC" "0.65" ""        760270  81  84 "1.01" 'BUY LIMIT (retest) @ %.5f  SL %.5f  lot %.2f'         '\[Dow Apertura US\]\s+(BUY|SELL)\s+(STOP|LIMIT)'         "PENDENTE" "OPTFRAME"),
  (S "I03" "ABTG_EMA200"                         "U30USD" "H1" "INDICI" "771531" "771501" "1.0"  "EMA200 DOW"      760280  43  46 "1.00" '%s LIMIT %s @ %s SL %s TP %s lot %.2f'                '\[EMA200\]\s+(BUY|SELL)\s+LIMIT'                         "PENDENTE" "OPTFRAME"),
  (S "I04" "ABTG_GapFill"                        "U30USD" "H1" "INDICI" "772234" "772201" "1.0"  "GAP DOW"         760290  16  19 "1.00" 'GAP-FILL %s @ %s  SL %s  TP %s  lot %.2f'             '\[GAP\]\s+GAP-FILL\s+(BUY|SELL)\s+@'                     "MERCATO"  "OPTFRAME"),
  (S "I05" "ABTG_GapFill"                        "225JPY" "H1" "INDICI" "772235" "772201" "1.0"  "GAP NIKKEI"      760300  16  19 "1.00" 'GAP-FILL %s @ %s  SL %s  TP %s  lot %.2f'             '\[GAP\]\s+GAP-FILL\s+(BUY|SELL)\s+@'                     "MERCATO"  "OPTFRAME"),
  (S "I06" "ABTG_MaxMinNotte_DAX_Short_Ottimizzato" "D30EUR" "M15" "INDICI" "770411" "770411" "0.65" "MAXMIN DAX SHORT" 760310 52 55 "1.10" 'BUY STOP @ %.2f SL %.2f TP %.2f lot %.2f'        '\[MaxMinNotte\]\s+(BUY|SELL)\s+STOP\s+@'                 "PENDENTE" "OPTFRAME"),
  (S "I07" "ABTG_ORB_Ottimizzato"                "U30USD" "M5" "INDICI" "770611" "770611" "0.3"  "ORB OTT"         760320  53  56 "1.02" 'BUY STOP @ %.5f SL %.5f TP %.5f lot %.2f'             '\[ORB_OTT\]\s+(BUY|SELL)\s+STOP\s+@'                     "PENDENTE" "OPTFRAME"),
  (S "I08" "ABTG_PTE"                            "U30USD" "H1" "INDICI" "771321" "771301" "1.0"  "PTE DOW"         760330  44  47 "1.01" '%s @ %s SL %s TP %s lot %.2f'                         '\[PTE\]\s+(LONG|SHORT)\s+@'                              "MERCATO"  "OPTFRAME"),
  (S "I09" "ABTG_PunteLarry"                     "U30USD" "H1" "INDICI" "772341" "772301" "1.0"  "LARRY DOW"       760340  20  23 "1.00" 'PENDENTE %s %s @ %s'                                  '\[LARRY\]\s+PENDENTE\s'                                  "PENDENTE" "OPTFRAME"),
  (S "I10" "ABTG_SupRev_DAX_H4_Ottimizzato"      "D30EUR" "H4" "INDICI" "970912" "970912" "1.0"  "STREV DAX H4"    760350  42  45 "1.00" '%s mercato %.2f lot @ %s SL %s TP %s'                 '\[STReversal\]\s+(LONG|SHORT)\s+mercato'                 "MERCATO"  "OPTFRAME"),
  (S "I11" "ABTG_SupRev_NAS_H1_Ottimizzato"      "NASUSD" "H1" "INDICI" "970913" "970913" "1.0"  "STREV NAS H1"    760360  42  45 "1.00" '%s mercato %.2f lot @ %s SL %s TP %s'                 '\[STReversal\]\s+(LONG|SHORT)\s+mercato'                 "MERCATO"  "OPTFRAME"),
  (S "I12" "ABTG_SuperWave"                      "U30USD" "H4" "INDICI" "770531" "770501" "1.0"  "SW DOW H2"       760370  44  47 "1.00" '%s mercato %.2f lot @ %s SL %s TP %s'                 '\[SuperWave\]\s+(LONG|SHORT)\s+mercato'                  "MERCATO"  "OPTFRAME"),
  (S "I13" "ABTG_SuperWave_DOW_H1_Ottimizzato"   "U30USD" "H1" "INDICI" "770511" "770511" "1.0"  "SUPERWAVE DOW H1" 760380 44  47 "1.00" '%s mercato %.2f lot @ %s SL %s TP %s'                 '\[SuperWave\]\s+(LONG|SHORT)\s+mercato'                  "MERCATO"  "OPTFRAME"),
  (S "I14" "ABTG_SupertrendReversal"             "225JPY" "H2" "INDICI" "770901" "770901" "0.65" "STREV"           760390  44  47 "1.00" '%s mercato %.2f lot'                                  '\[STReversal\]\s+(LONG|SHORT)\s+mercato'                 "MERCATO"  "OPTFRAME"),
  (S "I15" "ABTG_SupertrendReversal"             "225JPY" "H4" "INDICI" "770924" "770901" "1.0"  "STREV FW Nik"    760400  44  47 "1.00" '%s mercato %.2f lot'                                  '\[STReversal\]\s+(LONG|SHORT)\s+mercato'                 "MERCATO"  "OPTFRAME")
)

# --- I TIMEFRAME DA SCARICARE, per gruppo. Le barre M1 sono quelle che
#     mordono (il tester costruisce gli altri TF dalle M1), ma i TF di
#     grafico servono lo stesso: sugli indici ci sono sedie su M5 e M15.
$TfForex  = "M1,H1,H2,H4,D1"
$TfIndici = "M1,M5,M15,H1,H2,H4,D1"

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
$Storico   = New-Object System.Collections.ArrayList
$ContrTesto= ""
#  Diciassette EA per quaranta sedie: si compila UNA volta per EA. La
#  tabella nasce QUI, fuori dal try e fuori dal ciclo: dentro il ciclo si
#  sarebbe ricreata a ogni sedia e la guardia non avrebbe mai potuto
#  scattare (checklist 48).
$giaCompilati = @{}
$script:DealIntestazioni = @()
$script:DealColonne      = "NON LETTE"

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
function ValoreDi([string]$riga){
  $resto = $riga.Substring($riga.IndexOf("=")+1)
  return (($resto -split '\|\|')[0]).Trim()
}
function NomeDi([string]$riga){
  if($riga -match '^@'){ return ($riga -split '\s+')[0] }
  return (($riga -split '=')[0]).Trim()
}
#  un numero NON MISURATO si scrive "n/d", non "-1.00": un meno uno in una
#  colonna di percentuali si legge come un numero (checklist 47, il lato del
#  rumore) e nel referto sarebbe il peggior refuso possibile.
function Fmt2($v){
  if($v -eq $null){ return "n/d" }
  if([double]$v -lt 0){ return "n/d" }
  return ([double]$v).ToString("0.00",$INV)
}
#  Il PROFITTO invece PUO' essere negativo, e un profitto negativo e' un
#  NUMERO, non un "non misurato". Per questo ha un formattatore SUO, con
#  la sentinella esplicita: e' esattamente lo scivolone che Fmt2 farebbe
#  se lo si riusasse per pigrizia (checklist 58).
#  IL PF SI FORMATTA A MANO, IN CULTURA INVARIANTE. Il driver mette
#  gia' la cultura invariante sul thread, ma un double passato secco a
#  -f la prende DALLA CULTURA: sul PC di Claudio (it-IT) uscirebbe
#  "1,3" invece di "1.30", e nella stessa tabella dei numeri col punto.
#  MISURATO sul banco di prova forzando it-IT: senza questo, la colonna
#  PF esce con la virgola.
function Fmt3($v){
  if($v -eq $null){ return "n/d" }
  if([double]$v -lt 0){ return "n/d" }
  return ([double]$v).ToString("0.000",$INV)
}
function FmtEuro($v,[bool]$misurato){
  if(-not $misurato){ return "n/d" }
  return ([double]$v).ToString("+0;-0;0",$INV)
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
function DataInv($s){
  $d = [datetime]::MinValue
  if([datetime]::TryParseExact(("" + $s),"yyyy.MM.dd",$INV,[Globalization.DateTimeStyles]::None,[ref]$d)){ return $d }
  return $null
}

#  LETTURA DEI LOG A OFFSET (checklist 23-bis): si legge SOLO cio' che e'
#  stato scritto dopo la fotografia. Un file NON cresciuto non si rilegge da
#  capo, altrimenti il "=== FINITO" di ieri sera passa per quello di adesso.
function LeggiNuovo([string]$path,[long]$da){
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
#  come "prima operazione del 2020". Qui si scartano quelle coi millesimi
#  e si prende l'ULTIMA rimasta prima del marcatore dell'EA.
function DataSimulata([string]$riga,[string]$marcatore){
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
#  E' quella di R100/R102, che nasce dal bug di R99: il parser cercava
#  'balance'/'saldo' e MT5 in italiano scrive **BILANCIO**, quindi
#  tornava una lista vuota su una tabella perfettamente leggibile.
#  E il netto e' Profitto+Commissioni+Swap, non il solo Profitto.
#  L'intestazione MISURATA (MT5 italiano) e':
#    Ora | Affare | Simbolo | Tipo | Direzione | Volume | Prezzo |
#    Ordine | Commissioni | Swap | Profitto | Bilancio | Commento
#  Il CONTROLLO POSITIVO e' dentro: una riga vale solo se ha una data
#  vera nella colonna Ora E 'in'/'out' nella colonna Direzione. Se non
#  ne riconosce nessuna torna VUOTO, chi chiama scrive "NON MISURATA"
#  -- e dice anche QUALI intestazioni ha visto.
# =====================================================================
function LeggiDeal([string]$path){
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
    #  una riga qualunque (checklist 58). MISURATO: i valori sono 'in'/'out'
    #  MINUSCOLI e NON localizzati, anche col terminale in italiano.
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
    #  IL NETTO: Profitto + Commissioni + Swap.
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
#  LA SECONDA MISURA -- n, netto, PF e DD DAL SALDO, ricavati dai DEAL.
#  Su 39 sedie e' un CONTROLLO INCROCIATO indipendente dall'OptResults
#  (che lo scrive l'EA). Su Gold_Ichimoku, che l'OPTFRAME NON CE L'HA,
#  e' l'UNICA misura possibile -- e il referto lo dichiara su ogni sua
#  riga (criteri par. 4.5 e 7.1).
#  >>> IL DD QUI E' SUL SALDO CHIUSO, NON SULL'EQUITY: ignora il
#      flottante, quindi e' un LIMITE INFERIORE DEL LIMITE INFERIORE.
#      Non finisce mai nella stessa colonna dell'altro.
# =====================================================================
function MisureDaiDeal($deal,[double]$deposito){
  $r = @{ N=-1; Netto=0.0; PF=-1.0; DDSaldo=-1.0; Ok=$false }
  if($deal -eq $null){ return $r }
  $chiusure = @($deal | Where-Object { ($_.Dir -eq "out" -or $_.Dir -eq "in/out") -and $_.Netto -ne $null })
  if(@($chiusure).Count -eq 0){ return $r }
  $vinte = 0.0; $perse = 0.0; $tot = 0.0
  foreach($d in $chiusure){
    $v = [double]$d.Netto
    $tot = $tot + $v
    if($v -ge 0){ $vinte = $vinte + $v } else { $perse = $perse + [math]::Abs($v) }
  }
  $r.N = @($chiusure).Count
  $r.Netto = [math]::Round($tot,2)
  if($perse -gt 0){ $r.PF = [math]::Round(($vinte / $perse),3) }
  #  --- il DD sul saldo: massimo di picco, misurato sulla colonna Bilancio
  $picco = $deposito; $ddMax = 0.0; $visti = 0
  foreach($d in $deal){
    if($d.Saldo -eq $null){ continue }
    $visti++
    $s = [double]$d.Saldo
    if($s -gt $picco){ $picco = $s }
    if($picco -gt 0){
      $giu = 100.0 * ($picco - $s) / $picco
      if($giu -gt $ddMax){ $ddMax = $giu }
    }
  }
  if($visti -gt 0){ $r.DDSaldo = [math]::Round($ddMax,2) }
  $r.Ok = $true
  return $r
}

# =====================================================================
#  LA SPINA DORSALE -- ed e' il REQUISITO del chiarimento di Claudio.
#  Costruisce l'elenco COMPLETO dei periodi della finestra (anche quelli
#  senza nessuna operazione: un periodo che manca dall'elenco non si
#  vede, e un periodo vuoto e' un DATO), e per ognuno mette n e netto.
#    granularita' "ANNO"      -> 2020, 2021, ... (gruppo FOREX)
#    granularita' "TRIMESTRE" -> 2024Q4, 2025Q1, ... (gruppo INDICI)
#    granularita' "MESE"      -> 2024.09, ... (DIAGNOSTICA degli indici)
#  Il perche' della scelta sta nei criteri par. 4.2: su 21 mesi le
#  caselle mensili di sedie da 1-2 operazioni al mese conterrebbero 0 o 1
#  trade, e "12 mesi negativi su 21" si leggerebbe come una condanna
#  quando e' solo il segno di dodici singoli trade.
# =====================================================================
function EtichettaPeriodo([datetime]$q,[string]$gran){
  if($gran -eq "ANNO"){ return $q.Year.ToString($INV) }
  if($gran -eq "TRIMESTRE"){ return ($q.Year.ToString($INV) + "Q" + ([math]::Floor(($q.Month - 1) / 3) + 1).ToString($INV)) }
  return ($q.Year.ToString($INV) + "." + $q.Month.ToString("00",$INV))
}
function ElencoPeriodi([datetime]$da,[datetime]$a,[string]$gran){
  $out = New-Object System.Collections.ArrayList
  if($gran -eq "ANNO"){
    for($y=$da.Year; $y -le $a.Year; $y++){ [void]$out.Add($y.ToString($INV)) }
    return @($out)
  }
  $cur = $da
  while($cur -le $a){
    $et = EtichettaPeriodo $cur $gran
    if(-not $out.Contains($et)){ [void]$out.Add($et) }
    $cur = $cur.AddDays(15)
  }
  #  l'ultimo periodo va incluso anche se l'ultimo passo l'ha scavalcato
  $et = EtichettaPeriodo $a $gran
  if(-not $out.Contains($et)){ [void]$out.Add($et) }
  return @($out)
}
function SpinaDorsale($deal,[datetime]$da,[datetime]$a,[string]$gran){
  $netto = @{}; $enne = @{}
  foreach($d in $deal){
    $et = EtichettaPeriodo $d.Q $gran
    if(-not $netto.ContainsKey($et)){ $netto[$et] = 0.0; $enne[$et] = 0 }
    if($d.Netto -ne $null){ $netto[$et] = $netto[$et] + [double]$d.Netto }
    if($d.Dir -eq "out" -or $d.Dir -eq "in/out"){ $enne[$et] = $enne[$et] + 1 }
  }
  $lista = New-Object System.Collections.ArrayList
  foreach($et in (ElencoPeriodi $da $a $gran)){
    $nn = 0; $pp = 0.0
    if($enne.ContainsKey($et)){ $nn = $enne[$et]; $pp = $netto[$et] }
    [void]$lista.Add([pscustomobject]@{ Periodo=$et; N=$nn; Netto=[math]::Round($pp,2) })
  }
  return @($lista)
}

# =====================================================================
#  IL DD PROMESSO, ESTRATTO DALL'ARTEFATTO -- PER COLONNA.
#  E' la funzione di R100/R102, invariata. Il vincolo sul SIMBOLO e'
#  quello che in R100 ha impedito alla sedia oro di pescare la riga del
#  Nikkei (stesso magic 770901, collisione misurata il 22/08); il
#  vincolo sul MAGIC e' quello che distingue le due PTE GBPUSD.
#  >>> E si rifiuta di leggere un numero scritto a UN'ALTRA TAGLIA: se
#      la cella contiene "a rischio 0,3%" o "a 0,5%", il DD promesso e'
#      AMBIGUO e il confronto resta NON CALCOLABILE, con la riga
#      verbatim nel referto. Un denominatore letto alla taglia sbagliata
#      e' peggio di un denominatore mancante.
# =====================================================================
function DDPromesso([string]$testoContratti,[string]$ea,[string]$sym,[string]$magicVivo){
  $r = @{ Riga="RIGA NON TROVATA"; DD=-1.0; Stato="DD PROMESSO NON AGLI ATTI"; Cella="" }
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
    #      "ABTG_EMA200_Ottimizzato": due sedie diverse)
    $primo = ("" + $celle[0]).Replace("*","").Trim()
    if($primo -notmatch ('^' + [regex]::Escape($ea) + '(\s|\(|$)')){ continue }
    #  --- IL SIMBOLO nella sua colonna (indice 1)
    if($celle.Count -lt 2 -or ("" + $celle[1]).Trim().ToUpper() -ne $sym.ToUpper()){ continue }
    #  --- e il MAGIC VIVO nella sua colonna
    if($magicVivo -ne "" -and ($riga -notmatch ('\|\s*' + [regex]::Escape($magicVivo) + '\s*\|'))){ continue }
    $r.Riga  = ([regex]::Replace($riga.Trim(),'[^\x20-\x7E]','.'))
    $r.Cella = ([regex]::Replace(("" + $celle[$iDD]),'[^\x20-\x7E]','.'))
    $r.Stato = "RIGA TROVATA"
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
Write-Host "#  R103 - LA CLASSIFICA DELLA FLOTTA                                #" -ForegroundColor Cyan
Write-Host "#  40 sedie, 20 EA, 17 simboli, DUE gruppi con DUE finestre          #" -ForegroundColor Cyan
Write-Host "#  FOREX+METALLI 2020.01.01 -> 2026.06.30   (6,5 anni)               #" -ForegroundColor Cyan
Write-Host "#  INDICI        2024.09.26 -> 2026.06.30   (21 mesi, il muro BCM)   #" -ForegroundColor Cyan
Write-Host "#  modello OHLC M1, deposito 100.000                                 #" -ForegroundColor Cyan
Write-Host "#####################################################################" -ForegroundColor Cyan
Dico ("pin      : " + $Pin)
Dico ("cartella : " + $Work)

# =====================================================================
#  LA LISTA DI LAVORO. -SoloSedia accetta un ELENCO e -SoloGruppo un
#  gruppo: e' il modo previsto di lanciare questo round.
#  >>> @() SULLA RICEZIONE (checklist 62): con UNA sola sedia PowerShell
#      srotolerebbe la collezione nell'oggetto, e $Lavoro[0] diventerebbe
#      una PROPRIETA' invece della sedia.
# =====================================================================
$Lavoro = @($SEDIE)
if($SoloGruppo -ne ""){
  $g = $SoloGruppo.Trim().ToUpper()
  if($g -ne "FOREX" -and $g -ne "INDICI"){
    Write-Host ("!!! -SoloGruppo '" + $SoloGruppo + "' non e' ne' FOREX ne' INDICI.") -ForegroundColor Red
    exit 1
  }
  $Lavoro = @($Lavoro | Where-Object { $_.Gruppo -eq $g })
}
if($SoloSedia -ne ""){
  #  [,\s]+ e non ',' (CHECKLIST 65): senza apici nella riga di chat,
  #  PowerShell passa un ARRAY che il binder unisce con $OFS (spazio)
  #  -> "F01 F02 F03". Accetto tutte e due le forme.
  $ids = @($SoloSedia -split '[,\s]+' | ForEach-Object { $_.Trim().ToUpper() } | Where-Object { $_ -ne "" })
  $ignoti = @($ids | Where-Object { $u = $_; -not (@($SEDIE | Where-Object { $_.Id -eq $u }).Count) })
  if($ignoti.Count -gt 0){
    Write-Host ("!!! -SoloSedia: id sconosciuti [" + ($ignoti -join ", ") + "]. Id validi: " + (($SEDIE | ForEach-Object { $_.Id }) -join ", ")) -ForegroundColor Red
    exit 1
  }
  $Lavoro = @($Lavoro | Where-Object { $ids -contains $_.Id })
}
if($Lavoro.Count -eq 0){
  Write-Host "!!! la selezione (-SoloGruppo / -SoloSedia) non ha selezionato nessuna sedia." -ForegroundColor Red
  exit 1
}

# --- IL MOLTIPLICATORE DI NORMALIZZAZIONE, sedia per sedia.
#     E' la DECISIONE 3 firmata: si ordina sul profitto normalizzato a
#     1%, perche' confrontare in euro sedie a taglie diverse premia la
#     taglia, non il motore.
#     [APPROSSIMATO lineare, convenzione CONTRATTI_SEDIE.md punto 2].
foreach($sd in $Lavoro){
  $rv = 0.0
  if([double]::TryParse($sd.Risk,[Globalization.NumberStyles]::Float,$INV,[ref]$rv) -and $rv -gt 0){
    $sd.Molt = [math]::Round((1.0 / $rv),4)
  } else {
    $sd.Molt = -1.0
    [void]$Problemi.Add($sd.Id + ": il rischio vivo '" + $sd.Risk + "' non e' un numero: la colonna NORMALIZZATA a 1% di questa sedia NON si calcola.")
  }
}

# --- I SIMBOLI DISTINTI, con la data PIU' VECCHIA che serve a qualcuno e
#     i TF del suo gruppo. Su GBPUSD ci sono sette sedie e su U30USD otto:
#     le barre si scaricano UNA volta per simbolo, non per sedia.
$Simboli = @{}
foreach($sd in $Lavoro){
  if(-not $Simboli.ContainsKey($sd.Sym)){
    $Simboli[$sd.Sym] = [pscustomobject]@{ Da=$sd.Da; Gruppo=$sd.Gruppo }
  } else {
    $d = DataInv $sd.Da
    $dv = DataInv $Simboli[$sd.Sym].Da
    if($d -ne $null -and $dv -ne $null -and $d -lt $dv){ $Simboli[$sd.Sym].Da = $sd.Da }
  }
}
$SimboliOrd = @($Simboli.Keys | Sort-Object)

$nF = @($Lavoro | Where-Object { $_.Gruppo -eq "FOREX" }).Count
$nI = @($Lavoro | Where-Object { $_.Gruppo -eq "INDICI" }).Count
Titolo "NUMERI ATTESI (dichiarati PRIMA della corsa)"
Write-Host ("    sedie ........................  " + $Lavoro.Count + " su " + $SEDIE.Count + "   (FOREX+METALLI " + $nF + ", INDICI " + $nI + ")") -ForegroundColor White
Write-Host ("    simboli distinti .............  " + $SimboliOrd.Count + "   (" + ($SimboliOrd -join " ") + ")") -ForegroundColor White
Write-Host  "    passate per sedia ............  3   (1 SINGOLA + 2 GEMELLE)" -ForegroundColor White
Write-Host ("    passate TOTALI ...............  " + (3 * $Lavoro.Count) + "   (meno 2 per ogni sedia senza OPTFRAME)") -ForegroundColor White
Write-Host ("    finestra FOREX+METALLI .......  " + $DaForex + " -> " + $Fino + "   (6,5 anni, col crollo covid dentro)") -ForegroundColor White
Write-Host ("    finestra INDICI ..............  " + $DaIndici + " -> " + $Fino + "   (21 mesi: IL BROKER NON HA ALTRO)") -ForegroundColor White
Write-Host ("    modello FOREX ................  " + $Modello + " = OHLC su M1") -ForegroundColor White
if($TickReali){
  Write-Host ("    modello INDICI ...............  " + $ModelloIx + " = TICK REALI   <<< -TickReali ACCESO: e' la corsa [DA FIRMARE]") -ForegroundColor Yellow
} else {
  Write-Host ("    modello INDICI ...............  " + $ModelloIx + " = OHLC su M1   (i tick reali ESISTONO su questa finestra: -TickReali, [DA FIRMARE])") -ForegroundColor White
}
Write-Host  "                                    DD = LIMITE INFERIORE del rischio. PROFITTO = STIMA DEL LORDO." -ForegroundColor White
Write-Host ("    deposito .....................  " + $Deposito) -ForegroundColor White
Write-Host ("    spread .......................  Spread=" + $SpreadIni + " = spread CORRENTE, dichiarato. NON e' una misura.") -ForegroundColor White
Write-Host ("    n minimo per riga piena ......  " + $NMinimo + "   (sotto: etichetta CAMPIONE SOTTILE, MAI esclusione)") -ForegroundColor White
Write-Host ""
Write-Host  "    LE SEDIE DI QUESTO GIRO:" -ForegroundColor White
foreach($sd in $Lavoro){
  $mm = "x" + $sd.Molt.ToString("0.00",$INV)
  Write-Host ("      " + $sd.Id + "  " + $sd.Ea.PadRight(38) + " " + $sd.Sym.PadRight(7) + " " + $sd.Tf.PadRight(3) +
              "  " + $sd.Gruppo.PadRight(6) + " " + $sd.Da + " -> " + $Fino + "   rischio " + $sd.Risk + "% (norm " + $mm + ")   " + $sd.Strumento) -ForegroundColor DarkGray
}
Write-Host ""
Write-Host  "    COSA ESCE, E CON QUALE ETICHETTA (criteri R103 par. 4):" -ForegroundColor Yellow
Write-Host  "      PROF-VIVO  profitto alla TAGLIA VIVA: quello che avrebbe fatto sul conto" -ForegroundColor Yellow
Write-Host  "      PROF-1%    profitto NORMALIZZATO a 1% -- E' LA COLONNA SU CUI SI ORDINA" -ForegroundColor Yellow
Write-Host  "      PF, DD (vivo e normalizzato), n, PEGGIOR GIORNATA, DD promesso dal contratto" -ForegroundColor Yellow
Write-Host  "      PERIODI NEGATIVI / PERIODI OPERATI + la SPINA DORSALE nel referto:" -ForegroundColor Yellow
Write-Host  "        FOREX  -> ANNO per ANNO        INDICI -> TRIMESTRE per TRIMESTRE" -ForegroundColor Yellow
Write-Host  "        (piu' il mese per mese degli indici, marcato DIAGNOSTICA)" -ForegroundColor Yellow
Write-Host ""
Write-Host  "    >>> QUESTO ROUND NON PROMUOVE E NON BOCCIA NIENTE." -ForegroundColor Yellow
Write-Host  "        Una classifica e' un'informazione per decidere, non un verdetto." -ForegroundColor Yellow
Write-Host  "    >>> E LE DUE TABELLE NON SI CONFRONTANO FRA LORO: 21 mesi e 6,5 anni" -ForegroundColor Yellow
Write-Host  "        nella stessa classifica sarebbero la truffa peggiore del round." -ForegroundColor Yellow
Write-Host ""
Write-Host  "    >>> E LE SEDIE DICHIARATE E NON MISURABILI, che NON sono fra le 40:" -ForegroundColor Yellow
Write-Host  "        BREAKOUT_EA_JPY_v3 USDJPY -- il sorgente NON ESISTE nel repo (rilievo del 18/08)" -ForegroundColor Yellow
Write-Host  "        ABTG_GapContinuation 225JPY -- nel .chr del 23/08 NON ha un rischio leggibile" -ForegroundColor Yellow

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
$vivi = @(Get-Process -Name "terminal64","metaeditor64" -ErrorAction SilentlyContinue)
if($vivi.Count -gt 0){
  Write-Host ""
  Write-Host ("!!! APERTO: " + (($vivi | ForEach-Object { $_.ProcessName } | Sort-Object -Unique) -join ", ")) -ForegroundColor Red
  Write-Host "    Non parto: col terminale aperto il tester non gira, e con MetaEditor" -ForegroundColor Red
  Write-Host "    aperto la compilazione torna subito senza compilare." -ForegroundColor Red
  #  DICHIARATO: questo exit 1 sta DENTRO il try e SALTA LA RACCOLTA. Qui e'
  #  accettabile: siamo a due secondi dal lancio, non e' stato prodotto
  #  NIENTE. Il messaggio a schermo E' il referto di questo caso.
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

# --- 1-bis. LA SOSTA SI SVUOTA A OGNI GIRO (checklist 56). Senza, gli .ini
#     del giro a vuoto finirebbero nello zip della corsa vera,
#     indistinguibili da quelli veri.
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
#     TUTTI e venti gli EA di R103 fanno #include <ABTG_PausaGuardian.mqh>
#     (verificato negli #include di ognuno, Gold_Ichimoku COMPRESO): senza
#     questa riga la compilazione fallisce e il round muore alla prima passata.
#     NOTA: nel tester il Guardian e' FAIL-OPEN TOTALE (le sue
#     GlobalVariable non esistono li'): non cambia una virgola del backtest.
$mqh = Join-Path $MqlInclude "ABTG_PausaGuardian.mqh"
Scarica ("$RawPin/mql5/Include/ABTG_PausaGuardian.mqh") $mqh 'ABTG_GuardiaIngresso'
$vfy = Get-Item -LiteralPath $mqh
if($vfy.PSIsContainer){ throw "ABTG_PausaGuardian.mqh: in Include c'e' una CARTELLA con quel nome (checklist 27-ter)." }
if($vfy.Length -lt 4000){ throw ("ABTG_PausaGuardian.mqh e' lungo " + $vfy.Length + " byte: troppo poco, scarico monco.") }
Dico ("include installato: ABTG_PausaGuardian.mqh (" + $vfy.Length + " byte)") "Green"

# --- 1b. IL CENSIMENTO DEI CONTRATTI, scaricato AL PIN: il DD promesso
#     si ESTRAE dall'artefatto, non si scrive a memoria.
$Contr = Join-Path $Work "CONTRATTI_SEDIE.md"
Scarica ("$RawPin/report/CONTRATTI_SEDIE.md") $Contr 'DD promesso'
$ContrTesto = Get-Content -LiteralPath $Contr -Raw
Copy-Item -LiteralPath $Contr -Destination (Join-Path $Sosta "CONTRATTI_SEDIE_al_pin.md") -Force -ErrorAction SilentlyContinue
Dico ("CONTRATTI_SEDIE.md al pin: " + $ContrTesto.Length + " byte") "Green"

# =====================================================================
#  2. PASSO 0-A -- LE BARRE, UN SIMBOLO ALLA VOLTA.
#     Si fa UNA volta per simbolo, non per sedia: su GBPUSD ci sono
#     sette sedie e su U30USD otto.
#     >>> NIENTE TICK: il round e' a modello OHLC M1 (l'eventuale
#         -TickReali sugli indici usa i tick che il tester si scarica da
#         solo, e il referto lo dichiara).
#     >>> E IL M1 QUASI CERTAMENTE NON SARA' "COMPLETO", ed e' ATTESO:
#         scarica_storico.ps1 scrive InpTimeoutSec=120 nel preset, cioe'
#         due minuti per timeframe. Per questo il verdetto non-COMPLETO
#         sulla riga M1 finisce nelle NOTE e non nei PROBLEMI
#         (checklist 47). La misura che DECIDE resta la data della prima
#         operazione.
#     >>> IL VERDETTO SI CONFRONTA CON LA DATA CHIESTA (come R95/R99/R102).
# =====================================================================
if(-not $SoloControllo -and -not $SenzaStorico){
  Titolo ("2. PASSO 0-A - LE BARRE, " + $SimboliOrd.Count + " SIMBOLI")
  $ScStorico = Join-Path $Work "scarica_storico.ps1"
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
  }catch{
    [void]$Problemi.Add("PASSO 0-A NON PREPARATO: " + $_.Exception.Message + ". NESSUN simbolo e' stato scaricato: il tester si arrangera' da solo, e il gate sulla PRIMA OPERAZIONE resta l'unica misura sulla copertura.")
    $ScStorico = ""
  }

  if($ScStorico -ne ""){
    foreach($sy in $SimboliOrd){
      $daSy = $Simboli[$sy].Da
      $tfSy = $TfForex
      if($Simboli[$sy].Gruppo -eq "INDICI"){ $tfSy = $TfIndici }
      Write-Host ""
      Write-Host ("  -- barre di " + $sy + " dal " + $daSy + "  (TF " + $tfSy + ")") -ForegroundColor White
      #  Righe e' una ArrayList e NON un @(): su un array fisso .Add()
      #  esplode, e sarebbe esploso proprio dentro il PASSO 0-A.
      $riga = [pscustomobject]@{ Sym=$sy; Da=$daSy; Tf=$tfSy; Esito="NON ESEGUITO"; Righe=(New-Object System.Collections.ArrayList) }
      $t0A = Get-Date
      try{
        $global:LASTEXITCODE = 0
        & powershell.exe -ExecutionPolicy Bypass -File $ScStorico -Simboli $sy -Da $daSy -Timeframes $tfSy -SenzaTick -Auto -TimeoutMin 60 2>&1 |
          Tee-Object -FilePath (Join-Path $Logs ("passo0a_storico_" + $sy + ".txt")) | Out-Host
        $riga.Esito = "eseguito, uscita " + $LASTEXITCODE
        if($LASTEXITCODE -ne 0){
          $che = "errore"
          if($LASTEXITCODE -eq 2){ $che = "TIMEOUT dei 60 minuti: MT5 fermato a meta', il referto storico e' PARZIALE (ma c'e', e lo leggo lo stesso)" }
          [void]$Problemi.Add("PASSO 0-A " + $sy + ": scarica_storico.ps1 e' uscito con codice " + $LASTEXITCODE + " -> " + $che + ". Il gate sulla PRIMA OPERAZIONE, sedia per sedia, resta la misura che decide.")
        }
        #  >>> E ANCHE QUI SI GUARDA LA DATA (checklist 23). <<<
        $csvSt = Join-Path $MqlFiles "ABTG_StoricoScaricato.csv"
        if((Test-Path -LiteralPath $csvSt) -and ((Get-Item -LiteralPath $csvSt).LastWriteTime -lt $t0A)){
          [void]$Problemi.Add("PASSO 0-A " + $sy + ": il referto storico e' del " +
                              (Get-Item -LiteralPath $csvSt).LastWriteTime.ToString("yyyy-MM-dd HH:mm",$INV) +
                              ", PRIMA dell'avvio di questo passo: e' STANTIO e NON descrive questa corsa. Non lo leggo.")
          $csvSt = ""
        }
        if($csvSt -ne "" -and (Test-Path -LiteralPath $csvSt)){
          Copy-Item -LiteralPath $csvSt -Destination (Join-Path $Sosta ("passo0a_storico_" + $sy + ".csv")) -Force -ErrorAction SilentlyContinue
          #  LE COLONNE VERE le scrive ABTG_HistoryDownloader.mq5:
          #    Simbolo,Timeframe,Barre,PrimaDataLocale,PrimaDataServer,Verdetto
          #  'Stato' NON esiste (checklist 46-bis).
          $vistoSym = $false
          foreach($r in (Import-Csv -LiteralPath $csvSt)){
            $s2 = ("" + $r.Simbolo).Trim().ToUpper()
            if($s2 -ne $sy){ continue }
            $vistoSym = $true
            $verd = ("" + $r.Verdetto).Trim()
            $vv = $verd; if($vv -eq ""){ $vv = "VERDETTO VUOTO" }
            [void]$riga.Righe.Add(($s2 + " " + $r.Timeframe + " | barre " + $r.Barre + " | disco " + $r.PrimaDataLocale + " | broker " + $r.PrimaDataServer + " -> " + $vv))
            #  --- IL CONFRONTO COL DICHIARATO. E' la parte che R95/R99
            #      hanno insegnato: un verdetto letto e non confrontato
            #      non e' un gate.
            $dServer = DataInv (("" + $r.PrimaDataServer).Trim())
            $dChiesta= DataInv $daSy
            if($dServer -ne $null -and $dChiesta -ne $null -and $dServer -gt $dChiesta.AddDays(31)){
              [void]$Problemi.Add("PASSO 0-A " + $s2 + " " + $r.Timeframe + ": il BROKER dichiara la prima data " + $r.PrimaDataServer +
                                  ", cioe' DOPO il " + $daSy + " che e' l'inizio della finestra di questo gruppo. " +
                                  "La finestra di quelle sedie NON e' quella dichiarata: il referto va letto con la finestra vera, e la classifica di quelle righe non e' confrontabile con le altre.")
            }
            #  >>> LA GUARDIA SI SCRIVE AL POSITIVO (checklist 40-ter e 47). <<<
            if($verd -like "MANCA STORICO LOCALE*"){
              [void]$Note.Add("PASSO 0-A: " + $s2 + " " + $r.Timeframe + " -> '" + $verd + "' (BENIGNO: c'e' sul server, non ancora sul disco. Il tester si scarica il resto da solo -- ed e' anche il motivo per cui la PRIMA passata su questo simbolo puo' durare molto piu' delle altre.)")
            }
            elseif($verd -ne "COMPLETO"){
              $che2 = "'" + $verd + "'"
              if($verd -eq ""){ $che2 = "VUOTO (formato del referto cambiato: NON e' stato letto)" }
              $testo = "PASSO 0-A: verdetto NON 'COMPLETO' su " + $s2 + " " + $r.Timeframe + " -> " + $che2 +
                       " | barre " + $r.Barre + " | broker " + $r.PrimaDataServer + " | chiesto dal " + $daSy +
                       ".  Il gate sulla PRIMA OPERAZIONE e' la misura che decide."
              if(("" + $r.Timeframe).Trim().ToUpper() -eq "M1"){
                [void]$Note.Add($testo + "  ATTESO: scarica_storico.ps1 da' 120 secondi per timeframe. NON e' un guasto del round.")
              } else {
                [void]$Problemi.Add($testo)
              }
            }
          }
          if(-not $vistoSym){ [void]$Problemi.Add("PASSO 0-A: nessuna riga per " + $sy + " nel referto storico.") }
        } else { [void]$Note.Add("PASSO 0-A " + $sy + ": ABTG_StoricoScaricato.csv non trovato, referto storico NON letto.") }
      }catch{
        $riga.Esito = "NON ESEGUITO (" + $_.Exception.Message + ")"
        [void]$Problemi.Add("PASSO 0-A " + $sy + " NON ESEGUITO: " + $_.Exception.Message)
      }
      [void]$Storico.Add($riga)
      Dico ("  ... " + $sy + ": " + $riga.Esito) "Gray"
    }
  }
} else {
  [void]$Storico.Add([pscustomobject]@{ Sym="(tutti)"; Da="-"; Tf="-"; Esito="SALTATO (SoloControllo / SenzaStorico)"; Righe=@() })
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
#     >>> E IL SEQUENZIALE QUI NON E' PRUDENZA GENERICA: due sedie dello
#         stesso EA sullo stesso simbolo (F13/F14 su ABTG_PTE GBPUSD,
#         I14/I15 su ABTG_SupertrendReversal 225JPY) scrivono NELLO
#         STESSO OptResults_<EA>_<Simbolo>.csv. In parallelo si
#         cancellerebbero a vicenda.
# =====================================================================
Titolo ("3. LA CATENA - " + $Lavoro.Count + " sedie, una finestra ciascuna")
$iS = 0
foreach($sd in $Lavoro){
  $iS++
  $trascorse = (New-TimeSpan -Start $Avvio -End (Get-Date)).TotalHours
  if($trascorse -ge $OreMax -and -not $SoloControllo){
    $sd.Esito = "NON INIZIATA (tetto ore raggiunto)"
    [void]$Problemi.Add("TEMPO SCADUTO prima di " + $sd.Id + " " + $sd.Ea + " " + $sd.Sym + ": il round NON e' completo. COME SI RIPRENDE: -SoloSedia con l'ELENCO delle sedie non fatte (qui non c'e' niente da saltare, una finestra sola per sedia).")
    continue
  }
  $tSedia = Get-Date
  Write-Host ""
  Write-Host "==================================================================" -ForegroundColor Cyan
  Write-Host ("  [" + $iS + "/" + $Lavoro.Count + "]  " + $sd.Id + "  " + $sd.Ea) -ForegroundColor Cyan
  Write-Host ("           " + $sd.Sym + " " + $sd.Tf + "  |  " + $sd.Gruppo + "  " + $sd.Da + " -> " + $Fino + "  |  magic vivo " + $sd.MagicVivo + "  |  rischio " + $sd.Risk + "%") -ForegroundColor Cyan
  Write-Host "==================================================================" -ForegroundColor Cyan

  $sdFatale = ""
  $modelloSd = $Modello; $suffSd = $Suffisso
  if($sd.Gruppo -eq "INDICI"){ $modelloSd = $ModelloIx; $suffSd = $SuffissoIx }
  try{
    # -----------------------------------------------------------------
    #  3a. IL FILE PROVA DI QUESTA SEDIA
    # -----------------------------------------------------------------
    $nomeProva = "R103_" + $sd.Ea + "_" + $sd.Sym + "_" + $sd.MagicVivo + ".txt"
    $ProvaFile = Join-Path $Prove $nomeProva
    Scarica ("$RawPin/backtest_pipeline/prove/" + $nomeProva) $ProvaFile '@SIMBOLO'
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
    if(-not $m.Success -or $m.Groups[1].Value -ne $sd.Da){ throw ("@DAQUANDO non e' " + $sd.Da + " (l'inizio della finestra del gruppo " + $sd.Gruppo + ")") }
    $s1 = [regex]::Match($txtProva,'(?m)^@SIMBOLO\s+(\S+)')
    if(-not $s1.Success -or $s1.Groups[1].Value -ne $sd.Sym){ throw ("@SIMBOLO non e' " + $sd.Sym) }
    $p1 = [regex]::Match($txtProva,'(?m)^@PERIODO\s+(\S+)')
    if(-not $p1.Success -or $p1.Groups[1].Value -ne $sd.Tf){ throw ("@PERIODO non e' " + $sd.Tf + " (il TF del GRAFICO di questa sedia, che NON si deriva da InpTF)") }
    #  --- il rischio: e' la TAGLIA VIVA, ed e' anche il denominatore
    #      della colonna normalizzata a 1%
    if($txtProva -notmatch ('(?m)^InpRiskPercent=' + [regex]::Escape($sd.Risk) + '\|\|')){ throw ("file prova: InpRiskPercent non e' " + $sd.Risk + ". Con un rischio diverso il profitto, il DD E la normalizzazione a 1% non sono quelli della sedia viva.") }
    #  --- il commento della sedia viva, SOLO dove l'EA ce l'ha.
    #      >>> TRE EA NON HANNO InpComment (MISURATO nei sorgenti):
    #          ABTG_DAX_Apertura_EU, ABTG_Dow_Apertura_US,
    #          Gold_Ichimoku_TK_ATR_EA -- e infatti nel .chr il loro
    #          commento e' VUOTO. Su quelle tre il gate NON ESISTE, e si
    #          dice, invece di lasciarlo passare zitto (checklist 55).
    if($sd.Commento -ne ""){
      if($txtProva -notmatch ('(?m)^InpComment=' + [regex]::Escape($sd.Commento) + '\r?$')){ throw ("file prova: InpComment non e' '" + $sd.Commento + "'.") }
    } else {
      if($txtProva -match '(?m)^InpComment='){ throw "file prova: c'e' un InpComment, ma questa sedia e' dichiarata SENZA InpComment nel sorgente. Una delle due fonti e' cambiata." }
      [void]$Note.Add($sd.Id + ": questo EA NON HA l'input InpComment (MISURATO nel sorgente), quindi il gate sul commento vivo su questa sedia NON ESISTE. Nel censimento .chr il suo commento e' infatti VUOTO.")
    }
    #  --- il magic: coppia VERGINE, e MAI una sedia viva
    $mg = [regex]::Match($txtProva,'(?m)^InpMagic=(\d+)\|\|(\d+)\|\|1\|\|(\d+)\|\|Y\r?$')
    if(-not $mg.Success){ throw "file prova: InpMagic non e' nella forma gemella 'm||m||1||m+1||Y'. Senza quell'asse non esistono le due passate gemelle, e il gate dei gemelli non ha niente da confrontare." }
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
    #  --- e nessun default non risolto: una macro rimasta in un .ini e'
    #      un input che il tester NON applica, in silenzio (criteri 2.2)
    $nonNum = @($ProvaPar | Where-Object { $_ -match '\|\|' } | Where-Object { (ValoreDi $_) -notmatch '^-?[0-9]+(\.[0-9]+)?$' -and (ValoreDi $_) -notmatch '^(true|false)$' })
    if($nonNum.Count -gt 0){
      throw ("file prova: " + $nonNum.Count + " parametri hanno un valore che non e' ne' numero ne' bool (il primo: '" + $nonNum[0] + "'). Nel .ini una macro non risolta viene IGNORATA IN SILENZIO e la sedia gira con un altro valore.")
    }
    $haVerbose = ($txtProva -match '(?m)^InpVerbose=')
    Dico ("file prova: " + $Vive.Count + " righe vive (" + $ProvaPar.Count + " parametri + 3 direttive), " + $sd.Sym + " " + $sd.Tf + " dal " + $sd.Da + ", rischio " + $sd.Risk + "%, asse Y = InpMagic " + $magA + "/" + $magB) "Green"

    # -----------------------------------------------------------------
    #  3b. IL SORGENTE E I GATE DI VERSIONE
    # -----------------------------------------------------------------
    $srcMq5 = Join-Path $SrcDir ($sd.Ea + ".mq5")
    Scarica ("$RawPin/mql5/Experts/" + $sd.Ea + ".mq5") $srcMq5 'InpMagic'
    $txtSrc = Get-Content -LiteralPath $srcMq5 -Raw
    $mv = [regex]::Match($txtSrc,'#property\s+version\s+"([^"]+)"')
    if(-not $mv.Success){ throw ($sd.Ea + ".mq5 scaricato senza #property version: non e' il sorgente che credo.") }
    if($mv.Groups[1].Value -ne $sd.Ver){ throw ($sd.Ea + ".mq5 dichiara version '" + $mv.Groups[1].Value + "' invece di '" + $sd.Ver + "'. O la cache di raw.githubusercontent serve una copia vecchia, o il pin e' sbagliato.") }
    #  >>> IL MAGIC DEL SORGENTE, non quello vivo. Su quasi tutte le sedie
    #      di R103 i due differiscono: sono sedie di VIVAIO, cioe' N
    #      grafici dello stesso EA, e il default del sorgente e' il magic
    #      "di famiglia". Sulle due APERTURE il default e' addirittura una
    #      MACRO (ABTG_DEF_MAGIC), e il gate cerca quella.
    if($txtSrc -notmatch ('InpMagic\s*=\s*' + [regex]::Escape($sd.MagicSrc))){ throw ($sd.Ea + ".mq5 non dichiara InpMagic = " + $sd.MagicSrc + " (il default del sorgente): non e' il motore che credo.") }
    if($txtSrc -notmatch 'ABTG_PausaGuardian\.mqh'){ throw ($sd.Ea + ".mq5 non include ABTG_PausaGuardian.mqh: il sorgente non e' quello che credo.") }
    #  >>> L'OPTFRAME. Su 39 sedie e' il solo strumento del profitto, del
    #      PF e del DD. Su Gold_Ichimoku NON C'E', ed e' DICHIARATO nella
    #      colonna Strumento: li' il gate non pretende cio' che non esiste,
    #      ma lo SCRIVE (un gate che non c'e' non e' un gate verde).
    if($sd.Strumento -eq "OPTFRAME"){
      if($txtSrc -notmatch 'OnTesterDeinit'){ throw ($sd.Ea + ".mq5 non ha OnTesterDeinit: senza OPTFRAME non scrive nessun OptResults e questa sedia non ha strumento.") }
    } else {
      if($txtSrc -match 'OnTesterDeinit'){ throw ($sd.Ea + ".mq5 ADESSO ha OnTesterDeinit, ma questa sedia e' dichiarata SENZA OPTFRAME: la dichiarazione e' invecchiata e va rifatta (bene: vuol dire che si puo' misurare come le altre).") }
      [void]$Note.Add($sd.Id + " " + $sd.Ea + ": NESSUN OPTFRAME nel sorgente (MISURATO). Questa sedia gira SOLO la passata singola; profitto, PF, n e la spina dorsale escono dai DEAL del report .htm, e il DD dell'EQUITY resta NON MISURATO. Le due passate GEMELLE non girano, quindi il gate 3 su di lei NON ESISTE.")
    }
    #  >>> IL MARCATORE DELLA RIGA D'INGRESSO, PRESO DAL SORGENTE CHE LA
    #      PRODUCE (checklist 55): e' da quella riga che il gate 1 legge la
    #      data della prima operazione. Dove non c'e' (Gold_Ichimoku non
    #      logga gli ingressi) si dichiara.
    if($sd.MarkSrc -ne ""){
      if($txtSrc -notmatch [regex]::Escape($sd.MarkSrc)){ throw ($sd.Ea + ".mq5 non contiene piu' la Log() d'ingresso ('" + $sd.MarkSrc + "'): il gate 1 non avrebbe niente da leggere nel log.") }
    } else {
      [void]$Note.Add($sd.Id + " " + $sd.Ea + ": nessuna riga di log d'ingresso nel sorgente (MISURATO). La misura 1 del GATE 1 su questa sedia NON ESISTE: la prima operazione si legge SOLO dal report.")
    }
    Dico ($sd.Ea + ".mq5 al pin, version " + $mv.Groups[1].Value + " (magic sorgente " + $sd.MagicSrc + " [magic VIVO della sedia: " + $sd.MagicVivo + "], include Guardian, strumento " + $sd.Strumento + ")") "Green"

    # -----------------------------------------------------------------
    #  3c. IL DD PROMESSO DI QUESTA SEDIA, dall'artefatto
    # -----------------------------------------------------------------
    $dd = DDPromesso $ContrTesto $sd.Ea $sd.Sym $sd.MagicVivo
    $sd.ContrRiga = $dd.Riga; $sd.ContrDD = $dd.DD; $sd.ContrStato = $dd.Stato
    if([double]$sd.ContrDD -gt 0){
      Dico ("DD promesso ESTRATTO: " + $sd.ContrDD.ToString("0.00",$INV) + "%") "Green"
    } else {
      Dico ("DD promesso: " + $sd.ContrStato + " -> il confronto sara' NON CALCOLABILE. NON e' un via libera.") "Yellow"
    }

    # -----------------------------------------------------------------
    #  3d. FASE COMPILA. .ex5 SCRITTO ADESSO.
    #     >>> INVOCAZIONE DIRETTA di metaeditor64.exe (checklist 54).
    #     >>> IL VERDETTO E' IL LastWriteTime DEL .ex5 PRIMA/DOPO.
    #     >>> Questi EA sono SEDIE VIVE e il terminale e' collegato al
    #         conto vero: .mq5 E .ex5 vanno in backup DATATO, e se la
    #         compilazione fallisce il .mq5 viene RIMESSO com'era.
    #     >>> SI COMPILA UNA VOLTA PER EA: 20 EA per 40 sedie.
    # -----------------------------------------------------------------
    if(-not $SoloControllo){
      if($giaCompilati.ContainsKey($sd.Ea)){
        Dico ("compilazione SALTATA: " + $sd.Ea + " gia' compilato in questo giro (" + $giaCompilati[$sd.Ea] + ")") "Gray"
      } else {
        $mq5 = Join-Path $MqlExperts ($sd.Ea + ".mq5")
        $ex5 = Join-Path $MqlExperts ($sd.Ea + ".ex5")
        $logC= Join-Path $MqlExperts ($sd.Ea + ".log")
        $bakMq5 = $mq5 + ".prima_r103_" + $Stamp
        $bakEx5 = $ex5 + ".prima_r103_" + $Stamp
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
          Copy-Item -LiteralPath $logC -Destination (Join-Path $Sosta ("compile_" + $sd.Ea + ".log")) -Force -ErrorAction SilentlyContinue
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
          [void]$Note.Add($sd.Ea + ": compilazione con " + $mw.Groups[1].Value + " warning (0 errori). Non fermano il round, ma vanno letti in compile_" + $sd.Ea + ".log dello zip.")
        }
        $giaCompilati[$sd.Ea] = "v" + $mv.Groups[1].Value + " alle " + (Ora)
        Dico ("COMPILATO " + $sd.Ea + " v" + $mv.Groups[1].Value + " (.ex5 riscritto adesso, rc=" + $rcMe + ")") "Green"
      }
    }

    # -----------------------------------------------------------------
    #  LE DUE FABBRICHE DI .ini DI QUESTA SEDIA. Un solo artefatto: le
    #  righe le detta il FILE PROVA, non questa riga (checklist 33).
    # -----------------------------------------------------------------
    $OptCsv = Join-Path $MqlFiles ("OptResults_" + $sd.Ea + "_" + $sd.Sym + ".csv")
    $sdRef = $sd; $parRef = $ProvaPar; $verbRef = $haVerbose; $modRef = $modelloSd
    #  (a) OTTIMIZZAZIONE a due celle gemelle. Le righe restano in FORMA
    #      COMPLETA v||v||0||v||N: un pin scritto "Nome=v" secco imposta il
    #      valore ma NON spegne il flag di ottimizzazione che MT5 ricorda
    #      dall'ultima griglia di quell'EA (checklist 5).
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
      if($inputs -notmatch ('(?m)^InpRiskPercent=' + [regex]::Escape($sdRef.Risk) + '\|\|')){ throw ("ini OTT: InpRiskPercent non e' " + $sdRef.Risk + " (la TAGLIA VIVA, che e' anche il denominatore della normalizzazione).") }
      $testo = @"
[Charts]
MaxBars=2000000000

[Experts]
AllowLiveTrading=false
AllowDllImport=false

[Tester]
Expert=$($sdRef.Ea).ex5
Symbol=$($sdRef.Sym)
Period=$($sdRef.Tf)
Model=$modRef
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
    #  (b) PASSATA SINGOLA -> log (righe d'ingresso) e report .htm (i deal,
    #      da cui la peggior giornata, LA SPINA DORSALE e la SECONDA
    #      MISURA). Qui i valori si scrivono SECCHI e Optimization=0: un
    #      "||" rimasto vorrebbe dire un'ottimizzazione travestita -- e in
    #      ottimizzazione le Print non le legge nessuno (checklist 34),
    #      cioe' il gate 1 resterebbe muto.
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
      #  InpVerbose SOLO dove l'EA ce l'ha: Gold_Ichimoku non ce l'ha, e
      #  pretenderlo fermerebbe una sedia sana su un input che non esiste.
      if($verbRef){
        if($inputs -notmatch '(?m)^InpVerbose=true\r?$'){ throw "ini SINGOLA: InpVerbose non e' true: l'EA non stamperebbe le righe d'ingresso e la PRIMA OPERAZIONE non sarebbe leggibile dal log." }
      }
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
Symbol=$($sdRef.Sym)
Period=$($sdRef.Tf)
Model=$modRef
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

    $iniSing = Join-Path $Work ($sd.Id + "_singola.ini")
    $iniGem  = Join-Path $Work ($sd.Id + "_gemelle.ini")
    & $iniSingola $sd.Da $Fino ($sd.Base + 12) $iniSing ("R103_" + $sd.Id + "_singola")
    Copy-Item -LiteralPath $iniSing -Destination (Join-Path $Sosta ($sd.Id + "_singola.ini")) -Force
    if($sd.Strumento -eq "OPTFRAME"){
      & $iniOtt $sd.Da $Fino ($sd.Base + 10) $iniGem ("R103_" + $sd.Id + "_gemelle")
      Copy-Item -LiteralPath $iniGem -Destination (Join-Path $Sosta ($sd.Id + "_gemelle.ini")) -Force
    }

    if($SoloControllo){
      $sd.Esito = "SOLO CONTROLLO"
      $quante = 3; if($sd.Strumento -ne "OPTFRAME"){ $quante = 1 }
      Write-Host ("    ini scritti e verificati (" + $quante + " passate previste per questa sedia)") -ForegroundColor DarkGray
    }
    else{
      # ---------------------------------------------------------------
      #  3e. LA PASSATA SINGOLA
      #      -> gate 1 misura 1 (log), peggior giornata, SPINA DORSALE,
      #         seconda misura (n, netto, PF, DD sul saldo)
      # ---------------------------------------------------------------
      Write-Host ("  -- PASSATA SINGOLA su " + $sd.Da + " -> " + $Fino + " (magic " + ($sd.Base+12) + ", modello " + $modelloSd + ")") -ForegroundColor White
      $tPasso0 = Get-Date
      $primaLen = FotografaLog
      $tp = Get-Date
      (Start-Process -FilePath $Terminal -ArgumentList ("/config:`"" + $iniSing + "`"") -PassThru).WaitForExit()
      $minSing = [math]::Round((New-TimeSpan -Start $tp -End (Get-Date)).TotalMinutes,1)
      Dico ("  ... passata singola: " + $minSing.ToString("0.0",$INV) + " minuti") "Gray"

      # --- (1) IL LOG: la data della PRIMA OPERAZIONE, misura n.1
      if($sd.MarkLog -ne ""){
        $righeIN = New-Object System.Collections.ArrayList
        $letti = 0
        foreach($rad in $RadiciLog){
          if(-not (Test-Path -LiteralPath $rad)){ continue }
          foreach($lg in @(Get-ChildItem -LiteralPath $rad -Recurse -Filter "*.log" -File -ErrorAction SilentlyContinue | Sort-Object LastWriteTime)){
            $da0 = 0
            if($primaLen.ContainsKey($lg.FullName)){ $da0 = $primaLen[$lg.FullName] }
            $tx = LeggiNuovo $lg.FullName $da0
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
          [void]$dump.Add("R103 " + $sd.Id + " " + $sd.Ea + " " + $sd.Sym + " - righe d'ingresso lette nel log della passata singola (magic " + ($sd.Base+12) + ")")
          [void]$dump.Add("marcatore: " + $sd.MarkLog + "   tipo: " + $sd.TipoLog)
          [void]$dump.Add("log letti: " + $letti + "   righe trovate: " + $righeIN.Count)
          [void]$dump.Add("")
          foreach($x in @($righeIN | Select-Object -First 40)){ [void]$dump.Add($x.Riga) }
          Set-Content -LiteralPath (Join-Path $Sosta ($sd.Id + "_ingressi_log.txt")) -Value $dump -Encoding ASCII
        }
      } else {
        $sd.PrimaDataLog = "NON APPLICABILE (l'EA non logga gli ingressi)"
      }

      # --- (2) IL REPORT: i DEAL. Da qui la PEGGIOR GIORNATA, la SPINA
      #     DORSALE, la SECONDA MISURA e la seconda data.
      #     >>> QUESTA MISURA SI FA SEMPRE, fuori dal ramo della prima
      #         (checklist 56-bis): serve a DIAGNOSTICARE il fallimento
      #         dell'altra, non a sostituirla.
      $repFile = ""
      foreach($rad in @($InstDir,$DataFolder,$Work,$MqlFiles)){
        if(-not (Test-Path -LiteralPath $rad)){ continue }
        $c = @(Get-ChildItem -LiteralPath $rad -Filter ("R103_" + $sd.Id + "_singola*.htm*") -File -ErrorAction SilentlyContinue |
               Where-Object { $_.LastWriteTime -ge $tPasso0 } | Sort-Object LastWriteTime -Descending)
        if($c.Count -gt 0){ $repFile = $c[0].FullName; break }
      }
      if($repFile -ne ""){
        Copy-Item -LiteralPath $repFile -Destination (Join-Path $Sosta ($sd.Id + "_report_singola.htm")) -Force -ErrorAction SilentlyContinue
        $deal = @(LeggiDeal $repFile)
        if($deal.Count -eq 0){
          $diag = "nessuna intestazione candidata trovata"
          if($script:DealIntestazioni.Count -gt 0){ $diag = "intestazioni candidate viste: [ " + ($script:DealIntestazioni -join " ]  [ ") + " ]" }
          [void]$Problemi.Add($sd.Id + ": il report esiste (" + $repFile + ") ma NON ci ho riconosciuto nessuna riga di DEAL (Ora con data + Direzione in/out + Profitto + Bilancio). LA SPINA DORSALE e la PEGGIOR GIORNATA restano NON MISURATE: nessun numero inventato. DIAGNOSTICA -> " + $diag)
        } else {
          [void]$Note.Add($sd.Id + ": tabella deal riconosciuta, colonne " + $script:DealColonne + " (indici a base 0). Netto = Profitto+Commissioni+Swap.")
          $sd.PrimaDataReport = $deal[0].Q.ToString("yyyy.MM.dd",$INV)
          $sd.NReport = @($deal | Where-Object { $_.Dir -eq "out" -or $_.Dir -eq "in/out" }).Count
          $conNetto = @($deal | Where-Object { $_.Netto -ne $null }).Count
          if($conNetto -eq 0){
            [void]$Problemi.Add($sd.Id + ": riconosciuti " + $deal.Count + " deal ma NESSUNO ha un netto leggibile (" + $script:DealColonne + "). SPINA DORSALE e PEGGIOR GIORNATA NON MISURATE.")
          } else {
            # ---- LA SECONDA MISURA (o l'unica, su Gold_Ichimoku) -----
            $md = MisureDaiDeal $deal ([double]$Deposito)
            if($md.Ok){
              $sd.DealN = [int]$md.N; $sd.DealNetto = [double]$md.Netto
              $sd.DealPF = [double]$md.PF; $sd.DealDDSaldo = [double]$md.DDSaldo
              $sd.DealMisurate = $true
            }
            # ---- LA PEGGIOR GIORNATA, per giorno di calendario -------
            #  [APPROSSIMATO, e il referto lo dice]: e' la peggior
            #  giornata sulle CHIUSURE REALIZZATE, non sull'equity
            #  intraday. Stessa approssimazione di R51, R99, R100, R102.
            $perGiorno = @{}; $saldoFine = @{}
            $ordine = New-Object System.Collections.ArrayList
            foreach($d in $deal){
              $g = $d.Q.ToString("yyyy.MM.dd",$INV)
              if(-not $perGiorno.ContainsKey($g)){ $perGiorno[$g] = 0.0; [void]$ordine.Add($g) }
              if($d.Netto -ne $null){ $perGiorno[$g] = $perGiorno[$g] + [double]$d.Netto }
              if($d.Saldo -ne $null){ $saldoFine[$g] = [double]$d.Saldo }
            }
            $saldoPrec = [double]$Deposito
            if($deal[0].Saldo -ne $null -and $deal[0].Netto -ne $null){
              $sIni = [double]$deal[0].Saldo - [double]$deal[0].Netto
              if($sIni -gt 0){ $saldoPrec = $sIni }
            }
            $peggio = $null; $peggioG = ""
            foreach($g in $ordine){
              $base = $saldoPrec
              if($base -le 0){ $base = [double]$Deposito }
              $pct = 100.0 * $perGiorno[$g] / $base
              if($peggio -eq $null -or $pct -lt $peggio){ $peggio = $pct; $peggioG = $g }
              if($saldoFine.ContainsKey($g)){ $saldoPrec = $saldoFine[$g] }
            }
            if($peggio -eq $null){
              [void]$Problemi.Add($sd.Id + ": nessuna giornata operativa ricavata dai deal. PEGGIOR GIORNATA NON MISURATA.")
            } else {
              $sd.PeggiorGiornataPct = [math]::Round($peggio,2)
              $coda = ""
              if($peggio -ge 0){ $coda = "   <<< NESSUNA giornata in perdita: e' il giorno MENO buono, non una perdita" }
              $sd.PeggiorGiornata = $sd.PeggiorGiornataPct.ToString("0.00",$INV) + "%  (il " + $peggioG + ", su " + $ordine.Count + " giornate operative, " + $conNetto + " deal col netto letto)" + $coda
            }
            # ---- LA SPINA DORSALE -- IL REQUISITO DI CLAUDIO ---------
            $dIni = DataInv $sd.Da
            $dFin = DataInv $Fino
            $gran = "ANNO"; if($sd.Gruppo -eq "INDICI"){ $gran = "TRIMESTRE" }
            if($dIni -ne $null -and $dFin -ne $null){
              $sd.PerPeriodo = @(SpinaDorsale $deal $dIni $dFin $gran)
              if($sd.Gruppo -eq "INDICI"){
                #  il mese per mese e' DIAGNOSTICA (criteri 4.2): costa
                #  zero, si stampa, ma NON e' la colonna della classifica.
                $sd.PerMese = @(SpinaDorsale $deal $dIni $dFin "MESE")
              }
              $vuoti = @($sd.PerPeriodo | Where-Object { $_.N -eq 0 } | ForEach-Object { $_.Periodo })
              $operati = @($sd.PerPeriodo | Where-Object { $_.N -gt 0 })
              $negativi = @($operati | Where-Object { [double]$_.Netto -lt 0 })
              $sd.PeriodiVuoti   = @($vuoti)
              $sd.PeriodiTot     = @($sd.PerPeriodo).Count
              $sd.PeriodiOperati = @($operati).Count
              $sd.PeriodiNeg     = @($negativi).Count
              if(@($vuoti).Count -gt 0){
                [void]$Note.Add($sd.Id + " GATE DENSITA': " + @($vuoti).Count + " periodi su " + $sd.PeriodiTot +
                                " dentro la finestra NON hanno NESSUNA operazione (" + (@($vuoti) -join ", ") +
                                "). NON contano come negativi: si tolgono dal denominatore. La colonna dice quindi '" +
                                $sd.PeriodiNeg + " su " + $sd.PeriodiOperati + " operati', non 'su " + $sd.PeriodiTot + "'.")
              }
            }
          }
        }
      } else {
        [void]$Problemi.Add($sd.Id + ": NON ho trovato nessun report 'R103_" + $sd.Id + "_singola*.htm' scritto dopo l'avvio della passata (cercato in " + $InstDir + ", " + $DataFolder + ", " + $Work + ", " + $MqlFiles + "). LA SPINA DORSALE e la PEGGIOR GIORNATA restano NON MISURATE e NON si inventano. COME AVERLE: aprire MT5, Strategy Tester, ricaricare " + $sd.Id + "_singola.ini (e' nello zip) in test singolo, tasto destro sul risultato -> Report, e leggere la tabella dei Deal.")
      }

      # ---------------------------------------------------------------
      #  3f. LE DUE PASSATE GEMELLE -> l'OptResults e il gate 3
      #      (non esistono per la sedia senza OPTFRAME: dichiarato)
      # ---------------------------------------------------------------
      if($sd.Strumento -eq "OPTFRAME"){
        Write-Host ("  -- DUE PASSATE GEMELLE (magic " + ($sd.Base+10) + "/" + ($sd.Base+11) + ")") -ForegroundColor White
        $csvFin = Join-Path $Risultati ("R103_" + $sd.Id + "_" + $sd.Ea + "_" + $sd.Sym + $suffSd + ".csv")
        #  >>> SI CANCELLA PRIMA, TUTTI E DUE (checklist 23 e 14). Se la
        #      passata non producesse niente, un file di IERI resterebbe
        #      li' e verrebbe letto come il risultato di ADESSO.
        #      E qui MORDE DAVVERO: F13/F14 e I14/I15 scrivono nello
        #      STESSO OptResults_<EA>_<Simbolo>.csv.
        Remove-Item -LiteralPath $OptCsv -Force -ErrorAction SilentlyContinue
        if((Test-Path -LiteralPath $csvFin) -and -not $Rifai){
          #  >>> UN CSV VECCHIO NON E' UN CSV OK: SI GUARDA LA DATA. Se fra
          #      i due lanci fosse cambiato il pin, meta' round verrebbe da
          #      un altro motore (checklist 15 e 53).
          [void]$Problemi.Add($sd.Id + ": esisteva gia' un CSV del " + (Get-Item -LiteralPath $csvFin).LastWriteTime.ToString("yyyy-MM-dd HH:mm",$INV) + ". LO RIFACCIO LO STESSO (questa e' una finestra sola per sedia: saltarla vorrebbe dire leggere numeri di un'altra corsa).")
        }
        Remove-Item -LiteralPath $csvFin -Force -ErrorAction SilentlyContinue
        $tp = Get-Date
        (Start-Process -FilePath $Terminal -ArgumentList ("/config:`"" + $iniGem + "`"") -PassThru).WaitForExit()
        $minOtt = [math]::Round((New-TimeSpan -Start $tp -End (Get-Date)).TotalMinutes,1)
        Dico ("  ... due gemelle: " + $minOtt.ToString("0.0",$INV) + " minuti") "Gray"
        if(Test-Path -LiteralPath $OptCsv){
          if((Get-Item -LiteralPath $OptCsv).LastWriteTime -lt $tp){
            [void]$Problemi.Add($sd.Id + ": l'OptResults e' PIU' VECCHIO dell'avvio delle gemelle: NON e' di questa corsa, non lo leggo.")
          } else {
            Copy-Item -LiteralPath $OptCsv -Destination $csvFin -Force
            Copy-Item -LiteralPath $OptCsv -Destination (Join-Path $Sosta ($sd.Id + "_optresults.csv")) -Force
            Remove-Item -LiteralPath $OptCsv -Force -ErrorAction SilentlyContinue
          }
        }
        if(-not (Test-Path -LiteralPath $csvFin)){
          $sdFatale = "GEMELLE: nessun OptResults. O lo storico non copre " + $sd.Da + ", o MT5 non e' partito, o la cache ha ripescato passate vecchie senza riscrivere i frame. NON e' un via libera: senza questo file non esistono ne' il n, ne' il profitto, ne' il DD, ne' il gate dei gemelli."
        } else {
          $rows = @(Import-Csv -LiteralPath $csvFin)
          if($rows.Count -ne $CelleAttese){
            $sdFatale = "GEMELLE: l'OptResults ha " + $rows.Count + " righe invece di " + $CelleAttese + ". O la cache del tester ha ripescato passate gia' calcolate senza riscrivere i frame, o l'asse InpMagic non ha spazzolato."
          } else {
            #  IL CONTROLLO POSITIVO SUL PARSER (checklist 55): prima si
            #  verifica che le COLONNE esistano, coi loro nomi veri.
            $cols = @($rows | Get-Member -MemberType NoteProperty | ForEach-Object { $_.Name })
            $manca = @()
            foreach($c in @("Profit","Profit Factor","Equity DD %","Trades")){ if($cols -notcontains $c){ $manca += $c } }
            if($manca.Count -gt 0){
              $sdFatale = "GEMELLE: nell'OptResults mancano le colonne [" + ($manca -join ", ") + "]. Le scrive l'OPTFRAME dell'EA (OnTesterDeinit): se sono cambiate, e' cambiato il motore. IL GATE NON E' STATO ESEGUITO. Colonne trovate: " + ($cols -join ", ")
            } else {
              $ddv=@(); $pfv=@(); $prv=@(); $trv=@()
              foreach($r in $rows){
                $ddv += (NumInv $r.'Equity DD %'); $pfv += (NumInv $r.'Profit Factor')
                $prv += (NumInv $r.'Profit');      $trv += (NumInv $r.'Trades')
              }
              if(($ddv -contains $null) -or ($prv -contains $null) -or ($trv -contains $null)){
                $sdFatale = "GEMELLE: le colonne ci sono ma i VALORI non sono numeri leggibili. IL GATE NON E' STATO ESEGUITO: non e' un via libera."
              } else {
                $sd.DD     = [math]::Round([double]$ddv[0],2)
                $sd.PF     = [math]::Round([double]$pfv[0],3)
                $sd.Profit = [math]::Round([double]$prv[0],2)
                $sd.N      = [int]$trv[0]
                $sd.Misurata = $true
                #  >>> IL QUARTO STRUMENTO, dove c'e': alcuni EA hanno la
                #      colonna 'Peggior Giornata %' calcolata DENTRO l'EA.
                #      E' un controllo incrociato indipendente.
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
      } else {
        #  --- LA SEDIA SENZA OPTFRAME: i numeri vengono dai DEAL, e si
        #      dice a chiare lettere QUALI colonne restano vuote.
        $sd.Gemelli = "NON ESISTE (l'EA non ha OPTFRAME: le gemelle non hanno niente da scrivere)"
        if($sd.DealMisurate){
          $sd.Profit   = $sd.DealNetto
          $sd.N        = $sd.DealN
          $sd.PF       = $sd.DealPF
          $sd.DD       = -1.0        # il DD dell'EQUITY qui NON ESISTE
          $sd.Misurata = $true
          [void]$Note.Add($sd.Id + ": profitto, PF e n vengono dai DEAL del report (unica fonte possibile). Il DD dell'EQUITY resta NON MISURATO; al suo posto il referto stampa il DD SUL SALDO CHIUSO (" + (Fmt2 $sd.DealDDSaldo) + "%), che e' un'altra cosa e un limite inferiore piu' basso ancora.")
        } else {
          $sdFatale = "SENZA OPTFRAME e SENZA DEAL LEGGIBILI: di questa sedia non esiste nessun numero. Non e' un profitto zero, e' un profitto ASSENTE."
        }
      }

      # ---------------------------------------------------------------
      #  3g. I GATE DELLA PRIMA OPERAZIONE
      # ---------------------------------------------------------------
      $dLog = [datetime]::MinValue; $okLog = $false
      $dRep = [datetime]::MinValue; $okRep = $false
      if($sd.PrimaDataLog    -ne "NON MISURATA"){ $okLog = [datetime]::TryParseExact($sd.PrimaDataLog,   "yyyy.MM.dd",$INV,[Globalization.DateTimeStyles]::None,[ref]$dLog) }
      if($sd.PrimaDataReport -ne "NON MISURATA"){ $okRep = [datetime]::TryParseExact($sd.PrimaDataReport,"yyyy.MM.dd",$INV,[Globalization.DateTimeStyles]::None,[ref]$dRep) }
      $dUsata = [datetime]::MinValue
      if($okLog -and $okRep){
        $dUsata = $dLog; if($dRep -lt $dLog){ $dUsata = $dRep }
        $scarto = ($dRep - $dLog).TotalDays
        #  >>> IL CONFRONTO E' DIVERSO A SECONDA DEL TIPO DI LOG: su una
        #      sedia PENDENTE l'EA logga anche il PIAZZAMENTO, che PRECEDE
        #      legittimamente il primo deal. Li' "log piu' vecchio del
        #      report" e' il mestiere, non un difetto; il contrario no.
        if($sd.TipoLog -eq "PENDENTE"){
          if($scarto -lt -1){
            [void]$Problemi.Add($sd.Id + " GATE 1: il report (" + $sd.PrimaDataReport + ") e' PIU' VECCHIO del log (" + $sd.PrimaDataLog + ") di " + [int](-$scarto) + " giorni. Su una sedia che logga anche il PIAZZAMENTO dei pendenti questo non dovrebbe succedere: un deal non puo' precedere il suo ordine.")
            $sd.FonteData = "log e report INCOERENTI (report prima del log su sedia PENDENTE)"
          } elseif($scarto -gt 60){
            [void]$Note.Add($sd.Id + " GATE 1: fra il primo ordine piazzato (" + $sd.PrimaDataLog + ") e il primo deal eseguito (" + $sd.PrimaDataReport + ") passano " + [int]$scarto + " giorni. E' possibile su una sedia a pendenti che scadono, ma vale la pena saperlo.")
            $sd.FonteData = "log = primo ORDINE, report = primo DEAL (sedia PENDENTE)"
          } else { $sd.FonteData = "log (primo ordine) e report (primo deal) coerenti - sedia PENDENTE" }
        } else {
          $sd.FonteData = "log e report CONCORDI"
          if([math]::Abs($scarto) -gt 1){
            [void]$Problemi.Add($sd.Id + " GATE 1: le due misure indipendenti della prima operazione NON coincidono -- log " + $sd.PrimaDataLog + " contro report " + $sd.PrimaDataReport + " (" + [int][math]::Abs($scarto) + " giorni). Uso la PIU' VECCHIA e lo dichiaro, ma lo scarto va capito.")
            $sd.FonteData = "log e report DIVERGENTI: uso la piu' vecchia"
          }
        }
      }
      elseif($okLog){ $dUsata = $dLog; $sd.FonteData = "SOLO il log (il report non e' stato letto)" }
      elseif($okRep){
        $dUsata = $dRep
        $sd.FonteData = "SOLO il report"
        if($sd.MarkLog -eq ""){ $sd.FonteData = "SOLO il report (questo EA non logga gli ingressi: la misura 1 NON ESISTE)" }
      }

      if($sdFatale -eq ""){
        if(-not $okLog -and -not $okRep){
          $sdFatale = "GATE 1: la data della PRIMA OPERAZIONE non e' leggibile NE' dal log NE' dal report. Il gate NON HA GUARDATO NIENTE, e un gate che non legge non e' un gate verde. Cause da distinguere: (1) l'EA non ha operato affatto; (2) i log stanno in una radice che non guardo; (3) InpVerbose non e' arrivato acceso; (4) il report non e' stato scritto dove lo cerco; (5) il marcatore di log di QUESTA sedia (" + $sd.MarkLog + ") non corrisponde piu'. In tutti i casi NON e' un via libera."
        } else {
          $sd.PrimaDataUsata = $dUsata.ToString("yyyy.MM.dd",$INV)
          $dIni2 = DataInv $sd.Da
          $dFin2 = DataInv $Fino
          if($dFin2 -ne $null){ $sd.MesiOperati = [math]::Round((($dFin2 - $dUsata).TotalDays / 30.44),1) }
          $limP = $dIni2.AddMonths($MesiPrimaOp)
          if($dUsata -le $limP){
            $sd.Finestra = "PIENA (prima op. " + $sd.PrimaDataUsata + ", entro " + $MesiPrimaOp + " mesi dall'inizio della finestra)"
          } else {
            $sd.Finestra = "ACCORCIATA (prima op. " + $sd.PrimaDataUsata + ", finestra dichiarata dal " + $sd.Da + ")"
            [void]$Problemi.Add($sd.Id + " FINESTRA ACCORCIATA: la prima operazione e' del " + $sd.PrimaDataUsata + ", cioe' " +
                                [int]((($dUsata - $dIni2).TotalDays)/30.44) + " mesi dopo l'inizio della finestra (" + $sd.Da + "). O lo storico non arriva davvero li', o il motore non aveva le condizioni per operare. La corsa PROSEGUE, ma questa riga va scritta ACCANTO A OGNI NUMERO di questa sedia: i mesi misurati sono " + $sd.MesiOperati + ", non quelli della finestra dichiarata.")
          }
        }
      }
      if([int]$sd.N -ge 0 -and [int]$sd.NReport -ge 0 -and [int]$sd.N -ne [int]$sd.NReport -and $sd.Strumento -eq "OPTFRAME"){
        [void]$Problemi.Add($sd.Id + " GATE 2: il n dell'ottimizzazione (" + $sd.N + ", colonna Trades) e il n del report della passata singola (" + $sd.NReport + ", deal 'out') NON coincidono. Sono la STESSA cella su magic diversi: dovrebbero. Va capito prima di leggere la spina dorsale, che e' calcolata sui deal del report.")
      }
      if([int]$sd.N -eq 0){
        [void]$Problemi.Add($sd.Id + " GATE 2: n = 0 operazioni su tutta la finestra. Non c'e' niente da misurare: o lo storico non c'e', o la cella non opera su questo simbolo in questo periodo. NON e' un profitto zero, e' un profitto ASSENTE.")
      }
      Write-Host ("     prima op: log " + $sd.PrimaDataLog + " | report " + $sd.PrimaDataReport + " -> usata " + $sd.PrimaDataUsata) -ForegroundColor White
      Write-Host ("     FINESTRA " + $sd.Finestra + " | n " + $sd.N + " | gemelli " + $sd.Gemelli) -ForegroundColor Yellow
      if($sdFatale -ne ""){ throw $sdFatale }
    }

    # -----------------------------------------------------------------
    #  3h. LA NORMALIZZAZIONE A 1% -- e' la DECISIONE 3 firmata
    #      [APPROSSIMATO lineare, convenzione CONTRATTI_SEDIE punto 2].
    # -----------------------------------------------------------------
    if(-not $SoloControllo -and $sd.Misurata -and [double]$sd.Molt -gt 0){
      $sd.ProfitNorm = [math]::Round(([double]$sd.Profit * [double]$sd.Molt),2)
      if([double]$sd.DD -ge 0){ $sd.DDNorm = [math]::Round(([double]$sd.DD * [double]$sd.Molt),2) }
      #  --- il confronto col DD promesso: SOLO se il contratto da' un
      #      numero non ambiguo. E NON e' un verdetto (criteri 4.4).
      if([double]$sd.ContrDD -gt 0 -and [double]$sd.DDNorm -ge 0){
        $rap = [math]::Round(($sd.DDNorm / $sd.ContrDD),2)
        $sd.RapportoDD = $rap.ToString("0.00",$INV) + "x"
        if([double]$sd.DDNorm -gt [double]$sd.ContrDD){
          [void]$Problemi.Add($sd.Id + " RILIEVO (NON e' una revisione automatica): il DD normalizzato a 1% e' " + (Fmt2 $sd.DDNorm) + "%, cioe' " + $sd.RapportoDD + " il DD promesso dal contratto (" + $sd.ContrDD.ToString("0.00",$INV) + "%). ATTENZIONE: il promesso e' stato misurato su UN'ALTRA FINESTRA (spesso 12-13 mesi di OOS), quindi la differenza puo' essere tutta del cambio di finestra. Va portato a Claudio, non eseguito.")
        }
      }
      #  --- e l'avvertenza sul lotto minimo, dove la linearita' si rompe
      $rvv = 0.0
      if([double]::TryParse($sd.Risk,[Globalization.NumberStyles]::Float,$INV,[ref]$rvv) -and $rvv -lt 0.5){
        [void]$Note.Add($sd.Id + ": rischio vivo " + $sd.Risk + "% (sotto lo 0,5%). A questa taglia il lotto calcolato puo' cadere SOTTO IL MINIMO del simbolo e venire arrotondato in su: li' il rapporto col rischio NON e' piu' lineare e il numero NORMALIZZATO a 1% e' SOVRASTIMATO. La colonna serve a ordinare i motori, non a promettere euro.")
      }
    }

    # -----------------------------------------------------------------
    #  3i. IL CANCELLO SUL n -- ETICHETTA, MAI ESCLUSIONE (criteri 5.1)
    # -----------------------------------------------------------------
    if($SoloControllo){ $sd.Campione = "GIRO A VUOTO" }
    elseif([int]$sd.N -lt 0){ $sd.Campione = "NON MISURATO" }
    elseif([int]$sd.N -eq 0){ $sd.Campione = "PROFITTO ASSENTE (n=0, e non e' uno zero)" }
    elseif([int]$sd.N -lt [int]$NMinimo){ $sd.Campione = "CAMPIONE SOTTILE (n=" + $sd.N + " < " + $NMinimo + ")" }
    else { $sd.Campione = "n=" + $sd.N }

    if($SoloControllo){ $sd.Esito = "SOLO CONTROLLO" }
    elseif($sd.Misurata){ $sd.Esito = "OK" }
    else { $sd.Esito = "PARZIALE (nessun numero letto)" }

  }catch{
    $sd.Esito = "FERMATA -- " + $_.Exception.Message
    [void]$Problemi.Add($sd.Id + " " + $sd.Ea + " " + $sd.Sym + " FERMATA: " + $_.Exception.Message + "  >>> La sedia si dichiara NON MISURATA e la corsa PASSA ALLA SEGUENTE: una sedia storta non porta via le altre.")
    Write-Host ("  !! " + $sd.Id + " FERMATA: " + $_.Exception.Message) -ForegroundColor Red
  }
  $sd.Minuti = [math]::Round((New-TimeSpan -Start $tSedia -End (Get-Date)).TotalMinutes,1)
  if(-not $SoloControllo){
    $negtxt = "n/d"
    if([int]$sd.PeriodiOperati -ge 0){ $negtxt = $sd.PeriodiNeg.ToString() + "/" + $sd.PeriodiOperati.ToString() }
    Write-Host ("  => " + $sd.Id + " " + $sd.Esito + "   [" + $sd.Minuti.ToString("0.0",$INV) + " min]") -ForegroundColor Yellow
    Write-Host ("     PROF-VIVO " + (FmtEuro $sd.Profit $sd.Misurata) + " EUR | PROF-1% " + (FmtEuro $sd.ProfitNorm $sd.Misurata) +
                " | PF " + (Fmt3 $sd.PF) + " | DD " + (Fmt2 $sd.DD) + "% | " + $sd.Campione + " | periodi negativi " + $negtxt) -ForegroundColor Yellow
  }
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
if($SoloControllo){ $Modo = "CONTROLLO" }
if($TickReali -and -not $SoloControllo){ $Modo = "CORSA_TICKREALI" }
$Cart = Join-Path $Dsk ("R103_CLASSIFICA_FLOTTA_" + $Modo + "_" + $Stamp)
$Zip  = Join-Path $Dsk ("R103_CLASSIFICA_FLOTTA_" + $Modo + "_" + $Stamp + ".zip")
$Referto = Join-Path $Cart "REFERTO_R103.txt"

#  --- la riga della classifica: UNA sola definizione, usata dalle due
#      tabelle. Cosi' le colonne non possono divergere fra i due gruppi.
$FmtRiga = "{0,-4} {1,-4} {2,-34} {3,-7} {4,-6} {5,11} {6,11} {7,7} {8,8} {9,8} {10,9} {11,7} {12,9} {13,9}  {14}"
function IntestazioneTab(){
  return ($FmtRiga -f "POS","ID","EA","SIMB","RISCH","PROF-VIVO","PROF-1%","PF","DD-VIVO","DD-1%","DD-PROM","n","PEGGGIOR","NEG/OPER","NOTA")
}
function RigaTab($sd,$pos){
  $pgg = "n/d"; if($sd.PeggiorGiornata -ne "NON MISURATA"){ $pgg = ($sd.PeggiorGiornata -split "%")[0] + "%" }
  $prom = "n/d"; if([double]$sd.ContrDD -gt 0){ $prom = $sd.ContrDD.ToString("0.00",$INV) }
  $neg = "n/d"; if([int]$sd.PeriodiOperati -ge 0){ $neg = $sd.PeriodiNeg.ToString() + "/" + $sd.PeriodiOperati.ToString() }
  $nota = $sd.Campione
  if($sd.Esito -like "FERMATA*"){ $nota = $sd.Esito }
  elseif($sd.Strumento -ne "OPTFRAME"){ $nota = $nota + "  [SENZA OPTFRAME: numeri dai DEAL, DD equity NON MISURATO]" }
  return ($FmtRiga -f $pos,$sd.Id,$sd.Ea.Replace("ABTG_",""),$sd.Sym,($sd.Risk + "%"),
          (FmtEuro $sd.Profit $sd.Misurata),(FmtEuro $sd.ProfitNorm $sd.Misurata),(Fmt3 $sd.PF),
          (Fmt2 $sd.DD),(Fmt2 $sd.DDNorm),$prom,$sd.N,$pgg,$neg,$nota)
}

try{
  New-Item -ItemType Directory -Force -Path $Cart | Out-Null
  #  Solo i CSV delle sedie di QUESTO blocco: $Risultati non viene svuotata
  #  fra un blocco e l'altro, e senza filtro lo zip del blocco N
  #  conterrebbe i CSV dei blocchi precedenti senza etichetta.
  $idBlocco = '^R103_(' + (($Lavoro | ForEach-Object { [regex]::Escape($_.Id) }) -join '|') + ')_'
  foreach($f in @(Get-ChildItem -LiteralPath $Risultati -Filter "R103_*.csv" -File -ErrorAction SilentlyContinue | Where-Object { $_.Name -match $idBlocco })){
    Copy-Item -LiteralPath $f.FullName -Destination (Join-Path $Cart $f.Name) -Force
  }
  if(Test-Path -LiteralPath $Sosta){
    foreach($f in @(Get-ChildItem -LiteralPath $Sosta -File -ErrorAction SilentlyContinue)){
      Copy-Item -LiteralPath $f.FullName -Destination (Join-Path $Cart $f.Name) -Force
    }
  }

  $R = New-Object System.Collections.ArrayList
  [void]$R.Add("REFERTO R103 - LA CLASSIFICA DELLA FLOTTA")
  [void]$R.Add($Lavoro.Count.ToString() + " sedie su " + $SEDIE.Count + " (FOREX+METALLI " + $nF + ", INDICI " + $nI + "), deposito " + $Deposito + " EUR")
  [void]$R.Add("  FOREX+METALLI : " + $DaForex + " -> " + $Fino + "   (6,5 anni, col crollo covid dentro)   modello " + $Modello)
  [void]$R.Add("  INDICI        : " + $DaIndici + " -> " + $Fino + "   (21 mesi: IL BROKER NON HA ALTRO)     modello " + $ModelloIx)
  $coda = ""
  if($SoloControllo){ $coda = "   <<< GIRO A VUOTO: NESSUNA passata, NESSUN numero di round qui dentro" }
  [void]$R.Add("modo: " + $Modo + $coda)
  $sw = @()
  if($SoloControllo){ $sw += "-SoloControllo (nessuna passata)" }
  if($SenzaStorico) { $sw += "-SenzaStorico (barre NON scaricate: il tester si arrangia, e puo' volerci molto di piu')" }
  if($Rifai)        { $sw += "-Rifai" }
  if($SoloGruppo -ne ""){ $sw += ("-SoloGruppo " + $SoloGruppo + " (questo NON e' il round intero)") }
  if($SoloSedia -ne ""){ $sw += ("-SoloSedia " + $SoloSedia + " (un BLOCCO di sedie: questo NON e' il round intero)") }
  if($TickReali)    { $sw += "-TickReali (SOLO gruppo INDICI, modello 4: e' la corsa [DA FIRMARE] dei criteri 3.3)" }
  if($sw.Count -eq 0){ $sw += "nessuno (corsa piena su tutte e 40 le sedie, modello OHLC su tutte)" }
  [void]$R.Add("switch di questo giro: " + ($sw -join " | "))
  [void]$R.Add("data: " + (Get-Date).ToString("yyyy-MM-dd HH:mm:ss",$INV) + "   (questa data deve essere di ADESSO)")
  [void]$R.Add("     ATTENZIONE: la data fresca NON distingue un giro a vuoto da una corsa.")
  [void]$R.Add("     Lo distinguono la riga 'modo:' qui sopra e il NOME della cartella.")
  [void]$R.Add("avvio: " + $Avvio.ToString("yyyy-MM-dd HH:mm:ss",$INV) + "   durata: " + ((New-TimeSpan -Start $Avvio -End (Get-Date)).TotalHours).ToString("0.0",$INV) + " ore")
  [void]$R.Add("pin: " + $Pin)
  [void]$R.Add("criteri: risultati_archivio\R103_CRITERI.md   proposta FIRMATA: R103_PROPOSTA_CLASSIFICA_FLOTTA.md")
  [void]$R.Add("")
  [void]$R.Add("=====================================================================")
  [void]$R.Add(" COME SI LEGGE QUESTO REFERTO - e va letto PRIMA dei numeri")
  [void]$R.Add("=====================================================================")
  [void]$R.Add("  1. NESSUNA SEDIA VIENE PROMOSSA O BOCCIATA QUI DENTRO. Una")
  [void]$R.Add("     classifica e' un'informazione per decidere, non un verdetto")
  [void]$R.Add("     automatico. Le uscite restano quelle della C3 del 18/08, che")
  [void]$R.Add("     girano sul FORWARD, non su un backtest.")
  [void]$R.Add("")
  [void]$R.Add("  2. SI ORDINA SULLA COLONNA 'PROF-1%', NON SU 'PROF-VIVO'. E' la")
  [void]$R.Add("     DECISIONE 3 firmata: le sedie girano a taglie diverse (da 0,25%")
  [void]$R.Add("     a 1,0%), e confrontarle in euro 'come stanno' premia la TAGLIA,")
  [void]$R.Add("     non il MOTORE. PROF-1% = PROF-VIVO x (1 / rischio).")
  [void]$R.Add("     [APPROSSIMATO: riscalatura LINEARE, convenzione CONTRATTI_SEDIE")
  [void]$R.Add("     punto 2]. Sotto lo 0,5% di rischio la linearita' si rompe (il")
  [void]$R.Add("     lotto ha un minimo): su quelle righe il numero normalizzato e'")
  [void]$R.Add("     SOVRASTIMATO, e c'e' una nota apposta.")
  [void]$R.Add("")
  [void]$R.Add("  3. LE DUE TABELLE NON SI CONFRONTANO FRA LORO. 6,5 anni e 21 mesi")
  [void]$R.Add("     nella stessa classifica sarebbero la truffa peggiore del round.")
  [void]$R.Add("")
  [void]$R.Add("  4. IL BANCO, E I SUOI DUE LIMITI:")
  [void]$R.Add("     - MODELLO OHLC M1: il DD e la peggior giornata sono un LIMITE")
  [void]$R.Add("       INFERIORE del rischio (l'OHLC non vede i percorsi dentro la")
  [void]$R.Add("       barra);")
  [void]$R.Add("     - IL PROFITTO E' UNA STIMA DEL LORDO, E GENEROSA: spread")
  [void]$R.Add("       corrente, nessuno slippage, nessun requote, riempimenti")
  [void]$R.Add("       ideali. >>> NON E' UN GUADAGNO. La frase giusta e' 'su questo")
  [void]$R.Add("       banco avrebbe fatto X', mai 'avrebbe guadagnato X'.")
  [void]$R.Add("     >>> E SUGLI INDICI L'OHLC HA GIA' MENTITO, ed e' MISURATO: il")
  [void]$R.Add("         30/07 la revalidation a tick reali ha ribaltato")
  [void]$R.Add("         SupRev_DOW_H4 da PF 2,77 (OHLC) a PF 0,79 (tick reali).")
  [void]$R.Add("         La seconda tabella va letta sapendolo.")
  [void]$R.Add("")
  [void]$R.Add("  5. LA COLONNA 'NEG/OPER' e' la risposta letterale alla domanda di")
  [void]$R.Add("     Claudio del 24/08 ('vorrei capire se esistono anni negativi x")
  [void]$R.Add("     qualcuno'): periodi in perdita / periodi OPERATI. I periodi con")
  [void]$R.Add("     ZERO operazioni NON contano come negativi: si tolgono dal")
  [void]$R.Add("     denominatore e si elencano a parte. Il dettaglio periodo per")
  [void]$R.Add("     periodo sta sotto, sedia per sedia.")
  [void]$R.Add("       FOREX  -> ANNO per ANNO        INDICI -> TRIMESTRE per TRIMESTRE")
  [void]$R.Add("     Il trimestre sugli indici NON e' pigrizia: su 21 mesi e sedie")
  [void]$R.Add("     da 1-2 operazioni al mese, le caselle MENSILI conterrebbero 0 o")
  [void]$R.Add("     1 trade, e '12 mesi negativi su 21' si leggerebbe come una")
  [void]$R.Add("     condanna quando e' solo il segno di dodici singoli trade.")
  [void]$R.Add("     Il mese per mese si stampa lo stesso, marcato DIAGNOSTICA.")
  [void]$R.Add("")
  [void]$R.Add("  6. 'DD-PROM' e' il DD promesso dal contratto, ESTRATTO A RUNTIME da")
  [void]$R.Add("     CONTRATTI_SEDIE.md al pin. Dove esce 'n/d' il contratto NON DA'")
  [void]$R.Add("     un numero confrontabile (o e' scritto a due taglie, o non c'e'):")
  [void]$R.Add("     NON e' un via libera, e' un rilievo. E un DD sopra il promesso")
  [void]$R.Add("     qui e' un RILIEVO DA PORTARE A CLAUDIO, non una revisione")
  [void]$R.Add("     automatica: il promesso e' stato misurato su UN'ALTRA FINESTRA.")
  [void]$R.Add("")

  #  --- LE DUE TABELLE
  foreach($grp in @("FOREX","INDICI")){
    $righe = @($Lavoro | Where-Object { $_.Gruppo -eq $grp })
    if($righe.Count -eq 0){ continue }
    [void]$R.Add("=====================================================================")
    if($grp -eq "FOREX"){
      [void]$R.Add(" TABELLA 1 - FOREX + METALLI - " + $DaForex + " -> " + $Fino + " (6,5 anni)")
      [void]$R.Add(" ordinata su PROF-1% (profitto NORMALIZZATO a rischio 1%)")
    } else {
      [void]$R.Add(" TABELLA 2 - INDICI - " + $DaIndici + " -> " + $Fino)
      [void]$R.Add(" >>> 21 MESI, UN SOLO REGIME, NON CONFRONTABILE CON LA TABELLA 1 <<<")
      [void]$R.Add(" Non e' una scelta: la sonda del 17/08 misura su tutti gli indici")
      [void]$R.Add(" prima data 2024.09.26 con verdetto COMPLETO -- non manca sul disco,")
      [void]$R.Add(" IL BROKER NON CE L'HA, e nessuna riga puo' inventarlo.")
      [void]$R.Add(" ordinata su PROF-1% (profitto NORMALIZZATO a rischio 1%)")
    }
    [void]$R.Add("=====================================================================")
    $dentro = @($righe | Where-Object { $_.Misurata -and [int]$_.N -gt 0 })
    $fuori  = @($righe | Where-Object { -not ($_.Misurata -and [int]$_.N -gt 0) })
    $dentro = @($dentro | Sort-Object -Property @{ Expression = { [double]$_.ProfitNorm } } -Descending)
    [void]$R.Add((IntestazioneTab))
    [void]$R.Add(("-"*205))
    $pos = 0
    foreach($sd in $dentro){ $pos++; [void]$R.Add((RigaTab $sd $pos)) }
    if($fuori.Count -gt 0){
      [void]$R.Add("")
      [void]$R.Add("  --- SENZA NUMERI (e il perche' e' scritto, sedia per sedia) ---")
      [void]$R.Add("  >>> NON sono zeri: una sedia senza numeri non e' una sedia che ha")
      [void]$R.Add("      fatto zero. Stanno sotto, con la loro ragione.")
      foreach($sd in $fuori){ [void]$R.Add((RigaTab $sd "-")) }
    }
    [void]$R.Add("")
    if($grp -eq "INDICI"){
      [void]$R.Add("  ETICHETTA OBBLIGATORIA SU OGNI RIGA DI QUESTA TABELLA:")
      [void]$R.Add("  '21 mesi, UN solo regime, NON confrontabile con la tabella a 6,5 anni'.")
      [void]$R.Add("  E per DAX_Apertura_EU (I01) e Dow_Apertura_US (I02) il dettaglio")
      [void]$R.Add("  FINE e' gia' agli atti, misurato A TICK REALI sulla STESSA finestra:")
      [void]$R.Add("  risultati_archivio\R101_REFERTO.md (ablazione dei filtri). Qui le due")
      [void]$R.Add("  righe ci sono per COMPLETEZZA della flotta, e in OHLC.")
      [void]$R.Add("")
    }
  }

  [void]$R.Add("=====================================================================")
  [void]$R.Add(" SEDIA PER SEDIA - i numeri, la SPINA DORSALE, i gate, il contratto")
  [void]$R.Add("=====================================================================")
  foreach($sd in $Lavoro){
    [void]$R.Add("")
    [void]$R.Add("---------------------------------------------------------------------")
    [void]$R.Add($sd.Id + "  " + $sd.Ea + "   " + $sd.Sym + " " + $sd.Tf + "   [" + $sd.Gruppo + "]")
    [void]$R.Add("     magic vivo " + $sd.MagicVivo + " | magic del sorgente " + $sd.MagicSrc + " | rischio VIVO " + $sd.Risk + "% | commento '" + $sd.Commento + "' | version attesa " + $sd.Ver)
    if($sd.Commento -eq ""){
      [void]$R.Add("     >>> questo EA NON HA l'input InpComment (MISURATO nel sorgente): il")
      [void]$R.Add("         gate sul commento su questa sedia NON ESISTE, e nel .chr il suo")
      [void]$R.Add("         commento e' infatti VUOTO.")
    }
    [void]$R.Add("     finestra: " + $sd.Da + " -> " + $Fino + "   modello: " + $(if($sd.Gruppo -eq "INDICI"){ $ModelloIx } else { $Modello }))
    [void]$R.Add("     magic della corsa: gemelle " + ($sd.Base+10) + "/" + ($sd.Base+11) + ", singola " + ($sd.Base+12) + " (blocco 76xxxx VERGINE)")
    [void]$R.Add("     strumento: " + $sd.Strumento)
    [void]$R.Add("     esito: " + $sd.Esito + "   durata " + $sd.Minuti.ToString("0.0",$INV) + " min")
    [void]$R.Add("")
    [void]$R.Add("  I NUMERI")
    if($sd.Misurata){
      [void]$R.Add("     PROFITTO alla TAGLIA VIVA (" + $sd.Risk + "%) ...... " + (FmtEuro $sd.Profit $true) + " EUR")
      [void]$R.Add("     PROFITTO NORMALIZZATO a 1% (x" + $sd.Molt.ToString("0.00",$INV) + ") ..... " + (FmtEuro $sd.ProfitNorm $true) + " EUR   <<< e' la colonna della classifica")
      [void]$R.Add("     PF ................................. " + (Fmt3 $sd.PF))
      [void]$R.Add("     n operazioni ....................... " + $sd.N + "   (" + $sd.Campione + ")")
      [void]$R.Add("     DD massimo equity alla taglia viva .. " + (Fmt2 $sd.DD) + " %   [RISCHIO, limite inferiore: OHLC]")
      [void]$R.Add("     DD massimo normalizzato a 1% ....... " + (Fmt2 $sd.DDNorm) + " %   [APPROSSIMATO lineare]")
      if([double]$sd.MesiOperati -ge 0){
        [void]$R.Add("     mesi EFFETTIVAMENTE operati (dalla prima operazione): " + $sd.MesiOperati.ToString("0.0",$INV))
      }
    } else { [void]$R.Add("     ->  NON MISURATI. " + $sd.Campione) }
    if($sd.Strumento -ne "OPTFRAME"){
      [void]$R.Add("     >>> ATTENZIONE: questa sedia NON HA L'OPTFRAME (MISURATO nel")
      [void]$R.Add("         sorgente: nessun OnTesterDeinit). Profitto, PF e n qui sopra")
      [void]$R.Add("         vengono dai DEAL del report, non dallo strumento delle altre")
      [void]$R.Add("         39 sedie; IL DD DELL'EQUITY NON ESISTE e non e' stato")
      [void]$R.Add("         inventato. Le due passate gemelle non sono girate, quindi il")
      [void]$R.Add("         GATE 3 su di lei NON ESISTE -- e un gate che non c'e' non e'")
      [void]$R.Add("         un gate verde.")
    }
    [void]$R.Add("")
    [void]$R.Add("  LA SECONDA MISURA (dai DEAL del report, indipendente dall'OPTFRAME)")
    if($sd.DealMisurate){
      [void]$R.Add("     n " + $sd.DealN + "   netto " + (FmtEuro $sd.DealNetto $true) + " EUR   PF " + (Fmt3 $sd.DealPF) +
                   "   DD SUL SALDO CHIUSO " + (Fmt2 $sd.DealDDSaldo) + " %")
      [void]$R.Add("     >>> IL DD SUL SALDO NON E' IL DD DELL'EQUITY: ignora il flottante,")
      [void]$R.Add("         quindi e' un limite inferiore PIU' BASSO ANCORA. Non si mette")
      [void]$R.Add("         mai nella stessa colonna dell'altro.")
      [void]$R.Add("     >>> Se questi numeri divergono molto da quelli qui sopra, e' il")
      [void]$R.Add("         METODO che va guardato, non la sedia.")
    } else { [void]$R.Add("     ->  NON MISURATA (i deal del report non sono stati letti)") }
    [void]$R.Add("")
    $gran = "ANNO PER ANNO"; if($sd.Gruppo -eq "INDICI"){ $gran = "TRIMESTRE PER TRIMESTRE" }
    [void]$R.Add("  LA SPINA DORSALE " + $gran + "   <<< IL REQUISITO DI CLAUDIO")
    [void]$R.Add("     [APPROSSIMATO]: netto delle CHIUSURE REALIZZATE (Profitto+")
    [void]$R.Add("     Commissioni+Swap), periodo della CHIUSURA. NON e' l'equity e NON")
    [void]$R.Add("     e' il DD. Una posizione aperta a dicembre e chiusa a gennaio conta")
    [void]$R.Add("     TUTTA nel periodo della chiusura.")
    if(@($sd.PerPeriodo).Count -eq 0){
      [void]$R.Add("     ->  NON MISURATA (i deal del report non sono stati letti)")
    } else {
      [void]$R.Add(("     {0,-10} {1,7} {2,13} {3,15}" -f "PERIODO","n","NETTO EUR","CUMULATO EUR"))
      $cum = 0.0
      foreach($a in @($sd.PerPeriodo)){
        $cum = $cum + [double]$a.Netto
        $mark = ""
        if($a.N -eq 0){ $mark = "   <<< NESSUNA OPERAZIONE (fuori dal denominatore)" }
        elseif([double]$a.Netto -lt 0){ $mark = "   <<< NEGATIVO" }
        [void]$R.Add(("     {0,-10} {1,7} {2,13} {3,15}" -f $a.Periodo,$a.N,([double]$a.Netto).ToString("+0;-0;0",$INV),$cum.ToString("+0;-0;0",$INV)) + $mark)
      }
      [void]$R.Add("     >>> PERIODI NEGATIVI: " + $sd.PeriodiNeg + " su " + $sd.PeriodiOperati + " OPERATI (su " + $sd.PeriodiTot + " nominali)")
      if(@($sd.PeriodiVuoti).Count -gt 0){
        [void]$R.Add("     >>> " + @($sd.PeriodiVuoti).Count + " periodi SENZA NESSUNA OPERAZIONE: " + (@($sd.PeriodiVuoti) -join ", "))
        [void]$R.Add("         Non contano come negativi e NON stanno nel denominatore: un")
        [void]$R.Add("         periodo in cui la sedia non ha operato non e' un periodo in")
        [void]$R.Add("         perdita.")
      }
      if($sd.Gruppo -eq "FOREX"){
        [void]$R.Add("     >>> il 2026 e' PARZIALE: la finestra finisce il " + $Fino + ".")
      } else {
        [void]$R.Add("     >>> il primo trimestre (2024Q3) e' di soli CINQUE GIORNI (dal " + $DaIndici + "):")
        [void]$R.Add("         se esce a zero operazioni NON e' un trimestre negativo, e' un")
        [void]$R.Add("         trimestre che non c'e'. L'ultimo finisce il " + $Fino + ".")
      }
    }
    if(@($sd.PerMese).Count -gt 0){
      [void]$R.Add("")
      [void]$R.Add("     -- MESE PER MESE  [DIAGNOSTICA, NON E' IL CRITERIO] --")
      [void]$R.Add("        Sta qui perche' costa zero (sono gli stessi deal) e Claudio lo")
      [void]$R.Add("        vede se lo vuole. NON entra nella colonna NEG/OPER: su sedie da")
      [void]$R.Add("        1-2 operazioni al mese una casella mensile e' UN TRADE, e il")
      [void]$R.Add("        suo segno non e' una statistica.")
      [void]$R.Add(("        {0,-10} {1,7} {2,13}" -f "MESE","n","NETTO EUR"))
      foreach($a in @($sd.PerMese)){
        $mark = ""; if($a.N -eq 0){ $mark = "   (nessuna operazione)" }
        [void]$R.Add(("        {0,-10} {1,7} {2,13}" -f $a.Periodo,$a.N,([double]$a.Netto).ToString("+0;-0;0",$INV)) + $mark)
      }
    }
    [void]$R.Add("")
    [void]$R.Add("  LA PEGGIOR GIORNATA   (il muro prop giornaliero e' 5%)")
    [void]$R.Add("     ->  " + $sd.PeggiorGiornata)
    [void]$R.Add("     [APPROSSIMATO]: chiusure REALIZZATE, non equity intraday;")
    [void]$R.Add("     percentuale sul saldo a inizio giornata.")
    [void]$R.Add("     [APPROSSIMATO n.2]: MT5 lascia la colonna Profitto VUOTA sulle")
    [void]$R.Add("     righe di APERTURA ('in'), quindi quelle righe non entrano nella")
    [void]$R.Add("     somma -- e con loro non entra la COMMISSIONE d'ingresso, se il")
    [void]$R.Add("     simbolo ne ha una. L'errore va nella direzione COMODA (giornata")
    [void]$R.Add("     migliore del vero). Si controlla nello zip, in " + $sd.Id + "_report_singola.htm.")
    if($sd.PeggiorGiornataEA -ne "n/d"){
      [void]$R.Add("     -> SECONDA MISURA INDIPENDENTE (dall'OPTFRAME dell'EA): " + $sd.PeggiorGiornataEA)
    } else {
      [void]$R.Add("     -> nessuna seconda misura: l'OPTFRAME di questo EA non ha la")
      [void]$R.Add("        colonna 'Peggior Giornata %'.")
    }
    [void]$R.Add("")
    [void]$R.Add("  I GATE")
    [void]$R.Add("    1 prima operazione .. " + $sd.PrimaDataUsata + "   (finestra dichiarata dal " + $sd.Da + ")")
    [void]$R.Add("        misura 1, log del tester ... " + $sd.PrimaDataLog + "   (marcatore " + $(if($sd.MarkLog -eq ""){ "NESSUNO: questo EA non logga gli ingressi" } else { $sd.MarkLog }) + ", tipo " + $sd.TipoLog + ")")
    [void]$R.Add("        misura 2, report .htm ...... " + $sd.PrimaDataReport)
    [void]$R.Add("        fonte usata ................ " + $sd.FonteData)
    [void]$R.Add("        >>> FINESTRA: " + $sd.Finestra)
    [void]$R.Add("    2 n totale .......... " + $sd.N + "   (controllo incrociato dal report: " + $sd.NReport + ")")
    [void]$R.Add("    3 gemelli ........... " + $sd.Gemelli)
    [void]$R.Add("    4 densita' .......... " + $(if(@($sd.PerPeriodo).Count -eq 0){ "NON MISURATA" } else { $sd.PeriodiOperati.ToString() + " periodi operati su " + $sd.PeriodiTot + " nominali" }))
    [void]$R.Add("    5 campione .......... " + $sd.Campione + "   (soglia " + $NMinimo + ": sotto e' un'ETICHETTA, mai un'esclusione)")
    [void]$R.Add("")
    [void]$R.Add("  IL CONTRATTO DI QUESTA SEDIA, letto ADESSO dall'artefatto")
    [void]$R.Add("    fonte: report/CONTRATTI_SEDIE.md al pin " + $Pin)
    [void]$R.Add("    stato: " + $sd.ContrStato)
    [void]$R.Add("    riga VERBATIM: " + $sd.ContrRiga)
    if([double]$sd.ContrDD -gt 0){
      [void]$R.Add("    DD promesso " + $sd.ContrDD.ToString("0.00",$INV) + " %   contro il DD-1% misurato: " + $sd.RapportoDD)
      [void]$R.Add("    >>> E NON E' UN VERDETTO: il DD promesso e' stato misurato su")
      [void]$R.Add("        UN'ALTRA FINESTRA (spesso 12-13 mesi di OOS). Sopra il")
      [void]$R.Add("        promesso qui e' un RILIEVO da portare a Claudio, non una")
      [void]$R.Add("        revisione automatica. La regola del 18/08 parla del FORWARD.")
    } else {
      [void]$R.Add("    >>> CONFRONTO NON CALCOLABILE: il contratto di questa sedia non da'")
      [void]$R.Add("        un DD promesso numerico e confrontabile. IL CRITERIO NON E'")
      [void]$R.Add("        STATO TOCCATO: si dichiara che il denominatore non esiste.")
      [void]$R.Add("        E NON E' UN VIA LIBERA.")
    }
  }

  [void]$R.Add("")
  [void]$R.Add("=====================================================================")
  [void]$R.Add(" LE SEDIE CHE NON SONO IN QUESTA CLASSIFICA - e non e' un via libera")
  [void]$R.Add("=====================================================================")
  [void]$R.Add("  BREAKOUT_EA_JPY_v3   USDJPY   magic n/d   rischio n/d")
  [void]$R.Add("  >>> NON MISURABILE, e il motivo e' MISURATO: il sorgente NON ESISTE nel")
  [void]$R.Add("      repo (zero file 'BREAKOUT_EA_JPY_v3.mq5'; esistono BREAKOUT_EA_JPY.mq5")
  [void]$R.Add("      e BREAKOUT_EA_JPY_Multi.mq5, che sono ALTRI EA). Senza sorgente non")
  [void]$R.Add("      c'e' niente da compilare e niente da misurare. Nel .chr del 23/08 la")
  [void]$R.Add("      riga c'e' ancora, e non ha nemmeno un input di rischio leggibile.")
  [void]$R.Add("      E' una delle DUE SEDIE SENZA CONTRATTO del 18/08, famiglia SCARTATA")
  [void]$R.Add("      pre-progetto. IL RILIEVO E' APERTO DAL 18/08.")
  [void]$R.Add("")
  [void]$R.Add("  ABTG_GapContinuation   225JPY   magic 774101   rischio n/d")
  [void]$R.Add("  >>> FUORI MISURA: nel censimento .chr del 23/08 NON ha nessun input di")
  [void]$R.Add("      rischio leggibile. Senza taglia viva non esiste ne' la colonna")
  [void]$R.Add("      PROF-VIVO ne' quella normalizzata. NON e' una sedia senza metro (un")
  [void]$R.Add("      contratto ce l'ha: DD promesso 11,59%): e' una sedia senza TAGLIA")
  [void]$R.Add("      MISURATA. Si chiude con un .chr che la legga.")
  [void]$R.Add("")
  [void]$R.Add("  ABTG_Guardian e ABTG_TradeExporter: utility, non tradano.")
  [void]$R.Add("  ABTG_Nasdaq_Apertura_US: SPENTA dal 18/08 09:41.")
  [void]$R.Add("")
  [void]$R.Add("=====================================================================")
  [void]$R.Add(" COSA QUESTO ROUND **NON** PUO' DIRE")
  [void]$R.Add("=====================================================================")
  [void]$R.Add("  1. NESSUNA PROMOZIONE E NESSUNA BOCCIATURA. Non c'e' nessun verdetto")
  [void]$R.Add("     meccanico in questo round: e' una MISURA. Le decisioni le prende")
  [void]$R.Add("     Claudio leggendo la tabella.")
  [void]$R.Add("  2. NESSUN DRAWDOWN DI PORTAFOGLIO. Quaranta sedie non fanno un DD")
  [void]$R.Add("     pari alla somma dei loro ne' pari al massimo: dipende da QUANTO SI")
  [void]$R.Add("     SOVRAPPONGONO nel tempo, e questo round le misura UNA PER UNA.")
  [void]$R.Add("     SETTE di queste sedie stanno su GBPUSD e OTTO su U30USD: la")
  [void]$R.Add("     domanda del portafoglio, li', e' la domanda successiva ovvia, ed e'")
  [void]$R.Add("     un round diverso (macchina R16/R34/R37/R41).")
  [void]$R.Add("  3. NESSUN NUMERO A TICK REALI sul gruppo FOREX (non esistono prima")
  [void]$R.Add("     del 2024.07.05), nessuna misura di spread, nessuno slippage.")
  [void]$R.Add("  4. NIENTE SULLA CELLA MIGLIORE. Ogni sedia gira su UNA cella sola,")
  [void]$R.Add("     quella VIVA. Se una sedia esce male, la risposta NON e' 'proviamo")
  [void]$R.Add("     un'altra cella' -- quello sarebbe pescare.")
  [void]$R.Add("  5. NIENTE SUL FORWARD. Un backtest non e' un forward, e le uscite")
  [void]$R.Add("     della C3 del 18/08 girano sul forward.")
  [void]$R.Add("")
  [void]$R.Add("--- PASSO 0-A (le barre, un simbolo alla volta) ---")
  foreach($st in $Storico){
    [void]$R.Add("  " + $st.Sym + " dal " + $st.Da + " (TF " + $st.Tf + "): " + $st.Esito)
    foreach($rr in @($st.Righe)){ [void]$R.Add("      " + $rr) }
  }
  [void]$R.Add("  NIENTE TICK nello scarico: il round e' OHLC M1 per criterio. Le barre M1")
  [void]$R.Add("  servono davvero: il tester costruisce gli altri TF dalle M1, quindi la")
  [void]$R.Add("  profondita' che MORDE e' quella dell'M1.")
  [void]$R.Add("")
  [void]$R.Add("--- SE QUESTO ROUND E' PARZIALE: COME SI RIPRENDE ---")
  [void]$R.Add("  Qui non c'e' niente da saltare: ogni sedia ha UNA finestra sola, e un")
  [void]$R.Add("  rilancio liscio la rifa' tutta. LA RIPRESA CHE COSTA POCO e'")
  [void]$R.Add("  -SoloSedia con l'ELENCO (FRA APICI) delle sedie il cui 'esito' qui")
  [void]$R.Add("  sopra NON e' 'OK', oppure -SoloGruppo per rifare un gruppo intero.")
  [void]$R.Add("  Ogni giro scrive uno zip suo: vanno mandati TUTTI, non solo l'ultimo.")
  [void]$R.Add("")
  [void]$R.Add("--- NOTE ---")
  if($Note.Count -eq 0){ [void]$R.Add("  (nessuna)") }
  foreach($n in $Note){ [void]$R.Add("  - " + $n) }
  [void]$R.Add("")
  [void]$R.Add("--- PROBLEMI E RILIEVI ---")
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
    $ko2 = @($Lavoro | Where-Object { $_.Esito -ne "OK" })
    #  >>> DIFETTO DI LEGGIBILITA' GIA' PAGATO (R102 blocco 1, 24/08): la
    #      frase diceva "PARZIALE -- 0 sedie su 3 non sono OK", cioe'
    #      ANNUNCIAVA UN GUASTO mentre diceva che tutto era a posto, e i
    #      "problemi" erano rilievi DICHIARATIVI (cioe' RISULTATI del
    #      round). Claudio ha letto giallo e ha pensato che la corsa fosse
    #      fallita. Classe 47: la spia rossa decorativa. I due casi restano
    #      DISTINTI, e la frase dice quale dei due e'.
    if($ko2.Count -gt 0){
      [void]$R.Add("ESITO: PARZIALE -- " + $ko2.Count + " sedie su " + $Lavoro.Count + " NON hanno prodotto i numeri (elenco qui sopra), piu' " + $Problemi.Count + " rilievi. NON e' un blocco completo.")
    }
    elseif($Problemi.Count -gt 0){
      [void]$R.Add("ESITO: COMPLETO CON RILIEVI -- tutte e " + $Lavoro.Count + " le sedie hanno prodotto i numeri attesi. I " + $Problemi.Count + " rilievi in elenco sono RISULTATI del round (finestra accorciata, densita', contratto, DD sopra il promesso), non guasti: si leggono ACCANTO ai numeri, non invece dei numeri.")
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
function Riga3([string]$path,[string]$coda){
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
  foreach($grp in @("FOREX","INDICI")){
    $righe2 = @($Lavoro | Where-Object { $_.Gruppo -eq $grp })
    if($righe2.Count -eq 0){ continue }
    Write-Host ""
    if($grp -eq "FOREX"){
      Write-Host ("  TABELLA 1 - FOREX+METALLI  " + $DaForex + " -> " + $Fino + "   (ordinata su PROF-1%)") -ForegroundColor White
    } else {
      Write-Host ("  TABELLA 2 - INDICI  " + $DaIndici + " -> " + $Fino + "   (ordinata su PROF-1%)") -ForegroundColor White
      Write-Host  "  >>> 21 MESI, UN SOLO REGIME, NON CONFRONTABILE CON LA TABELLA 1" -ForegroundColor Yellow
    }
    $d2 = @($righe2 | Where-Object { $_.Misurata -and [int]$_.N -gt 0 })
    $d2 = @($d2 | Sort-Object -Property @{ Expression = { [double]$_.ProfitNorm } } -Descending)
    $f2 = @($righe2 | Where-Object { -not ($_.Misurata -and [int]$_.N -gt 0) })
    Write-Host ("   " + ("{0,-4} {1,-4} {2,-28} {3,-7} {4,-6} {5,11} {6,11} {7,7} {8,8} {9,7} {10,9}" -f "POS","ID","EA","SIMB","RISCH","PROF-VIVO","PROF-1%","PF","DD-1%","n","NEG/OPER")) -ForegroundColor White
    $p2 = 0
    foreach($sd in $d2){
      $p2++
      $c = "White"
      if([double]$sd.ProfitNorm -le 0){ $c = "Red" } elseif($sd.Campione -like "CAMPIONE SOTTILE*"){ $c = "Yellow" }
      $neg2 = "n/d"; if([int]$sd.PeriodiOperati -ge 0){ $neg2 = $sd.PeriodiNeg.ToString() + "/" + $sd.PeriodiOperati.ToString() }
      Write-Host ("   " + ("{0,-4} {1,-4} {2,-28} {3,-7} {4,-6} {5,11} {6,11} {7,7} {8,8} {9,7} {10,9}" -f `
         $p2,$sd.Id,$sd.Ea.Replace("ABTG_",""),$sd.Sym,($sd.Risk+"%"),
         (FmtEuro $sd.Profit $true),(FmtEuro $sd.ProfitNorm $true),(Fmt3 $sd.PF),(Fmt2 $sd.DDNorm),$sd.N,$neg2)) -ForegroundColor $c
    }
    if($f2.Count -gt 0){
      Write-Host ("   SENZA NUMERI: " + (($f2 | ForEach-Object { $_.Id }) -join ", ") + "  (il perche' e' nel referto, sedia per sedia -- NON sono zeri)") -ForegroundColor Yellow
    }
  }
  Write-Host ""
  Write-Host  "  >>> SI ORDINA SU PROF-1% (normalizzato a rischio 1%), non sugli euro veri:" -ForegroundColor Yellow
  Write-Host  "      in euro 'come stanno' vincerebbe la TAGLIA, non il MOTORE." -ForegroundColor Yellow
  Write-Host  "  >>> Il profitto e' una STIMA DEL LORDO su modello OHLC con spread corrente:" -ForegroundColor Yellow
  Write-Host  "      NON e' un guadagno, e NESSUNA sedia viene promossa o bocciata qui." -ForegroundColor Yellow
  Write-Host  "  >>> E R103 NON dice il DD di PORTAFOGLIO: misura le sedie una per una." -ForegroundColor Yellow
}
if($Problemi.Count -gt 0){
  Write-Host ""
  Write-Host "   PROBLEMI E RILIEVI DA LEGGERE:" -ForegroundColor Red
  foreach($p in $Problemi){ Write-Host ("    - " + $p) -ForegroundColor Red }
}
Write-Host ""
#  L'ESITO IN CONSOLE DEVE DIRE LE STESSE PAROLE DEL REFERTO, o i due si
#  contraddicono: chi legge lo schermo e manda lo zip non ha visto il referto.
if($Fatale -ne ""){ Write-Host ("ESITO: FERMATO -- " + $Fatale) -ForegroundColor Red; exit 1 }
$ko3 = @($Lavoro | Where-Object { $_.Esito -ne "OK" -and $_.Esito -ne "SOLO CONTROLLO" })
if($SoloControllo){
  if($ko3.Count -gt 0 -or $Problemi.Count -gt 0){
    Write-Host ("ESITO: GIRO A VUOTO CON PROBLEMI (" + $Problemi.Count + ") -- NESSUNA passata, e c'e' da leggere il referto") -ForegroundColor Yellow; exit 1
  }
  Write-Host "ESITO: GIRO A VUOTO COMPLETATO -- NESSUNA passata, NESSUN numero. QUESTO ZIP NON E' IL ROUND." -ForegroundColor Green
  exit 0
}
if($ko3.Count -gt 0){
  Write-Host ("ESITO: PARZIALE (" + $ko3.Count + " sedie non OK, " + $Problemi.Count + " rilievi) -- lo zip esiste: mandalo") -ForegroundColor Yellow; exit 1
}
if($Problemi.Count -gt 0){
  #  Tutte le sedie OK e solo rilievi dichiarativi: NON e' un fallimento, e
  #  quindi NON esce 1. Un codice rosso su una corsa riuscita e' esattamente
  #  la spia che nessuno guarda piu' la volta che diventa vera (classe 47).
  Write-Host ("ESITO: COMPLETO CON RILIEVI (" + $Problemi.Count + " rilievi da leggere nel referto, nessuna sedia mancante)") -ForegroundColor Green
  exit 0
}
Write-Host "ESITO: OK" -ForegroundColor Green
#  >>> L'exit 0 NON e' decorativo (rilievo del verificatore su R100).
#      Senza, uno script che finisce bene non tocca $LASTEXITCODE, che
#      resta quello dell'ULTIMO comando NATIVO eseguito: qui
#      `& $MetaEditor /compile` dell'ultimo EA, il cui rc questo driver
#      NON usa come esito (il verdetto e' il LastWriteTime del .ex5) e
#      che puo' benissimo essere != 0 a compilazione riuscita. La coda
#      della riga in chat avrebbe stampato "ESITO: PARZIALE O FERMO" su
#      un round andato bene.
exit 0
