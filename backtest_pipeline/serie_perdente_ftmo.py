#!/usr/bin/env python3
# -*- coding: utf-8 -*-
"""
serie_perdente_ftmo.py -- 25/09/2026

QUANTO E' RARA LA SERIE D'APERTURA DELLA CHALLENGE FTMO 541452707?
Referto: report/QUANTO_E_RARA_LA_SERIE_2026-09-25.md
Zero tempo macchina: solo dati gia' in repo.

L'EVENTO (screenshot di Claudio + report/TERZO_STOP_FTMO_2026-09-25.md par.4), rischio 2,00%:
  22/09  771531 EMA200 Dow short, 2 ingressi a stop      -1.757,68
  23/09  nessuna operazione                                   0,00
  24/09  770411 MaxMin DAX short -1.668,46 ; 770101 +69,66  -1.598,80
  25/09  770101 DAX long                                  -1.552,80
  netto -4.909,28 = -6,1366% del 80.000 (arrotondato 6,14%)

STATISTICHE DICHIARATE PRIMA DEL CALCOLO (non si cambiano dopo aver visto i numeri):
  (a) finestre di K giornate CONSECUTIVE, K = 3 e 4, con somma del P/L @2,00% <= SOGLIA,
      SOGLIA = -4.909,28 / 80.000 = -6,1366% (il valore ESATTO dell'evento: con -6,14 tondo
      l'evento stesso NON si conterebbe, vedi autotest).
      due definizioni di "giornata":
        a1  GIORNATE CON OPERAZIONI (l'evento = 3 giornate: 22, 24, 25/09)
        a2  GIORNATE DI BORSA DI CALENDARIO (feriali, zero se nessuna operazione;
            l'evento = 4 giornate: 22, 23, 24, 25/09)
  (b) 3 giornate-con-operazioni consecutive TUTTE in perdita netta.
  e inoltre: serie negativa piu' lunga (giornate con operazioni) e peggior somma su 4 giornate.
  Conteggio: finestre che si sovrappongono formano UN episodio. Frequenza = episodi.
  "una volta ogni N giornate di borsa" = feriali della finestra / episodi  [DERIVATO]
  "attesi per anno" = episodi / (arco in giorni / 365,25)                   [DERIVATO]

IL POOL (lo stesso del Monte Carlo di casa, mc_challenge_ftmo_stato.dati()):
  4 sedie per-trade (770101, 770202, 770411, 771531), a deposito 100.000 e rischio 1,00%;
  net_profit sommato per DATA DI CHIUSURA, diviso 100.000 -> frazione @1,00%; x2 -> @2,00%.

CONTRO-ESEMPIO (la domanda "un pool di giornate indipendenti sottostima l'ammucchiarsi?"):
  sulla sequenza VERA delle date (struttura a blocchi) contro due rimescolamenti:
    R-giorno  : permuta le giornate intere (tiene la correlazione fra sedie NELLA giornata,
                distrugge quella fra giornate vicine) = l'ipotesi del MC di casa
    R-sedia   : permuta ogni sedia per conto suo (distrugge anche la correlazione fra sedie
                nello stesso giorno)
  p = frazione dei rimescolamenti con episodi >= di quelli veri.

LATO FORWARD (demo BCM, data/statements/trades_auto.csv = piccolo 50503392 al 1,00%;
trades_100k.csv = 100k 50504263 allo 0,65%): stesse magic delle sedie FTMO (770101, 770202,
770411, 771531; i preset FTMO cambiano solo ora, nome simbolo, rischio e magic:
report/CONTRATTI_DELLE_SEDIE_FTMO_2026-09-20.md par.2). Unita': R = uno stop pieno della
sedia su QUEL conto, stimato come mediana degli stop pieni osservati (sul piccolo il DAX
perde ~2,3% del saldo a stop: la % del saldo lo peserebbe il doppio). L'evento FTMO in R:
-4.909,28 / 1.600 = -3,068 R, identico a -6,1366% @2,00%.

USO:
  python3 backtest_pipeline/serie_perdente_ftmo.py
  python3 backtest_pipeline/serie_perdente_ftmo.py --autotest
"""
import collections, csv, datetime as dt, os, random, statistics, sys

