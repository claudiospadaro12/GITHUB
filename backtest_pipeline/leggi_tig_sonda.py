#!/usr/bin/env python3
# -*- coding: ascii -*-
"""
leggi_tig_sonda.py -- il LETTORE della SONDA 1 dell'EA di TERZI 'The Impossible Gold 2.1' (XAUUSD M5, magic 778899) nel NOSTRO Strategy Tester
(zip/cartella di backtest_pipeline/righe/TIG_TESTER_SONDA.ps1). SOLA LETTURA. Scatola nera. Non giudica il merito, non promuove, non archivia.

USO
  python3 backtest_pipeline/leggi_tig_sonda.py TIG_TESTER_SONDA.zip
  python3 backtest_pipeline/leggi_tig_sonda.py --autotest

Riusa il parser del report di leggi_arena_tester.py (passato dal cancello il 14/10/2026). ATTESE scritte PRIMA dei numeri (15/10/2026):
  A. L'EA OPERA nel tester sul 14/10: >= 1 operazione nel report. Se ZERO: e' una MISURA MANCANTE (il tester rifiuta l'EA, la licenza del Market non
     gira nel tester, o il filtro non scatta), non un errore: si legge il giornale.
  B. GEMELLO: sul 14/10 il demo ha aperto CINQUE trade TIG (il tetto 'Max trades per day 5'), ora server BCM:
       LOW  SELL 0,31 11:05:00 a 4140,77 (SL)   [LETTO: ReportHistory_50503392_2026-10-14.xlsx, ordine 3672118, e trades_auto.csv]
       LOW  SELL 0,30 12:05:02 a 4137,05 (SL)   [LETTO: ReportHistory_50503392_2026-10-14.xlsx, ordine 3673166, e trades_auto.csv]
       LOW  SELL 0,35 17:05:00 a 4074,31 (SL)   [LETTO: trades_auto.csv pid 3682609; NON nei due xlsx: il 14/10 si ferma alle 13:58, il 15/10 parte dal 15/10]
       HIGH BUY  0,36 18:25:00 a 4086,57 (SL)   [LETTO: trades_auto.csv pid 3683888; idem]
       HIGH BUY  0,36 19:15:00 a 4091,20 (aperto la mattina del 15/10)   [LETTO: ReportHistory_50503392_2026-10-15.xlsx, posizioni aperte, 3684498]
     (v1 ne contava TRE: mancavano 17:05 e 18:25, che stanno solo nel CSV del logger -- controllo-preventivo 15/10.)
     Un trade del tester e' il GEMELLO di uno del demo se ha lo STESSO lato, apre entro 10 minuti e a meno di 1,0 USD di prezzo.
     REGGE se almeno 4 dei 5 hanno il gemello; SMENTITA se 0, 1 o 2; 3 su 5 = NON DECISA. (Si giudica SOLO se il giro e' CONFORME e le ancore (C) ci sono.)
  C. I VALORI USATI dal tester sono quelli della finestra del demo (screenshot del 15/10): 12 ancore numeriche (magic 778899, TP 300, SL 25, rischio 1,5,
     lookback 16, buffer 1,5, range minimo 5, sessione 10-20, esclusione fine 15, passo del TP 14, distanza trailing 2). Il confronto e' per MULTINSIEME:
     un valore che compare k volte fra le ancore (1,5 = rischio E buffer) deve comparire almeno k volte fra i valori del report, e per ogni ancora si
     stampano i NOMI degli input che portano quel valore (i piccoli interi 2/5/10/15/20 li possono portare anche altri input: i nomi si guardano a occhio
     prima di usare (B)). CONFORME se tutte le ancore ci sono; altrimenti i default NON sono quelli del demo: (B) e' descrittiva e la sonda 2 impone gli
     input coi NOMI qui stampati.
  D. OROLOGIO GMT DEL TESTER (ipotesi ALTERNATIVA dichiarata prima, classe 762): nel tester TimeGMT() = TimeTradeServer(). Se TIG legge la sessione
     (10-20 GMT, esclusa 12-15) da TimeGMT(), nel tester la applica alle ORE SERVER (H2: possibili 10,11,15..20), mentre sul demo (server UTC+1) la
     applicava a server 11,12,16..21 (H1); gli estremi ambigui (fine 20 e fine esclusione 15 inclusi o no) stanno fra i possibili. Ore che solo H1
     puo' produrre: 12 e 21. Ore che solo H2 puo' produrre: 10 e 15. Il gemello delle 12:05 e' impossibile
     sotto H2. Esito: H1 se c'e' un trade del tester alle ore 12/21 (o il gemello delle 12:05) e nessuno alle 10/15; H2 se il contrario; ENTRAMBE o
     ore fuori da tutte e due = l'EA non usa (solo) TimeGMT; nessuna ora discriminante = NON DECISA. Se H2: OGNI sonda lunga di TIG nel tester misura
     un EA con la sessione spostata di un'ora rispetto al campo, e va detto prima di leggerne i numeri.
Giro CONFORME = simbolo XAUUSD, periodo M5(2026.10.14-2026.10.15), qualita' 100% ticks reali, deposito 5000, leva 1:100, un solo Expert 'Impossible',
provenienza (REFERTO_TIG_SONDA.txt: marcatore, pin passato dal cancello, data, .ex5 UGUALE). Le ancore (C) NON sono parte della conformita' del giro
ma della lettura di (B): senza di esse (B) e' descrittiva. Se il giro NON e' conforme NESSUNA attesa (A, B, C, D) riceve un verdetto. ASCII puro.
"""
import argparse
import collections
import datetime as dt
import os
import re
import sys
import tempfile

