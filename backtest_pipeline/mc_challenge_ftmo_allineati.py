#!/usr/bin/env python3
# -*- coding: utf-8 -*-
"""
mc_challenge_ftmo_allineati.py -- 24/09/2026

DOMANDA: quanto vale la probabilita' di passare la challenge FTMO se le tre
sedie a ORARIO (770101 DAX, 770202 Dow, 770411 MaxMin DAX) si leggono SOLO
nei mesi in cui il backtest armava all'apertura cash, come fanno oggi le
sedie FTMO? (report/OROLOGIO_BCM_2026-09-24.md par.5.1)

NON modifica mc_challenge_ftmo.py: lo IMPORTA e ne usa carica(), serie(),
simula(). La variante "a donatore" usa simula_mix(), copia riga per riga di
simula() con un solo aggancio: il valore della giornata. Con l'aggancio
nullo riproduce simula() AL DECIMALE (stessa sequenza del generatore):
e' verificato in testa all'uscita, prima di ogni variante.

CALENDARIO (data di CHIUSURA del trade, ora server BCM UTC+1 fisso):
  DAX sfasato : 2025-10-26 <= d < 2026-03-29  (ult. dom. ott -> ult. dom. mar)
  USA sfasato : 2025-11-02 <= d < 2026-03-08  (1a dom. nov -> 2a dom. mar)
  Nella finestra (2025.06.10 -> 2026.06.29) c'e' UN SOLO inverno.

VARIANTI (tutte: 2,00%, Guardian 4,5%/gg, saldo 76.573,86/80.000, seme 11,
20.000 simulazioni -- la configurazione del 74,6% di
report/SECONDO_STOP_FTMO_2026-09-24.md):
  V0  riferimento          : mc_challenge_ftmo cosi' com'e'.
  V1  orario->allineati    : stesse 242 giornate; nelle giornate in cui una
                             sedia a orario e' SFASATA, il suo contributo e'
                             sostituito da quello della stessa sedia in un
                             giorno feriale "tutto allineato" estratto a caso
                             (nuova estrazione a ogni uso). EMA200 intatta.
  V2  tutti estivi         : solo le giornate "tutto allineato", tutte le
                             sedie (EMA200 compresa). Pool fisso -> simula().
  V3  placebo EMA200 estiva: le sedie a orario INTATTE, EMA200 sostituita a
                             donatore nei giorni USA sfasati. Misura quanto
                             sposta la sola STAGIONE su una sedia che
                             dall'orologio non dipende.
  V4  tutti invernali      : solo le giornate "tutto sfasato" (specchio di V2).

USO:  python3 backtest_pipeline/mc_challenge_ftmo_allineati.py
"""
import collections, csv, datetime as dt, itertools, os, random, statistics, sys

QUI = os.path.dirname(os.path.abspath(__file__))
sys.path.insert(0, QUI)
import mc_challenge_ftmo as m                      # noqa: E402

SALDO = 76573.86                  # report/SECONDO_STOP_FTMO_2026-09-24.md
m.SALDO_VERO_2209 = SALDO
S0 = SALDO / m.BANCO_FTMO         # 0,957173...
FATT, GUARD, SEME, NSIM = 2.0, 0.045, 11, 20000

DAX_SF = (dt.date(2025, 10, 26), dt.date(2026, 3, 29))
USA_SF = (dt.date(2025, 11, 2), dt.date(2026, 3, 8))
MERCATO = {'770101 DAX': 'DAX', '770411 MaxMin': 'DAX',
           '770202 Dow': 'USA', '771531 EMA200': 'USA'}
A_ORARIO = ['770101 DAX', '770202 Dow', '770411 MaxMin']


def data(s):
    return dt.date(*map(int, s[:10].split('.')))


def sfasato(d, merc):
    a, b = DAX_SF if merc == 'DAX' else USA_SF
    return a <= d < b


def tutto_allineato(d):
    return not sfasato(d, 'DAX') and not sfasato(d, 'USA')


def tutto_sfasato(d):
    return sfasato(d, 'DAX') and sfasato(d, 'USA')


# ---------------------------------------------------------------- per-trade
def trade():
    out = {}
    for nome, rel in m.SORGENTI.items():
        with open(os.path.join(QUI, rel), newline='') as fh:
            out[nome] = [(r['close_time'][:10], float(r['net_profit']))
                         for r in csv.DictReader(fh, delimiter=';')]
    return out


