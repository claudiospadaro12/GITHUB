#!/usr/bin/env python3
# -*- coding: ascii -*-
"""
r246_giudizio.py -- 24/09/2026

IL GIUDIZIO DI R246 "OROLOGIO O STAGIONE?" COI CRITERI CONGELATI PRIMA.
Tutto si calcola dai file archiviati (niente numeri a mano):
    backtest_pipeline/risultati_archivio/R246/ROUND_R246a..l/*.csv
    backtest_pipeline/risultati_archivio/R246/PERTRADE/abtg_trades_*_7946xx.csv
Criteri: prove/R246a_orologio_DOW_U30USD_d0_B.txt par. 5-8 (e R246e, R246i),
calendario e funzioni da r246_bande_attese.py (importate, non ricopiate).

ORDINE OBBLIGATORIO (classe 750: i cancelli PRIMA dei numeri):
  1. G1 determinismo (ogni file)      2. G0 riproduzione (d0 finestra B)
  3. G2 coerenza fra finestre          4. S1 sentinella dell'orologio
  5. SOLO DOPO: verdetto PF (Dow) e verdetto FREQUENZA (tutti e tre).
  I per-trade -1h NON si aprono per i verdetti prima che G0 sia deciso
  (se G0 e' ROSSO si rifanno PRIMA le bande col per-trade d0 B del round).

REGOLA G1 APPLICATA ALLA LETTERA (par. 5, testo congelato):
  "le due gemelle identiche in Profit, PF, DD, Trades in tutti e due i CSV,
   e i due per-trade identici RIGA PER RIGA tranne la colonna magic.
   Se no -> quel file e' NULLO."
  Nessuna tolleranza: un centesimo e' una differenza. La DIAGNOSI (campi
  decisionali identici? scarto solo in net_profit?) si stampa accanto, ma
  NON cambia l'esito del cancello. I verdetti su file NULLI si stampano come
  lettura SOSPESA, con la prova di invarianza (stesso verdetto con l'una o
  l'altra gemella), e la decisione resta a Claudio.

USO:   python3 backtest_pipeline/r246_giudizio.py            (~1 s)
       python3 backtest_pipeline/r246_giudizio.py --autotest (contro-esempi)
"""
import collections
import copy
import csv
import datetime as dt
import os
import sys

QUI = os.path.dirname(os.path.abspath(__file__))
sys.path.insert(0, QUI)
import r246_bande_attese as rb  # noqa: E402  (calendario, feriali, pf)

ARCH = os.path.join(QUI, 'risultati_archivio', 'R246')
PT = os.path.join(ARCH, 'PERTRADE')

