#!/usr/bin/env python3
# -*- coding: ascii -*-
# Stub di `powershell.exe -File RIGA_ROUND_VPS_RETRY.ps1` per la riga DAXAP03 (DUE job). Scrive gli stessi artefatti del driver con la
# riprova, nel formato VERO:
#   - copie di lavoro (src_prove\EA.mq5, src_include\ABTG_PausaGuardian.mqh, walkforward_generico_RETRY.ps1, prove\<file prova>);
#   - CSV _IS/_OOS di OptFrame con la colonna dell'asse PRIMA e poi tutti gli input (bool -> 1/0, piu' InpNewsCurrencies che il file
#     prova non ha), come i CSV veri di R246i (risultati_archivio/R246/ROUND_R246i, stesso EA, 24/09); opzionale: i CSV VERI di R246i;
#   - giornale del tester UTF-16 con le righe vere, UNA intestazione per TENTATIVO (una gamba riprovata = 2 intestazioni, classe 1030);
#   - risultati_prove\<EA>\RIPROVE_<EA>_<SIM>_<etichetta>.txt nelle righe di walkforward_generico_RETRY.ps1 (GAMBA IS  | tentativo 1 -> ...
#     | RIPROVATA | ESITO GAMBA: CSV PRODOTTO AL TENTATIVO 2), copiato nella cartella ROUND_<etichetta> se fresco, come fa la riga RETRY;
#   - per-trade degli agenti in Common\Files (abtg_trades_<EA>_<SIM>_<magic>.csv, ';');
#   - cartella ROUND_<etichetta> sul Desktop con REFERTO_ROUND_<etichetta>.txt nelle righe della riga RETRY (pin/macchina/terminale/
#     deposito/modello/driver/riprova), i due CSV, il file prova e il RIPROVE.
# Deposito, modello, pin, MaxRiprove, attesa e scadenza del referto sono QUELLI RICEVUTI (default del driver vero se mancano).
# Lo scenario JSON ha le chiavi globali e, per job, un sotto-dizionario con il nome dell'etichetta (DAXAP03a / DAXAP03b) che le sovrascrive.
# Gambe: 'ok' | 'ko' (morta, nessuna riprova: oltre la scadenza) | 'ko_ok' (morta e salvata al tentativo 2) | 'ko_ko' (morta due volte)
#        | 'altro' (Tester cannot be initialized con una causa diversa: MORTA_ALTRO, nessuna riprova).
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
MAXR = arg('-MaxRiprove', '1'); ATT = arg('-AttesaRiprovaSec', '20'); SCAD = arg('-RiprovaEntro', '')
UP = os.environ['USERPROFILE']; AP = os.environ['APPDATA']; DSK = os.environ['DESKTOP_DIR']
S0 = json.load(open(os.environ['SCENARIO']))
sc = {k: v for k, v in S0.items() if not k.startswith('DAXAP03')}
sc.update(S0.get(LBL, {}))
wdir = os.path.join(UP, 'abtg_round')
log = open(os.environ['HARNESS_LOG'], 'a'); log.write('STUB %s %s modello=%s dep=%s pin=%s argv=%s\n' % (LBL, PROVA, MOD, DEP, PIN, ' | '.join(a))); log.close()
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
# il driver di walk-forward CON LA RIPROVA (e, accanto, l'originale delle righe vecchie: NON e' lui che si controlla)
wf = open(os.path.join(REPO, 'backtest_pipeline/walkforward_generico_RETRY.ps1'), 'rb').read()
if sc.get('mut_wf'):
    wf += b'\n#x'
if sc.get('wf_originale'):
    wf = open(os.path.join(REPO, 'backtest_pipeline/walkforward_generico.ps1'), 'rb').read()
if not sc.get('no_wf'):
    open(J(wdir, 'walkforward_generico_RETRY.ps1'), 'wb').write(wf)
