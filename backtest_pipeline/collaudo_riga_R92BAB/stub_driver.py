#!/usr/bin/env python3
# -*- coding: ascii -*-
# Stub di powershell.exe -File RIGA_ROUND_VPS.ps1 per la riga R92BAB: scrive gli stessi artefatti del driver vero (copie di lavoro, CSV IS/OOS
# di OptFrame con la colonna Symbols_List, giornale del tester UTF-16 con le righe VERE di una gamba partita e di una gamba morta,
# cartella ROUND_<etichetta> sul Desktop) secondo SCENARIO. Il formato delle righe del giornale e' quello letto da
# risultati_archivio/ROUND_R92B_2026-09-30/LOG_TESTER/0006_Tester_logs_20260930.log (gamba morta) e ROUND_RFWD_2026-09-30 (gamba partita).
import sys, os, re, csv, json, shutil, time, datetime as dt
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
txt = open(os.path.join(REPO, 'backtest_pipeline', 'prove', PROVA), 'rb').read()
if sc.get('mut_prova'):
    txt += b'\n#x\n'
os.makedirs(wdir, exist_ok=True)
open(J(wdir, 'prove\\' + PROVA), 'wb').write(txt)
eatxt = open(os.path.join(REPO, 'mql5/Experts/' + EA + '.mq5'), 'rb').read()
if sc.get('mut_ea'):
    eatxt += b'\n//x'
open(J(wdir, 'src_prove\\' + EA + '.mq5'), 'wb').write(eatxt)
open(J(wdir, 'src_include\\ABTG_PausaGuardian.mqh'), 'wb').write(open(os.path.join(REPO, 'mql5/Include/ABTG_PausaGuardian.mqh'), 'rb').read())
wf = open(os.path.join(REPO, 'backtest_pipeline/walkforward_generico.ps1'), 'rb').read()
if sc.get('mut_wf'):
    wf += b'\n#x'
if not sc.get('no_wf'):
    open(J(wdir, 'walkforward_generico.ps1'), 'wb').write(wf)
pins = []; axis = None; dirs = {}; symval = None
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
    if k == 'Symbols_List':
        symval = v
    pins.append((k, v))
ak, ap = axis
vals = [int(float(ap[1])), int(float(ap[3]))]
SIM = dirs['SIMBOLO']; TF = dirs['PERIODO']
d0 = dirs['DAQUANDO']; d1 = dirs['FINOA']; fz = float(dirs['FRAZIONEIS'])
D0 = dt.datetime.strptime(d0, '%Y.%m.%d'); D1 = dt.datetime.strptime(d1, '%Y.%m.%d')
META = D0 + dt.timedelta(days=int((D1 - D0).days * fz))
ISA, ISB = d0, META.strftime('%Y.%m.%d'); OOA, OOB = (META + dt.timedelta(days=1)).strftime('%Y.%m.%d'), d1
sfx = '' if str(MOD) == '4' else '_ohlc'
pins_w = [(k, v) for (k, v) in pins if not (sc.get('sym_col_absent') and k == 'Symbols_List')]
hdr0 = ['Pass', 'Profit', 'Expected Payoff', 'Profit Factor', 'Recovery Factor', 'Sharpe Ratio', 'Equity DD %', 'Trades', 'Peggior Giornata %', 'Perdite Consecutive Max', 'Serie Perdente Peggiore'] + [k for k, _ in pins_w]
hdr = hdr0
legs = sc.get('legs', ['ok', 'ok'])
def write_csv(fase, stato):
    if stato != 'ok' and not sc.get('csv_anyway'):
        return None
    if sc.get('no_%s' % fase):
        return None
    fn = J(wdir, 'risultati_prove\\' + EA + '\\' + EA + '_' + SIM + '_' + fase + sfx + '_' + LBL + '.csv')
    if sc.get('csv_zero'):
        open(fn, 'wb').close()
        return fn
    ntr = sc.get('trades', 5)
    with open(fn, 'w', newline='', encoding='ascii') as f:
        w = csv.writer(f, lineterminator='\r\n')
        w.writerow(hdr)
        for i, v in enumerate(vals):
            if sc.get('una_riga') and i == 1:
                break
            row = [str(i), '%.2f' % (100.0 * ntr), '1.00000', '1.30000', '0.50000', '1.00000', '2.0000', str(ntr), '-1.0000', '3', '-100.00']
            for k, pv in pins_w:
                if k == ak:
                    row.append('%d' % v)
                elif k == 'Symbols_List':
                    s = pv
                    if 'sym_len' in sc:
                        s = s[:int(sc['sym_len'])]
                    if 'sym_plus' in sc:
                        s = s + 'X' * int(sc['sym_plus'])
                    row.append(s)
                else:
                    row.append('1' if pv == 'true' else '0' if pv == 'false' else pv)
            w.writerow(row)
    if sc.get('csv_stale'):
        _t = time.time() - 600
        os.utime(fn, (_t, _t))
    return fn
