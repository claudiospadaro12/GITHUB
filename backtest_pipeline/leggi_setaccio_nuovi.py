#!/usr/bin/env python3
# =====================================================================
#  leggi_setaccio_nuovi.py -- LETTORE CONGELATO: dei nuovi EA del Market quali richiedono il SET. Scritto il 24/10/2026 PRIMA dei numeri.
#  Criteri: report/MARKET_NUOVI_SET_CRITERI_2026-10-24.md
#  USO: python3 backtest_pipeline/leggi_setaccio_nuovi.py <cartella con SCREEN_<EA>/ (MANIFEST_SCREEN.csv + report/*.htm)> | --autotest
#  REGOLE per EA (passate H1 = TRANCHE1, M15 = TRANCHE2):
#   R1 NECESSARIO: 0 operazioni in entrambe e nessuna riga no money. R2 NECESSARIO: < 10 operazioni in entrambe e >= 100 righe no money.
#   R3 NECESSARIO: operato anche su un simbolo diverso da XAUUSD, o un input con 'symbol' nel nome nomina simboli diversi da XAUUSD.
#   R4 NECESSARIO: input licenza/password/token/api/url/e-mail/seriale/segreto/slug/login vuoto o segnaposto, o nome input che richiama polymarket|http. I filtri news NON sono R4 (solo una nota).
#   R5 CONSIGLIATO: 1-9 operazioni in entrambe, nessuna R1-R4. Altrimenti NON NECESSARIO (>= 10 operazioni, nessuna R1-R4).
# =====================================================================
import csv, glob, os, re, sys, tempfile
CRED = re.compile(r'licen[sc]e|passw|token|api|\burl\b|e-?mail|serial|activation.?(key|code)|secret|slug|username|login', re.I)
EXT = re.compile(r'polymarket|http', re.I)
SIMB = re.compile(r'^[A-Z][A-Z0-9._#]{3,11}$')
IDENT = re.compile(r'^[A-Za-z_][A-Za-z0-9_]*$')
SEGN = re.compile(r'^\s*$|^x+$|your|enter|^none$|^0+$', re.I)
RED = re.compile(r'martin|grid|multipl|recover|hedge|averag|basket|layer|pyramid|dca', re.I)
def leggi_htm(path):
    b = open(path, 'rb').read()
    t = b.decode('utf-16') if b[:2] in (b'\xff\xfe', b'\xfe\xff') else b.decode('utf-8', 'replace')
    flat = re.sub(r'<[^>]+>', '|', t); flat = re.sub(r'\s*\|[\s|]*', '|', flat)
    exp = re.search(r'\|Expert:\|([^|]*)\|', flat); sym = re.search(r'\|Simbolo:\|([^|]*)\|', flat)
    ing = re.search(r'\|Dati in ingresso:\|(.*?)\|(?:Broker:|Valuta:|Deposito|Leva:)', flat)
    inputs = {}
    if ing:
        for tok in ing.group(1).split('|'):
            if '=' in tok:
                k, v = tok.split('=', 1); inputs.setdefault(k.strip(), v.strip())
    ops = re.search(r'Operazioni di Trading Totali:\|(\d+)', flat)
    deals = re.findall(r'\d{4}\.\d\d\.\d\d \d\d:\d\d:\d\d\|\d+\|([A-Za-z0-9._#]+)\|(?:buy|sell)\|', flat)
    return dict(expert=exp.group(1) if exp else '?', simbolo=sym.group(1) if sym else '?', inputs=inputs, ops=int(ops.group(1)) if ops else 0, simboli_operati=sorted(set(deals)))
def un_ea(d):
    nome = os.path.basename(d.rstrip('/\\'))[7:]
    man = []
    mp = os.path.join(d, 'MANIFEST_SCREEN.csv')
    if os.path.exists(mp): man = list(csv.DictReader(open(mp, newline=''), delimiter=';'))
    rep = {}
    for tag in ('TRANCHE1', 'TRANCHE2'):
        fs = sorted(glob.glob(os.path.join(d, 'report', '*%s*.htm' % tag)))
        rep[tag] = leggi_htm(fs[0]) if fs else None
    nomoney = sum(int(float(m.get('no_money_log') or 0)) for m in man) if man else 0
    stato = {m['sonda']: m['stato'] for m in man} if man else {}
    return nome, rep, nomoney, stato
