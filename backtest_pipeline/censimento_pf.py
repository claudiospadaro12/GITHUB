#!/usr/bin/env python3
# -*- coding: utf-8 -*-
"""
CENSIMENTO PF MISURATI - legge TUTTI i CSV di risultati del tester e produce
la tabella dei Profit Factor (cella migliore + cella MEDIANA) per ogni
(motore, simbolo, TF, etichetta/round, cartella), separando IS / OOS / UNICA.

REGOLA: nessun numero stimato. Se un dato non c'e' -> None -> [NON MISURATO].
"""
import csv, os, re, sys, json
from collections import defaultdict

ROOT = "/home/user/GITHUB"
DIRS = ["backtest_pipeline/risultati_archivio", "backtest_pipeline/risultati_prove",
        "backtest_pipeline/prove"]
OUT_CSV = os.path.join(ROOT, "backtest_pipeline/risultati_archivio/CENSIMENTO_PF_TUTTI_2026-09-09.csv")
OUT_MD  = os.path.join(ROOT, "report/CENSIMENTO_PF_MISURATI_2026-09-09.md")

# ---------------------------------------------------------------- utilita'
def num(s):
    """float robusto: accetta punto O virgola decimale. None se non numerico."""
    if s is None: return None
    s = s.strip().strip('"').replace(' ', ' ').strip()
    if s == '' or s.lower() in ('nan', 'n/a', '-', 'inf', '+inf', '-inf'): return None
    # separatore migliaia + virgola decimale tipo 1.234,56
    if ',' in s and '.' in s:
        if s.rfind(',') > s.rfind('.'):
            s = s.replace('.', '').replace(',', '.')
        else:
            s = s.replace(',', '')
    elif ',' in s:
        s = s.replace(',', '.')
    s = s.replace(' ', '')
    try: return float(s)
    except ValueError: return None

TFSET = {'M1','M5','M15','M30','H1','H4','D1','W1','MN1'}
MQLTF = {1:'M1',2:'M2',3:'M3',4:'M4',5:'M5',6:'M6',10:'M10',12:'M12',15:'M15',
         20:'M20',30:'M30',16385:'H1',16386:'H2',16387:'H3',16388:'H4',
         16390:'H6',16392:'H8',16396:'H12',16408:'D1',32769:'W1',49153:'MN1'}

SYM_BLACK = {'EMA200','CROLLO','ANCORA','SIGNAL','LARRY','METRO','SUPREV'}
SYM_EXTRA = {'UKOIL','USOIL','ORO','DAX','NAS','NASDAQ','FTSE','DOW','OIL'}
SYM_RE = re.compile(r'^(?:[A-Z]{6}|[0-9]{3}[A-Z]{3}|[A-Z][0-9]{2}[A-Z]{3})$')

def is_sym(t):
    if t.upper() in SYM_BLACK: return False
    if t.upper() in SYM_EXTRA: return True
    return bool(SYM_RE.match(t))

FASE_TOK = {'IS':'IS','OOS':'OOS','FULL':'UNICA'}

def parse_name(path):
    rel = os.path.relpath(path, ROOT)
    cartella = os.path.dirname(rel)
    base = os.path.basename(path)[:-4]
    # prefisso hash MT5 tipo "00616ea4-valid_..."
    m = re.match(r'^[0-9a-f]{8}-(.*)$', base)
    if m: base = m.group(1)
    toks = base.split('_')
    up = [t.upper() for t in toks]

    fase = 'UNICA'
    for t in up:
        if t in FASE_TOK and FASE_TOK[t] in ('IS','OOS'):
            fase = FASE_TOK[t]

    sym = None
    for t in toks:
        if is_sym(t): sym = t.upper(); break

    tf = None
    for t in up:
        if t in TFSET: tf = t; break

    # indice del token simbolo / TF
    sym_i = next((i for i, t in enumerate(toks) if is_sym(t)), None)
    tf_i  = next((i for i, t in enumerate(up) if t in TFSET), None)
    cut = min([i for i in (sym_i, tf_i) if i is not None], default=None)

    PREFIX = ('ABTG', 'SCAN', 'VALID', 'WF')
    p0 = 0
    while p0 < len(toks) and up[p0] in PREFIX:
        p0 += 1

    if cut is None:
        mot = '_'.join(toks[p0:p0 + 2]) if len(toks) > p0 else toks[0]
    elif cut > p0:
        mot = '_'.join(toks[p0:cut])
    elif len(toks) > cut + 1:
        # il simbolo e' il primo token (es. dow_walkforward, oro_maxmin, PTEGBP_B25)
        mot = toks[cut + 1]
        if len(mot) == 1 and len(toks) > cut + 2:   # DAX_A_geometria_IS
            mot = mot + '_' + toks[cut + 2]
    else:
        mot = toks[0]
    if not mot:
        mot = toks[0]
    # PTEGBP_* / PTEJPY_* = famiglia PTE (il simbolo esatto NON e' nel nome file)
    if sym_i is not None and toks[sym_i].upper() in ('PTEGBP', 'PTEJPY'):
        mot = 'PTE'

    # etichetta = quel che resta
    used = set()
    consumed = {mot.upper(), 'ABTG', 'SCAN', 'VALID', 'WF'}
    if sym: consumed.add(sym)
    if tf: consumed.add(tf)
    consumed |= {'IS','OOS','FULL','REALTICK'}
    consumed |= set(mot.upper().split('_'))
    lab = [t for t in toks if t.upper() not in consumed]
    etich = '_'.join(lab) if lab else os.path.basename(cartella)
    return dict(rel=rel, cartella=cartella, base=base, motore=mot, simbolo=sym,
                tf=tf, fase=fase, etichetta=etich)

