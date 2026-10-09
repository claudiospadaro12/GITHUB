#!/usr/bin/env python3
# -*- coding: ascii -*-
"""
leggi_natcla_f1.py -- IL LETTORE della fase F1 di 'Ea Nat&Cla' (EA_NatCla v1.11, tre regole di stop, tick reali, SOLO l'IS).
Legge cio' che torna da NATCLA_F1_PASSATE.ps1 (zip o cartella: MANIFEST_F1.csv, csv\\<passata>.csv = CSV per-setup dell'EA, report\\<passata>.htm,
log\\<passata>.txt = righe [NatCla] con l'ora simulata, trades\\<passata>.csv facoltativo, il file prova copiato) e stampa, nell'ordine scritto nel file
prova PRIMA dei numeri:
  (1) affidabilita' di ogni passata (stato del driver + controlli rifatti qui: AVVIO/CFG/righe SETUP/regola di stop/report/colla CSV-report);
  (2) n per GAMBA (famiglia x config x lato x modo) contro le attese @F1-ATTESA (banda 0,5-2,0);
  (3) PF_R per setup, media di R e p, tasso di vincita, DD in R, peggior giornata, durata mediana, con e senza la commissione derivata;
  (4) verdetto di gamba T1-T4 (SOTTILE / VIVO / NON DISTINGUIBILE / PERDENTE MISURATO), MAI 'morto' (certificato T7: manca sempre la casella 3);
  (5) confronto dei modi T5; (6) determinismo fra passate ripetute (pilota contro lotti).
NON promuove niente, NON sceglie il modo: se due modi sono VIVI e indistinguibili la scelta e' di Claudio.

USO
  python3 backtest_pipeline/leggi_natcla_f1.py NATCLA_F1_P.zip [NATCLA_F1_O.zip ...] [--prova FILE] [--csv-out F1_gambe.csv]
  python3 backtest_pipeline/leggi_natcla_f1.py --autotest     (dati finti con risposta nota + contro-esempi; esce 1 se un controllo cade)

L'UNITA' (specifica 5.5): n = SETUP riempiti = righe SETUP del CSV dell'EA (mai ordini, mai deal). R di un setup = colonna esito_R dell'EA
(= esito in soldi / rischio OBIETTIVO del setup). PF_R = somma degli R positivi / somma dei valori assoluti degli R negativi.
COMMISSIONE: se la colonna Commissioni dei deal del report somma ZERO, si sottrae per setup c_R = riempiti x c / somma(|prezzo_i - SL|) sugli ordini
piazzati (lotti uguali, pesi 1:1:1), c = forex 0,004% del prezzo della linea, oro 0,04 USD, indici 0 (a giro); e si stampa SEMPRE anche il doppio.
"""
import csv, datetime, io, math, os, re, statistics, sys, tempfile, zipfile

QD = os.path.dirname(os.path.abspath(__file__))
REPO = os.path.abspath(os.path.join(QD, ".."))
NOME_PROVA = "NATCLA_F1_STOP_2026-10-09.txt"
PROVA_REPO = os.path.join(REPO, "backtest_pipeline", "prove", NOME_PROVA)

# ---------------------------------------------------------------------------------------------------------------------
#  SOGLIE CONGELATE -- copiate dal file prova NATCLA_F1_STOP_2026-10-09.txt (T1-T7, A1), scritte PRIMA dei numeri
# ---------------------------------------------------------------------------------------------------------------------
VERSIONE_EA = "1.11"
STOP_U = 20.0
BUFFER_U = 5.0
DEPOSITO = 1000000.0
N_GAMBA = 150            # T1
PF_VIVO = 1.15           # T2
P_VIVO = 0.05            # T2/T3, unilaterale
SEGNO = 2.0 / 3.0        # T2/T5, per eccesso
N_SIM_SEGNO = 30         # T2/T5: un simbolo vota solo con n >= 30
DPF_MODO = 0.10          # T5
BANDA_N = (0.5, 2.0)     # A1
STOP_N = (0.1, 10.0)     # A1
DUR_FEDELE = 60.0        # A4
DUR_COMPAT = 180.0       # A4
MURO_DD = 10.0           # T6 (%)
PAUSA_GIORNO = 4.0       # T6 (%)
TOL_TRADES = 3           # colla: un setup aperto a fine test = fino a 3 posizioni senza riga SETUP
MOTIVI_OK = ("TP", "SL", "EA", "DURATA", "ALTRO")
STOP_AVVIO = {"0": "GEOMETRIA_ATTUALE", "1": "OLTRE_LINEA_ESTERNA 20.00 u", "2": "OLTRE_PIU_ESTERNA 20.00 u"}
VERDETTI = ("SOTTILE", "VIVO", "NON DISTINGUIBILE", "PERDENTE MISURATO")


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

    def ha(self, nome):
        return nome in self.nomi

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
#  IL FILE PROVA: i blocchi @F1
# ---------------------------------------------------------------------------------------------------------------------
def leggi_blocchi(txt):
    r = {"CONFIG": {}, "MODO": {}, "LATO": {}, "SIMBOLO": {}, "INCL": {}, "ATTESA": {}, "LOTTO": {}}
    for l in txt.splitlines():
        m = re.match(r"^#\s*@F1-(CONFIG|MODO|LATO|SIMBOLO|INCL|ATTESA|LOTTO)\s+(.*)$", l.strip())
        if not m:
            continue
        kv = {}
        for pezzo in m.group(2).split():
            a, b = pezzo.split("=", 1)
            if a in kv:
                raise ValueError("chiave doppia nel blocco: " + l)
            kv[a] = b
        t = m.group(1)
        if t == "INCL":
            r[t][(kv["famiglia"], kv["config"])] = kv["soglia"]
        elif t == "ATTESA":
            r[t][(kv["simbolo"], kv["config"])] = (int(kv["long"]), int(kv["short"]))
        else:
            r[t][kv["nome"]] = kv
    return r


# ---------------------------------------------------------------------------------------------------------------------
#  IL REPORT DEL TESTER (.htm, UTF-16): celle del riassunto + deal (13 colonne) per la commissione
# ---------------------------------------------------------------------------------------------------------------------
def _cella(piatto, etichette):
    for e in etichette:
        m = re.search(r"\|" + e + r":\|([^|]*)\|", piatto)
        if m:
            return re.sub(r"\s", "", m.group(1))
    return None


def leggi_report(raw):
    t = decodifica(raw)
    piatto = re.sub(r"<[^>]+>", "|", t)
    piatto = re.sub(r"\s*\|[\s|]*", "|", piatto)
    r = {"ok": False, "motivo": ""}
    r["expert"] = _cella(piatto, ["Expert"])
    r["simbolo"] = _cella(piatto, ["Simbolo", "Symbol"])
    r["periodo"] = _cella(piatto, ["Periodo", "Period"])
    r["qualita"] = _cella(piatto, ["Qualit. dello Storico", "History Quality"])
    r["trades"] = numero(_cella(piatto, ["Numero di Operazioni di Trading Totali", "Total Trades"]))
    r["profitto"] = numero(_cella(piatto, ["Profitto Totale Netto", "Total Net Profit"]))
    r["pf"] = numero(_cella(piatto, ["Fattore di Profitto", "Profit Factor"]))
    r["deposito"] = numero(_cella(piatto, ["Deposito Iniziale", "Initial Deposit"]))
    comm, nin = 0.0, 0
    for tr in re.findall(r"<tr[^>]*>(.*?)</tr>", t, flags=re.S | re.I):
        celle = [re.sub(r"\s+", " ", re.sub(r"<[^>]+>", "", c)).replace("&nbsp;", " ").strip() for c in re.findall(r"<td[^>]*>(.*?)</td>", tr, flags=re.S | re.I)]
        if len(celle) == 13 and re.match(r"^\d{4}\.\d\d\.\d\d \d\d:\d\d:\d\d$", celle[0]) and celle[1].isdigit() and celle[3] in ("buy", "sell"):
            comm += numero(celle[8]) or 0.0
            if celle[4] == "in":
                nin += 1
    r["commissioni"] = comm
    r["deal_in"] = nin
    if r["trades"] is None or r["profitto"] is None:
        r["motivo"] = "etichette del totale operazioni / profitto netto non trovate"
        return r
    r["ok"] = True
    return r


# ---------------------------------------------------------------------------------------------------------------------
#  IL CSV PER-SETUP DELL'EA e IL GIORNALE
# ---------------------------------------------------------------------------------------------------------------------
def leggi_csv(raw):
    out = {"avvio": "", "cfg": {}, "header": None, "setup": [], "conta": 0, "errori": []}
    for l in decodifica(raw).splitlines():
        if l.startswith("#AVVIO"):
            if not out["avvio"]:
                out["avvio"] = l
            continue
        if l.startswith("#cfg;"):
            p = l.split(";", 3)
            if len(p) >= 3:
                out["cfg"][p[1]] = p[2]
            continue
        if l.startswith("tipo;barra;linea;lato;"):
            out["header"] = l.split(";")
            continue
        if l.startswith("CONTA;"):
            out["conta"] += 1
            continue
        if l.startswith("SETUP;"):
            if out["header"] is None:
                out["errori"].append("riga SETUP prima dell'intestazione")
                continue
            c = l.split(";")
            if len(c) != len(out["header"]):
                out["errori"].append("riga SETUP con %d campi invece di %d" % (len(c), len(out["header"])))
                continue
            out["setup"].append(dict(zip(out["header"], c)))
    return out


def leggi_log(raw):
    out = {"avvio": [], "verifica": [], "invio_fallito": 0, "invio_10019": 0, "lotto_min": 0, "semaforo": 0, "imbuto_rotte": 0, "rifiuti": 0, "righe": 0}
    for riga in decodifica(raw).splitlines():
        m = re.match(r"^(\d{4}\.\d\d\.\d\d \d\d:\d\d:\d\d)\s+(\[(?:NatCla|NATCLA-IMBUTO)\].*)$", riga.rstrip())
        if not m:
            continue
        out["righe"] += 1
        msg = m.group(2)
        if msg.startswith("[NatCla] AVVIO v"):
            out["avvio"].append(msg)
        elif msg.startswith("[NatCla] VERIFICA ADX"):
            out["verifica"].append(msg)
        elif msg.startswith("[NatCla] INVIO FALLITO"):
            out["invio_fallito"] += 1
            if re.search(r"retcode 10019\b", msg):
                out["invio_10019"] += 1
        elif "lotto sotto il minimo" in msg:
            out["lotto_min"] += 1
        elif "SEMAFORO SFORATO" in msg:
            out["semaforo"] += 1
        elif msg.startswith("[NATCLA-IMBUTO]") and "quadratura ROTTA" in msg:
            out["imbuto_rotte"] += 1
        elif re.match(r"^\[NatCla\] (AVVIO RIFIUTATO|ERRORE)", msg):
            out["rifiuti"] += 1
    return out


