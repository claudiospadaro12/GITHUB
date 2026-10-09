#!/usr/bin/env python3
# -*- coding: ascii -*-
"""
leggi_natcla_f0.py -- IL LETTORE del PASSO 0 (F0) di 'Ea Nat&Cla'. Legge cio' che torna da NATCLA_F0_PASSATE.ps1 (zip o cartella: MANIFEST_F0.csv, csv\\natcla_setup_*.csv,
log\\EA_*.txt, il file prova copiato) e stampa la TABELLA: setup per anno per linea e simbolo (regola 'n = SETUP', specifica 5.5), il confronto con le attese SCRITTE PRIMA nel
file prova, i simboli 'vivi', la riga VERIFICA ADX estratta dai log, il costo (stop/pedaggio per ordine), l'inclinazione (P25/P50/P75) e lo split dell'orologio.
NON giudica merito: nessun PF, nessun DD (il Modello 1 puo' solo bocciare, specifica 5.1). NON promuove niente.

USO
  python3 backtest_pipeline/leggi_natcla_f0.py NATCLA_F0_PILOTA.zip [altro.zip ...] [--prova FILE] [--csv-out F0_tabella.csv]
  python3 backtest_pipeline/leggi_natcla_f0.py --autotest          (dati finti con risposta nota + contro-esempi; esce 1 se un controllo cade)

LA REGOLA DEL CONTO (identica a quella scritta nel file prova): una riga CONTA e' un SETUP se nuovo_ep=1 E tocco_n <= limite della linea (ST25 1, ST30 1, ST35 2, E200 illimitato:
letti dalla riga '#cfg;TocchiMax' del CSV) E ctx_arm=0 (contesto valido alla barra in cui la scala si arma = la barra PRIMA del tocco). n = setup, mai righe, mai ordini.

v1.10 DELL'EA (09/10, regola di stop di Claudio dell'08/10): il CSV ha TRE colonne in coda (stop_modo, linea_stop, stop_esito) e la riga '#cfg;Stop'. Il lettore legge
anche i CSV della v1.04/v1.05 (44 colonne, stop = GEOMETRIA_ATTUALE). Il COSTO si calcola come prima (|p - SL| / pedaggio) dallo SL scritto dall'EA, quindi riflette la
regola di stop della passata, che la tabella DICHIARA; i setup con stop_esito 1 (linea esterna discorde: l'EA NON li arma) restano nel conto n (regola del file prova,
scritta prima) ma ESCONO dal costo e sono contati a parte. Ogni riga OLTRE si ricontrolla: SL = linea_stop -/+ N u (esito 0), oltre X4 (esito 2), SL 0 (esito 1).
Il DETERMINISMO si confronta solo fra passate con la STESSA regola di stop; la v1.10 in GEOMETRIA_ATTUALE ha la stessa impronta della v1.05.
v1.11 DELL'EA (09/10, Claudio "Proviamole entrambe"): terzo modo OLTRE_PIU_ESTERNA (stop_modo = 2), stessi campi. La riga si ricontrolla come OLTRE
(SL = linea_stop -/+ N u); in piu', per tutti e due i modi OLTRE: sulla linea E200 la linea dello stop E' la linea del setup; sulla ST35 lo e' in
OLTRE_LINEA_ESTERNA, e in OLTRE_PIU_ESTERNA e' la linea del setup o una PIU' esterna (mai dentro). La scelta fra ST3,5 ed EMA200 non e' nel CSV.
"""
import csv, datetime, hashlib, io, os, re, statistics, sys, tempfile, zipfile

QD = os.path.dirname(os.path.abspath(__file__))
REPO = os.path.abspath(os.path.join(QD, ".."))
PROVA_REPO = os.path.join(REPO, "backtest_pipeline", "prove", "NATCLA_F0_conteggio_2026-10-07.txt")

# ---------------------------------------------------------------------------------------------------------------------
#  SOGLIE E ATTESE -- tutte copiate dal file prova / dalla specifica (7 ottobre), scritte PRIMA dei numeri
# ---------------------------------------------------------------------------------------------------------------------
VIVO_E0 = 70                  # E0: AUDIO_H1, setup >= 70 per simbolo nella finestra
FAMIGLIA_E3 = 300             # E3: 150 IS + 150 OOS setup
LAVORO_X = 40.0               # E2: stop >= 40 x pedaggio = PASSA IL LAVORO
DURO_X = 13.3                 # E2: sotto = ESCLUSO PER ARITMETICA
VERSIONE_EA = "1.11"           # 09/10: secondo modo di stop OLTRE_PIU_ESTERNA (v1.10: OLTRE_LINEA_ESTERNA; default GEOMETRIA_ATTUALE = v1.05)
VERSIONI_VALIDE = ("1.05", "1.10", "1.11")
VERSIONI_CON_STOP = ("1.10", "1.11")   # versioni che DEVONO dichiarare la regola di stop nella riga AVVIO
MODI_STOP = {"GEOMETRIA_ATTUALE": "0", "OLTRE_LINEA_ESTERNA": "1", "OLTRE_PIU_ESTERNA": "2"}   # valore della colonna stop_modo   # 1.05 = il tocco degli handle in CaricaDati (diagnosi NATCLA_DIAG_U30): lotti F0 al pin d6586360, validi
# lotti girati PRIMA del rimedio (PILOTA, A, B, D del 07/10, EA v1.04): si leggono, ma ogni passata e' MARCATA e contata a parte nel riepilogo.
# La v1.05 cambia qualcosa solo dove la v1.04 restava bloccata (collaudo_natcla.py, modelli 0 e 2): sul forex e sull'oro le righe CONTA attese
# sono IDENTICHE, e XAUUSD (PILOTA v1.04 contro lotto C v1.05) lo misura nel DETERMINISMO.
VERSIONI_ARCHIVIO = ("1.04",)
FINE_FINESTRA = datetime.date(2026, 6, 30)
CAMBIO_OROLOGIO_DA = datetime.date(2024, 12, 26)     # forex: ultimo giorno col vecchio orologio (specifica 5.5)
CAMBIO_OROLOGIO_A = datetime.date(2025, 2, 3)        # forex: primo giorno col nuovo orologio sicuro (02/02/2025 23:05 e' l'ultimo dubbio)
LIMITI_ATTESI = {"ST25": 1, "ST30": 1, "ST35": 2, "E200": 0}
# oro HistData (NON BCM, orologio +6 h), specifica 5.4, per anno, per linea ST25/ST30/ST35: episodi, entro il limite, con iADX<=20 alla barra del tocco
ORO_HISTDATA = {"episodi": (151.0, 121.0, 97.0), "limite": (101.0, 84.0, 88.0), "adx20_tocco": (16.0, 18.0, 16.0)}
ORO_WILDER_TOCCO = (40.0, 36.0, 36.0)               # stessa colonna con l'ADX di WILDER (specifica 5.4, ricontato dal cancello): il doppio di iADX. Serve a distinguere le due ipotesi
ORO_SETUP_ATTESI_ANNO = (101.0, 84.0, 21.0)          # ST25, ST30 (senza ADX), ST35 (iADX<=20 alla barra PRIMA): ~206/anno
BANDA_COERENTE = (0.5, 2.0)
BANDA_GUARDARE = (0.1, 10.0)
INCL_ORO_H1 = (0.34, 0.69, 1.18)                     # P25/P50/P75 su TUTTE le barre (popolazione diversa dai setup)
SPREAD_VIVO = {"EURUSD": 0.2, "GBPUSD": 0.3, "USDJPY": 0.3, "D30EUR": 1.6, "NASUSD": 1.8, "U30USD": 2.0, "225JPY": 22.0, "XAUUSD": 0.21}   # specifica 5.3: pip / punti indice / USD (5 giornate, 04-11/09/2026)
BANDA_SPREAD = (0.5, 2.0)
LINEE = ("ST25", "ST30", "ST35", "E200")
CAMPI_NUM = ("tocco_n", "nuovo_ep", "troncato", "ctx_arm", "ctx_tocco")


# ---------------------------------------------------------------------------------------------------------------------
#  UN SORGENTE = uno zip o una cartella
# ---------------------------------------------------------------------------------------------------------------------
class Sorgente:
    def __init__(self, percorso):
        self.percorso = percorso
        self.zip = None
        if os.path.isdir(percorso):
            # SEPARATORI (07/10, lettura del pilota): Compress-Archive scrive i nomi con il BACKSLASH ('csv\natcla_...'); estratti su Linux diventano FILE
            # con il backslash nel nome, non sottocartelle. Si normalizza come per lo zip, e si ricorda il percorso VERO di ogni nome normalizzato.
            self.nomi = []
            self.reali = {}
            for rd, _d, files in os.walk(percorso):
                for f in files:
                    vero = os.path.join(rd, f)
                    nome = os.path.relpath(vero, percorso).replace(os.sep, "/").replace("\\", "/")
                    if nome in self.reali:
                        if open(self.reali[nome], "rb").read() != open(vero, "rb").read():
                            raise ValueError("due file diversi con lo stesso nome normalizzato '%s' (uno col backslash, uno in sottocartella): quale si legge e' ambiguo" % nome)
                        continue
                    self.reali[nome] = vero
                    self.nomi.append(nome)
        else:
            self.zip = zipfile.ZipFile(percorso)
            self.nomi = [n.replace("\\", "/") for n in self.zip.namelist() if not n.endswith("/")]

    def leggi(self, nome):
        if self.zip is not None:
            for n in self.zip.namelist():
                if n.replace("\\", "/") == nome:
                    return self.zip.read(n)
            raise KeyError(nome)
        return open(self.reali[nome], "rb").read()

    def ha(self, nome):
        return nome in self.nomi


def testo(b):
    if b[:2] == b"\xff\xfe":
        return b.decode("utf-16-le").lstrip("\ufeff")
    return b.decode("ascii", errors="replace")


# ---------------------------------------------------------------------------------------------------------------------
#  IL FILE PROVA: i blocchi @F0 (la sola fonte di simboli, configurazioni e lotti)
# ---------------------------------------------------------------------------------------------------------------------
def leggi_blocchi(txt):
    r = {"config": {}, "simboli": {}, "lotti": {}}
    for l in txt.splitlines():
        m = re.match(r"^#\s*@F0-(CONFIG|SIMBOLO|LOTTO)\s+(.*)$", l.strip())
        if not m:
            continue
        kv = {}
        for pezzo in m.group(2).split():
            a, b = pezzo.split("=", 1)
            assert a not in kv, "chiave doppia nel blocco: " + l
            kv[a] = b
        r[{"CONFIG": "config", "SIMBOLO": "simboli", "LOTTO": "lotti"}[m.group(1)]][kv["nome"]] = kv
    return r


# ---------------------------------------------------------------------------------------------------------------------
#  I CONTROLLI DELL'AVVIO e della VERIFICA ADX (rifatti qui, indipendenti da quelli del driver)
# ---------------------------------------------------------------------------------------------------------------------
RE_AVVIO = re.compile(r"AVVIO v(?P<v>[0-9.]+) \| modalita' (?P<mod>\w+) \| (?P<sym>\S+) PERIOD_(?P<tf>\w+) \| 1 u = (?P<u>[0-9.]+) \((?P<descr>.*?)\) \| 1 pip = (?P<pip>[0-9.]+) \| "
                      r"magic (?P<mg>[0-9]+) \| linee (?P<linee>.*?)\s*\| ADX (?P<adx>ACCESO|spento), (?P<tipo>iADX MetaQuotes|iADXWilder), max (?P<max>[0-9.]+), periodo (?P<per>[0-9]+) \| "
                      r"ingresso (?P<ing>\w+) \| rischio setup (?P<risk>[0-9.]+)% .*?\| guardian .*?\| solo conta (?P<sc>\w+) \| placebo (?P<pl>[0-9.]+) ATR")
RE_VER = re.compile(r"VERIFICA ADX barra (?P<barra>\d{4}\.\d\d\.\d\d \d\d:\d\d) periodo (?P<per>\d+): terminale (?P<tipo>\S+) = (?P<t>-?[0-9.]+) \| ricalcolo MetaQuotes = (?P<e>-?[0-9.]+) \| "
                    r"ricalcolo Wilder = (?P<w>-?[0-9.]+) -> il terminale coincide con: (?P<chi>.*)$")


def controlla_avvio(riga, cfg, sim):
    """lista dei motivi per cui la riga AVVIO non e' quella attesa (vuota = giusta)"""
    m = RE_AVVIO.search(riga)
    if not m:
        return ["riga AVVIO non riconosciuta: " + riga[:80]]
    g = m.groupdict()
    mot = []
    if g["v"] not in VERSIONI_VALIDE and g["v"] not in VERSIONI_ARCHIVIO:
        mot.append("versione %s invece di %s" % (g["v"], "/".join(VERSIONI_VALIDE)))
    if g["v"] in VERSIONI_CON_STOP and stop_da_avvio(riga) is None:
        mot.append("versione %s senza la regola di stop nella riga AVVIO ('| stop ...')" % g["v"])
    # cancello 07/10 notte: l'archivio v1.04 vale SOLO fuori dagli indici. Sugli indici BCM la v1.04 e' lo STALLO misurato dalla
    # diagnosi NATCLA_DIAG_U30: una passata d'indice v1.04 non e' mai un conto valido, qualunque cosa dica il resto (la nota del riepilogo non basta).
    if g["v"] in VERSIONI_ARCHIVIO and sim["classe"] == "IDX":
        mot.append("versione %s su un INDICE: sugli indici BCM valgono solo la v1.05 e le successive (%s) (la v%s e' lo stallo della diagnosi NATCLA_DIAG_U30)" % (g["v"], "/".join(VERSIONI_VALIDE), g["v"]))
    if g["mod"] != ("AUDIO" if cfg["modalita"] == "0" else "EMA200"):
        mot.append("modalita %s" % g["mod"])
    if g["sym"] != sim["nome"]:
        mot.append("simbolo %s" % g["sym"])
    if g["tf"] != cfg["periodo"]:
        mot.append("TF %s" % g["tf"])
    if g["mg"] != cfg["magic"]:
        mot.append("magic %s" % g["mg"])
    if ",".join(g["linee"].split()) != cfg["linee"]:
        mot.append("linee %s" % g["linee"])
    if g["adx"] != cfg["adx"]:
        mot.append("ADX %s" % g["adx"])
    if g["tipo"] != "iADX MetaQuotes":
        mot.append("tipo ADX %s" % g["tipo"])
    if float(g["max"]) != 20.0 or int(g["per"]) != 14:
        mot.append("ADX max/periodo %s/%s" % (g["max"], g["per"]))
    if g["ing"] != "SCALA3_PENDENTI":
        mot.append("ingresso %s" % g["ing"])
    if g["sc"] != "SI":
        mot.append("solo conta %s: MANDEREBBE ORDINI" % g["sc"])
    if float(g["pl"]) != 0.0:
        mot.append("placebo %s" % g["pl"])
    if abs(float(g["u"]) - float(sim["u"])) > 1e-9:
        mot.append("1 u = %s invece di %s" % (g["u"], sim["u"]))
    dat = {"FX": "AUTO_CLASSE forex", "ORO": "AUTO_CLASSE metallo", "ARG": "AUTO_CLASSE metallo", "IDX": "AUTO_CLASSE indice/CFD"}[sim["classe"]]
    if not g["descr"].startswith(dat):
        mot.append("descrizione unita '%s' non comincia per '%s'" % (g["descr"], dat))
    return mot


RE_STOP_AVVIO = re.compile(r"\| stop (?P<m>GEOMETRIA_ATTUALE|(?P<mo>OLTRE_LINEA_ESTERNA|OLTRE_PIU_ESTERNA) (?P<u>[0-9.]+) u)\s*$")
RE_STOP_CFG = re.compile(r"^#cfg;Stop;(?P<m>GEOMETRIA_ATTUALE|(?P<mo>OLTRE_LINEA_ESTERNA|OLTRE_PIU_ESTERNA) (?P<u>[0-9.]+) u);")
STOP_V105 = ("GEOMETRIA_ATTUALE", None)


def stop_da_avvio(riga):
    """('GEOMETRIA_ATTUALE', None) / ('OLTRE_LINEA_ESTERNA', 20.0) dalla riga AVVIO della v1.10; None se la riga non la porta (v1.04/v1.05)"""
    m = RE_STOP_AVVIO.search(riga.rstrip())
    if not m:
        return None
    return (m.group("mo"), float(m.group("u"))) if m.group("u") else STOP_V105


def stop_da_csv(b):
    """la regola di stop dalla riga '#cfg;Stop' del CSV (v1.10); None se assente (CSV v1.04/v1.05 = GEOMETRIA_ATTUALE)"""
    for l in testo(b).splitlines():
        m = RE_STOP_CFG.match(l)
        if m:
            return (m.group("mo"), float(m.group("u"))) if m.group("u") else STOP_V105
    return None


