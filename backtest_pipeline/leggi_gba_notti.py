#!/usr/bin/env python3
# -*- coding: ascii -*-
"""
leggi_gba_notti.py -- LETTURA PER NOTTE del lotto R2NOTTE di GBA (ABTG_GoldBreakoutATR v1.10, XAUUSD, tick reali).
BOZZA, NON passata dal cancello (controllo-preventivo): non leggere dati veri finche' i due strati del cancello non danno PASS.

PERCHE' ESISTE. Il lettore leggi_gba_r0.py (SHA256 9CD02D2A..., re-gate PASS al commit 7b4b6c53) NON aggrega per notte e NON si tocca. Questo file lo IMPORTA
(riusa i suoi parser: Sorgente, leggi_report, accoppia, leggi_log, costruisci_passata, posizioni_numeriche, costo_ingressi, carica con il controllo dei doppioni,
gemelle_dichiarative) dopo aver verificato che il suo SHA256 sia quello pinnato: se il lettore e' cambiato, questo script si FERMA. Duplicato qui: niente
dei parser; sono scritti qui solo la lettura dei file prova (attese e soglie) e le statistiche per notte.

COSA LEGGE. Gli zip dei lotti R2NOTTEM1 (cella N7: InpHourEnd=7) e R2NOTTEM5 (cella M5: InpSignalTF=5, InpHourEnd=7), anche dentro un unico GBA_R2_NOTTE.zip
(zip annidati: vengono estratti in una cartella temporanea e caricati tutti insieme, cosi' il controllo dei doppioni vede tutto). Stessa struttura degli zip R2:
MANIFEST_R0.csv, report\\*.htm (deal), log\\, ini\\. Qualunque lotto che NON e' uno dei due lotti notte dichiarati nei file prova risulta NON APPLICABILE (nessun
numero per notte: il filtro orario non c'e').

COME SI LEGGE (nell'ordine che il file prova impone: i numeri PRIMA di ogni lettura)
  (1) CONTROLLO DIRETTO: il 100% dei deal d'ingresso (non solo le posizioni accoppiate) deve avere ora SERVER dentro la fascia dichiarata nella prova
      (InpHourStart <= ora < InpHourEnd, qui 0-6). ANCHE UNO fuori = 'FILTRO NON COME DICHIARATO': la passata non si legge, il totale della cella non si calcola.
      Stesso trattamento per gli input dell'ini diversi da quelli dichiarati (pin + cella del file prova), per le date di tranche e per il G0 del lettore.
  (2) n, costo (2,5 x ATR / (spread + 0,04 USD/oz), mediana sugli ingressi) e PF_V (convenzione del lettore: profitto + swap + commissione, 3,90 EUR/lotto a giro
      se il tester non ne addebita) per tranche e totale: PRIMA di ogni lettura.
  (3) le attese scritte nel file prova, LETTE DAL FILE a runtime (riga citata) accanto ai numeri: dentro/fuori attesa. Nessuna soglia e' scritta nello script.
  (4) NOTTE = data server con almeno un ingresso nella fascia; netto di notte = somma dei netti PF_V delle posizioni ENTRATE quella notte. q = quota di notti con
      netto < 0; finestre scorrevoli di L notti consecutive (con ingressi, dentro la stessa tranche) senza notti negative contro il caso nullo (1-q)^L; lettura
      con le soglie del file prova (derivate dell'autore); bootstrap PER NOTTE (non per operazione) di q e del PF; autocorrelazione del netto per notte lag 1-3
      e q condizionata alla notte precedente (Gemini B3: MISURA, non criterio). CONCENTRAZIONE PER NOTTE: netto senza le 3 e le 5 migliori notti, per passata e totale;
      'netto senza le 3 migliori notti <= 0' = FRAGILE PER NOTTE (soglia letta dai file prova, o 3 DERIVATA dal cancello se non scritta); S5 del lettore conta le operazioni e non lo vede.
  (5) confronto M1 notte contro M5 notte sullo stesso insieme di notti (per tranche) e contro le ANCORE post-hoc di R1A, calcolate dagli stessi deal archiviati.
  (6) l'ipotesi H-M5N del collega, INTERA come nel file prova, con la dichiarazione di cosa questo lotto misura.
Non scrive verdetti: 'NON ANCORA MISURATO' / 'dentro attesa' / 'fuori attesa'. Non scrive la parola vietata dal certificato dei 5 punti.

USO (sempre con -I)
  python3 -I backtest_pipeline/leggi_gba_notti.py GBA_R2_NOTTE.zip
  python3 -I backtest_pipeline/leggi_gba_notti.py GBA_R0_R2NOTTEM1.zip GBA_R0_R2NOTTEM5.zip
  opzioni: --prova-m1 F  --prova-m5 F   (default: backtest_pipeline/prove/GBA_R2_NOTTEM{1,5}_*.txt, l'ultimo in ordine alfabetico: al HEAD della lettura)
           --ancora ZIP_R1A   (default: archivio R1A)   --g1 ZIP_R2TTREND (default: archivio R2 senza codice)   --senza-ancora
           --bootstrap N (default 5000)   --seed S (default 20261010)
  python3 -I backtest_pipeline/leggi_gba_notti.py --autotest
  uscita: 0 letto; 1 ERRORE (nessun numero); 2 nessun lotto applicabile; 3 almeno una passata NON LEGGIBILE (filtro/ini/G0).
"""
import bisect, contextlib, datetime, hashlib, importlib.util, io, math, os, random, re, statistics, subprocess, sys, tempfile, zipfile

sys.dont_write_bytecode = True      # non scrivere __pycache__ nel repo (il lettore e' importato da file)

QD = os.path.dirname(os.path.abspath(__file__))
REPO = os.path.abspath(os.path.join(QD, ".."))
VERSIONE = "leggi_gba_notti v1 (bozza)"
LETTORE_PATH = os.path.join(QD, "leggi_gba_r0.py")
LETTORE_SHA256 = "9CD02D2A3BD30E3DF555F20FC0342CFCCCAB80222AD671F0BF727BE1DEAF862F"   # PASS del re-gate al commit 7b4b6c53
PROVE_DIR = os.path.join(QD, "prove")
PIANO_PATH = os.path.join(REPO, "report", "GBA_R2_PIANO_2026-10-10.md")
ARCH = os.path.join(QD, "risultati_archivio")
R1A_ZIP = os.path.join(ARCH, "GBA_R0_R1A_20261010", "GBA_R0_R1A.zip")
R2_DIR = os.path.join(ARCH, "GBA_R2_SENZA_CODICE_20261010")
R2TTREND_ZIP = os.path.join(R2_DIR, "GBA_R0_R2TTREND.zip")
SEED_DEFAULT = 20261010
BOOT_DEFAULT = 5000
N_MIN_MERITO = 150          # S1 del file madre (stesso valore del lettore: lg.N_MIN, riletto a runtime)
QUALITA_ATTESA = "100%ticksreali"
VIETATA = re.compile(r"mort[oae]", re.I)   # la parola vietata dal certificato dei 5 punti: se compare in un testo CITATO dal file prova, e' mascherata

lg = None                   # il lettore, caricato da carica_lettore()


class ErroreLettura(Exception):
    pass


# ---------------------------------------------------------------------------------------------------------------------
#  IL LETTORE PINNATO
# ---------------------------------------------------------------------------------------------------------------------
def sha256_file(p):
    return hashlib.sha256(open(p, "rb").read()).hexdigest().upper()


def carica_lettore(percorso=LETTORE_PATH, pin=LETTORE_SHA256):
    global lg
    if not os.path.isfile(percorso):
        raise ErroreLettura("lettore non trovato: %s" % percorso)
    sha = sha256_file(percorso)
    if sha != pin.upper():
        raise ErroreLettura("il lettore %s ha SHA256 %s, NON quello pinnato %s (PASS del re-gate): questo script non lo importa. Se il lettore e' cambiato "
                            "legittimamente, va ripassato dal cancello anche questo script." % (percorso, sha, pin.upper()))
    spec = importlib.util.spec_from_file_location("leggi_gba_r0_pinnato", percorso)
    mod = importlib.util.module_from_spec(spec)
    spec.loader.exec_module(mod)
    lg = mod
    return mod


# ---------------------------------------------------------------------------------------------------------------------
#  UTILITA' DI TESTO
# ---------------------------------------------------------------------------------------------------------------------
def asc(s):
    """testo CITATO da un file: solo ASCII, e la parola vietata mascherata (dichiarato in stampa)."""
    s = s.encode("ascii", "replace").decode("ascii")
    return VIETATA.sub("[x]", s)


def fnum(s):
    return float(str(s).replace(",", "."))


def f2(x, d=2):
    if x is None:
        return "n.d."
    if isinstance(x, float) and x != x:
        return "n.d."
    return ("%." + str(d) + "f") % x


def fpf(x):
    if x is None or (isinstance(x, float) and x != x):
        return "n.d."
    if x == float("inf"):
        return "inf"
    return "%.3f" % x


def git(args):
    try:
        r = subprocess.run(["git", "-C", REPO] + args, stdout=subprocess.PIPE, stderr=subprocess.PIPE, timeout=20)
        if r.returncode != 0:
            return None
        return r.stdout.decode("ascii", "replace").strip()
    except Exception:
        return None


def info_git(percorso):
    """{'head': sha|None, 'ultimo': sha dell'ultimo commit che ha toccato il file|None, 'sporco': True/False/None}"""
    rel = os.path.relpath(percorso, REPO).replace(os.sep, "/")
    head = git(["rev-parse", "HEAD"])
    ultimo = git(["log", "-1", "--format=%H", "--", rel])
    st = git(["status", "--porcelain", "--", rel])
    return {"head": head, "ultimo": ultimo or None, "sporco": (None if st is None else bool(st))}


def descr_git(g):
    if g["head"] is None:
        return "git non disponibile (commit NON dichiarabile)"
    s = "HEAD %s, ultimo commit che tocca il file %s" % (g["head"][:8], (g["ultimo"] or "?")[:8])
    if g["sporco"]:
        s += ", FILE MODIFICATO NON COMMITTATO (differisce dal commit)"
    return s


# ---------------------------------------------------------------------------------------------------------------------
#  I FILE PROVA: pin, celle, tranche, lotto, sezioni, attese e soglie (LETTE a runtime)
# ---------------------------------------------------------------------------------------------------------------------
RE_INTEST = re.compile(r"^\s*=+\s+(\S.*?)\s+=+\s*$")


def leggi_prova(percorso):
    raw = open(percorso, "rb").read()
    testo = raw.decode("latin-1")
    P = {"percorso": percorso, "nome": os.path.basename(percorso), "sha256": hashlib.sha256(raw).hexdigest().upper(), "pin": {}, "celle": {}, "tranche": {}, "lotto": None,
         "modello": None, "passate": [], "gemelle": [], "asse": None, "commenti": [], "sezioni": [], "git": info_git(percorso)}
    for n, r in enumerate(testo.splitlines(), 1):
        r = r.rstrip("\r")
        if r.startswith("#"):
            body = r[1:]
            if body.startswith(" "):
                body = body[1:]
            P["commenti"].append((n, body))
            m = re.match(r"^\s*@GBA-(\w+)\s+(.*)$", body)
            if m:
                kv = dict(t.split("=", 1) for t in m.group(2).split() if "=" in t)
                if m.group(1) == "TRANCHE" and "nome" in kv:
                    P["tranche"][kv["nome"]] = (kv.get("da"), kv.get("a"))
                elif m.group(1) == "CELLA" and "nome" in kv:
                    P["celle"][kv["nome"]] = {k: v for k, v in kv.items() if k != "nome"}
                elif m.group(1) == "LOTTO":
                    P["lotto"] = kv.get("nome")
                    P["modello"] = kv.get("modello")
                    for x in kv.get("passate", "").split(","):
                        parti = x.split(":")
                        if len(parti) == 2:
                            P["passate"].append((parti[0], parti[1]))
                        elif len(parti) == 3:          # gemella: cella:tranche:magic
                            P["gemelle"].append((parti[0], parti[1], parti[2]))
                elif m.group(1) == "ASSE":
                    P["asse"] = kv.get("chiave")
        elif "=" in r and not r.strip().startswith(";"):
            k, v = r.split("=", 1)
            if k.strip().startswith("Inp"):
                P["pin"][k.strip()] = v.strip()
    cur = None
    for n, b in P["commenti"]:
        m = RE_INTEST.match(b)
        if m:
            cur = {"titolo": m.group(1), "riga": n, "righe": []}
            P["sezioni"].append(cur)
        elif cur is not None:
            cur["righe"].append((n, b))
    return P


def inputs_attesi(P, cella):
    """pin + override della cella, senza InpMagic (e' un'etichetta tecnica dell'asse)."""
    d = {k: v for k, v in P["pin"].items() if k != "InpMagic"}
    d.update(P["celle"].get(cella, {}))
    return d


def testo_con_righe(righe):
    """righe = [(n, testo)] -> (stringa unica, [(offset, n)]) per risalire alla riga del file prova."""
    parti, offs, pos = [], [], 0
    for n, b in righe:
        s = b.strip()
        offs.append((pos, n))
        parti.append(s)
        pos += len(s) + 1
    return " ".join(parti), offs


def riga_di(offs, p):
    i = bisect.bisect_right([o for o, _ in offs], p) - 1
    return offs[max(i, 0)][1]


def sezioni_per(P, *chiavi):
    return [s for s in P["sezioni"] if any(k in s["titolo"].upper() for k in chiavi)]


def estrai_attese(P):
    """{'n_banda': [...], 'n_smentita': {...}, 'pf_banda': [...], 'costo_banda': [...], 'costo_punto': [...], 'notti_punto', 'notti_max', 'q_banda': [...]}.
    Ogni voce porta la riga del file prova e il frammento letto. Quello che non si trova NON e' inventato: la chiave resta vuota."""
    out = {"n_banda": [], "n_smentita": {}, "pf_banda": [], "costo_banda": [], "costo_punto": [], "notti_punto": [], "notti_max": [], "notti_banda": [], "q_banda": [], "sezioni_trovate": []}
    att = sezioni_per(P, "ATTESE")
    cri = sezioni_per(P, "CRITERIO DI EMILIANO", "NESSUNA NOTTE")
    out["sezioni_trovate"] = [(s["titolo"], s["riga"]) for s in att + cri]
    for sez, ruolo in [(s, "att") for s in att] + [(s, "cri") for s in cri]:
        t, offs = testo_con_righe(sez["righe"])
        if ruolo == "att":
            for m in re.finditer(r"banda\s+[\d,.x]+\s*-\s*[\d,.x]+\s*=\s*(\d+)\s*-\s*(\d+)", t):
                out["n_banda"].append((int(m.group(1)), int(m.group(2)), riga_di(offs, m.start()), m.group(0)))
            if not out["n_banda"]:
                for m in re.finditer(r"(?<![A-Za-z_])n\s+(\d+)\s*-\s*(\d+)\b", t):
                    out["n_banda"].append((int(m.group(1)), int(m.group(2)), riga_di(offs, m.start()), m.group(0)))
            for m in re.finditer(r"PF_V\s+(\d[,.]\d+)\s*-\s*(\d[,.]\d+)", t):
                out["pf_banda"].append((fnum(m.group(1)), fnum(m.group(2)), riga_di(offs, m.start()), m.group(0)))
            for m in re.finditer(r"costo mediano atteso\s+(\d+)\s*-\s*(\d+)\s*x", t, re.I):
                out["costo_banda"].append((int(m.group(1)), int(m.group(2)), riga_di(offs, m.start()), m.group(0)))
            for m in re.finditer(r"costo mediano\s*~\s*(\d+)\s*x", t, re.I):
                out["costo_punto"].append((int(m.group(1)), riga_di(offs, m.start()), m.group(0)))
            for m in re.finditer(r"Notti:\s*~\s*(\d+)\s*,\s*negative\s*~\s*(\d+)", t):
                out["notti_punto"].append((int(m.group(1)), int(m.group(2)), riga_di(offs, m.start()), m.group(0)))
            for m in re.finditer(r"Notti con almeno un ingresso:.{0,60}?banda larga\s+(\d+)\s*-\s*(\d+)", t):
                out["notti_banda"].append((int(m.group(1)), int(m.group(2)), riga_di(offs, m.start()), m.group(0)))
            for m in re.finditer(r"Notti:\s*<=\s*~?\s*(\d+)", t):
                out["notti_max"].append((int(m.group(1)), riga_di(offs, m.start()), m.group(0)))
            ms = re.search(r"SMENTITE:(.*?)(?:PASSATE:|$)", t)
            if ms and not out["n_smentita"]:
                par = ms.group(1)
                base = ms.start(1)
                lo = re.search(r"(?<![A-Za-z_])n\s*<\s*(\d+)(?![\d,.])", par)
                hi = re.search(r">(?!=)\s*(\d+)(?![\d,.])", par)
                out["n_smentita"] = {"lo": (int(lo.group(1)), riga_di(offs, base + lo.start()), lo.group(0)) if lo else None,
                                     "hi": (int(hi.group(1)), riga_di(offs, base + hi.start()), hi.group(0)) if hi else None}
        for m in re.finditer(r"(?<![A-Za-z_])q\s+(\d[,.]\d+)\s*-\s*(\d[,.]\d+)", t):
            out["q_banda"].append((fnum(m.group(1)), fnum(m.group(2)), riga_di(offs, m.start()), m.group(0), sez["titolo"][:40]))
    return out


