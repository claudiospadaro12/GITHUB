#!/usr/bin/env python3
# -*- coding: ascii -*-
"""
R264_GENERA.py -- 26/09/2026 -- genera i 19 file prova di R264 (EMA200 H4
a due lati su GBPUSD / AUDJPY / GBPJPY / XAUUSD) e di R265 (EMA200 H4
EURUSD solo CORTO). ASCII puro.

I pin (43 righe, tutte col flag esplicito) sono scritti UNA volta qui,
presi riga per riga dai CSV del genetico (valid_ABTG_EMA200_H4_realtick_*.csv,
commit b57374c4: tutti gli input fuori dagli assi sono COSTANTI, verificato
sui 4 file) piu' i due input nati dopo (InpUsaGuardian, InpLogImbuto),
nello stesso ordine di prove/R221a (che ha gia' passato il cancello).
Cambiano solo: lati, O1, O2, TP_RR, l'asse, il magic e il commento.

I due file di TESTA (R264a_controllo_..., R265a_atr_...) portano tutto il
ragionamento: la prosa sta in prove/R264_TESTA.txt.in e prove/R265_TESTA.txt.in
(ASCII, UNA sola sorgente; l'estensione .in li tiene fuori dai glob *.txt dei
cancelli). Gli altri 17 file portano solo le loro differenze.

USO:  python3 backtest_pipeline/prove/R264_GENERA.py            (scrive)
      python3 backtest_pipeline/prove/R264_GENERA.py --verifica (non scrive:
            rigenera in memoria e confronta byte per byte col disco)
"""
import os
import sys
import textwrap

QUI = os.path.dirname(os.path.abspath(__file__))

# ---------------------------------------------------------------------------
# I PIN. (nome, valore). Le stringhe (InpNewsFile, InpComment) si scrivono
# nude: niente '||' (formato di casa, come R221a).
# InpNewsCurrencies NON si scrive: il default compilato e' "" e un pin vuoto
# non arriva all'EA (controlla_prova, controllo 3). Nel genetico era "".
# ---------------------------------------------------------------------------
STRINGHE = {'InpNewsFile', 'InpComment'}


def pin_base(lungo, corto, o1, o2, tp):
    return [
        ('InpUsaGuardian', '1'),
        ('InpTF', '16388'),
        ('InpEmaPeriod', '200'),
        ('InpEma14Period', '14'),
        ('InpAtrPeriod', '14'),
        ('InpMinDistAtr', '0.3'),
        ('InpMaxDistAtr', '1.5'),
        ('InpUseEma14Bias', '1'),
        ('InpAllowLong', lungo),
        ('InpAllowShort', corto),
        ('InpUseAdrFilter', '0'),
        ('InpAdrDays', '50'),
        ('InpAdrDistMin', '0.0'),
        ('InpAdrDistMax', '0.8'),
        ('InpUseOrder2', '1'),
        ('InpPendingExpiryBars', '6'),
        ('InpSLatr', '1.0'),
        ('InpMinRR', '1.0'),
        ('InpTP1_ATRmult', '0.0'),
        ('InpTP1Pct', '50'),
        ('InpBreakeven', '1'),
        ('InpUseTrailing', '1'),
        ('InpUseCutoff', '0'),
        ('InpCutoffHour', '19'),
        ('InpCutoffMin', '0'),
        ('InpRiskPercent', '1.0'),
        ('InpMaxTradesPerDay', '0'),
        ('InpUseNewsFilter', '0'),
        ('InpNewsFile', 'abtg_news.csv'),
        ('InpNewsMinImpact', '3'),
        ('InpNewsBeforeMin', '60'),
        ('InpNewsAfterMin', '30'),
        ('InpNewsShiftMinutes', '0'),
        ('InpFridayClose', '0'),
        ('InpFridayCloseHour', '20'),
        ('InpMaxSpread', '0'),
        ('InpVerbose', '1'),
        ('InpLogImbuto', '1'),
        ('InpComment', 'X'),
        ('InpMagic', '0'),
        ('InpTP_RR', tp),
        ('InpOrder2Atr', o2),
        ('InpOrder1Atr', o1),
    ]


# ---------------------------------------------------------------------------
# LA FAMIGLIA. asse = (nome, start, step, stop): stop scritto CON MARGINE
# (0.31, 0.41, 3.01) = idioma di casa di R221a par. 9 / R169: il cancello
# conta int(|stop-start|/step)+1 SENZA epsilon, il driver CON 1e-9, e con lo
# stop esatto i due conteggi non tornano (0.15..0.30 passo 0.05 = 3 o 4).
# ---------------------------------------------------------------------------
F = []