def _dec(s):
    return len(s.split(".")[1]) if "." in s else 0


def controlla_riga_setup(r, sim, cfg, lato, modo):
    """None se la riga SETUP e' coerente con la passata dichiarata, altrimenti il motivo."""
    s = int(lato["segno"])
    u = float(sim["u"])
    if int(r["lato"]) != s:
        return "lato %s nella riga contro %s della passata" % (r["lato"], lato["nome"])
    if r["stop_modo"] != modo["valore"]:
        return "stop_modo %s contro %s della passata" % (r["stop_modo"], modo["nome"])
    if r["linea"] not in cfg["linee"].split(","):
        return "linea %s non della config %s" % (r["linea"], cfg["nome"])
    try:
        nr = int(r["n_riempiti"])
        soldi, rr, risk = float(r["esito_soldi"]), float(r["esito_R"]), float(r["rischio_soldi"])
        sl = float(r["sl"])
        p = [float(r["p1"]), float(r["p2"]), float(r["p3"])]
        lp, ls = float(r["linea_prezzo"]), float(r["linea_stop"])
    except (ValueError, KeyError) as e:
        return "campo non numerico: %s" % e
    if nr < 1:
        return "riga SETUP con n_riempiti %d (un setup senza riempimenti non ha esito)" % nr
    if r["motivo"] not in MOTIVI_OK:
        return "motivo di chiusura '%s' sconosciuto" % r["motivo"]
    if not risk > 0:
        return "rischio_soldi %s non positivo" % r["rischio_soldi"]
    if abs(rr - soldi / risk) > 0.002 + 1e-3 * abs(rr):
        return "esito_R %s contro esito_soldi/rischio_soldi %.4f" % (r["esito_R"], soldi / risk)
    tol = 1.5 * 10 ** (-max(_dec(r["sl"]), _dec(r["p3"])))
    if not all(s * (x - sl) > 0 for x in p):
        return "SL %s dal lato sbagliato di un ordine (lato %d)" % (r["sl"], s)
    x4 = p[2] - s * BUFFER_U * u
    es = r["stop_esito"]
    if modo["valore"] == "0":
        if es != "0" or ls != 0.0:
            return "GEOMETRIA_ATTUALE con stop_esito %s / linea_stop %s non nulli" % (es, r["linea_stop"])
        if abs(sl - x4) > tol:
            return "GEOMETRIA_ATTUALE: SL %s invece di ordine profondo - %g u = %.6f" % (r["sl"], BUFFER_U, x4)
        return None
    if es == "1":
        return "stop_esito 1 (setup che l'EA scarta) in una riga SETUP: un setup scartato non si arma"
    if not ls > 0:
        return "linea_stop %s non valida" % r["linea_stop"]
    crit = ls - s * STOP_U * u
    if es == "0" and abs(sl - crit) > tol:
        return "SL %s non a %g u oltre la linea dello stop %s (atteso %.6f)" % (r["sl"], STOP_U, r["linea_stop"], crit)
    if es == "2":
        if abs(sl - x4) > tol:
            return "stop_esito 2 (vince X4) ma SL %s diverso da ordine profondo - 5 u (%.6f)" % (r["sl"], x4)
        if s * (crit - sl) < -tol:
            return "stop_esito 2 ma la regola (%.6f) e' piu' LONTANA di X4: avrebbe dovuto vincere la regola" % crit
    if es not in ("0", "2"):
        return "stop_esito %s sconosciuto" % es
    tl = 1.5 * 10 ** (-max(_dec(r["linea_prezzo"]), _dec(r["linea_stop"])))
    if r["linea"] == "E200" and abs(ls - lp) > tl:
        return "linea E200: la linea dello stop %s non e' la EMA200 del setup %s" % (r["linea_stop"], r["linea_prezzo"])
    if r["linea"] == "ST35" and modo["valore"] == "1" and abs(ls - lp) > tl:
        return "ST35 in OLTRE_LINEA_ESTERNA: la linea dello stop %s non e' la ST3,5 del setup %s" % (r["linea_stop"], r["linea_prezzo"])
    if r["linea"] == "ST35" and modo["valore"] == "2" and s * (lp - ls) < -tl:
        return "ST35 in OLTRE_PIU_ESTERNA: la linea dello stop %s sta DENTRO la ST3,5 del setup %s" % (r["linea_stop"], r["linea_prezzo"])
    return None


def comm_prezzo(sim, linea_prezzo):
    return {"FX": 0.00004 * linea_prezzo, "ORO": 0.04, "IDX": 0.0}[sim["classe"]]


# [CANCELLO 09/10] IL NULLO MISURATO SULLA GEOMETRIA VERA (contro-esempio di A2/T5, solo DIAGNOSTICA: nessun verdetto cambia).
# Passeggiata casuale senza deriva che parte dal PRIMO ordine piazzato (una riga SETUP esiste solo se almeno un ordine si e' riempito),
# riempie gli altri in ordine di distanza dallo stop, esce tutta insieme al TP comune o allo SL comune. Gambler's ruin a ogni ordine:
# P(TP prima del prossimo ordine | sul livello x) = (x - prossimo) / (TP - prossimo). Pedaggio c per lotto (spread + commissione).
# Ritorna (vincita attesa, perdita attesa) IN R del setup (R = sum lotto_i x |p_i - SL|), oppure None se la geometria non e' leggibile.
# Controllato: ordine singolo = formula per ordine di A2 (EURUSD 0,83/0,87/0,84); scala intera contro Monte Carlo entro l'1%.
def nullo_setup(s, ps_lotti, sl, tp, c):
    liv = sorted(((s * (p - sl), lt) for p, lt in ps_lotti if lt > 0), reverse=True)
    T = s * (tp - sl)
    if not liv or liv[-1][0] <= 0 or T <= liv[0][0]:
        return None
    R = sum(d * lt for d, lt in liv)
    ew, pr, pieni = 0.0, 1.0, []
    for k, (d, lt) in enumerate(liv):
        pieni.append((d, lt))
        nxt = liv[k + 1][0] if k + 1 < len(liv) else 0.0
        a = (d - nxt) / (T - nxt)
        ew += pr * a * sum(l2 * (T - d2 - c) for d2, l2 in pieni)
        pr *= (1.0 - a)
    el = pr * sum(l2 * (d2 + c) for d2, l2 in pieni)
    return ew / R, el / R


def nullo_riga(r, sim):
    try:
        s = int(r["lato"])
        ps = [(float(r["p%d" % k]), float(r["lotto%d" % k])) for k in (1, 2, 3)]
        tps = [float(r["tp%d" % k]) for k in (1, 2, 3) if float(r["lotto%d" % k]) > 0]
        sl, sp = float(r["sl"]), float(r["spread"])
        c = max(sp, 0.0) + comm_prezzo(sim, float(r["linea_prezzo"]))
    except (ValueError, KeyError):
        return None
    if not tps or max(tps) - min(tps) > 1e-9 * max(1.0, abs(tps[0])):
        return None
    return nullo_setup(s, ps, sl, tps[0], c)


# [CANCELLO 09/10] R DI UNO STOP PIENO: un setup con i 3 ordini riempiti che esce allo SL deve valere ~ -1 R (meno commissione e scivolamento).
# Se vale molto meno in valore assoluto, i lotti sono stati arrotondati/troncati (deposito, step 0,1 degli indici, volume massimo) e il PF_R
# pesa i setup in modo diverso da quello dichiarato. Banda della MEDIANA scritta prima dei numeri: [-1,10 ; -0,85] (arrotondamento <= ~11% a
# 1.000.000 EUR sull'oro H1, file prova; commissione forex di uno stop pieno ~0,04-0,06 R). Solo DIAGNOSTICA (DA GUARDARE), nessun verdetto cambia.
BANDA_STOP_PIENO = (-1.10, -0.85)


def comm_r(r, sim):
    """commissione derivata di UN setup in R (lotti uguali, pesi 1:1:1): riempiti x c / somma delle distanze dallo stop degli ordini piazzati."""
    c = comm_prezzo(sim, float(r["linea_prezzo"]))
    if c <= 0:
        return 0.0
    sl = float(r["sl"])
    dist = sum(abs(float(r["p%d" % k]) - sl) for k in (1, 2, 3) if float(r["lotto%d" % k]) > 0)
    if dist <= 0:
        return 0.0
    return int(r["n_riempiti"]) * c / dist


# ---------------------------------------------------------------------------------------------------------------------
#  STATISTICHE
# ---------------------------------------------------------------------------------------------------------------------
def pf_di(v):
    g = sum(x for x in v if x > 0)
    p = -sum(x for x in v if x < 0)
    if p <= 0:
        return float("inf") if g > 0 else float("nan")
    return g / p


def p_media(v):
    """(p unilaterale media > 0, p unilaterale media < 0), approssimazione normale; None con n < 30."""
    n = len(v)
    if n < 30:
        return (None, None)
    sd = statistics.pstdev(v) * math.sqrt(n / (n - 1.0))
    m = statistics.mean(v)
    if sd == 0:
        return (0.0 if m > 0 else 1.0, 0.0 if m < 0 else 1.0)
    t = m / (sd / math.sqrt(n))
    return (0.5 * math.erfc(t / math.sqrt(2.0)), 0.5 * math.erfc(-t / math.sqrt(2.0)))


def dd_r(seq):
    picco, cum, dd = 0.0, 0.0, 0.0
    for x in seq:
        cum += x
        picco = max(picco, cum)
        dd = max(dd, picco - cum)
    return dd


def verdetto(n, pf, pp, pn, segno_ok):
    if n < N_GAMBA:
        return "SOTTILE"
    if pf == pf and pf >= PF_VIVO and pp is not None and pp < P_VIVO and segno_ok:
        return "VIVO"
    if pf == pf and pf < 1.0 and pn is not None and pn < P_VIVO:
        return "PERDENTE MISURATO"
    return "NON DISTINGUIBILE"


