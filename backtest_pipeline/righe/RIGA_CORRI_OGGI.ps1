# =====================================================================
#  MARCATORE_RIGA_CORRI_OGGI_v1
#  RIGA_CORRI_OGGI.ps1 -- 21 round GIA' SCRITTI e MAI GIRATI, in fila,
#                         su un sabato a mercati chiusi.
#
#  BERSAGLIO, DICHIARATO QUI E NON IN FONDO:
#    finestra PowerShell sul VPS (VMI3047753).
#    Pilota SOLO il terminale di BACKTEST 50504400 (C:\MT5_Backtest),
#    e nemmeno direttamente: lo fa per procura, attraverso
#    RIGA_SOTTILE_ROUND.ps1, che porta quel percorso SCRITTO IN CODICE
#    e non accetta nessun argomento per spostarlo.
#    NON tocca, e non ha modo di toccare:
#       50503392  BCM Markets MT5 Terminal        (il piccolo, sedie vive)
#       50504263  BCM Markets MT5 Terminal -V3    (il 100k, sedie vive)
#       10105439  C:\BCM_Reale                    (il REALE)
#       la cartella dati Pepperstone
#       la cartella dati Tickmill
#    Sul VPS convivono SEI cartelle dati: "gira sul VPS" da solo non e'
#    un bersaglio, e' un indirizzo. Il bersaglio e' il quarto terminale.
#
#  NON E' UNA RIGA DA CODA. Non va in backtest_pipeline\coda\CODA.txt:
#  la coda di stanotte ha i suoi tre round e resta com'e'. Questa si
#  incolla A MANO in una finestra PowerShell, di giorno, guardandola.
# =====================================================================
#  >>> QUELLO CHE QUESTO FILE FA DI PERICOLOSO, DETTO PER PRIMO <<<
#
#  Come RIGA_SOTTILE_ROUND.ps1, questo script FA PASSARE DEL CODICE CHE
#  IL CANCELLO NON HA LETTO: scarica un altro .ps1 e lo esegue, e quello
#  a sua volta ne scarica altri due. La catena e' ristretta cosi':
#
#   1. IL PIN E' FISSO E SCRITTO QUI DENTRO, non e' un argomento.
#   2. IL FILE SCARICATO E' INCHIODATO AL BYTE (SHA-256) e al MARCATORE.
#      L'impronta qui sotto e' stata calcolata sul BLOB GIT del commit
#      pinnato, e il METODO e' stato validato contro due valori che
#      qualcun altro aveva gia' inchiodato a mano l'11/09/2026
#      ($SHA_ROUND 348ED533... e $SHA_WALK 02E2FE8F... dentro
#      RIGA_SOTTILE_ROUND.ps1): ricalcolati con questo stesso metodo,
#      tornano identici. Non e' un'impronta "che mi torna": e' un
#      metodo provato contro numeri scritti da altri.
#   3. NESSUN ARGOMENTO DI QUESTO SCRIPT PUO' NOMINARE UN PERCORSO.
#      La tabella dei round e' SCRITTA QUI, letterale. Gli unici
#      argomenti sono tre interruttori e una etichetta di ripartenza,
#      e quest'ultima passa da una lista bianca.
#
#  >>> E QUELLO CHE RESTA SCOPERTO, e va letto insieme al resto:
#      IL DRIVER COMPILA L'EA DALLA TESTA DEL BRANCH 'lavoro', NON DAL
#      PIN ($EABranch="lavoro" e' cablato in walkforward_generico.ps1).
#      Per questo i round di questa tabella sono stati SCELTI guardando
#      a che commit sta il loro .mq5: nessuno dei SEI EA qui sotto sta
#      su un commit "IN CORSO D'OPERA -- NON COMPILARE". I dodici file
#      prova che ci stavano sono stati TOLTI, e il motivo e' scritto nel
#      blocco ESCLUSI qui sotto.
#      >>> Se fra la scrittura di questo file e la corsa qualcuno
#          committa su uno di quei SEI EA, questa garanzia scade.
#          Il controllo si rifa' in un secondo, per ogni EA:
#             git log -1 -- mql5/Experts/<NOME>.mq5
# =====================================================================
#  COSA FA, IN ORDINE
#    1. lista bianca sugli argomenti;
#    2. pre-volo: il banco C:\MT5_Backtest deve esistere su questa
#       macchina, altrimenti muore ADESSO;
#    3. scarica RIGA_SOTTILE_ROUND.ps1 dal pin fisso e ne verifica
#       IMPRONTA, MARCATORE e dimensione;
#    4. gira i 21 round IN SEQUENZA, uno per volta, mai in parallelo
#       (due tester sulla stessa macchina si rubano i core e i tempi
#       misurati non valgono piu' niente);
#    5. raccoglie tutto in una cartella sul Desktop, fa lo zip e
#       STAMPA L'ELENCO DEI FILE ATTESI con presente/assente accanto;
#    6. esce 0 solo se TUTTI i round sono usciti 0 o 3.
#
#  COSA NON FA, E NON E' UNA DIMENTICANZA
#    - non chiude nessun processo (l'interruttore -ChiudiBacktest di
#      RIGA_ROUND_VPS.ps1 qui NON e' raggiungibile);
#    - non tocca nessun EA, preset, parametro o sedia in forward;
#    - non scrive in backtest_pipeline\coda\;
#    - non promuove niente e non giudica niente: produce CSV.
#
#  CODICI D'USCITA DEI SINGOLI ROUND (sono di RIGA_ROUND_VPS.ps1):
#     0 = ROUND GIRATO        2 = NON MISURATO (CSV assenti o Trades=0)
#     3 = GIRATO CON RILIEVI  1 = non e' nemmeno partito
#
#  NIENTE EMOJI, NIENTE ACCENTI: sul VPS gira Windows PowerShell 5.1 che
#  legge i .ps1 come ANSI. Questo file e' ASCII puro.
# =====================================================================
#  IL COSTO, STIMATO CON UN METRO MISURATO IN CASA
#
#  Il metro NON e' "22 secondi per passata". Quel numero viene da R112
#  (16 passate in 0,1 ore) ed e' GONFIO, perche' R112 girava OTTO gambe
#  separate per sole 16 passate: quasi tutto quel tempo e' avviamento
#  del tester, non celle.
#  Il metro buono sta in risultati_archivio\r88_csv\REFERTO_R88.txt
#  r.10-14, che riporta il tempo ROUND PER ROUND sullo STESSO EA
#  (ABTG_ORB_Ottimizzato), stesso simbolo, stesso TF, stessa finestra,
#  tick reali:
#        4 celle ( 8 passate) -> 1,1 / 1,2 / 1,3 min
#        8 celle (16 passate) -> 2,1 min
#       48 celle (96 passate) -> 8,0 min
#  Retta fra (8; 1,2) e (96; 8,0):
#        T(min) = 0,6 + 0,077 x passate      per ROUND
#  Controprova su un terzo punto dello stesso EA: 16 passate -> 1,8 min
#  previsti contro 2,1 misurati (-15%). Su EA diversi la dispersione
#  misurata e' piu' larga (R89b: 18 passate in 4,1 min), quindi la
#  BANDA DICHIARATA E' DA META' A DUE VOLTE la stima.
#
#  Su questa tabella: 21 round, 77 celle, 154 passate
#        21 x 0,6  +  154 x 0,077  =  12,6 + 11,9  =  ~25 MINUTI
#        banda dichiarata: da ~13 min a ~50 min
#
#  >>> E UNA VOCE CHE IL METRO NON CONTIENE, DICHIARATA: [NON MISURATO]
#      lo SCARICO DEI TICK. Se sul banco i tick di un simbolo non sono
#      in cache, MT5 li scarica prima di partire, e quel tempo non sta
#      in nessun referto di casa. Tre dei quattro simboli di questa
#      tabella (NASUSD, U30USD, D30EUR) sono gli stessi della coda di
#      stanotte, quindi ci sono buone probabilita' che siano caldi -- ma
#      "buone probabilita'" non e' una misura.
#      XAUUSD dal 2020.01.01 e' il caso che NON e' mai stato scaldato da
#      nessuna corsa recente: per questo i quattro round r120c stanno
#      ULTIMI in tabella. Se il tempo totale sfonda, sfonda in coda e
#      non a meta'.
# =====================================================================

