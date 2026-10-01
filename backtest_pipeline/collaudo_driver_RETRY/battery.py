#!/usr/bin/env python3
# -*- coding: ascii -*-
"""
battery.py -- la batteria di contro-esempi del driver con la riprova (walkforward_generico_RETRY.ps1) e della riga
che lo lancia (righe/RIGA_ROUND_VPS_RETRY.ps1). Gira il DRIVER VERO con pwsh su Linux, con il terminale finto
(stub_terminal.py) che scrive un giornale del tester nel formato delle righe vere. Vedi harness.py per cosa e' finto.

Ogni scenario dichiara PRIMA cosa deve succedere: quanti lanci del terminale (dal registro dello stub, non dal
driver), quali CSV, cosa dice il file RIPROVE, il codice d'uscita. Gli scenari "non deve riprovare" sono i
contro-esempi che una riprova scritta male farebbe sbagliare: causa diversa, giornale sporco di una corsa
precedente, giornale muto, EA diverso, CSV presente, scadenza passata, -MaxRiprove 0.

Uso:  python3 backtest_pipeline/collaudo_driver_RETRY/battery.py [nome_scenario ...]
Esce 0 se tutti gli scenari scelti passano.
"""
import hashlib, os, sys
sys.path.insert(0, os.path.dirname(os.path.abspath(__file__)))
import harness

OK = []
KO = []


def chk(nome, cond, msg):
    (OK if cond else KO).append((nome, msg))
    print(('    ok   ' if cond else '    KO!! ') + msg)


def lanci(e, gamba):
    return [l for l in e['lanci'] if l.startswith('LANCIO %s ' % gamba)]


def riga_gamba(e, g):
    for l in (e['riprove'] or '').splitlines():
        if l.startswith('GAMBA %s' % g.ljust(3)):
            return l
    return ''


def comune(n, e, nIS, nOOS, csvIS, csvOOS, riprovate, exitc='0'):
    chk(n, e['exit'] == exitc, 'codice d uscita %s (atteso %s)' % (e['exit'], exitc))
    chk(n, len(lanci(e, 'IS')) == nIS, 'lanci della gamba IS: %d (attesi %d)' % (len(lanci(e, 'IS')), nIS))
    chk(n, len(lanci(e, 'OOS')) == nOOS, 'lanci della gamba OOS: %d (attesi %d)' % (len(lanci(e, 'OOS')), nOOS))
    chk(n, e['csv_IS'] == csvIS, 'CSV IS presente=%s (atteso %s)' % (e['csv_IS'], csvIS))
    chk(n, e['csv_OOS'] == csvOOS, 'CSV OOS presente=%s (atteso %s)' % (e['csv_OOS'], csvOOS))
    if riprovate is not None:
        chk(n, e['riprove'] is not None and ('RIPROVATE  : %s' % riprovate) in e['riprove'], 'file RIPROVE dice "RIPROVATE  : %s"' % riprovate)


def D_morta_viva():
    n = 'D1 morta al 1o tentativo, viva al 2o'
    e = harness.run_driver('D1', {'legs': {'IS': ['dead', 'ok'], 'OOS': ['ok']}})
    comune(n, e, 2, 1, True, True, '1 (IS)')
    g = riga_gamba(e, 'IS')
    chk(n, 'tentativo 1 -> MORTA_INIT' in g and 'tentativo 2 -> PARTITA' in g and '| RIPROVATA |' in g and 'CSV PRODOTTO AL TENTATIVO 2' in g, 'riga IS: tentativo 1 MORTA_INIT, tentativo 2 PARTITA, RIPROVATA, CSV al tentativo 2')
    chk(n, '6 righe' in g and 'cache: nessuna riga' in g.split('tentativo 2')[0], 'tentativo 1: 6 righe works too long e NESSUNA riga di cache nel giornale')
    chk(n, 'RIPROVATA' not in riga_gamba(e, 'OOS'), 'gamba OOS NON marcata')
    chk(n, 'finestra = dichiarata' in g.split('tentativo 2')[1], 'tentativo 2: from/to = finestra dichiarata (classe 992)')
    ini = [l.split(' ini ')[1] for l in lanci(e, 'IS')]
    chk(n, len(set(ini)) == 1, 'i due tentativi usano LO STESSO .ini (%s)' % ','.join(sorted(set(ini))))


