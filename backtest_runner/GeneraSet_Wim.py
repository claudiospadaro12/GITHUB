#!/usr/bin/env python3
# Azione 4: genera un batch di file .set LOGICI (non casuali) per un EA, applicando le regole di Wim documentate nei nostri file
# (vedi REGOLE_WIM.md per fonti e per cio che NON e documentato). Deterministico: stessi input = stessi file.
# Uso: python3 GeneraSet_Wim.py --mq5 EA.mq5 --ruoli ruoli_EA.json --out Set_da_testare [--preset base.set]
import argparse, json, os, re, csv, sys
PER = {'M1': 1, 'M5': 5, 'M15': 15, 'M30': 30, 'H1': 16385, 'H2': 16386, 'H3': 16387, 'H4': 16388, 'H6': 16390, 'H8': 16392, 'H12': 16396, 'D1': 16408, 'W1': 32769, 'MN1': 49153}
ap = argparse.ArgumentParser(); ap.add_argument('--mq5', required=True); ap.add_argument('--ruoli', required=True); ap.add_argument('--out', default='Set_da_testare'); ap.add_argument('--preset', default='')
a = ap.parse_args()
ruoli = json.load(open(a.ruoli, encoding='utf-8'))
EA = ruoli['ea']; P = ruoli['parametri']; log = []
if len(P) > 4: sys.exit('ERRORE regola R1: al massimo 4 parametri liberi (ne hai %d)' % len(P))
# --- baseline: preset se dato, altrimenti i valori di default scritti nel sorgente ---
base = {}
if a.preset:
    for l in open(a.preset, encoding='utf-8-sig', errors='ignore'):
        l = l.strip()
        if l and not l.startswith(';') and '=' in l: k, v = l.split('=', 1); base[k.strip()] = v.split('||')[0].strip()
    fonte = 'preset ' + os.path.basename(a.preset)
else:
    rx = re.compile(r'^\s*(?:sinput|input)\s+[A-Za-z_][A-Za-z0-9_ ]*?\s+([A-Za-z_][A-Za-z0-9_]*)\s*=\s*([^;]*?)\s*;')
    for l in open(a.mq5, encoding='utf-8-sig', errors='ignore'):
        m = rx.match(l)
        if not m: continue
        k, v = m.group(1), m.group(2).strip()
        if v in ('true', 'false'): base[k] = v
        elif re.fullmatch(r'-?\d+(\.\d+)?', v): base[k] = v
        elif re.fullmatch(r'PERIOD_([A-Z]+\d+)', v) and v[7:] in PER: base[k] = str(PER[v[7:]])
        elif re.fullmatch(r'"[^"]*"', v): base[k] = v[1:-1]
        else: log.append('saltato (valore non letterale, resta il default dell EA): %s = %s' % (k, v))
    fonte = 'valori di default di ' + os.path.basename(a.mq5)
for p in P:
    if p['nome'] not in base: sys.exit('ERRORE: parametro libero %s non trovato nella baseline' % p['nome'])
def num(x): return float(x)
def fmt(x, intero):
    if intero: return str(int(round(x)))
    s = ('%.4f' % x).rstrip('0').rstrip('.'); return s if s else '0'
B = {p['nome']: num(base[p['nome']]) for p in P}
# --- regola R3 (pavimenti) e limiti min/max dichiarati nel file dei ruoli ---
def livello(p, k):  # k = -1, 0, +1 passi
    v = B[p['nome']] + k * p['passo']
    lo = p.get('min', None); hi = p.get('max', None)
    if p['tipo'] in ('sl', 'tp'): lo = max(lo if lo is not None else 0, 0.5 * B[p['nome']])  # R3: mai sotto il 50% della baseline
    if lo is not None: v = max(v, lo)
    if hi is not None: v = min(v, hi)
    return v
# --- regola R4 (coerenza di regime): il rapporto target/stop non esce da [0.75, 1.5] x quello della baseline ---
cp = ruoli.get('coppia_rr', {})
def rapporto(val):
    if 'tp_R' in cp: return val.get(cp['tp_R'], B.get(cp['tp_R']))
    if 'sl' in cp and 'tp' in cp:
        s = val.get(cp['sl'], B.get(cp['sl'])); t = val.get(cp['tp'], B.get(cp['tp']))
        return t / s if s else None
    return None
R0 = rapporto({})
def coerente(val):
    if R0 is None: return True
    r = rapporto(val); return r is not None and 0.75 * R0 <= r <= 1.5 * R0
