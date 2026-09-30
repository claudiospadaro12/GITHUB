# =====================================================================
#  MARCATORE_CONFRONTO_TOCCO_CHIUSURA_M5_v1
#  confronto_tocco_chiusura_m5.py -- ENTRARE AL PRIMO TOCCO DEL LIVELLO
#  O ALLA CHIUSURA DI UNA BARRA M5 OLTRE IL LIVELLO? (Nasdaq) 30/09/2026
# ---------------------------------------------------------------------
#  LA DOMANDA (UNA, e solo questa)
#    Live di Paolo Lavorenti del 29/09/2026 (report/ANALISI_LIVE_PAOLO_2026-09-29.md,
#    par. 2 punto 1): ORB = box dei primi 15 minuti dopo l'apertura cash;
#    "si entra quando una candela M5 CHIUDE oltre la linea del box". I nostri
#    motori entrano invece al PRIMO TOCCO con un ordine pendente. Sul Nasdaq,
#    entrare alla chiusura M5 fuori e' MEGLIO o PEGGIO che entrare al primo
#    tocco? Il confronto non e' mai stato misurato.
#
#  ###################################################################
#  #  QUELLO CHE QUESTO STRUMENTO **NON** E':                         #
#  #  NON e' un backtest. NON calcola PF, NON calcola un'EQUITY, NON  #
#  #  promuove niente. NIENTE spread, NIENTE costi, NIENTE slippage:  #
#  #  ogni "R lordo" qui e' LORDO. UNA FREQUENZA NON E' UN EDGE.      #
#  #  Non tocca MT5, EA, preset, sedie, conti. Legge un CSV e conta.  #
#  #  Usa (IMPORTA) le funzioni di lettura, costruzione M5 e          #
#  #  calendario di anatomia_movimenti_m5.py SENZA modificarle: il    #
#  #  file dell'anatomia resta byte per byte quello del pin (SHA256   #
#  #  controllato qui sotto e dall'autotest).                         #
#  ###################################################################
#
#  DEFINIZIONI (dichiarate, non nascoste)
#    Giorno valido = stesso cancello dell'anatomia (stato OK). Range = prime
#    15 (e, in un secondo blocco, prime 30) minuti dell'apertura cash Nasdaq
#    09:30 New York, dalle M5 costruite dalle M1 (feed HistData, ora di NY).
#    STOP = bordo OPPOSTO del range, in tutte e due le entrate.
#    ENTRATA A (primo tocco) = la PRIMA barra M5 con offset >= N il cui
#      estremo tocca il livello (RH per il long, RL per lo short; buffer 0).
#      E' la "prima rottura" dell'anatomia, identica: entrata AL LIVELLO.
#      Una barra che tocca tutti e due i lati = AMBIGUA, niente entrata A.
#    ENTRATA B (chiusura fuori) = la PRIMA barra M5 con offset >= N la cui
#      CHIUSURA sta oltre il livello (close > RH: long; close < RL: short;
#      strettamente oltre, una chiusura SUL livello non e' "fuori"). Entrata
#      al CLOSE di quella barra. E' PEGGIORE per il ritardo e per il prezzo
#      (si entra piu' lontano dal livello): DICHIARATO, e' parte della domanda.
#    R' = distanza entrata-stop: per A = ampiezza del range; per B = close
#      d'entrata meno stop (piu' grande di A). Diversa nei due casi.
#    ESITO = sequenza sulle barre M5 fino a fine seduta (16:00 NY): +1R'
#      toccato prima dello stop (T), stop prima (S), nessuno dei due (N).
#      Convenzioni di ambiguita' dell'anatomia, IDENTICHE (funzione _sequenza
#      importata): barra con bersaglio E stop = A (ambigua, mai T ne' S);
#      per A nella barra del tocco anche il solo stop e' ambiguo (puo'
#      precedere l'ingresso); per B le barre contano dalla SUCCESSIVA a
#      quella d'entrata (l'entrata e' alla chiusura).
#    R LORDO (pre-registrato) = P(T)*(+1) + P(S)*(-1) + P(N)*0, con A
#      contato come S (conservativo); SENZA costi. Seconda lettura, "a
#      mercato": i N si chiudono al close dell'ultima barra della seduta, in
#      unita' di R'. La forchetta dell'ambiguita' (A come T) e' stampata.
#    FALSO (dopo l'entrata) = una delle prime 3 CHIUSURE M5 dopo il momento
#      d'entrata e' <= al livello. A: chiusure delle barre kA, kA+1, kA+2
#      (e' la definizione "falso entro 15 min" dell'anatomia, riprodotta).
#      B: chiusure delle barre kB+1, kB+2, kB+3. Tre chiusure per parte.
#    COPPIE = i giorni in cui esistono TUTTE E DUE le entrate. Si separano:
#      stesso lato (LONG, SHORT), lati opposti (A long e B short o viceversa),
#      e si CONTANO i giorni con solo A o solo B. [Cancello 30/09: le coppie
#      sono DESCRIZIONE; il verdetto e' sulle ENTRATE, le due politiche.]
#
#  ###################################################################
#  ATTESE, SCRITTE PRIMA DEI NUMERI (mai visti i numeri di questo studio;
#  dell'anatomia si sono lette SOLO le frequenze di A dell'ADDESTRAMENTO,
#  per sapere che l'R lordo di A e' gia' ~0: -0,03..+0,05. La cassaforte
#  dell'anatomia NON e' stata guardata.)
#  ###################################################################
#  Due ipotesi, NON esaustive e NON esclusive (possono valere insieme):
#   H_CHIUSURA (meccanismo): la chiusura M5 FILTRA i falsi breakout: fra le
#     entrate di B c'e' una quota di falsi minore che fra quelle di A.
#   H_NIENTE   (pagamento) : B paga solo il ritardo: R lordo B <= R lordo A.
#  [Cancello 30/09: il verdetto decide SOLO il pagamento, fra le politiche,
#   sul grezzo. La quota di falsi e' stampata come descrizione: non separa
#   il filtro dalla deriva, vedi la correzione piu' sotto.]
#
#  IL CONTRO-ESEMPIO CHE HA DETTATO IL METODO (classe 178). Il confronto
#  GREZZO "falso% di B < falso% di A di X punti" e' GARANTITO anche in un
#  mercato senza memoria: B entra a una distanza d > 0 OLTRE il livello, A
#  entra ESATTAMENTE sul livello, e su un cammino casuale la probabilita' di
#  ritoccare il livello nelle 3 chiusure successive e' piu' alta partendo da
#  d = 0 che da d > 0. MISURATO nell'autotest (random walk con profilo orario
#  tipo Nasdaq, 24 celle): divario grezzo A-B 16,2..22,9 punti (media 19,7)
#  SENZA nessuna informazione. Una banda "B meno di A di 10 punti" cadrebbe
#  IDENTICA sotto H_NIENTE. Idem per l'R: sulle coppie, A e' avvantaggiata
#  dalla selezione (i giorni in cui B esiste sono i giorni in cui il prezzo ha
#  chiuso fuori, DOPO l'entrata di A ma PRIMA di quella di B): B-A e'
#  negativo anche a mercato senza memoria. Quindi (STESURA ORIGINALE,
#  SUPERATA dal cancello qui sotto: oggi l'eccesso e' solo DESCRIZIONE)
#  il numero che decideva era l'ECCESSO SUL NULLO: lo stesso confronto, su
#  giorni SURROGATI in cui il range e' quello vero e ogni barra successiva
#  ha il SEGNO tirato a sorte (stessa ampiezza, stessa forma, stesso profilo
#  orario, stessi buchi; direzione senza memoria = H_NIENTE per costruzione).
#  Il nullo e' calcolato IN CORSA sugli stessi giorni (K=30 surrogati per
#  giorno, seme fisso 20260930). ECCESSO = osservato - media del nullo.
#
#  DUE CONFRONTI, perche' UNO SOLO SBAGLIA (dichiarato prima):
#   - COPPIE (stessi giorni, A e B dello stesso lato). Non vede il filtro:
#     i giorni in cui B non entra NON sono nelle coppie. DESCRITTIVO.
#   - ENTRATE (le due politiche sugli stessi giorni validi: tutte le
#     entrate di A contro tutte quelle di B, per lato). Qui il filtro si
#     vede. Errore standard per giorno (metodo delta), giorni sovrapposti.
#
#  ###################################################################
#  CORRETTO DAL CANCELLO DI GIUDIZIO (30/09/2026, PRIMA di ogni numero
#  vero; classe 929 della checklist). La prima stesura decideva il
#  PAGAMENTO sull'ECCESSO sul nullo e lo chiedeva SU COPPIE E ENTRATE, e il
#  MECCANISMO sull'eccesso del falso. Tre contro-esempi ESEGUITI (script
#  collaudo_riga_confronto_tocco/mondi_controesempio.py):
#   (1) nel MONDO POSITIVO dell'autotest stesso, sulle coppie B-A GREZZO e'
#       -0,11..-0,19 (6 errori standard SOTTO zero) e il verdetto diceva
#       "PAGA" = "B batte A al lordo": il nullo di quel mondo vale -0,54 e
#       l'eccesso lo scavalca. L'etichetta diceva il FALSO;
#   (2) in un mondo dove la chiusura fuori PORTA davvero l'informazione
#       (dopo una chiusura fuori il prezzo prosegue, dopo un tocco che
#       richiude dentro torna indietro) B batte A di +0,25..+0,37 R' sulle
#       entrate (10 errori standard) e il verdetto era INCONCLUSIVA 24 celle
#       su 24, meccanismo NON_FILTRA 24 su 24: le coppie non vedono il filtro
#       (lo diceva gia' il par. 5.2) ma il verdetto le RICHIEDEVA;
#   (3) il falso di A CONTIENE la chiusura della barra del tocco, cioe' il
#       segnale stesso di B, e il nullo la riproduce (forme conservate):
#       l'eccesso del falso misura solo la deriva nelle 3 barre dopo
#       l'entrata. Nel mondo (2) esce -3,8..+2,9 (filtro vero, "NON
#       FILTRA" 24 su 24); in un mondo dove l'informazione e' nel TOCCO e la
#       chiusura non aggiunge niente esce +3,1..+12,8 (FILTRA in 4 celle su 24).
#   [24 celle per mondo, ricontate dal secondo giudice il 30/09; la prima
#    stesura di questo blocco riportava una corsa da 6 celle.]
#  QUINDI, da qui: il VERDETTO e' UNO, sul PAGAMENTO, ed e' sul confronto
#  fra le POLITICHE (ENTRATE), sul valore GREZZO (R lordo e R a mercato,
#  B meno A): e' la risposta diretta a "meglio o peggio". Il nullo, le
#  coppie e l'eccesso del falso restano STAMPATI come DESCRIZIONE: non
#  decidono niente.
#  ###################################################################
#
#  SOGLIE (congelate qui e in report/CONFRONTO_TOCCO_CHIUSURA_M5_CRITERI.md):
#   X_R = 0,08 R' sulla differenza GREZZA B-A fra le politiche (R lordo e
#   R a mercato). n minimo 150 = min(entrate A, entrate B) per cella:
#   Emendamento A, l'unita' e' l'operazione-giorno. X_F = 10 punti resta
#   SOLO come riferimento della riga descrittiva del falso (non decide).
#   Zona di una misura: SI se valore >= X e il limite basso dell'IC 95% > 0;
#   NO se il limite alto dell'IC 95% < X; INCERTO negli altri casi.
#   PAGAMENTO: PAGA = R lordo e R a mercato in zona SI; NON_PAGA = tutte e
#     due in zona NO; altrimenti INCONCLUSIVO.
#   Lettura: PAGA = "B MEGLIO al lordo"; NON_PAGA = "B NON MEGLIO" (H_NIENTE
#     sul pagamento); il resto = INCONCLUSIVA. Un RANGE (15 o 30) ha una
#     lettura solo se LONG e SHORT dicono la STESSA cosa. Sono verdetti su
#     una DESCRIZIONE, non promozioni.
#  PERCHE' X_R = 0,08 (scelta del costruttore, tenuta): l'errore standard
#   della differenza per giorno e' ~0,025 a n ~650 entrate per lato (mondi
#   sintetici) e scende con 1/radice(n) [a n ~1250: stima, NON misurata];
#   0,08 R' e' dello stesso ordine del costo di 1 punto di spread su un R'
#   di 15 punti (0,067 R; spread NON MISURATO): un vantaggio minore non
#   pagherebbe un costo di quell'ordine nemmeno se fosse vero.
#  CONTRO-ESEMPI ESEGUITI (mondi_controesempio.py, 12 semi x 2 lati = 24
#   celle per mondo, 1400 giorni, range 15; regola VECCHIA -> NUOVA):
#   senza memoria : PAGA 0 -> 0;  NON_PAGA 13 -> 20;  B-A grezzo -0,11..+0,05
#   positivo      : PAGA 24 -> 24 (ma sulle COPPIE B-A grezzo -0,19..-0,11)
#   FILTRO        : PAGA 0 -> 24; meccanismo vecchio NON_FILTRA 24/24;
#                   B-A grezzo sulle entrate +0,25..+0,37
#   TOCCO         : PAGA 0 -> 0;  NON_PAGA 0 -> 23; meccanismo vecchio
#                   FILTRA 4/24 (falso positivo del falso)
#  X_F = 10 punti resta solo come riferimento della riga DESCRITTIVA del
#   falso (divario grezzo A-B senza memoria ~20 punti: vedi sopra).
#  Attesa di chi scrive (NON un criterio): NON_PAGA o INCONCLUSIVO in quasi
#   tutte le celle (l'R lordo di A e' gia' ~0, quello di B non ha motivo di
#   stare sopra). Se esce il contrario e' una notizia e va ricontrollata a
#   mano prima di crederci.
#
#  COSA NON SI POTRA CONCLUDERE (dichiarato prima dei numeri)
#   - Nessun PF, nessuna equity, NESSUN COSTO: "PAGA" vuol dire "B batte A
#     al LORDO", non "B guadagna". Cella con R' mediano di 15 punti: la
#     frontiera stop >= 40 x spread ammette solo spread <= 0,375 punti
#     [spread Nasdaq BCM: NON MISURATO qui].
#   - USO D-C = SOLO_PROVA_REGIME: feed HistData esterno, non BCM. Nessun
#     parametro, nessuna sedia, nessuna promozione esce da qui.
#   - L'addestramento 2010-2020 e' UN SOLO REGIME (lunga salita con tassi a
#     zero): la lettura vale per quel regime. La cassaforte 2021-2026 contiene
#     un altro regime ma l'anno 2023 ha una quota di giorni sospetti alta
#     nel feed (33,2% nel log dell'anatomia): i suoi giorni buoni sono meno.
#   - Il close della barra come prezzo d'entrata B ignora slippage e gap fra
#     close e open successivo; l'ordine DENTRO una barra M5 non e' osservabile.
#   - ASIMMETRIA A FAVORE DI A, dichiarata: l'entrata A e' "AL LIVELLO" (fill
#     perfetto di un pendente, anche se la barra del tocco lo ha attraversato
#     con un salto) mentre B paga il close reale della barra. Un B <= A puo'
#     dipendere in parte da questo fill ideale di A, non solo dal ritardo.
#   - Otto celle (2 range x 2 lati x 2 fasi) sono otto occasioni di rumore:
#     per questo la soglia e' una DIFFERENZA con IC e un range vale solo se LONG
#     e SHORT concordano; i verdetti dell'addestramento decidono, la cassaforte
#     conferma o no.
#   - Il verdetto dice SE la chiusura M5 rende di piu' del primo tocco, non
#     PERCHE': il falso non separa il filtro dalla deriva (il falso di A
#     contiene il segnale di B) e il nullo a segni casuali e' descrizione.
#     Vicino alla soglia e' INCERTO, non SI. Se l'IC95 della differenza e'
#     piu' largo della soglia la cella e' "non risolvibile" (rilievo).
#   - Non dice NIENTE sul DAX (feed non misurabile) ne' sul retest, ne' su
#     uscite diverse da +1R'.
#
#  DUE FASI, come l'anatomia: addestramento Nasdaq 2010-2020 (le ipotesi si
#  scrivono SOLO qui), cassaforte 2021-2026 (VALIDA soglie gia' congelate),
#  in referti DISTINTI, mai mescolati. Solo NASDAQ (il DAX non e'
#  misurabile col feed HistData: vedi l'anatomia).
#
#  CODICI D'USCITA: 0 = misurato, nessun rilievo; 1 = misurato CON RILIEVI
#  (gli artefatti ci sono e vanno mandati); 2 = NON partito / invalido
#  (incoerenza con l'anatomia, file sbagliato, pin non corrispondente).
#  Numeri sempre col PUNTO decimale (float()/"%.*f", niente locale).
# =====================================================================

import argparse
import hashlib
import math
import os
import random
import shutil
import sys
import tempfile
from datetime import date, timedelta

_QUI = os.path.dirname(os.path.abspath(__file__))
if _QUI not in sys.path:
    sys.path.insert(0, _QUI)
try:
    import anatomia_aperture as AA
    import anatomia_movimenti_m5 as AM
except ImportError as _e:                      # pragma: no cover
    sys.stdout.write("!!! MANCA anatomia_movimenti_m5.py (o anatomia_aperture.py) accanto a "
                     "questo file (%s).\n" % _e)
    sys.exit(2)

VERSIONE = "CONFRONTO_TOCCO_CHIUSURA_M5_v1"
SHA_ANATOMIA_M5 = "EFD839E232F348DED01208BF421FA3EE07E4FDCA664E7789D9D1FEDEE872173F"
SHA_ANATOMIA_APERTURE = "446D2D18B1C5281A16C01704C23844D9333087393D5EC48F0DA7883D2ECA0183"

# ---- soglie CONGELATE (vedi la testa del file e il file dei criteri)
X_FALSO_PP = 10.0          # punti percentuali di ECCESSO sul nullo (SOLO descrittivo)
X_R = 0.08                 # R': soglia del VERDETTO sulla differenza GREZZA B-A fra le politiche
                           # (usata anche, solo descrittiva, sulle righe dell'eccesso sul nullo)
N_MIN_CELLA = 150          # entrate minime per politica, min(nA, nB), per pronunciarsi (Emendamento A)
Z95 = 1.96
K_SURR_DEFAULT = 30
SEME_DEFAULT = 20260930
FALSO_BARRE = 3            # tre chiusure M5 = 15 minuti
RANGES_DEFAULT = "15,30"

log = AA.log

# mutazioni per l'autotest (classe 918: ogni convenzione ha un caso che la ROMPE)
_MUT = {}


def _m(nome):
    return bool(_MUT.get(nome, False))


def sha256_file(percorso):
    h = hashlib.sha256()
    with open(percorso, "rb") as fh:
        while True:
            blocco = fh.read(1 << 20)
            if not blocco:
                break
            h.update(blocco)
    return h.hexdigest().upper()


