#!/usr/bin/env python3
# -*- coding: ascii -*-
"""
R255_GENERA.py -- 26/09/2026 -- genera i 24 file prova di R255
(IL LATO SHORT DELL'APERTURA DOW). ASCII puro.

I pin vengono da prove/R254c_trailfix_770202_PIN.txt (la sedia 770202
tradotta FTMO -> BCM, PASS del cancello), letti dal file, NON ricopiati a
mano. Cambiano SOLO le righe elencate in CONFIG e ORE. Il file di testa
(R255a) porta tutto il ragionamento ed e' scritto a mano: di R255a il
generatore rifa' SOLO il blocco dei pin; gli altri 23 li scrive interi.

USO:  python3 backtest_pipeline/prove/R255_GENERA.py        (scrive i 24 file)
      python3 backtest_pipeline/prove/R255_GENERA.py --verifica   (non scrive:
            rigenera in memoria e confronta byte per byte coi file su disco)
"""
import collections
import os
import sys

QUI = os.path.dirname(os.path.abspath(__file__))
BASE = os.path.join(QUI, 'R254c_trailfix_770202_PIN.txt')

# ---------------------------------------------------------------------------
# le configurazioni: (sigla, descrizione breve, differenze rispetto alla BASE)
# BASE = R254c (770202 long, EMA H4 acceso) con i lati girati allo SHORT.
# ---------------------------------------------------------------------------
SHORT = collections.OrderedDict([('InpAllowLong', 'false'), ('InpAllowShort', 'true')])
CONFIG = [
    ('ancora',  "SHORT ANCORA = la 770202 a specchio (EMA H4 1/50 acceso, gestione della sedia)", dict(SHORT)),
    ('nudo',    "SHORT NUDO = ancora con il filtro EMA SPENTO", dict(SHORT, InpUseEmaFilter='false')),
    ('parz0',   "USCITA: ancora con InpTP1_ClosePct = 0 (spegne ANCHE il BE)", dict(SHORT, InpTP1_ClosePct='0.0')),
    ('tp05',    "USCITA: ancora con InpTP1_R = 0.5 (TP finale 1,5R)", dict(SHORT, InpTP1_R='0.5')),
    ('tp15',    "USCITA: ancora con InpTP1_R = 1.5 (TP finale 4,5R)", dict(SHORT, InpTP1_R='1.5')),
    ('trail0',  "USCITA: ancora con InpUseTrailing = false", dict(SHORT, InpUseTrailing='false')),
    ('stH4',    "REGIME: nudo + Supertrend H4 (10 / 2,5)", dict(SHORT, InpUseEmaFilter='false', InpUseSupertrend='true', InpStTF='16388')),
    ('stH6',    "REGIME: nudo + Supertrend H6 (10 / 2,5)", dict(SHORT, InpUseEmaFilter='false', InpUseSupertrend='true', InpStTF='16390')),
    ('stH8',    "REGIME: nudo + Supertrend H8 (10 / 2,5)", dict(SHORT, InpUseEmaFilter='false', InpUseSupertrend='true', InpStTF='16392')),
    ('stH12',   "REGIME: nudo + Supertrend H12 (10 / 2,5)", dict(SHORT, InpUseEmaFilter='false', InpUseSupertrend='true', InpStTF='16396')),
    ('stD1',    "REGIME: nudo + Supertrend D1 (10 / 2,5)", dict(SHORT, InpUseEmaFilter='false', InpUseSupertrend='true', InpStTF='16408')),
    ('long',    "LONG DI RIFERIMENTO = la 770202 com'e' (non decide niente)", {}),
]
ORE = [('1430', '14', '17'), ('1530', '15', '18')]
LETTERE = 'abcdefghijklmnopqrstuvwx'
MAGIC0 = 793101


def pin_base():
    righe = []
    for l in open(BASE, encoding='ascii'):
        if l.startswith('Inp'):
            k, v = l.rstrip('\n').split('=', 1)
            righe.append((k, v.split('||')[0]))
    nomi = [k for k, _v in righe]
    assert len(nomi) == len(set(nomi)) == 80, len(nomi)
    return righe


STRINGHE = {'InpCorrSymbol', 'InpNewsFile'}


def blocco_pin(diff, ora, chiusura, magic):
    out = []
    for k, v in pin_base():
        if k == 'InpMagic':
            out.append('InpMagic=%d||%d||50||%d||Y' % (magic, magic, magic + 50))
            continue
        if k == 'InpSessionHour':
            v = ora
        elif k == 'InpCloseHour':
            v = chiusura
        elif k in diff:
            v = diff[k]
        if k in STRINGHE:
            out.append('%s=%s' % (k, v))
        else:
            out.append('%s=%s||%s||0||%s||N' % (k, v, v, v))
    return out


def famiglia():
    fam = []
    i = 0
    for sig, desc, diff in CONFIG:
        for tag, ora, chi in ORE:
            fam.append(dict(lettera=LETTERE[i], sig=sig, desc=desc, diff=diff, tag=tag, ora=ora,
                            chi=chi, magic=MAGIC0 + i,
                            nome='R255%s_%s_DOW_%s_%s.txt' % (LETTERE[i], 'long' if sig == 'long' else 'short',
                                                             sig, tag)))
            i += 1
    return fam


