#!/usr/bin/env python3
# -*- coding: ascii -*-
# Stub di `powershell.exe -File RIGA_ROUND_VPS_RETRY.ps1` per la riga LATI (QUATTRO job, UNA tranche ciascuno). Scrive gli stessi artefatti del driver con la riprova nel formato VERO
# (stesso schema dello stub di EMAGEM2, adattato alla gamba OOS DEGENERE di @FRAZIONEIS 1.0):
#   - copie di lavoro (src_prove\EA.mq5, src_include\ABTG_PausaGuardian.mqh, walkforward_generico_RETRY.ps1, prove\<file prova>);
#   - CSV _IS di OptFrame con le DUE celle dell asse (InpAllowShort o InpAllowLong 0/1; ordine dei Pass NON ordinato). Job A2: i numeri VERI di R110 (prove/R110_CSV_EMADOW, OOS: 00_metro per
#     la L+S, 01_long / 02_short per le pure, scritti da MT5 il 26/08, NON da noi: classe 1020); job A1: numeri sintetici di leggi_lati.A1_NUM (L+S identica nei due file, tutti distinti da R110);
#   - il CSV _OOS: DEGENERE, da 0 byte come lo lascia OnTesterDeinit senza frame (R264a) o assente ('oos_csv': 'none'); 'oos_csv': 'righe' = un CSV con righe (contraddizione);
#   - giornale del tester UTF-16 con le righe vere, UNA intestazione per tentativo; la gamba OOS degenere come l ha scritta MT5 il 27/09/2026 su questo PC (R263e: intestazione,
#     register, 'set mode to math calculations or adjust testing dates' gravita 2, frame started/stopped, NESSUNA riga from/to);
#   - risultati_prove\<EA>\RIPROVE_<EA>_<SIM>_<etichetta>.txt nelle righe del driver VERO (le due righe GAMBA sono quelle di collaudo_riga_LATI/riprove_veri, scritte dal driver vero);
#   - per-trade in Common\Files (UNO per magic, ';');
#   - cartella ROUND_<etichetta> sul Desktop con REFERTO_ROUND_<etichetta>.txt (con la riga ESITO finale NON MISURATO -- CSV mancanti o vuoti: OOS), i CSV, il file prova e il RIPROVE;
#   - la console: la riga 'Pass 0 Profit 1.00 STUBNUM <etichetta>' come quella del driver (classe 1092: lo stub NON e muto).
# Deposito, modello, pin, MaxRiprove, attesa e scadenza del referto sono QUELLI RICEVUTI. Lo scenario JSON ha le chiavi globali e, per job, un sotto-dizionario con l etichetta che le sovrascrive.
# Gambe IS: 'ok' | 'ko' (morta, nessuna riprova: oltre la scadenza) | 'ko_ok' (morta e salvata al tentativo 2) | 'ko_ko' (morta due volte) | 'altro' (MORTA_ALTRO).
# Manopole: 'patch' [{ax (0/1), col, val}] riscrive UNA cella del CSV IS dopo la lettura dei numeri; 'oos' ('deg' | 'partita' | 'morta' | 'nv2' | 'nessuna') = come va la gamba OOS; 'oos_csv' ('zero' | 'none' | 'righe');
# 'ref_esito' (riga ESITO del referto); 'rc'; 'pin_over'; 'pin_bad'; 'col_absent'; 'ax_vals'; 'trades0'; 'una_riga'; 'csv_stale'; 'tlog'; 'no_logs'; 'prima'; ... (come EMAGEM2).
import sys, os, re, csv, json, shutil, time, datetime as dt
REPO = os.environ.get('REPO_ROOT', '/home/user/GITHUB')
sys.path.insert(0, os.path.join(REPO, 'backtest_pipeline'))
import leggi_lati as LG
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
sc = {k: v for k, v in S0.items() if not k.startswith('LATIA')}
sc.update(S0.get(LBL, {}))
SIG = {'LATIA2L': 'A2L', 'LATIA2S': 'A2S', 'LATIA1L': 'A1L', 'LATIA1S': 'A1S'}[LBL]
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
wf = open(os.path.join(REPO, 'backtest_pipeline/walkforward_generico_RETRY.ps1'), 'rb').read()
if sc.get('mut_wf'):
    wf += b'\n#x'