open(J(wdir, 'walkforward_generico.ps1'), 'wb').write(open(os.path.join(REPO, 'backtest_pipeline/walkforward_generico.ps1'), 'rb').read())
if sc.get('mut_drvloc'):
    # qualcuno (un altro processo) riscrive la copia locale della riga RETRY durante il job
    with open(J(wdir, 'RIGA_ROUND_VPS_RETRY.ps1'), 'ab') as f:
        f.write(b'\n# mutato durante il job\n')
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
vals = list(range(a0, a2 + 1, a1))
vals = [vals[-1]] + vals[:-1]                       # ordine dei Pass NON ordinato per asse: la riga deve ordinare da se
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
hdr = ['Pass', 'Profit', 'Expected Payoff', 'Profit Factor', 'Recovery Factor', 'Sharpe Ratio', 'Equity DD %', 'Trades', ak] + [k for k, _ in pins_w] + ['InpNewsCurrencies']
legs = sc.get('legs', ['ok', 'ok'])
def write_csv(fase):
    if sc.get('no_%s' % fase):
        return None
    fn = J(wdir, 'risultati_prove\\' + EA + '\\' + EA + '_' + SIM + '_' + fase + sfx + '_' + LBL + '.csv')
    if sc.get('real_csv'):
        # i CSV VERI di R246i (24/09, stesso EA e finestra, 2 righe con asse tecnico InpMagic 794621/794671, InpPlaceHour 7, InpPlaceMin 59).
        # 'patch' = portati alla forma che il job deve produrre (una riga per cella, InpPlaceMin dell'asse, InpPlaceHour e magic del file);
        # 'pin_perso' = una riga per cella e il magic giusto, ma InpPlaceMin resta 59 e InpPlaceHour 7 dappertutto (il caso "pin non arrivato").
        src = os.path.join(REPO, 'backtest_pipeline', 'risultati_archivio', 'R246', 'ROUND_R246i', 'ABTG_MaxMinNotte_DAX_Short_Ottimizzato_D30EUR_%s_R246i.csv' % fase)
        rows = list(csv.reader(open(src, encoding='ascii', newline='')))
        h = rows[0]; ipm = h.index('InpPlaceMin'); iph = h.index('InpPlaceHour'); im = h.index('InpMagic')
        mg = [v for k, v in pins if k == 'InpMagic'][0]; ph = [v for k, v in pins if k == 'InpPlaceHour'][0]
        out = [h]
        for n, v in enumerate(vals):
            r = list(rows[1 + (n % (len(rows) - 1))]); r[0] = str(n); r[im] = mg
            if sc['real_csv'] == 'patch':
                r[ipm] = str(v); r[iph] = ph
            out.append(r)
        with open(fn, 'w', newline='', encoding='ascii') as f:
            csv.writer(f, lineterminator='\r\n').writerows(out)
        return fn
    if sc.get('csv_zero'):
        open(fn, 'wb').close()
        return fn
    with open(fn, 'w', newline='', encoding='ascii') as f:
        w = csv.writer(f, lineterminator='\r\n')
        w.writerow(hdr)
        for i, v in enumerate(vals):
            if sc.get('una_riga') and i == len(vals) - 1:
                break
            ntr = 0 if (sc.get('trades0') and i == 1) else 18 + i
            row = [str(i), '%.2f' % (4000.0 + 37.11 * v), '238.34800', '%.5f' % (1.8 + 0.001 * v), '1.52059', '16.05348', '%.4f' % (3.0 + 0.01 * v), str(ntr), str(v)]
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
def attempt(esito, fase, ea_name):
    # le righe del giornale di UN tentativo, e la stringa del tentativo come la scrive TestoTentativo del driver
    L = ['RP\t0\t%s\tTester\t"%s.ex5" X64' % (hms(), ea_name), 'DF\t0\t%s\tTester\tregister MQL5.community account and use MQL5 Cloud Network to speed up optimizations' % hms()]
    if esito == 'PARTITA':
        a_, b_ = (ISA, ISB) if fase == 'IS' else (OOA, OOB)
        if sc.get('win_bad') and fase == 'OOS':
            b_ = (dt.datetime.strptime(b_, '%Y.%m.%d') - dt.timedelta(days=1)).strftime('%Y.%m.%d')
        L.append('GD\t0\t%s\tTester\tExperts\\%s.ex5 on %s,%s from %s 00:00 to %s 00:00' % (hms(), ea_name, SIM, TF, a_, b_))
        L.append('JS\t0\t%s\tTester\tcomplete optimization started' % hms())
        L.append('RR\t0\t%s\tTester\toptimization finished, total passes %d' % (hms(), len(vals)))
        s = "PARTITA (from %s to %s su %s: finestra = dichiarata); CSV: presente (%d righe)" % (a_, b_, SIM, len(vals))
    elif esito == 'MORTA_INIT':
        for i in range(5):
            L.append('DJ\t3\t%s\tTester\tOnTesterInit works too long...' % hms())
        hm = hms()
        L.append('RI\t3\t%s\tTester\tOnTesterInit works too long. Tester cannot be initialized.' % hm)
        s = "MORTA_INIT (5 righe 'OnTesterInit works too long', fatale alle %s); CSV: assente" % hm
    else:
        L.append('RI\t3\t%s\tTester\tOnTesterInit returned non-zero code 1. Tester cannot be initialized.' % hms())
        s = "MORTA_ALTRO (fatale senza la causa OnTesterInit works too long sulla stessa riga); CSV: assente"
    return L, s + "; giornale: %d righe in questo tentativo, 0 di prima ignorate; cache: nessuna riga 'saved to cache file'" % len(L)
