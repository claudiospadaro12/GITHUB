#!/usr/bin/env python3
# -*- coding: ascii -*-
# Stub di `powershell.exe -File RIGA_ROUND_VPS.ps1` per la riga DAXAP02: scrive gli stessi artefatti del driver vero, nel formato VERO letto
# da risultati_archivio/ROUND_R270_USCITA_DAX_2026-09-28 (stesso EA, stessa finestra, stesso PC, 28/09):
#   - copie di lavoro (src_prove\EA.mq5, src_include\ABTG_PausaGuardian.mqh, walkforward_generico.ps1, prove\<file prova>);
#   - CSV _IS/_OOS di OptFrame con la colonna dell'asse PRIMA e poi tutti gli input (bool -> 1/0, piu' InpNewsCurrencies che il file prova non ha);
#   - giornale del tester UTF-16 con le righe vere ("EA.ex5" X64 / Experts\EA.ex5 on D30EUR,M5 from ... to ... / Tester cannot be initialized);
#   - per-trade degli agenti in Common\Files (abtg_trades_<EA>_<SIM>_<magic>.csv, ';');
#   - cartella ROUND_<etichetta> sul Desktop con REFERTO_ROUND_<etichetta>.txt nelle righe del driver vero (pin/macchina/terminale/deposito/modello),
#     i due CSV e il file prova.
# Il deposito, il modello e il pin del referto sono QUELLI RICEVUTI come argomenti (default del driver vero se mancano: 10000, 4, lavoro).
import sys, os, re, csv, json, shutil, time, datetime as dt
REPO = os.environ.get('REPO_ROOT', '/home/user/GITHUB')
a = sys.argv[1:]
def J(base, rel):
    q = os.path.join(base, *rel.split('\\'))
    os.makedirs(os.path.dirname(q), exist_ok=True)
    return q
def arg(n, dflt=None):
    return a[a.index(n)+1] if n in a else dflt
EA = arg('-Expert'); PROVA = arg('-Prova'); LBL = arg('-Etichetta'); PIN = arg('-Pin', 'lavoro'); MOD = arg('-Modello', '4'); DEP = arg('-Deposito', '10000')
UP = os.environ['USERPROFILE']; AP = os.environ['APPDATA']; DSK = os.environ['DESKTOP_DIR']
SCEN = json.load(open(os.environ['SCENARIO']))
wdir = os.path.join(UP, 'abtg_round')
log = open(os.environ['HARNESS_LOG'], 'a'); log.write('STUB %s %s modello=%s dep=%s pin=%s argv=%s\n' % (LBL, PROVA, MOD, DEP, PIN, ' '.join(a))); log.close()
sc = SCEN
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
if not sc.get('no_ea'):
    open(J(wdir, 'src_prove\\' + EA + '.mq5'), 'wb').write(eatxt)
inc = open(os.path.join(REPO, 'mql5/Include/ABTG_PausaGuardian.mqh'), 'rb').read()
if sc.get('mut_inc'):
    inc += b'\n//x'
open(J(wdir, 'src_include\\ABTG_PausaGuardian.mqh'), 'wb').write(inc)
wf = open(os.path.join(REPO, 'backtest_pipeline/walkforward_generico.ps1'), 'rb').read()
if sc.get('mut_wf'):
    wf += b'\n#x'
if not sc.get('no_wf'):
    open(J(wdir, 'walkforward_generico.ps1'), 'wb').write(wf)
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
            axis = (k, p); continue
        v = p[0]
    pins.append((k, v))
ak, ap = axis
a0, a1, a2 = int(float(ap[1])), int(float(ap[2])), int(float(ap[3]))
vals = list(range(a0, a2 + 1, a1))                  # 11, 13, 15, 17
vals = [vals[-1]] + vals[:-1]                       # ordine dei Pass NON ordinato per asse (17, 11, 13, 15): la riga deve ordinare da se
if 'ax_vals' in sc:
    vals = sc['ax_vals']
SIM = dirs['SIMBOLO']; TF = dirs['PERIODO']
d0 = dirs['DAQUANDO']; d1 = dirs['FINOA']; fz = float(dirs['FRAZIONEIS'])
D0 = dt.datetime.strptime(d0, '%Y.%m.%d'); D1 = dt.datetime.strptime(d1, '%Y.%m.%d')
META = D0 + dt.timedelta(days=int((D1 - D0).days * fz))
ISA, ISB = d0, META.strftime('%Y.%m.%d'); OOA, OOB = (META + dt.timedelta(days=1)).strftime('%Y.%m.%d'), d1
sfx = '' if str(MOD) == '4' else '_ohlc'
def norm(v):
    if v == 'true':
        return '1'
    if v == 'false':
        return '0'
    if re.match(r'^-?[0-9]+(\.[0-9]+)?$', v):
        f = float(v)
        return str(int(f)) if f == int(f) else repr(f)
    return v