if sc.get('wf_originale'):
    wf = open(os.path.join(REPO, 'backtest_pipeline/walkforward_generico.ps1'), 'rb').read()
if not sc.get('no_wf'):
    open(J(wdir, 'walkforward_generico_RETRY.ps1'), 'wb').write(wf)
open(J(wdir, 'walkforward_generico.ps1'), 'wb').write(open(os.path.join(REPO, 'backtest_pipeline/walkforward_generico.ps1'), 'rb').read())
if sc.get('mut_drvloc'):
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
vals = list(range(a0, a2 + 1, a1))                  # [0, 1]
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
k_bad = sc.get('pin_bad')
# i numeri delle due celle: A2 = R110 veri; A1 = sintetici di leggi_lati
def numeri(ax):
    if SIG[1] == '2':
        cella = {'0': ('01_long' if SIG == 'A2L' else '02_short'), '1': '00_metro'}[str(ax)]
        r = list(csv.DictReader(open(os.path.join(REPO, 'backtest_pipeline', 'prove', 'R110_CSV_EMADOW', 'ABTG_EMA200_U30USD_OOS_%s.csv' % cella), encoding='ascii', newline='')))[0]
        return [r['Profit'], r['Expected Payoff'], r['Profit Factor'], r['Recovery Factor'], r['Sharpe Ratio'], r['Equity DD %'], r['Trades']]
    return list({'0': LG.A1_NUM['L'] if SIG == 'A1L' else LG.A1_NUM['S'], '1': LG.A1_NUM['ls']}[str(ax)])
def write_is():
    if sc.get('no_IS'):
        return None
    fn = J(wdir, 'risultati_prove\\' + EA + '\\' + EA + '_' + SIM + '_IS' + sfx + '_' + LBL + '.csv')
    if sc.get('csv_zero'):
        open(fn, 'wb').close()
        return fn
    with open(fn, 'w', newline='', encoding='ascii') as f:
        w = csv.writer(f, lineterminator='\r\n')
        w.writerow(hdr)
        for i, v in enumerate(vals):
            if sc.get('una_riga') and i == len(vals) - 1:
                break
            num = list(numeri(v)) if str(v) in ('0', '1') else list(numeri(0))
            for p_ in sc.get('patch', []):
                if str(p_['ax']) == str(v):
                    num[LG.G1_COLONNE.index(p_['col'])] = p_['val']
            if sc.get('trades0') and i == 1:
                num[6] = '0'
            row = [str(i)] + num + [str(v)]
            for k, pv in pins_w:
                if k in sc.get('pin_over', {}):
                    row.append(sc['pin_over'][k])
                elif k == sc.get('pin_bad'):
                    row.append('0' if norm(pv) != '0' else '1')
                else:
                    row.append(norm(pv))
            row.append('')
            w.writerow(row)
    if sc.get('csv_stale'):
        _t = time.time() - 600
        os.utime(fn, (_t, _t))
    return fn