sys.path.insert(0, os.path.dirname(os.path.abspath(__file__)))
import leggi_arena_tester as L  # noqa: E402

PIN_PASSATI_TIG = ("cc86973ddd633384beab3c357486a83c46e1e7be",)   # v2: il pin della riga v2 passata dal cancello (fail-closed se vuota)
MARCATORE_ATTESO = "MARCATORE_TIG_TESTER_SONDA_v2"
DATA_MINIMA_REFERTO = "2026-10-15"
PERIODO_ATTESO = ("2026.10.14", ("2026.10.14", "2026.10.15"))
LEVA = "1:100"
DEPOSITO = 5000.0
LIVE = [("sell", 0.31, "2026.10.14 11:05:00", 4140.77, "LOW"), ("sell", 0.30, "2026.10.14 12:05:02", 4137.05, "LOW"),
        ("sell", 0.35, "2026.10.14 17:05:00", 4074.31, "LOW"), ("buy", 0.36, "2026.10.14 18:25:00", 4086.57, "HIGH"),
        ("buy", 0.36, "2026.10.14 19:15:00", 4091.20, "HIGH")]
TOL_MIN = 10.0
TOL_PX = 1.0
B_REGGE = 4       # >= 4 su 5
B_SMENTITA = 2    # <= 2 su 5 ; 3 = NON DECISA
# (D) ore SERVER che ciascuna lettura PUO' produrre. Gli estremi ambigui (fine sessione 20 GMT e fine esclusione 15 GMT: inclusi o no [NON NOTO])
# stanno fra i POSSIBILI, mai fra quelli che escludono l'altra lettura: H1 = TIG legge il GMT vero (server = UTC+1, il demo), H2 = nel tester
# TimeGMT() = ora server (classe 762). Solo-H1 = {12, 21}, solo-H2 = {10, 15}, entrambe = {11, 16..20}, nessuna = il resto.
ORE_H1 = (11, 12, 16, 17, 18, 19, 20, 21)
ORE_H2 = (10, 11, 15, 16, 17, 18, 19, 20)
ORE_SOLO_H1 = tuple(h for h in ORE_H1 if h not in ORE_H2)
ORE_SOLO_H2 = tuple(h for h in ORE_H2 if h not in ORE_H1)
# ancore: (descrizione, valore numerico o testo) dalla finestra Proprieta' del demo (15/10 09:43-09:44)
ANCORE = [("magic", 778899.0), ("take profit pips", 300.0), ("stop loss pips", 25.0), ("rischio % equity", 1.5), ("lookback barre", 16.0),
          ("buffer pips", 1.5), ("range minimo pips", 5.0), ("ora inizio GMT", 10.0), ("ora fine GMT", 20.0), ("esclusione fine", 15.0),
          ("passo TP pips", 14.0), ("distanza trailing", 2.0)]


def inputs_del_report(raw):
    """TUTTI i 'Nome=valore' della testa del report (nomi di QUESTO EA: non iniziano per Inp), in ordine, senza ripetizioni."""
    t = L.decodifica(raw)
    cut = len(t)
    for et in (">Ordini<", ">Orders<"):
        i = t.find(et)
        if i >= 0:
            cut = min(cut, i)
    piatto = re.sub(r"<[^>]+>", "|", t[:cut])
    piatto = re.sub(r"\s*\|[\s|]*", "|", piatto)
    out = collections.OrderedDict()
    for m in re.finditer(r"\|([A-Za-z_][A-Za-z0-9_]*)=([^|]*)(?=\|)", piatto):
        out.setdefault(m.group(1), m.group(2).strip())
    return out


def num(v):
    try:
        return float(str(v).replace(" ", "").replace(",", "."))
    except ValueError:
        return None


def portatori(inp, v):
    """i NOMI degli input del report il cui valore numerico e' v (|d| < 1e-9)"""
    out = []
    for k, x in inp.items():
        y = num(x)
        if y is not None and abs(y - v) < 1e-9:
            out.append(k)
    return out


