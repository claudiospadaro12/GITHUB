#!/usr/bin/env python3
# -*- coding: utf-8 -*-
"""
MANOPOLE INERTI v2 (12/09/2026) -- rifa' il censimento del 09/09 con:
  (1) l'ATTRIBUZIONE riparata: ea_of() di censimento_uscite.py (VIA path /
      magic / firma + VETO sulle colonne) al posto del nome del file;
  (2) la scansione di TUTTO il repo, non di tre cartelle;
  (3) la distinzione, DICHIARATA PRIMA DEI NUMERI, fra:
        INERTE          = i gruppi ceteris paribus danno esiti IDENTICI
                          cifra per cifra (Profit, PF, Trades, DD).
                          La manopola NON e' stata letta dal codice.
        INFLUENZA DEBOLE= i gruppi danno esiti DIVERSI ma piccoli
                          (dTrades == 0 e dPF <= SOGLIA_DEBOLE).
                          La manopola E' stata letta: conta come provata.
      Le due cose NON si sommano mai.

ESITO = (Profit, Profit Factor, Trades, Equity DD %) arrotondato al 5o decimale.
GRUPPO VIVO = gruppo di confronto con almeno una passata a >= 30 operazioni
              (un motore muto da' esiti identici perche' non c'e' niente da
              misurare: non e' una manopola morta).
Nessun numero stimato. Dove manca -> None -> [NON MISURATO].
"""
import csv, os, sys, json
from collections import defaultdict, Counter

ROOT = "/home/user/GITHUB"
sys.path.insert(0, os.path.join(ROOT, "backtest_pipeline"))
import censimento_uscite as CU          # ea_of riparata l'11/09/2026

SCRATCH = "/tmp/claude-0/-home-user-GITHUB/c2d73886-9ef2-5105-8937-d770bc36d6df/scratchpad"
SOGLIA_DEBOLE = 0.05        # dPF sotto cui un morso e' "debole", dichiarata qui
MIN_TRADES_VIVO = 30

def num(s):
    if s is None: return None
    s = s.strip().strip('"').replace('\xa0', ' ').strip()
    if s == '' or s.lower() in ('nan','n/a','-','inf','+inf','-inf'): return None
    if ',' in s and '.' in s:
        if s.rfind(',') > s.rfind('.'): s = s.replace('.','').replace(',','.')
        else: s = s.replace(',','')
    elif ',' in s:
        s = s.replace(',','.')
    s = s.replace(' ','')
    try: return float(s)
    except ValueError: return None

def read_file(path):
    raw = None
    for enc in ('utf-8-sig','utf-16','latin-1'):
        try:
            with open(path,'r',encoding=enc,newline='') as fh: raw = fh.read()
            if '\x00' in raw: raw = None; continue
            break
        except (UnicodeDecodeError, UnicodeError): continue
    if raw is None: return ('ILLEGGIBILE', None, [])
    lines = raw.splitlines()
    if not lines: return ('VUOTO', None, [])
    head = lines[0]
    if 'Profit Factor' not in head or 'Trades' not in head:
        return ('NON_RISULTATI', None, [])
    delim = ';' if head.count(';') > head.count(',') else ','
    rdr = csv.DictReader(lines, delimiter=delim)
    cols = rdr.fieldnames or []
    inpcols = [c for c in cols if c and c.strip().startswith('Inp')]
    rows = []
    for r in rdr:
        if r is None: continue
        pf = num(r.get('Profit Factor')); tr = num(r.get('Trades'))
        if pf is None or tr is None: continue
        rows.append(dict(pf=pf, trades=int(tr), dd=num(r.get('Equity DD %')),
                         profit=num(r.get('Profit')),
                         inp={c.strip(): (r.get(c) or '').strip() for c in inpcols}))
    if not rows: return ('SOLO_INTESTAZIONE', inpcols, [])
    return ('OK', [c.strip() for c in inpcols], rows)

def esito(r):
    rr = lambda x: None if x is None else round(x, 5)
    return (rr(r['profit']), rr(r['pf']), r['trades'], rr(r['dd']))