def estrai_soglie_notti(P):
    """Soglie della lettura per notte, dal file prova: {'n_min', 'q_alta', 'q_bassa', 'finestra', 'riga'} (None = non lette)."""
    s = {"n_min": None, "q_alta": None, "q_bassa": None, "finestra": None, "riga": None, "k_fragile": None, "k_riga": None, "k_extra": [], "k_derivata": False}
    for sez in sezioni_per(P, "CRITERIO DI EMILIANO", "NESSUNA NOTTE"):
        t, offs = testo_con_righe(sez["righe"])
        m = re.search(r"con\s*>=\s*(\d+)\s*notti", t)
        if m and s["n_min"] is None:
            s["n_min"] = int(m.group(1))
            s["riga"] = riga_di(offs, m.start())
        m = re.search(r"q\s*>=\s*(\d[,.]\d+)", t)
        if m and s["q_alta"] is None:
            s["q_alta"] = fnum(m.group(1))
        m = re.search(r"q\s*<=\s*(\d[,.]\d+)\s*(?:->|=>|:)?\s*COMPATIBILE", t)
        if m and s["q_bassa"] is None:
            s["q_bassa"] = fnum(m.group(1))
        m = re.search(r"finestre\s+di\s+(\d+)\s+notti", t, re.I)
        if m and s["finestra"] is None:
            s["finestra"] = int(m.group(1))
    # CONCENTRAZIONE PER NOTTE: la soglia sta in qualunque punto del file prova ("netto senza le 3 migliori notti <= 0 = FRAGILE PER NOTTE"); se non c'e' ancora, 3 DERIVATA dal cancello
    t, offs = testo_con_righe(P["commenti"])
    m = re.search(r"netto senza le (\d+) migliori notti\s*<=\s*0\s*=\s*FRAGILE PER NOTTE", t)
    if m:
        s["k_fragile"], s["k_riga"] = int(m.group(1)), riga_di(offs, m.start())
        s["k_extra"] = sorted(set(int(x) for x in re.findall(r"(?:si stampa anche|anche) senza le (\d+)", t)))
    else:
        s["k_fragile"], s["k_derivata"] = 3, True
    return s


def estrai_hm5n(P):
    """Il paragrafo dell'ipotesi alternativa H-M5N INTERO: dalla riga che dice 'IPOTESI ALTERNATIVA' (con H-M5N) fino alla riga prima di SMENTITE/PASSATE o
    della prossima intestazione. Piu' inclusivo che esclusivo: se il file prova ha aggiunto frasi dopo, si stampano."""
    com = P["commenti"]
    idx = None
    for i, (n, b) in enumerate(com):
        if "IPOTESI ALTERNATIVA" in b.upper() and "H-M5N" in b.upper():
            idx = i
            break
    if idx is None:
        return None
    righe = []
    for n, b in com[idx:]:
        if righe and (re.match(r"^\s*(SMENTITE|SMENTITA|PASSATE|CONTROLLO DIRETTO)\b", b) or RE_INTEST.match(b)):
            break
        righe.append((n, b))
    return righe


def estrai_hm5n_piano(percorso=PIANO_PATH):
    """La frase dell'ipotesi alternativa nel piano 4.3 (riga che contiene 'Ipotesi alternativa H-M5N')."""
    if not os.path.isfile(percorso):
        return None
    for n, r in enumerate(open(percorso, "rb").read().decode("latin-1").splitlines(), 1):
        i = r.lower().find("ipotesi alternativa h-m5n")
        if i >= 0:
            return (n, r[i:].replace("**", "").strip())
    return None


def trova_prova(tag):
    if not os.path.isdir(PROVE_DIR):
        return None
    c = sorted(f for f in os.listdir(PROVE_DIR) if re.match(r"^GBA_R2_NOTTE%s_.*\.txt$" % tag, f))
    return os.path.join(PROVE_DIR, c[-1]) if c else None


# ---------------------------------------------------------------------------------------------------------------------
#  STATISTICHE PER NOTTE
# ---------------------------------------------------------------------------------------------------------------------
def notti_da_posizioni(pos, fascia=None):
    """pos = lista di lg.posizioni_numeriche. Una NOTTE = data server (del deal d'ingresso) con almeno un ingresso (nella fascia, se data). Se fascia e' data,
    le posizioni fuori fascia sono ESCLUSE (post-hoc: solo per le ancore di R1A); per i lotti col filtro in tester fascia=None e il controllo diretto le ha gia' verificate."""
    per = {}
    for x in pos:
        if fascia is not None and not (fascia[0] <= x["ora"] < fascia[1]):
            continue
        d = x["t"].date()
        n = per.setdefault(d, {"data": d, "net": 0.0, "gp": 0.0, "gl": 0.0, "nops": 0})
        v = x["net_v"]
        n["net"] += v
        n["nops"] += 1
        if v > 0:
            n["gp"] += v
        elif v < 0:
            n["gl"] += -v
    return [per[k] for k in sorted(per)]


def pf_da(gp, gl):
    if gl <= 0:
        return float("inf") if gp > 0 else float("nan")
    return gp / gl


def pearson(xs, ys):
    n = len(xs)
    if n < 3:
        return None
    mx, my = sum(xs) / n, sum(ys) / n
    sx = math.sqrt(sum((x - mx) ** 2 for x in xs))
    sy = math.sqrt(sum((y - my) ** 2 for y in ys))
    if sx == 0 or sy == 0:
        return None
    return sum((x - mx) * (y - my) for x, y in zip(xs, ys)) / (sx * sy)


def acf_lag(serie, lag):
    """Autocorrelazione del netto per notte a distanza di `lag` notti CONSECUTIVE CON INGRESSI, dentro la stessa tranche (mai a cavallo di due tranche)."""
    xs, ys = [], []
    for tr in sorted(serie):
        v = [n["net"] for n in serie[tr]]
        for i in range(len(v) - lag):
            xs.append(v[i])
            ys.append(v[i + lag])
    return pearson(xs, ys), len(xs)


def cond_neg(serie):
    """q condizionata alla notte precedente (lag 1, stessa tranche): (negative dopo negativa, notti dopo negativa, negative dopo non negativa, notti dopo non negativa)."""
    k1 = n1 = k0 = n0 = 0
    for tr in sorted(serie):
        v = [n["net"] < 0 for n in serie[tr]]
        for i in range(1, len(v)):
            if v[i - 1]:
                n1 += 1
                k1 += 1 if v[i] else 0
            else:
                n0 += 1
                k0 += 1 if v[i] else 0
    return k1, n1, k0, n0


def bootstrap(notti, B, seed):
    """Bootstrap PER NOTTE: si ricampionano le notti (con le loro operazioni insieme), non le operazioni. Restituisce q e PF con intervallo 2,5-97,5."""
    n = len(notti)
    if n < 2 or B < 1:
        return None
    rng = random.Random(seed)
    qs, pfs = [], []
    for _ in range(B):
        s = rng.choices(notti, k=n)
        qs.append(sum(1 for x in s if x["net"] < 0) / float(n))
        pfs.append(pf_da(sum(x["gp"] for x in s), sum(x["gl"] for x in s)))
    qs.sort()
    pfv = sorted(p for p in pfs if p == p)

    def pc(v, p):
        return v[min(len(v) - 1, int(p * (len(v) - 1)))] if v else float("nan")
    return {"B": B, "q": (pc(qs, 0.025), pc(qs, 0.975)), "pf": (pc(pfv, 0.025), pc(pfv, 0.975)), "pf_nan": len(pfs) - len(pfv)}


def statistiche(serie, S, B, seed):
    """serie = {tranche: [notte...]} (notti ordinate per data). S = soglie lette dal file prova."""
    tutte = [n for tr in sorted(serie) for n in serie[tr]]
    st = {"n_notti": len(tutte), "n_ops": sum(n["nops"] for n in tutte), "net": sum(n["net"] for n in tutte),
          "gp": sum(n["gp"] for n in tutte), "gl": sum(n["gl"] for n in tutte)}
    st["pf"] = pf_da(st["gp"], st["gl"])
    st["neg"] = sum(1 for n in tutte if n["net"] < 0)
    st["q"] = (st["neg"] / float(st["n_notti"])) if st["n_notti"] else None
    L = S.get("finestra")
    st["L"] = L
    nf = nc = 0
    if L:
        for tr in serie:
            ns = serie[tr]
            for i in range(len(ns) - L + 1):
                nf += 1
                if all(m["net"] >= 0 for m in ns[i:i + L]):
                    nc += 1
    st["fin_tot"], st["fin_pulite"] = nf, nc
    st["fin_oss"] = (nc / float(nf)) if nf else None
    st["fin_nullo"] = ((1.0 - st["q"]) ** L) if (L and st["q"] is not None) else None
    st["boot"] = bootstrap(tutte, B, seed) if tutte else None
    st["acf"] = {lag: acf_lag(serie, lag) for lag in (1, 2, 3)}
    st["cond"] = cond_neg(serie)
    st["lettura"] = lettura_q(st["n_notti"], st["q"], S)
    kf = S.get("k_fragile") or 3
    ks = sorted(set([3, 5, kf] + list(S.get("k_extra") or [])))
    ordinate = sorted((n["net"] for n in tutte), reverse=True)
    st["conc_k"] = {k: st["net"] - sum(ordinate[:k]) for k in ks}
    st["k_fragile"] = kf
    st["fragile_notte"] = (st["conc_k"][kf] <= 0) if tutte else None
    return st


def lettura_q(n_notti, q, S):
    """Lettura con le SOGLIE DEL FILE PROVA (derivate dell'autore, non criteri firmati). Nessun verdetto sul motore."""
    if S.get("n_min") is None or S.get("q_alta") is None or S.get("q_bassa") is None:
        return "soglie NON lette dal file prova: lettura non valutabile"
    if n_notti < S["n_min"]:
        return "NON MISURATO (notti %d < %d)" % (n_notti, S["n_min"])
    if q >= S["q_alta"] - 1e-12:
        return "q >= %s: 'nessuna notte negativa' NON e' una proprieta' del metodo su questo feed e regime (soglia derivata dell'autore)" % f2(S["q_alta"])
    if q <= S["q_bassa"] + 1e-12:
        return "q <= %s: COMPATIBILE con una proprieta' del metodo (soglia derivata dell'autore; non e' una prova)" % f2(S["q_bassa"])
    return "q fra %s e %s: una settimana pulita e' plausibile per caso, NON dice niente" % (f2(S["q_bassa"]), f2(S["q_alta"]))


def dentro(x, lo, hi):
    return lo <= x <= hi


# ---------------------------------------------------------------------------------------------------------------------
#  VALUTAZIONE DI UNA PASSATA E DI UNA CELLA
# ---------------------------------------------------------------------------------------------------------------------
def fascia_da_prova(P):
    """(ora_inizio, ora_fine) della fascia dichiarata, dall'input atteso della prima cella del file prova. None se non leggibile."""
    for c in P["celle"]:
        e = inputs_attesi(P, c)
        try:
            return (int(float(e["InpHourStart"])), int(float(e["InpHourEnd"])))
        except (KeyError, ValueError):
            return None
    return None


def valuta_passata(P, prova, fascia):
    """Restituisce un dict: 'stato' ('LEGGIBILE' / 'NON LEGGIBILE' / 'NON LANCIATA'), 'motivi' (bloccanti), 'guardare', 'n_ing', 'fuori'."""
    info = {"tag": P["tag"], "tranche": P["tranche"], "magic": P["magic"], "cella": P["cella"], "P": P, "motivi": [], "filtro": [], "guardare": [],
            "n_ing": 0, "fuori": [], "stato": ""}
    if P["riga"]["stato"] == "NON_LANCIATA":
        info["stato"] = "NON LANCIATA"
        return info
    info["motivi"] += ["G0 del lettore: " + m for m in P["g0"]]
    r = P["riga"]
    if r["lotto"] != prova["lotto"]:
        info["motivi"].append("lotto '%s' invece di '%s'" % (r["lotto"], prova["lotto"]))
    if P["cella"] not in prova["celle"]:
        info["motivi"].append("cella '%s' non dichiarata nel file prova (celle: %s)" % (P["cella"], ", ".join(sorted(prova["celle"])) or "nessuna"))
    elif P["magic"] == "775800" and (P["cella"], P["tranche"]) not in prova["passate"]:
        info["motivi"].append("passata %s:%s non prevista dal @GBA-LOTTO del file prova" % (P["cella"], P["tranche"]))
    elif P["magic"] != "775800" and (P["cella"], P["tranche"], P["magic"]) not in prova["gemelle"]:
        info["motivi"].append("passata gemella %s:%s:%s non prevista dal @GBA-LOTTO del file prova" % (P["cella"], P["tranche"], P["magic"]))
    dt = prova["tranche"].get(P["tranche"])
    if dt is None:
        info["motivi"].append("tranche '%s' non dichiarata nel file prova" % P["tranche"])
    elif (r["da"], r["a"]) != dt:
        info["motivi"].append("date del manifest %s-%s invece di %s-%s dichiarate" % (r["da"], r["a"], dt[0], dt[1]))
    if prova["modello"] and str(r["modello"]) != str(prova["modello"]):
        info["motivi"].append("Modello %s invece di %s" % (r["modello"], prova["modello"]))
    rep = P["rep"]
    if rep and rep["ok"]:
        q = re.sub(r"\s", "", (rep.get("qualita") or "")).lower()
        if str(r["modello"]) == "4" and q != QUALITA_ATTESA:
            info["motivi"].append("qualita' dello storico del report '%s' invece di '100%% ticks reali'" % (rep.get("qualita") or "n.d."))
        if rep.get("deposito") is not None and abs(rep["deposito"] - lg.DEPOSITO_ATTESO) > 0.5:
            info["guardare"].append("deposito del report %.2f invece di %.0f" % (rep["deposito"], lg.DEPOSITO_ATTESO))
    an = P["log"]["anomalie"] if P["log"] else {}
    if an:
        info["guardare"].append("giornale dell'EA (minimo): " + "; ".join("%s %d" % (k, an[k]) for k in sorted(an)))
    # input dell'ini contro il dichiarato (pin + cella)
    if P["cella"] in prova["celle"]:
        att = inputs_attesi(prova, P["cella"])
        ini = P.get("ini")
        if ini is None:
            info["guardare"].append("ini assente nello zip: gli input sono verificati SOLO dai deal d'ingresso")
        else:
            inp, te = ini["inputs"], ini["tester"]
            for k in sorted(att):
                if k not in inp:
                    info["filtro"].append("%s assente nell'ini (atteso %s)" % (k, att[k]))
                elif lg._norm(inp[k]) != lg._norm(att[k]):
                    info["filtro"].append("%s=%s nell'ini invece di %s" % (k, inp[k], att[k]))
            for k in sorted(inp):
                if k != "InpMagic" and k not in att:
                    info["filtro"].append("%s=%s nell'ini ma non nel file prova" % (k, inp[k]))
            try:
                tf = int(float(att["InpSignalTF"]))
                per_att = {1: "M1", 5: "M5"}.get(tf, "M%d" % tf)
                if te.get("Period") != per_att:
                    info["filtro"].append("Period=%s nell'ini invece di %s" % (te.get("Period"), per_att))
            except (KeyError, ValueError):
                pass
    # controllo DIRETTO: il 100% dei deal d'ingresso
    if rep and rep["ok"]:
        ing = [d for d in rep["deals"] if d["dir"] in ("in", "in/out")]
        info["n_ing"] = len(ing)
        info["fuori"] = [d for d in ing if not (fascia[0] <= d["t"].hour < fascia[1])]
        if rep["trades"] is not None and abs(len(ing) - int(rep["trades"])) > 1:
            info["motivi"].append("deal d'ingresso letti %d contro %d operazioni del report: il controllo diretto non e' completo" % (len(ing), int(rep["trades"])))
    else:
        info["motivi"].append("report assente o illeggibile")
    if info["fuori"]:
        info["filtro"].append("%d deal d'ingresso su %d con ora server FUORI da %02d:00-%02d:59" % (len(info["fuori"]), info["n_ing"], fascia[0], fascia[1] - 1))
    info["stato"] = "LEGGIBILE" if not (info["motivi"] or info["filtro"]) else "NON LEGGIBILE"
    return info