def ancore(inp):
    """(trovate, mancanti) per MULTINSIEME: un valore che compare k volte fra le ancore (1,5 = rischio e buffer) deve essere portato da almeno
    k input DISTINTI del report. v1 diceva 'almeno un valore uguale': un solo input a 1,5 soddisfaceva rischio E buffer (controllo-preventivo 15/10)."""
    trov, manc = [], []
    usati = collections.Counter()
    for d, v in ANCORE:
        chiave = round(v, 9)
        usati[chiave] += 1
        (trov if len(portatori(inp, v)) >= usati[chiave] else manc).append(d)
    return trov, manc


def orologio(tr):
    """(D) ore server dei trade del tester -> 'H1', 'H2', 'ENTRAMBE/NESSUNA' o 'NON DECISA', con il dettaglio"""
    ore = [x["t"].hour for x in tr]
    s1 = sorted(set(h for h in ore if h in ORE_SOLO_H1))
    s2 = sorted(set(h for h in ore if h in ORE_SOLO_H2))
    fuori = sorted(set(h for h in ore if h not in ORE_H1 and h not in ORE_H2))
    if fuori or (s1 and s2):
        return "ENTRAMBE/NESSUNA", "ore %s fuori da tutte e due le letture, ore solo-H1 %s, ore solo-H2 %s: l'EA non usa (solo) TimeGMT" % (fuori, s1, s2)
    if s1:
        return "H1", "ore solo-H1 presenti %s, nessuna ora solo-H2: TIG nel tester legge il GMT VERO (o ha un suo offset)" % s1
    if s2:
        return "H2", "ore solo-H2 presenti %s, nessuna ora solo-H1: nel tester TIG applica la sessione GMT alle ORE SERVER (classe 762)" % s2
    return "NON DECISA", "nessun trade alle ore discriminanti (10, 12, 15, 21 server): con questi trade le due letture coincidono"


def condizioni(nome, rep):
    m = []
    if rep.get("simbolo") != "XAUUSD":
        m.append("simbolo %s invece di XAUUSD" % rep.get("simbolo"))
    p = rep.get("periodo") or ""
    mm = re.match(r"^M5\((\d{4}\.\d\d\.\d\d)-(\d{4}\.\d\d\.\d\d)\)", p)
    if not mm or mm.group(1) != PERIODO_ATTESO[0] or mm.group(2) not in PERIODO_ATTESO[1]:
        m.append("periodo %s invece di M5(%s-%s)" % (p or "NON LETTO", PERIODO_ATTESO[0], PERIODO_ATTESO[1][-1]))
    if not (rep.get("qualita") or "").startswith("100%"):
        m.append("qualita' dello storico %s invece di 100%%" % rep.get("qualita"))
    if rep.get("deposito") is None or abs(rep["deposito"] - DEPOSITO) > 0.005:
        m.append("deposito %s invece di %.0f" % (rep.get("deposito"), DEPOSITO))
    if rep.get("leva") != LEVA:
        m.append("leva %s invece di %s" % (rep.get("leva"), LEVA))
    if not rep.get("expert") or "impossible" not in rep["expert"].lower() or len(rep.get("esperti") or []) != 1:
        m.append("Expert %s (celle Expert %d): non e' il solo The Impossible Gold" % (rep.get("expert"), len(rep.get("esperti") or [])))
    return m


def leggi_giornali_tig(src):
    """v2 (15/10/2026, verificatore-stringhe, ricorrenza della classe 1448): gli estratti dei giornali di QUESTA sonda (log/TIG1_*.txt).
    v1 chiamava L.leggi_giornali del padre, che cerca SOLO log/SONDA1_ e log/SONDA2_: i giornali TIG non venivano MAI letti e il lettore
    stampava 'nessun estratto' proprio nel caso (ZERO operazioni, licenza, EA rimosso) in cui l'attesa (A) rimanda al giornale."""
    per = collections.OrderedDict()
    for n in src.nomi():
        parti = n.replace("\\", "/").split("/")
        m = re.match(r"^(TIG1)_", parti[-1])
        if not m or parti[-2:-1] != ["log"]:
            continue
        d = per.setdefault(m.group(1), {"input": collections.OrderedDict(), "stop_out": set(), "no_money": set(), "errori": [], "file": 0, "righe": 0})
        d["file"] += 1
        dopo = 0
        for r in L.decodifica(src.leggi(n)).splitlines():
            if r.startswith("#"):
                continue
            d["righe"] += 1
            msg = r.rsplit("\t", 1)[-1]
            if "started with inputs" in r:
                dopo = 80
                continue
            if dopo > 0:
                dopo -= 1
                mi = re.match(r"^\s*([A-Za-z_][A-Za-z0-9_]*)=(.*)$", msg)
                if mi:
                    d["input"][mi.group(1)] = mi.group(2).strip()
                    continue
            if re.search(r"stop ?out", r, re.I):
                d["stop_out"].add(msg.strip())
            if re.search(r"no money|not enough money", r, re.I):
                d["no_money"].add(msg.strip())
            if len(d["errori"]) < 20 and re.search(r"error|failed|cannot|not found|invalid|licen|dll|critical|expired|removed", r, re.I):
                if msg.strip() not in d["errori"]:
                    d["errori"].append(msg.strip())
    return per


