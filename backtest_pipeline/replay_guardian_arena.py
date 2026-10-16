# APPOGGIO (NON passato dal cancello come strumento): ricostruisce l'equita' MINUTO PER MINUTO di un report del tester Arena
# (deal + barre M1 dell'oro, ora server) e simula un Guardian che a -L EUR di equita' giornaliera chiude tutto e blocca la giornata.
# Uso: python3 replay_guardian_arena.py report.htm|zip barre_M1.csv [--limite 500] [--slip 0.0] [--dal 2026.09.01] [--al 2026.09.30] [--deposito 5000]
# Ipotesi dichiarate: k = 86.41 EUR per 1.0 USD di prezzo per lotto (misurato nei report); buy valutati a bid, sell ad ask = bid+spread;
# i deal XAUUSD si accoppiano in->out per volume e prezzo d'entrata INFERITO dal profitto; dopo lo stop del Guardian le posizioni chiuse
# e quelle aperte nel blocco sono "morte" (i loro deal successivi si ignorano); i giorni dopo ripartono dal baseline del tester.
import re, sys, zipfile, collections, argparse
from datetime import datetime

K = 86.41


def leggi_html(p):
    sub = ''
    if '::' in p:
        p, sub = p.split('::', 1)   # file.zip::TRANCHE2 sceglie il report il cui nome contiene TRANCHE2
    if p.lower().endswith('.zip'):
        z = zipfile.ZipFile(p)
        n = [x for x in z.namelist() if x.lower().endswith('.htm') and sub in x][0]
        b = z.read(n)
    else:
        b = open(p, 'rb').read()
    return b.decode('utf-16', 'replace') if b[:2] in (b'\xff\xfe', b'\xfe\xff') else b.decode('utf-8', 'replace')


def f(x):
    x = x.replace(' ', '').replace('\xa0', '')
    return float(x) if x not in ('', '-') else 0.0


def deals_xau(t):
    righe = re.findall(r'<tr[^>]*>(.*?)</tr>', t, re.S)
    D = []
    for r in righe:
        c = [re.sub(r'<[^>]+>', '', x).replace('&nbsp;', ' ').strip() for x in re.findall(r'<t[dh][^>]*>(.*?)</t[dh]>', r, re.S)]
        if len(c) >= 13 and re.match(r'\d{4}\.\d\d\.\d\d \d\d:\d\d:\d\d', c[0]) and c[2] == 'XAUUSD' and c[4] in ('in', 'out'):
            D.append(dict(t=c[0], tipo=c[3], dir=c[4], v=f(c[5]), p=f(c[6]), co=f(c[8]), sw=f(c[9]), pr=f(c[10]), bal=f(c[11]), cm=c[12]))
    D.sort(key=lambda d: d['t'])
    return D


def barre(p):
    B = []
    for l in open(p, encoding='utf-8', errors='replace').read().splitlines()[1:]:
        r = l.split('\t')
        if len(r) >= 9:
            B.append((r[0] + ' ' + r[1], float(r[2]), float(r[3]), float(r[4]), float(r[5]), int(r[8])))
    return B


def accoppia(D):
    """posizioni: dict(id, lato, v, e, t0, t1, out_idx). Ritorna (posizioni, mappa deal_idx->pos_id, non_accoppiati)."""
    aperte = collections.defaultdict(list)  # (lato) -> lista pos
    pos = []
    mappa = {}
    nonacc = 0
    for i, d in enumerate(D):
        if d['dir'] == 'in':
            lato = 'buy' if d['tipo'] == 'buy' else 'sell'
            mc = re.search(r'\[CID=(\d+)\]', d['cm'])
            P = dict(id=len(pos), lato=lato, v=d['v'], e=d['p'], t0=d['t'], t1=None, deal_in=i, deal_out=None, cid=(mc.group(1) if mc else None), tag=('R' if '[R]' in d['cm'] else ('F' if '[F]' in d['cm'] else '')))
            pos.append(P)
            aperte[lato].append(P)
            mappa[i] = P['id']
        else:
            lato = 'buy' if d['tipo'] == 'sell' else 'sell'   # un out 'sell' chiude un buy
            e_inf = d['p'] - d['pr'] / (d['v'] * K) if lato == 'buy' else d['p'] + d['pr'] / (d['v'] * K)
            cand = [x for x in aperte[lato] if abs(x['v'] - d['v']) < 1e-9]
            if not cand:
                nonacc += 1
                continue
            best = min(cand, key=lambda x: abs(x['e'] - e_inf))
            best['t1'] = d['t']
            best['deal_out'] = i
            aperte[lato].remove(best)
            mappa[i] = best['id']
    return pos, mappa, nonacc