def valuta_cella(chiave, prova, Ps, fascia):
    """Ps = passate (tutte le magic) del lotto. Numeri solo dalla passata principale 775800; la gemella (775850) e' controllata, non sommata."""
    passate = [valuta_passata(P, prova, fascia) for P in Ps]
    princ = [i for i in passate if i["magic"] == "775800"]
    vive = [i for i in passate if i["stato"] != "NON LANCIATA"]
    att = set(prova["passate"])
    viste = set((i["cella"], i["tranche"]) for i in princ if i["stato"] != "NON LANCIATA")
    mancanti = sorted(att - viste)
    C = {"chiave": chiave, "prova": prova, "passate": passate, "princ": princ, "mancanti": mancanti, "serie": {}, "pos": {}, "costo": [], "costo_tr": {}, "comm": {}, "g1": []}
    C["leggibili"] = [i for i in princ if i["stato"] == "LEGGIBILE"]
    C["non_leggibili"] = [i for i in vive if i["stato"] == "NON LEGGIBILE"]
    for i in C["leggibili"]:
        pos, comm = lg.posizioni_numeriche(i["P"], lg.COMM_EUR_LOTTO_GIRO)
        C["pos"][i["tranche"]] = pos
        C["comm"][i["tranche"]] = comm
        C["serie"][i["tranche"]] = notti_da_posizioni(pos)
        c = lg.costo_ingressi(i["P"])
        C["costo_tr"][i["tranche"]] = c["c04"]
        C["costo"] += c["c04"]
    C["totale_ok"] = (not C["non_leggibili"]) and bool(C["leggibili"])
    C["parziale"] = bool(mancanti)
    try:
        C["g1"] = lg.gemelle_dichiarative(Ps)
    except Exception as e:      # il G1 e' un di piu': se cade lo si dice
        C["g1"] = ["  G1: lettura della gemella FALLITA (%s)" % e]
    return C


# ---------------------------------------------------------------------------------------------------------------------
#  ANCORA R1A (post-hoc dagli stessi deal archiviati) E G1
# ---------------------------------------------------------------------------------------------------------------------
def ancora_r1a(percorso, fascia):
    """Notti 'post-hoc' dentro R1A: le posizioni della REPL (magic 775800) con ora d'ingresso nella fascia. Restituisce dict o {'errore': ...}."""
    if not os.path.isfile(percorso):
        return {"errore": "zip R1A non trovato: %s" % percorso}
    try:
        Ps = lg.carica([percorso])
    except SystemExit as e:
        return {"errore": "caricamento R1A fallito: %s" % e}
    serie, costo, costo_tr, motivi = {}, [], {}, []
    for P in Ps:
        if P["magic"] != "775800":
            continue
        if P["g0"]:
            motivi.append("%s G0 KO: %s" % (P["tag"], "; ".join(P["g0"])))
            continue
        pos, _c = lg.posizioni_numeriche(P, lg.COMM_EUR_LOTTO_GIRO)
        serie[P["tranche"]] = notti_da_posizioni(pos, fascia)
        ing = P["log"]["ingressi"] if P["log"] else []
        cv = []
        if P.get("r_ok"):
            for i, x in enumerate(pos):
                if fascia[0] <= x["ora"] < fascia[1] and i < len(ing) and ing[i]["spread"] > 0:
                    cv.append(2.5 * ing[i]["atr"] / (ing[i]["spread"] + lg.COMM_USD_OZ[0]))
        costo_tr[P["tranche"]] = cv
        costo += cv
    if motivi or not serie:
        return {"errore": "; ".join(motivi) or "nessuna passata REPL 775800 in R1A"}
    return {"serie": serie, "costo": costo, "costo_tr": costo_tr, "sorgente": os.path.basename(percorso)}


def g1_ancora(r1a, r2ttrend):
    """G1 dell'ancora: la gemella REPL T1 (magic 775850) di R2TTREND contro R1A T1, col confronto deal-per-deal del lettore. -> ('VERDE'|'ROSSA'|'NON VERIFICABILE', riga)"""
    for p in (r1a, r2ttrend):
        if not os.path.isfile(p):
            return "NON VERIFICABILE", "zip non trovato: %s" % p
    try:
        Ps = lg.carica([r1a, r2ttrend])
        righe = [g for g in lg.gemelle_dichiarative(Ps) if "tranche T1" in g]
    except SystemExit as e:
        return "NON VERIFICABILE", "caricamento fallito: %s" % e
    if not righe:
        return "NON VERIFICABILE", "nessuna coppia di gemelle T1 fra i due zip"
    r = righe[0]
    if "VERDE" in r:
        return "VERDE", r.strip()
    if "NON VERIFICABILE" in r:
        return "NON VERIFICABILE", r.strip()
    return "ROSSA", r.strip()


# ---------------------------------------------------------------------------------------------------------------------
#  STAMPA
# ---------------------------------------------------------------------------------------------------------------------
def riga_stat(label, st):
    return "   %-8s n op %4d | notti %3d | negative %3d | q %s | PF_V %s | netto %s EUR" % (
        label, st["n_ops"], st["n_notti"], st["neg"], f2(st["q"]), fpf(st["pf"]), f2(st["net"]))


def stampa_statistiche(W, titolo, st, S):
    W("   %s" % titolo)
    W("      notti %d (con %d operazioni), negative %d, q = %s   [lettura: %s]" % (st["n_notti"], st["n_ops"], st["neg"], f2(st["q"], 3), st["lettura"]))
    b = st["boot"]
    if b is None:
        W("      bootstrap per notte: n.d. (meno di 2 notti)")
    else:
        W("      bootstrap per NOTTE (%d ricampionamenti, seed fisso): q %s [%s ; %s]  PF_V %s [%s ; %s]%s" % (
            b["B"], f2(st["q"], 3), f2(b["q"][0], 3), f2(b["q"][1], 3), fpf(st["pf"]), fpf(b["pf"][0]), fpf(b["pf"][1]),
            ("  (%d ricampionamenti senza operazioni ne' perdite scartati dal PF)" % b["pf_nan"]) if b["pf_nan"] else ""))
        if st["n_notti"] < 30:
            W("      (meno di 30 notti: l'intervallo e' largo, si legge come ordine di grandezza)")
    if st["L"]:
        if st["fin_tot"]:
            W("      finestre di %d notti consecutive (scorrevoli, dentro la tranche): %d su %d senza notti negative = %s osservata  contro (1-q)^%d = %s  (caso nullo di notti indipendenti)" % (
                st["L"], st["fin_pulite"], st["fin_tot"], f2(st["fin_oss"], 3), st["L"], f2(st["fin_nullo"], 3)))
        else:
            W("      finestre di %d notti: NON MISURABILI (meno di %d notti con ingressi in una tranche)" % (st["L"], st["L"]))
    else:
        W("      finestre: lunghezza NON letta dal file prova")
    if st["n_notti"]:
        W("      CONCENTRAZIONE PER NOTTE: netto %s; %s -> %s  (soglia: netto senza le %d migliori notti <= 0 = FRAGILE PER NOTTE, %s)" % (
            f2(st["net"], 0), "; ".join("senza le %d migliori notti %s" % (k, f2(v, 0)) for k, v in sorted(st["conc_k"].items())),
            "FRAGILE PER NOTTE" if st["fragile_notte"] else "non fragile per notte", st["k_fragile"],
            "DERIVATA dal cancello 3o passaggio R2NOTTE: il file prova non la scrive" if S.get("k_derivata") else "scritta nel file prova, r.%s" % S.get("k_riga")))
    ac = []
    for lag in (1, 2, 3):
        r, n = st["acf"][lag]
        if r is None:
            ac.append("lag%d n.d. (coppie %d)" % (lag, n))
        else:
            ac.append("lag%d %+.2f (coppie %d, +-%.2f)" % (lag, r, n, 1.96 / math.sqrt(n)))
    W("      autocorrelazione del netto per notte (Gemini B3, MISURA non criterio; fra parentesi coppie e banda +-1,96/sqrt(n) del caso di indipendenza): " + " | ".join(ac))
    k1, n1, k0, n0 = st["cond"]
    W("      q condizionata (lag 1): dopo una notte negativa %s (%d su %d); dopo una notte non negativa %s (%d su %d)" % (
        f2(k1 / float(n1), 3) if n1 else "n.d.", k1, n1, f2(k0 / float(n0), 3) if n0 else "n.d.", k0, n0))


def mediana(v):
    return statistics.median(v) if v else float("nan")


def stampa_attese(W, C, st_tot, costo_med):
    """Le attese del file prova accanto ai numeri: dentro/fuori. Nessuna soglia scritta qui: tutto e' letto dal file (riga citata)."""
    prova = C["prova"]
    A = estrai_attese(prova)
    W("(3) ATTESE DEL FILE PROVA (%s, %s), LETTE a runtime accanto ai numeri" % (prova["nome"], descr_git(prova["git"])))
    if not A["sezioni_trovate"]:
        W("   sezioni delle attese NON trovate nel file prova: dentro/fuori attesa NON VALUTABILE")
        return
    n = st_tot["n_ops"]
    nn = st_tot["n_notti"]
    parz = " [TOTALE PARZIALE: mancano %s]" % ", ".join("%s:%s" % m for m in C["mancanti"]) if C["parziale"] else ""
    if A["n_banda"]:
        for lo, hi, riga, fr in A["n_banda"]:
            W("   n totale = %d%s  | attesa r.%d '%s' = %d-%d -> %s" % (n, parz, riga, asc(fr), lo, hi, "DENTRO attesa" if dentro(n, lo, hi) else "FUORI attesa"))
    else:
        W("   n totale = %d | banda di n NON letta dal file prova" % n)
    sm = A["n_smentita"]
    if sm and (sm.get("lo") or sm.get("hi")):
        for chiave, segno in (("hi", ">"), ("lo", "<")):
            if sm.get(chiave):
                v, riga, fr = sm[chiave]
                scatta = (n > v) if chiave == "hi" else (n < v)
                W("   smentita r.%d '%s': n = %d %s %d? -> %s" % (riga, asc(fr), n, segno, v, "SCATTA: la causa si legge PRIMA di ogni numero (testo della smentita alla riga citata)" if scatta else "non scatta"))
    else:
        W("   smentita su n: NON letta dal file prova")
    if A["pf_banda"]:
        for lo, hi, riga, fr in A["pf_banda"]:
            sosp = "" if n >= N_MIN_MERITO else "  [merito SOSPESO: n < %d (S1), il numero e' solo descrittivo]" % N_MIN_MERITO
            W("   PF_V totale = %s | attesa r.%d '%s' = %s-%s -> %s%s" % (fpf(st_tot["pf"]), riga, asc(fr), f2(lo), f2(hi), "DENTRO attesa" if dentro(st_tot["pf"], lo, hi) else "FUORI attesa", sosp))
    else:
        W("   PF_V totale = %s | banda di PF_V NON letta dal file prova" % fpf(st_tot["pf"]))
    if C["costo"]:
        if A["costo_banda"]:
            for lo, hi, riga, fr in A["costo_banda"]:
                W("   costo mediano (+0,04) = %.1fx | attesa r.%d '%s' = %d-%dx -> %s" % (costo_med, riga, asc(fr), lo, hi, "DENTRO attesa" if dentro(costo_med, lo, hi) else "FUORI attesa"))
        for v, riga, fr in A["costo_punto"]:
            W("   costo mediano (+0,04) = %.1fx | attesa puntuale r.%d '%s' (nessuna banda scritta: nessun dentro/fuori automatico); soglia S2 del lettore: %s" % (
                costo_med, riga, asc(fr), lg.banda_costo(costo_med)))
        if not A["costo_banda"] and not A["costo_punto"]:
            W("   costo mediano (+0,04) = %.1fx | attesa di costo NON letta dal file prova" % costo_med)
    for np_, nneg, riga, fr in A["notti_punto"]:
        W("   notti = %d, negative = %d | attesa puntuale r.%d '%s' (nessuna banda: nessun dentro/fuori automatico)" % (nn, st_tot["neg"], riga, asc(fr)))
    for mx, riga, fr in A["notti_max"]:
        W("   notti = %d | attesa r.%d '%s' -> %s" % (nn, riga, asc(fr), "DENTRO attesa" if nn <= mx else "FUORI attesa (piu' notti del previsto)"))
    for lo, hi, riga, fr in A["notti_banda"]:
        W("   notti = %d | attesa r.%d '%s' = %d-%d -> %s" % (nn, riga, asc(fr), lo, hi, "DENTRO attesa" if dentro(nn, lo, hi) else "FUORI attesa"))
    if not A["notti_punto"] and not A["notti_max"] and not A["notti_banda"]:
        W("   notti = %d | attesa sul numero di notti NON letta dal file prova" % nn)
    if st_tot["q"] is not None:
        if A["q_banda"]:
            for lo, hi, riga, fr, tit in A["q_banda"]:
                W("   q = %s | attesa r.%d '%s' [sezione: %s] = %s-%s -> %s" % (f2(st_tot["q"], 3), riga, asc(fr), asc(tit), f2(lo), f2(hi), "DENTRO attesa" if dentro(st_tot["q"], lo, hi) else "FUORI attesa"))
        else:
            W("   q = %s | banda di q NON letta dal file prova" % f2(st_tot["q"], 3))
    W("   Il testo INTERO delle sezioni delle attese, dal file prova (la parola vietata del certificato, se presente, e' mascherata con [x]):")
    for tit, riga in A["sezioni_trovate"]:
        sez = [s for s in prova["sezioni"] if s["riga"] == riga][0]
        W("     --- r.%d %s" % (riga, asc(tit)))
        for nr, b in sez["righe"]:
            W("     r.%-3d %s" % (nr, asc(b.rstrip())))


def leggi_nome_atteso(prova):
    return prova["lotto"] or "?"