def segno(pf_per_sim, n_per_sim):
    """(voti positivi, votanti, ok): PF_R > 1 in almeno 2/3 (per eccesso) dei simboli con n >= 30."""
    votanti = [s for s, n in n_per_sim.items() if n >= N_SIM_SEGNO]
    pos = sum(1 for s in votanti if pf_per_sim[s] == pf_per_sim[s] and pf_per_sim[s] > 1.0)
    serve = math.ceil(SEGNO * len(votanti) - 1e-9)
    return pos, len(votanti), (len(votanti) >= 2 and pos >= serve)


# ---------------------------------------------------------------------------------------------------------------------
#  CARICAMENTO
# ---------------------------------------------------------------------------------------------------------------------
def carica(percorsi, prova_txt=None):
    srcs = [Sorgente(p) for p in percorsi]
    if prova_txt is None:
        for s in srcs:
            if s.ha(NOME_PROVA):
                prova_txt = decodifica(s.leggi(NOME_PROVA))
                break
    if prova_txt is None:
        prova_txt = open(PROVA_REPO, encoding="ascii").read()
    bl = leggi_blocchi(prova_txt)
    passate, problemi = [], []
    for s in srcs:
        if not s.ha("MANIFEST_F1.csv"):
            problemi.append("%s: manca MANIFEST_F1.csv (non e' uno zip di NATCLA_F1_PASSATE.ps1)" % s.percorso)
            continue
        for m in csv.DictReader(io.StringIO(decodifica(s.leggi("MANIFEST_F1.csv"))), delimiter=";"):
            P = {"m": m, "src": s.percorso, "ko": [], "guarda": [], "rows": [], "rep": None}
            try:
                sim, cfg = bl["SIMBOLO"][m["simbolo"]], bl["CONFIG"][m["config"]]
                lato, modo = bl["LATO"][m["lato"]], bl["MODO"][m["modo"]]
            except KeyError as e:
                problemi.append("MANIFEST %s: %s non e' nei blocchi del file prova" % (m.get("passata"), e))
                continue
            P.update({"sim": sim, "cfg": cfg, "lato": lato, "modo": modo, "fam": sim["famiglia"]})
            if m["stato"] == "NON_LANCIATA":
                P["ko"].append("NON LANCIATA: " + m.get("motivi", ""))
                passate.append(P)
                continue
            if not m["stato"].startswith("OK"):
                P["ko"].append("KO del driver: " + m.get("motivi", ""))
            tag = m["passata"]
            soglia = bl["INCL"].get((sim["famiglia"], cfg["nome"]))
            if soglia is None or m.get("soglia_incl") != soglia:
                P["ko"].append("soglia d'inclinazione del MANIFEST %s contro il file prova %s" % (m.get("soglia_incl"), soglia))
            stop_att = STOP_AVVIO[modo["valore"]]
            # il CSV per-setup
            cn = "csv/%s.csv" % tag
            if not s.ha(cn):
                P["ko"].append("CSV per-setup assente nello zip")
            else:
                c = leggi_csv(s.leggi(cn))
                P["csv"] = c
                for e in c["errori"]:
                    P["ko"].append("CSV: " + e)
                if not c["avvio"].startswith("#AVVIO v%s " % VERSIONE_EA) or ("| stop " + stop_att) not in c["avvio"] or "| solo conta no |" not in c["avvio"]:
                    P["ko"].append("#AVVIO del CSV senza v%s / '| stop %s' / 'solo conta no'" % (VERSIONE_EA, stop_att))
                if c["cfg"].get("InpDirezione") != lato["cfg"]:
                    P["ko"].append("#cfg InpDirezione %s invece di %s" % (c["cfg"].get("InpDirezione"), lato["cfg"]))
                if c["cfg"].get("Inclinazione") != "ACCESA, N 20, soglia %s ATR, verso NC_INCL_QUALSIASI" % soglia:
                    P["ko"].append("#cfg Inclinazione '%s' invece della soglia %s" % (c["cfg"].get("Inclinazione"), soglia))
                if c["cfg"].get("Stop") != stop_att:
                    P["ko"].append("#cfg Stop '%s' invece di '%s'" % (c["cfg"].get("Stop"), stop_att))
                if c["conta"] > 0:
                    P["ko"].append("%d righe CONTA: l'EA era in SOLO CONTA" % c["conta"])
                cattive = []
                for r in c["setup"]:
                    mot = controlla_riga_setup(r, sim, cfg, lato, modo)
                    if mot:
                        cattive.append("%s %s: %s" % (r["barra"], r["linea"], mot))
                if cattive:
                    P["ko"].append("%d righe SETUP incoerenti con la passata (es. %s)" % (len(cattive), "; ".join(cattive[:2])))
                P["rows"] = c["setup"]
                if m.get("setup_righe") not in (None, "") and int(m["setup_righe"]) != len(c["setup"]):
                    P["ko"].append("righe SETUP: MANIFEST %s, CSV %d" % (m["setup_righe"], len(c["setup"])))
            # il report
            rn = "report/%s.htm" % tag
            if not s.ha(rn):
                P["ko"].append("report .htm assente nello zip")
            else:
                rep = leggi_report(s.leggi(rn))
                P["rep"] = rep
                if not rep["ok"]:
                    P["ko"].append("report: " + rep["motivo"])
                else:
                    if rep["expert"] != "EA_NatCla" or rep["simbolo"] != sim["nome"]:
                        P["ko"].append("report di %s %s invece di EA_NatCla %s" % (rep["expert"], rep["simbolo"], sim["nome"]))
                    if not (rep["qualita"] or "").startswith("100%"):
                        P["ko"].append("qualita dello storico '%s' invece di 100%% ticks reali" % rep["qualita"])
                    if rep["deposito"] is None or abs(rep["deposito"] - DEPOSITO) > 0.5:
                        P["ko"].append("deposito del report %s invece di %.0f (R e lotti deformati: file prova)" % (rep["deposito"], DEPOSITO))
                    per = rep["periodo"] or ""
                    if not per.startswith("%s(%s-" % (cfg["periodo"], sim["da"])):
                        P["ko"].append("periodo del report '%s' invece di %s(%s-...)" % (per, cfg["periodo"], sim["da"]))
                    if P["rows"] or rep["trades"]:
                        riemp = sum(int(r["n_riempiti"]) for r in P["rows"])
                        d = int(rep["trades"]) - riemp
                        if d < 0 or d > TOL_TRADES:
                            P["ko"].append("operazioni del report %d contro riempiti delle righe SETUP %d (colla ordini -> CSV)" % (int(rep["trades"]), riemp))
                        soldi = sum(float(r["esito_soldi"]) for r in P["rows"])
                        rmax = max([float(r["rischio_soldi"]) for r in P["rows"]] or [0.0])
                        tol = 2.0 * rmax + 1.0 if P["rows"] else 0.02 * DEPOSITO
                        if abs(rep["profitto"] - soldi) > tol:
                            P["ko"].append("profitto del report %.2f contro somma degli esiti SETUP %.2f (tolleranza %.2f)" % (rep["profitto"], soldi, tol))
            # il giornale
            ln = "log/%s.txt" % tag
            if not s.ha(ln):
                P["ko"].append("log dell'EA assente nello zip")
            else:
                g = leggi_log(s.leggi(ln))
                P["log"] = g
                if len(g["avvio"]) != 1:
                    P["ko"].append("righe AVVIO nel giornale: %d (attesa 1)" % len(g["avvio"]))
                if len(g["verifica"]) != 1 or "il terminale coincide con: formula MetaQuotes" not in g["verifica"][0]:
                    P["ko"].append("VERIFICA ADX assente, doppia o non MetaQuotes")
                if g["invio_10019"] or g["lotto_min"] or g["rifiuti"]:
                    P["ko"].append("giornale: INVIO FALLITO 10019 %d, lotto sotto il minimo %d, AVVIO RIFIUTATO/ERRORE %d" % (g["invio_10019"], g["lotto_min"], g["rifiuti"]))
                for k, nome in (("invio_fallito", "INVIO FALLITO (altri retcode)"), ("semaforo", "SEMAFORO SFORATO"), ("imbuto_rotte", "imbuto quadratura ROTTA")):
                    if g[k]:
                        P["guarda"].append("%s: %d" % (nome, g[k]))
            passate.append(P)
    return bl, passate, problemi


def chiave_gamba(P):
    return (P["fam"], P["cfg"]["nome"], P["lato"]["nome"], P["modo"]["nome"])


