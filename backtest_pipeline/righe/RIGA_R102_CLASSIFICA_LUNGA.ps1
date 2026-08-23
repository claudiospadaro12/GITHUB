# =====================================================================
#  MARCATORE_RIGA_R102_v1
#  RIGA_R102_CLASSIFICA_LUNGA.ps1  --  R102: LA CLASSIFICA LUNGA.
#  Le celle vive/promosse della flotta NON-ORO e NON-INDICE, misurate
#  sulla FINESTRA PIU' LUNGA che il broker permette, SIMBOLO PER SIMBOLO.
# ---------------------------------------------------------------------
#  CRITERI: backtest_pipeline\risultati_archivio\R102_CRITERI.md
#  >>> BOZZA: al momento in cui questo file e' scritto i criteri NON
#      sono ancora firmati. La riga NON si manda finche' Claudio non
#      firma R102_CRITERI.md. I criteri si cambiano PRIMA dei numeri.
#
#  DA DOVE NASCE, dichiarato: e' RIGA_R100_ORO_FLOTTA.ps1 (pin adbc27c
#  piu' le correzioni del verificatore fino a HEAD) GENERALIZZATA A
#  SIMBOLI DIVERSI. Il punto 9 della checklist dice che una riscrittura
#  non puo' perdere le funzioni di sicurezza del gemello: sono state
#  riportate TUTTE -- guardia MT5/MetaEditor chiusi, download pinnato
#  col marcatore, install dell'include ABTG_PausaGuardian.mqh, [Charts]
#  MaxBars, compilazione DIRETTA con verdetto LastWriteTime + backup
#  datato + ripristino del .mq5 se fallisce, SOSTA SVUOTATA A OGNI GIRO,
#  artefatti in sosta col nome proprio PRIMA dei gate, funzioni sopra il
#  try, MODO nel nome della cartella, log letti A OFFSET, \r? davanti a
#  ogni $ multilinea, cultura INVARIANTE, raccolta SEMPRE, exit 0
#  esplicito in fondo, parser dei deal corretto ('Bilancio' fra i
#  sinonimi + netto = Profitto+Commissioni+Swap).
#
#  ------------------------------------------------------------------
#  LA DOMANDA DEL ROUND, ed e' di Claudio (23/08, in chat):
#    "Breaking Band mi hai detto 133k ma con 10 anni di storico avrebbe
#     fatto lo stesso?"
#  R102 non risponde con un'opinione: risponde con la SPINA DORSALE ANNO
#  PER ANNO di ogni sedia (quante operazioni e quanto netto in ogni anno
#  solare), piu' i numeri sulla finestra lunga, sulla finestra COMUNE e
#  dentro le quattro finestre di regime di casa.
#
#  E RISPONDE DENTRO L'EMENDAMENTO REGOLA B (16/08), che qui e' il
#  cuore e non una postilla:
#    "Il VECCHIO giudica il RISCHIO. Il RECENTE giudica il MERITO."
#  Nato da un caso MISURATO: PTE USDJPY, IS 2010-2016 = 0 celle positive
#  su 28, OOS recente = 25 su 28. Quella finestra bocciava per un'epoca
#  morta.
#  >>> QUINDI: il profitto della finestra VECCHIA che esce da questo
#      round NON e' un giudizio di MERITO. E' una misura di ROBUSTEZZA
#      (l'edge attraversa i regimi, o e' figlio del 2024-26?) e una
#      misura di RISCHIO (DD lungo, peggior giornata). NESSUNA sedia
#      viene promossa o bocciata qui dentro. Ogni colonna del referto
#      porta la sua etichetta: [ROBUSTEZZA] o [RISCHIO].
#  ------------------------------------------------------------------
#
#  ------------------------------------------------------------------
#  LE TRE COSE CHE QUESTA RIGA FA E R100 NON FACEVA, tutte dichiarate:
#
#  1. IL SIMBOLO CAMBIA SEDIA PER SEDIA. Il PASSO 0-A (scarico barre)
#     si fa UNA VOLTA PER SIMBOLO DISTINTO, non per sedia: dodici
#     simboli, venti sedie. Su GBPUSD ci sono SETTE sedie e le barre si
#     scaricano una volta sola.
#  2. LA FINESTRA COMUNE. Le finestre lunghe hanno lunghezze DIVERSE
#     (GBPUSD 33 anni, XAGUSD 17,6): i profitti in euro su finestre
#     diverse NON SONO CONFRONTABILI, e una classifica costruita su
#     quelli sarebbe una classifica della PROFONDITA' DELLO STORICO.
#     Per questo esiste la finestra COMUNE 2009.01.01 -> 2026.06.30,
#     che tutti i dodici simboli hanno: e' l'UNICA colonna in cui la
#     parola "classifica" vuol dire qualcosa.
#  3. LA SPINA DORSALE ANNO PER ANNO, letta dai deal del report .htm
#     della passata singola: anno | n | netto. E' la risposta letterale
#     alla domanda di Claudio, ed e' anche il GATE 4 (DENSITA'): una
#     serie che il broker dichiara dal 1971 ma che nei primi quindici
#     anni non produce nessuna operazione NON e' "cinquantacinque anni
#     di storico", ed e' giusto che si veda.
#  ------------------------------------------------------------------
#
#  ------------------------------------------------------------------
#  IL LIMITE PIU' GRANDE, SCRITTO QUI E NON IN FONDO: IL MODELLO.
#  Modello 1 = OHLC su M1. I tick reali di BCM partono dal 2024.07.05:
#  su venti o trent'anni NON ESISTONO, e nessuna riga puo' inventarli.
#  Conseguenza, in due direzioni diverse:
#    - il DD e la peggior giornata sono un LIMITE INFERIORE del
#      rischio (l'OHLC non vede i percorsi dentro la barra);
#    - il PROFITTO e' una STIMA DEL LORDO, e generosa: spread scritto
#      a 0 (= spread corrente del terminale, non lo spread storico che
#      nel 1993 era molte volte piu' largo), nessuno slippage, nessun
#      requote, riempimenti ideali. Su una strategia a molte operazioni
#      la differenza col vero e' GRANDE.
#  >>> UN NUMERO DI PROFITTO DI QUESTO ROUND NON E' UN GUADAGNO. E' un
#      ordine di grandezza per confrontare le sedie FRA LORO, sullo
#      stesso banco e con gli stessi difetti.
#  ------------------------------------------------------------------
#
#  COSA FA, in ordine, e DA SOLA:
#    0. si rifiuta di partire se MT5 O MetaEditor sono aperti
#    1. scarica AL PIN report\CONTRATTI_SEDIE.md e scarica_storico.ps1
#    2. PASSO 0-A: per OGNI SIMBOLO DISTINTO della lista di lavoro,
#       barre M1 + H1/H2/H4/D1 dalla data della SONDA, -SenzaTick,
#       con VERDETTO confrontato con la data dichiarata
#    3. POI, UNA SEDIA ALLA VOLTA (mai in parallelo), per ognuna:
#       a. il SUO file prova e il SUO sorgente, col gate di versione
#       b. il SUO DD promesso da CONTRATTI_SEDIE.md, PER COLONNA e col
#          vincolo sul SIMBOLO
#       c. compila il SUO .mq5
#       d. PASSO 0-B: una passata SINGOLA su tutta la finestra lunga
#          -> log (prima operazione), report (deal, peggior giornata,
#             spina dorsale anno per anno)
#       e. PASSO 0-C: due passate GEMELLE sulla finestra lunga
#       f. i gate, poi la finestra COMUNE + le 4 di regime + 1
#          diagnostica 2008
#    4. raccolta SEMPRE: cartella sul Desktop + zip, con LA TABELLA
#       MADRE ordinata sulla finestra COMUNE.
#
#  QUELLO CHE NON FA, dichiarato:
#    - non promuove e non boccia niente per MERITO (Emendamento B)
#    - non tocca nessuna sedia viva: gira su magic VERGINI del blocco
#      79xxxx (verificato: ZERO occorrenze in tutto il repo, magic per
#      magic, tutti e 300). Sono vietati e controllati nel codice tutti
#      i magic vivi del censimento 23/08 e i blocchi 7799xx e 78xxxx
#      gia' spesi da R99 e R100.
#    - non scarica tick e non svuota bases\<server>\ticks
#    - non ammazza un lavoro in corso allo scadere di -OreMax
#    - NON MISURA LO SPREAD e non inventa nessun numero non letto in
#      un artefatto
#    - non tocca gli INDICI (partono tutti dal 2024.09.26: 21 mesi, e
#      il verdetto della sonda e' COMPLETO -- il broker non ce l'ha)
#      ne' l'ORO (gia' fatto: R99 e R100)
#
#  QUANTO CI METTE: [STIMA] misurata in DURATA SIMULATA, che e' l'unita'
#  che costa. Per sedia: PASSO 0 = 3 passate sulla finestra lunga
#  (media ~24 anni) = ~72 anni-sedia; le sei finestre = COMUNE 17,5x2
#  + ORSO 0,83x2 + CROLLO 0,25x2 + TORO 1x2 + LATERALE 1x2 + 2008 0,5x2
#  = ~42 anni-sedia. Totale ~114 per sedia, ~2.280 per venti sedie --
#  contro gli ~886 di R100, che erano stimati 2-6 ore.
#  >>> ORDINE DI GRANDEZZA ATTESO: 6-16 ORE DI TESTER, PIU' LO SCARICO
#      DELLE BARRE M1 DI DODICI SIMBOLI, che puo' valere altre ore e
#      che e' il collo di bottiglia vero. -OreMax e' 20 (tetto
#      sull'INIZIO di nuovi lavori).
#  >>> PER QUESTO LA RIGA SI LANCIA A BLOCCHI: -SoloSedia accetta un
#      ELENCO ("C01,C02,C03"). Il primo blocco e' BREAKING BAND, che e'
#      la domanda di Claudio.
#
#  LA RIGA CHE SI INCOLLA (blocco INTERO, un comando solo - checklist 21).
#  <PIN> = il commit che contiene QUESTO file: e' l'hash dato in chat.
#
#  & { $ErrorActionPreference='Stop'; [Net.ServicePointManager]::SecurityProtocol=[Net.SecurityProtocolType]::Tls12;
#      if(Get-Process terminal64,metaeditor64 -EA SilentlyContinue){ throw 'MT5 O METAEDITOR APERTO: chiudili e rilancia.' };
#      $pin='<PIN>'; $p="$env:USERPROFILE\RIGA_R102.ps1"; Remove-Item $p -EA SilentlyContinue;
#      irm "https://raw.githubusercontent.com/claudiospadaro12/GITHUB/$pin/backtest_pipeline/righe/RIGA_R102_CLASSIFICA_LUNGA.ps1" -OutFile $p;
#      if(-not (Select-String -Path $p -SimpleMatch -Pattern 'MARCATORE_RIGA_R102_v1' -Quiet)){ throw 'SCRIPT VECCHIO' };
#      $global:LASTEXITCODE=0; & $p -Pin $pin; if($LASTEXITCODE -ne 0){ Write-Host 'ESITO: PARZIALE O FERMO - leggi il REFERTO' } }
#
#  GIRO A VUOTO (pochi minuti, nessuna passata, nessun MT5 che opera):
#    ... & $p -Pin $pin -SoloControllo
#  Il giro a vuoto scrive e verifica GLI STESSI .ini che girano nella
#  corsa vera. Non c'e' un secondo artefatto (checklist 33).
#  >>> E NON MISURA NESSUN NUMERO: senza tester non esiste nessun DD,
#      nessun profitto, nessun n, nessuna giornata, nessuna classifica.
#      Sta scritto anche nel suo referto, perche' non lo si scambi per
#      il round (checklist 57).
# =====================================================================
param(
  # -Pin NON ha default: un default silenzioso ("lavoro") farebbe girare la
  #  punta del branch spacciandola per un commit congelato. Meglio morire.
  [string]$Pin        = "",
  [double]$OreMax     = 20.0,      # oltre questo NON si iniziano nuovi lavori
  [switch]$Rifai,                  # rifa' anche cio' che e' gia' presente
  [switch]$SoloControllo,
  [switch]$SenzaStorico,           # salta SOLO il PASSO 0-A (le barre)
  [string]$SoloSedia  = "",        # es. "C01" oppure "C01,C02,C03": un BLOCCO.
                                   #   E' il modo previsto di lanciare questo
                                   #   round, non un ripiego: 20 sedie in un
                                   #   colpo sono 6-16 ore.
  [string]$PavimentoData = "",     # es. "1999.01.04". VUOTO = nessun pavimento,
                                   #   cioe' si usa la data della SONDA cosi'
                                   #   com'e'. Serve SOLO se la corsa dimostra
                                   #   che le serie ricostruite (EUR pre-1999,
                                   #   USDJPY pre-1993) fanno perdere tempo o
                                   #   producono operazioni finte: si rilancia
                                   #   col pavimento SENZA cambiare il pin.
                                   #   Il referto lo dichiara in testa.
  [switch]$SaltaPasso0             # SOLO per riprendere una coda gia' gatata.
                                   #   Se lo usi, il referto lo scrive in rosso
                                   #   E i gate NON ci sono.
)
$ErrorActionPreference = "Stop"
[Threading.Thread]::CurrentThread.CurrentCulture   = [Globalization.CultureInfo]::InvariantCulture
[Threading.Thread]::CurrentThread.CurrentUICulture = [Globalization.CultureInfo]::InvariantCulture
[Net.ServicePointManager]::SecurityProtocol = [Net.SecurityProtocolType]::Tls12
$INV = [Globalization.CultureInfo]::InvariantCulture

$Avvio = Get-Date
$Stamp = $Avvio.ToString("yyyyMMdd_HHmm", $INV)
$Dsk   = Join-Path $env:USERPROFILE "Desktop"
$Work  = Join-Path $env:USERPROFILE "abtg_r102"
$Prove = Join-Path $Work "prove"
$Logs  = Join-Path $Work "log_r102"
$SrcDir= Join-Path $Work "src_motori"
$RawPin= "https://raw.githubusercontent.com/claudiospadaro12/GITHUB/$Pin"

$Fino     = "2026.06.30"      # scritto nel CRITERIO A, uguale a R99/R100
$Modello  = 1                 # OHLC M1 -- vedi l'intestazione. I tick reali
                              #  partono dal 2024.07.05: su vent'anni NON
                              #  ESISTONO. Il DD e' un LIMITE INFERIORE, il
                              #  profitto una STIMA DEL LORDO.
$Deposito = 100000            # la taglia della domanda di Claudio ("su 100k"),
                              #  ed e' anche quella dei round per-trade.
$SpreadIni= 0                 # 0 = spread CORRENTE, ma SCRITTO nell'ini invece
                              #  che lasciato allo stato nascosto del terminale.
                              #  NON e' uno stress di spread e NON e' una misura.
                              #  >>> E SU VENT'ANNI E' OTTIMISTA: lo spread del
                              #      1993 non era quello di oggi. Dichiarato.