def stampa_cella(W, C, S, B, seed, fascia):
    prova = C["prova"]
    ch = C["chiave"]
    cella = sorted(prova["celle"])[0] if prova["celle"] else "?"
    att = inputs_attesi(prova, cella) if prova["celle"] else {}
    W("")
    W("=" * 100)
    W(" CELLA %s -- lotto %s, cella %s (%s)  --  file prova %s" % (ch, prova["lotto"], cella, ", ".join("%s=%s" % (k, v) for k, v in sorted(prova["celle"].get(cella, {}).items())), prova["nome"]))
    W("=" * 100)
    W("(1) CONTROLLO DIRETTO: il 100%% dei deal d'ingresso con ora SERVER in %02d:00-%02d:59 (anche UNO fuori = 'FILTRO NON COME DICHIARATO': la passata non si legge)" % (fascia[0], fascia[1] - 1))
    for i in C["passate"]:
        if i["stato"] == "NON LANCIATA":
            W("   %-34s NON LANCIATA" % i["tag"])
            continue
        W("   %-34s magic %s  deal d'ingresso %d, dentro la fascia %d, fuori %d  -> %s" % (i["tag"], i["magic"], i["n_ing"], i["n_ing"] - len(i["fuori"]), len(i["fuori"]), i["stato"]))
        for d in i["fuori"][:5]:
            W("        fuori fascia: deal %d alle %s (ora server %02d)" % (d["id"], d["t"].strftime("%Y.%m.%d %H:%M:%S"), d["t"].hour))
        if len(i["fuori"]) > 5:
            W("        ... e altri %d" % (len(i["fuori"]) - 5))
        for m in i["filtro"]:
            W("        FILTRO NON COME DICHIARATO / INPUT DIVERSI: " + m)
        for m in i["motivi"]:
            W("        NON LEGGIBILE: " + m)
        for m in i["guardare"]:
            W("        ! DA GUARDARE: " + m)
    ing_tot = sum(i["n_ing"] for i in C["passate"] if i["stato"] != "NON LANCIATA")
    fuori_tot = sum(len(i["fuori"]) for i in C["passate"] if i["stato"] != "NON LANCIATA")
    W("   TOTALE della cella: deal d'ingresso %d, fuori fascia %d -> %s" % (ing_tot, fuori_tot, "tutti dentro" if fuori_tot == 0 else "FILTRO NON COME DICHIARATO: il totale non si calcola"))
    for g in C["g1"]:
        W(g)
    if C["mancanti"]:
        W("   MANCANO passate previste dal file prova: %s -> il totale della cella e' PARZIALE" % ", ".join("%s:%s" % m for m in C["mancanti"]))
    if not C["leggibili"]:
        W("   nessuna passata leggibile: nessun numero per questa cella")
        return None
    # (2) n, costo, PF_V PRIMA di ogni lettura
    W("(2) PRIMA DI OGNI LETTURA: n, costo e PF_V (PF_V = PF dei netti con la convenzione del lettore; S1: il merito vale solo con n >= %d)" % N_MIN_MERITO)
    W("    costo = mediana sugli ingressi di 2,5 x ATR / (spread + 0,04 USD/oz), dalle righe d'ingresso dell'EA")
    righe_tr = {}
    for tr in sorted(C["serie"]):
        st = statistiche({tr: C["serie"][tr]}, S, B, seed)
        righe_tr[tr] = st
        cm = mediana(C["costo_tr"].get(tr, []))
        W("   %-3s n op %4d | costo mediano %s | PF_V %s | netto %s EUR%s" % (tr, st["n_ops"], ("%.1fx" % cm) if cm == cm else "n.d.", fpf(st["pf"]), f2(st["net"]),
                                                                          "" if st["n_ops"] >= N_MIN_MERITO else "   [merito SOSPESO: n < %d]" % N_MIN_MERITO))
    totale = None
    cm_tot = mediana(C["costo"])
    if C["totale_ok"]:
        totale = statistiche(C["serie"], S, B, seed)
        etich = "TOT" if not C["parziale"] else "PARZIALE"
        v04 = C["costo"]
        W("   %-3s n op %4d | costo mediano %s (quota <13,3x: %.0f%%, quota <40x: %.0f%%; S2 del lettore: %s) | PF_V %s | netto %s EUR%s" % (
            etich, totale["n_ops"], ("%.1fx" % cm_tot) if cm_tot == cm_tot else "n.d.",
            100.0 * sum(1 for x in v04 if x < lg.COSTO_DURO) / len(v04) if v04 else float("nan"),
            100.0 * sum(1 for x in v04 if x < lg.COSTO_LAVORO) / len(v04) if v04 else float("nan"),
            lg.banda_costo(cm_tot), fpf(totale["pf"]), f2(totale["net"]),
            "" if totale["n_ops"] >= N_MIN_MERITO else "   [merito SOSPESO: n < %d (S1)]" % N_MIN_MERITO))
        if C["parziale"]:
            W("   TOTALE PARZIALE: mancano %s" % ", ".join("%s:%s" % m for m in C["mancanti"]))
        nets = [x["net_v"] for tr in sorted(C["pos"]) for x in C["pos"][tr]]
        if nets:
            pos_tot, netto = sum(x for x in nets if x > 0), sum(nets)
            top1 = (max(nets) / pos_tot) if pos_tot > 0 else None
            senza5 = netto - sum(sorted(nets, reverse=True)[:lg.TOP_N_FRAGILE])
            fragile = (top1 is not None and top1 >= lg.TOP1_FRAGILE) or senza5 <= 0
            n780 = [v for i in C["leggibili"] for v in lg.netti_780(i["P"])]
            W("   concentrazione PER OPERAZIONE (S5, definizione del lettore): migliore operazione = %s del profitto positivo; netto senza le %d migliori = %.0f -> %s | PF con 7,80 EUR/lotto a giro = %s" % (
                "n.d." if top1 is None else "%.0f%%" % (100 * top1), lg.TOP_N_FRAGILE, senza5, "FRAGILE" if fragile else "non fragile", fpf(lg.pf_di(n780))))
            C["s5"] = {"fragile": fragile, "top1": top1, "senza5": senza5}
            W("   concentrazione PER NOTTE (S5 conta le operazioni e non vede 3 notti da 3 operazioni): %s -> %s  (soglia: senza le %d migliori notti <= 0 = FRAGILE PER NOTTE, %s)" % (
                "; ".join("senza le %d migliori notti %s" % (k, f2(v, 0)) for k, v in sorted(totale["conc_k"].items())),
                "FRAGILE PER NOTTE" if totale["fragile_notte"] else "non fragile per notte", totale["k_fragile"],
                "DERIVATA dal cancello 3o passaggio R2NOTTE, il file prova non la scrive" if S.get("k_derivata") else "scritta nel file prova, r.%s" % S.get("k_riga")))
    else:
        W("   TOT: NON CALCOLATO -- almeno una passata della cella NON e' leggibile (%s)" % ", ".join(i["tag"] for i in C["non_leggibili"]))
    C["tr_stat"], C["tot_stat"], C["costo_med"] = righe_tr, totale, cm_tot
    if totale is not None:
        stampa_attese(W, C, totale, cm_tot)
    W("(4) LA NOTTE: netto per notte, q, finestre contro il caso nullo, bootstrap per notte, dipendenza fra notti")
    W("    notte = data server con almeno un ingresso in fascia; netto = somma dei netti PF_V delle posizioni entrate quella notte; soglie dal file prova (r.%s)" % (S.get("riga") or "?"))
    for tr in sorted(righe_tr):
        stampa_statistiche(W, "[%s]" % tr, righe_tr[tr], S)
    if totale is not None:
        stampa_statistiche(W, "[TOTALE%s]" % (" PARZIALE" if C["parziale"] else ""), totale, S)
    return totale


def tabella_confronto(W, ancora, C1, C5, S):
    W("")
    W("=" * 100)
    W(" (5) CONFRONTO: M1 notte contro M5 notte, e contro le ANCORE post-hoc di R1A")
    W("=" * 100)
    serie = {}
    if ancora and "serie" in ancora:
        serie["R1A post-hoc"] = ancora["serie"]
    if C1 and C1["serie"] and C1["totale_ok"]:
        serie["M1 notte"] = C1["serie"]
    if C5 and C5["serie"] and C5["totale_ok"]:
        serie["M5 notte"] = C5["serie"]
    if C1 is None or C5 is None or "M1 notte" not in serie or "M5 notte" not in serie:
        mancano = [n for n, c in (("M1 notte (R2NOTTEM1)", C1), ("M5 notte (R2NOTTEM5)", C5)) if c is None or not c["serie"] or not c["totale_ok"]]
        W("   CONFRONTO M1/M5 NON POSSIBILE: manca o non e' leggibile: %s" % ", ".join(mancano))
    W("   (a) per tranche, ciascuna serie sul proprio insieme di notti; 'R1A post-hoc' = REPL a 24 ore con le posizioni entrate in fascia, filtrate DOPO (non e' il filtro in tester)")
    W("   %-4s %-13s %6s %7s %6s %7s %7s %9s" % ("tr", "serie", "n op", "PF_V", "notti", "negat.", "q", "netto"))
    for tr in ("T1", "T2", "T3", "TOT"):
        for nome in ("R1A post-hoc", "M1 notte", "M5 notte"):
            if nome not in serie:
                continue
            if tr == "TOT":
                s = serie[nome]
            elif tr in serie[nome]:
                s = {tr: serie[nome][tr]}
            else:
                continue
            st = statistiche(s, S, 0, SEED_DEFAULT)
            W("   %-4s %-13s %6d %7s %6d %7d %7s %9s" % (tr, nome, st["n_ops"], fpf(st["pf"]), st["n_notti"], st["neg"], f2(st["q"], 3), f2(st["net"], 0)))
    if "M1 notte" in serie and "M5 notte" in serie:
        W("   (b) M1 notte contro M5 notte sullo STESSO insieme di notti (solo le notti con almeno un ingresso in tutte e due)")
        W("   %-4s %7s %9s %9s | %s | %s | %s" % ("tr", "comuni", "solo M1", "solo M5", "M1 sulle comuni: n op / PF_V / neg / netto", "M5 sulle comuni: n op / PF_V / neg / netto", "segno concorde"))
        tot1, tot5 = {}, {}
        for tr in ("T1", "T2", "T3"):
            a, b = serie["M1 notte"].get(tr, []), serie["M5 notte"].get(tr, [])
            da = {n["data"]: n for n in a}
            db = {n["data"]: n for n in b}
            com = sorted(set(da) & set(db))
            a2, b2 = [da[d] for d in com], [db[d] for d in com]
            tot1[tr], tot5[tr] = a2, b2
            s1, s5 = statistiche({tr: a2}, S, 0, SEED_DEFAULT), statistiche({tr: b2}, S, 0, SEED_DEFAULT)
            conc = sum(1 for x, y in zip(a2, b2) if (x["net"] < 0) == (y["net"] < 0))
            W("   %-4s %7d %9d %9d | %4d / %s / %3d / %9s | %4d / %s / %3d / %9s | %d su %d" % (
                tr, len(com), len(set(da) - set(db)), len(set(db) - set(da)), s1["n_ops"], fpf(s1["pf"]), s1["neg"], f2(s1["net"], 0),
                s5["n_ops"], fpf(s5["pf"]), s5["neg"], f2(s5["net"], 0), conc, len(com)))
        s1, s5 = statistiche(tot1, S, 0, SEED_DEFAULT), statistiche(tot5, S, 0, SEED_DEFAULT)
        ncom = sum(len(v) for v in tot1.values())
        conc = sum(1 for tr in tot1 for x, y in zip(tot1[tr], tot5[tr]) if (x["net"] < 0) == (y["net"] < 0))
        W("   %-4s %7d %9s %9s | %4d / %s / %3d / %9s | %4d / %s / %3d / %9s | %d su %d" % (
            "TOT", ncom, "", "", s1["n_ops"], fpf(s1["pf"]), s1["neg"], f2(s1["net"], 0), s5["n_ops"], fpf(s5["pf"]), s5["neg"], f2(s5["net"], 0), conc, ncom))
        W("   (la differenza di n fra M1 e M5 sulle stesse notti e' la sequenza: a M5 le posizioni durano di piu' e bloccano di piu'; e' una descrizione, non un giudizio)")


def stampa_hm5n(W, C5, prove):
    W("")
    W("=" * 100)
    W(" (6) L'IPOTESI H-M5N DEL COLLEGA (DICHIARATO DA TERZI), INTERA come nel file prova")
    W("=" * 100)
    P5 = prove.get("M5")
    par = estrai_hm5n(P5) if P5 else None
    if par is None:
        W("   paragrafo H-M5N NON trovato nel file prova M5 (%s): non lo ricostruisco a memoria" % (P5["nome"] if P5 else "file prova assente"))
    else:
        W("   dal file prova %s, righe %d-%d (%s):" % (P5["nome"], par[0][0], par[-1][0], descr_git(P5["git"])))
        for nr, b in par:
            W("     r.%-3d %s" % (nr, asc(b.rstrip())))
        pi = estrai_hm5n_piano()
        if pi is None:
            W("   frase del piano 4.3 (%s): NON trovata" % os.path.relpath(PIANO_PATH, REPO))
        else:
            W("   frase del piano %s r.%d (per confronto): %s" % (os.path.relpath(PIANO_PATH, REPO).replace(os.sep, "/"), pi[0], asc(pi[1])))
            tk = lambda s: set(re.findall(r"[a-z_]+|\d+(?:[,.]\d+)?", s.lower()))
            diff = sorted(tk(pi[1]) - tk(" ".join(b for _n, b in par)))
            W("   CONFRONTO MECCANICO piano/prova: parole e numeri della frase del piano che NON compaiono nel paragrafo del file prova: %s" % (", ".join(diff) if diff else "nessuno"))
    W("   DICHIARAZIONE: da questo lotto e' misurabile SOLO la meta' NOTTURNA dell'ipotesi (PF_V della notte per tranche, con n >= 150 per tranche). La meta' 'di giorno'")
    W("   non e' in questo lotto (richiede M5 a 24 ore, R2T, e la fascia diurna): e' NON MISURATA qui, e senza di lei l'ipotesi H-M5N intera resta NON ANCORA MISURATA.")
    if C5 is not None and C5.get("tot_stat") is not None:
        t5 = C5["tot_stat"]
        W("   Clausola (c) (il guadagno poggia su poche giornate?): si legge SOLO con la concentrazione PER NOTTE. M5 notte totale: per operazione (S5) %s; per notte %s (senza le 3 migliori notti %s EUR)." % (
            ("FRAGILE" if C5.get("s5", {}).get("fragile") else "non fragile") if C5.get("s5") else "n.d.",
            "FRAGILE PER NOTTE" if t5["fragile_notte"] else "non fragile per notte", f2(t5["conc_k"].get(3), 0)))
    else:
        W("   Clausola (c): NON MISURATO in questa corsa (totale M5 non leggibile/assente): senza la concentrazione per notte non si legge.")
    if C5 is not None and C5.get("tr_stat"):
        W("   Meta' notturna, per tranche (n op >= 150 serve per leggere il merito, S1):")
        for tr in sorted(C5["tr_stat"]):
            st = C5["tr_stat"][tr]
            W("     %s: n op %d, PF_V %s -> %s" % (tr, st["n_ops"], fpf(st["pf"]), "merito NON misurabile per tranche (n < %d)" % N_MIN_MERITO if st["n_ops"] < N_MIN_MERITO else "n >= %d: PF_V si confronta con la condizione scritta sopra" % N_MIN_MERITO))
    else:
        W("   Meta' notturna: nessun dato M5 leggibile in questa corsa.")


# ---------------------------------------------------------------------------------------------------------------------
#  CARICAMENTO DEGLI ZIP (anche annidati)
# ---------------------------------------------------------------------------------------------------------------------
def espandi(percorsi, tmpdir):
    """Uno zip che contiene GLI ZIP dei lotti (e non un MANIFEST_R0.csv alla radice) viene estratto in tmpdir, un file per zip interno, col nome del membro.
    Tutto passa poi a lg.carica insieme: il controllo dei doppioni vede anche lo stesso lotto caricato due volte (una volta nell'esterno, una a parte)."""
    out = []
    for p in percorsi:
        if os.path.isdir(p):
            out.append(p)
            continue
        z = zipfile.ZipFile(p)
        nomi = [n for n in z.namelist() if not n.endswith("/")]
        if "MANIFEST_R0.csv" in [n.replace("\\", "/") for n in nomi]:
            out.append(p)
            continue
        inner = sorted(n for n in nomi if n.lower().endswith(".zip"))
        if not inner:
            out.append(p)               # lg.carica dira' 'manca MANIFEST_R0.csv'
            continue
        for k, n in enumerate(inner):
            d = os.path.join(tmpdir, "%d_%d" % (len(out), k))
            os.makedirs(d)
            dest = os.path.join(d, os.path.basename(n.replace("\\", "/")))
            with open(dest, "wb") as f:
                f.write(z.read(n))
            out.append(dest)
    return out


def copia_prova_nello_zip(percorsi, prova):
    """Se lo zip contiene una copia del file prova (il driver la copia dentro), la confronta col file letto al HEAD: se e' DIVERSA, le attese sono cambiate fra la
    partenza del lotto e la lettura, e si stampano le righe che differiscono (una attesa riscritta DOPO i numeri non e' un'attesa)."""
    import difflib
    out = []
    letto = open(prova["percorso"], "rb").read()
    for pth in percorsi:
        if os.path.isdir(pth):
            continue
        try:
            z = zipfile.ZipFile(pth)
        except Exception:
            continue
        for n in z.namelist():
            if os.path.basename(n.replace("\\", "/")) == prova["nome"]:
                dato = z.read(n)
                if dato == letto:
                    out.append(" Copia del file prova dentro %s: IDENTICA al file letto (le attese sono quelle con cui il lotto e' partito)." % os.path.basename(pth))
                else:
                    out.append(" ! Copia del file prova dentro %s: DIVERSA dal file letto (SHA256 zip %s, letto %s): le attese lette sono quelle del HEAD, NON necessariamente quelle con cui il lotto e' partito. Righe che differiscono:" % (
                        os.path.basename(pth), hashlib.sha256(dato).hexdigest().upper()[:12], prova["sha256"][:12]))
                    d = list(difflib.unified_diff(dato.decode("latin-1").splitlines(), letto.decode("latin-1").splitlines(), "nello_zip", "letto_al_HEAD", n=0, lineterm=""))
                    for r in d[:40]:
                        out.append("     " + asc(r[:230]))
                    if len(d) > 40:
                        out.append("     ... e altre %d righe" % (len(d) - 40))
    return out


