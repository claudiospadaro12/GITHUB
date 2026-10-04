#!/usr/bin/env python3
# -*- coding: ascii -*-
"""
genera_fixture.py -- fa girare il DRIVER VERO (walkforward_generico_RETRY.ps1) e la riga VERA che lo lancia (righe/RIGA_ROUND_VPS_RETRY.ps1) su un file prova LATI vero
(@FRAZIONEIS 1.0: la gamba OOS e' DEGENERE) con il terminale finto di questa cartella (stub_terminal.py, che scrive la gamba degenere come l'ha scritta MT5 il 27/09/2026),
e copia in ../riprove_veri/ il file RIPROVE e il REFERTO che il driver ha scritto DA SOLO (classe 1020: il materiale di prova per il lettore della riga LATI non esce dallo
stub di questa riga, esce dal driver vero). Uso: python3 genera_fixture.py   -> riscrive i file LATI_*.txt in ../riprove_veri/ e stampa cosa ha prodotto.
"""
import os, shutil, sys
sys.path.insert(0, os.path.dirname(os.path.abspath(__file__)))
import harness
QD = os.path.dirname(os.path.abspath(__file__))
FX = os.path.join(QD, '..', 'riprove_veri')
os.makedirs(FX, exist_ok=True)
PROVA = 'LATI_A1_EMA200_U30USD_DISCESA_long.txt'
CASI = [
    ('LATI_ok',          {'sim': 'U30USD', 'legs': {'IS': ['ok']}}),
    ('LATI_riprovata',   {'sim': 'U30USD', 'legs': {'IS': ['dead', 'ok']}}),
    ('LATI_ko',          {'sim': 'U30USD', 'legs': {'IS': ['dead', 'dead']}}),
    ('LATI_ok_senzacsv', {'sim': 'U30USD', 'legs': {'IS': ['ok']}, 'deg_csv': 'none'}),
    ('LATI_is_altro',    {'sim': 'U30USD', 'legs': {'IS': ['altro']}}),
]
for nome, sc in CASI:
    e = harness.run_riga(nome, sc, extra=['-Deposito', '100000'], ea='ABTG_EMA200', prova=PROVA, lbl='LATIA1L', modello='4')
    print('== %s: exit %s, lanci %s, csv_IS %s, csv_OOS %s (%s byte)' % (nome, e['exit'], [l.split(' ini ')[0] for l in e['lanci']], e['csv_IS'], e['csv_OOS'], e.get('csv_OOS_byte')))
    # solo il percorso del banco di Linux e' sostituito (come in collaudo_riga_EMAGEM2/riprove_veri): tutto il resto e' come l'ha scritto il driver
    san = lambda t: t.replace(e['H'], '<banco_collaudo_riga_LATI>')
    if e['riprove']:
        open(os.path.join(FX, 'RIPROVE_%s.txt' % nome), 'w', newline='').write(san(e['riprove']))
    if e['referto']:
        open(os.path.join(FX, 'REFERTO_%s.txt' % nome), 'w', newline='').write(san(e['referto']))
    for l in (e['riprove'] or '').splitlines():
        if l.startswith('GAMBA'):
            print('   ' + l[:260])
    print('   ESITO referto:', [l for l in e['referto'].splitlines() if l.startswith('ESITO')])