def D_morta_due():
    n = 'D2 morta due volte'
    e = harness.run_driver('D2', {'legs': {'IS': ['dead', 'dead', 'ok'], 'OOS': ['ok']}})
    comune(n, e, 2, 1, False, True, '1 (IS)')
    g = riga_gamba(e, 'IS')
    chk(n, g.count('MORTA_INIT') == 2 and 'gia\' riprovata 1 volta' in g and 'CSV NON PRODOTTO' in g and '| RIPROVATA |' in g, 'IS: due MORTA_INIT, "gia riprovata 1 volta", CSV NON PRODOTTO, RIPROVATA')
    chk(n, 'tentativo 3' not in g, 'nessun terzo tentativo')


def D_altro():
    for nome, stato, attesa in [('D3a causa diversa (OnTesterInit returned non-zero ... cannot be initialized)', 'altro', 'MORTA_ALTRO'),
                                ('D3b errore di storico (ne from/to ne fatale)', 'nodata', 'NON_VERIFICABILE'),
                                ('D3c terminale muto (giornale senza righe)', 'silent', 'NON_VERIFICABILE'),
                                ('D3d morta MA con CSV (contraddizione)', 'dead_csv', 'MORTA_INIT'),
                                ('D3e intestazione di UN ALTRO EA', 'other_ea', 'ANOMALA')]:
        print('  ' + nome)
        e = harness.run_driver('D3_' + stato, {'legs': {'IS': [stato, 'ok'], 'OOS': ['ok']}})
        comune(nome, e, 1, 1, stato == 'dead_csv', True, '0')
        g = riga_gamba(e, 'IS')
        chk(nome, ('tentativo 1 -> ' + attesa) in g and 'RIPROVATA' not in g, 'IS: tentativo 1 -> %s, NON riprovata' % attesa)
        if stato == 'dead_csv':
            chk(nome, 'contraddizione' in g, 'IS: "contraddizione" scritta')


def D_compila_ko():
    n = 'D3f compilazione fallita'
    e = harness.run_driver('D3f', {'legs': {'IS': ['ok'], 'OOS': ['ok']}, 'compila_ko': True})
    comune(n, e, 0, 0, False, False, None, exitc='1')
    chk(n, 'compilazione fallita' in e['out'], 'il driver muore su "compilazione fallita", PRIMA del terminale: nessuna riprova possibile')


def D_due_gambe():
    n = 'D4 due gambe morte nello stesso job'
    e = harness.run_driver('D4', {'legs': {'IS': ['dead', 'ok'], 'OOS': ['dead', 'ok']}})
    comune(n, e, 2, 2, True, True, '2 (IS,OOS)')
    chk(n, '| RIPROVATA |' in riga_gamba(e, 'IS') and '| RIPROVATA |' in riga_gamba(e, 'OOS'), 'tutte e due marcate RIPROVATA')


def D_residuo():
    n = 'D5a giornale sporco: gamba MORTA di una corsa precedente (60 s prima), gambe di adesso vive'
    e = harness.run_driver('D5a', {'legs': {'IS': ['ok'], 'OOS': ['ok']}, 'residuo': 60})
    comune(n, e, 1, 1, True, True, '0')
    g = riga_gamba(e, 'IS')
    chk(n, 'tentativo 1 -> PARTITA' in g and '8 di prima ignorate' in g, 'IS PARTITA, e le 8 righe della corsa precedente contate e IGNORATE')
    n = 'D5b giornale sporco + gamba di adesso MUTA: la morta di prima NON deve far riprovare'
    e = harness.run_driver('D5b', {'legs': {'IS': ['silent', 'ok'], 'OOS': ['ok']}, 'residuo': 60})
    comune(n, e, 1, 1, False, True, '0')
    chk(n, 'tentativo 1 -> NON_VERIFICABILE' in riga_gamba(e, 'IS'), 'IS NON_VERIFICABILE (non MORTA_INIT)')
    n = 'D5c giornale sporco dalla gamba IS di QUESTO job: la OOS viva NON eredita la morte della IS'
    e = harness.run_driver('D5c', {'legs': {'IS': ['dead', 'dead'], 'OOS': ['ok']}})
    comune(n, e, 2, 1, False, True, '1 (IS)')
    chk(n, 'tentativo 1 -> PARTITA' in riga_gamba(e, 'OOS') and 'RIPROVATA' not in riga_gamba(e, 'OOS'), 'OOS PARTITA al primo tentativo, non riprovata')