def verifica_anatomia():
    """Il file dell'anatomia importato e' quello del pin? Torna (ok, righe)."""
    righe = []
    ok = True
    for nome, mod, atteso in (("anatomia_movimenti_m5.py", AM, SHA_ANATOMIA_M5),
                              ("anatomia_aperture.py", AA, SHA_ANATOMIA_APERTURE)):
        try:
            h = sha256_file(mod.__file__.replace(".pyc", ".py"))
        except (IOError, OSError, AttributeError) as e:
            righe.append("%s: SHA256 non leggibile (%s)" % (nome, e))
            ok = False
            continue
        if h != atteso:
            righe.append("%s: SHA256 %s DIVERSO dal pin %s" % (nome, h[:12], atteso[:12]))
            ok = False
        else:
            righe.append("%s: SHA256 %s.. = pin" % (nome, h[:12]))
    if getattr(AM, "VERSIONE", "") != "ANATOMIA_MOVIMENTI_M5_v1":
        righe.append("anatomia_movimenti_m5.VERSIONE = %r, atteso ANATOMIA_MOVIMENTI_M5_v1" %
                     getattr(AM, "VERSIONE", None))
        ok = False
    return ok, righe


# =====================================================================
#  LA MISURA DI UN GIORNO PER UN RANGE (A: primo tocco, B: chiusura fuori)
# =====================================================================
def _specchio(m5, lato):
    """Serie (hi, lo, close) con 'su' = verso favorevole. Short = prezzi
    specchiati (p -> -p), come l'anatomia. Le barre vuote restano None."""
    out = []
    for b in m5:
        if b is None:
            out.append(None)
        elif lato == 1:
            out.append((b[1], b[2], b[3]))
        else:
            out.append((-b[2], -b[1], -b[3]))
    return out


def _valuta(mb, j0, K, E, S, speciale, Rp=None):
    """Esito di un'entrata in E con stop S: bersaglio +1R' (R' = E - S).
    Torna seq (T/S/A/N) e R in quattro versioni: R (A come stop, timeout 0),
    Rh (A come bersaglio), Rm/Rmh (i N chiusi al close dell'ultima barra)."""
    if Rp is None:
        Rp = E - S
    T = E + Rp
    seq = AM._sequenza(mb, j0, K, T, S, speciale)
    ultimo = None
    for j in range(K - 1, j0 - 1, -1):
        if j >= 0 and mb[j] is not None:
            ultimo = mb[j][2]
            break
    if seq == "T":
        R = Rh = Rm = Rmh = 1.0
    elif seq == "S":
        R = Rh = Rm = Rmh = -1.0
    elif seq == "A":
        R = Rm = -1.0
        Rh = Rmh = 1.0
    else:
        R = Rh = 0.0
        Rm = Rmh = ((ultimo - E) / Rp) if ultimo is not None else 0.0
    return {"seq": seq, "R": R, "Rh": Rh, "Rm": Rm, "Rmh": Rmh, "Rp": Rp}


def _falso(mb, da, K, level):
    """Una delle 3 chiusure M5 dalla barra `da` e' <= al livello? None se la
    finestra non sta tutta dentro la seduta o non ha nessuna chiusura."""
    if da < 0 or da + FALSO_BARRE > K:
        return None
    v = [mb[j][2] for j in range(da, da + FALSO_BARRE) if mb[j] is not None]
    if not v:
        return None
    return min(v) <= level


def misura_range(cfg, m5, N):
    """Le due entrate per il range di N minuti. m5: lista di K barre
    (o,h,l,c,n) o None. Torna un dict; 'stato' = OK / MANCANTE / PIATTO."""
    K = cfg.K
    nb = N // 5
    buf = cfg.buffer
    rec = {"N": N, "A": None, "B": None, "A_txt": "", "stato": "OK"}
    barre = m5[:nb]
    if any(b is None for b in barre):
        rec["stato"] = "MANCANTE"
        rec["A_txt"] = "MANCANTE"
        return rec
    RH = max(b[1] for b in barre)
    RL = min(b[2] for b in barre)
    Ar = RH - RL
    rec["Ar"] = Ar
    if Ar <= 0:
        rec["stato"] = "PIATTO"
        rec["A_txt"] = "PIATTO"
        return rec
    # ---------------- ENTRATA A: primo tocco (la "prima rottura" dell'anatomia)
    rec["A_txt"] = "NESSUNA"
    kA = None
    latoA = 0
    for k in range(nb, K):
        b = m5[k]
        if b is None:
            continue
        up = b[1] >= RH + buf
        dn = b[2] <= RL - buf
        if up and dn:
            rec["A_txt"] = "AMBIGUA"
            break
        if up or dn:
            kA = k
            latoA = 1 if up else -1
            break
    if kA is not None:
        mb = _specchio(m5, latoA)
        if latoA == 1:
            level, S = RH, RL - buf
        else:
            level, S = -RL, -(RH + buf)
        E = level + buf
        a = _valuta(mb, kA, K, E, S, True)
        a["lato"] = latoA
        a["k"] = kA
        a["chiude_dentro"] = mb[kA][2] <= level
        a["falso"] = _falso(mb, kA + 1 if _m("a_falso_dopo") else kA, K, level)
        rec["A"] = a
        rec["A_txt"] = "LONG" if latoA == 1 else "SHORT"
    # ---------------- ENTRATA B: prima chiusura M5 oltre il livello
    kB = None
    latoB = 0
    for k in range(nb, K):
        b = m5[k]
        if b is None:
            continue
        c = b[3]
        if _m("b_ge"):
            if c >= RH + buf:
                kB, latoB = k, 1
                break
            if c <= RL - buf:
                kB, latoB = k, -1
                break
        else:
            if c > RH + buf:
                kB, latoB = k, 1
                break
            if c < RL - buf:
                kB, latoB = k, -1
                break
    if kB is not None:
        mb = _specchio(m5, latoB)
        if latoB == 1:
            level, S = RH, RL - buf
        else:
            level, S = -RL, -(RH + buf)
        EB = mb[kB][2]
        j0 = kB if _m("b_seq_da_entrata") else kB + 1
        Rp = Ar if _m("b_rprime_range") else None
        b_ = _valuta(mb, j0, K, EB, S, False, Rp)
        b_["lato"] = latoB
        b_["k"] = kB
        b_["dist"] = EB - level
        b_["dist_pct"] = 100.0 * (EB - level) / Ar
        b_["falso"] = _falso(mb, kB if _m("b_falso_da_entrata") else kB + 1, K, level)
        rec["B"] = b_
    return rec


def classe_giorno(rec):
    """(classe, sottoclasse). classe in LONG/SHORT (stesso lato), OPPOSTI,
    SOLO_A, SOLO_B, NESSUNO; sottoclasse S = B sulla STESSA barra del tocco,
    L = B piu' TARDI (la barra del tocco chiude dentro)."""
    a, b = rec["A"], rec["B"]
    if a and b:
        if a["lato"] == b["lato"]:
            return ("LONG" if a["lato"] == 1 else "SHORT",
                    "S" if a["k"] == b["k"] else "L")
        return ("OPPOSTI", "")
    if a:
        return ("SOLO_A", "")
    if b:
        return ("SOLO_B", "")
    return ("NESSUNO", "")


# =====================================================================
#  IL NULLO: giorni surrogati a segni tirati a sorte (H_NIENTE per costruzione)
# =====================================================================
def surroga(m5, nb, rng):
    """Copia del giorno in cui le barre dopo il range hanno il SEGNO tirato a
    sorte, una per una: stesse ampiezze, stesse forme, stesso profilo orario,
    stessi buchi; range vero; direzione SENZA MEMORIA. Barra reale con
    (gap, su, giu, corpo) rispetto alla chiusura precedente; con segno -1
    la barra e' specchiata attorno alla sua apertura."""
    out = list(m5[:nb])
    pc_r = m5[nb - 1][3]
    pc_s = pc_r
    for k in range(nb, len(m5)):
        b = m5[k]
        if b is None:
            out.append(None)
            continue
        g = b[0] - pc_r
        su = b[1] - b[0]
        gi = b[0] - b[2]
        co = b[3] - b[0]
        if _m("surr_senza_segni") or rng.random() < 0.5:
            o = pc_s + g
            h, l, c = o + su, o - gi, o + co
        else:
            o = pc_s - g
            h, l, c = o + gi, o - su, o - co
        out.append((o, h, l, c, b[4]))
        pc_r = b[3]
        pc_s = c
    return out


# =====================================================================
#  ACCUMULATORI DI COPPIA E STATISTICHE DI CELLA
# =====================================================================
class Cella(object):
    """Somme su coppie (a, b) dello stesso giorno e stesso lato."""

    def __init__(self):
        self.n = 0
        self.sd = self.sd2 = 0.0        # B - A, R lordo (timeout 0)
        self.sdm = self.sdm2 = 0.0      # B - A, R a mercato
        self.sdh = 0.0                  # B - A, ambiguita' come bersaglio
        self.sra = self.srb = 0.0
        self.sma = self.smb = 0.0
        self.nf = self.fa = self.fb = 0
        self.sf = self.sf2 = 0

    def add(self, a, b):
        self.n += 1
        d = b["R"] - a["R"]
        dm = b["Rm"] - a["Rm"]
        self.sd += d
        self.sd2 += d * d
        self.sdm += dm
        self.sdm2 += dm * dm
        self.sdh += b["Rh"] - a["Rh"]
        self.sra += a["R"]
        self.srb += b["R"]
        self.sma += a["Rm"]
        self.smb += b["Rm"]
        if a["falso"] is not None and b["falso"] is not None:
            self.nf += 1
            self.fa += 1 if a["falso"] else 0
            self.fb += 1 if b["falso"] else 0
            x = (1 if a["falso"] else 0) - (1 if b["falso"] else 0)
            self.sf += x
            self.sf2 += x * x


class CellaE(object):
    """Somme sulle ENTRATE (non sulle coppie) di un lato: tutte le entrate A
    contro tutte le entrate B dello stesso lato, sugli stessi giorni validi.
    E' il confronto fra le due POLITICHE (quello che un trader prenderebbe),
    dove il filtro della chiusura si vede: i giorni in cui B non entra."""

    def __init__(self):
        self.na = self.nb = 0
        self.sra = self.srb = 0.0
        self.sma = self.smb = 0.0
        self.nfa = self.nfb = 0
        self.fa = self.fb = 0

    def add_a(self, a):
        self.na += 1
        self.sra += a["R"]
        self.sma += a["Rm"]
        if a["falso"] is not None:
            self.nfa += 1
            self.fa += 1 if a["falso"] else 0

    def add_b(self, b):
        self.nb += 1
        self.srb += b["R"]
        self.smb += b["Rm"]
        if b["falso"] is not None:
            self.nfb += 1
            self.fb += 1 if b["falso"] else 0


def stat_cella_e(c, giorni=None):
    """Grandezze del verdetto sulle entrate: dR = R lordo medio B - A,
    dF = falso% A - falso% B (punti). Se `giorni` (lista di tuple per
    giorno valido: (a, b) con a/b dict o None) e' data, l'errore standard
    e' quello del rapporto per giorno (metodo delta, giorni sovrapposti)."""
    n = min(c.na, c.nb)
    out = {"n": n, "na": c.na, "nb": c.nb, "dR": None, "seR": None, "dRm": None, "seRm": None,
           "dF": None, "seF": None, "nf": min(c.nfa, c.nfb),
           "Ra": None, "Rb": None, "Rma": None, "Rmb": None, "Fa": None, "Fb": None}
    if c.na == 0 or c.nb == 0:
        return out
    out["Ra"], out["Rb"] = c.sra / c.na, c.srb / c.nb
    out["Rma"], out["Rmb"] = c.sma / c.na, c.smb / c.nb
    out["dR"] = out["Rb"] - out["Ra"]
    out["dRm"] = out["Rmb"] - out["Rma"]
    if c.nfa and c.nfb:
        out["Fa"], out["Fb"] = 100.0 * c.fa / c.nfa, 100.0 * c.fb / c.nfb
        out["dF"] = out["Fa"] - out["Fb"]
    if giorni is None:
        return out
    # errore standard: contributo di ogni giorno alla differenza di due medie
    def se_diff(valore_a, valore_b, ma, mb, na, nb):
        # valore_x(giorno) -> (presente 0/1, x) ; influenza = (x - m*p)/n
        s2 = 0.0
        for a, b in giorni:
            pa, xa = valore_a(a)
            pb, xb = valore_b(b)
            infl = ((xb - mb * pb) / nb) - ((xa - ma * pa) / na)
            s2 += infl * infl
        # correzione N/(N-1) (varianza campionaria): identica alle coppie quando ogni giorno ha A e B
        return math.sqrt(s2 * len(giorni) / (len(giorni) - 1.0)) if len(giorni) > 1 else float("nan")

    def vr(x):
        return (1, x["R"]) if x is not None else (0, 0.0)

    def vm(x):
        return (1, x["Rm"]) if x is not None else (0, 0.0)

    def vf(x):
        if x is None or x["falso"] is None:
            return (0, 0.0)
        return (1, 1.0 if x["falso"] else 0.0)

    out["seR"] = se_diff(vr, vr, out["Ra"], out["Rb"], c.na, c.nb)
    out["seRm"] = se_diff(vm, vm, out["Rma"], out["Rmb"], c.na, c.nb)
    if out["dF"] is not None:
        out["seF"] = 100.0 * se_diff(vf, vf, out["Fa"] / 100.0, out["Fb"] / 100.0, c.nfa, c.nfb)
    return out


def _media_se(s, s2, n):
    if n <= 0:
        return None, None
    m = s / n
    if n < 2:
        return m, None
    var = (s2 - n * m * m) / (n - 1)
    return m, math.sqrt(max(var, 0.0) / n)


def stat_cella(c):
    """Le grandezze del verdetto. dF = falso% A - falso% B (punti);
    dR = R lordo B - R lordo A. Positivo = B meglio."""
    if c.n == 0:
        return {"n": 0, "dR": None, "seR": None, "dRm": None, "seRm": None,
                "dF": None, "seF": None, "nf": 0, "dRh": None,
                "Ra": None, "Rb": None, "Rma": None, "Rmb": None, "Fa": None, "Fb": None}
    dR, seR = _media_se(c.sd, c.sd2, c.n)
    dRm, seRm = _media_se(c.sdm, c.sdm2, c.n)
    pF, sePF = _media_se(c.sf, c.sf2, c.nf)
    return {"n": c.n, "dR": dR, "seR": seR, "dRm": dRm, "seRm": seRm,
            "dRh": c.sdh / c.n,
            "dF": (100.0 * pF) if pF is not None else None,
            "seF": (100.0 * sePF) if sePF is not None else None,
            "nf": c.nf,
            "Ra": c.sra / c.n, "Rb": c.srb / c.n,
            "Rma": c.sma / c.n, "Rmb": c.smb / c.n,
            "Fa": (100.0 * c.fa / c.nf) if c.nf else None,
            "Fb": (100.0 * c.fb / c.nf) if c.nf else None}


def _mean_sd(v):
    v = [x for x in v if x is not None]
    if not v:
        return None, None
    m = sum(v) / len(v)
    if len(v) < 2:
        return m, 0.0
    return m, math.sqrt(sum((x - m) ** 2 for x in v) / (len(v) - 1))


def sintesi_nullo(nulli):
    """nulli: lista di stat_cella (una per surrogato). Media e SD per grandezza."""
    out = {}
    for chiave in ("dF", "dR", "dRm"):
        m, sd = _mean_sd([s[chiave] for s in nulli])
        out[chiave] = (m, sd)
    out["K"] = len(nulli)
    return out


def zona(ex, se, X):
    """SI / NO / INCERTO per un ECCESSO ex con errore se (1 sigma) e soglia X."""
    if ex is None or se is None:
        return "INCERTO"
    if ex >= X and ex - Z95 * se > 0:
        return "SI"
    if ex + Z95 * se < X:
        return "NO"
    return "INCERTO"


def giudica_cella(obs, nullo, n_min=None, x_f=None, x_r=None):
    """DESCRITTIVO dal cancello del 30/09: eccessi sul NULLO (falso e R) per le righe
    'DESCRIZIONE contro il NULLO' del referto; la sua 'lettura' NON esce nel referto e NON
    decide (il verdetto e' giudica_politica). Funzione pura, testata.
    obs = stat_cella osservata; nullo = sintesi_nullo. Le soglie sono quelle
    congelate in testa al file (argomenti solo per i test di mutazione)."""
    n_min = N_MIN_CELLA if n_min is None else n_min
    x_f = X_FALSO_PP if x_f is None else x_f
    x_r = X_R if x_r is None else x_r
    res = {"n": obs["n"], "exF": None, "seF": None, "exR": None, "seR": None,
           "exRm": None, "seRm": None, "zF": "INCERTO", "zR": "INCERTO", "zRm": "INCERTO",
           "meccanismo": "NON_GIUDICABILE", "pagamento": "NON_GIUDICABILE",
           "lettura": "NON GIUDICABILE (coppie < %d, Emendamento A)" % n_min}
    K = max(nullo.get("K", 0), 1)
    dF0, sdF0 = nullo["dF"]
    dR0, sdR0 = nullo["dR"]
    dRm0, sdRm0 = nullo["dRm"]
    if obs["n"] >= 1 and obs["dF"] is not None and dF0 is not None:
        res["exF"] = obs["dF"] - dF0
        res["seF"] = math.sqrt((obs["seF"] or 0.0) ** 2 + (sdF0 or 0.0) ** 2 / K)
    if obs["n"] >= 1 and obs["dR"] is not None and dR0 is not None:
        res["exR"] = obs["dR"] - dR0
        res["seR"] = math.sqrt((obs["seR"] or 0.0) ** 2 + (sdR0 or 0.0) ** 2 / K)
        res["exRm"] = obs["dRm"] - dRm0
        res["seRm"] = math.sqrt((obs["seRm"] or 0.0) ** 2 + (sdRm0 or 0.0) ** 2 / K)
    if obs["n"] < n_min:
        return res
    res["zF"] = zona(res["exF"], res["seF"], x_f)
    res["zR"] = zona(res["exR"], res["seR"], x_r)
    res["zRm"] = zona(res["exRm"], res["seRm"], x_r)
    res["meccanismo"] = {"SI": "FILTRA", "NO": "NON_FILTRA", "INCERTO": "INCONCLUSIVO"}[res["zF"]]
    if res["zR"] == "SI" and res["zRm"] == "SI":
        res["pagamento"] = "PAGA"
    elif res["zR"] == "NO" and res["zRm"] == "NO":
        res["pagamento"] = "NON_PAGA"
    else:
        res["pagamento"] = "INCONCLUSIVO"
    m, p = res["meccanismo"], res["pagamento"]
    if m == "FILTRA" and p == "PAGA":
        res["lettura"] = "H_CHIUSURA sostenuta (filtra e paga, AL LORDO)"
    elif m == "NON_FILTRA" and p == "NON_PAGA":
        res["lettura"] = "H_NIENTE sostenuta (la chiusura non filtra e non paga)"
    elif m == "FILTRA" and p == "NON_PAGA":
        res["lettura"] = "filtra MA non paga: il ritardo si mangia il filtro (H_NIENTE sul pagamento)"
    elif m == "NON_FILTRA" and p == "PAGA":
        res["lettura"] = "ANOMALIA: paga senza filtrare, da guardare a mano (NON e' H_CHIUSURA)"
    else:
        res["lettura"] = "INCONCLUSIVA"
    return res


