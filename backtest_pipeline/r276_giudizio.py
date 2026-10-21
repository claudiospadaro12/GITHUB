#!/usr/bin/env python3
# =====================================================================
#  r276_giudizio.py -- LETTORE CONGELATO dei round R276 (T3 lotto forzato al minimo, T5 armo tardivo)
#  Scritto il 21/10/2026 PRIMA di aprire i per-trade, dai criteri dei file prova
#  backtest_pipeline/prove/R276a_T3_deposito2000..., R276c_T3x_deposito500..., R276b_T5_armo_tardivo...
#  USO:  python3 backtest_pipeline/r276_giudizio.py <cartella ROUND_R276_data> [--base <per-trade 80000 di R274a>]
#        python3 backtest_pipeline/r276_giudizio.py --autotest
#  Layout atteso: <cartella>/ROUND_R276a|b|c/{ABTG_..._IS_<tag>.csv, ..._OOS_<tag>.csv}, <cartella>/PERTRADE/abtg_trades_ABTG_Nasdaq_Apertura_US_NASUSD_<magic>.csv
# =====================================================================
import csv, os, sys, collections, statistics, datetime

JOBS = {  # tag: (deposito, magic gemelli, ora sessione attesa, tipo)
    'R276a': (2000, ('798611', '798661'), '14', 'T3'),
    'R276c': (500, ('798621', '798671'), '14', 'T3'),
    'R276b': (80000, ('798631', '798681'), '19', 'T5'),
}
EA = 'ABTG_Nasdaq_Apertura_US'; SIM = 'NASUSD'
SOGLIA_RISCHIO = 2.5      # % del saldo stimato all'ingresso (T3, congelata)
T5_DA = (19, 35); T5_A = (21, 45); T5_PRIMA = (19, 5)


def leggi_pertrade(p):
    with open(p, newline='') as f:
        r = list(csv.DictReader(f, delimiter=';'))
    out = []
    for x in r:
        out.append(dict(t=datetime.datetime.strptime(x['close_time'], '%Y.%m.%d %H:%M:%S'), pid=x['position_id'],
                        vol=float(x['volume']), net=float(x['net_profit']), magic=x['magic'], raw=x))
    return out


def posizioni(deals, deposito):
    """per posizione: volume totale, netto, primo orario, ultimo orario, saldo stimato all'ingresso (deposito + netto dei deal chiusi prima)."""
    deals = sorted(deals, key=lambda d: d['t'])
    pos = collections.OrderedDict()
    for d in deals:
        pos.setdefault(d['pid'], []).append(d)
    out = []
    for pid, ds in pos.items():
        t0 = ds[0]['t']
        saldo = deposito + sum(x['net'] for x in deals if x['t'] < t0)
        out.append(dict(pid=pid, vol=sum(x['vol'] for x in ds), net=sum(x['net'] for x in ds), t0=t0, t1=ds[-1]['t'], saldo=saldo, n=len(ds)))
    return out


def metriche_t3(deals, deposito):
    P = posizioni(deals, deposito)
    if not P: return dict(n=0)
    vmin = min(p['vol'] for p in P)
    perd = [p for p in P if p['net'] < 0]
    for p in P: p['risk'] = -p['net'] / p['saldo'] * 100 if p['net'] < 0 else 0.0
    oltre = [p for p in perd if p['risk'] > SOGLIA_RISCHIO]
    forzate = [p for p in oltre if p['vol'] <= vmin * 1.0000001]
    vols = sorted(p['vol'] for p in P)
    n_min = sum(1 for p in P if p['vol'] <= vmin * 1.0000001)
    return dict(n=len(P), n_perd=len(perd), vmin=vmin, vmed=statistics.median(vols), vmax=vols[-1], n_al_min=n_min,
                quota_min=100.0 * n_min / len(P), peggiore=max((p['risk'] for p in perd), default=0.0),
                oltre=len(oltre), forzate=len(forzate), top=sorted(perd, key=lambda p: -p['risk'])[:5], P=P)