def impronta(b):
    """impronta del CSV per il DETERMINISMO: via la riga #AVVIO (porta la versione) e la riga #cfg;Stop (la regola si confronta a parte); in GEOMETRIA_ATTUALE
    le tre colonne della v1.10 (costanti, ricontrollate da calcola) si tolgono, cosi' la v1.10 in GEOMETRIA_ATTUALE ha la STESSA impronta della v1.05.
    In OLTRE le colonne restano tutte. Le altre righe (comprese le #cfg) restano intere."""
    out, header, nbase, imodo = [], None, None, None
    for l in testo(b).splitlines():
        if l.startswith("#AVVIO") or l.startswith("#cfg;Stop;"):
            continue
        if l.startswith("tipo;barra;linea;lato;"):
            header = l.split(";")
            nbase = header.index("motivo") + 1 if "motivo" in header else len(header)
            imodo = header.index("stop_modo") if "stop_modo" in header else None
            l = ";".join(header[:nbase])
        elif header is not None and (l.startswith("CONTA;") or l.startswith("SETUP;")):
            c = l.split(";")
            if imodo is None or (imodo < len(c) and c[imodo] == "0"):
                l = ";".join(c[:nbase])
        out.append(l)
    return hashlib.sha256("\n".join(out).encode("ascii", "replace")).hexdigest()


def senza_troncate(righe):
    """classe 1173: MT5 scrive la stessa riga Print in DUE log e una puo' essere TRONCATA (a 489 caratteri nella diagnosi del 07/10).
    Una riga che e' PREFISSO PROPRIO di un'altra e' la sua copia troncata, non una riga diversa: si tiene la piu' lunga. Le copie identiche
    restano una. L'ordine delle righe tenute e' quello del file."""
    pulite = [r.rstrip() for r in righe]
    lunghe = sorted(set(pulite), key=len, reverse=True)
    tenute = set()
    for r in lunghe:
        if not any(len(x) > len(r) and x.startswith(r) for x in tenute):
            tenute.add(r)
    out, viste = [], set()
    for r in pulite:
        if r in tenute and r not in viste:
            out.append(r)
            viste.add(r)
    return out


def verdetto_adx(t, e, w):
    """il verdetto della riga VERIFICA ADX, ricalcolato dai tre numeri (stessa regola dell'EA: tolleranza 0,05)"""
    if abs(t - e) <= 0.05:
        return "MetaQuotes"
    if abs(t - w) <= 0.05:
        return "Wilder"
    return "NESSUNA"


def adx_al_bordo(stampato, t, e, w):
    """i tre numeri della riga sono ARROTONDATI a 2 decimali (+/-0,01 ciascuno): un verdetto dell'EA, calcolato sui double veri, puo' differire dal ricalcolo sui numeri stampati
    solo se la differenza sta a meno di 0,011 dalla tolleranza 0,05 (classe: contro-esempio a mano, 07/10). Fuori da questa fascia stampato != ricalcolato e' una CONTRADDIZIONE."""
    dte, dtw = abs(t - e), abs(t - w)
    if stampato == "MetaQuotes":
        return dte <= 0.061
    if stampato == "Wilder":
        return dtw <= 0.061 and dte > 0.039
    return dte > 0.039 and dtw > 0.039


def leggi_verifica(righe_log):
    """ritorna (barra datetime, verdetto stampato, verdetto ricalcolato, coerente) oppure None"""
    out = []
    for r in righe_log:
        m = RE_VER.search(r)
        if m:
            g = m.groupdict()
            stampato = "MetaQuotes" if g["chi"].startswith("formula MetaQuotes") else ("Wilder" if g["chi"].startswith("formula di Wilder") else "NESSUNA")
            t, e, w = float(g["t"]), float(g["e"]), float(g["w"])
            ric = verdetto_adx(t, e, w)
            out.append((datetime.datetime.strptime(g["barra"], "%Y.%m.%d %H:%M"), stampato, ric, stampato == ric or adx_al_bordo(stampato, t, e, w)))
    if len(out) != 1:
        return None
    return out[0]


# ---------------------------------------------------------------------------------------------------------------------
#  UNA PASSATA: CSV -> numeri
# ---------------------------------------------------------------------------------------------------------------------
def quantile(v, q):
    v = sorted(v)
    if not v:
        return None
    pos = q * (len(v) - 1)
    lo = int(pos)
    hi = min(lo + 1, len(v) - 1)
    return v[lo] + (v[hi] - v[lo]) * (pos - lo)


def leggi_csv(b):
    """righe CONTA come dict + la riga #cfg;TocchiMax. Le righe '#' sono commento."""
    righe = []
    limiti = None
    header = None
    for l in testo(b).splitlines():
        if l.startswith("#cfg;TocchiMax;"):
            m = re.match(r"^#cfg;TocchiMax;(\d+) / (\d+) / (\d+) / EMA (\d+)", l)
            if m:
                limiti = dict(zip(LINEE, [int(x) for x in m.groups()]))
            continue
        if l.startswith("#"):
            continue
        if l.startswith("tipo;barra;linea;lato;"):
            header = l.split(";")
            continue
        if l.startswith("CONTA;"):
            assert header is not None, "riga CONTA prima dell'intestazione"
            c = l.split(";")
            assert len(c) == len(header), "riga CONTA con %d campi invece di %d" % (len(c), len(header))
            d = dict(zip(header, c))
            righe.append(d)
    return righe, limiti, header


def anni(da, a):
    return max((a - da).days, 0) / 365.25


def stop_coerente(r, stop, u):
    """v1.10: None se la riga rispetta la regola di stop DICHIARATA (stop = (modo, N u)), altrimenti il motivo. Righe senza le colonne nuove = v1.04/v1.05."""
    atteso = MODI_STOP[stop[0]]
    modo_r = r.get("stop_modo")
    if modo_r is None:
        return None if atteso == "0" else "colonna stop_modo assente con la regola OLTRE dichiarata"
    if modo_r != atteso:
        return "stop_modo %s contro la regola dichiarata %s" % (modo_r, stop[0])
    es, sl, ls = r["stop_esito"], float(r["sl"]), float(r["linea_stop"])
    if atteso == "0":
        return None if (es == "0" and ls == 0.0) else "GEOMETRIA_ATTUALE con linea_stop %s / stop_esito %s non nulli" % (r["linea_stop"], es)
    lato = int(r["lato"])
    if es == "1":
        ok = sl == 0.0 and all(float(r["stop_ped%d" % k]) == 0.0 for k in (1, 2, 3))
        return None if ok else "stop_esito 1 (scartato) con SL o stop_ped non nulli"
    if es not in ("0", "2"):
        return "stop_esito %s sconosciuto" % es
    if not ls > 0:
        return "linea_stop %s non valida con stop_esito %s" % (r["linea_stop"], es)
    dec = len(r["sl"].split(".")[1]) if "." in r["sl"] else 0
    tol = 1.5 * 10 ** (-dec)
    if not all(lato * (float(r[k]) - sl) > 0 for k in ("p1", "p2", "p3")):
        return "SL %s dal lato sbagliato di un ordine (lato %d)" % (r["sl"], lato)
    crit = ls - lato * stop[1] * u
    if es == "0" and abs(sl - crit) > tol:
        return "SL %s non a %.2f u oltre la linea esterna %s (atteso %.6f)" % (r["sl"], stop[1], r["linea_stop"], crit)
    if es == "2" and lato * (crit - sl) < -tol:
        return "stop_esito 2 (vince X4) ma lo SL %s e' piu' VICINO della regola (%.6f)" % (r["sl"], crit)
    # v1.11: la LINEA dello stop rispetto alla linea del setup (stesso calcolo, stessa stampa nel CSV del conteggio)
    lp = float(r["linea_prezzo"])
    dl = len(r["linea_prezzo"].split(".")[1]) if "." in r["linea_prezzo"] else 0
    tl = 1.5 * 10 ** (-max(dl, dec))
    if r["linea"] == "E200" and abs(ls - lp) > tl:
        return "linea E200: la linea dello stop %s non e' la EMA200 del setup %s" % (r["linea_stop"], r["linea_prezzo"])
    if r["linea"] == "ST35" and atteso == "1" and abs(ls - lp) > tl:
        return "ST35 in OLTRE_LINEA_ESTERNA: la linea dello stop %s non e' la ST3,5 del setup %s" % (r["linea_stop"], r["linea_prezzo"])
    if r["linea"] == "ST35" and atteso == "2" and lato * (lp - ls) < -tl:
        return "ST35 in OLTRE_PIU_ESTERNA: la linea dello stop %s sta DENTRO la ST3,5 del setup %s" % (r["linea_stop"], r["linea_prezzo"])
    return None


def calcola(righe, limiti, sim, cfg, inizio_effettivo, stop=None):
    """tutti i numeri di UNA passata. limiti = dict per linea (0 = illimitato). stop = regola dichiarata nel CSV (None = v1.04/v1.05). Ritorna un dict."""
    stop = stop or STOP_V105
    ris = {"righe": len(righe), "linee": {}, "barre": set(), "incl": [], "adx_ep": [], "costo": {}, "incoerenti_stop_ped": 0, "spread_zero": 0, "split": None,
           "prezzo_primo": None, "prezzo_ultimo": None, "stop": stop, "incoerenti_stop": 0, "esempi_stop": [], "stop_scartati": 0}
    for r in righe:
        mot = stop_coerente(r, stop, float(sim["u"]))
        if mot:
            ris["incoerenti_stop"] += 1
            if len(ris["esempi_stop"]) < 3:
                ris["esempi_stop"].append("%s %s: %s" % (r["barra"], r["linea"], mot))
    fin = FINE_FINESTRA
    ini = inizio_effettivo.date()
    ris["inizio"] = ini
    sp_all = [float(r["spread"]) for r in righe]
    ris["spread"] = {"min": min(sp_all), "med": statistics.median(sp_all), "max": max(sp_all), "n": len(sp_all)} if sp_all else None
    ris["anni"] = anni(ini, fin)
    ris["troncati"] = 0
    per_linea = {}
    for r in righe:
        per_linea.setdefault(r["linea"], []).append(r)
    ordini_dist = [[], [], []]
    ordini_r0 = [[], [], []]
    ordini_r1 = [[], [], []]
    # split dell'orologio: contatori A (prima del cambio), B (zona dubbia), C (dopo)
    split = {"A": 0, "B": 0, "C": 0}
    for ln in LINEE:
        rr = per_linea.get(ln, [])
        lim = limiti.get(ln, LIMITI_ATTESI[ln])
        d = {"righe": len(rr), "episodi": 0, "limite": 0, "setup": 0, "setup_tocco": 0, "adx20_tocco": 0, "stop_scartati": 0}
        for r in rr:
            if int(r["troncato"]) == 1:
                ris["troncati"] += 1
            if int(r["nuovo_ep"]) != 1:
                continue
            d["episodi"] += 1
            tn = int(r["tocco_n"])
            if lim > 0 and tn > lim:
                continue
            d["limite"] += 1
            adx = float(r["adx"])
            if adx <= 20.0:
                d["adx20_tocco"] += 1
            if int(r["ctx_tocco"]) == 0:
                d["setup_tocco"] += 1
            if int(r["ctx_arm"]) != 0:
                continue
            d["setup"] += 1
            ris["barre"].add(r["barra"])
            ris["incl"].append(abs(float(r["incl_atr"])))
            ris["adx_ep"].append(adx)
            dt = datetime.datetime.strptime(r["barra"], "%Y.%m.%d %H:%M").date()
            if dt < CAMBIO_OROLOGIO_DA:
                split["A"] += 1
            elif dt < CAMBIO_OROLOGIO_A:
                split["B"] += 1
            else:
                split["C"] += 1
            # v1.10: un setup che l'EA NON arma (linea esterna discorde) resta in n, esce dal costo (il suo SL e' 0) e si conta a parte
            if r.get("stop_esito") == "1":
                d["stop_scartati"] += 1
                ris["stop_scartati"] += 1
                continue
            # costo, per ordine: |prezzo ordine - SL| / (spread + commissione)
            sl = float(r["sl"])
            spread = float(r["spread"])
            lv = float(r["linea_prezzo"])
            comm = {"FX": 0.00004 * lv, "ORO": 0.04, "ARG": 0.0, "IDX": 0.0}[sim["classe"]]
            for i, col in enumerate(("p1", "p2", "p3")):
                dist = abs(float(r[col]) - sl)
                ordini_dist[i].append(dist)
                if spread > 0:
                    ordini_r0[i].append(dist / spread)
                    ordini_r1[i].append(dist / (spread + comm))
                    sp = float(r["stop_ped%d" % (i + 1)])
                    if abs(sp - dist / spread) > 0.06 + 0.002 * (dist / spread):
                        ris["incoerenti_stop_ped"] += 1
            if spread <= 0:
                ris["spread_zero"] += 1
        ris["linee"][ln] = d
    ris["split"] = split
    if righe:
        ris["prezzo_primo"] = float(righe[0]["linea_prezzo"])
        ris["prezzo_ultimo"] = float(righe[-1]["linea_prezzo"])
    # costo: mediane per ordine
    for i in range(3):
        ris["costo"][i] = {"dist": statistics.median(ordini_dist[i]) if ordini_dist[i] else None,
                           "r_senza": statistics.median(ordini_r0[i]) if ordini_r0[i] else None,
                           "r_con": statistics.median(ordini_r1[i]) if ordini_r1[i] else None, "n": len(ordini_r1[i])}
    ris["n_linee"] = sum(d["setup"] for d in ris["linee"].values())
    ris["n_barre"] = len(ris["barre"])
    return ris


def classe_costo(x):
    if x is None:
        return "NON MISURATO"
    if x >= LAVORO_X:
        return "PASSA"
    if x >= DURO_X:
        return "FRA"
    return "ESCLUSO"


def verdetto_costo(costo, chiave):
    """ESCLUSO PER COSTO se l'ordine con la distanza MAGGIORE (mediana) ha rapporto mediano < 13,3 (specifica E2, operativizzazione scritta nel file prova)"""
    cand = [(costo[i]["dist"], costo[i][chiave]) for i in range(3) if costo[i]["dist"] is not None and costo[i][chiave] is not None]
    if not cand:
        return "NON MISURATO"
    dmax, rmax = max(cand, key=lambda x: x[0])
    c = classe_costo(rmax)
    return {"PASSA": "PASSA IL LAVORO", "FRA": "FRA", "ESCLUSO": "ESCLUSO PER COSTO", "NON MISURATO": "NON MISURATO"}[c]


def banda(rapp):
    if rapp is None:
        return "n.d."
    if BANDA_COERENTE[0] <= rapp <= BANDA_COERENTE[1]:
        return "COERENTE"
    if rapp < BANDA_GUARDARE[0]:
        return "UN ORDINE DI GRANDEZZA MENO: STOP (E0)"
    if rapp > BANDA_GUARDARE[1]:
        return "UN ORDINE DI GRANDEZZA IN PIU: STOP"
    return "DA GUARDARE"


