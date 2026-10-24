#!/usr/bin/env python3
# =====================================================================
#  sonda_spec_giudizio.py -- LETTORE CONGELATO della sonda delle specifiche (A1, A2 del giro 3). Scritto il 24/10/2026 PRIMA dei numeri.
#  USO: python3 backtest_pipeline/sonda_spec_giudizio.py <ABTG_SONDA_SPEC.csv> | --autotest
#  CRITERI: report/SONDA_SPECIFICHE_CRITERI_2026-10-24.md
#   A1: d = 20*pip/point (pip = point; 10*point a 3 o 5 cifre). RIFIUTATO se StopsLevel > d, AMMESSO altrimenti.
#       COERENTE se NASUSD e 225JPY RIFIUTATI e D30EUR AMMESSO; NON SPIEGA se NASUSD e 225JPY AMMESSI; CONTRADDITTORIO se D30EUR RIFIUTATO; altrimenti PARZIALE.
#   A2: stop_soglia = S*R/100/(vol_min*vpp), vpp = tick_value/tick_size*point.
# =====================================================================
import csv, sys, os, tempfile
SALDI = (5344.0, 5000.0); RISCHI = (1.0, 0.65, 0.5, 0.3, 0.25)
def leggi(path):
    b = open(path, 'rb').read()
    t = b.decode('utf-16') if b[:2] in (b'\xff\xfe', b'\xfe\xff') else b.decode('utf-8-sig', 'replace')
    rows = list(csv.DictReader(t.splitlines(), delimiter=';'))
    return {r['simbolo']: r for r in rows}
def f(r, k): return float(r[k])
def dist20(r):
    dg = int(f(r, 'digits')); pip = f(r, 'point') * (10 if dg in (3, 5) else 1)
    return 20 * pip / f(r, 'point')
def a1(S):
    out = {}
    for s in ('U30USD', 'NASUSD', 'D30EUR', '225JPY', 'XAUUSD'):
        r = S.get(s)
        if not r or r['trovato'] != '1': out[s] = 'NON LETTO'; continue
        d = dist20(r); sl = int(f(r, 'stops_level'))
        out[s] = ('RIFIUTATO' if sl > d else 'AMMESSO') + ' (StopsLevel %d, distanza pendente %.0f punti, FreezeLevel %d)' % (sl, d, int(f(r, 'freeze_level')))
    st = {k: v.split(' ')[0] for k, v in out.items()}
    if 'NON' in (st['NASUSD'], st['225JPY'], st['D30EUR']): v = 'NON LEGGIBILE (simbolo non letto)'
    elif st['D30EUR'] == 'RIFIUTATO': v = 'CONTRADDITTORIO (D30EUR rifiutato ma il gemello DAX riempie la gamba: la specifica di oggi puo essere diversa da quella di agosto)'
    elif st['NASUSD'] == 'RIFIUTATO' and st['225JPY'] == 'RIFIUTATO': v = 'COERENTE coi dati: NASUSD e 225JPY rifiutano il pendente, D30EUR lo ammette'
    elif st['NASUSD'] == 'AMMESSO' and st['225JPY'] == 'AMMESSO': v = 'NON SPIEGA: StopsLevel non rifiuta il pendente su NASUSD ne 225JPY, la causa dell assenza della gamba 2/3 resta NON TROVATA'
    else: v = 'PARZIALE: uno solo fra NASUSD e 225JPY rifiuta il pendente'
    out['ESITO A1'] = v
    return out
def a2(S):
    rig = []
    for s, r in S.items():
        if r['trovato'] != '1': rig.append('%s: NON LETTO' % s); continue
        vmin = f(r, 'vol_min'); ts = f(r, 'tick_size')
        vpp = f(r, 'tick_value') / ts * f(r, 'point') if ts else 0.0
        if vpp <= 0 or vmin <= 0: rig.append('%s: vol_min %g vpp %g NON CALCOLABILE' % (s, vmin, vpp)); continue
        soglie = ' | '.join('S=%.0f ' % sa + ' '.join('R%.2f%%=%.0f' % (ri, sa * ri / 100 / (vmin * vpp)) for ri in RISCHI) for sa in SALDI)
        rig.append('%s: vol_min %g step %g, %.4f EUR/punto/lotto, swap L/S %g/%g | stop_soglia (punti): %s' % (s, vmin, f(r, 'vol_step'), vpp, f(r, 'swap_long'), f(r, 'swap_short'), soglie))
    return rig
def autotest():
    d = tempfile.mkdtemp(); p = os.path.join(d, 's.csv')
    H = 'simbolo;trovato;digits;point;stops_level;freeze_level;vol_min;vol_max;vol_step;tick_value;tick_size;tick_value_profit;tick_value_loss;contract_size;swap_long;swap_short;swap_mode;spread;filling_mode;order_mode;expiration_mode;trade_mode;valuta_profitto;bid;ask'
    def riga(s, dg, pt, sl, vmin=0.1, tv=0.86, ts=1.0): return '%s;1;%d;%g;%d;0;%g;100;%g;%g;%g;%g;%g;1;-1;-2;1;3;1;127;15;4;USD;1;1' % (s, dg, pt, sl, vmin, vmin, tv, ts, tv, tv)
    def scrivi(sls):
        open(p, 'w').write(H + '\n' + '\n'.join(riga(s, 2 if s != '225JPY' else 0, 0.01 if s != '225JPY' else 1, sls[s]) for s in sls) + '\n')
    scrivi({'U30USD': 0, 'NASUSD': 50, 'D30EUR': 10, '225JPY': 30, 'XAUUSD': 0}); a = a1(leggi(p)); assert a['ESITO A1'].startswith('COERENTE'), a
    scrivi({'U30USD': 0, 'NASUSD': 10, 'D30EUR': 10, '225JPY': 5, 'XAUUSD': 0}); a = a1(leggi(p)); assert a['ESITO A1'].startswith('NON SPIEGA'), a
    scrivi({'U30USD': 0, 'NASUSD': 50, 'D30EUR': 100, '225JPY': 30, 'XAUUSD': 0}); a = a1(leggi(p)); assert a['ESITO A1'].startswith('CONTRADDITTORIO'), a
    scrivi({'U30USD': 0, 'NASUSD': 50, 'D30EUR': 10, '225JPY': 5, 'XAUUSD': 0}); a = a1(leggi(p)); assert a['ESITO A1'].startswith('PARZIALE'), a
    r = a2(leggi(p)); assert len(r) == 5 and 'S=5344' in r[0] and 'R1.00%=' in r[0], r
    # soglia: 5344*1%/(0.1*0.86*0.01/0.01...) con point=0.01,tick=1,tv=0.86 -> vpp=0.0086 ; 53.44/(0.1*0.0086)=62139
    assert abs(float(r[0].split('R1.00%=')[1].split()[0]) - 53.44 / (0.1 * 0.0086)) < 1.5, r[0]
    print('AUTOTEST sonda specifiche: 6 casi OK (coerente, non spiega, contraddittorio, parziale, tabella A2, soglia)')
if __name__ == '__main__':
    if len(sys.argv) > 1 and sys.argv[1] == '--autotest': autotest(); sys.exit(0)
    if len(sys.argv) != 2: print(__doc__); sys.exit(2)
    S = leggi(sys.argv[1])
    print('=== A1: il pendente a 20 pip ===')
    for k, v in a1(S).items(): print('%-10s %s' % (k, v))
    print('=== A2: soglia del pavimento del lotto ===')
    for l in a2(S): print(l)