param(
  [switch]$SoloControllo,
  [string]$Da = "",
  [switch]$NonFermarti
)

$ErrorActionPreference = "Stop"
[Net.ServicePointManager]::SecurityProtocol = [Net.SecurityProtocolType]::Tls12

$MARC_MIO = "MARCATORE_RIGA_CORRI_OGGI_v1"

function Muori($m){
  Write-Host ""
  Write-Host ("ERRORE: " + $m) -ForegroundColor Red
  Write-Host "Non eseguo niente." -ForegroundColor Red
  exit 1
}

# ---------------------------------------------------------------------
#  IL BANCO, SCRITTO IN CODICE E NON IN UN COMMENTO.
#  Stessa ragione di RIGA_SOTTILE_ROUND.ps1: il cancello positivo del
#  runner segue una variabile solo sulle righe che nominano un
#  terminale. Un bersaglio scritto in un commento non ha dimostrato
#  niente, perche' un commento non esegue.
#  Conto del banco: 50504400, il demo solo-tester, zero EA attaccati.
# ---------------------------------------------------------------------
$BancoBT = 'C:\MT5_Backtest'

# ---------------------------------------------------------------------
#  IL PIN. FISSO. E NON E' UN PIN QUALUNQUE: E' QUELLO GIUSTO DEI DUE.
#
#  RIGA_SOTTILE_ROUND.ps1 porta DENTRO DI SE' un secondo pin ($PIN), che
#  e' quello da cui il driver prende i FILE PROVA. I due pin non sono lo
#  stesso numero, e sbagliarli e' un 404 che manda a cercare il guasto
#  nella rete:
#    - al commit 0c7d98af il file porta dentro $PIN = fb9b4731  <== questo
#    - al commit fb9b4731 il file porta dentro $PIN = 63e10ba9
#  Verificato aprendo i due blob, non ricordato.
#  E a fb9b4731 ci sono TUTTI E VENTUNO i file prova di questa tabella:
#  verificato uno per uno con 'git cat-file -e'.
# ---------------------------------------------------------------------
$PIN = '0c7d98af7cb1b3e77aed764c1ab86e49026a3244'

#  Impronta del blob di RIGA_SOTTILE_ROUND.ps1 A QUEL PIN.
$SHA_SOTTILE  = '105D35C41187ABAEF560B7F841A168BF3C80D6D1187E4F5D9F84E9BE175BE28B'
$MARC_SOTTILE = "MARCATORE_RIGA_SOTTILE_ROUND_v1"

