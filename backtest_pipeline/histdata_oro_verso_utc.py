#!/usr/bin/env python3
# =====================================================================
#  MARCATORE_HISTDATA_ORO_VERSO_UTC_v1
#  histdata_oro_verso_utc.py
#  HISTDATA M1 (ora locale di NEW YORK) -> CSV UTC NEL FORMATO OANDA
# ---------------------------------------------------------------------
#  PERCHE' ESISTE (22/09/2026)
#    report/ANATOMIA_ESPLOSIONI_ORO_2026-09-22.md gira su 4.884.366
#    barre M1 di feed OANDA, 2006-03 -> 2020-05. Il 2021-2026 manca.
#    Questo strumento prende il feed HISTDATA (che Claudio scarica dal
#    PC di backtest con oro_m1_histdata.ps1) e lo porta nel formato
#    ESATTO che anatomia_esplosioni_oro.py sa leggere.
#
#  ###################################################################
#  #  LA REGOLA CHE VIENE PRIMA DI TUTTO:                            #
#  #  IL 2021-2026 **NON SI CONCATENA** CON L'OANDA 2006-2020.       #
#  #  Sono due feed diversi. Si misura come FINESTRA SEPARATA e si   #
#  #  CONFRONTA. Per questo l'uscita va in una cartella SUA, e non   #
#  #  in quella dell'Oanda: una cartella sola sarebbe una serie      #
#  #  sola, e anatomia_esplosioni_oro.py legge TUTTI i .csv della    #
#  #  cartella che gli si passa.                                    #
#  ###################################################################
#
#  ===================================================================
#  IL FUSO -- MISURATO IN CASA, NON ASSUNTO
#  ===================================================================
#  mql5/Scripts/ABTG_ImportaStoricoEsterno_v2.mq5, intestazione
#  (18/08/2026, tre import indipendenti sul PC di backtest):
#      "i timestamp HistData sono ORA LOCALE DI NEW YORK (calendario
#       DST USA), il server BCM segue il calendario DST EUROPEO"
#  e la calibrazione automatica (scansione -6..+6, nessun valore
#  imposto) ha trovato shift base +5 su 8 simboli su 8 il 15/08
#  (REFERTO_IMPORT_6_SIMBOLI.md) e su 3 su 3 il 18/08.
#  Quindi:
#      UTC = ora HistData + 5h   quando New York e' in EST (inverno)
#      UTC = ora HistData + 4h   quando New York e' in EDT (estate)
#  con il calendario USA: seconda domenica di marzo 02:00 locale ->
#  prima domenica di novembre 02:00 locale.
#
#  E NON CI SI FIDA NEMMENO DI QUESTO: il risultato viene COLLAUDATO
#  sull'uscita, con lo STESSO metodo (e la stessa soglia) che usa
#  anatomia_esplosioni_oro.py, PIU' un'ancora ASSOLUTA che quel
#  collaudo non ha. Vedi CONTROLLO 8 qui sotto.
#
#  ===================================================================
#  GLI OTTO CONTROLLI -- tutti fail-closed (exit 2), nessuno opzionale
#  ===================================================================
#   1. forma della riga HistData: AAAAMMGG HHMMSS;O;H;L;C;V
#   2. coerenza OHLC (h >= max(o,c), l <= min(o,c), tutti > 0)
#   3. tempi in ordine crescente, doppioni contati
#   4. ZERO barre nell'ora che NON ESISTE (02:00-02:59 locale della
#      seconda domenica di marzo). Se ce ne fossero, il file NON e'
#      in ora di New York con DST e tutta la conversione salta.
#   5. ZERO barre nell'ora AMBIGUA (01:00-01:59 locale della prima
#      domenica di novembre, che accade due volte).
#   6. banda di prezzo 200-10.000 $ : becca un errore di UNITA'
#   7. volume: si CONTA quanti sono diversi da zero e si DICHIARA.
#      HistData scrive 0 sul forex; se e' 0 anche sull'oro, le
#      sezioni a volume di anatomia_esplosioni_oro.py NON sono
#      misurabili su questa finestra e va scritto nel referto.
#   8. ANCORA DELL'OROLOGIO, sull'uscita:
#      (a) lo spostamento estate-inverno del minuto piu' mosso deve
#          essere -60 +/- 2   (e' il collaudo di anatomia, che pero'
#          da solo NON vede un offset costante sbagliato);
#      (b) IL PICCO INVERNALE DEVE CADERE FRA LE 13:00 E LE 14:00 UTC
#          e quello estivo FRA LE 12:00 E LE 13:00 UTC.
#          E' il dato USA delle 8:30 di New York. QUESTA e' l'ancora
#          ASSOLUTA: senza, un +4 o un +6 al posto del +5 passerebbe
#          il controllo (a) e sballerebbe OGNI etichetta oraria.
#
#  ===================================================================
#  COSA QUESTO STRUMENTO **NON** FA
#  ===================================================================
#  NON e' un backtest. NON tocca MT5. NON scrive preset. NON inventa
#  volume dove non c'e'. NON concatena feed diversi. Legge righe e
#  scrive righe.
#
#  USO
#    python3 backtest_pipeline/histdata_oro_verso_utc.py \
#        --dentro <cartella con gli ZIP/CSV HistData> \
#        --fuori  <cartella di uscita, NUOVA>
#    python3 backtest_pipeline/histdata_oro_verso_utc.py --autotest
# =====================================================================