# ---------------------------------------------------------------- disegno
# lettera -> (EA-chiave, orologio, finestra, magic m); gemella = m + 50
EA = {
    'DOW': ('ABTG_Dow_Apertura_US', 'U30USD', 'USA'),
    'DAX': ('ABTG_DAX_Apertura_EU', 'D30EUR', 'UE'),
    'MM':  ('ABTG_MaxMinNotte_DAX_Short_Ottimizzato', 'D30EUR', 'UE'),
}
FILES = {
    'a': ('DOW', 'd0', 'B', 794601), 'b': ('DOW', '-1h', 'B', 794602),
    'c': ('DOW', 'd0', 'A', 794603), 'd': ('DOW', '-1h', 'A', 794604),
    'e': ('DAX', 'd0', 'B', 794611), 'f': ('DAX', '-1h', 'B', 794612),
    'g': ('DAX', 'd0', 'A', 794613), 'h': ('DAX', '-1h', 'A', 794614),
    'i': ('MM', 'd0', 'B', 794621), 'j': ('MM', '-1h', 'B', 794622),
    'k': ('MM', 'd0', 'A', 794623), 'l': ('MM', '-1h', 'A', 794624),
}
# G0: numeri di riferimento congelati (R246a par. 5, R246e, R246i) + per-trade
G0_RIF = {
    'a': dict(IS=('2811.84', '1.22247', '5.6692', '74'), OOS=('6721.93', '1.27013', '4.3941', '130'),
              pt='risultati_prove/aperture_r47/abtg_trades_ABTG_Dow_Apertura_US_U30USD_772505.csv',
              righe=130, pos=96, somma='6721.93'),
    'e': dict(IS=('3789.36', '1.12634', '5.4362', '175'), OOS=('18029.58', '1.39709', '7.2328', '270'),
              pt='risultati_prove/aperture_r47/abtg_trades_ABTG_DAX_Apertura_EU_D30EUR_772501.csv',
              righe=270, pos=193, somma='18029.58'),
    'i': dict(IS=('4766.96', '1.87803', '3.0977', '20'), OOS=('6143.38', '2.15985', '1.9213', '21'),
              pt='risultati_prove/trades_portafoglio/abtg_trades_ABTG_MaxMinNotte_DAX_Short_Ottimizzato_D30EUR_770413.csv',
              righe=21, pos=14, somma='6143.38'),
}
G2_COPPIE = [('c', 'a'), ('d', 'b'), ('g', 'e'), ('h', 'f'), ('k', 'i'), ('l', 'j')]
# S1 (par. 5, R246e, R246i): (d0 minimo uscita, d0 massimo, -1h massimo, -1h soglia "prima di")
S1_SOGLIE = {
    'DOW': dict(d0_min='15:05:00', d0_max='17:31:00', m1_max='16:31:00', m1_prima='15:05:00', m1_quota=0.10),
    'DAX': dict(d0_min='08:35:00', d0_max='17:31:00', m1_max='16:31:00', m1_prima='08:35:00', m1_quota=0.10),
    'MM':  dict(d0_min='08:00:00', d0_max=None, m1_max='16:31:00', m1_prima='08:00:00', m1_quota=None),
}
# par. 7: precondizioni
PRE_PF = {'DOW': 0.44}
PRE_F = {'DOW': 0.054, 'DAX': 0.067, 'MM': 0.018}
# bande p10-p90 CONGELATE della cella -1h d'estate su A+B (R246a par. 6,
# R246e, R246i; rifatte da r246_bande_attese.py sez. 1): (H_STAGIONE, H_OROLOGIO)
BANDE_PF = {'DOW': ((0.55, 1.15), (1.27, 2.22)), 'DAX': ((0.94, 1.79), (1.18, 1.90)),
            'MM': ((0.69, 7.52), (1.16, 4.51))}
BANDE_POS = {'DOW': ((76.9, 96.7), (106.4, 127.5)), 'DAX': ((144.3, 163.1), (177.1, 193.4)),
             'MM': ((4.9, 12.3), (12.1, 22.4))}
CAMPI_CSV = ('Profit', 'Profit Factor', 'Equity DD %', 'Trades')
CAMPI_DECISIONALI = ('close_time', 'symbol', 'position_id', 'deal_type', 'volume', 'price')


# ---------------------------------------------------------------- lettura
def csv_round(lett, gamba):
    k = FILES[lett][0]
    p = os.path.join(ARCH, 'ROUND_R246' + lett, f"{EA[k][0]}_{EA[k][1]}_{gamba}_R246{lett}.csv")
    if not os.path.exists(p) or os.path.getsize(p) == 0:
        return None
    with open(p, newline='') as fh:
        return {int(r['InpMagic']): r for r in csv.DictReader(fh)}


def pertrade_path(lett, magic):
    k = FILES[lett][0]
    return os.path.join(PT, f"abtg_trades_{EA[k][0]}_{EA[k][1]}_{magic}.csv")


def leggi_pt(path):
    with open(path, newline='') as fh:
        return list(csv.DictReader(fh, delimiter=';'))


def cent(s):
    """importo in centesimi interi (niente float: il confronto e' esatto)"""
    s = s.strip()
    neg = s.startswith('-')
    a, _, b = s.lstrip('-').partition('.')
    v = int(a) * 100 + int((b + '00')[:2])
    return -v if neg else v


def ora(r):
    return r['close_time'][11:19]


def giorno(r):
    return dt.datetime.strptime(r['close_time'][:10], '%Y.%m.%d').date()


# ---------------------------------------------------------------- G1
def g1_confronta(csv_is, csv_oos, pt_m, pt_g, m, g):
    """ritorna (esito, lista differenze, diagnosi)"""
    diff = []
    for nome, c in (('IS', csv_is), ('OOS', csv_oos)):
        if c is None:
            continue
        for f in CAMPI_CSV:
            if c[m][f] != c[g][f]:
                diff.append(f"CSV {nome} {f}: {c[m][f]} vs {c[g][f]}")
    diag = []
    if len(pt_m) != len(pt_g):
        diff.append(f"per-trade righe {len(pt_m)} vs {len(pt_g)}")
    else:
        for i, (x, y) in enumerate(zip(pt_m, pt_g), 2):
            dx = {k: v for k, v in x.items() if k != 'magic'}
            dy = {k: v for k, v in y.items() if k != 'magic'}
            if dx != dy:
                campi = [k for k in dx if dx[k] != dy[k]]
                diff.append(f"per-trade riga {i}: " + ", ".join(f"{k} {dx[k]} vs {dy[k]}" for k in campi))
                dec = [k for k in campi if k in CAMPI_DECISIONALI]
                diag.append((i, x['close_time'], campi, dec,
                             cent(dy['net_profit']) - cent(dx['net_profit']) if 'net_profit' in campi else 0))
    return ('PASS' if not diff else 'NULLO'), diff, diag


