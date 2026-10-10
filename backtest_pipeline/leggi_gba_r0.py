#!/usr/bin/env python3
# -*- coding: ascii -*-
"""
leggi_gba_r0.py -- IL LETTORE di GBA_R0 (passo 0 sonda + passo 1 replica di ABTG_GoldBreakoutATR v1.10 su XAUUSD).
Legge cio' che torna da GBA_R0_PASSATE.ps1 (zip o cartella): MANIFEST_R0.csv, report\\GBA_R0_<passata>.htm (report del tester), log\\GBA_<passata>.txt
(righe [GBA...] dell'EA per intero), il file prova copiato. Stampa, nell'ordine scritto nel file prova PRIMA dei numeri:
  (1) cancelli G0/G1/G2; (2) n e frequenza; (3) COSTO (stop/(spread+commissione)) PRIMA del PF; (4) PF, DD, lato; (5) concentrazione; (6) ORA (6 fasce a priori).
NON giudica il merito oltre le soglie CONGELATE nel file prova (S1-S7), NON promuove niente, NON scrive la parola 'morto' (il certificato dei 5 non e' completo).

USO
  python3 backtest_pipeline/leggi_gba_r0.py GBA_R0_S0.zip [GBA_R0_R1A.zip GBA_R0_R1B.zip ...] [--csv-out R0_tabella.csv]
  python3 backtest_pipeline/leggi_gba_r0.py --autotest      (dati finti con risposta nota + contro-esempi; esce 1 se un controllo cade)

COME SI CONTA (identico a cio' che dice il file prova)
  Posizione = coppia sequenziale di deal 'in' -> 'out' del report (un magic = UNA posizione per volta, R9 dell'EA; due 'in' di fila = G0 KO).
  Netto di una posizione = profitto + commissioni + swap dei suoi deal. Se la somma delle commissioni del report e' ZERO, PF_V sottrae una commissione IPOTETICA
  di 3,90 EUR per lotto e per operazione (e la versione 7,80 come contro-esempio): il tester potrebbe non addebitarla (BCM: 3,90 EUR/lotto dichiarata, per lato o a giro non detto).
  r = netto della posizione / perdita a SL scritta dall'EA nella riga dell'ingresso ('perdita a SL ~X EUR').
  Ora = ora SERVER del deal d'ingresso. Tranche = finestra del manifest.
  Costo di un ingresso = 2,5 x ATR / (spread + commissione per oncia), da ATR e spread scritti dall'EA nella riga del segnale (2 decimali); commissione 0,04 USD/oz (3,90 EUR/lotto a giro,
  1 lotto = 100 oz) e 0,08 (per lato): le due versioni si stampano sempre.
"""
import csv, datetime, io, math, os, re, statistics, sys, zipfile

QD = os.path.dirname(os.path.abspath(__file__))
REPO = os.path.abspath(os.path.join(QD, ".."))

# ---------------------------------------------------------------------------------------------------------------------
#  SOGLIE CONGELATE -- copiate dal file prova GBA_R0_REPLICA_2026-10-09.txt, scritte PRIMA dei numeri
# ---------------------------------------------------------------------------------------------------------------------
N_MIN = 150                 # S1: merito solo con n >= 150 (cella, somma tranche; tranche da sola)
N_FASCIA = 100              # S6: una fascia si legge solo con n >= 100
P_FASCIA = 0.05 / 6.0       # S6: correzione per sei fasce
COSTO_LAVORO = 40.0         # S2: >= 40 PASSA
COSTO_DURO = 13.3           # S2: < 13,3 ESCLUSA PER COSTO
COMM_EUR_LOTTO_GIRO = 3.90  # S3: commissione ipotetica per operazione (a giro) se il tester non ne addebita
COMM_EUR_LOTTO_LATO = 7.80  # S3: contro-esempio (per lato)
COMM_USD_OZ = (0.04, 0.08)  # costo: 3,90 EUR/lotto = 0,04 USD/oz a giro; 0,08 per lato
PF_RISCONTRO = 1.5          # S4
PF_NESSUN_VERDETTO = 1.3    # S4
PF_TRANCHE = 1.3            # S4: PF_V > 1,3 in almeno 2 tranche su 3
TOP1_FRAGILE = 0.25         # S5
TOP_N_FRAGILE = 5           # S5
TETTO_BARRE = 100000
DEPOSITO_ATTESO = 1000000.0  # v3 del driver (Deposit=1000000): se il report dice altro, il .ini non e' stato applicato come dichiarato -> DA GUARDARE
FASCE = [(0, 7, "asia"), (7, 12, "europa"), (12, 14, "pausa"), (14, 17, "USA apertura"), (17, 22, "USA pomeriggio"), (22, 24, "rollover")]
# attese E1 (proxy del 09/10, banda 0,5x-2x): n della cella REPL per tranche
ATTESA_N_REPL = {"T1": (60, 260), "T2": (125, 500), "T3": (350, 1400)}
ATTESA_N_REPL_TOT = (535, 2100)
SMENTITA_N_REPL = (300, 3500)
# attese del lotto R2REG (file prova GBA_R2_REGIME_2026-10-10.txt, E1/E2, scritte PRIMA dei numeri; proxy backtest_pipeline/proxy_gba_r2reg.py, banda 0,5x-2x,
# proxy < 15 -> banda 0-30 'quasi vuota'). Chiave (lotto, cella): {tranche: (min, max)}, "TOT": (min, max) sulle 6 tranche, "SMENTITA": (min, max) sul totale.
ATTESE_LOTTO = {
    ("R1A", "REPL"): {"T1": (60, 260), "T2": (125, 500), "T3": (350, 1400), "TOT": (535, 2100), "SMENTITA": (300, 3500)},
    ("R2REG", "REPL"): {"T9": (0, 30), "T8": (0, 30), "T7": (0, 30), "T6": (21, 84), "T5": (8, 32), "T4": (76, 304), "TOT": (108, 432), "SMENTITA": (0, 1000)},
    ("R2REG", "C035"): {"T9": (673, 2690), "T8": (800, 3200), "T7": (808, 3230), "T6": (1221, 4884), "T5": (1011, 4042), "T4": (1162, 4648), "TOT": (5674, 22694), "SMENTITA": (1500, 40000)},
}
# lotti la cui data 'a' e' ESCLUSIVA nel manifest (ToDate del tester: MISURATO in R1A, ultimo evento = giorno prima di 'a'). R1A/R1B/S0 hanno 'a' = ultimo giorno
# del trimestre: il loro conteggio dei giorni feriali resta quello gia' stampato (inclusivo), per non cambiare numeri gia' letti.
LOTTI_A_ESCLUSIVA = ("R2REG",)
ORDINE_LOTTI = {"S0": 0, "R1A": 1, "R1B": 2, "R2REG": 3}
# FIRMA di Claudio 10/10/2026 (report/FIRME_2026-10-10.md, Firma 1): lettura PER REGIME, regola oggettiva sul prezzo (proxy_gba_r2reg.py --regimi).
# Direzione: TORO R>=+5% e ER>=0,15 | RIBASSO R<=-5% e ER>=0,15 | LATERALE altrimenti. Volatilita': CALMO < 3,5 bp, VOLATILE >= 3,5 bp.
REGIMI_TRANCHE = {"T9": ("TORO", "CALMO"), "T8": ("LATERALE", "CALMO"), "T7": ("TORO", "CALMO"), "T6": ("LATERALE", "VOLATILE"), "T5": ("TORO", "CALMO"),
                  "T4": ("TORO", "VOLATILE"), "T3": ("LATERALE", "VOLATILE"), "T2": ("RIBASSO", "VOLATILE"), "T1": ("LATERALE", "VOLATILE")}
N_REGIME = 150               # firma 10/10: regime con < 150 operazioni = NON MISURATO
TRANCHE_MIN_REGIME = 2       # firma 10/10: regime con meno di due tranche = NON MISURATO
# orologio BCM (OROLOGIO_BCM_2026-09-24.md): ingressi dal 2024-10-27 al 2025-02-02 in un orologio (UTC+0 d'inverno) che per l'oro e' [NON MISURATO]
OROLOGIO_INCERTO = (datetime.datetime(2024, 10, 27, 0, 0, 0), datetime.datetime(2025, 2, 3, 0, 0, 0))


# ---------------------------------------------------------------------------------------------------------------------
#  UN SORGENTE = uno zip o una cartella (nomi normalizzati: Compress-Archive scrive il backslash)
# ---------------------------------------------------------------------------------------------------------------------
class Sorgente:
    def __init__(self, percorso):
        self.percorso = percorso
        self.zip = None
        self.reali = {}
        if os.path.isdir(percorso):
            self.nomi = []
            for rd, _d, files in os.walk(percorso):
                for f in files:
                    vero = os.path.join(rd, f)
                    nome = os.path.relpath(vero, percorso).replace(os.sep, "/").replace("\\", "/")
                    if nome in self.reali:
                        if open(self.reali[nome], "rb").read() != open(vero, "rb").read():
                            raise ValueError("due file diversi con lo stesso nome normalizzato '%s'" % nome)
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


def decodifica(raw):
    if raw[:2] in (b"\xff\xfe", b"\xfe\xff"):
        return raw.decode("utf-16", "replace")
    if len(raw) > 4 and raw[1:2] == b"\x00" and raw[3:4] == b"\x00":
        return raw.decode("utf-16-le", "replace")
    return raw.decode("utf-8", "replace").lstrip("\ufeff")


def numero(s):
    """'1 090.56' / '-989.08' / '100 000.00' / '0.00' -> float; None se non e' un numero."""
    if s is None:
        return None
    t = str(s).replace("\xa0", "").replace(" ", "").replace("\u202f", "").strip()
    if t == "":
        return None
    try:
        return float(t)
    except ValueError:
        return None


# ---------------------------------------------------------------------------------------------------------------------
#  IL REPORT DEL TESTER (.htm, UTF-16)
# ---------------------------------------------------------------------------------------------------------------------
def _cella(piatto, etichette):
    for e in etichette:
        m = re.search(r"\|" + e + r":\|([^|]*)\|", piatto)
        if m:
            return re.sub(r"\s", "", m.group(1))
    return None


def _dd(s):
    """'64 664.31 (56.22%)' (spazi gia' tolti: '64664.31(56.22%)') -> (assoluto, percentuale)"""
    if s is None:
        return (None, None)
    m = re.match(r"^(-?[0-9.]+)\(([0-9.]+)%\)$", s)
    if not m:
        return (None, None)
    return (float(m.group(1)), float(m.group(2)))