def pf(xs):
    g = sum(x for x in xs if x > 0); p = -sum(x for x in xs if x < 0)
    return g / p if p else float('inf')


# ---------------------------------------------------------------- simulatore
def simula_mix(giorni, fisso, sost, donatori, fattore, saldo_iniziale=1.0,
               guardian=None, slip=1.0, n_sim=NSIM, seme=SEME, target=0.10,
               muro_stat=0.10, muro_gior=0.05, min_giorni=4, max_giorni=800):
    """Copia di m.simula(). Giornata i = fisso[i] + (se sost[i]) un donatore
       estratto a caso da donatori[sost[i]]. Con sost tutto None consuma il
       generatore ESATTAMENTE come m.simula()."""
    rnd = random.Random(seme)
    idx = list(range(len(giorni)))
    esiti = collections.Counter(); durate = []
    for _ in range(n_sim):
        s = idx[:]; rnd.shuffle(s)
        bal = saldo_iniziale; g = 0; esito = None; i = 0
        while esito is None:
            if i >= len(s):
                s2 = idx[:]; rnd.shuffle(s2); s = s + s2
            k = s[i]; i += 1
            v = fisso[k]
            if sost[k] is not None:
                pool = donatori[sost[k]]
                v = v + pool[rnd.randrange(len(pool))]
            r = v * fattore
            if r < 0:
                r *= slip
            b0 = bal
            perdita = -r * b0
            if guardian is not None and perdita > guardian:
                perdita = guardian
                r = -perdita / b0
            bal = b0 + r * b0
            g += 1
            if (b0 - bal) > muro_gior:   esito = 'MORTE_GIORNALIERA'; break
            if bal < 1.0 - muro_stat:    esito = 'MORTE_STATICA';     break
            if bal >= 1.0 + target and g >= min_giorni: esito = 'PASS'; break
            if g >= max_giorni:          esito = 'TIMEOUT';           break
        esiti[esito] += 1
        if esito == 'PASS':
            durate.append(g)
    tot = sum(esiti.values())
    return ({k: 100.0 * v / tot for k, v in esiti.items()},
            statistics.median(durate) if durate else None)


def riga(nome, o, med, extra=''):
    print("  %-34s PASS %5.1f%% | giorn %4.1f%% | statico %5.1f%% | timeout %4.1f%% | gg med %5s %s" % (
        nome, o.get('PASS', 0), o.get('MORTE_GIORNALIERA', 0),
        o.get('MORTE_STATICA', 0), o.get('TIMEOUT', 0), med, extra))