def analizza(path):
    stato, inpcols, rows = read_file(path)
    rel = os.path.relpath(path, ROOT)
    if stato != 'OK':
        return dict(stato=stato, rel=rel)
    esiti = [esito(r) for r in rows]
    var = [c for c in inpcols if len({r['inp'].get(c,'') for r in rows}) > 1]
    magics = sorted({r['inp'].get('InpMagic','') for r in rows} - {''})
    ea = CU.ea_of(rel, cols=inpcols, magics=magics)
    knobs = []
    for c in var:
        ctx = defaultdict(list)
        for i, r in enumerate(rows):
            ctx[tuple(r['inp'].get(o,'') for o in var if o != c)].append(i)
        g_conf = g_vivi = 0
        g_vivi_id = g_vivi_div = g_vivi_debole = 0
        dpfs = []; dtrs = []
        for k, idxs in ctx.items():
            if len({rows[i]['inp'].get(c,'') for i in idxs}) < 2: continue
            g_conf += 1
            ee = {esiti[i] for i in idxs}
            trs = [rows[i]['trades'] for i in idxs]
            pfs = [rows[i]['pf'] for i in idxs]
            if max(trs) < MIN_TRADES_VIVO: continue
            g_vivi += 1
            dpf = max(pfs) - min(pfs); dtr = max(trs) - min(trs)
            if len(ee) == 1:
                g_vivi_id += 1
            else:
                g_vivi_div += 1
                if dtr == 0 and dpf <= SOGLIA_DEBOLE: g_vivi_debole += 1
                dpfs.append(dpf); dtrs.append(dtr)
        valori = sorted({r['inp'].get(c,'') for r in rows},
                        key=lambda x: (num(x) is None, num(x) if num(x) is not None else x))
        dpfs.sort(); dtrs.sort()
        knobs.append(dict(col=c, valori=valori[:14], n_valori=len(valori),
                          g_conf=g_conf, g_vivi=g_vivi, g_vivi_id=g_vivi_id,
                          g_vivi_div=g_vivi_div, g_vivi_debole=g_vivi_debole,
                          dpf_med=(round(dpfs[(len(dpfs)-1)//2],4) if dpfs else None),
                          dpf_max=(round(max(dpfs),4) if dpfs else None),
                          dtr_med=(dtrs[(len(dtrs)-1)//2] if dtrs else None)))
    return dict(stato='OK', rel=rel, ea=ea, magics=magics, n_passate=len(rows),
                n_esiti=len(set(esiti)), n_vive=sum(1 for r in rows if r['trades']>0),
                n_esiti_vivi=len({esiti[i] for i,r in enumerate(rows) if r['trades']>0}),
                knobs=knobs)

def main():
    files = []
    for dp, dn, fn in os.walk(ROOT):
        if '/.git' in dp: continue
        for f in sorted(fn):
            if f.lower().endswith('.csv'): files.append(os.path.join(dp, f))
    files.sort()
    res = []; scarti = Counter()
    for p in files:
        r = analizza(p)
        if r.get('stato') != 'OK': scarti[r['stato']] += 1; continue
        res.append(r)
    os.makedirs(SCRATCH, exist_ok=True)
    json.dump(dict(res=res, scarti=dict(scarti)),
              open(os.path.join(SCRATCH,'manopole_v2.json'),'w'))
    att = sum(1 for r in res if r['ea'])
    print("csv di risultati letti:", len(res), "| scarti:", dict(scarti))
    print("attribuiti a un EA (ea_of riparata):", att, "| non attribuibili:", len(res)-att)
    print("passate totali:", sum(r['n_passate'] for r in res))
    print("passate con Trades>0:", sum(r['n_vive'] for r in res))
    dup = [r for r in res if r['n_vive'] > r['n_esiti_vivi'] and r['n_vive'] > 0]
    print("CSV con esiti duplicati fra le passate vive:", len(dup),
          "| passate vive senza esito nuovo:",
          sum(r['n_vive']-r['n_esiti_vivi'] for r in dup))

if __name__ == '__main__':
    main()
