#!/usr/bin/env python3
# -*- coding: ascii -*-
# MARCATORE_LEGGI_GBA_USCITE_v1 (10/10/2026)
# LETTORE DELLE USCITE del lotto GBA R1A (e dei lotti R2 che verranno): rilegge report .htm (deal) + giornale (righe [GBA] BUY/SELL con SL e ATR)
# e ricava, per ogni operazione: il MOTIVO d'uscita, R, durata, ora, giorno. SOLA LETTURA di un archivio gia' prodotto: non lancia niente, non tocca MT5.
# STATO: strumento di analisi del 10/10/2026, NON ancora passato dal cancello (controllo-preventivo): non e' una riga di lancio e non va a Claudio da solo.
#
# USO:   python3 -I backtest_pipeline/leggi_gba_uscite.py <GBA_R0_R1A.zip | cartella con report/ e log/>       (stampa le tabelle)
#        python3 -I backtest_pipeline/leggi_gba_uscite.py --autotest                                          (contro-esempi su dati finti con risposta nota)
#
# COME CLASSIFICA L'USCITA (dal commento del deal d'uscita del tester, 'sl <livello>', e dai prezzi scritti nel giornale all'ingresso):
#   TEMPO ........ commento vuoto (e' la PositionClose dell'EA: uscita a tempo; verificato in R1A: 8 commenti vuoti = 8 righe 'uscita a tempo' del giornale)
#   SL_INIT ...... livello 'sl' = SL iniziale scritto dall'EA all'ingresso (tolleranza 1,5 tick)
#   BE ........... livello 'sl' = prezzo d'ingresso (breakeven con offset 0: tolleranza 1,5 tick)
#   TRAIL_SOTTO .. livello 'sl' spostato dal trailing ma ancora SOTTO l'ingresso (lato perdente): il BE non si era armato
#   TRAIL_PROFIT . livello 'sl' spostato oltre l'ingresso, dal lato del profitto
# LIMITE DICHIARATO: con InpBE_OffsetATR != 0 la riga BE va letta col suo offset (qui non gestito: R1A ha offset 0). Il motivo e' dedotto dal LIVELLO, non letto
# dall'EA: se un livello cade per coincidenza sull'ingresso viene detto BE.
#
# R = (profitto + commissioni + swap del deal) / 'perdita a SL' scritta dall'EA all'ingresso (stima in valuta del conto: EUR).
import sys, os, re, io, zipfile, glob, random, statistics as st
from collections import defaultdict, Counter
from datetime import datetime

TOL = 0.015
TRANCHE_RE = re.compile(r'_(T\d+)_')


def num(x):
    x = x.replace('\xa0', '').replace(' ', '')
    return float(x) if x not in ('', '-') else 0.0


def dt(x):
    return datetime.strptime(x, '%Y.%m.%d %H:%M:%S')


def classifica(comment, side_sgn, entry, sl0, tol=TOL):
    """motivo d'uscita da commento del deal 'out' + prezzi d'ingresso. Ritorna (motivo, livello_sl_o_None)."""
    if comment == '':
        return 'TEMPO', None
    m = re.match(r'sl ([\d.]+)', comment)
    if not m:
        return 'ALTRO:' + comment, None
    x = float(m.group(1))
    if abs(x - sl0) <= tol:
        return 'SL_INIT', x
    if abs(x - entry) <= tol:
        return 'BE', x
    return ('TRAIL_PROFIT' if side_sgn * (x - entry) > 0 else 'TRAIL_SOTTO'), x


def leggi_deal(testo_htm):
    i = testo_htm.find('<b>Affari</b>')
    seg = testo_htm[i:]
    out = []
    for r in re.findall(r'<tr[^>]*>(.*?)</tr>', seg, re.S):
        c = [re.sub(r'<[^>]+>', '', x).strip() for x in re.findall(r'<t[dh][^>]*>(.*?)</t[dh]>', r, re.S)]
        if len(c) == 13 and c[3] in ('buy', 'sell'):
            out.append(c)
    return out