def cancello_g1(ptcache):
    out = {}
    for lett, (k, orol, fin, m) in FILES.items():
        g = m + 50
        ci, co = csv_round(lett, 'IS'), csv_round(lett, 'OOS')
        out[lett] = g1_confronta(ci, co, ptcache[(lett, m)], ptcache[(lett, g)], m, g)
    return out


# ---------------------------------------------------------------- G0
def cancello_g0(ptcache):
    out = {}
    for lett, rif in G0_RIF.items():
        m = FILES[lett][3]
        ci, co = csv_round(lett, 'IS'), csv_round(lett, 'OOS')
        ref = leggi_pt(os.path.join(QUI, rif['pt']))
        esiti = []
        for tw in (m, m + 50):
            csv_ok = all(tuple(c[tw][f] for f in CAMPI_CSV) == rif[g]
                         for c, g in ((ci, 'IS'), (co, 'OOS')))
            pt = ptcache[(lett, tw)]
            pt_ok = [{k: v for k, v in r.items() if k != 'magic'} for r in pt] == \
                    [{k: v for k, v in r.items() if k != 'magic'} for r in ref]
            n_pos = len({r['position_id'] for r in pt})
            somma = sum(cent(r['net_profit']) for r in pt)
            conta_ok = (len(pt), n_pos, somma) == (rif['righe'], rif['pos'], cent(rif['somma']))
            if csv_ok and pt_ok and conta_ok:
                e = 'VERDE'
            else:
                tr_ok = all(c[tw]['Trades'] == rif[g][3] for c, g in ((ci, 'IS'), (co, 'OOS')))
                dp = max(abs(cent(c[tw]['Profit']) - cent(rif[g][0])) / abs(cent(rif[g][0]))
                         for c, g in ((ci, 'IS'), (co, 'OOS')))
                e = 'GIALLO' if (tr_ok and dp <= 0.01) else 'ROSSO'
            esiti.append((tw, e, csv_ok, pt_ok, len(pt), n_pos, somma))
        out[lett] = esiti
    return out


def bande_rifatte_se_rosso(g0):
    """par. 5: con G0 non VERDE/GIALLO le bande si rifanno sul per-trade d0 B
    del round PRIMA di aprire i -1h. Qui: si ripuntano le F di r246_bande_attese."""
    rossi = [l for l, es in g0.items() if all(e[1] == 'ROSSO' for e in es)]
    if not rossi:
        return False
    k2rb = {'DOW': 'DOW', 'DAX': 'DAX', 'MM': 'MM'}
    for l in rossi:
        k, _, _, m = FILES[l]
        rb.F[k2rb[k]] = (os.path.relpath(pertrade_path(l, m), QUI), EA[k][2])
    print("  G0 ROSSO su", rossi, "-> bande rifatte sul per-trade d0 B del round:")
    rb.main()
    rb.sezione4()
    return True


# ---------------------------------------------------------------- G2
def cancello_g2(ptcache):
    out = []
    for la, lb in G2_COPPIE:
        ma, mb = FILES[la][3], FILES[lb][3]
        cb = csv_round(lb, 'IS')
        righe = []
        for off in (0, 50):
            pt = ptcache[(la, ma + off)]
            s, n = sum(cent(r['net_profit']) for r in pt), len(pt)
            rb_ = cb[mb + off]
            ok = (s == cent(rb_['Profit']) and n == int(rb_['Trades']))
            giorno26 = sum(1 for r in pt if r['close_time'].startswith('2024.09.26'))
            righe.append((off, s, n, rb_['Profit'], rb_['Trades'], ok, giorno26))
        out.append((la, lb, righe))
    return out


