#!/usr/bin/env python3
# -*- coding: ascii -*-
# Stub di powershell.exe -File RIGA_ROUND_VPS.ps1 per la riga RFWD: scrive gli stessi artefatti del driver vero
# (CSV IS/OOS di OptFrame, per-trade di ExportTrades, cartella ROUND_<etichetta> sul Desktop) con numeri da SCENARIO.
import sys, os, re, csv, json, shutil, time, importlib.util
REPO = os.environ.get('REPO_ROOT', '/home/user/GITHUB')
a = sys.argv[1:]
def J(base, rel):
    q = os.path.join(base, *rel.split('\\'))
    os.makedirs(os.path.dirname(q), exist_ok=True)
    return q
def arg(n):
    return a[a.index(n)+1] if n in a else None
EA = arg('-Expert'); PROVA = arg('-Prova'); LBL = arg('-Etichetta'); PIN = arg('-Pin'); MOD = arg('-Modello'); DEP = arg('-Deposito')
UP = os.environ['USERPROFILE']; AP = os.environ['APPDATA']; DSK = os.environ['DESKTOP_DIR']
SCEN = json.load(open(os.environ['SCENARIO']))
wdir = os.path.join(UP, 'abtg_round')
log = open(os.environ['HARNESS_LOG'], 'a'); log.write('STUB %s %s modello=%s dep=%s\n' % (LBL, PROVA, MOD, DEP)); log.close()
sc = SCEN.get(LBL, {})
if sc.get('rc1'):
    sys.exit(1)
src = os.path.join(REPO, 'backtest_pipeline', 'prove', PROVA)
txt = open(src, 'rb').read()
if sc.get('mut_prova'):
    txt = txt.replace(b'InpRiskPercent=2', b'InpRiskPercent=3')
os.makedirs(wdir, exist_ok=True)
open(J(wdir, 'prove\\' + PROVA), 'wb').write(txt)
eatxt = open(os.path.join(REPO, 'mql5/Experts/' + EA + '.mq5'), 'rb').read()
if sc.get('mut_ea'):
    eatxt += b'\n//x'
open(J(wdir, 'src_prove\\' + EA + '.mq5'), 'wb').write(eatxt)
open(J(wdir, 'src_include\\ABTG_PausaGuardian.mqh'), 'wb').write(open(os.path.join(REPO, 'mql5/Include/ABTG_PausaGuardian.mqh'), 'rb').read())
pins = []; axis = None; dirs = {}
for l in txt.decode().splitlines():
    t = l.strip()
    if not t or t.startswith('#'):
        continue
    if t.startswith('@'):
        m = re.match(r'@(\w+)\s+(.+)', t); dirs[m.group(1).upper()] = m.group(2).strip(); continue
    k, v = t.split('=', 1)
    if '||' in v and v.split('||')[-1] in ('Y', 'N'):
        p = v.split('||')
        if p[-1] == 'Y':
            axis = (k, p); pins.append((k, None)); continue
        v = p[0]
    pins.append((k, v))
ak, ap = axis
vals = [int(float(ap[1])), int(float(ap[3]))]
if 'axis_vals' in sc:
    vals = sc['axis_vals']
SIM = dirs['SIMBOLO']
hdr = ['Pass', 'Profit', 'Expected Payoff', 'Profit Factor', 'Recovery Factor', 'Sharpe Ratio', 'Equity DD %', 'Trades', 'Peggior Giornata %', 'Perdite Consecutive Max', 'Serie Perdente Peggiore'] + [k for k, _ in pins]
def valfmt(k, v, axv):
    if k == ak:
        return '%d' % axv
    if v in ('true', 'false'):
        return '1' if v == 'true' else '0'
    if sc.get('bad_pin') and k == 'InpRiskPercent':
        return '9'
    return v
def write_csv(fase):
    if sc.get('no_%s' % fase):
        return None
    fn = J(wdir, 'risultati_prove\\' + EA + '\\' + EA + '_' + SIM + '_' + fase + '_' + LBL + '.csv')
    ntr = sc.get('trades', 5)
    with open(fn, 'w', newline='', encoding='ascii') as f:
        w = csv.writer(f, lineterminator='\r\n')
        w.writerow(hdr)
        if not sc.get('no_rows'):
            for i, v in enumerate(vals):
                row = [str(i), '%.2f' % (100.0 * ntr), '1.00000', '1.30000', '0.50000', '1.00000', '2.0000', str(ntr), '-1.0000', '3', '-100.00']
                for k, pv in pins:
                    row.append(valfmt(k, pv, v))
                w.writerow(row)
    return fn