def leggi_ingressi(testo_log):
    ent, seen = [], set()
    pat = re.compile(r'(\S+ \S+)\s+\[GBA\] (BUY|SELL) ([\d.]+) lotti @ ([\d.]+) \| SL ([\d.]+) \(([\d.]+) x ATR ([\d.]+)\) \| spread ([\d.]+) \| perdita a SL ~([\d.]+) EUR')
    for line in testo_log.splitlines():
        m = pat.match(line)
        if m:
            k = (m.group(1), m.group(4))
            if k in seen:
                continue            # il giornale ripete ogni riga due volte (grezze 2x uniche)
            seen.add(k)
            ent.append(dict(t=m.group(1), px=float(m.group(4)), sl0=float(m.group(5)), atr=float(m.group(7)), spr=float(m.group(8)), lossSL=float(m.group(9))))
    return ent


def operazioni(tr, testo_htm, testo_log):
    deals, ent = leggi_deal(testo_htm), leggi_ingressi(testo_log)
    pos, cur = [], None
    for d in deals:
        if d[4] == 'in':
            cur = d
        elif d[4] == 'out':
            pos.append((cur, d))
            cur = None
    res = []
    for a, b in pos:
        e = [x for x in ent if x['t'] == a[0] and abs(x['px'] - num(a[6])) < 0.006]
        if len(e) != 1:
            raise SystemExit('ingresso non abbinato al giornale: %s %s (%d candidati)' % (tr, a[0], len(e)))
        e = e[0]
        sgn = 1 if a[3] == 'buy' else -1
        entry, exitp = num(a[6]), num(b[6])
        why, slx = classifica(b[12], sgn, entry, e['sl0'])
        net = num(b[10]) + num(a[8]) + num(b[8]) + num(b[9])
        res.append(dict(tr=tr, side=a[3], sgn=sgn, t_in=a[0], t_out=b[0], entry=entry, exit=exitp, sl0=e['sl0'], slx=slx, why=why,
                        atr=e['atr'], spr=e['spr'], lossSL=e['lossSL'], net=net, comm=num(a[8]) + num(b[8]), profit=num(b[10]),
                        R=net / e['lossSL'], dur=(dt(b[0]) - dt(a[0])).total_seconds(), hour=int(a[0][11:13]), day=a[0][:10],
                        wd=dt(a[0]).weekday()))
    return res


def carica(sorgente):
    files = {}
    if os.path.isdir(sorgente):
        for p in glob.glob(os.path.join(sorgente, '**', '*'), recursive=True):
            if os.path.isfile(p):
                files[p.replace('\\', '/')] = lambda p=p: open(p, 'rb').read()
    else:
        z = zipfile.ZipFile(sorgente)
        for n in z.namelist():
            files[n.replace('\\', '/')] = lambda n=n: z.read(n)
    htm = {k: v for k, v in files.items() if k.endswith('.htm') and '/report/' in '/' + k}
    out = []
    for k in sorted(htm):
        m = TRANCHE_RE.search(os.path.basename(k))
        tr = m.group(1) if m else os.path.basename(k)
        base = os.path.basename(k).replace('GBA_R0_', 'GBA_').replace('.htm', '.txt')
        logk = [x for x in files if x.endswith(base) and '/log/' in '/' + x]
        if not logk:
            raise SystemExit('log mancante per ' + k)
        th = files[k]().decode('utf-16', errors='replace')
        tl = files[logk[0]]().decode('ascii', errors='replace')
        out += operazioni(tr, th, tl)
    return out


def pf(vals):
    p = sum(v for v in vals if v > 0)
    n = -sum(v for v in vals if v < 0)
    return p / n if n else float('inf')


def q(v, ps=(0.1, 0.25, 0.5, 0.75, 0.9)):
    v = sorted(v)
    return [round(v[min(len(v) - 1, int(p * len(v)))], 3) for p in ps]


MOTIVI = ['SL_INIT', 'BE', 'TRAIL_SOTTO', 'TRAIL_PROFIT', 'TEMPO']