# ------------------------------------------------------------- lettura CSV
def find_csvs():
    out = []
    for d in DIRS:
        full = os.path.join(ROOT, d)
        if not os.path.isdir(full):
            BUCHI.append((d, "cartella assente"))
            continue
        for dp, dn, fn in os.walk(full):
            for f in fn:
                if f.lower().endswith('.csv'):
                    out.append(os.path.join(dp, f))
    return sorted(out)

BUCHI = []
COLS_NEEDED = ('Profit Factor', 'Trades')

def read_file(path):
    """ritorna (stato, righe) - righe = list di dict numerici"""
    raw = None
    for enc in ('utf-8-sig', 'utf-16', 'latin-1'):
        try:
            with open(path, 'r', encoding=enc, newline='') as fh:
                raw = fh.read()
            if '\x00' in raw: raw = None; continue
            break
        except (UnicodeDecodeError, UnicodeError):
            continue
    if raw is None:
        return ('ILLEGGIBILE', [])
    lines = raw.splitlines()
    if not lines: return ('VUOTO', [])
    head = lines[0]
    if 'Profit Factor' not in head or 'Trades' not in head:
        return ('NON_RISULTATI', [])
    delim = ';' if (head.count(';') > head.count(',')) else ','
    rdr = csv.DictReader(lines, delimiter=delim)
    rows = []
    bad = 0
    for r in rdr:
        if r is None: continue
        pf = num(r.get('Profit Factor'))
        tr = num(r.get('Trades'))
        if pf is None or tr is None:
            bad += 1
            continue
        rows.append(dict(
            pf=pf, trades=int(tr),
            dd=num(r.get('Equity DD %')),
            profit=num(r.get('Profit')),
            payoff=num(r.get('Expected Payoff')),
            sharpe=num(r.get('Sharpe Ratio')),
            rf=num(r.get('Recovery Factor')),
            tfraw=num(r.get('InpTF')),
            simb=(r.get('Simbolo') or '').strip() or None,
        ))
    if not rows:
        return ('SOLO_INTESTAZIONE', [])
    return ('OK', rows)

# ------------------------------------------------------------------ main
def dedup(rows):
    """passate con ESITO identico (Profit/PF/Trades/DD) contano UNA volta:
       una griglia con parametri inerti ripete lo stesso esito N volte e
       sposterebbe la mediana senza che nessuna misura sia cambiata."""
    seen, out = set(), []
    for r in rows:
        k = (r['profit'], r['pf'], r['trades'], r['dd'])
        if k in seen: continue
        seen.add(k); out.append(r)
    return out