def giudica_politica(obsE, n_min=None, x_r=None):
    """IL VERDETTO (correzione del cancello, 30/09): la politica B contro la
    politica A sulle ENTRATE (stessi giorni validi), sul valore GREZZO della
    differenza B-A dell'R lordo e dell'R a mercato, con l'errore standard per
    giorno. Nessun nullo: l'R e' gia' l'esito, non un indicatore che il
    ritardo sposta per costruzione (quello era il falso)."""
    n_min = N_MIN_CELLA if n_min is None else n_min
    x_r = X_R if x_r is None else x_r
    res = {"n": obsE["n"], "dR": obsE.get("dR"), "seR": obsE.get("seR"), "dRm": obsE.get("dRm"),
           "seRm": obsE.get("seRm"), "zR": "INCERTO", "zRm": "INCERTO", "pagamento": "NON_GIUDICABILE",
           "peggio": False}
    if obsE["n"] < n_min:
        return res
    res["zR"] = zona(res["dR"], res["seR"], x_r)
    res["zRm"] = zona(res["dRm"], res["seRm"], x_r)
    if res["zR"] == "SI" and res["zRm"] == "SI":
        res["pagamento"] = "PAGA"
    elif res["zR"] == "NO" and res["zRm"] == "NO":
        res["pagamento"] = "NON_PAGA"
    else:
        res["pagamento"] = "INCONCLUSIVO"
    # descrittivo: B PEGGIO di A su tutto l'IC (tutte e due le letture)
    if None not in (res["dR"], res["seR"], res["dRm"], res["seRm"]):
        res["peggio"] = (res["dR"] + Z95 * res["seR"] < 0) and (res["dRm"] + Z95 * res["seRm"] < 0)
    return res


LETTURA_PAGA = "B MEGLIO: la chiusura M5 batte il primo tocco AL LORDO, per operazione (>= %.2f R')" % X_R
LETTURA_NON_PAGA = "B NON MEGLIO: nessun vantaggio della chiusura M5 >= %.2f R' al lordo (H_NIENTE sul pagamento)" % X_R


def combina(vp, ve, obsE):
    """Il verdetto di una cella. Decide SOLO il pagamento fra le POLITICHE
    (entrate, valore grezzo): giudica_politica. Il 'meccanismo' (eccesso del
    falso sul nullo, entrate) e il pagamento sulle COPPIE restano campi
    DESCRITTIVI: non entrano nella lettura (correzione del cancello, 30/09:
    le coppie non vedono il filtro e il falso di A contiene il segnale di B)."""
    pol = giudica_politica(obsE)
    pay = pol["pagamento"]
    if _m("pagamento_su_eccesso"):            # mutazione: la regola vecchia (eccesso sul nullo)
        pay = ve["pagamento"]
    if _m("pagamento_coppie") and pay != "NON_GIUDICABILE":   # mutazione: coppie obbligatorie
        if vp["pagamento"] == "NON_GIUDICABILE":
            pay = "NON_GIUDICABILE"
        elif vp["pagamento"] != pay:
            pay = "INCONCLUSIVO"
    if pay == "NON_GIUDICABILE":
        lett = "NON GIUDICABILE (entrate < %d, Emendamento A)" % N_MIN_CELLA
    elif pay == "PAGA":
        lett = LETTURA_PAGA
    elif pay == "NON_PAGA":
        lett = LETTURA_NON_PAGA
    else:
        lett = "INCONCLUSIVA"
    return {"meccanismo": ve["meccanismo"], "pagamento": pay, "lettura": lett, "pol": pol}


def lettura_range(cl, cs):
    """Le due celle (LONG, SHORT) dello stesso range: una lettura vale per il
    range solo se le due celle dicono la STESSA cosa."""
    if cl["lettura"] == cs["lettura"] and not cl["lettura"].startswith("NON GIUDICABILE"):
        return cl["lettura"]
    if cl["lettura"].startswith("NON GIUDICABILE") or cs["lettura"].startswith("NON GIUDICABILE"):
        return "NON GIUDICABILE (una delle due celle ha meno di %d)" % N_MIN_CELLA
    return "INCONCLUSIVA (LONG e SHORT non concordano: %s | %s)" % (cl["lettura"], cs["lettura"])


# =====================================================================
#  CONTESTO DELLA CORSA: il gancio nel flusso dell'anatomia + il nullo
# =====================================================================
FASI = ("IS", "CASSAFORTE")


class Contesto(object):
    def __init__(self, cfg, K, seme):
        self.cfg = cfg
        self.K = K
        self.rng = random.Random(seme)
        self.nullP = {}
        self.nullE = {}
        self.incoerenze = 0
        self.esempi = []
        self.giorni_ok = 0

    def nulle(self, fase, N, lato):
        chiave = (fase, N, lato)
        if chiave not in self.nullP:
            self.nullP[chiave] = [Cella() for _ in range(self.K)]
            self.nullE[chiave] = [CellaE() for _ in range(self.K)]
        return self.nullP[chiave], self.nullE[chiave]


def _lato_da_rec(rec, lato):
    a = rec["A"] if rec["A"] is not None and rec["A"]["lato"] == lato else None
    b = rec["B"] if rec["B"] is not None and rec["B"]["lato"] == lato else None
    return a, b


def controlla_coerenza(rec, ev):
    """Le entrate A qui coincidono con la 'prima rottura' dell'anatomia,
    GIORNO PER GIORNO? Torna la lista delle differenze (vuota = coerente)."""
    d = []
    if ev is None:
        return d
    attesa = ev["lato_txt"]
    mia = rec["A_txt"]
    if attesa != mia:
        d.append("lato: anatomia %s, qui %s" % (attesa, mia))
        return d
    if mia in ("LONG", "SHORT"):
        a = rec["A"]
        if ev["min_rott"] != a["k"] * 5:
            d.append("minuto rottura: anatomia %s, qui %s" % (ev["min_rott"], a["k"] * 5))
        if ev["seq"][1.0] != a["seq"]:
            d.append("sequenza +1R: anatomia %s, qui %s" % (ev["seq"][1.0], a["seq"]))
        if ev["falso"].get(15) != a["falso"]:
            d.append("falso15: anatomia %s, qui %s" % (ev["falso"].get(15), a["falso"]))
        if ev["chiude_dentro"] != a["chiude_dentro"]:
            d.append("barra di rottura chiude dentro: anatomia %s, qui %s" %
                     (ev["chiude_dentro"], a["chiude_dentro"]))
    return d


def invarianti(rec):
    """Identita' che valgono PER COSTRUZIONE fra le due entrate (nessuna dipende
    dall'anatomia): se cadono, il confronto e' guasto. Torna la lista dei problemi.
      1. B non viene mai prima di A (chiudere fuori = aver toccato).
      2. B sta sulla STESSA barra di A se e solo se la barra del tocco chiude
         FUORI dal livello (e allora ha lo stesso lato); altrimenti B e' dopo
         o non c'e'.
      3. R' di B > R' di A (si entra oltre il livello: B ha sempre piu' rischio)."""
    d = []
    a, b = rec.get("A"), rec.get("B")
    if a is None or b is None:
        if a is not None and not a["chiude_dentro"]:
            d.append("la barra del tocco chiude fuori ma B non c'e'")
        return d
    if b["k"] < a["k"]:
        d.append("B (barra %d) prima di A (barra %d)" % (b["k"], a["k"]))
    stessa = (b["k"] == a["k"])
    if stessa and a["chiude_dentro"]:
        d.append("B sulla barra del tocco ma la barra chiude dentro")
    if (not stessa) and (not a["chiude_dentro"]):
        d.append("la barra del tocco chiude fuori ma B e' su un'altra barra")
    if stessa and a["lato"] != b["lato"]:
        d.append("B sulla barra del tocco con lato diverso")
    if not (b["Rp"] > a["Rp"]) and not _m("b_rprime_range"):
        d.append("R' di B (%s) non maggiore di quello di A (%s)" % (b["Rp"], a["Rp"]))
    return d