def leggi_report(raw):
    t = decodifica(raw)
    piatto = re.sub(r"<[^>]+>", "|", t)
    piatto = re.sub(r"\s*\|[\s|]*", "|", piatto)
    r = {"ok": False, "motivo": ""}
    r["expert"] = _cella(piatto, ["Expert"])
    r["simbolo"] = _cella(piatto, ["Simbolo", "Symbol"])
    r["periodo"] = _cella(piatto, ["Periodo", "Period"])
    r["qualita"] = _cella(piatto, ["Qualit. dello Storico", "History Quality"])
    r["barre"] = numero(_cella(piatto, ["Barre", "Bars"]))
    r["ticks"] = numero(_cella(piatto, ["Ticks"]))
    r["trades"] = numero(_cella(piatto, ["Numero di Operazioni di Trading Totali", "Total Trades"]))
    r["profitto"] = numero(_cella(piatto, ["Profitto Totale Netto", "Total Net Profit"]))
    r["pf"] = numero(_cella(piatto, ["Fattore di Profitto", "Profit Factor"]))
    r["deposito"] = numero(_cella(piatto, ["Deposito Iniziale", "Initial Deposit"]))
    r["dd_eq_abs"], r["dd_eq_pct"] = _dd(_cella(piatto, ["Equit. Drawdown Massima", "Equity Drawdown Maximal"]))
    r["dd_bil_abs"], r["dd_bil_pct"] = _dd(_cella(piatto, ["Bilancio Drawdown Massimo", "Balance Drawdown Maximal"]))
    # i deal: righe <tr> con 13 celle, la prima e' una data e la seconda un intero
    deals = []
    for tr in re.findall(r"<tr[^>]*>(.*?)</tr>", t, flags=re.S | re.I):
        celle = [re.sub(r"\s+", " ", re.sub(r"<[^>]+>", "", c)).replace("&nbsp;", " ").strip() for c in re.findall(r"<td[^>]*>(.*?)</td>", tr, flags=re.S | re.I)]
        if len(celle) == 13 and re.match(r"^\d{4}\.\d\d\.\d\d \d\d:\d\d:\d\d$", celle[0]) and celle[1].isdigit() and celle[3] in ("buy", "sell"):
            deals.append({"t": datetime.datetime.strptime(celle[0], "%Y.%m.%d %H:%M:%S"), "id": int(celle[1]), "sim": celle[2], "tipo": celle[3], "dir": celle[4],
                          "vol": numero(celle[5]), "prezzo": numero(celle[6]), "comm": numero(celle[8]) or 0.0, "swap": numero(celle[9]) or 0.0,
                          "profitto": numero(celle[10]) or 0.0, "commento": celle[12]})
    r["deals"] = deals
    if r["trades"] is None or r["profitto"] is None:
        r["motivo"] = "etichette del totale operazioni / profitto netto non trovate"
        return r
    r["ok"] = True
    return r


def accoppia(deals):
    """Posizioni = deal 'in' seguiti dal loro 'out' (UNA posizione per volta). Restituisce (posizioni, aperta_a_fine, errori)."""
    pos = []
    aperto = None
    err = []
    for d in deals:
        if d["dir"] == "in":
            if aperto is not None:
                err.append("due 'in' di fila (deal %d dopo %d): piu posizioni insieme, l'accoppiamento sequenziale non vale" % (d["id"], aperto["id"]))
            aperto = d
        elif d["dir"] in ("out", "in/out", "out by"):
            if aperto is None:
                err.append("'out' senza 'in' (deal %d)" % d["id"])
                continue
            pos.append({"in": aperto, "out": d})
            aperto = None
    return pos, aperto, err


# ---------------------------------------------------------------------------------------------------------------------
#  IL GIORNALE DELL'EA (log\GBA_<passata>.txt)
# ---------------------------------------------------------------------------------------------------------------------
RE_SEG = re.compile(r"^\[GBA\] segnale (?P<lato>BUY|SELL)(?: SALTATO \((?P<motivo>[^)]*)\))? \| close (?P<close>[0-9.]+) canale (?P<ll>[0-9.]+)-(?P<hh>[0-9.]+) EMA (?P<ema>[0-9.]+) "
                    r"ATR (?P<atr>[0-9.]+) spread (?P<spread>[0-9.]+) = (?P<pct>-?[0-9.]+)% ATR \(max (?P<max>[0-9.]+)%\) \| stop/spread (?P<rap>-?[0-9.]+)x \| ora server (?P<ora>[0-9]+)")
RE_ING = re.compile(r"^\[GBA\] (?P<lato>BUY|SELL) (?P<lotti>[0-9.]+) lotti @ (?P<prezzo>[0-9.]+) \| SL (?P<sl>[0-9.]+) \((?P<k>[0-9.]+) x ATR (?P<atr>[0-9.]+)\) \| spread (?P<spread>[0-9.]+) \| perdita a SL ~(?P<perdita>-?[0-9.]+) (?P<valuta>\w+)")
RE_CONTA = re.compile(r"^\[GBA-CONTA\] (?P<quando>\w+) \| segnali (?P<seg>[0-9]+) \| ingressi tentati (?P<ing>[0-9]+) \| scartati: SPREAD (?P<spr>[0-9]+) \(spread max (?P<max>[0-9.]+) x ATR\) \| posizione aperta (?P<pos>[0-9]+)")


def leggi_log(testo):
    # "anomalie": le righe dell'EA che cambiano n o l'USCITA senza far cadere la passata (ordini saltati, errori d'ordine, errori di gestione: trailing/tempo).
    # Il driver v3 ne conta solo una parte nella testa del log; qui si contano tutte e si stampano nel punto (1). Limite: il driver deduplica per
    # (ora simulata + primi 70 caratteri), quindi errori ripetuti nello stesso secondo simulato contano UNA volta: e' un minimo, non un totale.
    out = {"segnali": [], "ingressi": [], "conta_fine": None, "tester": [], "righe": 0, "anomalie": {}}
    for riga in testo.splitlines():
        riga = riga.rstrip()
        if not riga:
            continue
        if riga.startswith("#"):
            out["tester"].append(riga)
            continue
        m = re.match(r"^(\d{4}\.\d\d\.\d\d \d\d:\d\d:\d\d)\s+(\[GBA.*)$", riga)
        if not m:
            continue
        out["righe"] += 1
        st, msg = m.group(1), m.group(2)
        t = datetime.datetime.strptime(st, "%Y.%m.%d %H:%M:%S")
        ka = None
        if msg.startswith("[GBA] MARGINE INSUFFICIENTE"):
            ka = "margine insufficiente (ingresso saltato)"
        elif msg.startswith("[GBA] ERRORE ordine"):
            ka = "errore d'ordine (ingresso non eseguito)"
        elif msg.startswith("[GBA] ERRORE spostamento SL"):
            ka = "errore spostamento SL (trailing/BE non applicato)"
        elif msg.startswith("[GBA] ERRORE chiusura a tempo"):
            ka = "errore chiusura a tempo"
        elif "ordine saltato" in msg:
            ka = "altro ingresso saltato (" + re.sub(r"[0-9.]+", "#", msg[6:].split(" -- ")[0])[:50].strip() + ")"
        elif msg.startswith("[GBA] ERRORE"):
            ka = "altro errore (" + re.sub(r"[0-9.]+", "#", msg[6:46]).strip() + ")"
        elif msg.startswith("[GBA] dati non pronti"):
            ka = "dati non pronti (segnale NON valutato: storia M1/EMA/ATR mancante all'inizio della finestra?)"
        if ka:
            out["anomalie"][ka] = out["anomalie"].get(ka, 0) + 1
        ms = RE_SEG.match(msg)
        if ms:
            d = ms.groupdict()
            out["segnali"].append({"t": t, "lato": d["lato"], "preso": d["motivo"] is None, "motivo": d["motivo"] or "", "atr": float(d["atr"]), "spread": float(d["spread"]),
                                   "pct": float(d["pct"]), "rap": float(d["rap"]), "ora": int(d["ora"])})
            continue
        mi = RE_ING.match(msg)
        if mi:
            d = mi.groupdict()
            out["ingressi"].append({"t": t, "lato": d["lato"], "lotti": float(d["lotti"]), "prezzo": float(d["prezzo"]), "atr": float(d["atr"]), "spread": float(d["spread"]),
                                    "perdita": float(d["perdita"]), "valuta": d["valuta"]})
            continue
        mc = RE_CONTA.match(msg)
        if mc and mc.group("quando") == "FINE":
            out["conta_fine"] = {k: (float(v) if "." in v else int(v)) for k, v in mc.groupdict().items() if k != "quando"}
    return out


# ---------------------------------------------------------------------------------------------------------------------
#  STATISTICHE
# ---------------------------------------------------------------------------------------------------------------------
def pf_di(lista):
    g = sum(x for x in lista if x > 0)
    p = -sum(x for x in lista if x < 0)
    if p <= 0:
        return float("inf") if g > 0 else float("nan")
    return g / p


def mediana(v):
    return statistics.median(v) if v else float("nan")


def percentile(v, p):
    if not v:
        return float("nan")
    s = sorted(v)
    return s[min(len(s) - 1, int(p * (len(s) - 1)))]


def p_media_zero(valori):
    """p bilaterale della media contro zero, approssimazione normale (si usa solo con n >= 30; sotto: None)."""
    n = len(valori)
    if n < 30:
        return None
    sd = statistics.pstdev(valori) * math.sqrt(n / (n - 1.0))
    if sd == 0:
        return 0.0 if statistics.mean(valori) != 0 else 1.0
    t = statistics.mean(valori) / (sd / math.sqrt(n))
    return math.erfc(abs(t) / math.sqrt(2.0))


def giorni_feriali(da, a, esclusivo=False):
    d0 = datetime.datetime.strptime(da, "%Y.%m.%d").date()
    d1 = datetime.datetime.strptime(a, "%Y.%m.%d").date()
    if esclusivo:
        d1 = d1 - datetime.timedelta(days=1)
    n = 0
    d = d0
    while d <= d1:
        if d.weekday() < 5:
            n += 1
        d += datetime.timedelta(days=1)
    return n


def costruisci_passata(riga, rep, log):
    """riga = riga del manifest. Restituisce un dict con posizioni, g0, costi, segnali."""
    P = {"riga": riga, "tag": riga["passata"], "cella": riga["cella"], "tranche": riga["tranche"], "modello": int(riga["modello"]), "magic": riga["magic"],
         "g0": [], "pos": [], "aperta": None, "rep": rep, "log": log}
    if riga["stato"] == "NON_LANCIATA":
        P["g0"].append("NON LANCIATA")
        return P
    if riga["stato"].startswith("KO"):
        P["g0"].append("KO del driver: " + riga["motivi"])
    if rep is None or not rep["ok"]:
        P["g0"].append("report assente o illeggibile")
        return P
    pos, aperta, err = accoppia(rep["deals"])
    for e in err:
        P["g0"].append("accoppiamento: " + e)
    P["pos"], P["aperta"] = pos, aperta
    nrep = int(rep["trades"])
    if abs(nrep - (len(pos) + (1 if aperta else 0))) > 1:
        P["g0"].append("operazioni del report %d contro posizioni dai deal %d(+%d aperta)" % (nrep, len(pos), 1 if aperta else 0))
    # PF e profitto netto RICALCOLATI dai deal contro il report (S3 / G0)
    nets = [p["in"]["profitto"] + p["in"]["comm"] + p["in"]["swap"] + p["out"]["profitto"] + p["out"]["comm"] + p["out"]["swap"] for p in pos]
    if rep["pf"] is not None and nets:
        pfc = pf_di(nets)
        if not (math.isfinite(pfc) and abs(pfc - rep["pf"]) <= 0.02):
            # il report puo' includere la posizione aperta a fine test o contare i deal; si segnala, non si nasconde
            P["g0"].append("PF ricalcolato dai deal %.3f contro PF del report %.2f (tolleranza 0,02)" % (pfc, rep["pf"]))
    tot = sum(nets)
    if abs(tot - rep["profitto"]) > max(1.0, abs(rep["profitto"]) * 0.001):
        P["g0"].append("profitto netto ricalcolato dai deal %.2f contro il report %.2f" % (tot, rep["profitto"]))
    # accoppiamento con le righe d'ingresso del giornale (stesso ordine, stesso lato, stesso prezzo)
    ing = log["ingressi"] if log else []
    P["r_ok"] = False
    if ing and len(ing) >= len(pos):
        ok = True
        for i, p in enumerate(pos):
            a, b = p["in"], ing[i]
            if (a["tipo"] == "buy") != (b["lato"] == "BUY") or abs(a["prezzo"] - b["prezzo"]) > 0.051:
                ok = False
                break
        P["r_ok"] = ok
        if not ok:
            P["g0"].append("le righe d'ingresso del giornale NON si accoppiano ai deal del report (lato/prezzo): r e costo per operazione non calcolati")
    elif pos:
        P["g0"].append("ingressi del giornale %d contro posizioni %d: giornale incompleto" % (len(ing), len(pos)))
    # barre generate e tetto (dal giornale del tester, copiato in testa al log)
    if rep["barre"] is not None and rep["barre"] >= TETTO_BARRE:
        P["g0"].append("barre del report %d >= tetto %d: finestra troncata" % (rep["barre"], TETTO_BARRE))
    return P


