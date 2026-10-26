#!/usr/bin/env python3
"""prepara_dati.py (A4, SALA-BIAS-001) - serie D1 FUSA e barre W1.

Regole (criteri S1 v2, punto 1, 3, 11):
- le barre di DOMENICA si fondono nel LUNEDI' successivo: open della domenica, massimo/minimo
  estremi, close del lunedi', tick volume sommato. Il "giorno di borsa" e' la barra fusa.
- W1 = barre fuse lunedi'-venerdi' della stessa settimana (etichetta = data del lunedi').
- partenza dalla prima barra del primo lunedi' (2004-06-14): il venerdi' 2004-06-11 (settimana
  con una sola barra) NON entra (criteri v2 punto 4: "dalla prima barra disponibile (2004-06-14)").
- si ESCLUDONO dalle uscite la barra 2026-10-21 e l'ultima settimana (2026-10-19): tutte le barre
  con data >= lunedi' dell'ultima settimana presente nel file (punto 11).
Solo libreria standard.
"""
import csv, os, sys, datetime as dt

QUI = os.path.dirname(os.path.abspath(__file__))
RAW_DEFAULT = ('/tmp/claude-0/-home-user-GITHUB/c2d73886-9ef2-5105-8937-d770bc36d6df/scratchpad/'
               'lavoro_wt/data/prezzi/XAUUSD_D1_BCM_2004-06-11_2026-10-21.csv')
A3_W1 = os.path.join(QUI, '..', 'A3', 'weekly_W1.csv')
INIZIO = dt.date(2004, 6, 14)


def leggi_raw(path=RAW_DEFAULT):
    righe = []
    with open(path, newline='') as f:
        rd = csv.reader(f, delimiter='\t')
        next(rd)
        for r in rd:
            if not r:
                continue
            y, m, d = (int(x) for x in r[0].split('.'))
            righe.append(dict(date=dt.date(y, m, d), so=r[1], sh=r[2], sl=r[3], sc=r[4],
                              o=float(r[1]), h=float(r[2]), l=float(r[3]), c=float(r[4]),
                              v=int(r[5]), spread=int(r[7]), n_raw=1, dom=0))
    return righe


def fondi_domeniche(raw, inizio=INIZIO):
    """Fonde ogni domenica nel lunedi' successivo. Le barre con data < inizio sono scartate PRIMA
    della fusione (ma una domenica che precede un lunedi' >= inizio e' fusa)."""
    out, pend = [], None
    for r in raw:
        wd = r['date'].weekday()
        if wd == 5:
            raise ValueError('barra di sabato inattesa %s' % r['date'])
        if wd == 6:
            if pend is not None:
                raise ValueError('due domeniche consecutive')
            pend = r
            continue
        if pend is not None:
            if r['date'] - pend['date'] != dt.timedelta(days=1):
                raise ValueError('domenica %s senza lunedi\' successivo' % pend['date'])
            f = dict(r)
            f.update(o=pend['o'], so=pend['so'], v=pend['v'] + r['v'], n_raw=2, dom=1)
            if pend['h'] > r['h']:
                f['h'], f['sh'] = pend['h'], pend['sh']
            if pend['l'] < r['l']:
                f['l'], f['sl'] = pend['l'], pend['sl']
            pend = None
        else:
            f = dict(r)
        if f['date'] >= inizio:
            out.append(f)
    if pend is not None:
        raise ValueError('domenica finale senza lunedi\'')
    return out


def settimane(d1):
    """Barre W1 dalle barre D1 fuse. Ogni W1: date=lunedi', first_date, last_date, n."""
    wk, cur, key = [], None, None
    for r in d1:
        k = r['date'] - dt.timedelta(days=r['date'].weekday())
        if k != key:
            if cur is not None:
                wk.append(cur)
            key = k
            cur = dict(date=k, first_date=r['date'], last_date=r['date'], o=r['o'], so=r['so'],
                       h=r['h'], sh=r['sh'], l=r['l'], sl=r['sl'], c=r['c'], sc=r['sc'], v=r['v'], n=1)
        else:
            cur['last_date'] = r['date']
            if r['h'] > cur['h']:
                cur['h'], cur['sh'] = r['h'], r['sh']
            if r['l'] < cur['l']:
                cur['l'], cur['sl'] = r['l'], r['sl']
            cur['c'], cur['sc'] = r['c'], r['sc']
            cur['v'] += r['v']
            cur['n'] += 1
    if cur is not None:
        wk.append(cur)
    return wk


def escludi_ultima_settimana(d1):
    """Esclude tutte le barre della settimana (lunedi'-...) dell'ultima barra presente."""
    ult = d1[-1]['date']
    lun = ult - dt.timedelta(days=ult.weekday())
    return [r for r in d1 if r['date'] < lun], lun


def scrivi_d1(d1, path):
    with open(path, 'w', newline='') as f:
        f.write('data;open;high;low;close;tickvol;n_raw;domenica_fusa\n')
        for r in d1:
            f.write('%s;%s;%s;%s;%s;%d;%d;%d\n' % (r['date'].isoformat(), r['so'], r['sh'], r['sl'],
                                                   r['sc'], r['v'], r['n_raw'], r['dom']))