import argparse
import io
import os
import re
import sys
import zipfile
from datetime import date, datetime, timedelta

VERSIONE = "MARCATORE_HISTDATA_ORO_VERSO_UTC_v1"

# banda di prezzo ammessa per l'oro: serve a beccare un errore di UNITA'
# (centesimi invece di dollari, o un simbolo sbagliato dentro lo zip),
# non a giudicare il mercato. Larga apposta.
PREZZO_MIN, PREZZO_MAX = 200.0, 10000.0

# soglia di scarto oltre la quale il file non e' quello che crediamo
FRAZIONE_SCARTI_MAX = 0.001      # 0,1%

# collaudo dell'orologio: stessi numeri di anatomia_esplosioni_oro.py
MIN_OSSERVAZIONI_MINUTO = 200
SPOSTAMENTO_ATTESO = -60
SPOSTAMENTO_TOLLERANZA = 2
# ancora ASSOLUTA: il dato USA delle 8:30 di New York
BANDA_INVERNO = (13 * 60, 14 * 60)   # 13:00-13:59 UTC
BANDA_ESTATE = (12 * 60, 13 * 60)    # 12:00-12:59 UTC

RIGA_HISTDATA = re.compile(
    r"^(\d{8}) (\d{6});"
    r"(-?\d+(?:\.\d+)?);(-?\d+(?:\.\d+)?);"
    r"(-?\d+(?:\.\d+)?);(-?\d+(?:\.\d+)?);"
    r"(-?\d+(?:\.\d+)?)\s*$")

INTESTAZIONE = "time,close,high,low,open,volume"


def log(m):
    print(m, flush=True)


# ---------------------------------------------------------------------
#  CALENDARIO DST USA -- copiato riga per riga da
#  backtest_pipeline/anatomia_esplosioni_oro.py (r.127-145), che a sua
#  volta l'ha preso da sonda_oro_apertura_m1.py, gia' collaudato il
#  10/09. Si copia invece di importare cosi' questo strumento resta
#  leggibile da solo; il collaudo ne verifica l'identita' (autotest 0).
# ---------------------------------------------------------------------
def domenica_n(anno, mese, n):
    d = date(anno, mese, 1)
    avanti = (6 - d.weekday()) % 7
    return d + timedelta(days=avanti + 7 * (n - 1))


def domenica_ultima(anno, mese):
    if mese == 12:
        d = date(anno + 1, 1, 1) - timedelta(days=1)
    else:
        d = date(anno, mese + 1, 1) - timedelta(days=1)
    return d - timedelta(days=(d.weekday() + 1) % 7)


def dst_usa(g):
    if g.year >= 2007:
        return domenica_n(g.year, 3, 2) <= g < domenica_n(g.year, 11, 1)
    return domenica_n(g.year, 4, 1) <= g < domenica_ultima(g.year, 10)


# ---------------------------------------------------------------------
#  CONVERSIONE -- si lavora ALL'ISTANTE, non alla data.
#  Il salto di primavera avviene alle 02:00 LOCALI della seconda
#  domenica di marzo, quello d'autunno alle 02:00 LOCALI della prima
#  domenica di novembre. Applicare la regola alla DATA invece che
#  all'ISTANTE sbaglierebbe fino a due ore su due giorni l'anno.
#  Sull'oro quelle ore sono a mercato CHIUSO (Wall Street spot: dalla
#  domenica 18:00 ET al venerdi' 17:00 ET), quindi il conto dovrebbe
#  essere identico -- ma "dovrebbe" non e' una misura: i CONTROLLI 4 e
#  5 contano quante barre ci cadono dentro e pretendono ZERO.
# ---------------------------------------------------------------------
def ny_in_dst(t):
    """t = datetime in ora LOCALE di New York -> vero se e' EDT."""
    g = t.date()
    if g.year >= 2007:
        inizio, fine = domenica_n(g.year, 3, 2), domenica_n(g.year, 11, 1)
    else:
        inizio, fine = domenica_n(g.year, 4, 1), domenica_ultima(g.year, 10)
    if g < inizio or g > fine:
        return False
    if g == inizio:
        return t.hour >= 2        # prima delle 02:00 locali e' ancora EST
    if g == fine:
        return t.hour < 2         # l'ambiguita' e' risolta verso EDT: CONTROLLO 5
    return True