def testa_breve(f):
    lato = 'LONG' if f['sig'] == 'long' else 'SHORT'
    r = []
    r.append('#  EA: ABTG_Dow_Apertura_US')
    r.append('# =====================================================================')
    r.append('#  R255%s -- IL LATO SHORT DELL\'APERTURA DOW -- %s' % (f['lettera'], lato))
    r.append('#  U30USD M5, TICK REALI, deposito 10000 (banco), rischio 1% (banco)')
    r.append('#  CONFIGURAZIONE "%s": %s' % (f['sig'], f['desc']))
    if f['tag'] == '1430':
        r.append('#  OROLOGIO 14:30 / flat 17:30 BCM = cash NY in ORA LEGALE USA.')
        r.append('#  Entrano nella curva IN FASE solo le righe d\'ESTATE (calendario USA);')
        r.append('#  TUTTE le righe fanno la curva CONTROLLO (BCM a ora fissa).')
    else:
        r.append('#  OROLOGIO 15:30 / flat 18:30 BCM = cash NY in ORA SOLARE USA.')
        r.append('#  @ORARIO_INVERNALE R255: armo 15:30 BCM = 9:30 EST, cash NY in ora solare USA (BCM')
        r.append('#  indici UTC+1 fisso); di questa corsa entrano nella curva IN FASE SOLO le righe')
        r.append('#  d\'INVERNO USA, quelle d\'estate (10:30 EDT, un\'ora DOPO la cash) si scrivono e basta.')
    r.append('#  Magic %d / %d (asse gemello a passo 50: G1 e un per-trade per' % (f['magic'], f['magic'] + 50))
    r.append('#  gemella). Per-trade atteso in Common\\Files:')
    r.append('#    abtg_trades_ABTG_Dow_Apertura_US_U30USD_%d.csv e _%d.csv' % (f['magic'], f['magic'] + 50))
    r.append('#')
    r.append('#  TUTTO IL RAGIONAMENTO, I PIN, L\'OROLOGIO, LE ATTESE E I CANCELLI')
    r.append('#  STANNO NEL FILE DI TESTA: prove/R255a_short_DOW_ancora_1430.txt.')
    r.append('#  Qui solo le differenze. Rispetto alla BASE (prove/R254c_trailfix_')
    r.append('#  770202_PIN.txt, input per input) cambiano SOLO:')
    diff = collections.OrderedDict()
    diff['InpSessionHour'] = f['ora'] + ' (BASE 14)'
    diff['InpCloseHour'] = f['chi'] + ' (BASE 17)'
    for k, v in f['diff'].items():
        diff[k] = v
    diff['InpMagic'] = '%d||%d||50||%d||Y' % (f['magic'], f['magic'], f['magic'] + 50)
    for k, v in diff.items():
        r.append('#    %s = %s' % (k, v))
    r.append('#  (generato da prove/R255_GENERA.py: diff dei pin eseguito nel')
    r.append('#   generatore, non a mano; --verifica lo rifa\' contro il disco)')
    r.append('#')
    r.append('#  GIRA SOLO SUL PC DI BACKTEST DESKTOP-H4D7CAJ, MAI SUL VPS.')
    r.append('#  Banco: -Deposito 10000, -Modello 4, niente -Spread / -Ritardo /')
    r.append('#  -FrazioneIS, MaxBars=100000000 (testa, riquadro iniziale). Nessuna')
    r.append('#  riga di lancio qui. Non tocca preset, EA, sedie, conti, taglie.')
    r.append('# =====================================================================')
    return r


def file_testo(f):
    if f['lettera'] == 'a':
        # la TESTA di R255a e' scritta a mano: se ne prende l'intestazione
        # (tutto cio' che precede '@SIMBOLO') e si rigenera SOLO il blocco pin
        testo = open(os.path.join(QUI, f['nome']), encoding='ascii').read().split('\n')
        righe = testo[:[i for i, l in enumerate(testo) if l.startswith('@SIMBOLO')][0]]
    else:
        righe = testa_breve(f)
    righe += ['@SIMBOLO    U30USD', '@PERIODO    M5', '@DAQUANDO   2024.09.26', '@FINOA      2026.06.30',
              '@FRAZIONEIS 0.001', '']
    righe += blocco_pin(f['diff'], f['ora'], f['chi'], f['magic'])
    return '\n'.join(righe) + '\n'


def main():
    verifica = '--verifica' in sys.argv
    bad = 0
    for f in famiglia():
        t = file_testo(f)
        t.encode('ascii')
        p = os.path.join(QUI, f['nome'])
        if verifica:
            ok = os.path.exists(p) and open(p, encoding='ascii').read() == t
            bad += not ok
            print('%-45s %s' % (f['nome'], 'IDENTICO' if ok else 'DIVERSO'))
        else:
            open(p, 'w', encoding='ascii', newline='\n').write(t)
            print('scritto', f['nome'], f['magic'], f['magic'] + 50)
    sys.exit(1 if bad else 0)


if __name__ == '__main__':
    main()
