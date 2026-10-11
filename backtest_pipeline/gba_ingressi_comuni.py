# gba_ingressi_comuni.py (11/10/2026) -- strumento di analisi, NON passato dal cancello (controllo-preventivo).
# Bozza, NON passata dal cancello.
#
# Scopo: separare l'EFFETTO D'USCITA dall'EFFETTO DI SELEZIONE fra due celle dello stesso motore
# (S9 del piano GBA R2). Una cella d'uscita cambia anche QUALI ingressi avvengono (una posizione per
# volta: se la posizione dura di piu' o di meno, i segnali successivi trovano o non trovano il posto
# libero). Quindi il PF di cella mescola due cose. Qui si confronta:
#   - COMUNI   : ingressi presenti in entrambe le celle -> stessa entrata, uscita diversa = effetto d'uscita
#   - SOLO-A   : ingressi che ci sono solo nella cella A (REMOVED passando ad B)
#   - SOLO-B   : ingressi che ci sono solo nella cella B (ADDED passando ad B)
# Ingresso = (tranche, data-ora server del deal d'ingresso, lato del deal d'ingresso).
#
# Parser scritto da zero (indipendente da leggi_gba_r0.py e da scratchpad/s7/overlap.py):
#   - html.parser sui report .htm del tester (UTF-16); riga deal = 13 celle, la prima 'AAAA.MM.GG hh:mm:ss',
#     tipo buy/sell, direzione in/out/out by/in/out;
#   - posizioni FIFO PER LATO: un deal 'out' di tipo sell chiude la buy aperta piu' vecchia, un 'out' buy
#     chiude la sell aperta piu' vecchia; volumi parziali -> errore esplicito (non gestiti, non attesi);
#   - netto PF_V = profitto+swap+commissione di in e out; se la commissione TOTALE della passata (file) e'
#     zero, si tolgono 3,90 per lotto (volume dell'in).
# Bootstrap per GIORNO (giorno server del deal d'ingresso), 5.000 repliche, seed fisso 12345, sul delta
# PF_V(B) - PF_V(A) calcolato sugli ingressi COMUNI (stessi giorni ricampionati per le due celle).
#
# Uso:
#   python3 -I backtest_pipeline/gba_ingressi_comuni.py --autotest
#   python3 -I backtest_pipeline/gba_ingressi_comuni.py <ancora_R1A.zip> <lotto1.zip> [<lotto2.zip> ...]
# Il primo zip e' l'ancora: le sue celle magic 775800 si chiamano col loro nome (REPL). Una cella con magic
# diverso da 775800 si chiama CELLA@LOTTO (es. REPL@R2UBE = la gemella G1 col magic 775850).
import sys, zipfile, datetime, collections, random
from html.parser import HTMLParser

COSTO_LOTTO = 3.90
MAGIC_BASE = "775800"
SEED = 12345
NBOOT = 5000


class _Righe(HTMLParser):
    def __init__(self):
        super().__init__()
        self.righe, self._r, self._c, self._in = [], None, [], False

    def handle_starttag(self, tag, attrs):
        if tag == "tr":
            self._r = []
        elif tag == "td" and self._r is not None:
            self._in, self._c = True, []

    def handle_endtag(self, tag):
        if tag == "td" and self._r is not None and self._in:
            self._r.append("".join(self._c).replace("\xa0", " ").strip())
            self._in = False
        elif tag == "tr" and self._r is not None:
            self.righe.append(self._r)
            self._r = None

    def handle_data(self, data):
        if self._in:
            self._c.append(data)


def _f(s):
    s = s.replace(" ", "").replace("\xa0", "")
    return float(s) if s else 0.0


def righe_html(testo):
    p = _Righe()
    p.feed(testo)
    return p.righe


def leggi_sl_ordini(righe):
    """Tabella Ordini (11 celle): ordine -> S/L dichiarato all'invio (vuoto -> None)."""
    sl = {}
    for c in righe:
        if len(c) != 11 or c[3] not in ("buy", "sell") or not c[1].isdigit():
            continue
        try:
            datetime.datetime.strptime(c[0], "%Y.%m.%d %H:%M:%S")
        except ValueError:
            continue
        sl[int(c[1])] = _f(c[6]) if c[6] else None
    return sl