# ---------------------------------------------------------------- S1
def s1_cella(k, orol, pt, pt_d0=None):
    S = S1_SOGLIE[k]
    ore = [ora(r) for r in pt]
    n = len(ore)
    note = []
    if orol == 'd0':
        prima = sum(o < S['d0_min'] for o in ore)
        dopo = sum(o > S['d0_max'] for o in ore) if S['d0_max'] else 0
        esito = 'VERDE' if (prima == 0 and dopo == 0) else 'ROSSO'
        note.append(f"uscite prima delle {S['d0_min'][:5]}: {prima}/{n}")
        if S['d0_max']:
            note.append(f"dopo le {S['d0_max'][:5]}: {dopo}/{n}")
        note.append(f"min {min(ore)} max {max(ore)}")
        return esito, note
    ident = pt_d0 is not None and [{kk: v for kk, v in r.items() if kk != 'magic'} for r in pt] == \
        [{kk: v for kk, v in r.items() if kk != 'magic'} for r in pt_d0]
    dopo = sum(o > S['m1_max'] for o in ore)
    prima = sum(o < S['m1_prima'] for o in ore)
    note.append(f"identico a d0: {'SI' if ident else 'no'}")
    note.append(f"dopo le {S['m1_max'][:5]}: {dopo}/{n}")
    note.append(f"prima delle {S['m1_prima'][:5]}: {prima}/{n} = {prima / n:.1%}" if n else "n=0")
    note.append(f"min {min(ore)} max {max(ore)}" if n else "")
    if ident or dopo > 0 or n == 0:
        return 'ROSSO', note
    if S['m1_quota'] is not None:
        return ('VERDE' if prima / n >= S['m1_quota'] else 'ROSSO'), note
    return ('VERDE' if prima >= 1 else 'GIALLO'), note


def cancello_s1(ptcache):
    out = {}
    for lett, (k, orol, fin, m) in FILES.items():
        d0 = None
        if orol == '-1h':
            gem = [l for l, v in FILES.items() if v[0] == k and v[1] == 'd0' and v[2] == fin][0]
            d0 = ptcache[(gem, FILES[gem][3])]
        out[lett] = s1_cella(k, orol, ptcache[(lett, m)], d0)
    return out


# ---------------------------------------------------------------- misure
def stagione(d, cal):
    return 'I' if rb.inverno(d, cal) else 'E'


def feriali_AB(cal):
    fa, fb = rb.feriali(*rb.A, cal), rb.feriali(*rb.B, cal)
    return dict(E=fa[0] + fb[0], I=fa[1] + fb[1], AE=fa[0], AI=fa[1], BE=fb[0], BI=fb[1])


def aggrega(celle, cal):
    """celle = lista di (etichetta, per-trade). PF sui deal, n = posizioni
    (etichetta, position_id) distinte, per stagione della DATA DI CHIUSURA."""
    s = {x: dict(deal=[], pos=set()) for x in ('E', 'I')}
    for et, pt in celle:
        for r in pt:
            z = stagione(giorno(r), cal)
            s[z]['deal'].append(cent(r['net_profit']) / 100.0)
            s[z]['pos'].add((et, r['position_id']))
    return {z: dict(pf=rb.pf(v['deal']), deal=len(v['deal']), pos=len(v['pos']),
                    netto=round(sum(v['deal']), 2)) for z, v in s.items()}


def dd_saldo(pt, dep=100000.0):
    """DD massimo sul SALDO A DEAL CHIUSI (non equity): EUR e % del picco."""
    sal, picco, dd, ddp = dep, dep, 0.0, 0.0
    for r in sorted(pt, key=lambda r: r['close_time']):
        sal += cent(r['net_profit']) / 100.0
        picco = max(picco, sal)
        if picco - sal > dd:
            dd, ddp = picco - sal, (picco - sal) / picco
    return dd, ddp


def zona(q):
    return 'STAGIONE' if q <= 0.30 else ('OROLOGIO' if q >= 0.70 else 'MISTO / NON SEPARATO')