QUI = os.path.dirname(os.path.abspath(__file__))
sys.path.insert(0, QUI)
import mc_challenge_ftmo_stato as st              # noqa: E402  (importa m e al)
m, al = st.m, st.al

BANCO = 80000.0
RISCHIO = 2.0                                       # taglia FTMO in campo
EVENTO_EUR = collections.OrderedDict([('2026.09.22', -1757.68), ('2026.09.23', 0.0),
                                      ('2026.09.24', -1668.46 + 69.66), ('2026.09.25', -1552.80)])
EVENTO_ATTIVO = {'2026.09.22': True, '2026.09.23': False, '2026.09.24': True, '2026.09.25': True}
SOGLIA = sum(EVENTO_EUR.values()) / BANCO          # -0,0613660 @2,00%
EPS = 1e-12
NPERM, SEME = 10000, 25
ANCORE = {  # saldo di fine 19/08 (report/PAGELLA_2026-08-19.md par.1) e rischio per sedia
    'piccolo 50503392': ('trades_auto.csv', 5076.62, 1.00, ['770101', '770202', '770411', '771531']),
    '100k 50504263':    ('trades_100k.csv', 99380.25, 0.65, ['770101', '770202', '770411']),
}


# ---------------------------------------------------------------- statistiche
def finestre(v, K, soglia):
    return [i for i in range(len(v) - K + 1) if sum(v[i:i + K]) <= soglia + EPS]


def tutte_neg(v, K):
    return [i for i in range(len(v) - K + 1) if all(x < 0 for x in v[i:i + K])]


def episodi(inizi, K):
    """Finestre che si sovrappongono = un episodio. Ritorna [(primo, ultimo_giorno_incluso)]."""
    out = []
    for i in inizi:
        if out and i <= out[-1][1]:
            out[-1] = (out[-1][0], i + K - 1)
        else:
            out.append((i, i + K - 1))
    return out


def serie_max(v):
    best = (0, None); cur = 0
    for i, x in enumerate(v):
        cur = cur + 1 if x < 0 else 0
        if cur > best[0]:
            best = (cur, i - cur + 1)
    return best


def peggiore(v, K):
    s = [(sum(v[i:i + K]), i) for i in range(len(v) - K + 1)]
    return min(s) if s else (0.0, None)


def dd_max(v):
    eq = pk = dd = 0.0
    for x in v:
        eq += x; pk = max(pk, eq); dd = min(dd, eq - pk)
    return dd


def conta(att, cal, soglia=SOGLIA, f=RISCHIO):
    """Le statistiche dichiarate su una coppia (giornate con operazioni, calendario), gia' in unita' 1%."""
    a = [x * f for x in att]; c = [x * f for x in cal]
    return {'a1_K3': len(episodi(finestre(a, 3, soglia), 3)), 'a1_K4': len(episodi(finestre(a, 4, soglia), 4)),
            'a2_K3': len(episodi(finestre(c, 3, soglia), 3)), 'a2_K4': len(episodi(finestre(c, 4, soglia), 4)),
            'b_3neg': len(episodi(tutte_neg(a, 3), 3)), 'serie': serie_max(a)[0]}


# ---------------------------------------------------------------- dati
def griglia():
    """Calendario = feriali della finestra + giornate con operazioni nel weekend (come st.pool_feriali),
       con le DATE. Ritorna date, valore pool @1%, flag attivo, e per sedia (valore, flag)."""
    per, giorni, base, _, _ = st.dati()
    D = [al.data(g) for g in giorni]
    key = dict(zip(D, giorni))
    fer = [D[0] + dt.timedelta(k) for k in range((D[-1] - D[0]).days + 1)]
    tutti = sorted(set(d for d in fer if d.weekday() < 5) | set(D))
    val = dict(zip(D, base))
    cal = [val.get(d, 0.0) for d in tutti]
    att = [d in val for d in tutti]
    sedie = {}
    for n in per:
        sedie[n] = [((per[n][key[d]] / m.DEPOSITO_MISURA) if (d in key and key[d] in per[n]) else 0.0,
                     d in key and key[d] in per[n]) for d in tutti]
    return per, giorni, base, tutti, cal, att, sedie