def main():
    per = m.carica()
    tr = trade()
    giorni, base = m.serie(per)
    D = [data(g) for g in giorni]
    N = len(giorni)
    nomi = list(per)

    # ---- 0. il simulatore copiato e' identico all'originale
    print("=" * 100)
    print("0. CONTRO-ESEMPIO DEL SIMULATORE: simula_mix con aggancio nullo contro m.simula")
    o_ref, med_ref = m.simula(base, FATT, S0, guardian=GUARD)
    o_nul, med_nul = simula_mix(giorni, base, [None] * N, {}, FATT, S0, guardian=GUARD)
    riga("m.simula (riferimento)", o_ref, med_ref)
    riga("simula_mix aggancio nullo", o_nul, med_nul)
    ok = (o_ref == o_nul and med_ref == med_nul)
    print("  identici: %s" % ok)
    if not ok:
        sys.exit("STOP: il simulatore copiato non riproduce l'originale")
    print("  riferimento 74,6%% riprodotto: %s (%.4f%%)" % (abs(o_ref['PASS'] - 74.6) < 0.05, o_ref['PASS']))

    # ---- 1. PF e n per sedia, allineato / sfasato
    print("\n1. PER-TRADE PER SEDIA (data di chiusura; EMA200 col calendario USA)")
    print("  %-15s %5s %5s | %8s %8s | %11s %11s" % ('sedia', 'n_al', 'n_sf', 'PF_al', 'PF_sf', 'netto_al', 'netto_sf'))
    for n in nomi:
        al = [p for d, p in tr[n] if not sfasato(data(d), MERCATO[n])]
        sf = [p for d, p in tr[n] if sfasato(data(d), MERCATO[n])]
        print("  %-15s %5d %5d | %8.2f %8.2f | %+11.2f %+11.2f" % (n, len(al), len(sf), pf(al), pf(sf), sum(al), sum(sf)))
        if n == '771531 EMA200':
            al2 = [p for d, p in tr[n] if not sfasato(data(d), 'DAX')]
            sf2 = [p for d, p in tr[n] if sfasato(data(d), 'DAX')]
            print("  %-15s %5d %5d | %8.2f %8.2f |   (stessa sedia, calendario DAX)" % ('  EMA200/DAX', len(al2), len(sf2), pf(al2), pf(sf2)))
        # controllo: le somme combaciano con m.carica
        assert abs(sum(p for _, p in tr[n]) - sum(per[n].values())) < 1e-6

    # ---- giorni feriali della finestra (per la frequenza e per i donatori)
    fer = [D[0] + dt.timedelta(k) for k in range((D[-1] - D[0]).days + 1)]
    fer = [d for d in fer if d.weekday() < 5]
    fer_al = [d for d in fer if tutto_allineato(d)]
    key = {d: g for d, g in zip(D, giorni)}

    def contr(d, sedie):
        g = key.get(d)
        return 0.0 if g is None else sum(per[n].get(g, 0.0) for n in sedie) / m.DEPOSITO_MISURA

    ntr = {n: collections.Counter(data(d) for d, _ in tr[n]) for n in nomi}

    # ---- 2. frequenza
    print("\n2. FREQUENZA (operazioni per giorno FERIALE, feriali = lun-ven della finestra, festivi compresi)")
    fer_sf = {mm: [d for d in fer if sfasato(d, mm)] for mm in ('DAX', 'USA')}
    fer_alm = {mm: [d for d in fer if not sfasato(d, mm)] for mm in ('DAX', 'USA')}
    for n in nomi:
        mm = MERCATO[n]
        a = sum(ntr[n][d] for d in fer_alm[mm]) / len(fer_alm[mm])
        b = sum(ntr[n][d] for d in fer_sf[mm]) / len(fer_sf[mm])
        print("  %-15s allineati %.3f op/gg (%d feriali)   sfasati %.3f op/gg (%d feriali)" % (n, a, len(fer_alm[mm]), b, len(fer_sf[mm])))

    # ---- 3. costruzione delle varianti
    # donatori: giorni FERIALI tutto-allineati (zero se la sedia non ha operato):
    # la frequenza del donatore e' quindi "per feriale", non "per giornata con trade".
    def donatori_da(giorni_don):
        return {'DAX': [contr(d, ['770101 DAX', '770411 MaxMin']) for d in giorni_don],
                'USA': [contr(d, ['770202 Dow']) for d in giorni_don],
                'ORARIO': [contr(d, A_ORARIO) for d in giorni_don],
                'EMA': [contr(d, ['771531 EMA200']) for d in giorni_don]}

    def costruisci_v1():
        fisso, sost = [], []
        for d, g in zip(D, giorni):
            sd, su = sfasato(d, 'DAX'), sfasato(d, 'USA')
            keep = ['771531 EMA200']
            if not sd: keep += ['770101 DAX', '770411 MaxMin']
            if not su: keep += ['770202 Dow']
            fisso.append(sum(per[n].get(g, 0.0) for n in keep) / m.DEPOSITO_MISURA)
            sost.append('ORARIO' if (sd and su) else 'DAX' if sd else 'USA' if su else None)
        return fisso, sost

    def costruisci_v3():
        fisso, sost = [], []
        for d, g in zip(D, giorni):
            su = sfasato(d, 'USA')
            keep = A_ORARIO + ([] if su else ['771531 EMA200'])
            fisso.append(sum(per[n].get(g, 0.0) for n in keep) / m.DEPOSITO_MISURA)
            sost.append('EMA' if su else None)
        return fisso, sost

    def freq_attesa(fisso_idx_sedie, sost, don_giorni):
        """op attese per giornata simulata"""
        tot = 0.0
        for (d, keep), k in zip(fisso_idx_sedie, sost):
            tot += sum(ntr[n][d] for n in keep)
            if k is not None:
                sed = {'DAX': ['770101 DAX', '770411 MaxMin'], 'USA': ['770202 Dow'],
                       'ORARIO': A_ORARIO, 'EMA': ['771531 EMA200']}[k]
                tot += sum(ntr[n][dd] for n in sed for dd in don_giorni) / len(don_giorni)
        return tot / len(sost)

    risultati = []
    print("\n3. MONTE CARLO -- 2,00%%, Guardian 4,5%%/gg, saldo %.5f, seme %d, %d simulazioni" % (S0, SEME, NSIM))
    tutte_op = sum(ntr[n][d] for n in nomi for d in D)
    riga("V0 riferimento", o_ref, med_ref, "| %d giornate, %.2f op/giornata" % (N, tutte_op / N))
    risultati.append(('V0', o_ref['PASS']))

    for etichetta, don_g in [("", fer_al), (" [donatori=solo giornate con trade]", [d for d in D if tutto_allineato(d)])]:
        DON = donatori_da(don_g)
        f1, s1 = costruisci_v1()
        o, med = simula_mix(giorni, f1, s1, DON, FATT, S0, guardian=GUARD)
        keep1 = []
        for d in D:
            k = ['771531 EMA200']
            if not sfasato(d, 'DAX'): k += ['770101 DAX', '770411 MaxMin']
            if not sfasato(d, 'USA'): k += ['770202 Dow']
            keep1.append((d, k))
        fr = freq_attesa(keep1, s1, don_g)
        nsost = sum(1 for x in s1 if x)
        riga("V1 orario->allineati" + etichetta, o, med, "| %d giornate sostituite su %d, %.2f op/giornata" % (nsost, N, fr))
        if not etichetta:
            risultati.append(('V1', o['PASS']))
            # stabilita' al seme
            ps = [simula_mix(giorni, f1, s1, DON, FATT, S0, guardian=GUARD, seme=sm)[0].get('PASS', 0) for sm in (12, 13, 14)]
            print("      semi 12/13/14: %s" % ", ".join("%.1f%%" % p for p in ps))

    # V2 / V4: pool fisso
    for tag, filtro in [("V2 tutti estivi", tutto_allineato), ("V4 tutti invernali", tutto_sfasato)]:
        sel = [i for i, d in enumerate(D) if filtro(d)]
        fr = [base[i] for i in sel]
        o, med = m.simula(fr, FATT, S0, guardian=GUARD)
        nop = sum(ntr[n][D[i]] for n in nomi for i in sel)
        nper = {n.split()[0]: sum(ntr[n][D[i]] for i in sel) for n in nomi}
        riga(tag, o, med, "| %d giornate, %.2f op/giornata, n=%s" % (len(sel), nop / len(sel), nper))
        risultati.append((tag[:2], o.get('PASS', 0)))

    DON = donatori_da(fer_al)
    f3, s3 = costruisci_v3()
    o, med = simula_mix(giorni, f3, s3, DON, FATT, S0, guardian=GUARD)
    keep3 = [(d, A_ORARIO + ([] if sfasato(d, 'USA') else ['771531 EMA200'])) for d in D]
    riga("V3 placebo: solo EMA200 estiva", o, med, "| %d giornate sostituite, %.2f op/giornata" % (sum(1 for x in s3 if x), freq_attesa(keep3, s3, fer_al)))
    risultati.append(('V3', o['PASS']))

    # ---- 4. placebo sui mesi: quanto e' raro un PF cosi' in 7 mesi presi a caso
    print("\n4. PLACEBO SUI MESI: PF su tutti i sottoinsiemi di k mesi (k = mesi allineati) -- quota <= PF allineato osservato")
    mesi = sorted(set(d[:7] for n in nomi for d, _ in tr[n]))
    for n in nomi:
        mm = MERCATO[n]
        al = [p for d, p in tr[n] if not sfasato(data(d), mm)]
        oss = pf(al)
        k = 7
        per_mese = collections.defaultdict(list)
        for d, p in tr[n]:
            per_mese[d[:7]].append(p)
        vals = []
        for comb in itertools.combinations(mesi, k):
            xs = [p for mo in comb for p in per_mese[mo]]
            if xs:
                vals.append(pf(xs))
        q = sum(1 for v in vals if v <= oss) / len(vals)
        vals.sort()
        print("  %-15s PF allineato %.2f | %d sottoinsiemi di %d mesi su %d | quota <= osservato %5.1f%% | mediana %.2f | 5%%-95%% %.2f-%.2f" % (
            n, oss, len(vals), k, len(mesi), 100 * q, statistics.median(vals), vals[int(.05 * len(vals))], vals[int(.95 * len(vals))]))
    print("=" * 100)


if __name__ == '__main__':
    main()