$RawBase = "https://raw.githubusercontent.com/claudiospadaro12/GITHUB/" + $PIN
$Avvio   = Get-Date

# =====================================================================
#  LA TABELLA DEI ROUND -- 21 file prova, 77 celle, 154 passate.
#
#  Ordine: valore/costo, col criterio della bussola (quanto avvicina una
#  sedia schierabile il 1 ottobre), e con due vincoli di LETTURA che
#  vengono prima del costo:
#    - dentro r120a e r120d e r120c la cella VIVA (11) va PRIMA delle
#      altre tre: e' l'ancora, e se non riproduce non si leggono le
#      altre;
#    - i quattro r120c (XAUUSD dal 2020) stanno ULTIMI, perche' sono i
#      soli con lo scarico dei tick [NON MISURATO].
#
#  Le colonne: etichetta | EA | file prova | modello | deposito | celle
#  Ogni valore di modello e deposito e' LETTO nell'intestazione del suo
#  file prova, non scelto qui -- con UNA eccezione dichiarata (r127a,
#  vedi la nota "MODELLO" qui sotto).
# =====================================================================
$Round = @(
  # --- BLOCCO A: la manopola d'uscita MAI MOSSA in TUTTO l'archivio,
  #     su una sedia viva. Censimento uscite dell'11/09, par. 3-bis:
  #     InpSLBufferPips vale 3 in 280 CSV e in ZERO file ha due valori.
  #     Chiude la casella 3 del certificato di morte sulla 970913.
  #     MODELLO -- ECCEZIONE DICHIARATA: il file prova scrive
  #     "-Modello 1" e lo commenta "= TICK REALI". QUEL COMMENTO E'
  #     FALSO, ed e' il driver a dirlo (walkforward_generico.ps1 r.172:
  #     "4 = tick reali (verita'). 1 = OHLC M1: SOLO screening, mai
  #     verdetti"). Qui si passa 4, e non per gusto: l'ANCORA di quel
  #     round e' PF 1,68815 / DD 0,8567% / 86 deal, che sta nel CSV
  #     TICK ABTG_SupRev_NAS_H1_Ottimizzato_NASUSD_OOS.csv. Lo stesso
  #     punto nel CSV OHLC fa PF 1,85106: misurati tutti e due oggi.
  #     Con -Modello 1 la sentinella dell'ancora fallirebbe per il
  #     motivo sbagliato.
  @{ et='r127a';   ea='ABTG_SupRev_NAS_H1_Ottimizzato';            pv='R127a_slbuffer_NASUSD.txt';         mo=4; de=10000;  ce=9 },

  # --- BLOCCO B: le uscite Supertrend sulla STESSA sedia viva.
  #     InpTrailOnST e InpExitOnFlip hanno ZERO occorrenze come asse in
  #     tutto il repo (AUDIT_USCITE del 09/09). Quattro file = le
  #     quattro combinazioni. La 11 e' la cella viva: e' l'ancora.
  @{ et='r120a11'; ea='ABTG_SupRev_NAS_H1_Ottimizzato';            pv='R120a_NASUSD_11_vivo.txt';          mo=4; de=10000;  ce=2 },
  @{ et='r120a01'; ea='ABTG_SupRev_NAS_H1_Ottimizzato';            pv='R120a_NASUSD_01_notrail.txt';       mo=4; de=10000;  ce=2 },
  @{ et='r120a10'; ea='ABTG_SupRev_NAS_H1_Ottimizzato';            pv='R120a_NASUSD_10_noflip.txt';        mo=4; de=10000;  ce=2 },
  @{ et='r120a00'; ea='ABTG_SupRev_NAS_H1_Ottimizzato';            pv='R120a_NASUSD_00_nuda.txt';          mo=4; de=10000;  ce=2 },

  # --- BLOCCO C: la meta' di asse mai percorsa sulla sedia che gira
  #     anche sul conto REALE 10105439 (magic 770101). E' l'UNICO dei
  #     cinque file di R128 che chiede FrazioneIS 0.40, cioe' il default
  #     del driver: gli altri quattro chiedono 0.50 e da questa strada
  #     NON SONO RAGGIUNGIBILI (vedi ESCLUSI).
  #     CELLE: 7, non 26. InpTrailTF e' ENUM_TIMEFRAMES e il driver
  #     spazzola i MEMBRI (M5 M6 M10 M12 M15 M20 M30). Il 26 e' il
  #     conteggio aritmetico e lo stampa controlla_prova.py, che l'enum
  #     non lo conosce. SE IL GIRO A VUOTO STAMPA 26, CI SI FERMA.
  @{ et='r128a';   ea='ABTG_DAX_Apertura_EU';                      pv='R128a_trailingTF_D30EUR.txt';       mo=4; de=10000;  ce=7 },

  # --- BLOCCO D: R125, la frontiera del costo dell'ORB su tre simboli.
  #     CRITERI FIRMATI DA CLAUDIO il 10/09/2026 (par. in testa a
  #     R125_ORB_COSTO_CRITERI.md: "firma i criteri R125", 6 file, 33
  #     celle, 66 passate). L'unico blocco di questa tabella che ha
  #     gia' una firma sopra.
  #     DEPOSITO 100000 su tutti e sei: e' dichiarato nei file.
  @{ et='r125a';   ea='ABTG_ORB_Ottimizzato';                      pv='R125a_costo_buffer_U30USD.txt';     mo=4; de=100000; ce=7 },
  @{ et='r125b';   ea='ABTG_ORB_Ottimizzato';                      pv='R125b_parziale_U30USD.txt';         mo=4; de=100000; ce=5 },
  @{ et='r125c';   ea='ABTG_ORB_Ottimizzato';                      pv='R125c_costo_buffer_D30EUR.txt';     mo=4; de=100000; ce=7 },
  @{ et='r125d';   ea='ABTG_ORB_Ottimizzato';                      pv='R125d_lato_short_D30EUR.txt';       mo=4; de=100000; ce=2 },
  @{ et='r125e';   ea='ABTG_ORB_Ottimizzato';                      pv='R125e_ampiezzaminima_D30EUR.txt';   mo=4; de=100000; ce=5 },
  @{ et='r125f';   ea='ABTG_ORB_Ottimizzato';                      pv='R125f_finestra15_NASUSD.txt';       mo=4; de=100000; ce=7 },

  # --- BLOCCO E: InpFirstFraction sul SupRev Dow H1, il motore che
  #     R120 e R121 NON coprono. Terza manopola a ZERO occorrenze come
  #     asse in tutto il repo.
  @{ et='r124a';   ea='ABTG_SupRev_DOW_H1_Ottimizzato';            pv='R124a_U30USD_04_firstfraction.txt'; mo=4; de=10000;  ce=4 },

  # --- BLOCCO F: le stesse due uscite Supertrend sul DAX H4 (970912).
  @{ et='r120d11'; ea='ABTG_SupRev_DAX_H4_Ottimizzato';            pv='R120d_D30EUR_11_vivo.txt';          mo=4; de=10000;  ce=2 },
  @{ et='r120d01'; ea='ABTG_SupRev_DAX_H4_Ottimizzato';            pv='R120d_D30EUR_01_notrail.txt';       mo=4; de=10000;  ce=2 },
  @{ et='r120d10'; ea='ABTG_SupRev_DAX_H4_Ottimizzato';            pv='R120d_D30EUR_10_noflip.txt';        mo=4; de=10000;  ce=2 },
  @{ et='r120d00'; ea='ABTG_SupRev_DAX_H4_Ottimizzato';            pv='R120d_D30EUR_00_nuda.txt';          mo=4; de=10000;  ce=2 },

  # --- BLOCCO G, ULTIMO PER UN MOTIVO: XAUUSD H4 dal 2020.01.01.
  #     E' il solo blocco della tabella con PIU' DI UN REGIME dentro la
  #     finestra (crollo 2020, orso 2022, toro 2023-2025): la regola C
  #     dell'Emendamento della Finestra qui e' l'unica volta che si puo'
  #     provare a soddisfare. E per questo vale.
  #     MA e' anche il solo con lo scarico dei tick [NON MISURATO]:
  #     se il tempo sfonda, sfonda qui, in coda, con i primi diciassette
  #     round gia' in cassaforte.
  @{ et='r120c11'; ea='ABTG_SupertrendReversal_Multi_Ottimizzato'; pv='R120c_XAUUSD_11_vivo.txt';          mo=4; de=10000;  ce=2 },
  @{ et='r120c01'; ea='ABTG_SupertrendReversal_Multi_Ottimizzato'; pv='R120c_XAUUSD_01_notrail.txt';       mo=4; de=10000;  ce=2 },
  @{ et='r120c10'; ea='ABTG_SupertrendReversal_Multi_Ottimizzato'; pv='R120c_XAUUSD_10_noflip.txt';        mo=4; de=10000;  ce=2 },
  @{ et='r120c00'; ea='ABTG_SupertrendReversal_Multi_Ottimizzato'; pv='R120c_XAUUSD_00_nuda.txt';          mo=4; de=10000;  ce=2 }
)