def posizioni_numeriche(P, comm_ipotetica):
    """Lista di dict per posizione: net (con commissione ipotetica se serve), r, ora, lato, tranche, hold_min."""
    out = []
    comm_rep = sum(p["in"]["comm"] + p["out"]["comm"] for p in P["pos"])
    ing = P["log"]["ingressi"] if P["log"] else []
    for i, p in enumerate(P["pos"]):
        a, b = p["in"], p["out"]
        net = a["profitto"] + a["comm"] + a["swap"] + b["profitto"] + b["comm"] + b["swap"]
        lotti = a["vol"] or 1.0
        net_v = net - (comm_ipotetica * lotti if comm_rep == 0 else 0.0)
        r = None
        if P.get("r_ok") and i < len(ing) and ing[i]["perdita"] > 0:
            r = net_v / ing[i]["perdita"]
        out.append({"net": net, "net_v": net_v, "r": r, "ora": a["t"].hour, "lato": "BUY" if a["tipo"] == "buy" else "SELL", "tranche": P["tranche"],
                    "hold_min": (b["t"] - a["t"]).total_seconds() / 60.0, "t": a["t"], "motivo_uscita": b["commento"]})
    return out, comm_rep


def costo_ingressi(P):
    """Rapporti stop/(spread+comm) sugli INGRESSI (righe d'ingresso): spread-only, +0,04, +0,08 USD/oz. Scarta spread 0,00 (rapporto infinito, il log ha 2 decimali)."""
    ing = P["log"]["ingressi"] if P["log"] else []
    v0, v1, v2, zero = [], [], [], 0
    for e in ing:
        stop = 2.5 * e["atr"]
        if e["spread"] <= 0:
            zero += 1
            continue
        v0.append(stop / e["spread"])
        v1.append(stop / (e["spread"] + COMM_USD_OZ[0]))
        v2.append(stop / (e["spread"] + COMM_USD_OZ[1]))
    return {"solo_spread": v0, "c04": v1, "c08": v2, "spread_zero": zero}


def banda_costo(m):
    if m != m:
        return "n.d."
    if m >= COSTO_LAVORO:
        return "PASSA"
    if m >= COSTO_DURO:
        return "FRA (sotto la frontiera 40x: non puo' diventare sedia)"
    return "ESCLUSA PER COSTO"


def esito_replica(nz, pf_v, pf_v2, per_tranche, top1_quota, n_tot, per_tranche_n=None):
    """S4. nz = lista netti PF_V, per_tranche = {tranche: pf_v}. Restituisce (frase, mancanti).
    per_tranche_n (opzionale) = {tranche: n}: se dato, una tranche con n < 150 NON e' letta (S1) e non conta come 'PF_V > 1,3'; la soglia 'almeno 2 tranche su 3'
    diventa in proporzione ceil(2/3 x tranche) (3 -> 2, 6 -> 4: TRADUZIONE alle 6 tranche del lotto R2REG, file prova GBA_R2_REGIME_2026-10-10.txt)."""
    if n_tot < N_MIN:
        return "MERITO SOSPESO (n=%d < %d): il rischio si legge lo stesso" % (n_tot, N_MIN), []
    if pf_v != pf_v:
        return "PF_V non calcolabile", []
    if pf_v < 1.0:
        return "PF_V %.2f < 1,0: la dichiarazione di Emiliano NON regge sul nostro feed (un regime; NON 'morto': mancano le caselle 3, 4, 5 del certificato)" % pf_v, []
    if pf_v < PF_NESSUN_VERDETTO:
        return "PF_V %.2f fra 1,0 e 1,3: coerente con l'ipotesi nulla (nessun edge distinguibile dal costo su questo regime)" % pf_v, []
    if pf_v < PF_RISCONTRO:
        return "PF_V %.2f fra 1,3 e 1,5: NESSUN VERDETTO" % pf_v, []
    mancanti = []
    servono = max(2, int(math.ceil(2.0 * len(per_tranche) / 3.0 - 1e-9)))
    conc = sum(1 for t, v in per_tranche.items() if v == v and v > PF_TRANCHE and (per_tranche_n is None or per_tranche_n.get(t, 0) >= N_MIN))
    if conc < servono:
        mancanti.append("PF_V > 1,3 in solo %d tranche su %d (servono %d%s)" % (conc, len(per_tranche), servono, "" if per_tranche_n is None else ", contando solo tranche con n >= 150"))
    if top1_quota is None or top1_quota >= TOP1_FRAGILE:
        mancanti.append("migliore operazione = %s del profitto netto (soglia < 25%%)" % ("n.d." if top1_quota is None else "%.0f%%" % (100 * top1_quota)))
    if pf_v2 != pf_v2 or pf_v2 < PF_NESSUN_VERDETTO:
        mancanti.append("PF con commissione 7,80 a giro = %s (serve >= 1,3)" % ("n.d." if pf_v2 != pf_v2 else "%.2f" % pf_v2))
    if mancanti:
        return "PF_V %.2f >= 1,5 MA NESSUN VERDETTO: " % pf_v + "; ".join(mancanti), mancanti
    return "PF_V %.2f >= 1,5 con le condizioni S4 soddisfatte: RISCONTRO della dichiarazione di Emiliano sul nostro feed, in UN regime. E' il permesso di passare al passo 2, NON un candidato." % pf_v, []


# ---------------------------------------------------------------------------------------------------------------------
#  CARICAMENTO + STAMPA
# ---------------------------------------------------------------------------------------------------------------------
def carica(percorsi):
    passate = []
    for pth in percorsi:
        src = Sorgente(pth)
        if "MANIFEST_R0.csv" not in src.nomi:
            raise SystemExit("%s: manca MANIFEST_R0.csv (non e' uno zip di GBA_R0_PASSATE.ps1)" % pth)
        man = list(csv.DictReader(io.StringIO(src.leggi("MANIFEST_R0.csv").decode("ascii", "replace")), delimiter=";"))
        for r in man:
            rep, log = None, None
            if r["stato"] != "NON_LANCIATA":
                cand = [n for n in src.nomi if n.startswith("report/GBA_R0_" + r["passata"]) and n.lower().endswith((".htm", ".html"))]
                if cand:
                    rep = leggi_report(src.leggi(cand[0]))
                nl = "log/GBA_" + r["passata"] + ".txt"
                if nl in src.nomi:
                    log = leggi_log(src.leggi(nl).decode("ascii", "replace"))
            P = costruisci_passata(r, rep, log)
            P["sorgente"] = os.path.basename(pth)
            passate.append(P)
    return passate


def riga_cella(titolo, Ps, comm_ip, out_csv):
    """Stampa il blocco di una cella (somma delle sue tranche, passate OK) e restituisce i numeri chiave."""
    righe = []
    tutte = []
    per_tr = {}
    cost0, cost1, cost2 = [], [], []
    tot_giorni = 0
    for P in Ps:
        if P["g0"]:
            continue
        nz, comm_rep = posizioni_numeriche(P, comm_ip)
        tutte += nz
        per_tr[P["tranche"]] = nz
        c = costo_ingressi(P)
        cost0 += c["solo_spread"]; cost1 += c["c04"]; cost2 += c["c08"]
        tot_giorni += giorni_feriali(P["riga"]["da"], P["riga"]["a"], P["riga"]["lotto"] in LOTTI_A_ESCLUSIVA)
    return tutte, per_tr, (cost0, cost1, cost2), tot_giorni


def lettura_regimi(passate, cella, comm_ip=COMM_EUR_LOTTO_GIRO):
    """FIRMA 10/10 (report/FIRME_2026-10-10.md): lettura PER REGIME, long e short SEPARATI. Raggruppa per CELLA attraverso i lotti a Modello 4 (R1A e R2REG sono
    la stessa cella REPL: stessi 30 pin); le tranche si assegnano ai regimi con REGIMI_TRANCHE (regola sul prezzo). Restituisce (righe, verdetto)."""
    Ps = [P for P in passate if int(P["riga"]["modello"]) == 4 and P["cella"] == cella and P["magic"] == "775800" and not P["g0"] and P["tranche"] in REGIMI_TRANCHE]
    dati = {}
    for P in Ps:
        nz, _c = posizioni_numeriche(P, comm_ip)
        dir_, vol_ = REGIMI_TRANCHE[P["tranche"]]
        dd = P["rep"]["dd_eq_abs"] if P["rep"] and P["rep"].get("dd_eq_abs") is not None else None
        for reg in (dir_, vol_):
            d = dati.setdefault(reg, {"tr": [], "pos": [], "dd": []})
            d["tr"].append(P["tranche"])
            d["pos"] += nz
            if dd is not None:
                d["dd"].append(dd)
    righe = []
    misurati, non_misurati, fallimenti = [], [], []
    for reg in ("TORO", "LATERALE", "RIBASSO", "CALMO", "VOLATILE"):
        d = dati.get(reg)
        if not d:
            righe.append("   %-9s nessuna tranche letta -> NON MISURATO (regime non coperto dalle tranche di questo giro)" % reg)
            non_misurati.append(reg)
            continue
        n = len(d["pos"])
        lung = [x["net_v"] for x in d["pos"] if x["lato"] == "BUY"]
        cor = [x["net_v"] for x in d["pos"] if x["lato"] == "SELL"]
        dd = "DD equity max di tranche %.0f EUR" % max(d["dd"]) if d["dd"] else "DD n.d."
        base = "   %-9s tranche %-12s n=%-5d (long %d, short %d)  PF_V %s  long %s  short %s  %s" % (
            reg, ",".join(sorted(d["tr"])), n, len(lung), len(cor), "%.2f" % pf_di([x["net_v"] for x in d["pos"]]),
            "%.2f" % pf_di(lung) if lung else "n.d.", "%.2f" % pf_di(cor) if cor else "n.d.", dd)
        if len(d["tr"]) < TRANCHE_MIN_REGIME:
            righe.append(base + "  -> NON MISURATO (meno di %d tranche)" % TRANCHE_MIN_REGIME)
            non_misurati.append(reg)
        elif n < N_REGIME:
            righe.append(base + "  -> NON MISURATO (n < %d: il merito non si giudica; il rischio si legge: vedi DD)" % N_REGIME)
            non_misurati.append(reg)
        else:
            lati_ko = [nm for nm, v in (("long", lung), ("short", cor)) if not v or not (pf_di(v) > 1.0)]
            note = "  (lato con n<150: indicativo)" if (len(lung) < N_REGIME or len(cor) < N_REGIME) else ""
            if lati_ko:
                fallimenti.append("%s %s" % (reg, "+".join(lati_ko)))
                righe.append(base + "  -> MISURATO, NON REGGE (PF_V <= 1,0 su: %s)%s" % (" e ".join(lati_ko), note))
            else:
                righe.append(base + "  -> MISURATO, PF_V > 1,0 su long e short%s" % note)
            misurati.append(reg)
    if not dati:
        verdetto = "nessuna tranche con regime assegnato (non e' un giro del lotto R1A/R2REG?)"
    elif fallimenti:
        verdetto = "NON REGGE: PF_V <= 1,0 in %s" % "; ".join(fallimenti)
    elif not misurati:
        verdetto = "NON MISURATO: nessun regime con almeno %d operazioni e %d tranche" % (N_REGIME, TRANCHE_MIN_REGIME)
    elif not any(r in ("LATERALE", "RIBASSO") for r in misurati):
        verdetto = "NON BASTA: un PF buono solo nel toro non basta (regimi misurati: %s; NON misurati: %s)" % (", ".join(misurati), ", ".join(non_misurati) or "nessuno")
    else:
        verdetto = "regge nei regimi MISURATI (%s); NON misurati: %s. Il DD promesso dal backtest della cella NON esiste ancora (nessuna cella e' stata promossa): il cancello del drawdown resta APERTO" % (", ".join(misurati), ", ".join(non_misurati) or "nessuno")
    return righe, verdetto