def write_oos():
    mod = sc.get('oos_csv', 'zero')
    if mod == 'none':
        return None
    fn = J(wdir, 'risultati_prove\\' + EA + '\\' + EA + '_' + SIM + '_OOS' + sfx + '_' + LBL + '.csv')
    if mod == 'zero':
        open(fn, 'wb').close()
    else:
        with open(fn, 'w', newline='', encoding='ascii') as f:
            w = csv.writer(f, lineterminator='\r\n'); w.writerow(hdr)
            for i, v in enumerate(vals):
                w.writerow([str(i)] + list(numeri(v)) + [str(v)] + [norm(pv) for k, pv in pins_w] + [''])
    if sc.get('oos_stale'):
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
    L = ['RP\t0\t%s\tTester\t"%s.ex5" X64' % (hms(), ea_name), 'DF\t0\t%s\tTester\tregister MQL5.community account and use MQL5 Cloud Network to speed up optimizations' % hms()]
    if esito == 'PARTITA':
        a_, b_ = (ISA, ISB) if fase == 'IS' else (OOA, OOB)
        if sc.get('retry_win_oos') and RETRY_N[0] == 2:
            a_, b_ = '2020.01.01', '2020.02.01'
        if sc.get('win_bad') and fase == 'IS':
            b_ = (dt.datetime.strptime(b_, '%Y.%m.%d') - dt.timedelta(days=1)).strftime('%Y.%m.%d')
        L.append('GD\t0\t%s\tTester\tExperts\\%s.ex5 on %s,%s from %s 00:00 to %s 00:00' % (hms(), ea_name, SIM, TF, a_, b_))
        L.append('JS\t0\t%s\tTester\tcomplete optimization started' % hms())
        L.append('RR\t0\t%s\tTester\toptimization finished, total passes %d' % (hms(), len(vals)))
        s = "PARTITA (from %s 00:00 to %s 00:00 su %s: finestra = dichiarata); CSV: presente (%d righe)" % (a_, b_, SIM, len(vals))
    elif esito == 'DEGENERE':
        L.append('JQ\t2\t%s\tTester\tset mode to math calculations or adjust testing dates' % hms())
        L.append('MJ\t0\t%s\tExperts\toptimization frame expert %s (%s,%s) processing started' % (hms(), ea_name, SIM, TF))
        L.append('EG\t0\t%s\tExperts\toptimization frame expert %s (%s,%s) processing stopped' % (hms(), ea_name, SIM, TF))
        s = "NON_VERIFICABILE (intestazione della gamba presente, ma ne' 'from ... to ...' ne' 'Tester cannot be initialized': fine non leggibile (errore di dati, di .ini o dell'EA?)); CSV: %s" % ('presente (-1 righe)' if sc.get('oos_csv', 'zero') != 'none' else 'assente')
    elif esito == 'MORTA_INIT' and sc.get('dead_nocause') == fase:
        hm = hms()
        L.append('RI\t3\t%s\tTester\tTester cannot be initialized.' % hm)
        s = "MORTA_INIT (5 righe 'OnTesterInit works too long', fatale alle %s); CSV: assente" % hm
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
    _w16(TL, ['NS\t0\t00:00:01.000\tTester\t"%s.ex5" X64' % EA] + ['RI\t3\t00:00:27.000\tTester\tOnTesterInit works too long. Tester cannot be initialized.'] +
         ['NS\t0\t00:01:01.000\tTester\t"%s.ex5" X64' % EA, 'GD\t0\t00:01:03.000\tTester\tExperts\\%s.ex5 on U30USD,H1 from 2025.06.10 00:00 to 2026.06.30 00:00' % EA])
files = []; RR = []; riprovate = []; RETRY_N = [0]
SEQ = {'ok': ['PARTITA'], 'ko': ['MORTA_INIT'], 'ko_ok': ['MORTA_INIT', 'PARTITA'], 'ko_ko': ['MORTA_INIT', 'MORTA_INIT'], 'altro': ['MORTA_ALTRO']}
isseq = SEQ[legs[0]]
tt = []
for n, es in enumerate(isseq):
    RETRY_N[0] = n + 1
    time.sleep(float(sc.get('sleep', 0.1)))
    Lg, s = attempt(es, 'IS', sc.get('ea_other', EA) if n == 0 else EA)
    if not sc.get('tlog') and not sc.get('no_logs') and not (sc.get('rp_fake_retry') == 'IS' and n == 0):
        _w16(TL, Lg)
    tt.append('tentativo %d -> %s' % (n + 1, s))
    time.sleep(0.15)
if isseq[-1] == 'MORTA_INIT':
    tt.append("nessuna riprova: " + ("gia' riprovata 1 volta: il massimo e' 1 per gamba" if len(isseq) > 1 else "oltre la scadenza -RiprovaEntro: il tetto della riga non si allunga"))
f_is = write_is() if (isseq[-1] == 'PARTITA' or sc.get('csv_anyway')) else None
eg = 'CSV PRODOTTO' if (isseq[-1] == 'PARTITA' and f_is and os.path.exists(f_is)) else 'CSV NON PRODOTTO'
if sc.get('rp_dice_prodotto') == 'IS':
    eg = 'CSV PRODOTTO'