def verso_utc(t):
    """ora locale di New York -> UTC."""
    return t + timedelta(hours=(4 if ny_in_dst(t) else 5))


def ora_inesistente(t):
    """02:00-02:59 locali della seconda domenica di marzo: NON ESISTE."""
    g = t.date()
    if g.year >= 2007:
        salto = domenica_n(g.year, 3, 2)
    else:
        salto = domenica_n(g.year, 4, 1)
    return g == salto and t.hour == 2


def ora_ambigua(t):
    """01:00-01:59 locali della prima domenica di novembre: accade DUE volte."""
    g = t.date()
    if g.year >= 2007:
        ritorno = domenica_n(g.year, 11, 1)
    else:
        ritorno = domenica_ultima(g.year, 10)
    return g == ritorno and t.hour == 1


# ---------------------------------------------------------------------
#  LETTURA DEGLI INGRESSI
#  HistData ASCII M1:  AAAAMMGG HHMMSS;O;H;L;C;V   (punto e virgola,
#  ordine O,H,L,C -- e il formato Oanda in uscita vuole C,H,L,O).
#  I PREZZI SI RISCRIVONO COME STRINGHE, TALI E QUALI: niente
#  float->str, quindi niente arrotondamenti e niente separatore
#  decimale che dipende dalla localizzazione.
# ---------------------------------------------------------------------
def righe_di(percorso):
    """restituisce (etichetta, iteratore di righe) per uno zip o un csv."""
    if percorso.lower().endswith(".zip"):
        with zipfile.ZipFile(percorso) as z:
            nomi = [n for n in z.namelist() if n.lower().endswith(".csv")]
            if len(nomi) != 1:
                raise ValueError(
                    "lo zip %s contiene %d csv (atteso 1): %s"
                    % (os.path.basename(percorso), len(nomi), nomi))
            dati = z.read(nomi[0]).decode("ascii", "replace")
        return nomi[0], dati.splitlines()
    with open(percorso, "r", encoding="ascii", errors="replace") as f:
        return os.path.basename(percorso), f.read().splitlines()


def elenca_ingressi(cartella):
    v = []
    for n in sorted(os.listdir(cartella)):
        b = n.lower()
        if b.endswith(".zip") or (b.endswith(".csv") and "_m1_" in b):
            v.append(os.path.join(cartella, n))
    return v


def converti(cartella_in, cartella_out, cont, anni_out=None):
    """legge, controlla, converte. Restituisce {anno: [righe csv]}."""
    ingressi = elenca_ingressi(cartella_in)
    if not ingressi:
        raise ValueError("nessuno zip/csv HistData in %s" % cartella_in)
    per_anno = {}
    ultimo = {}
    for p in ingressi:
        etichetta, righe = righe_di(p)
        cont["file"] += 1
        n_file = 0
        for riga in righe:
            riga = riga.strip()
            if not riga:
                continue
            m = RIGA_HISTDATA.match(riga)
            if not m:
                cont["forma_sbagliata"] += 1
                cont["scartate"] += 1
                continue
            g, hh = m.group(1), m.group(2)
            so, sh, sl, sc, sv = m.group(3), m.group(4), m.group(5), m.group(6), m.group(7)
            try:
                t = datetime(int(g[0:4]), int(g[4:6]), int(g[6:8]),
                             int(hh[0:2]), int(hh[2:4]), int(hh[4:6]))
            except ValueError:
                cont["data_impossibile"] += 1
                cont["scartate"] += 1
                continue
            o, h, l, c = float(so), float(sh), float(sl), float(sc)
            if o <= 0 or h <= 0 or l <= 0 or c <= 0:
                cont["ohlc_incoerenti"] += 1
                cont["scartate"] += 1
                continue
            if h < max(o, c) - 1e-9 or l > min(o, c) + 1e-9 or h < l:
                cont["ohlc_incoerenti"] += 1
                cont["scartate"] += 1
                continue
            if not (PREZZO_MIN <= o <= PREZZO_MAX and PREZZO_MIN <= c <= PREZZO_MAX):
                cont["fuori_banda"] += 1
                cont["scartate"] += 1
                continue
            if ora_inesistente(t):
                cont["ora_inesistente"] += 1
            if ora_ambigua(t):
                cont["ora_ambigua"] += 1
            if float(sv) != 0.0:
                cont["volume_non_zero"] += 1
            prec = ultimo.get(etichetta)
            if prec is not None:
                if t < prec:
                    cont["fuori_ordine"] += 1
                elif t == prec:
                    cont["doppioni"] += 1
            ultimo[etichetta] = t
            tu = verso_utc(t)
            # FORMATO OANDA: time,close,high,low,open,volume  -- C,H,L,O!
            per_anno.setdefault(tu.year, []).append(
                (tu, "%04d-%02d-%02d %02d:%02d,%s,%s,%s,%s,%s"
                 % (tu.year, tu.month, tu.day, tu.hour, tu.minute,
                    sc, sh, sl, so, sv)))
            cont["barre"] += 1
            n_file += 1
        cont["per_file"].append((etichetta, n_file))
    for anno in per_anno:
        per_anno[anno].sort(key=lambda x: x[0])
    if cartella_out:
        os.makedirs(cartella_out, exist_ok=True)
        for anno in sorted(per_anno):
            if anni_out and anno not in anni_out:
                continue
            nome = os.path.join(cartella_out, "XAUUSD_M1_UTC_%04d.csv" % anno)
            with open(nome, "w", encoding="ascii", newline="") as f:
                f.write(INTESTAZIONE + "\n")
                for _, riga in per_anno[anno]:
                    f.write(riga + "\n")
            cont["scritti"].append((nome, len(per_anno[anno])))
    return per_anno


