# -*- coding: ascii -*-
import os, io
BASE='/home/user/GITHUB/backtest_pipeline/prove/'
src=[l.rstrip('\n') for l in open(BASE+'R112_00_metro.txt')]
corpo=[l for l in src if l.startswith('Inp')]
def body(skip, magic_axis, comment):
    out=[]
    for l in corpo:
        nome=l.split('=')[0]
        if nome in skip or nome=='InpMagic': continue
        if nome=='InpComment':
            out.append('InpComment='+comment); continue
        if nome=='InpNewsCurrencies':
            out.append('# InpNewsCurrencies NON pinnato DI PROPOSITO: il pin di una')
            out.append('# stringa a valore vuoto MT5 lo IGNORA e usa il default')
            out.append('# compilato (controlla_prova.py, controllo 3 -- difetto')
            out.append('# ereditato dall antenato R112_00_metro.txt r.96). Default = "".')
            continue
        out.append(l)
    out.append('InpMagic='+magic_axis)
    return out

TESTA = """# ==========================================================================
#  EA: ABTG_EMA200
#  COLLAUDO PROP -- cella viva U30USD H1 (sedia 771531). File %s.
#  CRITERI CONGELATI PRIMA DEI NUMERI:
#    backtest_pipeline/prove/COLLAUDO_EMA200_DOW_CRITERI.md  (commit caaf5d1,
#    12/09/2026 -- committato PRIMA di questo file, e prima di ogni numero)
#  BANCO: Modello 4 (TICK REALI), deposito 100000, leva 100, rischio 1.0%%,
#         finestra 2024.09.26 -> 2026.06.30, split 40/60 -- IDENTICO a
#         R112/R110. Non si cambia il banco dentro un collaudo.
#  G0-A (gate di casa): il corpo di questo file e' la COPIA RIGA PER RIGA
#         dell'ANTENATO prove/R112_00_metro.txt (= il preset vivo, verificato
#         46 chiavi su 46). Delta ammessi e dichiarati per nome qui sotto.
#  G5: nessun deploy. Questo file non tocca VPS, preset, ne' sedie vive.
#  MAGIC: blocco 7666xx, VERGINE -- verificato repo-wide il 12/09/2026
#         (grep -rE "\\b7666[0-9][0-9]\\b" --exclude-dir=.git . -> 0).
#         VIETATI: 771531 (sedia viva), 771501 (sorgente), 7633xx (R110),
#         76340x-76343x (R112), 7636xx (R114), 764102/764103 (LATI).
# ==========================================================================
"""
def scrivi(nome, testa_extra, skip, magic, comment, asse, coda=''):
    f=io.open(BASE+nome,'w',newline='\n')
    f.write(TESTA % nome)
    f.write(testa_extra)
    f.write("@SIMBOLO  U30USD\n@PERIODO  H1\n@DAQUANDO 2024.09.26\n")
    f.write(coda)
    f.write("#\n# --- I FISSI: copia dell'antenato R112_00_metro.txt\n")
    f.write("\n".join(body(skip, magic, comment))+"\n")
    if asse: f.write(asse)
    f.write("# ==========================================================================\n")
    f.close()
    print("scritto", nome)