def leggi_deal(testo, righe=None):
    deal = []
    for c in (righe if righe is not None else righe_html(testo)):
        if len(c) != 13 or c[3] not in ("buy", "sell"):
            continue
        try:
            t = datetime.datetime.strptime(c[0], "%Y.%m.%d %H:%M:%S")
        except ValueError:
            continue
        deal.append(dict(t=t, id=int(c[1]), tipo=c[3], dir=c[4], vol=_f(c[5]), prezzo=_f(c[6]), comm=_f(c[8]), swap=_f(c[9]), prof=_f(c[10]), cmt=c[12], ordine=int(c[7]) if c[7].isdigit() else None))
    return deal


def posizioni(deal):
    """FIFO per lato. Ritorna (lista posizioni, aperte_a_fine, costo_imputato)."""
    comm_tot = sum(d["comm"] for d in deal)
    imputa = (comm_tot == 0)
    aperte = {"buy": collections.deque(), "sell": collections.deque()}
    out = []
    for d in deal:
        if d["dir"] == "in":
            aperte[d["tipo"]].append(d)
        elif d["dir"] in ("out", "out by"):
            lato = "buy" if d["tipo"] == "sell" else "sell"
            if not aperte[lato]:
                raise ValueError("out senza in aperto sul lato %s (deal %d)" % (lato, d["id"]))
            a = aperte[lato].popleft()
            if abs(a["vol"] - d["vol"]) > 1e-9:
                raise ValueError("volume parziale non gestito (in %d vol %g, out %d vol %g)" % (a["id"], a["vol"], d["id"], d["vol"]))
            net = a["prof"] + a["swap"] + a["comm"] + d["prof"] + d["swap"] + d["comm"]
            if imputa:
                net -= COSTO_LOTTO * (a["vol"] or 1.0)
            out.append(dict(tin=a["t"], lato=lato, tout=d["t"], net=net, vol=a["vol"], pin=a.get("prezzo"), pout=d.get("prezzo"), cmt_out=d.get("cmt", ""), ordine_in=a.get("ordine")))
        else:
            raise ValueError("direzione non gestita: %r (deal %d)" % (d["dir"], d["id"]))
    return out, sum(len(v) for v in aperte.values()), imputa


def pf(v):
    gp = sum(x for x in v if x > 0)
    gl = -sum(x for x in v if x < 0)
    if gl == 0:
        return float("inf") if gp > 0 else float("nan")
    return gp / gl


def carica(zips):
    """cella -> {(tranche, tin, lato): posizione}"""
    celle = collections.OrderedDict()
    info = []
    for zp in zips:
        z = zipfile.ZipFile(zp)
        for nome in sorted(z.namelist()):
            nn = nome.replace("\\", "/")
            if not (nn.startswith("report/") and nn.endswith(".htm")):
                continue
            base = nn.split("/")[-1][:-4]
            parti = base.split("_")
            magic = parti[-1].lstrip("m")
            tranche = parti[-2]
            cella = parti[-3]
            lotto = parti[2]
            if magic != MAGIC_BASE:
                cella = "%s@%s" % (cella, lotto)
            rr = righe_html(z.read(nome).decode("utf-16"))
            deal = leggi_deal(None, rr)
            slo = leggi_sl_ordini(rr)
            ps, rest, imputa = posizioni(deal)
            for p in ps:
                p["sl0"] = slo.get(p["ordine_in"], "assente")
            d = celle.setdefault(cella, {})
            dup = 0
            for p in ps:
                k = (tranche, p["tin"], p["lato"])
                if k in d:
                    dup += 1
                d[k] = dict(p, tranche=tranche)
            info.append((cella, tranche, len(deal), len(ps), rest, imputa, dup))
    return celle, info


def riassunto(pos):
    v = [p["net"] for p in pos]
    n = len(v)
    return n, pf(v), (sum(v) / n if n else float("nan")), sum(v)


def scomponi(A, B):
    kA, kB = set(A), set(B)
    com = kA & kB
    return com, kA - kB, kB - kA


