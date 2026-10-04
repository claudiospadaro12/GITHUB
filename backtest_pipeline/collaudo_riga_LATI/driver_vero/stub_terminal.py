#!/usr/bin/env python3
# -*- coding: ascii -*-
"""
stub_terminal.py (COPIA ADATTATA per la riga LATI, 04/10/2026) -- finto terminal64.exe per il collaudo di walkforward_generico_RETRY.ps1.
AGGIUNTA: se FromDate > ToDate nell'.ini (la gamba OOS di un file con @FRAZIONEIS 1.0) lo stub scrive la gamba DEGENERE come l'ha scritta MT5 sul PC di backtest il
27/09/2026 (risultati_archivio/ROUND_CORTI_B_2026-09-27/LOG_TESTER/0002_Tester_logs_20260927.log, righe 'FG 09:52:19.462' .. 'GE 09:52:35.045', job R263e): intestazione
'"EA.ex5" X64', 'register MQL5.community ...', 'set mode to math calculations or adjust testing dates' (gravita' 2), 'optimization frame expert ... processing started'
e '... processing stopped', NESSUNA riga 'from ... to ...'; e un CSV da 0 BYTE (come lo lascia OnTesterDeinit di ABTG_EMA200 senza frame: R264a, 28/09, 'CSV DA 0 BYTE';
scenario 'deg_csv': 'none' per non scriverlo).

Il driver lo lancia come lancia MT5:  terminal64.exe /config:"<cartella>\gen_<tag>.ini"
Lo stub legge dall'.ini la gamba (Report=OptReport_<EA>_<SIM>_IS... / _OOS...), FromDate e ToDate, e secondo
SCENARIO (json) per QUESTA gamba e QUESTO tentativo (contatore su disco, per gamba) scrive:
  - il GIORNALE DEL TESTER <DATAFOLDER_STUB>/Tester/logs/AAAAMMGG.log in UTF-16 LE con BOM, righe col TAB e l'ora
    al millisecondo, NEL FORMATO DELLE RIGHE VERE (copiate da risultati_archivio/ROUND_R92BAB_20261001_2201/
    LOG_TESTER/0002_Tester_logs_20261001.log: intestazione '"EA.ex5" X64', 5 righe 'OnTesterInit works too long...'
    poi la fatale; gamba partita = 'Experts\\EA.ex5 on SIM,TF from ... to ...' e 'new records saved to cache file');
  - il CSV OptResults_<EA>_<SIM>.csv in <DATAFOLDER_STUB>/MQL5/Files quando la gamba parte (o quando lo scenario
    lo chiede apposta per costruire la contraddizione).
Stati di un tentativo:
  ok        partita, CSV con 2 righe
  dead      morta in OnTesterInit (5 avvisi + fatale), nessun CSV         -> il driver DEVE riprovare (una volta)
  dead_csv  come dead ma lascia un CSV                                   -> NON deve riprovare (contraddizione)
  altro     'OnTesterInit returned non-zero code 1. Tester cannot be initialized.' (causa diversa) -> NON riprova
  nodata    intestazione + errore di storico, ne' from/to ne' fatale    -> NON riprova
  silent    il terminale non scrive niente nel giornale                  -> NON riprova (NON_VERIFICABILE)
  other_ea  intestazione di UN ALTRO EA + morte in OnTesterInit          -> NON riprova (ANOMALA)
  win_bad   partita ma il tester dichiara una fine diversa (classe 992)  -> PARTITA con finestra DIVERSA
"""
import datetime as dt, json, os, re, sys, time

SCEN = json.load(open(os.environ['SCENARIO']))
DF = os.environ['DATAFOLDER_STUB']
LOG = os.environ['HARNESS_LOG']
CNT = os.environ['STUB_COUNTERS']
args = sys.argv[1:]
ini = None
for a in args:
    if a.lower().startswith('/config:'):
        ini = a[8:].strip().strip('"')
if ini is None:
    open(LOG, 'a').write('TERMINALE senza /config: %r\n' % (args,))
    sys.exit(0)
ini = ini.replace('\\', '/')
txt = open(ini, encoding='ascii', errors='replace').read()
def k(name):
    m = re.search(r'^' + name + r'=(.*)$', txt, re.M)
    return m.group(1).strip() if m else ''
ea = k('Expert')[:-4]
sim = k('Symbol'); per = k('Period'); da = k('FromDate'); a_ = k('ToDate'); rep = k('Report')
leg = 'IS' if re.search(r'_IS(_|$)', rep) else 'OOS'
os.makedirs(CNT, exist_ok=True)
cf = os.path.join(CNT, leg)
n = int(open(cf).read()) + 1 if os.path.exists(cf) else 1
open(cf, 'w').write(str(n))
stati = SCEN.get('legs', {}).get(leg, ['ok'])
stato = stati[n - 1] if n - 1 < len(stati) else stati[-1]
if da > a_:
    stato = 'degenere'
