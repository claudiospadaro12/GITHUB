#!/usr/bin/env python3
# -*- coding: ascii -*-
"""
giornali_veri.py -- le funzioni della riprova di walkforward_generico_RETRY.ps1 contro i GIORNALI VERI del tester
(scritti da MT5 sul PC di backtest, non da noi), piu' due giornali costruiti per romperle (mezzanotte, riga quasi uguale).

Estrae dal driver:
  - il blocco fra '# ===== BLOCCO RIPROVA COLLAUDABILE: INIZIO =====' e '... FINE =====' (RigaGiornaleTester,
    ClassificaTentativo, DecidiRiprova, TestoTentativo), cosi' com'e', e lo ESEGUE con pwsh;
  - la funzione LeggiGiornaleTester (impura) con il parser AST di PowerShell, per il caso della mezzanotte.
Le ATTESE sono scritte leggendo i giornali a occhio (righe citate qui sotto), non dal codice:
  R92BAB 01/10 (risultati_archivio/ROUND_R92BAB_20261001_2201/LOG_TESTER/0002_Tester_logs_20261001.log)
    r.1  22:01:43.777 Cloud servers switched off
    r.2  22:02:08.987 "ABTG_DAX_Apertura_EU_Pin9fca.ex5" X64
    r.4-8  5 x 'OnTesterInit works too long...'  r.9 22:03:43.533 '... Tester cannot be initialized.'
    r.10 22:03:53.008 Cloud servers switched off   r.11 22:04:08.719 intestazione  r.14 from 2026.08.18 00:00 to 2026.09.01 00:00
    r.31 'new records saved to cache file'
    r.158 22:07:57.848 Cloud ...  r.159 22:08:12.329 "ABTG_Bulge.ex5" X64  r.161-165 avvisi  r.166 22:09:46.796 fatale
    r.167 22:10:06.931 Cloud ...  r.168 intestazione  r.171 from 2026.03.02 00:00 to 2026.05.01 00:00
  R92B 30/09 (ROUND_R92B_2026-09-30/LOG_TESTER/0006_Tester_logs_20260930.log): gambe morte 08:50:47-08:52:26.006 e
    08:52:52-08:54:27.915, 6 righe 'works too long' ciascuna.
  RFWD 30/09 (ROUND_RFWD_2026-09-30/LOG_TESTER/0002_Tester_logs_20260930.log): 4 gambe Bulge MORTE la mattina
    (08:50-09:02), poi ABTG_MaxMinNotte_DAX_Short_Ottimizzato PARTITA alle 21:02:19 from 2026.09.14 to 2026.09.20.
Uso: python3 giornali_veri.py     (esce 0 se tutti i casi tornano)
"""
import os, subprocess, sys, tempfile
QD = os.path.dirname(os.path.abspath(__file__))
REPO = os.path.abspath(os.path.join(QD, '..', '..'))
DRV = os.path.join(REPO, 'backtest_pipeline', 'walkforward_generico_RETRY.ps1')
AR = os.path.join(REPO, 'backtest_pipeline', 'risultati_archivio')
src = open(DRV, encoding='ascii').read()
I = '# ===== BLOCCO RIPROVA COLLAUDABILE: INIZIO ====='
F = '# ===== BLOCCO RIPROVA COLLAUDABILE: FINE ====='
assert src.count(I) == 1 and src.count(F) == 1, 'marcatori del blocco non unici'
blk = src[src.index(I):src.index(F) + len(F)]

G_R92BAB = os.path.join(AR, 'ROUND_R92BAB_20261001_2201', 'LOG_TESTER', '0002_Tester_logs_20261001.log')
G_R92B = os.path.join(AR, 'ROUND_R92B_2026-09-30', 'LOG_TESTER', '0006_Tester_logs_20260930.log')
G_RFWD = os.path.join(AR, 'ROUND_RFWD_2026-09-30', 'LOG_TESTER', '0002_Tester_logs_20260930.log')

