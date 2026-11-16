#!/usr/bin/env python3
# Azione 1: mappa i parametri di input dei tuoi EA (.mq5) e dei .set esistenti nella directory indicata (default: corrente).
# Scrive mappa_parametri.csv (un parametro per riga) e stampa un riassunto. Solo lettura.
# Uso: python3 Mappa-Parametri.py [cartella] [--out mappa_parametri.csv]
import os, re, sys, csv
radice = '.'; out = 'mappa_parametri.csv'
a = sys.argv[1:]
if a and not a[0].startswith('--'): radice = a[0]; a = a[1:]
if '--out' in a: out = a[a.index('--out') + 1]
RUOLI = [  # (ruolo, regex sul nome, liberabile per l'ottimizzazione?)
 ('orario',   r'(?i)hour|minute|(^|_)min$|time|session|cutoff|zona|tz|gmt|start$|end$', False),
 ('rischio',  r'(?i)risk|lot|size|equity|balance|margin|maxdd|dailyloss|maxtotal', False),
 ('id',       r'(?i)magic|comment|file|name|symbol|currenc|prefix|path|url|key', False),
 ('uscita',   r'(?i)(^|_)(sl|tp)|stop|target|limit|trail|breakeven|\bbe\b|exit|rr$|_rr|partial|close', True),
 ('distanza', r'(?i)atr|buffer|dist|range|gap|pips|points|pts|offset|expir|countback|strength|level', True),
 ('soglia',   r'(?i)adx|rsi|stoch|ema|period|mult|min|max|thresh|filter|lookback', True),
]
def ruolo(nome, tipo):
    if tipo in ('bool',) or tipo.startswith('ENUM') : return ('interruttore/enum', False)
    if tipo == 'string': return ('testo', False)
    for r, rx, lib in RUOLI:
        if re.search(rx, nome): return (r, lib)
    return ('altro', False)
righe = []; n_set = 0; n_mq5 = 0; eas = {}
rx_in = re.compile(r'^\s*(?:sinput|input)\s+([A-Za-z_][A-Za-z0-9_ ]*?)\s+([A-Za-z_][A-Za-z0-9_]*)\s*=\s*([^;]*?)\s*;\s*(?://\s*(.*))?$')
for d, _, files in os.walk(radice):
    if '/.git' in d.replace('\\', '/'): continue
    for f in files:
        p = os.path.join(d, f); low = f.lower()
        if low.endswith('.mq5'):
            n_mq5 += 1; ea = f[:-4]
            for l in open(p, encoding='utf-8-sig', errors='ignore'):
                m = rx_in.match(l)
                if m:
                    tipo, nome, val, com = m.group(1).strip(), m.group(2), m.group(3).strip(), (m.group(4) or '').strip()
                    r, lib = ruolo(nome, tipo)
                    righe.append([ea, 'mq5', os.path.relpath(p, radice), nome, tipo, val, '', '', '', r, 'si' if lib else 'no', com[:80]])
                    eas.setdefault(ea, set()).add(nome)
        elif low.endswith('.set'):
            n_set += 1; ea = f[:-4]
            b = open(p, 'rb').read()
            t = b.decode('utf-16') if b[:2] in (b'\xff\xfe', b'\xfe\xff') else b.decode('utf-8-sig', errors='ignore')
            for l in t.splitlines():
                l = l.strip()
                if not l or l.startswith(';') or '=' not in l: continue
                nome, resto = l.split('=', 1); parti = resto.split('||')
                val = parti[0]; ini = parti[1] if len(parti) > 1 else ''; pas = parti[2] if len(parti) > 2 else ''; fin = parti[3] if len(parti) > 3 else ''
                fl = parti[4] if len(parti) > 4 else ''
                tipo = 'bool' if val in ('true', 'false') else ('numero' if re.fullmatch(r'-?\d+(\.\d+)?', val) else 'testo')
                r, lib = ruolo(nome, tipo)
                righe.append([ea, 'set', os.path.relpath(p, radice), nome, tipo, val, ini, pas, fin, r, 'si' if lib else 'no', 'ottimizzazione=' + fl if fl else ''])
with open(out, 'w', newline='', encoding='utf-8') as fo:
    w = csv.writer(fo); w.writerow(['ea', 'origine', 'file', 'parametro', 'tipo', 'valore', 'inizio', 'passo', 'fine', 'ruolo', 'liberabile', 'nota']); w.writerows(righe)
print('cartella: %s | .mq5: %d | .set: %d | righe di parametri: %d -> %s' % (os.path.abspath(radice), n_mq5, n_set, len(righe), out))
lib = [r for r in righe if r[1] == 'mq5' and r[10] == 'si']
print('parametri LIBERABILI nei sorgenti (uscite, distanze, soglie):', len(lib), 'su', sum(1 for r in righe if r[1] == 'mq5'))
from collections import Counter
print('per ruolo (sorgenti):', dict(Counter(r[9] for r in righe if r[1] == 'mq5')))
print('.set con intervalli di ottimizzazione (||):', len({r[2] for r in righe if r[1] == 'set' and r[6] != ''}), 'su', n_set)