def tabelle(T):
    print('operazioni lette:', len(T), ' per tranche:', dict(Counter(t['tr'] for t in T)))
    print('\n== USCITE PER MOTIVO (tutte le tranche)')
    for w in MOTIVI + sorted({t['why'] for t in T} - set(MOTIVI)):
        r = [t for t in T if t['why'] == w]
        if r:
            print('%-13s n=%4d (%4.1f%%) netto=%9.0f  R medio %6.3f  R mediana %6.3f  durata mediana %5.1f min' %
                  (w, len(r), 100. * len(r) / len(T), sum(t['net'] for t in r), st.mean(t['R'] for t in r), st.median(t['R'] for t in r), st.median(t['dur'] for t in r) / 60))
    print('TOTALE        n=%4d netto=%9.0f  PF_V %.3f  R medio %.4f  win %.1f%%' % (len(T), sum(t['net'] for t in T), pf([t['net'] for t in T]), st.mean(t['R'] for t in T), 100. * sum(1 for t in T if t['net'] > 0) / len(T)))
    for tr in sorted({t['tr'] for t in T}):
        r = [t for t in T if t['tr'] == tr]
        print(' ', tr, 'n=%d' % len(r), {w: sum(1 for t in r if t['why'] == w) for w in MOTIVI}, 'PF_V %.2f' % pf([t['net'] for t in r]))
    print('\n== SLITTAMENTO rispetto al livello SL scritto nel commento (USD/oz; negativo = peggio del livello)')
    for w in ('SL_INIT', 'BE', 'TRAIL_SOTTO', 'TRAIL_PROFIT'):
        r = [t for t in T if t['why'] == w]
        if r:
            s = [t['sgn'] * (t['exit'] - t['slx']) for t in r]
            print('%-13s quantili 10/25/50/75/90 %s  min %.2f  esatti(|x|<=1,5 tick) %.0f%%' % (w, q(s), min(s), 100. * sum(1 for x in s if abs(x) <= TOL) / len(s)))
    sl = [(t['sgn'] * (t['exit'] - t['slx'])) * 100 * (t['lossSL'] / (2.5 * t['atr'] * 100)) for t in T if t['slx'] is not None]
    print('slittamento totale (EUR, 1,00 lotto = 100 oz, cambio ricavato da lossSL/(2,5 ATR x 100)): %.0f su %d uscite = %.1f EUR per uscita' % (sum(sl), len(sl), sum(sl) / len(sl)))
    print('\n== R PER FASCE')
    for a, b in [(-9, -1.05), (-1.05, -0.9), (-0.9, -0.6), (-0.6, -0.3), (-0.3, -0.1), (-0.1, 0.1), (0.1, 0.5), (0.5, 1), (1, 2), (2, 3), (3, 99)]:
        r = [t for t in T if a <= t['R'] < b]
        print('  R in [%5.2f,%5.2f)  n=%4d  netto=%9.0f' % (a, b, len(r), sum(t['net'] for t in r)))
    print('operazioni con |R|<0.10: %d (%.1f%%): di cui BE %d' % (sum(1 for t in T if abs(t['R']) < 0.1), 100. * sum(1 for t in T if abs(t['R']) < 0.1) / len(T), sum(1 for t in T if abs(t['R']) < 0.1 and t['why'] == 'BE')))
    print('\n== DURATA (minuti) quantili 10/25/50/75/90 %s  massimo %.1f  oltre 24 min: %d  oltre 48 min: %d' %
          (q([t['dur'] / 60 for t in T]), max(t['dur'] for t in T) / 60, sum(1 for t in T if t['dur'] >= 1440), sum(1 for t in T if t['dur'] >= 2880)))
    print('\n== COSTI (stima, EUR): commissioni %.0f  swap %.0f  profitto lordo di commissioni/swap %.0f  spread all ingresso (1 lato) %.0f' %
          (sum(t['comm'] for t in T), sum(t['net'] - t['profit'] - t['comm'] for t in T), sum(t['profit'] for t in T),
           sum(t['spr'] * 100 * (t['lossSL'] / (2.5 * t['atr'] * 100)) for t in T)))
    print('\n== FASCE ORA SERVER (ora dell ingresso)')
    for nome, a, b in [('asia 00-07', 0, 7), ('europa 07-12', 7, 12), ('pausa 12-14', 12, 14), ('USA apertura 14-17', 14, 17), ('pomeriggio USA 17-22', 17, 22), ('rollover 22-24', 22, 24)]:
        r = [t for t in T if a <= t['hour'] < b]
        if r:
            print('  %-22s n=%4d netto=%8.0f PF_V %5.2f R medio %6.3f' % (nome, len(r), sum(t['net'] for t in r), pf([t['net'] for t in r]), st.mean(t['R'] for t in r)))
    print('\n== GIORNO DELLA SETTIMANA (0=lun)')
    for w in range(7):
        r = [t for t in T if t['wd'] == w]
        if r:
            print('  %d n=%4d netto=%8.0f PF_V %5.2f' % (w, len(r), sum(t['net'] for t in r), pf([t['net'] for t in r])))
    days = defaultdict(list)
    for t in T:
        days[t['day']].append(t)
    dn = {d: sum(t['net'] for t in r) for d, r in days.items()}
    s = sorted(dn.items(), key=lambda x: x[1])
    print('\n== GIORNI: con ingressi %d, positivi %d, negativi %d; operazioni/giorno media %.2f mediana %.1f massimo %d' %
          (len(days), sum(1 for v in dn.values() if v > 0), sum(1 for v in dn.values() if v < 0), st.mean(len(r) for r in days.values()), st.median(len(r) for r in days.values()), max(len(r) for r in days.values())))
    print('   5 peggiori', [(d, round(v)) for d, v in s[:5]], ' 5 migliori', [(d, round(v)) for d, v in s[-5:]], ' netto senza i 5 migliori giorni %.0f' % (sum(dn.values()) - sum(v for _, v in s[-5:])))
    print('   giorni con >=10 operazioni: %d, con >=20: %d' % (sum(1 for r in days.values() if len(r) >= 10), sum(1 for r in days.values() if len(r) >= 20)))