# ---------------------------------------------------------------------------------------------------------------------
#  LA LETTURA COMPLETA
# ---------------------------------------------------------------------------------------------------------------------
def carica(sorgenti, prova_txt=None):
    """ritorna dict: blocchi, runs[(sim,cfg)] = lista di record (uno per sorgente che la contiene), problemi[]"""
    prova = prova_txt
    for s in sorgenti:
        if prova is None:
            nomi = [n for n in s.nomi if n.endswith("NATCLA_F0_conteggio_2026-10-07.txt")]
            if nomi:
                prova = testo(s.leggi(nomi[0]))
    if prova is None:
        prova = open(PROVA_REPO, encoding="ascii").read()
    bl = leggi_blocchi(prova)
    out = {"blocchi": bl, "runs": {}, "problemi": [], "manifest": [], "lotti": set()}
    for s in sorgenti:
        if not s.ha("MANIFEST_F0.csv"):
            out["problemi"].append("%s: manca MANIFEST_F0.csv" % s.percorso)
            continue
        rows = list(csv.DictReader(io.StringIO(testo(s.leggi("MANIFEST_F0.csv"))), delimiter=";"))
        for m in rows:
            out["lotti"].add(m["lotto"])
            sim = bl["simboli"].get(m["simbolo"])
            cfg = bl["config"].get(m["config"])
            if sim is None or cfg is None:
                out["problemi"].append("MANIFEST: (%s, %s) non e' nei blocchi @F0 del file prova" % (m["simbolo"], m["config"]))
                continue
            rec = {"manifest": m, "sim": sim, "cfg": cfg, "sorgente": s.percorso, "righe": None, "limiti": None, "calc": None, "adx": None, "avvio_motivi": None, "csv_sha": None,
                   "conta_sha": None, "versione": None, "stato": m["stato"], "problemi": [], "stop": None, "stop_avvio": None}
            tag = "%s_%s" % (m["simbolo"], m["config"])
            logn = "log/EA_%s.txt" % tag
            righe_log = senza_troncate(testo(s.leggi(logn)).splitlines()) if s.ha(logn) else []
            if not righe_log and m["stato"].startswith("OK"):
                rec["problemi"].append("stato OK nel MANIFEST ma log dell'EA assente")
            avvi = [r for r in righe_log if "[NatCla] AVVIO v" in r]
            if m["stato"].startswith("OK"):
                if len(avvi) != 1:
                    rec["problemi"].append("righe AVVIO nel log: %d (attesa 1)" % len(avvi))
                else:
                    mot = controlla_avvio(avvi[0].split("[NatCla] ", 1)[1], cfg, sim)
                    rec["avvio_motivi"] = mot
                    mv_ = RE_AVVIO.search(avvi[0])
                    rec["versione"] = mv_.group("v") if mv_ else None
                    rec["stop_avvio"] = stop_da_avvio(avvi[0]) or STOP_V105
                    for x in mot:
                        rec["problemi"].append("AVVIO: " + x)
                ver = leggi_verifica(righe_log)
                rec["adx"] = ver
                if ver is None:
                    rec["problemi"].append("riga VERIFICA ADX assente o doppia")
                else:
                    if ver[1] != "MetaQuotes":
                        rec["problemi"].append("VERIFICA ADX: il terminale coincide con %s" % ver[1])
                    if not ver[3]:
                        rec["problemi"].append("VERIFICA ADX: verdetto stampato %s ma i tre numeri dicono %s" % (ver[1], ver[2]))
            cn = "csv/natcla_setup_%s_%s.csv" % (m["simbolo"], cfg["magic"])
            if m["stato"].startswith("OK"):
                if not s.ha(cn):
                    rec["problemi"].append("stato OK ma CSV assente nello zip")
                else:
                    b = s.leggi(cn)
                    rec["csv_sha"] = hashlib.sha256(b).hexdigest()
                    # determinismo SENZA la riga #AVVIO (porta la versione dell'EA: v1.04, v1.05 e v1.10 la scrivono diversa, il resto del CSV no) e, dalla
                    # v1.10, senza #cfg;Stop e senza le tre colonne nuove quando la regola e' GEOMETRIA_ATTUALE (impronta): la regola si confronta a parte
                    rec["conta_sha"] = impronta(b)
                    righe, limiti, header = leggi_csv(b)
                    stop_csv = stop_da_csv(b)
                    if stop_csv is None and header is not None and "stop_modo" in header:
                        rec["problemi"].append("CSV con le colonne della v1.10 ma senza la riga #cfg;Stop: regola di stop non dichiarata")
                    rec["stop"] = stop_csv or STOP_V105
                    if rec["stop_avvio"] is not None and rec["stop_avvio"] != rec["stop"]:
                        rec["problemi"].append("regola di stop: riga AVVIO %s, CSV %s" % (rec["stop_avvio"], rec["stop"]))
                    rec["righe"] = righe
                    rec["limiti"] = limiti
                    if limiti is None:
                        rec["problemi"].append("riga #cfg;TocchiMax non trovata nel CSV: limiti per linea NON verificati")
                        limiti = dict(LIMITI_ATTESI)
                    elif limiti != LIMITI_ATTESI:
                        rec["problemi"].append("limiti di tocco nel CSV %s invece di %s" % (limiti, LIMITI_ATTESI))
                    if int(m["righe_conta"]) != len(righe):
                        rec["problemi"].append("righe CONTA: MANIFEST %s, CSV %d" % (m["righe_conta"], len(righe)))
                    inizio = rec["adx"][0] if rec["adx"] else datetime.datetime.strptime(sim["da"], "%Y.%m.%d")
                    rec["calc"] = calcola(righe, limiti, sim, cfg, inizio, rec["stop"])
                    if rec["calc"]["incoerenti_stop"]:
                        rec["problemi"].append("regola di stop NON rispettata in %d righe (es. %s)" % (rec["calc"]["incoerenti_stop"], "; ".join(rec["calc"]["esempi_stop"])))
            if rec["problemi"]:
                rec["stato"] = "KO(lettore)"
            out["runs"].setdefault((m["simbolo"], m["config"]), []).append(rec)
    return out


def nome_stop(st):
    st = st or STOP_V105
    return st[0] if st[1] is None else "%s %.2f u" % st


def fmt(x, n=1):
    return "-" if x is None else ("%." + str(n) + "f") % x


def riepilogo(dati, righe_out):
    P = righe_out.append
    bl = dati["blocchi"]
    runs = dati["runs"]
    tutte = [r for lst in runs.values() for r in lst]
    P("=" * 110)
    P("F0 DI Ea Nat&Cla -- LETTURA (nessun PF, nessun DD, nessun merito: il Modello 1 puo' solo bocciare)")
    P("=" * 110)
    # ---- stato delle passate e passate attese ma assenti
    n_ok = sum(1 for r in tutte if r["stato"].startswith("OK"))
    P("PASSATE LETTE: %d    stato OK dopo i controlli del lettore: %d    altre: %d" % (len(tutte), n_ok, len(tutte) - n_ok))
    for r in tutte:
        if not r["stato"].startswith("OK"):
            P("   %-10s %-10s %-14s %s" % (r["manifest"]["simbolo"], r["manifest"]["config"], r["stato"], "; ".join(r["problemi"]) or r["manifest"]["motivi"]))
    attese = set()
    for nome in sorted(dati["lotti"]):
        lot = bl["lotti"].get(nome)
        if not lot:
            continue
        for s in lot["simboli"].split(","):
            for c in lot["configs"].split(","):
                attese.add((s, c))
    mancano = sorted(attese - set(runs))
    if mancano:
        P("ATTESE DAI LOTTI LETTI MA ASSENTI: %d  (%s%s)" % (len(mancano), ", ".join("%s/%s" % x for x in mancano[:12]), " ..." if len(mancano) > 12 else ""))
    # ---- tempo
    durate = [int(r["manifest"]["durata_s"]) for r in tutte if r["stato"].startswith("OK") and r["manifest"]["durata_s"].isdigit()]
    if durate:
        mdn = statistics.median(durate)
        P("TEMPO per passata OK: mediana %.0f s, media %.0f s, min %d, max %d  ->  F0 intera (216 passate) = %.1f ore alla mediana, %.1f ore alla media" % (
            mdn, statistics.mean(durate), min(durate), max(durate), 216 * mdn / 3600.0, 216 * statistics.mean(durate) / 3600.0))
    # ---- determinismo (stessa passata in due sorgenti)
    for chiave, lst in sorted(runs.items()):
        con = [r for r in lst if r["conta_sha"]]
        regole = sorted(set(r["stop"] or STOP_V105 for r in con), key=str)
        if len(con) > 1 and len(regole) > 1:
            P("DETERMINISMO %s/%s: %d corse con REGOLE DI STOP DIVERSE (%s): impronte NON confrontabili fra regole diverse, si confrontano dentro ciascuna" % (
              chiave[0], chiave[1], len(con), " | ".join(nome_stop(x) for x in regole)))
        for reg in regole:
            grp = [r for r in con if (r["stop"] or STOP_V105) == reg]
            shas = [r["conta_sha"] for r in grp]
            if len(shas) > 1:
                vers = sorted(set(r["versione"] or "?" for r in grp))
                P("DETERMINISMO %s/%s%s: %d corse%s, CSV (senza la riga #AVVIO) %s" % (chiave[0], chiave[1], (" [stop " + nome_stop(reg) + "]") if len(regole) > 1 else "", len(shas),
                  (" con EA " + " e ".join("v" + v for v in vers) + ": misura anche che la versione nuova non cambia le righe CONTA") if len(vers) > 1 else "",
                  "IDENTICI" if len(set(shas)) == 1 else "DIVERSI: il conto non e' riproducibile, F0 non vale"))
    vconta = {}
    for r in tutte:
        if r["versione"]:
            vconta[r["versione"]] = vconta.get(r["versione"], 0) + 1
    if vconta:
        P("VERSIONI DELL'EA nelle righe AVVIO: %s%s" % (", ".join("v%s x %d" % kv for kv in sorted(vconta.items())),
          ("   (v%s = ARCHIVIO, lotti girati prima del rimedio v1.05: letti, ma per gli INDICI valgono solo la v1.05 e le successive, %s)" % ("/".join(VERSIONI_ARCHIVIO), "/".join(VERSIONI_VALIDE)))
          if any(v in VERSIONI_ARCHIVIO for v in vconta) else ""))
    # ---- VERIFICA ADX
    P("")
    P("-" * 110)
    P("VERIFICA ADX (riga dell'EA alla prima barra con dati; deve dire 'formula MetaQuotes' su TUTTE le passate)")
    conta = {}
    for r in tutte:
        if r["adx"]:
            conta[r["adx"][1]] = conta.get(r["adx"][1], 0) + 1
    P("   verdetti stampati: %s   (passate senza la riga: %d)" % (", ".join("%s %d" % kv for kv in sorted(conta.items())) or "nessuno", sum(1 for r in tutte if r["stato"].startswith("OK") and not r["adx"])))
    for r in tutte[:1]:
        pass
    esempi = [r for r in tutte if r["adx"]]
    if esempi:
        e = esempi[0]
        P("   esempio %s/%s: barra %s, verdetto stampato %s, ricalcolato dai tre numeri %s" % (e["manifest"]["simbolo"], e["manifest"]["config"], e["adx"][0], e["adx"][1], e["adx"][2]))
    if any(k != "MetaQuotes" for k in conta):
        P("   >>> FERMARSI: almeno una passata dice Wilder o NESSUNA. Nessun numero di ADX si legge finche' non si capisce quale formula usa il terminale (checklist par. 6 punto 2).")
    # ---- tabella per configurazione
    ordine_cfg = sorted(bl["config"], key=lambda n: int(bl["config"][n]["magic"]))
    for cn in ordine_cfg:
        cfg = bl["config"][cn]
        if not any(r["calc"] is not None and r["stato"].startswith("OK") for sn in bl["simboli"] for r in runs.get((sn, cn), [])):
            P("")
            P("%s: nessuna passata OK letta" % cn)
            continue
        P("")
        P("-" * 110)
        P("%s   (modalita %s, TF %s, magic %s, linee %s)   n = SETUP per linea; anni = dalla barra della riga VERIFICA ADX al 2026.06.30" % (cn, cfg["modalita"], cfg["periodo"], cfg["magic"], cfg["linee"]))
        P("   %-8s %5s %6s | %5s %5s %5s %5s | %6s %6s | %5s %5s | %s" % ("simbolo", "anni", "setup", "ST25", "ST30", "ST35", "E200", "set/an", "barre", "adxM", "incl", "costo (con commissione) / senza"))
        vivi = []
        somma = 0
        tot_simboli = 0
        for sn in sorted(bl["simboli"]):
            lst = [r for r in runs.get((sn, cn), []) if r["calc"] is not None and r["stato"].startswith("OK")]
            if not lst:
                continue
            c = lst[0]["calc"]
            tot_simboli += 1
            n = c["n_linee"]
            somma += n
            if n >= VIVO_E0:
                vivi.append(sn)
            d = c["linee"]
            incl50 = quantile(c["incl"], 0.5)
            adxm = statistics.mean(c["adx_ep"]) if c["adx_ep"] else None
            P("   %-8s %5.2f %6d | %5d %5d %5d %5d | %6.1f %6d | %5s %5s | %s / %s   [stop %s%s]" % (sn, c["anni"], n, d["ST25"]["setup"], d["ST30"]["setup"], d["ST35"]["setup"], d["E200"]["setup"],
                                                                                    n / c["anni"] if c["anni"] > 0 else 0, c["n_barre"], fmt(adxm), fmt(incl50, 2),
                                                                                    verdetto_costo(c["costo"], "r_con"), verdetto_costo(c["costo"], "r_senza"), nome_stop(c["stop"]),
                                                                                    (", %d setup SCARTATI dallo stop (linea esterna discorde: l'EA non li arma, fuori dal costo)" % c["stop_scartati"]) if c["stop_scartati"] else ""))
        if tot_simboli:
            P("   simboli letti %d, somma dei setup (famiglia) %d contro %d richiesti da E3 (150 IS + 150 OOS)  ->  %s" % (
                tot_simboli, somma, FAMIGLIA_E3, "SOPRA" if somma >= FAMIGLIA_E3 else "SOTTO: merito SOSPESO per n (il rischio si giudica lo stesso)"))
            if cn == "AUDIO_H1":
                P("   E0: VIVI (setup >= %d nella finestra): %d su %d letti%s" % (VIVO_E0, len(vivi), tot_simboli, (": " + ", ".join(vivi)) if vivi else ""))
            else:
                P("   (informazione, NON E0): simboli con setup >= %d: %d su %d" % (VIVO_E0, len(vivi), tot_simboli))
    # ---- E0: confronto oro
    P("")
    P("-" * 110)
    P("E0 -- CONFRONTO CON IL FEED ESTERNO (oro HistData, NON BCM, orologio +6 h), per anno, AUDIO_H1, XAUUSD  [banda scritta prima: %.1f-%.1f COERENTE, %.1f-%.1f DA GUARDARE, sotto %.1f STOP]" % (
        BANDA_COERENTE[0], BANDA_COERENTE[1], BANDA_GUARDARE[0], BANDA_GUARDARE[1], BANDA_GUARDARE[0]))
    og = [r for r in runs.get(("XAUUSD", "AUDIO_H1"), []) if r["calc"] is not None and r["stato"].startswith("OK")]
    if not og:
        P("   XAUUSD AUDIO_H1 non letta: confronto NON MISURATO.")
    else:
        c = og[0]["calc"]
        y = c["anni"]
        P("   anni effettivi BCM: %.2f (HistData: 2,19)" % y)
        for chiave, titolo in (("episodi", "episodi di tocco"), ("limite", "entro il limite audio 1/1/2"), ("adx20_tocco", "limite + iADX<=20 alla barra del tocco")):
            att = ORO_HISTDATA[chiave]
            for i, ln in enumerate(("ST25", "ST30", "ST35")):
                num = c["linee"][ln][chiave if chiave != "episodi" else "episodi"]
                per_anno = num / y if y > 0 else 0
                rapp = per_anno / att[i] if att[i] else None
                P("   %-40s %s: BCM %6.1f/anno  HistData %6.1f/anno  rapporto %5.2f  %s" % (titolo, ln, per_anno, att[i], rapp, banda(rapp)))
        import math
        for i, ln in enumerate(("ST25", "ST30", "ST35")):
            x = c["linee"][ln]["adx20_tocco"] / y if y > 0 else 0
            if x > 0:
                dm = abs(math.log(x / ORO_HISTDATA["adx20_tocco"][i]))
                dw = abs(math.log(x / ORO_WILDER_TOCCO[i]))
                P("   CONTRO-ESEMPIO ADX %s: %.1f/anno con ADX<=20 alla barra del tocco: iADX atteso %.0f, Wilder atteso %.0f -> piu vicino a %s" % (ln, x, ORO_HISTDATA["adx20_tocco"][i], ORO_WILDER_TOCCO[i], "iADX" if dm <= dw else "WILDER (se la riga VERIFICA ADX dice MetaQuotes, cercare perche)"))
            else:
                P("   CONTRO-ESEMPIO ADX %s: zero con ADX<=20 alla barra del tocco" % ln)
        tot = sum(c["linee"][l]["setup"] for l in ("ST25", "ST30", "ST35")) / y if y > 0 else 0
        att_tot = sum(ORO_SETUP_ATTESI_ANNO)
        P("   SETUP/anno (EA: ADX solo su ST35, barra PRIMA): BCM %.1f  attesa ~%.0f (101+84+21)  rapporto %.2f  %s" % (tot, att_tot, tot / att_tot, banda(tot / att_tot)))
        rr = sum(c["linee"][l]["righe"] for l in ("ST25", "ST30", "ST35"))
        ee = sum(c["linee"][l]["episodi"] for l in ("ST25", "ST30", "ST35"))
        P("   CONTRO-ESEMPIO: se si contassero le RIGHE invece degli episodi: %d righe contro %d episodi = x%.2f (le righe NON sono setup)" % (rr, ee, rr / ee if ee else 0))
    # ---- spread usato dal tester
    P("")
    P("-" * 110)
    P("SPREAD USATO DAL TESTER (Modello 1; AUDIO_H1 se c'e', altrimenti la prima configurazione letta), in u (pip / punti / USD). COSTANTE = spread corrente al lancio, VARIABILE = dalla barra M1.")
    for sn in sorted(bl["simboli"]):
        rr_ = None
        for cn in ["AUDIO_H1"] + [x for x in ordine_cfg if x != "AUDIO_H1"]:
            for r in runs.get((sn, cn), []):
                if r["calc"] is not None and r["calc"]["spread"] and r["stato"].startswith("OK"):
                    rr_ = r
                    break
            if rr_:
                break
        if not rr_:
            continue
        sp = rr_["calc"]["spread"]
        u = float(bl["simboli"][sn]["u"])
        cost = "COSTANTE" if sp["min"] == sp["max"] else "VARIABILE"
        rif = SPREAD_VIVO.get(sn)
        if rif:
            rap = (sp["med"] / u) / rif
            conf = "rapporto con spread_vivo %.2f: %s" % (rap, "COERENTE" if BANDA_SPREAD[0] <= rap <= BANDA_SPREAD[1] else "LONTANO dal campo: il verdetto di costo di F0 NON si usa")
            rif_t = "spread_vivo %.2f" % rif
        else:
            conf = "nessuno spread_vivo (28 simboli NON MISURATI: questo e' il primo numero)"
            rif_t = ""
        P("   %-8s min %.5g  mediana %.5g  max %.5g  (in u: %.3g)  %s  %s  %s" % (sn, sp["min"], sp["med"], sp["max"], sp["med"] / u, cost, rif_t, conf))
    # ---- inclinazione
    P("")
    P("-" * 110)
    P("F5 -- INCLINAZIONE |EMA200[1]-EMA200[21]|/ATR14, sui SETUP (le 3 celle P25/P50/P75 dell'asse A6, fissate PRIMA di ogni P/L; NON sono soglie del merito)")
    for cn in ordine_cfg:
        tutti = []
        for sn in bl["simboli"]:
            for r in runs.get((sn, cn), []):
                if r["calc"] is not None and r["stato"].startswith("OK"):
                    tutti.extend(r["calc"]["incl"])
                    break
        if tutti:
            P("   %-10s n %5d   P25 %.2f   P50 %.2f   P75 %.2f%s" % (cn, len(tutti), quantile(tutti, .25), quantile(tutti, .5), quantile(tutti, .75),
                                                                   ("   (oro H1 HistData su TUTTE le barre: %.2f/%.2f/%.2f)" % INCL_ORO_H1) if cn == "AUDIO_H1" else ""))
    # ---- orologio forex
    P("")
    P("-" * 110)
    P("OROLOGIO BCM sul FOREX (H4/H12/D1): setup prima del %s | zona dubbia | dal %s  (cambio fra il 26/12/2024 e il 02/02/2025, giorno esatto NON MISURATO)" % (CAMBIO_OROLOGIO_DA, CAMBIO_OROLOGIO_A))
    for cn in ordine_cfg:
        if bl["config"][cn]["periodo"] == "H1":
            continue
        a = b = c_ = 0
        quanti = 0
        for sn, s in bl["simboli"].items():
            if s["classe"] != "FX":
                continue
            for r in runs.get((sn, cn), []):
                if r["calc"] is not None and r["stato"].startswith("OK"):
                    a += r["calc"]["split"]["A"]; b += r["calc"]["split"]["B"]; c_ += r["calc"]["split"]["C"]; quanti += 1
                    break
        if quanti:
            P("   %-10s forex letti %2d: prima %4d | dubbia %4d | dopo %4d   (finestre: %.2f anni prima, %.2f dopo, dall'inizio del forex 2024.07.05 al 2026.06.30)" % (
                cn, quanti, a, b, c_, anni(datetime.date(2024, 7, 5), CAMBIO_OROLOGIO_DA), anni(CAMBIO_OROLOGIO_A, FINE_FINESTRA)))
    # ---- regime (proxy)
    P("")
    P("-" * 110)
    P("REGIME della finestra: NON MISURATO da questa corsa (il CSV non ha il rendimento ne' l'ADX medio della finestra). [PROXY] prezzo della linea al primo e all'ultimo tocco, AUDIO_H1:")
    for sn in sorted(bl["simboli"]):
        for r in runs.get((sn, "AUDIO_H1"), []):
            if r["calc"] is not None and r["calc"]["prezzo_primo"]:
                c = r["calc"]
                P("   %-8s %12.5f -> %12.5f  (%+.1f%%)" % (sn, c["prezzo_primo"], c["prezzo_ultimo"], 100.0 * (c["prezzo_ultimo"] / c["prezzo_primo"] - 1)))
                break
    # ---- avvertenze fisse
    P("")
    P("-" * 110)
    P("INCOERENZE interne dei CSV: stop_ped scritto dall'EA contro |p-SL|/spread: %d righe-ordine fuori tolleranza; spread = 0: %d setup (rapporto non calcolabile). Righe troncate (segmento che inizia con la finestra): %d. Regola di stop non rispettata (v1.10): %d righe." % (
        sum(r["calc"]["incoerenti_stop_ped"] for r in tutte if r["calc"]), sum(r["calc"]["spread_zero"] for r in tutte if r["calc"]), sum(r["calc"]["troncati"] for r in tutte if r["calc"]),
        sum(r["calc"]["incoerenti_stop"] for r in tutte if r["calc"])))
    P("Il Guardian nel tester e' FAIL-OPEN (specifica 2.5): irrilevante in SoloConta. Barre OHLC M1: nessun PF/DD si legge. Commissione DERIVATA (forex 0,004% del prezzo, oro 0,04 USD, indici 0).")
    for x in dati["problemi"]:
        P("PROBLEMA: " + x)