def _w16(path, lines):
    os.makedirs(os.path.dirname(path), exist_ok=True)
    with open(path, 'ab') as f:
        if f.tell() == 0:
            f.write(b'\xff\xfe')
        f.write(('\r\n'.join(lines) + '\r\n').encode('utf-16-le'))
TL = os.path.join(AP, 'MetaQuotes', 'Tester', 'logs', dt.datetime.now().strftime('%Y%m%d') + '.log')
def hms(delta=0.0):
    n = dt.datetime.now() + dt.timedelta(seconds=delta)
    return n.strftime('%H:%M:%S.') + '%03d' % (n.microsecond // 1000)
def leg_lines(stato, fase, ea_name):
    L = ['NS\t0\t%s\tTester\t"%s.ex5" X64' % (hms(), ea_name), 'DF\t0\t%s\tTester\tregister MQL5.community account and use MQL5 Cloud Network to speed up optimizations' % hms()]
    if stato == 'ok':
        a_, b_ = (ISA, ISB) if fase == 'IS' else (OOA, OOB)
        if sc.get('win_bad') and fase == 'OOS':
            b_ = (dt.datetime.strptime(b_, '%Y.%m.%d') - dt.timedelta(days=1)).strftime('%Y.%m.%d')
        L.append('MI\t0\t%s\tTester\tExperts\\%s.ex5 on %s,%s from %s 00:00 to %s 00:00' % (hms(), EA, SIM, TF, a_, b_))
        L.append('RK\t0\t%s\tTester\toptimization finished, total passes 2' % hms())
    else:
        for i in range(5):
            L.append('DJ\t3\t%s\tTester\tOnTesterInit works too long...' % hms())
        L.append('RI\t3\t%s\tTester\tOnTesterInit works too long. Tester cannot be initialized.' % hms())
    L.append('ND\t0\t%s\tTester\tCloud servers switched off' % hms())
    return L
files = []
if sc.get('tlog') == 'vuoto':
    os.makedirs(os.path.dirname(TL), exist_ok=True); open(TL, 'wb').close()
if sc.get('prima'):
    # una gamba MORTA scritta da una corsa PRECEDENTE dello stesso giorno (00:00:01, prima dell avvio di qualunque riga)
    _w16(TL, ['NS\t0\t00:00:01.000\tTester\t"ABTG_Bulge.ex5" X64'] + ['DJ\t3\t00:00:2%d.000\tTester\tOnTesterInit works too long...' % i for i in range(5)] +
         ['RI\t3\t00:00:27.000\tTester\tOnTesterInit works too long. Tester cannot be initialized.'])
for i, fase in enumerate(['IS', 'OOS']):
    stato = legs[i]
    time.sleep(float(sc.get('sleep', 0.1)))
    if not sc.get('tlog') and not sc.get('no_logs'):
        _w16(TL, leg_lines(stato, fase, sc.get('ea_other', EA) if i == 0 else EA))
    files.append(write_csv(fase, stato))
    time.sleep(0.15)
# per-trade degli AGENTI in Common\Files (classe 998): una riga per deal di uscita, colonna symbol; stesso formato di ExportTrades (';')
if sc.get('pertrade') is not None:
    cf = os.path.join(AP, 'MetaQuotes', 'Terminal', 'Common', 'Files'); os.makedirs(cf, exist_ok=True)
    for v in vals:
        pf = os.path.join(cf, 'abtg_trades_%s_%s_%d_violaEA.csv' % (EA, SIM, v))
        with open(pf, 'w', newline='', encoding='ascii') as f:
            f.write('close_time;symbol;magic;position_id;deal_type;volume;price;net_profit;signal;entry_comment;exit_comment\r\n')
            for i, s_ in enumerate(sc['pertrade']):
                f.write('%s;%s;%d;%d;1;0.10;1.00000;-5.00;BLU;BULGE_V520A_BLU_L;sl\r\n' % (sc.get('pertrade_ct', '2026.05.10 10:00:00'), s_, v, 1000 + i))
        # classe 1005 (terzo cancello): un per-trade di una corsa PRECEDENTE con lo stesso magic (scritto prima dell avvio del job) NON si legge
        if sc.get('pertrade_stale'):
            _t = time.time() - 3600
            os.utime(pf, (_t, _t))
if sc.get('extra_leg') and not sc.get('tlog'):
    _w16(TL, leg_lines('ok', 'OOS', EA))
d = os.path.join(DSK, 'ROUND_' + LBL); os.makedirs(d, exist_ok=True)
open(os.path.join(d, 'REFERTO_ROUND_' + LBL + '.txt'), 'w').write('referto finto\n')
for f_ in files:
    if f_ and os.path.exists(f_):
        shutil.copy(f_, os.path.join(d, os.path.basename(f_)))
shutil.copy(J(wdir, 'prove\\' + PROVA), os.path.join(d, PROVA))
rcdef = 3 if all(x == 'ok' for x in legs) else 2
sys.exit(int(sc.get('rc', rcdef)))