def processa_giorno(ctx, g, r):
    """Chiamata per ogni giorno dal gancio. Aggiunge r['cmp'][N] = misura
    delle due entrate e accumula il NULLO (K surrogati per range)."""
    cfg = ctx.cfg
    if r.get("stato") != "OK":
        return
    m5 = AM.m5_da_m1(g["m1"], cfg.K)
    r["cmp"] = {}
    ctx.giorni_ok += 1
    for N in cfg.ranges:
        rec = misura_range(cfg, m5, N)
        r["cmp"][N] = rec
        diff = controlla_coerenza(rec, r["ev"].get(N)) + invarianti(rec)
        if diff:
            ctx.incoerenze += 1
            if len(ctx.esempi) < 5:
                ctx.esempi.append("%s range %d: %s" % (r["data"], N, "; ".join(diff)))
        if rec["stato"] != "OK":
            continue
        for k in range(ctx.K):
            ms = surroga(m5, N // 5, ctx.rng)
            rs = misura_range(cfg, ms, N)
            for lato in (1, -1):
                a, b = _lato_da_rec(rs, lato)
                if a is None and b is None:
                    continue
                cp, ce = ctx.nulle(r["fase"], N, lato)
                if a is not None:
                    ce[k].add_a(a)
                if b is not None:
                    ce[k].add_b(b)
                if a is not None and b is not None:
                    cp[k].add(a, b)


class Gancio(object):
    """Aggancia processa_giorno a AM.analizza_giorno SOLO per la durata della
    corsa e poi RIMETTE l'originale: il file dell'anatomia non e' toccato, e
    nemmeno il modulo resta cambiato (l'autotest lo verifica)."""

    def __init__(self, ctx):
        self.ctx = ctx
        self.orig = None

    def __enter__(self):
        self.orig = AM.analizza_giorno
        orig = self.orig
        ctx = self.ctx

        def con_gancio(cfg, g):
            r = orig(cfg, g)
            processa_giorno(ctx, g, r)
            return r
        AM.analizza_giorno = con_gancio
        return self

    def __exit__(self, *exc):
        AM.analizza_giorno = self.orig
        return False


# =====================================================================
#  AGGREGAZIONE PER (fase, range)
# =====================================================================
def aggrega(ctx, righe, N):
    """righe: giorni di UNA fase (con 'cmp'). Torna il dict dei risultati."""
    fase = righe[0]["fase"] if righe else ""
    res = {"N": N, "fase": fase, "giorni_ok": 0, "MANCANTE": 0, "PIATTO": 0,
           "A": {"LONG": 0, "SHORT": 0, "AMBIGUA": 0, "NESSUNA": 0},
           "B": {"LONG": 0, "SHORT": 0, "NESSUNA": 0},
           "classi": {"LONG": 0, "SHORT": 0, "OPPOSTI": 0, "SOLO_A": 0, "SOLO_B": 0, "NESSUNO": 0},
           "sub": {"LONG": {"S": [], "L": []}, "SHORT": {"S": [], "L": []}},
           "coppie": {1: [], -1: []}, "entrate_a": {1: [], -1: []}, "entrate_b": {1: [], -1: []},
           "giorni_lato": {1: [], -1: []}, "opposti": [], "solo_a": {1: [], -1: []},
           "solo_b": {1: [], -1: []}, "celle": {}}
    for r in righe:
        rec = r.get("cmp", {}).get(N)
        if rec is None:
            continue
        if rec["stato"] != "OK":
            res[rec["stato"]] += 1
            continue
        res["giorni_ok"] += 1
        res["A"][rec["A_txt"]] += 1
        res["B"]["NESSUNA" if rec["B"] is None else ("LONG" if rec["B"]["lato"] == 1 else "SHORT")] += 1
        cl, sub = classe_giorno(rec)
        res["classi"][cl] += 1
        for lato in (1, -1):
            a, b = _lato_da_rec(rec, lato)
            res["giorni_lato"][lato].append((a, b))
            if a is not None:
                res["entrate_a"][lato].append(a)
            if b is not None:
                res["entrate_b"][lato].append(b)
        if cl in ("LONG", "SHORT"):
            lato = rec["A"]["lato"]
            res["coppie"][lato].append((rec["A"], rec["B"]))
            res["sub"][cl][sub].append((rec["A"], rec["B"]))
        elif cl == "OPPOSTI":
            res["opposti"].append((rec["A"], rec["B"]))
        elif cl == "SOLO_A":
            res["solo_a"][rec["A"]["lato"]].append(rec["A"])
        elif cl == "SOLO_B":
            res["solo_b"][rec["B"]["lato"]].append(rec["B"])
    for lato in (1, -1):
        cp = Cella()
        for a, b in res["coppie"][lato]:
            cp.add(a, b)
        ce = CellaE()
        for a in res["entrate_a"][lato]:
            ce.add_a(a)
        for b in res["entrate_b"][lato]:
            ce.add_b(b)
        obsP = stat_cella(cp)
        obsE = stat_cella_e(ce, res["giorni_lato"][lato])
        nP, nE = ctx.nullP.get((fase, N, lato)), ctx.nullE.get((fase, N, lato))
        if nP is None:
            nP = [Cella() for _ in range(ctx.K)]
            nE = [CellaE() for _ in range(ctx.K)]
        sP = sintesi_nullo([stat_cella(c) for c in nP])
        sE = sintesi_nullo([stat_cella_e(c) for c in nE])
        vP = giudica_cella(obsP, sP)
        vE = giudica_cella(obsE, sE)
        res["celle"][lato] = {"obsP": obsP, "obsE": obsE, "nullP": sP, "nullE": sE,
                              "vP": vP, "vE": vE, "comb": combina(vP, vE, obsE)}
    return res


# =====================================================================
#  REFERTO
# =====================================================================
def _f(x, c=3):
    return AA.f(x, c)


def _sgn(x, c=3):
    if x is None:
        return "n/d"
    return ("%+." + str(c) + "f") % x


def _q3(vals, cifre):
    v = [x for x in vals if x is not None]
    if not v:
        return "n/d"
    return "/".join(AA.f(AA.quantile(v, q), cifre) for q in (0.25, 0.5, 0.75)) + \
        ("*" if len(v) < AM.SOGLIA_N else "")


def agg_entrate(lst):
    """Colonna di una tabella: n, T/S/A/N, R lordo (3 letture), falso."""
    n = len(lst)
    conta = dict((s, len([x for x in lst if x["seq"] == s])) for s in "TSAN")
    nf = [x for x in lst if x["falso"] is not None]
    kf = len([x for x in nf if x["falso"]])

    def media(chiave):
        return sum(x[chiave] for x in lst) / n if n else None
    return {"n": n, "T": conta["T"], "S": conta["S"], "A": conta["A"], "N": conta["N"],
            "R": media("R"), "Rh": media("Rh"), "Rm": media("Rm"),
            "nf": len(nf), "kf": kf, "Rp": [x["Rp"] for x in lst]}


def riga_col(etich, ca, cb, fmt):
    return "  %-40s %14s %14s" % (etich, fmt(ca), fmt(cb))


def righe_due_colonne(out, ca, cb, titolo_a="A (primo tocco)", titolo_b="B (chiusura M5 fuori)"):
    n = lambda c: "%d%s" % (c["n"], "*" if c["n"] < AM.SOGLIA_N else "")
    out.append("  %-40s %14s %14s" % ("", titolo_a[:14], titolo_b[:14]))
    out.append(riga_col("operazioni (giorni con entrata)", ca, cb, n))
    for nome, ch in (("+1R' prima dello stop (T) %", "T"), ("stop prima (S) %", "S"),
                     ("stessa barra, ambigua (A) %", "A"), ("nessuno dei due, fine seduta (N) %", "N")):
        out.append(riga_col(nome, ca, cb, lambda c, ch=ch: AA.pct(c[ch], c["n"], 1)))
    out.append(riga_col("R lordo (timeout=0, A come stop)", ca, cb, lambda c: _sgn(c["R"])))
    out.append(riga_col("R lordo (ambigue come bersaglio)", ca, cb, lambda c: _sgn(c["Rh"])))
    out.append(riga_col("R lordo a mercato (N al close 16:00)", ca, cb, lambda c: _sgn(c["Rm"])))
    out.append(riga_col("falso dopo l'entrata % (3 chiusure)", ca, cb,
                        lambda c: "%s(%d)" % (AA.pct(c["kf"], c["nf"], 1), c["nf"])))
    out.append(riga_col("R' mediana (punti)", ca, cb,
                        lambda c: _f(AA.mediana(c["Rp"]), 1) if c["Rp"] else "n/d"))


def riga_zona(nome, ex, se, X, unita, cifre):
    if ex is None or se is None:
        return "    %-34s n/d" % nome
    return ("    %-34s eccesso %s%s  (IC95%% %s..%s)  soglia %s%s  -> %s" %
            (nome, _sgn(ex, cifre), unita, _sgn(ex - Z95 * se, cifre), _sgn(ex + Z95 * se, cifre),
             ("%.*f" % (cifre, X)), unita, zona(ex, se, X)))


def blocco_politica(out, pol):
    """Il VERDETTO della cella: politica B contro politica A (entrate), GREZZO."""
    out.append("  -- VERDETTO (DECIDE): politica B contro politica A sulle ENTRATE, differenza GREZZA B-A, n=min(nA,nB)=%d --"
               % pol["n"])
    out.append(riga_zona("R lordo B-A (timeout 0)", pol["dR"], pol["seR"], X_R, " R", 3).replace("eccesso", "valore "))
    out.append(riga_zona("R a mercato B-A", pol["dRm"], pol["seRm"], X_R, " R", 3).replace("eccesso", "valore "))
    out.append("    -> pagamento %s%s" % (pol["pagamento"],
                                       "   [descrittivo: B PEGGIO di A su tutto l'IC, tutte e due le letture]"
                                       if pol["peggio"] else ""))


def blocco_verdetto(out, etich, obs, nullo, v, frame):
    out.append("  -- DESCRIZIONE contro il NULLO, NON decide: %s [%s] --" % (etich, frame))
    dF0, sF0 = nullo["dF"]
    dR0, sR0 = nullo["dR"]
    dM0, sM0 = nullo["dRm"]
    out.append("    osservato: falso A-B %s pt | R lordo B-A %s | R a mercato B-A %s   (n=%d, nullo K=%d)" %
               (_sgn(obs["dF"], 1), _sgn(obs["dR"]), _sgn(obs["dRm"]), obs["n"], nullo["K"]))
    out.append("    NULLO (segni a sorte): falso A-B %s pt (SD %s) | R B-A %s (SD %s) | a mercato %s (SD %s)" %
               (_sgn(dF0, 1), _f(sF0, 1), _sgn(dR0), _f(sR0), _sgn(dM0), _f(sM0)))
    out.append(riga_zona("ECCESSO falso (A-B) [meccanismo]", v["exF"], v["seF"], X_FALSO_PP, " pt", 1))
    out.append(riga_zona("ECCESSO R lordo (B-A)", v["exR"], v["seR"], X_R, " R", 3))
    out.append(riga_zona("ECCESSO R a mercato (B-A)", v["exRm"], v["seRm"], X_R, " R", 3))
    out.append("    -> (descrittivo) segnale del falso %s | eccesso R %s" % (v["meccanismo"], v["pagamento"]))


def _lato_txt(lato):
    return "LONG" if lato == 1 else "SHORT"


def blocco_range(out, cfg, res):
    N = res["N"]
    out.append("#" * 78)
    out.append("# RANGE D'APERTURA DI %d MINUTI" % N)
    out.append("#" * 78)
    a, b, cl = res["A"], res["B"], res["classi"]
    out.append("giorni buoni con range valido %d (range MANCANTE %d, PIATTO %d)" %
               (res["giorni_ok"], res["MANCANTE"], res["PIATTO"]))
    out.append("ENTRATA A (primo tocco)   : LONG %d  SHORT %d  AMBIGUA(una barra tocca i due lati) %d  NESSUNA %d" %
               (a["LONG"], a["SHORT"], a["AMBIGUA"], a["NESSUNA"]))
    out.append("ENTRATA B (chiusura fuori): LONG %d  SHORT %d  NESSUNA (nessuna chiusura fuori in tutta la seduta) %d" %
               (b["LONG"], b["SHORT"], b["NESSUNA"]))
    out.append("COPPIE (esistono A e B)   : stesso lato LONG %d  stesso lato SHORT %d  LATI OPPOSTI %d" %
               (cl["LONG"], cl["SHORT"], cl["OPPOSTI"]))
    out.append("SOLO A (B non entra mai)  : %d giorni      SOLO B (A ambigua, B entra): %d      nessuna entrata: %d" %
               (cl["SOLO_A"], cl["SOLO_B"], cl["NESSUNO"]))
    out.append("  (le tabelle 'coppie' usano SOLO i giorni con tutte e due le entrate e lo STESSO lato;")
    out.append("   i giorni SOLO A sono le entrate che la chiusura M5 FILTRA: sono contati e descritti sotto)")
    out.append("")
    out.append("--- RIPRODUZIONE DELL'ANATOMIA (entrata A su TUTTI i giorni con tocco: deve coincidere con")
    out.append("    'prima rottura' dell'anatomia: n, sequenza +1R, barra di rottura che chiude dentro, falso15) ---")
    for lato in (1, -1):
        lst = res["entrate_a"][lato]
        c = agg_entrate(lst)
        dentro = len([x for x in lst if x["chiude_dentro"]])
        out.append("  %-5s n=%d%s  T %s%%  S %s%%  A %s%%  N %s%%  | chiude DENTRO %s%%  | falso15 %s%% (n=%d)" %
                   (_lato_txt(lato), c["n"], "*" if c["n"] < AM.SOGLIA_N else "",
                    AA.pct(c["T"], c["n"], 1), AA.pct(c["S"], c["n"], 1), AA.pct(c["A"], c["n"], 1),
                    AA.pct(c["N"], c["n"], 1), AA.pct(dentro, c["n"], 1), AA.pct(c["kf"], c["nf"], 1), c["nf"]))
        out.append("        identita': A con la barra del tocco che chiude FUORI = %d;  B sulla STESSA barra del tocco = %d"
                   % (c["n"] - dentro, len(res["sub"][_lato_txt(lato)]["S"])))
    out.append("")
    for lato in (1, -1):
        cella = res["celle"][lato]
        nome = _lato_txt(lato)
        out.append("=" * 78)
        out.append("%s, range %d min" % (nome, N))
        out.append("=" * 78)
        coppie = res["coppie"][lato]
        out.append("")
        out.append("  == COPPIE STESSO LATO: stessi giorni, n=%d%s (A e B esistono e sono %s) ==" %
                   (len(coppie), "*" if len(coppie) < AM.SOGLIA_N else "", nome))
        ca = agg_entrate([x[0] for x in coppie])
        cb = agg_entrate([x[1] for x in coppie])
        righe_due_colonne(out, ca, cb)
        dist = [x[1]["dist"] for x in coppie]
        distp = [x[1]["dist_pct"] for x in coppie]
        out.append("  distanza livello -> prezzo d'entrata B, punti  q25/q50/q75 : %s" % _q3(dist, 2))
        out.append("  idem in %% dell'ampiezza del range                 q25/q50/q75 : %s" % _q3(distp, 1))
        out.append("  R' di B / R' di A (rapporto)                     q25/q50/q75 : %s" %
                   _q3([x[1]["Rp"] / x[0]["Rp"] for x in coppie], 3))
        out.append("  ritardo di B dall'inizio della barra del tocco, minuti q25/q50/q75 : %s" %
                   _q3([(x[1]["k"] + 1 - x[0]["k"]) * 5 for x in coppie], 0))
        out.append("  ATTENZIONE: sulle coppie A e' AVVANTAGGIATA per costruzione (i giorni in cui B esiste sono quelli in cui il")
        out.append("  prezzo ha poi chiuso fuori: dopo l'entrata di A, prima di quella di B) e B ha meno falsi anche senza")
        out.append("  memoria (entra oltre il livello). I divari sulle COPPIE qui sotto NON sono il verdetto: il verdetto e' la")
        out.append("  differenza GREZZA fra le POLITICHE (tutte le entrate), piu' sotto. L'eccesso sul nullo e' solo DESCRIZIONE.")
        sp = cella["obsP"]
        out.append("  scarto sulle coppie: R lordo B-A %s (+-%s, 1 SE)  | falso A-B %s pt (+-%s)  | a mercato B-A %s" %
                   (_sgn(sp["dR"]), _f(sp["seR"]), _sgn(sp["dF"], 1), _f(sp["seF"], 1), _sgn(sp["dRm"])))
        out.append("  forchetta dell'ambiguita' sull'R lordo B-A: %s .. %s (ambigue come stop / come bersaglio)" %
                   (_sgn(sp["dR"]), _sgn(sp["dRh"])))
        out.append("")
        out.append("  -- decomposizione: B sulla STESSA barra del tocco (S: pura perdita di prezzo/ritardo)")
        out.append("     contro B su una barra PIU' TARDI (L: la barra del tocco chiudeva dentro = FILTRO) --")
        for sub, txt in (("S", "S stessa barra"), ("L", "L barra dopo ")):
            ss = res["sub"][nome][sub]
            sa = agg_entrate([x[0] for x in ss])
            sb = agg_entrate([x[1] for x in ss])
            out.append("     %-15s n=%-5d%s R lordo A %s  B %s  | falso A %s%%  B %s%% | T%% A %s  B %s | S%% A %s  B %s" %
                       (txt, sa["n"], "*" if sa["n"] < AM.SOGLIA_N else " ", _sgn(sa["R"]), _sgn(sb["R"]),
                        AA.pct(sa["kf"], sa["nf"], 1), AA.pct(sb["kf"], sb["nf"], 1),
                        AA.pct(sa["T"], sa["n"], 1), AA.pct(sb["T"], sb["n"], 1),
                        AA.pct(sa["S"], sa["n"], 1), AA.pct(sb["S"], sb["n"], 1)))
        out.append("")
        out.append("  == TUTTE LE ENTRATE %s (le due POLITICHE sugli stessi %d giorni validi: A tutte le sue" %
                   (nome, res["giorni_ok"]))
        out.append("     entrate, B tutte le sue; i giorni SOLO A sono in A e non in B) ==")
        ea = agg_entrate(res["entrate_a"][lato])
        eb = agg_entrate(res["entrate_b"][lato])
        righe_due_colonne(out, ea, eb)
        sa_ = agg_entrate(res["solo_a"][lato])
        out.append("  entrate A che B NON prende (giorni SOLO A, %s): n=%d%s  T %s%%  S %s%%  N %s%%  R lordo %s" %
                   (nome, sa_["n"], "*" if sa_["n"] < AM.SOGLIA_N else "", AA.pct(sa_["T"], sa_["n"], 1),
                    AA.pct(sa_["S"], sa_["n"], 1), AA.pct(sa_["N"], sa_["n"], 1), _sgn(sa_["R"])))
        sb_ = agg_entrate(res["solo_b"][lato])
        out.append("  entrate B senza A (A ambigua quel giorno, %s): n=%d%s  R lordo %s" %
                   (nome, sb_["n"], "*" if sb_["n"] < AM.SOGLIA_N else "", _sgn(sb_["R"])))
        out.append("")
        out.append("  == VERDETTO MECCANICO DELLA CELLA (soglie congelate in testa al file) ==")
        c = cella["comb"]
        blocco_politica(out, c["pol"])
        out.append("  (sotto: il NULLO a segni casuali, le COPPIE e l'eccesso del FALSO sono DESCRIZIONE e non decidono:")
        out.append("   le coppie non vedono il filtro e il falso di A contiene la chiusura che B usa come segnale;")
        out.append("   vedi report/CONFRONTO_TOCCO_CHIUSURA_M5_CRITERI.md par. 12)")
        blocco_verdetto(out, "sulle ENTRATE", cella["obsE"], cella["nullE"],
                        cella["vE"], "n=min(nA,nB)")
        blocco_verdetto(out, "sulle COPPIE", cella["obsP"], cella["nullP"],
                        cella["vP"], "n=coppie")
        out.append("  >>> CELLA %s range %d: PAGAMENTO %s (decide) | segnale del falso sul nullo %s (descrittivo)" %
                   (nome, N, c["pagamento"], c["meccanismo"]))
        out.append("  >>> LETTURA: %s" % c["lettura"])
        out.append("")
    if res["opposti"]:
        oa = agg_entrate([x[0] for x in res["opposti"]])
        ob = agg_entrate([x[1] for x in res["opposti"]])
        out.append("  == LATI OPPOSTI (A tocca da una parte, B chiude fuori dall'altra): n=%d ==" % oa["n"])
        righe_due_colonne(out, oa, ob)
        out.append("  (qui A e B non fanno la stessa scommessa: non entrano in nessuna cella del verdetto)")
        out.append("")
    cl_, cs_ = res["celle"][1]["comb"], res["celle"][-1]["comb"]
    out.append("  >>>>>> RANGE %d: %s" % (N, lettura_range(cl_, cs_)))
    out.append("")


def costruisci_referto(cfg, righe, res_per_range, diag, percorso, titolo, nota_fase, simbolo,
                       righe_fuso, righe_cal, rilievi, ctx, fase, verd_is=None):
    out = []
    add = out.append
    add("=" * 78)
    add(titolo)
    add("=" * 78)
    add("versione strumento : " + VERSIONE)
    add("file dati          : " + percorso)
    add("mercato            : NASDAQ (apertura cash Nasdaq 09:30 New York)")
    add("USO                : D-C = SOLO_PROVA_REGIME (feed HistData esterno, non BCM): nessuna ipotesi di")
    add("                     motore, nessun parametro, nessuna sedia, nessuna promozione escono da qui.")
    add("")
    add(nota_fase)
    add("")
    add("--- LEGGERE PRIMA DI CITARE UN NUMERO ---")
    add("  1. E' una DESCRIZIONE, non un backtest: niente PF, niente equity, NIENTE spread/costi/slippage.")
    add("     Ogni 'R lordo' e' LORDO. Una frequenza non e' un edge. Nessuna promozione.")
    add("  2. ENTRATA A = primo tocco del livello (la 'prima rottura' dell'anatomia, riprodotta). ENTRATA B =")
    add("     prima barra M5 che CHIUDE oltre il livello, entrata al close (piu' tardi e piu' lontano dal")
    add("     livello: dichiarato). Stop = bordo opposto in tutte e due; R' = distanza entrata-stop (B > A).")
    add("  3. Esito = sequenza sulle barre M5 fino a fine seduta: +1R' prima dello stop (T), stop prima (S),")
    add("     nessuno (N); barra con bersaglio e stop = A (ambigua). R lordo = T*(+1) + S*(-1) + N*0, A come")
    add("     stop. 'A mercato': i N chiusi al close dell'ultima barra. L'ordine DENTRO la barra non e' visibile.")
    add("  4. FALSO = una delle prime 3 chiusure M5 dopo l'entrata e' <= al livello (A: barre kA..kA+2;")
    add("     B: kB+1..kB+3). NON confrontare il falso di A con quello di B a occhio: B entra OLTRE il")
    add("     livello e A SUL livello, quindi anche in un mercato SENZA memoria B ha meno falsi. Il numero che")
    add("     si stampa e' l'ECCESSO sul NULLO (giorni surrogati con i segni delle barre tirati a sorte, K=%d per" % ctx.K)
    add("     giorno, seme fisso), ed e' DESCRITTIVO: il falso di A contiene la chiusura della barra del tocco,")
    add("     cioe' il segnale stesso di B, quindi NON misura il filtro. Non decide niente.")
    add("  5. IL VERDETTO e' UNO: la politica B contro la politica A sulle ENTRATE (tutte le entrate di A contro")
    add("     tutte quelle di B, stessi giorni validi), differenza GREZZA dell'R lordo e dell'R a mercato:")
    add("     PAGA se tutte e due >= %.2f R' con IC 95%% sopra zero; NON_PAGA se tutte e due con IC sotto %.2f;" %
        (X_R, X_R))
    add("     n >= %d entrate per politica. Le COPPIE (stessi giorni) sono DESCRIZIONE: sono selezionate da un" %
        N_MIN_CELLA)
    add("     evento che avviene dopo A e prima di B, e non vedono i giorni che la chiusura filtra.")
    add("     Vedi report/CONFRONTO_TOCCO_CHIUSURA_M5_CRITERI.md par. 6 e 12.")
    add("  6. Ogni percentuale porta il suo n. * = n < %d. Le COPPIE sono i giorni con A e B dello stesso lato." % AM.SOGLIA_N)
    add("")
    add("--- FUSO E APERTURA ---")
    for x in righe_cal:
        add(x)
    add("")
    for x in righe_fuso:
        add(x)
    add("")
    add("--- GIORNI: BUONI / SOSPETTI / SENZA APERTURA, PER ANNO ---")
    add("  %-6s %7s %7s %9s %9s" % ("ANNO", "GIORNI", "BUONI", "SOSPETTI", "NO-APERT"))
    for a in sorted(set(r["anno"] for r in righe)):
        gg = [r for r in righe if r["anno"] == a]
        add("  %-6d %7d %7d %9d %9d" % (a, len(gg), len([r for r in gg if r["stato"] == "OK"]),
                                        len([r for r in gg if r["stato"] == "SOSPETTO"]),
                                        len([r for r in gg if r["stato"] == "SENZA_APERTURA"])))
    add("")
    for N in cfg.ranges:
        blocco_range(out, cfg, res_per_range[N])
    add("#" * 78)
    add("# VERDETTI MECCANICI DI QUESTA FASE (%s)" % fase)
    add("#" * 78)
    for N in cfg.ranges:
        r = res_per_range[N]
        for lato in (1, -1):
            c = r["celle"][lato]["comb"]
            add("  range %2d %-5s: pagamento %-15s | %s   [falso sul nullo, descrittivo: %s]" %
                (N, _lato_txt(lato), c["pagamento"], c["lettura"], c["meccanismo"]))
        add("  range %2d      : %s" % (N, lettura_range(r["celle"][1]["comb"], r["celle"][-1]["comb"])))
    if verd_is is not None:
        add("")
        add("  CONFRONTO CON L'ADDESTRAMENTO (soglie identiche, congelate prima): cella per cella")
        for N in cfg.ranges:
            for lato in (1, -1):
                ci = verd_is[(N, lato)]
                cc = res_per_range[N]["celle"][lato]["comb"]["lettura"]
                add("    range %2d %-5s: addestramento '%s' | cassaforte '%s' -> %s" %
                    (N, _lato_txt(lato), ci, cc, "CONCORDE" if ci == cc else "DISCORDE"))
    add("")
    add("--- QUELLO CHE QUESTO STUDIO NON PUO' DIRE ---")
    add("  Non dice se un motore guadagnerebbe: niente spread, fill, costi, posizione. 'PAGA' = B batte A")
    add("  AL LORDO, non 'B guadagna'. Con un R' mediano di 15 punti (range 15) la frontiera stop >= 40 x")
    add("  spread e' sotto l'R' tipico se lo spread supera 0,375 punti [spread Nasdaq BCM: NON MISURATO qui].")
    add("  Vale per il regime di questa fase (addestramento 2010-2020: UN SOLO REGIME; cassaforte 2021-2026:")
    add("  un altro, con 2023 a poca copertura buona). Il close come prezzo d'entrata ignora slippage e gap.")
    add("  Il NULLO e' un modello di H_NIENTE (segni casuali barra per barra): e' DESCRIZIONE, non decide.")
    add("  Il verdetto dice SE la chiusura M5 rende di piu' del primo tocco, non PERCHE': il falso non separa")
    add("  il filtro dalla deriva (il falso di A contiene il segnale di B). Vicino alla soglia: INCERTO, non SI.")
    add("  L'entrata A e' AL LIVELLO (fill ideale di un pendente, anche se la barra del tocco lo ha attraversato")
    add("  con un salto); B paga il close reale: un B <= A puo' dipendere in parte dal fill ideale di A.")
    add("  Il verdetto e' PER OPERAZIONE (R medio per entrata, in unita' del proprio R'): B entra in meno giorni")
    add("  (i SOLO A) e con R' piu' largo, quindi 'B MEGLIO' NON vuol dire piu' R in totale ne' piu' punti: il")
    add("  numero di operazioni di ciascuna politica e' stampato accanto e va letto insieme al verdetto.")
    add("")
    add("--- RILIEVI DI QUESTA CORSA ---")
    if not rilievi:
        add("  nessuno")
    for x in rilievi:
        add("  - " + x)
    add("")
    add("ESITO: " + ("OK" if not rilievi else "MISURATO CON RILIEVI (%d)" % len(rilievi)))
    return out


# =====================================================================
#  CSV PER GIORNO
# =====================================================================
def colonne_csv(cfg):
    base = ["data", "anno", "fase", "stato", "gruppo", "px_apertura"]
    per = ["Ar", "A_lato", "A_k", "A_seq", "A_R", "A_Rm", "A_falso", "A_Rp", "A_chiude_dentro",
           "B_lato", "B_k", "B_seq", "B_R", "B_Rm", "B_falso", "B_Rp", "B_dist", "B_dist_pct", "classe", "sub"]
    cols = list(base)
    for N in cfg.ranges:
        cols += ["N%d_%s" % (N, c) for c in per]
    return cols


def riga_csv(cfg, r):
    v = [r["data"], r["anno"], r["fase"], r["stato"], r["gruppo"], r.get("px")]
    for N in cfg.ranges:
        rec = r.get("cmp", {}).get(N)
        if rec is None:
            v += [""] * 20
            continue
        a, b = rec["A"], rec["B"]
        cl, sub = classe_giorno(rec) if rec["stato"] == "OK" else (rec["stato"], "")
        v += [rec.get("Ar")]
        v += ([a["lato"], a["k"], a["seq"], a["R"], a["Rm"], a["falso"], a["Rp"], a["chiude_dentro"]]
              if a else [rec["A_txt"], "", "", "", "", "", "", ""])
        v += ([b["lato"], b["k"], b["seq"], b["R"], b["Rm"], b["falso"], b["Rp"], b["dist"], b["dist_pct"]]
              if b else ["NESSUNA", "", "", "", "", "", "", "", ""])
        v += [cl, sub]
    return ",".join(AM._v(x, 5) for x in v)


# =====================================================================
#  CORSA VERA
# =====================================================================
def costruisci_parser():
    ap = argparse.ArgumentParser(
        description="Confronto ENTRATA AL PRIMO TOCCO / ENTRATA ALLA CHIUSURA M5 FUORI dal range "
                    "d'apertura (Nasdaq). NON e' un backtest: niente PF, niente equity, niente costi.")
    ap.add_argument("--file", default="", help="CSV Formato 1 (Time,Open,High,Low,Close,Volume), ora di New York")
    ap.add_argument("--simbolo", default="NASUSD", help="per i nomi dei file prodotti")
    ap.add_argument("--uscita", default="", help="cartella dei referti e del CSV per-giorno")
    ap.add_argument("--autotest", action="store_true")
    ap.add_argument("--surrogati", type=int, default=K_SURR_DEFAULT, help="K surrogati per giorno (il nullo)")
    ap.add_argument("--seme", type=int, default=SEME_DEFAULT)
    ap.add_argument("--ranges", default=RANGES_DEFAULT, help="minuti, multipli di 5 (default 15,30)")
    ap.add_argument("--addestramento", default=None, help="AAAA-AAAA (default 2010-2020)")
    ap.add_argument("--cassaforte", default=None, help="AAAA-AAAA (default 2021-2026)")
    ap.add_argument("--senza-calibrazione", dest="senza_calibrazione", action="store_true")
    ap.add_argument("--min-giorni-anno", dest="min_giorni_anno", default="150")
    ap.add_argument("--min-giorni-calibra", dest="min_giorni_calibra", default="30")
    return ap


def config_anatomia(args):
    """La Config dell'anatomia (Nasdaq), con i soli parametri che servono qui.
    Buffer 0 (default dell'anatomia): 'primo tocco di livello + buffer 0'."""
    argv = ["--mercato", "NASDAQ", "--ranges", args.ranges, "--bersagli", "1",
            "--offset-retest", "0", "--scadenze", "30", "--scadenza-ref", "30",
            "--min-giorni-anno", str(args.min_giorni_anno),
            "--min-giorni-calibra", str(args.min_giorni_calibra)]
    if args.addestramento is not None:
        argv += ["--addestramento", args.addestramento]
    if args.cassaforte is not None:
        argv += ["--cassaforte", args.cassaforte]
    if args.senza_calibrazione:
        argv += ["--senza-calibrazione"]
    return AM.Config(AM.costruisci_parser().parse_args(argv))


def _rilievi_potere(res_per_range, fase, cfg):
    """Le celle in cui il VERDETTO (politiche, grezzo) non si puo' dare o non si
    puo' risolvere alla soglia. Le coppie e il falso sono descrittivi: niente rilievo."""
    out = []
    for N in cfg.ranges:
        for lato in (1, -1):
            pol = res_per_range[N]["celle"][lato]["comb"]["pol"]
            if pol["n"] < N_MIN_CELLA:
                out.append("%s range %d %s (entrate): n=%d < %d, NON GIUDICABILE" %
                           (fase, N, _lato_txt(lato), pol["n"], N_MIN_CELLA))
                continue
            for nome, se in (("R lordo", pol["seR"]), ("R a mercato", pol["seRm"])):
                if se is not None and Z95 * se >= X_R:
                    out.append("%s range %d %s (entrate): IC95 della differenza %s (%.3f) >= soglia %.2f: "
                               "pagamento non risolvibile" % (fase, N, _lato_txt(lato), nome, Z95 * se, X_R))
    return out


# Bersagli di riproduzione dell'entrata A: 'prima rottura' dell'anatomia, ADDESTRAMENTO Nasdaq 2010-2020
# (risultati_archivio/ANATOMIA_MOVIMENTI_M5_2026-09-29/NASUSD/..._IS_2010_2020.txt, righe 91 e 457).
BERSAGLI_A_IS = {(15, 1): 1267, (15, -1): 1214, (30, 1): 1348, (30, -1): 1135}


def controlla_bersagli(res_per_range, cfg, simbolo):
    """Il feed e' quello dell'anatomia del 29/09? Confronta n di A (LONG/SHORT) con i
    numeri in archivio. Torna la lista dei rilievi (vuota = coincide o non applicabile)."""
    if simbolo != "NASUSD" or tuple(cfg.per_is or ()) != (2010, 2020):
        return []
    out = []
    for (N, lato), atteso in sorted(BERSAGLI_A_IS.items()):
        if N not in res_per_range:
            continue
        visto = res_per_range[N]["A"][_lato_txt(lato)]
        if visto != atteso:
            out.append("RIPRODUZIONE: range %d %s entrata A n=%d, l'anatomia del 29/09 ne ha %d: il CSV non e' "
                       "quello dell'anatomia (o il pin e' un altro). I numeri si leggono SOLO dopo aver capito "
                       "perche'" % (N, _lato_txt(lato), visto, atteso))
    return out


def esegui(args):
    """La corsa vera. Torna il codice d'uscita 0/1/2."""
    ok, righe_sha = verifica_anatomia()
    for x in righe_sha:
        log(" " + x)
    if not ok:
        log("!!! IL FILE DELL'ANATOMIA NON E' QUELLO DEL PIN: non si misura con uno strumento "
            "appoggiato a un altro strumento. Non si parte.")
        return 2
    try:
        cfg = config_anatomia(args)
    except (ValueError, TypeError) as e:
        log("!!! PARAMETRI NON VALIDI: %s" % e)
        return 2
    if cfg.problemi:
        log("!!! PARAMETRI INCOERENTI:")
        for p in cfg.problemi:
            log("    - " + p)
        return 2
    if args.surrogati < 1:
        log("!!! --surrogati deve essere >= 1 (il nullo e' parte del criterio)")
        return 2
    if not args.file:
        log("!!! MANCA --file")
        return 2
    percorso = args.file
    if not os.path.exists(percorso):
        log("!!! IL FILE NON ESISTE: " + percorso)
        return 2
    forma, prima = AA.riconosci_formato(percorso)
    if forma != "FORMATO1":
        log("!!! IL FILE C'E' MA NON E' NEL FORMATO GIUSTO: %s (formato %s, prima riga %s)" %
            (percorso, forma, str(prima)[:100]))
        log("    Atteso il Formato 1: Time,Open,High,Low,Close,Volume con 'AAAA.MM.GG HH:MM'.")
        return 2
    cartella = args.uscita or os.path.dirname(os.path.abspath(percorso))
    os.makedirs(cartella, exist_ok=True)
    log(" file      : " + percorso)
    log(" periodi   : addestramento %s   cassaforte %s" %
        (cfg.per_is, cfg.per_cs if cfg.per_cs else "NESSUNA"))
    log(" range     : %s min   surrogati per giorno %d   seme %d" % (cfg.ranges, args.surrogati, args.seme))
    log(" verdetto  : politica B - politica A sulle entrate, GREZZO, R lordo e a mercato >= %.2f, entrate >= %d, "
        "IC 95%% (nullo, coppie e falso: descrittivi)" % (X_R, N_MIN_CELLA))
    log("")
    rilievi = []
    aperture = {}
    if cfg.calibra:
        log(" prima passata: calibrazione dell'ora d'apertura ...")
        esito, righe_cal, ril_cal = AM.calibra_apertura(cfg, percorso)
        for x in righe_cal:
            log(x)
        rilievi += ril_cal
        aperture = dict((k, x["usata"]) for k, x in esito.items())
        if not aperture:
            log("!!! CALIBRAZIONE IMPOSSIBILE: nessun dato nelle finestre attese. Si ferma.")
            return 2
    else:
        righe_cal = ["  calibrazione DISATTIVATA (--senza-calibrazione): si usa l'ipotesi del calendario."]
        rilievi.append("calibrazione dell'apertura disattivata: l'ora d'apertura e' un'ipotesi, non una misura")
    log("")
    log(" seconda passata: lettura in streaming + confronto + nullo ...")
    ctx = Contesto(cfg, args.surrogati, args.seme)
    with Gancio(ctx):
        giorni, diag = AM.scandisci(cfg, percorso, aperture)
    if AM.analizza_giorno.__name__ == "con_gancio":
        log("!!! IL GANCIO NON E' STATO RIMOSSO: errore interno. Non si continua.")
        return 2
    if diag["barre"] == 0 or not giorni:
        log("!!! ZERO GIORNI ANALIZZABILI dentro i periodi dichiarati (barre lette %d)." % diag["barre"])
        return 2
    buoni = [r for r in giorni if r["stato"] == "OK"]
    log(" barre lette %d   giorni analizzati %d: BUONI %d   SOSPETTI %d   SENZA APERTURA %d" %
        (diag["barre"], len(giorni), len(buoni), len([r for r in giorni if r["stato"] == "SOSPETTO"]),
         len([r for r in giorni if r["stato"] == "SENZA_APERTURA"])))
    if ctx.incoerenze:
        log("!!! INCOERENZA CON L'ANATOMIA in %d giorni-range (la 'prima rottura' di questo strumento non "
            "coincide con quella dell'anatomia). Confronto INVALIDO, nessun referto." % ctx.incoerenze)
        for x in ctx.esempi:
            log("    " + x)
        return 2
    righe_fuso, ril_fuso = AA.canarino_fuso(diag)
    rilievi += ril_fuso
    if diag["fuori_ordine"]:
        rilievi.append("%d righe FUORI ORDINE nel file" % diag["fuori_ordine"])
    if diag.get("duplicate"):
        rilievi.append("%d barre M1 duplicate nella seduta (tenuta la prima)" % diag["duplicate"])
    if diag["date_ripetute"]:
        rilievi.append("%d date ricompaiono dopo essere state chiuse" % diag["date_ripetute"])
    for anno in sorted(set(r["anno"] for r in giorni)):
        gg = [r for r in giorni if r["anno"] == anno]
        s = len([r for r in gg if r["stato"] == "SOSPETTO"])
        m = len([r for r in gg if r["stato"] in ("OK", "SOSPETTO")])
        if m and 100.0 * s / m > cfg.quota_sospetti:
            rilievi.append("anno %d: %.1f%% di giorni sospetti (soglia %.1f%%): pochi giorni buoni" %
                           (anno, 100.0 * s / m, cfg.quota_sospetti))
    if not buoni:
        rilievi.append("NESSUN giorno buono")
    prodotti = []
    nome_csv = "CONFRONTO_TOCCO_CHIUSURA_M5_PERGIORNO_%s.csv" % args.simbolo
    percorso_csv = os.path.join(cartella, nome_csv)
    AA.scrivi_atomico(percorso_csv, [",".join(colonne_csv(cfg))] + [riga_csv(cfg, r) for r in giorni])
    log(" CSV per-giorno: %s (%d righe)" % (percorso_csv, len(giorni)))
    blocchi = []
    if cfg.per_is:
        blocchi.append(("IS", cfg.per_is,
                        "QUESTO E' IL FILE DELL'ADDESTRAMENTO (%d-%d): le soglie sono congelate PRIMA dei numeri e "
                        "si pronunciano SOLO su questa fase; UN SOLO REGIME. Feed esterno: nessuna ipotesi di motore."
                        % cfg.per_is,
                        "CONFRONTO TOCCO/CHIUSURA M5 -- %s -- ADDESTRAMENTO %d-%d" %
                        (args.simbolo, cfg.per_is[0], cfg.per_is[1])))
    if cfg.per_cs:
        blocchi.append(("CASSAFORTE", cfg.per_cs,
                        "QUESTA E' LA CASSAFORTE (%d-%d). NON SI GUARDA per costruire ipotesi o ritoccare soglie: "
                        "VALIDA le soglie gia' congelate. Un verdetto qui che non concorda con l'addestramento "
                        "NON e' confermato." % cfg.per_cs,
                        "CONFRONTO TOCCO/CHIUSURA M5 -- %s -- CASSAFORTE %d-%d  [NON PER LE IPOTESI]" %
                        (args.simbolo, cfg.per_cs[0], cfg.per_cs[1])))
    verd_is = None
    riepilogo = []
    for fase, per, nota, titolo in blocchi:
        sotto = [r for r in giorni if r["fase"] == fase]
        if not sotto:
            rilievi.append("nessun giorno nel periodo %s: referto non prodotto" % fase)
            continue
        res = dict((N, aggrega(ctx, sotto, N)) for N in cfg.ranges)
        if fase == "IS":
            rilievi += controlla_bersagli(res, cfg, args.simbolo)
        ril_fase = rilievi + _rilievi_potere(res, fase, cfg)
        testo = costruisci_referto(cfg, sotto, res, diag, percorso, titolo, nota, args.simbolo,
                                   righe_fuso, righe_cal, ril_fase, ctx, fase,
                                   verd_is if fase == "CASSAFORTE" else None)
        nome = "CONFRONTO_TOCCO_CHIUSURA_M5_%s_%s_%d_%d.txt" % (args.simbolo, fase, per[0], per[1])
        pr = os.path.join(cartella, nome)
        AA.scrivi_atomico(pr, testo)
        prodotti.append(pr)
        log(" referto: " + pr)
        for x in _rilievi_potere(res, fase, cfg):
            rilievi.append(x)
        if fase == "IS":
            verd_is = {}
            for N in cfg.ranges:
                for lato in (1, -1):
                    verd_is[(N, lato)] = res[N]["celle"][lato]["comb"]["lettura"]
        for N in cfg.ranges:
            for lato in (1, -1):
                c = res[N]["celle"][lato]["comb"]
                riepilogo.append("  %-10s range %2d %-5s: %s" % (fase, N, _lato_txt(lato), c["lettura"]))
    picco = AA.ram_picco_mb()
    log(" RAM di picco: %s" % ("non misurabile" if picco is None else "%.0f MB" % picco))
    log("")
    log(" VERDETTI MECCANICI (descrizioni, non promozioni; soglie congelate prima dei numeri):")
    for x in riepilogo:
        log(x)
    log("")
    log(" FILE PRODOTTI:")
    for p in [percorso_csv] + prodotti:
        log("   " + os.path.basename(p))
    if rilievi:
        log(" ESITO: MISURATO CON RILIEVI -- %d" % len(rilievi))
        for x in rilievi:
            log("   - " + x)
        return 1
    log(" ESITO: OK")
    return 0


def main():
    args = costruisci_parser().parse_args()
    log("=====================================================================")
    log(" CONFRONTO TOCCO / CHIUSURA M5 -- %s (DESCRITTIVO)" % VERSIONE)
    log("=====================================================================")
    log(" NON e' un backtest: niente PF, niente equity, niente costi, niente motori.")
    log("")
    if args.autotest:
        return autotest()
    return esegui(args)


# =====================================================================
#  AUTOTEST: giorni SINTETICI con risposta nota. Nessun file vero.
# =====================================================================
class _Verifiche(object):
    def __init__(self):
        self.n = 0
        self.ok = 0
        self.falliti = []

    def check(self, nome, cond, dettaglio=""):
        self.n += 1
        if cond:
            self.ok += 1
        else:
            self.falliti.append("%s %s" % (nome, dettaglio))

    def uguale(self, nome, a, b, tol=1e-9):
        if isinstance(a, float) or isinstance(b, float):
            cond = a is not None and b is not None and abs(a - b) <= tol
        else:
            cond = (a == b)
        self.check(nome, cond, "atteso %r ottenuto %r" % (b, a))


def _args_test(extra=None):
    argv = ["--ranges", "5,15", "--min-giorni-anno", "1", "--min-giorni-calibra", "3"]
    if extra:
        argv += extra
    return costruisci_parser().parse_args(argv)


def _cfg_test(extra=None):
    return config_anatomia(_args_test(extra))


def m5_da_barre(cfg, barre):
    """M5 (o,h,l,c,5) da un dizionario k -> (o,h,l,c): passa per le M1 e per
    l'aggregazione VERA dell'anatomia (esatta per costruzione)."""
    return AM.m5_da_m1(AM.m1_da_m5(barre, cfg.K), cfg.K)


def _piatte(da, prezzo, K=78):
    return dict((k, (prezzo, prezzo, prezzo, prezzo)) for k in range(da, K))


RANGE5 = (1000.0, 1010.0, 990.0, 1000.0)      # barra 0: RH 1010, RL 990, ampiezza 20


def casi_a_mano():
    """(nome, barre) dei giorni di prova con RISPOSTA CALCOLATA A MANO."""
    c = {}
    b = {0: RANGE5, 1: (1000.0, 1015.0, 1000.0, 1008.0)}
    b.update(_piatte(2, 1006.0))
    c["C1_tocca_senza_chiudere_fuori"] = b
    b = {0: RANGE5, 1: (1000.0, 1015.0, 1000.0, 1012.0), 2: (1012.0, 1040.0, 1010.0, 1035.0)}
    b.update(_piatte(3, 1035.0))
    c["C2_chiusura_fuori_stessa_barra_del_tocco"] = b
    b = {0: RANGE5, 1: (1000.0, 1015.0, 1000.0, 1008.0), 2: (1008.0, 1020.0, 1007.0, 1018.0),
         3: (1018.0, 1035.0, 1015.0, 1030.0), 4: (1030.0, 1030.0, 985.0, 986.0)}
    b.update(_piatte(5, 986.0))
    c["C3_chiusura_fuori_una_barra_dopo"] = b
    c["C4_specchio_di_C3"] = AM.specchia(c["C3_chiusura_fuori_una_barra_dopo"])
    c["C5_ambigua_senza_chiusura_fuori"] = {0: RANGE5, 1: (1000.0, 1015.0, 985.0, 1000.0)}
    b = {0: RANGE5, 1: (1000.0, 1015.0, 985.0, 1000.0), 2: (1000.0, 1013.0, 1000.0, 1012.0)}
    b.update(_piatte(3, 1012.0))
    c["C5b_ambigua_poi_chiude_fuori"] = b
    c["C6_nessuna_rottura"] = {0: RANGE5, 1: (1000.0, 1008.0, 992.0, 1000.0), 2: (1000.0, 1005.0, 995.0, 1000.0)}
    c["C7_range_degenere"] = {0: (1000.0, 1000.0, 1000.0, 1000.0)}
    b = {0: RANGE5, 1: (1000.0, 1015.0, 1000.0, 1008.0), 2: (1008.0, 1008.0, 975.0, 980.0)}
    b.update(_piatte(3, 980.0))
    c["C8_lati_opposti"] = b
    b = {0: RANGE5, 1: (1000.0, 1015.0, 1000.0, 1012.0), 2: (1012.0, 1040.0, 988.0, 1012.0)}
    b.update(_piatte(3, 1012.0))
    c["C9_bersaglio_e_stop_stessa_barra"] = b
    b = {0: RANGE5}
    for k in range(1, 77):
        b[k] = (1000.0, 1004.0, 996.0, 1000.0)
    b[77] = (1000.0, 1015.0, 1000.0, 1012.0)
    c["C11_entrata_sull_ultima_barra"] = b
    b = {0: RANGE5, 1: (1000.0, 1012.0, 1000.0, 1010.0)}
    b.update(_piatte(2, 1005.0))
    c["C13_chiusura_esattamente_sul_livello"] = b
    b = {0: RANGE5, 1: (1000.0, 1015.0, 1000.0, 1012.0), 2: (1012.0, 1030.0, 1012.0, 1025.0),
         3: (1025.0, 1030.0, 1025.0, 1025.0), 4: (1025.0, 1025.0, 1005.0, 1008.0)}
    b.update(_piatte(5, 1008.0))
    c["C15_falso_solo_alla_terza_chiusura"] = b
    b = {0: RANGE5, 1: (1000.0, 1040.0, 1000.0, 1012.0)}
    b.update(_piatte(2, 1012.0))
    c["C16_bersaglio_di_B_toccato_nella_barra_d_entrata"] = b
    b = {0: RANGE5, 1: (1000.0, 1015.0, 1000.0, 1012.0), 2: (1012.0, 1033.0, 1010.0, 1020.0)}
    b.update(_piatte(3, 1020.0))
    c["C17_bersaglio_di_B_piu_lontano_di_quello_di_A"] = b
    return c


def esegui_casi(cfg, v):
    """Tutti i controlli a risposta nota. Riusata dalle MUTAZIONI: con una
    convenzione cambiata almeno un controllo deve fallire."""
    casi = casi_a_mano()

    def rec_di(nome, N=5, buchi=()):
        m5 = m5_da_barre(cfg, casi[nome])
        for k in buchi:
            m5[k] = None
        return misura_range(cfg, m5, N)

    # ---- C1: tocca senza chiudere fuori
    r = rec_di("C1_tocca_senza_chiudere_fuori")
    v.uguale("C1: ampiezza 20", r["Ar"], 20.0)
    v.uguale("C1: A e' LONG alla barra 1", (r["A_txt"], r["A"]["k"]), ("LONG", 1))
    v.check("C1: B non esiste (nessuna chiusura oltre 1010)", r["B"] is None)
    v.uguale("C1: A sequenza N (ne' 1030 ne' 990)", r["A"]["seq"], "N")
    v.uguale("C1: A R lordo 0 (timeout)", r["A"]["R"], 0.0)
    v.uguale("C1: A R a mercato (1006-1010)/20 = -0,2", r["A"]["Rm"], -0.2)
    v.uguale("C1: A falso (chiusure 1008,1006,1006)", r["A"]["falso"], True)
    v.uguale("C1: A la barra del tocco chiude DENTRO", r["A"]["chiude_dentro"], True)
    v.uguale("C1: classe SOLO_A", classe_giorno(r)[0], "SOLO_A")
    # ---- C2: chiusura fuori sulla STESSA barra del tocco
    r = rec_di("C2_chiusura_fuori_stessa_barra_del_tocco")
    a, b = r["A"], r["B"]
    v.uguale("C2: A alla barra 1", a["k"], 1)
    v.uguale("C2: B alla stessa barra 1", b["k"], 1)
    v.uguale("C2: R' di A = 20", a["Rp"], 20.0)
    v.uguale("C2: R' di B = 1012-990 = 22", b["Rp"], 22.0)
    v.uguale("C2: distanza livello-entrata B = 2", b["dist"], 2.0)
    v.uguale("C2: distanza in % del range = 10", b["dist_pct"], 10.0)
    v.uguale("C2: A sequenza T (1040 >= 1030 alla barra 2)", a["seq"], "T")
    v.uguale("C2: B sequenza T (1040 >= 1034 alla barra 2)", b["seq"], "T")
    v.uguale("C2: A falso False (chiusure 1012,1035,1035)", a["falso"], False)
    v.uguale("C2: B falso False (chiusure 1035 x3)", b["falso"], False)
    v.uguale("C2: classe LONG sottoclasse S", classe_giorno(r), ("LONG", "S"))
    # ---- C3: chiusura fuori UNA BARRA DOPO; A vince prima, B stoppata
    r = rec_di("C3_chiusura_fuori_una_barra_dopo")
    a, b = r["A"], r["B"]
    v.uguale("C3: A alla barra 1, B alla barra 2", (a["k"], b["k"]), (1, 2))
    v.uguale("C3: A chiude dentro alla barra del tocco", a["chiude_dentro"], True)
    v.uguale("C3: R' di B = 1018-990 = 28", b["Rp"], 28.0)
    v.uguale("C3: A sequenza T (alla barra 3, hi 1035 >= 1030)", a["seq"], "T")
    v.uguale("C3: B sequenza S (bersaglio 1046 mai visto, lo stop 990 alla barra 4)", b["seq"], "S")
    v.uguale("C3: R lordo A = +1, B = -1", (a["R"], b["R"]), (1.0, -1.0))
    v.uguale("C3: distanza B = 8 punti = 40% del range", (b["dist"], b["dist_pct"]), (8.0, 40.0))
    v.uguale("C3: A falso True (chiusure 1008,1018,1030: la prima e' <= 1010)", a["falso"], True)
    v.uguale("C3: B falso True (chiusure barre 3,4,5 = 1030,986,986)", b["falso"], True)
    v.uguale("C3: classe LONG sottoclasse L", classe_giorno(r), ("LONG", "L"))
    # ---- C4: specchio di C3 -> stessi numeri sul lato opposto
    r4 = rec_di("C4_specchio_di_C3")
    a4, b4 = r4["A"], r4["B"]
    v.uguale("C4 specchio: lato SHORT per A e B", (a4["lato"], b4["lato"]), (-1, -1))
    for ch in ("k", "seq", "R", "Rm", "Rp", "falso", "chiude_dentro"):
        v.uguale("C4 specchio: A %s uguale a C3" % ch, a4[ch], a[ch])
    for ch in ("k", "seq", "R", "Rm", "Rp", "falso", "dist", "dist_pct"):
        v.uguale("C4 specchio: B %s uguale a C3" % ch, b4[ch], b[ch])
    # ---- C5: barra ambigua (tocca i due lati)
    r = rec_di("C5_ambigua_senza_chiusura_fuori")
    v.uguale("C5: A_txt AMBIGUA", r["A_txt"], "AMBIGUA")
    v.check("C5: nessuna entrata A", r["A"] is None)
    v.check("C5: nessuna entrata B (chiude a 1000, dentro)", r["B"] is None)
    v.uguale("C5: classe NESSUNO", classe_giorno(r)[0], "NESSUNO")
    r = rec_di("C5b_ambigua_poi_chiude_fuori")
    v.check("C5b: A ambigua = niente entrata A", r["A"] is None and r["A_txt"] == "AMBIGUA")
    v.uguale("C5b: B esiste alla barra 2 (LONG)", (r["B"]["k"], r["B"]["lato"]), (2, 1))
    v.uguale("C5b: classe SOLO_B", classe_giorno(r)[0], "SOLO_B")
    # ---- C6 / C7
    r = rec_di("C6_nessuna_rottura")
    v.uguale("C6: nessuna rottura A_txt", r["A_txt"], "NESSUNA")
    v.check("C6: nessuna B", r["B"] is None and r["A"] is None)
    r = rec_di("C7_range_degenere")
    v.uguale("C7: range piatto PIATTO", r["stato"], "PIATTO")
    v.check("C7: nessuna entrata", r["A"] is None and r["B"] is None)
    # ---- C8: lati opposti
    r = rec_di("C8_lati_opposti")
    v.uguale("C8: A LONG barra 1", (r["A_txt"], r["A"]["k"]), ("LONG", 1))
    v.uguale("C8: B SHORT barra 2 (close 980 < 990)", (r["B"]["lato"], r["B"]["k"]), (-1, 2))
    v.uguale("C8: R' di B = 1010-980 = 30", r["B"]["Rp"], 30.0)
    v.uguale("C8: A stoppata (lo stop 990 alla barra 2)", r["A"]["seq"], "S")
    v.uguale("C8: B nessun esito, a mercato 0", (r["B"]["seq"], r["B"]["Rm"]), ("N", 0.0))
    v.uguale("C8: classe OPPOSTI", classe_giorno(r)[0], "OPPOSTI")
    # ---- C9: bersaglio e stop nella stessa barra
    r = rec_di("C9_bersaglio_e_stop_stessa_barra")
    v.uguale("C9: A ambigua (1040 >= 1030 e 988 <= 990)", r["A"]["seq"], "A")
    v.uguale("C9: B ambigua (1040 >= 1034 e 988 <= 990)", r["B"]["seq"], "A")
    v.uguale("C9: A come stop -1 / come bersaglio +1", (r["A"]["R"], r["A"]["Rh"]), (-1.0, 1.0))
    # ---- C11: entrata sull'ultima barra
    r = rec_di("C11_entrata_sull_ultima_barra")
    v.uguale("C11: A alla barra 77", r["A"]["k"], 77)
    v.uguale("C11: B alla barra 77", r["B"]["k"], 77)
    v.uguale("C11: B senza barre dopo: N, a mercato 0", (r["B"]["seq"], r["B"]["Rm"]), ("N", 0.0))
    v.check("C11: falso B non valutabile (finestra fuori seduta)", r["B"]["falso"] is None)
    v.check("C11: falso A non valutabile (finestra fuori seduta)", r["A"]["falso"] is None)
    v.uguale("C11: A a mercato (1012-1010)/20 = 0,1", r["A"]["Rm"], 0.1)
    # ---- C13: chiusura ESATTAMENTE sul livello NON e' "fuori"
    r = rec_di("C13_chiusura_esattamente_sul_livello")
    v.uguale("C13: A tocca (hi 1012 >= 1010)", r["A_txt"], "LONG")
    v.check("C13: B non esiste (close 1010 non e' oltre 1010)", r["B"] is None)
    # ---- C15: il falso di B si vede solo alla TERZA chiusura dopo l'entrata
    r = rec_di("C15_falso_solo_alla_terza_chiusura")
    v.uguale("C15: B alla barra 1 (close 1012)", r["B"]["k"], 1)
    v.uguale("C15: B falso True (chiusure barre 2,3,4 = 1025,1025,1008)", r["B"]["falso"], True)
    v.uguale("C15: A falso False (chiusure barre 1,2,3 = 1012,1025,1025)", r["A"]["falso"], False)
    # ---- C16: il bersaglio di B nella barra d'entrata NON conta (l'entrata e' al close)
    r = rec_di("C16_bersaglio_di_B_toccato_nella_barra_d_entrata")
    v.uguale("C16: A sequenza T (hi 1040 >= 1030 nella barra del tocco)", r["A"]["seq"], "T")
    v.uguale("C16: B sequenza N (hi 1040 e' PRIMA dell'entrata al close)", r["B"]["seq"], "N")
    # ---- C17: il bersaglio di B e' a +1 R' (22), non a +1 ampiezza (20)
    r = rec_di("C17_bersaglio_di_B_piu_lontano_di_quello_di_A")
    v.uguale("C17: A sequenza T (1033 >= 1030)", r["A"]["seq"], "T")
    v.uguale("C17: B sequenza N (1033 < 1034)", r["B"]["seq"], "N")
    v.uguale("C17: B a mercato (1020-1012)/22", r["B"]["Rm"], 8.0 / 22.0)
    # ---- invarianti per costruzione, su tutti i casi a mano
    for nome_c in casi:
        for N_c in (5, 15):
            rc_ = misura_range(cfg, m5_da_barre(cfg, casi[nome_c]), N_c)
            v.check("invarianti A/B nel caso %s (range %d)" % (nome_c, N_c), invarianti(rc_) == [], str(invarianti(rc_)))
    # un guasto costruito a mano: B PRIMA di A viene visto
    guasto = {"A": {"k": 4, "chiude_dentro": True, "lato": 1, "Rp": 20.0},
              "B": {"k": 3, "lato": 1, "Rp": 22.0}}
    v.check("invarianti: B prima di A e' un guasto", any("prima di A" in x for x in invarianti(guasto)))
    guasto["B"]["k"] = 4
    v.check("invarianti: B sulla barra del tocco che chiude DENTRO e' un guasto",
            any("chiude dentro" in x for x in invarianti(guasto)))
    # ---- barre vuote: il falso di B senza nessuna chiusura in finestra non e' un dato
    r = rec_di("C2_chiusura_fuori_stessa_barra_del_tocco", buchi=(2, 3, 4))
    v.check("buchi: nessuna chiusura in finestra -> falso B non valutabile", r["B"]["falso"] is None)
    # ---- range di 15 minuti: le barre 0-2 sono il range
    b15 = {0: (1000.0, 1004.0, 998.0, 1002.0), 1: (1002.0, 1010.0, 1001.0, 1006.0),
           2: (1006.0, 1008.0, 990.0, 992.0), 3: (992.0, 1012.0, 992.0, 1011.0)}
    b15.update(_piatte(4, 1011.0))
    r = misura_range(cfg, m5_da_barre(cfg, b15), 15)
    v.uguale("range 15: le barre 0-2 fanno il range, ampiezza 1010-990 = 20", r["Ar"], 20.0)
    v.uguale("range 15: A e B alla barra 3 (offset 15)", (r["A"]["k"], r["B"]["k"]), (3, 3))
    return casi


def _gen_barre_casuali(rng, K=78, sigma=3.0):
    """Random walk di barre M5 (o,h,l,c) per il fuzz contro l'anatomia."""
    barre = {}
    p = 1000.0
    for k in range(K):
        c = p + rng.gauss(0, sigma * (1.0 + (2.0 if k < 6 else 0.0)))
        h = max(p, c) + abs(rng.gauss(0, sigma * 0.5))
        l = min(p, c) - abs(rng.gauss(0, sigma * 0.5))
        barre[k] = (p, h, l, c)
        p = c
    return barre


def fuzz_contro_anatomia(cfg, giorni, seme):
    """Giorni casuali (anche con buchi dopo la prima ora) attraverso l'anatomia
    VERA e questo strumento: la 'prima rottura' deve coincidere GIORNO PER
    GIORNO. Torna (n_confrontati, differenze, n_lati)."""
    rng = random.Random(seme)
    diffs = []
    n = 0
    lati = {"LONG": 0, "SHORT": 0, "AMBIGUA": 0, "NESSUNA": 0}
    for i in range(giorni):
        barre = _gen_barre_casuali(rng, cfg.K, sigma=rng.choice([1.0, 3.0, 8.0]))
        buchi = []
        if rng.random() < 0.3:
            k = rng.randint(14, 70)
            buchi = list(range(5 * k, 5 * k + 5 * rng.randint(1, 3)))
        g = AM.giorno_sint(cfg, "2015.%02d.%02d" % (1 + (i // 28) % 12, 1 + i % 28), barre, buchi=tuple(buchi),
                           prec=1000.0)
        r = AM.analizza_giorno(cfg, g)
        if r["stato"] != "OK":
            continue
        m5 = AM.m5_da_m1(g["m1"], cfg.K)
        for N in cfg.ranges:
            rec = misura_range(cfg, m5, N)
            d = controlla_coerenza(rec, r["ev"].get(N)) + invarianti(rec)
            n += 1
            lati[rec["A_txt"]] = lati.get(rec["A_txt"], 0) + 1
            if d:
                diffs.append("giorno %d range %d: %s" % (i, N, "; ".join(d)))
    return n, diffs, lati


class _RngFisso(object):
    def __init__(self, x):
        self.x = x

    def random(self):
        return self.x


def prove_surrogato(cfg, v):
    rng = random.Random(7)
    barre = _gen_barre_casuali(rng, cfg.K, 3.0)
    m5 = m5_da_barre(cfg, barre)
    m5[40] = None
    m5[41] = None
    nb = 3
    s = surroga(m5, nb, random.Random(11))
    v.uguale("surrogato: stessa lunghezza", len(s), len(m5))
    v.check("surrogato: le barre del range sono quelle VERE", s[:nb] == m5[:nb])
    v.check("surrogato: i buchi restano buchi", s[40] is None and s[41] is None)
    forme = True
    for k in range(nb, len(m5)):
        if m5[k] is None:
            continue
        if abs((s[k][1] - s[k][2]) - (m5[k][1] - m5[k][2])) > 1e-9 or abs(abs(s[k][3] - s[k][0]) - abs(m5[k][3] - m5[k][0])) > 1e-9:
            forme = False
    v.check("surrogato: stessa ampiezza e stesso corpo di ogni barra (solo il segno cambia)", forme)
    v.check("surrogato: stesso seme, stesso giorno surrogato", surroga(m5, nb, random.Random(11)) == s)
    v.check("surrogato: seme diverso, giorno diverso", surroga(m5, nb, random.Random(12)) != s)
    piu = surroga(m5, nb, _RngFisso(0.0))
    ok = all((piu[k] is None and m5[k] is None) or
             (piu[k] is not None and all(abs(piu[k][i] - m5[k][i]) < 1e-9 for i in range(4)))
             for k in range(len(m5)))
    v.check("surrogato: tutti i segni + = il giorno VERO (gli incrementi ricostruiscono il cammino)", ok)
    meno = surroga(m5, nb, _RngFisso(0.9))
    P = m5[nb - 1][3]
    ok = all((meno[k] is None and m5[k] is None) or
             (meno[k] is not None and abs(meno[k][0] - (2 * P - m5[k][0])) < 1e-9 and
              abs(meno[k][1] - (2 * P - m5[k][2])) < 1e-9 and abs(meno[k][2] - (2 * P - m5[k][1])) < 1e-9 and
              abs(meno[k][3] - (2 * P - m5[k][3])) < 1e-9)
             for k in range(nb, len(m5)))
    v.check("surrogato: tutti i segni - = lo SPECCHIO del giorno attorno alla chiusura del range", ok)


def prove_statistiche(v):
    # 4 coppie a mano: R_A = 1,-1,0,1  R_B = 1,1,0,-1  -> B-A = 0,2,0,-2 : media 0, SD 1,63299
    def e(seq, R, Rm, falso):
        return {"seq": seq, "R": R, "Rh": R, "Rm": Rm, "Rmh": Rm, "falso": falso, "Rp": 1.0}
    coppie = [(e("T", 1.0, 1.0, True), e("T", 1.0, 1.0, False)),
              (e("S", -1.0, -1.0, True), e("T", 1.0, 1.0, False)),
              (e("N", 0.0, 0.2, False), e("N", 0.0, 0.1, False)),
              (e("T", 1.0, 1.0, True), e("S", -1.0, -1.0, True))]
    c = Cella()
    for a, b in coppie:
        c.add(a, b)
    s = stat_cella(c)
    v.uguale("statistiche: n coppie", s["n"], 4)
    v.uguale("statistiche: B-A medio 0", s["dR"], 0.0)
    v.uguale("statistiche: SE di B-A = SD/sqrt(n) = 1,63299/2", s["seR"], math.sqrt(8.0 / 3.0) / 2.0)
    v.uguale("statistiche: falso A 75%, B 25%", (s["Fa"], s["Fb"]), (75.0, 25.0))
    v.uguale("statistiche: falso A-B 50 punti", s["dF"], 50.0)
    v.uguale("statistiche: a mercato B-A = (0+2+(-0,1)... ) -> media", s["dRm"], (0.0 + 2.0 - 0.1 - 2.0) / 4.0)
    # se TUTTI i giorni hanno A e B, il confronto fra ENTRATE ha lo stesso SE delle coppie
    ce = CellaE()
    for a, b in coppie:
        ce.add_a(a)
        ce.add_b(b)
    se_ = stat_cella_e(ce, coppie)
    v.uguale("entrate: stessa media B-A", se_["dR"], s["dR"])
    v.uguale("entrate: con giorni tutti pieni il SE e' quello delle coppie", se_["seR"], s["seR"], 1e-9)
    v.uguale("entrate: falso A-B", se_["dF"], s["dF"])
    # se A entra 4 volte e B solo 2 (le altre 2 sono il FILTRO), le medie sono sulle rispettive entrate
    ce2 = CellaE()
    for a, b in coppie:
        ce2.add_a(a)
    ce2.add_b(coppie[0][1])
    ce2.add_b(coppie[1][1])
    s2 = stat_cella_e(ce2, [(coppie[0][0], coppie[0][1]), (coppie[1][0], coppie[1][1]), (coppie[2][0], None),
                            (coppie[3][0], None)])
    v.uguale("entrate filtrate: R medio A sulle 4 sue entrate = 0,25", s2["Ra"], 0.25)
    v.uguale("entrate filtrate: R medio B sulle 2 sue entrate = 1", s2["Rb"], 1.0)
    v.uguale("entrate filtrate: n = min(nA, nB) = 2", s2["n"], 2)
    # zona: SI / NO / INCERTO con confini ESATTI
    v.uguale("zona: eccesso esattamente sulla soglia, IC sopra zero -> SI", zona(10.0, 1.0, 10.0), "SI")
    v.uguale("zona: 9,9 con se 1 -> INCERTO (ne' SI, ne' NO: 9,9+1,96 >= 10)", zona(9.9, 1.0, 10.0), "INCERTO")
    v.uguale("zona: 5 con se 1 -> NO (5+1,96 < 10)", zona(5.0, 1.0, 10.0), "NO")
    v.uguale("zona: 12 con se 7 -> INCERTO (il limite basso e' sotto zero)", zona(12.0, 7.0, 10.0), "INCERTO")
    v.uguale("zona: dato mancante -> INCERTO, mai SI", zona(None, None, 10.0), "INCERTO")


def _nullo_fisso(dF=0.0, dR=0.0, dRm=0.0, K=30):
    return {"dF": (dF, 0.0), "dR": (dR, 0.0), "dRm": (dRm, 0.0), "K": K}


def _obs_fisso(n, dF, seF, dR, seR, dRm, seRm):
    return {"n": n, "dF": dF, "seF": seF, "dR": dR, "seR": seR, "dRm": dRm, "seRm": seRm, "dRh": dR,
            "nf": n, "Ra": 0.0, "Rb": dR, "Rma": 0.0, "Rmb": dRm, "Fa": 70.0, "Fb": 70.0 - (dF or 0.0)}


def prove_verdetto(v):
    nul0 = _nullo_fisso()
    g = giudica_cella(_obs_fisso(1000, 25.0, 1.5, 0.15, 0.02, 0.15, 0.02), nul0)
    v.uguale("verdetto: filtra e paga -> H_CHIUSURA", g["lettura"].split(" ")[0], "H_CHIUSURA")
    g = giudica_cella(_obs_fisso(1000, 1.0, 1.5, 0.0, 0.02, 0.0, 0.02), nul0)
    v.uguale("verdetto: nulla e nulla -> NON_FILTRA + NON_PAGA", (g["meccanismo"], g["pagamento"]), ("NON_FILTRA", "NON_PAGA"))
    # IL CONTRO-ESEMPIO DI CLASSE 178: un divario grezzo di 20 punti sul falso c'e' anche SENZA memoria:
    # se il nullo lo riproduce, l'ECCESSO e' ~0 e la cella NON FILTRA.
    g = giudica_cella(_obs_fisso(1000, 20.0, 1.5, 0.0, 0.02, 0.0, 0.02), _nullo_fisso(dF=19.5))
    v.uguale("verdetto: divario grezzo 20 pt ma nullo 19,5 -> NON_FILTRA (eccesso 0,5)", g["meccanismo"], "NON_FILTRA")
    g = giudica_cella(_obs_fisso(1000, 20.0, 1.5, 0.0, 0.02, 0.0, 0.02), _nullo_fisso(dF=0.0))
    v.uguale("verdetto: lo STESSO 20 pt senza nullo -> FILTRA (e' il falso positivo che il nullo evita)", g["meccanismo"], "FILTRA")
    # confini della soglia sul falso
    g = giudica_cella(_obs_fisso(1000, 10.0, 0.5, 0.0, 0.02, 0.0, 0.02), nul0)
    v.uguale("verdetto: eccesso falso esattamente 10 -> FILTRA", g["meccanismo"], "FILTRA")
    g = giudica_cella(_obs_fisso(1000, 9.9, 0.5, 0.0, 0.02, 0.0, 0.02), nul0)
    v.check("verdetto: eccesso falso 9,9 -> NON FILTRA", g["meccanismo"] != "FILTRA")
    # confini della soglia su R
    g = giudica_cella(_obs_fisso(1000, 0.0, 1.5, 0.08, 0.01, 0.08, 0.01), nul0)
    v.uguale("verdetto: eccesso R esattamente 0,08 -> PAGA", g["pagamento"], "PAGA")
    g = giudica_cella(_obs_fisso(1000, 0.0, 1.5, 0.079, 0.01, 0.079, 0.01), nul0)
    v.check("verdetto: eccesso R 0,079 -> NON PAGA", g["pagamento"] != "PAGA")
    # R paga ma a mercato no -> INCONCLUSIVO (le due letture devono concordare)
    g = giudica_cella(_obs_fisso(1000, 0.0, 1.5, 0.12, 0.01, 0.0, 0.01), nul0)
    v.uguale("verdetto: R lordo paga, a mercato no -> INCONCLUSIVO", g["pagamento"], "INCONCLUSIVO")
    # n minimo esatto
    g = giudica_cella(_obs_fisso(149, 25.0, 1.5, 0.15, 0.02, 0.15, 0.02), nul0)
    v.uguale("verdetto: 149 coppie -> NON GIUDICABILE", g["meccanismo"], "NON_GIUDICABILE")
    g = giudica_cella(_obs_fisso(150, 25.0, 1.5, 0.15, 0.02, 0.15, 0.02), nul0)
    v.uguale("verdetto: 150 coppie -> si pronuncia", g["meccanismo"], "FILTRA")
    # IL VERDETTO (correzione del cancello, 30/09): politica B contro politica A, entrate, GREZZO
    o_si = _obs_fisso(1000, 0.0, 1.5, 0.15, 0.02, 0.15, 0.02)
    o_no = _obs_fisso(1000, 0.0, 1.5, 0.0, 0.02, 0.0, 0.02)
    v.uguale("politica: B-A +0,15 (se 0,02) su R e a mercato -> PAGA", giudica_politica(o_si)["pagamento"], "PAGA")
    v.uguale("politica: B-A 0 (se 0,02) -> NON_PAGA", giudica_politica(o_no)["pagamento"], "NON_PAGA")
    v.uguale("politica: esattamente 0,08 con IC sopra zero -> PAGA",
             giudica_politica(_obs_fisso(1000, 0.0, 1.5, 0.08, 0.01, 0.08, 0.01))["pagamento"], "PAGA")
    v.check("politica: 0,079 -> non PAGA",
            giudica_politica(_obs_fisso(1000, 0.0, 1.5, 0.079, 0.01, 0.079, 0.01))["pagamento"] != "PAGA")
    v.uguale("politica: R lordo paga, a mercato no -> INCONCLUSIVO",
             giudica_politica(_obs_fisso(1000, 0.0, 1.5, 0.12, 0.01, 0.0, 0.01))["pagamento"], "INCONCLUSIVO")
    v.uguale("politica: 149 entrate -> NON_GIUDICABILE",
             giudica_politica(_obs_fisso(149, 0.0, 1.5, 0.15, 0.02, 0.15, 0.02))["pagamento"], "NON_GIUDICABILE")
    v.uguale("politica: 150 entrate -> si pronuncia",
             giudica_politica(_obs_fisso(150, 0.0, 1.5, 0.15, 0.02, 0.15, 0.02))["pagamento"], "PAGA")
    v.check("politica: B-A -0,10 (se 0,02) -> NON_PAGA e 'peggio' descrittivo",
            giudica_politica(_obs_fisso(1000, 0.0, 1.5, -0.10, 0.02, -0.10, 0.02))["peggio"] is True)
    # IL CONTRO-ESEMPIO DEL CANCELLO (1): B GREZZO PEGGIO di A (-0,02), nullo -0,12 -> eccesso +0,10.
    # La regola vecchia (eccesso sul nullo) diceva PAGA = "B batte A al lordo": FALSO. Ora: NON_PAGA.
    o_neg = _obs_fisso(1000, 0.0, 1.5, -0.02, 0.01, -0.02, 0.01)
    n_neg = _nullo_fisso(dR=-0.12, dRm=-0.12)
    ve_neg = giudica_cella(o_neg, n_neg)
    v.uguale("contro-esempio: l'eccesso sul nullo direbbe PAGA (+0,10)", ve_neg["pagamento"], "PAGA")
    c = combina(ve_neg, ve_neg, o_neg)
    v.uguale("contro-esempio: B grezzo PEGGIO di A -> il verdetto NON e' PAGA (NON_PAGA)", c["pagamento"], "NON_PAGA")
    # IL CONTRO-ESEMPIO DEL CANCELLO (2): le coppie non vedono il filtro -> non possono bloccare il verdetto
    vp_no = giudica_cella(o_no, nul0)
    c = combina(vp_no, giudica_cella(o_si, nul0), o_si)
    v.uguale("combina: entrate PAGA e coppie NON_PAGA -> PAGA (le coppie sono descrizione)", c["pagamento"], "PAGA")
    v.check("combina: la lettura PAGA dice B MEGLIO", c["lettura"].startswith("B MEGLIO"))
    c0 = combina(vp_no, giudica_cella(o_no, nul0), o_no)
    v.check("combina: niente -> B NON MEGLIO", c0["lettura"].startswith("B NON MEGLIO"))
    v.check("combina: il meccanismo (falso) non entra nella lettura",
            combina(vp_no, giudica_cella(_obs_fisso(1000, 25.0, 1.5, 0.0, 0.02, 0.0, 0.02), nul0), o_no)["lettura"]
            == c0["lettura"])
    # un range vale solo se LONG e SHORT concordano
    v.check("range: LONG e SHORT discordi -> INCONCLUSIVA", lettura_range(c, c0).startswith("INCONCLUSIVA"))
    v.check("range: concordi -> la lettura comune", lettura_range(c, c).startswith("B MEGLIO"))


def mondo_sintetico(rng, mondo, K=78, s=3.0):
    """M5 di un giorno. mondo 'neg': random walk (H_NIENTE vero). mondo 'pos':
    la chiusura porta informazione: 45% rotture VERE (chiude fuori e prosegue), 45% TRAPPOLE (il
    tocco e' solo uno stoppino, poi il prezzo va dall'altra parte), 10% rumore.
    Aggiunti dal cancello di giudizio (30/09), barre ORDINARIE (nessuna barra costruita apposta):
    'filtro': dopo la PRIMA barra che CHIUDE fuori il prezzo deriva a favore (+0,2 s per barra),
    dopo la prima barra che TOCCA e richiude dentro deriva contro (trappola): l'informazione e'
    nella CHIUSURA, B deve risultare MEGLIO. 'tocco': dal primo TOCCO il prezzo deriva nella
    direzione del tocco, qualunque sia la chiusura: l'informazione e' nel tocco, la chiusura non
    aggiunge niente, B NON deve risultare meglio (paga solo il ritardo)."""
    def barra(o, drift):
        c = o + rng.gauss(drift, s)
        h = max(o, c) + abs(rng.gauss(0, s * 0.5))
        l = min(o, c) - abs(rng.gauss(0, s * 0.5))
        return (o, h, l, c, 5)
    bars = []
    p = 1000.0
    if mondo in ("filtro", "tocco"):
        for _ in range(3):
            b = barra(p, 0.0)
            b = (b[0], b[0] + 2.0 * (b[1] - b[0]), b[0] + 2.0 * (b[2] - b[0]), b[0] + 2.0 * (b[3] - b[0]), 5)
            bars.append(b)
            p = b[3]
        RH = max(b[1] for b in bars)
        RL = min(b[2] for b in bars)
        drift = 0.0
        deciso = False
        while len(bars) < K:
            b = barra(p, drift)
            bars.append(b)
            p = b[3]
            if deciso:
                continue
            su, giu = b[1] >= RH, b[2] <= RL
            if mondo == "tocco":
                if su or giu:
                    deciso = True
                    drift = 0.0 if (su and giu) else (1 if su else -1) * 0.2 * s
            else:
                if b[3] > RH or b[3] < RL:
                    deciso = True
                    drift = (1 if b[3] > RH else -1) * 0.2 * s
                elif su != giu:
                    deciso = True
                    drift = (-1 if su else 1) * 0.2 * s
        return bars
    for _ in range(3):
        b = barra(p, 0.0)
        bars.append(b)
        p = b[3]
    RH = max(b[1] for b in bars)
    RL = min(b[2] for b in bars)
    A = RH - RL
    drift = 0.0
    if mondo == "pos":
        u = rng.random()
        side = 1 if rng.random() < 0.5 else -1
        lv = RH if side == 1 else RL
        if u < 0.45:
            c = lv + side * 1.0 * A
            ex = c + side * 0.5 * s
            b = (p, max(p, c, ex), min(p, c, ex), c, 5)
            drift = side * 0.9
            bars.append(b)
            p = b[3]
        elif u < 0.90:
            ex = lv + side * 0.2 * A
            c = lv - side * 0.3 * A
            b = (p, max(p, c, ex), min(p, c, ex), c, 5)
            drift = -side * 0.9
            bars.append(b)
            p = b[3]
    while len(bars) < K:
        b = barra(p, drift)
        bars.append(b)
        p = b[3]
    return bars


def simula_mondo(cfg, mondo, giorni, K, seme, N=15, x_f=None, x_r=None):
    """Il metodo COMPLETO (osservato + nullo + verdetto) su un mondo sintetico. Torna
    {lato: (verdetto_combinato, obsE, nullE)}."""
    rng = random.Random(seme)
    oe = {1: CellaE(), -1: CellaE()}
    gi = {1: [], -1: []}
    op = {1: Cella(), -1: Cella()}
    ne = {1: [CellaE() for _ in range(K)], -1: [CellaE() for _ in range(K)]}
    npp = {1: [Cella() for _ in range(K)], -1: [Cella() for _ in range(K)]}
    for _ in range(giorni):
        m5 = mondo_sintetico(rng, mondo, cfg.K)
        r = misura_range(cfg, m5, N)
        if r["stato"] != "OK":
            continue
        for lato in (1, -1):
            a, b = _lato_da_rec(r, lato)
            gi[lato].append((a, b))
            if a is not None:
                oe[lato].add_a(a)
            if b is not None:
                oe[lato].add_b(b)
            if a is not None and b is not None:
                op[lato].add(a, b)
        for k in range(K):
            rs = misura_range(cfg, surroga(m5, N // 5, rng), N)
            for lato in (1, -1):
                a, b = _lato_da_rec(rs, lato)
                if a is not None:
                    ne[lato][k].add_a(a)
                if b is not None:
                    ne[lato][k].add_b(b)
                if a is not None and b is not None:
                    npp[lato][k].add(a, b)
    out = {}
    for lato in (1, -1):
        obsE = stat_cella_e(oe[lato], gi[lato])
        obsP = stat_cella(op[lato])
        nE = sintesi_nullo([stat_cella_e(c) for c in ne[lato]])
        nP = sintesi_nullo([stat_cella(c) for c in npp[lato]])
        vE = giudica_cella(obsE, nE, x_f=x_f, x_r=x_r)
        vP = giudica_cella(obsP, nP, x_f=x_f, x_r=x_r)
        out[lato] = {"comb": combina(vP, vE, obsE), "vE": vE, "vP": vP, "obsE": obsE, "nE": nE,
                     "obsP": obsP, "nP": nP}
    return out


def _scrivi_csv_m1(percorso, giorni_barre):
    """File Formato 1 sintetico: per ogni (data, barre M5) 390 minuti dalle 09:30 (ora NY)."""
    righe = ["Time,Open,High,Low,Close,Volume"]
    for dt, barre in giorni_barre:
        m1 = AM.m1_da_m5(barre, 78)
        for off in range(390):
            mm = 570 + off
            o, h, l, c = m1.get(off, (1000.0,) * 4)
            righe.append("%04d.%02d.%02d %02d:%02d,%.4f,%.4f,%.4f,%.4f,0" %
                         (dt.year, dt.month, dt.day, mm // 60, mm % 60, o, h, l, c))
    with open(percorso, "w", newline="", encoding="ascii") as fh:
        for x in righe:
            fh.write(x + "\n")


def autotest():
    log("=== AUTOTEST %s (offline, dati SINTETICI) ===" % VERSIONE)
    totale = 0
    giusti = 0
    # -- 0. l'anatomia e' quella del pin e NON viene toccata
    z = _Verifiche()
    sha_prima = {}
    for nome, mod in (("m5", AM), ("aperture", AA)):
        sha_prima[nome] = sha256_file(mod.__file__.replace(".pyc", ".py"))
    ok, righe_sha = verifica_anatomia()
    z.check("anatomia: SHA256 dei due file = pin", ok, "; ".join(righe_sha))
    z.check("anatomia: versione dichiarata", AM.VERSIONE == "ANATOMIA_MOVIMENTI_M5_v1")
    orig_fn = AM.analizza_giorno
    ctx_t = Contesto(_cfg_test(), 2, 1)
    with Gancio(ctx_t):
        z.check("gancio: dentro la corsa la funzione e' sostituita", AM.analizza_giorno is not orig_fn)
    z.check("gancio: FUORI dalla corsa l'originale e' rimesso", AM.analizza_giorno is orig_fn)
    try:
        with Gancio(ctx_t):
            raise RuntimeError("guasto")
    except RuntimeError:
        pass
    z.check("gancio: rimesso anche dopo un'eccezione", AM.analizza_giorno is orig_fn)
    sha_dopo = {}
    for nome, mod in (("m5", AM), ("aperture", AA)):
        sha_dopo[nome] = sha256_file(mod.__file__.replace(".pyc", ".py"))
    z.check("anatomia: i file NON sono cambiati durante l'autotest", sha_prima == sha_dopo)
    with open(__file__.replace(".pyc", ".py"), "r") as fh:
        mio = fh.read()
    z.check("questo file NON contiene una copia delle funzioni di lettura dell'anatomia (le importa)",
            not any(("def " + n + "(") in mio for n in ("calibra_apertura", "scandisci", "m5_da_m1", "analizza_giorno",
                                                        "_sequenza", "_stampa_riga")))
    totale += z.n
    giusti += z.ok
    log("0. l'anatomia importata e' quella del pin, non modificata, gancio reversibile: %d/%d" % (z.ok, z.n))
    for x in z.falliti:
        log("   FALLITO: " + x)
    # -- 1. casi a risposta nota
    cfg = _cfg_test()
    if cfg.problemi:
        log("!!! configurazione di test incoerente: %s" % cfg.problemi)
        return 2
    v = _Verifiche()
    esegui_casi(cfg, v)
    base_n, base_ok = v.n, v.ok
    totale += v.n
    giusti += v.ok
    log("1. casi a risposta nota (tocco senza chiusura, stessa barra, barra dopo, specchio, ambigua, opposti,"
        " ultima barra, sul livello, falso alla 3a chiusura, bersaglio di B): %d/%d" % (v.ok, v.n))
    for x in v.falliti:
        log("   FALLITO: " + x)
    # -- 2. surrogato, statistiche, verdetto
    w = _Verifiche()
    prove_surrogato(cfg, w)
    totale += w.n
    giusti += w.ok
    log("2. il surrogato del nullo (forme conservate, segni +/- = giorno vero/specchio, seme): %d/%d" % (w.ok, w.n))
    for x in w.falliti:
        log("   FALLITO: " + x)
    s_ = _Verifiche()
    prove_statistiche(s_)
    totale += s_.n
    giusti += s_.ok
    log("3. statistiche di cella calcolate a mano (coppie, entrate filtrate, zone ai confini): %d/%d" % (s_.ok, s_.n))
    for x in s_.falliti:
        log("   FALLITO: " + x)
    vv = _Verifiche()
    prove_verdetto(vv)
    totale += vv.n
    giusti += vv.ok
    log("4. verdetto: confini esatti delle soglie, contro-esempio di classe 178, concordanza: %d/%d" % (vv.ok, vv.n))
    for x in vv.falliti:
        log("   FALLITO: " + x)
    # -- 5. FUZZ contro l'anatomia vera
    fz = _Verifiche()
    n_fz, diffs, lati = fuzz_contro_anatomia(cfg, 700, 20260930)
    fz.check("fuzz: almeno 600 giorni-range confrontati", n_fz >= 600, str(n_fz))
    fz.check("fuzz: tutti i lati presenti (LONG e SHORT)", lati.get("LONG", 0) > 50 and lati.get("SHORT", 0) > 50, str(lati))
    fz.check("fuzz: NESSUNA differenza con la 'prima rottura' dell'anatomia", not diffs, "; ".join(diffs[:3]))
    totale += fz.n
    giusti += fz.ok
    log("5. fuzz: %d giorni-range casuali (con buchi) contro l'anatomia VERA, differenze %d: %d/%d" %
        (n_fz, len(diffs), fz.ok, fz.n))
    for x in fz.falliti:
        log("   FALLITO: " + x)
    # -- 6. CONTROLLI DI MONDO: negativo (H_NIENTE vero) e positivo (la chiusura porta informazione)
    mm = _Verifiche()
    cfg15 = _cfg_test(["--ranges", "15"])
    neg = simula_mondo(cfg15, "neg", 1400, 12, 5)
    pos = simula_mondo(cfg15, "pos", 1400, 12, 5)
    for lato in (1, -1):
        nome = _lato_txt(lato)
        no = neg[lato]
        po = pos[lato]
        mm.check("mondo NEGATIVO %s: il divario GREZZO di falso (%.1f pt) supera la soglia %.0f -> la banda "
                 "grezza cadrebbe anche senza memoria" % (nome, no["obsE"]["dF"], X_FALSO_PP),
                 no["obsE"]["dF"] >= X_FALSO_PP, "dF=%s" % no["obsE"]["dF"])
        mm.check("mondo NEGATIVO %s: l'ECCESSO sul nullo (%.1f pt) sta sotto la soglia e NON filtra" %
                 (nome, no["vE"]["exF"]), no["vE"]["meccanismo"] != "FILTRA", str(no["vE"]["exF"]))
        mm.check("mondo NEGATIVO %s: nessun pagamento (eccesso R %s)" % (nome, _sgn(no["vE"]["exR"])),
                 no["comb"]["pagamento"] != "PAGA", str(no["comb"]))
        mm.check("mondo NEGATIVO %s: H_CHIUSURA NON sostenuta" % nome,
                 not no["comb"]["lettura"].startswith("H_CHIUSURA"), no["comb"]["lettura"])
        mm.check("mondo NEGATIVO %s: il verdetto non dice B MEGLIO (B-A grezzo %s)" % (nome, _sgn(no["obsE"]["dR"])),
                 not no["comb"]["lettura"].startswith("B MEGLIO"), no["comb"]["lettura"])
        mm.check("mondo POSITIVO %s: paga (B-A grezzo sulle entrate %s)" % (nome, _sgn(po["obsE"]["dR"])),
                 po["comb"]["pagamento"] == "PAGA", str(po["comb"]["pol"]))
        mm.check("mondo POSITIVO %s: l'eccesso sul falso (%.1f pt) e' positivo e vicino/oltre la soglia" %
                 (nome, po["vE"]["exF"]), po["vE"]["exF"] is not None and po["vE"]["exF"] >= X_FALSO_PP * 0.8,
                 str(po["vE"]["exF"]))
    # i due mondi del cancello di giudizio (barre ordinarie): FILTRO (l'informazione e' nella chiusura)
    # e TOCCO (l'informazione e' nel tocco, la chiusura non aggiunge niente)
    fil = simula_mondo(cfg15, "filtro", 1400, 4, 7)
    toc = simula_mondo(cfg15, "tocco", 1400, 4, 7)
    for lato in (1, -1):
        nome = _lato_txt(lato)
        fi, to = fil[lato], toc[lato]
        mm.check("mondo FILTRO %s: B MEGLIO (B-A grezzo %s, coppie %s): il verdetto lo vede" %
                 (nome, _sgn(fi["obsE"]["dR"]), _sgn(fi["obsP"]["dR"])),
                 fi["comb"]["pagamento"] == "PAGA", str(fi["comb"]["pol"]))
        mm.check("mondo TOCCO %s: B NON meglio (B-A grezzo %s): nessun PAGA" % (nome, _sgn(to["obsE"]["dR"])),
                 to["comb"]["pagamento"] != "PAGA", str(to["comb"]["pol"]))
        mm.check("mondo POSITIVO %s: sulle COPPIE B e' grezzo PEGGIO di A (%s) mentre l'eccesso sul nullo e' %s: "
                 "per questo l'eccesso NON decide" % (nome, _sgn(pos[lato]["obsP"]["dR"]), _sgn(pos[lato]["vP"]["exR"])),
                 pos[lato]["obsP"]["dR"] < 0 < pos[lato]["vP"]["exR"])
    totale += mm.n
    giusti += mm.ok
    log("6. quattro MONDI sintetici (senza memoria / positivo / FILTRO nella chiusura / informazione nel TOCCO): "
        "il divario grezzo del falso cade anche senza memoria, il verdetto sulle politiche vede FILTRO e "
        "non vede TOCCO: %d/%d" % (mm.ok, mm.n))
    log("   FILTRO B-A grezzo entrate LONG %s SHORT %s | TOCCO LONG %s SHORT %s | POSITIVO coppie grezzo %s / %s" %
        (_sgn(fil[1]["obsE"]["dR"]), _sgn(fil[-1]["obsE"]["dR"]), _sgn(toc[1]["obsE"]["dR"]),
         _sgn(toc[-1]["obsE"]["dR"]), _sgn(pos[1]["obsP"]["dR"]), _sgn(pos[-1]["obsP"]["dR"])))
    log("   nullo (mondo senza memoria, range 15): divario grezzo falso A-B LONG %s pt, SHORT %s pt; eccesso %s / %s" %
        (_sgn(neg[1]["obsE"]["dF"], 1), _sgn(neg[-1]["obsE"]["dF"], 1),
         _sgn(neg[1]["vE"]["exF"], 1), _sgn(neg[-1]["vE"]["exF"], 1)))
    for x in mm.falliti:
        log("   FALLITO: " + x)
    # -- 7. corsa vera su un CSV sintetico: file, referti, fasi distinte, niente PF
    ee = _Verifiche()
    tmpd = tempfile.mkdtemp(prefix="conf_tc_")
    rng = random.Random(3)
    gg = []
    d = date(2015, 1, 5)
    while len(gg) < 26:
        if d.weekday() < 5:
            gg.append((d, _gen_barre_casuali(rng, 78, 3.0)))
        d += timedelta(days=1)
    d = date(2022, 1, 3)
    n2 = 0
    while n2 < 24:
        if d.weekday() < 5:
            gg.append((d, _gen_barre_casuali(rng, 78, 3.0)))
            n2 += 1
        d += timedelta(days=1)
    f_csv = os.path.join(tmpd, "NASUSD_M1.csv")
    _scrivi_csv_m1(f_csv, gg)
    out_dir = os.path.join(tmpd, "uscita")
    args = costruisci_parser().parse_args(["--file", f_csv, "--simbolo", "TEST", "--uscita", out_dir,
                                           "--ranges", "5,15", "--surrogati", "3", "--senza-calibrazione",
                                           "--min-giorni-anno", "1", "--addestramento", "2010-2020",
                                           "--cassaforte", "2021-2026"])
    import io
    import contextlib
    buf = io.StringIO()
    with contextlib.redirect_stdout(buf):
        rc = esegui(args)
    ee.uguale("corsa: senza calibrazione -> MISURATO CON RILIEVI (1)", rc, 1)
    ee.check("corsa: l'originale e' rimesso dopo la corsa", AM.analizza_giorno is orig_fn)
    nomi = sorted(os.listdir(out_dir)) if os.path.isdir(out_dir) else []
    ee.uguale("corsa: tre file (CSV per giorno + 2 referti DISTINTI)", len(nomi), 3, 0)
    testi = {}
    for nm in nomi:
        with open(os.path.join(out_dir, nm), "r", encoding="ascii") as fh:
            testi[nm] = fh.read()
    t_is = [t for nm, t in testi.items() if "_IS_" in nm]
    t_cs = [t for nm, t in testi.items() if "_CASSAFORTE_" in nm]
    ee.check("corsa: un referto IS e uno CASSAFORTE", len(t_is) == 1 and len(t_cs) == 1)
    if t_is and t_cs:
        ee.check("corsa: il referto IS non parla della cassaforte e viceversa",
                 "CASSAFORTE" not in t_is[0].split("--- LEGGERE PRIMA")[0] and "ADDESTRAMENTO" not in t_cs[0].split("--- LEGGERE PRIMA")[0])
        ee.check("corsa: solo ASCII", all(ord(ch) < 128 for t in testi.values() for ch in t))
        ee.check("corsa: nessun 'profit factor' come misura", not any("profit factor" in t.lower() or "PF =" in t for t in testi.values()))
        ee.check("corsa: dichiara SOLO_PROVA_REGIME", "SOLO_PROVA_REGIME" in t_is[0] and "SOLO_PROVA_REGIME" in t_cs[0])
        ee.check("corsa: dichiara che NON ci sono costi", "NIENTE spread" in t_is[0])
        ee.check("corsa: le due celle LONG e SHORT ci sono separate", "LONG, range 5 min" in t_is[0] and "SHORT, range 5 min" in t_is[0])
        ee.check("corsa: il verdetto meccanico c'e' nell'IS", "VERDETTI MECCANICI DI QUESTA FASE (IS)" in t_is[0])
        ee.check("corsa: la cassaforte confronta con l'addestramento", "CONFRONTO CON L'ADDESTRAMENTO" in t_cs[0])
        ee.check("corsa: il referto IS non ha il confronto con l'addestramento", "CONFRONTO CON L'ADDESTRAMENTO" not in t_is[0])
        ee.check("corsa: il referto termina con ESITO", t_is[0].rstrip().split("\n")[-1].startswith("ESITO:"))
        # classe 45 (residuo della correzione): la regola VECCHIA non deve comparire come affermazione nel referto
        ee.check("corsa: il referto non dice piu' che decide l'ECCESSO sul nullo (residuo del cancello)",
                 not any("conta l'ECCESSO" in t or "numero che decide" in t for t in testi.values()))
        ee.check("corsa: il referto dichiara che il verdetto e' PER OPERAZIONE", "PER OPERAZIONE" in t_is[0])
    csv_t = [t for nm, t in testi.items() if nm.endswith(".csv")]
    if csv_t:
        righe_csv = csv_t[0].strip().split("\n")
        ee.check("corsa: il CSV ha lo stesso numero di campi per riga",
                 len(set(len(x.split(",")) for x in righe_csv)) == 1, str(set(len(x.split(",")) for x in righe_csv)))
        ee.uguale("corsa: una riga per giorno + intestazione", len(righe_csv), 51, 0)
    # bersagli di riproduzione dell'anatomia (29/09): coincidono -> niente; uno diverso -> un rilievo
    class _CfgB(object):
        per_is = (2010, 2020)
    rb = {15: {"A": {"LONG": 1267, "SHORT": 1214}}, 30: {"A": {"LONG": 1348, "SHORT": 1135}}}
    ee.uguale("bersagli: n di A uguali all'anatomia -> nessun rilievo", controlla_bersagli(rb, _CfgB, "NASUSD"), [])
    rb[30]["A"]["SHORT"] = 1134
    ee.uguale("bersagli: un n diverso (30 SHORT 1134) -> un rilievo RIPRODUZIONE",
              len([x for x in controlla_bersagli(rb, _CfgB, "NASUSD") if x.startswith("RIPRODUZIONE")]), 1)
    ee.uguale("bersagli: non applicabili a un altro simbolo", controlla_bersagli(rb, _CfgB, "D30EUR"), [])
    _CfgB.per_is = (2011, 2020)
    ee.uguale("bersagli: non applicabili a un altro addestramento", controlla_bersagli(rb, _CfgB, "NASUSD"), [])
    # file NON in Formato 1: rifiuto (rc 2), non un referto vuoto
    f_brutto = os.path.join(tmpd, "storto.csv")
    with open(f_brutto, "w") as fh:
        fh.write("20150105 093000;1;2;3;4;0\n")
    with contextlib.redirect_stdout(io.StringIO()):
        rc2 = esegui(costruisci_parser().parse_args(["--file", f_brutto, "--uscita", out_dir, "--senza-calibrazione"]))
    ee.uguale("corsa: file in un altro formato -> rc 2", rc2, 2)
    with contextlib.redirect_stdout(io.StringIO()):
        rc3 = esegui(costruisci_parser().parse_args(["--file", os.path.join(tmpd, "non_esiste.csv"), "--uscita", out_dir]))
    ee.uguale("corsa: file inesistente -> rc 2", rc3, 2)
    # INCOERENZA con l'anatomia: se la 'prima rottura' di questo strumento cambia, la corsa si rifiuta
    _MUT["a_falso_dopo"] = True
    try:
        with contextlib.redirect_stdout(io.StringIO()):
            rc4 = esegui(costruisci_parser().parse_args(["--file", f_csv, "--uscita", os.path.join(tmpd, "u2"),
                                                         "--ranges", "5,15", "--surrogati", "1",
                                                         "--senza-calibrazione", "--min-giorni-anno", "1",
                                                         "--addestramento", "2010-2020", "--cassaforte", "2021-2026"]))
    finally:
        _MUT.pop("a_falso_dopo", None)
    ee.uguale("corsa: A diversa dalla 'prima rottura' dell'anatomia -> rc 2, nessun referto", rc4, 2)
    ee.check("corsa: e nessun referto scritto", not os.path.isdir(os.path.join(tmpd, "u2")) or
             not [x for x in os.listdir(os.path.join(tmpd, "u2")) if x.endswith(".txt")])
    try:
        shutil.rmtree(tmpd, ignore_errors=True)
    except Exception:
        pass
    totale += ee.n
    giusti += ee.ok
    log("7. corsa vera su CSV sintetico (due fasi in file distinti, ASCII, niente PF, rifiuti): %d/%d" % (ee.ok, ee.n))
    for x in ee.falliti:
        log("   FALLITO: " + x)
    # -- 8. MUTAZIONI: una convenzione cambiata deve far FALLIRE i casi a risposta nota
    mutazioni = [
        ("b_ge", "B entra anche con la chiusura ESATTAMENTE sul livello (>= al posto di >)"),
        ("b_falso_da_entrata", "il falso di B conta dalla barra d'entrata invece che dalla successiva"),
        ("b_seq_da_entrata", "la sequenza di B parte dalla barra d'entrata (l'entrata e' al close!)"),
        ("b_rprime_range", "il bersaglio di B a +1 ampiezza del range invece che a +1 R' (entrata-stop)"),
        ("a_falso_dopo", "il falso di A conta dalla barra DOPO il tocco (non riproduce piu' l'anatomia)"),
    ]
    catturate = 0
    for chiave, nome in mutazioni:
        _MUT[chiave] = True
        try:
            vm = _Verifiche()
            esegui_casi(cfg, vm)
            fallito = len(vm.falliti) > 0
        except (KeyError, IndexError, TypeError, ValueError):
            fallito = True
        finally:
            _MUT.pop(chiave, None)
        catturate += 1 if fallito else 0
        log("   mutazione: %-80s -> %s" % (nome, "CATTURATA" if fallito else "*** NON CATTURATA ***"))
    # il surrogato senza segni deve rompere le prove del surrogato
    _MUT["surr_senza_segni"] = True
    try:
        vm = _Verifiche()
        prove_surrogato(cfg, vm)
        fallito = len(vm.falliti) > 0
    finally:
        _MUT.pop("surr_senza_segni", None)
    catturate += 1 if fallito else 0
    log("   mutazione: %-80s -> %s" % ("il surrogato non tira i segni (= il giorno vero: nullo senza senso)",
                                        "CATTURATA" if fallito else "*** NON CATTURATA ***"))
    # le due regole VECCHIE del verdetto (corrette dal cancello): devono far fallire le prove del verdetto
    for chiave, nome in (("pagamento_su_eccesso", "il pagamento deciso sull'ECCESSO sul nullo (B grezzo peggio -> PAGA)"),
                         ("pagamento_coppie", "il pagamento che chiede anche le COPPIE (non vedono il filtro)")):
        _MUT[chiave] = True
        try:
            vm = _Verifiche()
            prove_verdetto(vm)
            fallito = len(vm.falliti) > 0
        finally:
            _MUT.pop(chiave, None)
        catturate += 1 if fallito else 0
        log("   mutazione: %-80s -> %s" % (nome, "CATTURATA" if fallito else "*** NON CATTURATA ***"))
    # soglie mutate: la stessa cella cambia verdetto
    nul0 = _nullo_fisso()
    base = giudica_cella(_obs_fisso(1000, 12.0, 1.0, 0.09, 0.01, 0.09, 0.01), nul0)
    mut_f = giudica_cella(_obs_fisso(1000, 12.0, 1.0, 0.09, 0.01, 0.09, 0.01), nul0, x_f=15.0)
    o_b = _obs_fisso(1000, 12.0, 1.0, 0.09, 0.01, 0.09, 0.01)
    mut_r = giudica_politica(o_b, x_r=0.12)
    mut_n = giudica_politica(_obs_fisso(140, 12.0, 1.0, 0.09, 0.01, 0.09, 0.01))
    for nome, cambia in (("soglia falso (descrittiva) 10 -> 15", mut_f["meccanismo"] != base["meccanismo"]),
                         ("soglia R del verdetto 0,08 -> 0,12", mut_r["pagamento"] != giudica_politica(o_b)["pagamento"]),
                         ("n minimo 150 -> 140 entrate", mut_n["pagamento"] != giudica_politica(o_b)["pagamento"])):
        catturate += 1 if cambia else 0
        log("   mutazione: %-80s -> %s" % (nome, "CATTURATA" if cambia else "*** NON CATTURATA ***"))
    n_mut = len(mutazioni) + 1 + 2 + 3
    log("8. mutazioni catturate: %d/%d" % (catturate, n_mut))
    totale += n_mut
    giusti += catturate
    log("")
    log("AUTOTEST: %d/%d" % (giusti, totale))
    if giusti == totale:
        log("ESITO: OK")
        return 0
    log("ESITO: FALLITO")
    return 1


if __name__ == "__main__":
    sys.exit(main())
