"""Parser INDIPENDENTE (controllo-preventivo) dei deal R1A: non importa niente dal lettore ne' dallo script sotto esame.
Deal: html.parser (non regex), riga = 13 celle, la prima e' 'AAAA.MM.GG hh:mm:ss'.
Posizione: ricostruita per ORDINE DI DEAL con un registro per lato (non 'in seguito da out'): l'out chiude la posizione aperta piu' vecchia (FIFO).
Netto = profitto+swap+commissione di in e out; se la passata intera ha commissione 0 -> -3,90 x lotti.
Notte = data server del deal d'ingresso con ora 0..6; netto di notte = somma netti delle posizioni ENTRATE quella notte."""
import sys, zipfile, datetime, collections
from html.parser import HTMLParser


class Righe(HTMLParser):
    def __init__(self):
        super().__init__()
        self.righe, self.cur, self.cell, self.intd = [], None, [], False

    def handle_starttag(self, tag, a):
        if tag == "tr":
            self.cur = []
        elif tag == "td" and self.cur is not None:
            self.intd, self.cell = True, []

    def handle_endtag(self, tag):
        if tag == "td" and self.cur is not None and self.intd:
            self.cur.append("".join(self.cell).replace("\xa0", " ").strip())
            self.intd = False
        elif tag == "tr" and self.cur is not None:
            self.righe.append(self.cur)
            self.cur = None

    def handle_data(self, d):
        if self.intd:
            self.cell.append(d)


def num(s):
    s = s.replace(" ", "").replace("\xa0", "")
    return float(s) if s else 0.0


def deals_da_htm(raw):
    t = raw.decode("utf-16")
    p = Righe()
    p.feed(t)
    out = []
    for c in p.righe:
        if len(c) != 13:
            continue
        try:
            ts = datetime.datetime.strptime(c[0], "%Y.%m.%d %H:%M:%S")
        except ValueError:
            continue
        if c[3] not in ("buy", "sell"):
            continue
        out.append(dict(t=ts, id=int(c[1]), tipo=c[3], dir=c[4], vol=num(c[5]), comm=num(c[8]), swap=num(c[9]), prof=num(c[10])))
    return out


def posizioni(deals, fascia_ore=(0, 7)):
    comm_tot = sum(d["comm"] for d in deals)
    aperte = collections.deque()
    pos = []
    for d in deals:
        if d["dir"] == "in":
            aperte.append(d)
        elif d["dir"] in ("out", "out by", "in/out"):
            a = aperte.popleft()
            net = a["prof"] + a["swap"] + a["comm"] + d["prof"] + d["swap"] + d["comm"]
            if comm_tot == 0:
                net -= 3.90 * (a["vol"] or 1.0)
            pos.append(dict(tin=a["t"], tout=d["t"], net=net))
    return pos, len(aperte)


def pf(v):
    gp = sum(x for x in v if x > 0)
    gl = -sum(x for x in v if x < 0)
    return gp / gl if gl > 0 else float("inf")


if __name__ == "__main__":
    z = zipfile.ZipFile(sys.argv[1])
    tot_n, tot_v, tot_notti, tot_neg = 0, [], 0, 0
    oltre7 = 0
    notti_all = {}
    for n in sorted(z.namelist()):
        if not (n.startswith("report") and n.endswith("m775800.htm")):
            continue
        tr = n.split("_")[-2]
        dl = deals_da_htm(z.read(n))
        ps, rest = posizioni(dl)
        notte = [p for p in ps if 0 <= p["tin"].hour < 7]
        oltre7 += sum(1 for p in notte if p["tout"].hour >= 7 or p["tout"].date() != p["tin"].date())
        per = collections.OrderedDict()
        for p in notte:
            per.setdefault(p["tin"].date(), 0.0)
            per[p["tin"].date()] += p["net"]
        neg = sum(1 for v in per.values() if v < 0)
        v = [p["net"] for p in notte]
        print("%s deal %d pos %d aperte_a_fine %d | notte: n %d PF_V %.4f netto %.2f notti %d negative %d" % (tr, len(dl), len(ps), rest, len(notte), pf(v), sum(v), len(per), neg))
        tot_n += len(notte)
        tot_v += v
        tot_notti += len(per)
        tot_neg += neg
        notti_all[tr] = per
    print("TOT n %d PF_V %.4f netto %.2f notti %d negative %d q %.4f | uscite dopo le 07:00 (o altro giorno) %d" % (tot_n, pf(tot_v), sum(tot_v), tot_notti, tot_neg, tot_neg / tot_notti, oltre7))
    # concentrazione per notte e finestre 7 (mie)
    tutte = [v for tr in notti_all for v in notti_all[tr].values()]
    s = sorted(tutte, reverse=True)
    print("netto senza le 3 migliori notti %.2f, senza le 5 %.2f" % (sum(tutte) - sum(s[:3]), sum(tutte) - sum(s[:5])))
    nf = nc = 0
    for tr in notti_all:
        vs = list(notti_all[tr].values())
        for i in range(len(vs) - 6):
            nf += 1
            nc += all(x >= 0 for x in vs[i:i + 7])
    q = tot_neg / tot_notti
    print("finestre 7: %d su %d pulite; nullo (1-q)^7 = %.4f" % (nc, nf, (1 - q) ** 7))