def dai_sedie(sedie):
    n = len(next(iter(sedie.values())))
    cal = [sum(sedie[s][i][0] for s in sedie) for i in range(n)]
    att = [any(sedie[s][i][1] for s in sedie) for i in range(n)]
    return cal, att


def rimescola(cal, att, sedie, modo, nperm=NPERM, seme=SEME):
    rnd = random.Random(seme)
    out = []
    for _ in range(nperm):
        if modo == 'giorno':
            idx = list(range(len(cal))); rnd.shuffle(idx)
            c2 = [cal[i] for i in idx]; a2 = [att[i] for i in idx]
        else:
            s2 = {}
            for s, v in sedie.items():
                v2 = v[:]; rnd.shuffle(v2); s2[s] = v2
            c2, a2 = dai_sedie(s2)
        out.append(conta([x for x, f in zip(c2, a2) if f], c2))
    return out


def pool_saldo(giorni, composto=True):
    """SENSIBILITA': ogni operazione divisa per il saldo CORRENTE della sua sedia nel backtest
       (100.000 + P/L chiusi prima), invece che per il deposito fisso. composto=False -> il pool di casa."""
    d = collections.defaultdict(float)
    for nome, rel in m.SORGENTI.items():
        with open(os.path.join(QUI, rel), newline='') as fh:
            righe = sorted((r['close_time'], float(r['net_profit'])) for r in csv.DictReader(fh, delimiter=';'))
        bal = m.DEPOSITO_MISURA
        for t, x in righe:
            d[t[:10]] += x / (bal if composto else m.DEPOSITO_MISURA)
            bal += x
    return [d[g] for g in giorni]


# ---------------------------------------------------------------- forward
def carica_forward(nome):
    fil, saldo, rischio, magic = ANCORE[nome]
    p = os.path.join(QUI, '..', 'data', 'statements', fil)
    tr = []
    with open(p, newline='') as fh:
        for r in csv.DictReader(fh, delimiter=';'):
            if r['magic'] in magic:
                net = float(r['profit']) + float(r['commission']) + float(r['swap'])
                tr.append((r['close_time'], r['magic'], net, r['close_reason'], r['strategy']))
    return tr, saldo, rischio, magic


def stima_R(tr, saldo, rischio, magic):
    """R per sedia = mediana degli stop pieni: perdite chiuse a 'sl', le gambe dello stesso giorno e
       dello stesso lato (EMA200 L1/L2, S1/S2) sommate; pieno = |perdita| >= meta' del R nominale.
       Nessuno stop pieno osservato -> R nominale = rischio x saldo di ancora [DERIVATO]."""
    nom = rischio / 100.0 * saldo
    R = {}
    for mg in magic:
        g = collections.defaultdict(float)
        for t, mm, net, why, com in tr:
            if mm == mg and why == 'sl' and net < 0:
                k = (t[:10], com.rstrip('0123456789 ') if com[-1:].isdigit() else com + '|' + t)
                g[k] += net
        piene = [-x for x in g.values() if -x >= 0.5 * nom]
        R[mg] = (statistics.median(piene), len(piene), 'mediana stop pieni') if piene else (nom, 0, 'NOMINALE')
    return R


def giorni_R(tr, R):
    d = collections.OrderedDict()
    for t, mm, net, _, _ in sorted(tr):
        d.setdefault(t[:10], [0.0, 0.0, []])
        d[t[:10]][0] += net / R[mm][0]; d[t[:10]][1] += net
        d[t[:10]][2].append('%s:%+.0f' % (mm, net))
    return d