# (nome, file, giorno, expert, t0, t1, da, a, attesi {campo: valore})
CASI = [
    ('R92BAB P gamba IS (la prima della sessione)', G_R92BAB, '2026-10-01', 'ABTG_DAX_Apertura_EU_Pin9fca', '22:01:40', '22:03:50', '2026.06.01', '2026.08.17',
     {'Esito': 'MORTA_INIT', 'NAvvisi': '6', 'OraMorte': '22:03:43.533', 'NPrima': '0', 'Cache': ''}),
    ('R92BAB P gamba OOS', G_R92BAB, '2026-10-01', 'ABTG_DAX_Apertura_EU_Pin9fca', '22:03:52', '22:04:40', '2026.08.18', '2026.09.01',
     {'Esito': 'PARTITA', 'Da': '2026.08.18 00:00', 'A': '2026.09.01 00:00', 'Sim': 'D30EUR', 'Finestra': '= dichiarata', 'NPrima': '9', 'CacheOk': '1'}),
    ('R92BAB C gamba OOS (morta a meta sessione)', G_R92BAB, '2026-10-01', 'ABTG_Bulge', '22:07:55', '22:10:00', '2026.05.02', '2026.06.30',
     {'Esito': 'MORTA_INIT', 'NAvvisi': '6', 'OraMorte': '22:09:46.796', 'Cache': ''}),
    ('R92BAB gamba dopo la morta di C: le righe della morta sono PRIMA e non contano', G_R92BAB, '2026-10-01', 'ABTG_Bulge', '22:10:05', '22:10:36', '2026.03.02', '2026.05.01',
     {'Esito': 'PARTITA', 'Da': '2026.03.02 00:00', 'Finestra': '= dichiarata', 'NPrima': '166'}),
    ('R92BAB tutto il round in UNA finestra: illeggibile per gamba', G_R92BAB, '2026-10-01', 'ABTG_Bulge', '22:00:00', '22:13:00', '2026.03.02', '2026.05.01',
     {'Esito': 'ANOMALA'}),
    ('R92BAB P OOS chiesta col nome di UN ALTRO EA', G_R92BAB, '2026-10-01', 'ABTG_Bulge', '22:03:52', '22:04:40', '2026.08.18', '2026.09.01',
     {'Esito': 'ANOMALA'}),
    ('R92BAB P OOS con finestra dichiarata diversa (classe 992)', G_R92BAB, '2026-10-01', 'ABTG_DAX_Apertura_EU_Pin9fca', '22:03:52', '22:04:40', '2026.08.18', '2026.09.02',
     {'Esito': 'PARTITA', 'FinestraDiversa': '1'}),
    ('R92B 30/09 prima gamba', G_R92B, '2026-09-30', 'ABTG_Bulge', '08:50:20', '08:52:30', '2026.03.02', '2026.05.01',
     {'Esito': 'MORTA_INIT', 'NAvvisi': '6', 'OraMorte': '08:52:26.006', 'NPrima': '0'}),
    ('R92B 30/09 seconda gamba', G_R92B, '2026-09-30', 'ABTG_Bulge', '08:52:30', '08:54:33', '2026.05.02', '2026.06.30',
     {'Esito': 'MORTA_INIT', 'NAvvisi': '6', 'OraMorte': '08:54:27.915', 'NPrima': '9'}),
    ('RFWD 30/09 sera: 4 gambe morte la mattina NON contano', G_RFWD, '2026-09-30', 'ABTG_MaxMinNotte_DAX_Short_Ottimizzato', '21:02:00', '21:02:35', '2026.09.14', '2026.09.20',
     {'Esito': 'PARTITA', 'Da': '2026.09.14 00:00', 'A': '2026.09.20 00:00', 'Finestra': '= dichiarata'}),
    ('RFWD 30/09 finestra vuota fra mattina e sera', G_RFWD, '2026-09-30', 'ABTG_Bulge', '12:00:00', '12:05:00', '2026.03.02', '2026.05.01',
     {'Esito': 'NON_VERIFICABILE', 'NFinestra': '0'}),
]


def ps_lit(s):
    return "'" + s.replace("'", "''") + "'"


ps = [blk, '$ErrorActionPreference="Stop"']
for i, (nome, f, giorno, ea, t0, t1, da, a, att) in enumerate(CASI):
    ps.append("$rr=New-Object System.Collections.ArrayList; $g=[datetime]::ParseExact(%s,'yyyy-MM-dd',[Globalization.CultureInfo]::InvariantCulture)" % ps_lit(giorno))
    ps.append("foreach($l in [IO.File]::ReadAllLines(%s,[Text.Encoding]::Unicode)){ $o=RigaGiornaleTester $l $g; if($null -ne $o){ [void]$rr.Add($o) } }" % ps_lit(f))
    ps.append("$c=ClassificaTentativo $rr %s $g.Add([TimeSpan]::Parse(%s)) $g.Add([TimeSpan]::Parse(%s)) %s %s" % (ps_lit(ea), ps_lit(t0), ps_lit(t1), ps_lit(da), ps_lit(a)))
    ps.append("'CASO%d|'+$c.Esito+'|'+$c.NAvvisi+'|'+$c.OraMorte+'|'+$c.NPrima+'|'+$c.Da+'|'+$c.A+'|'+$c.Sim+'|'+$c.Finestra+'|'+$c.Cache+'|'+$c.NFinestra+'|'+$c.Motivo" % i)