def valuta(rep, nomoney):
    ops = [rep[t]['ops'] if rep.get(t) else None for t in ('TRANCHE1', 'TRANCHE2')]
    if any(o is None for o in ops): return 'NON LEGGIBILE (manca un report H1 o M15)', ['report mancante'], []
    inp = {}
    for t in ('TRANCHE1', 'TRANCHE2'): inp.update({k: v for k, v in rep[t]['inputs'].items() if k not in inp})
    reg = []; note = []
    if max(ops) == 0 and nomoney == 0: reg.append('R1 non opera (0 operazioni in H1 e M15, nessun no money)')
    if max(ops) < 10 and nomoney >= 100: reg.append('R2 lotto troppo grande per 5.000 EUR (%d righe no money, %d/%d operazioni)' % (nomoney, ops[0], ops[1]))
    altri = set()
    for t in ('TRANCHE1', 'TRANCHE2'):
        altri |= {x for x in rep[t]['simboli_operati'] if x.upper() != 'XAUUSD'}
    for k, v in inp.items():
        if re.search('symbol', k, re.I):
            for x in re.split(r'[,; ]+', v):
                x = x.strip().upper()
                if SIMB.match(x) and x not in ('XAUUSD', 'TRUE', 'FALSE', 'NONE', 'AUTO', 'ALL', 'CURRENT'): altri.add(x)
    if altri: reg.append('R3 strumento: simboli diversi da XAUUSD (%s)' % ', '.join(sorted(altri)[:8]))
    r4 = []
    for k, v in inp.items():
        if CRED.search(k) and not re.search(r'magic|comment|enable|use|show|allow|info|section|setting|^-', k, re.I) and SEGN.search(v): r4.append('%s=%r' % (k, v))
        elif IDENT.match(k) and EXT.search(k): r4.append('dipendenza esterna nel nome: %s' % k)
    note_news = sorted({k for k in inp if re.search('news|calendar', k, re.I)})[:3]
    if r4: reg.append('R4 credenziali o servizi esterni: ' + '; '.join(r4[:6]))
    if not reg and 1 <= max(ops) <= 9: reg.append('R5 opera poco (%d/%d operazioni)')
    if reg and reg[0].startswith('R5'): reg[0] = reg[0] % (ops[0], ops[1])
    if any(r[:2] in ('R1', 'R2', 'R3', 'R4') for r in reg): v = 'SET NECESSARIO'
    elif reg: v = 'SET CONSIGLIATO'
    else: v = 'SET NON NECESSARIO per lo screening (%d/%d operazioni)' % (ops[0], ops[1])
    s5 = sorted({k for k in inp if RED.search(k) and not k.startswith('-') and not k.startswith('#')})
    if note_news: s5 = s5 + ['(nota: filtro news/calendario negli input, non simulabile nel tester: %s)' % ', '.join(note_news)]
    return v, reg, s5
def giudica(cart):
    out = []
    for d in sorted(glob.glob(os.path.join(cart, 'SCREEN_*'))):
        if not os.path.isdir(d): continue
        nome, rep, nm, stato = un_ea(d); v, reg, s5 = valuta(rep, nm)
        out.append((nome, v, reg, s5, stato, nm))
    return out
def autotest():
    d = tempfile.mkdtemp()
    def mk(nome, ops1, ops2, inputs, syms=('XAUUSD',), nomoney=0):
        p = os.path.join(d, 'SCREEN_' + nome); os.makedirs(os.path.join(p, 'report'), exist_ok=True)
        with open(os.path.join(p, 'MANIFEST_SCREEN.csv'), 'w', newline='') as f:
            w = csv.writer(f, delimiter=';'); w.writerow(['sonda', 'stato', 'no_money_log']); w.writerow(['TRANCHE1', 'OK', nomoney]); w.writerow(['TRANCHE2', 'OK', 0])
        for tag, ops in (('TRANCHE1', ops1), ('TRANCHE2', ops2)):
            righe = ''.join('<tr><td>2026.01.0%d 10:00:00</td><td>%d</td><td>%s</td><td>buy</td><td>in</td></tr>' % (i + 1, i + 1, syms[i % len(syms)]) for i in range(min(ops, 9)))
            h = '<html><body><table><tr><td>Expert:</td><td>%s</td></tr><tr><td>Simbolo:</td><td>XAUUSD</td></tr><tr><td>Dati in ingresso:</td><td>%s</td></tr><tr><td>Broker:</td><td>x</td></tr><tr><td>Operazioni di Trading Totali:</td><td>%d</td></tr>%s</table></body></html>' % (nome, '</td></tr><tr><td>'.join('%s=%s' % kv for kv in inputs.items()), ops, righe)
            open(os.path.join(p, 'report', 'x_%s_a.htm' % tag), 'wb').write(h.encode('utf-16'))
    mk('Bravo', 50, 60, {'Lots': '0.01', 'Risk': '1'})
    mk('Zero', 0, 0, {'Lots': '0.01'})
    mk('Pesante', 0, 2, {'Lots': '5.0'}, nomoney=1000)
    mk('Multi', 40, 40, {'Symbols': 'AUDNZD,EURUSD'}, syms=('AUDNZD', 'XAUUSD'))
    mk('Licenza', 30, 30, {'LicenseKey': ''})
    mk('Poco', 3, 4, {'Lots': '0.01'})
    mk('Griglia', 30, 30, {'GridMultiplier': '1.6'})
    r = {x[0]: x for x in giudica(d)}
    assert r['Bravo'][1].startswith('SET NON NECESSARIO'), r['Bravo']
    assert r['Zero'][1] == 'SET NECESSARIO' and r['Zero'][2][0].startswith('R1'), r['Zero']
    assert r['Pesante'][1] == 'SET NECESSARIO' and r['Pesante'][2][0].startswith('R2'), r['Pesante']
    assert r['Multi'][1] == 'SET NECESSARIO' and any(x.startswith('R3') for x in r['Multi'][2]), r['Multi']
    assert r['Licenza'][1] == 'SET NECESSARIO' and any(x.startswith('R4') for x in r['Licenza'][2]), r['Licenza']
    assert r['Poco'][1] == 'SET CONSIGLIATO' and r['Poco'][2][0].startswith('R5'), r['Poco']
    assert r['Griglia'][1].startswith('SET NON NECESSARIO') and r['Griglia'][3] == ['GridMultiplier'], r['Griglia']
    print('AUTOTEST setaccio nuovi: 7 casi OK (opera, zero, no money, strumento, licenza, poco, griglia descrittivo)')
if __name__ == '__main__':
    if len(sys.argv) > 1 and sys.argv[1] == '--autotest': autotest(); sys.exit(0)
    if len(sys.argv) != 2: print(__doc__); sys.exit(2)
    for nome, v, reg, s5, stato, nm in giudica(sys.argv[1]):
        print('%-42s %s' % (nome, v))
        for r in reg: print('      ' + r)
        if s5: print('      S5 (descrittivo, input che richiamano recupero/griglia): ' + ', '.join(s5))