def stampa_giornali_tig(per):
    if not per:
        print("GIORNALI: NESSUN estratto log/TIG1_*.txt nelle sorgenti (lo zip della riga li porta sempre se il terminale ha scritto un giornale).")
        return
    for sn, d in per.items():
        print("GIORNALE %s (%d estratti, %d righe): input stampati dopo 'started with inputs': %s" % (
            sn, d["file"], d["righe"], ", ".join("%s=%s" % kv for kv in d["input"].items()) if d["input"] else "NESSUNO letto (formato [NON VERIFICATO]: fa fede il report)"))
        print("  righe distinte di stop out %d, di no money %d" % (len(d["stop_out"]), len(d["no_money"])))
        for e in d["errori"]:
            print("  giornale: " + e)


def provenienza(src):
    comuni, righe = [], []
    nomi = [n for n in src.nomi() if os.path.basename(n) == "REFERTO_TIG_SONDA.txt"]
    if not nomi:
        comuni.append("REFERTO_TIG_SONDA.txt ASSENTE: provenienza (script, pin, data, impronta del .ex5) NON verificata")
        return comuni, righe
    if len(nomi) > 1:
        comuni.append("%d REFERTO nella stessa sorgente: non so quale vale" % len(nomi))
    rr = L.decodifica(src.leggi(nomi[0])).splitlines()
    prima = rr[0] if rr else ""
    mpin = re.search(r"\bpin ([0-9a-fA-F]{40})\b", prima)
    mmar = re.search(r"MARCATORE_TIG_TESTER_SONDA_v\d+", prima)
    mdat = None
    for r in rr[:3]:
        mdat = re.match(r"^data: (\d{4}-\d\d-\d\d) \d\d:\d\d:\d\d", r)
        if mdat:
            break
    pin = mpin.group(1).lower() if mpin else None
    righe.append("PROVENIENZA dal REFERTO: marcatore %s | pin %s | data %s | pin passati dal cancello: %s" % (
        mmar.group(0) if mmar else "ASSENTE", pin or "ASSENTE", mdat.group(1) if mdat else "ASSENTE",
        ", ".join(PIN_PASSATI_TIG) if PIN_PASSATI_TIG else "NESSUNO (tupla vuota)"))
    if not mmar or mmar.group(0) != MARCATORE_ATTESO:
        comuni.append("marcatore %s invece di %s" % (mmar.group(0) if mmar else "ASSENTE", MARCATORE_ATTESO))
    if pin is None or pin not in PIN_PASSATI_TIG:
        comuni.append("pin %s NON fra quelli passati dal cancello (%s)" % (pin or "ASSENTE", ", ".join(PIN_PASSATI_TIG) if PIN_PASSATI_TIG else "tupla vuota"))
    if not mdat or mdat.group(1) < DATA_MINIMA_REFERTO:
        comuni.append("data del REFERTO %s prima del %s" % (mdat.group(1) if mdat else "ASSENTE", DATA_MINIMA_REFERTO))
    visto = None
    for r in rr:
        me = re.match(r"^EX5_DOPO (TIG1): (\S+) (UGUALE|DIVERSO)\s*$", r)
        if me:
            visto = me.group(3)
    if visto is None:
        comuni.append("riga EX5_DOPO TIG1 ASSENTE dal REFERTO: impronta del .ex5 dopo la passata NON ricontrollata")
    elif visto != "UGUALE":
        comuni.append("il .ex5 e' CAMBIATO durante la passata (EX5_DOPO DIVERSO)")
    return comuni, righe


def trade_del_tester(rep):
    """accoppia 'in' e 'out' per volume e ordine (1 posizione alla volta): lista di dict ordinati per apertura"""
    deals = rep["deals"]
    ins = [d for d in deals if d["dir"] == "in"]
    outs = [d for d in deals if d["dir"].startswith("out")]
    res = []
    usati = set()
    for d in ins:
        o = None
        for k, x in enumerate(outs):
            if k in usati or x["t"] < d["t"] or abs(x["vol"] - d["vol"]) > 1e-9:
                continue
            o = (k, x)
            break
        if o:
            usati.add(o[0])
        ord_ = rep["ordini"].get(d.get("ordine")) or {}
        res.append({"t": d["t"], "lato": d["tipo"], "vol": d["vol"], "px": d["prezzo"], "sl": ord_.get("sl"), "tp": ord_.get("tp"),
                    "t1": o[1]["t"] if o else None, "px1": o[1]["prezzo"] if o else None,
                    "netto": (o[1]["profitto"] + o[1]["comm"] + o[1]["swap"] + d["comm"]) if o else None, "commento": d.get("commento")})
    return res