def verdetti(k, pt_d0A, pt_d0B, pt_m1A, pt_m1B):
    cal = EA[k][2]
    fer = feriali_AB(cal)
    d0 = aggrega([('A', pt_d0A), ('B', pt_d0B)], cal)
    m1 = aggrega([('A', pt_m1A), ('B', pt_m1B)], cal)
    r = dict(k=k, fer=fer, d0=d0, m1=m1)
    D = d0['I']['pf'] - d0['E']['pf']
    r['D'] = D
    r['Q'] = (m1['E']['pf'] - d0['E']['pf']) / D if D else float('nan')
    if k in PRE_PF:
        r['pf_verdetto'] = zona(r['Q']) if D >= PRE_PF[k] else 'DIVARIO NON RIPRODOTTO SU DUE INVERNI'
    else:
        r['pf_verdetto'] = 'NON DISCRIMINANTE PER COSTRUZIONE (classe 178): solo lettura'
    rE0, rI0 = d0['E']['pos'] / fer['E'], d0['I']['pos'] / fer['I']
    rE1 = m1['E']['pos'] / fer['E']
    Df = rI0 - rE0
    r.update(rE0=rE0, rI0=rI0, rE1=rE1, rI1=m1['I']['pos'] / fer['I'], Df=Df,
             Qf=(rE1 - rE0) / Df if Df else float('nan'))
    r['f_verdetto'] = zona(r['Qf']) if Df >= PRE_F[k] else 'DIVARIO NON RIPRODOTTO SU DUE INVERNI'
    # lettura descrittiva: i due inverni separati (d0)
    iA = aggrega([('A', pt_d0A)], cal)['I']
    iB = aggrega([('B', pt_d0B)], cal)['I']
    eA = aggrega([('A', pt_d0A)], cal)['E']
    eB = aggrega([('B', pt_d0B)], cal)['E']
    r['inverni'] = (iA, iB)
    r['estati'] = (eA, eB)
    # DD per stagione [DERIVATO]: saldo a deal chiusi, sequenza A poi B della
    # sola stagione (i due run partono ognuno da 100000: si concatenano i P/L)
    for nome, celle in (('d0', (pt_d0A, pt_d0B)), ('m1', (pt_m1A, pt_m1B))):
        for z in ('E', 'I'):
            seq = [x for c in celle for x in sorted(c, key=lambda y: y['close_time'])
                   if stagione(giorno(x), cal) == z]
            r[f'dd_{nome}_{z}'] = dd_saldo(seq)
    return r


def fragilita(k, celle):
    """jackknife descrittivo: si toglie UNA posizione alla volta da una delle
    quattro celle e si rifanno Q e Qf. NON e' un verdetto: dice quanto il
    verdetto dista dalla soglia in unita' di 'una operazione'."""
    base = verdetti(k, *celle)
    q, qf = [], []
    for i in range(4):
        for pid in sorted({x['position_id'] for x in celle[i]}):
            cc = list(celle)
            cc[i] = [x for x in celle[i] if x['position_id'] != pid]
            v = verdetti(k, *cc)
            q.append((v['Q'], v['pf_verdetto']))
            qf.append((v['Qf'], v['f_verdetto']))
    cambia = lambda L, b: sum(1 for _, z in L if z != b)
    return dict(n=len(q), qmin=min(q)[0], qmax=max(q)[0], qcambia=cambia(q, base['pf_verdetto']),
                qfmin=min(qf)[0], qfmax=max(qf)[0], qfcambia=cambia(qf, base['f_verdetto']))


def dove_cade(x, bande):
    (s0, s1), (o0, o1) = bande
    return ', '.join(t for t, ok in (('dentro H_STAGIONE', s0 <= x <= s1), ('dentro H_OROLOGIO', o0 <= x <= o1)) if ok) \
        or ('SOPRA entrambe' if x > max(s1, o1) else ('SOTTO entrambe' if x < min(s0, o0) else 'nel buco fra le due'))