def bootstrap_e_finestre(T, B=5000, seed=12345):
    random.seed(seed)
    days = defaultdict(list)
    for t in T:
        days[t['day']].append(t['net'])
    ks = list(days)
    bs = []
    for _ in range(B):
        v = []
        for _ in ks:
            v += days[random.choice(ks)]
        bs.append(pf(v))
    bs.sort()
    print('\n== RUMORE DEL PF_V (bootstrap per GIORNO, %d ricampionamenti, seed %d): PF_V %.3f  p2.5 %.3f  p5 %.3f  p50 %.3f  p95 %.3f  p97.5 %.3f' %
          (B, seed, pf([t['net'] for t in T]), bs[int(.025 * B)], bs[int(.05 * B)], bs[B // 2], bs[int(.95 * B)], bs[int(.975 * B)]))
    nets = [t['net'] for t in T]
    lo, hi = 0.0, 500.0
    for _ in range(60):
        c = (lo + hi) / 2
        if pf([x + c for x in nets]) < 1.0:
            lo = c
        else:
            hi = c
    lo2, hi2 = 0.0, 3000.0
    for _ in range(60):
        c2 = (lo2 + hi2) / 2
        if pf([x + c2 for x in nets]) < 1.5:
            lo2 = c2
        else:
            hi2 = c2
    ml = st.mean(t['lossSL'] for t in T)
    print('   per portare il PF_V a 1,0 servono +%.1f EUR a operazione (+%.3f R); per 1,5 servono +%.0f EUR (+%.3f R); perdita a SL media %.0f EUR' % (c, c / ml, c2, c2 / ml, ml))
    S = sorted(T, key=lambda t: t['t_in'])
    W = 62
    res = []
    for i in range(0, len(S) - W + 1):
        w = S[i:i + W]
        res.append((pf([t['net'] for t in w]), sum(1 for t in w if t['net'] > 0) / W))
    if res:
        print('== FINESTRE DI %d OPERAZIONI CONSECUTIVE (come le 62 dichiarate nel pannello di Emiliano): %d finestre, PF mediano %.2f, massimo %.2f, quota con PF>=2,0: %.1f%%, win rate massimo %.1f%%, quota con win rate>=46,8%%: %.1f%%' %
              (W, len(res), sorted(r[0] for r in res)[len(res) // 2], max(r[0] for r in res), 100. * sum(1 for r in res if r[0] >= 2.0) / len(res), 100. * max(r[1] for r in res), 100. * sum(1 for r in res if r[1] >= 0.468) / len(res)))
    d = defaultdict(list)
    for t in S:
        d[t['day']].append(t)
    print('== TETTO DI OPERAZIONI AL GIORNO, ESATTO su R1A (con tetto N l EA apre le prime N del giorno server e nient altro; scoperto DOPO aver guardato i numeri: NON e un attesa, vedi dossier)')
    for cap in (1, 2, 3, 5, 10):
        sel = [t for r in d.values() for t in r[:cap]]
        print('   tetto %2d: n=%4d netto=%8.0f PF_V %.3f  per tranche %s' % (cap, len(sel), sum(t['net'] for t in sel), pf([t['net'] for t in sel]),
              {tr: round(pf([t['net'] for t in sel if t['tr'] == tr]), 2) for tr in sorted({t['tr'] for t in sel})}))


def autotest():
    ok = True

    def chk(nome, got, att):
        nonlocal ok
        r = (got == att)
        ok = ok and r
        print(('PASS ' if r else 'FAIL ') + nome, '' if r else '(atteso %r, letto %r)' % (att, got))
    chk('BE long esatto', classifica('sl 2000.00', 1, 2000.00, 1990.0)[0], 'BE')
    chk('SL iniziale long', classifica('sl 1990.00', 1, 2000.00, 1990.0)[0], 'SL_INIT')
    chk('trail long sopra ingresso', classifica('sl 2003.50', 1, 2000.00, 1990.0)[0], 'TRAIL_PROFIT')
    chk('trail long sotto ingresso', classifica('sl 1994.00', 1, 2000.00, 1990.0)[0], 'TRAIL_SOTTO')
    chk('trail short sopra ingresso = sotto (lato perdente)', classifica('sl 2004.00', -1, 2000.00, 2010.0)[0], 'TRAIL_SOTTO')
    chk('trail short oltre ingresso = profitto', classifica('sl 1996.00', -1, 2000.00, 2010.0)[0], 'TRAIL_PROFIT')
    chk('commento vuoto = tempo', classifica('', 1, 2000.00, 1990.0)[0], 'TEMPO')
    chk('BE a 1 tick di distanza', classifica('sl 2000.01', 1, 2000.00, 1990.0)[0], 'BE')
    chk('SL iniziale == ingresso (degenere): SL_INIT ha la precedenza', classifica('sl 2000.00', 1, 2000.00, 2000.00)[0], 'SL_INIT')
    # contro-esempio: un trail che cade a 3 tick dal BE NON e BE
    chk('trail a 3 tick dall ingresso non e BE', classifica('sl 2000.03', 1, 2000.00, 1990.0)[0], 'TRAIL_PROFIT')
    # parsing
    htm = '<b>Affari</b><tr><td>Ora</td></tr>' + ''.join('<tr><td>%s</td></tr>' % ('</td><td>'.join(r)) for r in [
        ['2026.07.01 14:23:00', '2', 'XAUUSD', 'buy', 'in', '1', '4038.85', '2', '-1.76', '0.00', '0.00', '999 998.24', 'GBA_L'],
        ['2026.07.01 14:26:20', '3', 'XAUUSD', 'sell', 'out', '1', '4038.85', '3', '-1.76', '0.00', '0.00', '999 996.48', 'sl 4038.85']])
    log = '2026.07.01 14:23:00   [GBA] BUY 1.00 lotti @ 4038.85 | SL 4027.34 (2.50 x ATR 4.60) | spread 0.20 | perdita a SL ~1011.24 EUR\n' * 2
    r = operazioni('T1', htm, log)
    chk('parsing: 1 operazione (giornale duplicato deduplicato)', len(r), 1)
    chk('parsing: motivo BE', r[0]['why'], 'BE')
    chk('parsing: R = (0 -1,76 -1,76)/1011,24', round(r[0]['R'], 5), round(-3.52 / 1011.24, 5))
    print('AUTOTEST', 'PASS' if ok else 'FAIL')
    return 0 if ok else 1


if __name__ == '__main__':
    if len(sys.argv) >= 2 and sys.argv[1] == '--autotest':
        sys.exit(autotest())
    if len(sys.argv) != 2:
        raise SystemExit('uso: python3 -I backtest_pipeline/leggi_gba_uscite.py <GBA_R0_R1A.zip | cartella con report/ e log/> | --autotest')
    T = carica(sys.argv[1])
    tabelle(T)
    bootstrap_e_finestre(T)
