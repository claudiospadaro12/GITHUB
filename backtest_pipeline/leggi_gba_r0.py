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
  (v5) opzioni della lettura per regime (decisioni APERTE di Claudio; default = lettura letterale della firma 10/10, report/FIRME_2026-10-10.md):
     --durata-regime 1anno|365giorni|2trimestri   (default 1anno = 4 trimestri; 2trimestri = la regola scritta nel file prova R2REG)
     --lato-sotto-150 giudica|non_misurato        (default giudica: la soglia 150 e' sul regime, ogni lato conta col suo n)
     --dd-promesso <EUR>                           (default assente: nessun verdetto di regime puo' cominciare con 'regge')
  (v5) legge anche gli zip dei file prova DICHIARATIVI del driver v5 (@GBA-ASSE: qualunque input come asse, simbolo/TF per passata) e si ferma con ERRORE
  se la stessa misura (stessa cella, tranche, magic: confronto sugli ini) e' caricata due volte.

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


def a_esclusiva(lotto):
    """(v5) 'a' esclusiva per R2REG e per OGNI lotto di un file prova dichiarativo (e' il comportamento vero del tester); S0/R1A/R1B restano come gia' stampati."""
    return lotto in LOTTI_A_ESCLUSIVA or lotto not in LOTTI_STORICI
# FIRMA di Claudio 10/10/2026 (report/FIRME_2026-10-10.md, Firma 1): lettura PER REGIME, regola oggettiva sul prezzo (proxy_gba_r2reg.py --regimi).
# Direzione: TORO R>=+5% e ER>=0,15 | RIBASSO R<=-5% e ER>=0,15 | LATERALE altrimenti. Volatilita': CALMO < 3,5 bp, VOLATILE >= 3,5 bp.
REGIMI_TRANCHE = {"T9": ("TORO", "CALMO"), "T8": ("LATERALE", "CALMO"), "T7": ("TORO", "CALMO"), "T6": ("LATERALE", "VOLATILE"), "T5": ("TORO", "CALMO"),
                  "T4": ("TORO", "VOLATILE"), "T3": ("LATERALE", "VOLATILE"), "T2": ("RIBASSO", "VOLATILE"), "T1": ("LATERALE", "VOLATILE")}
N_REGIME = 150               # firma 10/10: regime con < 150 operazioni = NON MISURATO
# (v5) la regola sul prezzo con i suoi NUMERI per tranche (file prova GBA_R2_REGIME_2026-10-10.txt r.81-88, proxy HistData): R in %, ER di Kaufman, ATR M1/prezzo in bp.
# Servono a stampare la SENSIBILITA' del verdetto alle soglie tonde (ER 0,10 e 0,20): l'autotest verifica che a ER 0,15 la regola ridia REGIMI_TRANCHE.
TRANCHE_PREZZO = {"T9": (11.0, 0.253, 2.59), "T8": (-1.4, 0.029, 2.58), "T7": (17.5, 0.431, 2.61), "T6": (6.4, 0.081, 4.07), "T5": (15.5, 0.344, 2.60),
                  "T4": (11.8, 0.176, 4.40), "T3": (4.1, 0.035, 5.84), "T2": (-16.0, 0.184, 4.73), "T1": (8.2, 0.116, 4.22)}
REGOLA_R, REGOLA_ER, REGOLA_BP = 5.0, 0.15, 3.5
# (v5) una tranche prende il regime della tabella SOLO se il suo inizio e' quello della partizione (un file prova dichiarativo potrebbe chiamare 'T1' un'altra finestra)
TRANCHE_DA = {"T9": "2024.07.10", "T8": "2024.10.01", "T7": "2025.01.01", "T6": "2025.04.01", "T5": "2025.07.01", "T4": "2025.10.01", "T3": "2026.01.01", "T2": "2026.04.01", "T1": "2026.07.01"}
# ---------------------------------------------------------------------------------------------------------------------
#  (v5) LE DUE DECISIONI CHE SPETTANO A CLAUDIO, come PARAMETRI (una scelta non richiede una riscrittura). Default = lettura LETTERALE della firma 10/10
#  (report/FIRME_2026-10-10.md, Firma 1). Si cambiano da riga di comando: --durata-regime e --lato-sotto-150. Il lettore stampa SEMPRE quali valori ha usato.
# ---------------------------------------------------------------------------------------------------------------------
# 1) DURATA MINIMA DI UN REGIME. Firma, punto 4: "Un anno per regime, anche non contigui". Letterale = un anno = 4 trimestri (le tranche sono trimestri).
#    '365giorni' = la somma dei giorni di calendario delle tranche [da, a) >= 365 (T9 parte dal 10/07, inizio dei tick: il toro T9+T7+T5+T4 fa 357 giorni).
#    '2trimestri' = la lettura del file prova R2REG (r.186: 'almeno 2 tranche'), che e' quella usata fino alla v4 del lettore.
DURATE_REGIME = {"1anno": ("tranche", 4), "365giorni": ("giorni", 365), "2trimestri": ("tranche", 2)}
DURATA_REGIME = "1anno"
# 2) PESO DI UN LATO SOTTO 150 OPERAZIONI. Firma, punto 1: "PF_V > 1,0 in OGNI regime che ha almeno 150 operazioni, con long e short letti SEPARATAMENTE":
#    la soglia 150 e' sul REGIME, al lato non ne pone una. Letterale = 'giudica': il lato conta nel verdetto qualunque sia il suo n (stampato col suo n).
#    'non_misurato' = un lato con n < 150 non giudica (se nessun lato arriva a 150 il regime resta NON MISURATO).
LATI_SOTTO_150 = ("giudica", "non_misurato")
PESO_LATO_SOTTO_150 = "giudica"
# (2o FAIL, D1) True quando il valore arriva da riga di comando (--durata-regime / --lato-sotto-150): allora la decisione e' DICHIARATA da chi legge e il verdetto
# non deve piu' dire 'DIPENDE'; finche' sono False il default e' una lettura della firma, non una scelta, e il verdetto mostra se l'alternativa cambia l'esito.
DURATA_SCELTA = False
LATO_SCELTO = False
# DD PROMESSO dal backtest della cella (firma, punto 1): oggi NON esiste (nessuna cella promossa, nessun censimento di contratto). Senza, il verdetto NON puo'
# cominciare con 'regge': esce 'NON DICHIARABILE (DD promesso assente)'. Da riga di comando: --dd-promesso <EUR a 1,00 lotto>.
DD_PROMESSO = None
# lotti dei file prova STORICI (semantica fissa; S0/R1A/R1B hanno 'a' INCLUSIVA nel conto dei giorni: vedi LOTTI_A_ESCLUSIVA e a_esclusiva)
LOTTI_STORICI = ("S0", "R1A", "R1B", "R2REG")
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
def leggi_ini(testo):
    """(v5) il .ini della passata (scritto dal driver, copiato nello zip): {'tester': {Symbol, Period, Model, FromDate, ToDate, ...}, 'inputs': {Inp...: valore}}."""
    sez, out = None, {"tester": {}, "inputs": {}}
    for riga in testo.splitlines():
        riga = riga.strip()
        if not riga or riga.startswith(";"):
            continue
        if riga.startswith("[") and riga.endswith("]"):
            sez = riga[1:-1]
            continue
        if "=" not in riga:
            continue
        k, v = riga.split("=", 1)
        if sez == "Tester":
            out["tester"][k.strip()] = v.strip()
        elif sez == "TesterInputs":
            out["inputs"][k.strip()] = v.strip()
    return out


def _norm(v):
    """'1.0' e '1.00' sono lo stesso input; '48' e '48.0' anche. Le stringhe restano come sono."""
    try:
        if re.fullmatch(r"-?[0-9]+(\.[0-9]+)?", str(v)):
            return repr(float(v))
    except ValueError:
        pass
    return str(v)


def identita(P):
    """(v5) IDENTITA' DELLA CELLA = cio' che rende due passate la stessa misura a meno di tranche e magic: Modello, simbolo, periodo e TUTTI gli input tranne
    InpMagic, letti dall'ini dello zip (fonte: cio' che il tester ha davvero ricevuto). Senza ini (zip vecchi): dal manifest (modello, simbolo, periodo, asse=valore).
    Restituisce (id_cella, id_misura, da_ini)."""
    r = P["riga"]
    if P.get("ini"):
        te, inp = P["ini"]["tester"], P["ini"]["inputs"]
        idc = ("ini", te.get("Model", r["modello"]), te.get("Symbol", ""), te.get("Period", ""), tuple(sorted((k, _norm(v)) for k, v in inp.items() if k != "InpMagic")))
        return idc, idc + (te.get("FromDate", r["da"]), te.get("ToDate", r["a"]), inp.get("InpMagic", r["magic"])), True
    idc = ("manifest", r["modello"], P["simbolo"], P["periodo"], P["asse"], _norm(P["valore"]))
    return idc, idc + (r["da"], r["a"], r["magic"]), False


def controlla_doppioni(passate):
    """(v5, difetto 3 del cancello R2REG) la stessa misura caricata DUE volte (lo stesso zip passato due volte, o la stessa cella+tranche+magic in due lotti)
    conterebbe le sue operazioni due volte in OGNI somma (cella, regime, lato) e farebbe passare per 'due tranche' una tranche sola. Vale anche per due finestre
    che si SOVRAPPONGONO sulla stessa cella e lo stesso magic (es. T1 di R1A 07.01-09.30 e un T1 07.01-10.01 di un file nuovo): gli stessi giorni contati due volte.
    Le passate NON_LANCIATA non contano (non hanno numeri). Stessa cella = stessa identita' dall'ini se l'hanno tutte e due; se a una manca, la chiave del
    manifest (modello, simbolo, periodo, asse, valore, cella). Restituisce la lista degli errori (vuota = nessun doppione)."""
    vive = [P for P in passate if P["riga"]["stato"] != "NON_LANCIATA"]
    err = []
    for i in range(len(vive)):
        for j in range(i + 1, len(vive)):
            a, b = vive[i], vive[j]
            if a["da_ini"] and b["da_ini"]:
                stessa = a["id_cella"] == b["id_cella"]
                ma, mb = a["id_misura"][-1], b["id_misura"][-1]
                da_a, a_a, da_b, a_b = a["id_misura"][-3], a["id_misura"][-2], b["id_misura"][-3], b["id_misura"][-2]
            else:
                stessa = (a["riga"]["modello"], a["simbolo"], a["periodo"], a["asse"], _norm(a["valore"]), a["cella"]) == (b["riga"]["modello"], b["simbolo"], b["periodo"], b["asse"], _norm(b["valore"]), b["cella"])
                ma, mb = a["magic"], b["magic"]
                da_a, a_a, da_b, a_b = a["riga"]["da"], a["riga"]["a"], b["riga"]["da"], b["riga"]["a"]
            if not stessa or ma != mb:
                continue
            if (da_a, a_a) == (da_b, a_b):
                err.append("la stessa misura e' caricata DUE volte: %s [%s] e %s [%s] (modello %s, cella %s/%s, tranche %s, magic %s)" % (
                    a["tag"], a["sorgente"], b["tag"], b["sorgente"], a["riga"]["modello"], a["cella"], b["cella"], a["tranche"], ma))
            elif da_a < a_b and da_b < a_a:
                err.append("finestre SOVRAPPOSTE sulla stessa cella e lo stesso magic: %s [%s] %s-%s e %s [%s] %s-%s: gli stessi giorni si conterebbero due volte" % (
                    a["tag"], a["sorgente"], da_a, a_a, b["tag"], b["sorgente"], da_b, a_b))
    return err


def carica(percorsi, controlla=True):
    passate = []
    for pth in percorsi:
        src = Sorgente(pth)
        if "MANIFEST_R0.csv" not in src.nomi:
            raise SystemExit("%s: manca MANIFEST_R0.csv (non e' uno zip di GBA_R0_PASSATE.ps1)" % pth)
        man = list(csv.DictReader(io.StringIO(src.leggi("MANIFEST_R0.csv").decode("ascii", "replace")), delimiter=";"))
        for r in man:
            rep, log, ini = None, None, None
            if r["stato"] != "NON_LANCIATA":
                cand = [n for n in src.nomi if n.startswith("report/GBA_R0_" + r["passata"]) and n.lower().endswith((".htm", ".html"))]
                if cand:
                    rep = leggi_report(src.leggi(cand[0]))
                nl = "log/GBA_" + r["passata"] + ".txt"
                if nl in src.nomi:
                    log = leggi_log(src.leggi(nl).decode("ascii", "replace"))
                ni = "ini/gba_" + r["passata"] + ".ini"
                if ni in src.nomi:
                    ini = leggi_ini(src.leggi(ni).decode("ascii", "replace"))
            P = costruisci_passata(r, rep, log)
            P["sorgente"] = os.path.basename(pth)
            # (v5) colonne in coda al manifest del driver v5; uno zip v3/v4 non le ha: era l'asse InpSpreadMaxATR su XAUUSD M1
            P["lotto"] = r["lotto"]
            P["asse"] = r.get("asse") or "InpSpreadMaxATR"
            P["valore"] = r.get("valore_asse") or r.get("spread_max_atr", "")
            P["simbolo"] = r.get("simbolo") or "XAUUSD"
            P["periodo"] = r.get("periodo") or "M1"
            P["ini"] = ini
            P["id_cella"], P["id_misura"], P["da_ini"] = identita(P)
            passate.append(P)
    if controlla:
        err = controlla_doppioni(passate)
        if err:
            raise SystemExit("ERRORE (nessun numero si stampa: ogni somma sarebbe falsata):\n  " + "\n  ".join(err) + "\nCarica ogni zip UNA volta sola, e una sola copia di ogni misura.")
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
        tot_giorni += giorni_feriali(P["riga"]["da"], P["riga"]["a"], a_esclusiva(P["riga"]["lotto"]))
    return tutte, per_tr, (cost0, cost1, cost2), tot_giorni


def regimi_da_prezzo(er=REGOLA_ER, r=REGOLA_R, bp=REGOLA_BP):
    """La regola sul prezzo del file prova R2REG applicata a TRANCHE_PREZZO: {tranche: (direzione, volatilita')}. A ER 0,15 rida' REGIMI_TRANCHE (autotest)."""
    out = {}
    for tr, (R, E, B) in TRANCHE_PREZZO.items():
        d = "TORO" if (R >= r and E >= er) else ("RIBASSO" if (R <= -r and E >= er) else "LATERALE")
        out[tr] = (d, "CALMO" if B < bp else "VOLATILE")
    return out


def regime_di(P, regimi=None):
    """(v5) il regime della passata, SOLO se nome e inizio della tranche sono quelli della partizione (TRANCHE_DA); altrimenti None."""
    regimi = REGIMI_TRANCHE if regimi is None else regimi
    if P["tranche"] in regimi and TRANCHE_DA.get(P["tranche"]) == P["riga"]["da"]:
        return regimi[P["tranche"]]
    return None


def giorni_calendario(P):
    """giorni di calendario della finestra [da, a) (ToDate del tester ESCLUSIVO, misurato in R1A)."""
    d0 = datetime.datetime.strptime(P["riga"]["da"], "%Y.%m.%d")
    d1 = datetime.datetime.strptime(P["riga"]["a"], "%Y.%m.%d")
    return (d1 - d0).days


def lettura_regimi(passate, cella=None, comm_ip=COMM_EUR_LOTTO_GIRO, Ps=None, regimi=None, durata=None, lato150=None, dd_promesso=None):
    """FIRMA 10/10 (report/FIRME_2026-10-10.md): lettura PER REGIME, long e short SEPARATI. Le passate sono quelle della CELLA (per nome, come prima, oppure la lista
    Ps gia' raggruppata per IDENTITA': R1A e R2REG sono la stessa cella REPL, stessi 30 pin). Le tranche si assegnano ai regimi con la regola sul prezzo
    (regimi; default REGIMI_TRANCHE) e si contano come INSIEME: una tranche vista due volte e' un ERRORE, non due tranche (difetto 3 del cancello R2REG).
    durata / lato150 / dd_promesso: i parametri delle decisioni di Claudio (default: lettura letterale della firma). Restituisce (righe, verdetto)."""
    durata_esplicita = durata is not None or DURATA_SCELTA
    lato_esplicito = lato150 is not None or LATO_SCELTO
    durata = DURATA_REGIME if durata is None else durata
    lato150 = PESO_LATO_SOTTO_150 if lato150 is None else lato150
    dd_promesso = DD_PROMESSO if dd_promesso is None else dd_promesso
    if durata not in DURATE_REGIME:
        raise ValueError("durata del regime '%s' sconosciuta (ammesse: %s)" % (durata, ", ".join(sorted(DURATE_REGIME))))
    if lato150 not in LATI_SOTTO_150:
        raise ValueError("peso del lato sotto 150 '%s' sconosciuto (ammessi: %s)" % (lato150, ", ".join(LATI_SOTTO_150)))
    tipo_d, soglia_d = DURATE_REGIME[durata]
    if Ps is None:
        Ps = [P for P in passate if P["cella"] == cella]
    Ps = [P for P in Ps if int(P["riga"]["modello"]) == 4 and P["magic"] == "775800" and not P["g0"] and regime_di(P, regimi)]
    dati = {}
    for P in Ps:
        nz, _c = posizioni_numeriche(P, comm_ip)
        dir_, vol_ = regime_di(P, regimi)
        dd = P["rep"]["dd_eq_abs"] if P["rep"] and P["rep"].get("dd_eq_abs") is not None else None
        for reg in (dir_, vol_):
            d = dati.setdefault(reg, {"tr": {}, "pos": [], "dd": [], "dd_nd": []})
            if P["tranche"] in d["tr"]:
                return ([], "ERRORE: la tranche %s compare DUE volte nel regime %s (passate %s): lettura per regime NON fatta, ogni somma sarebbe doppia" % (
                    P["tranche"], reg, ", ".join(sorted(x["tag"] for x in Ps if x["tranche"] == P["tranche"]))))
            d["tr"][P["tranche"]] = giorni_calendario(P)
            d["pos"] += nz
            if dd is not None:
                d["dd"].append(dd)
            else:
                # (classe 1252) un DD che manca NON e' un DD rispettato: si ricorda quale tranche non ce l'ha
                d["dd_nd"].append(P["tranche"])
    righe = []
    misurati, non_misurati, fallimenti, dd_oltre, dd_mancanti = [], [], [], [], []
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
        if len(d["dd"]) != len(d["tr"]):
            dd_mancanti.append("%s (%s)" % (reg, ",".join(sorted(d["dd_nd"]))))
            if d["dd"]:
                dd += " (DD n.d. in %s)" % ",".join(sorted(d["dd_nd"]))
        ntr, ngg = len(d["tr"]), sum(d["tr"].values())
        base = "   %-9s tranche %-12s n=%-5d (long %d, short %d)  PF_V %s  long %s  short %s  %s  [%d tranche, %d giorni]" % (
            reg, ",".join(sorted(d["tr"])), n, len(lung), len(cor), "%.2f" % pf_di([x["net_v"] for x in d["pos"]]),
            "%.2f" % pf_di(lung) if lung else "n.d.", "%.2f" % pf_di(cor) if cor else "n.d.", dd, ntr, ngg)
        # il RISCHIO si legge a qualunque n (R59): un DD oltre il promesso boccia anche un regime NON MISURATO per il merito
        if dd_promesso is not None and d["dd"] and max(d["dd"]) > dd_promesso:
            dd_oltre.append("%s (%.0f > %.0f EUR)" % (reg, max(d["dd"]), dd_promesso))
            base += "  DD OLTRE IL PROMESSO"
        corta = (ntr < soglia_d) if tipo_d == "tranche" else (ngg < soglia_d)
        if corta:
            righe.append(base + "  -> NON MISURATO (durata: %s < %d %s, regola '%s')" % (ntr if tipo_d == "tranche" else ngg, soglia_d, tipo_d, durata))
            non_misurati.append(reg)
        elif n < N_REGIME:
            righe.append(base + "  -> NON MISURATO (n < %d: il merito non si giudica; il rischio si legge: vedi DD)" % N_REGIME)
            non_misurati.append(reg)
        else:
            lati = (("long", lung), ("short", cor))
            # un lato con ZERO operazioni (es. InpAllowShort=false) non ha un PF: NON si giudica, si dichiara spento/assente (un 'n.d.' non e' un PF <= 1)
            vuoti = [nm for nm, v in lati if not v]
            giudicati = [(nm, v) for nm, v in lati if v] if lato150 == "giudica" else [(nm, v) for nm, v in lati if len(v) >= N_REGIME]
            sotto = [nm for nm, v in lati if 0 < len(v) < N_REGIME]
            if lato150 == "giudica":
                note = "  (lato con n<150: %s -- CONTA nel verdetto, lettura letterale della firma; --lato-sotto-150 non_misurato per l'alternativa)" % "+".join(sotto) if sotto else ""
            else:
                note = "  (lato NON MISURATO, n<150: %s -- regola '--lato-sotto-150 non_misurato')" % "+".join(sotto) if sotto else ""
            if vuoti:
                note += "  (lato %s spento/assente, n=0: NON giudicato)" % "+".join(vuoti)
            if not giudicati:
                righe.append(base + "  -> NON MISURATO (nessun lato giudicabile: %s)%s" % ("nessun lato con operazioni" if lato150 == "giudica" else "nessun lato con n >= %d, regola 'non_misurato'" % N_REGIME, note))
                non_misurati.append(reg)
                continue
            lati_ko = [nm for nm, v in giudicati if not v or not (pf_di(v) > 1.0)]
            if lati_ko:
                fallimenti.append("%s %s" % (reg, "+".join(lati_ko)))
                righe.append(base + "  -> MISURATO, NON REGGE (PF_V <= 1,0 su: %s)%s" % (" e ".join(lati_ko), note))
            else:
                righe.append(base + "  -> MISURATO, PF_V > 1,0 su %s%s" % (" e ".join(nm for nm, _v in giudicati), note))
            misurati.append(reg)
    durata_txt = ("%d tranche" % soglia_d) if tipo_d == "tranche" else ("%d giorni" % soglia_d)
    if not dati:
        verdetto = "nessuna tranche con regime assegnato (non e' un giro sulle tranche della partizione T1-T9?)"
    elif fallimenti or dd_oltre:
        parti = []
        if fallimenti:
            parti.append("PF_V <= 1,0 in %s" % "; ".join(fallimenti))
        if dd_oltre:
            parti.append("DD oltre il promesso in %s" % "; ".join(dd_oltre))
        verdetto = "NON REGGE: " + " | ".join(parti)
    elif not misurati:
        verdetto = "NON MISURATO: nessun regime con almeno %d operazioni e durata >= %s (regola '%s')" % (N_REGIME, durata_txt, durata)
    elif not any(r in ("LATERALE", "RIBASSO") for r in misurati):
        verdetto = "NON BASTA: un PF buono solo nel toro non basta (regimi misurati: %s; NON misurati: %s)" % (", ".join(misurati), ", ".join(non_misurati) or "nessuno")
    else:
        regge = "regge nei regimi MISURATI (%s); NON misurati: %s" % (", ".join(misurati), ", ".join(non_misurati) or "nessuno")
        if dd_promesso is None:
            verdetto = ("NON DICHIARABILE (DD promesso assente): " + regge + ". Il DD promesso dal backtest della cella NON esiste ancora (nessuna cella e' stata promossa, "
                        "nessun censimento di contratto): il cancello del drawdown resta APERTO e la parola 'regge' non si puo' scrivere da sola")
        else:
            verdetto = regge + "; DD equity max di tranche <= DD promesso %.0f EUR in ogni regime letto" % dd_promesso
    if dd_mancanti and dati:
        # (classe 1252) un DD mancante non si conta come rispettato: un NON REGGE resta (e' un fatto misurato), ogni altro esito diventa NON DICHIARABILE
        if verdetto.startswith("NON REGGE"):
            verdetto += " | DD n.d. in %s" % "; ".join(dd_mancanti)
        else:
            verdetto = "NON DICHIARABILE (DD n.d. in %s): %s" % ("; ".join(dd_mancanti), verdetto)
    if dati and not (durata_esplicita and lato_esplicito):
        # (classi 1253 e 2o FAIL D3) le due letture della firma NON dichiarate da chi legge sono SCELTE: se l'alternativa cambia la CATEGORIA dell'esito
        # (non il testo), il verdetto lo dice per primo. Le letture interne passano durata e lato espliciti: nessuna ricorsione oltre un livello.
        dipende = []
        if not durata_esplicita:
            v_1a = lettura_regimi(passate, cella, comm_ip, Ps, regimi, "1anno", lato150, dd_promesso)[1]
            v_365 = lettura_regimi(passate, cella, comm_ip, Ps, regimi, "365giorni", lato150, dd_promesso)[1]
            if _esito(v_1a) != _esito(v_365):
                dipende.append("DIPENDE DALLA DURATA (decisione di Claudio aperta): 1anno -> %s, 365giorni -> %s" % (v_1a, v_365))
        if not lato_esplicito:
            v_g = lettura_regimi(passate, cella, comm_ip, Ps, regimi, durata, "giudica", dd_promesso)[1]
            v_n = lettura_regimi(passate, cella, comm_ip, Ps, regimi, durata, "non_misurato", dd_promesso)[1]
            if _esito(v_g) != _esito(v_n):
                dipende.append("DIPENDE DAL LATO SOTTO 150 (decisione di Claudio aperta): giudica -> %s, non_misurato -> %s" % (v_g, v_n))
        if dipende:
            verdetto = " || ".join(dipende)
    return righe, verdetto


def _esito(v):
    """(2o FAIL, D2) la CATEGORIA di un verdetto di regime: ERRORE / NON REGGE / NON BASTA / NON MISURATO / regge / NESSUNA TRANCHE; per
    'NON DICHIARABILE (...): X' la coppia NON DICHIARABILE + categoria di X. Due letture che danno la stessa categoria CONCORDANO, anche se il testo differisce."""
    if v.startswith("NON DICHIARABILE ("):
        i = v.find("): ")
        return "NON DICHIARABILE+" + (_esito(v[i + 3:]) if i >= 0 else "?")
    for cat in ("ERRORE", "NON REGGE", "NON BASTA", "NON MISURATO", "DIPENDE"):
        if v.startswith(cat):
            return cat
    if v.startswith("regge"):
        return "regge"
    if v.startswith("nessuna tranche"):
        return "NESSUNA TRANCHE"
    return "?" + v[:20]


def _ordine_cella(c):
    return {"REPL": 0, "C010": 1, "C020": 2, "C035": 3}.get(c, 9)


def gruppi_per_identita(passate, filtro):
    """(v5) passate raggruppate per IDENTITA' della cella (stessi input tranne il magic, stesso simbolo/TF/modello), nell'ordine di casa. -> [(etichetta, [P...])]"""
    gruppi = {}
    for P in passate:
        if filtro(P):
            gruppi.setdefault(P["id_cella"], []).append(P)
    out = []
    for idc, Ps in gruppi.items():
        nomi = sorted(set(P["cella"] for P in Ps), key=_ordine_cella)
        lotti = sorted(set(P["riga"]["lotto"] for P in Ps), key=lambda l: (ORDINE_LOTTI.get(l, 9), l))
        out.append(("%s (lotti %s)" % ("/".join(nomi), "+".join(lotti)), Ps, min(_ordine_cella(n) for n in nomi), nomi))
    out.sort(key=lambda x: (x[2], x[0]))
    return [(e, Ps, nomi) for e, Ps, _o, nomi in out]


def tabella_regimi(passate, W):
    filtro = lambda P: int(P["riga"]["modello"]) == 4 and regime_di(P) is not None
    gruppi = gruppi_per_identita(passate, filtro)
    if not gruppi:
        return
    tipo_d, soglia_d = DURATE_REGIME[DURATA_REGIME]
    W("")
    W("-" * 100)
    W(" (7) LETTURA PER REGIME (firma di Claudio 10/10/2026, report/FIRME_2026-10-10.md; si AGGIUNGE a S4-S7, non li sostituisce)")
    W("     regola sul prezzo: TORO R>=+5% e ER>=0,15 | RIBASSO R<=-5% e ER>=0,15 | LATERALE altrimenti | CALMO ATR M1/prezzo <3,5 bp | VOLATILE >=3,5 bp (proxy_gba_r2reg.py --regimi)")
    W("     regge se PF_V > 1,0 in OGNI regime con >= 150 operazioni e durata >= %s, long e short letti SEPARATAMENTE, e nessun regime ha DD oltre il promesso;" % (
        ("%d tranche" % soglia_d) if tipo_d == "tranche" else ("%d giorni" % soglia_d)))
    W("     < 150 operazioni = NON MISURATO; solo toro non basta. Le tranche di un regime si contano come INSIEME (una tranche doppia = ERRORE).")
    W("     PARAMETRI (decisioni APERTE di Claudio; default = lettura letterale della firma 10/10):")
    W("       durata del regime   = '%s' (%s)   [alternative: %s]" % (DURATA_REGIME, {"1anno": "un anno = 4 trimestri", "365giorni": "somma dei giorni [da,a) >= 365", "2trimestri": "almeno 2 tranche, come il file prova R2REG r.186"}[DURATA_REGIME],
                                                                    ", ".join(k for k in sorted(DURATE_REGIME) if k != DURATA_REGIME)))
    W("       lato sotto 150      = '%s' (%s)   [alternativa: %s]" % (PESO_LATO_SOTTO_150, {"giudica": "la soglia 150 e' sul regime: ogni lato conta nel verdetto col suo n", "non_misurato": "un lato con n<150 non giudica"}[PESO_LATO_SOTTO_150],
                                                                   [x for x in LATI_SOTTO_150 if x != PESO_LATO_SOTTO_150][0]))
    W("       DD promesso         = %s" % ("ASSENTE (nessuna cella promossa): nessun verdetto puo' cominciare con 'regge'" if DD_PROMESSO is None else "%.0f EUR (equity, 1,00 lotto)" % DD_PROMESSO))
    if DURATA_REGIME != "2trimestri":
        W("       NOTA: il file prova R2REG (r.186, 'almeno 2 tranche') e la firma ('un anno per regime') NON dicono la stessa cosa: per la lettura del file -> --durata-regime 2trimestri")
    vicine = sorted(((abs(v[1] - REGOLA_ER), t, v[1]) for t, v in TRANCHE_PREZZO.items() if abs(v[1] - REGOLA_ER) <= 0.07), key=lambda x: x[0])
    W("     SOGLIE TONDE (5%%, 0,15, 3,5 bp) scelte il 10/10 DOPO aver letto rendimenti e ATR dei trimestri (non i PF). Tranche vicine al confine ER 0,15 (entro 0,07): %s." % (
        ", ".join("%s ER %s" % (t, ("%.3f" % e).replace(".", ",")) for _d, t, e in sorted(vicine, key=lambda x: x[2]))))
    W("     Il loro regime dipende da quei numeri: sotto, per ogni cella, la SENSIBILITA' del verdetto a ER 0,10 e 0,20 (NON e' un verdetto: il verdetto e' quello a 0,15).")
    for etich, Ps, _nomi in gruppi:
        W("   --- cella %s ---" % etich)
        righe, verdetto = lettura_regimi(passate, Ps=Ps)
        for r in righe:
            W(r)
        W("   VERDETTO PER REGIME (cella %s): %s" % (etich, verdetto))
        for dur in ("1anno", "365giorni", "2trimestri"):
            W("   DURATA '%s'%s -> %s" % (dur, " (in uso)" if dur == DURATA_REGIME else "", lettura_regimi(passate, Ps=Ps, durata=dur, lato150=PESO_LATO_SOTTO_150)[1]))
        for lat in LATI_SOTTO_150:
            W("   LATO SOTTO 150 '%s'%s -> %s" % (lat, " (in uso)" if lat == PESO_LATO_SOTTO_150 else "", lettura_regimi(passate, Ps=Ps, durata=DURATA_REGIME, lato150=lat)[1]))
        for er_alt in (0.10, 0.20):
            reg_alt = regimi_da_prezzo(er=er_alt)
            presenti = sorted(set(P["tranche"] for P in Ps if regime_di(P) is not None))
            cambia = ["%s %s->%s" % (t, REGIMI_TRANCHE[t][0], reg_alt[t][0]) for t in presenti if reg_alt[t][0] != REGIMI_TRANCHE[t][0]]
            _r, v_alt = lettura_regimi(passate, Ps=Ps, regimi=reg_alt)
            W("   SENSIBILITA' (NON e' un verdetto) con ER %s: %s -> esito: %s" % (("%.2f" % er_alt).replace(".", ","),
                                                                                "cambiano " + ", ".join(cambia) if cambia else "nessuna tranche di questa cella cambia direzione", v_alt))


def gemelle_dichiarative(passate):
    """(v5) G1 fuori da S0: per ogni passata 775850 di un lotto dichiarativo, la gemella 775800 con la stessa identita' di cella e la stessa finestra
    (in qualunque zip caricato). Uguali (operazioni, profitto, PF, DD equity) = VERDE; diverse = ROSSO; gemella assente = NON VERIFICABILE."""
    out = []
    for b in passate:
        if b["magic"] != "775850" or b["riga"]["lotto"] in LOTTI_STORICI:
            continue
        cand = [a for a in passate if a["magic"] == "775800" and a["id_cella"] == b["id_cella"] and a["riga"]["da"] == b["riga"]["da"] and a["riga"]["a"] == b["riga"]["a"]]
        nome = "  G1 gemelle (cella %s, tranche %s, Modello %s, magic 775800 [%s] e 775850 [%s])" % (b["cella"], b["tranche"], b["riga"]["modello"],
                                                                                                    cand[0]["sorgente"] if cand else "?", b["sorgente"])
        if not cand:
            out.append(nome + ": la gemella 775800 NON e' fra gli zip caricati (stessa identita' di cella e stessa finestra) -> NON VERIFICABILE")
            continue
        ra, rb = cand[0]["rep"], b["rep"]
        if not (ra and rb and ra["ok"] and rb["ok"]):
            out.append(nome + ": manca il report di una delle due -> NON VERIFICABILE")
            continue
        uguali = (ra["trades"] == rb["trades"] and ra["profitto"] == rb["profitto"] and ra["pf"] == rb["pf"] and ra["dd_eq_abs"] == rb["dd_eq_abs"])
        out.append(nome + ": operazioni %s/%s, profitto %s/%s, PF %s/%s, DD equity %s/%s -> %s" % (ra["trades"], rb["trades"], ra["profitto"], rb["profitto"], ra["pf"], rb["pf"],
                   ra["dd_eq_abs"], rb["dd_eq_abs"], "VERDE (identiche)" if uguali else "ROSSO: la passata non e' riproducibile, NESSUN numero del lotto %s si usa" % b["riga"]["lotto"]))
    return out


def _num_o_testo(v):
    try:
        return (0, float(v))
    except (TypeError, ValueError):
        return (1, str(v))


def frontiera_dichiarativa(tab, W):
    """(v5) S7 per i lotti dei file prova dichiarativi: per ogni (lotto, asse), le celle del lotto PIU' le ANCORE caricate (una cella di qualunque lotto i cui input
    differiscono SOLO nella chiave dell'asse, stesso modello/simbolo/TF e stesse tranche: di solito la REPL di R1A). Ordinate per valore dell'asse; la monotonia
    del PF_V si legge solo con >= 3 punti numerici (con 2 punti e' vuota). Centro dell'altopiano, mai il picco: il lettore NON sceglie una cella."""
    fam = {}
    for t in tab:
        if t["modello"] == 4 and t["lotto"] not in LOTTI_STORICI:
            fam.setdefault((t["lotto"], t["asse"]), []).append(t)
    for (lotto, asse), membri in sorted(fam.items()):
        punti = {id(t): (t[ "valore"], t, "") for t in membri}
        for t in membri:
            if not t["inputs"]:
                continue
            for u in tab:
                if u is t or id(u) in punti or u["modello"] != 4 or not u["inputs"] or (u["simbolo"], u["periodo"]) != (t["simbolo"], t["periodo"]):
                    continue
                diff = set(k for k in set(t["inputs"]) | set(u["inputs"]) if k != "InpMagic" and _norm(t["inputs"].get(k)) != _norm(u["inputs"].get(k)))
                if diff == {asse}:
                    if u["tranche_da"] == t["tranche_da"]:
                        punti[id(u)] = (u["inputs"][asse], u, " (ancora, lotto %s)" % u["lotto"])
                    else:
                        W("   (S7 %s/%s) la cella %s del lotto %s differisce solo in %s ma gira su ALTRE tranche: non e' un'ancora confrontabile" % (lotto, asse, u["cella"], u["lotto"], asse))
        righe = sorted(punti.values(), key=lambda x: _num_o_testo(x[0]))
        W("")
        W("-" * 100)
        W(" (S7) FRONTIERA del lotto %s lungo l'asse %s (Modello 4): %d punti; centro dell'altopiano, mai il picco" % (lotto, asse, len(righe)))
        for val, t, nota in righe:
            W("   %-5s %s=%-8s n=%-6d PF_V %.3f  costo mediano (+0,04) %.1f  %s%s" % (t["cella"], asse, val, t["n"], t["pf_v"], t["costo_mediano_c04"], banda_costo(t["costo_mediano_c04"]), nota))
        numerici = all(_num_o_testo(v)[0] == 0 for v, _t, _n in righe)
        if len(righe) >= 3 and numerici:
            pfs = [t["pf_v"] for _v, t, _n in righe]
            mono = all(pfs[i] <= pfs[i + 1] for i in range(len(pfs) - 1)) or all(pfs[i] >= pfs[i + 1] for i in range(len(pfs) - 1))
            W("   PF_V lungo l'asse: %s -> %s" % (" / ".join("%.2f" % x for x in pfs), "monotono (un altopiano si legge)" if mono else "NON monotono: una cella che sporge e' un PICCO, non un altopiano"))
        else:
            W("   %s -> NESSUN altopiano si legge: contano n, PF_V e costo" % ("solo %d punti (la monotonia fra 2 punti e' vuota)" % len(righe) if len(righe) < 3 else "asse non numerico"))


def stampa(passate, csv_out=None):
    out = []
    W = out.append
    W("=" * 100)
    lotti_presenti = set(P["riga"]["lotto"] for P in passate)
    generici = sorted(l for l in lotti_presenti if l not in LOTTI_STORICI)
    if generici:
        prove = sorted(set(P["riga"].get("prova") or "?" for P in passate if P["riga"]["lotto"] in generici))
        W(" GBA R2 -- lettore (leggi_gba_r0.py), lotti di file prova DICHIARATIVI: %s (file %s). Soglie S1-S7 del file madre GBA_R0_REPLICA_2026-10-09.txt, firma 10/10 per regime." % (", ".join(generici), ", ".join(prove)))
        W(" Le attese per cella stanno nel file prova (scritte PRIMA dei numeri): il lettore NON le conosce e non le stampa. NON giudica oltre le soglie, NON promuove, NON scrive 'morto'.")
        if lotti_presenti & set(LOTTI_STORICI):
            W(" Caricati anche lotti storici (%s): ancore e gemelle si leggono insieme, raggruppate per IDENTITA' della cella (stessi input, dall'ini)." % ", ".join(sorted(lotti_presenti & set(LOTTI_STORICI), key=lambda l: ORDINE_LOTTI.get(l, 9))))
    elif "R2REG" in lotti_presenti:
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
    # (v5) G1 per i lotti dichiarativi: gemelle = stessa IDENTITA' di cella e stessa finestra, magic 775800 e 775850, anche in due zip diversi (ancora in R1A)
    for g in gemelle_dichiarative(passate):
        W(g)
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
    # (v5) chiave della cella = (modello, lotto, cella, asse): due file dichiarativi possono usare lo stesso nome di cella su assi diversi
    for P in passate:
        k = (int(P["riga"]["modello"]), P["riga"]["lotto"], P["cella"], P["asse"])
        if k not in celle:
            celle.append(k)
    celle.sort(key=lambda k: (-k[0], ORDINE_LOTTI.get(k[1], 9), k[1], {"REPL": 0, "C010": 1, "C020": 2, "C035": 3}.get(k[2], 9), k[2]))
    tab = []
    for (mod, lotto_c, cella, asse_c) in celle:
        Ps = [P for P in passate if int(P["riga"]["modello"]) == mod and P["riga"]["lotto"] == lotto_c and P["cella"] == cella and P["asse"] == asse_c and P["magic"] == "775800"]
        if not Ps:
            # (v5) un lotto con la sola gemella 775850 di una cella (ancora in R1A): la si legge solo in G1
            continue
        simtf = "" if (Ps[0]["simbolo"], Ps[0]["periodo"]) == ("XAUUSD", "M1") else " %s %s" % (Ps[0]["simbolo"], Ps[0]["periodo"])
        W("")
        W("-" * 100)
        W(" CELLA %s%s (%s %s)%s  --  Modello %d (%s)" % (cella, " [lotto " + lotto_c + "]" if lotto_c not in ("S0", "R1A", "R1B") else "", asse_c, Ps[0]["valore"], simtf, mod,
                                                         "TICKS REALI: verdetto" if mod == 4 else "OHLC su %s: SOLO CONTEGGIO, nessun PF si legge come merito" % Ps[0]["periodo"]))
        W("-" * 100)
        # (2) n e frequenza
        W("(2) n e frequenza (denominatore: giorni feriali della tranche)")
        for P in Ps:
            n = len(P["pos"]) if not P["g0"] else None
            gf = giorni_feriali(P["riga"]["da"], P["riga"]["a"], a_esclusiva(lotto_c))
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
        if any(OROLOGIO_INCERTO[0] <= x["t"] < OROLOGIO_INCERTO[1] for x in tutte) or lotto_c == "R2REG":
            W("   ORA con OROLOGIO UNIFORME: esclusi gli ingressi dal %s al %s (server): orologio UTC+0 d'inverno fino al cambio (26/12/2024-02/02/2025, giorno NON MISURATO; che l'ORO segua il forex e' [NON MISURATO]); il lettore NON converte le ore" % (
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
        tab.append({"modello": mod, "lotto": lotto_c, "cella": cella, "n": n_tot, "pf_v": pf_v, "pf_v2": pf_v2, "netto": sum(nets), "costo_mediano_c04": mediana(c1), "fragile": fragile,
                    "asse": asse_c, "valore": Ps[0]["valore"], "id_cella": Ps[0]["id_cella"], "tranche_da": tuple(sorted(P["riga"]["da"] for P in Ps if not P["g0"])),
                    "inputs": dict(Ps[0]["ini"]["inputs"]) if Ps[0].get("ini") else None, "simbolo": Ps[0]["simbolo"], "periodo": Ps[0]["periodo"]})
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
    frontiera_dichiarativa(tab, W)
    tabella_regimi(passate, W)
    W("")
    W("-" * 100)
    W(" CERTIFICATO DI MORTE: mancano le caselle 3 (uscita ad asse), 4 (simboli gemelli), 5 (TF cambiato). Qualunque esito sopra NON e' 'morto': e' 'NON ANCORA MISURATO' o 'la replica non regge (un regime)'.")
    if csv_out:
        with open(csv_out, "w", newline="") as f:
            w = csv.DictWriter(f, fieldnames=["modello", "lotto", "cella", "n", "pf_v", "pf_v2", "netto", "costo_mediano_c04", "fragile", "asse", "valore"], delimiter=";", extrasaction="ignore")
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
    global DURATA_REGIME, PESO_LATO_SOTTO_150, DD_PROMESSO, DURATA_SCELTA, LATO_SCELTO
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
    zb = os.path.join(REPO, "backtest_pipeline", "risultati_archivio", "GBA_R0_R1B_20261010", "GBA_R0_R1B.zip")
    if os.path.exists(zr):
        pr = carica([zr])
        # (v5) con la regola del file prova R2REG ('2trimestri') i numeri e il verdetto sono quelli della v4: e' la prova che la riscrittura non li ha spostati
        rg, vd = lettura_regimi(pr, "REPL", durata="2trimestri")
        tx = "\n".join(rg)
        ck("DATI VERI R1A (2trimestri = regola v4): LATERALE = T1+T3 n=685 (long 329, short 356), VOLATILE = T1+T2+T3 n=933 (long 443, short 490), RIBASSO = T2 sola -> NON MISURATO (1 tranche), TORO/CALMO senza tranche",
           "LATERALE  tranche T1,T3        n=685   (long 329, short 356)" in tx and "VOLATILE  tranche T1,T2,T3     n=933   (long 443, short 490)" in tx and "durata: 1 < 2 tranche" in tx and tx.count("nessuna tranche letta") == 2, tx[:400])
        ck("DATI VERI R1A (2trimestri): verdetto 'NON REGGE' (PF_V 0,88 e 0,85 < 1,0) identico alla v4", vd == "NON REGGE: PF_V <= 1,0 in LATERALE long+short; VOLATILE long+short", vd)
        rg1, vd1 = lettura_regimi(pr, "REPL")
        ck("DATI VERI R1A (default '1anno' = lettura letterale della firma): nessun regime ha 4 trimestri -> NON MISURATO (e NON 'non regge')", vd1.startswith("NON MISURATO") and "durata >= 4 tranche" in vd1, vd1)
        # CONTRO-ESEMPIO del difetto 3: R1A caricata DUE volte. Prima della v5 il RIBASSO (T2 sola) diventava 'T2,T2' = due tranche = MISURATO.
        try:
            carica([zr, zr])
            ck("CONTRO-ESEMPIO difetto 3: R1A caricata due volte -> ERRORE", False, "nessun errore")
        except SystemExit as e:
            ck("CONTRO-ESEMPIO difetto 3: R1A caricata due volte -> ERRORE (3 misure doppie, nessun numero stampato)", str(e).startswith("ERRORE") and str(e).count("caricata DUE volte") == 3, str(e)[:120])
        dop = controlla_doppioni(carica([zr, zr], controlla=False))
        ck("controlla_doppioni: 3 doppioni sull'ini (T1, T2, T3)", len(dop) == 3, str(len(dop)))
        prx = carica([zr, zr], controlla=False)
        _r, vdx2 = lettura_regimi(prx, "REPL", durata="2trimestri")
        ck("CONTRO-ESEMPIO difetto 3, seconda rete: anche saltando il controllo, la lettura per regime si rifiuta (tranche doppia = ERRORE, non 'due tranche')", vdx2.startswith("ERRORE: la tranche"), vdx2[:100])
        if os.path.exists(zb):
            ck("R1A + R1B insieme (celle diverse, stesse tranche): NESSUN doppione", not controlla_doppioni(carica([zr, zb], controlla=False)))
    # (v5) la regola sul prezzo e la sua sensibilita' alle soglie tonde
    ck("regola sul prezzo: a ER 0,15 TRANCHE_PREZZO rida' ESATTAMENTE REGIMI_TRANCHE (9 tranche)", regimi_da_prezzo() == REGIMI_TRANCHE, str(regimi_da_prezzo()))
    r10, r20 = regimi_da_prezzo(er=0.10), regimi_da_prezzo(er=0.20)
    cambia10 = sorted(t for t in REGIMI_TRANCHE if r10[t] != REGIMI_TRANCHE[t])
    cambia20 = sorted(t for t in REGIMI_TRANCHE if r20[t] != REGIMI_TRANCHE[t])
    ck("SENSIBILITA': a ER 0,10 cambia solo T1 (ER 0,116: LATERALE->TORO); a ER 0,20 cambiano T2 (0,184: RIBASSO->LATERALE) e T4 (0,176: TORO->LATERALE)",
       cambia10 == ["T1"] and r10["T1"][0] == "TORO" and cambia20 == ["T2", "T4"] and r20["T2"][0] == "LATERALE" and r20["T4"][0] == "LATERALE", "%s %s" % (cambia10, cambia20))
    for tipo, atteso, nome in (("laterale_perde", "NON REGGE: PF_V <= 1,0 in LATERALE long+short", "toro buono ma laterale in perdita -> NON REGGE"),
                               ("solo_toro", "NON BASTA", "CONTRO-ESEMPIO 'PF buono solo nel toro': laterale con n=60 < 150 -> NON MISURATO -> NON BASTA"),
                               ("tutto_bene", "regge nei regimi MISURATI (TORO, LATERALE", "tutti i regimi misurati con PF_V > 1,0 long e short -> regge (DD ancora aperto)"),
                               ("short_perde_toro", "NON REGGE: PF_V <= 1,0 in TORO short", "CONTRO-ESEMPIO long/short: toro con long buono e short perdente -> NON REGGE (short)")):
        zt = _zip_r2reg(tipo)
        with contextlib.redirect_stdout(io.StringIO()):
            outr, _tr = stampa(carica([zt]), None)
        trx = "\n".join(outr)
        # i quattro casi della v4 si leggono con la regola del file R2REG (2trimestri): con '1anno' il laterale (T8+T6) non arriva mai a 4 trimestri
        rgx, vdx = lettura_regimi(carica([zt]), "REPL", durata="2trimestri", lato150="giudica")
        ck("R2REG finto (%s, 2trimestri): %s" % (tipo, nome), atteso in vdx, vdx)
        if tipo == "solo_toro":
            ck("R2REG finto: LATERALE n=60 -> 'n < 150' e RIBASSO senza tranche -> NON MISURATO", any(r.strip().startswith("LATERALE") and "NON MISURATO (n < 150" in r for r in rgx) and any(r.strip().startswith("RIBASSO") and "NON MISURATO" in r for r in rgx))
        if tipo == "tutto_bene":
            ck("R2REG finto: stampa con attese R2REG, 'sei tranche', S7 senza altopiano, orologio uniforme (ingressi dal 27/10 esclusi), controesempio", "sei tranche: n=" in trx and "NESSUN altopiano si legge" in trx and "ORA con OROLOGIO UNIFORME" in trx and "CONTROESEMPIO (scritto prima)" in trx, "")
            ck("R2REG finto: il lettore NON scrive 'MORTO' e porta l'intestazione del lotto", "MORTO" not in trx and "GBA R2REG -- lettore" in trx)
            # (v5) il verdetto NON comincia con 'regge' se il DD promesso manca
            ck("DD promesso ASSENTE: il verdetto comincia con 'NON DICHIARABILE (DD promesso assente)', mai con 'regge'", vdx.startswith("NON DICHIARABILE (DD promesso assente): regge nei regimi MISURATI"), vdx[:90])
            _r, vdd = lettura_regimi(carica([zt]), "REPL", durata="2trimestri", lato150="giudica", dd_promesso=5000.0)
            ck("DD promesso 5000 EUR e DD di tranche 1000: 'regge' si puo' scrivere, col DD accanto", vdd.startswith("regge nei regimi MISURATI") and "<= DD promesso 5000" in vdd, vdd[:120])
            _r, vdk = lettura_regimi(carica([zt]), "REPL", durata="2trimestri", dd_promesso=500.0)
            ck("CONTRO-ESEMPIO DD: promesso 500 EUR e DD di tranche 1000 -> NON REGGE per DD anche con PF buono", vdk.startswith("NON REGGE") and "DD oltre il promesso" in vdk, vdk[:120])
            # le TRE durate danno tre risposte diverse sullo stesso dato: il parametro morde davvero (contro-esempio della decisione aperta)
            v_1a = lettura_regimi(carica([zt]), "REPL", durata="1anno")[1]
            v_365 = lettura_regimi(carica([zt]), "REPL", durata="365giorni")[1]
            ck("DURATA '1anno' (default): TORO e CALMO hanno 4 trimestri, LATERALE e VOLATILE 2 -> misurati solo TORO/CALMO -> NON BASTA", v_1a.startswith("NON BASTA") and "TORO, CALMO" in v_1a, v_1a[:120])
            ck("DURATA '365giorni': TORO = T9+T7+T5+T4 = 83+90+92+92 = 357 giorni < 365 (T9 parte dal 10/07) -> NON MISURATO", v_365.startswith("NON MISURATO") and "357 giorni" in "\n".join(lettura_regimi(carica([zt]), "REPL", durata="365giorni")[0]), v_365[:100])
            ck("stampa (7): parametri dichiarati, nota soglie tonde con T6/T1/T4/T2, SENSIBILITA' a ER 0,10 e 0,20 che NON e' un verdetto",
               "durata del regime   = '1anno'" in trx and "lato sotto 150      = 'giudica'" in trx and "T1 ER 0,116" in trx and "T2 ER 0,184" in trx and "T4 ER 0,176" in trx and "T6 ER 0,081" in trx
               and trx.count("SENSIBILITA' (NON e' un verdetto) con ER 0,10") == 1 and trx.count("SENSIBILITA' (NON e' un verdetto) con ER 0,20") == 1 and "cambiano T4 TORO->LATERALE" in trx)
            ck("orologio: 'fino al cambio (26/12/2024-02/02/2025, giorno NON MISURATO'", "fino al cambio (26/12/2024-02/02/2025, giorno NON MISURATO" in trx)
            # (classe 1253) default: 1anno -> NON BASTA, 365giorni -> NON MISURATO: il verdetto lo DICE per primo, e la stampa da' l'esito con ogni durata
            v_def = lettura_regimi(carica([zt]), "REPL")[1]
            ck("DURATA non decisa: 1anno (NON BASTA) e 365giorni (NON MISURATO) non concordano -> 'DIPENDE DALLA DURATA (decisione di Claudio aperta): 1anno -> ..., 365giorni -> ...'",
               v_def.startswith("DIPENDE DALLA DURATA (decisione di Claudio aperta): 1anno -> NON BASTA") and ", 365giorni -> NON MISURATO" in v_def, v_def[:140])
            ck("stampa (7): una riga di esito per OGNI durata (1anno in uso, 365giorni, 2trimestri)",
               "DURATA '1anno' (in uso) -> NON BASTA" in trx and "DURATA '365giorni' -> NON MISURATO" in trx and "DURATA '2trimestri' -> NON DICHIARABILE (DD promesso assente): regge" in trx)
            # (classe 1252) un DD che manca non e' un DD rispettato
            zn = _togli_dd(zt, ("T8",))
            _r, vnd = lettura_regimi(carica([zn]), "REPL", durata="2trimestri", lato150="giudica", dd_promesso=5000.0)
            ck("CONTRO-ESEMPIO DD n.d.: report di T8 senza riga DD + DD promesso 5000 -> 'NON DICHIARABILE (DD n.d. in ...)', mai 'regge'",
               vnd.startswith("NON DICHIARABILE (DD n.d. in LATERALE (T8); CALMO (T8))") and not vnd.startswith("regge"), vnd[:120])
            ck("DD n.d.: la riga del regime dice in quale tranche manca", any(r.strip().startswith("LATERALE") and "(DD n.d. in T8)" in r for r in _r))
            zn2 = _togli_dd(zt, ("T4", "T5", "T6", "T7", "T8", "T9"))
            _r, vnd2 = lettura_regimi(carica([zn2]), "REPL", durata="2trimestri", lato150="giudica", dd_promesso=5000.0)
            ck("CONTRO-ESEMPIO DD n.d. ovunque + DD promesso 5000 -> NON DICHIARABILE (prima: 'regge ... <= DD promesso')", vnd2.startswith("NON DICHIARABILE (DD n.d. in") and "<= DD promesso" in vnd2, vnd2[:100])
            _r, vnk = lettura_regimi(carica([zn]), "REPL", durata="2trimestri", dd_promesso=500.0)
            ck("DD n.d. in T8 ma DD 1000 > 500 altrove -> resta NON REGGE (fatto misurato) con la nota del DD mancante", vnk.startswith("NON REGGE: DD oltre il promesso") and "DD n.d. in" in vnk, vnk[:120])
            os.remove(zn); os.remove(zn2)
        os.remove(zt)
    # --dd-promesso: solo un numero finito > 0
    for cattivo in ("nan", "inf", "-inf", "0", "-5", "abc"):
        with contextlib.redirect_stdout(io.StringIO()):
            rc_dd = main(["--dd-promesso", cattivo, "x.zip"])
        ck("--dd-promesso %s rifiutato (rc 2), DD_PROMESSO resta assente" % cattivo, rc_dd == 2 and DD_PROMESSO is None)
    # (2o FAIL) D1: la durata scelta da riga di comando NON e' piu' 'aperta'; D2: tre NON REGGE non 'dipendono'; D3: il lato sotto 150 ha la stessa cura della durata
    salva = (DURATA_REGIME, PESO_LATO_SOTTO_150, DD_PROMESSO, DURATA_SCELTA, LATO_SCELTO)
    try:
        zt = _zip_r2reg("tutto_bene")
        pt = carica([zt])
        DURATA_REGIME, DURATA_SCELTA, DD_PROMESSO = "2trimestri", True, 5000.0      # = --durata-regime 2trimestri --dd-promesso 5000
        with contextlib.redirect_stdout(io.StringIO()):
            o1, _t = stampa(pt, None)
        verd = [x.split("): ", 1)[1] for x in o1 if x.startswith("   VERDETTO PER REGIME (cella ")][0]
        ck("D1: '--durata-regime 2trimestri --dd-promesso 5000' (lato NON scelto): il verdetto non dice piu' 'DIPENDE DALLA DURATA' (il lato resta aperto e lo dice)",
           "DIPENDE DALLA DURATA" not in verd and verd.startswith("DIPENDE DAL LATO SOTTO 150"), verd[:120])
        PESO_LATO_SOTTO_150, LATO_SCELTO = "giudica", True                          # + --lato-sotto-150 giudica
        with contextlib.redirect_stdout(io.StringIO()):
            o2, _t = stampa(pt, None)
        verd2 = [x.split("): ", 1)[1] for x in o2 if x.startswith("   VERDETTO PER REGIME (cella ")][0]
        riga_uso = [x.split(" -> ", 1)[1] for x in o2 if x.startswith("   DURATA '2trimestri' (in uso) -> ")][0]
        riga_lato = [x.split(" -> ", 1)[1] for x in o2 if x.startswith("   LATO SOTTO 150 'giudica' (in uso) -> ")][0]
        ck("D1: durata e lato scelti da riga di comando -> il VERDETTO coincide con la riga '(in uso)' e non contiene DIPENDE",
           verd2 == riga_uso == riga_lato and "DIPENDE" not in verd2 and verd2.startswith("regge nei regimi MISURATI"), verd2[:100])
        os.remove(zt)
        DURATA_REGIME, PESO_LATO_SOTTO_150, DD_PROMESSO, DURATA_SCELTA, LATO_SCELTO = salva
        zt = _zip_r2reg("short_pochi_perde")
        _r, vsp = lettura_regimi(carica([zt]), "REPL", dd_promesso=500.0)
        ck("D2: short_pochi_perde + DD promesso 500 -> NON REGGE con ogni durata e ogni lato (rischio, R59): nessun DIPENDE", vsp.startswith("NON REGGE") and "DIPENDE" not in vsp, vsp[:100])
        ck("D2: _esito confronta CATEGORIE: due NON REGGE con testi diversi concordano; NON DICHIARABILE(regge) != NON BASTA",
           _esito("NON REGGE: PF_V <= 1,0 in TORO short") == _esito("NON REGGE: DD oltre il promesso in CALMO (1 > 0 EUR)") and
           _esito("NON DICHIARABILE (DD n.d. in LATERALE (T8); CALMO (T8)): regge nei regimi") == "NON DICHIARABILE+regge" != _esito("NON BASTA: x"))
        os.remove(zt)
        zt = _zip_r2reg("uno_short")
        _r, vu = lettura_regimi(carica([zt]), "REPL", durata="2trimestri")
        ck("D3: TORO con 319 long vincenti e 1 short in perdita (n=1): con il lato NON scelto il verdetto comincia con 'DIPENDE DAL LATO'",
           vu.startswith("DIPENDE DAL LATO SOTTO 150 (decisione di Claudio aperta): giudica -> NON REGGE: PF_V <= 1,0 in TORO short") and ", non_misurato -> " in vu, vu[:160])
        rt = "\n".join(_r)
        ck("D3: la riga TORO conta 319 long e 1 short", "(long 319, short 1)" in rt, [x for x in _r if x.strip().startswith("TORO")][:1])
        _r, vu2 = lettura_regimi(carica([zt]), "REPL")
        ck("D3: durata E lato non scelti -> il verdetto dice tutte e due le dipendenze, durata per prima", vu2.startswith("DIPENDE DALLA DURATA") and " || DIPENDE DAL LATO SOTTO 150" in vu2, vu2[:80])
        with contextlib.redirect_stdout(io.StringIO()):
            o3, _t = stampa(carica([zt]), None)
        ck("(7): una riga per ogni valore di --lato-sotto-150 ('giudica' in uso, 'non_misurato')", sum(1 for x in o3 if x.startswith("   LATO SOTTO 150 'giudica' (in uso) -> ")) == 1 and sum(1 for x in o3 if x.startswith("   LATO SOTTO 150 'non_misurato' -> ")) == 1)
        os.remove(zt)
    finally:
        DURATA_REGIME, PESO_LATO_SOTTO_150, DD_PROMESSO, DURATA_SCELTA, LATO_SCELTO = salva
    # (lato vuoto) cella solo-long (InpAllowShort=false): lo short ha n=0, NON e' un PF <= 1
    zt = _zip_r2reg("solo_long")
    rgl, vgl = lettura_regimi(carica([zt]), "REPL", durata="2trimestri")
    ck("CONTRO-ESEMPIO lato vuoto: cella solo-long -> nessun 'NON REGGE ... short' (prima era un falso certificato di morte)", "NON REGGE" not in vgl and "short" not in vgl.split(":")[0], vgl[:110])
    ck("lato vuoto: la riga dice 'lato short spento/assente, n=0' e giudica il solo long", any(r.strip().startswith("TORO") and "lato short spento/assente, n=0" in r and "PF_V > 1,0 su long" in r for r in rgl))
    os.remove(zt)
    # (classe 1253) il LATERALE 363 giorni: R2REG (T8+T6) + R1A (T3+T1) = 4 trimestri ma 92+91+89+91 = 363 giorni
    if os.path.exists(zr):
        zt = _zip_r2reg("tutto_bene")
        rgm, _v = lettura_regimi(carica([zt, zr]), "REPL", durata="365giorni")
        _r1, v1m = lettura_regimi(carica([zt, zr]), "REPL", durata="1anno")
        ck("LATERALE R2REG+R1A: 4 trimestri (MISURATO con 1anno) ma 363 giorni (NON MISURATO con 365giorni)",
           any(r.strip().startswith("LATERALE") and "[4 tranche, 363 giorni]" in r and "NON MISURATO (durata: 363 < 365 giorni" in r for r in rgm)
           and any(r.strip().startswith("LATERALE") and "MISURATO, " in r and "NON MISURATO" not in r for r in _r1))
        os.remove(zt)
    # (v5) PESO DI UN LATO SOTTO 150: toro con 240 long vincenti e 80 short perdenti (n regime 320 >= 150, lato short < 150)
    zt = _zip_r2reg("short_pochi_perde")
    rgs, vgs = lettura_regimi(carica([zt]), "REPL", durata="2trimestri", lato150="giudica")
    rgn, vgn = lettura_regimi(carica([zt]), "REPL", durata="2trimestri", lato150="non_misurato")
    ck("LATO < 150, 'giudica' (default letterale): lo short con 80 operazioni e PF < 1 CONTA -> NON REGGE TORO short", vgs.startswith("NON REGGE") and "TORO short" in vgs, vgs[:100])
    ck("LATO < 150, 'non_misurato': lo short non giudica, il toro si legge sul solo long -> nessun 'NON REGGE'", "NON REGGE" not in vgn and any(r.strip().startswith("TORO") and "lato NON MISURATO, n<150: short" in r and "PF_V > 1,0 su long" in r for r in rgn), vgn[:100])
    os.remove(zt)
    # (v5) FILE PROVA DICHIARATIVI: asse qualunque, ancora da R1A, gemelle fra zip, doppioni e sovrapposizioni, nomi di cella uguali su assi diversi
    za = _zip_v5("R1A", [("REPL", "InpSpreadMaxATR", "0.05", t_, "775800", {}) for t_ in ("T1", "T2", "T3")], fine_t1="2026.09.30", storico=True)
    zu = _zip_v5("R2UA", [("B990", "InpBE_TriggerATR", "99.0", t_, "775800", {"InpBE_TriggerATR": "99.0"}) for t_ in ("T1", "T2", "T3")]
                 + [("REPL", "InpBE_TriggerATR", "1.0", "T1", "775850", {})], fine_t1="2026.09.30")
    pv = carica([za, zu])
    with contextlib.redirect_stdout(io.StringIO()):
        outv, tabv = stampa(pv, None)
    tv = "\n".join(outv)
    ck("dichiarativo: cella col SUO asse nell'intestazione e lotto dichiarato", "CELLA B990 [lotto R2UA] (InpBE_TriggerATR 99.0)" in tv and "lotti di file prova DICHIARATIVI: R2UA" in tv, [x for x in outv if "CELLA B990" in x][:1])
    ck("dichiarativo: S7 trova l'ANCORA (la REPL di R1A differisce SOLO in InpBE_TriggerATR, stesse tranche) e con 2 punti NON legge un altopiano",
       "(S7) FRONTIERA del lotto R2UA lungo l'asse InpBE_TriggerATR (Modello 4): 2 punti" in tv and "(ancora, lotto R1A)" in tv and "solo 2 punti" in tv)
    ck("dichiarativo: G1 della gemella 775850 contro la 775800 di R1A (altro zip, stessa identita' dall'ini) -> VERDE", any("G1 gemelle (cella REPL, tranche T1" in x and "VERDE" in x for x in outv), [x for x in outv if "G1 gemelle (cella REPL" in x][:1])
    za2 = _zip_v5("R1A", [("REPL", "InpSpreadMaxATR", "0.05", t_, "775800", {"InpTrail_ATR": "3.5"}) for t_ in ("T1", "T2", "T3")], fine_t1="2026.09.30", storico=True)
    with contextlib.redirect_stdout(io.StringIO()):
        outa2, _t = stampa(carica([za2, zu]), None)
    ta2 = "\n".join(outa2)
    ck("CONTRO-ESEMPIO S7: una REPL che differisce anche in InpTrail_ATR NON e' un'ancora dell'asse InpBE_TriggerATR (1 punto solo, nessuna '(ancora')",
       "(ancora, lotto R1A)" not in ta2 and "lungo l'asse InpBE_TriggerATR (Modello 4): 1 punti" in ta2)
    os.remove(za2)
    zu2 = _zip_v5("R2UA", [("REPL", "InpBE_TriggerATR", "1.0", "T1", "775850", {})], fine_t1="2026.09.30", profitto_extra=5.0)
    with contextlib.redirect_stdout(io.StringIO()):
        outg, _t = stampa(carica([za, zu2]), None)
    ck("CONTRO-ESEMPIO G1 dichiarativo: gemella con profitto diverso di 5 EUR -> ROSSO", any("G1 gemelle (cella REPL, tranche T1" in x and "ROSSO" in x for x in outg))
    zd = _zip_v5("R2UA", [("REPL", "InpBE_TriggerATR", "1.0", "T1", "775800", {})], fine_t1="2026.09.30")
    err_d = controlla_doppioni(carica([za, zd], controlla=False))
    ck("CONTRO-ESEMPIO: la REPL T1 775800 rifatta in un file dichiarativo (stessi input, asse diverso nel manifest) e' la STESSA misura di R1A -> ERRORE (ini)", len(err_d) == 1 and "caricata DUE volte" in err_d[0], err_d)
    zo = _zip_v5("R2UA", [("REPL", "InpBE_TriggerATR", "1.0", "T1", "775800", {})], fine_t1="2026.10.01")
    err_o = controlla_doppioni(carica([za, zo], controlla=False))
    ck("CONTRO-ESEMPIO: T1 07.01-10.01 contro il T1 07.01-09.30 di R1A, stessa cella e magic -> finestre SOVRAPPOSTE = ERRORE", len(err_o) == 1 and "SOVRAPPOSTE" in err_o[0], err_o)
    zx = _zip_v5("R2UX", [("C05", "InpBE_TriggerATR", "0.5", "T1", "775800", {"InpBE_TriggerATR": "0.5"})], fine_t1="2026.09.30")
    zy = _zip_v5("R2UY", [("C05", "InpTrail_ATR", "1.5", "T1", "775800", {"InpTrail_ATR": "1.5"})], fine_t1="2026.09.30")
    pxy = carica([zx, zy])
    with contextlib.redirect_stdout(io.StringIO()):
        oxy, _t = stampa(pxy, None)
    ck("stesso NOME di cella (C05) su due assi diversi: nessun falso doppione, due blocchi separati (chiave modello, lotto, cella, asse)",
       not controlla_doppioni(pxy) and sum(1 for x in oxy if x.startswith(" CELLA C05")) == 2)
    zt1 = _zip_v5("R2UZ", [("C05", "InpBE_TriggerATR", "0.5", "T1", "775800", {"InpBE_TriggerATR": "0.5"})], fine_t1="2026.10.01", da_t1="2026.08.01")
    pz = carica([zt1])
    ck("una tranche chiamata T1 ma che NON parte il 2026.07.01 non prende il regime di T1 (TRANCHE_DA)", regime_di(pz[0]) is None)
    zv = _zip_v5("R1A", [("REPL", "InpSpreadMaxATR", "0.05", "T1", "775800", {})], fine_t1="2026.09.30", storico=True, ini=False)
    pzv = carica([zv])
    ck("zip vecchio (manifest v3/v4 senza colonne v5, senza ini): asse InpSpreadMaxATR, XAUUSD M1, identita' dal manifest", pzv[0]["asse"] == "InpSpreadMaxATR" and pzv[0]["simbolo"] == "XAUUSD" and pzv[0]["periodo"] == "M1" and not pzv[0]["da_ini"])
    for pth in (za, zu, zu2, zd, zo, zx, zy, zt1, zv):
        os.remove(pth)
    print("")
    if falliti:
        print("AUTOTEST FALLITO: %d controlli: %s" % (len(falliti), ", ".join(falliti)))
        return 1
    print("AUTOTEST OK")
    return 0


def _togli_dd(zpath, tranche):
    """(classe 1252) copia dello zip finto con la riga 'Equita' Drawdown Massima' TOLTA dal report delle tranche date: DD n.d. per quelle passate."""
    import tempfile
    f = tempfile.NamedTemporaryFile(suffix=".zip", delete=False)
    f.close()
    zi, zo = zipfile.ZipFile(zpath), zipfile.ZipFile(f.name, "w")
    for n in zi.namelist():
        b = zi.read(n)
        if n.startswith("report") and any(("_%s_" % tr) in n for tr in tranche):
            b = ("\ufeff" + decodifica(b).replace("Equit\u00e0 Drawdown Massima:", "RIGA TOLTA:")).encode("utf-16-le")
        zo.writestr(n, b)
    zi.close(); zo.close()
    return f.name


def _zip_r2reg(tipo):
    """Zip finto del lotto R2REG (REPL, 6 tranche T4..T9) con risposta nota. tipo:
    'laterale_perde'  : toro PF 1,6 (n 320), laterale PF 0,5 (n 160)   -> NON REGGE (LATERALE)
    'solo_toro'       : toro PF 1,6 (n 320), laterale con 30 operazioni per tranche (n 60) -> LATERALE NON MISURATO -> NON BASTA (solo toro)
    'tutto_bene'      : toro e laterale PF 1,6, n>=150                  -> regge nei regimi misurati
    'short_perde_toro': nel toro il long vince e lo short perde (PF short < 1) -> NON REGGE (TORO short)"""
    import tempfile
    tranche = {"T4": "2025.10.01", "T5": "2025.07.01", "T6": "2025.04.01", "T7": "2025.01.01", "T8": "2024.10.01", "T9": "2024.07.10"}
    # (v5) T8 della partizione parte il 2024.10.01 (TRANCHE_DA); le sue operazioni finte partono dal 20/10 per cadere anche nella finestra dell'orologio incerto
    inizio_op = dict(tranche, T8="2024.10.20")
    fine = {"T4": "2026.01.01", "T5": "2025.10.01", "T6": "2025.07.01", "T7": "2025.04.01", "T8": "2025.01.01", "T9": "2024.10.01"}
    righe, z = [], None
    f = tempfile.NamedTemporaryFile(suffix=".zip", delete=False)
    f.close()
    z = zipfile.ZipFile(f.name, "w")
    k = 0
    for tr in ("T4", "T5", "T6", "T7", "T8", "T9"):
        toro = REGIMI_TRANCHE[tr][0] == "TORO"
        n = 80 if (toro or tipo in ("laterale_perde", "tutto_bene", "short_pochi_perde", "solo_long", "uno_short")) else 30
        k += 1
        base = datetime.datetime.strptime(inizio_op[tr], "%Y.%m.%d") + datetime.timedelta(hours=1)
        lista, nets = [], []
        cont = {"buy": 0, "sell": 0}
        for i in range(n):
            lato = "buy" if i % 2 == 0 else "sell"
            vince = ((i // 2) % 2 == 0)
            if tipo == "uno_short":
                # (2o FAIL, D3) toro: tutti long vincenti (PF 1,6) tranne UN solo short in perdita, il primo di T4; altrove alternati e vincenti
                if toro:
                    lato = "sell" if (tr == "T4" and i == 0) else "buy"
                vince = (cont[lato] % 2 == 0)
                cont[lato] += 1
                prof = -200.0 if (toro and lato == "sell") else (160.0 if vince else -100.0)
            elif tipo == "solo_long":
                lato = "buy"
                prof = 160.0 if vince else -100.0
            elif tipo == "short_pochi_perde":
                # (v5) toro: 3 long ogni short (60 long vincenti PF 1,6 e 20 short perdenti per tranche); altrove alternati e vincenti
                lato = ("sell" if i % 4 == 0 else "buy") if toro else lato
                vince = (cont[lato] % 2 == 0)
                cont[lato] += 1
                prof = (50.0 if vince else -200.0) if (toro and lato == "sell") else (160.0 if vince else -100.0)
            elif tipo == "laterale_perde" and not toro:
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


# (v5) i 30 pin di GBA_R2_REGIME_2026-10-10.txt (r.274-304): la base degli ini finti
_PIN_BASE = {"InpSymbol": "XAUUSD", "InpSignalTF": "1", "InpTrendTF": "0", "InpAtrTF": "0", "InpChannelBars": "48", "InpEmaPeriod": "100", "InpAtrPeriod": "14",
             "InpSpreadMaxATR": "0.05", "InpAllowLong": "true", "InpAllowShort": "true", "InpSL_ATR": "2.5", "InpTrail_ATR": "2.5", "InpTrailAtrMode": "0",
             "InpTimeExitBars": "48", "InpUseBreakeven": "true", "InpBE_TriggerATR": "1.0", "InpBE_OffsetATR": "0.0", "InpSlippagePoints": "30", "InpMaxDailyLoss": "0.0",
             "InpMaxTradesPerDay": "0", "InpCheckFreeMargin": "true", "InpHourStart": "0", "InpHourEnd": "24", "InpLotMode": "0", "InpLots": "1.0", "InpRiskPct": "0.25",
             "InpComment": "GBA", "InpUsaGuardian": "true", "InpVerbose": "true", "InpAutoTest": "true"}


def _zip_v5(lotto, voci, fine_t1="2026.09.30", da_t1="2026.07.01", storico=False, ini=True, profitto_extra=0.0):
    """(v5) zip finto come lo scrive il driver v5: voci = [(cella, asse, valore, tranche, magic, input_cambiati)]. Ogni passata ha le STESSE 40 operazioni
    (cosi' due gemelle sono identiche per costruzione), il suo ini (se ini=True) e, se storico=False, le 5 colonne in coda al manifest.
    storico=True + ini=False imita uno zip v3/v4 (manifest a 27 colonne, nessun ini)."""
    import tempfile
    finestre = {"T1": (da_t1, fine_t1), "T2": ("2026.04.01", "2026.06.30"), "T3": ("2026.01.01", "2026.03.31")}
    f = tempfile.NamedTemporaryFile(suffix=".zip", delete=False)
    f.close()
    z = zipfile.ZipFile(f.name, "w")
    righe = []
    for k, (cella, asse, valore, tr, mg, cambi) in enumerate(voci, 1):
        da, a = finestre[tr]
        base = datetime.datetime.strptime(da, "%Y.%m.%d") + datetime.timedelta(hours=1)
        lista = [((base + datetime.timedelta(hours=i * 11)).strftime("%Y.%m.%d %H:%M:%S"), "buy" if i % 3 else "sell", 90.0 if i % 2 == 0 else -100.0, 4.0, 0.10, 6) for i in range(40)]
        nets = [x[2] for x in lista]
        dd, lg = _sintetico(lista)
        tag = "%s_%02d_%s_%s_m%s" % (lotto, k, cella, tr, mg)
        z.writestr("report\\GBA_R0_" + tag + ".htm", _htm(dd, 40, _fmt(sum(nets) + (profitto_extra if mg == "775850" else 0.0)), "%.2f" % pf_di(nets), periodo="M1 (%s - %s)" % (da, a)))
        z.writestr("log\\GBA_" + tag + ".txt", "\r\n".join(["# passata finta"] + lg))
        if ini:
            inp = dict(_PIN_BASE, **cambi)
            testo = "[Experts]\r\nAllowLiveTrading=false\r\n\r\n[Tester]\r\nExpert=ABTG_GoldBreakoutATR.ex5\r\nSymbol=%s\r\nPeriod=M1\r\nModel=4\r\nFromDate=%s\r\nToDate=%s\r\n\r\n[TesterInputs]\r\n" % (inp["InpSymbol"], da, a)
            testo += "\r\n".join("%s=%s" % (kk, vv) for kk, vv in inp.items()) + "\r\nInpMagic=%s\r\n" % mg
            z.writestr("ini\\gba_" + tag + ".ini", testo)
        spread = dict(_PIN_BASE, **cambi)["InpSpreadMaxATR"]
        riga = "%s;%s;%s;%s;%s;%s;%s;4;%s;2026-10-10 10:00:00;60;OK;40;%s;%.2f;100%%ticksreali;88000;;88000;25000000;;100;40;si;si;%s-%s;" % (
            lotto, tag, cella, spread, tr, da, a, mg, sum(nets), pf_di(nets), da, a)
        if not storico:
            riga += ";%s;%s;XAUUSD;M1;PROVA_FINTA.txt" % (asse, valore)
        righe.append(riga)
    cols = "lotto;passata;cella;spread_max_atr;tranche;da;a;modello;magic;t_avvio;durata_s;stato;trades_report;profitto_report;pf_report;qualita;barre_report;ticks_report;barre_gen;ticks_gen;ticks_inizio;righe_gba;ingressi_log;avvio_ok;autotest;finestra;motivi"
    if not storico:
        cols += ";asse;valore_asse;simbolo;periodo;prova"
    z.writestr("MANIFEST_R0.csv", cols + "\n" + "\n".join(righe) + "\n")
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
    global DURATA_REGIME, PESO_LATO_SOTTO_150, DD_PROMESSO, DURATA_SCELTA, LATO_SCELTO
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
        # (v5) le decisioni APERTE di Claudio come parametri (default = lettura letterale della firma 10/10)
        if argv[i] == "--durata-regime" and i + 1 < len(argv):
            if argv[i + 1] not in DURATE_REGIME:
                print("--durata-regime: ammessi %s" % ", ".join(sorted(DURATE_REGIME)))
                return 2
            DURATA_REGIME = argv[i + 1]
            DURATA_SCELTA = True
            i += 2
            continue
        if argv[i] == "--lato-sotto-150" and i + 1 < len(argv):
            if argv[i + 1] not in LATI_SOTTO_150:
                print("--lato-sotto-150: ammessi %s" % ", ".join(LATI_SOTTO_150))
                return 2
            PESO_LATO_SOTTO_150 = argv[i + 1]
            LATO_SCELTO = True
            i += 2
            continue
        if argv[i] == "--dd-promesso" and i + 1 < len(argv):
            try:
                ddp = float(argv[i + 1])
            except ValueError:
                ddp = float("nan")
            if not (math.isfinite(ddp) and ddp > 0):
                print("--dd-promesso: serve un numero finito > 0 in EUR (ricevuto '%s'): nan, inf, 0 o negativo non sono un DD promesso" % argv[i + 1])
                return 2
            DD_PROMESSO = ddp
            i += 2
            continue
        if argv[i].startswith("--"):
            print("opzione sconosciuta: %s" % argv[i])
            return 2
        zs.append(argv[i])
        i += 1
    if not zs:
        print(__doc__)
        return 2
    stampa(carica(zs), csv_out)
    return 0


if __name__ == "__main__":
    sys.exit(main(sys.argv[1:]))