# ------------------------------------------------------------------ 00
scrivi('COLLAUDO_EMADOW_00_canarino_spread.txt', """#
#  LA DOMANDA, e non e' "conviene filtrare lo spread?"
#    E' IL CANARINO. Prima di qualunque scala di spread bisogna sapere
#    UNA cosa: il tester, a Modello 4, fa arrivare all'EA uno spread VERO
#    E VARIABILE, o un numero costante? Finche' non si sa, ogni gradino
#    di spread e' una figura retorica. In casa la domanda e' aperta e
#    scritta: "La riga Spread dell'.ini a Modello 4 e' [NON MISURATO]:
#    non sappiamo se MT5 la onori. Chi volesse aggiungerlo deve prima
#    passare il CANARINO" (prove/R118_PAVIMENTO_STOP_CRITERI.md par.4.3;
#    REFERTO_R118_PAVIMENTO_STOP.md par.8.2 punto 6).
#
#  COME LO CHIEDE, senza toccare una riga di codice
#    L'EA ha GIA' la manopola: SpreadOK() al r.507 del .mq5 confronta
#    SymbolInfoInteger(_Symbol,SYMBOL_SPREAD) con InpMaxSpread, in PUNTI
#    MT5, e il r.325 la chiama al momento del SEGNALE (una volta per
#    barra, prima di piazzare i due LIMIT). Quindi: si sale con la
#    soglia e si guarda se il numero di operazioni si muove.
#    >>> CONVERSIONE DICHIARATA: 100 punti MT5 = 1 punto indice U30USD
#        (R118_PAVIMENTO_STOP_CRITERI.md par.4.4: 2000 punti MT5 = 20 idx).
#    >>> LIMITE DICHIARATO: il filtro guarda lo spread all'ISTANTE DEL
#        SEGNALE, non a quello del riempimento del LIMIT. Non e' lo
#        stesso momento e non e' lo stesso spread.
#
#  I NUMERI VERI DELLO SPREAD, misurati, che rendono l'attesa falsificabile
#    spread_flotta/spread_orario_U30USD.csv, 64.711.285 tick, 0 tick
#    solo-bid. Mediana per fascia, ORA SERVER BCM (= ora italiana - 1):
#      ore 16-21 : 1.8-1.9 idx (= 180-190 punti MT5)
#      ore 14-15 : 2.0       (= 200)
#      ore 0-13  : 2.6-2.8   (= 260-280)
#      ora 23    : 2.8, p95 7.0, max 101 (= 280 / 700 / 10100)
#    Distribuzione MISURATA delle 517 uscite della base: 55.7% nelle ore
#    14-21, 44.3% nelle ore 0-13 e 23 (conteggio sul per-trade R112).
#
#  ATTESA DICHIARATA PRIMA DEI NUMERI -- tre uscite, tutte scritte QUI
#    Base (cella InpMaxSpread=0) = R112/R110 al centesimo:
#      OOS  PF 1.52365 | DD 7.8323% | 517 deal | +23321.47
#      IS   PF 1.20110 | DD 5.7325% | 237 deal
#    (A) SI MUOVE, e nell'ordine giusto: n(100) crolla quasi a zero,
#        n(200) perde una fetta grossa (le ore 0-13 e 23 hanno mediana
#        2.6-2.8 = 260-280 > 200), n(300) quasi un no-op (p95 = 3.0),
#        n(400) identico alla base. ==> IL TESTER PORTA LO SPREAD VERO.
#        Conseguenze: la PROVA A (scala di spread nell'.ini) si puo'
#        fare, e questo file ha gia' prodotto GRATIS la manopola di
#        irrobustimento che serve al cancello C3 (tagliare le ore
#        larghe senza toccare InpSLatr, che R118 ha misurato costoso e
#        NON riproducibile: OOS 29/56 = una monetina).
#    (B) NON SI MUOVE: cinque celle identiche alla cifra. ==> l'EA vede
#        uno spread che non varia. La PROVA A a Modello 4 e' MORTA e va
#        dichiarata tale; lo stress di costo resta la PROVA B
#        (post-processing sui per-trade) e il C3 resta un conto
#        d'archivio. Non e' un fallimento del collaudo: e' la risposta.
#    (C) SI MUOVE ALL'INCONTRARIO o a salti non monotoni (es. n(100) >
#        n(300)). ==> CANARINO FALLITO: non si conclude NIENTE, la scala
#        resta bloccata e si apre un difetto di banco. Un canarino che
#        non conferma e non smentisce non e' un risultato: e' un guasto.
#
#  QUANTO COSTA: 5 celle x 2 gemelli = 10 passate per gamba (IS + OOS).
#  L'UNICO DELTA sull'antenato: InpMaxSpread (l'asse) e InpMagic.
#
""", skip=['InpMaxSpread'], magic='766600',
     comment='COLLAUDO EMADOW canarino spread',
     asse="""#
# --- L'UNICO ASSE: la soglia di spread, in PUNTI MT5 (100 = 1 punto indice)
#     0 = filtro SPENTO (la cella viva) | 100 = 1.0 idx | 200 = 2.0 idx
#     300 = 3.0 idx (il p95 misurato) | 400 = 4.0 idx (no-op atteso)
InpMaxSpread=0||0||100||400||Y
""")