# =====================================================================
#  ESCLUSI, E PERCHE'. Trentadue file prova su cinquantatre.
#  Si scrive qui e non in un referto a parte, perche' chi legge questo
#  file deve sapere cosa NON c'e' dentro e per quale motivo.
#
#  A) DODICI FILE -- L'EA STA SU UN COMMIT "NON COMPILARE".
#     Il commit b45dd00 (11/09 09:12) dice testualmente "IN CORSO
#     D'OPERA -- NON COMPILARE: 10 EA e 2 strumenti, agenti ancora al
#     lavoro", e il driver compila la TESTA del branch. Verificato EA
#     per EA con 'git log -1 -- mql5/Experts/<NOME>.mq5':
#        ABTG_SuperWave_DOW_H1_Ottimizzato   b45dd00  -> r120b x4, r120e x2, r126a, r126b, r126c
#        ABTG_SuperWave                      b45dd00  -> r126d
#        ABTG_SupertrendReversal_Ottimizzato b45dd00  -> r127b
#        ABTG_CostToCost                     b45dd00  -> r127c
#     Fra questi ci sono DUE dei tre round in cima al censimento delle
#     uscite (r127b InpSLLookback, r127c InpMaxBarsHold) e la sedia al
#     72% del pavimento di costo (r126a). Non e' un dettaglio: e' la
#     META' BUONA del giacimento, e oggi non e' misurabile.
#     Il giorno in cui quei quattro EA tornano su un commit compilabile,
#     quei dodici file sono pronti e costano ~14 minuti in tutto.
#
#  B) VENTI FILE -- CHIEDONO -FrazioneIS 0.50 E DA QUI NON PASSA.
#     RIGA_SOTTILE_ROUND.ps1 accetta cinque argomenti (-Expert -Prova
#     -Etichetta -Modello -Deposito) e -FrazioneIS NON e' fra quelli;
#     il driver ha 0.40 come default (walkforward_generico.ps1 r.171).
#     Questi venti file scrivono "-FrazioneIS 0.50 NON E' OPZIONALE":
#        r128b r128c r128d r128e            (4)
#        r129a r129b r129c                  (3)
#        r130a r130b r130c r130d r130e      (5)
#        r131a..r131h                       (8)
#     Girarli da questa strada darebbe un taglio 40/60 dove i criteri
#     dicono 50/50: le finestre IS e OOS non sarebbero quelle su cui le
#     soglie sono state congelate, e la misura NON sarebbe attribuibile.
#     >>> E' un difetto NUOVO, e non lo trova controlla_prova.py, che di
#         FrazioneIS non sa niente. Passano il cancello E NON SONO
#         LANCIABILI: sono due cose diverse.
#     La via piu' corta per sbloccarli e' UN solo script dedicato che
#     passi -FrazioneIS 0.50, che pero' e' CODICE NUOVO: vuole un giro
#     di cancello e un giro di pin. Non e' "a costo zero di scrittura",
#     e va deciso, non fatto di nascosto.
#
#  C) E CIO' CHE NON ENTRA PER SCELTA, non per impedimento: nessun
#     round di questa tabella allarga i parametri d'ingresso di un
#     motore dichiarato senza edge (limite del 19/08). r126d, per
#     esempio, dichiara da se' una base PF 1,02213 -- e sarebbe stato
#     escluso anche senza il problema del commit.
# =====================================================================