def median_cell(rows):
    """cella MEDIANA per PF: si ordina per PF e si prende l'elemento centrale
       (per n pari: quello subito SOTTO la meta' - dichiarato, non stimato)."""
    if not rows: return None
    s = sorted(rows, key=lambda r: r['pf'])
    return s[(len(s) - 1) // 2]

def best_cell(rows):
    if not rows: return None
    return max(rows, key=lambda r: r['pf'])

def main():
    files = find_csvs()
    stat = defaultdict(int)
    file_notes = []          # (rel, stato, dettaglio)
    zero_files = []          # csv con TUTTE le passate a Trades=0
    zero_partial = []        # csv con ALCUNE passate a Trades=0
    groups = defaultdict(lambda: defaultdict(list))   # key -> fase -> rows
    gmeta = {}
    letti_dirs = set()

    for p in files:
        rel = os.path.relpath(p, ROOT)
        stato, rows = read_file(p)
        stat['totali'] += 1
        if stato == 'NON_RISULTATI':
            stat['non_risultati'] += 1
            continue
        stat['risultati'] += 1
        if stato != 'OK':
            stat['illeggibili_o_vuoti'] += 1
            file_notes.append((rel, stato, ''))
            BUCHI.append((rel, stato))
            continue
        nz = [r for r in rows if r['trades'] == 0]
        ok = [r for r in rows if r['trades'] > 0]
        if len(nz) == len(rows):
            zero_files.append((rel, len(rows)))
            stat['csv_tutti_zero'] += 1
            continue
        if nz:
            zero_partial.append((rel, len(nz), len(rows)))
            stat['passate_zero'] += len(nz)
        meta = parse_name(p)
        letti_dirs.add(meta['cartella'])
        # TF da InpTF se il nome non lo dice
        tf = meta['tf']
        if tf is None:
            tfv = [r['tfraw'] for r in ok if r['tfraw'] is not None]
            if tfv:
                cand = {MQLTF.get(int(v)) for v in tfv}
                cand.discard(None)
                if len(cand) == 1: tf = cand.pop()
                elif len(cand) > 1: tf = 'MISTO(' + '/'.join(sorted(cand)) + ')'
        if tf is None:
            dirup = meta['cartella'].upper().replace('-', '_').replace('/', '_')
            for t in ('M15','M30','M5','H1','H4','D1','M1'):
                if re.search(r'(?:^|_)' + t + r'(?:_|$)', dirup): tf = t; break
        sym = meta['simbolo']
        if sym is None:
            syms = {r['simb'] for r in ok if r['simb']}
            if len(syms) == 1: sym = syms.pop()
            elif len(syms) > 1: sym = 'MULTI(' + str(len(syms)) + ')'
        key = (meta['motore'], sym or '[NON MISURATO]', tf or '[NON MISURATO]',
               meta['etichetta'], meta['cartella'])
        groups[key][meta['fase']].extend(ok)
        gmeta.setdefault(key, []).append(rel)
        stat['csv_usati'] += 1

    # ------------------------------------------------------ costruzione righe
    out_rows = []
    for key, fasi in groups.items():
        mot, sym, tf, etich, cart = key
        rec = dict(motore=mot, simbolo=sym, tf=tf, etichetta=etich, cartella=cart,
                   file=';'.join(sorted(gmeta[key])))
        for fase in ('IS', 'OOS', 'UNICA'):
            rr = fasi.get(fase, [])
            pre = fase.lower()
            if not rr:
                for c in ('passate','uniche','pf_med','pf_max','trades_med','trades_max',
                          'dd_med','profit_med','dd_max','profit_max'):
                    rec[pre + '_' + c] = None
                continue
            ru = dedup(rr)
            med = median_cell(ru); bst = best_cell(ru)
            rec[pre + '_passate']    = len(rr)
            rec[pre + '_uniche']     = len(ru)
            rec[pre + '_pf_med']     = med['pf']
            rec[pre + '_pf_max']     = bst['pf']
            rec[pre + '_trades_med'] = med['trades']
            rec[pre + '_trades_max'] = bst['trades']
            rec[pre + '_dd_med']     = med['dd']
            rec[pre + '_profit_med'] = med['profit']
            rec[pre + '_dd_max']     = bst['dd']
            rec[pre + '_profit_max'] = bst['profit']
        # colonna vicino alla soglia: PF OOS mediano >= 0.90 e n(trade) >= 100
        pfo, tro = rec.get('oos_pf_med'), rec.get('oos_trades_med')
        if pfo is None or tro is None:
            rec['vicino'] = '[NON MISURATO]'
        else:
            rec['vicino'] = 'SI' if (pfo >= 0.90 and tro >= 100) else 'no'
        out_rows.append(rec)

    # ordina per PF OOS mediano decrescente; senza OOS in fondo
    out_rows.sort(key=lambda r: (0 if r.get('oos_pf_med') is not None else 1,
                                 -(r.get('oos_pf_med') or 0),
                                 -(r.get('unica_pf_med') or 0),
                                 -(r.get('is_pf_med') or 0)))

    # ------------------------------------------------------------ CSV grezzo
    fields = ['motore','simbolo','tf','etichetta','cartella','vicino']
    for fase in ('is','oos','unica'):
        for c in ('passate','uniche','pf_med','pf_max','trades_med','trades_max',
                  'dd_med','profit_med','dd_max','profit_max'):
            fields.append(fase + '_' + c)
    fields.append('file')
    os.makedirs(os.path.dirname(OUT_CSV), exist_ok=True)
    with open(OUT_CSV, 'w', encoding='utf-8', newline='') as fh:
        w = csv.DictWriter(fh, fieldnames=fields, extrasaction='ignore')
        w.writeheader()
        for r in out_rows: w.writerow(r)

    dump = dict(stat=dict(stat), n_gruppi=len(out_rows), zero_files=zero_files,
                zero_partial=zero_partial, buchi=BUCHI,
                dirs=sorted(letti_dirs), rows=out_rows)
    with open('/tmp/claude-0/-home-user-GITHUB/c2d73886-9ef2-5105-8937-d770bc36d6df/scratchpad/dump.json','w') as fh:
        json.dump(dump, fh)
    print(json.dumps(dict(stat=dict(stat), gruppi=len(out_rows),
                          zero=len(zero_files), zero_parz=len(zero_partial),
                          buchi=len(BUCHI), dirs=len(letti_dirs)), indent=1))
    print("con OOS:", sum(1 for r in out_rows if r.get('oos_pf_med') is not None))
    print("SI vicino:", sum(1 for r in out_rows if r['vicino']=='SI'))

main()