def calcola(bl, passate):
    """gambe[(fam, cfg, lato, modo)] -> statistiche; solo passate senza KO."""
    gambe = {}
    # [CANCELLO 09/10] una passata RIPETUTA (pilota P + lotto O/FA che la rigira: le 4 del pilota) si conta UNA volta sola, la prima letta.
    # Senza, leggere P insieme ai lotti -- cio' che USO e il punto (6) chiedono -- raddoppiava n, la peggior giornata e la significativita'.
    contate = set()
    for P in passate:
        if P["ko"]:
            continue
        k5 = (P["sim"]["nome"], P["cfg"]["nome"], P["lato"]["nome"], P["modo"]["nome"])
        if k5 in contate:
            continue
        contate.add(k5)
        rep = P["rep"]
        tester_comm = rep is not None and abs(rep.get("commissioni") or 0.0) > 1e-9
        g = gambe.setdefault(chiave_gamba(P), {"sim": {}, "seq": [], "comm_tester": set(), "nullo": [0.0, 0.0, 0], "pieni": []})
        g["comm_tester"].add(tester_comm)
        # [CANCELLO 09/10] il simbolo entra nella gamba ANCHE con zero righe SETUP: senza, un simbolo a n 0 sparirebbe da n E dall'attesa (A1 cieca)
        g["sim"].setdefault(P["sim"]["nome"], [])
        for r in P["rows"]:
            cr = 0.0 if tester_comm else comm_r(r, P["sim"])
            x = float(r["esito_R"])
            g["seq"].append((r["barra"], P["sim"]["nome"], x - cr, x - 2.0 * cr, x, float(r["durata_min"])))
            g["sim"].setdefault(P["sim"]["nome"], []).append((x - cr, x - 2.0 * cr))
            nu = nullo_riga(r, P["sim"])
            if nu is None:
                g["nullo"][2] += 1
            else:
                g["nullo"][0] += nu[0]
                g["nullo"][1] += nu[1]
            piazzati = sum(1 for k in (1, 2, 3) if float(r["lotto%d" % k]) > 0)
            if r["motivo"] == "SL" and piazzati == 3 and int(r["n_riempiti"]) == 3:
                g["pieni"].append(x)
    out = {}
    for k, g in gambe.items():
        seq = sorted(g["seq"])
        v1 = [x[2] for x in seq]
        v2 = [x[3] for x in seq]
        v0 = [x[4] for x in seq]
        n = len(v1)
        pfs1 = {s: pf_di([a for a, _b in vv]) for s, vv in g["sim"].items()}
        pfs2 = {s: pf_di([b for _a, b in vv]) for s, vv in g["sim"].items()}
        ns = {s: len(vv) for s, vv in g["sim"].items()}
        pos, vot, ok1 = segno(pfs1, ns)
        _pos2, _vot2, ok2 = segno(pfs2, ns)
        pp1, pn1 = p_media(v1)
        pp2, pn2 = p_media(v2)
        pf1, pf2 = pf_di(v1), pf_di(v2)
        giorni = {}
        for x in seq:
            giorni[x[0][:10]] = giorni.get(x[0][:10], 0.0) + x[2]
        ddr = dd_r(v1)
        peggio = min(giorni.values()) if giorni else 0.0
        if k[0] == "ORO" or len(ns) < 2:
            ok1 = ok1 and len(ns) >= 2
        att = 0
        for s in ns:
            a = bl["ATTESA"].get((s, k[1]))
            if a:
                att += a[0] if k[2] == "LONG" else a[1]
        out[k] = {"n": n, "pf": pf1, "pf2": pf2, "pf_lordo": pf_di(v0), "media": statistics.mean(v1) if v1 else float("nan"), "pp": pp1, "pn": pn1,
                  "wr": (100.0 * sum(1 for x in v1 if x > 0) / n) if n else float("nan"), "dd": ddr, "peggio": peggio,
                  "dur": statistics.median([x[5] for x in seq]) if seq else float("nan"), "pf_sim": pfs1, "n_sim": ns, "segno": (pos, vot),
                  "verdetto": verdetto(n, pf1, pp1, pn1, ok1), "verdetto2": verdetto(n, pf2, pp2, pn2, ok2), "attesa": att,
                  "comm_tester": sorted(g["comm_tester"]), "sequenza": [(x[0], x[1], x[2]) for x in seq],
                  "pf_nullo": (g["nullo"][0] / g["nullo"][1]) if g["nullo"][1] > 0 else float("nan"), "nullo_saltati": g["nullo"][2],
                  "att_sim": {s: (bl["ATTESA"].get((s, k[1])) or (0, 0))[0 if k[2] == "LONG" else 1] for s in ns},
                  "pieni": sorted(g["pieni"])}
    return out


def stop_pieno(g):
    """(n, mediana, il meno negativo, fuori banda?) degli R degli stop pieni della gamba; None se nessuno."""
    v = g.get("pieni") or []
    if not v:
        return None
    med = statistics.median(v)
    return len(v), med, max(v), not (BANDA_STOP_PIENO[0] <= med <= BANDA_STOP_PIENO[1])


def banda_n(n, att):
    if att <= 0:
        return "n.d."
    q = n / float(att)
    if BANDA_N[0] <= q <= BANDA_N[1]:
        return "COERENTE (%.2fx)" % q
    if q < STOP_N[0] or q > STOP_N[1]:
        return "STOP (%.2fx): si cerca la causa prima di leggere il PF" % q
    return "DA GUARDARE (%.2fx)" % q


def confronta_modi(gambe):
    """T5: per (fam, cfg, lato) e coppia di modi. Ritorna lista di righe."""
    righe = []
    gruppi = {}
    for (f, c, l, m), g in gambe.items():
        gruppi.setdefault((f, c, l), {})[m] = g
    for (f, c, l), mm in sorted(gruppi.items()):
        modi = [x for x in ("GEOM", "LINEA", "PIU") if x in mm]
        for i in range(len(modi)):
            for j in range(i + 1, len(modi)):
                a, b = mm[modi[i]], mm[modi[j]]
                comuni = [s for s in a["n_sim"] if s in b["n_sim"] and a["n_sim"][s] >= N_SIM_SEGNO and b["n_sim"][s] >= N_SIM_SEGNO]
                piu_b = sum(1 for s in comuni if b["pf_sim"][s] > a["pf_sim"][s])
                d = b["pf"] - a["pf"] if (a["pf"] == a["pf"] and b["pf"] == b["pf"]) else float("nan")
                migliore, peggiore, voti = (modi[j], modi[i], piu_b) if d == d and d > 0 else (modi[i], modi[j], len(comuni) - piu_b)
                g_m = mm[migliore]
                serve = math.ceil(SEGNO * len(comuni) - 1e-9)
                if d == d and abs(d) >= DPF_MODO and g_m["verdetto"] == "VIVO" and len(comuni) >= 2 and voti >= serve:
                    esito = "%s MIGLIORE di %s" % (migliore, peggiore)
                else:
                    esito = "NESSUNA DIFFERENZA DISTINGUIBILE"
                righe.append(((f, c, l), modi[i], modi[j], d, piu_b, len(comuni), esito))
    return righe


def determinismo(passate):
    visti, out = {}, []
    for P in passate:
        if P["ko"]:
            continue
        k = (P["sim"]["nome"], P["cfg"]["nome"], P["lato"]["nome"], P["modo"]["nome"])
        impronta = tuple(tuple(sorted(r.items())) for r in P["rows"])
        if k in visti:
            out.append((k, "IDENTICHE" if visti[k] == impronta else "DIVERSE"))
        else:
            visti[k] = impronta
    return out


# ---------------------------------------------------------------------------------------------------------------------
#  STAMPA
# ---------------------------------------------------------------------------------------------------------------------
def f2(x, n=2):
    if x is None or x != x:
        return "n.d."
    if x == float("inf"):
        return "inf"
    return ("%." + str(n) + "f") % x


def riepilogo(bl, passate, problemi, gambe, W):
    W("LETTORE NATCLA F1 -- EA_NatCla v%s, tre regole di stop, tick reali, SOLO l'IS. Soglie congelate nel file prova (T1-T7). NESSUNA promozione." % VERSIONE_EA)
    W("Guardian nel tester FAIL-OPEN: il DD qui NON e' ridotto da pausa B1 ne' da cap C1. Rischio per setup 0,25% = SEGNAPOSTO (si legge tutto in R).")
    for p in problemi:
        W("! PROBLEMA: " + p)
    W("")
    W("(1) AFFIDABILITA' DELLE PASSATE (una passata con un KO non entra in nessun numero)")
    nko = 0
    for P in passate:
        m = P["m"]
        stato = "OK" if not P["ko"] else "KO"
        nko += 1 if P["ko"] else 0
        W("   %-44s %-3s setup %-5s op %-6s %s" % (m["passata"], stato, len(P["rows"]) if not P["ko"] else "-", m.get("trades_report", ""), ("  | " + " | ".join(P["ko"])) if P["ko"] else ""))
        for x in P["guarda"]:
            W("        ! DA GUARDARE: " + x)
    W("   passate %d, KO %d" % (len(passate), nko))
    W("")
    W("(2)+(3)+(4) GAMBE = famiglia x config x lato x modo. n = setup riempiti. PF_R per setup DOPO la commissione derivata se il tester non la addebita (PF2 = commissione doppia).")
    W("   %-6s %-9s %-5s %-5s %5s %-26s %6s %6s %6s %7s %6s %6s %6s %7s %7s  %s" % ("fam", "config", "lato", "modo", "n", "n contro attesa", "PF_R", "PF2", "lordo", "mediaR", "p(>0)", "WR%", "DD_R", "peggioG", "dur_med", "verdetto"))
    for k in sorted(gambe):
        g = gambe[k]
        v = g["verdetto"]
        if g["verdetto2"] != v:
            v += "  [con la commissione DOPPIA: %s]" % g["verdetto2"]
        W("   %-6s %-9s %-5s %-5s %5d %-26s %6s %6s %6s %7s %6s %6s %6s %7s %7s  %s" % (k[0], k[1], k[2], k[3], g["n"], banda_n(g["n"], g["attesa"]) + " att %d" % g["attesa"], f2(g["pf"]), f2(g["pf2"]), f2(g["pf_lordo"]),
                                                                                f2(g["media"], 3), f2(g["pp"], 3), f2(g["wr"], 1), f2(g["dd"], 1), f2(g["peggio"], 2), f2(g["dur"], 0), v))
        W("        segno: PF_R > 1 in %d su %d simboli con n >= %d | per simbolo: %s" % (g["segno"][0], g["segno"][1], N_SIM_SEGNO, ", ".join("%s %s (n %d, att %d)" % (s, f2(g["pf_sim"][s]), g["n_sim"][s], g["att_sim"].get(s, 0)) for s in sorted(g["n_sim"]))))
        for s in sorted(g["n_sim"]):
            a_s = g["att_sim"].get(s, 0)
            if a_s > 0 and g["n_sim"][s] < STOP_N[0] * a_s:
                W("        ! DA GUARDARE (A1 per simbolo): %s ha n %d contro un'attesa di %d (< %.1fx): si cerca la causa prima di leggere la gamba" % (s, g["n_sim"][s], a_s, STOP_N[0]))
        W("        nullo sulla geometria vera (passeggiata casuale con questo pedaggio, DIAGNOSTICA): PF_R0 = %s%s ; PF_R - PF_R0 = %s" % (
            f2(g["pf_nullo"]), (" (%d setup senza geometria leggibile esclusi)" % g["nullo_saltati"]) if g["nullo_saltati"] else "", f2(g["pf"] - g["pf_nullo"]) if g["pf_nullo"] == g["pf_nullo"] else "n.d."))
        sp_ = stop_pieno(g)
        if sp_ is None:
            W("        R degli stop pieni (3 riempiti, uscita SL): nessuno in questa gamba")
        else:
            W("        R degli stop pieni (3 riempiti, uscita SL): n %d, mediana %s, il meno negativo %s, banda della mediana [%.2f ; %.2f]%s" % (
                sp_[0], f2(sp_[1], 3), f2(sp_[2], 3), BANDA_STOP_PIENO[0], BANDA_STOP_PIENO[1],
                "  ! DA GUARDARE: lotti arrotondati/troncati, R deformato (deposito, step, volume massimo): il PF_R pesa i setup diversamente dal dichiarato" if sp_[3] else "  ok"))
        rm1 = (MURO_DD / g["dd"]) if g["dd"] > 0 else float("inf")
        rm2 = (PAUSA_GIORNO / -g["peggio"]) if g["peggio"] < 0 else float("inf")
        W("        rischio (T6): r_max = 10%%/DD_R = %s%% ; 4%%/peggior giornata = %s%% per setup (segnaposto 0,25%%: la taglia e' di Claudio)   E1 durata: %s" % (f2(rm1), f2(rm2), ("FEDELE (<= 60 min)" if g["dur"] <= DUR_FEDELE else ("compatibile (60-180)" if g["dur"] <= DUR_COMPAT else "NON e' il metodo della collega (> 180 min)")) if g["dur"] == g["dur"] else "n.d."))
        if True in g["comm_tester"] and False in g["comm_tester"]:
            W("        ! DA GUARDARE: dentro la gamba il tester ha addebitato la commissione su alcune passate e su altre no")
    W("")
    W("(5) CONFRONTO DEI MODI (T5: migliore solo se VIVO, delta PF_R >= %.2f e segno concorde in >= 2/3 dei simboli con n >= %d in entrambi)." % (DPF_MODO, N_SIM_SEGNO))
    W("    Il nullo sposta il PF di +0,01/+0,05 da GEOM a LINEA a PIU SOLO per il costo (file prova A2): un delta sotto la soglia non distingue niente.")
    W("    [cancello 09/10] Per SETUP il nullo si sposta di piu' sui setup con la EMA200 oltre la ST3,5 (EURUSD GEOM 0,85 -> LINEA 0,88 -> PIU con 38 u 0,91;")
    W("    USDJPY fino a +0,08): accanto a ogni delta c'e' il delta del NULLO misurato sulla geometria vera delle due gambe. Il verdetto T5 resta quello congelato.")
    for (grp, a, b, d, piu_b, nc, esito) in confronta_modi(gambe):
        ga, gb = gambe.get((grp[0], grp[1], grp[2], a)), gambe.get((grp[0], grp[1], grp[2], b))
        dn = (gb["pf_nullo"] - ga["pf_nullo"]) if (ga and gb and ga["pf_nullo"] == ga["pf_nullo"] and gb["pf_nullo"] == gb["pf_nullo"]) else float("nan")
        W("   %-6s %-9s %-5s  %s -> %s: delta PF_R %s (delta del nullo %s), %s meglio in %d su %d simboli  => %s" % (grp[0], grp[1], grp[2], a, b, f2(d), f2(dn), b, piu_b, nc, esito))
    W("")
    W("(6) DETERMINISMO (stessa passata girata due volte, es. pilota contro lotto):")
    det = determinismo(passate)
    if not det:
        W("   nessuna passata ripetuta fra le sorgenti lette")
    for k, e in det:
        W("   %s: righe SETUP %s (nei numeri la passata conta UNA volta, la prima letta)" % (" ".join(k), e))
    W("")
    W("CERTIFICATO (T7): (1) PF misurato si', (2) n e DD si', (3) uscita ad asse NO (A1/A9 sono di F2), (4) gemelli: FX7 si', IDX3 si', ORO NO (argento fuori scala, domanda Q3),")
    W("(5) TF H1 e H4 si'. Quindi NESSUNA gamba e' 'morta' dopo F1: il verdetto massimo e' 'NON ANCORA MISURATO (manca la casella 3)'.")
    W("Regola T8 per F2 (file prova nuovo): assi pieni SOLO sulle gambe VIVE; sulle altre solo le due celle d'uscita A1 e A9.")