# ------------------------------------------------------------------ 01
scrivi('COLLAUDO_EMADOW_01_spread_scala_ini.txt', """#
#  LA PROVA A -- LA SCALA DI SPREAD. E PARTE SOLO SE IL CANARINO DICE (A).
#    Questo file NON si lancia prima di COLLAUDO_EMADOW_00_canarino_spread.
#    Se il canarino esce (B) o (C), questo file va ARCHIVIATO NON LANCIATO
#    e il referto lo scrive. Lanciarlo comunque produrrebbe quattro
#    colonne identiche e un verdetto falso -- il tipo di numero che costa
#    una challenge.
#
#  IL GRADINO NON STA IN QUESTO FILE, E NON E' UNA DIMENTICANZA
#    Lo spread e' un PARAMETRO DI BANCO: sta nella riga Spread= dell'.ini,
#    che la scrive il DRIVER, non il file prova (stessa convenzione di
#    R114, dove Deposit/Leverage/Model stanno nel driver). Quindi: UNA
#    cella, QUATTRO corse, e i quattro valori sono questi -- congelati:
#      Spread=0     base, spread dei tick registrati   (gia' misurata)
#      Spread=238   +25%  (1.9 idx x 1.25 = 2.375 idx)
#      Spread=285   +50%  (1.9 x 1.50 = 2.85 idx)
#      Spread=380   +100% (1.9 x 2.00 = 3.8 idx)
#    Da dove esce l'1.9: MEDIANA MISURATA delle ore 14-21 server, dove
#    cade il 55.7% delle uscite della base (spread_orario_U30USD.csv,
#    64.7 M tick). Non e' una stima: e' un percentile di 64 milioni di
#    tick, e la conversione 100 punti MT5 = 1 punto indice e' dichiarata.
#
#  ATTESA DICHIARATA PRIMA DEI NUMERI
#    Base: OOS PF 1.52365 | DD 7.8323% | 517 deal | +23321.47.
#    Il costo di 1 punto indice su OGNI ingresso e' MISURATO sul
#    per-trade della base: 1553.40 lotti chiusi x 0.861 EUR = 1337.48 EUR,
#    cioe' il 5.73% del profitto per punto. Quindi, se il tester applica
#    lo spread forzato agli ingressi e alle uscite, l'attesa aritmetica e':
#      +25% (+0.475 idx) ~= -635 EUR   -> netto ~ +22690, PF ~ 1.505
#      +50% (+0.95  idx) ~= -1271 EUR  -> netto ~ +22050, PF ~ 1.489
#      +100% (+1.9  idx) ~= -2541 EUR  -> netto ~ +20780, PF ~ 1.456
#    >>> E QUESTO E' IL CONTRO-ESEMPIO DEL FILE: se i numeri veri
#        cadessero LONTANO da questa riga (per esempio un crollo del 40%
#        a +25%), non sarebbe "un risultato": vorrebbe dire che lo
#        spread forzato agisce su un'altra grandezza (il grilletto, il
#        riempimento del LIMIT) e il gradino andrebbe capito prima di
#        essere letto.
#
#  SOGLIE: quelle congelate in COLLAUDO_EMA200_DOW_CRITERI.md par.2.
#    PASS = a +50%: netto > 0 E PF >= 1.10 E DD <= 10.0% E peggior
#    giornata chiusi > -3.50%. Niente di questo si rilegge dopo.
#
#  QUANTO COSTA: 1 cella x 2 gemelli x 4 valori di spread = 8 passate
#  per gamba. L'UNICO DELTA sull'antenato: InpMagic.
#
""", skip=[], magic='766610||766610||1||766611||Y',
     comment='COLLAUDO EMADOW scala spread',
     asse="")

