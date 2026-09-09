#!/usr/bin/env python3
# -*- coding: utf-8 -*-
"""
MANOPOLE INERTI - per OGNI csv di risultati del tester e per OGNI colonna Inp*
che VARIA dentro quel csv, misura se quella manopola HA MORSO.

METRICA DICHIARATA (due, e si dichiara quale si usa riga per riga):

 (1) TEST CETERIS PARIBUS  [metrica primaria, si usa quando esiste]
     Si raggruppano le passate per il valore di TUTTE LE ALTRE colonne Inp*
     ("contesto"). Dentro un contesto, la sola cosa che cambia e' la manopola
     in esame. Se in quel contesto la manopola prende >=2 valori:
        - il gruppo e' un CONFRONTO VALIDO;
        - se produce >=2 esiti distinti -> la manopola HA MORSO in quel gruppo.
     morso% = gruppi_con_esito_diverso / gruppi_confrontabili
     dPF    = mediana e massimo di (max PF - min PF) dentro i gruppi.
     Perche' e' la metrica giusta: e' l'unica che isola la manopola. Su una
     griglia fattoriale del tester le altre colonne sono bilanciate, quindi il
     confronto e' pulito per costruzione.

 (2) VARIANZA SPIEGATA (eta^2 del PF sulla manopola) [metrica di ripiego]
     Si usa SOLO quando nessun contesto ha >=2 valori (griglie non fattoriali,
     es. ottimizzazione genetica): eta^2 = SS_tra_gruppi / SS_totale del PF.
     E' piu' debole (confusa dagli altri parametri) e viene marcata come tale.

ESITO = quadrupla (Profit, Profit Factor, Trades, Equity DD %) arrotondata.
Passate con Trades=0 vengono TENUTE ma marcate: una manopola che porta a
zero operazioni HA morso (ha spento il motore), non e' inerte.

Nessun numero stimato. Dove manca -> None -> [NON MISURATO] nel referto.
"""
import csv, os, re, json, sys
from collections import defaultdict, Counter

ROOT = "/home/user/GITHUB"
DIRS = ["backtest_pipeline/risultati_archivio", "backtest_pipeline/risultati_prove",
        "backtest_pipeline/prove"]
SCRATCH = "/tmp/claude-0/-home-user-GITHUB/c2d73886-9ef2-5105-8937-d770bc36d6df/scratchpad"

# ---------------------------------------------------------------- utilita'
def num(s):
    if s is None: return None
    s = s.strip().strip('"').replace('\xa0', ' ').strip()
    if s == '' or s.lower() in ('nan', 'n/a', '-', 'inf', '+inf', '-inf'): return None
    if ',' in s and '.' in s:
        if s.rfind(',') > s.rfind('.'): s = s.replace('.', '').replace(',', '.')
        else: s = s.replace(',', '')
    elif ',' in s:
        s = s.replace(',', '.')
    s = s.replace(' ', '')
    try: return float(s)
    except ValueError: return None