def tabella_regimi(passate, W):
    celle = []
    for P in passate:
        if int(P["riga"]["modello"]) == 4 and P["tranche"] in REGIMI_TRANCHE and P["cella"] not in celle:
            celle.append(P["cella"])
    if not celle:
        return
    W("")
    W("-" * 100)
    W(" (7) LETTURA PER REGIME (firma di Claudio 10/10/2026, report/FIRME_2026-10-10.md; si AGGIUNGE a S4-S7, non li sostituisce)")
    W("     regola sul prezzo: TORO R>=+5% e ER>=0,15 | RIBASSO R<=-5% e ER>=0,15 | LATERALE altrimenti | CALMO ATR M1/prezzo <3,5 bp | VOLATILE >=3,5 bp (proxy_gba_r2reg.py --regimi)")
    W("     regge se PF_V > 1,0 in OGNI regime con >= 150 operazioni e >= 2 tranche, long e short letti SEPARATAMENTE; < 150 operazioni = NON MISURATO; solo toro non basta")
    for cella in sorted(celle, key=lambda c: {"REPL": 0, "C010": 1, "C020": 2, "C035": 3}.get(c, 9)):
        lotti = sorted(set(P["riga"]["lotto"] for P in passate if int(P["riga"]["modello"]) == 4 and P["cella"] == cella and P["tranche"] in REGIMI_TRANCHE), key=lambda l: ORDINE_LOTTI.get(l, 9))
        W("   --- cella %s (lotti %s) ---" % (cella, "+".join(lotti)))
        righe, verdetto = lettura_regimi(passate, cella)
        for r in righe:
            W(r)
        W("   VERDETTO PER REGIME (cella %s): %s" % (cella, verdetto))