# ------------------------------------------------------------------ 02
scrivi('COLLAUDO_EMADOW_02_pertrade_IS.txt', """#
#  LA DOMANDA: QUANTE POSIZIONI HA L'IS DI QUESTA CELLA?
#    E' il numero che manca al CERTIFICATO (requisito 2: n e DD) e che
#    decide un cancello. L'Emendamento A chiede >= 150 OPERAZIONI per
#    parte; la colonna Trades dei nostri CSV conta DEAL DI USCITA, non
#    posizioni (classe 226). Misurato oggi sui per-trade di R112:
#      00_metro     517 deal = 257 posizioni  (rapporto 2.0117)
#      01_short_r1  302 deal = 140 posizioni  (2.1571)
#      02_short_r2  315 deal = 140 posizioni  (2.2500)
#      03_short_r3  324 deal = 140 posizioni  (2.3143)
#    L'OOS quindi e' 257 posizioni: PASSA. L'IS ha 237 deal e il suo
#    per-trade NON ESISTE in archivio (R112 dichiara "IS n/d PER
#    COSTRUZIONE"): stimato 237/2.0117 = 118 posizioni, cioe' SOTTO 150.
#    >>> Ma e' una STIMA, e su una stima non si archivia un cancello.
#        Questo file la trasforma in una misura, in una passata.
#
#  COME: la finestra IS da sola, tranche unica (FrazioneIS 1.0 dalla
#  riga di lancio), e si CONTANO i position_id distinti nel per-trade
#  che l'EA esporta a fine test.
#
#  LA SENTINELLA -- e serve, perche' la data del confine e' DEDOTTA
#    Il confine IS/OOS non e' scritto in nessun file prova: e' il 40%
#    di 2024.09.26 -> 2026.06.30 calcolato dal driver. Il primo close
#    del per-trade OOS di R112 e' il 2025.06.12 13:44:51, e il file
#    LATI_A2 del 09/09 ha dedotto 2025.06.10. Qui si usa 2025.06.10 e
#    si CONTROLLA: questa corsa deve riprodurre l'IS di R112
#      237 deal (tolleranza +-2%) | PF 1.20110 (+-0.05) | DD 5.7325%
#    Fuori tolleranza = la data del confine e' un'altra, il file va
#    riscritto con quella, e il conteggio delle posizioni NON si legge.
#
#  ATTESA DICHIARATA PRIMA: posizioni fra 102 e 118 (= 237 diviso per
#  il rapporto misurato 2.3143 - 2.0117). Perche' l'intervallo e' quello
#  e non "fra 1 e 237": il rapporto e' guidato da InpTP1Pct, che qui e'
#  50.0 come nella cella 00_metro, dove il rapporto misurato e' 2.0117.
#    >>> CONTRO-ESEMPIO: per arrivare a 150 posizioni il rapporto dovrebbe
#        scendere a 1.58, FUORI dalla banda misurata su quattro varianti
#        della stessa cella. Se il numero vero uscisse >= 150, allora
#        sarebbe il MODELLO del rapporto a essere sbagliato, non il
#        cancello -- e andrebbe riaperta la classe 226.
#
#  QUANTO COSTA: 1 cella x 2 gemelli = 2 passate, UNA SOLA GAMBA.
#  L'UNICO DELTA sull'antenato: InpMagic e la finestra (dichiarata qui).
#
""", skip=[], magic='766620||766620||1||766621||Y',
     comment='COLLAUDO EMADOW pertrade IS',
     asse="", coda="@FINOA    2025.06.10\n")