def fam(nome, sim, tipo, modello, da, frz, lati, cella, asse, magic, desc,
        commento):
    F.append(dict(nome=nome, sim=sim, tipo=tipo, modello=modello, da=da,
                  frz=frz, lati=lati, cella=cella, asse=asse, magic=magic,
                  desc=desc, commento=commento))


DUE = ('1', '1')
CORTO = ('0', '1')
MONC = ('2023.12.31', '0.001')      # moncone: IS = 1 giorno, OOS = 2024.01.01 -> 2026.06.30
MAG2 = lambda m: ('InpMagic', str(m), '50', str(m + 50))

# --- R264a GBPUSD: IS 2020-2023 (4 anni) -------------------------------------
G_A = ('2020.01.01', '0.6157')
fam('R264a_controllo_EMA200_GBPUSD.txt', 'GBPUSD', 'controllo', 4, *MONC, DUE,
    ('0.25', '0.2', '2.0'), MAG2(796501), 796501,
    "G0 ANCORA GBPUSD: la cella citata dal referto (O1 0.25 / O2 0.2 / TP 2.0) sulla finestra del genetico, a tick", 'R264A G0')
for i, o2 in enumerate(('0.3', '0.4', '0.5'), 1):
    fam('R264a%d_o2_%s_EMA200_GBPUSD.txt' % (i, o2.replace('.', '') + '0'), 'GBPUSD', 'griglia', 1, *G_A, DUE,
        (None, o2, '2.0'), ('InpOrder1Atr', '0.10', '0.10', '0.31'), 796501 + i,
        "GRIGLIA GBPUSD: O2 = %s pinnato, asse O1 0.10 / 0.20 / 0.30, TP 2.0" % o2, 'R264A%d' % i)
fam('R264a4_uscita_EMA200_GBPUSD.txt', 'GBPUSD', 'uscita', 1, *G_A, DUE,
    ('0.20', '0.4', '2.0'), ('InpTP1Pct', '0', '25', '75'), 796505,
    "USCITA GBPUSD: centro della griglia (0.20 / 0.4 / TP 2.0), asse InpTP1Pct 0 / 25 / 50 / 75", 'R264A4')

# --- R264b AUDJPY: NIENTE griglia d'ingresso (par. 2 della testa) ------------
fam('R264b_controllo_EMA200_AUDJPY.txt', 'AUDJPY', 'controllo', 4, *MONC, DUE,
    ('0.05', '0.4', '3.0'), MAG2(796511), 796511,
    "G0 ANCORA AUDJPY: la cella citata dal referto (O1 0.05 / O2 0.4 / TP 3.0) = il 1,514", 'R264B G0')
fam('R264b1_ponte_R139a_EMA200_AUDJPY.txt', 'AUDJPY', 'ponte', 1, *MONC, DUE,
    ('0.25', '0.5', None), ('InpTP_RR', '1.5', '0.5', '3.01'), 796512,
    "PONTE AUDJPY: le 4 celle ESATTE di R139a (0.25 / 0.5, TP 1.5-3.0) sulla finestra del genetico, OHLC", 'R264B1 PONTE')

# --- R264c GBPJPY: IS 2019-2023 (5 anni) --------------------------------------
G_C = ('2019.01.01', '0.667')
fam('R264c_controllo_EMA200_GBPJPY.txt', 'GBPJPY', 'controllo', 4, *MONC, DUE,
    ('0.10', '0.4', '1.5'), MAG2(796521), 796521,
    "G0 ANCORA GBPJPY: la cella citata dal referto (O1 0.10 / O2 0.4 / TP 1.5)", 'R264C G0')
for i, o2 in enumerate(('0.5', '0.6', '0.7'), 1):
    fam('R264c%d_o2_%s_EMA200_GBPJPY.txt' % (i, o2.replace('.', '') + '0'), 'GBPJPY', 'griglia', 1, *G_C, DUE,
        (None, o2, '2.0'), ('InpOrder1Atr', '0.10', '0.10', '0.31'), 796521 + i,
        "GRIGLIA GBPJPY: O2 = %s pinnato, asse O1 0.10 / 0.20 / 0.30, TP 2.0" % o2, 'R264C%d' % i)