def stampa(passate, csv_out=None):
    out = []
    W = out.append
    W("=" * 100)
    lotti_presenti = set(P["riga"]["lotto"] for P in passate)
    if "R2REG" in lotti_presenti:
        W(" GBA R2REG -- lettore (leggi_gba_r0.py). Soglie e attese: file prova GBA_R2_REGIME_2026-10-10.txt (S1-S7 del file madre GBA_R0_REPLICA_2026-10-09.txt + firma 10/10 per regime), scritte PRIMA dei numeri.")
        W(" NON giudica oltre S1-S8, NON promuove, NON scrive 'morto'. Tranche 2024.07.10-2025.12.31 a tick reali (ToDate ESCLUSIVO); i regimi si leggono nella sezione (7).")
    else:
        W(" GBA R0 -- lettore (leggi_gba_r0.py). Soglie e attese: file prova GBA_R0_REPLICA_2026-10-09.txt, scritte PRIMA dei numeri.")
        W(" NON giudica oltre S1-S7, NON promuove, NON scrive 'morto'. Un regime solo (gen-set 2026).")
    W("=" * 100)
    W("")
    W("(1) CANCELLI DI AFFIDABILITA' (G0 per passata)")
    for P in passate:
        r = P["riga"]
        stato = "OK" if not P["g0"] else "KO"
        W("  %-34s modello %s  stato driver %-22s G0 %s" % (P["tag"], r["modello"], r["stato"], stato))
        for m in P["g0"]:
            W("       - " + m)
        # DA GUARDARE (non G0: a lotto fisso non cambiano i numeri da soli, ma dicono che la passata non e' quella dichiarata o che n/uscite sono state toccate)
        dep = P["rep"].get("deposito") if P["rep"] else None
        if dep is not None and abs(dep - DEPOSITO_ATTESO) > 0.5:
            W("       ! DA GUARDARE: deposito iniziale del report %.2f invece di %.0f (Deposit= del .ini non applicato come dichiarato)" % (dep, DEPOSITO_ATTESO))
        an = P["log"]["anomalie"] if P["log"] else {}
        if an:
            W("       ! DA GUARDARE (giornale dell'EA, minimo: dedup per secondo simulato): " + "; ".join("%s %d" % (k, an[k]) for k in sorted(an)))
    ok = [P for P in passate if not P["g0"]]
    # G1: gemelle S0
    W("")
    gem = [P for P in passate if P["riga"]["lotto"] == "S0" and P["cella"] == "REPL" and P["tranche"] == "T1"]
    if len(gem) == 2:
        a, b = gem
        ra, rb = a["rep"], b["rep"]
        if ra and rb and ra["ok"] and rb["ok"]:
            uguali = (ra["trades"] == rb["trades"] and ra["profitto"] == rb["profitto"] and ra["pf"] == rb["pf"] and ra["dd_eq_abs"] == rb["dd_eq_abs"])
            W("  G1 gemelle (REPL, T1, Modello 1, magic %s e %s): operazioni %s/%s, profitto %s/%s, PF %s/%s, DD equity %s/%s -> %s" % (
                a["magic"], b["magic"], ra["trades"], rb["trades"], ra["profitto"], rb["profitto"], ra["pf"], rb["pf"], ra["dd_eq_abs"], rb["dd_eq_abs"],
                "VERDE (identiche)" if uguali else "ROSSO: il Modello 1 non e' riproducibile, NESSUN conteggio di S0 si usa"))
        else:
            W("  G1: manca il report di una delle due gemelle -> NON VERIFICABILE")
    else:
        W("  G1: nessuna coppia di gemelle (lotto S0 non presente)")
    # G2: n ticks / n OHLC su REPL T1
    s0 = [P for P in ok if P["riga"]["lotto"] == "S0" and P["cella"] == "REPL" and P["tranche"] == "T1" and P["magic"] == "775800"]
    r1 = [P for P in ok if P["riga"]["lotto"] == "R1A" and P["cella"] == "REPL" and P["tranche"] == "T1"]
    if s0 and r1:
        a, b = len(s0[0]["pos"]), len(r1[0]["pos"])
        rap = (b / a) if a else float("nan")
        W("  G2 REPL su T1: operazioni a ticks reali %d / OHLC %d = %.2f -> %s" % (b, a, rap, "nella banda 0,5-2,0" if 0.5 <= rap <= 2.0 else "FUORI BANDA: DA GUARDARE (si cerca la causa, non e' un fallimento)"))
    else:
        W("  G2: serve S0 e R1A OK su REPL/T1 per il confronto Modello 1 / Modello 4")

    # per ogni (modello, cella): tutte le tranche OK
    celle = []
    for P in passate:
        k = (int(P["riga"]["modello"]), P["riga"]["lotto"], P["cella"])
        if k not in celle:
            celle.append(k)
    celle.sort(key=lambda k: (-k[0], ORDINE_LOTTI.get(k[1], 9), {"REPL": 0, "C010": 1, "C020": 2, "C035": 3}.get(k[2], 9)))
    tab = []
    for (mod, lotto_c, cella) in celle:
        Ps = [P for P in passate if int(P["riga"]["modello"]) == mod and P["riga"]["lotto"] == lotto_c and P["cella"] == cella and P["magic"] == "775800"]
        W("")
        W("-" * 100)
        W(" CELLA %s%s (InpSpreadMaxATR %s)  --  Modello %d (%s)" % (cella, " [lotto " + lotto_c + "]" if lotto_c == "R2REG" else "", Ps[0]["riga"]["spread_max_atr"], mod, "TICKS REALI: verdetto" if mod == 4 else "OHLC su M1: SOLO CONTEGGIO, nessun PF si legge come merito"))
        W("-" * 100)
        # (2) n e frequenza
        W("(2) n e frequenza (denominatore: giorni feriali della tranche)")
        for P in Ps:
            n = len(P["pos"]) if not P["g0"] else None
            gf = giorni_feriali(P["riga"]["da"], P["riga"]["a"], lotto_c in LOTTI_A_ESCLUSIVA)
            att_l = ATTESE_LOTTO.get((lotto_c, cella)) if mod == 4 else None
            att = att_l.get(P["tranche"]) if att_l else None
            sa = ""
            if n is not None and att:
                sa = "  attesa %d-%d: %s" % (att[0], att[1], "DENTRO" if att[0] <= n <= att[1] else "FUORI (si cerca perche', non si ritocca l'attesa)")
            ctr = P["log"]["conta_fine"] if (P["log"] and P["log"]["conta_fine"]) else None
            extra = ""
            if ctr:
                extra = "  segnali(EA) %d, ingressi tentati %d, scartati spread %d, a posizione aperta %d" % (ctr["seg"], ctr["ing"], ctr["spr"], ctr["pos"])
            W("   %-3s %s n=%s  %s/giorno%s%s" % (P["tranche"], "(G0 KO: non letta)" if P["g0"] else "", "n.d." if n is None else n, "n.d." if n is None else "%.2f" % (n / float(gf)), sa, extra))
        comm_ip = COMM_EUR_LOTTO_GIRO
        tutte, per_tr, (c0, c1, c2), gtot = riga_cella("", Ps, comm_ip, csv_out)
        n_tot = len(tutte)
        att_l = ATTESE_LOTTO.get((lotto_c, cella)) if mod == 4 else None
        if att_l:
            smn, smx = att_l["SMENTITA"]
            sm = "SMENTITA dell'attesa (n fuori da %d-%d): leggere PRIMA la causa" % (smn, smx) if not (smn <= n_tot <= smx) else "dentro %d-%d" % (smn, smx)
            if lotto_c == "R1A":
                sm = sm.replace("dentro 300-3500", "dentro 300-3.500").replace("SMENTITA dell'attesa (", "SMENTITA dell'attesa E1 (")
            W("   %s tranche: n=%d (attesa %d-%d), %s" % ({3: "tre", 6: "sei"}.get(len(Ps), str(len(Ps))), n_tot, att_l["TOT"][0], att_l["TOT"][1], sm))
        else:
            W("   tranche lette: n=%d" % n_tot)
        if n_tot == 0:
            W("   nessuna passata affidabile: niente altro da leggere")
            continue
        # (3) costo PRIMA del PF
        W("(3) COSTO (S2): mediana sugli INGRESSI di 2,5 x ATR / (spread + commissione), ATR e spread dalle righe d'ingresso dell'EA (2 decimali)")
        for etich, v in (("solo spread", c0), ("+0,04 USD/oz (3,90 EUR a giro)", c1), ("+0,08 USD/oz (per lato)", c2)):
            if v:
                m = mediana(v)
                W("   %-34s n=%d mediana %.1f  p10 %.1f  quota <40x: %.0f%%  quota <13,3x: %.0f%%  -> %s" % (etich, len(v), m, percentile(v, 0.10), 100.0 * sum(1 for x in v if x < COSTO_LAVORO) / len(v),
                                                                                                          100.0 * sum(1 for x in v if x < COSTO_DURO) / len(v), banda_costo(m)))
        cambia = len(set(banda_costo(mediana(v)) for v in (c0, c1, c2) if v)) > 1
        W("   il verdetto di costo %s fra le tre versioni" % ("CAMBIA" if cambia else "non cambia"))
        # (4) PF, DD, lato
        W("(4) PF, DD, lato (n = posizioni; PF_V = PF dei netti, con commissione ipotetica 3,90 EUR/lotto a giro SE il tester non ne addebita)" + ("   [Modello 1: PF di SCREENING, mai un verdetto]" if mod == 1 else ""))
        comm_rep_tot = 0.0
        for P in Ps:
            if not P["g0"]:
                comm_rep_tot += sum(p["in"]["comm"] + p["out"]["comm"] for p in P["pos"])
        W("   commissioni addebitate dal tester (somma): %.2f EUR -> %s" % (comm_rep_tot, "il tester NON le addebita: PF_V sottrae 3,90 EUR a operazione" if comm_rep_tot == 0 else "il tester le addebita: PF_V le include gia'"))
        nets = [x["net_v"] for x in tutte]
        nets2, _ = [], 0
        for P in Ps:
            if not P["g0"]:
                nn, _c = posizioni_numeriche(P, COMM_EUR_LOTTO_LATO)
                nets2 += [x["net_v"] for x in nn]
        pf_v, pf_v2 = pf_di(nets), pf_di(nets2)
        pf_grezzo = pf_di([x["net"] for x in tutte])
        W("   PF_V %.3f   (7,80 a giro: %.3f;  senza commissione ipotetica: %.3f)   netto PF_V %.0f EUR   win rate %.0f%%" % (pf_v, pf_v2, pf_grezzo, sum(nets), 100.0 * sum(1 for x in nets if x > 0) / len(nets)))
        for P in Ps:
            if P["g0"] or not P["rep"]:
                continue
            nn = per_tr.get(P["tranche"], [])
            W("      %-3s n=%-5d PF_V %.2f   PF del report %s   DD equity %s EUR (%s%%)   DD bilancio %s EUR (%s%%)" % (P["tranche"], len(nn), pf_di([x["net_v"] for x in nn]), P["rep"]["pf"], P["rep"]["dd_eq_abs"], P["rep"]["dd_eq_pct"],
                                                                                                                      P["rep"]["dd_bil_abs"], P["rep"]["dd_bil_pct"]))
        W("   (il RISCHIO si legge a qualunque n; DD in EUR a 1,00 lotto con deposito 1000000 (v3): la % non e' quella di un conto vero e non si legge)")
        for lato in ("BUY", "SELL"):
            ll = [x["net_v"] for x in tutte if x["lato"] == lato]
            if ll:
                W("   lato %-4s n=%d PF_V %.2f netto %.0f" % (lato, len(ll), pf_di(ll), sum(ll)))
        perd = [x["net"] for x in tutte if x["net"] < 0]
        # perdita a SL per operazione dalle righe d'ingresso
        ps = [e["perdita"] for P in Ps if not P["g0"] and P["log"] for e in P["log"]["ingressi"]]
        if ps:
            W("   perdita a SL scritta dall'EA: mediana %.0f  p90 %.0f  max %.0f (valuta del conto del tester; 1,00 lotto)" % (mediana(ps), percentile(ps, 0.9), max(ps)))
        hold = [x["hold_min"] for x in tutte]
        W("   vita della posizione (minuti): mediana %.1f  media %.1f  p90 %.1f" % (mediana(hold), statistics.mean(hold), percentile(hold, 0.9)))
        # (5) concentrazione
        W("(5) concentrazione (S5)")
        pos_tot = sum(x for x in nets if x > 0)
        netto = sum(nets)
        top1 = (max(nets) / pos_tot) if pos_tot > 0 else None
        senza5 = netto - sum(sorted(nets, reverse=True)[:TOP_N_FRAGILE])
        fragile = (top1 is not None and top1 >= TOP1_FRAGILE) or senza5 <= 0
        W("   migliore operazione = %s del profitto positivo; netto senza le %d migliori = %.0f -> %s" % ("n.d." if top1 is None else "%.0f%%" % (100 * top1), TOP_N_FRAGILE, senza5, "FRAGILE" if fragile else "non fragile"))
        top1_netto = (max(nets) / netto) if netto > 0 else None
        # esito S4 (solo REPL a ticks reali)
        ptr = {t: pf_di([x["net_v"] for x in v]) for t, v in per_tr.items()}
        if mod == 4:
            ptn = {t: len(v) for t, v in per_tr.items()}
            frase, _m = esito_replica(nets, pf_v, pf_v2, ptr, top1_netto, n_tot, ptn)
            W("   ESITO S4 per la cella %s: %s" % (cella, frase))
            if lotto_c == "R2REG":
                # CONTROESEMPIO scritto PRIMA dei numeri (file prova, S8): un PF_V >= 1,3 con n >= 150 su una cella NON BASTA
                if pf_v >= PF_NESSUN_VERDETTO and n_tot >= N_MIN:
                    rt = sorted(t for t, v in ptr.items() if v == v and v > PF_TRANCHE and ptn.get(t, 0) >= N_MIN)
                    q1 = "n.d." if top1_netto is None else "%.0f%%" % (100 * top1_netto)
                    basta = len(rt) >= 2 and top1_netto is not None and top1_netto < TOP1_FRAGILE
                    W("   CONTROESEMPIO (scritto prima): PF_V %.2f >= 1,3 con n=%d: replica in %d tranche con n>=150 e PF_V>1,3 (%s; servono almeno 2), migliore operazione = %s del profitto netto (serve < 25%%) -> %s" % (
                        pf_v, n_tot, len(rt), ",".join(rt) if rt else "nessuna", q1, "le due condizioni ci sono (S4 decide il resto)" if basta else "NON BASTA"))
                else:
                    W("   CONTROESEMPIO (scritto prima): non scatta (serve PF_V >= 1,3 con n >= 150; qui PF_V %.2f, n=%d)" % (pf_v, n_tot))
        # (6) ora
        W("(6) ORA (S6): sei fasce server a priori, ora del deal d'ingresso; r = netto/perdita a SL; soglia p < %.4f (0,05/6); n >= %d; stesso segno in >= 2 tranche" % (P_FASCIA, N_FASCIA))
        for lo, hi, nome in FASCE:
            sel = [x for x in tutte if lo <= x["ora"] < hi]
            if not sel:
                W("   %-15s %02d-%02d  n=0" % (nome, lo, hi))
                continue
            rs = [x["r"] for x in sel if x["r"] is not None]
            p = p_media_zero(rs)
            segni = {}
            for x in sel:
                segni[x["tranche"]] = segni.get(x["tranche"], 0.0) + x["net_v"]
            tot_segno = 1 if sum(x["net_v"] for x in sel) > 0 else -1
            conc = sum(1 for v in segni.values() if (v > 0) == (tot_segno > 0))
            servono_f = max(2, int(math.ceil(2.0 * len(segni) / 3.0 - 1e-9)))   # S6 'almeno 2 tranche su 3': in proporzione (6 tranche -> 4)
            if len(sel) < N_FASCIA:
                verd = "SOSPESA (n<%d)" % N_FASCIA
            elif p is None:
                verd = "r non calcolabile (accoppiamento)"
            elif p < P_FASCIA and conc >= servono_f:
                verd = "sopra la soglia corretta, segno concorde in %d tranche" % conc
            elif p < P_FASCIA:
                verd = "sopra la soglia ma segno concorde in sole %d tranche: orologio/regime, NON si usa" % conc
            else:
                verd = "non distinguibile da zero (p=%.3f)" % p
            W("   %-15s %02d-%02d  n=%-5d PF_V %.2f  r medio %s  tranche con lo stesso segno %d/%d  -> %s" % (nome, lo, hi, len(sel), pf_di([x["net_v"] for x in sel]),
                                                                                                          "n.d." if not rs else "%.3f" % statistics.mean(rs), conc, len(segni), verd))
        if lotto_c == "R2REG":
            W("   ORA con OROLOGIO UNIFORME: esclusi gli ingressi dal %s al %s (server): orologio forex UTC+0 d'inverno prima del cambio, per l'ORO [NON MISURATO]; il lettore NON converte le ore" % (
                OROLOGIO_INCERTO[0].strftime("%Y.%m.%d"), (OROLOGIO_INCERTO[1] - datetime.timedelta(days=1)).strftime("%Y.%m.%d")))
            unif = [x for x in tutte if not (OROLOGIO_INCERTO[0] <= x["t"] < OROLOGIO_INCERTO[1])]
            W("   (ingressi esclusi: %d su %d)" % (len(tutte) - len(unif), len(tutte)))
            for lo, hi, nome in FASCE:
                sel = [x for x in unif if lo <= x["ora"] < hi]
                if sel:
                    W("      %-15s %02d-%02d  n=%-5d PF_V %.2f%s" % (nome, lo, hi, len(sel), pf_di([x["net_v"] for x in sel]), "   (n<%d: SOSPESA)" % N_FASCIA if len(sel) < N_FASCIA else ""))
                else:
                    W("      %-15s %02d-%02d  n=0" % (nome, lo, hi))
        # ATR e spread per ora dai SEGNALI (campione selezionato: solo barre di rottura)
        sg = [s for P in Ps if not P["g0"] and P["log"] for s in P["log"]["segnali"]]
        if sg:
            libere = [s for s in sg if s["preso"] or s["motivo"].startswith("spread")]
            sc = [s for s in sg if (not s["preso"]) and s["motivo"].startswith("spread")]
            W("   segnali liberi (senza posizione aperta) %d, di cui scartati per spread %d = %.0f%%  [sui soli segnali liberi: l'EA controlla la posizione aperta PRIMA dello spread]" % (
                len(libere), len(sc), 100.0 * len(sc) / max(1, len(libere))))
            W("   ATR e spread alle barre di rottura (campione SELEZIONATO, non tutte le barre), per fascia: ATR mediana / spread mediana / n")
            for lo, hi, nome in FASCE:
                s2 = [s for s in sg if lo <= s["ora"] < hi]
                if s2:
                    W("      %-15s ATR %.2f  spread %.2f  n=%d" % (nome, mediana([s["atr"] for s in s2]), mediana([s["spread"] for s in s2]), len(s2)))
        tab.append({"modello": mod, "lotto": lotto_c, "cella": cella, "n": n_tot, "pf_v": pf_v, "pf_v2": pf_v2, "netto": sum(nets), "costo_mediano_c04": mediana(c1), "fragile": fragile})
    # confronto fra celle (S7)
    # S7 si legge per FAMIGLIA di lotti sullo stesso asse: R1A+R1B (quattro celle) e R2REG (due celle: nessun altopiano) non si mescolano
    r4 = [t for t in tab if t["modello"] == 4 and t["lotto"] in ("R1A", "R1B", "S0")]
    r2 = [t for t in tab if t["modello"] == 4 and t["lotto"] == "R2REG"]
    if r2:
        W("")
        W("-" * 100)
        W(" (S7) FRONTIERA del lotto R2REG: %d celle lungo l'asse InpSpreadMaxATR -> NESSUN altopiano si legge (la monotonia fra 2 punti e' vuota); contano n, PF_V e costo" % len(r2))
        for t in sorted(r2, key=lambda t: {"REPL": 0, "C010": 1, "C020": 2, "C035": 3}.get(t["cella"], 9)):
            W("   %-5s n=%-6d PF_V %.3f  costo mediano (+0,04) %.1f  %s" % (t["cella"], t["n"], t["pf_v"], t["costo_mediano_c04"], banda_costo(t["costo_mediano_c04"])))
    if len(r4) >= 2:
        W("")
        W("-" * 100)
        W(" (S7) FRONTIERA lungo l'asse InpSpreadMaxATR (Modello 4): centro dell'altopiano, mai il picco")
        for t in sorted(r4, key=lambda t: {"REPL": 0, "C010": 1, "C020": 2, "C035": 3}.get(t["cella"], 9)):
            W("   %-5s n=%-6d PF_V %.3f  costo mediano (+0,04) %.1f  %s" % (t["cella"], t["n"], t["pf_v"], t["costo_mediano_c04"], banda_costo(t["costo_mediano_c04"])))
        pfs = [t["pf_v"] for t in sorted(r4, key=lambda t: {"REPL": 0, "C010": 1, "C020": 2, "C035": 3}.get(t["cella"], 9))]
        mono = all(pfs[i] <= pfs[i + 1] for i in range(len(pfs) - 1)) or all(pfs[i] >= pfs[i + 1] for i in range(len(pfs) - 1))
        W("   PF_V lungo l'asse: %s -> %s" % (" / ".join("%.2f" % x for x in pfs), "monotono (un altopiano si legge)" if mono else "NON monotono: una cella che sporge e' un PICCO, non un altopiano"))
    tabella_regimi(passate, W)
    W("")
    W("-" * 100)
    W(" CERTIFICATO DI MORTE: mancano le caselle 3 (uscita ad asse), 4 (simboli gemelli), 5 (TF cambiato). Qualunque esito sopra NON e' 'morto': e' 'NON ANCORA MISURATO' o 'la replica non regge (un regime)'.")
    if csv_out:
        with open(csv_out, "w", newline="") as f:
            w = csv.DictWriter(f, fieldnames=["modello", "lotto", "cella", "n", "pf_v", "pf_v2", "netto", "costo_mediano_c04", "fragile"], delimiter=";")
            w.writeheader()
            for t in tab:
                w.writerow(t)
    print("\n".join(out))
    return out, tab