def D_parametri():
    n = 'D6 -MaxRiprove 0 = comportamento dell originale'
    e = harness.run_driver('D6', {'legs': {'IS': ['dead', 'ok'], 'OOS': ['ok']}}, ['-MaxRiprove', '0'])
    comune(n, e, 1, 1, False, True, '0')
    chk(n, 'riprova spenta' in riga_gamba(e, 'IS'), 'IS: "riprova spenta" scritto')
    n = 'D7 -MaxRiprove 2 rifiutato'
    e = harness.run_driver('D7', {'legs': {'IS': ['dead', 'ok'], 'OOS': ['ok']}}, ['-MaxRiprove', '2'])
    comune(n, e, 0, 0, False, False, None, exitc='1')
    chk(n, 'MaxRiprove ammette 0' in e['out'], 'messaggio di rifiuto')
    n = 'D8a scadenza passata'
    e = harness.run_driver('D8a', {'legs': {'IS': ['dead', 'ok'], 'OOS': ['ok']}}, ['-RiprovaEntro', '2020-01-01 00:00:00'])
    comune(n, e, 1, 1, False, True, '0')
    chk(n, 'oltre la scadenza' in riga_gamba(e, 'IS'), 'IS: "oltre la scadenza" scritto')
    n = 'D8b scadenza malformata'
    e = harness.run_driver('D8b', {'legs': {'IS': ['ok'], 'OOS': ['ok']}}, ['-RiprovaEntro', '2026-10-01T10:00'])
    comune(n, e, 0, 0, False, False, None, exitc='1')
    n = 'D8c scadenza futura: la riprova parte'
    e = harness.run_driver('D8c', {'legs': {'IS': ['dead', 'ok'], 'OOS': ['ok']}}, ['-RiprovaEntro', '2099-01-01 00:00:00'])
    comune(n, e, 2, 1, True, True, '1 (IS)')
    n = 'D9 attesa fuori campo'
    e = harness.run_driver('D9', {'legs': {'IS': ['ok'], 'OOS': ['ok']}}, ['-AttesaRiprovaSec', '1'])
    comune(n, e, 0, 0, False, False, None, exitc='1')
    n = 'D10 finestra girata diversa dalla dichiarata (classe 992): partita, NON riprovata, scritto DIVERSA'
    e = harness.run_driver('D10', {'legs': {'IS': ['win_bad'], 'OOS': ['ok']}})
    comune(n, e, 1, 1, True, True, '0')
    chk(n, 'finestra DIVERSA dalla dichiarata' in riga_gamba(e, 'IS'), 'IS: finestra DIVERSA scritta')