# ------------------------------------------------------------------ 03
scrivi('COLLAUDO_EMADOW_03_uscita_TP1PCT.txt', """#
#  LA DOMANDA: LA GESTIONE DELL'USCITA E' MAI STATA MESSA AD ASSE?
#    Requisito 3 del CERTIFICATO (regola del 09/09). Risposta misurata
#    oggi, leggendo le colonne che VARIANO in tutti i CSV di questo EA:
#    su U30USD sono stati messi ad asse SOLO InpOrder1Atr, InpOrder2Atr
#    e InpTP_RR (R29b, R28/valid_realtick) piu' i due lati (R110/R112).
#    InpTP1Pct, InpBreakeven, InpUseTrailing, InpSLatr e
#    InpPendingExpiryBars non hanno MAI variato in NESSUN CSV di
#    ABTG_EMA200, su NESSUN simbolo. Verificato file per file.
#    >>> Cioe': la macchina d'uscita che produce il rapporto 2.01
#        deal/posizione, il 50% di parziale, il breakeven e il trailing
#        EMA14 -- quella che decide il DD -- e' MAI STATA MISURATA
#        contro un'alternativa. Il PF 1.52 e' il PF di UNA gestione.
#
#  PERCHE' PROPRIO InpTP1Pct, e prima delle altre
#    1. e' il parametro che GUIDA il rapporto deal/posizione (classe
#       226): a TP1Pct=0 il rapporto deve andare verso 1.00, e allora
#       le 257 posizioni OOS diventano leggibili in DEAL senza
#       ambiguita', e il cancello del campione si chiude da solo;
#    2. il parziale al 50% e' esattamente cio' che una prop guarda:
#       toglie rischio presto e taglia la coda dei vincenti;
#    3. e' un input, non codice nuovo. Niente si tocca nell'EA.
#
#  ATTESA DICHIARATA PRIMA DEI NUMERI
#    cella 50 = la sedia viva = OOS PF 1.52365 | DD 7.8323% | 517 deal
#               (G0-B: se questa cella non riproduce, il round e' nullo)
#    cella 0   (nessun parziale): rapporto deal/posizione -> ~1.0, deal
#               attesi ~260-290; PF NON prevedibile nel segno -- il
#               parziale al 50% puo' star togliendo o aggiungendo edge;
#    celle 25/75/100: servono a vedere se c'e' un ALTOPIANO o un picco.
#    >>> LA REGOLA DI SELEZIONE, dichiarata col numero: se il profilo e'
#        piatto si TIENE LA CELLA VIVA (50), non la migliore. Si cambia
#        la sedia solo se una cella batte la viva su DD *e* su PF *e*
#        ha le vicine d'accordo. CENTRO DELL'ALTOPIANO, MAI IL PICCO.
#    >>> E il limite di casa: questo file NON promuove niente da solo.
#        Un parametro nuovo su una cella promossa cambia la sedia e va
#        rivalidato da zero. Qui si misura la FRAGILITA' della gestione,
#        che e' una domanda di collaudo, non di ottimizzazione.
#
#  QUANTO COSTA: 5 celle x 2 gemelli = 10 passate per gamba (IS + OOS).
#  L'UNICO DELTA sull'antenato: InpTP1Pct (l'asse) e InpMagic.
#
""", skip=['InpTP1Pct'], magic='766630',
     comment='COLLAUDO EMADOW uscita TP1PCT',
     asse="""#
# --- L'UNICO ASSE: quota del parziale al primo bersaglio, in percento
#     0 = nessun parziale | 50 = la sedia viva | 100 = chiude tutto a TP1
InpTP1Pct=50.0||0.0||25.0||100.0||Y
""")

# ------------------------------------------------------------------ 04
scrivi('COLLAUDO_EMADOW_04_uscita_TRAILING.txt', """#
#  LA DOMANDA: IL TRAILING SU EMA14 REGGE O E' UN REGALO DEL REGIME?
#    Seconda meta' del requisito 3 del CERTIFICATO. InpUseTrailing non
#    ha MAI variato in nessun CSV di questo EA (verificato file per
#    file il 12/09). E il trailing e' il meccanismo che, in 21 mesi di
#    indici in salita, puo' aver fatto tutto il lavoro -- oppure aver
#    tagliato le gambe ai vincenti. Non si sa: non e' mai stato spento.
#
#  PERCHE' CONTA PER UNA PROP, e non e' una curiosita'
#    Il trailing su una media mobile in un toro lungo e' il classico
#    meccanismo che in un LATERALE si rovescia (esce in anticipo e
#    rientra peggio). Il collaudo prop chiede: se il regime cambia, il
#    profitto era del motore o del trailing?
#
#  ATTESA DICHIARATA PRIMA DEI NUMERI
#    cella 1 = la sedia viva = OOS PF 1.52365 | DD 7.8323% | 517 deal
#              (G0-B: se non riproduce, il round e' nullo)
#    cella 0 = trailing spento, breakeven ancora acceso. Attesa sul
#              VERSO, non sulla misura: meno deal per posizione (il
#              trailing e' una delle cause delle uscite multiple),
#              e DD atteso PIU' ALTO o uguale. Se il DD scendesse
#              con il trailing SPENTO, vorrebbe dire che il trailing
#              sta chiudendo tardi, non presto: e sarebbe la scoperta
#              piu' importante del round.
#    >>> Non si promuove niente da qui. Si misura una dipendenza.
#
#  QUANTO COSTA: 2 celle x 2 gemelli = 4 passate per gamba.
#  L'UNICO DELTA sull'antenato: InpUseTrailing (l'asse) e InpMagic.
#
""", skip=['InpUseTrailing'], magic='766640',
     comment='COLLAUDO EMADOW uscita TRAILING',
     asse="""#
# --- L'UNICO ASSE: 0 = trailing EMA14 SPENTO | 1 = la sedia viva
InpUseTrailing=1||0||1||1||Y
""")