# ---------------------------------------------------------------------
#  CONTROLLO 8 -- L'ANCORA DELL'OROLOGIO, SULL'USCITA
#  Stesso metodo di anatomia_esplosioni_oro.py (mediana di |close-open|
#  per minuto del giorno, mesi 12-1-2 contro 6-7-8, n>=200), PIU'
#  l'ancora ASSOLUTA che quel collaudo non ha.
# ---------------------------------------------------------------------
def mediana(v):
    if not v:
        return float("nan")
    s = sorted(v)
    n = len(s)
    return s[n // 2] if n % 2 else 0.5 * (s[n // 2 - 1] + s[n // 2])


def collauda_orologio(per_anno):
    inv, est = {}, {}
    for anno in per_anno:
        for t, riga in per_anno[anno]:
            p = riga.split(",")
            c, o = float(p[1]), float(p[4])
            m = t.hour * 60 + t.minute
            if t.month in (12, 1, 2):
                inv.setdefault(m, []).append(abs(c - o))
            elif t.month in (6, 7, 8):
                est.setdefault(m, []).append(abs(c - o))

    def cima(d, quanti=5):
        v = [(mediana(x), m, len(x)) for m, x in d.items()
             if len(x) >= MIN_OSSERVAZIONI_MINUTO]
        v.sort(reverse=True)
        return v[:quanti]

    ci, ce = cima(inv), cima(est)
    return ci, ce


def giudica_orologio(ci, ce, out):
    out("  CONTROLLO 8 -- ANCORA DELL'OROLOGIO (mediana di |close-open|, n>=%d)"
        % MIN_OSSERVAZIONI_MINUTO)
    if not ci or not ce:
        out("    NON MISURABILE: servono mesi invernali E estivi con n>=%d."
            % MIN_OSSERVAZIONI_MINUTO)
        return False
    for eti, c in (("inverno (12-1-2)", ci), ("estate  (6-7-8)", ce)):
        out("    %-17s %s" % (eti, "  ".join(
            "%02d:%02d (%.4f n=%d)" % (m // 60, m % 60, v, n) for v, m, n in c)))
    spost = ce[0][1] - ci[0][1]
    out("    (a) spostamento estate-inverno = %+d minuti (atteso %+d +/- %d)"
        % (spost, SPOSTAMENTO_ATTESO, SPOSTAMENTO_TOLLERANZA))
    ok_a = abs(spost - SPOSTAMENTO_ATTESO) <= SPOSTAMENTO_TOLLERANZA
    ok_b1 = BANDA_INVERNO[0] <= ci[0][1] < BANDA_INVERNO[1]
    ok_b2 = BANDA_ESTATE[0] <= ce[0][1] < BANDA_ESTATE[1]
    out("    (b) picco inverno %02d:%02d UTC (banda %02d:00-%02d:59) -> %s"
        % (ci[0][1] // 60, ci[0][1] % 60, BANDA_INVERNO[0] // 60,
           BANDA_INVERNO[1] // 60 - 1, "OK" if ok_b1 else "FUORI"))
    out("    (b) picco estate  %02d:%02d UTC (banda %02d:00-%02d:59) -> %s"
        % (ce[0][1] // 60, ce[0][1] % 60, BANDA_ESTATE[0] // 60,
           BANDA_ESTATE[1] // 60 - 1, "OK" if ok_b2 else "FUORI"))
    if not ok_a:
        out("    FALLITO (a): il calendario DST applicato e' SBAGLIATO.")
    if not (ok_b1 and ok_b2):
        out("    FALLITO (b): l'offset COSTANTE e' sbagliato di un'ora o piu'.")
        out("        Il controllo (a) da solo NON lo vede: e' per questo che (b) esiste.")
    return ok_a and ok_b1 and ok_b2


# =====================================================================
#  AUTOTEST -- I CONTRO-ESEMPI, COSTRUITI PER FAR SBAGLIARE QUESTO FILE
# =====================================================================
def _serie_finta(anni, offset_ore=None, minuto_picco=(8, 30)):
    """Serie M1 finta in ora LOCALE DI NEW YORK, con un'esplosione
    piantata alle 8:30 di New York di ogni giorno feriale. Se
    offset_ore e' diverso da None, i timestamp vengono SPOSTATI di
    quelle ore: serve a fabbricare un file che NON e' in ora di New
    York, e a vedere se il collaudo lo becca."""
    righe = []
    prezzo = 1800.0
    for anno in anni:
        for mese in (1, 2, 6, 7, 8, 12):
            for giorno in range(1, 29):
                g = date(anno, mese, giorno)
                if g.weekday() >= 5:
                    continue
                for ora in range(0, 24):
                    for minuto in (0, 15, 30, 45):
                        t = datetime(anno, mese, giorno, ora, minuto)
                        if offset_ore:
                            t = t + timedelta(hours=offset_ore)
                        grande = (ora, minuto) == minuto_picco
                        d = 5.0 if grande else 0.1
                        o = prezzo
                        c = prezzo + d
                        h = max(o, c) + 0.2
                        l = min(o, c) - 0.2
                        righe.append("%04d%02d%02d %02d%02d00;%.3f;%.3f;%.3f;%.3f;0"
                                     % (t.year, t.month, t.day, t.hour, t.minute,
                                        o, h, l, c))
    return righe


def _converti_righe(righe, cont):
    """come converti(), ma su una lista di righe in memoria."""
    import tempfile
    d = tempfile.mkdtemp()
    p = os.path.join(d, "DAT_ASCII_XAUUSD_M1_2021.csv")
    with open(p, "w", encoding="ascii") as f:
        f.write("\n".join(righe) + "\n")
    return converti(d, None, cont)


def nuovo_contatore():
    return {"file": 0, "barre": 0, "scartate": 0, "forma_sbagliata": 0,
            "data_impossibile": 0, "ohlc_incoerenti": 0, "fuori_banda": 0,
            "ora_inesistente": 0, "ora_ambigua": 0, "volume_non_zero": 0,
            "doppioni": 0, "fuori_ordine": 0, "per_file": [], "scritti": []}


def autotest():
    log("=" * 70)
    log(VERSIONE + "  --  AUTOTEST (i contro-esempi)")
    log("=" * 70)
    esiti = []

    def prova(nome, ok, nota=""):
        esiti.append((nome, ok, nota))
        log("  [%s] %s%s" % ("PASS" if ok else "FALLITO", nome,
                             ("  -- " + nota) if nota else ""))

    # --- 0. il calendario DST e' LO STESSO di anatomia_esplosioni_oro.py
    try:
        sys.path.insert(0, os.path.dirname(os.path.abspath(__file__)))
        import anatomia_esplosioni_oro as an
        uguali = all(an.dst_usa(date(a, m, g)) == dst_usa(date(a, m, g))
                     for a in range(2006, 2031) for m in range(1, 13)
                     for g in (1, 8, 14, 15, 21, 28))
        prova("0. calendario DST identico a anatomia_esplosioni_oro.py", uguali)
    except Exception as e:                                   # pragma: no cover
        prova("0. calendario DST identico a anatomia_esplosioni_oro.py",
              False, "non importabile: %s" % e)
        an = None

    # --- 1. ordine delle colonne: C,H,L,O e NON O,H,L,C
    cont = nuovo_contatore()
    righe = ["20210104 093000;1800.000;1805.000;1799.000;1804.000;0"]
    pa = _converti_righe(righe, cont)
    riga = pa[2021][0][1]
    campi = riga.split(",")
    ok = (campi[1] == "1804.000" and campi[2] == "1805.000"
          and campi[3] == "1799.000" and campi[4] == "1800.000")
    prova("1. colonne C,H,L,O (non O,H,L,C)", ok, riga)

    # --- 1-bis. e il LETTORE VERO le rilegge come le abbiamo scritte?
    if an is not None:
        import tempfile
        d = tempfile.mkdtemp()
        with open(os.path.join(d, "x.csv"), "w", encoding="ascii") as f:
            f.write(INTESTAZIONE + "\n" + riga + "\n")
        c2 = {"barre": 0, "righe_scartate": 0, "ohlc_incoerenti": 0,
              "file_formato_ignoto": 0}
        letti = list(an.leggi_tutto(d, c2))
        ok = (len(letti) == 1 and c2["file_formato_ignoto"] == 0
              and abs(letti[0][1] - 1800.0) < 1e-9      # open
              and abs(letti[0][2] - 1805.0) < 1e-9      # high
              and abs(letti[0][3] - 1799.0) < 1e-9      # low
              and abs(letti[0][4] - 1804.0) < 1e-9)     # close
        prova("1-bis. anatomia_esplosioni_oro.leggi_tutto rilegge O/H/L/C giusti",
              ok, "letti=%d ignoti=%d" % (len(letti), c2["file_formato_ignoto"]))

    # --- 2. il fuso e' applicato: 09:30 NY del 4 gennaio -> 14:30 UTC
    ok = (pa[2021][0][0] == datetime(2021, 1, 4, 14, 30))
    prova("2. inverno: 09:30 New York -> 14:30 UTC (+5)", ok, str(pa[2021][0][0]))

    cont = nuovo_contatore()
    pa2 = _converti_righe(
        ["20210705 093000;1800.000;1805.000;1799.000;1804.000;0"], cont)
    ok = (pa2[2021][0][0] == datetime(2021, 7, 5, 13, 30))
    prova("3. estate: 09:30 New York -> 13:30 UTC (+4)", ok, str(pa2[2021][0][0]))

    # --- 4. i confini DST, all'ISTANTE e non alla data
    #  2021: seconda domenica di marzo = 14/03 ; prima di novembre = 07/11
    casi = [
        (datetime(2021, 3, 14, 1, 59), datetime(2021, 3, 14, 6, 59), "prima del salto: +5"),
        (datetime(2021, 3, 14, 3, 0), datetime(2021, 3, 14, 7, 0), "dopo il salto: +4"),
        (datetime(2021, 3, 13, 23, 0), datetime(2021, 3, 14, 4, 0), "sabato sera: +5"),
        (datetime(2021, 11, 7, 0, 30), datetime(2021, 11, 7, 4, 30), "prima del ritorno: +4"),
        (datetime(2021, 11, 7, 3, 0), datetime(2021, 11, 7, 8, 0), "dopo il ritorno: +5"),
    ]
    ok = all(verso_utc(a) == b for a, b in [(x[0], x[1]) for x in casi])
    prova("4. confini DST USA calcolati all'ISTANTE", ok,
          "; ".join("%s -> %s" % (a.strftime("%d/%m %H:%M"),
                                  verso_utc(a).strftime("%d/%m %H:%M"))
                    for a, _, _ in casi))

    # --- 5. l'ora che NON ESISTE viene CONTATA
    cont = nuovo_contatore()
    _converti_righe(["20210314 023000;1800.0;1801.0;1799.0;1800.5;0"], cont)
    prova("5. barra nell'ora inesistente (14/03/2021 02:30 NY) CONTATA",
          cont["ora_inesistente"] == 1, "contate=%d" % cont["ora_inesistente"])

    # --- 6. l'ora AMBIGUA viene CONTATA
    cont = nuovo_contatore()
    _converti_righe(["20211107 013000;1800.0;1801.0;1799.0;1800.5;0"], cont)
    prova("6. barra nell'ora ambigua (07/11/2021 01:30 NY) CONTATA",
          cont["ora_ambigua"] == 1, "contate=%d" % cont["ora_ambigua"])

    # --- 7. separatore decimale e precisione: i prezzi passano TALI E QUALI
    cont = nuovo_contatore()
    pa3 = _converti_righe(
        ["20210104 093000;1803.1234567;1899.9999999;1700.0000001;1803.1234568;0"],
        cont)
    riga = pa3[2021][0][1]
    ok = ("1803.1234568,1899.9999999,1700.0000001,1803.1234567" in riga
          and "," in riga and ";" not in riga)
    prova("7. prezzi riscritti TALI E QUALI (nessun float->str, nessuna virgola decimale)",
          ok, riga)

    # --- 8. banda di prezzo: un errore di UNITA' viene scartato
    cont = nuovo_contatore()
    _converti_righe(["20210104 093000;180312.0;180500.0;179900.0;180400.0;0"], cont)
    prova("8. prezzo fuori banda (centesimi invece di dollari) SCARTATO",
          cont["fuori_banda"] == 1 and cont["barre"] == 0,
          "fuori_banda=%d barre=%d" % (cont["fuori_banda"], cont["barre"]))

    # --- 9. OHLC incoerente scartato
    cont = nuovo_contatore()
    _converti_righe(["20210104 093000;1800.0;1799.0;1801.0;1800.5;0"], cont)
    prova("9. OHLC incoerente (high<low) SCARTATO",
          cont["ohlc_incoerenti"] == 1 and cont["barre"] == 0,
          "incoerenti=%d" % cont["ohlc_incoerenti"])

    # --- 10. IL CONTRO-ESEMPIO CHE CONTA: la serie GIUSTA passa l'ancora
    cont = nuovo_contatore()
    pa4 = _converti_righe(_serie_finta([2021, 2022, 2023, 2024]), cont)
    ci, ce = collauda_orologio(pa4)
    righe_log = []
    ok = giudica_orologio(ci, ce, lambda m: righe_log.append(m))
    prova("10. serie in ora di New York: l'ancora dell'orologio PASSA", ok,
          "inverno %02d:%02d UTC, estate %02d:%02d UTC"
          % (ci[0][1] // 60, ci[0][1] % 60, ce[0][1] // 60, ce[0][1] % 60)
          if ci and ce else "non misurabile")

    # --- 11. IL CONTRO-ESEMPIO PIU' PERICOLOSO: offset costante SBAGLIATO
    #  un file spostato di +1h passerebbe il collaudo (a) di anatomia
    #  (lo spostamento stagionale resta -60) e sballerebbe OGNI ora.
    cont = nuovo_contatore()
    pa5 = _converti_righe(_serie_finta([2021, 2022, 2023, 2024], offset_ore=1), cont)
    ci5, ce5 = collauda_orologio(pa5)
    spost5 = ce5[0][1] - ci5[0][1] if (ci5 and ce5) else None
    righe_log = []
    ok5 = giudica_orologio(ci5, ce5, lambda m: righe_log.append(m))
    prova("11. file spostato di +1h: (a) da solo NON lo vede",
          spost5 == SPOSTAMENTO_ATTESO,
          "spostamento stagionale = %s minuti (identico al caso giusto)" % spost5)
    prova("11-bis. ma l'ancora ASSOLUTA (b) lo RIFIUTA", not ok5,
          "picco inverno %02d:%02d UTC invece della banda 13:xx"
          % (ci5[0][1] // 60, ci5[0][1] % 60) if ci5 else "")

    # --- 12. e anche -1h viene rifiutato (l'altro verso)
    cont = nuovo_contatore()
    pa6 = _converti_righe(_serie_finta([2021, 2022, 2023, 2024], offset_ore=-1), cont)
    ci6, ce6 = collauda_orologio(pa6)
    righe_log = []
    ok6 = giudica_orologio(ci6, ce6, lambda m: righe_log.append(m))
    prova("12. file spostato di -1h: RIFIUTATO dall'ancora assoluta", not ok6,
          "picco inverno %02d:%02d UTC" % (ci6[0][1] // 60, ci6[0][1] % 60)
          if ci6 else "")

    # --- 13. il weekend: HistData non scrive barre, e NON se ne inventano
    cont = nuovo_contatore()
    pa7 = _converti_righe(
        ["20210108 170000;1800.0;1801.0;1799.0;1800.5;0",
         "20210110 180000;1800.0;1801.0;1799.0;1800.5;0"], cont)
    ok = (cont["barre"] == 2)
    prova("13. weekend: due barre dentro, DUE barre fuori (nessun riempimento)",
          ok, "barre=%d" % cont["barre"])

    # --- 14. volume a zero: si CONTA, non si inventa
    prova("14. volume a zero contato e dichiarato (non inventato)",
          cont["volume_non_zero"] == 0,
          "volume_non_zero=%d" % cont["volume_non_zero"])

    log("")
    falliti = [n for n, o, _ in esiti if not o]
    log("AUTOTEST: %d prove, %d passate, %d fallite"
        % (len(esiti), len(esiti) - len(falliti), len(falliti)))
    if falliti:
        for n in falliti:
            log("  FALLITA: " + n)
        return 2
    log("ESITO: TUTTO VERDE.")
    return 0


# =====================================================================
def main():
    ap = argparse.ArgumentParser()
    ap.add_argument("--dentro", default="",
                    help="cartella con gli ZIP/CSV HistData")
    ap.add_argument("--fuori", default="",
                    help="cartella di uscita (NUOVA: non quella dell'Oanda)")
    ap.add_argument("--anni", default="",
                    help="anni da scrivere, separati da virgola (vuoto = tutti)")
    ap.add_argument("--autotest", action="store_true")
    a = ap.parse_args()

    if a.autotest:
        sys.exit(autotest())

    if not a.dentro or not a.fuori:
        ap.error("servono --dentro e --fuori (oppure --autotest)")
    if os.path.abspath(a.dentro) == os.path.abspath(a.fuori):
        log("STOP: --dentro e --fuori sono la stessa cartella.")
        sys.exit(2)

    log("=" * 70)
    log(VERSIONE)
    log("=" * 70)
    log("IL 2021-2026 E' UNA FINESTRA SEPARATA: non si concatena con")
    log("l'Oanda 2006-2020. Uscita in una cartella SUA.")
    log("")

    anni_out = None
    if a.anni:
        anni_out = set(int(x) for x in a.anni.split(",") if x.strip())

    cont = nuovo_contatore()
    per_anno = converti(a.dentro, a.fuori, cont, anni_out)

    log("LETTURA")
    for eti, n in cont["per_file"]:
        log("    %-44s %8d barre" % (eti, n))
    log("")
    log("  barre convertite      = %d" % cont["barre"])
    log("  righe scartate        = %d  (forma %d, data %d, OHLC %d, banda %d)"
        % (cont["scartate"], cont["forma_sbagliata"], cont["data_impossibile"],
           cont["ohlc_incoerenti"], cont["fuori_banda"]))
    log("  doppioni / fuori ordine = %d / %d"
        % (cont["doppioni"], cont["fuori_ordine"]))
    log("  CONTROLLO 4 barre nell'ora INESISTENTE = %d (atteso 0)"
        % cont["ora_inesistente"])
    log("  CONTROLLO 5 barre nell'ora AMBIGUA     = %d (atteso 0)"
        % cont["ora_ambigua"])
    log("  CONTROLLO 7 barre con volume != 0      = %d su %d"
        % (cont["volume_non_zero"], cont["barre"]))
    if cont["volume_non_zero"] == 0:
        log("      >>> IL VOLUME E' ZERO SU TUTTO IL FEED. Le sezioni a")
        log("          volume di anatomia_esplosioni_oro.py (6-ter e 9) NON")
        log("          sono misurabili su questa finestra: va SCRITTO nel")
        log("          referto, non lasciato leggere come 'nessun effetto'.")
    log("")
    log("SCRITTI")
    for nome, n in cont["scritti"]:
        log("    %-60s %8d righe" % (os.path.basename(nome), n))
    log("")

    grave = False
    if cont["barre"] == 0:
        log("STOP: zero barre convertite.")
        sys.exit(2)
    if cont["scartate"] > FRAZIONE_SCARTI_MAX * (cont["barre"] + cont["scartate"]):
        log("STOP: troppe righe scartate (%.3f%%, tetto %.3f%%): il file non e'"
            % (100.0 * cont["scartate"] / (cont["barre"] + cont["scartate"]),
               100.0 * FRAZIONE_SCARTI_MAX))
        log("      quello che crediamo. Non si prosegue.")
        grave = True
    if cont["ora_inesistente"] > 0:
        log("STOP (CONTROLLO 4): ci sono barre nell'ora che NON ESISTE in ora")
        log("      di New York. Allora il file NON e' in ora di New York, e la")
        log("      conversione applicata e' sbagliata per costruzione.")
        grave = True
    if cont["fuori_ordine"] > 0:
        log("STOP (CONTROLLO 3): %d righe fuori ordine." % cont["fuori_ordine"])
        grave = True

    ci, ce = collauda_orologio(per_anno)
    if not giudica_orologio(ci, ce, log):
        grave = True

    log("")
    if grave:
        log("ESITO: FALLITO. I file scritti NON si usano.")
        sys.exit(2)
    log("ESITO: PASSATO. I file in %s sono in UTC e nel formato Oanda." % a.fuori)
    log("")
    log("PROSSIMO PASSO (finestra SEPARATA, mai concatenata):")
    log("  python3 backtest_pipeline/anatomia_esplosioni_oro.py \\")
    log("      --dati %s \\" % a.fuori)
    log("      --news mql5/Files/abtg_news_postnews_2010_2025_UTC.csv,"
        "mql5/Files/abtg_news_usd1330_2010_2023_UTC.csv,"
        "mql5/Files/abtg_news_ism1500_2010_2023_UTC.csv \\")
    log("      --fuori backtest_pipeline/risultati_prove/"
        "ANATOMIA_ESPLOSIONI_ORO_2021_2026.txt")
    sys.exit(0)


if __name__ == "__main__":
    main()
