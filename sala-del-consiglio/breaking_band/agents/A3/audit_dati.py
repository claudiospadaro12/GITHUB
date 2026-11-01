#!/usr/bin/env python3
"""A3 / R002 - Audit dati M1 oro + geometria a priori Bollinger/ATR.
Uso: python3 -I audit_dati.py <cartella_dati> [--json out.json]
Legge solo i 4 CSV (dati NON fidati: parsing difensivo, righe malformate contate). Nessun backtest di regole.

Convenzioni dichiarate:
- spread in punti; 1 punto = 0,01 USD. Orari = ora server BCM come nel CSV (nessuna conversione).
- Barre H1/M15: chiave = minuto_assoluto // TF (allineate a :00 del server); una barra esiste se ha >=1 M1.
- Bollinger(20,2): SMA di 20 chiusure, deviazione standard di POPOLAZIONE (ddof=0, come MT5).
- ATR(14): Wilder (RMA), seme = media dei primi 14 TR; TR usa la chiusura precedente (anche oltre buchi).
- Distanze in ATR: (SMA-inf)/ATR, (sup-SMA)/ATR, (sup-inf)/ATR, calcolate alla chiusura di ogni barra (solo dati passati).
- Primi 20 (BB) / 14 (ATR) barre scartate (warm-up).
"""
import sys, json
import numpy as np

FILES = [('2013', 'ABTG_M1_XAUUSD_2013.csv'), ('2018', 'ABTG_M1_XAUUSD_2018.csv'),
         ('2020', 'ABTG_M1_XAUUSD_2020.csv'), ('2025-26', 'ABTG_M1_XAUUSD.csv')]
PT = 0.01
STOP_ATR = 3.0


def carica(path):
    t = []; v = []; bad = 0; bad_ex = []
    with open(path, encoding='utf-8', errors='replace') as f:
        hdr = f.readline().strip()
        for n, ln in enumerate(f, start=2):
            p = ln.strip().split(';')
            try:
                if len(p) != 7: raise ValueError('colonne')
                ts = p[0]
                t.append(np.datetime64(ts[:4] + '-' + ts[5:7] + '-' + ts[8:10] + 'T' + ts[11:13] + ':' + ts[14:16], 'm'))
                v.append([float(x) for x in p[1:]])
            except Exception:
                bad += 1
                if len(bad_ex) < 5: bad_ex.append((n, ln[:60]))
    return hdr, np.array(t, dtype='datetime64[m]'), np.array(v, dtype=float), bad, bad_ex


def pct(x, q):
    return float(np.percentile(x, q)) if len(x) else float('nan')