if sc.get('tlog') == 'vuoto':
    os.makedirs(os.path.dirname(TL), exist_ok=True); open(TL, 'wb').close()
if sc.get('prima'):
    # due gambe di una corsa PRECEDENTE dello stesso giorno (00:00:01, prima dell avvio di qualunque riga): una morta e una partita
    _w16(TL, ['NS\t0\t00:00:01.000\tTester\t"%s.ex5" X64' % EA] + ['RI\t3\t00:00:27.000\tTester\tOnTesterInit works too long. Tester cannot be initialized.'] +
         ['NS\t0\t00:01:01.000\tTester\t"%s.ex5" X64' % EA, 'GD\t0\t00:01:03.000\tTester\tExperts\\%s.ex5 on D30EUR,M15 from 2024.09.26 00:00 to 2025.06.09 00:00' % EA])
files = []; RR = []; riprovate = []
SEQ = {'ok': ['PARTITA'], 'ko': ['MORTA_INIT'], 'ko_ok': ['MORTA_INIT', 'PARTITA'], 'ko_ko': ['MORTA_INIT', 'MORTA_INIT'], 'altro': ['MORTA_ALTRO']}
for i, fase in enumerate(['IS', 'OOS']):
    seq = SEQ[legs[i]]
    tt = []
    for n, es in enumerate(seq):
        time.sleep(float(sc.get('sleep', 0.1)))
        Lg, s = attempt(es, fase, sc.get('ea_other', EA) if (i == 0 and n == 0) else EA)
        if not sc.get('tlog') and not sc.get('no_logs'):
            _w16(TL, Lg)
        tt.append('tentativo %d -> %s' % (n + 1, s))
        time.sleep(0.15)
    if seq[-1] == 'MORTA_INIT':
        tt.append("nessuna riprova: " + ("gia' riprovata 1 volta: il massimo e' 1 per gamba" if len(seq) > 1 else "oltre la scadenza -RiprovaEntro: il tetto della riga non si allunga"))
    f_ = write_csv(fase) if (seq[-1] == 'PARTITA' or sc.get('csv_anyway')) else None
    files.append(f_)
    # ESITO GAMBA come lo scrive il driver; csv_anyway = un CSV fresco che il driver NON ha dichiarato (la contraddizione da prendere)
    eg = 'CSV PRODOTTO' if (seq[-1] == 'PARTITA' and f_ and os.path.exists(f_)) else 'CSV NON PRODOTTO'
    if sc.get('rp_dice_prodotto') == fase:
        eg = 'CSV PRODOTTO'
    rip = ' | RIPROVATA' if len(seq) > 1 else ''
    RR.append('GAMBA %s | %s%s | ESITO GAMBA: %s%s' % (fase.ljust(3), ' | '.join(tt), rip, eg, (' AL TENTATIVO %d' % len(seq)) if (len(seq) > 1 and eg == 'CSV PRODOTTO') else ''))
    if len(seq) > 1:
        riprovate.append(fase)
mg = [v for k, v in pins if k == 'InpMagic'][0]
if sc.get('pertrade', True) and any(f for f in files):
    cf = os.path.join(AP, 'MetaQuotes', 'Terminal', 'Common', 'Files'); os.makedirs(cf, exist_ok=True)
    pf = os.path.join(cf, 'abtg_trades_%s_%s_%s.csv' % (EA, SIM, mg))
    cts = sc.get('pertrade_ct', ['2025.06.11 08:23:12', '2025.06.12 15:32:17', '2026.06.25 09:19:38'])
    with open(pf, 'w', newline='', encoding='ascii') as f:
        f.write('close_time;symbol;magic;position_id;deal_type;volume;price;net_profit\r\n')
        for i, ct in enumerate(cts):
            f.write('%s;%s;%s;%d;0;3.50;24055.60;117.30\r\n' % (ct, SIM, sc.get('pertrade_mg', mg), 2 + i))
    if sc.get('pertrade_stale'):
        _t = time.time() - 3600
        os.utime(pf, (_t, _t))
if sc.get('extra_leg') and not sc.get('tlog'):
    _w16(TL, attempt('PARTITA', 'OOS', EA)[0])