# ---------------------------------------------------------------- stampa
def main():
    ptc = {}
    for lett, (k, orol, fin, m) in FILES.items():
        for tw in (m, m + 50):
            ptc[(lett, tw)] = leggi_pt(pertrade_path(lett, tw))

    print("=" * 78)
    print("R246 -- GIUDIZIO COI CRITERI CONGELATI (R246a par. 5-8, R246e, R246i)")
    print("=" * 78)
    print("\n### 1. G1 DETERMINISMO -- regola alla LETTERA, nessuna tolleranza")
    g1 = cancello_g1(ptc)
    for lett in FILES:
        esito, diff, diag = g1[lett]
        print(f"  R246{lett} {FILES[lett][0]:3s} {FILES[lett][1]:3s} {FILES[lett][2]}: G1 {esito}")
        for d in diff:
            print(f"        - {d}")
        for (i, t, campi, dec, dc) in diag:
            print(f"        diagnosi riga {i} ({t}): campi diversi {campi}; decisionali diversi {dec or 'NESSUNO'};"
                  f" scarto net_profit {dc:+d} centesimi")
    print("  -> file NULLI per G1:", [l for l in FILES if g1[l][0] != 'PASS'] or 'nessuno')

    print("\n### 2. G0 RIPRODUZIONE (d0 finestra B) contro R47c / R47a / R16b")
    g0 = cancello_g0(ptc)
    for lett, es in g0.items():
        for (tw, e, cok, pok, n, npos, s) in es:
            print(f"  R246{lett} magic {tw}: {e}  (CSV identici al centesimo: {cok}; per-trade identico riga per riga: {pok};"
                  f" righe {n}, posizioni {npos}, somma {s / 100:.2f})")
    rifatte = bande_rifatte_se_rosso(g0)
    if not rifatte:
        print("  -> nessun G0 ROSSO: bande, soglie e probabilita' del par. 6-7 restano CONFRONTABILI")

    print("\n### 3. G2 COERENZA FRA FINESTRE (per-trade A contro gamba IS del CSV B)")
    for la, lb, righe in cancello_g2(ptc):
        for (off, s, n, pb, tb, ok, g26) in righe:
            print(f"  R246{la} (+{off:2d}) vs R246{lb} IS: somma {s / 100:.2f} / {n} deal contro {pb} / {tb}"
                  f" -> {'IDENTICI' if ok else 'SCARTO'}  (deal del 26/09/2024 nel per-trade A: {g26})")

    print("\n### 4. S1 SENTINELLA DELL'OROLOGIO (per-trade, ora di uscita BCM)")
    s1 = cancello_s1(ptc)
    for lett in FILES:
        e, note = s1[lett]
        print(f"  R246{lett} {FILES[lett][0]:3s} {FILES[lett][1]:3s} {FILES[lett][2]}: S1 {e}  | " + "; ".join(x for x in note if x))
    nullo_round = {k: any(s1[l][0] == 'ROSSO' for l, v in FILES.items() if v[0] == k) for k in EA}
    print("  -> round NULLO per S1:", [k for k, v in nullo_round.items() if v] or 'nessuno')

    print("\n### 5. VERDETTI (aperti SOLO ora)  -- n = posizioni, PF sui deal, calendario per data di chiusura")
    ris = {}
    for k in EA:
        L = {v[1] + v[2]: l for l, v in FILES.items() if v[0] == k}
        if nullo_round[k]:
            print(f"  {k}: ROUND NULLO (S1) -- nessun verdetto")
            continue
        file_k = [L['d0A'], L['d0B'], L['-1hA'], L['-1hB']]
        nulli = [l for l in file_k if g1[l][0] != 'PASS']
        varianti = [(0, 0, 0, 0)]
        if nulli:
            varianti = [(0, 0, 0, 0), (50, 50, 50, 50)]
        rr = []
        for off in varianti:
            rr.append(verdetti(k, *[ptc[(l, FILES[l][3] + o)] for l, o in zip(file_k, off)]))
        r = rr[0]
        ris[k] = (r, nulli, rr)
        fer = r['fer']
        stato = f"SOSPESO dal G1 (file NULLI: {', '.join('R246' + x for x in nulli)})" if nulli else "PRONUNCIATO"
        print(f"\n  == {k} ({EA[k][0]}, calendario {EA[k][2]}) -- {stato}")
        print(f"     feriali A+B: estate {fer['E']} (A {fer['AE']} + B {fer['BE']}), inverno {fer['I']} (A {fer['AI']} + B {fer['BI']})")
        for nome, g in (('d0 ', r['d0']), ('-1h', r['m1'])):
            for z, zz in (('E', 'estate '), ('I', 'inverno')):
                print(f"     {nome} {zz}: PF {g[z]['pf']:.3f}  posizioni {g[z]['pos']:3d}  deal {g[z]['deal']:3d}  netto {g[z]['netto']:10.2f}")
        print(f"     PF:   PF_E0 {r['d0']['E']['pf']:.3f}  PF_I0 {r['d0']['I']['pf']:.3f}  D {r['D']:.3f}"
              f"  PF_E-1h {r['m1']['E']['pf']:.3f}  Q {r['Q']:.3f}  -> {r['pf_verdetto']}")
        print(f"     FREQ: r_E0 {r['rE0']:.4f}  r_I0 {r['rI0']:.4f}  Df {r['Df']:.4f} (soglia {PRE_F[k]})"
              f"  r_E-1h {r['rE1']:.4f}  Qf {r['Qf']:.3f}  -> {r['f_verdetto']}")
        (iA, iB), (eA, eB) = r['inverni'], r['estati']
        print(f"     descrittivo d0: inverno 24/25 PF {iA['pf']:.3f} (pos {iA['pos']})  inverno 25/26 PF {iB['pf']:.3f} (pos {iB['pos']})"
              f" | estate A PF {eA['pf']:.3f} (pos {eA['pos']})  estate B PF {eB['pf']:.3f} (pos {eB['pos']})")
        print(f"     bande congelate (par. 6): PF -1h estate {r['m1']['E']['pf']:.3f} -> {dove_cade(r['m1']['E']['pf'], BANDE_PF[k])}"
              f" {BANDE_PF[k]}; posizioni -1h estate {r['m1']['E']['pos']} -> {dove_cade(r['m1']['E']['pos'], BANDE_POS[k])}"
              f" {BANDE_POS[k]}")
        print(f"     DD saldo per stagione [DERIVATO]: d0 E {r['dd_d0_E'][1]:.2%}  d0 I {r['dd_d0_I'][1]:.2%}"
              f"  -1h E {r['dd_m1_E'][1]:.2%}  -1h I {r['dd_m1_I'][1]:.2%}")
        fr = fragilita(k, [ptc[(l, FILES[l][3])] for l in file_k])
        print(f"     fragilita' (jackknife, {fr['n']} posizioni tolte una a una): Q [{fr['qmin']:.3f} ; {fr['qmax']:.3f}]"
              f" verdetto PF cambia in {fr['qcambia']}; Qf [{fr['qfmin']:.3f} ; {fr['qfmax']:.3f}] verdetto FREQ cambia in {fr['qfcambia']}")
        if len(rr) > 1:
            r2 = rr[1]
            print(f"     INVARIANZA gemella m+50: D {r2['D']:.6f} Q {r2['Q']:.6f} -> {r2['pf_verdetto']} | "
                  f"Qf {r2['Qf']:.6f} -> {r2['f_verdetto']}  (gemella m: D {r['D']:.6f} Q {r['Q']:.6f})")

    print("\n### 6. RISCHIO (si legge sempre, Emendamento B)")
    print("  Equity DD % dai CSV (gemella m) e DD sul saldo a deal chiusi del per-trade [DERIVATO]")
    for lett, (k, orol, fin, m) in FILES.items():
        ci, co = csv_round(lett, 'IS'), csv_round(lett, 'OOS')
        dd, ddp = dd_saldo(ptc[(lett, m)])
        print(f"  R246{lett} {k:3s} {orol:3s} {fin}: CSV IS DD {ci[m]['Equity DD %'] if ci else '(vuoto, atteso)':>16s}"
              f"  OOS DD {co[m]['Equity DD %']:>8s}  Profit OOS {co[m]['Profit']:>10s}  PF OOS {co[m]['Profit Factor']}"
              f"  Trades {co[m]['Trades']:>3s} | per-trade DD saldo {dd:8.2f} EUR = {ddp:.2%}")
    return g1, g0, s1, ris