def boot_delta(A, B, com, seed=SEED, nb=NBOOT, appaiato=True):
    """delta PF_V(B) - PF_V(A) sugli ingressi comuni, bootstrap per giorno (giorno del deal d'ingresso)."""
    per = collections.OrderedDict()
    for k in sorted(com):
        g = k[1].date()
        per.setdefault(g, ([], []))
        per[g][0].append(A[k]["net"])
        per[g][1].append(B[k]["net"])
    giorni = list(per)

    def stat(gs, gs_b=None):
        va, vb = [], []
        for g in gs:
            va += per[g][0]
        for g in (gs if gs_b is None else gs_b):
            vb += per[g][1]
        return pf(vb) - pf(va)

    oss = stat(giorni)
    rng = random.Random(seed)
    rs = []
    for _ in range(nb):
        ga = [giorni[rng.randrange(len(giorni))] for _ in giorni]
        if appaiato:
            rs.append(stat(ga))
        else:
            rs.append(stat(ga, [giorni[rng.randrange(len(giorni))] for _ in giorni]))
    rs.sort()
    m = sum(rs) / nb
    sd = (sum((x - m) ** 2 for x in rs) / (nb - 1)) ** 0.5
    return dict(oss=oss, giorni=len(giorni), sd=sd, p025=rs[int(0.025 * nb)], p975=rs[int(0.975 * nb) - 1],
                p_le0=sum(1 for x in rs if x <= 0) / nb)


def _r(sel, D):
    return riassunto([D[k] for k in sorted(sel)])


def fmt(n, p, m, s):
    return "n %4d PF_V %.4f medio %8.2f netto %10.2f" % (n, p, m, s)


def confronta(nA, nB, A, B, tranche_list, out=print):
    com, sA, sB = scomponi(A, B)
    out("=== %s -> %s" % (nA, nB))
    out("  coerenza: comuni %d + solo-%s %d = %d (n %s %d) | comuni %d + solo-%s %d = %d (n %s %d)" % (
        len(com), nA, len(sA), len(com) + len(sA), nA, len(A), len(com), nB, len(sB), len(com) + len(sB), nB, len(B)))
    assert len(com) + len(sA) == len(A) and len(com) + len(sB) == len(B)
    for tr in ["TOT"] + tranche_list:
        f = (lambda k: True) if tr == "TOT" else (lambda k, tr=tr: k[0] == tr)
        c = [k for k in com if f(k)]
        a = [k for k in sA if f(k)]
        b = [k for k in sB if f(k)]
        out("  [%s] cella %s: %s" % (tr, nA, fmt(*_r([k for k in A if f(k)], A))))
        out("  [%s] cella %s: %s" % (tr, nB, fmt(*_r([k for k in B if f(k)], B))))
        out("  [%s] comuni con uscita %s: %s" % (tr, nA, fmt(*_r(c, A))))
        out("  [%s] comuni con uscita %s: %s" % (tr, nB, fmt(*_r(c, B))))
        out("  [%s] solo-%s (REMOVED): %s" % (tr, nA, fmt(*_r(a, A))))
        out("  [%s] solo-%s (ADDED)  : %s" % (tr, nB, fmt(*_r(b, B))))
        # scomposizione ADDITIVA del netto: netto(B)-netto(A) = uscita(comuni) + ADDED - REMOVED
        dc = sum(B[k]["net"] for k in c) - sum(A[k]["net"] for k in c)
        ad = sum(B[k]["net"] for k in b)
        rm = sum(A[k]["net"] for k in a)
        out("  [%s] d_netto = uscita sui comuni %+.2f + ADDED %+.2f - REMOVED %+.2f = %+.2f" % (tr, dc, ad, rm, dc + ad - rm))
    # (5) ordine: le posizioni comuni hanno la stessa uscita?
    same_t = sum(1 for k in com if A[k]["tout"] == B[k]["tout"])
    same_tn = sum(1 for k in com if A[k]["tout"] == B[k]["tout"] and abs(A[k]["net"] - B[k]["net"]) < 0.005)
    out("  ordine: comuni %d, stessa ora d'uscita %d, stessa ora E stesso netto %d, uscita diversa %d" % (
        len(com), same_t, same_tn, len(com) - same_t))
    # la chiave identifica lo stesso ingresso? prezzo e volume dell'in devono coincidere sui comuni
    dpz = sum(1 for k in com if abs(A[k]["pin"] - B[k]["pin"]) > 1e-9 or abs(A[k]["vol"] - B[k]["vol"]) > 1e-9)
    out("  chiave: comuni con prezzo o volume d'ingresso DIVERSO: %d" % dpz)
    dsl = sum(1 for k in com if A[k].get("sl0") != B[k].get("sl0"))
    nsl = sum(1 for k in com if A[k].get("sl0") in (None, "assente"))
    out("  chiave: comuni con S/L iniziale (tabella Ordini) DIVERSO: %d; senza S/L leggibile in %s: %d" % (dsl, nA, nsl))
    # sui comuni con la STESSA uscita il netto deve coincidere (delta 0): se no, il parser o la chiave sbagliano
    ug = [k for k in com if A[k]["tout"] == B[k]["tout"]]
    out("  comuni con stessa ora d'uscita: somma |netto B - netto A| = %.2f (n %d)" % (sum(abs(B[k]["net"] - A[k]["net"]) for k in ug), len(ug)))
    dv = [k for k in com if A[k]["tout"] != B[k]["tout"]]
    mot = lambda c: "sl" if c.lower().startswith("sl") else ("tp" if c.lower().startswith("tp") else (c or "a mercato(commento vuoto)"))
    out("  uscite diverse, motivo in %s: %s | in %s: %s" % (
        nA, dict(collections.Counter(mot(A[k]["cmt_out"]) for k in dv)), nB, dict(collections.Counter(mot(B[k]["cmt_out"]) for k in dv))))
    out("  uscite diverse: %s %s | %s %s" % (nA, fmt(*_r(dv, A)), nB, fmt(*_r(dv, B))))
    return com, sA, sB