fam('R264c4_uscita_EMA200_GBPJPY.txt', 'GBPJPY', 'uscita', 1, *G_C, DUE,
    ('0.20', '0.6', '2.0'), ('InpTP1Pct', '0', '25', '75'), 796525,
    "USCITA GBPJPY: centro della griglia (0.20 / 0.6 / TP 2.0), asse InpTP1Pct 0 / 25 / 50 / 75", 'R264C4')

# --- R264d XAUUSD: IS 2017-2023 (7 anni) --------------------------------------
G_D = ('2017.01.01', '0.7371')
fam('R264d_controllo_EMA200_XAUUSD.txt', 'XAUUSD', 'controllo', 4, *MONC, DUE,
    ('0.30', '0.4', '2.5'), MAG2(796531), 796531,
    "G0 ANCORA XAUUSD: la cella citata dal referto (O1 0.30 / O2 0.4 / TP 2.5)", 'R264D G0')
for i, o2 in enumerate(('0.5', '0.6', '0.7'), 1):
    fam('R264d%d_o2_%s_EMA200_XAUUSD.txt' % (i, o2.replace('.', '') + '0'), 'XAUUSD', 'griglia', 1, *G_D, DUE,
        (None, o2, '2.0'), ('InpOrder1Atr', '0.10', '0.10', '0.31'), 796531 + i,
        "GRIGLIA XAUUSD: O2 = %s pinnato, asse O1 0.10 / 0.20 / 0.30, TP 2.0" % o2, 'R264D%d' % i)
fam('R264d4_uscita_EMA200_XAUUSD.txt', 'XAUUSD', 'uscita', 1, *G_D, DUE,
    ('0.20', '0.6', '2.0'), ('InpTP1Pct', '0', '25', '75'), 796535,
    "USCITA XAUUSD: centro della griglia (0.20 / 0.6 / TP 2.0), asse InpTP1Pct 0 / 25 / 50 / 75", 'R264D4')

# --- R265 EURUSD solo CORTO ----------------------------------------------------
fam('R265a_atr_controllo_EMA200_EURUSD_short.txt', 'EURUSD', 'atr', 1, *MONC, CORTO,
    ('0.30', '0.5', '1.5'), MAG2(798501), 798501,
    "G0 + LETTURA DELLO STOP (ATR H4) EURUSD CORTO: cella citata (0.30 / 0.5 / TP 1.5), finestra della scansione, OHLC", 'R265A ATR')
fam('R265b_short_o2_EMA200_EURUSD.txt', 'EURUSD', 'corto', 1, '2017.01.01', '0.7371', CORTO,
    ('0.20', None, '2.0'), ('InpOrder2Atr', '0.1', '0.1', '0.41'), 798502,
    "WALK-FORWARD EURUSD SOLO CORTO: O1 0.20 / TP 2.0 pinnati, asse O2 0.1 / 0.2 / 0.3 / 0.4", 'R265B')

TESTE = {'R264a_controllo_EMA200_GBPUSD.txt', 'R265a_atr_controllo_EMA200_EURUSD_short.txt'}


def blocco_pin(f):
    o1, o2, tp = f['cella']
    righe = pin_base(f['lati'][0], f['lati'][1], o1 or '0', o2 or '0', tp or '0')
    asse = f['asse']
    out = []
    for k, v in righe:
        if k == 'InpComment':
            out.append('InpComment=' + f['commento'].replace(' ', '_'))
            continue
        if k in STRINGHE:
            out.append(k + '=' + v)
            continue
        if k == 'InpMagic' and asse[0] != 'InpMagic':
            v = str(f['magic'])
        if k == asse[0]:
            # valore di partenza = start (per InpTP1Pct: 50 = il default, dentro l'asse)
            val = '50' if k == 'InpTP1Pct' else asse[1]
            out.append('%s=%s||%s||%s||%s||Y' % (k, val, asse[1], asse[2], asse[3]))
        else:
            out.append('%s=%s||%s||0||%s||N' % (k, v, v, v))
    assert sum(1 for r in out if r.endswith('||Y')) == 1
    assert len(out) == 43
    return out


def direttive(f):
    return ['@SIMBOLO    ' + f['sim'],
            '@PERIODO    H4',
            '@DAQUANDO   ' + f['da'],
            '@FINOA      2026.06.30',
            '@FRAZIONEIS ' + f['frz']]


def celle(f):
    a = f['asse']
    n = int(abs(float(a[3]) - float(a[1])) / float(a[2]) + 1e-9) + 1
    return n