# ---------------------------------------------------------------- autotest
def autotest():
    """I CONTRO-ESEMPI: ogni cancello deve SCATTARE sul caso che deve prendere."""
    ok = True

    def chk(nome, cond):
        nonlocal ok
        print(f"  [{'OK ' if cond else 'KO!'}] {nome}")
        ok &= bool(cond)

    print("AUTOTEST r246_giudizio.py")
    d0 = leggi_pt(pertrade_path('a', 794601))
    m1 = leggi_pt(pertrade_path('b', 794602))
    # 1. -1h identico a d0 -> S1 ROSSO (round NULLO), per costruzione
    falso = copy.deepcopy(d0)
    for r in falso:
        r['magic'] = '794602'
    e, _ = s1_cella('DOW', '-1h', falso, d0)
    chk("per-trade -1h ARTIFICIALMENTE uguale a d0 -> S1 ROSSO -> NULLO", e == 'ROSSO')
    # 1b. -1h con orari veri spostati di +1h (pin non arrivato ma giorni diversi) -> ROSSO
    spost = copy.deepcopy(m1)
    for r in spost:
        t = dt.datetime.strptime(r['close_time'], '%Y.%m.%d %H:%M:%S') + dt.timedelta(hours=1)
        r['close_time'] = t.strftime('%Y.%m.%d %H:%M:%S')
    e, _ = s1_cella('DOW', '-1h', spost, d0)
    chk("per-trade -1h riportato a orario d0 (+1h) -> S1 ROSSO", e == 'ROSSO')
    # 1c. il vero -1h passa
    e, _ = s1_cella('DOW', '-1h', m1, d0)
    chk("per-trade -1h vero -> S1 VERDE", e == 'VERDE')
    # 1d. d0 con un'uscita artificiale alle 15:00 -> ROSSO
    x = copy.deepcopy(d0)
    x[0]['close_time'] = x[0]['close_time'][:11] + '15:00:00'
    chk("d0 con un'uscita alle 15:00 (dentro il range) -> S1 ROSSO", s1_cella('DOW', 'd0', x)[0] == 'ROSSO')
    # 2. G1: un centesimo su UNA riga deve far scattare NULLO
    g = copy.deepcopy(d0)
    for r in g:
        r['magic'] = '794651'
    chk("G1 gemelle identiche tranne magic -> PASS", g1_confronta(None, None, d0, g, 1, 2)[0] == 'PASS')
    g[5]['net_profit'] = f"{cent(g[5]['net_profit']) / 100 + 0.01:.2f}"
    es, diff, diag = g1_confronta(None, None, d0, g, 1, 2)
    chk("G1 con +0,01 su una riga -> NULLO, diagnosi 'nessun campo decisionale'",
        es == 'NULLO' and diag and diag[0][3] == [] and diag[0][4] == 1)
    g[5]['price'] = '1.00'
    chk("G1 con prezzo diverso -> diagnosi con campo decisionale 'price'",
        'price' in g1_confronta(None, None, d0, g, 1, 2)[2][0][3])
    # 3. il calendario congelato riproduce i numeri del MC (par. 4)
    for f, cal, att in (('risultati_prove/aperture_r47/abtg_trades_ABTG_Dow_Apertura_US_U30USD_772505.csv', 'USA',
                         (73, 57, 0.782, 1.662)),
                        ('risultati_prove/aperture_r47/abtg_trades_ABTG_DAX_Apertura_EU_D30EUR_772501.csv', 'UE',
                         (144, 126, 1.274, 1.481)),
                        ('risultati_prove/trades_portafoglio/abtg_trades_ABTG_MaxMinNotte_DAX_Short_Ottimizzato_D30EUR_770413.csv',
                         'UE', (8, 13, 2.032, 2.245))):
        a = aggrega([('B', leggi_pt(os.path.join(QUI, f)))], cal)
        got = (a['E']['deal'], a['I']['deal'], round(a['E']['pf'], 3), round(a['I']['pf'], 3))
        chk(f"calendario congelato su {os.path.basename(f)}: {got} == {att}", got == att)
    # 4. il verdetto va dove deve: -1h estate = d0 inverno -> Q ~ 1 (OROLOGIO);
    #    -1h = d0 -> Q = 0 (STAGIONE)
    dA, dB = leggi_pt(pertrade_path('c', 794603)), d0
    r = verdetti('DOW', dA, dB, dA, dB)
    chk(f"-1h = d0 -> Q {r['Q']:.3f} e Qf {r['Qf']:.3f} = 0 -> STAGIONE (se D>=0,44)",
        abs(r['Q']) < 1e-12 and abs(r['Qf']) < 1e-12 and (r['pf_verdetto'] == 'STAGIONE' or r['D'] < 0.44))
    inv = [x for x in dA + dB if rb.inverno(giorno(x), 'USA')]
    fer = feriali_AB('USA')
    # -1h sintetico: i deal d'inverno ricollocati su giorni d'estate, tanti
    # quanti ne servono per avere il tasso invernale (posizioni per feriale)
    pos_inv = collections.OrderedDict()
    for x in inv:
        pos_inv.setdefault(x['position_id'] + x['close_time'][:4], []).append(x)
    estivi = [rb.A[0] + dt.timedelta(i) for i in range((rb.B[1] - rb.A[0]).days + 1)]
    estivi = [d for d in estivi if d.weekday() < 5 and not rb.inverno(d, 'USA')]
    npos = round(r['rI0'] * fer['E'])
    lista = list(pos_inv.values())
    sint = []
    for j in range(npos):
        for x in lista[j % len(lista)]:
            y = dict(x)
            y['close_time'] = estivi[j].strftime('%Y.%m.%d') + x['close_time'][10:]
            y['position_id'] = str(j)
            sint.append(y)
    r = verdetti('DOW', dA, dB, [], sint)
    chk(f"-1h estate SINTETICO = deal d'inverno al tasso invernale -> Qf {r['Qf']:.3f} ~ 1 -> "
        f"{r['f_verdetto']}", r['f_verdetto'] == 'OROLOGIO' or r['Df'] < PRE_F['DOW'])
    print("AUTOTEST:", "PASS" if ok else "FALLITO")
    return ok


if __name__ == '__main__':
    if '--autotest' in sys.argv:
        sys.exit(0 if autotest() else 1)
    main()
