#!/usr/bin/env python3
# MARCATORE_LETTURA_TRIAL_SENZA_APERTE_v1 -- COPIA di backtest_pipeline/lettura_trial.py (MARCATORE v2, NON modificato), adattata
# al report MT5 del 03/10/2026 che NON ha la sezione 'Posizioni aperte' (conto tutto piatto): la fine degli 'Affari' e' la prima
# sezione che segue fra 'Posizioni aperte', 'Ordini attivi', 'Bilancio:' e 'Risultati' (o la fine del foglio). In piu' espone
# leggi(path) che restituisce le posizioni con SL/TP dell'ordine d'apertura, commento d'ingresso, commento d'uscita e saldo dopo
# l'ingresso: serve a report/TRIAL_SFORTUNA_O_EA_2026-10-03.md. SOLA LETTURA: non tocca niente.
# Uso: python3 backtest_pipeline/lettura_trial_senza_aperte.py <report.xlsx> [AAAA.MM.GG da]
import sys, re, collections
import openpyxl

FINE_AFFARI = ('Posizioni aperte', 'Ordini attivi', 'Bilancio', 'Risultati')


def num(x):
    try:
        return float(str(x).split('/')[0].replace(' ', '')) if isinstance(x, str) else float(x)
    except Exception:
        return 0.0


def famiglia(c):
    c = re.sub(r'\[.*?\]', '', c or '').strip()
    return c or '(senza commento)'


def _sezioni(rows):
    sez = {}
    for i, r in enumerate(rows):
        if not r:
            continue
        if r[0] in ('Posizioni', 'Ordini', 'Affari', 'Posizioni aperte', 'Ordini attivi', 'Risultati') or str(r[0]).startswith('Bilancio:'):
            sez.setdefault(str(r[0]).split(':')[0], i)
    return sez


def leggi(path, da='0000.00.00'):
    """Posizioni chiuse dal report. Ritorna (posizioni, info) -- info: saldo finale, commissioni totali, netto da 'Risultati'."""
    wb = openpyxl.load_workbook(path, data_only=True)
    rows = [list(r) for r in wb.active.iter_rows(values_only=True)]
    sez = _sezioni(rows)
    p0 = sez['Posizioni'] + 2; p1 = sez['Ordini']
    o0 = sez['Ordini'] + 2; o1 = sez['Affari']
    a0 = sez['Affari'] + 2
    a1 = min([sez[k] for k in FINE_AFFARI if k in sez and sez[k] > a0] or [len(rows)])
    ordini = {}
    for r in rows[o0:o1]:
        if r and r[1] is not None and str(r[1]).isdigit():
            ordini[str(r[1])] = dict(tipo=r[3], sl=num(r[6]), tp=num(r[7]), stato=r[9], comm=(r[11] if len(r) > 11 else None) or '')
    com, bal_in, usc = {}, {}, {}
    comm_tot = 0.0
    for r in rows[a0:a1]:
        if not r or r[0] is None:
            continue
        comm_tot += num(r[8]) if r[3] != 'balance' else 0.0
        if r[4] == 'in' and r[7]:
            com[str(r[7])] = r[13] or ''
            bal_in[str(r[7])] = num(r[12])
        elif r[4] == 'out':
            usc[(r[2], str(r[0]), round(num(r[5]), 2))] = str((r[13] if len(r) > 13 else '') or '')
    pos = []
    for r in rows[p0:p1]:
        if not r or not r[1] or not str(r[1]).isdigit():
            continue
        t1 = str(r[8])
        if t1[:10] < da:
            continue
        pid = str(r[1])
        o = ordini.get(pid, {})
        uc = usc.get((r[2], t1, round(num(r[4]), 2)), '').strip().lower()
        sl_pos = num(r[6]); tp_pos = num(r[7]); pc = num(r[9])
        pos.append(dict(id=pid, sim=r[2], lato=r[3], vol=num(r[4]), t0=str(r[0]), p0=num(r[5]), t1=t1, p1=pc,
                        sl0=o.get('sl') or sl_pos, tp0=o.get('tp') or tp_pos, sl_pos=sl_pos, tp_pos=tp_pos,
                        comm=num(r[10]), swap=num(r[11]), prof=num(r[12]), net=num(r[12]) + num(r[10]) + num(r[11]),
                        uscita=('sl' if uc.startswith('[sl') else 'tp' if uc.startswith('[tp') else ('altro' if uc else 'mercato_senza_commento')),
                        stop=(uc.startswith('[sl') if uc else (sl_pos > 0 and abs(pc - sl_pos) < 1e-9 and num(r[12]) < 0)),
                        tp=(uc.startswith('[tp') if uc else (tp_pos > 0 and abs(pc - tp_pos) < 1e-9)),
                        com_in=com.get(pid, ''), com=famiglia(com.get(pid, '')), bal_dopo_in=bal_in.get(pid)))
    info = dict(saldo=None, netto=None, comm_tot=round(comm_tot, 2))
    for r in rows:
        if r and r[0] == 'Bilancio:':
            info['saldo'] = num(r[3])
        if r and r[0] == 'Profitto Totale Netto:':
            info['netto'] = num(r[3])
    return pos, info


def main():
    if len(sys.argv) < 2:
        print(__doc__); return 2
    da = sys.argv[2] if len(sys.argv) > 2 else '0000.00.00'
    pos, info = leggi(sys.argv[1], da)
    print('posizioni chiuse dal', da, ':', len(pos))
    g = collections.defaultdict(lambda: collections.defaultdict(list))
    for p in pos:
        g[p['t1'][:10]][p['com']].append(p)
    allarmi = []
    for giorno in sorted(g):
        tot = sum(p['net'] for L in g[giorno].values() for p in L)
        stops = sum(1 for L in g[giorno].values() for p in L if p['stop'])
        print(f"\n== {giorno}  netto {tot:9.2f}  stop a SL: {stops}")
        for c, L in sorted(g[giorno].items(), key=lambda x: -len(x[1])):
            print(f"   {c[:34]:34s} n={len(L):3d} vinte={sum(1 for p in L if p['net']>0):3d} stop={sum(1 for p in L if p['stop']):2d} TP={sum(1 for p in L if p['tp']):2d} netto={sum(p['net'] for p in L):9.2f}")
        if stops >= 3:
            allarmi.append(f"{giorno}: {stops} stop a SL nello stesso giorno (soglia: 3)")
    print(f"\nBilancio: {info['saldo']}  netto da Risultati: {info['netto']}  commissioni (affari): {info['comm_tot']}")
    if info['saldo'] and 0 < info['saldo'] <= 148000:
        allarmi.append(f"saldo {info['saldo']:.2f} <= 148000 (soglia di attenzione)")
    print('\nALLARMI:' if allarmi else '\nALLARMI: nessuno')
    for a in allarmi:
        print('  !!', a)
    return 0


if __name__ == '__main__':
    sys.exit(main())