# ---------------------------------------------------------------------
#  1. LISTA BIANCA SUGLI ARGOMENTI.
# ---------------------------------------------------------------------
if($Da -ne ""){
  if($Da.Contains("..")){ Muori ("-Da non passa la lista bianca: '" + $Da + "'") }
  if($Da -notmatch '^[A-Za-z0-9_.-]+$'){ Muori ("-Da non passa la lista bianca: '" + $Da + "'. E' una etichetta, non un percorso.") }
  if(-not ($Round | Where-Object { $_.et -eq $Da })){
    Muori ("-Da '" + $Da + "' non e' una etichetta di questa tabella. Le etichette sono: " + (($Round | ForEach-Object { $_.et }) -join " "))
  }
}

$celleTot   = ($Round | Measure-Object -Property ce -Sum).Sum
$passateTot = $celleTot * 2
$stimaMin   = [math]::Round($Round.Count * 0.6 + $passateTot * 0.077, 1)

Write-Host "=== CORRI OGGI -- 21 ROUND GIA' SCRITTI E MAI GIRATI ================"
Write-Host ("    " + $MARC_MIO) -ForegroundColor DarkGray
Write-Host ("data     : " + $Avvio.ToString("yyyy-MM-dd HH:mm:ss") + "   (ora locale del VPS)")
Write-Host ("banco    : " + $BancoBT + "   (conto 50504400, demo solo-tester)")
Write-Host  "NON TOCCATI: 50503392 . 50504263 . 10105439 . Pepperstone . Tickmill"
Write-Host ("pin fisso: " + $PIN)
Write-Host ("carico   : " + $Round.Count + " round . " + $celleTot + " celle . " + $passateTot + " passate")
Write-Host ("stima    : ~" + $stimaMin + " min   (banda dichiarata: da " + [math]::Round($stimaMin/2,0) + " a " + [math]::Round($stimaMin*2,0) + " min)")
Write-Host  "           piu' lo SCARICO DEI TICK, che e' [NON MISURATO]."
if($SoloControllo){
  Write-Host ""
  Write-Host "GIRO A VUOTO: nessun tester viene avviato. Serve a leggere il numero" -ForegroundColor Yellow
  Write-Host "di CELLE PER FINESTRA che stampa il DRIVER. Il numero che conta e'" -ForegroundColor Yellow
  Write-Host "quello, non quello di controlla_prova.py." -ForegroundColor Yellow
  Write-Host "  >>> r128a DEVE stampare 7. Se stampa 26, SI FERMA TUTTO: vuol dire" -ForegroundColor Yellow
  Write-Host "      che il driver non ha riconosciuto l'enum ENUM_TIMEFRAMES e" -ForegroundColor Yellow
  Write-Host "      girerebbe valori che non sono timeframe." -ForegroundColor Yellow
}
if($Da -ne ""){ Write-Host ("RIPARTENZA: si comincia da '" + $Da + "', i round prima sono SALTATI.") -ForegroundColor Yellow }
Write-Host ""
Write-Host "AVVERTENZA DICHIARATA: il driver prende l'EA .mq5 e gli include dalla" -ForegroundColor Yellow
Write-Host "TESTA del branch 'lavoro', NON da questo pin. I sei EA di questa" -ForegroundColor Yellow
Write-Host "tabella sono stati controllati uno per uno e NESSUNO sta su un commit" -ForegroundColor Yellow
Write-Host "'NON COMPILARE'. Se qualcuno ha committato da allora, la garanzia scade." -ForegroundColor Yellow