def tabella_csv(gambe, percorso):
    with open(percorso, "w", newline="") as f:
        w = csv.writer(f, delimiter=";")
        w.writerow(["famiglia", "config", "lato", "modo", "n", "attesa", "pf_r", "pf_r_comm_doppia", "pf_lordo", "media_r", "p_pos", "wr", "dd_r", "peggior_giornata_r", "durata_mediana", "verdetto", "verdetto_comm_doppia",
                    "pf_r_nullo", "stop_pieni_n", "stop_pieni_mediana_r"])
        for k in sorted(gambe):
            g = gambe[k]
            sp_ = stop_pieno(g)
            w.writerow(list(k) + [g["n"], g["attesa"], f2(g["pf"], 4), f2(g["pf2"], 4), f2(g["pf_lordo"], 4), f2(g["media"], 4), f2(g["pp"], 4), f2(g["wr"], 2), f2(g["dd"], 3), f2(g["peggio"], 3), f2(g["dur"], 1), g["verdetto"], g["verdetto2"],
                                  f2(g["pf_nullo"], 4), sp_[0] if sp_ else 0, f2(sp_[1], 4) if sp_ else "n.d."])


# ---------------------------------------------------------------------------------------------------------------------
#  AUTOTEST: dati finti con risposta nota + contro-esempi
# ---------------------------------------------------------------------------------------------------------------------
INTEST = ("tipo;barra;linea;lato;tocco_n;nuovo_ep;troncato;ctx_arm;ctx_tocco;vicino_ok;conferma_ok;dist_apertura_atr;adx;incl_atr;confl_dist_atr;confl_etichetta;ema9;ema21;"
          "bb_larg;atr14;linea_prezzo;ingresso;n_ordini;p1;p2;p3;sl;tp1;tp2;tp3;lotto1;lotto2;lotto3;spread;commissione;stop_ped1;stop_ped2;stop_ped3;rischio_soldi;"
          "n_riempiti;esito_soldi;esito_R;durata_min;motivo;stop_modo;linea_stop;stop_esito")
MANI = ("lotto;passata;simbolo;config;lato;modo;magic;soglia_incl;da;a;t_avvio;durata_s;stato;trades_report;profitto_report;pf_report;qualita;deposito;ticks_report;barre_gen;"
        "ticks_inizio;setup_righe;riempiti_somma;soldi_somma;invio_fallito;lotto_min;semaforo;imbuto_rotte;righe_ea;avvio_ok;adx_verifica;finestra;motivi")


def riga_setup(bl, sim, cfg, lato, modo, barra, esito_r, linea="ST35", nfill=2, risk=2500.0, dur=45.0, motivo=None, lv=None, sl_sbagliato=False, ls_extra=0.0):
    s = int(bl["LATO"][lato]["segno"])
    S = bl["SIMBOLO"][sim]
    u = float(S["u"])
    dg = 2 if S["classe"] in ("ORO", "IDX") else (3 if u == 0.01 else 5)
    lv = lv if lv is not None else (2400.0 if S["classe"] == "ORO" else (150.0 if u == 0.01 else 1.10000))
    p = [lv + s * 5 * u, lv, lv - s * 5 * u]
    mv = bl["MODO"][modo]["valore"]
    if mv == "0":
        sl, ls, es = p[2] - s * 5 * u, 0.0, "0"
    else:
        ls = lv - s * ls_extra * u
        sl, es = ls - s * 20 * u, "0"
    if sl_sbagliato:
        sl -= s * 1 * u
    soldi = esito_r * risk
    lin = linea if linea in cfg_linee(bl, cfg) else cfg_linee(bl, cfg)[0]
    fmt = "%." + str(dg) + "f"
    campi = {"tipo": "SETUP", "barra": barra, "linea": lin, "lato": str(s), "tocco_n": "1", "dist_apertura_atr": "0.000", "adx": "15.00", "incl_atr": "0.900", "confl_dist_atr": "1.000",
             "confl_etichetta": "0", "ema9": "0", "ema21": "0", "bb_larg": "0", "atr14": fmt % (10 * u), "linea_prezzo": fmt % lv, "ingresso": "SCALA3", "n_ordini": "3",
             "p1": fmt % p[0], "p2": fmt % p[1], "p3": fmt % p[2], "sl": fmt % sl, "tp1": fmt % (lv + s * 10 * u), "tp2": fmt % (lv + s * 10 * u), "tp3": fmt % (lv + s * 10 * u),
             "lotto1": "1.00", "lotto2": "1.00", "lotto3": "1.00", "spread": fmt % (0.5 * u), "commissione": "0", "stop_ped1": "50.0", "stop_ped2": "40.0", "stop_ped3": "30.0",
             "rischio_soldi": "%.2f" % risk, "n_riempiti": str(nfill), "esito_soldi": "%.2f" % soldi, "esito_R": "%.3f" % (soldi / risk), "durata_min": "%.1f" % dur,
             "motivo": motivo or ("TP" if esito_r > 0 else "SL"), "stop_modo": mv, "linea_stop": fmt % ls if mv != "0" else "0", "stop_esito": es}
    return ";".join(campi.get(h, "") for h in INTEST.split(";"))


def cfg_linee(bl, cfg):
    return bl["CONFIG"][cfg]["linee"].split(",")