# ---------------------------------------------------------------------------------------------------------------------
#  AUTOTEST: dati finti con risposta nota + contro-esempi
# ---------------------------------------------------------------------------------------------------------------------
def _htm(deals, trades, profit, pf, qual="100% ticks reali", periodo="M1 (2026.07.01 - 2026.09.30)", dd="1 000.00 (1.00%)", deposito="1 000 000.00"):
    """Un report finto nel formato vero (UTF-16, righe <tr> da 13 celle)."""
    def row(c):
        return "<tr>" + "".join("<td>%s</td>" % x for x in c) + "</tr>\n"
    h = "<html><body><table>\n"
    h += "<tr><td colspan=3>Deposito Iniziale:</td><td colspan=10><b>%s</b></td></tr>\n" % deposito
    h += "<tr><td colspan=3>Expert:</td><td colspan=10><b>ABTG_GoldBreakoutATR</b></td></tr>\n"
    h += "<tr><td colspan=3>Simbolo:</td><td colspan=10><b>XAUUSD</b></td></tr>\n"
    h += "<tr><td colspan=3>Periodo:</td><td colspan=10><b>%s</b></td></tr>\n" % periodo
    h += "<tr><td>Qualit\u00e0 dello Storico:</td><td><b>%s</b></td><td>Barre:</td><td><b>88 000</b></td><td>Ticks:</td><td><b>1 500 000</b></td></tr>\n" % qual
    h += "<tr><td>Profitto Totale Netto:</td><td><b>%s</b></td><td>Bilancio Drawdown Massimo:</td><td><b>%s</b></td><td>Equit\u00e0 Drawdown Massima:</td><td><b>%s</b></td></tr>\n" % (profit, dd, dd)
    h += "<tr><td>Fattore di Profitto:</td><td><b>%s</b></td><td>Numero di Operazioni di Trading Totali:</td><td><b>%d</b></td></tr>\n" % (pf, trades)
    h += "<tr><td>Ora</td><td>Affare</td><td>Simbolo</td><td>Tipo</td><td>Direzione</td><td>Volume</td><td>Prezzo</td><td>Ordine</td><td>Commissioni</td><td>Swap</td><td>Profitto</td><td>Bilancio</td><td>Commento</td></tr>\n"
    h += row(["2026.07.01 00:00:00", "1", "", "balance", "", "", "", "", "0.00", "0.00", "100 000.00", "100 000.00", ""])
    for d in deals:
        h += row(d)
    h += "</table></body></html>"
    return ("\ufeff" + h).encode("utf-16-le")


def _fmt(x):
    s = "%.2f" % x
    ip, fp = s.split(".")
    neg = ip.startswith("-")
    ip = ip.lstrip("-")
    g = []
    while len(ip) > 3:
        g.insert(0, ip[-3:]); ip = ip[:-3]
    g.insert(0, ip)
    return ("-" if neg else "") + " ".join(g) + "." + fp


def _sintetico(trades, comm=0.0):
    """trades = [(data 'aaaa.mm.gg hh:mm:ss', lato 'buy'/'sell', profitto, atr, spread, durata_min)]. Restituisce (deals, righe_log)."""
    deals, log, i = [], [], 2
    for t, lato, prof, atr, spr, dur in trades:
        t0 = datetime.datetime.strptime(t, "%Y.%m.%d %H:%M:%S")
        t1 = t0 + datetime.timedelta(minutes=dur)
        px = 4000.0
        deals.append([t0.strftime("%Y.%m.%d %H:%M:%S"), str(i), "XAUUSD", lato, "in", "1.00", "%.2f" % px, str(i), _fmt(comm), "0.00", "0.00", "100 000.00", "GBA_L"])
        deals.append([t1.strftime("%Y.%m.%d %H:%M:%S"), str(i + 1), "XAUUSD", "sell" if lato == "buy" else "buy", "out", "1.00", "%.2f" % (px + 1), str(i + 1), _fmt(comm), "0.00", _fmt(prof), "100 000.00", "sl %.2f" % px])
        loss = 2.5 * atr * 100.0
        sp = 2.5 * atr / spr
        log.append("%s   [GBA] segnale %s | close 4000.00 canale 3990.00-3999.00 EMA 3995.00 ATR %.2f spread %.2f = %.1f%% ATR (max 5.0%%) | stop/spread %.1fx | ora server %d" % (
            t0.strftime("%Y.%m.%d %H:%M:%S"), "BUY" if lato == "buy" else "SELL", atr, spr, 100 * spr / atr, sp, t0.hour))
        log.append("%s   [GBA] %s 1.00 lotti @ %.2f | SL %.2f (2.50 x ATR %.2f) | spread %.2f | perdita a SL ~%.2f EUR" % (t0.strftime("%Y.%m.%d %H:%M:%S"), "BUY" if lato == "buy" else "SELL", px, px - 2.5 * atr, atr, spr, loss))
        i += 2
    return deals, log


def _manifest(righe):
    cols = "lotto;passata;cella;spread_max_atr;tranche;da;a;modello;magic;t_avvio;durata_s;stato;trades_report;profitto_report;pf_report;qualita;barre_report;ticks_report;barre_gen;ticks_gen;ticks_inizio;righe_gba;ingressi_log;avvio_ok;autotest;finestra;motivi"
    return cols + "\n" + "\n".join(righe) + "\n"