# ---------------------------------------------------------------------
#  2. PRE-VOLO SUL BANCO. Queste righe non si toglono: mettono il
#     bersaglio sotto la regola di SQUALIFICA del cancello positivo.
# ---------------------------------------------------------------------
$exeBanco = ""
try  { $exeBanco = Join-Path $BancoBT "terminal64.exe" }
catch{ Muori ("il percorso del banco non e' utilizzabile su questa macchina: '" + $BancoBT + "' -- " + $_.Exception.Message) }
if(-not (Test-Path -LiteralPath $exeBanco -PathType Leaf)){
  Muori ("il terminale del banco non c'e': non trovo '" + $exeBanco + "'.`n" +
         "    Il banco e' la cartella programma del demo solo-tester 50504400.`n" +
         "    Finche' non c'e', non si scarica e non si esegue niente.")
}
Write-Host ""
Write-Host ("    banco trovato: " + $exeBanco) -ForegroundColor Green

if($PIN -notmatch '^[0-9a-f]{40}$'){
  Muori ("IL PIN NON E' UN COMMIT: '" + $PIN + "'. Qui ci va l'hash a 40 cifre.")
}

# ---------------------------------------------------------------------
#  3. IL FILE, DAL PIN, CON IMPRONTA E MARCATORE.
# ---------------------------------------------------------------------
$Lavoro = Join-Path $env:USERPROFILE "abtg_corri_oggi"
New-Item -ItemType Directory -Force -Path $Lavoro | Out-Null
$fileSottile = Join-Path $Lavoro "RIGA_SOTTILE_ROUND.ps1"

Write-Host ""
Write-Host "--- IL CODICE CHE STA PER GIRARE, INCHIODATO AL BYTE -----------------" -ForegroundColor Cyan
$url = $RawBase + "/backtest_pipeline/righe/RIGA_SOTTILE_ROUND.ps1?cb=" + [Guid]::NewGuid().ToString("N")
try  { Invoke-WebRequest -Uri $url -OutFile $fileSottile -UseBasicParsing -TimeoutSec 120 }
catch{ Muori ("scarico fallito: RIGA_SOTTILE_ROUND.ps1 -- " + $_.Exception.Message) }
if(-not (Test-Path -LiteralPath $fileSottile -PathType Leaf)){ Muori "file non scaricato." }
if((Get-Item -LiteralPath $fileSottile).Length -eq 0){ Muori "file scaricato VUOTO." }
$h = (Get-FileHash -LiteralPath $fileSottile -Algorithm SHA256).Hash
if($h -ne $SHA_SOTTILE){
  Muori ("IMPRONTA DIVERSA su RIGA_SOTTILE_ROUND.ps1.`n" +
         "    attesa  : " + $SHA_SOTTILE + "`n" +
         "    trovata : " + $h + "`n" +
         "    I byte scaricati NON sono quelli del blob letto al pin " + $PIN + ".`n" +
         "    Questo e' esattamente il caso in cui NON si esegue.")
}
if(-not (Select-String -LiteralPath $fileSottile -SimpleMatch -Pattern $MARC_SOTTILE -Quiet)){
  Muori ("manca il marcatore " + $MARC_SOTTILE + ": e' una copia sbagliata.")
}
Write-Host "    backtest_pipeline/righe/RIGA_SOTTILE_ROUND.ps1" -ForegroundColor Green
Write-Host ("        impronta SHA-256 verificata . marcatore " + $MARC_SOTTILE + " presente") -ForegroundColor Green
Write-Host "  (quel file ne scarichera' altri due dal SUO pin interno fb9b4731, e" -ForegroundColor DarkGray
Write-Host "   verifichera' anche quelle due impronte da se'. E' da quello stesso" -ForegroundColor DarkGray
Write-Host "   pin che il driver prende i 21 file prova.)" -ForegroundColor DarkGray
Write-Host "---------------------------------------------------------------------" -ForegroundColor Cyan

# ---------------------------------------------------------------------
#  4. I ROUND, IN SEQUENZA. MAI IN PARALLELO.
# ---------------------------------------------------------------------
$esiti  = @()
$salta  = ($Da -ne "")
$t0Tot  = Get-Date
$i      = 0