# ------- parse_name: COPIA VERBATIM della logica di censimento_pf.py -------
TFSET = {'M1','M5','M15','M30','H1','H4','D1','W1','MN1'}
MQLTF = {1:'M1',5:'M5',15:'M15',30:'M30',16385:'H1',16386:'H2',16388:'H4',
         16408:'D1',32769:'W1',49153:'MN1'}
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
    m = re.match(r'^[0-9a-f]{8}-(.*)$', base)
    if m: base = m.group(1)
    toks = base.split('_'); up = [t.upper() for t in toks]
    fase = 'UNICA'
    for t in up:
        if t in FASE_TOK and FASE_TOK[t] in ('IS','OOS'): fase = FASE_TOK[t]
    sym = None
    for t in toks:
        if is_sym(t): sym = t.upper(); break
    tf = None
    for t in up:
        if t in TFSET: tf = t; break
    sym_i = next((i for i, t in enumerate(toks) if is_sym(t)), None)
    tf_i  = next((i for i, t in enumerate(up) if t in TFSET), None)
    cut = min([i for i in (sym_i, tf_i) if i is not None], default=None)
    PREFIX = ('ABTG', 'SCAN', 'VALID', 'WF')
    p0 = 0
    while p0 < len(toks) and up[p0] in PREFIX: p0 += 1
    if cut is None:
        mot = '_'.join(toks[p0:p0 + 2]) if len(toks) > p0 else toks[0]
    elif cut > p0:
        mot = '_'.join(toks[p0:cut])
    elif len(toks) > cut + 1:
        mot = toks[cut + 1]
        if len(mot) == 1 and len(toks) > cut + 2: mot = mot + '_' + toks[cut + 2]
    else:
        mot = toks[0]
    if not mot: mot = toks[0]
    if sym_i is not None and toks[sym_i].upper() in ('PTEGBP', 'PTEJPY'): mot = 'PTE'
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
BUCHI = []
def read_file(path):
    raw = None
    for enc in ('utf-8-sig', 'utf-16', 'latin-1'):
        try:
            with open(path, 'r', encoding=enc, newline='') as fh: raw = fh.read()
            if '\x00' in raw: raw = None; continue
            break
        except (UnicodeDecodeError, UnicodeError): continue
    if raw is None: return ('ILLEGGIBILE', None, [])
    lines = raw.splitlines()
    if not lines: return ('VUOTO', None, [])
    head = lines[0]
    if 'Profit Factor' not in head or 'Trades' not in head:
        return ('NON_RISULTATI', None, [])
    delim = ';' if (head.count(';') > head.count(',')) else ','
    rdr = csv.DictReader(lines, delimiter=delim)
    cols = rdr.fieldnames or []
    inpcols = [c for c in cols if c and c.strip().startswith('Inp')]
    rows = []
    for r in rdr:
        if r is None: continue
        pf = num(r.get('Profit Factor')); tr = num(r.get('Trades'))
        if pf is None or tr is None: continue
        rows.append(dict(
            pf=pf, trades=int(tr), dd=num(r.get('Equity DD %')),
            profit=num(r.get('Profit')),
            inp={c: (r.get(c) or '').strip() for c in inpcols},
        ))
    if not rows: return ('SOLO_INTESTAZIONE', inpcols, [])
    return ('OK', inpcols, rows)

def esito(r):
    """chiave ESITO. Arrotondata al 5o decimale per non far contare come
       'diverse' due passate che differiscono per rumore di stampa."""
    def rr(x): return None if x is None else round(x, 5)
    return (rr(r['profit']), rr(r['pf']), r['trades'], rr(r['dd']))