def g1_csv(a, b):
    p = []
    for k, tol in (('Profit', 1.0), ('Profit Factor', 0.0002), ('Recovery Factor', 0.0002)):
        if abs(float(a[k]) - float(b[k])) > tol: p.append('%s %s vs %s' % (k, a[k], b[k]))
    for k in ('Trades', 'Equity DD %'):
        if a[k] != b[k]: p.append('%s %s vs %s' % (k, a[k], b[k]))
    return p


def g1_pertrade(d1, d2):
    """righe uguali tranne il magic; righe con |diff net| > 0,01 elencate e somma <= 1,00."""
    if len(d1) != len(d2): return ['numero di righe %d vs %d' % (len(d1), len(d2))]
    pr = []; somma = 0.0; el = []
    for i, (x, y) in enumerate(zip(d1, d2)):
        rx = {k: v for k, v in x['raw'].items() if k != 'magic'}; ry = {k: v for k, v in y['raw'].items() if k != 'magic'}
        for k in rx:
            if k == 'net_profit':
                df = abs(float(rx[k]) - float(ry[k]))
                if df > 0.01: el.append((i + 1, df)); somma += df
            elif rx[k] != ry[k]: pr.append('riga %d colonna %s %s vs %s' % (i + 1, k, rx[k], ry[k]))
    if somma > 1.0: pr.append('somma |diff| net_profit %.2f > 1,00 EUR (righe %s)' % (somma, el[:5]))
    return pr


def csv_righe(p):
    if not os.path.exists(p) or os.path.getsize(p) == 0: return []
    return list(csv.DictReader(open(p, newline='')))


def t5_metriche(deals):
    P = posizioni(deals, 80000)
    dentro = []; prima = []; dopo = []
    for p in P:
        h = (p['t1'].hour, p['t1'].minute)
        if h < T5_PRIMA: prima.append(p)
        elif h > T5_A: dopo.append(p)
        elif h >= T5_DA: dentro.append(p)
    per_ora = collections.Counter(p['t1'].hour for p in P)
    return dict(n=len(P), dentro=len(dentro), prima=prima, dopo=dopo, per_ora=dict(sorted(per_ora.items())), P=P)


