#!/usr/bin/env python3
"""Fase 1: inventario dei file .set (Wim e terzi) + join con l'Excel dei PF. Solo lettura (nessun file di terzi viene eseguito).
Uso: /usr/bin/python3 -I build_inventory.py <out_dir>  (le radici sono in ROOTS)"""
import os, sys, csv, hashlib, re, collections
OUT = sys.argv[1]
ROOTS = [  # (cartella, etichetta di provenienza = SOLO il percorso, nessuna attribuzione certa)
 ('/tmp/claude-0/sfs', 'pacchetto_V9.8_di_Wim'), ('/tmp/claude-0/ubsset', 'pacchetto_set_di_Wim'),
 ('/tmp/claude-0/z5', 'UBSChristmas'), ('/tmp/claude-0/c6b/files', 'telegram_topic_set_potential'),
 ('/tmp/claude-0/tgf6', 'telegram_altri_topic'), ('/tmp/claude-0/btc', 'bitcoin_set'), ('/tmp/claude-0/btcz', 'bitcoin_set')]
KEYS = ['ForceSymbol','ST1_Timeframe','Run_Strategy','EntryModel','EA_Comment','EA_MagicNumber','Risk','StartLots','MaxTrades','Exit_stop','Exit_limit','RNG_TimeZone','UseTradingTimeZones']
def leggi(p):
    b = open(p, 'rb').read()
    if b[:2] in (b'\xff\xfe', b'\xfe\xff'): t = b.decode('utf-16', 'replace')
    else: t = b.decode('latin-1')
    d = {}
    for ln in t.splitlines():
        if '=' in ln and not ln.startswith(';'):
            k, v = ln.split('=', 1); d[k.strip()] = v.strip().split('||')[0]
    return t, d
rows = []; seen = collections.defaultdict(list)
for root, lab in ROOTS:
    for dp, dn, fn in os.walk(root):
        for f in fn:
            if not f.lower().endswith('.set'): continue
            p = os.path.join(dp, f)
            try: t, d = leggi(p)
            except Exception as e: continue
            norm = '\n'.join(sorted(l.strip() for l in t.splitlines() if '=' in l and not l.startswith(';')))
            h = hashlib.md5(norm.encode('utf-8', 'replace')).hexdigest()
            r = dict(nome=f, provenienza=lab, percorso=p.replace('/tmp/claude-0/', ''), md5=h, n_parametri=len(d))
            for k in KEYS: r[k] = d.get(k, '')
            rows.append(r); seen[h].append(len(rows) - 1)
for h, ix in seen.items():
    for i in ix: rows[i]['copie_identiche'] = len(ix)
# join con l'Excel dei PF (nome del set = cartella Zairex/Vantage)
import openpyxl
wb = openpyxl.load_workbook('/home/user/GITHUB/report/telegram_ubs_2026-11-22/UBS_sets_profit_factor.xlsx', data_only=True)
pf = {}
for r in wb['All sets'].iter_rows(min_row=2, values_only=True):
    if r[0]: pf[str(r[0]).strip().lower()] = r
for r in rows:
    k = re.sub(r'\.set$', '', r['nome'], flags=re.I).strip().lower()
    x = pf.get(k) if len(k) >= 4 else None  # i nomi di 1-3 caratteri (a, b, e, g...) sono ambigui fra cartelle: nessun join
    r['xlsx_PF'], r['xlsx_trade'], r['xlsx_DD_pct'] = (x[2], x[3], x[5]) if x else ('', '', '')
os.makedirs(OUT, exist_ok=True)
cols = list(rows[0].keys())
with open(os.path.join(OUT, 'master_inventory.csv'), 'w', newline='', encoding='utf-8') as fh:
    w = csv.DictWriter(fh, fieldnames=cols, delimiter=';'); w.writeheader(); w.writerows(rows)
uniq = {r['md5'] for r in rows}
print('file .set', len(rows), '| contenuti distinti', len(uniq), '| con PF nell Excel', sum(1 for r in rows if r['xlsx_PF'] != ''))
c = collections.Counter((r['provenienza']) for r in rows); print(dict(c))
s = collections.Counter(r['ForceSymbol'] for r in rows if r['ForceSymbol']); print('simboli (ForceSymbol):', s.most_common(15))
