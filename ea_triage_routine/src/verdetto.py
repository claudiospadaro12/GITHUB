#!/usr/bin/env python3
"""STEP 4 - Verdetto finale SALVATO / SCARTATO, con archiviazione.
Uso: verdetto.py <trades.csv> <cartella_analisi> [--plateau plateau.csv] [--nome NOME] [--archivia] [soglie.json]
Criteri (config/soglie.json -> verdetto): PF IS e OOS, n trade, anni positivi, stress costi x2, plateau (vicini con PF netto > 1 in frazione >= soglia),
drawdown giornaliero e totale al profilo di rischio valutato (DD realizzato sul chiuso: limite noto, il DD intraday di posizioni aperte e' peggiore).
Con --archivia sposta la cartella in SALVATI/ o SCARTATI/ (la cartella radice e quella che contiene IN_ANALISI)."""
import sys, os, json, shutil, datetime as dt, numpy as np, pandas as pd
sys.path.insert(0, os.path.dirname(__file__))
from triage_analyzer import load, pf
def dd_profile(d, risk_pct):
    s = d.sort_values('ts_close'); eq = (s.net * risk_pct).cumsum(); peak = eq.cummax().clip(lower=0)
    tot = float((peak - eq).max()); daily = float((s.groupby(s.ts_close.dt.date).net.sum() * risk_pct).min())
    return tot, -daily
def verdict(path, outdir, cfg, plateau=None):
    d, cut = load(path, cfg); v = cfg['verdetto']; rows = []; ok_all = True
    def chk(nome, valore, soglia, ok, nota=''):
        nonlocal ok_all; ok_all &= bool(ok); rows.append((nome, valore, soglia, 'OK' if ok else 'NO', nota))
    bi, bo = pf(d.net[d.IS]), pf(d.net[~d.IS])
    chk('PF IS', '%.2f' % bi, '>= %.2f' % v['pf_is_min'], bi >= v['pf_is_min']); chk('PF OOS', '%.2f' % bo, '>= %.2f' % v['pf_oos_min'], bo >= v['pf_oos_min'])
    chk('Operazioni totali', len(d), '>= %d' % v['min_trade_totali'], len(d) >= v['min_trade_totali'])
    ya = d.net.groupby(d.ts_open.dt.year).sum(); fr = float((ya > 0).mean()); chk('Anni positivi', '%d/%d (%.0f%%)' % ((ya > 0).sum(), len(ya), 100 * fr), '>= %.0f%%' % (100 * v['anni_positivi_min_frazione']), fr >= v['anni_positivi_min_frazione'])
    st = d.R_gross - v['stress_costi_x'] * d.cost_R; sp = pf(st); chk('PF con costi x%g (stress swap/spread)' % v['stress_costi_x'], '%.2f' % sp, '> %.2f' % v['stress_pf_min'], sp > v['stress_pf_min'])
    if plateau is not None:
        nb = plateau[~plateau.centro]; frac = float((nb.pf_netto > v['plateau_vicini_pf_sopra']).mean())
        chk('Plateau (vicini con PF netto > %.2f)' % v['plateau_vicini_pf_sopra'], '%.0f%% di %d' % (100 * frac, len(nb)), '>= %.0f%%' % (100 * v['plateau_vicini_frazione_min']), frac >= v['plateau_vicini_frazione_min'], 'PF vicini min %.2f / mediana %.2f' % (nb.pf_netto.min(), nb.pf_netto.median()))
    else: chk('Plateau', 'non calcolato', '-', False, 'serve --plateau: senza plateau non si salva')
    dd = {}
    for nome, rp in v['profili_rischio_pct'].items(): dd[nome] = dd_profile(d, rp)
    pv = v['profilo_valutazione']; t, g = dd[pv]
    chk('DD totale al profilo %s (%.2f%% a trade)' % (pv, v['profili_rischio_pct'][pv]), '%.1f%%' % t, '<= %.1f%%' % v['dd_totale_max_pct'], t <= v['dd_totale_max_pct'])
    chk('DD giornaliero (chiuso) al profilo %s' % pv, '%.1f%%' % g, '<= %.1f%%' % v['dd_giornaliero_max_pct'], g <= v['dd_giornaliero_max_pct'])
    return ok_all, rows, dd, d, cut
def main():
    a = [x for x in sys.argv[1:] if not x.startswith('--')]; flags = sys.argv[1:]
    path, outdir = a[0], a[1]; cfgp = next((x for x in a[2:] if x.endswith('.json')), os.path.join(os.path.dirname(__file__), '..', 'config', 'soglie.json'))
    cfg = json.load(open(cfgp)); plateau = pd.read_csv(flags[flags.index('--plateau') + 1]) if '--plateau' in flags else None
    nome = flags[flags.index('--nome') + 1] if '--nome' in flags else os.path.basename(os.path.normpath(outdir))
    ok, rows, dd, d, cut = verdict(path, outdir, cfg, plateau); os.makedirs(outdir, exist_ok=True)
    L = ['# Verdetto finale (STEP 4): ' + ('🟢 SALVATO' if ok else '🔴 SCARTATO DEFINITIVAMENTE'), '', 'EA: %s | %d operazioni | IS fino al %s, OOS dopo.' % (nome, len(d), cut.date()), '', '| criterio | valore | soglia | esito | nota |', '|---|---|---|---|---|']
    L += ['| %s | %s | %s | %s | %s |' % r for r in rows]
    L += ['', '**Drawdown (chiuso, additivo) per profilo di rischio:** ' + '; '.join('%s %.2f%% a trade: totale %.1f%%, peggior giorno %.1f%%' % (n, cfg['verdetto']['profili_rischio_pct'][n], t, g) for n, (t, g) in dd.items())]
    if ok: L += ['', 'Passa in pipeline principale. Profili che rientrano nei limiti (totale <= %.1f%%, giornaliero <= %.1f%%): %s.' % (cfg['verdetto']['dd_totale_max_pct'], cfg['verdetto']['dd_giornaliero_max_pct'], ', '.join(n for n, (t, g) in dd.items() if t <= cfg['verdetto']['dd_totale_max_pct'] and g <= cfg['verdetto']['dd_giornaliero_max_pct']) or 'nessuno'),
                '', 'Limiti: DD calcolato sul chiuso (non sul flottante intraday); costi della replica non provati su tick reali; nessun consiglio su taglie, decide Claudio.']
    else:
        fail = [r for r in rows if r[3] == 'NO']
        L += ['', 'Perche si archivia (3 righe):'] + ['%d. %s: %s (soglia %s)%s' % (i + 1, r[0], r[1], r[2], (' - ' + r[4]) if r[4] else '') for i, r in enumerate(fail[:3])]
    open(os.path.join(outdir, 'verdict_report.md'), 'w', encoding='utf-8').write('\n'.join(L) + '\n')
    print('SALVATO' if ok else 'SCARTATO', '-', ', '.join(r[0] for r in rows if r[3] == 'NO') or 'tutti i criteri OK')
    if '--archivia' in flags:
        root = os.path.dirname(os.path.dirname(os.path.abspath(outdir))); dest = os.path.join(root, 'SALVATI' if ok else 'SCARTATI', os.path.basename(os.path.normpath(outdir)))
        if os.path.abspath(dest) != os.path.abspath(outdir):
            if os.path.exists(dest): shutil.rmtree(dest)
            shutil.move(outdir, dest); print('archiviato in', dest)
if __name__ == '__main__': main()