# ---------------------------------------------------------------- autotest
def autotest():
    ok = True

    def chk(nome, cond, det=''):
        nonlocal ok
        print("  [%s] %s %s" % ('PASS' if cond else 'FAIL', nome, det)); ok = ok and cond

    print("AUTOTEST serie_perdente_ftmo.py")
    # 1. l'evento: aritmetica e riconoscimento, nelle due definizioni
    ev_c = [x / BANCO / RISCHIO for x in EVENTO_EUR.values()]           # unita' 1% (x2 -> frazione)
    ev_a = [x for x, k in zip(ev_c, EVENTO_EUR) if EVENTO_ATTIVO[k]]
    chk("netto evento -4.909,28 = -6,1366%", abs(SOGLIA * BANCO + 4909.28) < 0.005 and abs(100 * SOGLIA + 6.1366) < 5e-5,
        "(%.4f%%)" % (100 * SOGLIA))
    c = conta(ev_a, ev_c)
    chk("evento: a1 K3 = 1, a2 K4 = 1, a2 K3 = 0, b = 1, serie = 3",
        (c['a1_K3'], c['a2_K4'], c['a2_K3'], c['b_3neg'], c['serie']) == (1, 1, 0, 1, 3), str(c))
    # CONTRO-ESEMPIO della soglia: col 6,14 tondo l'evento stesso non si conta
    c2 = conta(ev_a, ev_c, soglia=-0.0614)
    chk("CONTRO-ESEMPIO soglia tonda -6,14%: l'evento NON si conta (per questo si usa -6,1366)",
        c2['a1_K3'] == 0 and c2['a2_K4'] == 0, str(c2))
    chk("evento in R: -4.909,28 / 1.600 = -3,068 R = SOGLIA/2%",
        abs(sum(EVENTO_EUR.values()) / (0.02 * BANCO) - SOGLIA / 0.02) < 1e-12, "(%.4f R)" % (SOGLIA / 0.02))
    # 2. contatori su una serie sintetica
    v = [-1, -1, -1, 5, -1, -1, -1, -1]
    chk("finestre K3<=-3: inizi [0,4,5], episodi 2, serie max 4 da idx 4",
        finestre(v, 3, -3) == [0, 4, 5] and len(episodi([0, 4, 5], 3)) == 2 and serie_max(v) == (4, 4))
    chk("episodi: finestre contigue NON sovrapposte restano due", episodi([0, 3], 3) == [(0, 2), (3, 5)])
    chk("peggiore K4 e DD", peggiore(v, 4) == (-4, 4) and dd_max([1, -2, -3, 4, -1]) == -5)
    # 3. il pool e' QUELLO del MC di casa
    per, giorni, base, tutti, cal, att, sedie = griglia()
    fer_pool, fer_att = st.pool_feriali(giorni, base)
    chk("calendario == st.pool_feriali (valori e flag)", cal == fer_pool and att == fer_att,
        "(%d voci, %d attive)" % (len(cal), sum(att)))
    chk("giornate attive == pool MC (242, stesso ordine)", [x for x, f in zip(cal, att) if f] == base and len(base) == 242)
    ps = pool_saldo(giorni, composto=False)
    chk("pool_saldo senza composizione == pool di casa", all(abs(x - y) < 1e-15 for x, y in zip(ps, base)))
    c_s, a_s = dai_sedie(sedie)
    chk("somma per sedia == pool", all(abs(x - y) < 1e-12 for x, y in zip(c_s, cal)) and a_s == att)
    # 4. CONTRO-ESEMPIO del rimescolamento: il metodo vede l'ammucchiarsi quando c'e', e il suo contrario
    a = [0.004] * 100; a[40:52] = [-0.012] * 12                  # perdite tutte attaccate
    real = conta(a, a)['b_3neg']
    perm = rimescola(a, [True] * len(a), {'x': [(x, True) for x in a]}, 'giorno', nperm=2000)
    mu = statistics.mean(p['b_3neg'] for p in perm)
    chk("serie AMMUCCHIATA: episodi veri > media rimescolata", real == 1 and mu < 1 and
        sum(p['b_3neg'] >= real for p in perm) / 2000.0 < 0.5, "(vero %d, rimescolato %.3f)" % (real, mu))
    alt = [-0.01, 0.011] * 50
    real = conta(alt, alt)['b_3neg']
    perm = rimescola(alt, [True] * len(alt), {'x': [(x, True) for x in alt]}, 'giorno', nperm=2000)
    mu = statistics.mean(p['b_3neg'] for p in perm)
    chk("serie ALTERNATA: episodi veri (0) < media rimescolata", real == 0 and mu > 1, "(rimescolato %.2f)" % mu)
    # 5. CONTRO-ESEMPIO del rimescolamento per sedia: due sedie identiche (correlazione 1 nello stesso giorno)
    s = [(-0.02 if i % 7 == 0 else 0.003, True) for i in range(140)]
    sed = {'A': s, 'B': s[:]}
    cc, aa = dai_sedie(sed)
    real = sum(1 for x in cc if x <= -0.04 + EPS)
    rr = random.Random(9); tot = 0
    for _ in range(500):
        s2 = {k: rr.sample(v, len(v)) for k, v in sed.items()}
        tot += sum(1 for x in dai_sedie(s2)[0] if x <= -0.04 + EPS)
    chk("sedie IDENTICHE: giornate doppie vere (20) > rimescolate per sedia (~2,9)", real == 20 and tot / 500.0 < 5,
        "(%d contro %.2f)" % (real, tot / 500.0))
    # 6. forward: il 100k riproduce la pagella del 19/08 (-117,37) e R stimato su gambe sintetiche
    p = os.path.join(QUI, '..', 'data', 'statements', 'trades_100k.csv')
    with open(p, newline='') as fh:
        s19 = sum(float(r['profit']) + float(r['commission']) + float(r['swap'])
                  for r in csv.DictReader(fh, delimiter=';') if r['close_time'].startswith('2026.08.19'))
    chk("100k: realizzato 19/08 = -117,37 (PAGELLA_2026-08-19)", abs(s19 + 117.37) < 0.005, "(%.2f)" % s19)
    tr = [('2026.01.01 10:00', 'E', -18.0, 'sl', 'EMA S1'), ('2026.01.01 10:00', 'E', -18.0, 'sl', 'EMA S2'),
          ('2026.01.02 10:00', 'E', -12.0, 'sl', 'EMA L1'), ('2026.01.03 10:00', 'E', -0.4, 'sl', 'EMA L1'),
          ('2026.01.01 09:00', 'D', -110.0, 'sl', 'DAX BUY'), ('2026.01.01 11:00', 'D', -120.0, 'sl', 'DAX BUY'),
          ('2026.01.02 09:00', 'D', -80.0, 'expert', 'DAX SELL')]
    R = stima_R(tr, 5000.0, 1.0, ['E', 'D', 'Z'])
    chk("R: gambe EMA stesso giorno sommate (36), singola e pareggio esclusi; DAX 2 stop separati (115); Z nominale",
        R['E'][:2] == (36.0, 1) and R['D'][:2] == (115.0, 2) and R['Z'][2] == 'NOMINALE', str(R))
    print("AUTOTEST: %s" % ("TUTTO VERDE" if ok else "ROSSO"))
    return ok