def R_riga():
    n = 'R1 riga: gamba IS morta e poi viva -> GIRATO CON RILIEVI (codice 3), RIPROVE nel referto e nello zip'
    e = harness.run_riga('R1', {'legs': {'IS': ['dead', 'ok'], 'OOS': ['ok']}}, modello='4')
    chk(n, e['exit'] == '3', 'codice %s (atteso 3)' % e['exit'])
    chk(n, 'ESITO: ROUND GIRATO CON RILIEVI (1)' in e['referto'], 'referto: ROUND GIRATO CON RILIEVI (1)')
    chk(n, 'gamba IS RIPROVATA dal driver' in e['referto'] and 'gambe RIPROVATE: 1' in e['referto'], 'referto: rilievo della gamba IS RIPROVATA e sezione RIPROVE')
    chk(n, 'RIPROVE_ABTG_Bulge_GBPUSD_T.txt' in e['raccolta'] and 'ROUND_T.zip' in e['desktop'], 'raccolta: file RIPROVE copiato, zip presente')
    chk(n, len(lanci(e, 'IS')) == 2 and len(lanci(e, 'OOS')) == 1, 'lanci IS 2, OOS 1')
    chk(n, 'SCARICA backtest_pipeline/walkforward_generico_RETRY.ps1' in e['log'] and 'SCARICA backtest_pipeline/walkforward_generico.ps1' not in e['log'], 'la riga scarica walkforward_generico_RETRY.ps1 e NON il driver originale')
    n = 'R2 riga: tutto vivo -> ROUND GIRATO (codice 0)'
    e = harness.run_riga('R2', {'legs': {'IS': ['ok'], 'OOS': ['ok']}}, modello='4')
    chk(n, e['exit'] == '0' and 'ESITO: ROUND GIRATO' in e['referto'] and 'gambe RIPROVATE: 0' in e['referto'], 'codice %s, ROUND GIRATO, RIPROVATE 0' % e['exit'])
    n = 'R3 riga: gamba IS morta due volte -> NON MISURATO (codice 2)'
    e = harness.run_riga('R3', {'legs': {'IS': ['dead', 'dead'], 'OOS': ['ok']}}, modello='4')
    chk(n, e['exit'] == '2' and 'NON MISURATO -- CSV mancanti o vuoti: IS' in e['referto'] and 'gamba IS RIPROVATA' in e['referto'], 'codice %s, NON MISURATO IS, RIPROVATA scritta' % e['exit'])
    n = 'R4 riga: -MaxRiprove 2 rifiutato al pre-volo (nessun download, nessun lancio)'
    e = harness.run_riga('R4', {'legs': {'IS': ['ok'], 'OOS': ['ok']}}, ['-MaxRiprove', '2'], modello='4')
    chk(n, e['exit'] == '1' and not e['lanci'] and not any(l.startswith('SCARICA') for l in e['log']), 'codice %s, zero lanci, zero download' % e['exit'])
    n = 'R5 riga: scadenza con lo spazio arriva intera al driver (classe 540) e la riprova parte'
    e = harness.run_riga('R5', {'legs': {'IS': ['dead', 'ok'], 'OOS': ['ok']}}, ['-RiprovaEntro', '2099-01-01 00:00:00'], modello='4')
    pl = [l for l in e['log'] if l.startswith('POWERSHELL')]
    chk(n, pl and '-RiprovaEntro | 2099-01-01 00:00:00 |' in pl[0] + ' |', 'argomento -RiprovaEntro arrivato intero: %s' % (pl[0][-80:] if pl else 'NESSUN LANCIO'))
    chk(n, e['exit'] == '3' and len(lanci(e, 'IS')) == 2, 'codice %s, IS lanciata 2 volte' % e['exit'])
    n = 'R6 riga: il file scaricato col nome RETRY ma SENZA il marcatore v7 (e il driver originale) -> si ferma'
    srv = os.path.join(harness.OUT, 'srv_R6'); os.makedirs(srv, exist_ok=True)
    open(os.path.join(srv, 'walkforward_generico_RETRY.ps1'), 'wb').write(open(os.path.join(harness.REPO, 'backtest_pipeline', 'walkforward_generico.ps1'), 'rb').read())
    os.environ['SRV_OVERRIDE'] = srv
    try:
        e = harness.run_riga('R6', {'legs': {'IS': ['ok'], 'OOS': ['ok']}}, modello='4')
    finally:
        del os.environ['SRV_OVERRIDE']
    chk(n, e['exit'] == '1' and 'NON ha il marcatore MARCATORE_WALKFORWARD_GENERICO_v7_RETRY' in e['out'] and not e['lanci'], 'codice %s, rifiutato, zero lanci' % e['exit'])
    n = 'R7 riga: il driver muore prima del terminale (compilazione) -> nessun file RIPROVE: rilievo + NON MISURATO'
    e = harness.run_riga('R7', {'legs': {'IS': ['ok'], 'OOS': ['ok']}, 'compila_ko': True}, modello='4')
    chk(n, e['exit'] == '2' and 'NON ha scritto un file RIPROVE fresco' in e['referto'], 'codice %s, rilievo "file RIPROVE" nel referto' % e['exit'])


def originali():
    n = 'O gli originali NON sono cambiati di un byte'
    for rel, sha in [('backtest_pipeline/walkforward_generico.ps1', '6eff8e4061eb6e82f88c66673b26b7cf5bffc1f3ab55f07e3a504ec6e0e027a1'),
                     ('backtest_pipeline/righe/RIGA_ROUND_VPS.ps1', '3341756fb37889dbd6e827a87bac26893e01c85b6c18343918083b01b4dd3425')]:
        h = hashlib.sha256(open(os.path.join(harness.REPO, rel), 'rb').read()).hexdigest()
        chk(n, h == sha, '%s sha256 %s' % (rel, h[:16]))


SCEN = [('originali', originali), ('D1', D_morta_viva), ('D2', D_morta_due), ('D3', D_altro), ('D3f', D_compila_ko), ('D4', D_due_gambe),
        ('D5', D_residuo), ('D6-10', D_parametri), ('R', R_riga)]
scelti = sys.argv[1:]
for k, f in SCEN:
    if scelti and k not in scelti:
        continue
    print('== ' + (f.__doc__ or k) if False else '== ' + k)
    f()
print('')
print('BATTERIA DRIVER RETRY: %d controlli passati, %d FALLITI' % (len(OK), len(KO)))
for nome, msg in KO:
    print('  FALLITO: %s -- %s' % (nome, msg))
sys.exit(0 if not KO else 1)