def autotest():
    def riga(t, i, tipo, dr, vol, comm, prof):
        return ("<tr><td>%s</td><td>%d</td><td>XAUUSD</td><td>%s</td><td>%s</td><td>%s</td><td>1.0</td><td>%d</td>"
                "<td>%s</td><td>0.00</td><td>%s</td><td>1 000 000.00</td><td></td></tr>") % (t, i, tipo, dr, vol, i, comm, prof)
    # buy e sell sovrapposti: FIFO per lato deve appaiare buy1/out-sell e sell1/out-buy, non per ordine globale
    html = "<table>" + "".join([
        riga("2026.01.02 10:00:00", 2, "buy", "in", "1", "-1.76", "0.00"),
        riga("2026.01.02 10:01:00", 3, "sell", "in", "1", "-1.76", "0.00"),
        riga("2026.01.02 10:02:00", 4, "buy", "out", "1", "-1.76", "-50.00"),   # chiude la SELL
        riga("2026.01.02 10:03:00", 5, "sell", "out", "1", "-1.76", "1 200.00"),  # chiude la BUY (spazio migliaia)
        riga("2026.01.02 10:04:00", 6, "buy", "in", "2", "-3.52", "0.00"),       # resta aperta
        "<tr><td>non una data</td></tr>",
    ]) + "</table>"
    d = leggi_deal(html)
    assert len(d) == 5, d
    ps, rest, imputa = posizioni(d)
    assert rest == 1 and not imputa and len(ps) == 2
    s = [p for p in ps if p["lato"] == "sell"][0]
    b = [p for p in ps if p["lato"] == "buy"][0]
    assert s["tin"].minute == 1 and s["tout"].minute == 2 and abs(s["net"] - (-53.52)) < 1e-9, s
    assert b["tin"].minute == 0 and b["tout"].minute == 3 and abs(b["net"] - 1196.48) < 1e-9, b
    # commissione zero -> 3,90 per lotto
    d0 = [dict(x, comm=0.0) for x in d[:4]]
    ps0, _, imp0 = posizioni(d0)
    assert imp0 and abs([p for p in ps0 if p["lato"] == "buy"][0]["net"] - (1200 - 3.90)) < 1e-9
    # pf
    assert abs(pf([3, -1, -2]) - 1.0) < 1e-12
    # scomposizione: controesempio dichiarato (A e B identici -> tutto comune, delta 0)
    A = {("T1", p["tin"], p["lato"]): p for p in ps}
    com, sA, sB = scomponi(A, dict(A))
    assert len(com) == 2 and not sA and not sB
    # B con un ingresso in piu' e uno in meno
    B = dict(A)
    k0 = sorted(B)[0]
    del B[k0]
    kx = ("T1", datetime.datetime(2026, 1, 3, 9, 0), "buy")
    B[kx] = dict(tin=kx[1], lato="buy", tout=kx[1], net=5.0, vol=1.0, pin=1.0, pout=1.0, cmt_out="")
    com, sA, sB = scomponi(A, B)
    assert len(com) == 1 and sA == {k0} and sB == {kx}
    righe = []
    confronta("A", "B", A, B, ["T1"], out=righe.append)
    assert any("comuni 1 + solo-A 1 = 2" in r for r in righe), righe
    # identita': A contro se stesso -> nessuna uscita diversa, somma |delta| 0, bootstrap delta 0
    righe = []
    confronta("A", "A2", A, dict(A), ["T1"], out=righe.append)
    assert any("uscita diversa 0" in r for r in righe) and any("= 0.00 (n 2)" in r for r in righe), righe
    r = boot_delta(A, dict(A), set(A), nb=50)
    assert r["oss"] == 0 and r["sd"] == 0
    # volume parziale -> errore esplicito
    try:
        posizioni([d[0], dict(d[3], vol=0.5)])
        raise AssertionError("volume parziale non segnalato")
    except ValueError:
        pass
    print("AUTOTEST OK (parser 13 celle, FIFO per lato, costo 3,90 a commissione zero, pf, scomposizione, volume parziale)")