def tabella_csv(dati, percorso):
    with open(percorso, "w", newline="") as f:
        w = csv.writer(f, delimiter=";")
        w.writerow(["simbolo", "config", "linea", "anni", "righe", "episodi", "entro_limite", "setup", "setup_ctx_tocco", "adx20_tocco", "n_istanza", "n_barre", "costo_con", "costo_senza",
                    "stop", "setup_scartati_stop"])
        for (sn, cn), lst in sorted(dati["runs"].items()):
            for r in lst:
                if r["calc"] is None:
                    continue
                c = r["calc"]
                for ln in LINEE:
                    d = c["linee"][ln]
                    w.writerow([sn, cn, ln, "%.3f" % c["anni"], d["righe"], d["episodi"], d["limite"], d["setup"], d["setup_tocco"], d["adx20_tocco"], c["n_linee"], c["n_barre"],
                                verdetto_costo(c["costo"], "r_con"), verdetto_costo(c["costo"], "r_senza"), nome_stop(c["stop"]), d["stop_scartati"]])
                break


# ---------------------------------------------------------------------------------------------------------------------
#  AUTOTEST: dati finti con risposta nota (costruita per COSTRUZIONE, non dal lettore) + contro-esempi
# ---------------------------------------------------------------------------------------------------------------------
INTEST = ("tipo;barra;linea;lato;tocco_n;nuovo_ep;troncato;ctx_arm;ctx_tocco;vicino_ok;conferma_ok;dist_apertura_atr;adx;incl_atr;confl_dist_atr;confl_etichetta;ema9;ema21;bb_larg;"
          "atr14;linea_prezzo;ingresso;n_ordini;p1;p2;p3;sl;tp1;tp2;tp3;lotto1;lotto2;lotto3;spread;commissione;stop_ped1;stop_ped2;stop_ped3;rischio_soldi;n_riempiti;esito_soldi;esito_R;"
          "durata_min;motivo")


INTEST_110 = INTEST + ";stop_modo;linea_stop;stop_esito"


def riga_conta(barra, linea, nep, nuovo, ctx_arm, ctx_tocco, adx, incl, lv, spread, u, lato=1, tronc=0, stop=None, linea_est=None, discorde=False):
    """una riga CONTA con la geometria della scala AUDIO (5,5): anticipo +5u, linea, oltre -5u. stop None = CSV v1.04/v1.05 (44 colonne), SL = oltre - 5u (long);
    stop = (modo, N) = CSV v1.10 con le tre colonne in coda: GEOMETRIA_ATTUALE come prima (linea_stop 0, esito 0); OLTRE: SL = linea esterna (default la linea) - N u,
    esito 2 se la linea esterna sta dentro la scala (vince X4), esito 1 (discorde) = SL 0 e stop_ped 0. Specchio per lo short. COSTRUITA qui, non dal lettore."""
    s = lato
    p = [lv + s * 5 * u, lv, lv - s * 5 * u]
    sl = p[2] - s * 5 * u
    esito, le = 0, 0.0
    if stop is not None and stop[0] != "GEOMETRIA_ATTUALE":
        le = lv if linea_est is None else linea_est
        cand = le - s * stop[1] * u
        if discorde:
            sl, esito = 0.0, 1
        elif s * (cand - sl) > 0:
            esito = 2                  # la regola starebbe dentro la scala: resta l'ordine profondo + 5 (X4)
        else:
            sl = cand
    sp = [abs(x - sl) / spread if esito != 1 else 0.0 for x in p]
    c = ["CONTA", barra, linea, str(s), str(nep), str(nuovo), str(tronc), str(ctx_arm), str(ctx_tocco), "1", "0", "0.100", "%.1f" % adx, "%.3f" % incl, "0.300", "1", "1", "1", "1", "1",
         "%.5f" % lv, "SCALA3", "0", "%.5f" % p[0], "%.5f" % p[1], "%.5f" % p[2], "%.5f" % sl, "0", "0", "0", "0", "0", "0", "%.5f" % spread, "0", "%.1f" % sp[0], "%.1f" % sp[1], "%.1f" % sp[2],
         "0", "0", "0", "0", "0", "SOLO_CONTA"]
    assert len(c) == 44 and len(INTEST.split(";")) == 44
    if stop is not None:
        c += [MODI_STOP[stop[0]], "%.5f" % le, str(esito)]
        assert len(c) == 47 and len(INTEST_110.split(";")) == 47
    return ";".join(c)


def csv_finto(piano, u, spread, lv0, anno_inizio=2024, limiti=(1, 1, 2, 0), spread_alt=None, versione=VERSIONE_EA, stop="auto", linea_est=None, discorde_ogni=0):
    """piano: {linea: lista di episodi (n_barre_di_tocco, nep, ctx_arm, ctx_tocco, adx, incl)}. Gli episodi sono distribuiti su barre diverse in ordine cronologico.
    stop 'auto' = formato della versione (v1.10: GEOMETRIA_ATTUALE con le colonne nuove e #cfg;Stop; v1.04/v1.05: 44 colonne, nessuna #cfg;Stop).
    discorde_ogni k > 0: una riga ogni k ha la linea esterna discorde (solo OLTRE)."""
    if stop == "auto":
        stop = STOP_V105 if versione in VERSIONI_CON_STOP else None
    righe = ["#AVVIO v%s finto" % versione, "#cfg;TocchiMax;%d / %d / %d / EMA %d (0 = illimitato)   [FONTE]" % limiti]
    righe += ["#cfg;x;y;z"] * 25
    if stop is not None:
        righe.append("#cfg;Stop;%s;v1.10 [FONTE Claudio 08/10]" % nome_stop(stop))
    righe.append(INTEST if stop is None else INTEST_110)
    t = datetime.datetime(anno_inizio, 7, 8, 10, 0)
    tutte = []
    for linea, eps in piano.items():
        for ep in eps:
            nb, nep, ca, ct, adx, incl, quando = ep
            for k in range(nb):
                tutte.append((quando + datetime.timedelta(hours=k), linea, nep, 1 if k == 0 else 0, ca, ct, adx, incl))
    tutte.sort(key=lambda x: (x[0], x[1]))
    for k, (q, linea, nep, nuovo, ca, ct, adx, incl) in enumerate(tutte):
        sp = spread if (spread_alt is None or k % 2 == 0) else spread_alt
        righe.append(riga_conta(q.strftime("%Y.%m.%d %H:%M"), linea, nep, nuovo, ca, ct, adx, incl, lv0, sp, u, stop=stop, linea_est=linea_est,
                                discorde=(discorde_ogni > 0 and k % discorde_ogni == discorde_ogni - 1)))
    return ("\n".join(righe) + "\n").encode("ascii")


def log_finto(sim, cfg, barra_verifica="2024.07.08 10:00", adx_t=21.34, adx_e=21.30, adx_w=18.10, chi="formula MetaQuotes (DI per barra, media esponenziale 2/(n+1))", u=None, versione=VERSIONE_EA, sc="SI",
              modalita=None, descr=None, stop="auto"):
    u = u if u is not None else sim["u"]
    mod = modalita or ("AUDIO" if cfg["modalita"] == "0" else "EMA200")
    descr = descr or {"FX": "AUTO_CLASSE forex: pip", "ORO": "AUTO_CLASSE metallo: 1,0 USD", "ARG": "AUTO_CLASSE metallo: 1,0 USD", "IDX": "AUTO_CLASSE indice/CFD: 1,0 punto"}[sim["classe"]]
    linee = (" ".join(cfg["linee"].split(",")) + " ") if cfg["modalita"] == "0" else "E200"
    adx = cfg["adx"]
    avv = ("[NatCla] AVVIO v%s | modalita' %s | %s PERIOD_%s | 1 u = %s (%s) | 1 pip = %s | magic %s | linee %s | ADX %s, iADX MetaQuotes, max 20.0, periodo 14 | ingresso SCALA3_PENDENTI | "
           "rischio setup 0.25%% (SEGNAPOSTO DA FIRMARE DA CLAUDIO) | guardian ON (nel tester FAIL-OPEN) | solo conta %s | placebo 0.00 ATR | fonte SOLO AUDIO (PDF escluso 07/10)" % (
               versione, mod, sim["nome"], cfg["periodo"], u, descr, u, cfg["magic"], linee, adx, sc))
    if stop == "auto":
        stop = STOP_V105 if versione in VERSIONI_CON_STOP else None
    if stop is not None:
        avv += " | stop " + nome_stop(stop)
    ver = ("[NatCla] VERIFICA ADX barra %s periodo 14: terminale NC_ADX_MT5 = %.2f | ricalcolo MetaQuotes = %.2f | ricalcolo Wilder = %.2f -> il terminale coincide con: %s" % (barra_verifica, adx_t, adx_e, adx_w, chi))
    return "passata finta\r\n" + avv + "\r\n" + ver + "\r\n[NatCla] AVVISO: SOLO CONTA: nessun ordine verra' inviato\r\n"


def manifest_riga(lotto, sim, cfg, stato="OK", righe=0, durata=60, motivi="", avvio="si", adx="MetaQuotes"):
    return ";".join([lotto, sim, cfg["nome"] if isinstance(cfg, dict) else cfg, cfg["magic"] if isinstance(cfg, dict) else "", "2026-10-08 10:00:00", str(durata), stato,
                     "natcla_setup_%s_%s.csv" % (sim, cfg["magic"]), str(righe), avvio, adx, "2024.07.05-2026.06.30", motivi])


def costruisci_zip(percorso, prova_txt, voci):
    """voci = lista di dict(sim, cfg, csv_bytes, log_txt, stato, righe, durata) -> zip nella forma del driver"""
    bl = leggi_blocchi(prova_txt)
    mrows = ["lotto;simbolo;config;magic;t_avvio;durata_s;stato;csv;righe_conta;avvio_ok;adx_verifica;finestra;motivi"]
    with zipfile.ZipFile(percorso, "w") as z:
        z.writestr("NATCLA_F0_conteggio_2026-10-07.txt", prova_txt)
        for v in voci:
            sim = bl["simboli"][v["sim"]]
            cfg = bl["config"][v["cfg"]]
            mrows.append(manifest_riga(v.get("lotto", "PILOTA"), v["sim"], cfg, v.get("stato", "OK"), v.get("righe", 0), v.get("durata", 60), v.get("motivi", "")))
            if v.get("log_txt") is not None:
                z.writestr("log/EA_%s_%s.txt" % (v["sim"], v["cfg"]), v["log_txt"])
            if v.get("csv_bytes") is not None:
                z.writestr("csv/natcla_setup_%s_%s.csv" % (v["sim"], cfg["magic"]), v["csv_bytes"])
        z.writestr("MANIFEST_F0.csv", "\r\n".join(mrows) + "\r\n")