$Suffisso = "_ohlc"           # regola di casa: un OHLC non deve nemmeno poter
                              #  finire nella stessa tabella di un tick reale
$CelleAttese = 2              # le due passate GEMELLE di controllo

#--- I GATE DELLA PRIMA OPERAZIONE (criteri R102 par. 5)
#    R100 aveva due date fisse perche' il simbolo era uno solo. Qui la
#    finestra cambia sedia per sedia, quindi il gate e' RELATIVO:
$MesiPiena     = 24           # prima op. entro DaQuando+24 mesi -> FINESTRA PIENA
$LimiteRanking = "2019.01.01" # se la prima operazione e' DOPO questa data la
                              #  sedia NON entra nella CLASSIFICA (la sua
                              #  finestra non contiene nemmeno le quattro
                              #  finestre di regime): i numeri si stampano
                              #  lo stesso, con l'etichetta NON CONFRONTABILE.
                              #  >>> NON e' un FATALE: e' un'etichetta. Una
                              #      sedia che ha girato non si butta via.

#--- I MAGIC VIETATI: TUTTI i magic vivi del censimento .chr del 23/08/2026
#    15:49, piu' i blocchi gia' spesi (7799xx di R99, 78xxxx di R100).
#    Il magic non cambia il comportamento dell'EA -- e' l'etichetta degli
#    ordini e qui l'asse gemello -- ma un magic vivo in un ini e' comunque
#    da fermare.
$MagicVietati = @(
  772161,772162,772163, 772361,772362,772363, 770101,770202,
  772421,772422,772423, 771531, 772231,772232,772233,772234,772235,
  770411,770611, 771321,771322,771323,771332,
  772341,772342,772343,772344,772345,772346,
  770901,770924,970901, 770511,770531,770532, 970912,970913,
  770402,971501,250604, 779001,
  970301,971001,771001,771501,770801,771301,771401,770301,770401,
  770921,770922,770923,770925,
  779910,779911,779912,
  780110,780111,780112,781210,781211,781212)

# =====================================================================
#  LE VENTI SEDIE. Ogni riga e' UNA sedia, col suo SIMBOLO, la sua data
#  di inizio storico, il suo file prova, il suo sorgente, i suoi input,
#  il suo marcatore di log.
#
#  >>> DA DOVE VIENE OGNI COLONNA (criteri R102 par. 2):
#      - Ea / Ver / MarkSrc / MarkLog : LETTI NEL SORGENTE al pin
#      - Sym / DaQuando  : MISURATI nella sonda del 17/08 (colonna
#        PrimaDataTF del CSV, non il ricordo)
#      - MagicVivo / Risk / Commento : MISURATI nel censimento .chr del
#        23/08/2026 15:49. **TUTTE E VENTI** hanno il rischio vivo
#        misurato: in R102 NON esiste il GRUPPO 2 di R100.
#      - Par / Vive : MISURATI sul file prova, non ricordati
#      - Base       : la base dei magic VERGINI 79xxxx di questa sedia
#      - TipoLog    : MERCATO = l'EA logga l'ESECUZIONE; PENDENTE = logga
#        anche il PIAZZAMENTO, che PUO' PRECEDERE il deal. Serve al
#        confronto fra le due misure del gate 1.
# =====================================================================
function S($id,$ea,$sym,$tf,$daq,$ver,$magicVivo,$magicSrc,$risk,$commento,$base,$par,$vive,$markSrc,$markLog,$tipoLog){
  return [pscustomobject]@{
    Id=$id; Ea=$ea; Sym=$sym; Tf=$tf; DaQuando=$daq; Ver=$ver;
    MagicVivo=$magicVivo; MagicSrc=$magicSrc; Risk=$risk;
    Commento=$commento; Base=$base; Par=$par; Vive=$vive;
    MarkSrc=$markSrc; MarkLog=$markLog; TipoLog=$tipoLog;
    # --- i risultati, riempiti durante la corsa
    Esito="NON ESEGUITA"; Minuti=0.0; DaEff=$daq;
    DDLungo=-1.0; N=-1; NReport=-1; Profit=0.0; PF=0.0;
    Gemelli="NON MISURATO"; Finestra="NON MISURATA"; AnniMisurati=-1.0;
    PrimaDataLog="NON MISURATA"; PrimaDataReport="NON MISURATA";
    PrimaDataUsata="NON MISURATA"; FonteData="nessuna";
    PeggiorGiornata="NON MISURATA"; PeggiorGiornataPct=99.9;
    PeggiorGiornataEA="n/d";
    ContrRiga="NON CERCATA"; ContrDD=-1.0; ContrStato="NON LETTO";
    Verdetto="NON MISURABILE"; Ranking="NON MISURABILE";
    Robustezza="NON MISURATA"; PerAnno=@(); AnniVuoti=@();
    Fin=@{}
  }
}

#  >>> ATTENZIONE ALLA COLONNA 'magicSrc'. Il gate di versione controlla
#      che il sorgente dichiari il magic giusto. Su TUTTE E VENTI le
#      sedie di R102 il magic VIVO non e' il default del sorgente: sono
#      tutte sedie di VIVAIO, cioe' N grafici dello stesso EA, e il
#      default del sorgente e' il magic "di famiglia" (772101 per il
#      BreakingBand, 772201 per il GapFill, ...). E' esattamente il caso
#      che in R100 valeva per due sedie su dodici, qui vale per tutte:
#      per questo NESSUNA di queste celle e' fatta di default, e ognuna
#      viene da un artefatto di DEPLOY nominato nel file prova.
$SEDIE = @(
  #   id    EA                    sym      TF   daQuando     ver    magicVivo magicSrc risk  commento           base   par vive markSrc                                                    markLog                                                     tipoLog
  (S "C01" "ABTG_BreakingBand"   "GBPUSD" "H1" "1993.05.11" "1.03" "772161" "772101" "1.0" "BB GBPUSD"        790100  71  74 '@ %s SL %s TP(%s) %s RR %.3f lot %.2f'                    '\[BB\]\s+(CONTINUAZIONE|INVERSIONE)\s+(LONG|SHORT)\s+@'    "MERCATO"),
  (S "C02" "ABTG_BreakingBand"   "EURUSD" "H1" "1971.01.03" "1.03" "772162" "772101" "1.0" "BB EURUSD"        790200  71  74 '@ %s SL %s TP(%s) %s RR %.3f lot %.2f'                    '\[BB\]\s+(CONTINUAZIONE|INVERSIONE)\s+(LONG|SHORT)\s+@'    "MERCATO"),
  (S "C03" "ABTG_BreakingBand"   "AUDUSD" "H1" "1993.04.26" "1.03" "772163" "772101" "1.0" "BB AUDUSD"        790300  71  74 '@ %s SL %s TP(%s) %s RR %.3f lot %.2f'                    '\[BB\]\s+(CONTINUAZIONE|INVERSIONE)\s+(LONG|SHORT)\s+@'    "MERCATO"),
  (S "C04" "ABTG_PTE"            "GBPUSD" "H1" "1993.05.11" "1.01" "771322" "771301" "0.5" "PTE GBPUSD"       790400  44  47 '%s @ %s SL %s TP %s lot %.2f'                             '\[PTE\]\s+(LONG|SHORT)\s+@'                                "MERCATO"),
  (S "C05" "ABTG_PTE"            "GBPUSD" "H1" "1993.05.11" "1.01" "771332" "771301" "0.5" "PTE GBPUSD B25"   790500  44  47 '%s @ %s SL %s TP %s lot %.2f'                             '\[PTE\]\s+(LONG|SHORT)\s+@'                                "MERCATO"),
  (S "C06" "ABTG_PTE"            "USDJPY" "H1" "1971.01.03" "1.01" "771323" "771301" "1.0" "PTE USDJPY"       790600  44  47 '%s @ %s SL %s TP %s lot %.2f'                             '\[PTE\]\s+(LONG|SHORT)\s+@'                                "MERCATO"),
  (S "C07" "ABTG_SuperWave"      "GBPUSD" "H4" "1993.05.11" "1.00" "770532" "770501" "1.0" "SW GBPUSD H2"     790700  44  47 '%s mercato %.2f lot @ %s SL %s TP %s'                     '\[SuperWave\]\s+(LONG|SHORT)\s+mercato'                    "MERCATO"),
  (S "C08" "ABTG_EasyTrend"      "CHFJPY" "H1" "1992.02.18" "1.00" "772421" "772401" "1.0" "EASYTREND CHFJPY" 790800  27  30 '%s a MERCATO @ %s  SL %s  TP %s  lot %.2f'                '\[EZ\]\s+(BUY|SELL|LONG|SHORT)\s+(LIMIT|a MERCATO)\s+@'    "PENDENTE"),
  (S "C09" "ABTG_EasyTrend"      "GBPUSD" "H1" "1993.05.11" "1.00" "772422" "772401" "1.0" "EASYTREND GBPUSD" 790900  27  30 '%s a MERCATO @ %s  SL %s  TP %s  lot %.2f'                '\[EZ\]\s+(BUY|SELL|LONG|SHORT)\s+(LIMIT|a MERCATO)\s+@'    "PENDENTE"),
  (S "C10" "ABTG_EasyTrend"      "AUDJPY" "H1" "1993.05.16" "1.00" "772423" "772401" "1.0" "EASYTREND AUDJPY" 791000  27  30 '%s a MERCATO @ %s  SL %s  TP %s  lot %.2f'                '\[EZ\]\s+(BUY|SELL|LONG|SHORT)\s+(LIMIT|a MERCATO)\s+@'    "PENDENTE"),
  (S "C11" "ABTG_CostToCost"     "EURJPY" "H4" "1993.04.26" "1.00" "772361" "772311" "1.0" "COST EURJPY"      791100  17  20 '%s a mercato @ %s  SL %s  TP %s  lot %.2f  (punta %s'     '\[COST\]\s+(LONG|SHORT)\s+a mercato @'                     "MERCATO"),
  (S "C12" "ABTG_CostToCost"     "GBPCAD" "H4" "2007.08.21" "1.00" "772362" "772311" "1.0" "COST GBPCAD"      791200  17  20 '%s a mercato @ %s  SL %s  TP %s  lot %.2f  (punta %s'     '\[COST\]\s+(LONG|SHORT)\s+a mercato @'                     "MERCATO"),
  (S "C13" "ABTG_CostToCost"     "XAGUSD" "H4" "2008.11.07" "1.00" "772363" "772311" "1.0" "COST XAGUSD"      791300  17  20 '%s a mercato @ %s  SL %s  TP %s  lot %.2f  (punta %s'     '\[COST\]\s+(LONG|SHORT)\s+a mercato @'                     "MERCATO"),
  (S "C14" "ABTG_GapFill"        "GBPUSD" "H1" "1993.05.11" "1.00" "772231" "772201" "1.0" "GAP GBPUSD"       791400  16  19 'GAP-FILL %s @ %s  SL %s  TP %s  lot %.2f'                 '\[GAP\]\s+GAP-FILL\s+(BUY|SELL)\s+@'                       "MERCATO"),
  (S "C15" "ABTG_GapFill"        "EURUSD" "H1" "1971.01.03" "1.00" "772232" "772201" "1.0" "GAP EURUSD"       791500  16  19 'GAP-FILL %s @ %s  SL %s  TP %s  lot %.2f'                 '\[GAP\]\s+GAP-FILL\s+(BUY|SELL)\s+@'                       "MERCATO"),
  (S "C16" "ABTG_GapFill"        "AUDUSD" "H1" "1993.04.26" "1.00" "772233" "772201" "1.0" "GAP AUDUSD"       791600  16  19 'GAP-FILL %s @ %s  SL %s  TP %s  lot %.2f'                 '\[GAP\]\s+GAP-FILL\s+(BUY|SELL)\s+@'                       "MERCATO"),
  (S "C17" "ABTG_PunteLarry"     "EURAUD" "H1" "2004.06.16" "1.00" "772342" "772301" "1.0" "LARRY EURAUD"     791700  20  23 'PENDENTE %s %s @ %s'                                      '\[LARRY\]\s+PENDENTE\s'                                    "PENDENTE"),
  (S "C18" "ABTG_PunteLarry"     "GBPJPY" "H1" "1993.04.18" "1.00" "772344" "772301" "1.0" "LARRY GBPJPY"     791800  20  23 'PENDENTE %s %s @ %s'                                      '\[LARRY\]\s+PENDENTE\s'                                    "PENDENTE"),
  (S "C19" "ABTG_PunteLarry"     "GBPUSD" "H1" "1993.05.11" "1.00" "772345" "772301" "1.0" "LARRY GBPUSD"     791900  20  23 'PENDENTE %s %s @ %s'                                      '\[LARRY\]\s+PENDENTE\s'                                    "PENDENTE"),
  (S "C20" "ABTG_PunteLarry"     "EURCAD" "H1" "1999.08.01" "1.00" "772346" "772301" "1.0" "LARRY EURCAD"     792000  20  23 'PENDENTE %s %s @ %s'                                      '\[LARRY\]\s+PENDENTE\s'                                    "PENDENTE")
)