def gemelli(tr):
    out = []
    for lato, vol, ts, px, nome in LIVE:
        t0 = dt.datetime.strptime(ts, "%Y.%m.%d %H:%M:%S")
        best = None
        for x in tr:
            if x["lato"] != lato or x["px"] is None:
                continue
            dm = abs((x["t"] - t0).total_seconds()) / 60.0
            dp = abs(x["px"] - px)
            if dm <= TOL_MIN and dp <= TOL_PX and (best is None or dm < best[1]):
                best = (x, dm, dp)
        out.append((lato, vol, ts, px, nome, best))
    return out


def stampa(nome, rep, inp, comuni):
    W = print
    W("=" * 118)
    W("REPORT  --  %s" % nome)
    W("=" * 118)
    W("Expert %s | simbolo %s | periodo %s | qualita %s | barre %s | tick %s | deposito %s | leva %s" % (
        rep["expert"], rep["simbolo"], rep["periodo"], rep["qualita"], L.fmt(rep["barre"], 0), L.fmt(rep["ticks"], 0), L.fmt(rep["deposito"]), rep["leva"]))
    mot = comuni + condizioni(nome, rep)
    conforme = not mot
    if mot:
        W("GIRO NON CONFORME a quello dichiarato -> " + "; ".join(mot[:8]) + " : i numeri sono DESCRITTIVI di QUEL giro, nessun verdetto")
    W("")
    W("INPUT USATI dal tester (nomi e valori del report, %d):" % len(inp))
    for k, v in inp.items():
        W("   %s=%s" % (k, v))
    trov, manc = ancore(inp)
    W("ANCORE (C): %d su %d trovate fra i valori del report (per MULTINSIEME: 1,5 serve DUE volte)." % (len(trov), len(ANCORE)))
    for d, v in ANCORE:
        W("   %-20s %-9s portato da: %s" % (d, ("%g" % v), ", ".join(portatori(inp, v)) or "NESSUN input"))
    W("   (i NOMI qui sopra si guardano a occhio: un piccolo intero puo' essere portato da un altro input; se il nome non e' quello dell'ancora, (C) non regge)")
    if manc:
        W("   MANCANTI: %s -> i default NON sono (tutti) quelli del demo: (B) e' descrittiva e la sonda 2 deve imporre gli input coi nomi sopra." % ", ".join(manc))
    ancore_ok = not manc
    W("")
    W("RISULTATO (dal report): operazioni %s | netto %s EUR | PF %s | DD equita' %s EUR (%s%%)" % (
        L.fmt(rep["trades"], 0), L.fmt(rep["profitto"]), L.fmt(rep["pf"]), L.fmt(rep["dd_eq_abs"]), L.fmt(rep["dd_eq_pct"], 2)))
    tr = trade_del_tester(rep)
    W("")
    W("TRADE DEL TESTER (%d):" % len(tr))
    W("  %-19s %-5s %5s %9s %9s %9s %-19s %9s %9s %s" % ("apertura", "lato", "lotto", "ingresso", "SL", "TP", "chiusura", "uscita", "netto", "commento"))
    for x in tr:
        W("  %-19s %-5s %5.2f %9s %9s %9s %-19s %9s %9s %s" % (x["t"].strftime("%Y.%m.%d %H:%M:%S"), x["lato"], x["vol"], L.fmt(x["px"], 2), L.fmt(x["sl"], 2), L.fmt(x["tp"], 2),
              x["t1"].strftime("%Y.%m.%d %H:%M:%S") if x["t1"] else "APERTA", L.fmt(x["px1"], 2), L.fmt(x["netto"]), x["commento"] or ""))
    for x in tr:
        if x["sl"] and x["tp"] and x["px"]:
            W("  geometria %s %s: SL a %.2f USD, TP a %.2f USD dall'ingresso (rapporto %.1f)" % (x["t"].strftime("%H:%M:%S"), x["lato"], abs(x["px"] - x["sl"]), abs(x["tp"] - x["px"]), abs(x["tp"] - x["px"]) / max(abs(x["px"] - x["sl"]), 1e-9)))
    W("")
    if not conforme:
        W("(A) NESSUN verdetto (giro non conforme): operazioni %s, descrittivo." % L.fmt(rep["trades"], 0))
    elif rep["trades"] is not None and rep["trades"] >= 1:
        W("(A) VERIFICATA: %d operazioni: l'EA opera nel tester." % rep["trades"])
    else:
        W("(A) NON VERIFICATA: ZERO operazioni. MISURA MANCANTE (il tester rifiuta l'EA, la licenza del Market non gira nel tester, o il filtro non scatta): leggere log\\TIG1_*.txt.")
    gem = gemelli(tr)
    for lato, vol, ts, px, nome_l, best in gem:
        if best:
            x, dm, dp = best
            W("   gemello di %s %s %.2f %s @ %.2f: SI (tester %s %.2f @ %.2f, scarto %.1f min, %.2f USD)" % (nome_l, lato, vol, ts[11:], px, x["t"].strftime("%H:%M:%S"), x["vol"], x["px"], dm, dp))
        else:
            W("   gemello di %s %s %.2f %s @ %.2f: NO" % (nome_l, lato, vol, ts[11:], px))
    n = sum(1 for g in gem if g[5])
    nl = len(LIVE)
    if conforme and ancore_ok:
        W("(B) GEMELLO: %d su %d -> %s" % (n, nl, "REGGE" if n >= B_REGGE else ("SMENTITA" if n <= B_SMENTITA else "NON DECISA")))
    else:
        W("(B) GEMELLO: %d su %d -> NESSUN verdetto (giro non conforme o ancore (C) mancanti): descrittivo." % (n, nl))
    esD, perD = orologio(tr)
    if conforme:
        W("(D) OROLOGIO GMT DEL TESTER: %s -- %s" % (esD, perD))
        if esD == "H2":
            W("    -> OGNI sonda lunga di TIG nel tester misura la sessione spostata di UN'ORA rispetto al campo (classe 762): va detto PRIMA di leggerne i numeri.")
    else:
        W("(D) OROLOGIO GMT DEL TESTER: NESSUN verdetto (giro non conforme); lettura descrittiva: %s -- %s" % (esD, perD))
    W("")
    W("COSA NON SI PUO' CONCLUDERE: un giorno, un regime; tester senza slippage ne' latenza; feed BCM; nessun merito; i valori degli input sono quelli che il report dice usati.")
    return 0


