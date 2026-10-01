#!/usr/bin/env python3
# MARCATORE_LETTURA_TRIAL_v2 -- legge il report MT5 (xlsx 'Report Cronistorico') di un conto e stampa, PER GIORNO e PER SEDIA (commento
# dal deal di ingresso): posizioni chiuse, vinte, stop (uscita a prezzo di SL), netto; poi le SOGLIE DI ALLARME scritte prima in
# report/TRIAL_14_GIORNI_CRITERI_2026-10-01.md (equity <= 148.000, >= 3 stop nello stesso giorno). SOLA LETTURA: non tocca niente.
# Uso: python3 backtest_pipeline/lettura_trial.py <report.xlsx> [AAAA.MM.GG da]   NON e' un backtest: nessun PF come criterio di merito.
import sys, re, collections
import openpyxl

def num(x):
    try: return float(x)
    except Exception: return 0.0

def famiglia(c):
    c = re.sub(r'\[.*?\]', '', c or '').strip()
    return c or '(senza commento)'

def main():
    if len(sys.argv) < 2:
        print(__doc__); return 2
    da = sys.argv[2] if len(sys.argv) > 2 else '0000.00.00'
    wb = openpyxl.load_workbook(sys.argv[1], data_only=True)
    rows = [list(r) for r in wb.active.iter_rows(values_only=True)]
    sez = {}
    for i, r in enumerate(rows):
        if r[0] in ('Posizioni', 'Ordini', 'Affari', 'Posizioni aperte', 'Ordini attivi', 'Risultati') or str(r[0]).startswith('Bilancio:'):
            sez.setdefault(str(r[0]).split(':')[0], i)
    p0 = sez['Posizioni'] + 2; p1 = sez['Ordini']
    a0 = sez['Affari'] + 2; a1 = sez['Posizioni aperte']
    com = {}
    usc = {}   # (simbolo, ora uscita, volume) -> commento del deal di uscita: '[sl ...]' = stop, '[tp ...]' = take profit
    for r in rows[a0:a1]:
        if r[4] == 'in' and r[7]:
            com[str(r[7])] = r[13] or ''
        elif r[4] == 'out':
            usc[(r[2], str(r[0]), round(num(r[5]), 2))] = str(r[13] or '')
    pos = []
    for r in rows[p0:p1]:
        if not r[1] or not str(r[1]).isdigit():
            continue
        t1 = str(r[8]); 
        if t1[:10] < da: continue
        sl = num(r[6]); pc = num(r[9]); tp = num(r[7])
        uc = usc.get((r[2], t1, round(num(r[4]), 2)), '').strip().lower()
        pos.append(dict(id=str(r[1]), sim=r[2], vol=num(r[4]), t1=t1, net=num(r[12]) + num(r[10]) + num(r[11]),
                        stop=(uc.startswith('[sl') if uc else (sl > 0 and abs(pc - sl) < 1e-9 and num(r[12]) < 0)),
                        tp=(uc.startswith('[tp') if uc else (tp > 0 and abs(pc - tp) < 1e-9)),
                        com=famiglia(com.get(str(r[1]), ''))))
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
    # equity/bilancio dalla sezione Bilancio
    for r in rows[sez.get('Bilancio', 0):sez.get('Bilancio', 0) + 6]:
        v = [str(x) for x in r if x not in (None, '')]
        if v and ('Bilancio' in v[0] or 'Equit' in v[0]):
            print(' '.join(v))
            if 'Equit' in ' '.join(v):
                m = re.findall(r'Equit\S*:?\s*([0-9.]+)', ' '.join(v))
    for r in rows:
        for j, x in enumerate(r):
            if isinstance(x, str) and x.startswith('Equit') and j + 1 < len(r) and r[j + 1] is not None:
                e = num(r[j + 1])
                if 0 < e <= 148000:
                    allarmi.append(f"equity {e:.2f} <= 148000 (soglia di attenzione)")
    print('\nALLARMI:' if allarmi else '\nALLARMI: nessuno')
    for a in allarmi:
        print('  !!', a)
    return 0

if __name__ == '__main__':
    sys.exit(main())
