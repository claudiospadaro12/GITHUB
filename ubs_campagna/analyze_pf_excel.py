#!/usr/bin/env python3
"""Fase 1: analisi dell'Excel dei PF (312 set di Zairex_ su Vantage, tick). Uso: /usr/bin/python3 -I analyze_pf_excel.py <xlsx> <out_md>"""
import sys, re, collections, statistics as st
import openpyxl
wb = openpyxl.load_workbook(sys.argv[1], data_only=True); rows = [r for r in wb['All sets'].iter_rows(min_row=2, values_only=True) if r[0]]
D = [dict(set=str(r[0]), pf=float(r[2]), n=int(r[3]), net=float(r[4]), dd=float(r[5])) for r in rows]
SIM = [('XAU|GOLD', 'oro'), ('BTC', 'bitcoin'), ('ETH', 'ethereum'), ('US30|DOW', 'US30'), ('USTEC|NAS|NQ', 'Nasdaq'), ('US500|SPX|SP500', 'S&P500'), ('XAG|SILVER', 'argento'), ('EURUSD', 'EURUSD'), ('GBPUSD', 'GBPUSD'), ('USDJPY', 'USDJPY'), ('TSLA', 'Tesla'), ('DE40|DAX|GER', 'DAX'), ('XTI|OIL|WTI', 'petrolio')]
def fam(n):
    for pat, lab in SIM:
        if re.search(pat, n, re.I): return lab
    return 'altro/ignoto'
for d in D: d['fam'] = fam(d['set']); d['tf'] = (re.search(r'(M1|M5|M15|M30|H1|H4|D1|daily)', d['set'], re.I) or [None, '?'])[0].upper() if re.search(r'(M1|M5|M15|M30|H1|H4|D1|daily)', d['set'], re.I) else '?'
out = []
def P(s=''): out.append(s)
pfs = [d['pf'] for d in D]; P('# Analisi forense dell\'Excel dei PF (312 set, Vantage a tick, 2020-2026) - ' + '24/11/2026')
P('Fonte: `UBS_sets_profit_factor.xlsx` (Zairex_, Telegram UBS). **Colonne disponibili: PF, operazioni, utile netto, DD%.** Recovery Factor e Sharpe NON ci sono nel file (si ricalcolano solo dai report htm dei set, non scaricati). Tutti i numeri sono DICHIARATI dalla fonte, non nostri: sono lo stesso periodo e lo stesso feed per tutti i set, quindi servono per confrontarli fra loro, non come promessa.')
P(f'\n- Set: {len(D)}; PF mediano {st.median(pfs):.2f}; PF >= 1,80: {sum(p>=1.8 for p in pfs)}; PF >= 3: {sum(p>=3 for p in pfs)}; PF < 1,2: {sum(p<1.2 for p in pfs)}')
P(f'- Operazioni: mediana {st.median(d["n"] for d in D):.0f}; set con < 100 operazioni: {sum(d["n"]<100 for d in D)}; con < 60: {sum(d["n"]<60 for d in D)}')
P(f'- DD%: mediana {st.median(d["dd"] for d in D):.2f}; DD > 3%: {sum(d["dd"]>3 for d in D)}')
P('\n## Top 15 per PF (con operazioni e DD)'); P('| set | fam | PF | op | DD% | netto |'); P('|---|---|---|---|---|---|')
for d in sorted(D, key=lambda x: -x['pf'])[:15]: P(f"| {d['set']} | {d['fam']} | {d['pf']} | {d['n']} | {d['dd']} | {d['net']:.0f} |")
P('\n## Per famiglia (simbolo letto dal nome: indicativo)'); P('| famiglia | set | PF mediano | PF max | op mediane | set PF>=1,8 |'); P('|---|---|---|---|---|---|')
by = collections.defaultdict(list)
for d in D: by[d['fam']].append(d)
for k, v in sorted(by.items(), key=lambda kv: -st.median(x['pf'] for x in kv[1])): P(f"| {k} | {len(v)} | {st.median(x['pf'] for x in v):.2f} | {max(x['pf'] for x in v):.2f} | {st.median(x['n'] for x in v):.0f} | {sum(x['pf']>=1.8 for x in v)} |")
P('\n## Anomalie (da trattare come sospette)')
a1 = [d for d in D if d['pf'] >= 3 and d['n'] < 100]; P(f'- PF >= 3 con meno di 100 operazioni: {len(a1)} -> ' + ', '.join(f"{d['set']} (PF {d['pf']}, {d['n']} op)" for d in sorted(a1, key=lambda x: -x['pf'])[:10]))
a2 = [d for d in D if d['dd'] > 3.0 and d['pf'] >= 1.8]; P(f'- PF >= 1,8 ma DD > 3%: {len(a2)} (DD alto per un conto a lotto fisso piccolo)')
a3 = [d for d in D if d['n'] >= 250 and d['pf'] >= 1.8]; P(f'- PF >= 1,8 con >= 250 operazioni (le piu credibili statisticamente): {len(a3)} -> ' + ', '.join(f"{d['set']} ({d['pf']}, {d['n']})" for d in sorted(a3, key=lambda x: -x['pf'])[:12]))
# stesso nome base: varianti consecutive
base = collections.defaultdict(list)
for d in D: base[re.sub(r'[_ ]?[a-zA-Z]?$', '', d['set'])[:30]].append(d['pf'])
big = [(k, v) for k, v in base.items() if len(v) >= 5]
P('\n## Famiglie con molte varianti (spread del PF fra varianti: se alto, il PF dipende dal set e non dal modello)')
for k, v in sorted(big, key=lambda kv: -len(kv[1]))[:8]: P(f'- {k}: {len(v)} varianti, PF da {min(v):.2f} a {max(v):.2f}, mediano {st.median(v):.2f}')
P('\n## Correlazione tra PF e numero di operazioni (Spearman, rango)')
def rank(x): 
    o = sorted(range(len(x)), key=lambda i: x[i]); r = [0]*len(x)
    for j, i in enumerate(o): r[i] = j
    return r
ra, rb = rank([d['pf'] for d in D]), rank([d['n'] for d in D]); n = len(D); ma = (n-1)/2
rho = sum((a-ma)*(b-ma) for a, b in zip(ra, rb)) / sum((a-ma)**2 for a in ra); P(f'- rho(PF, operazioni) = {rho:+.2f}: i PF piu alti sono ' + ('quelli con MENO operazioni (segno di campione piccolo/fortuna)' if rho < -0.2 else 'non legati al numero di operazioni'))
open(sys.argv[2], 'w').write('\n'.join(out) + '\n'); print('\n'.join(out))
