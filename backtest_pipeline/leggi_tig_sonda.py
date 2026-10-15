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
  B. GEMELLO: sul 14/10 il demo ha aperto TRE trade (LOW SELL 0,31 alle 11:05:00 a 4140,77; LOW SELL 0,30 alle 12:05:02 a 4137,05; HIGH BUY 0,36 alle
     19:15:00 a 4091,20; ora server BCM, [LETTO nel report del 15/10]). Un trade del tester e' il GEMELLO di uno del demo se ha lo STESSO lato, apre entro
     10 minuti e a meno di 1,0 USD di prezzo. REGGE se almeno 2 dei 3 hanno il gemello; SMENTITA se 0 o 1. (Si giudica SOLO se il giro e' CONFORME.)
  C. I VALORI USATI dal tester sono quelli della finestra del demo (screenshot del 15/10): 12 ancore numeriche (magic 778899, TP 300, SL 25, rischio 1,5,
     lookback 16, buffer 1,5, range minimo 5, sessione 10-20, esclusione 12-15, passo del TP 14, trailing 10/2). CONFORME se tutte le ancore compaiono fra
     i valori del report; altrimenti i default NON sono quelli del demo: il giro e' descrittivo e la sonda 2 deve imporre gli input coi NOMI qui stampati.
Giro CONFORME = simbolo XAUUSD, periodo M5(2026.10.14-2026.10.15), qualita' 100% ticks reali, deposito 5000, leva 1:100, un solo Expert 'Impossible',
provenienza (REFERTO_TIG_SONDA.txt: marcatore, pin passato dal cancello, data, .ex5 UGUALE). Le ancore (C) NON sono parte della conformita' del giro
ma della lettura di (B): senza di esse (B) e' descrittiva. ASCII puro.
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

PIN_PASSATI_TIG = ()      # da scrivere: il pin della riga passata dal cancello (fail-closed finche' e' vuota)
MARCATORE_ATTESO = "MARCATORE_TIG_TESTER_SONDA_v1"
DATA_MINIMA_REFERTO = "2026-10-15"
PERIODO_ATTESO = ("2026.10.14", ("2026.10.14", "2026.10.15"))
LEVA = "1:100"
DEPOSITO = 5000.0
LIVE = [("sell", 0.31, "2026.10.14 11:05:00", 4140.77, "LOW"), ("sell", 0.30, "2026.10.14 12:05:02", 4137.05, "LOW"),
        ("buy", 0.36, "2026.10.14 19:15:00", 4091.20, "HIGH")]
TOL_MIN = 10.0
TOL_PX = 1.0
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


def ancore(inp):
    """(trovate, mancanti): una ancora e' trovata se ALMENO un valore numerico del report e' uguale (|d| < 1e-9)."""
    vals = [num(v) for v in inp.values()]
    vals = [x for x in vals if x is not None]
    trov, manc = [], []
    for d, v in ANCORE:
        (trov if any(abs(x - v) < 1e-9 for x in vals) else manc).append(d)
    return trov, manc


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
    W("ANCORE (C): %d su %d trovate fra i valori del report." % (len(trov), len(ANCORE)))
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
    if rep["trades"] is not None and rep["trades"] >= 1:
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
    if conforme and ancore_ok:
        W("(B) GEMELLO: %d su 3 -> %s" % (n, "REGGE" if n >= 2 else "SMENTITA"))
    else:
        W("(B) GEMELLO: %d su 3 -> NESSUN verdetto (giro non conforme o ancore (C) mancanti): descrittivo." % n)
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
        L.stampa_giornali(L.leggi_giornali(src))
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
    # gemelli
    D = dt.datetime
    tr = [{"t": D(2026, 10, 14, 11, 5, 0), "lato": "sell", "vol": 0.3, "px": 4140.5, "sl": 4143.0, "tp": 4110.5, "t1": None, "px1": None, "netto": None, "commento": ""},
          {"t": D(2026, 10, 14, 12, 7, 0), "lato": "sell", "vol": 0.3, "px": 4137.9, "sl": None, "tp": None, "t1": None, "px1": None, "netto": None, "commento": ""},
          {"t": D(2026, 10, 14, 19, 15, 0), "lato": "sell", "vol": 0.36, "px": 4091.2, "sl": None, "tp": None, "t1": None, "px1": None, "netto": None, "commento": ""}]
    g = gemelli(tr)
    ok([bool(x[5]) for x in g] == [True, True, False], "11 gemelli: 2 si (stesso lato/ora/prezzo, 2 min e 0,85 USD), HIGH no (lato opposto)")
    tr[1]["px"] = 4139.5
    g = gemelli(tr)
    ok([bool(x[5]) for x in g] == [True, False, False], "12 prezzo a 2,45 USD dal demo: niente gemello")
    tr[1]["px"] = 4137.9
    tr[1]["t"] = D(2026, 10, 14, 12, 20, 0)
    ok([bool(x[5]) for x in gemelli(tr)] == [True, False, False], "13 apertura 15 minuti dopo: niente gemello")
    # condizioni
    rep = {"simbolo": "XAUUSD", "periodo": "M5(2026.10.14-2026.10.15)", "qualita": "100%ticksreali", "deposito": 5000.0, "leva": "1:100", "expert": "The Impossible Gold", "esperti": ["The Impossible Gold"]}
    ok(not condizioni("x", rep), "14 report conforme: nessun motivo")
    r2 = dict(rep, periodo="M1(2026.10.14-2026.10.15)", leva="1:500", expert="Arena Nexus", esperti=["Arena Nexus"])
    ok(len(condizioni("x", r2)) == 3, "15 periodo M1, leva 1:500, altro EA: 3 motivi")
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