def leggi_d1(path):
    d1 = []
    with open(path, newline='') as f:
        rd = csv.reader(f, delimiter=';')
        next(rd)
        for r in rd:
            d1.append(dict(date=dt.date.fromisoformat(r[0]), so=r[1], sh=r[2], sl=r[3], sc=r[4],
                           o=float(r[1]), h=float(r[2]), l=float(r[3]), c=float(r[4]),
                           v=int(r[5]), n_raw=int(r[6]), dom=int(r[7])))
    return d1


def scrivi_w1(wk, path):
    with open(path, 'w', newline='') as f:
        f.write('week_start;open;high;low;close;tickvol;n_barre;prima_barra;ultima_barra\n')
        for w in wk:
            f.write('%s;%s;%s;%s;%s;%d;%d;%s;%s\n' % (w['date'].isoformat(), w['so'], w['sh'], w['sl'],
                                                     w['sc'], w['v'], w['n'], w['first_date'].isoformat(),
                                                     w['last_date'].isoformat()))


def confronta_a3(wk, path_a3=A3_W1):
    """Confronto delle W1 con quelle di A3. Ritorna lista di righe di testo."""
    a3 = {}
    with open(path_a3, newline='') as f:
        for r in csv.DictReader(f):
            a3[dt.date.fromisoformat(r['week_start'])] = r
    mie = {w['date']: w for w in wk}
    out = []
    out.append('W1 mie: %d (da %s a %s) | W1 A3: %d (da %s a %s)' % (
        len(mie), min(mie), max(mie), len(a3), min(a3), max(a3)))
    solo_a3 = sorted(set(a3) - set(mie))
    solo_mie = sorted(set(mie) - set(a3))
    out.append('settimane solo in A3: %s' % [d.isoformat() for d in solo_a3])
    out.append('settimane solo mie: %s' % [d.isoformat() for d in solo_mie])
    comuni = sorted(set(mie) & set(a3))
    diff = []
    for d in comuni:
        w, a = mie[d], a3[d]
        for campo, ka in (('o', 'open'), ('h', 'high'), ('l', 'low'), ('c', 'close')):
            if abs(w[campo] - float(a[ka])) > 1e-9:
                diff.append((d.isoformat(), campo, w[campo], float(a[ka])))
        if w['v'] != int(a['tickvol']):
            diff.append((d.isoformat(), 'tickvol', w['v'], int(a['tickvol'])))
        if w['n'] != int(a['n_barre_D1']) - (1 if int(a['ha_domenica']) else 0):
            diff.append((d.isoformat(), 'n_barre(feriali)', w['n'], int(a['n_barre_D1'])))
        if w['first_date'].isoformat() != a['prima_barra'] and not int(a['ha_domenica']):
            diff.append((d.isoformat(), 'prima_barra', w['first_date'].isoformat(), a['prima_barra']))
    out.append('settimane in comune: %d | differenze di valore/conteggio: %d' % (len(comuni), len(diff)))
    for x in diff[:40]:
        out.append('  DIFF %s' % (x,))
    return out


def main():
    raw = leggi_raw()
    fused_all = fondi_domeniche(raw)
    d1, lun = escludi_ultima_settimana(fused_all)
    wk = settimane(d1)
    p1 = os.path.join(QUI, 'D1_fuso.csv')
    scrivi_d1(d1, p1)
    scrivi_w1(wk, os.path.join(QUI, 'W1_fuso.csv'))
    righe = []
    righe.append('PREPARA_DATI (A4)')
    righe.append('barre raw: %d (da %s a %s) | domeniche raw: %d' % (
        len(raw), raw[0]['date'], raw[-1]['date'], sum(1 for r in raw if r['date'].weekday() == 6)))
    righe.append('barre fuse totali (dal %s): %d, di cui con domenica fusa: %d' % (
        INIZIO, len(fused_all), sum(r['dom'] for r in fused_all)))
    righe.append('ESCLUSE dalle uscite le barre con data >= %s (ultima settimana; incl. 2026-10-21): %d barre' % (
        lun, len(fused_all) - len(d1)))
    righe.append('D1_fuso.csv: %d barre, da %s a %s' % (len(d1), d1[0]['date'], d1[-1]['date']))
    righe.append('W1_fuso.csv: %d settimane, da %s a %s (ultima settimana inclusa: %s, %d barre)' % (
        len(wk), wk[0]['date'], wk[-1]['date'], wk[-1]['date'], wk[-1]['n']))
    righe.append('')
    righe.append('CONFRONTO CON agents/A3/weekly_W1.csv (A3 parte dal 2004-06-11 e include l\'ultima settimana):')
    comp = confronta_a3(wk)
    righe.extend(comp)
    # spiegazione attesa
    righe.append('NOTA: la settimana 2004-06-07 di A3 ha 1 sola barra (venerdi 2004-06-11) ed e\' esclusa dalla mia serie; '
                 'la settimana 2026-10-19 e\' esclusa per criteri v2 punto 11.')
    testo = '\n'.join(righe)
    print(testo)
    with open(os.path.join(QUI, 'prepara_dati_output.txt'), 'w') as f:
        f.write(testo + '\n')


if __name__ == '__main__':
    main()