# DecidiRiprova: la tabella completa delle sei condizioni
DEC = [('MORTA_INIT', False, 1, 1, False, False, True), ('MORTA_INIT', False, 2, 1, False, False, False), ('MORTA_INIT', True, 1, 1, False, False, False),
       ('MORTA_INIT', False, 1, 0, False, False, False), ('MORTA_INIT', False, 1, 1, True, False, False), ('MORTA_INIT', False, 1, 1, False, True, False),
       ('MORTA_ALTRO', False, 1, 1, False, False, False), ('PARTITA', False, 1, 1, False, False, False), ('NON_VERIFICABILE', False, 1, 1, False, False, False),
       ('ANOMALA', False, 1, 1, False, False, False)]
for j, (es, csvp, t, m, ol, tv, _) in enumerate(DEC):
    b = lambda x: '$true' if x else '$false'
    ps.append("$d=DecidiRiprova %s %s %d %d %s %s; 'DEC%d|'+$d.Si+'|'+$d.Motivo" % (ps_lit(es), b(csvp), t, m, b(ol), b(tv), j))
# MEZZANOTTE e RIGA QUASI UGUALE, giornali costruiti: la morte scritta il giorno DOPO l'intestazione.
td = tempfile.mkdtemp()
os.makedirs(os.path.join(td, 'Tester', 'logs'))
def w16(p, L):
    open(p, 'wb').write(b'\xff\xfe' + ('\r\n'.join(L) + '\r\n').encode('utf-16-le'))
w16(os.path.join(td, 'Tester', 'logs', '20261001.log'), ['QL\t0\t23:59:50.100\tTester\tCloud servers switched off', 'LL\t0\t23:59:55.200\tTester\t"ABTG_Bulge.ex5" X64'] +
    ['PD\t3\t23:59:5%d.000\tTester\tOnTesterInit works too long...' % (6 + i) for i in range(3)])
w16(os.path.join(td, 'Tester', 'logs', '20261002.log'), ['PD\t3\t00:00:10.000\tTester\tOnTesterInit works too long...', 'PD\t3\t00:00:20.000\tTester\tOnTesterInit works too long...',
    'JO\t3\t00:00:30.123\tTester\tOnTesterInit works too long. Tester cannot be initialized.'])
import re
m = re.search(r'^function LeggiGiornaleTester\(.*?^}\n', src, re.M | re.S)
assert m, 'LeggiGiornaleTester non trovata'
ps.append(m.group(0))
ps.append("$t0=[datetime]::ParseExact('2026-10-01 23:59:49','yyyy-MM-dd HH:mm:ss',[Globalization.CultureInfo]::InvariantCulture); $t1=$t0.AddSeconds(45)")
ps.append("$lg=LeggiGiornaleTester %s $t0 $t1; $c=ClassificaTentativo $lg.Righe 'ABTG_Bulge' $t0 $t1 '2026.03.02' '2026.05.01'" % ps_lit(td))
ps.append("'MEZZANOTTE|'+$lg.Ok+'|'+$c.Esito+'|'+$c.NAvvisi+'|'+$c.OraMorte+'|'+@($lg.File -split '; ').Count")
ps.append("$lg2=LeggiGiornaleTester %s $t0 $t0.AddSeconds(5); 'SOLOPRIMO|'+@($lg2.File -split '; ').Count+'|'+$lg2.Righe.Count" % ps_lit(td))
ps.append("$lg3=LeggiGiornaleTester %s $t0 $t1; 'ASSENTE|'+$lg3.Ok+'|'+$lg3.Problema" % ps_lit(os.path.join(td, 'nonc')))
# riga QUASI uguale: 'works too long' + 'cannot be initialized' su righe DIVERSE, e la fatale senza la causa -> MORTA_ALTRO
ps.append("$g=[datetime]'2026-10-01'; $q=@(RigaGiornaleTester ('LL'+[char]9+'0'+[char]9+'10:00:00.000'+[char]9+'Tester'+[char]9+[char]34+'ABTG_Bulge.ex5'+[char]34+' X64') $g; RigaGiornaleTester ('PD'+[char]9+'3'+[char]9+'10:00:15.000'+[char]9+'Tester'+[char]9+'OnTesterInit works too long...') $g; RigaGiornaleTester ('JO'+[char]9+'3'+[char]9+'10:00:30.000'+[char]9+'Tester'+[char]9+'Tester cannot be initialized.') $g)")
ps.append("$c=ClassificaTentativo $q 'ABTG_Bulge' $g.AddHours(9) $g.AddHours(11) '2026.03.02' '2026.05.01'; 'QUASI|'+$c.Esito+'|'+$c.NAvvisi")
# riga SENZA ora (formato rotto) -> ignorata, mai un'eccezione
ps.append("'SENZAORA|'+($null -eq (RigaGiornaleTester 'testo senza ora' $g))+'|'+($null -eq (RigaGiornaleTester ('XX'+[char]9+'0'+[char]9+'25:00:00.000'+[char]9+'Tester'+[char]9+'x') $g))")
p = os.path.join(td, 't.ps1')
open(p, 'w').write('\n'.join(ps) + '\n')
r = subprocess.run(['pwsh', '-NoProfile', '-File', p], capture_output=True, text=True)
out = {}
for l in r.stdout.splitlines():
    if '|' in l:
        k, v = l.split('|', 1)
        out[k] = v.split('|')