def main(argv):
    if argv and argv[0] == "--autotest":
        autotest()
        return
    celle, info = carica(argv)
    print("--- passate lette (cella, tranche, deal, posizioni, aperte a fine, costo imputato, chiavi duplicate)")
    for r in info:
        print("  %-12s %s deal %4d pos %4d aperte %d imputato %s dup %d" % r)
    print("--- totali per cella (da confrontare con la lettura)")
    for c, D in celle.items():
        print("  %-12s %s" % (c, fmt(*riassunto(list(D.values())))))
    trl = ["T1", "T2", "T3"]
    print()
    confronta("K15", "KOFF", celle["K15"], celle["KOFF"], trl)
    print()
    for c in ["BEOFF", "BE05", "BE15", "ATRFIX", "TOFF", "K15", "K35", "KOFF"]:
        confronta("REPL", c, celle["REPL"], celle[c], trl)
        print()
    if "REPL@R2UBE" in celle:
        T1 = {k: v for k, v in celle["REPL"].items() if k[0] == "T1"}
        confronta("REPL(T1)", "REPL@R2UBE", T1, celle["REPL@R2UBE"], ["T1"])
        print()
    print("--- bootstrap per giorno (5.000, seed %d) del delta PF_V sugli ingressi COMUNI" % SEED)
    coppie = [("K15", "KOFF"), ("REPL", "K35")] + [("REPL", c) for c in ["BEOFF", "BE05", "BE15", "ATRFIX", "TOFF", "K15", "KOFF"]]
    for a, b in coppie:
        com, _, _ = scomponi(celle[a], celle[b])
        r = boot_delta(celle[a], celle[b], com)
        print("  %-5s -> %-6s comuni %4d giorni %3d delta %+.4f sd %.4f [p2,5 %+.4f ; p97,5 %+.4f] P(delta<=0) %.3f" % (
            a, b, len(com), r["giorni"], r["oss"], r["sd"], r["p025"], r["p975"], r["p_le0"]))
    print("--- stesso bootstrap, ma con le DUE celle ricampionate su giorni INDIPENDENTI (non appaiato, per confronto)")
    for a, b in coppie[:2]:
        com, _, _ = scomponi(celle[a], celle[b])
        r = boot_delta(celle[a], celle[b], com, appaiato=False)
        print("  %-5s -> %-6s comuni %4d giorni %3d delta %+.4f sd %.4f [p2,5 %+.4f ; p97,5 %+.4f] P(delta<=0) %.3f" % (
            a, b, len(com), r["giorni"], r["oss"], r["sd"], r["p025"], r["p975"], r["p_le0"]))


if __name__ == "__main__":
    main(sys.argv[1:])