def pertrade(f):
    if f['asse'][0] == 'InpMagic':
        m = int(f['asse'][1])
        return ['abtg_trades_ABTG_EMA200_%s_%d.csv' % (f['sim'], m),
                'abtg_trades_ABTG_EMA200_%s_%d.csv' % (f['sim'], m + 50)]
    return ['abtg_trades_ABTG_EMA200_%s_%d.csv' % (f['sim'], f['magic'])]


def testa_breve(f):
    r = []
    r.append('#  EA: ABTG_EMA200')
    r.append('# ' + '=' * 69)
    fam_ = 'R265' if f['nome'].startswith('R265') else 'R264'
    sig = f['nome'].split('_')[0]
    for i, riga in enumerate(textwrap.wrap(f['desc'], 62)):
        r.append(('#  %s -- ' % sig if i == 0 else '#    ') + riga)
    mod = ('MODELLO 4 (TICK REALI)' if f['modello'] == 4
           else 'MODELLO 1 (OHLC M1) = SCREENING: puo\' BOCCIARE, non PROMUOVERE')
    # 26/09 cancello: 10000 solo dove si rifa' l'archivio (G0, ponte,
    # R265a); 100000 nei walk-forward (classi 228/229, pavimento del lotto).
    dep = '10000' if f['tipo'] in ('controllo', 'ponte', 'atr') else '100000'
    r.append('#  Banco (sta nella RIGA di lancio, classe 692): -Deposito %s,' % dep)
    r.append('#    -' + mod + '.')
    if f['frz'] == '0.001':
        r.append('#  Finestra: MONCONE. IS = 2023.12.31 (domenica, 1 giorno: CSV _IS')
        r.append('#    vuoto e rc 2 ATTESI, cancello E0 della testa); OOS = 2024.01.01')
        r.append('#    -> 2026.06.30 = ESATTAMENTE la finestra del genetico/scansione.')
    else:
        r.append('#  Finestra: IS %s -> 2023.12.31 (MAI vista dal genetico)' % f['da'])
        r.append('#    OOS 2024.01.01 -> 2026.06.30 (= la finestra del genetico: NON')
        r.append('#    cieca a livello di vicinato, testa par. 4). @FRAZIONEIS %s:' % f['frz'])
        r.append('#    driver r.934 Meta = Inizio + floor(giorni x frazione) = 2023.12.31.')
    a = f['asse']
    r.append('#  Asse: %s da %s a %s passo %s = %d celle x 2 finestre = %d passate.'
             % (a[0], a[1], a[3], a[2], celle(f), 2 * celle(f)))
    o1, o2, tp = f['cella']
    lat = 'DUE LATI' if f['lati'] == DUE else 'SOLO CORTO (InpAllowLong=0)'
    r.append('#  Pin che cambiano rispetto agli altri file: %s, O1 %s, O2 %s, TP %s,'
             % (lat, o1 or 'ASSE', o2 or 'ASSE', tp or 'ASSE'))
    r.append('#    InpComment=%s, InpMagic %s.' % (f['commento'].replace(' ', '_'),
             ('%s / %s (gemelle, passo 50)' % (a[1], a[3])) if a[0] == 'InpMagic' else str(f['magic'])))
    r.append('#  Per-trade atteso in Common\\Files (sovrascritto a ogni passata:')
    r.append('#    resta l\'ULTIMA, classe 455):')
    for p in pertrade(f):
        r.append('#      ' + p)
    testa = ('prove/R264a_controllo_EMA200_GBPUSD.txt' if fam_ == 'R264'
             else 'prove/R265a_atr_controllo_EMA200_EURUSD_short.txt')
    r.append('#  ATTESE, SOGLIE, CANCELLI E BUCHI: nel file di TESTA')
    r.append('#    ' + testa + ' (par. %s).' % SEZ.get(f['nome'], 'tutti'))
    r.extend(EXTRA.get(f['nome'], []))
    r.append('#  GIRA SOLO SUL PC DI BACKTEST DESKTOP-H4D7CAJ, MAI SUL VPS (firma')
    r.append('#  del 21/09/2026). Nessuna riga di lancio qui. Non tocca EA, preset,')
    r.append('#  sedie, conti, taglie o il forward. Generato da prove/R264_GENERA.py.')
    r.append('# ' + '=' * 69)
    return r