if r.stderr.strip():
    print(r.stderr)
ok = 0; tot = 0
def verdetto(cond, msg):
    global ok, tot
    tot += 1; ok += 1 if cond else 0
    print(('PASS  ' if cond else 'FALLITO ') + msg)
for i, (nome, f, giorno, ea, t0, t1, da, a, att) in enumerate(CASI):
    v = out.get('CASO%d' % i)
    if v is None:
        verdetto(False, nome + ' -> nessun risultato'); continue
    d = dict(zip(['Esito', 'NAvvisi', 'OraMorte', 'NPrima', 'Da', 'A', 'Sim', 'Finestra', 'Cache', 'NFinestra', 'Motivo'], v))
    good = True
    for kk, vv in att.items():
        if kk == 'CacheOk':
            good = good and ('saved to cache file' in d['Cache'])
        elif kk == 'FinestraDiversa':
            good = good and d['Finestra'].startswith('DIVERSA')
        else:
            good = good and d[kk] == vv
    verdetto(good, nome + ' -> ' + d['Esito'] + ' avvisi ' + d['NAvvisi'] + ' morte ' + d['OraMorte'] + ' prima ' + d['NPrima'] + ' ' + d['Da'] + '->' + d['A'] + ' ' + d['Finestra'] + (' | ' + d['Motivo'] if d['Motivo'] else ''))
for j, row in enumerate(DEC):
    v = out.get('DEC%d' % j, ['?', 'nessun risultato'])
    verdetto(v[0] == ('True' if row[6] else 'False'), 'DecidiRiprova%s -> %s (%s)' % (str(row[:6]), v[0], v[1]))
v = out.get('MEZZANOTTE', ['?'] * 6)
verdetto(v[0] == 'True' and v[1] == 'MORTA_INIT' and v[2] == '6' and v[3] == '00:00:30.123' and v[4] == '2', 'mezzanotte: due file letti, intestazione il 01/10 e fatale il 02/10 -> ' + '|'.join(v))
v = out.get('SOLOPRIMO', ['?'] * 3)
verdetto(v[0] == '1', 'tentativo tutto prima di mezzanotte: un solo file letto -> ' + '|'.join(v))
v = out.get('ASSENTE', ['?'] * 2)
verdetto(v[0] == 'False' and 'nessun giornale' in v[1], 'cartella dei giornali assente -> NON letto, motivo scritto: ' + '|'.join(v))
v = out.get('QUASI', ['?'] * 2)
verdetto(v[0] == 'MORTA_ALTRO', 'fatale SENZA la causa sulla stessa riga -> MORTA_ALTRO (non si riprova): ' + '|'.join(v))
v = out.get('SENZAORA', ['?'] * 2)
verdetto(v == ['True', 'True'], 'riga senza ora / ora 25 -> ignorate: ' + '|'.join(v))
print('GIORNALI VERI E COSTRUITI: %d/%d' % (ok, tot))
sys.exit(0 if ok == tot else 1)