# il file RIPROVE del driver (sempre scritto, anche con MaxRiprove 0), salvo gli scenari che lo tolgono o lo invecchiano
rpf = J(wdir, 'risultati_prove\\' + EA + '\\RIPROVE_' + EA + '_' + SIM + sfx + '_' + LBL + '.txt')
if not sc.get('rp_absent'):
    righe = ['RIPROVE DEL DRIVER -- MARCATORE_WALKFORWARD_GENERICO_v7_RETRY', 'data       : x', 'pc         : ' + os.environ.get('COMPUTERNAME', ''),
             'EA         : %s   simbolo %s   suffisso \'%s_%s\'' % (EA, SIM, sfx, LBL), 'MaxRiprove : %s   attesa fra i tentativi %s s   scadenza %s' % (MAXR, ATT, SCAD or 'nessuna'),
             'giornale   : x', 'cache      : Tester\\cache NON toccata da questo driver', "si riprova : SOLO 'OnTesterInit works too long. Tester cannot be initialized.' senza CSV, una volta per gamba"]
    rr = list(RR)
    if sc.get('rp_una_gamba'):
        rr = rr[:1]
    righe += rr + ['RIPROVATE  : %d%s' % (len(riprovate), (' (' + ','.join(riprovate) + ')') if riprovate else '')]
    open(rpf, 'w', newline='').write('\r\n'.join(righe))
    if sc.get('rp_stale'):
        _t = time.time() - 3600
        os.utime(rpf, (_t, _t))
d = os.path.join(DSK, 'ROUND_' + LBL); os.makedirs(d, exist_ok=True)
if not sc.get('ref_absent'):
    mac = os.environ.get('COMPUTERNAME', '')
    term = sc.get('ref_term', 'C:\\Program Files\\BCM Markets MT5 Terminal\\terminal64.exe')
    R = ['REFERTO ROUND SUL TERMINALE DA BACKTEST', 'marcatore riga  : MARCATORE_RIGA_ROUND_VPS_RETRY_v1', 'marcatore driver: MARCATORE_WALKFORWARD_GENERICO_v7_RETRY',
         'pin             : ' + PIN, 'data            : ' + dt.datetime.now().strftime('%Y-%m-%d %H:%M:%S') + "   <-- SE QUESTA DATA NON E' DI OGGI, IL FILE E' VECCHIO",
         'macchina        : ' + mac + '   (bersaglio ammesso qui: C:\\Program Files\\BCM Markets MT5 Terminal, conto 50503392)',
         'terminale       : ' + term, 'tetto barre     : MaxBars=100000000', '', 'EA              : ' + EA, 'file prova      : ' + PROVA + '   (1 byte, dal pin)',
         'etichetta       : ' + LBL, 'simbolo         : ' + SIM, 'periodo         : ' + TF, 'da quando       : ' + d0,
         'modello         : ' + str(MOD) + ('  (tick reali)' if str(MOD) == '4' else '  (NON tick reali: screening, non verdetto)'), 'deposito        : ' + str(DEP),
         'rc del driver   : 0   (informativo)',
         'driver          : ' + sc.get('ref_driver', 'walkforward_generico_RETRY.ps1') + '   (con la riprova; Tester\\cache NON toccata)',
         'riprova         : MaxRiprove %s   attesa %s s   scadenza %s' % (MAXR, ATT, SCAD.strip() if SCAD.strip() else 'nessuna'), '',
         '--- RIPROVE DEL DRIVER (gambe RIPROVATE: %d) ---' % len(riprovate)] + ['  ' + x for x in RR] + ['', 'ESITO: ROUND GIRATO']
    open(os.path.join(d, 'REFERTO_ROUND_' + LBL + '.txt'), 'w', newline='').write('\r\n'.join(R))
    if sc.get('ref_stale'):
        _t = time.time() - 3600
        os.utime(os.path.join(d, 'REFERTO_ROUND_' + LBL + '.txt'), (_t, _t))
for f_ in files:
    if f_ and os.path.exists(f_):
        shutil.copy(f_, os.path.join(d, os.path.basename(f_)))
shutil.copy(J(wdir, 'prove\\' + PROVA), os.path.join(d, PROVA))
if os.path.exists(rpf) and not sc.get('rp_stale') and not sc.get('rp_nocopy'):
    shutil.copy(rpf, os.path.join(d, os.path.basename(rpf)))
rcdef = 0 if all(x == 'ok' for x in legs) else (3 if all(SEQ[x][-1] == 'PARTITA' for x in legs) else 2)
sys.exit(int(sc.get('rc', rcdef)))
