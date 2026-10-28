import sys, glob, os, re, gzip, collections
sys.path.insert(0, os.path.dirname(os.path.abspath(__file__)))
import leggi_deep80k_nuovi as B
def deals(path):
    R = B.righe(B.leggi(path)); ii = [k for k, r in enumerate(R) if r and r[0] in ('Affari', 'Deals')]
    out = []
    for r in R[ii[0] + 2:]:
        if len(r) >= 12 and re.match(r'\d{4}\.\d\d\.\d\d', r[0]) and r[2] != '' and r[3] != 'balance':
            out.append(dict(t=r[0], sym=r[2], tipo=r[3].lower(), dir=r[4].lower(), vol=B.num(r[5]), net=B.num(r[8]) + B.num(r[9]) + B.num(r[10])))
    return out
base = sys.argv[1]
for d in sorted(glob.glob(base + '/20*_M1_DTP_*')):
    c = glob.glob(d + '/ANNO80K_DAYTRADEPROALGOMT5/report/*.htm') + glob.glob(d + '/report/*.htm') + glob.glob(d + '/report/*.htm.gz')
    h = c[0]
    if h.endswith('.gz'):
        import tempfile
        tf = tempfile.NamedTemporaryFile(delete=False, suffix='.htm'); tf.write(gzip.open(h, 'rb').read()); tf.close(); h = tf.name
    D = deals(h); name = os.path.basename(d)
    outs = [x for x in D if x['dir'] == 'out']
    w = [x['net'] for x in outs if x['net'] > 0]; l = [x['net'] for x in outs if x['net'] < 0]
    sy = collections.Counter(x['sym'] for x in D if x['dir'] == 'in')
    # posizioni aperte insieme (in +1, out -1 per deal)
    ev = sorted(D, key=lambda x: x['t']); c = 0; mx = 0
    for x in ev:
        c += 1 if x['dir'] == 'in' else -1 if x['dir'] == 'out' else 0; mx = max(mx, c)
    pay = (sum(w) / len(w)) / (-sum(l) / len(l)) if w and l else 0
    print(name, 'simboli', len(sy), 'win%% %.0f' % (100 * len(w) / max(1, len(outs))), 'payoff %.2f' % pay, 'max pos %d' % mx, dict(sy.most_common(14)))
