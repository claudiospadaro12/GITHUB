#!/usr/bin/env python3
# -*- coding: ascii -*-
"""
harness.py -- il banco di prova di walkforward_generico_RETRY.ps1 e di righe/RIGA_ROUND_VPS_RETRY.ps1 su Linux con pwsh.

Stessa idea di collaudo_riga_R92BAB/run.sh (ambiente finto, stub degli eseguibili, irm sostituito da una copia dal repo),
ma un gradino PIU' GIU': li' il driver era uno stub; qui il driver e' QUELLO VERO e lo stub e' il TERMINALE
(stub_terminal.py) e il compilatore (stub_metaeditor.py). Cosi' si collauda il ciclo dei tentativi, la lettura del
giornale e la decisione, che sono il codice nuovo.

COSA E' FINTO, dichiarato (differenze dal PC di backtest che NON si possono togliere su Linux):
  - il disco C: e' un PSDrive di pwsh puntato su <run>/cdrv: "C:\\Program Files\\BCM Markets MT5 Terminal" esiste
    come cartella vera (non junction), con dentro terminal64.exe e metaeditor64.exe che sono gli stub;
  - Invoke-WebRequest e' una funzione che COPIA dal repo il file chiesto (il percorso dopo il ramo/pin nell'URL):
    nessuna rete, e il driver che gira e' quello del working tree;
  - pwsh 7.4 su Linux, NON Windows PowerShell 5.1 (sul PC di backtest gira la 5.1): la compatibilita' 5.1 la
    controlla controlla_riga.py (costrutti pwsh-7, parser vero), non questo banco;
  - Join-Path su Linux scrive "/" : il driver cerca la cartella dati confrontando origin.txt con
    Split-Path -Parent del terminale, quindi qui ci sono DUE cartelle dati: DRV000 (origin con "/", la trova il
    driver, ed e' li' che lo stub scrive giornale e CSV) e RIGA000 (origin con "\\", la trova la riga per il
    tetto barre). Sul PC vero sono la stessa cartella.
  - powershell.exe (lanciato dalla riga con Start-Process) e' shim_powershell.py, che rilancia il .ps1 con pwsh
    dentro lo stesso preludio (PSDrive + Invoke-WebRequest finto).
"""
import datetime as dt, json, os, shutil, subprocess, sys, time

QD = os.path.dirname(os.path.abspath(__file__))
REPO = os.path.abspath(os.path.join(QD, '..', '..'))
OUT = os.environ.get('HARNESS_OUT', os.path.join('/tmp', 'retry_harness'))
TERM = 'C:\\Program Files\\BCM Markets MT5 Terminal'


def utf16(path, text):
    os.makedirs(os.path.dirname(path), exist_ok=True)
    open(path, 'wb').write(b'\xff\xfe' + text.encode('utf-16-le'))


def prelude(H):
    return ("New-PSDrive -Name C -PSProvider FileSystem -Root '" + H + "/cdrv' | Out-Null\n"
            "function Invoke-WebRequest { param([string]$Uri,[string]$OutFile,[switch]$UseBasicParsing,[int]$TimeoutSec)\n"
            "  $p=($Uri -split '[?]')[0]; $i=$p.IndexOf('/GITHUB/'); $r=$p.Substring($i+8); $r=$r.Substring($r.IndexOf('/')+1)\n"
            "  Add-Content -LiteralPath $env:HARNESS_LOG -Value ('SCARICA ' + $r)\n"
            "  $src=Join-Path $env:REPO_ROOT $r; if($env:SRV_OVERRIDE -and (Test-Path -LiteralPath (Join-Path $env:SRV_OVERRIDE (Split-Path -Leaf $r)))){ $src=Join-Path $env:SRV_OVERRIDE (Split-Path -Leaf $r) }\n"
            "  if(-not (Test-Path -LiteralPath $src)){ throw ('404 ' + $r) }\n"
            "  Copy-Item -LiteralPath $src -Destination $OutFile -Force }\n")


def sh_wrapper(path, py):
    open(path, 'w').write('#!/bin/sh\nexec python3 "%s" "$@"\n' % py)
    os.chmod(path, 0o755)