# ---------------------------------------------------------------------------------------------------------------------
#  MAIN
# ---------------------------------------------------------------------------------------------------------------------
def esegui(argv):
    try:
        return _esegui(argv)
    except Exception:
        import traceback
        print("ERRORE INTERNO (nessun numero si stampa):\n" + traceback.format_exc())
        return 1


def _esegui(argv):
    opz = {"prova_m1": None, "prova_m5": None, "ancora": R1A_ZIP, "g1": R2TTREND_ZIP, "senza_ancora": False, "B": BOOT_DEFAULT, "seed": SEED_DEFAULT}
    zs = []
    i = 0
    while i < len(argv):
        a = argv[i]
        if a in ("--prova-m1", "--prova-m5", "--ancora", "--g1", "--bootstrap", "--seed") and i + 1 < len(argv):
            k = {"--prova-m1": "prova_m1", "--prova-m5": "prova_m5", "--ancora": "ancora", "--g1": "g1", "--bootstrap": "B", "--seed": "seed"}[a]
            opz[k] = argv[i + 1] if k not in ("B", "seed") else int(argv[i + 1])
            i += 2
            continue
        if a == "--senza-ancora":
            opz["senza_ancora"] = True
            i += 1
            continue
        if a.startswith("--"):
            print("opzione sconosciuta o senza valore: %s" % a)
            return 1
        zs.append(a)
        i += 1
    if not zs:
        print(__doc__)
        return 1
    out = []
    W = out.append
    try:
        carica_lettore()
    except ErroreLettura as e:
        print("ERRORE (nessun numero): %s" % e)
        return 1
    prove = {}
    for k, tag in (("M1", "M1"), ("M5", "M5")):
        pth = opz["prova_m1" if k == "M1" else "prova_m5"] or trova_prova(tag)
        if not pth or not os.path.isfile(pth):
            print("ERRORE (nessun numero): file prova R2NOTTE%s non trovato (%s)" % (tag, pth))
            return 1
        prove[k] = leggi_prova(pth)
        for campo in ("lotto", "modello"):
            if not prove[k][campo]:
                print("ERRORE (nessun numero): il file prova %s non ha @GBA-LOTTO %s" % (prove[k]["nome"], campo))
                return 1
        if not prove[k]["celle"] or not prove[k]["passate"]:
            print("ERRORE (nessun numero): il file prova %s non dichiara celle o passate" % prove[k]["nome"])
            return 1
    fascia = fascia_da_prova(prove["M1"])
    fascia5 = fascia_da_prova(prove["M5"])
    if fascia is None or fascia5 is None:
        print("ERRORE (nessun numero): InpHourStart/InpHourEnd non leggibili dai file prova")
        return 1
    S = estrai_soglie_notti(prove["M1"])
    S5 = estrai_soglie_notti(prove["M5"])
    tmp = tempfile.mkdtemp(prefix="gba_notti_")
    try:
        try:
            percorsi = espandi(zs, tmp)
            passate = lg.carica(percorsi)
        except SystemExit as e:
            print("ERRORE (nessun numero si stampa):\n  %s" % e)
            return 1
        except (OSError, zipfile.BadZipFile, ValueError, KeyError) as e:
            print("ERRORE (nessun numero si stampa): zip non leggibile: %s" % e)
            return 1
        lotti = {}
        for P in passate:
            lotti.setdefault(P["riga"]["lotto"], []).append(P)
        W("=" * 100)
        W(" GBA R2NOTTE -- lettura PER NOTTE (%s). BOZZA, NON passata dal cancello." % VERSIONE)
        W(" Lettore importato: %s SHA256 %s (pinnato, verificato)" % (os.path.basename(LETTORE_PATH), LETTORE_SHA256))
        W(" Questo script: SHA256 %s" % sha256_file(os.path.abspath(__file__)))
        for k in ("M1", "M5"):
            p = prove[k]
            W(" File prova %s: %s SHA256 %s | %s" % (k, p["nome"], p["sha256"], descr_git(p["git"])))
        W(" Attese e soglie sono LETTE da questi file al momento della lettura (nessuna copiata nello script). Fascia notturna dichiarata: ora server %02d:00-%02d:59." % (fascia[0], fascia[1] - 1))
        if fascia != fascia5:
            W(" ! ATTENZIONE: la fascia di M1 (%s) e quella di M5 (%s) nei file prova NON coincidono: il confronto M1/M5 non vale" % (fascia, fascia5))
        W(" Soglie della lettura per notte, lette dal file prova M1: notti minime %s, q alta %s, q bassa %s, finestra %s notti (derivate dell'autore, non criteri firmati)" % (
            S["n_min"], S["q_alta"], S["q_bassa"], S["finestra"]))
        if (S5["n_min"], S5["q_alta"], S5["q_bassa"], S5["finestra"]) != (S["n_min"], S["q_alta"], S["q_bassa"], S["finestra"]):
            W(" ! ATTENZIONE: le soglie della lettura per notte nel file prova M5 sono DIVERSE da quelle di M1 (%s): si usano quelle di ciascuna cella" % ((S5["n_min"], S5["q_alta"], S5["q_bassa"], S5["finestra"]),))
        W(" Zip caricati: %s" % ", ".join(sorted(set(P["sorgente"] for P in passate))))
        W(" Le parole citate dai file prova passano da un filtro che maschera con [x] la parola vietata dal certificato dei 5 punti; lo script non la scrive.")
        W("=" * 100)
        # lotti non applicabili
        applicabili = {"M1": prove["M1"]["lotto"], "M5": prove["M5"]["lotto"]}
        for lotto in sorted(lotti):
            if lotto in applicabili.values():
                continue
            Ps = lotti[lotto]
            ini = [P["ini"]["inputs"] for P in Ps if P.get("ini")]
            hs = sorted(set("InpHourStart=%s InpHourEnd=%s" % (x.get("InpHourStart", "?"), x.get("InpHourEnd", "?")) for x in ini)) or ["ini assente"]
            W("")
            W(" LOTTO %s (%d passate): NON APPLICABILE -- non e' uno dei lotti notte dichiarati nei file prova (%s, %s); filtro orario nell'ini: %s." % (
                lotto, len(Ps), applicabili["M1"], applicabili["M5"], "; ".join(hs)))
            W("   Nessun numero per notte: senza il filtro in tester la 'notte' sarebbe una fascia letta dopo (post-hoc), e quella lettura si fa solo per l'ANCORA di R1A, dichiarata come tale.")
        C = {}
        rc = 0
        any_app = False
        for k in ("M1", "M5"):
            Ps = lotti.get(applicabili[k])
            if not Ps:
                W("")
                W(" LOTTO %s (%s): NON PRESENTE fra gli zip caricati" % (k, applicabili[k]))
                C[k] = None
                continue
            any_app = True
            fk = fascia if k == "M1" else fascia5
            C[k] = valuta_cella(k, prove[k], Ps, fk)
            copie = copia_prova_nello_zip(percorsi, prove[k])
            for riga in copie:
                W(riga)
            stampa_cella(W, C[k], S if k == "M1" else S5, opz["B"], opz["seed"], fk)
            if C[k]["non_leggibili"] or not C[k]["leggibili"]:
                rc = 3
        if not any_app:
            W("")
            W(" NIENTE DA LEGGERE: nessuno dei lotti R2NOTTEM1 / R2NOTTEM5 e' fra gli zip caricati. I dati veri del lotto R2NOTTE non sono stati letti da questa corsa.")
            print("\n".join(out))
            return 2
        # ancora
        anc = None
        W("")
        if opz["senza_ancora"]:
            W(" ANCORA R1A: saltata (--senza-ancora)")
        else:
            anc = ancora_r1a(opz["ancora"], fascia)
            if "errore" in anc:
                W(" ANCORA R1A: NON DISPONIBILE -- %s" % anc["errore"])
                anc = None
            else:
                st = statistiche(anc["serie"], S, 0, opz["seed"])
                cm = mediana(anc["costo"])
                W(" ANCORA R1A post-hoc (%s, REPL 775800, posizioni entrate in fascia, dai deal archiviati): n op %d | PF_V %s | notti %d | negative %d | q %s | costo mediano %s" % (
                    anc["sorgente"], st["n_ops"], fpf(st["pf"]), st["n_notti"], st["neg"], f2(st["q"], 3), ("%.1fx" % cm) if cm == cm else "n.d."))
                g, riga = g1_ancora(opz["ancora"], opz["g1"])
                W(" G1 DELL'ANCORA (REPL T1 gemella 775850 di R2TTREND contro R1A T1): %s" % g)
                W("   %s" % riga)
                if g != "VERDE":
                    W(" ! G1 NON VERDE: i confronti con l'ancora R1A NON valgono (file prova, 'ANCORA E G1'); i numeri ASSOLUTI della notte restano letti. La tabella R1A qui sotto e' omessa.")
                    anc = None
        tabella_confronto(W, anc, C.get("M1"), C.get("M5"), S)
        stampa_hm5n(W, C.get("M5"), prove)
        W("")
        W("=" * 100)
        W(" STATO: NON ANCORA MISURATO. Nessuna casella del certificato dei 5 punti si chiude con questo lotto (uscita ad asse, simboli gemelli, TF su 24 ore restano aperte).")
        W(" Nessun numero qui sopra e' un verdetto sul motore: sono misure della sola notte 2026 (un regime), in-sample (la fascia nasce dalla lettura per ora di R1A); si ripetono in T0.")
        W("=" * 100)
        print("\n".join(out))
        return rc
    finally:
        import shutil
        shutil.rmtree(tmp, ignore_errors=True)


# ---------------------------------------------------------------------------------------------------------------------
#  AUTOTEST
# ---------------------------------------------------------------------------------------------------------------------
def _spec_notte(date0, nets, ora=2, minuto=0, durata=6, passo_giorni=1, lato="buy", atr=4.0, spr=0.10):
    """Una operazione per notte: nets[i] = profitto lordo dell'operazione della notte i (il PF_V sottrae 3,90 se il report non ha commissioni)."""
    out = []
    d = datetime.datetime.strptime(date0, "%Y.%m.%d")
    for k, p in enumerate(nets):
        t = d + datetime.timedelta(days=k * passo_giorni, hours=ora, minutes=minuto)
        out.append((t.strftime("%Y.%m.%d %H:%M:%S"), lato, p, atr, spr, durata))
    return out


def _zip_notte(prova, k, ops_per_tranche, ini_cambi=None, comm=0.0, qualita="100% ticks reali", magic="775800", cella=None, lotto=None, nome_ini_period=None, prova_nello_zip=None):
    """Zip finto di un lotto notte nel formato del driver v5, con ini e manifest coerenti con il file prova (salvo `ini_cambi`)."""
    cella = cella or sorted(prova["celle"])[0]
    lotto = lotto or prova["lotto"]
    att = inputs_attesi(prova, cella)
    f = tempfile.NamedTemporaryFile(suffix=".zip", delete=False)
    f.close()
    z = zipfile.ZipFile(f.name, "w")
    righe = []
    tf = int(float(att["InpSignalTF"]))
    per = nome_ini_period or {1: "M1", 5: "M5"}.get(tf, "M%d" % tf)
    for j, tr in enumerate(sorted(ops_per_tranche), 1):
        da, a = prova["tranche"][tr]
        ops = ops_per_tranche[tr]
        deals, lg_ = lg._sintetico(ops, comm)
        nets = [x[2] + 2 * comm for x in ops]          # netto di report: profitto + commissioni dei due deal
        tag = "%s_%02d_%s_%s_m%s" % (lotto, j, cella, tr, magic)
        profit = sum(nets)
        z.writestr("report\\GBA_R0_" + tag + ".htm", lg._htm(deals, len(ops), lg._fmt(profit), "%.2f" % (lg.pf_di(nets) if nets else 0.0), qual=qualita, periodo="%s (%s - %s)" % (per, da, a)))
        z.writestr("log\\GBA_" + tag + ".txt", "\r\n".join(["# passata finta"] + lg_))
        inp = dict(att)
        inp.update(ini_cambi or {})
        txt = "[Experts]\r\nAllowLiveTrading=false\r\n\r\n[Tester]\r\nExpert=ABTG_GoldBreakoutATR.ex5\r\nSymbol=%s\r\nPeriod=%s\r\nModel=%s\r\nFromDate=%s\r\nToDate=%s\r\n\r\n[TesterInputs]\r\n" % (
            inp.get("InpSymbol", "XAUUSD"), per, prova["modello"], da, a)
        txt += "\r\n".join("%s=%s" % (kk, vv) for kk, vv in inp.items()) + "\r\nInpMagic=%s\r\n" % magic
        z.writestr("ini\\gba_" + tag + ".ini", txt)
        righe.append("%s;%s;%s;%s;%s;%s;%s;%s;%s;2026-10-11 10:00:00;60;OK;%d;%s;%.2f;100%%ticksreali;88000;;88000;25000000;;100;%d;si;si;%s-%s;;%s;%s;XAUUSD;%s;PROVA_FINTA.txt" % (
            lotto, tag, cella, att.get("InpSpreadMaxATR", "0.05"), tr, da, a, prova["modello"], magic, len(ops), profit, lg.pf_di(nets) if nets else 0.0, len(ops), da, a,
            prova["asse"] or "InpHourEnd", "7", per))
    cols = "lotto;passata;cella;spread_max_atr;tranche;da;a;modello;magic;t_avvio;durata_s;stato;trades_report;profitto_report;pf_report;qualita;barre_report;ticks_report;barre_gen;ticks_gen;ticks_inizio;righe_gba;ingressi_log;avvio_ok;autotest;finestra;motivi;asse;valore_asse;simbolo;periodo;prova"
    z.writestr("MANIFEST_R0.csv", cols + "\n" + "\n".join(righe) + "\n")
    if prova_nello_zip is not None:
        z.writestr(prova["nome"], prova_nello_zip)
    z.close()
    return f.name


def _zip_esterno(interni):
    f = tempfile.NamedTemporaryFile(suffix=".zip", delete=False)
    f.close()
    z = zipfile.ZipFile(f.name, "w")
    for nome, p in interni:
        z.writestr(nome, open(p, "rb").read())
    z.close()
    return f.name


def _esegui_catturando(argv):
    buf = io.StringIO()
    with contextlib.redirect_stdout(buf):
        try:
            rc = esegui(argv)
        except SystemExit as e:
            rc = e.code if isinstance(e.code, int) else 1
    return rc, buf.getvalue()


MINI_PROVA = """# header
#  ======================= ATTESE, SCRITTE PRIMA DEI NUMERI (tre tranche sommate) =======================
#  n 142-160 (fascia R1A 142 + le notti non piu' bloccate da posizioni del giorno, poche); per tranche T1 ~6.
#  PF_V 0,75-1,10 (post-hoc 0,944). Costo mediano ~50x (PASSA).
#  Notti: ~53, negative ~33 (q 0,50-0,75).
#  SMENTITE: n > 175 (la sequenza conta piu' del previsto) oppure n < 130 (filtro non applicato); PF_V >= 1,15 con n >= 150 = sorpresa.
#  PASSATE: 1 cella x 3 tranche = 3, ~7 min.
#
#  ======================= IL CRITERIO DI EMILIANO 'NESSUNA NOTTE NEGATIVA', TRADOTTO IN MISURA =======================
#  la quota di FINESTRE di 7 notti consecutive (con ingressi) senza nessuna notte negativa.
#  Lettura: con >= 30 notti, q >= 0,30 -> 'x' NON e' una proprieta'; q <= 0,10 -> COMPATIBILE ((0,9)^7 = 0,48); in mezzo non dice niente. Con < 30 notti: NON MISURATO.
#  @GBA-TRANCHE nome=T1 da=2026.07.01 a=2026.09.30
#  @GBA-CELLA nome=N7 InpHourEnd=7
#  @GBA-LOTTO nome=R2NOTTEMX modello=4 tetto_min=20 passate=N7:T1
InpHourStart=0
InpHourEnd=24
InpSignalTF=1
InpMagic=775800||775800||50||775850||Y
"""