# --------------------------------------------------------------- il motore
def analizza_csv(path):
    stato, inpcols, rows = read_file(path)
    if stato != 'OK':
        return dict(stato=stato, rel=os.path.relpath(path, ROOT))
    meta = parse_name(path)
    n = len(rows)
    esiti = [esito(r) for r in rows]
    n_esiti = len(set(esiti))
    # colonne Inp* che VARIANO
    var = []
    for c in inpcols:
        vals = {r['inp'].get(c, '') for r in rows}
        if len(vals) > 1: var.append(c)
    out_knobs = []
    for c in var:
        # --- (1) ceteris paribus
        ctx = defaultdict(list)
        for i, r in enumerate(rows):
            k = tuple(r['inp'].get(o, '') for o in var if o != c)
            ctx[k].append(i)
        gr_conf = 0; gr_morso = 0; dpfs = []; dtr = []
        gr_vivi = 0; gr_vivi_morso = 0     # gruppi con almeno una passata a >=30 trade
        for k, idxs in ctx.items():
            vv = {rows[i]['inp'].get(c, '') for i in idxs}
            if len(vv) < 2: continue
            gr_conf += 1
            ee = {esiti[i] for i in idxs}
            if len(ee) > 1: gr_morso += 1
            pfs = [rows[i]['pf'] for i in idxs]
            trs = [rows[i]['trades'] for i in idxs]
            if max(trs) >= 30:
                gr_vivi += 1
                if len(ee) > 1: gr_vivi_morso += 1
            dpfs.append(max(pfs) - min(pfs)); dtr.append(max(trs) - min(trs))
        valori = sorted({r['inp'].get(c, '') for r in rows},
                        key=lambda x: (num(x) is None, num(x) if num(x) is not None else x))
        rec = dict(col=c, n_valori=len(valori), valori=valori[:12],
                   valori_tutti=len(valori))
        if gr_conf > 0:
            dpfs.sort(); dtr.sort()
            rec.update(metrica='ceteris_paribus', gr_conf=gr_conf, gr_morso=gr_morso,
                       gr_vivi=gr_vivi, gr_vivi_morso=gr_vivi_morso,
                       morso_pct=round(100.0 * gr_morso / gr_conf, 1),
                       dpf_med=round(dpfs[(len(dpfs)-1)//2], 4),
                       dpf_max=round(max(dpfs), 4),
                       dtr_med=dtr[(len(dtr)-1)//2], dtr_max=max(dtr))
        else:
            # --- (2) eta^2 di ripiego
            byv = defaultdict(list)
            for r in rows: byv[r['inp'].get(c, '')].append(r['pf'])
            allpf = [r['pf'] for r in rows]
            mu = sum(allpf)/len(allpf)
            sst = sum((x-mu)**2 for x in allpf)
            ssb = sum(len(v)*((sum(v)/len(v))-mu)**2 for v in byv.values())
            eta = (ssb/sst) if sst > 0 else None
            # esiti distinti per valore della manopola (grezzo)
            rec.update(metrica='eta2', gr_conf=0, gr_morso=None, gr_vivi=0, gr_vivi_morso=None,
                       morso_pct=None,
                       eta2=(None if eta is None else round(eta, 4)),
                       dpf_max=round(max(allpf)-min(allpf), 4))
        out_knobs.append(rec)
    return dict(stato='OK', rel=os.path.relpath(path, ROOT), motore=meta['motore'],
                simbolo=meta['simbolo'], tf=meta['tf'], fase=meta['fase'],
                etichetta=meta['etichetta'], cartella=meta['cartella'],
                n_passate=n, n_esiti=n_esiti, n_inp=len(inpcols), knobs=out_knobs,
                n_zero=sum(1 for r in rows if r['trades'] == 0))

def main():
    files = []
    for d in DIRS:
        full = os.path.join(ROOT, d)
        if not os.path.isdir(full):
            BUCHI.append((d, 'cartella assente')); continue
        for dp, dn, fn in os.walk(full):
            for f in fn:
                if f.lower().endswith('.csv'): files.append(os.path.join(dp, f))
    files.sort()
    res = []; scarti = Counter()
    for p in files:
        r = analizza_csv(p)
        if r.get('stato') != 'OK':
            scarti[r.get('stato')] += 1
            if r.get('stato') not in ('NON_RISULTATI',): BUCHI.append((r['rel'], r['stato']))
            continue
        res.append(r)
    os.makedirs(SCRATCH, exist_ok=True)
    with open(os.path.join(SCRATCH, 'manopole.json'), 'w') as fh:
        json.dump(dict(res=res, scarti=dict(scarti), buchi=BUCHI), fh)
    print("csv analizzati:", len(res), "| scarti:", dict(scarti), "| buchi:", len(BUCHI))
    tot_p = sum(r['n_passate'] for r in res)
    tot_e = sum(r['n_esiti'] for r in res)
    print("passate totali:", tot_p, "| esiti distinti totali:", tot_e,
          "| passate senza informazione nuova:", tot_p - tot_e)

if __name__ == '__main__':
    main()