rip = ' | RIPROVATA' if (len(isseq) > 1 and sc.get('rp_no_rip') != 'IS') else ''
RR.append('GAMBA IS  | %s%s | ESITO GAMBA: %s%s' % (' | '.join(tt), rip, eg, (' AL TENTATIVO %d' % len(isseq)) if (len(isseq) > 1 and eg == 'CSV PRODOTTO') else ''))
if len(isseq) > 1:
    riprovate.append('IS')
# la gamba OOS: DEGENERE (default, come l ha scritta MT5 il 27/09 e come l ha classificata il driver vero), o altro (contro-esempi)
oos = sc.get('oos', 'deg')
time.sleep(0.1)
if oos == 'nessuna':
    pass
else:
    es_o = {'deg': 'DEGENERE', 'partita': 'PARTITA', 'morta': 'MORTA_INIT', 'nv2': 'DEGENERE'}[oos]
    Lo, so = attempt(es_o, 'OOS', EA)
    if not sc.get('tlog') and not sc.get('no_logs'):
        _w16(TL, Lo)
    if oos == 'nv2':
        Lo2, so2 = attempt('DEGENERE', 'OOS', EA)
        if not sc.get('tlog') and not sc.get('no_logs'):
            _w16(TL, Lo2)
        so = so + ' | tentativo 2 -> ' + so2.replace('NON_VERIFICABILE', 'NON_VERIFICABILE', 1)
    f_oos = write_oos()
    files.append(f_oos)
    ego = 'CSV PRODOTTO' if (f_oos and os.path.exists(f_oos)) else 'CSV NON PRODOTTO'
    if sc.get('rp_oos_dice') == 'prodotto':
        ego = 'CSV PRODOTTO'
    if sc.get('rp_oos_dice') == 'nonprodotto':
        ego = 'CSV NON PRODOTTO'
    rowo = 'GAMBA OOS | tentativo 1 -> %s | ESITO GAMBA: %s' % (so, ego)
    if sc.get('rp_oos_rip'):
        rowo = 'GAMBA OOS | tentativo 1 -> %s | RIPROVATA | ESITO GAMBA: %s' % (so, ego)
    RR.append(rowo)
files.insert(0, f_is)
mgs = [v for k, v in pins if k == 'InpMagic']
if sc.get('pertrade', True) and f_is:
    cf = os.path.join(AP, 'MetaQuotes', 'Terminal', 'Common', 'Files'); os.makedirs(cf, exist_ok=True)
    for mg in mgs:
        pf = os.path.join(cf, 'abtg_trades_%s_%s_%s.csv' % (EA, SIM, mg))
        cts = sc.get('pertrade_ct', ['2025.06.11 08:23:12', '2025.06.12 15:32:17', '2026.06.25 09:19:38'] if SIG[1] == '2' else ['2025.02.04 08:23:12', '2025.03.12 15:32:17', '2025.04.25 09:19:38'])
        with open(pf, 'w', newline='', encoding='ascii') as f:
            f.write('close_time;symbol;magic;position_id;deal_type;volume;price;net_profit\r\n')
            for i, ct in enumerate(cts):
                f.write('%s;%s;%s;%d;0;3.50;24055.60;117.30\r\n' % (ct, SIM, sc.get('pertrade_mg', mg), 2 + i))
        if sc.get('pertrade_stale'):
            _t = time.time() - 3600
            os.utime(pf, (_t, _t))
if sc.get('extra_leg') and not sc.get('tlog'):
    _w16(TL, attempt('PARTITA', 'IS', EA)[0])
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
esito_ref = sc.get('ref_esito', 'NON MISURATO -- CSV mancanti o vuoti: OOS' if (isseq[-1] == 'PARTITA') else 'NON MISURATO -- CSV mancanti o vuoti: IS, OOS')
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
         '--- RIPROVE DEL DRIVER (gambe RIPROVATE: %d) ---' % len(riprovate)] + ['  ' + x for x in RR] + ['', 'RILIEVI: 0', '', 'ESITO: ' + esito_ref]
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
print("--- I NUMERI, COSI' COME SONO USCITI ---"); print('    Pass 0    Profit 1.00    STUBNUM ' + LBL); sys.stdout.flush()
sys.exit(int(sc.get('rc', 2)))