def leggi_percorsi(percorsi):
    rc, trovati = 0, 0
    for p in percorsi:
        src = L.Sorgente(p)
        for n in src.nomi():
            if os.path.basename(n) == "REFERTO_TIG_SONDA.txt":
                print("-" * 118)
                print("REFERTO dello script (%s) -- righe chiave:" % n)
                for r in L.decodifica(src.leggi(n)).splitlines():
                    if re.search(r"MARCATORE|^data:|^EX5:|^EX5_DOPO|^esiti:|STATO|NON LANCIATA|ATTENZIONE|^   - ", r):
                        print("  " + r.strip())
        comuni, righe = provenienza(src)
        for r in righe:
            print(r)
        for x in comuni:
            print("PROVENIENZA NON VERIFICATA: " + x)
        stampa_giornali_tig(leggi_giornali_tig(src))
        for n in src.nomi():
            if n.lower().endswith((".htm", ".html")):
                trovati += 1
                raw = src.leggi(n)
                rep = L.leggi_report(raw)
                if not rep["ok"]:
                    print("REPORT %s ILLEGGIBILE: %s" % (n, rep["motivo"]))
                    rc = max(rc, 2)
                    continue
                rc = max(rc, stampa(n, rep, inputs_del_report(raw), comuni))
    if trovati == 0:
        print("NESSUN report .htm nelle sorgenti date: la sonda non ha misurato niente (guardare il REFERTO e i log).")
        return 2
    return rc