# ------------------------------------------------------------------ 05
scrivi('COLLAUDO_EMADOW_05_tf_U30USD.txt', """#
#  LA DOMANDA: SU QUESTO SIMBOLO IL TF E' MAI STATO CAMBIATO? NO.
#    Requisito 5 del CERTIFICATO. Misurato oggi, colonna InpTF di tutti
#    i CSV di ABTG_EMA200: l'asse TF (11 celle, M15 -> D1) e' girato A
#    TICK REALI su AUDJPY, GBPJPY, GBPUSD, SPXUSD, XAUUSD e in OHLC su
#    200AUD -- e MAI su U30USD, dove tutti i round (R29b, R31, R103,
#    R110, R112, R114) hanno InpTF=16385 fisso. Cioe': la sedia che
#    stiamo per schierare gira sull'UNICO TF che non e' mai stato
#    confrontato con un altro, sul suo simbolo.
#
#  E InpTF E' UN ASSE VERO, non il periodo del grafico: il .mq5 usa
#  InpTF in iMA (r.258-259), iATR (r.260), iTime (r.294), iClose
#  (r.329) e PeriodSeconds (r.378). Il @PERIODO del tester resta H1 su
#  tutte le celle: l'unica cosa che cambia e' il TF operativo dell'EA.
#
#  ATTESA DICHIARATA PRIMA DEI NUMERI
#    cella H1 (16385) = la sedia viva = OOS PF 1.52365 | DD 7.8323% |
#      517 deal (G0-B: se non riproduce, il round e' nullo)
#    M15 e M20: attesi FUORI dal cancello del costo, e il numero c'e':
#      lo stop pieno della gamba 2 su H1 e' 88.2 punti indice di
#      MEDIANA (misurato oggi su 33 coppie di stop pieni del per-trade
#      R112); la frontiera di casa e' stop >= 40 x spread = 76-80 punti
#      in sessione e 104-112 di notte. Su M15 l'ATR e' una frazione di
#      quello di H1: lo stop scende sotto la frontiera. Questo file NON
#      lo assume: lo MISURA, e se M15 passasse il costo sarebbe una
#      notizia (piu' operazioni = campione prima).
#    H2/H3/H4: attesi meno operazioni e PF non prevedibile nel segno.
#    >>> REGOLA DI SELEZIONE, dichiarata col numero: se H1 sta DENTRO un
#        altopiano di TF vicini positivi, la sedia resta H1 e il
#        requisito 5 si chiude. Se H1 fosse l'UNICO TF positivo, allora
#        e' un PICCO, e un picco isolato su un asse mai provato e' il
#        difetto che questo progetto chiama "verde per caso".
#        Non si cambia TF alla sedia da questo file. Si scopre se H1 e'
#        un altopiano o una fortuna.
#
#  QUANTO COSTA: MT5 sugli enum ignora lo step e spazzola i MEMBRI fra
#  start e stop: 15=M15, 20=M20, 30=M30, 16385=H1, 16386=H2, 16387=H3,
#  16388=H4 = 7 celle x 2 gemelli = 14 passate per gamba (IS + OOS).
#  Le barre stanno nel tetto del tester: M15 su 21 mesi ~ 44.000 barre.
#  >>> ATTENZIONE A UN NUMERO CHE MENTE, e va detto prima che spaventi:
#      controlla_prova.py conta questo asse ARITMETICAMENTE e stampa
#      "celle=16374". E' sbagliato per costruzione: su un ENUM MT5
#      ignora lo step e spazzola i MEMBRI fra start e stop (LEGGIMI.md).
#      Le celle vere sono SETTE, e il driver le conta bene e le stampa
#      prima di partire. Il -SoloControllo del driver e' l'unico numero
#      da guardare su questa riga.
#  L'UNICO DELTA sull'antenato: InpTF (l'asse) e InpMagic.
#
""", skip=['InpTF'], magic='766650',
     comment='COLLAUDO EMADOW asse TF',
     asse="""#
# --- L'UNICO ASSE: il TF OPERATIVO dell'EA (enum: contano gli estremi)
#     15=M15  20=M20  30=M30  16385=H1 (la sedia viva)  16386=H2
#     16387=H3  16388=H4
InpTF=16385||15||1||16388||Y
""")