def main(cart, base=None):
    print('=' * 78); print('R276 -- GIUDIZIO COI CRITERI CONGELATI (prove R276a/R276b/R276c par. 0-3)'); print('=' * 78)
    nulli = []
    for tag, (dep, mg, ora, tipo) in JOBS.items():
        d = os.path.join(cart, 'ROUND_' + tag)
        print('\n### %s (%s, deposito %d, magic %s/%s)' % (tag, tipo, dep, mg[0], mg[1]))
        csvs = {}
        for leg in ('IS', 'OOS'):
            rr = csv_righe(os.path.join(d, '%s_%s_%s_%s.csv' % (EA, SIM, leg, tag)))
            csvs[leg] = rr
            if len(rr) == 2:
                pr = g1_csv(rr[0], rr[1]); print('  G1 CSV %s: %s %s' % (leg, 'PASS' if not pr else 'NULLO', pr))
                if pr: nulli.append(tag)
                for x in rr: print('     magic %s Profit %s PF %s DD %s Trades %s PeggiorGiornata %s' % (x['InpMagic'], x['Profit'], x['Profit Factor'], x['Equity DD %'], x['Trades'], x['Peggior Giornata %']))
                if rr[0]['InpSessionHour'] != ora: print('  *** InpSessionHour %s invece di %s: CSV DA CESTINARE' % (rr[0]['InpSessionHour'], ora)); nulli.append(tag)
            else:
                print('  CSV %s: %d righe (%s)' % (leg, len(rr), 'atteso vuoto possibile solo per R276b IS' if tag == 'R276b' and leg == 'IS' else 'ANOMALO'))
                if not (tag == 'R276b' and leg == 'IS'): nulli.append(tag)
        f1 = os.path.join(cart, 'PERTRADE', 'abtg_trades_%s_%s_%s.csv' % (EA, SIM, mg[0])); f2 = os.path.join(cart, 'PERTRADE', 'abtg_trades_%s_%s_%s.csv' % (EA, SIM, mg[1]))
        if not (os.path.exists(f1) and os.path.exists(f2)): print('  PERTRADE MANCANTE'); nulli.append(tag); continue
        d1, d2 = leggi_pertrade(f1), leggi_pertrade(f2)
        pr = g1_pertrade(d1, d2); print('  G1 per-trade: %s %s' % ('PASS' if not pr else 'NULLO', pr[:3]))
        if pr: nulli.append(tag)
        oos = csvs['OOS']
        if oos and len(oos) == 2:
            somma = sum(x['net'] for x in d1)
            print('  coerenza per-trade/OOS: somma net %.2f / %d deal contro Profit %s / Trades %s' % (somma, len(d1), oos[0]['Profit'], oos[0]['Trades']))
        if tipo == 'T3':
            m = metriche_t3(d1, dep)
            print('  T3: posizioni %d (in perdita %d); volume per posizione min %.3f / mediano %.3f / max %.3f; posizioni al volume minimo %d (%.1f%%)' % (m['n'], m['n_perd'], m['vmin'], m['vmed'], m['vmax'], m['n_al_min'], m['quota_min']))
            print('      peggiore rischio realizzato %.2f%% del saldo stimato; posizioni oltre %.1f%%: %d; di cui AL VOLUME MINIMO (lotto forzato): %d' % (m['peggiore'], SOGLIA_RISCHIO, m['oltre'], m['forzate']))
            for p in m['top']: print('        %s vol %.3f perdita %.2f saldo %.2f rischio %.2f%% (%s)' % (p['pid'], p['vol'], -p['net'], p['saldo'], p['risk'], p['t1']))
            if m['n'] < 60: print('  A4: meno di 60 posizioni: NON MISURABILE')
            print('  VERDETTO T3 (%s): %s' % (tag, 'IL DIFETTO ESISTE a questo deposito (rischio > %.1f%% con lotto al minimo)' % SOGLIA_RISCHIO if m['forzate'] > 0 else ('perdite > %.1f%% ma con volume sopra il minimo: causa = salto dello stop o spread, NON lotto forzato' % SOGLIA_RISCHIO if m['oltre'] > 0 else 'NESSUNA posizione oltre %.1f%%: difetto NON osservato a questo deposito' % SOGLIA_RISCHIO)))
        else:
            m = t5_metriche(d1)
            print('  T5: posizioni %d; uscite per ora: %s' % (m['n'], m['per_ora']))
            print('      uscite fra %02d:%02d e %02d:%02d: %d posizioni; prima delle %02d:%02d: %d; dopo le %02d:%02d: %d' % (T5_DA + T5_A + (m['dentro'],) + T5_PRIMA + (len(m['prima']),) + T5_A + (len(m['dopo']),)))
            for p in m['dopo']: print('        dopo le 21:45: %s %s' % (p['pid'], p['t1']))
            for p in m['prima']: print('        prima delle 19:05: %s %s' % (p['pid'], p['t1']))
            print('  VERDETTO T5: %s' % ('NESSUN TETTO ALL ORARIO DI ARMO: CONFERMATO nel tester (%d posizioni chiuse fra 19:35 e 21:45)' % m['dentro'] if m['dentro'] >= 1 else 'NON CONFERMATO nel tester (zero posizioni chiuse fra 19:35 e 21:45)'))
    if base and os.path.exists(base):
        m = metriche_t3(leggi_pertrade(base), 80000)
        print('\n### BASE 80000 (R274a OOS): posizioni %d, volume min %.3f / med %.3f / max %.3f, peggiore rischio %.2f%% (su saldo stimato da 80000, senza IS), oltre 2,5%%: %d' % (m['n'], m['vmin'], m['vmed'], m['vmax'], m['peggiore'], m['oltre']))
    if nulli: print('\n*** FILE NULLI O ANOMALI: %s' % sorted(set(nulli)))
    print('\nNessun verdetto di merito (n < 150). Limiti: tester, un solo periodo, saldo all ingresso STIMATO dal netto dei deal chiusi prima.')