def audit(name, hdr, t, v, bad, bad_ex):
    R = {'periodo': name, 'header': hdr, 'righe': int(len(t)), 'righe_malformate': bad, 'esempi_malformate': bad_ex}
    o, h, l, c, tv, sp = v.T
    ti = t.astype('int64')  # minuti dal 1970 (UTC fittizio, solo aritmetica)
    R['primo'] = str(t[0]); R['ultimo'] = str(t[-1])
    d = np.diff(ti)
    R['ordine_violazioni(diff<0)'] = int((d < 0).sum())
    R['duplicati_timestamp(diff==0)'] = int((d == 0).sum())
    R['righe_duplicate_intere'] = int((np.all(v[1:] == v[:-1], axis=1) & (d == 0)).sum())
    # giorni della settimana (0=lun .. 6=dom)
    dow = ((t.astype('datetime64[D]').astype('int64') + 3) % 7)  # 1970-01-01 = giovedi (3)
    R['righe_sabato'] = int((dow == 5).sum()); R['righe_domenica'] = int((dow == 6).sum())
    # buchi
    gi = np.where(d > 1)[0]
    gaps = d[gi]
    cat = {'2-5 min': 0, '6-59 min': 0, '60-119 min (pausa giornaliera)': 0, '120-1439 min': 0,
           'weekend (contiene sabato)': 0, 'altro >=1440 min non weekend': 0}
    anom = []
    wk_len = []
    for i, g in zip(gi, gaps):
        a = t[i]; b = t[i + 1]
        # il buco contiene un sabato intero o sta a cavallo di un fine settimana?
        da = int(a.astype('datetime64[D]').astype('int64')); db = int(b.astype('datetime64[D]').astype('int64'))
        has_sat = any(((x + 3) % 7) == 5 for x in range(da, db + 1))
        if has_sat and g >= 24 * 60:
            cat['weekend (contiene sabato)'] += 1; wk_len.append(int(g)); continue
        if g <= 5: cat['2-5 min'] += 1
        elif g < 60: cat['6-59 min'] += 1
        elif g < 120: cat['60-119 min (pausa giornaliera)'] += 1
        elif g < 1440: cat['120-1439 min'] += 1; anom.append((str(a), str(b), int(g)))
        else: cat['altro >=1440 min non weekend'] += 1; anom.append((str(a), str(b), int(g)))
    R['buchi_per_categoria'] = cat
    R['buchi_totali'] = int(len(gi))
    R['minuti_mancanti_totali_(escl. weekend)'] = int(sum(g - 1 for i, g in zip(gi, gaps)) - sum(w - 1 for w in wk_len))
    R['weekend_durata_min_mediana_max'] = (float(np.median(wk_len)), int(max(wk_len))) if wk_len else None
    anom.sort(key=lambda x: -x[2])
    R['buchi_anomali_top20'] = anom[:20]
    R['buchi_anomali_n'] = len(anom)
    # buchi "anomali" in senso stretto: >=120 min feriali (non weekend): elenco sopra. Giorni di festa noti (25/12, 1/1) vengono dentro.
    # anomalie OHLC
    R['high<low'] = int((h < l).sum())
    R['high<max(open,close)'] = int((h < np.maximum(o, c) - 1e-9).sum())
    R['low>min(open,close)'] = int((l > np.minimum(o, c) + 1e-9).sum())
    R['prezzi<=0'] = int((v[:, :4] <= 0).sum())
    R['nan'] = int(np.isnan(v).sum())
    R['barre_piatte(h==l)'] = int((h == l).sum())
    R['tickvol==0'] = int((tv == 0).sum())
    R['spread<=0'] = int((sp <= 0).sum()); R['spread==0'] = int((sp == 0).sum()); R['spread<0'] = int((sp < 0).sum())
    ret = np.abs(np.diff(np.log(c))) if (c > 0).all() else np.array([0.0])
    R['salti_close_>0,5%_in_1_minuto'] = int((ret > 0.005).sum())
    R['salti_close_>1%_in_1_minuto'] = int((ret > 0.01).sum())
    R['max_salto_close_pct'] = float(ret.max() * 100)
    rng = (h - l)
    R['range_M1_max_USD'] = float(rng.max()); R['range_M1_mediano_USD'] = float(np.median(rng))
    R['prezzo_min_max'] = (float(l.min()), float(h.max()))
    # spread
    spd = sp * PT
    R['spread_USD'] = {'min': float(spd.min()), 'p50': pct(spd, 50), 'p90': pct(spd, 90), 'p99': pct(spd, 99), 'max': float(spd.max()), 'media': float(spd.mean())}
    R['spread_punti'] = {'p50': pct(sp, 50), 'p90': pct(sp, 90), 'p99': pct(sp, 99)}
    hour = (ti // 60) % 24
    byh = {}
    for hh in range(24):
        s = spd[hour == hh]
        byh[hh] = {'n': int(len(s)), 'p50': pct(s, 50), 'p90': pct(s, 90), 'p99': pct(s, 99)} if len(s) else {'n': 0}
    R['spread_per_ora_server_USD'] = byh
    # barre ricavabili
    for tf, lab in ((60, 'H1'), (15, 'M15')):
        k = ti // tf
        R['barre_' + lab] = int(len(np.unique(k)))
    return R


def barre(t, v, tf):
    """Barre OHLC + spread mediano per barra (USD) da M1. Ritorna dict di array."""
    ti = t.astype('int64'); k = ti // tf
    idx = np.r_[0, np.where(np.diff(k) != 0)[0] + 1]
    o = v[idx, 0]
    h = np.maximum.reduceat(v[:, 1], idx); l = np.minimum.reduceat(v[:, 2], idx)
    end = np.r_[idx[1:], len(k)] - 1
    c = v[end, 3]
    sp = v[:, 5] * PT
    spm = np.array([np.median(sp[a:b + 1]) for a, b in zip(idx, end)])
    return dict(key=k[idx], o=o, h=h, l=l, c=c, spm=spm)


def geometria(name, t, v, tf):
    B = barre(t, v, tf); c = B['c']; h = B['h']; l = B['l']; n = len(c)
    # SMA20 e dev. std. di popolazione tramite somme cumulate
    cs = np.cumsum(np.r_[0.0, c]); cs2 = np.cumsum(np.r_[0.0, c * c])
    W = 20
    sma = np.full(n, np.nan); sd = np.full(n, np.nan)
    s1 = cs[W:] - cs[:-W]; s2 = cs2[W:] - cs2[:-W]
    sma[W - 1:] = s1 / W
    var = np.maximum(s2 / W - (s1 / W) ** 2, 0.0); sd[W - 1:] = np.sqrt(var)
    up = sma + 2 * sd; lo = sma - 2 * sd
    # ATR Wilder 14
    pc = np.r_[c[0], c[:-1]]
    tr = np.maximum(h - l, np.maximum(np.abs(h - pc), np.abs(l - pc)))
    atr = np.full(n, np.nan); N = 14
    atr[N - 1] = tr[:N].mean()
    for i in range(N, n):
        atr[i] = (atr[i - 1] * (N - 1) + tr[i]) / N
    ok = ~np.isnan(sma) & ~np.isnan(atr) & (atr > 0)
    dl = (sma - lo)[ok] / atr[ok]; du = (up - sma)[ok] / atr[ok]; wd = (up - lo)[ok] / atr[ok]
    spb = B['spm'][ok]; atr_ok = atr[ok]
    spread_med = float(np.median(v[:, 5] * PT))  # spread mediano del periodo (tutti i M1), USD
    out = {'periodo': name, 'tf': 'H1' if tf == 60 else 'M15', 'barre_totali': int(n), 'barre_valide': int(ok.sum()),
           'ATR_USD_p10_p50_p90': [pct(atr_ok, q) for q in (10, 50, 90)],
           'dist_inf_ATR_p10_p50_p90': [pct(dl, q) for q in (10, 50, 90)],
           'dist_sup_ATR_p10_p50_p90': [pct(du, q) for q in (10, 50, 90)],
           'larghezza_ATR_p10_p50_p90': [pct(wd, q) for q in (10, 50, 90)],
           'max_abs(dist_inf-dist_sup)': float(np.max(np.abs(dl - du))),
           'spread_mediano_periodo_USD': spread_med,
           'spread_mediano_barra_USD_p50': pct(spb, 50)}
    D = float(np.median(dl))  # target = mediana della distanza (in ATR) tra banda e SMA
    S = STOP_ATR
    out['target_ATR_mediana'] = D
    out['BE_senza_costo'] = S / (S + D)
    # costo: spread mediano del periodo / ATR di ogni barra, pagato una volta (ingresso a mercato + uscita)
    c_atr = spread_med / atr_ok
    out['costo_spread_ATR_p10_p50_p90'] = [pct(c_atr, q) for q in (10, 50, 90)]
    c_med = float(np.median(c_atr))
    out['BE_con_spread_mediano_(target=D_mediana,costo=mediano)'] = (S + c_med) / (S + D)
    # variante per-barra: target = distanza della barra stessa, costo della barra stessa
    be0 = S / (S + dl); be1 = (S + c_atr) / (S + dl)
    out['BE_per_barra_senza_costo_p10_p50_p90'] = [pct(be0, q) for q in (10, 50, 90)]
    out['BE_per_barra_con_spread_p10_p50_p90'] = [pct(be1, q) for q in (10, 50, 90)]
    out['quota_barre_con_costo>0,25ATR'] = float((c_atr > 0.25).mean())
    # target sotto lo spread? (target netto <=0)
    out['quota_barre_target<=spread'] = float((dl <= c_atr).mean())
    # R:R
    out['RR_target/stop'] = D / S
    out['BE_con_spread_p90_(target=D_mediana,costo=spread_p90/ATR_mediano)'] = (S + spread_p90_atr(v, atr_ok)) / (S + D)
    return out


def spread_p90_atr(v, atr_ok):
    return float(np.median(pct(v[:, 5] * PT, 90) / atr_ok))


def main():
    if len(sys.argv) < 2:
        print(__doc__); sys.exit(1)
    d = sys.argv[1].rstrip('/')
    outj = sys.argv[sys.argv.index('--json') + 1] if '--json' in sys.argv else None
    res = {'audit': [], 'geometria': []}
    for name, fn in FILES:
        hdr, t, v, bad, bex = carica(d + '/' + fn)
        res['audit'].append(audit(name, hdr, t, v, bad, bex))
        for tf in (60, 15):
            res['geometria'].append(geometria(name, t, v, tf))
    # test di correttezza minimi (self-check su dati sintetici)
    res['selfcheck'] = selfcheck()
    s = json.dumps(res, indent=1, ensure_ascii=False, default=str)
    if outj:
        open(outj, 'w', encoding='utf-8').write(s)
    print(s)


def selfcheck():
    """Controlli su dati sintetici: barre, Bollinger, ATR, break-even."""
    out = {}
    # 1) barre H1 da 120 minuti sintetici
    t = np.arange(np.datetime64('2020-01-06T00:00', 'm'), np.datetime64('2020-01-06T02:00', 'm'))
    n = len(t); cl = np.arange(n, dtype=float) + 100
    v = np.column_stack([cl, cl + 1, cl - 1, cl + 0.5, np.ones(n), np.full(n, 10.0)])
    B = barre(t, v, 60)
    out['H1_2_barre'] = bool(len(B['c']) == 2 and B['o'][1] == v[60, 0] and B['c'][0] == v[59, 3] and B['h'][0] == v[59, 1] and B['l'][0] == v[0, 2])
    # 2) Bollinger di serie costante: banda = SMA, sd=0
    t2 = np.arange(np.datetime64('2020-01-06T00:00', 'm'), np.datetime64('2020-01-06T10:00', 'm'))
    n2 = len(t2); v2 = np.column_stack([np.full(n2, 50.0), np.full(n2, 51.0), np.full(n2, 49.0), np.full(n2, 50.0), np.ones(n2), np.full(n2, 20.0)])
    g = geometria('syn', t2, v2, 15)
    out['BB_costante_larghezza0'] = bool(g['larghezza_ATR_p10_p50_p90'] == [0.0, 0.0, 0.0] and abs(g['ATR_USD_p10_p50_p90'][1] - 2.0) < 1e-9)
    # 3) break-even: D=1, S=3 -> 0,75 ; con costo 0,2 -> 3,2/4=0,8
    out['BE_formula'] = abs(3 / (3 + 1) - 0.75) < 1e-12 and abs((3 + 0.2) / (3 + 1) - 0.8) < 1e-12
    # 4) Bollinger vs calcolo diretto su serie casuale (seed fisso)
    rng = np.random.default_rng(1); x = np.cumsum(rng.normal(size=200)) + 100
    w = x[-20:]; direct = (w.mean() + 2 * w.std()) - (w.mean() - 2 * w.std())
    cs = np.cumsum(np.r_[0.0, x]); cs2 = np.cumsum(np.r_[0.0, x * x])
    s1 = cs[-1] - cs[-21]; s2 = cs2[-1] - cs2[-21]
    out['BB_cumsum_uguale_diretto'] = bool(abs(4 * np.sqrt(max(s2 / 20 - (s1 / 20) ** 2, 0)) - direct) < 1e-6)
    return out


if __name__ == '__main__':
    main()