SEZ = {}
EXTRA = {}
for f in F:
    n = f['nome']
    if f['tipo'] == 'controllo':
        SEZ[n] = '5 (G0, G1, C0, K1) e 7'
    elif f['tipo'] == 'griglia':
        SEZ[n] = '6 (griglia), 7 (attese), 8 (soglie)'
    elif f['tipo'] == 'uscita':
        SEZ[n] = '6.3 (uscita), 7, 8'
    elif f['tipo'] == 'ponte':
        SEZ[n] = '9 (il conflitto AUDJPY)'
    elif f['tipo'] == 'corto':
        SEZ[n] = '3-7'

EXTRA['R264b1_ponte_R139a_EMA200_AUDJPY.txt'] = [
    '#  >>> ATTESA SCRITTA PRIMA (testa par. 9): DEVE CONFERMARE R139a.',
    '#      CONFERMA  = almeno 3 celle su 4 con PF >= 1,45: il 1,514 e\' una',
    '#                  FETTA D\'EPOCA, R139a (MORTO) regge, AUDJPY resta in',
    '#                  archivio e R221b diventa ridondante (proposta).',
    '#      SMENTITA  = almeno 3 su 4 sotto 1,25: OHLC e tick non concordano',
    '#                  sulla STESSA finestra -> il verdetto di R139a perde il',
    '#                  banco -> AUDJPY "NON ANCORA MISURATO" (non resuscitato).',
    '#      in mezzo  = NON CONCLUDENTE, e si scrive cosi\'.',
    '#      Previsione puntuale: CONFERMA, PF 1,55-1,95 (tick d\'archivio',
    '#      1,62295-1,71095 su 3 di queste 4 celle + scarto OHLC-tick misurato',
    '#      su AUDJPY H4 +0,040 / +0,167).',
]
EXTRA['R265b_short_o2_EMA200_EURUSD.txt'] = [
    '#  !!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!',
    '#  !!! NON LANCIARE finche\' R265a non ha dato K1 = PASS:            !!!',
    '#  !!! mediana dei LIMITI BASSI dello stop dell\'ORDINE 2 (= 1,0 x   !!!',
    '#  !!! ATR14 H4, il piu\' corto) >= 40 x 0,6636 pip (pedaggio all-in !!!',
    '#  !!! mediano EURUSD) = 26,54 pip. FAIL: EURUSD H4 ESCLUSO PER     !!!',
    '#  !!! COSTO col numero accanto; NON RISOLTO: fermo. In tutti e due !!!',
    '#  !!! i casi questo file NON parte (testa R265a par. 2).           !!!',
    '#  !!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!',
]


def file_testo(f):
    if f['nome'] == 'R264a_controllo_EMA200_GBPUSD.txt':
        testa = TESTA_R264.strip('\n').split('\n')
    elif f['nome'] == 'R265a_atr_controllo_EMA200_EURUSD_short.txt':
        testa = TESTA_R265.strip('\n').split('\n')
    else:
        testa = testa_breve(f)
    corpo = direttive(f) + [''] + blocco_pin(f)
    return '\n'.join(testa + corpo) + '\n'


TESTA_R264 = open(os.path.join(QUI, 'R264_TESTA.txt.in'), encoding='ascii').read() \
    if os.path.exists(os.path.join(QUI, 'R264_TESTA.txt.in')) else None
TESTA_R265 = open(os.path.join(QUI, 'R265_TESTA.txt.in'), encoding='ascii').read() \
    if os.path.exists(os.path.join(QUI, 'R265_TESTA.txt.in')) else None


def main():
    verifica = '--verifica' in sys.argv
    if TESTA_R264 is None or TESTA_R265 is None:
        print('mancano R264_TESTA.txt.in / R265_TESTA.txt.in accanto allo script')
        return 2
    diff = 0
    tot = 0
    for f in F:
        t = file_testo(f)
        t.encode('ascii')
        p = os.path.join(QUI, f['nome'])
        tot += 2 * celle(f)
        if verifica:
            ok = os.path.exists(p) and open(p, encoding='ascii').read() == t
            print(('OK   ' if ok else 'DIFF ') + f['nome'])
            diff += 0 if ok else 1
        else:
            with open(p, 'w', encoding='ascii', newline='\n') as h:
                h.write(t)
            print('scritto ' + f['nome'] + '  (%d celle)' % celle(f))
    print('file: %d  passate (celle x 2): %d' % (len(F), tot))
    return 1 if diff else 0


if __name__ == '__main__':
    sys.exit(main())