def autotest():
    esito = [0]

    def ok(c, m):
        print("  %s  %s" % ("OK  " if c else "FAIL", m))
        if not c:
            esito[0] = 1
    print("AUTOTEST leggi_tig_sonda.py")
    global PIN_PASSATI_TIG
    salva = PIN_PASSATI_TIG
    try:
        pin = "c" * 40
        PIN_PASSATI_TIG = (pin,)

        def ref(p=pin, mar=MARCATORE_ATTESO, data="2026-10-15", ex="UGUALE"):
            r = ["TIG TESTER SONDA -- x. Script %s, pin %s" % (mar, p), "data: %s 10:00:00   pc: X" % data]
            if ex:
                r.append("EX5_DOPO TIG1: ABC %s" % ex)
            return "\r\n".join(r) + "\r\n"

        def prov(t, nome="REFERTO_TIG_SONDA.txt"):
            with tempfile.TemporaryDirectory() as td:
                open(os.path.join(td, nome), "w").write(t)
                return provenienza(L.Sorgente(td))
        c, _ = prov(ref())
        ok(not c, "1 REFERTO conforme")
        c, _ = prov(ref(p="d" * 40))
        ok(any("NON fra quelli passati" in x for x in c), "2 pin diverso -> sospeso")
        c, _ = prov(ref(mar="MARCATORE_ARENA_TESTER_TRANCHE_v2"))
        ok(any("marcatore" in x for x in c), "3 marcatore di un altro script -> sospeso")
        c, _ = prov(ref(data="2026-10-14"))
        ok(any("data del REFERTO" in x for x in c), "4 data prima del 15/10 -> sospeso")
        c, _ = prov(ref(ex="DIVERSO"))
        ok(any("CAMBIATO" in x for x in c), "5 .ex5 cambiato -> sospeso")
        c, _ = prov(ref(ex=None))
        ok(any("EX5_DOPO TIG1 ASSENTE" in x for x in c), "6 riga EX5_DOPO assente -> sospeso")
        c, _ = prov("", nome="ALTRO.txt")
        ok(any("ASSENTE" in x for x in c), "7 REFERTO assente -> sospeso")
        PIN_PASSATI_TIG = ()
        c, _ = prov(ref())
        ok(any("NON fra quelli passati" in x for x in c), "8 tupla dei pin vuota -> fail-closed")
        PIN_PASSATI_TIG = (pin,)
    finally:
        PIN_PASSATI_TIG = salva
    # ancore
    inp = collections.OrderedDict((("a", "778899"), ("b", "300"), ("c", "25"), ("d", "1.5"), ("e", "16"), ("f", "1.5"), ("g", "5.0"), ("h", "10"), ("i", "20"), ("j", "15"), ("k", "14"), ("l", "2")))
    t, m = ancore(inp)
    ok(not m and len(t) == 12, "9 12 ancore trovate con i valori del demo")
    inp2 = collections.OrderedDict(inp)
    inp2["b"] = "250"
    t, m = ancore(inp2)
    ok(m == ["take profit pips"], "10 un default diverso (TP 250): ancora mancante riconosciuta")
    # v2: 1,5 e' DUE ancore (rischio e buffer): un solo input a 1,5 non basta (v1 le dava trovate tutte e due)
    inp3 = collections.OrderedDict(inp)
    inp3["d"] = "1.0"
    t, m = ancore(inp3)
    ok(m == ["buffer pips"] or m == ["rischio % equity"], "16 rischio 1,0 e buffer 1,5: UNA ancora 1,5 mancante (multinsieme)")
    # gemelli (v2: CINQUE trade del demo)
    D = dt.datetime

    def T(h, mi, lato, px):
        return {"t": D(2026, 10, 14, h, mi, 0), "lato": lato, "vol": 0.3, "px": px, "sl": None, "tp": None, "t1": None, "px1": None, "netto": None, "commento": ""}
    tr = [T(11, 5, "sell", 4140.5), T(12, 7, "sell", 4137.9), T(17, 5, "sell", 4074.0), T(18, 25, "buy", 4086.9), T(19, 15, "sell", 4091.2)]
    g = gemelli(tr)
    ok([bool(x[5]) for x in g] == [True, True, True, True, False], "11 gemelli: 4 si (stesso lato/ora/prezzo), HIGH 19:15 no (lato opposto)")
    tr[1]["px"] = 4139.5
    ok([bool(x[5]) for x in gemelli(tr)] == [True, False, True, True, False], "12 prezzo a 2,45 USD dal demo: niente gemello")
    tr[1]["px"] = 4137.9
    tr[1]["t"] = D(2026, 10, 14, 12, 20, 0)
    ok([bool(x[5]) for x in gemelli(tr)] == [True, False, True, True, False], "13 apertura 15 minuti dopo: niente gemello")
    # (D) orologio del tester
    ok(orologio([T(11, 5, "sell", 1), T(12, 5, "sell", 1), T(17, 5, "sell", 1)])[0] == "H1", "17 ore 11/12/17: H1 (le 12 server sono vietate sotto H2)")
    ok(orologio([T(10, 5, "sell", 1), T(11, 5, "sell", 1), T(17, 5, "sell", 1)])[0] == "H2", "18 ore 10/11/17: H2 (le 10 server sono vietate sotto H1)")
    ok(orologio([T(11, 5, "sell", 1), T(17, 5, "sell", 1), T(20, 5, "sell", 1)])[0] == "NON DECISA", "19 ore 11/17/20: nessuna ora discriminante (20 e' ambigua)")
    ok(orologio([T(10, 5, "sell", 1), T(12, 5, "sell", 1)])[0] == "ENTRAMBE/NESSUNA", "20 ore 10 e 12 insieme: nessuna delle due letture")
    ok(orologio([T(13, 5, "sell", 1)])[0] == "ENTRAMBE/NESSUNA", "21 ora 13 (esclusa da tutte e due): nessuna delle due letture")
    # (A)(B) senza conformita' nessun verdetto; con conformita' le soglie su 5
    import contextlib
    import io
    deals = []
    for i, (lato, vol, ts, px, _n) in enumerate(LIVE):
        deals.append({"t": dt.datetime.strptime(ts, "%Y.%m.%d %H:%M:%S"), "id": i, "sim": "XAUUSD", "tipo": lato, "dir": "in", "vol": vol, "prezzo": px, "ordine": None, "comm": 0.0, "swap": 0.0, "profitto": 0.0, "saldo": 0.0, "commento": ""})
    rep5 = {"simbolo": "XAUUSD", "periodo": "M5(2026.10.14-2026.10.15)", "qualita": "100%ticksreali", "deposito": 5000.0, "leva": "1:100", "expert": "The Impossible Gold",
            "esperti": ["The Impossible Gold"], "barre": 288.0, "ticks": 1.0, "trades": 5.0, "profitto": 0.0, "pf": 1.0, "dd_eq_abs": 0.0, "dd_eq_pct": 0.0, "deals": deals, "ordini": {}}

    def esce(rep_, comuni_):
        buf = io.StringIO()
        with contextlib.redirect_stdout(buf):
            stampa("x", rep_, inp, comuni_)
        return buf.getvalue()
    o = esce(rep5, [])
    ok("(A) VERIFICATA" in o and "-> REGGE" in o and "5 su 5" in o and "(D) OROLOGIO GMT DEL TESTER: H1" in o, "22 giro conforme, 5 gemelli: (A) verificata, (B) REGGE 5 su 5, (D) H1")
    o = esce(dict(rep5, periodo="M1(2026.09.28-2026.09.29)", expert="Arena Nexus", esperti=["Arena Nexus"]), [])
    ok("(A) NESSUN verdetto" in o and "VERIFICATA" not in o and "REGGE" not in o and "SMENTITA" not in o and "(D) OROLOGIO GMT DEL TESTER: NESSUN verdetto" in o,
       "23 giro NON conforme (zip dell'Arena): nessun verdetto su A, B, D (v1 stampava '(A) VERIFICATA: 111 operazioni')")
    o = esce(rep5, ["pin X NON fra quelli passati dal cancello"])
    ok("(A) NESSUN verdetto" in o and "REGGE" not in o, "24 provenienza non verificata: nessun verdetto")
    rep3 = dict(rep5, deals=deals[:3])
    o = esce(rep3, [])
    ok("3 su 5 -> NON DECISA" in o, "25 tre gemelli su cinque: NON DECISA")
    rep2 = dict(rep5, deals=deals[:2])
    ok("2 su 5 -> SMENTITA" in esce(rep2, []), "26 due gemelli su cinque: SMENTITA")
    # condizioni
    rep = {"simbolo": "XAUUSD", "periodo": "M5(2026.10.14-2026.10.15)", "qualita": "100%ticksreali", "deposito": 5000.0, "leva": "1:100", "expert": "The Impossible Gold", "esperti": ["The Impossible Gold"]}
    ok(not condizioni("x", rep), "14 report conforme: nessun motivo")
    r2 = dict(rep, periodo="M1(2026.10.14-2026.10.15)", leva="1:500", expert="Arena Nexus", esperti=["Arena Nexus"])
    ok(len(condizioni("x", r2)) == 3, "15 periodo M1, leva 1:500, altro EA: 3 motivi")
    # v2: i giornali di QUESTA sonda si leggono (log/TIG1_*.txt), quelli di un altro giro no (contro-esempio: log/SONDA1_ dell'Arena)
    with tempfile.TemporaryDirectory() as td:
        os.makedirs(os.path.join(td, "log"))
        riga = lambda s: "XX\t0\t10:00:00.000\tTester\t" + s
        with open(os.path.join(td, "log", "TIG1_01_logs_20261015.log.txt"), "wb") as fh:
            fh.write(("\r\n".join(["# giornale x", riga("XAUUSD,M5: testing of Experts\\Market\\The Impossible Gold.ex5 from 2026.10.14 00:00 to 2026.10.15 00:00 started with inputs:"),
                                  riga("  Magic=778899"), riga("  TakeProfit=300"), riga("The Impossible Gold (XAUUSD,M5) license check failed")]) + "\r\n").encode("ascii"))
        with open(os.path.join(td, "log", "SONDA1_01_logs_20261014.log.txt"), "wb") as fh:
            fh.write(riga("stop out occurred").encode("ascii"))
        per = leggi_giornali_tig(L.Sorgente(td))
        ok(list(per) == ["TIG1"] and per["TIG1"]["input"].get("Magic") == "778899" and per["TIG1"]["input"].get("TakeProfit") == "300"
           and any("license" in e for e in per["TIG1"]["errori"]) and not per["TIG1"]["stop_out"],
           "16m giornale log/TIG1_*.txt letto (input e errore di licenza); log/SONDA1_* di un altro giro NON contato")
        ok(not leggi_giornali_tig(L.Sorgente(os.path.join(td, "log"))), "17m un file TIG1_ fuori dalla cartella log/ non e' un estratto della riga")
    print("AUTOTEST: " + ("tutti i controlli OK" if not esito[0] else "ALMENO UN CONTROLLO CADUTO"))
    return esito[0]


def main():
    ap = argparse.ArgumentParser(description="lettore della sonda TIG nello Strategy Tester (sola lettura)")
    ap.add_argument("percorsi", nargs="*")
    ap.add_argument("--autotest", action="store_true")
    x = ap.parse_args()
    if x.autotest:
        return autotest()
    if not x.percorsi:
        ap.error("serve uno zip, una cartella o un report .htm (oppure --autotest)")
    return leggi_percorsi(x.percorsi)


if __name__ == "__main__":
    sys.exit(main())