def autotest():
    prova = open(PROVA_REPO, encoding="ascii").read()
    bl = leggi_blocchi(prova)
    esiti = []

    def chk(nome, cond, dettaglio=""):
        esiti.append((nome, bool(cond), dettaglio))

    # ---- il file prova letto bene
    chk("blocchi: 6 configurazioni, 36 simboli, 6 lotti (C0 = verifica del rimedio v1.05)", len(bl["config"]) == 6 and len(bl["simboli"]) == 36 and len(bl["lotti"]) == 6 and
        bl["lotti"]["C0"]["simboli"] == "U30USD,D30EUR" and bl["lotti"]["C0"]["configs"] == "AUDIO_H1,M2_H1")
    chk("lotti A-D coprono i 36 simboli una volta sola", sorted(s for n in "ABCD" for s in bl["lotti"][n]["simboli"].split(",")) == sorted(bl["simboli"]))
    chk("magic delle configurazioni = 7786 + 10*modalita + cifraTF", all(int(c["magic"]) == 778600 + 10 * int(c["modalita"]) + {"16385": 1, "16388": 4, "16396": 2, "16408": 8}[c["tf"]] for c in bl["config"].values()))

    # ---- verdetto ADX: tre casi + contro-esempio (verdetto stampato incoerente con i numeri)
    chk("verdetto ADX: terminale = MetaQuotes", verdetto_adx(21.34, 21.30, 18.10) == "MetaQuotes")
    chk("verdetto ADX: terminale = Wilder", verdetto_adx(18.12, 21.30, 18.10) == "Wilder")
    chk("verdetto ADX: nessuna delle due", verdetto_adx(25.0, 21.30, 18.10) == "NESSUNA")
    chk("verdetto ADX: a 0,04 e' MetaQuotes, a 0,06 no", verdetto_adx(21.34, 21.30, 10.0) == "MetaQuotes" and verdetto_adx(21.36, 21.30, 10.0) == "NESSUNA")
    chk("VERIFICA ADX al bordo: stampato MetaQuotes con differenza 0,06 per arrotondamento = coerente, con 0,10 = CONTRADDIZIONE",
        adx_al_bordo("MetaQuotes", 21.36, 21.30, 10.0) and not adx_al_bordo("MetaQuotes", 21.40, 21.30, 10.0))
    cfg_h1 = bl["config"]["AUDIO_H1"]
    sim_xau = bl["simboli"]["XAUUSD"]
    v = leggi_verifica(log_finto(sim_xau, cfg_h1).splitlines())
    chk("VERIFICA ADX estratta: barra e verdetto", v is not None and v[0] == datetime.datetime(2024, 7, 8, 10, 0) and v[1] == "MetaQuotes" and v[3])
    v2 = leggi_verifica(log_finto(sim_xau, cfg_h1, adx_t=25.0, chi="formula MetaQuotes (DI per barra)").splitlines())
    chk("CONTRO-ESEMPIO: la riga dice MetaQuotes ma i tre numeri dicono NESSUNA -> incoerente", v2 is not None and v2[1] == "MetaQuotes" and v2[2] == "NESSUNA" and not v2[3])
    v3 = leggi_verifica((log_finto(sim_xau, cfg_h1) + log_finto(sim_xau, cfg_h1, barra_verifica="2024.08.01 10:00")).splitlines())
    chk("VERIFICA ADX doppia (due barre diverse) = non letta", v3 is None)

    # ---- controlli dell'AVVIO
    sim_eur = bl["simboli"]["EURUSD"]
    chk("AVVIO giusto EURUSD AUDIO_H1: nessun motivo", controlla_avvio(log_finto(sim_eur, cfg_h1).splitlines()[1].split("[NatCla] ", 1)[1], cfg_h1, sim_eur) == [])
    chk("AVVIO versione 1.03 rifiutata", any("versione" in m for m in controlla_avvio(log_finto(sim_eur, cfg_h1, versione="1.03").splitlines()[1].split("[NatCla] ", 1)[1], cfg_h1, sim_eur)))
    chk("AVVIO 'solo conta no' = MANDEREBBE ORDINI", any("ORDINI" in m for m in controlla_avvio(log_finto(sim_eur, cfg_h1, sc="no").splitlines()[1].split("[NatCla] ", 1)[1], cfg_h1, sim_eur)))
    chk("AVVIO EURUSD con 1 u = 1.0 (classe sbagliata) rifiutata", any("1 u" in m for m in controlla_avvio(log_finto(sim_eur, cfg_h1, u="1.0").splitlines()[1].split("[NatCla] ", 1)[1], cfg_h1, sim_eur)))
    sim_jpy = bl["simboli"]["USDJPY"]
    chk("AVVIO USDJPY con 1 u = 0.010 giusto, con 0.0001 sbagliato",
        controlla_avvio(log_finto(sim_jpy, cfg_h1, u="0.010").splitlines()[1].split("[NatCla] ", 1)[1], cfg_h1, sim_jpy) == [] and
        any("1 u" in m for m in controlla_avvio(log_finto(sim_jpy, cfg_h1, u="0.0001").splitlines()[1].split("[NatCla] ", 1)[1], cfg_h1, sim_jpy)))
    giusta = log_finto(sim_eur, cfg_h1).splitlines()[1].split("[NatCla] ", 1)[1]
    for a, b, nome in (("PERIOD_H1", "PERIOD_H4", "TF"), ("magic 778601", "magic 778602", "magic"), ("linee ST25 ST30 ST35", "linee ST25 ST30", "linee"), ("ADX ACCESO", "ADX spento", "ADX acceso"),
                       ("iADX MetaQuotes, max", "iADXWilder, max", "tipo ADX"), ("SCALA3_PENDENTI", "MERCATO_PIU_PENDENTE", "ingresso"), ("placebo 0.00", "placebo 1.00", "placebo"),
                       ("EURUSD PERIOD", "GBPUSD PERIOD", "simbolo"), ("modalita' AUDIO", "modalita' EMA200", "modalita"), ("periodo 14", "periodo 20", "periodo ADX"), ("max 20.0", "max 25.0", "ADX max")):
        assert a in giusta, a
        chk("AVVIO cambiato (%s) -> almeno un motivo" % nome, controlla_avvio(giusta.replace(a, b), cfg_h1, sim_eur) != [])
    chk("AVVIO illeggibile -> motivo", controlla_avvio("AVVIO v1.04 ma il resto no", cfg_h1, sim_eur) != [])
    # ---- v1.05: versione attesa 1.05; la 1.04 si legge come ARCHIVIO (lotti girati prima del rimedio); qualunque altra e' un motivo
    chk("AVVIO v1.05 (lotti F0 al pin d6586360), v1.10 e v1.11 (versione attesa, con '| stop') senza motivi", VERSIONE_EA == "1.11" and
        controlla_avvio(log_finto(sim_eur, cfg_h1, versione="1.11").splitlines()[1].split("[NatCla] ", 1)[1], cfg_h1, sim_eur) == [] and
        controlla_avvio(log_finto(sim_eur, cfg_h1, versione="1.05").splitlines()[1].split("[NatCla] ", 1)[1], cfg_h1, sim_eur) == [] and
        controlla_avvio(log_finto(sim_eur, cfg_h1, versione="1.10").splitlines()[1].split("[NatCla] ", 1)[1], cfg_h1, sim_eur) == [])
    chk("CONTRO-ESEMPIO: AVVIO v1.10 SENZA la regola di stop -> motivo (una v1.10 deve dichiarare lo stop)",
        any("regola di stop" in m for m in controlla_avvio(log_finto(sim_eur, cfg_h1, versione="1.10", stop=None).splitlines()[1].split("[NatCla] ", 1)[1], cfg_h1, sim_eur)))
    chk("AVVIO v1.04 letta come ARCHIVIO (nessun motivo), v1.06 rifiutata",
        controlla_avvio(log_finto(sim_eur, cfg_h1, versione="1.04").splitlines()[1].split("[NatCla] ", 1)[1], cfg_h1, sim_eur) == [] and
        any("versione" in m for m in controlla_avvio(log_finto(sim_eur, cfg_h1, versione="1.06").splitlines()[1].split("[NatCla] ", 1)[1], cfg_h1, sim_eur)))
    # cancello 07/10 notte: l'archivio v1.04 NON vale sugli indici (lo stallo); la v1.05 sullo stesso indice si'
    sim_u30 = bl["simboli"]["U30USD"]
    chk("AVVIO v1.04 su un INDICE (U30USD) = motivo; v1.05 sullo stesso indice nessun motivo",
        any("INDICE" in m for m in controlla_avvio(log_finto(sim_u30, cfg_h1, versione="1.04").splitlines()[1].split("[NatCla] ", 1)[1], cfg_h1, sim_u30)) and
        controlla_avvio(log_finto(sim_u30, cfg_h1).splitlines()[1].split("[NatCla] ", 1)[1], cfg_h1, sim_u30) == [])
    # ---- classe 1173: la stessa riga in due log, una TRONCATA -> una sola; due righe DIVERSE (non prefisso) restano due
    lf = log_finto(sim_xau, cfg_h1).splitlines()
    avv_ok, ver_ok = lf[1], lf[2]
    doppio = [lf[0], avv_ok[:300], ver_ok, avv_ok, ver_ok[:len(ver_ok) - 20], lf[3]]
    st = senza_troncate(doppio)
    chk("1173: AVVIO intero + copia troncata a 300 caratteri -> UNA riga AVVIO, quella intera", [r for r in st if "AVVIO v" in r] == [avv_ok])
    chk("1173: VERIFICA ADX intera + copia troncata dentro la frase finale -> letta (una sola)", leggi_verifica(st) is not None and leggi_verifica(doppio) is None)
    altra = avv_ok.replace("magic 778601", "magic 778602")
    altra2 = avv_ok.replace("magic 778601", "magic 7786012")       # piu' LUNGA, stesso inizio, ma la corta NON ne e' prefisso
    chk("1173 CONTRO-ESEMPIO: due AVVIO diverse (stessa lunghezza, o piu' lunga con lo stesso inizio ma senza essere prefisso) restano DUE",
        len([r for r in senza_troncate([avv_ok, altra]) if "AVVIO v" in r]) == 2 and len([r for r in senza_troncate([avv_ok, altra2]) if "AVVIO v" in r]) == 2)
    chk("1173: copie IDENTICHE restano una, l'ordine del file e' tenuto", senza_troncate(["b", "a", "b", "c"]) == ["b", "a", "c"])
    cfg_m2 = bl["config"]["M2_H1"]
    chk("AVVIO M2_H1: linee E200, ADX spento", controlla_avvio(log_finto(sim_eur, cfg_m2).splitlines()[1].split("[NatCla] ", 1)[1], cfg_m2, sim_eur) == [])
    chk("AVVIO forex servito come CFD (descrizione con parentesi) riconosciuto", controlla_avvio(log_finto(sim_eur, cfg_h1, descr="AUTO_CLASSE forex (valute base/profitto): pip").splitlines()[1].split("[NatCla] ", 1)[1], cfg_h1, sim_eur) == [])
    chk("AVVIO oro con descrizione 'indice/CFD' rifiutata", any("descrizione" in m for m in controlla_avvio(log_finto(sim_xau, cfg_h1, descr="AUTO_CLASSE indice/CFD: 1,0 punto").splitlines()[1].split("[NatCla] ", 1)[1], cfg_h1, sim_xau)))

    # ---- il conto dei setup su un CSV costruito con risposta nota
    # XAUUSD H1, 1,97 anni dal 2024-07-08: piano per linea (nb_barre, tocco_n, ctx_arm, ctx_tocco, adx, incl, quando)
    base = datetime.datetime(2024, 7, 9, 10, 0)

    def ep(i, nb, nep, ca, ct, adx, incl):
        return (nb, nep, ca, ct, adx, incl, base + datetime.timedelta(hours=7 * i + {0: 0, 1: 2}.get(nep, 4)))
    piano = {"ST25": [], "ST30": [], "ST35": []}
    i = 0
    # ST25: 40 episodi 'nep=1', di cui 30 con ctx_arm=0 (setup), 10 con ctx_arm=1; 6 episodi 'nep=2' fuori dal limite (limite 1); ognuno dura 3 barre
    for k in range(40):
        piano["ST25"].append(ep(i, 3, 1, 0 if k < 30 else 1, 0, 15.0 if k % 2 == 0 else 30.0, 0.5 + 0.01 * k)); i += 1
    for k in range(6):
        piano["ST25"].append(ep(i, 2, 2, 0, 0, 12.0, 0.4)); i += 1
    # ST30: 20 episodi nep=1 tutti ctx_arm=0, uno con adx = 20,0 ESATTO (il bordo conta: iADX <= 20)
    for k in range(20):
        piano["ST30"].append(ep(i, 1, 1, 0, 0, 20.0 if k == 0 else 18.0, 0.6)); i += 1
    # ST35 (limite 2): 10 nep=1 (4 ctx_arm=0), 8 nep=2 (3 ctx_arm=0), 5 nep=3 fuori limite
    for k in range(10):
        piano["ST35"].append(ep(i, 2, 1, 0 if k < 4 else 3, 0 if k < 4 else 1, 10.0 if k < 4 else 40.0, 0.7)); i += 1
    for k in range(8):
        piano["ST35"].append(ep(i, 1, 2, 0 if k < 3 else 3, 0, 19.0, 0.8)); i += 1
    for k in range(5):
        piano["ST35"].append(ep(i, 1, 3, 0, 0, 10.0, 0.9)); i += 1
    csvb = csv_finto(piano, u=1.0, spread=0.25, lv0=2400.0)
    righe, limiti, header = leggi_csv(csvb)
    chk("CSV finto: limiti per linea letti dalla riga #cfg;TocchiMax", limiti == {"ST25": 1, "ST30": 1, "ST35": 2, "E200": 0})
    nrighe_attese = sum(nb for eps in piano.values() for (nb, *_r) in eps)
    chk("CSV finto: righe lette = righe scritte", len(righe) == nrighe_attese, "%d contro %d" % (len(righe), nrighe_attese))
    c = calcola(righe, limiti, sim_xau, cfg_h1, datetime.datetime(2024, 7, 8, 10, 0))
    # attese per COSTRUZIONE: ST25 40 episodi nep=1 (+6 nep=2), entro il limite 40, setup 30; ST30 20/20/20; ST35 episodi 23, entro limite 18, setup 4+3 = 7
    chk("ST25: episodi 46 (non righe 40*3+6*2=132)", c["linee"]["ST25"]["episodi"] == 46 and c["linee"]["ST25"]["righe"] == 132, str(c["linee"]["ST25"]))
    chk("ST25: entro il limite 40, setup 30", c["linee"]["ST25"]["limite"] == 40 and c["linee"]["ST25"]["setup"] == 30)
    chk("ST25: limite + ADX<=20 alla barra del tocco = 20", c["linee"]["ST25"]["adx20_tocco"] == 20)
    chk("ST30: 20/20/20, e con ADX<=20 alla barra del tocco 20 (il 20,0 esatto conta)", (c["linee"]["ST30"]["episodi"], c["linee"]["ST30"]["limite"], c["linee"]["ST30"]["setup"], c["linee"]["ST30"]["adx20_tocco"]) == (20, 20, 20, 20))
    chk("ST35 (limite 2): episodi 23, entro il limite 18, setup 7", (c["linee"]["ST35"]["episodi"], c["linee"]["ST35"]["limite"], c["linee"]["ST35"]["setup"]) == (23, 18, 7), str(c["linee"]["ST35"]))
    chk("ST35: setup con ctx_tocco=0 = 12, con ctx_arm=0 = 7 (barra del tocco contro barra PRIMA: la regola prende la seconda)", c["linee"]["ST35"]["setup_tocco"] == 12 and c["linee"]["ST35"]["setup"] == 7)
    chk("n_istanza = somma dei setup delle linee = 57", c["n_linee"] == 57, str(c["n_linee"]))
    chk("n_barre <= n_istanza (barre distinte)", c["n_barre"] <= c["n_linee"] and c["n_barre"] > 0)
    chk("E200 assente: zero righe, zero setup", c["linee"]["E200"]["righe"] == 0 and c["linee"]["E200"]["setup"] == 0)
    chk("anni effettivi = dal 2024-07-08 al 2026-06-30", abs(c["anni"] - (datetime.date(2026, 6, 30) - datetime.date(2024, 7, 8)).days / 365.25) < 1e-9)
    # costo: oro, spread 0,25, u=1: distanze 15/10/5 USD, commissione 0,04 -> senza 60/40/20, con 15/0.29=51.7, 10/0.29=34.5, 5/0.29=17.2
    co = c["costo"]
    chk("costo oro: distanze mediane 15/10/5", (round(co[0]["dist"], 6), round(co[1]["dist"], 6), round(co[2]["dist"], 6)) == (15.0, 10.0, 5.0))
    chk("costo oro senza commissione: 60/40/20", (round(co[0]["r_senza"], 6), round(co[1]["r_senza"], 6), round(co[2]["r_senza"], 6)) == (60.0, 40.0, 20.0))
    chk("costo oro con commissione 0,04: 51,7/34,5/17,2", (round(co[0]["r_con"], 1), round(co[1]["r_con"], 1), round(co[2]["r_con"], 1)) == (51.7, 34.5, 17.2), str([co[i]["r_con"] for i in range(3)]))
    chk("verdetto costo oro con commissione: PASSA IL LAVORO (anticipo 51,7 >= 40)", verdetto_costo(co, "r_con") == "PASSA IL LAVORO")
    chk("ncoerenza stop_ped: nessuna riga incoerente nel CSV finto", c["incoerenti_stop_ped"] == 0)
    # CONTRO-ESEMPIO del costo: EURUSD, spread 0,2 pip, u=0.0001 -> distanze 15/10/5 pip; senza commissione 75/50/25 (PASSA), con 0,47 pip: 22.4/14.9/7.5 -> anticipo 22,4: FRA
    pe = {"ST25": [ep(0, 1, 1, 0, 0, 15.0, 0.5)]}
    cb = csv_finto(pe, u=0.0001, spread=0.00002, lv0=1.1)
    rr2, lm2, _h = leggi_csv(cb)
    ce = calcola(rr2, lm2, sim_eur, cfg_h1, datetime.datetime(2024, 7, 8, 10, 0))["costo"]
    chk("CONTRO-ESEMPIO costo EURUSD: senza commissione PASSA, con commissione FRA (il verdetto CAMBIA e il lettore lo stampa)",
        verdetto_costo(ce, "r_senza") == "PASSA IL LAVORO" and verdetto_costo(ce, "r_con") == "FRA", "%s / %s" % (verdetto_costo(ce, "r_senza"), verdetto_costo(ce, "r_con")))
    # stop_ped scritto dall'EA incoerente con |p-SL|/spread: il lettore lo conta (3 ordini x 1 setup, colonne alterate)
    righe_alt = [dict(x) for x in rr2]
    for x in righe_alt:
        x["stop_ped1"] = "99.9"
    cal = calcola(righe_alt, lm2, sim_eur, cfg_h1, datetime.datetime(2024, 7, 8, 10, 0))
    chk("stop_ped del CSV alterato -> 1 riga-ordine incoerente contata", cal["incoerenti_stop_ped"] == 1, str(cal["incoerenti_stop_ped"]))
    # indici: commissione 0, i due coincidono
    ci = calcola(rr2, lm2, bl["simboli"]["U30USD"], cfg_h1, datetime.datetime(2024, 9, 26))["costo"]
    chk("indice: commissione 0, con = senza", abs(ci[0]["r_con"] - ci[0]["r_senza"]) < 1e-9)
    # escluso per costo: spread grande
    cx = csv_finto(pe, u=0.0001, spread=0.00030, lv0=1.1)
    r3, l3, _h = leggi_csv(cx)
    c3 = calcola(r3, l3, sim_eur, cfg_h1, datetime.datetime(2024, 7, 8, 10, 0))["costo"]
    chk("verdetto ESCLUSO PER COSTO quando l'anticipo ha rapporto < 13,3", verdetto_costo(c3, "r_con") == "ESCLUSO PER COSTO", verdetto_costo(c3, "r_con"))
    chk("classe_costo ai bordi 13,3 / 40", classe_costo(13.3) == "FRA" and classe_costo(13.29) == "ESCLUSO" and classe_costo(40.0) == "PASSA" and classe_costo(39.99) == "FRA")
    # clock split: forex, episodi a cavallo del cambio
    ps = {"ST25": [(1, 1, 0, 0, 10.0, 0.5, datetime.datetime(2024, 11, 5, 8, 0)), (1, 1, 0, 0, 10.0, 0.5, datetime.datetime(2024, 12, 25, 23, 0)), (1, 1, 0, 0, 10.0, 0.5, datetime.datetime(2024, 12, 26, 0, 0)),
                       (1, 1, 0, 0, 10.0, 0.5, datetime.datetime(2025, 2, 2, 23, 0)), (1, 1, 0, 0, 10.0, 0.5, datetime.datetime(2025, 2, 3, 0, 0)), (1, 1, 0, 0, 10.0, 0.5, datetime.datetime(2026, 1, 5, 8, 0))]}
    rs, ls, _h = leggi_csv(csv_finto(ps, u=0.0001, spread=0.00002, lv0=1.1))
    sp = calcola(rs, ls, sim_eur, bl["config"]["AUDIO_H4"], datetime.datetime(2024, 7, 8, 10, 0))["split"]
    chk("split orologio: 25/12 prima, 26/12 e 02/02 zona dubbia, 03/02 dopo -> A2 B2 C2", sp == {"A": 2, "B": 2, "C": 2}, str(sp))
    # riscaldamento: l'anno effettivo parte dalla barra VERIFICA, non dalla data della riga
    c_ind = calcola(righe, limiti, bl["simboli"]["U30USD"], cfg_h1, datetime.datetime(2025, 11, 14, 0, 0))
    chk("anni effettivi indici D1-like: inizio 2025-11-14 -> 228 giorni = 0,6242 anni, non 1,76 dalla data della riga", abs(c_ind["anni"] - 228 / 365.25) < 1e-9, "%.4f" % c_ind["anni"])
    # distinguere iADX da Wilder: 32 episodi/2 anni con adx<=20 = 16/anno (iADX) contro 80 = 40/anno (Wilder)
    def piano_adx(n20, ntot):
        bb = datetime.datetime(2024, 7, 9, 10, 0)
        return {"ST35": [(1, 1, 0, 0, 15.0 if k < n20 else 30.0, 0.5, bb + datetime.timedelta(hours=9 * k)) for k in range(ntot)]}
    for n20, atteso in ((32, "iADX"), (79, "WILDER")):
        zz = os.path.join(tempfile.gettempdir(), "nc_adxtest_%d.zip" % n20)
        costruisci_zip(zz, prova, [dict(sim="XAUUSD", cfg="AUDIO_H1", csv_bytes=csv_finto(piano_adx(n20, 120), u=1.0, spread=0.25, lv0=2400.0), log_txt=log_finto(sim_xau, cfg_h1), righe=120)])
        oo = []
        riepilogo(carica([Sorgente(zz)]), oo)
        os.remove(zz)
        riga_adx = [x for x in oo if "CONTRO-ESEMPIO ADX ST35" in x]
        chk("contro-esempio ADX: %d episodi con ADX<=20 in ~1,98 anni -> piu vicino a %s" % (n20, atteso), len(riga_adx) == 1 and ("piu vicino a " + atteso) in riga_adx[0], riga_adx)
    # due linee toccate nella STESSA barra = un solo setup per il semaforo E7: n_linee 3, n_barre 2
    q1 = datetime.datetime(2025, 3, 3, 9, 0)
    pb = {"ST25": [(1, 1, 0, 0, 10.0, 0.5, q1)], "ST30": [(1, 1, 0, 0, 10.0, 0.5, q1)], "ST35": [(1, 1, 0, 0, 10.0, 0.5, q1 + datetime.timedelta(hours=5))]}
    rb, lb, _h = leggi_csv(csv_finto(pb, u=1.0, spread=0.25, lv0=2400.0))
    cbb = calcola(rb, lb, sim_xau, cfg_h1, datetime.datetime(2024, 7, 8, 10, 0))
    chk("due linee nella stessa barra: n_linee 3, n_barre 2", (cbb["n_linee"], cbb["n_barre"]) == (3, 2), str((cbb["n_linee"], cbb["n_barre"])))
    # percentili
    chk("quantile P25/P50/P75 su 1..5", (quantile([1, 2, 3, 4, 5], .25), quantile([1, 2, 3, 4, 5], .5), quantile([1, 2, 3, 4, 5], .75)) == (2.0, 3.0, 4.0))
    chk("quantile di lista vuota = None", quantile([], .5) is None)
    # banda E0
    chk("banda: 1,0 COERENTE; 0,3 DA GUARDARE; 0,05 STOP; 12 STOP in piu'", banda(1.0) == "COERENTE" and banda(0.3) == "DA GUARDARE" and banda(0.05).startswith("UN ORDINE DI GRANDEZZA MENO") and banda(12).startswith("UN ORDINE DI GRANDEZZA IN PIU"))
    chk("banda ai bordi 0,5 / 2,0 coerenti, 0,49 / 2,01 da guardare", banda(0.5) == "COERENTE" and banda(2.0) == "COERENTE" and banda(0.49) == "DA GUARDARE" and banda(2.01) == "DA GUARDARE")

    # ---- v1.10: la regola di stop OLTRE_LINEA_ESTERNA (Claudio 08/10). Risposte scritte qui per COSTRUZIONE (u, spread, commissione del lettore).
    OL = ("OLTRE_LINEA_ESTERNA", 20.0)
    p6 = {"ST35": [ep(k, 1, 1, 0, 0, 10.0, 0.5) for k in range(6)]}
    p6b = {"ST25": [ep(k, 1, 1, 0, 0, 10.0, 0.5) for k in range(6)]}      # linea esterna DIVERSA dalla linea del setup: solo sulla ST2,5/3,0 e' possibile
    def costo_di(sim, u, spread, lv0, piano=None, **kw):
        rr_, ll_, _h = leggi_csv(csv_finto(piano or p6, u=u, spread=spread, lv0=lv0, versione=kw.pop("versione", "1.10"), **kw))
        return calcola(rr_, ll_, sim, cfg_h1, datetime.datetime(2024, 7, 8, 10, 0), kw.get("stop") or STOP_V105)
    co_ = costo_di(sim_xau, 1.0, 0.25, 2400.0, stop=OL)
    chk("v1.10 OLTRE oro (u 1 USD, spread 0,25, commissione 0,04): distanze 25/20/15, senza 100/80/60, con 86,2/69,0/51,7, PASSA, nessuna incoerenza",
        [round(co_["costo"][i]["dist"], 6) for i in range(3)] == [25.0, 20.0, 15.0] and [round(co_["costo"][i]["r_senza"], 6) for i in range(3)] == [100.0, 80.0, 60.0] and
        [round(co_["costo"][i]["r_con"], 1) for i in range(3)] == [86.2, 69.0, 51.7] and verdetto_costo(co_["costo"], "r_con") == "PASSA IL LAVORO" and co_["incoerenti_stop"] == 0,
        str([(co_["costo"][i]["dist"], co_["costo"][i]["r_con"]) for i in range(3)]) + str(co_["esempi_stop"]))
    ce_ = costo_di(sim_eur, 0.0001, 0.00002, 1.1, stop=OL)
    chk("v1.10 OLTRE EURUSD (spread 0,2 pip, commissione 0,004% = 0,44 pip a 1,1000): ordine sulla linea 20/0,64 = 31,25x, anticipo 39,1x -> FRA (sotto il lavoro 40x)",
        abs(ce_["costo"][1]["r_con"] - 20.0 / 0.64) < 0.05 and abs(ce_["costo"][0]["r_con"] - 25.0 / 0.64) < 0.05 and verdetto_costo(ce_["costo"], "r_con") == "FRA",
        str([ce_["costo"][i]["r_con"] for i in range(3)]))
    cu_ = costo_di(bl["simboli"]["U30USD"], 1.0, 2.0, 46000.0, stop=OL)
    chk("v1.10 OLTRE U30USD (u 1 punto, spread 2,0): 12,5/10/7,5 -> ESCLUSO PER COSTO (sotto il duro 13,3)",
        [round(cu_["costo"][i]["r_con"], 6) for i in range(3)] == [12.5, 10.0, 7.5] and verdetto_costo(cu_["costo"], "r_con") == "ESCLUSO PER COSTO")
    cg_ = costo_di(sim_xau, 1.0, 0.25, 2400.0)
    chk("CONTRO-ESEMPIO: stesso piano in GEOMETRIA_ATTUALE (v1.10, colonne nuove a 0) = distanze 15/10/5 della v1.05: la regola CAMBIA il costo e il lettore la segue",
        [round(cg_["costo"][i]["dist"], 6) for i in range(3)] == [15.0, 10.0, 5.0] and cg_["incoerenti_stop"] == 0 and cg_["stop"] == STOP_V105)
    cx4 = costo_di(sim_xau, 1.0, 0.25, 2400.0, piano=p6b, stop=OL, linea_est=2415.0)
    chk("v1.10 OLTRE (setup ST2,5) con la linea esterna DENTRO la scala (2415 - 20 = 2395 sopra l'X4 2390): esito 2, SL 2390, coerente, distanze 15/10/5",
        cx4["incoerenti_stop"] == 0 and [round(cx4["costo"][i]["dist"], 6) for i in range(3)] == [15.0, 10.0, 5.0], str(cx4["esempi_stop"]))
    cd_ = costo_di(sim_xau, 1.0, 0.25, 2400.0, piano=p6b, stop=OL, discorde_ogni=3)
    chk("v1.10 OLTRE con 2 setup ST2,5 su 6 a linea esterna DISCORDE: restano in n (6), escono dal costo (n costo 4), SL 0 senza rapporti assurdi, coerenti",
        cd_["linee"]["ST25"]["setup"] == 6 and cd_["stop_scartati"] == 2 and cd_["linee"]["ST25"]["stop_scartati"] == 2 and cd_["costo"][0]["n"] == 4 and
        cd_["incoerenti_stop"] == 0 and max(cd_["costo"][i]["r_senza"] for i in range(3)) == 100.0, str((cd_["stop_scartati"], cd_["costo"][0]["n"], cd_["esempi_stop"])))
    # contro-esempi della coerenza: righe che VIOLANO la regola dichiarata devono essere contate
    rr_, ll_, _h = leggi_csv(csv_finto(p6, u=1.0, spread=0.25, lv0=2400.0, versione="1.10", stop=OL))
    def viola(campo, valore, quante=1, stop=OL, sim=sim_xau):
        alt = [dict(x) for x in rr_]
        for x in alt[:quante]:
            x[campo] = valore
        return calcola(alt, ll_, sim, cfg_h1, datetime.datetime(2024, 7, 8, 10, 0), stop)["incoerenti_stop"]
    chk("CONTRO-ESEMPIO coerenza: SL dal lato SBAGLIATO (2420 su un long) -> 1 riga incoerente", viola("sl", "2420.00000") == 1)
    chk("CONTRO-ESEMPIO coerenza: SL a 10 u invece dei 20 dichiarati (2390, esito 0) -> incoerente", viola("sl", "2390.00000") == 1)
    chk("CONTRO-ESEMPIO coerenza: la regola dichiarata e' OLTRE 30 u ma lo SL sta a 20 -> TUTTE le 6 righe incoerenti", viola("sl", "2380.00000", 0, stop=("OLTRE_LINEA_ESTERNA", 30.0)) == 6)
    chk("CONTRO-ESEMPIO coerenza: esito 2 (vince X4) con SL PIU' VICINO della regola -> incoerente", viola("stop_esito", "2") == 0 and
        (lambda a: calcola(a, ll_, sim_xau, cfg_h1, datetime.datetime(2024, 7, 8, 10, 0), OL)["incoerenti_stop"])(
            [dict(x, stop_esito="2", sl="2385.00000") if i == 0 else x for i, x in enumerate(rr_)]) == 1)
    chk("CONTRO-ESEMPIO coerenza: esito 1 (scartato) con SL non nullo -> incoerente", viola("stop_esito", "1") == 1)
    chk("CONTRO-ESEMPIO coerenza: righe OLTRE lette con la regola GEOMETRIA_ATTUALE dichiarata -> 6 incoerenti (stop_modo 1 contro 0)", viola("sl", "2380.00000", 0, stop=STOP_V105) == 6)
    rg_, lg_, _h = leggi_csv(csv_finto(p6, u=1.0, spread=0.25, lv0=2400.0, versione="1.10"))
    chk("CONTRO-ESEMPIO coerenza: GEOMETRIA_ATTUALE con linea_stop non nulla -> incoerente",
        calcola([dict(x, linea_stop="2400.00000") if i == 0 else x for i, x in enumerate(rg_)], lg_, sim_xau, cfg_h1, datetime.datetime(2024, 7, 8, 10, 0), STOP_V105)["incoerenti_stop"] == 1)
    # impronta: v1.05 (44 colonne) == v1.10 GEOMETRIA_ATTUALE; due OLTRE con linea esterna diversa NO; GEOMETRIA contro OLTRE NO
    b105 = csv_finto(p6, u=1.0, spread=0.25, lv0=2400.0, versione="1.05")
    b110g = csv_finto(p6, u=1.0, spread=0.25, lv0=2400.0, versione="1.10")
    b110o = csv_finto(p6, u=1.0, spread=0.25, lv0=2400.0, versione="1.10", stop=OL)
    b110o2 = csv_finto(p6b, u=1.0, spread=0.25, lv0=2400.0, versione="1.10", stop=OL, linea_est=2398.0)
    b110o1 = csv_finto(p6b, u=1.0, spread=0.25, lv0=2400.0, versione="1.10", stop=OL)
    chk("impronta: v1.05 == v1.10 GEOMETRIA_ATTUALE (stesse righe CONTA); v1.10 OLTRE con linea esterna diversa -> DIVERSA",
        b105 != b110g and impronta(b105) == impronta(b110g) and impronta(b110o1) != impronta(b110o2) and stop_da_csv(b110o) == OL and stop_da_csv(b105) is None and stop_da_csv(b110g) == STOP_V105)
    chk("stop dalla riga AVVIO: v1.10 GEOMETRIA / OLTRE 20,00 u letti, v1.05 None",
        stop_da_avvio(log_finto(sim_xau, cfg_h1).splitlines()[1]) == STOP_V105 and stop_da_avvio(log_finto(sim_xau, cfg_h1, stop=OL).splitlines()[1]) == OL and
        stop_da_avvio(log_finto(sim_xau, cfg_h1, versione="1.05").splitlines()[1]) is None)

    # ---- v1.11: OLTRE_PIU_ESTERNA (stop_modo 2). Risposte per COSTRUZIONE.
    OP = ("OLTRE_PIU_ESTERNA", 20.0)
    c2_ = costo_di(sim_xau, 1.0, 0.25, 2400.0, versione="1.11", stop=OP, linea_est=2370.0)
    chk("v1.11 OLTRE_PIU_ESTERNA oro, setup ST35 con la EMA200 30 USD OLTRE la ST3,5 (2370): SL 2350, distanze 55/50/45, senza 220/200/180, coerente",
        [round(c2_["costo"][i]["dist"], 6) for i in range(3)] == [55.0, 50.0, 45.0] and [round(c2_["costo"][i]["r_senza"], 6) for i in range(3)] == [220.0, 200.0, 180.0] and
        c2_["incoerenti_stop"] == 0 and c2_["stop"] == OP, str(c2_["esempi_stop"]))
    c2b = costo_di(sim_xau, 1.0, 0.25, 2400.0, versione="1.11", stop=OP)
    chk("v1.11 OLTRE_PIU_ESTERNA, setup ST35 con la ST3,5 piu' esterna: stesse distanze di OLTRE_LINEA_ESTERNA (25/20/15), coerente",
        [round(c2b["costo"][i]["dist"], 6) for i in range(3)] == [25.0, 20.0, 15.0] and c2b["incoerenti_stop"] == 0)
    c2c = costo_di(sim_xau, 1.0, 0.25, 2400.0, versione="1.11", stop=OP, linea_est=2410.0)
    chk("CONTRO-ESEMPIO v1.11: setup ST35 long con la linea dello stop 2410 SOPRA la ST3,5 2400 (dentro) -> 6 righe incoerenti", c2c["incoerenti_stop"] == 6, str(c2c["esempi_stop"][:1]))
    c2d = costo_di(sim_xau, 1.0, 0.25, 2400.0, versione="1.11", stop=OP, linea_est=2370.0, piano={"E200": [ep(k, 1, 1, 0, 0, 10.0, 0.5) for k in range(6)]})
    chk("CONTRO-ESEMPIO v1.11: linea E200 (M2) con la linea dello stop diversa dalla EMA200 del setup -> 6 righe incoerenti", c2d["incoerenti_stop"] == 6, str(c2d["esempi_stop"][:1]))
    c2e = costo_di(sim_xau, 1.0, 0.25, 2400.0, versione="1.11", stop=OL, linea_est=2370.0)
    chk("CONTRO-ESEMPIO v1.10/v1.11: setup ST35 in OLTRE_LINEA_ESTERNA con la linea dello stop diversa dalla ST3,5 -> 6 righe incoerenti", c2e["incoerenti_stop"] == 6)
    c2f = costo_di(sim_xau, 1.0, 0.25, 2400.0, versione="1.11", stop=OP, linea_est=2370.0, piano=p6b)
    chk("v1.11: setup ST2,5 con la linea dello stop piu' esterna (EMA200) e' coerente (la scelta ST3,5/EMA200 non e' nel CSV: non si giudica)", c2f["incoerenti_stop"] == 0)
    rr2_, ll2_, _h = leggi_csv(csv_finto(p6, u=1.0, spread=0.25, lv0=2400.0, versione="1.11", stop=OP, linea_est=2370.0))
    chk("CONTRO-ESEMPIO v1.11: righe stop_modo 2 lette con la regola OLTRE_LINEA_ESTERNA dichiarata -> 6 incoerenti",
        calcola(rr2_, ll2_, sim_xau, cfg_h1, datetime.datetime(2024, 7, 8, 10, 0), OL)["incoerenti_stop"] == 6)
    b111p = csv_finto(p6, u=1.0, spread=0.25, lv0=2400.0, versione="1.11", stop=OP, linea_est=2370.0)
    chk("v1.11: regola dalla riga AVVIO e da #cfg;Stop (OLTRE_PIU_ESTERNA 20,00 u); AVVIO v1.11 senza '| stop' -> motivo",
        stop_da_avvio(log_finto(sim_xau, cfg_h1, stop=OP).splitlines()[1]) == OP and stop_da_csv(b111p) == OP and
        any("regola di stop" in m for m in controlla_avvio(log_finto(sim_eur, cfg_h1, versione="1.11", stop=None).splitlines()[1].split("[NatCla] ", 1)[1], cfg_h1, sim_eur)))

    # ---- la lettura da zip: pilota finto con 4 passate (XAU AUDIO_H1 ok; EURUSD AUDIO_H1 KO in log; XAU M2_H1 ok senza righe; EURUSD M2_H1 NON_LANCIATA)
    tmp = tempfile.mkdtemp(prefix="natcla_f0_autotest_")
    try:
        zp = os.path.join(tmp, "NATCLA_F0_PILOTA.zip")
        voci = [dict(sim="XAUUSD", cfg="AUDIO_H1", csv_bytes=csvb, log_txt=log_finto(sim_xau, cfg_h1), righe=len(righe), durata=50),
                dict(sim="EURUSD", cfg="AUDIO_H1", csv_bytes=cb, log_txt=log_finto(sim_eur, cfg_h1, chi="formula di Wilder (1/n)", adx_t=18.10), righe=len(rr2), durata=70),
                dict(sim="XAUUSD", cfg="M2_H1", csv_bytes=csv_finto({"E200": [ep(0, 2, 1, 0, 0, 10.0, 0.5)]}, u=1.0, spread=0.25, lv0=2400.0), log_txt=log_finto(sim_xau, cfg_m2), righe=2, durata=60),
                dict(sim="EURUSD", cfg="M2_H1", stato="NON_LANCIATA", righe=0, durata=0, motivi="tetto di 40 minuti")]
        costruisci_zip(zp, prova, voci)
        dati = carica([Sorgente(zp)])
        r_xau = dati["runs"][("XAUUSD", "AUDIO_H1")][0]
        chk("zip: XAUUSD AUDIO_H1 letta, OK, 57 setup", r_xau["stato"].startswith("OK") and r_xau["calc"]["n_linee"] == 57, str(r_xau["problemi"]))
        chk("zip: gli anni partono dalla barra VERIFICA ADX (2024-07-08), non dalla data della riga (2024-07-10)",
            abs(r_xau["calc"]["anni"] - (datetime.date(2026, 6, 30) - datetime.date(2024, 7, 8)).days / 365.25) < 1e-9, "%.5f" % r_xau["calc"]["anni"])
        r_eur = dati["runs"][("EURUSD", "AUDIO_H1")][0]
        chk("zip: EURUSD con VERIFICA ADX 'Wilder' = KO del lettore", r_eur["stato"] == "KO(lettore)" and any("Wilder" in p for p in r_eur["problemi"]), str(r_eur["problemi"]))
        r_m2 = dati["runs"][("XAUUSD", "M2_H1")][0]
        chk("zip: XAUUSD M2_H1 letta, 2 righe, E200 1 setup (limite illimitato: 0)", r_m2["stato"].startswith("OK") and r_m2["calc"]["linee"]["E200"]["setup"] == 1, str(r_m2["problemi"]))
        chk("zip: EURUSD M2_H1 NON_LANCIATA resta NON_LANCIATA", dati["runs"][("EURUSD", "M2_H1")][0]["stato"] == "NON_LANCIATA")
        out = []
        riepilogo(dati, out)
        t = "\n".join(out)
        chk("riepilogo: dice 'FERMARSI' quando una VERIFICA ADX non e' MetaQuotes", "FERMARSI" in t)
        chk("riepilogo: elenca la passata KO", "EURUSD" in t and "KO(lettore)" in t)
        chk("riepilogo: elenca le passate attese e assenti del lotto PILOTA (8 attese, 4 lette)", "ATTESE DAI LOTTI LETTI MA ASSENTI: 4" in t, [x for x in out if "ATTESE" in x][:1].__str__())
        chk("riepilogo: E0 oro scritto con il rapporto per linea", "E0 -- CONFRONTO" in t and "ST35" in t)
        chk("riepilogo: contro-esempio righe contro episodi", "CONTRO-ESEMPIO" in t)
        # determinismo: stessa passata in due zip
        zp2 = os.path.join(tmp, "NATCLA_F0_A.zip")
        costruisci_zip(zp2, prova, [dict(lotto="A", sim="XAUUSD", cfg="AUDIO_H1", csv_bytes=csvb, log_txt=log_finto(sim_xau, cfg_h1), righe=len(righe), durata=55)])
        d2 = carica([Sorgente(zp), Sorgente(zp2)])
        out2 = []
        riepilogo(d2, out2)
        chk("determinismo: stessa passata in due zip con CSV identico -> IDENTICI", any("DETERMINISMO XAUUSD/AUDIO_H1" in x and "IDENTICI" in x for x in out2))
        zp3 = os.path.join(tmp, "NATCLA_F0_A2.zip")
        csv_diverso = csv_finto({"ST25": piano["ST25"][:5]}, u=1.0, spread=0.25, lv0=2400.0)
        costruisci_zip(zp3, prova, [dict(lotto="A", sim="XAUUSD", cfg="AUDIO_H1", csv_bytes=csv_diverso, log_txt=log_finto(sim_xau, cfg_h1), righe=15, durata=55)])
        d3 = carica([Sorgente(zp), Sorgente(zp3)])
        out3 = []
        riepilogo(d3, out3)
        chk("determinismo: CSV DIVERSI -> il lettore lo dice", any("DETERMINISMO XAUUSD/AUDIO_H1" in x and "DIVERSI" in x for x in out3))
        # v1.05: la stessa passata girata con la v1.04 (PILOTA, archivio) e con la v1.05 (lotto C): CSV che differiscono SOLO nella riga #AVVIO
        zp8 = os.path.join(tmp, "NATCLA_F0_PILOTA_V104.zip")
        csv104 = csv_finto(piano, u=1.0, spread=0.25, lv0=2400.0, versione="1.04")
        costruisci_zip(zp8, prova, [dict(lotto="PILOTA", sim="XAUUSD", cfg="AUDIO_H1", csv_bytes=csv104, log_txt=log_finto(sim_xau, cfg_h1, versione="1.04"), righe=len(righe), durata=33)])
        d8 = carica([Sorgente(zp8), Sorgente(zp)])
        out8 = []
        riepilogo(d8, out8)
        r8 = d8["runs"][("XAUUSD", "AUDIO_H1")]
        chk("v1.04 (archivio, 44 colonne) contro v1.11 in GEOMETRIA_ATTUALE (47 colonne + #cfg;Stop), righe CONTA uguali: CSV interi DIVERSI ma DETERMINISMO IDENTICI, con le due versioni dichiarate",
            csv104 != csvb and len(set(x["csv_sha"] for x in r8)) == 2 and all(x["stato"].startswith("OK") for x in r8) and
            any("DETERMINISMO XAUUSD/AUDIO_H1" in x and "IDENTICI" in x and "v1.04 e v1.11" in x for x in out8), [x for x in out8 if "DETERMINISMO" in x])
        chk("riepilogo: le passate v1.04 sono contate e marcate come ARCHIVIO", any("VERSIONI DELL'EA" in x and "v1.04 x 1" in x and "ARCHIVIO" in x for x in out8))
        zp9 = os.path.join(tmp, "NATCLA_F0_C_V105_DIVERSO.zip")
        costruisci_zip(zp9, prova, [dict(lotto="C", sim="XAUUSD", cfg="AUDIO_H1", csv_bytes=csv_diverso, log_txt=log_finto(sim_xau, cfg_h1), righe=15, durata=55)])
        out9 = []
        riepilogo(carica([Sorgente(zp8), Sorgente(zp9)]), out9)
        chk("CONTRO-ESEMPIO: v1.04 contro v1.05 con righe CONTA DIVERSE -> DIVERSI (la riga #AVVIO tolta non nasconde una differenza vera)",
            any("DETERMINISMO XAUUSD/AUDIO_H1" in x and "DIVERSI" in x for x in out9))
        # cancello 07/10 notte (mutante cieco Y2): dall'impronta si toglie SOLO la riga #AVVIO; una #cfg diversa (configurazione diversa) resta DIVERSA
        csv_cfg = csvb.replace(b"#cfg;x;y;z\n", b"#cfg;x;y;DIVERSA\n", 1)
        zp11 = os.path.join(tmp, "NATCLA_F0_C_CFG_DIVERSA.zip")
        costruisci_zip(zp11, prova, [dict(lotto="C", sim="XAUUSD", cfg="AUDIO_H1", csv_bytes=csv_cfg, log_txt=log_finto(sim_xau, cfg_h1), righe=len(righe), durata=55)])
        out11 = []
        riepilogo(carica([Sorgente(zp8), Sorgente(zp11)]), out11)
        chk("CONTRO-ESEMPIO: stesse righe CONTA ma una riga #cfg DIVERSA -> DIVERSI (si toglie solo #AVVIO)",
            csv_cfg != csvb and any("DETERMINISMO XAUUSD/AUDIO_H1" in x and "DIVERSI" in x for x in out11), [x for x in out11 if "DETERMINISMO" in x])
        # cancello 07/10 notte (mutante cieco Y4): VERIFICA ADX 'NESSUNA DELLE DUE' (coerente coi tre numeri) e' KO come Wilder
        zp12 = os.path.join(tmp, "NATCLA_F0_NESSUNA.zip")
        costruisci_zip(zp12, prova, [dict(sim="XAUUSD", cfg="AUDIO_H1", csv_bytes=csvb, righe=len(righe),
                                          log_txt=log_finto(sim_xau, cfg_h1, adx_t=25.0, chi="NESSUNA DELLE DUE: il filtro ADX va capito PRIMA di leggere i numeri"))])
        r12 = carica([Sorgente(zp12)])["runs"][("XAUUSD", "AUDIO_H1")][0]
        chk("zip: VERIFICA ADX 'NESSUNA' (coerente coi tre numeri) = KO del lettore", r12["stato"] == "KO(lettore)" and any("NESSUNA" in p for p in r12["problemi"]), str(r12["problemi"]))
        # cancello 07/10 notte: una passata d'INDICE girata con la v1.04 non e' mai OK nel lettore (nemmeno con VERIFICA e CONTA)
        sim_u30z = bl["simboli"]["U30USD"]
        zp13 = os.path.join(tmp, "NATCLA_F0_C_U30_V104.zip")
        costruisci_zip(zp13, prova, [dict(lotto="C", sim="U30USD", cfg="AUDIO_H1", csv_bytes=csv104, log_txt=log_finto(sim_u30z, cfg_h1, versione="1.04"), righe=len(righe))])
        r13 = carica([Sorgente(zp13)])["runs"][("U30USD", "AUDIO_H1")][0]
        chk("zip: U30USD con AVVIO v1.04 (archivio) = KO del lettore: sugli indici vale solo la v1.05", r13["stato"] == "KO(lettore)" and any("INDICE" in p for p in r13["problemi"]), str(r13["problemi"]))
        # classe 1173 dentro la lettura vera: il log della passata ha la riga AVVIO e la VERIFICA ADX due volte, una TRONCATA
        lf2 = log_finto(sim_xau, cfg_h1).splitlines()
        log_doppio = "\r\n".join(lf2 + [lf2[1][:300], lf2[2][:len(lf2[2]) - 15]]) + "\r\n"
        zp10 = os.path.join(tmp, "NATCLA_F0_TRONCATE.zip")
        costruisci_zip(zp10, prova, [dict(sim="XAUUSD", cfg="AUDIO_H1", csv_bytes=csvb, log_txt=log_doppio, righe=len(righe))])
        r10 = carica([Sorgente(zp10)])["runs"][("XAUUSD", "AUDIO_H1")][0]
        chk("1173 nella lettura: log con AVVIO e VERIFICA ADX ripetute TRONCATE -> passata OK (una AVVIO, una VERIFICA)", r10["stato"].startswith("OK") and r10["adx"] is not None, str(r10["problemi"]))
        # MANIFEST che dice OK ma il CSV manca nello zip
        zp4 = os.path.join(tmp, "NATCLA_F0_X.zip")
        costruisci_zip(zp4, prova, [dict(sim="XAUUSD", cfg="AUDIO_H1", csv_bytes=None, log_txt=log_finto(sim_xau, cfg_h1), righe=10)])
        d4 = carica([Sorgente(zp4)])
        chk("MANIFEST OK ma CSV assente -> KO del lettore", d4["runs"][("XAUUSD", "AUDIO_H1")][0]["stato"] == "KO(lettore)")
        # MANIFEST con righe_conta diverso dal CSV
        zp5 = os.path.join(tmp, "NATCLA_F0_Y.zip")
        costruisci_zip(zp5, prova, [dict(sim="XAUUSD", cfg="AUDIO_H1", csv_bytes=csvb, log_txt=log_finto(sim_xau, cfg_h1), righe=len(righe) + 1)])
        d5 = carica([Sorgente(zp5)])
        chk("righe CONTA del MANIFEST diverse da quelle del CSV -> KO del lettore", d5["runs"][("XAUUSD", "AUDIO_H1")][0]["stato"] == "KO(lettore)")
        # CSV con limiti di tocco diversi dalla specifica
        csv_lim = csv_finto(piano, u=1.0, spread=0.25, lv0=2400.0, limiti=(0, 0, 0, 0))
        zp6 = os.path.join(tmp, "NATCLA_F0_Z.zip")
        costruisci_zip(zp6, prova, [dict(sim="XAUUSD", cfg="AUDIO_H1", csv_bytes=csv_lim, log_txt=log_finto(sim_xau, cfg_h1), righe=nrighe_attese)])
        d6 = carica([Sorgente(zp6)])
        chk("limiti di tocco del CSV (0/0/0) diversi dall'audio (1/1/2) -> segnalati", any("limiti di tocco" in p for p in d6["runs"][("XAUUSD", "AUDIO_H1")][0]["problemi"]))
        # soglia E0: 70 esatto = vivo, 69 no
        pv = {"ST25": [ep(k, 1, 1, 0, 0, 10.0, 0.5) for k in range(70)]}
        pn = {"ST25": [ep(k, 1, 1, 0, 0, 10.0, 0.5) for k in range(69)]}
        zp7 = os.path.join(tmp, "NATCLA_F0_V.zip")
        costruisci_zip(zp7, prova, [dict(sim="EURUSD", cfg="AUDIO_H1", csv_bytes=csv_finto(pv, u=0.0001, spread=0.00002, lv0=1.1), log_txt=log_finto(sim_eur, cfg_h1), righe=70),
                                    dict(sim="GBPUSD", cfg="AUDIO_H1", csv_bytes=csv_finto(pn, u=0.0001, spread=0.00002, lv0=1.3), log_txt=log_finto(bl["simboli"]["GBPUSD"], cfg_h1), righe=69)])
        d7 = carica([Sorgente(zp7)])
        o7 = []
        riepilogo(d7, o7)
        t7 = "\n".join(o7)
        chk("E0: 70 setup = VIVO, 69 = non vivo (1 su 2)", "VIVI (setup >= 70 nella finestra): 1 su 2 letti: EURUSD" in t7, [x for x in o7 if "E0: VIVI" in x].__str__())
        # spread usato dal tester: costante coerente, costante lontano dal campo, variabile
        zs = os.path.join(tmp, "NATCLA_F0_S.zip")
        pe2 = {"ST25": [ep(k, 1, 1, 0, 0, 10.0, 0.5) for k in range(6)]}
        costruisci_zip(zs, prova, [
            dict(sim="EURUSD", cfg="AUDIO_H1", csv_bytes=csv_finto(pe2, u=0.0001, spread=0.00002, lv0=1.1), log_txt=log_finto(sim_eur, cfg_h1), righe=6),
            dict(sim="GBPUSD", cfg="AUDIO_H1", csv_bytes=csv_finto(pe2, u=0.0001, spread=0.00020, lv0=1.3), log_txt=log_finto(bl["simboli"]["GBPUSD"], cfg_h1), righe=6),
            dict(sim="XAUUSD", cfg="AUDIO_H1", csv_bytes=csv_finto(pe2, u=1.0, spread=0.20, lv0=2400.0, spread_alt=0.60), log_txt=log_finto(sim_xau, cfg_h1), righe=6),
            dict(sim="EURGBP", cfg="AUDIO_H1", csv_bytes=csv_finto(pe2, u=0.0001, spread=0.00005, lv0=0.85), log_txt=log_finto(bl["simboli"]["EURGBP"], cfg_h1), righe=6),
            dict(sim="USDJPY", cfg="AUDIO_H1", csv_bytes=csv_finto(pe2, u=0.01, spread=0.0006, lv0=150.0), log_txt=log_finto(bl["simboli"]["USDJPY"], cfg_h1), righe=6)])
        os_ = []
        riepilogo(carica([Sorgente(zs)]), os_)
        riga_sp = {x.split()[0]: x for x in os_ if x.startswith("   ") and "min " in x and "mediana" in x and "max" in x}
        chk("spread EURUSD 0,2 pip costante, rapporto 1,00 con spread_vivo: COERENTE", "COSTANTE" in riga_sp.get("EURUSD", "") and "rapporto con spread_vivo 1.00: COERENTE" in riga_sp.get("EURUSD", ""), riga_sp.get("EURUSD"))
        chk("spread GBPUSD 2 pip contro 0,3 del campo: LONTANO, il verdetto di costo non si usa", "LONTANO" in riga_sp.get("GBPUSD", ""), riga_sp.get("GBPUSD"))
        chk("spread oro variabile (0,20 / 0,60): VARIABILE", "VARIABILE" in riga_sp.get("XAUUSD", ""), riga_sp.get("XAUUSD"))
        chk("spread USDJPY 0,06 pip contro 0,3 del campo (rapporto 0,2, SOTTO la banda 0,5 ma sopra 0,1): LONTANO", "LONTANO" in riga_sp.get("USDJPY", ""), riga_sp.get("USDJPY"))
        chk("spread EURGBP: nessuno spread_vivo, lo dice", "nessuno spread_vivo" in riga_sp.get("EURGBP", ""), riga_sp.get("EURGBP"))
        # tabella csv
        tc = os.path.join(tmp, "t.csv")
        tabella_csv(dati, tc)
        chk("tabella CSV scritta con intestazione e righe per linea", open(tc).read().count("\n") > 4)
        # SEPARATORI (07/10, pilota vero): zip di Compress-Archive con i nomi a BACKSLASH, estratto in una CARTELLA con zipfile (su Linux: file col backslash nel nome)
        zb = os.path.join(tmp, "NATCLA_F0_BACKSLASH.zip")
        with zipfile.ZipFile(zp) as zsrc, zipfile.ZipFile(zb, "w") as zdst:
            for n in zsrc.namelist():
                zdst.writestr(n.replace("/", "\\"), zsrc.read(n))
        cb_dir = os.path.join(tmp, "estratto_backslash")
        os.makedirs(cb_dir)
        zipfile.ZipFile(zb).extractall(cb_dir)
        dzb = carica([Sorgente(zb)])
        ddir = carica([Sorgente(cb_dir)])
        okz = dzb["runs"][("XAUUSD", "AUDIO_H1")][0]
        okd = ddir["runs"][("XAUUSD", "AUDIO_H1")][0]
        chk("separatori: zip con nomi a backslash letto, XAUUSD AUDIO_H1 OK 57 setup", okz["stato"].startswith("OK") and okz["calc"]["n_linee"] == 57, str(okz["problemi"]))
        chk("separatori: CARTELLA estratta da quello zip letta uguale (OK, 57 setup, stesso SHA del CSV)",
            okd["stato"].startswith("OK") and okd["calc"] is not None and okd["calc"]["n_linee"] == 57 and okd["csv_sha"] == okz["csv_sha"], str(okd["problemi"]))
        # contro-esempio: stesso nome normalizzato, contenuto DIVERSO (backslash + sottocartella) -> errore, non una scelta silenziosa
        amb = os.path.join(tmp, "ambiguo")
        os.makedirs(os.path.join(amb, "csv"))
        open(os.path.join(amb, "csv", "x.csv"), "wb").write(b"uno")
        open(os.path.join(amb, "csv\\x.csv"), "wb").write(b"due")
        try:
            Sorgente(amb)
            ambiguo_preso = (os.sep == "\\")      # su Windows il secondo file e' lo stesso del primo: niente da prendere
        except ValueError:
            ambiguo_preso = True
        chk("separatori: due file DIVERSI con lo stesso nome normalizzato -> errore dichiarato", ambiguo_preso)
        # ---- v1.10 nella lettura vera (zip): regola di stop dichiarata, coerente, determinismo per regola
        zv = os.path.join(tmp, "NATCLA_F0_V110.zip")
        costruisci_zip(zv, prova, [dict(lotto="A", sim="XAUUSD", cfg="AUDIO_H1", csv_bytes=b110o, log_txt=log_finto(sim_xau, cfg_h1, stop=OL), righe=6)])
        rv = carica([Sorgente(zv)])["runs"][("XAUUSD", "AUDIO_H1")][0]
        ov = []
        riepilogo(carica([Sorgente(zv)]), ov)
        chk("zip v1.10 OLTRE coerente: OK, regola letta, tabella con '[stop OLTRE_LINEA_ESTERNA 20.00 u]'", rv["stato"].startswith("OK") and rv["stop"] == OL and
            any("[stop OLTRE_LINEA_ESTERNA 20.00 u" in x for x in ov), str(rv["problemi"]))
        bad = b110o.replace(b";2380.00000;", b";2420.00000;", 1)
        zb2 = os.path.join(tmp, "NATCLA_F0_V110_BAD.zip")
        costruisci_zip(zb2, prova, [dict(lotto="A", sim="XAUUSD", cfg="AUDIO_H1", csv_bytes=bad, log_txt=log_finto(sim_xau, cfg_h1, stop=OL), righe=6)])
        rb2 = carica([Sorgente(zb2)])["runs"][("XAUUSD", "AUDIO_H1")][0]
        chk("CONTRO-ESEMPIO zip: una riga con lo SL dal lato sbagliato -> KO(lettore) 'regola di stop NON rispettata'", bad != b110o and rb2["stato"] == "KO(lettore)" and
            any("NON rispettata" in x for x in rb2["problemi"]), str(rb2["problemi"]))
        zb3 = os.path.join(tmp, "NATCLA_F0_V110_AVVIO.zip")
        costruisci_zip(zb3, prova, [dict(lotto="A", sim="XAUUSD", cfg="AUDIO_H1", csv_bytes=b110g, log_txt=log_finto(sim_xau, cfg_h1, stop=OL), righe=6)])
        rb3 = carica([Sorgente(zb3)])["runs"][("XAUUSD", "AUDIO_H1")][0]
        chk("CONTRO-ESEMPIO zip: AVVIO dice OLTRE, CSV dice GEOMETRIA_ATTUALE -> KO(lettore)", rb3["stato"] == "KO(lettore)" and any("riga AVVIO" in x for x in rb3["problemi"]), str(rb3["problemi"]))
        nocfg = b"\n".join(l for l in b110o.split(b"\n") if not l.startswith(b"#cfg;Stop;"))
        zb4 = os.path.join(tmp, "NATCLA_F0_V110_NOCFG.zip")
        costruisci_zip(zb4, prova, [dict(lotto="A", sim="XAUUSD", cfg="AUDIO_H1", csv_bytes=nocfg, log_txt=log_finto(sim_xau, cfg_h1, stop=OL), righe=6)])
        rb4 = carica([Sorgente(zb4)])["runs"][("XAUUSD", "AUDIO_H1")][0]
        chk("CONTRO-ESEMPIO zip: colonne v1.10 senza la riga #cfg;Stop -> KO(lettore) (regola non dichiarata)", rb4["stato"] == "KO(lettore)" and
            any("#cfg;Stop" in x for x in rb4["problemi"]), str(rb4["problemi"]))
        zg = os.path.join(tmp, "NATCLA_F0_V110_GEO.zip")
        costruisci_zip(zg, prova, [dict(lotto="A", sim="XAUUSD", cfg="AUDIO_H1", csv_bytes=b110g, log_txt=log_finto(sim_xau, cfg_h1), righe=6)])
        z105 = os.path.join(tmp, "NATCLA_F0_V105_GEO.zip")
        costruisci_zip(z105, prova, [dict(lotto="C", sim="XAUUSD", cfg="AUDIO_H1", csv_bytes=b105, log_txt=log_finto(sim_xau, cfg_h1, versione="1.05"), righe=6)])
        od = []
        riepilogo(carica([Sorgente(zg), Sorgente(zv), Sorgente(z105)]), od)
        det = [x for x in od if "DETERMINISMO XAUUSD/AUDIO_H1" in x]
        chk("determinismo v1.10/v1.11: GEOMETRIA (v1.05 e v1.11) contro OLTRE -> 'REGOLE DI STOP DIVERSE', le due GEOMETRIA IDENTICHE, nessun 'DIVERSI' falso",
            any("REGOLE DI STOP DIVERSE" in x for x in det) and any("[stop GEOMETRIA_ATTUALE]" in x and "IDENTICI" in x and "v1.05 e v1.11" in x for x in det) and
            not any("DIVERSI:" in x for x in det), det)
        # ---- v1.11 nella lettura vera: OLTRE_PIU_ESTERNA OK, e contro OLTRE_LINEA_ESTERNA = regole diverse
        zp2 = os.path.join(tmp, "NATCLA_F0_V111.zip")
        costruisci_zip(zp2, prova, [dict(lotto="A", sim="XAUUSD", cfg="AUDIO_H1", csv_bytes=b111p, log_txt=log_finto(sim_xau, cfg_h1, stop=OP), righe=6)])
        r2z = carica([Sorgente(zp2)])["runs"][("XAUUSD", "AUDIO_H1")][0]
        o2z = []
        riepilogo(carica([Sorgente(zp2), Sorgente(zv)]), o2z)
        d2z = [x for x in o2z if "DETERMINISMO XAUUSD/AUDIO_H1" in x]
        chk("zip v1.11 OLTRE_PIU_ESTERNA: OK; contro una OLTRE_LINEA_ESTERNA -> 'REGOLE DI STOP DIVERSE', nessun 'DIVERSI' falso",
            r2z["stato"].startswith("OK") and r2z["stop"] == OP and any("REGOLE DI STOP DIVERSE" in x and "OLTRE_PIU_ESTERNA" in x for x in d2z) and
            not any("DIVERSI:" in x for x in d2z), str(r2z["problemi"]) + str(d2z))
        zb5 = os.path.join(tmp, "NATCLA_F0_V111_AVVIO.zip")
        costruisci_zip(zb5, prova, [dict(lotto="A", sim="XAUUSD", cfg="AUDIO_H1", csv_bytes=b111p, log_txt=log_finto(sim_xau, cfg_h1, stop=OL), righe=6)])
        rb5 = carica([Sorgente(zb5)])["runs"][("XAUUSD", "AUDIO_H1")][0]
        chk("CONTRO-ESEMPIO zip v1.11: AVVIO dice OLTRE_LINEA_ESTERNA, CSV dice OLTRE_PIU_ESTERNA -> KO(lettore)", rb5["stato"] == "KO(lettore)" and
            any("riga AVVIO" in x for x in rb5["problemi"]), str(rb5["problemi"]))
    finally:
        import shutil
        shutil.rmtree(tmp, ignore_errors=True)

    falliti = [e for e in esiti if not e[1]]
    for nome, ok, det in esiti:
        print("  %s %s%s" % ("OK  " if ok else "FAIL", nome, ("   [" + str(det) + "]") if (det and not ok) else ""))
    print("AUTOTEST leggi_natcla_f0: %d controlli, %d falliti" % (len(esiti), len(falliti)))
    return 1 if falliti else 0


def main():
    a = sys.argv[1:]
    if "--autotest" in a:
        sys.exit(autotest())
    prova_f = None
    csv_out = None
    percorsi = []
    i = 0
    while i < len(a):
        if a[i] == "--prova":
            prova_f = a[i + 1]; i += 2
        elif a[i] == "--csv-out":
            csv_out = a[i + 1]; i += 2
        else:
            percorsi.append(a[i]); i += 1
    if not percorsi:
        print(__doc__)
        sys.exit(2)
    dati = carica([Sorgente(p) for p in percorsi], open(prova_f, encoding="ascii").read() if prova_f else None)
    out = []
    riepilogo(dati, out)
    print("\n".join(out))
    if csv_out:
        tabella_csv(dati, csv_out)
        print("tabella scritta in " + csv_out)


if __name__ == "__main__":
    main()