# ------------------------------------------------------------------ 06
scrivi('COLLAUDO_EMADOW_06_latenza.txt', """#
#  LA PROVA DELLA LATENZA -- E IL SUO CANARINO E' GIA' IN ARCHIVIO.
#    Il driver ha il parametro -Ritardo, che scrive ExecutionMode
#    nell'.ini (walkforward_generico.ps1 r.193). NON e' una chiave
#    inventata: il primo giro di R119 scriveva "Delay=" e il canarino
#    ha trovato i CSV IDENTICI BYTE PER BYTE (classe 156, MT5 ignora in
#    silenzio le chiavi che non conosce). Corretta la chiave, il secondo
#    giro MISURA l'effetto -- e lo si legge dai CSV in archivio:
#      risultati_archivio/ritardo_r119b_csv/ , somma Profit OOS
#        ABTG_DAX_Apertura_EU D30EUR : 2206.62 / 2212.22 / 2217.78 / 2240.50
#                                      (0 / 50 / 100 / 500 ms)  -> SI MUOVE
#        ABTG_ORB_Ottimizzato U30USD : 4968.34 in tutti e quattro -> FERMO
#    >>> QUINDI IL CANARINO NON VA RIFATTO: la chiave funziona, e' provata
#        su un EA nello stesso round, e non serve bruciare macchina per
#        riprovarla. Questo e' il file che ha gia' la risposta.
#    >>> E ATTENZIONE AL VERSO, che e' la parte contro-intuitiva: sul DAX
#        il ritardo ha MIGLIORATO il risultato (+1.5% a 500 ms). Il
#        ritardo del tester NON e' uno slippage avverso: e' un ritardo,
#        e puo' cadere da tutte e due le parti. Chi lo legge come
#        "costo" sbaglia di segno.
#
#  ATTESA DICHIARATA PRIMA DEI NUMERI, e qui e' una PREVISIONE precisa
#    Questa cella entra con DUE ORDINI LIMIT PENDENTI (.mq5 r.226-228),
#    non a mercato. Un LIMIT viene riempito al suo prezzo o non viene
#    riempito: il ritardo di esecuzione dell'INVIO non sposta il prezzo
#    di riempimento. Quindi l'attesa e': numeri IDENTICI o quasi
#    identici su tutti e quattro i gradini, come l'ORB.
#    >>> E QUESTO E' IL PUNTO DELICATO DEL FILE, scritto prima:
#        se escono identici, NON si scrive "immune alla latenza".
#        Si scrive: "il ritardo del tester non tocca il riempimento di
#        un LIMIT" -- che e' una frase sul MODELLO, non sulla sedia.
#        La latenza vera morde su altro (il pendente piazzato in
#        ritardo, il requote, il rifiuto) e quelle cose MT5 non le
#        modella: restano [NON MISURABILI] e vanno nel referto.
#    >>> Se invece i numeri si MUOVESSERO, sarebbe la notizia: vorrebbe
#        dire che il tester ritarda il PIAZZAMENTO del pendente, e
#        allora la scala misura una cosa vera e va letta contro le
#        soglie dei criteri (par.2).
#
#  I GRADINI, congelati: -Ritardo 0 / 50 / 100 / 500 ms.
#    Sono gli stessi di R119b, di proposito: cosi' i due round si
#    leggono sulla stessa scala e il confronto EMA200-vs-ORB (stesso
#    simbolo, U30USD!) e' un confronto, non un aneddoto.
#
#  QUANTO COSTA: 1 cella x 2 gemelli x 4 gradini = 8 passate per gamba.
#  L'UNICO DELTA sull'antenato: InpMagic.
#
""", skip=[], magic='766660||766660||1||766661||Y',
     comment='COLLAUDO EMADOW latenza',
     asse="")