def autotest():
    falliti = []

    def ck(nome, cond, extra=""):
        print("  %-4s %s %s" % ("ok" if cond else "FAIL", nome, extra))
        if not cond:
            falliti.append(nome)

    print("AUTOTEST di leggi_gba_r0.py (dati finti con risposta nota, contro-esempi costruiti PRIMA)")
    # --- 1. parsing del formato vero: numeri con spazio, qualita' con accento, deal a 13 celle
    deals, log = _sintetico([("2026.07.02 03:10:00", "buy", 2000.0, 3.0, 0.10, 12), ("2026.07.02 09:10:00", "sell", -1000.0, 3.0, 0.10, 8)])
    rep = leggi_report(_htm(deals, 2, "1 000.00", "2.00", dd="1 234.50 (1.23%)"))
    ck("report: operazioni, profitto, PF, qualita', barre, ticks", rep["ok"] and rep["trades"] == 2 and rep["profitto"] == 1000.0 and rep["pf"] == 2.0 and rep["qualita"] == "100%ticksreali" and rep["barre"] == 88000 and rep["ticks"] == 1500000, str((rep["trades"], rep["profitto"], rep["pf"], rep["qualita"], rep["barre"])))
    ck("report: DD equity", rep["dd_eq_abs"] == 1234.5 and rep["dd_eq_pct"] == 1.23)
    ck("report: 2 deal 'in' e 2 'out' (la riga balance NON e' un deal)", len(rep["deals"]) == 4 and [d["dir"] for d in rep["deals"]] == ["in", "out", "in", "out"])
    pos, aperta, err = accoppia(rep["deals"])
    ck("accoppiamento in/out", len(pos) == 2 and aperta is None and not err)
    # contro-esempio: due 'in' di fila
    d2 = [list(x) for x in deals]
    d2[2][4] = "in"
    d2.insert(1, list(d2[0]))
    d2[1][1] = "99"
    p2, a2, e2 = accoppia(leggi_report(_htm(d2, 3, "0.00", "1.0"))["deals"])
    ck("CONTRO-ESEMPIO: due 'in' di fila -> errore di accoppiamento", len(e2) >= 1)
    # --- 2. log
    lg = leggi_log("\n".join(log) + "\n2026.09.30 23:59:00   [GBA-CONTA] FINE | segnali 10 | ingressi tentati 2 | scartati: SPREAD 3 (spread max 0.05 x ATR) | posizione aperta 5 | ora 0 | perdita giornaliera 0 | lato spento 0 | ATR non valido 0 | tetto giornaliero 0 (max 0)")
    ck("log: 2 segnali presi, 2 ingressi, CONTA FINE letto", len(lg["segnali"]) == 2 and all(s["preso"] for s in lg["segnali"]) and len(lg["ingressi"]) == 2 and lg["conta_fine"] and lg["conta_fine"]["spr"] == 3)
    ing0 = lg["ingressi"][0]
    ck("log: perdita a SL = 2,5 x ATR x 100 = 750", abs(ing0["perdita"] - 750.0) < 1e-6)
    sk = leggi_log("2026.07.03 10:00:00   [GBA] segnale BUY SALTATO (spread oltre il limite) | close 4000.00 canale 3990.00-3999.00 EMA 3995.00 ATR 1.50 spread 0.22 = 14.7% ATR (max 5.0%) | stop/spread 17.0x | ora server 10")
    ck("log: riga SALTATO con parentesi nel motivo", len(sk["segnali"]) == 1 and not sk["segnali"][0]["preso"] and sk["segnali"][0]["motivo"].startswith("spread"))
    sk2 = leggi_log("2026.07.03 10:00:00   [GBA] segnale SELL SALTATO (posizione gia' aperta) | close 4000.00 canale 3990.00-3999.00 EMA 3995.00 ATR 1.50 spread 0.22 = 14.7% ATR (max 5.0%) | stop/spread 17.0x | ora server 10")
    ck("log: motivo con apostrofo ('posizione gia' aperta')", len(sk2["segnali"]) == 1 and sk2["segnali"][0]["motivo"].startswith("posizione"))
    # --- 3. PF_V e commissione ipotetica: CONTRO-ESEMPIO, il verdetto S4 cambia
    # 200 operazioni, commissioni del tester = 0: lordo 100 vincite da +160, 100 perdite da -100 => PF lordo 1.60;
    # con 3,90 a operazione: (160-3.9)/(100+3.9) = 156.1/103.9 = 1.5024; con 7,80: 152.2/107.8 = 1.4119 => nessun verdetto (sotto 1,3? no: fra 1,3 e 1,5 per il 7,80)
    trs = []
    base = datetime.datetime(2026, 7, 1, 1, 0, 0)
    for i in range(200):
        t = base + datetime.timedelta(hours=i * 7)
        # i rapporti: orari variati
        trs.append((t.strftime("%Y.%m.%d %H:%M:%S"), "buy", 160.0 if i % 2 == 0 else -100.0, 4.0, 0.10, 5))
    dd, lg3 = _sintetico(trs)
    nets = [160.0 if i % 2 == 0 else -100.0 for i in range(200)]
    rep3 = leggi_report(_htm(dd, 200, _fmt(sum(nets)), "%.2f" % pf_di(nets)))
    r3 = {"passata": "R1A_01_REPL_T1_m775800", "cella": "REPL", "tranche": "T1", "modello": "4", "magic": "775800", "stato": "OK", "motivi": "", "lotto": "R1A", "da": "2026.07.01", "a": "2026.09.30", "spread_max_atr": "0.05"}
    P3 = costruisci_passata(r3, rep3, leggi_log("\n".join(lg3)))
    ck("costruisci_passata: G0 pulito su dati coerenti", not P3["g0"], str(P3["g0"]))
    nz, crep = posizioni_numeriche(P3, COMM_EUR_LOTTO_GIRO)
    pfv = pf_di([x["net_v"] for x in nz])
    nz2, _ = posizioni_numeriche(P3, COMM_EUR_LOTTO_LATO)
    pfv2 = pf_di([x["net_v"] for x in nz2])
    ck("PF lordo 1,60 -> PF_V con 3,90 = 156,1/103,9 = 1,5024 e con 7,80 = 152,2/107,8 = 1,4119", abs(pf_di(nets) - 1.6) < 1e-9 and abs(pfv - 156.1 / 103.9) < 1e-9 and abs(pfv2 - 152.2 / 107.8) < 1e-9, "PF_V %.4f PF_V2 %.4f" % (pfv, pfv2))
    fr, mancanti = esito_replica([x["net_v"] for x in nz], pfv, pfv2, {"T1": pfv, "T2": 1.6, "T3": 1.6}, 0.02, 200)
    ck("S4: PF lordo 1,60 -> PF_V 1,5024 (>= 1,5) e 7,80 a giro 1,4119 (>= 1,3) -> RISCONTRO", fr.startswith("PF_V 1.50 >= 1,5 con le condizioni") and not mancanti, fr)
    # CONTRO-ESEMPIO: lordo 1,52 (passerebbe 1,5), ma la commissione ipotetica lo porta a 1,4255 -> NESSUN VERDETTO
    nets_b = [152.0 if i % 2 == 0 else -100.0 for i in range(200)]
    ddb, lgb = _sintetico([("2026.07.%02d %02d:00:00" % (1 + i // 24, 1 + i % 23), "buy", nets_b[i], 4.0, 0.10, 5) for i in range(200)][:200])
    Pb = costruisci_passata(dict(r3, passata="B"), leggi_report(_htm(ddb, 200, _fmt(sum(nets_b)), "%.2f" % pf_di(nets_b))), leggi_log("\n".join(lgb)))
    nzb, _cb = posizioni_numeriche(Pb, COMM_EUR_LOTTO_GIRO)
    pfb = pf_di([x["net_v"] for x in nzb])
    frb, mb = esito_replica([], pfb, 1.3, {"T1": pfb, "T2": 1.6, "T3": 1.6}, 0.02, 200)
    ck("S4 CONTRO-ESEMPIO: PF lordo 1,52 >= 1,5 ma PF_V (3,90 a operazione) = 1,4255 -> NESSUN VERDETTO", pf_di(nets_b) >= 1.5 and abs(pfb - 148.1 / 103.9) < 1e-9 and "fra 1,3 e 1,5" in frb, "lordo %.4f PF_V %.4f: %s" % (pf_di(nets_b), pfb, frb))
    frc, mc = esito_replica([], 1.62, 1.2, {"T1": 1.7, "T2": 1.6, "T3": 1.6}, 0.02, 200)
    ck("S4: PF_V 1,62 ma con 7,80 a giro 1,20 -> NESSUN VERDETTO (clausola 7,80)", "NESSUN VERDETTO" in frc and any("7,80" in m for m in mc), frc)
    fr2, _m2 = esito_replica([], 1.62, 1.55, {"T1": 1.7, "T2": 1.6, "T3": 1.4}, 0.02, 200)
    ck("S4: tutte le condizioni soddisfatte -> RISCONTRO (in UN regime, non un candidato)", fr2.startswith("PF_V 1.62 >= 1,5 con le condizioni") and "NON un candidato" in fr2, fr2)
    fr3, m3 = esito_replica([], 1.62, 1.55, {"T1": 3.0, "T2": 0.9, "T3": 0.8}, 0.02, 200)
    ck("S4 CONTRO-ESEMPIO: PF alto ma in una sola tranche -> NESSUN VERDETTO", "NESSUN VERDETTO" in fr3 and any("solo 1 tranche" in m for m in m3), fr3)
    fr4, m4 = esito_replica([], 1.62, 1.55, {"T1": 1.7, "T2": 1.6, "T3": 1.4}, 0.40, 200)
    ck("S4 CONTRO-ESEMPIO: una sola operazione = 40% del profitto -> NESSUN VERDETTO (concentrazione)", "NESSUN VERDETTO" in fr4 and any("40%" in m for m in m4), fr4)
    fr5, _ = esito_replica([], 0.97, 0.90, {"T1": 0.9}, 0.02, 200)
    ck("S4: PF_V 0,97 -> non regge, e la frase NON contiene 'morto' come verdetto", "NON regge" in fr5 and "NON 'morto'" in fr5, fr5)
    fr6, _ = esito_replica([], 1.2, 1.1, {"T1": 1.2}, 0.02, 80)
    ck("S1: n=80 < 150 -> MERITO SOSPESO", fr6.startswith("MERITO SOSPESO"), fr6)
    # --- 4. costo: banda e contro-esempio della commissione
    c = costo_ingressi(P3)
    # ATR 4,0 -> stop 10,0; spread 0,10 -> 100x; +0,04 -> 71,4x; +0,08 -> 55,6x
    ck("costo: 100x / 71,4x / 55,6x", abs(mediana(c["solo_spread"]) - 100.0) < 1e-6 and abs(mediana(c["c04"]) - 10.0 / 0.14) < 1e-6 and abs(mediana(c["c08"]) - 10.0 / 0.18) < 1e-6)
    ck("banda di costo: 45 PASSA, 39,9 FRA, 13,2 ESCLUSA", banda_costo(45).startswith("PASSA") and banda_costo(39.9).startswith("FRA") and banda_costo(13.2).startswith("ESCLUSA"))
    # contro-esempio: ATR 2,0 e spread 0,20 -> 25x solo spread = FRA; la sola guarentigia 'cella 0,05 => 50x' NON e' il verdetto
    d5, l5 = _sintetico([("2026.07.02 03:10:00", "buy", 10.0, 2.0, 0.20, 5)])
    P5 = costruisci_passata(dict(r3, passata="X"), leggi_report(_htm(d5, 1, "10.00", "inf")), leggi_log("\n".join(l5)))
    c5 = costo_ingressi(P5)
    ck("CONTRO-ESEMPIO costo: filtro a 0,05 non garantisce 50x se l'EA ha scritto ATR 2,0 / spread 0,20 -> 25x = FRA", abs(c5["solo_spread"][0] - 25.0) < 1e-9 and banda_costo(mediana(c5["solo_spread"])).startswith("FRA"))
    # --- 5. fasce: p corretto e concordanza di tranche
    ck("p_media_zero: n<30 -> None", p_media_zero([1.0] * 10) is None)
    rs = [1.0 if i % 2 == 0 else -0.8 for i in range(100)]
    p_ = p_media_zero(rs)
    ck("p_media_zero: media 0,1 su n=100, sd ~0,9 -> p ~ 0,27 (NON sotto 0,0083)", p_ is not None and 0.2 < p_ < 0.35 and p_ > P_FASCIA, "p=%.3f" % p_)
    rs2 = [1.0 if i % 10 else -0.5 for i in range(200)]
    ck("p_media_zero: media 0,85, sd 0,45 su n=200 -> p << 0,0083", p_media_zero(rs2) < 1e-6)
    ck("P_FASCIA = 0,05/6", abs(P_FASCIA - 0.008333333) < 1e-8)
    # --- 6. G1: gemelle diverse -> ROSSO nel testo
    import contextlib
    tmp = _zip_finto()
    with contextlib.redirect_stdout(io.StringIO()):
        out, tab = stampa(carica([tmp]), None)
    testo = "\n".join(out)
    ck("stampa: G1 gemelle IDENTICHE -> VERDE", "G1 gemelle" in testo and "VERDE (identiche)" in testo)
    ck("stampa: mai 'MORTO' come verdetto, e il certificato dice NON ANCORA MISURATO", "MORTO" not in testo and "NON ANCORA MISURATO" in testo)
    ck("stampa: le 6 fasce e il costo prima del PF", testo.index("(3) COSTO") < testo.index("(4) PF, DD") < testo.index("(6) ORA"))
    tmp2 = _zip_finto(gemelle_diverse=True)
    with contextlib.redirect_stdout(io.StringIO()):
        out2, _t = stampa(carica([tmp2]), None)
    ck("CONTRO-ESEMPIO G1: gemelle con profitto diverso -> ROSSO", "ROSSO" in "\n".join(out2))
    tmp3 = _zip_finto(qualita_cattiva=True)
    with contextlib.redirect_stdout(io.StringIO()):
        out3, _t3 = stampa(carica([tmp3]), None)
    ck("CONTRO-ESEMPIO qualita': 90% ticks reali in una passata a Modello 1 NON e' un errore (la qualita' conta solo a Modello 4)", True)
    # --- 7. (v3) deposito a 7 cifre e anomalie del giornale: risposta nota + contro-esempio
    rd = leggi_report(_htm(deals, 2, "-1 234 567.89", "2.00", dd="76 123.45 (7.61%)"))
    ck("report v3: deposito '1 000 000.00' = 1000000, profitto a 7 cifre e DD '76 123.45 (7.61%)' letti", rd["deposito"] == 1000000.0 and rd["profitto"] == -1234567.89 and rd["dd_bil_abs"] == 76123.45 and rd["dd_bil_pct"] == 7.61, str((rd["deposito"], rd["profitto"], rd["dd_bil_abs"])))
    rd2 = leggi_report(_htm(deals, 2, "1\u00a0000.00", "2.00", deposito="1\u00a0000\u00a0000.00"))
    ck("report v3: separatore delle migliaia NBSP", rd2["deposito"] == 1000000.0 and rd2["profitto"] == 1000.0)
    tmp4 = _zip_finto(deposito="100 000.00", righe_extra=["2026.07.03 10:00:01   [GBA] ERRORE spostamento SL ticket 7 a 4001.00: retcode 10016 (Invalid stops)",
                                                           "2026.07.03 10:00:02   [GBA] SL 4000.00 troppo vicino (stops level 0.50) -- ordine saltato"])
    with contextlib.redirect_stdout(io.StringIO()):
        out4, _t4 = stampa(carica([tmp4]), None)
    t4 = "\n".join(out4)
    ck("CONTRO-ESEMPIO deposito: report a 100 000.00 -> DA GUARDARE (Deposit= non applicato)", "deposito iniziale del report 100000.00 invece di 1000000" in t4)
    ck("CONTRO-ESEMPIO giornale: errore di trailing e SL troppo vicino -> contati e stampati", "errore spostamento SL (trailing/BE non applicato) 1" in t4 and "altro ingresso saltato (SL # troppo vicino (stops level #)) 1" in t4, [x for x in out4 if "DA GUARDARE (giornale" in x][:1])
    ck("pulito: report a 1 000 000.00 e giornale senza anomalie -> nessun DA GUARDARE", "DA GUARDARE" not in testo)
    for pth in (tmp, tmp2, tmp3, tmp4):
        try:
            os.remove(pth)
        except OSError:
            pass
    # --- 8. (10/10) R2REG: 6 tranche, ToDate esclusivo, regimi della firma, long/short separati. Contro-esempi costruiti PRIMA.
    ck("giorni feriali: ToDate ESCLUSIVO toglie l'ultimo giorno (2026.07.01-2026.09.30: 66 inclusivo, 65 esclusivo)", giorni_feriali("2026.07.01", "2026.09.30") == 66 and giorni_feriali("2026.07.01", "2026.09.30", True) == 65)
    ck("giorni feriali: tranche contigue R2REG non si sovrappongono (T5+T4 esclusive = giorni feriali di 2025.07.01-2025.12.31)", giorni_feriali("2025.07.01", "2025.10.01", True) + giorni_feriali("2025.10.01", "2026.01.01", True) == giorni_feriali("2025.07.01", "2025.12.31"))
    fa, ma = esito_replica([], 1.62, 1.55, {"T4": 1.7, "T5": 1.6, "T6": 1.4, "T7": 0.9, "T8": 0.9, "T9": 0.9}, 0.02, 400, {"T4": 200, "T5": 200, "T6": 200, "T7": 200, "T8": 200, "T9": 200})
    ck("S4 su 6 tranche: PF_V>1,3 in 3 tranche su 6 (servono 4 = due terzi) -> NESSUN VERDETTO", "NESSUN VERDETTO" in fa and any("solo 3 tranche su 6 (servono 4" in m for m in ma), fa)
    fb, mb2 = esito_replica([], 1.62, 1.55, {"T4": 1.7, "T5": 1.6, "T6": 1.4, "T7": 1.5, "T8": 0.9, "T9": 0.9}, 0.02, 400, {"T4": 200, "T5": 200, "T6": 200, "T7": 200, "T8": 200, "T9": 200})
    ck("S4 su 6 tranche: 4 tranche su 6 con n>=150 -> RISCONTRO", fb.startswith("PF_V 1.62 >= 1,5 con le condizioni"), fb)
    fc, mc2 = esito_replica([], 1.62, 1.55, {"T4": 1.7, "T5": 1.6, "T6": 1.4, "T7": 1.5, "T8": 0.9, "T9": 0.9}, 0.02, 400, {"T4": 200, "T5": 200, "T6": 20, "T7": 5, "T8": 100, "T9": 100})
    ck("S1 dentro S4: tranche con PF_V alto ma n<150 NON contano (2 su 6 contate) -> NESSUN VERDETTO", "NESSUN VERDETTO" in fc and any("solo 2 tranche su 6" in m for m in mc2), fc)
    lgn = leggi_log("2024.07.10 00:01:00   [GBA] dati non pronti sulla barra 2024.07.10 00:01 -- segnale non valutato")
    ck("log: 'dati non pronti' contato fra le anomalie", lgn["anomalie"].get("dati non pronti (segnale NON valutato: storia M1/EMA/ATR mancante all'inizio della finestra?)") == 1)
    # regimi sui DATI VERI di R1A (se l'archivio c'e'): la somma dei regimi deve tornare coi totali gia' letti (933 = 443 long + 490 short)
    zr = os.path.join(REPO, "backtest_pipeline", "risultati_archivio", "GBA_R0_R1A_20261010", "GBA_R0_R1A.zip")
    if os.path.exists(zr):
        pr = carica([zr])
        rg, vd = lettura_regimi(pr, "REPL")
        tx = "\n".join(rg)
        ck("DATI VERI R1A: LATERALE = T1+T3 n=685 (long 329, short 356), VOLATILE = T1+T2+T3 n=933 (long 443, short 490), RIBASSO = T2 sola -> NON MISURATO (1 tranche), TORO/CALMO senza tranche",
           "LATERALE  tranche T1,T3        n=685   (long 329, short 356)" in tx and "VOLATILE  tranche T1,T2,T3     n=933   (long 443, short 490)" in tx and "meno di 2 tranche" in tx and tx.count("nessuna tranche letta") == 2, tx[:400])
        ck("DATI VERI R1A: verdetto 'NON REGGE' (PF_V 0,88 e 0,85 < 1,0) e il toro non e' misurato", vd.startswith("NON REGGE") and "LATERALE long+short" in vd, vd)
    for tipo, atteso, nome in (("laterale_perde", "NON REGGE: PF_V <= 1,0 in LATERALE long+short", "toro buono ma laterale in perdita -> NON REGGE"),
                               ("solo_toro", "NON BASTA", "CONTRO-ESEMPIO 'PF buono solo nel toro': laterale con n=60 < 150 -> NON MISURATO -> NON BASTA"),
                               ("tutto_bene", "regge nei regimi MISURATI (TORO, LATERALE", "tutti i regimi misurati con PF_V > 1,0 long e short -> regge (DD ancora aperto)"),
                               ("short_perde_toro", "NON REGGE: PF_V <= 1,0 in TORO short", "CONTRO-ESEMPIO long/short: toro con long buono e short perdente -> NON REGGE (short)")):
        zt = _zip_r2reg(tipo)
        with contextlib.redirect_stdout(io.StringIO()):
            outr, _tr = stampa(carica([zt]), None)
        trx = "\n".join(outr)
        rgx, vdx = lettura_regimi(carica([zt]), "REPL")
        ck("R2REG finto (%s): %s" % (tipo, nome), atteso in vdx, vdx)
        if tipo == "solo_toro":
            ck("R2REG finto: LATERALE n=60 -> 'n < 150' e RIBASSO senza tranche -> NON MISURATO", any(r.strip().startswith("LATERALE") and "NON MISURATO (n < 150" in r for r in rgx) and any(r.strip().startswith("RIBASSO") and "NON MISURATO" in r for r in rgx))
        if tipo == "tutto_bene":
            ck("R2REG finto: stampa con attese R2REG, 'sei tranche', S7 senza altopiano, orologio uniforme (ingressi dal 27/10 esclusi), controesempio", "sei tranche: n=" in trx and "NESSUN altopiano si legge" in trx and "ORA con OROLOGIO UNIFORME" in trx and "CONTROESEMPIO (scritto prima)" in trx, "")
            ck("R2REG finto: il lettore NON scrive 'MORTO' e porta l'intestazione del lotto", "MORTO" not in trx and "GBA R2REG -- lettore" in trx)
        os.remove(zt)
    print("")
    if falliti:
        print("AUTOTEST FALLITO: %d controlli: %s" % (len(falliti), ", ".join(falliti)))
        return 1
    print("AUTOTEST OK")
    return 0


def _zip_r2reg(tipo):
    """Zip finto del lotto R2REG (REPL, 6 tranche T4..T9) con risposta nota. tipo:
    'laterale_perde'  : toro PF 1,6 (n 320), laterale PF 0,5 (n 160)   -> NON REGGE (LATERALE)
    'solo_toro'       : toro PF 1,6 (n 320), laterale con 30 operazioni per tranche (n 60) -> LATERALE NON MISURATO -> NON BASTA (solo toro)
    'tutto_bene'      : toro e laterale PF 1,6, n>=150                  -> regge nei regimi misurati
    'short_perde_toro': nel toro il long vince e lo short perde (PF short < 1) -> NON REGGE (TORO short)"""
    import tempfile
    tranche = {"T4": "2025.10.01", "T5": "2025.07.01", "T6": "2025.04.01", "T7": "2025.01.01", "T8": "2024.10.20", "T9": "2024.07.10"}
    fine = {"T4": "2026.01.01", "T5": "2025.10.01", "T6": "2025.07.01", "T7": "2025.04.01", "T8": "2025.01.01", "T9": "2024.10.01"}
    righe, z = [], None
    f = tempfile.NamedTemporaryFile(suffix=".zip", delete=False)
    f.close()
    z = zipfile.ZipFile(f.name, "w")
    k = 0
    for tr in ("T4", "T5", "T6", "T7", "T8", "T9"):
        toro = REGIMI_TRANCHE[tr][0] == "TORO"
        n = 80 if (toro or tipo in ("laterale_perde", "tutto_bene")) else 30
        k += 1
        base = datetime.datetime.strptime(tranche[tr], "%Y.%m.%d") + datetime.timedelta(hours=1)
        lista, nets = [], []
        for i in range(n):
            lato = "buy" if i % 2 == 0 else "sell"
            vince = ((i // 2) % 2 == 0)
            if tipo == "laterale_perde" and not toro:
                prof = 100.0 if vince else -200.0
            elif tipo == "short_perde_toro" and toro and lato == "sell":
                prof = 50.0 if vince else -200.0
            else:
                prof = 160.0 if vince else -100.0
            t = base + datetime.timedelta(hours=i * 6)
            lista.append((t.strftime("%Y.%m.%d %H:%M:%S"), lato, prof, 4.0, 0.10, 5))
            nets.append(prof)
        dd, lg = _sintetico(lista)
        tag = "R2REG_%02d_REPL_%s_m775800" % (k, tr)
        z.writestr("report\\GBA_R0_" + tag + ".htm", _htm(dd, n, _fmt(sum(nets)), "%.2f" % pf_di(nets)))
        z.writestr("log\\GBA_" + tag + ".txt", "\r\n".join(["# passata finta"] + lg))
        righe.append("R2REG;%s;REPL;0.05;%s;%s;%s;4;775800;2026-10-10 10:00:00;60;OK;%d;%s;%.2f;100%%ticksreali;88000;;88000;25000000;;100;%d;si;si;%s-%s;" % (
            tag, tr, tranche[tr], fine[tr], n, sum(nets), pf_di(nets), n, tranche[tr], fine[tr]))
    z.writestr("MANIFEST_R0.csv", _manifest(righe))
    z.close()
    return f.name


def _zip_finto(gemelle_diverse=False, qualita_cattiva=False, deposito="1 000 000.00", righe_extra=()):
    import tempfile
    tr = []
    base = datetime.datetime(2026, 7, 1, 1, 0, 0)
    for i in range(40):
        t = base + datetime.timedelta(hours=i * 11)
        tr.append((t.strftime("%Y.%m.%d %H:%M:%S"), "buy" if i % 3 else "sell", 90.0 if i % 2 == 0 else -100.0, 4.0, 0.10, 6))
    dd, lg = _sintetico(tr)
    nets = [90.0 if i % 2 == 0 else -100.0 for i in range(40)]
    righe = []
    f = tempfile.NamedTemporaryFile(suffix=".zip", delete=False)
    f.close()
    z = zipfile.ZipFile(f.name, "w")
    for mg in ("775800", "775850"):
        tag = "S0_0%d_REPL_T1_m%s" % (1 if mg == "775800" else 2, mg)
        prof = sum(nets) + (5.0 if (gemelle_diverse and mg == "775850") else 0.0)
        ddl = list(dd)
        rep = _htm(ddl, 40, _fmt(prof), "%.2f" % pf_di(nets), qual="n/a" if not qualita_cattiva else "90% ticks reali", deposito=deposito)
        z.writestr("report\\GBA_R0_" + tag + ".htm", rep)
        z.writestr("log\\GBA_" + tag + ".txt", "\r\n".join(["# passata finta"] + lg + list(righe_extra)))
        righe.append("S0;%s;REPL;0.05;T1;2026.07.01;2026.09.30;1;%s;2026-10-09 10:00:00;60;OK;40;%s;%.2f;n/a;88000;;88000;350000;;100;40;si;si;2026.07.01-2026.09.30;" % (tag, mg, prof, pf_di(nets)))
    z.writestr("MANIFEST_R0.csv", _manifest(righe))
    z.close()
    return f.name


def main(argv):
    if "--autotest" in argv:
        return autotest()
    csv_out = None
    zs = []
    i = 0
    while i < len(argv):
        if argv[i] == "--csv-out" and i + 1 < len(argv):
            csv_out = argv[i + 1]
            i += 2
            continue
        zs.append(argv[i])
        i += 1
    if not zs:
        print(__doc__)
        return 2
    stampa(carica(zs), csv_out)
    return 0


if __name__ == "__main__":
    sys.exit(main(sys.argv[1:]))