def setup(name, scen):
    H = os.path.join(OUT, 'run_' + name)
    if os.path.isdir(H):
        shutil.rmtree(H)
    tdir = os.path.join(H, 'cdrv', 'Program Files', 'BCM Markets MT5 Terminal')
    os.makedirs(tdir)
    sh_wrapper(os.path.join(tdir, 'terminal64.exe'), os.path.join(QD, 'stub_terminal.py'))
    sh_wrapper(os.path.join(tdir, 'metaeditor64.exe'), os.path.join(QD, 'stub_metaeditor.py'))
    ap = os.path.join(H, 'appdata')
    drv = os.path.join(ap, 'MetaQuotes', 'Terminal', 'DRV000')
    utf16(os.path.join(drv, 'origin.txt'), 'C:/Program Files/BCM Markets MT5 Terminal')
    rg = os.path.join(ap, 'MetaQuotes', 'Terminal', 'RIGA000')
    utf16(os.path.join(rg, 'origin.txt'), TERM)
    os.makedirs(os.path.join(rg, 'config'))
    open(os.path.join(rg, 'config', 'common.ini'), 'w').write('[Common]\r\nMaxBars=100000000\r\n')
    os.makedirs(os.path.join(ap, 'MetaQuotes', 'Terminal', 'Common'))
    os.makedirs(os.path.join(H, 'user', 'Desktop'))
    work = os.path.join(H, 'user', 'abtg_round')
    os.makedirs(os.path.join(work, 'prove'))
    sj = os.path.join(H, 'scenario.json')
    json.dump(scen, open(sj, 'w'))
    # IL GIORNALE GIA' SPORCO (classe 940): una gamba MORTA in OnTesterInit dello stesso EA, scritta OGGI da una corsa
    # PRECEDENTE (ora = adesso meno 'residuo' secondi). Il driver NON deve attribuirla al tentativo di adesso.
    if scen.get('residuo'):
        base = dt.datetime.now() - dt.timedelta(seconds=int(scen['residuo']))
        if base.date() != dt.datetime.now().date():
            base = dt.datetime.now().replace(hour=0, minute=0, second=1)
        def t(s):
            x = base + dt.timedelta(seconds=s)
            return x.strftime('%H:%M:%S') + '.%03d' % (x.microsecond // 1000)
        ea = scen.get('residuo_ea', 'ABTG_Bulge')
        L = ['QL\t0\t%s\tTester\tCloud servers switched off' % t(0), 'LL\t0\t%s\tTester\t"%s.ex5" X64' % (t(1), ea)]
        L += ['PD\t3\t%s\tTester\tOnTesterInit works too long...' % t(2 + i) for i in range(5)]
        L += ['JO\t3\t%s\tTester\tOnTesterInit works too long. Tester cannot be initialized.' % t(8)]
        p = os.path.join(drv, 'Tester', 'logs', dt.datetime.now().strftime('%Y%m%d') + '.log')
        os.makedirs(os.path.dirname(p), exist_ok=True)
        open(p, 'wb').write(b'\xff\xfe' + ('\r\n'.join(L) + '\r\n').encode('utf-16-le'))
    bindir = os.path.join(H, 'bin')
    os.makedirs(bindir)
    sh_wrapper(os.path.join(bindir, 'powershell.exe'), os.path.join(QD, 'shim_powershell.py'))
    env = dict(os.environ)
    env.update({'COMPUTERNAME': scen.get('pc', 'DESKTOP-H4D7CAJ'), 'USERPROFILE': os.path.join(H, 'user'), 'APPDATA': ap,
                'HOME': os.path.join(H, 'user'), 'SCENARIO': sj, 'HARNESS_LOG': os.path.join(H, 'stub.log'),
                'STUB_COUNTERS': os.path.join(H, 'contatori'), 'DATAFOLDER_STUB': drv, 'REPO_ROOT': REPO,
                'HARNESS_H': H, 'PATH': bindir + ':' + os.environ['PATH']})
    if scen.get('compila_ko'):
        env['STUB_COMPILA_KO'] = '1'
    open(env['HARNESS_LOG'], 'w').close()
    return H, work, drv, env


def att5(extra):
    # attesa corta fra i tentativi (5 s, il minimo ammesso) salvo che lo scenario la passi lui
    return [] if '-AttesaRiprovaSec' in (extra or []) else ['-AttesaRiprovaSec', '5']


def q(s):
    return "'" + s.replace("'", "''") + "'"


def run_driver(name, scen, extra=None, ea='ABTG_Bulge', prova='R92BAB_B_GBPUSD.txt', lbl='T', modello='1'):
    H, work, drv, env = setup(name, scen)
    shutil.copy(os.path.join(REPO, 'backtest_pipeline', 'walkforward_generico_RETRY.ps1'), os.path.join(work, 'walkforward_generico_RETRY.ps1'))
    shutil.copy(os.path.join(REPO, 'backtest_pipeline', 'prove', prova), os.path.join(work, 'prove', prova))
    a = ['-Expert', ea, '-Prova', os.path.join(work, 'prove', prova), '-Etichetta', lbl, '-Modello', modello, '-Rifai', '-Force',
         '-TerminaleBacktest', TERM] + att5(extra) + (extra or [])
    toks = ' '.join(x if (x.startswith('-') and x[1:].isalnum()) else q(x) for x in a)
    ps = prelude(H) + "& " + q(os.path.join(work, 'walkforward_generico_RETRY.ps1')) + " " + toks + "\n'EXIT=' + $LASTEXITCODE\n"
    open(os.path.join(H, 'lancia.ps1'), 'w').write(ps)
    t0 = time.time()
    r = subprocess.run(['pwsh', '-NoProfile', '-File', os.path.join(H, 'lancia.ps1')], cwd=work, env=env, capture_output=True, text=True)
    out = r.stdout + r.stderr
    open(os.path.join(H, 'out.txt'), 'w').write(out)
    return esito(H, work, drv, out, time.time() - t0, ea, lbl, modello)


def run_riga(name, scen, extra=None, ea='ABTG_Bulge', prova='R92BAB_B_GBPUSD.txt', lbl='T', modello='1'):
    H, work, drv, env = setup(name, scen)
    a = ['-Expert', ea, '-Prova', prova, '-Etichetta', lbl, '-Modello', modello, '-Pin', 'lavoro'] + att5(extra) + (extra or [])
    toks = ' '.join(x if (x.startswith('-') and x[1:].isalnum()) else q(x) for x in a)
    riga = os.path.join(REPO, 'backtest_pipeline', 'righe', 'RIGA_ROUND_VPS_RETRY.ps1')
    ps = prelude(H) + "& " + q(riga) + " " + toks + "\n'EXIT=' + $LASTEXITCODE\n"
    open(os.path.join(H, 'lancia.ps1'), 'w').write(ps)
    t0 = time.time()
    r = subprocess.run(['pwsh', '-NoProfile', '-File', os.path.join(H, 'lancia.ps1')], cwd=H, env=env, capture_output=True, text=True)
    out = r.stdout + r.stderr
    open(os.path.join(H, 'out.txt'), 'w').write(out)
    e = esito(H, work, drv, out, time.time() - t0, ea, lbl, modello)
    dsk = os.path.join(H, 'user', 'Desktop')
    e['desktop'] = sorted(os.listdir(dsk)) if os.path.isdir(dsk) else []
    ref = os.path.join(dsk, 'ROUND_' + lbl, 'REFERTO_ROUND_' + lbl + '.txt')
    e['referto'] = open(ref, encoding='ascii', errors='replace').read() if os.path.exists(ref) else ''
    e['raccolta'] = sorted(os.listdir(os.path.join(dsk, 'ROUND_' + lbl))) if os.path.isdir(os.path.join(dsk, 'ROUND_' + lbl)) else []
    return e


def esito(H, work, drv, out, sec, ea, lbl, modello):
    log = open(os.path.join(H, 'stub.log')).read().splitlines()
    lanci = [l for l in log if l.startswith('LANCIO')]
    sfx = '' if modello == '4' else '_ohlc'
    ris = os.path.join(work, 'risultati_prove', ea)
    rp = os.path.join(ris, 'RIPROVE_%s_GBPUSD%s_%s.txt' % (ea, sfx, lbl))
    ext = ''
    for l in out.splitlines():
        if l.startswith('EXIT='):
            ext = l[5:].strip()
    return {'H': H, 'out': out, 'exit': ext, 'lanci': lanci, 'log': log, 'sec': sec,
            'riprove': open(rp).read() if os.path.exists(rp) else None,
            'csv_IS': os.path.exists(os.path.join(ris, '%s_GBPUSD_IS%s_%s.csv' % (ea, sfx, lbl))),
            'csv_OOS': os.path.exists(os.path.join(ris, '%s_GBPUSD_OOS%s_%s.csv' % (ea, sfx, lbl)))}