def costruisci(cartella, bl, prova_txt, passate, lotto="P"):
    """passate: lista di dict(sim, cfg, lato, modo, esiti[list R], ...opzioni). Scrive una cartella con la forma dello zip del driver."""
    os.makedirs(cartella, exist_ok=True)
    for d in ("csv", "report", "log", "trades", "ini"):
        os.makedirs(os.path.join(cartella, d), exist_ok=True)
    open(os.path.join(cartella, NOME_PROVA), "w").write(prova_txt)
    man = [MANI]
    for i, q in enumerate(passate):
        sim, cfg, lato, modo = q["sim"], q["cfg"], q["lato"], q["modo"]
        S, C = bl["SIMBOLO"][sim], bl["CONFIG"][cfg]
        tag = "%s_%03d_%s_%s_%s_%s" % (lotto, i + 1, sim, cfg, lato, modo)
        soglia = q.get("soglia", bl["INCL"][(S["famiglia"], cfg)])
        stop_att = STOP_AVVIO[bl["MODO"][modo]["valore"]]
        righe = []
        d0 = datetime.datetime(2024, 8, 1, 10, 0)
        for j, x in enumerate(q["esiti"]):
            barra = (d0 + datetime.timedelta(hours=7 * j)).strftime("%Y.%m.%d %H:%M")
            righe.append(riga_setup(bl, sim, cfg, lato, modo, barra, x, nfill=q.get("nfill", 2), sl_sbagliato=(q.get("sl_sbagliato") and j == 0), ls_extra=q.get("ls_extra", 0.0)))
        if q.get("lato_riga_sbagliato") and righe:
            c = righe[0].split(";")
            c[3] = str(-int(c[3]))
            righe[0] = ";".join(c)
        avvio = "#AVVIO v%s | modalita' %s | %s PERIOD_%s | 1 u = %s (AUTO_CLASSE) | 1 pip = 0 | magic %s | linee %s | ADX x | ingresso SCALA3_PENDENTI | rischio setup 0.25%% | guardian ON | solo conta %s | placebo 0.00 ATR | fonte | stop %s" % (
            q.get("versione", VERSIONE_EA), "EMA200" if C["modalita"] == "2" else "AUDIO", sim, C["periodo"], S["u"], C["magic"], " ".join(C["linee"].split(",")), "SI" if q.get("conta") else "no", stop_att)
        testo = [avvio, "#cfg;InpDirezione;%s;x" % bl["LATO"][lato]["cfg"], "#cfg;Inclinazione;ACCESA, N 20, soglia %s ATR, verso NC_INCL_QUALSIASI;x" % soglia, "#cfg;Stop;%s;x" % stop_att, INTEST] + righe
        if q.get("conta"):
            testo.append("CONTA;" + ";".join("0" for _ in range(len(INTEST.split(";")) - 1)))
        open(os.path.join(cartella, "csv", tag + ".csv"), "w").write("\r\n".join(testo) + "\r\n")
        soldi = sum(float(r.split(";")[INTEST.split(";").index("esito_soldi")]) for r in righe)
        riemp = sum(int(r.split(";")[INTEST.split(";").index("n_riempiti")]) for r in righe)
        trades = riemp + q.get("trades_extra", 0)
        prof = soldi + q.get("profitto_extra", 0.0)
        dep = q.get("deposito", "1 000 000.00")
        qual = q.get("qualita", "100% ticks reali")
        comm = q.get("comm_deal", "0.00")
        rep = ("<html><table><tr><td>Expert:</td><td>EA_NatCla</td></tr><tr><td>Simbolo:</td><td>%s</td></tr><tr><td>Periodo:</td><td>%s (%s - 2025.06.30)</td></tr>"
               "<tr><td>Qualit\u00e0 dello Storico:</td><td>%s</td></tr><tr><td>Deposito Iniziale:</td><td>%s</td></tr><tr><td>Profitto Totale Netto:</td><td>%.2f</td></tr>"
               "<tr><td>Fattore di Profitto:</td><td>1.00</td></tr><tr><td>Numero di Operazioni di Trading Totali:</td><td>%d</td></tr>"
               "<tr><td>2024.08.01 10:00:00</td><td>2</td><td>%s</td><td>buy</td><td>in</td><td>1.00</td><td>1.1</td><td>2</td><td>%s</td><td>0.00</td><td>0.00</td><td>1000000.00</td><td>NATCLA_A_ST35_O1</td></tr>"
               "</table></html>") % (sim, C["periodo"], S["da"], qual, dep, prof, trades, sim, comm)
        open(os.path.join(cartella, "report", tag + ".htm"), "wb").write(rep.encode("utf-16"))
        ver = q.get("verifica", "formula MetaQuotes (DI per barra)")
        log = ["# passata", "2024.07.05 00:00:00   [NatCla] AVVIO v%s | x | stop %s" % (VERSIONE_EA, stop_att),
               "2024.07.05 00:00:00   [NatCla] VERIFICA ADX barra 2024.07.05 10:00 periodo 14: terminale iADX = 20.00 | ricalcolo MetaQuotes = 20.00 | ricalcolo Wilder = 18.00 -> il terminale coincide con: " + ver]
        for j in range(q.get("lotto_min", 0)):
            log.append("2024.07.0%d 00:00:00   [NatCla] SCARTATO ST35 O1: lotto sotto il minimo (mai alzato al minimo)" % (6 + j))
        for j in range(q.get("invio_altro", 0)):
            log.append("2024.07.0%d 01:00:00   [NatCla] INVIO FALLITO NATCLA_A_ST35_O1: retcode 10015 Invalid price" % (6 + j))
        open(os.path.join(cartella, "log", tag + ".txt"), "w").write("\r\n".join(log) + "\r\n")
        man.append(";".join([lotto, tag, sim, cfg, lato, modo, C["magic"], soglia, S["da"], "2025.06.30", "2026-10-10 10:00:00", "120", q.get("stato", "OK"), str(trades), "%.2f" % prof, "1.00", qual,
                             "1000000.00", "1", "6000", "", str(len(righe)), str(riemp), "%.2f" % soldi, "0", "0", "0", "0", "10", "si", "MetaQuotes", "x", q.get("motivi", "")]))
    open(os.path.join(cartella, "MANIFEST_F1.csv"), "w").write("\r\n".join(man) + "\r\n")