def autotest():
    import tempfile, shutil
    t = tempfile.mkdtemp()
    def scrivi(p, rows):
        os.makedirs(os.path.dirname(p), exist_ok=True)
        with open(p, 'w', newline='') as f:
            f.write('close_time;symbol;magic;position_id;deal_type;volume;price;net_profit\n')
            for r in rows: f.write(';'.join(str(c) for c in r) + '\n')
    def rows(magic, spec):
        out = []
        for i, (dt, vol, net) in enumerate(spec): out.append((dt, 'NASUSD', magic, i + 1, 0, vol, 20000, '%.2f' % net))
        return out
    # T3 sintetico: 3 posizioni; una in perdita 3% del saldo 500 con volume = minimo (0.01) -> difetto
    spec = [('2025.07.01 16:00:00', 0.05, 20.0), ('2025.07.02 16:00:00', 0.01, -15.6), ('2025.07.03 16:00:00', 0.05, -5.0)]
    for tag, (dep, mg, ora, tipo) in JOBS.items():
        for m in mg:
            s = spec if tipo == 'T3' else [('2026.05.20 20:10:00', 5, 100.0), ('2026.05.21 20:50:00', 5, -50.0), ('2026.05.22 22:10:00', 5, 10.0), ('2026.05.23 15:00:00', 5, 1.0)]
            scrivi(os.path.join(t, 'PERTRADE', 'abtg_trades_%s_%s_%s.csv' % (EA, SIM, m)), rows(m, s))
        for leg in ('IS', 'OOS'):
            p = os.path.join(t, 'ROUND_' + tag, '%s_%s_%s_%s.csv' % (EA, SIM, leg, tag)); os.makedirs(os.path.dirname(p), exist_ok=True)
            with open(p, 'w', newline='') as f:
                w = csv.writer(f); w.writerow(['Pass', 'Profit', 'Profit Factor', 'Recovery Factor', 'Equity DD %', 'Trades', 'Peggior Giornata %', 'InpMagic', 'InpSessionHour'])
                for i, m in enumerate(mg): w.writerow([i, '10.0', '1.2', '1.1', '5.0', '3', '-3.0', m, ora])
    import io, contextlib
    buf = io.StringIO()
    with contextlib.redirect_stdout(buf): main(t)
    o = buf.getvalue()
    ok = ('IL DIFETTO ESISTE a questo deposito' in o) and ('CONFERMATO nel tester (2 posizioni chiuse fra 19:35 e 21:45)' in o) and ('dopo le 21:45: 3' in o) and ('FILE NULLI' not in o)
    # contro-esempio: gemelle diverse -> NULLO
    scrivi(os.path.join(t, 'PERTRADE', 'abtg_trades_%s_%s_798611.csv' % (EA, SIM)), rows('798611', [('2025.07.01 16:00:00', 0.05, 20.0), ('2025.07.02 16:00:00', 0.01, -15.6), ('2025.07.03 16:00:00', 0.05, -9.0)]))
    buf2 = io.StringIO()
    with contextlib.redirect_stdout(buf2): main(t)
    ok2 = 'R276a' in buf2.getvalue() and 'FILE NULLI O ANOMALI' in buf2.getvalue()
    shutil.rmtree(t)
    print('autotest r276_giudizio: %s (esito sintetico %s, contro-esempio gemelle %s)' % ('OK' if ok and ok2 else 'FALLITO', ok, ok2))
    if not (ok and ok2): print(o); sys.exit(1)


if __name__ == '__main__':
    if '--autotest' in sys.argv: autotest()
    else:
        a = [x for x in sys.argv[1:] if not x.startswith('--')]
        base = sys.argv[sys.argv.index('--base') + 1] if '--base' in sys.argv else None
        if base in a: a.remove(base)
        main(a[0], base)