# --- LE FINESTRE.
#     COMUNE  : e' LA colonna della classifica. 2009.01.01 perche' il
#               simbolo piu' corto della lista e' XAGUSD (2008.11.07,
#               MISURATO dalla sonda): e' lui a legare tutti gli altri.
#               Senza XAGUSD si potrebbe scendere al 2008.01.01 e
#               prendersi dentro la crisi -- e' una DECISIONE DI CLAUDIO
#               scritta nei criteri par. 3.2, non del codice.
#     Le quattro di REGIME sono AGLI ATTI: prova_regime.ps1 righe 69-75,
#               le stesse di R50/R56/R59, di R99 e di R100.
#     CRISI2008 e' DIAGNOSTICA e NON e' un criterio: sui simboli il cui
#               storico comincia dopo, la riga esce NON APPLICABILE --
#               e questo e' un dato, non un guasto.
#     Lo scarto sul magic (+20, +30, ...) si somma alla Base della sedia.
$FINESTRE = @(
  @("COMUNE",   "2009.01.01","2026.06.30", 20, $true,  "LA CLASSIFICA - l'unica finestra che TUTTI i simboli hanno (legata da XAGUSD 2008.11.07)"),
  @("ORSO",     "2022.01.01","2022.10.31", 30, $true,  "REGIME - finestra ORSO (R50/R56/R59)"),
  @("CROLLO",   "2020.02.01","2020.04.30", 40, $true,  "REGIME - finestra CROLLO"),
  @("TORO",     "2021.01.01","2021.12.31", 50, $true,  "REGIME - finestra TORO (R50/R56/R59)"),
  @("LATERALE", "2019.01.01","2019.12.31", 60, $true,  "REGIME - finestra LATERALE (R50/R56/R59)"),
  @("CRISI2008","2008.07.01","2008.12.31", 70, $false, "DIAGNOSTICA - la crisi del 2008   <<< NON E' UN CRITERIO")
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
$Storico   = New-Object System.Collections.ArrayList
$ContrTesto= ""
#  Sette EA per venti sedie: si compila UNA volta per EA. La tabella nasce
#  QUI, fuori dal try e fuori dal ciclo: dentro il ciclo si sarebbe
#  ricreata a ogni sedia e la guardia non avrebbe mai potuto scattare
#  (checklist 48, la funzione/variabile che vive nel ramo sbagliato).
$giaCompilati = @{}
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
#  rumore) e nel referto sarebbe il peggior refuso possibile.
function Fmt2($v){
  if($v -eq $null){ return "n/d" }
  if([double]$v -lt 0){ return "n/d" }
  return ([double]$v).ToString("0.00",$INV)
}
#  Il PROFITTO invece PUO' essere negativo, e un profitto negativo e' un
#  NUMERO, non un "non misurato". Per questo ha un formattatore SUO, con
#  la sentinella esplicita: e' esattamente lo scivolone che Fmt2 farebbe
#  se lo si riusasse per pigrizia (checklist 58, la famiglia dei numeri
#  plausibili).
function FmtEuro($v,$misurato){
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
#  come "prima operazione del 1993". Qui si scartano quelle coi millesimi
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
#  E' quella di R100, che nasce dal bug di R99: il parser cercava
#  'balance'/'saldo' e MT5 in italiano scrive **BILANCIO**, quindi
#  tornava una lista vuota su una tabella perfettamente leggibile.
#  E il netto di giornata e' Profitto+Commissioni+Swap, non il solo
#  Profitto (Commissioni e Swap sono colonne separate).
#  L'intestazione MISURATA (MT5 italiano) e':
#    Ora | Affare | Simbolo | Tipo | Direzione | Volume | Prezzo |
#    Ordine | Commissioni | Swap | Profitto | Bilancio | Commento
#  Il CONTROLLO POSITIVO e' dentro: una riga vale solo se ha una data
#  vera nella colonna Ora E 'in'/'out' nella colonna Direzione. Se non
#  ne riconosce nessuna torna VUOTO, chi chiama scrive "NON MISURATA"
#  -- e dice anche QUALI intestazioni ha visto.
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
#  IL DD PROMESSO, ESTRATTO DALL'ARTEFATTO -- PER COLONNA.
#  E' la funzione di R100, con UNA generalizzazione dichiarata: il
#  SIMBOLO non e' piu' "XAUUSD" scritto dentro, e' un parametro. Il
#  vincolo pero' RESTA, ed e' quello che in R100 ha impedito alla sedia
#  SupertrendReversal oro di pescare la riga del Nikkei (stesso magic
#  770901, collisione misurata il 22/08).
#  >>> E si rifiuta di leggere un numero scritto a UN'ALTRA TAGLIA: se
#      la cella contiene "a rischio 0,3%" o "a 0,5%", il DD promesso e'
#      AMBIGUO e il 2x resta NON CALCOLABILE, con la riga verbatim nel
#      referto. Un denominatore letto alla taglia sbagliata e' peggio di
#      un denominatore mancante.
#      ATTESO SU R102: le due PTE GBPUSD (771322 e 771332) escono
#      AMBIGUE, perche' i loro contratti sono scritti a due taglie
#      ("2,64% -- a 0,5% = 1,3%"). E' dichiarato nei criteri par. 6.
# =====================================================================
function DDPromesso($testoContratti,$ea,$sym,$magicVivo){
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
    #      "ABTG_EMA200_Ottimizzato": due sedie diverse)
    $primo = ("" + $celle[0]).Replace("*","").Trim()
    if($primo -notmatch ('^' + [regex]::Escape($ea) + '(\s|\(|$)')){ continue }
    #  --- IL SIMBOLO nella sua colonna (indice 1). E' il vincolo che in
    #      R100 ha chiuso la collisione 770901 fra oro e Nikkei.
    if($celle.Count -lt 2 -or ("" + $celle[1]).Trim().ToUpper() -ne $sym.ToUpper()){ continue }
    #  --- e il MAGIC VIVO nella sua colonna. Su R102 e' il vincolo che
    #      distingue le DUE PTE GBPUSD (771322 storica e 771332 B25), che
    #      hanno lo STESSO EA e lo STESSO simbolo e contratti DIVERSI.
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
Write-Host "#  R102 - LA CLASSIFICA LUNGA                                       #" -ForegroundColor Cyan
Write-Host "#  20 sedie forex/argento, 12 simboli, finestra MASSIMA per simbolo  #" -ForegroundColor Cyan
Write-Host "#  modello OHLC M1, deposito 100.000                                 #" -ForegroundColor Cyan
Write-Host "#####################################################################" -ForegroundColor Cyan
Dico ("pin      : " + $Pin)
Dico ("cartella : " + $Work)

# =====================================================================
#  LA LISTA DI LAVORO. -SoloSedia accetta un ELENCO: e' il modo previsto
#  di lanciare questo round (6-16 ore in un colpo non si fanno).
#  >>> @() SULLA RICEZIONE (checklist 62): con UNA sola sedia
#      PowerShell srotolerebbe la collezione nell'oggetto, e $Lavoro[0]
#      diventerebbe una PROPRIETA' invece della sedia.
# =====================================================================
$Lavoro = @($SEDIE)
if($SoloSedia -ne ""){
  $ids = @($SoloSedia -split ',' | ForEach-Object { $_.Trim().ToUpper() } | Where-Object { $_ -ne "" })
  $ignoti = @($ids | Where-Object { $u = $_; -not (@($SEDIE | Where-Object { $_.Id -eq $u }).Count) })
  if($ignoti.Count -gt 0){
    Write-Host ("!!! -SoloSedia: id sconosciuti [" + ($ignoti -join ", ") + "]. Id validi: " + (($SEDIE | ForEach-Object { $_.Id }) -join ", ")) -ForegroundColor Red
    exit 1
  }
  $Lavoro = @($SEDIE | Where-Object { $ids -contains $_.Id })
  if($Lavoro.Count -eq 0){ Write-Host "!!! -SoloSedia non ha selezionato nessuna sedia." -ForegroundColor Red; exit 1 }
}

# --- IL PAVIMENTO, se c'e': si applica QUI, una volta, e si DICHIARA.
$Pav = $null
if($PavimentoData -ne ""){
  $Pav = DataInv $PavimentoData
  if($Pav -eq $null){ Write-Host ("!!! -PavimentoData '" + $PavimentoData + "' non e' una data yyyy.MM.dd.") -ForegroundColor Red; exit 1 }
}
foreach($sd in $Lavoro){
  $sd.DaEff = $sd.DaQuando
  if($Pav -ne $null){
    $d0 = DataInv $sd.DaQuando
    if($d0 -ne $null -and $d0 -lt $Pav){ $sd.DaEff = $PavimentoData }
  }
}

# --- I SIMBOLI DISTINTI, con la data PIU' VECCHIA che serve a qualcuno.
#     Su GBPUSD ci sono sette sedie: le barre si scaricano UNA volta.
$Simboli = @{}
foreach($sd in $Lavoro){
  $d = DataInv $sd.DaEff
  if(-not $Simboli.ContainsKey($sd.Sym)){ $Simboli[$sd.Sym] = $sd.DaEff }
  else {
    $dv = DataInv $Simboli[$sd.Sym]
    if($d -ne $null -and $dv -ne $null -and $d -lt $dv){ $Simboli[$sd.Sym] = $sd.DaEff }
  }
}
$SimboliOrd = @($Simboli.Keys | Sort-Object)

$nCrit = @($FINESTRE | Where-Object { $_[4] }).Count
$nDiag = @($FINESTRE | Where-Object { -not $_[4] }).Count
Titolo "NUMERI ATTESI (dichiarati PRIMA della corsa)"
Write-Host ("    sedie ........................  " + $Lavoro.Count + " su " + $SEDIE.Count) -ForegroundColor White
Write-Host ("    simboli distinti .............  " + $SimboliOrd.Count + "   (" + ($SimboliOrd -join " ") + ")") -ForegroundColor White
Write-Host ("    finestre per sedia ...........  " + $FINESTRE.Count + "   (" + $nCrit + " di misura, + " + $nDiag + " DIAGNOSTICA)") -ForegroundColor White
Write-Host  "    piu' la finestra LUNGA, diversa per simbolo, nel PASSO 0" -ForegroundColor White
Write-Host ("    passate per sedia ............  " + (2*$FINESTRE.Count + 3)) -ForegroundColor White
Write-Host ("    passate TOTALI ...............  " + ($Lavoro.Count * (2*$FINESTRE.Count + 3))) -ForegroundColor White
Write-Host ("    modello ......................  " + $Modello + " = OHLC su M1   <<< i tick su vent'anni NON ESISTONO.") -ForegroundColor White
Write-Host  "                                    DD = LIMITE INFERIORE del rischio. PROFITTO = STIMA DEL LORDO." -ForegroundColor White
Write-Host ("    deposito .....................  " + $Deposito) -ForegroundColor White
Write-Host ("    spread .......................  Spread=" + $SpreadIni + " = spread CORRENTE, dichiarato. Sul 1993 e' OTTIMISTA.") -ForegroundColor White
if($Pav -ne $null){
  Write-Host ("    PAVIMENTO ....................  " + $PavimentoData + "  <<< le finestre piu' vecchie di questa data sono state TAGLIATE") -ForegroundColor Yellow
} else {
  Write-Host  "    PAVIMENTO ....................  nessuno: si usa la data della SONDA cosi' com'e'" -ForegroundColor White
}
Write-Host ""
Write-Host  "    LE FINESTRE DI OGNI SEDIA:" -ForegroundColor White
foreach($sd in $Lavoro){
  Write-Host ("      " + $sd.Id + "  " + $sd.Ea.PadRight(20) + " " + $sd.Sym + " " + $sd.Tf.PadRight(3) + "  lunga " + $sd.DaEff + " -> " + $Fino + "   rischio " + $sd.Risk + "%") -ForegroundColor DarkGray
}
Write-Host ""
Write-Host  "    COSA ESCE, E CON QUALE ETICHETTA (criteri R102 par. 3):" -ForegroundColor Yellow
Write-Host  "      [ROBUSTEZZA] profitto / PF / n sulla finestra LUNGA, sulla COMUNE e nelle 4 di regime" -ForegroundColor Yellow
Write-Host  "      [RISCHIO]    DD massimo dell'equity e PEGGIOR GIORNATA (muro prop giornaliero 5%)" -ForegroundColor Yellow
Write-Host  "      [ROBUSTEZZA] la SPINA DORSALE anno per anno: n e netto, anno solare per anno solare" -ForegroundColor Yellow
Write-Host  "      [RISCHIO]    l'UNICA decisione meccanica: DD lungo > 2x il DD promesso -> REVISIONE" -ForegroundColor Yellow
Write-Host ""
Write-Host  "    >>> QUESTO ROUND NON PROMUOVE E NON BOCCIA NIENTE PER MERITO." -ForegroundColor Yellow
Write-Host  "        Emendamento regola B: il VECCHIO giudica il RISCHIO, il RECENTE il MERITO." -ForegroundColor Yellow
Write-Host  "        Il profitto della finestra vecchia dice se l'edge ATTRAVERSA i regimi." -ForegroundColor Yellow
Write-Host ""
Write-Host  "    >>> E UNA SEDIA DICHIARATA E NON MISURABILE: BREAKOUT_EA_JPY_v3 su" -ForegroundColor Yellow
Write-Host  "        USDJPY. Il sorgente NON ESISTE nel repo (zero file), non ha un magic" -ForegroundColor Yellow
Write-Host  "        leggibile nel censimento e non ha nessun contratto. Non e' un via" -ForegroundColor Yellow
Write-Host  "        libera: e' il rilievo, ed e' lo stesso del 18/08." -ForegroundColor Yellow

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
#     Tutti e sette gli EA di R102 fanno #include <ABTG_PausaGuardian.mqh>
#     (verificato negli #include di ognuno): senza questa riga la
#     compilazione fallisce e il round muore alla prima passata.
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
#     E' il COLLO DI BOTTIGLIA del round: dodici simboli di M1 da
#     vent'anni. Si fa UNA volta per simbolo, non per sedia.
#     >>> NIENTE TICK: il round e' a modello OHLC M1.
#     >>> E IL M1 QUASI CERTAMENTE NON SARA' "COMPLETO", ed e' ATTESO:
#         scarica_storico.ps1 scrive InpTimeoutSec=120 nel preset, cioe'
#         due minuti per timeframe. Per questo il verdetto non-COMPLETO
#         sulla riga M1 finisce nelle NOTE e non nei PROBLEMI
#         (checklist 47). Il tester completa da solo mentre gira, e la
#         misura che DECIDE resta la data della prima operazione.
#     >>> IL VERDETTO SI CONFRONTA CON LA DATA DICHIARATA (come R95/R99):
#         se il broker risponde una PrimaDataServer PIU' RECENTE di
#         quella che la sonda aveva misurato il 17/08, la finestra di
#         quella sedia NON e' quella scritta nel file prova, e va detto
#         PRIMA di leggere i numeri.
# =====================================================================
if(-not $SoloControllo -and -not $SaltaPasso0 -and -not $SenzaStorico){
  Titolo ("2. PASSO 0-A - LE BARRE M1 + H1/H2/H4/D1, " + $SimboliOrd.Count + " SIMBOLI")
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
      $daSy = $Simboli[$sy]
      Write-Host ""
      Write-Host ("  -- barre di " + $sy + " dal " + $daSy) -ForegroundColor White
      #  Righe e' una ArrayList e NON un @(): su un array fisso .Add()
      #  esplode, e sarebbe esploso proprio dentro il PASSO 0-A, cioe'
      #  nel punto piu' lungo e piu' caro del round.
      $riga = [pscustomobject]@{ Sym=$sy; Da=$daSy; Esito="NON ESEGUITO"; Righe=(New-Object System.Collections.ArrayList) }
      $t0A = Get-Date
      try{
        $global:LASTEXITCODE = 0
        & powershell.exe -ExecutionPolicy Bypass -File $ScStorico -Simboli $sy -Da $daSy -Timeframes "M1,H1,H2,H4,D1" -SenzaTick -Auto -TimeoutMin 120 2>&1 |
          Tee-Object -FilePath (Join-Path $Logs ("passo0a_storico_" + $sy + ".txt")) | Out-Host
        $riga.Esito = "eseguito, uscita " + $LASTEXITCODE
        if($LASTEXITCODE -ne 0){
          $che = "errore"
          if($LASTEXITCODE -eq 2){ $che = "TIMEOUT dei 120 minuti: MT5 fermato a meta', il referto storico e' PARZIALE (ma c'e', e lo leggo lo stesso)" }
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
                                  ", cioe' DOPO il " + $daSy + " che la sonda del 17/08 aveva misurato e che sta scritto nei file prova. " +
                                  "La finestra lunga di questo simbolo NON e' quella dichiarata: va corretta nel file prova PRIMA di leggere i numeri, oppure il referto va letto con la finestra vera.")
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
                [void]$Note.Add($testo + "  ATTESO: scarica_storico.ps1 da' 120 secondi per timeframe e vent'anni di M1 non ci stanno. NON e' un guasto del round.")
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
  [void]$Storico.Add([pscustomobject]@{ Sym="(tutti)"; Da="-"; Esito="SALTATO (SoloControllo / SaltaPasso0 / SenzaStorico)"; Righe=@() })
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
Titolo ("3. LA CATENA - " + $Lavoro.Count + " sedie, " + ($FINESTRE.Count + 1) + " finestre ciascuna")
$iS = 0
foreach($sd in $Lavoro){
  $iS++
  $trascorse = (New-TimeSpan -Start $Avvio -End (Get-Date)).TotalHours
  if($trascorse -ge $OreMax -and -not $SoloControllo){
    $sd.Esito = "NON INIZIATA (tetto ore raggiunto)"
    [void]$Problemi.Add("TEMPO SCADUTO prima di " + $sd.Id + " " + $sd.Ea + " " + $sd.Sym + ": il round NON e' completo. COME SI RIPRENDE, e non e' 'rilancia la stessa riga': un rilancio liscio RIFA' il PASSO 0 (3 passate sulla finestra lunga) di TUTTE le sedie della lista, e salta solo le finestre gia' fatte. La ripresa che costa poco e' -SoloSedia con l'ELENCO delle sedie non fatte.")
    continue
  }
  $tSedia = Get-Date
  Write-Host ""
  Write-Host "==================================================================" -ForegroundColor Cyan
  Write-Host ("  [" + $iS + "/" + $Lavoro.Count + "]  " + $sd.Id + "  " + $sd.Ea) -ForegroundColor Cyan
  Write-Host ("           " + $sd.Sym + " " + $sd.Tf + "  |  " + $sd.DaEff + " -> " + $Fino + "  |  magic vivo " + $sd.MagicVivo + "  |  rischio " + $sd.Risk + "%") -ForegroundColor Cyan
  Write-Host "==================================================================" -ForegroundColor Cyan

  $sdFatale = ""
  try{
    # -----------------------------------------------------------------
    #  3a. IL FILE PROVA DI QUESTA SEDIA
    # -----------------------------------------------------------------
    $nomeProva = "R102_" + $sd.Ea + "_" + $sd.Sym + "_" + $sd.MagicVivo + ".txt"
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
    if(-not $m.Success -or $m.Groups[1].Value -ne $sd.DaQuando){ throw ("@DAQUANDO non e' " + $sd.DaQuando + " (la data MISURATA dalla sonda per " + $sd.Sym + ")") }
    $s1 = [regex]::Match($txtProva,'(?m)^@SIMBOLO\s+(\S+)')
    if(-not $s1.Success -or $s1.Groups[1].Value -ne $sd.Sym){ throw ("@SIMBOLO non e' " + $sd.Sym) }
    $p1 = [regex]::Match($txtProva,'(?m)^@PERIODO\s+(\S+)')
    if(-not $p1.Success -or $p1.Groups[1].Value -ne $sd.Tf){ throw ("@PERIODO non e' " + $sd.Tf + " (la sedia gira su quel timeframe di GRAFICO)") }
    #  --- il rischio: e' la TAGLIA VIVA, non un dettaglio
    if($txtProva -notmatch ('(?m)^InpRiskPercent=' + [regex]::Escape($sd.Risk) + '\|\|')){ throw ("file prova: InpRiskPercent non e' " + $sd.Risk + ". Con un rischio diverso il profitto e il DD non sono quelli della sedia viva.") }
    #  --- il commento della sedia viva
    if($txtProva -notmatch ('(?m)^InpComment=' + [regex]::Escape($sd.Commento) + '\r?$')){ throw ("file prova: InpComment non e' '" + $sd.Commento + "'.") }
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
    Dico ("file prova: " + $Vive.Count + " righe vive (" + $ProvaPar.Count + " parametri + 3 direttive), " + $sd.Sym + " " + $sd.Tf + " dal " + $sd.DaQuando + ", rischio " + $sd.Risk + "%, asse Y = InpMagic " + $magA + "/" + $magB) "Green"

    # -----------------------------------------------------------------
    #  3b. IL SORGENTE E I GATE DI VERSIONE
    # -----------------------------------------------------------------
    $srcMq5 = Join-Path $SrcDir ($sd.Ea + ".mq5")
    Scarica ("$RawPin/mql5/Experts/" + $sd.Ea + ".mq5") $srcMq5 'OptResults_'
    $txtSrc = Get-Content -LiteralPath $srcMq5 -Raw
    $mv = [regex]::Match($txtSrc,'#property\s+version\s+"([^"]+)"')
    if(-not $mv.Success){ throw ($sd.Ea + ".mq5 scaricato senza #property version: non e' il sorgente che credo.") }
    if($mv.Groups[1].Value -ne $sd.Ver){ throw ($sd.Ea + ".mq5 dichiara version '" + $mv.Groups[1].Value + "' invece di '" + $sd.Ver + "'. O la cache di raw.githubusercontent serve una copia vecchia, o il pin e' sbagliato.") }
    #  >>> IL MAGIC DEL SORGENTE, non quello vivo. Su TUTTE le sedie di
    #      R102 i due differiscono: sono sedie di VIVAIO, cioe' N grafici
    #      dello stesso EA, e il default del sorgente e' il magic "di
    #      famiglia". Col magic vivo qui dentro morirebbero tutte al gate
    #      su sorgenti perfettamente sani.
    if($txtSrc -notmatch ('InpMagic\s*=\s*' + $sd.MagicSrc)){ throw ($sd.Ea + ".mq5 non dichiara InpMagic = " + $sd.MagicSrc + " (il default del sorgente): non e' il motore che credo.") }
    if($txtSrc -notmatch 'ABTG_PausaGuardian\.mqh'){ throw ($sd.Ea + ".mq5 non include ABTG_PausaGuardian.mqh: il sorgente non e' quello che credo.") }
    #  >>> L'OPTFRAME: e' il solo strumento dei numeri di finestra. Se
    #      sparisse, non ci sarebbe niente da leggere (checklist 55).
    if($txtSrc -notmatch 'OnTesterDeinit'){ throw ($sd.Ea + ".mq5 non ha OnTesterDeinit: senza OPTFRAME non scrive nessun OptResults e il round non ha strumento.") }
    #  >>> IL MARCATORE DELLA RIGA D'INGRESSO, PRESO DAL SORGENTE CHE LA
    #      PRODUCE (checklist 55): e' da quella riga che il gate 1 legge la
    #      data della prima operazione.
    if($txtSrc -notmatch [regex]::Escape($sd.MarkSrc)){ throw ($sd.Ea + ".mq5 non contiene piu' la Log() d'ingresso ('" + $sd.MarkSrc + "'): il gate 1 non avrebbe niente da leggere nel log.") }
    Dico ($sd.Ea + ".mq5 al pin, version " + $mv.Groups[1].Value + " (magic sorgente " + $sd.MagicSrc + " [magic VIVO della sedia: " + $sd.MagicVivo + " -- e' un grafico di VIVAIO], include Guardian, OPTFRAME e Log d'ingresso presenti)") "Green"

    # -----------------------------------------------------------------
    #  3c. IL DD PROMESSO DI QUESTA SEDIA, dall'artefatto
    # -----------------------------------------------------------------
    $dd = DDPromesso $ContrTesto $sd.Ea $sd.Sym $sd.MagicVivo
    $sd.ContrRiga = $dd.Riga; $sd.ContrDD = $dd.DD; $sd.ContrStato = $dd.Stato
    if($sd.ContrDD -gt 0){
      Dico ("DD promesso ESTRATTO: " + $sd.ContrDD.ToString("0.00",$INV) + "%  -> soglia 2x = " + (2*$sd.ContrDD).ToString("0.00",$INV) + "%") "Green"
    } else {
      Dico ("DD promesso: " + $sd.ContrStato + " -> il confronto 2x sara' NON CALCOLABILE. NON e' un via libera.") "Yellow"
    }

    # -----------------------------------------------------------------
    #  3d. FASE COMPILA. .ex5 SCRITTO ADESSO.
    #     >>> INVOCAZIONE DIRETTA di metaeditor64.exe (checklist 54): con
    #         Start-Process -ArgumentList a stringhe pre-quotate, sui path
    #         con spazi ("Program Files") torna rc=0 SENZA compilare.
    #     >>> IL VERDETTO E' IL LastWriteTime DEL .ex5 PRIMA/DOPO, non
    #         "esiste" e non "e' recente": il file c'era gia'.
    #     >>> Questi EA sono SEDIE VIVE e il terminale e' collegato al
    #         conto vero: .mq5 E .ex5 vanno in backup DATATO, e se la
    #         compilazione fallisce il .mq5 viene RIMESSO com'era.
    #     >>> SI COMPILA UNA VOLTA PER EA, non una per sedia: sette EA per
    #         venti sedie. La guardia e' $giaCompilati.
    # -----------------------------------------------------------------
    if(-not $SoloControllo){
      if($giaCompilati.ContainsKey($sd.Ea)){
        Dico ("compilazione SALTATA: " + $sd.Ea + " gia' compilato in questo giro (" + $giaCompilati[$sd.Ea] + ")") "Gray"
      } else {
        $mq5 = Join-Path $MqlExperts ($sd.Ea + ".mq5")
        $ex5 = Join-Path $MqlExperts ($sd.Ea + ".ex5")
        $logC= Join-Path $MqlExperts ($sd.Ea + ".log")
        $bakMq5 = $mq5 + ".prima_r102_" + $Stamp
        $bakEx5 = $ex5 + ".prima_r102_" + $Stamp
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
    #  (a) OTTIMIZZAZIONE a due celle gemelle. Le righe restano in FORMA
    #      COMPLETA v||v||0||v||N: un pin scritto "Nome=v" secco imposta il
    #      valore ma NON spegne il flag di ottimizzazione che MT5 ricorda
    #      dall'ultima griglia di quell'EA (checklist 5).
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
      if($inputs -notmatch ('(?m)^InpRiskPercent=' + [regex]::Escape($sdRef.Risk) + '\|\|')){ throw ("ini OTT: InpRiskPercent non e' " + $sdRef.Risk + " (la TAGLIA VIVA).") }
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
    #  (b) PASSATA SINGOLA -> log (righe d'ingresso) e report .htm (i deal,
    #      da cui la peggior giornata E la spina dorsale anno per anno).
    #      Qui i valori si scrivono SECCHI e Optimization=0: un "||" rimasto
    #      vorrebbe dire un'ottimizzazione travestita -- e in ottimizzazione
    #      le Print non le legge nessuno (checklist 34), cioe' il gate 1
    #      resterebbe muto.
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
Symbol=$($sdRef.Sym)
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
    $iniInt  = Join-Path $Work ($sd.Id + "_passo0_lunga.ini")
    & $iniSingola $sd.DaEff $Fino ($sd.Base + 12) $iniSing ("R102_" + $sd.Id + "_singola")
    & $iniOtt     $sd.DaEff $Fino ($sd.Base + 10) $iniInt  ("R102_" + $sd.Id + "_lunga")
    Copy-Item -LiteralPath $iniSing -Destination (Join-Path $Sosta ($sd.Id + "_passo0_singola.ini")) -Force
    Copy-Item -LiteralPath $iniInt  -Destination (Join-Path $Sosta ($sd.Id + "_passo0_lunga.ini"))  -Force

    if($SoloControllo){
      $sd.Esito = "SOLO CONTROLLO"
      Write-Host ("    ini del PASSO 0 scritti e verificati; " + $FINESTRE.Count + " ini di finestra a seguire") -ForegroundColor DarkGray
    }
    elseif($SaltaPasso0){
      [void]$Problemi.Add($sd.Id + ": PASSO 0 SALTATO SU RICHIESTA. I GATE (prima operazione, n totale, gemelli identici al centesimo, densita' per anno) NON SONO STATI ESEGUITI, e con loro la peggior giornata e la spina dorsale. Questa corsa non ha guardato.")
      Write-Host "    !! PASSO 0 SALTATO. Il referto lo scrive in rosso." -ForegroundColor Red
    }
    else{
      # ---------------------------------------------------------------
      #  3e. LA PASSATA SINGOLA
      #      -> gate 1 misura 1 (log), peggior giornata, spina dorsale
      # ---------------------------------------------------------------
      Write-Host ("  -- PASSO 0-B: passata SINGOLA su " + $sd.DaEff + " -> " + $Fino + " (magic " + ($sd.Base+12) + ")") -ForegroundColor White
      Write-Host  "     ATTENZIONE alla durata: se le barre M1 di questo simbolo non sono complete," -ForegroundColor Yellow
      Write-Host  "     MT5 se le scarica MENTRE gira, e questa passata puo' durare molto piu' delle altre." -ForegroundColor Yellow
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
        [void]$dump.Add("R102 " + $sd.Id + " " + $sd.Ea + " " + $sd.Sym + " - righe d'ingresso lette nel log della passata singola (magic " + ($sd.Base+12) + ")")
        [void]$dump.Add("marcatore: " + $sd.MarkLog + "   tipo: " + $sd.TipoLog)
        [void]$dump.Add("log letti: " + $letti + "   righe trovate: " + $righeIN.Count)
        [void]$dump.Add("")
        foreach($x in @($righeIN | Select-Object -First 40)){ [void]$dump.Add($x.Riga) }
        Set-Content -LiteralPath (Join-Path $Sosta ($sd.Id + "_ingressi_log.txt")) -Value $dump -Encoding ASCII
      }

      # --- (2) IL REPORT: i DEAL. Da qui la PEGGIOR GIORNATA, la SPINA
      #     DORSALE ANNO PER ANNO e la SECONDA misura della prima data.
      #     >>> QUESTA MISURA SI FA SEMPRE, fuori dal ramo della prima
      #         (checklist 56-bis): serve a DIAGNOSTICARE il fallimento
      #         dell'altra, non a sostituirla.
      $repFile = ""
      foreach($rad in @($InstDir,$DataFolder,$Work,$MqlFiles)){
        if(-not (Test-Path -LiteralPath $rad)){ continue }
        $c = @(Get-ChildItem -LiteralPath $rad -Filter ("R102_" + $sd.Id + "_singola*.htm*") -File -ErrorAction SilentlyContinue |
               Where-Object { $_.LastWriteTime -ge $tPasso0 } | Sort-Object LastWriteTime -Descending)
        if($c.Count -gt 0){ $repFile = $c[0].FullName; break }
      }
      if($repFile -ne ""){
        Copy-Item -LiteralPath $repFile -Destination (Join-Path $Sosta ($sd.Id + "_report_singola.htm")) -Force -ErrorAction SilentlyContinue
        $deal = @(LeggiDeal $repFile)
        if($deal.Count -eq 0){
          $diag = "nessuna intestazione candidata trovata"
          if($script:DealIntestazioni.Count -gt 0){ $diag = "intestazioni candidate viste: [ " + ($script:DealIntestazioni -join " ]  [ ") + " ]" }
          [void]$Problemi.Add($sd.Id + ": il report esiste (" + $repFile + ") ma NON ci ho riconosciuto nessuna riga di DEAL (Ora con data + Direzione in/out + Profitto + Bilancio). La PEGGIOR GIORNATA e la SPINA DORSALE restano NON MISURATE: nessun numero inventato. DIAGNOSTICA -> " + $diag)
        } else {
          [void]$Note.Add($sd.Id + ": tabella deal riconosciuta, colonne " + $script:DealColonne + " (indici a base 0). Netto = Profitto+Commissioni+Swap.")
          $sd.PrimaDataReport = $deal[0].Q.ToString("yyyy.MM.dd",$INV)
          $sd.NReport = @($deal | Where-Object { $_.Dir -eq "out" -or $_.Dir -eq "in/out" }).Count
          $conNetto = @($deal | Where-Object { $_.Netto -ne $null }).Count
          if($conNetto -eq 0){
            [void]$Problemi.Add($sd.Id + ": riconosciuti " + $deal.Count + " deal ma NESSUNO ha un netto leggibile (" + $script:DealColonne + "). PEGGIOR GIORNATA e SPINA DORSALE NON MISURATE.")
          } else {
            # ---- LA PEGGIOR GIORNATA, per giorno di calendario -------
            #  [APPROSSIMATO, e il referto lo dice]: e' la peggior
            #  giornata sulle CHIUSURE REALIZZATE, non sull'equity
            #  intraday. Stessa approssimazione di R51, R99 e R100.
            #  CONTROLLO POSITIVO (checklist 55): zero netti letti e zero
            #  giornate perdenti devono essere DISTINGUIBILI, e nessun
            #  accumulatore di minimo parte da un pavimento a 0.
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
            # ---- LA SPINA DORSALE ANNO PER ANNO (GATE 4: DENSITA') ----
            #  E' la risposta letterale alla domanda di Claudio: quante
            #  operazioni e quanto netto in OGNI anno solare.
            #  [APPROSSIMATO]: chiusure REALIZZATE. Non e' l'equity e non
            #  e' il DD: e' il flusso di cassa dei deal, che e' un'altra
            #  cosa e va letto come tale.
            $perAnno = @{}; $nAnno = @{}
            foreach($d in $deal){
              $y = $d.Q.Year
              if(-not $perAnno.ContainsKey($y)){ $perAnno[$y] = 0.0; $nAnno[$y] = 0 }
              if($d.Netto -ne $null){ $perAnno[$y] = $perAnno[$y] + [double]$d.Netto }
              if($d.Dir -eq "out" -or $d.Dir -eq "in/out"){ $nAnno[$y] = $nAnno[$y] + 1 }
            }
            $dIni = DataInv $sd.DaEff
            $dFin = DataInv $Fino
            $lista = New-Object System.Collections.ArrayList
            $vuoti = New-Object System.Collections.ArrayList
            if($dIni -ne $null -and $dFin -ne $null){
              for($y = $dIni.Year; $y -le $dFin.Year; $y++){
                $nn = 0; $pp = 0.0
                if($nAnno.ContainsKey($y)){ $nn = $nAnno[$y]; $pp = $perAnno[$y] }
                [void]$lista.Add([pscustomobject]@{ Anno=$y; N=$nn; Netto=[math]::Round($pp,2) })
                if($nn -eq 0){ [void]$vuoti.Add($y) }
              }
            }
            $sd.PerAnno   = @($lista)
            $sd.AnniVuoti = @($vuoti)
            if($vuoti.Count -gt 0){
              [void]$Note.Add($sd.Id + " GATE 4 (DENSITA'): " + $vuoti.Count + " anni solari su " + $lista.Count +
                              " dentro la finestra dichiarata NON hanno NESSUNA operazione (" + (@($vuoti) -join ", ") +
                              "). La finestra NOMINALE e' " + $lista.Count + " anni, quella EFFETTIVAMENTE OPERATA e' " +
                              ($lista.Count - $vuoti.Count) + ". Ogni volta che si dice 'N anni di storico' su questa sedia, il numero da dire e' il secondo.")
            }
          }
        }
      } else {
        [void]$Problemi.Add($sd.Id + ": NON ho trovato nessun report 'R102_" + $sd.Id + "_singola*.htm' scritto dopo l'avvio della passata (cercato in " + $InstDir + ", " + $DataFolder + ", " + $Work + ", " + $MqlFiles + "). PEGGIOR GIORNATA e SPINA DORSALE restano NON MISURATE e NON si inventano. COME AVERLE: aprire MT5, Strategy Tester, ricaricare " + $sd.Id + "_passo0_singola.ini (e' nello zip) in test singolo, tasto destro sul risultato -> Report, e leggere la tabella dei Deal.")
      }

      # ---------------------------------------------------------------
      #  3f. LE DUE PASSATE GEMELLE SULLA FINESTRA LUNGA
      # ---------------------------------------------------------------
      Write-Host ("  -- PASSO 0-C: due passate GEMELLE sulla finestra lunga (magic " + ($sd.Base+10) + "/" + ($sd.Base+11) + ")") -ForegroundColor White
      $csvInt = Join-Path $Risultati ("R102_" + $sd.Id + "_" + $sd.Ea + "_" + $sd.Sym + "_LUNGA" + $Suffisso + ".csv")
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
          Copy-Item -LiteralPath $OptCsv -Destination (Join-Path $Sosta ($sd.Id + "_lunga_optresults.csv")) -Force
          Remove-Item -LiteralPath $OptCsv -Force -ErrorAction SilentlyContinue
        }
      }
      if(-not (Test-Path -LiteralPath $csvInt)){
        $sdFatale = "PASSO 0-C: nessun OptResults sulla finestra lunga. O lo storico M1 non copre " + $sd.DaEff + ", o MT5 non e' partito, o la cache ha ripescato passate vecchie senza riscrivere i frame. NON e' un via libera: senza questo file non esistono ne' il n, ne' il profitto, ne' il DD, ne' il gate dei gemelli."
      } else {
        $rows = @(Import-Csv -LiteralPath $csvInt)
        if($rows.Count -ne $CelleAttese){
          $sdFatale = "PASSO 0-C: l'OptResults ha " + $rows.Count + " righe invece di " + $CelleAttese + " (le due gemelle). O la cache del tester ha ripescato passate gia' calcolate senza riscrivere i frame, o l'asse InpMagic non ha spazzolato."
        } else {
          #  IL CONTROLLO POSITIVO SUL PARSER (checklist 55): prima si
          #  verifica che le COLONNE esistano, coi loro nomi veri. Senza,
          #  una colonna rinominata darebbe $null in silenzio.
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
              #  >>> IL QUARTO STRUMENTO, dove c'e': sei EA su sette hanno
              #      la colonna 'Peggior Giornata %' calcolata DENTRO l'EA
              #      (ABTG_SuperWave no). E' un controllo incrociato
              #      indipendente sulla peggior giornata.
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
      elseif($okRep){ $dUsata = $dRep; $sd.FonteData = "SOLO il report (il log non e' stato letto)" }

      if($sdFatale -eq ""){
        if(-not $okLog -and -not $okRep){
          $sdFatale = "GATE 1: la data della PRIMA OPERAZIONE non e' leggibile NE' dal log NE' dal report. Il gate NON HA GUARDATO NIENTE, e un gate che non legge non e' un gate verde. Cause da distinguere: (1) l'EA non ha operato affatto; (2) i log stanno in una radice che non guardo; (3) InpVerbose non e' arrivato acceso; (4) il report non e' stato scritto dove lo cerco; (5) il marcatore di log di QUESTA sedia (" + $sd.MarkLog + ") non corrisponde piu'. In tutti i casi NON e' un via libera."
        } else {
          $sd.PrimaDataUsata = $dUsata.ToString("yyyy.MM.dd",$INV)
          $dIni2 = DataInv $sd.DaEff
          $dFin2 = DataInv $Fino
          if($dFin2 -ne $null){ $sd.AnniMisurati = [math]::Round((($dFin2 - $dUsata).TotalDays / 365.25),1) }
          $limP = $dIni2.AddMonths($MesiPiena)
          $limR = DataInv $LimiteRanking
          if($dUsata -le $limP){
            $sd.Finestra = "PIENA (prima op. " + $sd.PrimaDataUsata + ", entro " + $MesiPiena + " mesi dall'inizio dichiarato)"
          } else {
            $sd.Finestra = "ACCORCIATA (prima op. " + $sd.PrimaDataUsata + ", dichiarata dal " + $sd.DaEff + ")"
            [void]$Problemi.Add($sd.Id + " FINESTRA ACCORCIATA: la prima operazione e' del " + $sd.PrimaDataUsata + ", cioe' " +
                                [int]((($dUsata - $dIni2).TotalDays)/30.4) + " mesi dopo l'inizio dichiarato (" + $sd.DaEff + "). O lo storico M1 non arriva davvero li', o il motore non aveva le condizioni per operare. La corsa PROSEGUE, ma questa riga va scritta ACCANTO A OGNI NUMERO di questa sedia: gli anni misurati sono " + $sd.AnniMisurati + ", non quelli della finestra dichiarata.")
          }
          if($limR -ne $null -and $dUsata -gt $limR){
            $sd.Ranking = "FUORI CLASSIFICA (prima op. " + $sd.PrimaDataUsata + ", dopo il " + $LimiteRanking + ")"
            [void]$Problemi.Add($sd.Id + " FUORI CLASSIFICA: la prima operazione e' del " + $sd.PrimaDataUsata + ", dopo il " + $LimiteRanking + ". La sua finestra non contiene nemmeno le quattro finestre di regime, quindi la domanda del round (l'edge attraversa i regimi?) su questa sedia NON HA STRUMENTO. I numeri si stampano lo stesso -- una sedia che ha girato non si butta via -- ma NON entrano nella classifica.")
          }
        }
      }
      if($sd.N -ge 0 -and $sd.NReport -ge 0 -and $sd.N -ne $sd.NReport){
        [void]$Problemi.Add($sd.Id + " GATE 2: il n dell'ottimizzazione (" + $sd.N + ", colonna Trades) e il n del report della passata singola (" + $sd.NReport + ", deal 'out') NON coincidono. Sono la STESSA cella su magic diversi: dovrebbero. Va capito prima di leggere la peggior giornata e la spina dorsale, che sono calcolate sui deal del report.")
      }
      if($sd.N -eq 0){
        [void]$Problemi.Add($sd.Id + " GATE 2: n = 0 operazioni su tutta la finestra lunga. Non c'e' niente da misurare: o lo storico non c'e', o la cella non opera su questo simbolo. NON e' un profitto zero, e' un profitto ASSENTE.")
      }
      Write-Host ("     prima op: log " + $sd.PrimaDataLog + " | report " + $sd.PrimaDataReport + " -> usata " + $sd.PrimaDataUsata) -ForegroundColor White
      Write-Host ("     FINESTRA " + $sd.Finestra + " | n " + $sd.N + " | gemelli " + $sd.Gemelli) -ForegroundColor Yellow
      Write-Host ("     LUNGA: profitto " + (FmtEuro $sd.Profit ($sd.N -ge 0)) + " EUR | PF " + $sd.PF + " | DD " + (Fmt2 $sd.DDLungo) + "% | peggior giornata " + $sd.PeggiorGiornata) -ForegroundColor Yellow
      if($sdFatale -ne ""){ throw $sdFatale }
    }

    # -----------------------------------------------------------------
    #  3h. LE FINESTRE DI QUESTA SEDIA
    #      COMUNE (la classifica) + 4 di REGIME + 1 DIAGNOSTICA.
    #      >>> QUI SI LEGGONO ANCHE PROFITTO E PF, non solo il DD: e' la
    #          differenza fra R100 (round di puro RISCHIO) e R102, dove
    #          la domanda e' "l'edge attraversa i regimi?".
    # -----------------------------------------------------------------
    $dInizioSedia = DataInv $sd.DaEff
    foreach($f in $FINESTRE){
      $nome = $f[0]; $fda = $f[1]; $fa = $f[2]; $off = $f[3]; $crit = $f[4]
      $sd.Fin[$nome] = @{ DD=-1.0; N=-1; Profit=0.0; PF=0.0; Misurata=$false;
                          Righe=-1; Gemelli="-"; Esito="NON ESEGUITA";
                          Criterio=$crit; Da=$fda; A=$fa }
      #  --- LA FINESTRA CHE IL SIMBOLO NON HA. Non e' un guasto: e' un
      #      dato, e va scritto cosi'. XAGUSD comincia il 2008.11.07:
      #      la diagnostica CRISI2008 (luglio-dicembre 2008) su di lui
      #      copre due mesi su sei, e farla girare zitti darebbe un
      #      numero che sembra confrontabile con quello degli altri.
      $dFda = DataInv $fda
      if($dInizioSedia -ne $null -and $dFda -ne $null -and $dInizioSedia -gt $dFda){
        $sd.Fin[$nome].Esito = "NON APPLICABILE (lo storico di " + $sd.Sym + " comincia il " + $sd.DaEff + ", dopo l'inizio della finestra)"
        Write-Host ("     " + $nome.PadRight(10) + " " + $sd.Fin[$nome].Esito) -ForegroundColor DarkGray
        if($crit){
          [void]$Problemi.Add($sd.Id + " " + $nome + ": " + $sd.Fin[$nome].Esito + ". E' una finestra di MISURA, non una diagnostica: questa sedia ha un buco nella riga di confronto e la sua classifica va letta sapendolo.")
        } else {
          [void]$Note.Add($sd.Id + " " + $nome + ": " + $sd.Fin[$nome].Esito + " (e' una DIAGNOSTICA, non un criterio).")
        }
        continue
      }
      $dest = Join-Path $Risultati ("R102_" + $sd.Id + "_" + $sd.Ea + "_" + $sd.Sym + "_" + $nome + $Suffisso + ".csv")
      $ini  = Join-Path $Work ($sd.Id + "_" + $nome + ".ini")
      & $iniOtt $fda $fa ($sd.Base + $off) $ini ("R102_" + $sd.Id + "_" + $nome)
      Copy-Item -LiteralPath $ini -Destination (Join-Path $Sosta ($sd.Id + "_" + $nome + ".ini")) -Force
      if($SoloControllo){ $sd.Fin[$nome].Esito = "SOLO CONTROLLO"; continue }
      if((Test-Path -LiteralPath $dest) -and -not $Rifai){
        #  >>> UN CSV VECCHIO NON E' UN CSV OK: SI GUARDA LA DATA. Se fra
        #      i due lanci fosse cambiato il pin, META' ROUND VERREBBE DA
        #      UN ALTRO MOTORE (checklist 15 e 53).
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
          $colsF = @($rows | Get-Member -MemberType NoteProperty | ForEach-Object { $_.Name })
          $mancaF = @()
          foreach($c in @("Profit","Profit Factor","Equity DD %","Trades")){ if($colsF -notcontains $c){ $mancaF += $c } }
          if($mancaF.Count -gt 0){
            $sd.Fin[$nome].Esito = "COLONNE ASSENTI (" + ($mancaF -join ", ") + ")"
            [void]$Problemi.Add($sd.Id + " " + $nome + ": nell'OptResults mancano le colonne [" + ($mancaF -join ", ") + "]. Questa finestra NON e' misurata.")
          } else {
            $ddw=@(); $trw=@(); $prw=@(); $pfw=@()
            foreach($r in $rows){
              $ddw += (NumInv $r.'Equity DD %'); $trw += (NumInv $r.'Trades')
              $prw += (NumInv $r.'Profit');      $pfw += (NumInv $r.'Profit Factor')
            }
            if(($ddw -contains $null) -or ($trw -contains $null) -or ($prw -contains $null)){
              $sd.Fin[$nome].Esito = "COLONNE NON LETTE"
              [void]$Problemi.Add($sd.Id + " " + $nome + ": le colonne ci sono ma i valori non sono numeri leggibili. Questa finestra NON e' misurata.")
            } else {
              $sd.Fin[$nome].DD     = [math]::Round([double]$ddw[0],2)
              $sd.Fin[$nome].N      = [int]$trw[0]
              $sd.Fin[$nome].Profit = [math]::Round([double]$prw[0],2)
              if($pfw[0] -ne $null){ $sd.Fin[$nome].PF = [math]::Round([double]$pfw[0],3) }
              if([math]::Round([double]$ddw[0],2) -ne [math]::Round([double]$ddw[1],2) -or
                 [int]$trw[0] -ne [int]$trw[1] -or
                 [math]::Round([double]$prw[0],2) -ne [math]::Round([double]$prw[1],2)){
                $sd.Fin[$nome].Gemelli = "DIVERGONO"
                $sd.Fin[$nome].Esito   = "GEMELLI DIVERGENTI"
                [void]$Problemi.Add($sd.Id + " " + $nome + ": le due gemelle divergono (DD, n o profitto). Banco sporco su questa finestra: i suoi numeri non si leggono.")
              } else {
                $sd.Fin[$nome].Gemelli  = "IDENTICI"
                $sd.Fin[$nome].Esito    = "OK"
                $sd.Fin[$nome].Misurata = $true
              }
            }
          }
        }
      }
      Write-Host ("     " + $nome.PadRight(10) + " prof " + (FmtEuro $sd.Fin[$nome].Profit $sd.Fin[$nome].Misurata).PadLeft(9) +
                  "  PF " + $sd.Fin[$nome].PF + "  DD " + (Fmt2 $sd.Fin[$nome].DD) + "%  n " + $sd.Fin[$nome].N +
                  "  [" + $mn.ToString("0.0",$INV) + " min]  " + $sd.Fin[$nome].Esito) -ForegroundColor Gray
    }

    # -----------------------------------------------------------------
    #  3i. L'INDICE DI ROBUSTEZZA -- ED E' UN'ETICHETTA, NON UN VERDETTO
    #      Quante delle CINQUE finestre di misura (COMUNE + le 4 di
    #      regime) chiudono in profitto. NON promuove e non boccia
    #      niente: dice soltanto se il guadagno viene da tutte le
    #      epoche o da una sola.
    #      >>> E porta sempre il DENOMINATORE VERO: una finestra NON
    #          APPLICABILE o non misurata non conta come negativa, si
    #          toglie dal denominatore e si dichiara. "2 su 5" e "2 su 3
    #          piu' 2 non misurate" sono due frasi diverse.
    # -----------------------------------------------------------------
    if(-not $SoloControllo){
      $misur = @($FINESTRE | Where-Object { $_[4] -and $sd.Fin[$_[0]] -ne $null -and $sd.Fin[$_[0]].Misurata })
      $pos   = @($misur | Where-Object { $sd.Fin[$_[0]].Profit -gt 0 })
      $tot   = @($FINESTRE | Where-Object { $_[4] }).Count
      if($misur.Count -eq 0){
        $sd.Robustezza = "NON MISURATA (nessuna delle " + $tot + " finestre di misura ha prodotto numeri leggibili)"
      } else {
        $sd.Robustezza = $pos.Count.ToString() + " finestre POSITIVE su " + $misur.Count + " misurate (su " + $tot + " previste)"
        if($misur.Count -lt $tot){ $sd.Robustezza = $sd.Robustezza + "  <<< " + ($tot - $misur.Count) + " NON misurate: il denominatore NON e' " + $tot }
      }
    }

    if($SoloControllo){ $sd.Esito = "SOLO CONTROLLO" }
    else {
      $ko = @($FINESTRE | Where-Object { $sd.Fin[$_[0]].Esito -ne "OK" -and $sd.Fin[$_[0]].Esito -notlike "NON APPLICABILE*" })
      if($ko.Count -eq 0 -and $sd.N -ge 0){ $sd.Esito = "OK" }
      else { $sd.Esito = "PARZIALE (" + $ko.Count + " finestre non OK)" }
    }

  }catch{
    $sd.Esito = "FERMATA -- " + $_.Exception.Message
    [void]$Problemi.Add($sd.Id + " " + $sd.Ea + " " + $sd.Sym + " FERMATA: " + $_.Exception.Message + "  >>> La sedia si dichiara NON MISURATA e la corsa PASSA ALLA SEGUENTE: una sedia storta non porta via le altre.")
    Write-Host ("  !! " + $sd.Id + " FERMATA: " + $_.Exception.Message) -ForegroundColor Red
  }
  $sd.Minuti = [math]::Round((New-TimeSpan -Start $tSedia -End (Get-Date)).TotalMinutes,1)

  # -------------------------------------------------------------------
  #  3j. IL VERDETTO DELLA CORSIA RISCHIO -- MECCANICO, ED E' L'UNICO
  #      Ereditato INVARIATO dalla firma del 18/08 (criterio di uscita
  #      C3, corsia RISCHIO) e da R99/R100. E' l'unica cosa che questo
  #      round DECIDE, e sta sulla corsia che l'Emendamento regola B
  #      assegna esplicitamente alla finestra VECCHIA.
  # -------------------------------------------------------------------
  if($SoloControllo){ $sd.Verdetto = "GIRO A VUOTO: nessun numero" }
  elseif($sd.DDLungo -lt 0){ $sd.Verdetto = "NON MISURABILE (DD lungo non misurato)" }
  elseif($sd.ContrDD -le 0){ $sd.Verdetto = "NON MISURABILE (2x senza denominatore: " + $sd.ContrStato + ")" }
  elseif($sd.DDLungo -gt (2.0 * $sd.ContrDD)){ $sd.Verdetto = "REVISIONE (DD " + (Fmt2 $sd.DDLungo) + "% > 2x " + $sd.ContrDD.ToString("0.00",$INV) + "% = " + (2*$sd.ContrDD).ToString("0.00",$INV) + "%)" }
  else { $sd.Verdetto = "OK (DD " + (Fmt2 $sd.DDLungo) + "% <= 2x " + $sd.ContrDD.ToString("0.00",$INV) + "% = " + (2*$sd.ContrDD).ToString("0.00",$INV) + "%)" }
  if($sd.Ranking -eq "NON MISURABILE" -and -not $SoloControllo -and $sd.N -gt 0){ $sd.Ranking = "IN CLASSIFICA" }
  Write-Host ("  => " + $sd.Id + " " + $sd.Esito + "   [" + $sd.Minuti.ToString("0.0",$INV) + " min]   ROBUSTEZZA: " + $sd.Robustezza) -ForegroundColor Yellow
  Write-Host ("     VERDETTO CORSIA RISCHIO: " + $sd.Verdetto) -ForegroundColor Yellow
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
$Cart = Join-Path $Dsk ("R102_CLASSIFICA_LUNGA_" + $Modo + "_" + $Stamp)
$Zip  = Join-Path $Dsk ("R102_CLASSIFICA_LUNGA_" + $Modo + "_" + $Stamp + ".zip")
$Referto = Join-Path $Cart "REFERTO_R102.txt"
try{
  New-Item -ItemType Directory -Force -Path $Cart | Out-Null
  foreach($f in @(Get-ChildItem -LiteralPath $Risultati -Filter "R102_*.csv" -File -ErrorAction SilentlyContinue)){
    Copy-Item -LiteralPath $f.FullName -Destination (Join-Path $Cart $f.Name) -Force
  }
  if(Test-Path -LiteralPath $Sosta){
    foreach($f in @(Get-ChildItem -LiteralPath $Sosta -File -ErrorAction SilentlyContinue)){
      Copy-Item -LiteralPath $f.FullName -Destination (Join-Path $Cart $f.Name) -Force
    }
  }

  $R = New-Object System.Collections.ArrayList
  [void]$R.Add("REFERTO R102 - LA CLASSIFICA LUNGA")
  [void]$R.Add($Lavoro.Count.ToString() + " sedie forex/argento, finestra MASSIMA per simbolo -> " + $Fino + ", modello OHLC M1, deposito " + $Deposito)
  $coda = ""
  if($SoloControllo){ $coda = "   <<< GIRO A VUOTO: NESSUNA passata, NESSUN numero di round qui dentro" }
  [void]$R.Add("modo: " + $Modo + $coda)
  $sw = @()
  if($SoloControllo){ $sw += "-SoloControllo (nessuna passata)" }
  if($SaltaPasso0)  { $sw += "-SaltaPasso0 (I GATE NON ESEGUITI: i criteri chiedono il contrario)" }
  if($SenzaStorico) { $sw += "-SenzaStorico (barre NON scaricate: il tester si arrangia, e puo' volerci molto di piu')" }
  if($Rifai)        { $sw += "-Rifai (rifatto anche cio' che era gia' presente)" }
  if($SoloSedia -ne ""){ $sw += ("-SoloSedia " + $SoloSedia + " (un BLOCCO di sedie: questo NON e' il round intero)") }
  if($PavimentoData -ne ""){ $sw += ("-PavimentoData " + $PavimentoData + " (LE FINESTRE PIU' VECCHIE SONO STATE TAGLIATE A QUESTA DATA)") }
  if($sw.Count -eq 0){ $sw += "nessuno (corsa piena su tutte le sedie, PASSO 0 eseguito, date della sonda senza pavimento)" }
  [void]$R.Add("switch di questo giro: " + ($sw -join " | "))
  [void]$R.Add("data: " + (Get-Date).ToString("yyyy-MM-dd HH:mm:ss",$INV) + "   (questa data deve essere di ADESSO)")
  [void]$R.Add("     ATTENZIONE: la data fresca NON distingue un giro a vuoto da una corsa.")
  [void]$R.Add("     Lo distinguono la riga 'modo:' qui sopra e il NOME della cartella.")
  [void]$R.Add("avvio: " + $Avvio.ToString("yyyy-MM-dd HH:mm:ss",$INV) + "   durata: " + ((New-TimeSpan -Start $Avvio -End (Get-Date)).TotalHours).ToString("0.0",$INV) + " ore")
  [void]$R.Add("pin: " + $Pin)
  [void]$R.Add("criteri: risultati_archivio\R102_CRITERI.md")
  [void]$R.Add("")
  [void]$R.Add("=====================================================================")
  [void]$R.Add(" COME SI LEGGE QUESTO REFERTO, E LA COSA DA CAPIRE PRIMA DEI NUMERI")
  [void]$R.Add("=====================================================================")
  [void]$R.Add("  EMENDAMENTO REGOLA B (16/08), ed e' il cuore del round:")
  [void]$R.Add("    'Il VECCHIO giudica il RISCHIO. Il RECENTE giudica il MERITO.'")
  [void]$R.Add("  Nato da un caso MISURATO: PTE USDJPY, IS 2010-2016 = ZERO celle")
  [void]$R.Add("  positive su 28, OOS recente = 25 su 28. Quella finestra bocciava")
  [void]$R.Add("  per un'epoca morta, non per un difetto del motore.")
  [void]$R.Add("  >>> QUINDI NESSUN NUMERO DI QUESTO REFERTO PROMUOVE O BOCCIA UNA")
  [void]$R.Add("      SEDIA PER MERITO. Un profitto grande su vent'anni NON e' un")
  [void]$R.Add("      permesso ad alzare il rischio, e un profitto piccolo NON e'")
  [void]$R.Add("      una bocciatura. Le due letture LEGITTIME sono:")
  [void]$R.Add("      [ROBUSTEZZA] l'edge esiste attraverso i regimi, o e' figlio")
  [void]$R.Add("                   del 2024-26? Lo dicono le finestre e la spina")
  [void]$R.Add("                   dorsale anno per anno.")
  [void]$R.Add("      [RISCHIO]    quanto avrebbe perso. Lo dicono il DD lungo, la")
  [void]$R.Add("                   peggior giornata e il 2x sul DD promesso.")
  [void]$R.Add("")
  [void]$R.Add("  E DUE LIMITI DEL BANCO, che valgono su OGNI riga:")
  [void]$R.Add("  1. MODELLO OHLC M1. I tick reali di BCM partono dal 2024.07.05:")
  [void]$R.Add("     su vent'anni NON ESISTONO. Il DD e la peggior giornata sono un")
  [void]$R.Add("     LIMITE INFERIORE del rischio (l'OHLC non vede i percorsi dentro")
  [void]$R.Add("     la barra).")
  [void]$R.Add("  2. IL PROFITTO E' UNA STIMA DEL LORDO, E GENEROSA: spread scritto")
  [void]$R.Add("     a 0 (= spread CORRENTE, non quello storico, che nel 1993 era")
  [void]$R.Add("     molte volte piu' largo), nessuno slippage, nessun requote,")
  [void]$R.Add("     riempimenti ideali. Su una strategia a molte operazioni la")
  [void]$R.Add("     differenza col vero e' GRANDE.")
  [void]$R.Add("     >>> UN NUMERO DI PROFITTO DI QUESTO ROUND NON E' UN GUADAGNO.")
  [void]$R.Add("")
  [void]$R.Add("=====================================================================")
  [void]$R.Add(" LA TABELLA MADRE - LA CLASSIFICA, ordinata sulla FINESTRA COMUNE")
  [void]$R.Add("=====================================================================")
  [void]$R.Add("  >>> ORDINATA SULLA COMUNE (2009.01.01 -> " + $Fino + ") E NON SULLA LUNGA,")
  [void]$R.Add("      ed e' la cosa piu' importante di tutta la tabella: le finestre")
  [void]$R.Add("      lunghe hanno lunghezze DIVERSE (GBPUSD 33 anni, XAGUSD 17,6).")
  [void]$R.Add("      Una classifica costruita sui profitti delle finestre lunghe")
  [void]$R.Add("      sarebbe una CLASSIFICA DELLA PROFONDITA' DELLO STORICO, non")
  [void]$R.Add("      delle sedie. La COMUNE e' l'unica finestra che tutti i dodici")
  [void]$R.Add("      simboli hanno, ed e' l'unica colonna in cui la parola")
  [void]$R.Add("      'classifica' vuol dire qualcosa.")
  [void]$R.Add("")
  #  --- l'ordinamento: prima le sedie IN CLASSIFICA per profitto COMUNE
  #      decrescente, poi tutte le altre. Una sedia senza numero non
  #      finisce in mezzo alla classifica con uno zero: sta sotto, con
  #      la sua ragione (checklist 47, il lato del rumore).
  $inCl = @($Lavoro | Where-Object { $_.Fin.ContainsKey("COMUNE") -and $_.Fin["COMUNE"] -ne $null -and $_.Fin["COMUNE"].Misurata -and $_.Ranking -eq "IN CLASSIFICA" })
  $fuori= @($Lavoro | Where-Object { -not ($_.Fin.ContainsKey("COMUNE") -and $_.Fin["COMUNE"] -ne $null -and $_.Fin["COMUNE"].Misurata -and $_.Ranking -eq "IN CLASSIFICA") })
  $inCl = @($inCl | Sort-Object -Property @{ Expression = { $_.Fin["COMUNE"].Profit } } -Descending)
  [void]$R.Add(("{0,-4} {1,-4} {2,-18} {3,-7} {4,-6} {5,10} {6,7} {7,8} {8,7} {9,11} {10,9} {11,7} {12,9}  {13}" -f `
      "POS","ID","EA","SIMB","RISCH","PROF-COM","PF-COM","DD-COM","n-COM","PROF-LUNGA","DD-LUNGA","n-LUNGA","PEGGGIOR","ROBUSTEZZA / NOTA"))
  [void]$R.Add(("-"*205))
  $pos = 0
  foreach($sd in $inCl){
    $pos++
    $fc = $sd.Fin["COMUNE"]
    $pgg = "n/d"; if($sd.PeggiorGiornata -ne "NON MISURATA"){ $pgg = ($sd.PeggiorGiornata -split "%")[0] + "%" }
    [void]$R.Add(("{0,-4} {1,-4} {2,-18} {3,-7} {4,-6} {5,10} {6,7} {7,8} {8,7} {9,11} {10,9} {11,7} {12,9}  {13}" -f `
        $pos,$sd.Id,$sd.Ea.Replace("ABTG_",""),$sd.Sym,($sd.Risk + "%"),
        (FmtEuro $fc.Profit $fc.Misurata),$fc.PF,(Fmt2 $fc.DD),$fc.N,
        (FmtEuro $sd.Profit ($sd.N -ge 0)),(Fmt2 $sd.DDLungo),$sd.N,$pgg,$sd.Robustezza))
  }
  if($fuori.Count -gt 0){
    [void]$R.Add("")
    [void]$R.Add("  --- FUORI CLASSIFICA (e il perche' e' scritto, sedia per sedia) ---")
    foreach($sd in $fuori){
      $motivo = $sd.Ranking
      if($sd.Esito -like "FERMATA*"){ $motivo = $sd.Esito }
      elseif($motivo -eq "NON MISURABILE"){ $motivo = "COMUNE non misurata (" + $sd.Fin["COMUNE"].Esito + ")" }
      [void]$R.Add(("{0,-4} {1,-4} {2,-18} {3,-7} {4,-6} {5,10} {6,7} {7,8} {8,7} {9,11} {10,9} {11,7} {12,9}  {13}" -f `
          "-",$sd.Id,$sd.Ea.Replace("ABTG_",""),$sd.Sym,($sd.Risk + "%"),
          "n/d","n/d","n/d","n/d",(FmtEuro $sd.Profit ($sd.N -ge 0)),(Fmt2 $sd.DDLungo),$sd.N,"n/d",$motivo))
    }
  }
  [void]$R.Add("")
  [void]$R.Add("  PROF-COM  = [ROBUSTEZZA] profitto in EUR sulla finestra COMUNE, alla TAGLIA VIVA")
  [void]$R.Add("              della sedia (colonna RISCH). ATTENZIONE: due sedie a taglie diverse")
  [void]$R.Add("              NON sono confrontabili in euro. Le PTE GBPUSD girano a 0,5%: per")
  [void]$R.Add("              metterle sulla stessa riga delle altre il loro numero va RADDOPPIATO")
  [void]$R.Add("              [APPROSSIMATO lineare, convenzione CONTRATTI_SEDIE punto 2].")
  [void]$R.Add("  PROF-LUNGA= [ROBUSTEZZA] lo stesso sulla finestra piu' lunga che quel SIMBOLO ha.")
  [void]$R.Add("              NON confrontabile fra sedie: le finestre hanno lunghezze diverse.")
  [void]$R.Add("  DD-*      = [RISCHIO] drawdown massimo dell'equity, LIMITE INFERIORE (OHLC).")
  [void]$R.Add("  PEGGGIOR  = [RISCHIO] la peggior giornata sulle CHIUSURE REALIZZATE")
  [void]$R.Add("              [APPROSSIMATO], da confrontare col muro prop giornaliero del 5%.")
  [void]$R.Add("  ROBUSTEZZA= quante delle 5 finestre di misura (COMUNE + 4 di regime) chiudono")
  [void]$R.Add("              in profitto, SUL DENOMINATORE VERO delle finestre misurate.")
  [void]$R.Add("              E' un'ETICHETTA DESCRITTIVA, non un verdetto: nessuna sedia viene")
  [void]$R.Add("              promossa o bocciata da questo numero.")
  [void]$R.Add("")
  [void]$R.Add("=====================================================================")
  [void]$R.Add(" SEDIA PER SEDIA - i numeri, i gate, la spina dorsale, il contratto")
  [void]$R.Add("=====================================================================")
  foreach($sd in $Lavoro){
    [void]$R.Add("")
    [void]$R.Add("---------------------------------------------------------------------")
    [void]$R.Add($sd.Id + "  " + $sd.Ea + "   " + $sd.Sym + " " + $sd.Tf)
    [void]$R.Add("     magic vivo " + $sd.MagicVivo + " | magic del sorgente " + $sd.MagicSrc + " | rischio VIVO " + $sd.Risk + "% | commento '" + $sd.Commento + "' | version attesa " + $sd.Ver)
    [void]$R.Add("     >>> il magic vivo NON e' il default del sorgente, ed e' NORMALE su tutte")
    [void]$R.Add("         le sedie di questo round: sono grafici di VIVAIO, cioe' N copie dello")
    [void]$R.Add("         stesso EA. Per questo NESSUNA di queste celle e' fatta di default: ogni")
    [void]$R.Add("         cella viene da un artefatto di DEPLOY, nominato nel file prova.")
    [void]$R.Add("     finestra LUNGA dichiarata: " + $sd.DaEff + " -> " + $Fino + "   (data della SONDA del 17/08" + $(if($PavimentoData -ne ""){ ", con pavimento " + $PavimentoData } else { "" }) + ")")
    [void]$R.Add("     magic della corsa: gemelle " + ($sd.Base+10) + "/" + ($sd.Base+11) + ", singola " + ($sd.Base+12) + " (blocco 79xxxx VERGINE)")
    [void]$R.Add("     esito: " + $sd.Esito + "   durata " + $sd.Minuti.ToString("0.0",$INV) + " min")
    [void]$R.Add("")
    [void]$R.Add("  [ROBUSTEZZA] I NUMERI DELLA FINESTRA LUNGA")
    if($sd.N -ge 0){
      [void]$R.Add("     profitto " + (FmtEuro $sd.Profit $true) + " EUR   PF " + $sd.PF + "   n " + $sd.N + " operazioni")
      [void]$R.Add("     DD massimo equity " + (Fmt2 $sd.DDLungo) + " %  [RISCHIO, limite inferiore]")
      if($sd.AnniMisurati -ge 0){
        [void]$R.Add("     anni EFFETTIVAMENTE coperti (dalla prima operazione): " + $sd.AnniMisurati.ToString("0.0",$INV))
      }
    } else { [void]$R.Add("     ->  NON MISURATI") }
    [void]$R.Add("")
    [void]$R.Add("  [ROBUSTEZZA] LE FINESTRE")
    [void]$R.Add(("     {0,-10} {1,-24} {2,11} {3,8} {4,8} {5,7}  {6}" -f "FINESTRA","PERIODO","PROFITTO","PF","DD %","n","ESITO"))
    foreach($f in $FINESTRE){
      $x = $sd.Fin[$f[0]]
      $tag = ""; if(-not $f[4]){ $tag = " (DIAGNOSTICA, non un criterio)" }
      if($x -eq $null){ [void]$R.Add(("     {0,-10} {1,-24} {2,11} {3,8} {4,8} {5,7}  {6}" -f $f[0],($f[1]+" - "+$f[2]),"n/d","n/d","n/d","-",("NON ESEGUITA" + $tag))); continue }
      [void]$R.Add(("     {0,-10} {1,-24} {2,11} {3,8} {4,8} {5,7}  {6}" -f `
          $f[0],($f[1]+" - "+$f[2]),(FmtEuro $x.Profit $x.Misurata),$x.PF,(Fmt2 $x.DD),$x.N,($x.Esito + $tag)))
    }
    [void]$R.Add("     ROBUSTEZZA: " + $sd.Robustezza)
    [void]$R.Add("     >>> ETICHETTA, NON VERDETTO. Se il profitto viene tutto da UNA finestra,")
    [void]$R.Add("         quello e' un fatto da sapere -- non e' una bocciatura, e nemmeno un")
    [void]$R.Add("         permesso. Emendamento regola B.")
    [void]$R.Add("")
    [void]$R.Add("  [ROBUSTEZZA] LA SPINA DORSALE ANNO PER ANNO")
    [void]$R.Add("     >>> E' la risposta letterale alla domanda di Claudio del 23/08:")
    [void]$R.Add("         'con 10 anni di storico avrebbe fatto lo stesso?'")
    [void]$R.Add("     [APPROSSIMATO]: netto delle CHIUSURE REALIZZATE (Profitto+Commissioni+")
    [void]$R.Add("     Swap), anno di calendario del deal. NON e' l'equity e NON e' il DD.")
    if(@($sd.PerAnno).Count -eq 0){
      [void]$R.Add("     ->  NON MISURATA (i deal del report non sono stati letti)")
    } else {
      [void]$R.Add(("     {0,-6} {1,7} {2,13} {3,15}" -f "ANNO","n","NETTO EUR","CUMULATO EUR"))
      $cum = 0.0
      foreach($a in @($sd.PerAnno)){
        $cum = $cum + [double]$a.Netto
        $mark = ""; if($a.N -eq 0){ $mark = "   <<< NESSUNA OPERAZIONE" }
        [void]$R.Add(("     {0,-6} {1,7} {2,13} {3,15}" -f $a.Anno,$a.N,([double]$a.Netto).ToString("+0;-0;0",$INV),$cum.ToString("+0;-0;0",$INV)) + $mark)
      }
      if(@($sd.AnniVuoti).Count -gt 0){
        [void]$R.Add("     >>> GATE 4 (DENSITA'): " + @($sd.AnniVuoti).Count + " anni su " + @($sd.PerAnno).Count + " NON hanno nessuna operazione.")
        [void]$R.Add("         La finestra NOMINALE e' " + @($sd.PerAnno).Count + " anni; quella EFFETTIVAMENTE OPERATA e' " + (@($sd.PerAnno).Count - @($sd.AnniVuoti).Count) + ".")
        [void]$R.Add("         Ogni volta che si dice 'N anni di storico' su questa sedia, il numero")
        [void]$R.Add("         da dire e' il SECONDO. Una serie che il broker dichiara dal 1971 ma")
        [void]$R.Add("         che nei primi quindici anni non produce nessuna operazione non e'")
        [void]$R.Add("         cinquantacinque anni di storico.")
      }
    }
    [void]$R.Add("")
    [void]$R.Add("  [RISCHIO] LA PEGGIOR GIORNATA   (il muro prop giornaliero e' 5%)")
    [void]$R.Add("     ->  " + $sd.PeggiorGiornata)
    [void]$R.Add("     [APPROSSIMATO]: chiusure REALIZZATE, non equity intraday; percentuale")
    [void]$R.Add("     sul saldo a inizio giornata; netto = Profitto+Commissioni+Swap.")
    [void]$R.Add("     [APPROSSIMATO n.2, dichiarato]: MT5 lascia la colonna Profitto VUOTA")
    [void]$R.Add("     sulle righe di APERTURA ('in'), quindi quelle righe non entrano nella")
    [void]$R.Add("     somma -- e con loro non entra la COMMISSIONE d'ingresso, se il simbolo")
    [void]$R.Add("     ne ha una. L'errore va nella direzione COMODA (giornata migliore del")
    [void]$R.Add("     vero) ed e' limitato alle commissioni d'apertura: se la colonna")
    [void]$R.Add("     Commissioni del report e' tutta 0,00 l'errore e' ZERO. Si controlla")
    [void]$R.Add("     nello zip, nel file " + $sd.Id + "_report_singola.htm.")
    if($sd.PeggiorGiornataEA -ne "n/d"){
      [void]$R.Add("     -> SECONDA MISURA INDIPENDENTE (dall'OPTFRAME dell'EA): " + $sd.PeggiorGiornataEA)
      [void]$R.Add("        Le due misure vengono da strumenti diversi: se divergono molto,")
      [void]$R.Add("        e' il metodo che va guardato, non la sedia.")
    } else {
      [void]$R.Add("     -> nessuna seconda misura: l'OPTFRAME di questo EA non ha la colonna")
      [void]$R.Add("        'Peggior Giornata %'. E' il caso di ABTG_SuperWave, ed e' dichiarato.")
    }
    [void]$R.Add("")
    [void]$R.Add("  I GATE")
    [void]$R.Add("    1 prima operazione .. " + $sd.PrimaDataUsata + "   (dichiarata dal " + $sd.DaEff + ")")
    [void]$R.Add("        misura 1, log del tester ... " + $sd.PrimaDataLog + "   (marcatore " + $sd.MarkLog + ", tipo " + $sd.TipoLog + ")")
    [void]$R.Add("        misura 2, report .htm ...... " + $sd.PrimaDataReport)
    [void]$R.Add("        fonte usata ................ " + $sd.FonteData)
    [void]$R.Add("        >>> FINESTRA: " + $sd.Finestra)
    [void]$R.Add("        >>> CLASSIFICA: " + $sd.Ranking)
    [void]$R.Add("    2 n totale .......... " + $sd.N + "   (controllo incrociato dal report: " + $sd.NReport + ")")
    [void]$R.Add("    3 gemelli ........... " + $sd.Gemelli)
    [void]$R.Add("    4 densita' .......... " + $(if(@($sd.PerAnno).Count -eq 0){ "NON MISURATA" } else { (@($sd.PerAnno).Count - @($sd.AnniVuoti).Count).ToString() + " anni operati su " + @($sd.PerAnno).Count + " nominali" }))
    [void]$R.Add("")
    [void]$R.Add("  [RISCHIO] IL CONTRATTO DI QUESTA SEDIA, letto ADESSO dall'artefatto")
    [void]$R.Add("    fonte: report/CONTRATTI_SEDIE.md al pin " + $Pin)
    [void]$R.Add("    stato: " + $sd.ContrStato)
    [void]$R.Add("    riga VERBATIM: " + $sd.ContrRiga)
    if($sd.ContrDD -gt 0){
      [void]$R.Add("    DD promesso " + $sd.ContrDD.ToString("0.00",$INV) + " %   -> soglia 2x = " + (2*$sd.ContrDD).ToString("0.00",$INV) + " %")
    } else {
      [void]$R.Add("    >>> 2x NON CALCOLABILE: il contratto di questa sedia non da' un DD")
      [void]$R.Add("        promesso numerico e confrontabile ALLA TAGLIA VIVA. IL CRITERIO NON E'")
      [void]$R.Add("        STATO TOCCATO: si dichiara che il DENOMINATORE non esiste. E NON E' UN")
      [void]$R.Add("        VIA LIBERA. I numeri qui sopra sono CANDIDATI a riempire quel")
      [void]$R.Add("        contratto: riempirlo e' UNA FIRMA NUOVA di Claudio, non un esito")
      [void]$R.Add("        automatico di questo round.")
    }
    [void]$R.Add("    VERDETTO CORSIA RISCHIO: " + $sd.Verdetto)
  }
  [void]$R.Add("")
  [void]$R.Add("=====================================================================")
  [void]$R.Add(" LE SEDIE DICHIARATE E NON MISURABILI - e non e' un via libera")
  [void]$R.Add("=====================================================================")
  [void]$R.Add("  BREAKOUT_EA_JPY_v3   USDJPY   magic n/d   rischio n/d")
  [void]$R.Add("  >>> NON MISURABILE, e il motivo e' MISURATO: il sorgente NON ESISTE nel")
  [void]$R.Add("      repo (zero file 'BREAKOUT_EA_JPY_v3.mq5'; esistono BREAKOUT_EA_JPY.mq5")
  [void]$R.Add("      e BREAKOUT_EA_JPY_Multi.mq5, che sono ALTRI EA). Senza sorgente non")
  [void]$R.Add("      c'e' niente da compilare e niente da misurare.")
  [void]$R.Add("  >>> Nel censimento .chr del 23/08 15:49 la riga c'e' ancora, e NON ha")
  [void]$R.Add("      nemmeno un input di rischio leggibile. E' una delle DUE SEDIE SENZA")
  [void]$R.Add("      CONTRATTO del 18/08 (CONTRATTI_SEDIE.md), famiglia SCARTATA")
  [void]$R.Add("      pre-progetto (paniere 7 cross JPY 2022-24: -20.853 EUR, PF 0,67-0,95")
  [void]$R.Add("      su TUTTE, DD 30-48%).")
  [void]$R.Add("  >>> QUESTO E' IL RILIEVO, ed e' lo stesso del 18/08: una sedia viva senza")
  [void]$R.Add("      contratto, senza sorgente e senza rischio leggibile non ha NESSUN")
  [void]$R.Add("      metro, e la corsia RISCHIO della C3 su di lei NON PUO' SCATTARE.")
  [void]$R.Add("")
  [void]$R.Add("=====================================================================")
  [void]$R.Add(" IL PERIMETRO - CHI NON C'E' IN QUESTO ROUND, E PERCHE'")
  [void]$R.Add("=====================================================================")
  [void]$R.Add("  GLI INDICI (D30EUR, U30USD, NASUSD, SPXUSD, 225JPY, F40EUR, E35EUR,")
  [void]$R.Add("  E50EUR, 100GBP, 200AUD) e L'ENERGIA (UKOIL, USOIL): ESCLUSI.")
  [void]$R.Add("  Motivo MISURATO, non scelto: la sonda del 17/08 li da' tutti con prima")
  [void]$R.Add("  data 2024.09.26 e verdetto COMPLETO. 'COMPLETO' e' la parola che chiude")
  [void]$R.Add("  la questione: non manca sul disco, IL BROKER NON CE L'HA. Ventuno mesi")
  [void]$R.Add("  di storico non sono una finestra lunga, e nessuna riga puo' inventarli.")
  [void]$R.Add("  Per loro la strada e' l'import Dukascopy (macchina gia' collaudata in")
  [void]$R.Add("  R56), ed e' un round diverso.")
  [void]$R.Add("")
  [void]$R.Add("  L'ORO (XAUUSD): ESCLUSO perche' e' GIA' FATTO. R99 (SupertrendReversal")
  [void]$R.Add("  Ottimizzato 970901: DD 9,02% su 22 anni, peggior giornata -0,68%, n=657)")
  [void]$R.Add("  e R100 (le altre dodici sedie oro, stessa macchina, 2004.06.11 ->")
  [void]$R.Add("  2026.06.30). Si CITANO, non si rifanno.")
  [void]$R.Add("")
  [void]$R.Add("  E LE SEDIE SU INDICI DELLE STESSE FAMIGLIE di questo round (PTE DOW,")
  [void]$R.Add("  SuperWave DOW, GapFill DOW e NIKKEI, PunteLarry DOW): fuori per lo")
  [void]$R.Add("  stesso motivo degli indici. Vuol dire che di famiglie come GapFill e")
  [void]$R.Add("  PunteLarry R102 misura solo la META' forex.")
  [void]$R.Add("")
  [void]$R.Add("=====================================================================")
  [void]$R.Add(" COSA QUESTO ROUND **NON** PUO' DIRE")
  [void]$R.Add("=====================================================================")
  [void]$R.Add("  1. NESSUNA PROMOZIONE E NESSUNA BOCCIATURA DI MERITO. Emendamento")
  [void]$R.Add("     regola B. L'unica decisione e' il 2x sulla corsia RISCHIO.")
  [void]$R.Add("  2. NESSUN DRAWDOWN DI PORTAFOGLIO. Venti sedie non fanno un drawdown")
  [void]$R.Add("     pari alla somma dei loro ne' pari al massimo: dipende da QUANTO SI")
  [void]$R.Add("     SOVRAPPONGONO nel tempo, e questo round le misura UNA PER UNA.")
  [void]$R.Add("     Sette di queste sedie stanno sullo STESSO simbolo (GBPUSD): la")
  [void]$R.Add("     domanda del portafoglio, li', e' la domanda successiva ovvia, ed e'")
  [void]$R.Add("     un round diverso (macchina R16/R34/R37/R41).")
  [void]$R.Add("  3. NESSUN NUMERO A TICK REALI, nessuna misura di spread, nessuno")
  [void]$R.Add("     slippage. Vedi i due limiti del banco in testa.")
  [void]$R.Add("  4. NIENTE SULLA CELLA MIGLIORE. Ogni sedia gira su UNA cella sola,")
  [void]$R.Add("     quella VIVA. Questo round non ottimizza, non cerca e non propone")
  [void]$R.Add("     parametri: se una sedia esce male, la risposta NON e' 'proviamo")
  [void]$R.Add("     un'altra cella sulla finestra lunga' -- quello sarebbe pescare.")
  [void]$R.Add("")
  [void]$R.Add("--- PASSO 0-A (le barre, un simbolo alla volta) ---")
  foreach($st in $Storico){
    [void]$R.Add("  " + $st.Sym + " dal " + $st.Da + ": " + $st.Esito)
    foreach($rr in @($st.Righe)){ [void]$R.Add("      " + $rr) }
  }
  [void]$R.Add("  NIENTE TICK: il round e' OHLC M1 per criterio. Le barre M1 servono davvero:")
  [void]$R.Add("  il tester costruisce H1/H2/H4/D1 dalle M1, quindi la profondita' che MORDE")
  [void]$R.Add("  e' quella dell'M1.")
  [void]$R.Add("")
  [void]$R.Add("--- SE QUESTO ROUND E' PARZIALE: COME SI RIPRENDE (e quanto costa) ---")
  [void]$R.Add("  Un rilancio LISCIO della stessa riga NON salta le sedie gia' fatte:")
  [void]$R.Add("  salta solo le FINESTRE che hanno gia' il CSV (e lo dichiara con la data")
  [void]$R.Add("  del file, una riga di PROBLEMA per ognuna). Il PASSO 0 -- passata")
  [void]$R.Add("  SINGOLA + due GEMELLE, tutte e tre sulla finestra lunga -- si RIFA' per")
  [void]$R.Add("  OGNI sedia della lista. Misurato in durata simulata: PASSO 0 = ~72")
  [void]$R.Add("  anni-sedia, le finestre = ~42. Cioe' il rilancio liscio rifa' circa il")
  [void]$R.Add("  63% del lavoro.")
  [void]$R.Add("  >>> LA RIPRESA CHE COSTA POCO: -SoloSedia con l'ELENCO delle sedie che")
  [void]$R.Add("      qui sopra NON sono 'OK' (es. -SoloSedia C07,C11,C13). -Rifai rifa'")
  [void]$R.Add("      tutto, finestre comprese. Ogni giro scrive uno zip suo: vanno")
  [void]$R.Add("      mandati TUTTI, non solo l'ultimo.")
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
    $ko2 = @($Lavoro | Where-Object { $_.Esito -ne "OK" })
    if($ko2.Count -gt 0 -or $Problemi.Count -gt 0){
      [void]$R.Add("ESITO: PARZIALE -- " + $ko2.Count + " sedie su " + $Lavoro.Count + " non sono OK, e " + $Problemi.Count + " problemi in elenco. NON e' un round completo.")
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
  Write-Host  "  LA CLASSIFICA (finestra COMUNE 2009 -> 2026, taglia VIVA di ogni sedia):" -ForegroundColor White
  $inCl2 = @($Lavoro | Where-Object { $_.Fin.ContainsKey("COMUNE") -and $_.Fin["COMUNE"] -ne $null -and $_.Fin["COMUNE"].Misurata -and $_.Ranking -eq "IN CLASSIFICA" })
  $inCl2 = @($inCl2 | Sort-Object -Property @{ Expression = { $_.Fin["COMUNE"].Profit } } -Descending)
  Write-Host  ("   " + ("{0,-4} {1,-4} {2,-18} {3,-7} {4,-6} {5,10} {6,7} {7,8} {8,11}  {9}" -f "POS","ID","EA","SIMB","RISCH","PROF-COM","PF","DD-COM","PROF-LUNGA","ROBUSTEZZA")) -ForegroundColor White
  $p2 = 0
  foreach($sd in $inCl2){
    $p2++
    $fc = $sd.Fin["COMUNE"]
    $c = "White"; if($fc.Profit -le 0){ $c = "Red" } elseif($sd.Esito -ne "OK"){ $c = "Yellow" }
    Write-Host ("   " + ("{0,-4} {1,-4} {2,-18} {3,-7} {4,-6} {5,10} {6,7} {7,8} {8,11}  {9}" -f `
       $p2,$sd.Id,$sd.Ea.Replace("ABTG_",""),$sd.Sym,($sd.Risk+"%"),
       (FmtEuro $fc.Profit $true),$fc.PF,(Fmt2 $fc.DD),(FmtEuro $sd.Profit ($sd.N -ge 0)),$sd.Robustezza)) -ForegroundColor $c
  }
  $fu2 = @($Lavoro | Where-Object { -not ($_.Fin.ContainsKey("COMUNE") -and $_.Fin["COMUNE"] -ne $null -and $_.Fin["COMUNE"].Misurata -and $_.Ranking -eq "IN CLASSIFICA") })
  if($fu2.Count -gt 0){
    Write-Host ("   FUORI CLASSIFICA: " + (($fu2 | ForEach-Object { $_.Id }) -join ", ") + "  (il perche' e' nel referto, sedia per sedia)") -ForegroundColor Yellow
  }
  Write-Host ""
  Write-Host  "  >>> QUESTA CLASSIFICA E' DI ROBUSTEZZA, NON DI MERITO (Emendamento regola B)." -ForegroundColor Yellow
  Write-Host  "      Il profitto e' una STIMA DEL LORDO su modello OHLC con spread corrente:" -ForegroundColor Yellow
  Write-Host  "      NON e' un guadagno, e nessuna sedia viene promossa o bocciata qui." -ForegroundColor Yellow
  Write-Host  "  >>> E R102 NON dice il DD di PORTAFOGLIO: misura le sedie una per una." -ForegroundColor Yellow
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
$ko3 = @($Lavoro | Where-Object { $_.Esito -ne "OK" -and $_.Esito -ne "SOLO CONTROLLO" })
if($SoloControllo){
  if($ko3.Count -gt 0 -or $Problemi.Count -gt 0){
    Write-Host ("ESITO: GIRO A VUOTO CON PROBLEMI (" + $Problemi.Count + ") -- NESSUNA passata, e c'e' da leggere il referto") -ForegroundColor Yellow; exit 1
  }
  Write-Host "ESITO: GIRO A VUOTO COMPLETATO -- NESSUNA passata, NESSUN numero. QUESTO ZIP NON E' IL ROUND." -ForegroundColor Green
  exit 0
}
if($ko3.Count -gt 0 -or $Problemi.Count -gt 0){
  Write-Host ("ESITO: PARZIALE (" + $ko3.Count + " sedie non OK, " + $Problemi.Count + " problemi)") -ForegroundColor Yellow; exit 1
}
Write-Host "ESITO: OK" -ForegroundColor Green
#  >>> L'exit 0 NON e' decorativo (rilievo del verificatore su R100).
#      Senza, uno script che finisce bene non tocca $LASTEXITCODE, che
#      resta quello dell'ULTIMO comando NATIVO eseguito: qui
#      `& $MetaEditor /compile` dell'ultimo EA, il cui rc questo driver
#      NON usa come esito (il verdetto e' il LastWriteTime del .ex5) e
#      che puo' benissimo essere != 0 a compilazione riuscita. La coda
#      della riga in chat avrebbe stampato "ESITO: PARZIALE O FERMO" su
#      un round andato bene: un rosso falso su una corsa da ore e' il
#      modo piu' rapido per far rilanciare tutto a vuoto.
exit 0