foreach($r in $Round){
  $i++
  if($salta){
    if($r.et -eq $Da){ $salta = $false }
    else{
      Write-Host ("[" + $i + "/" + $Round.Count + "] " + $r.et + " -- SALTATO (-Da " + $Da + ")") -ForegroundColor DarkGray
      $esiti += @{ et=$r.et; rc=-1; sec=0; ce=$r.ce }
      continue
    }
  }

  Write-Host ""
  Write-Host ("=====================================================================")
  Write-Host ("[" + $i + "/" + $Round.Count + "]  " + $r.et + "   EA " + $r.ea) -ForegroundColor Cyan
  Write-Host ("        prova " + $r.pv + " . modello " + $r.mo + " . deposito " + $r.de + " . celle attese " + $r.ce)
  Write-Host ("=====================================================================")

  $argv = @("-NoProfile","-ExecutionPolicy","Bypass","-File",$fileSottile,
            "-Expert",$r.ea,
            "-Prova",$r.pv,
            "-Etichetta",$r.et,
            "-Modello",("" + $r.mo),
            "-Deposito",("" + $r.de))
  if($SoloControllo){ $argv += "-SoloControllo" }

  $t0 = Get-Date
  $p  = Start-Process -FilePath "powershell.exe" -ArgumentList $argv -NoNewWindow -PassThru -Wait
  $sec = [int]((Get-Date) - $t0).TotalSeconds
  $rc  = $p.ExitCode

  $esiti += @{ et=$r.et; rc=$rc; sec=$sec; ce=$r.ce }

  if($rc -eq 0){     Write-Host ("  [" + $r.et + "] uscita 0 -- ROUND GIRATO in " + $sec + "s") -ForegroundColor Green }
  elseif($rc -eq 3){ Write-Host ("  [" + $r.et + "] uscita 3 -- GIRATO CON RILIEVI in " + $sec + "s. NON e' un fallimento.") -ForegroundColor Yellow }
  elseif($rc -eq 2){ Write-Host ("  [" + $r.et + "] uscita 2 -- NON MISURATO in " + $sec + "s. Zero operazioni NON vuol dire nessun edge: vuol dire che non e' girata.") -ForegroundColor Red }
  else{              Write-Host ("  [" + $r.et + "] uscita " + $rc + " in " + $sec + "s -- non e' nemmeno partita.") -ForegroundColor Red }

  # La fermata sul primo guasto e' il DEFAULT, e non e' pigrizia:
  # se il banco e' sporco o l'EA non compila, i venti round dopo
  # sarebbero venti fallimenti identici e mezz'ora buttata. Con
  # -NonFermarti si tira avanti, quando si vuole sapere quanti ne cadono.
  if($rc -ne 0 -and $rc -ne 3 -and -not $NonFermarti){
    Write-Host ""
    Write-Host "MI FERMO QUI. Il round sopra non ha prodotto niente, e i prossimi" -ForegroundColor Red
    Write-Host "userebbero la stessa macchina, lo stesso pin e lo stesso banco:" -ForegroundColor Red
    Write-Host "probabilmente cadrebbero allo stesso modo." -ForegroundColor Red
    Write-Host ("Per ripartire da qui una volta riparato:  -Da " + $r.et) -ForegroundColor Red
    Write-Host "Per tirare avanti comunque:               -NonFermarti" -ForegroundColor Red
    break
  }
}

$secTot = [int]((Get-Date) - $t0Tot).TotalSeconds

# ---------------------------------------------------------------------
#  5. LA RACCOLTA: cartella sul Desktop, zip, ED ELENCO DEI FILE ATTESI.
#     L'elenco e' la parte che conta: uno zip senza elenco non dice
#     quello che MANCA, e quello che manca e' l'informazione.
# ---------------------------------------------------------------------
$dsk  = [Environment]::GetFolderPath("Desktop")
$dest = Join-Path $dsk ("CORRI_OGGI_" + $Avvio.ToString("yyyyMMdd_HHmmss"))
New-Item -ItemType Directory -Force -Path $dest | Out-Null

Write-Host ""
Write-Host "--- RACCOLTA ---------------------------------------------------------" -ForegroundColor Cyan
$attesi  = 0
$trovati = 0
$righeEl = @()
foreach($r in $Round){
  $sorg = Join-Path $dsk ("ROUND_" + $r.et)
  if(Test-Path -LiteralPath $sorg -PathType Container){
    $sub = Join-Path $dest ("ROUND_" + $r.et)
    New-Item -ItemType Directory -Force -Path $sub | Out-Null
    Copy-Item -Path (Join-Path $sorg "*") -Destination $sub -Recurse -Force -ErrorAction SilentlyContinue
  }
  # i tre file attesi per ogni round: CSV di IS, CSV di OOS, referto.
  # Il nome del CSV lo fa il driver: <EA>_<SIMBOLO>_<IS|OOS>_<etichetta>.csv
  # Il SIMBOLO qui NON e' noto a questo script (sta nel file prova),
  # quindi l'elenco cerca per SUFFISSO, che e' l'unica parte certa.
  foreach($q in @("_IS_" + $r.et + ".csv", "_OOS_" + $r.et + ".csv")){
    $attesi++
    $hit = @(Get-ChildItem -Path $dest -Recurse -Filter ("*" + $q) -ErrorAction SilentlyContinue)
    if($hit.Count -gt 0){ $trovati++; $righeEl += ("  PRESENTE  *" + $q + "   -> " + $hit[0].Name) }
    else                { $righeEl += ("  ASSENTE   *" + $q) }
  }
  $attesi++
  $ref = Join-Path $dest ("ROUND_" + $r.et + "\REFERTO_ROUND_" + $r.et + ".txt")
  if(Test-Path -LiteralPath $ref){ $trovati++; $righeEl += ("  PRESENTE  REFERTO_ROUND_" + $r.et + ".txt") }
  else                           { $righeEl += ("  ASSENTE   REFERTO_ROUND_" + $r.et + ".txt") }
}
foreach($l in $righeEl){
  if($l -like "*ASSENTE*"){ Write-Host $l -ForegroundColor Red } else { Write-Host $l -ForegroundColor Green }
}

$zip = Join-Path $dsk ("CORRI_OGGI_" + $Avvio.ToString("yyyyMMdd_HHmmss") + ".zip")
if(Test-Path -LiteralPath $zip){ Remove-Item -LiteralPath $zip -Force }
try{
  Compress-Archive -Path (Join-Path $dest "*") -DestinationPath $zip -Force
  Write-Host ""
  Write-Host ("ZIP PRONTO DA MANDARE: " + $zip) -ForegroundColor Green
}catch{
  Write-Host ""
  Write-Host ("ZIP NON FATTO: " + $_.Exception.Message) -ForegroundColor Red
  Write-Host ("La cartella c'e' comunque: " + $dest) -ForegroundColor Yellow
}