open(LOG, 'a').write('LANCIO %s tentativo %d stato %s ini %s from %s to %s\n' % (leg, n, stato, os.path.basename(ini), da, a_))

TLD = os.path.join(DF, 'Tester', 'logs')
os.makedirs(TLD, exist_ok=True)
def w(lines):
    p = os.path.join(TLD, dt.datetime.now().strftime('%Y%m%d') + '.log')
    with open(p, 'ab') as f:
        if f.tell() == 0:
            f.write(b'\xff\xfe')
        f.write(('\r\n'.join(lines) + '\r\n').encode('utf-16-le'))
def L(code, sev, src, msg):
    time.sleep(0.02)
    nw = dt.datetime.now()
    return '%s\t%d\t%s.%03d\t%s\t%s' % (code, sev, nw.strftime('%H:%M:%S'), nw.microsecond // 1000, src, msg)
def csv_out():
    fd = os.path.join(DF, 'MQL5', 'Files'); os.makedirs(fd, exist_ok=True)
    with open(os.path.join(fd, 'OptResults_%s_%s.csv' % (ea, sim)), 'w', newline='') as f:
        f.write('Pass,Profit,Profit Factor,Equity DD %,Trades\r\n0,100.00,1.30,2.00,5\r\n1,101.00,1.31,2.00,5\r\n')

time.sleep(0.05)
if stato == 'silent':
    sys.exit(0)
righe = [L('QL', 0, 'Tester', 'Cloud servers switched off')]
nome = SCEN.get('altro_ea', 'ABTG_Altro') if stato == 'other_ea' else ea
righe.append(L('LL', 0, 'Tester', '"%s.ex5" X64' % nome))
righe.append(L('ND', 0, 'Tester', 'register MQL5.community account and use MQL5 Cloud Network to speed up optimizations'))
if stato in ('ok', 'win_bad'):
    fine = a_
    if stato == 'win_bad':
        fine = (dt.datetime.strptime(a_, '%Y.%m.%d') - dt.timedelta(days=1)).strftime('%Y.%m.%d')
    righe.append(L('IQ', 0, 'Experts', 'optimization frame expert %s (%s,%s) processing started' % (ea, sim, per)))
    righe.append(L('JM', 0, 'Tester', 'Experts\\%s.ex5 on %s,%s from %s 00:00 to %s 00:00' % (ea, sim, per, da, fine)))
    righe.append(L('IR', 0, 'Tester', 'complete optimization started'))
    righe.append(L('DL', 0, 'Tester', 'optimization finished, total passes 2'))
    righe.append(L('MS', 0, 'Tester', "2 new records saved to cache file 'tester\\cache\\%s.%s.%s.x.opt'" % (ea, sim, per)))
    w(righe)
    csv_out()
elif stato in ('dead', 'dead_csv', 'other_ea'):
    for _ in range(5):
        righe.append(L('PD', 3, 'Tester', 'OnTesterInit works too long...'))
    righe.append(L('JO', 3, 'Tester', 'OnTesterInit works too long. Tester cannot be initialized.'))
    w(righe)
    if stato == 'dead_csv':
        csv_out()
elif stato == 'altro':
    righe.append(L('JO', 3, 'Tester', 'OnTesterInit returned non-zero code 1. Tester cannot be initialized.'))
    w(righe)
elif stato == 'degenere':
    righe.append(L('JQ', 2, 'Tester', 'set mode to math calculations or adjust testing dates'))
    righe.append(L('MJ', 0, 'Experts', 'optimization frame expert %s (%s,%s) processing started' % (ea, sim, per)))
    righe.append(L('EG', 0, 'Experts', 'optimization frame expert %s (%s,%s) processing stopped' % (ea, sim, per)))
    w(righe)
    if SCEN.get('deg_csv', 'zero') == 'zero':
        fd = os.path.join(DF, 'MQL5', 'Files'); os.makedirs(fd, exist_ok=True)
        open(os.path.join(fd, 'OptResults_%s_%s.csv' % (ea, sim)), 'wb').close()
elif stato == 'nodata':
    righe.append(L('HM', 2, 'Tester', '%s: history synchronization error' % sim))
    w(righe)
else:
    open(LOG, 'a').write('STATO IGNOTO %s\n' % stato)
time.sleep(0.05)
sys.exit(0)