time.sleep(float(sc.get('sleep', 0)))
f1 = write_csv('IS'); time.sleep(1.1); f2 = write_csv('OOS')
# per-trade
HDR = 'close_time;symbol;magic;position_id;deal_type;volume;price;net_profit'
def rows_default(mg):
    out = []
    for k in range(int(sc.get('trades', 5)) if not sc.get('pt_zero') else 0):
        out.append(['2026.09.%02d 08:%02d:00' % (22 + (k % 6), 10 + k), SIM, mg, str(2 * (k + 1)), '1', '1.00', '25000.00', '10.00'])
    return out
def rows_forward(mg, sid):
    spec = importlib.util.spec_from_file_location('mc', os.path.join(REPO, 'backtest_pipeline', 'collaudo_riga_RFWD', 'mondi_controesempio.py'))
    mc = importlib.util.module_from_spec(spec); spec.loader.exec_module(mc)
    CF = mc.CF
    fw = CF.parse_forward(CF.leggi_xlsx(mc.XLSX))
    Fp, _m, _n = CF.posizioni_forward(fw, 2, CF.COSTANTI['SALDO_INIZIALE'])
    sd = CF.SEDIA_PER_ID[sid]
    rr = mc.righe_da_forward([p for p in Fp if p['sedia'] == sid], sd, int(sc.get('shift', 0)), float(sc.get('dp', 1.0)))
    for r in rr:
        r[2] = mg
    return rr
if not sc.get('no_pertrade'):
    for mg in [str(vals[0]), str(vals[1])]:
        if sc.get('pt_missing_main') and mg == str(vals[0]):
            continue
        fn = J(AP, 'MetaQuotes\\Terminal\\Common\\Files\\abtg_trades_' + EA + '_' + SIM + '_' + mg + '.csv')
        if SCEN.get('_pt_forward'):
            sid = SCEN['_sid'][LBL]
            rows = rows_forward(mg, sid) if not sc.get('pt_zero') else []
        else:
            rows = rows_default(mg)
        if sc.get('pt_old_dates') and rows:
            rows[0][0] = '2026.09.16 09:00:00'
        if sc.get('twin_diff') and mg == str(vals[1]) and rows:
            rows[0][6] = '25001.00'
        with open(fn, 'w', newline='', encoding='ascii') as f:
            f.write(HDR + '\r\n')
            for r in rows:
                f.write(';'.join(str(x) for x in r) + '\r\n')
# giornali finti del tester (UTF-16 come quelli veri): 4 passate per job + righe sui tick
import datetime as _dt
def _w16(path, lines):
    os.makedirs(os.path.dirname(path), exist_ok=True)
    with open(path, 'ab') as f:
        if f.tell() == 0:
            f.write(b'\xff\xfe')
        f.write(('\r\n'.join(lines) + '\r\n').encode('utf-16-le'))
if not sc.get('no_logs'):
    _n = _dt.datetime.now()
    _hh = _n.strftime('%H:%M:%S')
    _w16(os.path.join(AP, 'MetaQuotes', 'Tester', 'H1', 'Agent-127.0.0.1-3000', 'logs', '20260930.log'),
         ['CS\t0\t%s.100\tTester\t%d OnTester result 0.3128 : passed in 0:00:04.592' % (_hh, i) for i in range(4)])
    _w16(os.path.join(AP, 'MetaQuotes', 'Tester', 'logs', '20260930.log'),
         ['MI\t0\t%s.353\tTester\t%s: preliminary downloading of history ticks completed' % (_hh, SIM),
          'QI\t0\t%s.306\tCore 1\t%s: ticks synchronization completed [3851 Kb]' % (_hh, SIM)])
if sc.get('pt_old_mtime') and f1:
    _t = os.path.getmtime(f1) - 0.02
    for mg in [str(vals[0]), str(vals[1])]:
        _fn = os.path.join(AP, 'MetaQuotes', 'Terminal', 'Common', 'Files', 'abtg_trades_' + EA + '_' + SIM + '_' + mg + '.csv')
        if os.path.exists(_fn):
            os.utime(_fn, (_t, _t))
d = os.path.join(DSK, 'ROUND_' + LBL); os.makedirs(d, exist_ok=True)
open(os.path.join(d, 'REFERTO_ROUND_' + LBL + '.txt'), 'w').write('referto finto\n')
for f_ in (f1, f2):
    if f_ and os.path.exists(f_):
        shutil.copy(f_, os.path.join(d, os.path.basename(f_)))
shutil.copy(J(wdir, 'prove\\' + PROVA), os.path.join(d, PROVA))
sys.exit(int(sc.get('rc', 3)))