# ---------------------------------------------------------------------
#  6. IL RIEPILOGO, E IL COSTO VERO CONTRO QUELLO STIMATO.
#     Il confronto si stampa APPOSTA: il metro di casa e' una retta
#     tarata su UN solo EA, e questa e' la prima occasione per vedere
#     quanto sbaglia su sette. Il numero misurato vale piu' del mio.
# ---------------------------------------------------------------------
Write-Host ""
Write-Host "--- RIEPILOGO --------------------------------------------------------" -ForegroundColor Cyan
$ok = 0; $ril = 0; $ko = 0; $sk = 0
foreach($e in $esiti){
  # if/elseif e non switch: in PowerShell un'etichetta di switch che
  # comincia col segno meno (-1) puo' essere letta come un PARAMETRO.
  # Costa tre righe in piu' e non ha quel modo di rompersi.
  $tag = "NON PARTITO "
  if($e.rc -eq  0){ $tag = "GIRATO      " }
  elseif($e.rc -eq  3){ $tag = "CON RILIEVI " }
  elseif($e.rc -eq  2){ $tag = "NON MISURATO" }
  elseif($e.rc -eq -1){ $tag = "SALTATO     " }
  Write-Host ("  " + $tag + "  " + $e.et.PadRight(10) + " celle " + ("" + $e.ce).PadLeft(3) + "   " + ("" + $e.sec).PadLeft(5) + "s")
  if($e.rc -eq 0){ $ok++ } elseif($e.rc -eq 3){ $ril++ } elseif($e.rc -eq -1){ $sk++ } else { $ko++ }
}
$girati = $ok + $ril
$passateGirate = 0
foreach($e in $esiti){ if($e.rc -eq 0 -or $e.rc -eq 3){ $passateGirate += ($e.ce * 2) } }
Write-Host ""
Write-Host ("  girati " + $girati + " . con rilievi " + $ril + " . caduti " + $ko + " . saltati " + $sk + "   su " + $Round.Count)
Write-Host ("  TEMPO TOTALE MISURATO: " + [math]::Round($secTot/60.0,1) + " min   (stima di questo file: ~" + $stimaMin + " min)")
if($passateGirate -gt 0){
  Write-Host ("  costo VERO per passata: " + [math]::Round($secTot/[double]$passateGirate,1) + " s su " + $passateGirate + " passate girate")
  Write-Host  "  >>> QUESTO numero va scritto nel referto: e' il primo metro"
  Write-Host  "      misurato su piu' di un EA, e sostituisce la mia retta."
}

Write-Host ""
Write-Host "COSA GUARDARE, in quest'ordine:" -ForegroundColor Cyan
Write-Host "  1. le righe 'PID vivi PRIMA' e 'PID vivi DOPO' stampate da ogni" -ForegroundColor Cyan
Write-Host "     round: devono essere GLI STESSI. E' la prova che i terminali in" -ForegroundColor Cyan
Write-Host "     forward (50503392, 50504263, 10105439) non sono stati toccati." -ForegroundColor Cyan
Write-Host "  2. gli ASSENTE nell'elenco della raccolta qui sopra." -ForegroundColor Cyan
Write-Host "  3. le ANCORE, prima di qualunque altro numero:" -ForegroundColor Cyan
Write-Host "     r127a  cella InpSLBufferPips=3 -> deve ridare OOS PF 1,68815" -ForegroundColor Cyan
Write-Host "            DD 0,8567% Trades 86 (e IS 1,34237 / 0,9670% / 69)." -ForegroundColor Cyan
Write-Host "     r120a11/r120d11/r120c11 sono le celle VIVE dei loro blocchi." -ForegroundColor Cyan
Write-Host "     Se un'ancora non torna, il guasto e' nel BANCO o nel BINARIO," -ForegroundColor Cyan
Write-Host "     non nei parametri, e i parametri NON si leggono." -ForegroundColor Cyan
Write-Host "  4. il numero di CELLE per finestra: r128a deve dire 7, non 26." -ForegroundColor Cyan
Write-Host ""
Write-Host "  E CIO' CHE QUESTI CSV NON POSSONO DIRE, dichiarato prima di leggerli:" -ForegroundColor Yellow
Write-Host "  il campione si conta in POSIZIONI, non in deal (classe 226: fattore" -ForegroundColor Yellow
Write-Host "  misurato 1,000-2,314). La colonna Trades conta i DEAL DI USCITA." -ForegroundColor Yellow
Write-Host "  Su r127a, r120a, r120c, r120d c'e' il parziale al 50% E la tranche" -ForegroundColor Yellow
Write-Host "  pendente: fino a 4 deal per segnale. Un Trades=86 puo' essere 22" -ForegroundColor Yellow
Write-Host "  posizioni. Sotto 150 POSIZIONI il MERITO e' sospeso, il RISCHIO no." -ForegroundColor Yellow

$rcFin = if($ko -gt 0){ 1 } else { 0 }
Write-Host ""
Write-Host ("ESITO CORRI OGGI: uscita " + $rcFin)
exit $rcFin