def _altera_profitto_notte(dat_utf16, nuovo="99 999.00"):
    """Test: cambia il profitto del primo deal d'uscita che chiude una posizione entrata di notte (ora 00-06) nel report .htm (UTF-16). -> (bytes, trovato)"""
    t = dat_utf16.decode("utf-16")
    prev_notte = False
    for m in re.finditer(r"<tr[^>]*>(.*?)</tr>", t, re.S | re.I):
        tds = list(re.finditer(r"<td[^>]*>(.*?)</td>", m.group(1), re.S | re.I))
        celle = [re.sub(r"\s+", " ", re.sub(r"<[^>]+>", "", x.group(1))).replace("&nbsp;", " ").strip() for x in tds]
        if len(celle) == 13 and re.match(r"^\d{4}\.\d\d\.\d\d \d\d:\d\d:\d\d$", celle[0]) and celle[3] in ("buy", "sell"):
            if prev_notte and celle[4] == "out":
                a = m.start(1) + tds[10].start(1)
                b = m.start(1) + tds[10].end(1)
                return (t[:a] + nuovo + t[b:]).encode("utf-16"), True
            prev_notte = celle[4] == "in" and int(celle[0][11:13]) < 7
    return dat_utf16, False


def autotest():
    falliti = []
    conta = [0]

    def ck(nome, cond, dettaglio=""):
        conta[0] += 1
        print("  %-4s %s%s" % ("ok" if cond else "FAIL", nome, "" if cond else "   <<< " + dettaglio))
        if not cond:
            falliti.append(nome)

    print("AUTOTEST di %s (dati finti con risposta nota + contro-esempi + dati veri archiviati)" % VERSIONE)
    # 0. il lettore pinnato
    try:
        carica_lettore()
        ck("il lettore importato ha l'SHA256 pinnato", True)
    except ErroreLettura as e:
        ck("il lettore importato ha l'SHA256 pinnato", False, str(e))
        print("\nAUTOTEST FALLITO: senza il lettore pinnato non si prosegue")
        return 1
    tmpd = tempfile.mkdtemp(prefix="gba_notti_test_")
    alt = os.path.join(tmpd, "lettore_alterato.py")
    open(alt, "wb").write(open(LETTORE_PATH, "rb").read() + b"\n# alterato\n")
    try:
        carica_lettore(alt)
        ck("CONTRO-ESEMPIO: un lettore con un byte in piu' viene RIFIUTATO", False, "importato lo stesso")
    except ErroreLettura:
        ck("CONTRO-ESEMPIO: un lettore con un byte in piu' viene RIFIUTATO", True)
    carica_lettore()
    src = open(os.path.abspath(__file__), "rb").read().decode("ascii", "replace").lower()
    ck("il sorgente dello script non contiene la parola vietata e (ASCII puro) nessun carattere non ASCII", ("mort" + "o") not in src and all(b < 128 for b in open(os.path.abspath(__file__), "rb").read()))

    # file prova veri (al HEAD) e mini prova
    p1, p5 = trova_prova("M1"), trova_prova("M5")
    ck("i due file prova R2NOTTE sono nel repo", bool(p1 and p5), str((p1, p5)))
    if not (p1 and p5):
        print("\nAUTOTEST FALLITO")
        return 1
    pr1, pr5 = leggi_prova(p1), leggi_prova(p5)
    ck("prova M1: lotto, cella N7 con InpHourEnd=7, 3 tranche, 3 passate, pin InpHourEnd=24", pr1["lotto"] == "R2NOTTEM1" and pr1["celle"].get("N7", {}).get("InpHourEnd") == "7" and len(pr1["tranche"]) == 3
       and len(pr1["passate"]) == 3 and pr1["pin"].get("InpHourEnd") == "24", str((pr1["lotto"], pr1["celle"], pr1["pin"].get("InpHourEnd"))))
    ck("prova M5: lotto, cella M5 con InpSignalTF=5, pin InpHourEnd=7 e InpHourStart=0", pr5["lotto"] == "R2NOTTEM5" and pr5["celle"].get("M5", {}).get("InpSignalTF") == "5" and pr5["pin"].get("InpHourEnd") == "7"
       and pr5["pin"].get("InpHourStart") == "0", str((pr5["lotto"], pr5["celle"], pr5["pin"].get("InpHourEnd"))))
    ck("fascia notturna letta dai file prova: 0-7 per entrambi (M1 via cella N7, M5 via pin)", fascia_da_prova(pr1) == (0, 7) and fascia_da_prova(pr5) == (0, 7), str((fascia_da_prova(pr1), fascia_da_prova(pr5))))
    S1_, S5_ = estrai_soglie_notti(pr1), estrai_soglie_notti(pr5)
    ck("le soglie della lettura per notte sono LEGGIBILI dai file prova veri (n minime, q alta, q bassa, finestra) in entrambi", all(v is not None for v in (S1_["n_min"], S1_["q_alta"], S1_["q_bassa"], S1_["finestra"]))
       and all(v is not None for v in (S5_["n_min"], S5_["q_alta"], S5_["q_bassa"], S5_["finestra"])), str((S1_, S5_)))
    A1, A5 = estrai_attese(pr1), estrai_attese(pr5)
    ck("le attese dei file prova veri sono LEGGIBILI (banda di n, banda di PF_V, almeno una banda di q) in entrambi", bool(A1["n_banda"] and A1["pf_banda"] and A1["q_banda"] and A5["n_banda"] and A5["pf_banda"] and A5["q_banda"]), str((A1, A5)))
    h5 = estrai_hm5n(pr5)
    ck("il paragrafo H-M5N si trova nel file prova M5 e contiene la condizione PF_V e 'OGNI tranche'", h5 is not None and "OGNI tranche" in " ".join(b for _n, b in h5) and "PF_V" in " ".join(b for _n, b in h5), str(h5))
    pm = os.path.join(tmpd, "mini.txt")
    open(pm, "w").write(MINI_PROVA)
    mp = leggi_prova(pm)
    Am = estrai_attese(mp)
    Sm = estrai_soglie_notti(mp)
    ck("mini prova: banda di n 142-160 letta con la sua riga", Am["n_banda"] and Am["n_banda"][0][:2] == (142, 160) and Am["n_banda"][0][2] == 3, str(Am["n_banda"]))
    ck("mini prova: banda di PF_V 0,75-1,10 letta (e PF_V >= 1,15 NON presa per una banda)", len(Am["pf_banda"]) == 1 and Am["pf_banda"][0][:2] == (0.75, 1.10), str(Am["pf_banda"]))
    ck("mini prova: smentite n > 175 e n < 130 lette", Am["n_smentita"].get("hi", (None,))[0] == 175 and Am["n_smentita"].get("lo", (None,))[0] == 130, str(Am["n_smentita"]))
    ck("mini prova: banda di q 0,50-0,75 e notti puntuali 53/33 lette, costo puntuale 50", Am["q_banda"] and Am["q_banda"][0][:2] == (0.5, 0.75) and Am["notti_punto"][0][:2] == (53, 33) and Am["costo_punto"][0][0] == 50, str(Am))
    ck("mini prova: soglie 30 notti, q >= 0,30, q <= 0,10, finestra 7", (Sm["n_min"], Sm["q_alta"], Sm["q_bassa"], Sm["finestra"]) == (30, 0.30, 0.10, 7), str(Sm))
    pm2 = os.path.join(tmpd, "mini2.txt")
    open(pm2, "w").write(MINI_PROVA.replace("q >= 0,30", "q >= 0,40"))
    ck("CONTRO-ESEMPIO: cambiando la soglia nel file prova (0,30 -> 0,40) cambia quello che lo script legge (non e' scritta nello script)", estrai_soglie_notti(leggi_prova(pm2))["q_alta"] == 0.40)
    ck("lettura_q con le soglie del file: q 0,35 su 40 notti -> 'NON e' una proprieta'' con soglia 0,30, 'non dice niente' con soglia 0,40", "NON e' una proprieta'" in lettura_q(40, 0.35, Sm)
       and "NON dice niente" in lettura_q(40, 0.35, estrai_soglie_notti(leggi_prova(pm2))))
    ck("lettura_q: 29 notti -> NON MISURATO anche con q altissimo; 30 notti con q 0,05 -> COMPATIBILE", lettura_q(29, 0.9, Sm).startswith("NON MISURATO") and "COMPATIBILE" in lettura_q(30, 0.05, Sm))
    ck("lettura_q: confini inclusivi (q = 0,30 -> alta; q = 0,10 -> bassa; q = 0,2 -> in mezzo)", "NON e' una proprieta'" in lettura_q(40, 0.30, Sm) and "COMPATIBILE" in lettura_q(40, 0.10, Sm) and "non dice niente" in lettura_q(40, 0.2, Sm).lower())
    ck("lettura_q senza soglie lette: dice che non e' valutabile (non inventa)", "NON lette" in lettura_q(40, 0.5, {"n_min": None, "q_alta": None, "q_bassa": None}))

    # 1. ANCORA R1A: dai deal veri archiviati
    fas = (0, 7)
    if os.path.isfile(R1A_ZIP):
        a = ancora_r1a(R1A_ZIP, fas)
        ck("ANCORA R1A caricata dallo zip archiviato", "serie" in a, str(a))
        if "serie" in a:
            st = statistiche(a["serie"], Sm, 200, SEED_DEFAULT)
            ck("R1A notte: 142 operazioni", st["n_ops"] == 142, str(st["n_ops"]))
            ck("R1A notte: PF_V 0,944 (al millesimo)", abs(round(st["pf"], 3) - 0.944) < 1e-9, fpf(st["pf"]))
            ck("R1A notte: 53 notti con almeno un ingresso", st["n_notti"] == 53, str(st["n_notti"]))
            ck("R1A notte: 33 notti con netto negativo (q = 0,623)", st["neg"] == 33 and abs(st["q"] - 33 / 53.0) < 1e-12, str(st["neg"]))
            pt = {tr: statistiche({tr: a["serie"][tr]}, Sm, 0, 1) for tr in a["serie"]}
            ck("R1A per tranche: n op 6 / 32 / 104", (pt["T1"]["n_ops"], pt["T2"]["n_ops"], pt["T3"]["n_ops"]) == (6, 32, 104), str([pt[t]["n_ops"] for t in sorted(pt)]))
            ck("R1A per tranche: PF_V 0,11 / 0,51 / 1,12", tuple(round(pt[t]["pf"], 2) for t in ("T1", "T2", "T3")) == (0.11, 0.51, 1.12), str([fpf(pt[t]["pf"]) for t in sorted(pt)]))
            ck("R1A per tranche: notti 6 / 15 / 32 e negative 5 / 12 / 16", tuple((pt[t]["n_notti"], pt[t]["neg"]) for t in ("T1", "T2", "T3")) == ((6, 5), (15, 12), (32, 16)), str([(pt[t]["n_notti"], pt[t]["neg"]) for t in sorted(pt)]))
            cm = mediana(a["costo"])
            ck("R1A notte: costo mediano con +0,04 vicino al 50,7x scritto nel file prova (mai oltre 0,5 di scarto)", abs(cm - 50.7) < 0.5, "%.2f" % cm)
            # il PF delle notti coincide con il PF del lettore sulle stesse posizioni
            Ps = lg.carica([R1A_ZIP])
            nets = []
            for P in Ps:
                pos, _c = lg.posizioni_numeriche(P, lg.COMM_EUR_LOTTO_GIRO)
                nets += [x["net_v"] for x in pos if x["ora"] < 7]
            ck("il PF dei gp/gl per notte coincide con lg.pf_di sui netti delle stesse posizioni (nessun conto a parte)", abs(lg.pf_di(nets) - st["pf"]) < 1e-9)
            # contro-esempio: alterando UN deal d'ingresso notturno di R1A, l'ancora cambia
            alt_zip = os.path.join(tmpd, "r1a_alterato.zip")
            zin = zipfile.ZipFile(R1A_ZIP)
            zout = zipfile.ZipFile(alt_zip, "w")
            for n in zin.namelist():
                dat = zin.read(n)
                if n.replace("\\", "/") == "report/GBA_R0_R1A_03_REPL_T3_m775800.htm":
                    dat, fatto = _altera_profitto_notte(dat)
                    ck("(prepara l'alterazione) trovato e alterato il deal d'uscita di una posizione notturna in T3", fatto)
                zout.writestr(n, dat)
            zout.close()
            a2 = ancora_r1a(alt_zip, fas)
            ck("CONTRO-ESEMPIO: un deal di R1A alterato (profitto 99 999) senza ritoccare i totali del report -> l'ancora NON si legge (G0 del lettore: il ricalcolo dai deal non torna col report)",
               "errore" in a2 and "G0 KO" in a2["errore"], str(a2)[:300])
    else:
        ck("ANCORA R1A: zip archiviato presente nel repo", False, R1A_ZIP)

    # 2. statistiche su serie costruite a mano
    def serie_da(nets, tr="T1", d0=datetime.date(2026, 1, 1)):
        return {tr: [{"data": d0 + datetime.timedelta(days=i), "net": v, "gp": max(v, 0.0), "gl": max(-v, 0.0), "nops": 1} for i, v in enumerate(nets)]}
    sp = statistiche(serie_da([5.0] * 7), Sm, 100, 1)
    ck("7 notti TUTTE positive: q = 0, 1 finestra su 1 pulita, osservata 1,0 e caso nullo (1-0)^7 = 1,0", sp["q"] == 0.0 and (sp["fin_tot"], sp["fin_pulite"]) == (1, 1) and sp["fin_oss"] == 1.0 and sp["fin_nullo"] == 1.0, str(sp))
    ck("7 notti tutte positive: PF infinito (nessuna perdita) e bootstrap di q = [0 ; 0]", sp["pf"] == float("inf") and sp["boot"]["q"] == (0.0, 0.0))
    sa = statistiche(serie_da([5.0, -5.0, 5.0, -5.0, 5.0, -5.0, 5.0]), Sm, 100, 1)
    ck("7 notti ALTERNATE: q = 3/7, 1 finestra su 1 NON pulita (osservata 0), caso nullo (4/7)^7", abs(sa["q"] - 3 / 7.0) < 1e-12 and (sa["fin_tot"], sa["fin_pulite"]) == (1, 0) and sa["fin_oss"] == 0.0 and abs(sa["fin_nullo"] - (4 / 7.0) ** 7) < 1e-12, str(sa))
    s8 = statistiche(serie_da([5.0, -5.0, 5.0, -5.0, 5.0, -5.0, 5.0, -5.0]), Sm, 0, 1)
    ck("8 notti alternate: 2 finestre scorrevoli, nessuna pulita", (s8["fin_tot"], s8["fin_pulite"]) == (2, 0))
    s10 = statistiche(serie_da([-1.0] + [1.0] * 7 + [-1.0, 1.0]), Sm, 0, 1)
    ck("10 notti [-, 7 positive, -, +]: 4 finestre scorrevoli, SOLO la seconda e' pulita (1 su 4)", (s10["fin_tot"], s10["fin_pulite"]) == (4, 1), str((s10["fin_tot"], s10["fin_pulite"])))
    s6 = statistiche(serie_da([1.0] * 6), Sm, 0, 1)
    ck("6 notti (meno di 7): finestre NON misurabili (0 finestre), osservata n.d.", s6["fin_tot"] == 0 and s6["fin_oss"] is None)
    due = {"T1": serie_da([1.0] * 4)["T1"], "T2": serie_da([1.0] * 4, "T2", datetime.date(2026, 4, 1))["T2"]}
    ck("due tranche da 4 notti: le finestre NON passano a cavallo delle tranche (0 finestre, non 2)", statistiche(due, Sm, 0, 1)["fin_tot"] == 0)
    z0 = statistiche(serie_da([0.0, 0.0, 3.0]), Sm, 0, 1)
    ck("una notte con netto esattamente 0 NON e' negativa", z0["neg"] == 0)
    alt_ = serie_da([5.0, -5.0] * 20)
    r1_, n1_ = acf_lag(alt_, 1)
    r2_, _n2 = acf_lag(alt_, 2)
    ck("autocorrelazione: serie alternata -> lag 1 = -1 e lag 2 = +1 (esatti)", abs(r1_ + 1) < 1e-9 and abs(r2_ - 1) < 1e-9 and n1_ == 39, str((r1_, r2_, n1_)))
    ck("autocorrelazione: serie costante -> n.d. (varianza zero), non un numero inventato", acf_lag(serie_da([2.0] * 10), 1)[0] is None)
    ck("autocorrelazione: la coppia NON attraversa le tranche (2 tranche da 2 notti, lag 1 -> 2 coppie, non 3)", acf_lag({"T1": serie_da([1.0, 2.0])["T1"], "T2": serie_da([3.0, 5.0], "T2")["T2"]}, 1)[1] == 2)
    k1, n1, k0, n0 = cond_neg(serie_da([-1.0, -1.0, 1.0, -1.0, 1.0, 1.0]))
    ck("q condizionata: dopo negativa 1 su 3, dopo non negativa 2 su 2 (a mano)", (k1, n1, k0, n0) == (1, 3, 1, 2), str((k1, n1, k0, n0)))
    b1 = bootstrap(serie_da([3.0, -2.0, 4.0, -1.0, 5.0, -3.0] * 10)["T1"], 300, 7)
    b2 = bootstrap(serie_da([3.0, -2.0, 4.0, -1.0, 5.0, -3.0] * 10)["T1"], 300, 7)
    ck("bootstrap: stesso seed = stesso intervallo; q osservato 0,5 dentro l'intervallo", b1 == b2 and b1["q"][0] <= 0.5 <= b1["q"][1], str(b1))
    # il bootstrap e' PER NOTTE: una notte con 3 operazioni resta insieme (il PF non puo' mai uscire da combinazioni di notti intere)
    nn = [{"data": datetime.date(2026, 1, 1), "net": 10.0, "gp": 30.0, "gl": 20.0, "nops": 3}, {"data": datetime.date(2026, 1, 2), "net": -5.0, "gp": 0.0, "gl": 5.0, "nops": 1}]
    bb = bootstrap(nn, 400, 3)
    ck("bootstrap PER NOTTE: con 2 notti i PF possibili sono solo 1,5 / 1,2 / 0 (combinazioni di notti intere)", all(round(x, 6) in (1.5, 1.2, 0.0) for x in bb["pf"]), str(bb))

    # 3. lotto finto con zip di notti
    def serie_ops(date0, nets, ora=2):
        return _spec_notte(date0, nets, ora=ora)
    tr_da = {t: pr1["tranche"][t][0] for t in pr1["tranche"]}
    base_nets = [100.0, -50.0, 80.0, -120.0, 60.0, 40.0, -30.0, 90.0]
    ops1 = {"T1": serie_ops(tr_da["T1"], base_nets), "T2": serie_ops(tr_da["T2"], base_nets), "T3": serie_ops(tr_da["T3"], base_nets)}
    zA = _zip_notte(pr1, "M1", ops1)
    rc, txt = _esegui_catturando([zA, "--senza-ancora", "--bootstrap", "100", "--prova-m1", p1, "--prova-m5", p5])
    ck("lotto notte finto M1 (24 operazioni, tutte alle 02:00): lettura riuscita (rc 0), tutte le passate LEGGIBILI", rc == 0 and txt.count("-> LEGGIBILE") == 3, "rc=%s\n%s" % (rc, txt[:1500]))
    ck("lotto finto: il controllo diretto conta 8 deal d'ingresso per passata, tutti dentro", txt.count("deal d'ingresso 8, dentro la fascia 8, fuori 0") == 3)
    nets_att = [x - 3.9 for x in base_nets]
    pf_att = sum(x for x in nets_att if x > 0) / -sum(x for x in nets_att if x < 0)
    ck("PF_V del lotto finto = PF dei netti con la commissione ipotetica 3,90 (conto indipendente: %.3f)" % pf_att, ("PF_V %.3f" % pf_att) in txt, txt[:100])
    ck("lotto finto: nessuna riga con la parola vietata e 'NON ANCORA MISURATO' presente", ("mort" + "o") not in txt.lower() and "NON ANCORA MISURATO" in txt)
    ck("lotto finto con solo M1: il confronto M1/M5 dichiara 'NON POSSIBILE', non inventa", "CONFRONTO M1/M5 NON POSSIBILE" in txt and "LOTTO M5 (R2NOTTEM5): NON PRESENTE" in txt)
    ck("H-M5N intera stampata con la dichiarazione 'solo la meta' NOTTURNA'", "L'IPOTESI H-M5N DEL COLLEGA" in txt and "misurabile SOLO la meta' NOTTURNA" in txt)
    for nr, b in h5 or []:
        if b.strip() and ("r.%-3d %s" % (nr, asc(b.rstrip()))) not in txt:
            ck("H-M5N: ogni riga del paragrafo del file prova e' nell'uscita", False, "manca r.%d" % nr)
            break
    else:
        ck("H-M5N: OGNI riga del paragrafo del file prova (r.%d-%d) e' nell'uscita, parola per parola" % (h5[0][0], h5[-1][0]) if h5 else "H-M5N", bool(h5))
    ck("la fascia, il commit e l'SHA256 dei file prova sono dichiarati in testa", "File prova M1" in txt and "SHA256" in txt and "ultimo commit" in txt)

    # filtro: un deal d'ingresso alle 07:00 nella T2
    ops_f = {"T1": ops1["T1"], "T2": serie_ops(tr_da["T2"], base_nets[:7]) + _spec_notte("2026.05.20", [10.0], ora=7), "T3": ops1["T3"]}
    zF = _zip_notte(pr1, "M1", ops_f)
    rc, txt = _esegui_catturando([zF, "--senza-ancora", "--bootstrap", "100", "--prova-m1", p1, "--prova-m5", p5])
    ck("un ingresso alle 07:00:00 (UNO solo) -> 'FILTRO NON COME DICHIARATO' sulla passata T2", "FILTRO NON COME DICHIARATO / INPUT DIVERSI:" in txt and "1 deal d'ingresso su 8 con ora server FUORI" in txt)
    ck("... la passata T2 risulta NON LEGGIBILE, T1 e T3 restano LEGGIBILI, rc = 3", txt.count("-> NON LEGGIBILE") == 1 and txt.count("-> LEGGIBILE") == 2 and rc == 3, "rc=%s" % rc)
    ck("... e il TOTALE della cella NON si calcola (nessuna riga TOT)", "TOT: NON CALCOLATO" in txt and "\n   TOT " not in txt)
    ck("... e le attese non si stampano accanto a un totale che non c'e'", "(3) ATTESE DEL FILE PROVA" not in txt)
    for ora, minuto, sec_ok in ((6, 59, True), (0, 0, True), (7, 0, False), (23, 59, False)):
        ops_b = {"T1": serie_ops(tr_da["T1"], base_nets), "T2": serie_ops(tr_da["T2"], base_nets), "T3": serie_ops(tr_da["T3"], base_nets)}
        ops_b["T3"][3] = _spec_notte("2026.02.20", [10.0], ora=ora, minuto=minuto)[0]
        zb = _zip_notte(pr1, "M1", ops_b)
        rc, tb = _esegui_catturando([zb, "--senza-ancora", "--bootstrap", "50", "--prova-m1", p1, "--prova-m5", p5])
        ck("confine della fascia: ingresso alle %02d:%02d -> %s" % (ora, minuto, "dentro (letto)" if sec_ok else "FUORI (passata non letta)"), ("FILTRO NON COME DICHIARATO / INPUT DIVERSI:" not in tb) == sec_ok, tb[:300])
    # ini diverso (HourEnd=24 nell'ini ma deal tutti di notte)
    zI = _zip_notte(pr1, "M1", ops1, ini_cambi={"InpHourEnd": "24"})
    rc, txt = _esegui_catturando([zI, "--senza-ancora", "--bootstrap", "50", "--prova-m1", p1, "--prova-m5", p5])
    ck("CONTRO-ESEMPIO: ini con InpHourEnd=24 ma deal tutti notturni -> INPUT DIVERSI, passate non lette (il solo controllo sui deal non basta)", txt.count("-> NON LEGGIBILE") == 3 and "InpHourEnd=24 nell'ini invece di 7" in txt and rc == 3, "rc=%s" % rc)
    zQ = _zip_notte(pr1, "M1", ops1, qualita="90% ticks reali")
    rc, txt = _esegui_catturando([zQ, "--senza-ancora", "--bootstrap", "50", "--prova-m1", p1, "--prova-m5", p5])
    ck("qualita' dello storico 90% (non tick reali) -> passata NON LEGGIBILE", "qualita' dello storico" in txt and txt.count("-> NON LEGGIBILE") == 3)
    # doppio caricamento
    rc, txt = _esegui_catturando([zA, zA, "--senza-ancora", "--prova-m1", p1, "--prova-m5", p5])
    ck("lo STESSO zip caricato due volte = ERRORE (rc 1) e NESSUN numero (niente PF_V, niente notti)", rc == 1 and "ERRORE" in txt and "PF_V" not in txt and "notti" not in txt.replace("nessun numero", ""), "rc=%s\n%s" % (rc, txt[:500]))
    zA_copia = os.path.join(tmpd, "copia_di_zA.zip")
    open(zA_copia, "wb").write(open(zA, "rb").read())
    rc, txt = _esegui_catturando([zA, zA_copia, "--senza-ancora", "--prova-m1", p1, "--prova-m5", p5])
    ck("la stessa misura in due FILE diversi (copia byte per byte) = ERRORE senza numeri", rc == 1 and "DUE volte" in txt and "PF_V" not in txt)
    # zip annidato + doppio fra esterno e interno
    zM5_ops = {"T1": serie_ops(tr_da["T1"], base_nets[:5]), "T2": serie_ops(tr_da["T2"], base_nets), "T3": serie_ops(tr_da["T3"], base_nets)}
    zB = _zip_notte(pr5, "M5", zM5_ops)
    ext = _zip_esterno([("GBA_R0_R2NOTTEM1.zip", zA), ("GBA_R0_R2NOTTEM5.zip", zB)])
    rc, txt = _esegui_catturando([ext, "--senza-ancora", "--bootstrap", "100", "--prova-m1", p1, "--prova-m5", p5])
    ck("zip ESTERNO con i due zip dei lotti (GBA_R2_NOTTE.zip): letti tutti e due, 6 passate LEGGIBILI, rc 0", rc == 0 and txt.count("-> LEGGIBILE") == 6, "rc=%s\n%s" % (rc, txt[:1200]))
    ck("... con la tabella di confronto M1/M5 sulle STESSE notti (comuni per tranche)", "(b) M1 notte contro M5 notte sullo STESSO insieme di notti" in txt)
    # notti comuni: M1 ha 8 notti per tranche, M5 ha 5 in T1 e 8 nelle altre: comuni T1 = 5, solo M1 = 3
    ck("... T1: 5 notti comuni, 3 solo in M1, 0 solo in M5 (costruite apposta)", re.search(r"T1\s+5\s+3\s+0 \|", txt) is not None, txt[txt.find("(b)"):txt.find("(b)") + 700])
    rc, txt = _esegui_catturando([ext, zA, "--senza-ancora", "--prova-m1", p1, "--prova-m5", p5])
    ck("zip esterno + lo stesso lotto M1 caricato a parte = ERRORE (il doppione vede dentro l'esterno)", rc == 1 and "DUE volte" in txt and "PF_V" not in txt)
    zB_p = _zip_notte(pr5, "M5", zM5_ops, nome_ini_period="M1")
    rc, txt = _esegui_catturando([zB_p, "--senza-ancora", "--bootstrap", "50", "--prova-m1", p1, "--prova-m5", p5])
    ck("   ... (contro-esempio) Period=M1 nell'ini di un lotto M5 -> 'Period=M1 nell'ini invece di M5'", "Period=M1 nell'ini invece di M5" in txt and txt.count("-> NON LEGGIBILE") == 3, txt[:600])

    # copia del file prova dentro lo zip: identica / diversa (attese riscritte dopo la partenza del lotto)
    testo_prova = open(p1, "rb").read()
    zP = _zip_notte(pr1, "M1", ops1, prova_nello_zip=testo_prova)
    rc, tp = _esegui_catturando([zP, "--senza-ancora", "--bootstrap", "50", "--prova-m1", p1, "--prova-m5", p5])
    ck("copia del file prova nello zip IDENTICA a quella letta: dichiarato", "IDENTICA al file letto" in tp and rc == 0)
    zP2 = _zip_notte(pr1, "M1", ops1, prova_nello_zip=testo_prova.replace(b"n 142-160", b"n 100-300"))
    rc, tp2 = _esegui_catturando([zP2, "--senza-ancora", "--bootstrap", "50", "--prova-m1", p1, "--prova-m5", p5])
    ck("CONTRO-ESEMPIO: copia del file prova nello zip con l'attesa di n riscritta (142-160 -> 100-300) -> 'DIVERSA' e la riga che differisce e' stampata", "DIVERSA dal file letto" in tp2 and "n 100-300" in tp2 and "n 142-160" in tp2, tp2[:300])
    # attese: confini dentro/fuori e smentite (stretti: > 175 e < 130)
    for n_, atteso_in, sm_hi, sm_lo in ((142, True, False, False), (160, True, False, False), (141, False, False, False), (161, False, False, False), (175, False, False, False), (176, False, True, False), (130, False, False, False), (129, False, False, True)):
        righe_ = []
        Cm = {"prova": mp, "costo": [], "parziale": False, "mancanti": []}
        stampa_attese(righe_.append, Cm, {"n_ops": n_, "n_notti": 10, "neg": 3, "q": 0.3, "pf": 1.0}, float("nan"))
        tt = "\n".join(righe_)
        okb = ("DENTRO attesa" in tt.split("\n")[1]) == atteso_in and (re.search(r"smentita r\.\d+ '> 175': n = %d > 175\? -> SCATTA" % n_, tt) is not None) == sm_hi and (("'n < 130': n = %d < 130? -> SCATTA" % n_) in tt) == sm_lo
        ck("attese: n = %d -> banda 142-160 %s, smentita >175 %s, smentita <130 %s" % (n_, "dentro" if atteso_in else "fuori", "scatta" if sm_hi else "no", "scatta" if sm_lo else "no"), okb, tt[:700])
    # CONCENTRAZIONE PER NOTTE: il controesempio ESATTO del cancello (n=210, PF_V 1,40, 3 notti x 3 operazioni = +6.000 su netto +4.600)
    def ops_notti(date0, liste, passo=1):
        out = []
        d0 = datetime.datetime.strptime(date0, "%Y.%m.%d")
        for k, nets_n in enumerate(liste):
            for h, v in enumerate(nets_n):
                t = d0 + datetime.timedelta(days=k * passo, hours=h)
                out.append((t.strftime("%Y.%m.%d %H:%M:%S"), "buy", round(v + 3.9, 2), 4.0, 0.10, 6))
        return out
    rng = random.Random(1)
    normali = [101.0] * 100 + [0.0] + [-115.0] * 100            # 201 operazioni: gp 10100, gl 11500, netto -1400
    rng.shuffle(normali)
    notti_n = [normali[i:i + 3] for i in range(0, 201, 3)]       # 67 notti da 3 operazioni
    grandi = [[2000.0 / 3] * 3 for _ in range(3)]                # 3 notti x 3 operazioni = +6000
    parti = {"T1": grandi + notti_n[:22], "T2": notti_n[22:45], "T3": notti_n[45:]}
    ops_c = {tr: ops_notti(tr_da[tr], parti[tr]) for tr in parti}
    n_tot_c = sum(len(v) for v in ops_c.values())
    zK = _zip_notte(pr1, "M1", ops_c)
    rc, tk = _esegui_catturando([zK, "--senza-ancora", "--bootstrap", "50", "--prova-m1", p1, "--prova-m5", p5])
    ck("lotto finto del controesempio: n = 210 operazioni, tutte le passate LEGGIBILI", n_tot_c == 210 and rc == 0 and tk.count("-> LEGGIBILE") == 3, "n=%d rc=%s" % (n_tot_c, rc))
    mtot = re.search(r"TOT\s+n op\s+(\d+) \|.*?\| PF_V (\S+) \| netto (\S+)", tk)
    ck("... PF_V 1,40 e netto +4.600 (come nel controesempio)", mtot is not None and int(mtot.group(1)) == 210 and abs(float(mtot.group(2)) - 1.40) < 0.005 and abs(float(mtot.group(3)) - 4600) < 1.0, str(mtot.groups() if mtot else tk[:300]))
    ck("... S5 PER OPERAZIONE dice 'non fragile' (come il cancello ha trovato)", re.search(r"concentrazione PER OPERAZIONE \(S5.*-> non fragile", tk) is not None)
    ck("... e la concentrazione PER NOTTE dice 'FRAGILE PER NOTTE' (netto senza le 3 migliori notti = -1.400)", re.search(r"concentrazione PER NOTTE.*senza le 3 migliori notti -1400.*-> FRAGILE PER NOTTE", tk) is not None, tk[tk.find("concentrazione PER NOTTE") - 20:tk.find("concentrazione PER NOTTE") + 500])
    ck("... il caso 'senza le 3 migliori notti' ha PF_V 0,88 (100,10/115 -> gp 10100 / gl 11500)", abs(10100.0 / 11500.0 - 0.88) < 0.005)
    st_k = statistiche({tr: notti_da_posizioni([{"t": datetime.datetime.strptime(o[0], "%Y.%m.%d %H:%M:%S"), "net_v": o[2] - 3.9, "ora": 0} for o in ops_c[tr]]) for tr in ops_c}, estrai_soglie_notti(pr1), 0, 1)
    ck("... in unita': 70 notti, le 3 migliori valgono +6000, conc_k[3] = -1400, fragile_notte True", st_k["n_notti"] == 70 and abs(st_k["conc_k"][3] + 1400) < 1.0 and st_k["fragile_notte"] is True, str(st_k["conc_k"]))
    dist = serie_da([50.0] * 40)
    sd = statistiche(dist, estrai_soglie_notti(pr1), 0, 1)
    ck("CASO OPPOSTO: guadagno distribuito su 40 notti (+50 ciascuna): senza le 3 migliori notti +1850 -> NON fragile per notte", sd["fragile_notte"] is False and abs(sd["conc_k"][3] - 1850) < 1e-9 and abs(sd["conc_k"][5] - 1750) < 1e-9, str(sd["conc_k"]))
    ck("il confine: netto senza le 3 migliori notti ESATTAMENTE 0 -> FRAGILE PER NOTTE (<= 0)", statistiche(serie_da([10.0, 10.0, 10.0]), estrai_soglie_notti(pr1), 0, 1)["fragile_notte"] is True)
    ck("la soglia k (3) e le 'anche senza le 5' sono LETTE dal file prova e dichiarate (riga citata) nella lettura", estrai_soglie_notti(pr1)["k_fragile"] == 3 and estrai_soglie_notti(pr1)["k_riga"] is not None and "scritta nel file prova, r." in tk, str(estrai_soglie_notti(pr1)))
    sd2 = estrai_soglie_notti(mp)
    ck("file prova SENZA la soglia per notte (mini): 3 DERIVATA dal cancello, dichiarata", sd2["k_fragile"] == 3 and sd2["k_derivata"] is True)
    pm3 = os.path.join(tmpd, "mini3.txt")
    open(pm3, "w").write(MINI_PROVA + "#  la soglia: netto senza le 4 migliori notti <= 0 = FRAGILE PER NOTTE (si stampa anche senza le 6)\n")
    s3 = estrai_soglie_notti(leggi_prova(pm3))
    ck("CONTRO-ESEMPIO: se il file prova dice 4 migliori notti (e anche 6), lo script legge 4 e 6 (non e' scritto nello script)", s3["k_fragile"] == 4 and s3["k_extra"] == [6] and statistiche(serie_da([10.0] * 4 + [-5.0]), s3, 0, 1)["fragile_notte"] is True and statistiche(serie_da([10.0] * 4 + [-5.0]), estrai_soglie_notti(pr1), 0, 1)["fragile_notte"] is False and 6 in statistiche(serie_da([1.0] * 8), s3, 0, 1)["conc_k"], str(s3))
    zK5 = _zip_notte(pr5, "M5", ops_c)
    rc, tk5 = _esegui_catturando([_zip_esterno([("GBA_R0_R2NOTTEM1.zip", zK), ("GBA_R0_R2NOTTEM5.zip", zK5)]), "--senza-ancora", "--bootstrap", "50", "--prova-m1", p1, "--prova-m5", p5])
    ck("clausola (c) di H-M5N con il controesempio nel lotto M5: 'per operazione (S5) non fragile; per notte FRAGILE PER NOTTE', letta solo con la concentrazione per notte",
       re.search(r"Clausola \(c\).*SOLO con la concentrazione PER NOTTE.*per operazione \(S5\) non fragile; per notte FRAGILE PER NOTTE", tk5) is not None, tk5[tk5.find("Clausola"):tk5.find("Clausola") + 400])
    rc, tk6 = _esegui_catturando([zA, "--senza-ancora", "--bootstrap", "50", "--prova-m1", p1, "--prova-m5", p5])
    ck("clausola (c) senza lotto M5: 'NON MISURATO in questa corsa'", "Clausola (c): NON MISURATO" in tk6)
    # una passata SENZA operazioni non fa crollare niente
    ops_v = {"T1": ops1["T1"], "T2": [], "T3": ops1["T3"]}
    zE = _zip_notte(pr1, "M1", ops_v)
    rc, te = _esegui_catturando([zE, "--senza-ancora", "--bootstrap", "50", "--prova-m1", p1, "--prova-m5", p5])
    ck("una passata con ZERO operazioni (T2) non fa crollare la lettura: nessun ERRORE INTERNO, T2 mostra n op 0", "ERRORE INTERNO" not in te and re.search(r"T2\s+n op\s+0 ", te) is not None, te[-600:])
    # una gemella 775850 NON dichiarata nel file prova blocca il totale
    zG = _zip_notte(pr1, "M1", {"T1": ops1["T1"]}, magic="775850")
    rc, tg = _esegui_catturando([zA, zG, "--senza-ancora", "--bootstrap", "50", "--prova-m1", p1, "--prova-m5", p5])
    ck("una passata gemella 775850 NON dichiarata dal file prova -> 'passata gemella ... non prevista', NON LEGGIBILE, totale non calcolato, rc 3", "passata gemella N7:T1:775850 non prevista" in tg and "TOT: NON CALCOLATO" in tg and rc == 3, "rc=%s" % rc)
    # deal alterato in un lotto finto: i numeri cambiano
    ops_alt = {k: list(v) for k, v in ops1.items()}
    t_, l_, p_, a_, s_, d_ = ops_alt["T1"][2]
    ops_alt["T1"][2] = (t_, l_, p_ + 500.0, a_, s_, d_)
    zD = _zip_notte(pr1, "M1", ops_alt)
    rc0, t0 = _esegui_catturando([zA, "--senza-ancora", "--bootstrap", "50", "--prova-m1", p1, "--prova-m5", p5])
    rc1, t1 = _esegui_catturando([zD, "--senza-ancora", "--bootstrap", "50", "--prova-m1", p1, "--prova-m5", p5])
    ck("CONTRO-ESEMPIO: un deal alterato (+500 su una notte) CAMBIA i numeri letti (PF_V e netto)", rc1 == 0 and t0 != t1 and "PF_V" in t1 and re.findall(r"TOT\s+n op\s+\d+ \|.*?\| PF_V (\S+) \| netto (\S+)", t0) != re.findall(r"TOT\s+n op\s+\d+ \|.*?\| PF_V (\S+) \| netto (\S+)", t1), "rc=%s" % rc1)
    # una notte alterata (spostata di data): il numero di notti cambia
    ops_mv = {k: list(v) for k, v in ops1.items()}
    tt = ops_mv["T1"][1]
    ops_mv["T1"][0] = (tt[0], ) + ops_mv["T1"][0][1:]     # prima e seconda operazione nella STESSA notte (stessa data): le notti scendono di 1
    zV = _zip_notte(pr1, "M1", ops_mv)
    rc, tv = _esegui_catturando([zV, "--senza-ancora", "--bootstrap", "50", "--prova-m1", p1, "--prova-m5", p5])
    ck("CONTRO-ESEMPIO: due operazioni nella stessa data server = UNA notte (notti T1: 7 invece di 8, operazioni 8)", re.search(r"\[T1\]\n\s+notti 7 \(con 8 operazioni\)", tv) is not None, tv[tv.find("[T1]") - 50:tv.find("[T1]") + 300])
    # commissione addebitata dal tester: nessuna commissione ipotetica
    zC = _zip_notte(pr1, "M1", ops1, comm=-1.95)
    rc, tc = _esegui_catturando([zC, "--senza-ancora", "--bootstrap", "50", "--prova-m1", p1, "--prova-m5", p5])
    ck("con commissione addebitata dal tester (-3,90 a operazione) il PF_V e' lo stesso del caso con commissione ipotetica", ("PF_V %.3f" % pf_att) in tc)

    # dichiarazione di attese: dentro/fuori con i numeri letti dal file
    ck("le attese del file prova compaiono accanto ai numeri con la riga citata e 'DENTRO/FUORI attesa'", re.search(r"attesa r\.\d+ '.*' = .* -> (DENTRO|FUORI) attesa", txt) is not None or re.search(r"attesa r\.\d+ '.*' = .* -> (DENTRO|FUORI) attesa", t0) is not None, t0[t0.find("(3)"):t0.find("(3)") + 800])

    # 4. non regressione sui 4 zip veri R2 gia' archiviati: NON APPLICABILE
    veri = [os.path.join(R2_DIR, n) for n in ("GBA_R0_R2SOLOBUY.zip", "GBA_R0_R2SOLOSELL.zip", "GBA_R0_R2TATR.zip", "GBA_R0_R2TTREND.zip")]
    if all(os.path.isfile(v) for v in veri):
        for v in veri:
            rc, tv = _esegui_catturando([v, "--senza-ancora", "--prova-m1", p1, "--prova-m5", p5])
            ck("NON REGRESSIONE %s: NON APPLICABILE (rc 2), nessun numero per notte" % os.path.basename(v), rc == 2 and "NON APPLICABILE" in tv and "PF_V" not in tv and "(4) LA NOTTE" not in tv and "(2) PRIMA DI OGNI LETTURA" not in tv, "rc=%s\n%s" % (rc, tv[-600:]))
            ck("   ... e dice perche': il filtro orario dell'ini (InpHourStart=0 InpHourEnd=24)", "InpHourStart=0 InpHourEnd=24" in tv)
        rc, tv = _esegui_catturando(veri + ["--senza-ancora", "--prova-m1", p1, "--prova-m5", p5])
        ck("NON REGRESSIONE: i 4 zip veri insieme -> 4 lotti NON APPLICABILI, rc 2, il caricamento dei doppioni del lettore non da' errore", rc == 2 and tv.count("NON APPLICABILE") == 4, "rc=%s" % rc)
        # e i 4 zip veri insieme a un lotto notte finto: il notte si legge, i 4 restano NON APPLICABILI
        rc, tv = _esegui_catturando(veri + [zA, "--senza-ancora", "--bootstrap", "50", "--prova-m1", p1, "--prova-m5", p5])
        ck("i 4 zip veri + un lotto notte finto: il lotto notte si legge (rc 0) e i 4 restano NON APPLICABILI", rc == 0 and tv.count("NON APPLICABILE") == 4 and tv.count("-> LEGGIBILE") == 3, "rc=%s" % rc)
        # l'ini REALE del driver v5 contro il file prova COPIATO nello zip: nessun falso positivo (pin + cella + Period + date), gemella dichiarata (REPL:T1:775850) accettata
        for v in (veri[0], veri[3], veri[2]):
            zz = zipfile.ZipFile(v)
            pn = [n for n in zz.namelist() if n.startswith("GBA_R2_")][0]
            pp = os.path.join(tmpd, pn)
            open(pp, "wb").write(zz.read(pn))
            prv = leggi_prova(pp)
            infos = [valuta_passata(P, prv, (0, 24)) for P in lg.carica([v])]
            ck("ini REALE del driver contro il file prova copiato nello zip (%s): tutte le %d passate LEGGIBILI con fascia 0-24, nessun input diverso" % (os.path.basename(v), len(infos)),
               all(i["stato"] == "LEGGIBILE" and not i["filtro"] for i in infos), str([(i["tag"], i["motivi"], i["filtro"]) for i in infos if i["stato"] != "LEGGIBILE"]))
        prv_txt = open(pp, "rb").read().decode("latin-1")
        ck("(prepara il contro-esempio) il file prova di TATR contiene il pin InpEmaPeriod=100", "\nInpEmaPeriod=100" in prv_txt)
        pp2 = os.path.join(tmpd, "prova_ritoccata.txt")
        open(pp2, "wb").write(prv_txt.replace("\nInpEmaPeriod=100", "\nInpEmaPeriod=90").encode("latin-1"))
        infos = [valuta_passata(P, leggi_prova(pp2), (0, 24)) for P in lg.carica([veri[2]])]
        ck("CONTRO-ESEMPIO: se il file prova dice InpEmaPeriod=90 e l'ini REALE ha 100, ogni passata e' NON LEGGIBILE con 'InpEmaPeriod=100 nell'ini invece di 90'",
           all(i["stato"] == "NON LEGGIBILE" and any("InpEmaPeriod=100 nell'ini invece di 90" in m for m in i["filtro"]) for i in infos), str([i["filtro"][:2] for i in infos]))
        # il controllo diretto, applicato per forza a un lotto vero senza filtro, FALLISCE (prova che discrimina)
        Ps = lg.carica([veri[0]])
        fi = [valuta_passata(P, pr1, (0, 7)) for P in Ps if P["magic"] == "775800"]
        ck("il controllo diretto discrimina: sui deal veri di SOLOBUY (24 ore) la fascia 0-6 ha ingressi FUORI in ogni passata", all(len(i["fuori"]) > 0 for i in fi) and len(fi) == 3, str([len(i["fuori"]) for i in fi]))
        # G1 dell'ancora: dai dati veri
        if os.path.isfile(R1A_ZIP):
            g, riga = g1_ancora(R1A_ZIP, R2TTREND_ZIP)
            ck("G1 dell'ancora sui dati veri (R1A T1 contro la gemella 775850 di R2TTREND): VERDE", g == "VERDE", riga)
            g, riga = g1_ancora(R1A_ZIP, os.path.join(tmpd, "non_esiste.zip"))
            ck("G1 dell'ancora con lo zip R2TTREND assente: NON VERIFICABILE (non VERDE per default)", g == "NON VERIFICABILE")
    else:
        ck("i 4 zip veri R2 archiviati sono presenti per la non-regressione", False, R2_DIR)

    # 5. con l'ancora vera in una corsa completa
    if os.path.isfile(R1A_ZIP):
        rc, tr_ = _esegui_catturando([ext, "--bootstrap", "100", "--prova-m1", p1, "--prova-m5", p5])
        ck("corsa completa M1+M5 finti con l'ancora R1A vera: stampa 142 operazioni / PF_V 0.944 / 53 notti / 33 negative", "ANCORA R1A post-hoc" in tr_ and "n op 142 | PF_V 0.944 | notti 53 | negative 33" in tr_, tr_[tr_.find("ANCORA R1A"):tr_.find("ANCORA R1A") + 400])
        ck("... e il G1 dell'ancora e' stampato VERDE", "G1 DELL'ANCORA" in tr_ and ": VERDE" in tr_)
        ck("... e la tabella (a) ha la riga TOT della serie R1A post-hoc con 142 operazioni", re.search(r"TOT\s+R1A post-hoc\s+142 ", tr_) is not None)
    # 6. i file prova non vengono modificati dall'autotest (sha prima/dopo) e il lettore nemmeno
    ck("il lettore non e' stato modificato dall'autotest (SHA256 invariato)", sha256_file(LETTORE_PATH) == LETTORE_SHA256)
    ck("i file prova non sono stati toccati dall'autotest", sha256_file(p1) == pr1["sha256"] and sha256_file(p5) == pr5["sha256"])
    import shutil
    shutil.rmtree(tmpd, ignore_errors=True)
    print("")
    print("controlli ESEGUITI: %d, falliti: %d" % (conta[0], len(falliti)))
    if falliti:
        print("AUTOTEST FALLITO:")
        for n in falliti:
            print("  - " + n)
        return 1
    print("AUTOTEST OK")
    return 0


def main(argv):
    if "--autotest" in argv:
        return autotest()
    return esegui(argv)


if __name__ == "__main__":
    sys.exit(main(sys.argv[1:]))