pins_w = [(k, v) for (k, v) in pins if k != sc.get('col_absent')]
hdr = ['Pass', 'Profit', 'Expected Payoff', 'Profit Factor', 'Recovery Factor', 'Sharpe Ratio', 'Equity DD %', 'Trades', 'Peggior Giornata %',
       'Perdite Consecutive Max', 'Serie Perdente Peggiore', ak] + [k for k, _ in pins_w] + ['InpNewsCurrencies']
legs = sc.get('legs', ['ok', 'ok'])
def write_csv(fase, stato):
    if stato != 'ok' and not sc.get('csv_anyway'):
        return None
    if sc.get('no_%s' % fase):
        return None
    fn = J(wdir, 'risultati_prove\\' + EA + '\\' + EA + '_' + SIM + '_' + fase + sfx + '_' + LBL + '.csv')
    if sc.get('real_csv'):
        # i CSV VERI di R270e (28/09, stesso EA e finestra, asse InpTP1_R e InpCloseHour=17 pinnato). 'patch' = li si porta alla forma
        # che DAXAP02 deve produrre (InpTP1_R=1 e InpMagic=798102 in ogni riga, InpCloseHour 11/13/15/17); senza patch e' il caso "pin perso".
        src = os.path.join(REPO, 'backtest_pipeline', 'risultati_archivio', 'ROUND_R270_USCITA_DAX_2026-09-28', 'ROUND_R270e', 'ABTG_DAX_Apertura_EU_D30EUR_%s_R270e.csv' % fase)
        rows = list(csv.reader(open(src, encoding='ascii', newline='')))
        if sc['real_csv'] == 'patch':
            h = rows[0]; it = h.index('InpTP1_R'); ic = h.index('InpCloseHour'); im = h.index('InpMagic')
            for n, r in enumerate(rows[1:]):
                r[it] = '1'; r[ic] = str([17, 11, 13, 15][n]); r[im] = '798102'
        with open(fn, 'w', newline='', encoding='ascii') as f:
            csv.writer(f, lineterminator='\r\n').writerows(rows)
        return fn
    if sc.get('csv_zero'):
        open(fn, 'wb').close()
        return fn
    with open(fn, 'w', newline='', encoding='ascii') as f:
        w = csv.writer(f, lineterminator='\r\n')
        w.writerow(hdr)
        for i, v in enumerate(vals):
            if sc.get('una_riga') and i == 3:
                break
            ntr = 0 if (sc.get('trades0') and i == 1) else 150 + 10 * i
            row = [str(i), '%.2f' % (1000.0 + 37.11 * v), '21.00000', '%.5f' % (1.1 + 0.01 * v), '0.70000', '3.00000', '%.4f' % (5.0 + 0.1 * v), str(ntr),
                   '-1.0764', '-3244', '-3243.90', str(v)]
            for k, pv in pins_w:
                if k == sc.get('pin_bad'):
                    row.append('0' if norm(pv) != '0' else '1')
                else:
                    row.append(norm(pv))
            row.append('')
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
def hms():
    n = dt.datetime.now()
    return n.strftime('%H:%M:%S.') + '%03d' % (n.microsecond // 1000)
def leg_lines(stato, fase, ea_name):
    L = ['RP\t0\t%s\tTester\t"%s.ex5" X64' % (hms(), ea_name), 'DF\t0\t%s\tTester\tregister MQL5.community account and use MQL5 Cloud Network to speed up optimizations' % hms()]
    if stato == 'ok':
        a_, b_ = (ISA, ISB) if fase == 'IS' else (OOA, OOB)
        if sc.get('win_bad') and fase == 'OOS':
            b_ = (dt.datetime.strptime(b_, '%Y.%m.%d') - dt.timedelta(days=1)).strftime('%Y.%m.%d')
        L.append('GD\t0\t%s\tTester\tExperts\\%s.ex5 on %s,%s from %s 00:00 to %s 00:00' % (hms(), ea_name, SIM, TF, a_, b_))
        L.append('JS\t0\t%s\tTester\tcomplete optimization started' % hms())
        L.append('RR\t0\t%s\tTester\toptimization finished, total passes %d' % (hms(), len(vals)))
    else:
        for i in range(5):
            L.append('DJ\t3\t%s\tTester\tOnTesterInit works too long...' % hms())
        L.append('RI\t3\t%s\tTester\tOnTesterInit works too long. Tester cannot be initialized.' % hms())
    return L
files = []
if sc.get('tlog') == 'vuoto':
    os.makedirs(os.path.dirname(TL), exist_ok=True); open(TL, 'wb').close()
if sc.get('prima'):
    # due gambe di una corsa PRECEDENTE dello stesso giorno (00:00:01, prima dell avvio di qualunque riga): una morta e una partita
    _w16(TL, ['NS\t0\t00:00:01.000\tTester\t"ABTG_DAX_Apertura_EU.ex5" X64'] + ['RI\t3\t00:00:27.000\tTester\tOnTesterInit works too long. Tester cannot be initialized.'] +
         ['NS\t0\t00:01:01.000\tTester\t"ABTG_DAX_Apertura_EU.ex5" X64', 'GD\t0\t00:01:03.000\tTester\tExperts\\ABTG_DAX_Apertura_EU.ex5 on D30EUR,M5 from 2024.09.26 00:00 to 2025.06.09 00:00'])
for i, fase in enumerate(['IS', 'OOS']):
    stato = legs[i]
    time.sleep(float(sc.get('sleep', 0.1)))
    if not sc.get('tlog') and not sc.get('no_logs'):
        _w16(TL, leg_lines(stato, fase, sc.get('ea_other', EA) if i == 0 else EA))
    files.append(write_csv(fase, stato))
    time.sleep(0.15)
mg = [v for k, v in pins if k == 'InpMagic'][0]
if sc.get('pertrade', True):
    cf = os.path.join(AP, 'MetaQuotes', 'Terminal', 'Common', 'Files'); os.makedirs(cf, exist_ok=True)
    pf = os.path.join(cf, 'abtg_trades_%s_%s_%s.csv' % (EA, SIM, mg))
    cts = sc.get('pertrade_ct', ['2025.06.11 10:23:12', '2025.06.12 15:32:17', '2026.06.25 09:19:38'])
    with open(pf, 'w', newline='', encoding='ascii') as f:
        f.write('close_time;symbol;magic;position_id;deal_type;volume;price;net_profit\r\n')
        for i, ct in enumerate(cts):
            f.write('%s;%s;%s;%d;1;11.50;24055.60;117.30\r\n' % (ct, SIM, sc.get('pertrade_mg', mg), 2 + i))
    if sc.get('pertrade_stale'):
        _t = time.time() - 3600
        os.utime(pf, (_t, _t))
if sc.get('extra_leg') and not sc.get('tlog'):
    _w16(TL, leg_lines('ok', 'OOS', EA))
d = os.path.join(DSK, 'ROUND_' + LBL); os.makedirs(d, exist_ok=True)
if not sc.get('ref_absent'):
    mac = os.environ.get('COMPUTERNAME', '')
    term = sc.get('ref_term', 'C:\\Program Files\\BCM Markets MT5 Terminal\\terminal64.exe')
    R = ['REFERTO ROUND SUL TERMINALE DA BACKTEST', 'marcatore riga  : MARCATORE_RIGA_ROUND_VPS_v2', 'marcatore driver: MARCATORE_WALKFORWARD_GENERICO_v5_INCLUDE',
         'pin             : ' + PIN, 'data            : ' + dt.datetime.now().strftime('%Y-%m-%d %H:%M:%S') + "   <-- SE QUESTA DATA NON E' DI OGGI, IL FILE E' VECCHIO",
         'macchina        : ' + mac + '   (bersaglio ammesso qui: C:\\Program Files\\BCM Markets MT5 Terminal, conto 50503392)',
         'terminale       : ' + term, 'tetto barre     : MaxBars=100000000', '', 'EA              : ' + EA, 'file prova      : ' + PROVA + '   (1 byte, dal pin)',
         'etichetta       : ' + LBL, 'simbolo         : ' + SIM, 'periodo         : ' + TF, 'da quando       : ' + d0,
         'modello         : ' + str(MOD) + ('  (tick reali)' if str(MOD) == '4' else '  (NON tick reali: screening, non verdetto)'), 'deposito        : ' + str(DEP),
         'rc del driver   : 0   (informativo)', '', 'ESITO: ROUND GIRATO']
    open(os.path.join(d, 'REFERTO_ROUND_' + LBL + '.txt'), 'w', newline='').write('\r\n'.join(R))
for f_ in files:
    if f_ and os.path.exists(f_):
        shutil.copy(f_, os.path.join(d, os.path.basename(f_)))
shutil.copy(J(wdir, 'prove\\' + PROVA), os.path.join(d, PROVA))
rcdef = 0 if all(x == 'ok' for x in legs) else 2
sys.exit(int(sc.get('rc', rcdef)))