def main():
    ap = argparse.ArgumentParser()
    ap.add_argument('report'); ap.add_argument('barre')
    ap.add_argument('--limite', type=float, default=500.0)
    ap.add_argument('--slip', type=float, default=0.0, help='USD di scivolamento per lotto alla chiusura forzata')
    ap.add_argument('--dal', default='0000.00.00'); ap.add_argument('--al', default='9999.99.99')
    ap.add_argument('--deposito', type=float, default=5000.0)
    ap.add_argument('--profitto', type=float, default=0.0, help='obiettivo giornaliero in EUR: a +P chiude tutto e blocca il giorno')
    ap.add_argument('--realizzato', action='store_true', help='con --profitto: il traguardo e il guadagno REALIZZATO del giorno (saldo), non l equita')
    ap.add_argument('--regola', default='', help='regola PER CESTO [R]: depth:N | bstop:X | tstop:H (ore); usare con --limite 0')
    ap.add_argument('--worst', action='store_true', help='valuta l equita con il peggiore fra low e high della barra')
    a = ap.parse_args()
    D = deals_xau(leggi_html(a.report))
    B = [b for b in barre(a.barre) if a.dal <= b[0][:10] <= a.al]
    pos, mappa, nonacc = accoppia(D)
    print('deal XAUUSD', len(D), 'posizioni', len(pos), 'out non accoppiati', nonacc)
    # indice degli eventi per minuto
    ev = collections.defaultdict(list)
    for i, d in enumerate(D):
        ev[d['t'][:16]].append(i)

    def flo(aperte, p, spr):
        s = 0.0
        for x in aperte:
            s += x['v'] * (p - x['e']) * K if x['lato'] == 'buy' else x['v'] * (x['e'] - (p + spr)) * K
        return s

    # ---------- mondo BASELINE (tester) e mondo GUARDIAN, in parallelo
    bal_b = a.deposito; open_b = []
    bal_g = a.deposito; open_g = []
    morte = set()           # id posizioni morte nel mondo guardian
    depth_g = collections.Counter(); first_g = {}; real_g = collections.defaultdict(float); tagliati = 0
    cid_morti = set()       # cicli [CID] chiusi a forza: i livelli successivi dello stesso ciclo non esistono piu'
    giorno = None; bloccato = False
    start_eq_g = None
    out = collections.OrderedDict()
    peak_b = bal_b; ddmax_b = 0.0; peak_g = bal_g; ddmax_g = 0.0
    primo = None
    # deal PRIMA della prima barra (es. giorni senza barre M1): stato iniziale uguale nei due mondi
    if B:
        for i, d in enumerate(D):
            if d['t'][:16] >= B[0][0][:16]:
                break
            pid = mappa.get(i)
            if d['dir'] == 'in':
                if pid is not None:
                    open_b.append(pos[pid]); open_g.append(pos[pid])
                    if pos[pid]['tag'] == 'R' and pos[pid]['cid']:
                        cc = pos[pid]['cid']; depth_g[cc] += 1; real_g[cc] += d['co']
                        if cc not in first_g: first_g[cc] = datetime.strptime(d['t'][:16], '%Y.%m.%d %H:%M')
                bal_b += d['co']; bal_g += d['co']
            else:
                if pid is not None and pos[pid] in open_b:
                    open_b.remove(pos[pid])
                    if pos[pid] in open_g: open_g.remove(pos[pid])
                    if pos[pid]['tag'] == 'R' and pos[pid]['cid']: real_g[pos[pid]['cid']] += d['pr'] + d['co'] + d['sw']
                bal_b += d['pr'] + d['co'] + d['sw']; bal_g += d['pr'] + d['co'] + d['sw']
    for (tm, o, h, l, c, sp) in B:
        g = tm[:10]
        spr = sp * 0.01
        if giorno != g:
            if giorno is not None:
                pass
            giorno = g; bloccato = False
            bal_inizio_g = bal_g
            eq_start = bal_g + flo(open_g, o, spr)
            start_eq_g = eq_start
            out[g] = dict(stop=None, loss_stop=None, base_start=bal_b + flo(open_b, o, spr), g_start=eq_start, n_ev=0)
        # eventi del minuto (deal con timestamp in questo minuto)
        for i in ev.get(tm[:16], []):
            d = D[i]
            pid = mappa.get(i)
            # baseline
            if d['dir'] == 'in':
                open_b.append(pos[pid]) if pid is not None else None
            else:
                if pid is not None and pos[pid] in open_b:
                    open_b.remove(pos[pid])
            bal_b += d['pr'] + d['co'] + d['sw'] if d['dir'] == 'out' else d['co']
            # guardian
            if bloccato:
                if pid is not None:
                    morte.add(pid)
                    if pos[pid]['cid']: cid_morti.add(pos[pid]['cid'])
                continue
            if pid is not None and d['dir'] == 'in' and pos[pid]['cid'] and pos[pid]['cid'] in cid_morti:
                morte.add(pid)
            if pid is not None and pid in morte:
                continue
            if d['dir'] == 'in':
                open_g.append(pos[pid]) if pid is not None else None
                if pid is not None and pos[pid]['tag'] == 'R' and pos[pid]['cid']:
                    cc = pos[pid]['cid']; depth_g[cc] += 1
                    if cc not in first_g: first_g[cc] = datetime.strptime(tm[:16], '%Y.%m.%d %H:%M')
                    real_g[cc] += d['co']
            else:
                if pid is not None and pos[pid] in open_g:
                    open_g.remove(pos[pid])
                    bal_g += d['pr'] + d['co'] + d['sw']
                    if pos[pid]['tag'] == 'R' and pos[pid]['cid']: real_g[pos[pid]['cid']] += d['pr'] + d['co'] + d['sw']
                else:
                    pass
            if d['dir'] == 'in':
                bal_g += d['co']
        # regola per CESTO [R] (dopo gli eventi del minuto)
        if a.regola and not bloccato:
            kind, val = a.regola.split(':'); val = float(val)
            por = collections.defaultdict(list)
            for x in open_g:
                if x['tag'] == 'R' and x['cid']:
                    por[x['cid']].append(x)
            ora_t = datetime.strptime(tm[:16], '%Y.%m.%d %H:%M')
            for cc, lst in list(por.items()):
                prezzo = c
                fl = flo(lst, prezzo, spr)
                if a.worst:
                    fl = min(fl, flo(lst, l, spr), flo(lst, h, spr))
                scatta = False
                if kind == 'depth':
                    scatta = depth_g[cc] >= val
                elif kind == 'bstop':
                    scatta = (real_g[cc] + fl) <= -val
                elif kind == 'tstop':
                    scatta = (ora_t - first_g[cc]).total_seconds() >= val * 3600
                if scatta:
                    lotti = sum(x['v'] for x in lst)
                    bal_g += flo(lst, c, spr) - a.slip * lotti * K
                    for x in lst:
                        open_g.remove(x); morte.add(x['id'])
                    cid_morti.add(cc); tagliati += 1
        # equita a fine minuto
        def eq(world_bal, world_open, p):
            return world_bal + flo(world_open, p, spr)
        p_eval = c
        eq_b = eq(bal_b, open_b, c)
        if a.worst:
            eq_b = min(eq_b, eq(bal_b, open_b, l), eq(bal_b, open_b, h))
        peak_b = max(peak_b, eq_b); ddmax_b = max(ddmax_b, peak_b - eq_b)
        if not bloccato:
            eq_g = eq(bal_g, open_g, c)
            if a.worst:
                eq_g = min(eq_g, eq(bal_g, open_g, l), eq(bal_g, open_g, h))
            peak_g = max(peak_g, eq_g); ddmax_g = max(ddmax_g, peak_g - eq_g)
            if ((a.limite > 0 and start_eq_g - eq_g >= a.limite) or (a.profitto > 0 and ((bal_g - bal_inizio_g >= a.profitto) if a.realizzato else (eq_g - start_eq_g >= a.profitto)))) and out[g]['stop'] is None:
                # chiusura forzata di tutto a prezzo c (peggiorato dallo slippage)
                lotti = sum(x['v'] for x in open_g)
                real = flo(open_g, c, spr) - a.slip * lotti * K
                for x in open_g:
                    morte.add(x['id'])
                    if x['cid']: cid_morti.add(x['cid'])
                bal_g += real
                open_g = []
                bloccato = True
                out[g]['stop'] = tm[11:]
                out[g]['loss_stop'] = start_eq_g - bal_g
        out[g]['eq_b_fine'] = eq_b
        out[g]['bal_b'] = bal_b
        out[g]['bal_g'] = bal_g
        out[g]['eq_g_fine'] = bal_g + flo(open_g, c, spr)
    # ---------- stampa
    print('\nlimite -%.0f EUR, slip %.2f USD/lotto, valutazione %s' % (a.limite, a.slip, 'PEGGIORE(low/high)' if a.worst else 'CHIUSURA minuto'))
    print('%-11s %10s %10s %9s %-9s %10s' % ('giorno', 'bal_tester', 'bal_guard', 'delta g-b', 'stop alle', 'perd.stop'))
    prev_b = a.deposito; prev_g = a.deposito
    for g, r in out.items():
        print('%-11s %10.2f %10.2f %9.2f %-9s %10s' % (g, r['bal_b'], r['bal_g'], r['bal_g'] - r['bal_b'], r['stop'] or '-', ('%.0f' % r['loss_stop']) if r['loss_stop'] is not None else '-'))
    ult = list(out.values())[-1]
    nstop = sum(1 for r in out.values() if r['stop'])
    print('\nFINE: saldo tester %.2f | saldo con Guardian %.2f | differenza %+.2f | giorni fermati %d su %d' % (ult['bal_b'], ult['bal_g'], ult['bal_g'] - ult['bal_b'], nstop, len(out)))
    print('DD massimo di equita (picco->minimo): tester %.2f | con Guardian %.2f' % (ddmax_b, ddmax_g))
    if a.regola: print('cesti chiusi a forza dalla regola %s: %d' % (a.regola, tagliati))


if __name__ == '__main__':
    main()