# ---------------------------------------------------------------- main
def pct(x):
    return "%+.2f%%" % (100 * x)


def main():
    per, giorni, base, tutti, cal, att, sedie = griglia()
    datt = [d for d, f in zip(tutti, att) if f]
    fer = sum(1 for d in tutti if d.weekday() < 5)
    arco = (tutti[-1] - tutti[0]).days + 1
    anni = arco / 365.25
    a2 = [x * RISCHIO for x in base]; c2 = [x * RISCHIO for x in cal]
    print("=" * 100)
    print("QUANTO E' RARA LA SERIE FTMO -- pool MC di casa, 4 sedie, @%.2f%%, soglia %s" % (RISCHIO, pct(SOGLIA)))
    print("finestra %s -> %s | %d giorni di calendario = %.3f anni | %d feriali | %d giornate con operazioni"
          % (tutti[0], tutti[-1], arco, anni, fer, len(base)))
    print("giornate in perdita netta: %d su %d (%.1f%%)" % (sum(1 for x in base if x < 0), len(base),
                                                          100.0 * sum(1 for x in base if x < 0) / len(base)))
    print("=" * 100)

    def mostra(nome, v, dd, K, inizi, sed_giorni=True):
        ep = episodi(inizi, K)
        print("\n[%s] finestre %d su %d (%.1f%%) -> episodi %d" % (nome, len(inizi), len(v) - K + 1,
              100.0 * len(inizi) / (len(v) - K + 1), len(ep)))
        for a, b in ep:
            gg = dd[a:b + 1]
            pf = min(sum(v[i:i + K]) for i in range(a, b - K + 2))
            print("   %s -> %s  peggior finestra %s  giornate %s" % (gg[0], gg[-1], pct(pf),
                  ' '.join("%s:%s" % (g.strftime('%d/%m'), pct(x)) for g, x in zip(gg, v[a:b + 1]))))
            if sed_giorni:
                for g in gg:
                    k = g.strftime('%Y.%m.%d')
                    if k in per[next(iter(per))] or any(k in per[n] for n in per):
                        print("        %s %s" % (g, {n: round(per[n][k] * RISCHIO / m.DEPOSITO_MISURA * 100, 2)
                                                    for n in per if k in per[n]}))
        return ep

    res = {}
    res['a1_K3'] = mostra("a1 K=3 giornate con operazioni, somma <= soglia", a2, datt, 3, finestre(a2, 3, SOGLIA))
    res['a1_K4'] = mostra("a1 K=4 giornate con operazioni, somma <= soglia", a2, datt, 4, finestre(a2, 4, SOGLIA))
    res['a2_K3'] = mostra("a2 K=3 feriali di calendario, somma <= soglia", c2, tutti, 3, finestre(c2, 3, SOGLIA), False)
    res['a2_K4'] = mostra("a2 K=4 feriali di calendario, somma <= soglia", c2, tutti, 4, finestre(c2, 4, SOGLIA), False)
    res['b_3neg'] = mostra("b  3 giornate con operazioni TUTTE negative", a2, datt, 3, tutte_neg(a2, 3), False)

    print("\n[FREQUENZE]  una volta ogni N feriali  |  attesi per anno  |  quanti in inverno sfasato")
    for k, ep in res.items():
        dd = datt if k[:2] in ('a1', 'b_') else tutti
        inv = sum(1 for a, b in ep if not al.tutto_allineato(dd[a]))
        n = len(ep)
        print("   %-7s episodi %2d | ogni %s feriali | %.2f / anno | in mesi non tutto-allineati: %d"
              % (k, n, ("%.0f" % (fer / n)) if n else "mai (>%d)" % fer, n / anni, inv))
    s, i = serie_max(a2)
    print("\n[SERIE NEGATIVA PIU' LUNGA] %d giornate con operazioni, da %s a %s, somma %s"
          % (s, datt[i], datt[i + s - 1], pct(sum(a2[i:i + s]))))
    runs = collections.Counter()
    cur = 0
    for x in a2 + [1]:
        if x < 0: cur += 1
        else:
            if cur: runs[cur] += 1
            cur = 0
    print("   distribuzione delle serie negative: %s" % dict(sorted(runs.items())))
    for K in (3, 4):
        v, j = peggiore(a2, K); w, h = peggiore(c2, K)
        print("[PEGGIORE SOMMA su %d] con operazioni: %s (%s -> %s) | calendario: %s (%s -> %s)"
              % (K, pct(v), datt[j], datt[j + K - 1], pct(w), tutti[h], tutti[h + K - 1]))
    print("[DD MASSIMO della serie @2%% (somma, contesto)] %s" % pct(dd_max(a2)))
    print("[STOP DA ~1R] giornate con perdita <= -1,5%% @2%%: %d" % sum(1 for x in a2 if x <= -0.015))

    ps = pool_saldo(giorni)
    vs = dict(zip(datt, ps))
    print("[SENSIBILITA' saldo corrente per sedia] %s | peggiore K3 %s K4 %s | stop medio <=-1,5%%: %s"
          % (conta(ps, [vs.get(d, 0.0) for d in tutti]), pct(peggiore([x * RISCHIO for x in ps], 3)[0]),
             pct(peggiore([x * RISCHIO for x in ps], 4)[0]),
             pct(statistics.mean(x * RISCHIO for x in ps if x * RISCHIO <= -0.015))))
    print("   (pool di casa, stessa riga: stop medio %s)" % pct(statistics.mean(x for x in a2 if x <= -0.015)))
    sl = [x * st.SLIP_MISURATO if x < 0 else x for x in base]
    vsl = dict(zip(datt, sl))
    print("[SENSIBILITA' slittamento x%.4f sulle perdite (3 stop veri FTMO)] %s"
          % (st.SLIP_MISURATO, conta(sl, [vsl.get(d, 0.0) for d in tutti])))

    vero = conta(base, cal)
    print("\n[CONTRO-ESEMPIO] vero contro rimescolato (%d permutazioni, seme %d)" % (NPERM, SEME))
    print("   vero: %s" % vero)
    for modo in ('giorno', 'sedia'):
        pp = rimescola(cal, att, sedie, modo)
        riga = []
        for k in ('a1_K3', 'a1_K4', 'a2_K3', 'a2_K4', 'b_3neg', 'serie'):
            mu = statistics.mean(p[k] for p in pp)
            pv = sum(1 for p in pp if p[k] >= vero[k]) / float(len(pp))
            riga.append("%s media %.2f p(>=vero) %.3f" % (k, mu, pv))
        print("   R-%-6s %s" % (modo, " | ".join(riga)))
    # autocorrelazione lag-1 delle giornate con operazioni (contesto)
    mu = statistics.mean(a2)
    num = sum((a2[i] - mu) * (a2[i + 1] - mu) for i in range(len(a2) - 1))
    den = sum((x - mu) ** 2 for x in a2)
    print("   autocorrelazione lag-1 giornate con operazioni: %+.3f (+-2/sqrt(n) = %.3f)" % (num / den, 2 / len(a2) ** 0.5))
    # correlazione fra sedie nello stesso giorno (giornate in cui operano entrambe)
    nomi = list(per)
    for x in range(len(nomi)):
        for y in range(x + 1, len(nomi)):
            com = sorted(set(per[nomi[x]]) & set(per[nomi[y]]))
            if len(com) >= 10:
                a = [per[nomi[x]][g] for g in com]; b = [per[nomi[y]][g] for g in com]
                ma, mb = statistics.mean(a), statistics.mean(b)
                cv = sum((p - ma) * (q - mb) for p, q in zip(a, b))
                r = cv / ((sum((p - ma) ** 2 for p in a) * sum((q - mb) ** 2 for q in b)) ** 0.5)
                neg = sum(1 for p, q in zip(a, b) if p < 0 and q < 0)
                print("   stesso giorno %-14s x %-14s n=%3d  r=%+.3f  tutte e due in perdita %d" % (nomi[x], nomi[y], len(com), r, neg))
            else:
                print("   stesso giorno %-14s x %-14s n=%3d  (troppo poche)" % (nomi[x], nomi[y], len(com)))

    print("\n" + "=" * 100)
    print("FORWARD BCM -- unita' R (uno stop pieno della sedia su quel conto); soglia %.3f R" % (SOGLIA / 0.02))
    for nome in ANCORE:
        tr, saldo, rischio, magic = carica_forward(nome)
        R = stima_R(tr, saldo, rischio, magic)
        d = giorni_R(tr, R)
        print("\n[%s] %d operazioni, %s -> %s | R: %s" % (nome, len(tr), min(t[0] for t in tr)[:10], max(t[0] for t in tr)[:10],
              {k: "%.2f (%s, n=%d)" % (v[0], v[2], v[1]) for k, v in R.items()}))
        dd = list(d); v = [d[k][0] for k in dd]
        for k in dd:
            print("   %s %+6.2f R %+9.2f EUR  %s" % (k, d[k][0], d[k][1], ' '.join(d[k][2])))
        for K in (3, 4):
            ep = episodi(finestre(v, K, SOGLIA / 0.02), K)
            print("   a1 K=%d somma <= %.3f R: %d episodi %s" % (K, SOGLIA / 0.02, len(ep), [(dd[a], dd[b]) for a, b in ep]))
        ep = episodi(tutte_neg(v, 3), 3)
        s, i = serie_max(v)
        print("   b 3 negative di fila: %d episodi %s | serie max %d (%s) | peggiore K4 %.2f R | peggiore K3 %.2f R"
              % (len(ep), [(dd[a], dd[b]) for a, b in ep], s, dd[i] if i is not None else '-',
                 peggiore(v, 4)[0], peggiore(v, 3)[0]))
    print("=" * 100)


if __name__ == '__main__':
    if '--autotest' in sys.argv:
        sys.exit(0 if autotest() else 1)
    main()