def autotest():
    prova_txt = open(PROVA_REPO, encoding="ascii").read()
    bl = leggi_blocchi(prova_txt)
    fallite = []
    nctl = [0]

    def ok(cond, nome):
        nctl[0] += 1
        if not cond:
            fallite.append(nome)
            print("   FALLITO: " + nome)

    # --- 0. i blocchi del file prova
    ok(len(bl["CONFIG"]) == 4 and len(bl["MODO"]) == 3 and len(bl["LATO"]) == 2 and len(bl["SIMBOLO"]) == 11 and len(bl["INCL"]) == 12 and len(bl["LOTTO"]) == 5, "blocchi del file prova contati")
    ok(len(bl["ATTESA"]) == 44, "44 attese (11 simboli x 4 config)")
    ok(bl["CONFIG"]["M2_H1"]["modi"] == "GEOM,LINEA" and bl["CONFIG"]["AUDIO_H1"]["modi"] == "GEOM,LINEA,PIU", "M2 senza PIU (identico a LINEA)")
    fx = [s for s, v in bl["SIMBOLO"].items() if v["famiglia"] == "FX7"]
    ok(sorted(fx) == sorted(["EURUSD", "GBPUSD", "USDJPY", "AUDUSD", "NZDUSD", "USDCAD", "USDCHF"]), "FX7 = i 7 maggiori")
    ok("XAGUSD" not in bl["SIMBOLO"] and "NASUSD" not in bl["SIMBOLO"] and "D30EUR" not in bl["SIMBOLO"], "argento, NASUSD, D30EUR fuori (S2)")
    # conto delle passate per lotto (stessa regola del driver: prodotto, modi non ammessi saltati)
    tot = 0
    for nome, L in bl["LOTTO"].items():
        if "passate" in L:
            n = len(L["passate"].split(","))
        else:
            n = 0
            for c in L["configs"].split(","):
                am = bl["CONFIG"][c]["modi"].split(",")
                n += len(L["simboli"].split(",")) * len(L["lati"].split(",")) * len([m for m in L["modi"].split(",") if m in am])
        tot += n
        ok(n == {"P": 4, "O": 20, "FA": 80, "FB": 60, "I": 36}[nome], "passate del lotto %s = %d" % (nome, n))
    ok(tot == 200, "tetto S4: 200 passate in tutto")
    att = sum(v[0] for (s, c), v in bl["ATTESA"].items() if bl["SIMBOLO"][s]["famiglia"] == "FX7" and c == "AUDIO_H1")
    ok(att == 475, "attesa FX7 AUDIO_H1 LONG = 475 (somma dei blocchi = numero scritto nell'intestazione)")

    base = tempfile.mkdtemp(prefix="natcla_f1_")
    # --- 1. una passata con risposta nota: R = +0,5 x 6, -1 x 2 -> PF 1,5, DD 2,0 (le due perdite in fila), n 8
    d1 = os.path.join(base, "uno")
    costruisci(d1, bl, prova_txt, [dict(sim="XAUUSD", cfg="AUDIO_H1", lato="LONG", modo="GEOM", esiti=[0.5, 0.5, -1.0, -1.0, 0.5, 0.5, 0.5, 0.5])])
    b1, pas, pr = carica([d1])
    ok(not pr and len(pas) == 1 and not pas[0]["ko"], "passata pulita = nessun KO (%s)" % (pas[0]["ko"] if pas else pr))
    gm1 = calcola(b1, pas)
    g = gm1.get(("ORO", "AUDIO_H1", "LONG", "GEOM"))
    ok(g is not None and g["n"] == 8, "n = 8 righe SETUP")
    ok(g is not None and abs(g["pf_lordo"] - 1.5) < 1e-9, "PF lordo 1,5")
    ok(g is not None and g["pf"] < 1.5, "commissione derivata applicata (tester a 0): PF_R < PF lordo")
    ok(g is not None and abs(g["dd"] - (2.0 + 2 * (0.04 * 2 / 30.0))) < 1e-6, "DD_R = 2 perdite in fila + la loro commissione (%.6f)" % (g["dd"] if g else -1))
    ok(g is not None and g["verdetto"] == "SOTTILE", "n 8 < 150 = SOTTILE")
    # commissione per setup: oro, 2 riempiti, distanze 15+10+5 = 30 USD -> 2 x 0,04 / 30
    ok(abs(comm_r(pas[0]["rows"][0], b1["SIMBOLO"]["XAUUSD"]) - 0.08 / 30.0) < 1e-12, "comm_r oro = riempiti x 0,04 / somma distanze")

    # --- 2. contro-esempi: ognuno deve dare KO
    casi = [
        ("lato sbagliato in una riga", dict(lato_riga_sbagliato=True), "righe SETUP incoerenti"),
        ("SL a 1 u dalla regola", dict(sl_sbagliato=True), "non a 20 u oltre"),
        ("profitto del report diverso dagli esiti", dict(profitto_extra=9000.0), "profitto del report"),
        ("operazioni del report > riempiti + 3", dict(trades_extra=4), "operazioni del report"),
        ("qualita 99%", dict(qualita="99% ticks reali"), "qualita dello storico"),
        ("deposito 100000", dict(deposito="100 000.00"), "deposito del report"),
        ("righe CONTA (SOLO CONTA)", dict(conta=True), "solo conta"),
        ("soglia d'inclinazione diversa", dict(soglia="0.500"), "soglia d'inclinazione"),
        ("VERIFICA ADX Wilder", dict(verifica="formula di Wilder"), "VERIFICA ADX"),
        ("lotto sotto il minimo", dict(lotto_min=1), "lotto sotto il minimo"),
        ("versione 1.10", dict(versione="1.10"), "#AVVIO del CSV"),
        ("KO del driver", dict(stato="KO", motivi="timeout"), "KO del driver"),
    ]
    casi.append(("GEOM: SL a 1 u dall'ordine profondo + 5", dict(sl_sbagliato=True, modo="GEOM"), "GEOMETRIA_ATTUALE: SL"))
    for nome, opz, chiave in casi:
        dd = os.path.join(base, "ko_" + re.sub(r"\W", "_", nome))
        q = dict(sim="EURUSD", cfg="AUDIO_H1", lato="SHORT", modo="LINEA", esiti=[0.3, -1.0, 0.3])
        q.update(opz)
        costruisci(dd, bl, prova_txt, [q])
        _b, pp, _p = carica([dd])
        ok(len(pp) == 1 and pp[0]["ko"] and any(chiave.lower() in x.lower() for x in pp[0]["ko"]), "contro-esempio '%s' -> KO per il motivo giusto (%s)" % (nome, pp[0]["ko"] if pp else "-"))
    # e uno che NON deve dare KO ma DA GUARDARE
    dg = os.path.join(base, "guarda")
    costruisci(dg, bl, prova_txt, [dict(sim="EURUSD", cfg="AUDIO_H1", lato="SHORT", modo="LINEA", esiti=[0.3], invio_altro=2)])
    _b, pp, _p = carica([dg])
    ok(not pp[0]["ko"] and pp[0]["guarda"], "INVIO FALLITO 10015 = DA GUARDARE, non KO")
    # un setup aperto a fine test: 3 operazioni in piu' e profitto entro 2 rischi = OK
    da = os.path.join(base, "aperto")
    costruisci(da, bl, prova_txt, [dict(sim="EURUSD", cfg="AUDIO_H1", lato="SHORT", modo="LINEA", esiti=[0.3, 0.3], trades_extra=3, profitto_extra=-2500.0)])
    _b, pp, _p = carica([da])
    ok(not pp[0]["ko"], "setup aperto a fine test (3 operazioni e -1 R senza riga SETUP) = OK")
    # PIU con la EMA200 oltre la ST3,5: linea dello stop piu' esterna di 30 u = OK; LINEA con linea dello stop diversa dalla ST3,5 = KO
    dp = os.path.join(base, "piu")
    costruisci(dp, bl, prova_txt, [dict(sim="EURUSD", cfg="AUDIO_H1", lato="LONG", modo="PIU", esiti=[0.3, -1.0], ls_extra=30.0)])
    _b, pp, _p = carica([dp])
    ok(not pp[0]["ko"], "PIU con linea dello stop 30 u piu' esterna = OK")
    dl = os.path.join(base, "linea_ko")
    costruisci(dl, bl, prova_txt, [dict(sim="EURUSD", cfg="AUDIO_H1", lato="LONG", modo="LINEA", esiti=[0.3, -1.0], ls_extra=30.0)])
    _b, pp, _p = carica([dl])
    ok(pp[0]["ko"], "LINEA con linea dello stop che non e' la ST3,5 = KO")
    dpk = os.path.join(base, "piu_dentro")
    costruisci(dpk, bl, prova_txt, [dict(sim="EURUSD", cfg="AUDIO_H1", lato="LONG", modo="PIU", esiti=[0.3, -1.0], ls_extra=-3.0)])
    _b, pp, _p = carica([dpk])
    ok(pp[0]["ko"], "PIU con linea dello stop DENTRO la ST3,5 = KO")

    # --- 3. verdetti di gamba, con risposta nota (FX7, 7 simboli, n per simbolo 30 -> 210)
    def gamba(cartella, pf_target_per_sim, modo="LINEA", lato="LONG", nps=30, comm_deal="0.00"):
        qq = []
        for s, (w, l) in pf_target_per_sim.items():
            # w vincite da +0,4 e l perdite da -1: PF = 0,4 w / l
            es = [0.4] * w + [-1.0] * l
            es = (es * ((nps // len(es)) + 1))[:nps]
            qq.append(dict(sim=s, cfg="AUDIO_H1", lato=lato, modo=modo, esiti=es, comm_deal=comm_deal))
        costruisci(cartella, bl, prova_txt, qq)
        b, pp, _p = carica([cartella])
        return calcola(b, pp), pp
    sette = ["EURUSD", "GBPUSD", "USDJPY", "AUDUSD", "NZDUSD", "USDCAD", "USDCHF"]
    # PF ~2,0 (8 vincite, 1 perdita, 0,4 x 8 = 3,2 / 1... troppo); usiamo w=9, l=2 -> PF 1,8
    gm, _ = gamba(os.path.join(base, "vivo"), {s: (9, 2) for s in sette}, comm_deal="-1.00")
    gv = gm[("FX7", "AUDIO_H1", "LONG", "LINEA")]
    ok(gv["n"] == 210 and gv["verdetto"] == "VIVO", "PF ~1,8, n 210, 7 simboli su 7 positivi = VIVO (%s, PF %.3f, p %s)" % (gv["verdetto"], gv["pf"], gv["pp"]))
    ok(gv["comm_tester"] == [True] and abs(gv["pf"] - gv["pf_lordo"]) < 1e-12, "commissione addebitata dal tester: nessuna sottrazione")
    gm, _ = gamba(os.path.join(base, "segno"), {**{s: (9, 2) for s in sette[:4]}, **{s: (2, 1) for s in sette[4:]}}, comm_deal="-1.00")
    gs = gm[("FX7", "AUDIO_H1", "LONG", "LINEA")]
    ok(gs["segno"] == (4, 7) and gs["verdetto"] != "VIVO", "4 simboli su 7 positivi < 2/3 = NON VIVO anche con PF alto (%s, PF %.3f)" % (gs["verdetto"], gs["pf"]))
    gm, _ = gamba(os.path.join(base, "perd"), {s: (1, 1) for s in sette}, comm_deal="-1.00")
    gp = gm[("FX7", "AUDIO_H1", "LONG", "LINEA")]
    ok(gp["verdetto"] == "PERDENTE MISURATO", "PF 0,4, n 210 = PERDENTE MISURATO (%s)" % gp["verdetto"])
    gm, _ = gamba(os.path.join(base, "nd"), {s: (5, 2) for s in sette}, comm_deal="-1.00")
    gn = gm[("FX7", "AUDIO_H1", "LONG", "LINEA")]
    ok(gn["verdetto"] == "NON DISTINGUIBILE", "PF 1,0 = NON DISTINGUIBILE (%s, PF %.3f)" % (gn["verdetto"], gn["pf"]))
    # PF 1,10 con n 3150 (p < 0,05, segno 7 su 7): sotto la soglia 1,15 = NON DISTINGUIBILE (contro-esempio della soglia T2)
    gm, _ = gamba(os.path.join(base, "pf110"), {s: (11, 4) for s in sette}, nps=450, comm_deal="-1.00")
    g110 = gm[("FX7", "AUDIO_H1", "LONG", "LINEA")]
    ok(abs(g110["pf"] - 1.1) < 0.01 and g110["pp"] is not None and g110["pp"] < 0.05 and g110["verdetto"] == "NON DISTINGUIBILE",
       "PF 1,10 significativo (p %s) ma sotto 1,15 = NON DISTINGUIBILE (%s)" % (f2(g110["pp"], 4), g110["verdetto"]))
    # il segno conta solo simboli con n >= 30: 6 simboli con n 25 + 1 con n 60 -> votanti 1 -> segno NON ok
    qq = []
    for s in sette:
        nps = 60 if s == "EURUSD" else 25
        qq.append(dict(sim=s, cfg="AUDIO_H1", lato="SHORT", modo="GEOM", esiti=([0.4] * 9 + [-1.0] * 2) * 6, comm_deal="-1.00"))
        qq[-1]["esiti"] = qq[-1]["esiti"][:nps]
    dn = os.path.join(base, "votanti")
    costruisci(dn, bl, prova_txt, qq)
    b, pp, _p = carica([dn])
    gm2 = calcola(b, pp)
    gq = gm2[("FX7", "AUDIO_H1", "SHORT", "GEOM")]
    ok(gq["segno"][1] == 1 and gq["verdetto"] != "VIVO", "un solo simbolo votante (n >= 30): la regola del segno NON e' soddisfatta (%s)" % (gq["segno"],))
    # la commissione derivata che cambia il verdetto si scrive: forex, PF lordo appena sopra 1,15 -> con la doppia sotto
    # (EURUSD: c = 0,00004 x 1,1 = 0,000044; distanze 25+20+15 = 60 pip = 0,0060; c_R = 2 x 0,000044/0,0060 = 0,01467 per setup)
    gm, _ = gamba(os.path.join(base, "comm"), {s: (13, 4) for s in sette}, nps=60)
    gc = gm[("FX7", "AUDIO_H1", "LONG", "LINEA")]
    ok(gc["pf_lordo"] > gc["pf"] > gc["pf2"], "commissione derivata: PF lordo > PF_R > PF2 (%.3f %.3f %.3f)" % (gc["pf_lordo"], gc["pf"], gc["pf2"]))
    # --- 4. il conto e' per SETUP: 100 righe da 3 riempiti e 300 operazioni nel report -> n = 100
    d3 = os.path.join(base, "unita")
    q = dict(sim="EURUSD", cfg="M2_H1", lato="LONG", modo="GEOM", esiti=[0.2] * 100)
    costruisci(d3, bl, prova_txt, [q])
    # riscrive i riempiti a 3 e le operazioni a 300
    cp = os.path.join(d3, "csv", os.listdir(os.path.join(d3, "csv"))[0])
    t = open(cp).read().replace(";2;", ";3;")
    open(cp, "w").write(t)
    rp = os.path.join(d3, "report", os.listdir(os.path.join(d3, "report"))[0])
    tr = open(rp, "rb").read().decode("utf-16").replace("<td>200</td>", "<td>300</td>")
    open(rp, "wb").write(tr.encode("utf-16"))
    b, pp, _p = carica([d3])
    ok(not pp[0]["ko"] and len(pp[0]["rows"]) == 100, "100 setup da 3 ordini e 300 operazioni: n = 100 SETUP, non 300 (%s)" % pp[0]["ko"])
    # --- 5. confronto dei modi
    gmA, _ = gamba(os.path.join(base, "mA"), {s: (5, 2) for s in sette}, modo="GEOM", comm_deal="-1.00")
    gmB, _ = gamba(os.path.join(base, "mB"), {s: (9, 2) for s in sette}, modo="LINEA", comm_deal="-1.00")
    gmC, _ = gamba(os.path.join(base, "mC"), {s: (10, 2) for s in sette}, modo="PIU", comm_deal="-1.00")
    tutte = {}
    tutte.update(gmA); tutte.update(gmB); tutte.update(gmC)
    cm = {(a, b): e for (_g, a, b, _d, _p, _n, e) in confronta_modi(tutte)}
    ok(cm[("GEOM", "LINEA")] == "LINEA MIGLIORE di GEOM", "LINEA (PF 1,8, VIVO) contro GEOM (PF 1,0): MIGLIORE (%s)" % cm[("GEOM", "LINEA")])
    dlp = tutte[("FX7", "AUDIO_H1", "LONG", "PIU")]["pf"] - tutte[("FX7", "AUDIO_H1", "LONG", "LINEA")]["pf"]
    ok(abs(dlp) < DPF_MODO and cm[("LINEA", "PIU")] == "NESSUNA DIFFERENZA DISTINGUIBILE", "PIU contro LINEA: delta sotto 0,10 = NESSUNA DIFFERENZA (%s, delta %.3f)" % (cm[("LINEA", "PIU")], dlp))
    # contro-esempio di T5: stesso delta grande ma il modo migliore NON e' vivo (n sotto 150) -> nessuna differenza
    gmS, _ = gamba(os.path.join(base, "mS"), {s: (9, 2) for s in sette[:4]}, modo="PIU", comm_deal="-1.00")
    gmG, _ = gamba(os.path.join(base, "mG"), {s: (5, 2) for s in sette[:4]}, modo="GEOM", comm_deal="-1.00")
    t2 = {}
    t2.update(gmS); t2.update(gmG)
    cm2 = {(a, b): e for (_g, a, b, _d, _p, _n, e) in confronta_modi(t2)}
    ok(t2[("FX7", "AUDIO_H1", "LONG", "PIU")]["n"] == 120 and cm2[("GEOM", "PIU")] == "NESSUNA DIFFERENZA DISTINGUIBILE", "delta grande ma n 120 (SOTTILE): NESSUNA DIFFERENZA (%s)" % cm2[("GEOM", "PIU")])
    # --- 6. determinismo: stessa passata in due cartelle -> IDENTICHE; un esito diverso -> DIVERSE
    e1, e2, e3 = os.path.join(base, "d1"), os.path.join(base, "d2"), os.path.join(base, "d3")
    costruisci(e1, bl, prova_txt, [dict(sim="XAUUSD", cfg="AUDIO_H1", lato="LONG", modo="PIU", esiti=[0.5, -1.0])], lotto="P")
    costruisci(e2, bl, prova_txt, [dict(sim="XAUUSD", cfg="AUDIO_H1", lato="LONG", modo="PIU", esiti=[0.5, -1.0])], lotto="O")
    costruisci(e3, bl, prova_txt, [dict(sim="XAUUSD", cfg="AUDIO_H1", lato="LONG", modo="PIU", esiti=[0.5, -0.9])], lotto="O")
    _b, pp, _p = carica([e1, e2])
    ok(determinismo(pp) == [(("XAUUSD", "AUDIO_H1", "LONG", "PIU"), "IDENTICHE")], "determinismo: IDENTICHE")
    _b, pp, _p = carica([e1, e3])
    ok(determinismo(pp) == [(("XAUUSD", "AUDIO_H1", "LONG", "PIU"), "DIVERSE")], "determinismo: DIVERSE")
    # [cancello 09/10] pilota + lotto letti insieme: la passata ripetuta conta UNA volta (n 2, non 4)
    bd, pd_, _p = carica([e1, e2])
    ok(calcola(bd, pd_)[("ORO", "AUDIO_H1", "LONG", "PIU")]["n"] == 2, "pilota + lotto insieme: la passata ripetuta non raddoppia n")
    # --- 7. la banda di n e la parola vietata
    ok(banda_n(475, 475).startswith("COERENTE") and banda_n(100, 475).startswith("DA GUARDARE") and banda_n(30, 475).startswith("STOP"), "banda di n contro le attese")
    buf = io.StringIO()
    riepilogo(b1, pas, [], gm1, lambda s: buf.write(s + "\n"))
    testo_out = buf.getvalue()
    ok("NON ANCORA MISURATO" in testo_out and "SOTTILE" in testo_out, "la stampa dice SOTTILE e 'NON ANCORA MISURATO' (certificato)")
    ok(all(g["verdetto"] in VERDETTI for g in gm.values()), "verdetti solo nell'elenco chiuso (nessun 'morto')")
    # --- 8. [cancello 09/10] il nullo sulla geometria vera, contro i numeri gia' scritti da altri (file prova A2, per ORDINE, EURUSD c 0,67 pip)
    def pfn(x):
        return x[0] / x[1] if x else float("nan")
    ok(abs(pfn(nullo_setup(1, [(5, 1), (0, 0), (-5, 0)], -10, 10, 0.67)) - 0.83) < 0.005, "nullo, solo anticipo GEOM = A2 0,83")
    ok(abs(pfn(nullo_setup(1, [(5, 0), (0, 1), (-5, 0)], -10, 10, 0.67)) - 0.87) < 0.005, "nullo, solo linea GEOM = A2 0,87")
    ok(abs(pfn(nullo_setup(1, [(5, 0), (0, 0), (-5, 1)], -10, 10, 0.67)) - 0.84) < 0.005, "nullo, solo profondo GEOM = A2 0,84")
    ok(abs(pfn(nullo_setup(1, [(5, 0), (0, 1), (-5, 0)], -20, 10, 0.67)) - 0.90) < 0.005, "nullo, solo linea LINEA = A2 0,90")
    geo = pfn(nullo_setup(1, [(5, 1), (0, 1), (-5, 1)], -10, 10, 0.67))
    lin = pfn(nullo_setup(1, [(5, 1), (0, 1), (-5, 1)], -20, 10, 0.67))
    piu = pfn(nullo_setup(1, [(5, 1), (0, 1), (-5, 1)], -58, 10, 0.67))
    ok(0.84 < geo < 0.85 and 0.875 < lin < 0.885 and 0.90 < piu < 0.91, "nullo per SETUP (scala intera) GEOM/LINEA/PIU38 = 0,846/0,881/0,905 (Monte Carlo 0,842/0,872/0,894) (%.4f %.4f %.4f)" % (geo, lin, piu))
    ok(piu - geo > 0.05, "contro-esempio di A2: per setup con la EMA200 oltre, il nullo si sposta di PIU' di +0,05 (%.3f)" % (piu - geo))
    ok(abs(pfn(nullo_setup(-1, [(-5, 1), (0, 1), (5, 1)], 10, -10, 0.67)) - geo) < 1e-12, "nullo: lo SHORT e' lo specchio del LONG")
    ok(nullo_setup(1, [(5, 1), (0, 1), (-5, 1)], -10, 4, 0.67) is None and nullo_setup(1, [(5, 1)], 6, 10, 0.67) is None, "nullo: TP non oltre il primo ordine o SL non sotto gli ordini = geometria non leggibile")
    rr0 = pas[0]["rows"][0]
    ok(nullo_riga(rr0, b1["SIMBOLO"]["XAUUSD"]) is not None and gm1[("ORO", "AUDIO_H1", "LONG", "GEOM")]["nullo_saltati"] == 0, "nullo letto dalle righe SETUP del lettore")
    # --- 9. [cancello 09/10] R degli stop pieni: -1,0 R = ok; -0,56 R (il PIU a 100.000 EUR del file prova) = DA GUARDARE
    for nome, rsl, atteso in (("pieni ok", -1.0, False), ("pieni deformati", -0.56, True)):
        dsp = os.path.join(base, re.sub(r"\W", "_", nome))
        costruisci(dsp, bl, prova_txt, [dict(sim="XAUUSD", cfg="AUDIO_H1", lato="LONG", modo="PIU", esiti=[0.3, rsl, 0.3, rsl], nfill=3)])
        bsp, psp, _p = carica([dsp])
        gsp = calcola(bsp, psp)[("ORO", "AUDIO_H1", "LONG", "PIU")]
        sp_ = stop_pieno(gsp)
        bufp = io.StringIO()
        riepilogo(bsp, psp, [], {("ORO", "AUDIO_H1", "LONG", "PIU"): gsp}, lambda s: bufp.write(s + "\n"))
        ok(sp_ is not None and sp_[0] == 2 and sp_[3] == atteso and (("lotti arrotondati" in bufp.getvalue()) == atteso), "stop pieni: %s (%s)" % (nome, sp_))
    # --- 10. [cancello 09/10] un simbolo con ZERO setup resta nella gamba: n 0 accanto alla sua attesa, e la banda A1 lo vede
    dz = os.path.join(base, "zero")
    costruisci(dz, bl, prova_txt, [dict(sim="EURUSD", cfg="AUDIO_H1", lato="LONG", modo="LINEA", esiti=[0.3] * 62), dict(sim="GBPUSD", cfg="AUDIO_H1", lato="LONG", modo="LINEA", esiti=[])])
    bz, pz, _p = carica([dz])
    gz = calcola(bz, pz)[("FX7", "AUDIO_H1", "LONG", "LINEA")]
    bufz = io.StringIO()
    riepilogo(bz, pz, [], {("FX7", "AUDIO_H1", "LONG", "LINEA"): gz}, lambda s: bufz.write(s + "\n"))
    ok(not any(P["ko"] for P in pz) and gz["n_sim"].get("GBPUSD") == 0 and gz["attesa"] == 62 + 70 and "A1 per simbolo): GBPUSD" in bufz.getvalue(),
       "simbolo a zero setup: nella gamba con n 0, attesa 62+70, segnalato (%s, att %d)" % (gz["n_sim"], gz["attesa"]))
    print("AUTOTEST: %d controlli, %d falliti" % (nctl[0], len(fallite)))
    return 1 if fallite else 0


def main():
    a = sys.argv[1:]
    if "--autotest" in a:
        sys.exit(autotest())
    prova_txt, csv_out, percorsi = None, None, []
    i = 0
    while i < len(a):
        if a[i] == "--prova":
            prova_txt = open(a[i + 1], encoding="ascii").read()
            i += 2
            continue
        if a[i] == "--csv-out":
            csv_out = a[i + 1]
            i += 2
            continue
        percorsi.append(a[i])
        i += 1
    if not percorsi:
        print(__doc__)
        sys.exit(2)
    bl, passate, problemi = carica(percorsi, prova_txt)
    gambe = calcola(bl, passate)
    riepilogo(bl, passate, problemi, gambe, print)
    if csv_out:
        tabella_csv(gambe, csv_out)
        print("tabella delle gambe scritta in " + csv_out)


if __name__ == "__main__":
    main()