# --- disegno: base + 8 vicini (un passo a sinistra e uno a destra, come il fine-tuning di Wim) + L9 ortogonale ---
L9 = [[0,0,0,0],[0,1,1,1],[0,2,2,2],[1,0,1,2],[1,1,2,0],[1,2,0,1],[2,0,2,1],[2,1,0,2],[2,2,1,0]]
sets = [('S000_BASE', 'base', 'baseline: %s' % fonte, {})]
for i, p in enumerate(P):
    for k, s in ((-1, 'meno'), (1, 'piu')):
        v = livello(p, k)
        if abs(v - B[p['nome']]) < 1e-9: log.append('vicino scartato (cade sul limite/pavimento): %s %s' % (p['nome'], s)); continue
        sets.append(('S1%02d_VIC_%s_%s' % (len(sets), p['nome'], s), 'vicino', 'un passo %s su %s (perturbazione, regola R2)' % (s, p['nome']), {p['nome']: v}))
n = len(P)
for j, riga in enumerate(L9):
    val = {p['nome']: livello(p, riga[i] - 1) for i, p in enumerate(P)}
    nome = 'S2%02d_OA9_%d' % (j + 1, j + 1)
    sets.append((nome, 'ortogonale', 'combinazione L9 (copre le coppie di livelli senza griglia completa)', val))
tenuti = []
for nome, tipo, tag, val in sets:
    if tipo != 'base' and not coerente(val): log.append('scartato %s: rapporto target/stop %.2f fuori da [%.2f, %.2f] (regola R4)' % (nome, rapporto(val) or 0, 0.75 * R0, 1.5 * R0)); continue
    if tipo == 'base' or any(abs(val[k] - B[k]) > 1e-9 for k in val): tenuti.append((nome, tipo, tag, val))
    else: log.append('scartato %s: coincide con la baseline' % nome)
# --- scrittura ---
os.makedirs(a.out, exist_ok=True)
for f in os.listdir(a.out):
    if f.endswith('.set') and (f.startswith('S0') or f.startswith('S1') or f.startswith('S2')): os.remove(os.path.join(a.out, f))
liberi = {p['nome']: p for p in P}
def scrivi(nome, val, tag):
    righe = ['; %s - %s' % (nome, tag), '; EA: %s  simbolo/tf: %s %s  generato da GeneraSet_Wim.py (regole R1-R9, vedi REGOLE_WIM.md)' % (EA, ruoli.get('simbolo', '?'), ruoli.get('tf', '?')), '; baseline: %s' % fonte]
    for k, v in base.items():
        if k in val: v = fmt(val[k], liberi[k].get('intero', False))
        righe.append('%s=%s' % (k, v))
    open(os.path.join(a.out, nome + '.set'), 'w', newline='\n', encoding='utf-8').write('\n'.join(righe) + '\n')
cat = [['set', 'tipo', 'tag'] + [p['nome'] for p in P] + ['rapporto_tp_sl']]
for nome, tipo, tag, val in tenuti:
    scrivi(nome, val, tag)
    cat.append([nome, tipo, tag] + [fmt(val.get(p['nome'], B[p['nome']]), p.get('intero', False)) for p in P] + [('%.2f' % rapporto(val)) if rapporto(val) else ''])
csv.writer(open(os.path.join(a.out, 'catalogo_set.csv'), 'w', newline='', encoding='utf-8')).writerows(cat)
# template di ottimizzazione in stile Wim (parametri liberi con ||Y e intervalli) - per chi volesse usare l'ottimizzatore di MT5 sugli stessi 4 parametri
tp = ['; TEMPLATE di ottimizzazione (stile Wim): solo i %d parametri liberi hanno ||Y; tutto il resto fisso a baseline (%s)' % (len(P), fonte)]
for k, v in base.items():
    if k in liberi:
        p = liberi[k]; tp.append('%s=%s||%s||%s||%s||Y' % (k, fmt(B[k], p.get('intero', False)), fmt(livello(p, -1), p.get('intero', False)), fmt(p['passo'], p.get('intero', False)), fmt(livello(p, 1), p.get('intero', False))))
    else: tp.append('%s=%s||%s||0||%s||N' % (k, v, v, v))
open(os.path.join(a.out, 'TEMPLATE_OTT_%s.set' % EA), 'w', newline='\n', encoding='utf-8').write('\n'.join(tp) + '\n')
open(os.path.join(a.out, 'LOG_generazione.txt'), 'w', encoding='utf-8').write('baseline: %s\nparametri liberi: %s\nrapporto target/stop baseline R0 = %s\nset scritti: %d\n' % (fonte, ', '.join(liberi), ('%.2f' % R0) if R0 else 'n.d.', len(tenuti)) + '\n'.join(log) + '\n')
print('baseline:', fonte, '| liberi:', list(liberi), '| R0:', R0, '| set scritti:', len(tenuti), '->', a.out)
for l in log: print('  nota:', l)
