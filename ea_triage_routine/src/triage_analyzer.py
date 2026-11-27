#!/usr/bin/env python3
"""STEP 1 - diagnostica forense di un EA con PF < 1 (o marginale).
Ingresso: log operazioni normalizzato (CSV) con colonne obbligatorie ts_open, ts_close, symbol, side(long/short), R_gross, cost_R
e opzionali tag, mae_R, mfe_R, atr_entry, entry. R = risultato in multipli del rischio iniziale; cost_R = costo (spread+commissioni) in R.
Uso: triage_analyzer.py <trades.csv> <cartella_out> [soglie.json]"""
import sys, json, os, numpy as np, pandas as pd
def pf(x):
    w = x[x > 0].sum(); l = -x[x < 0].sum(); return float(w / l) if l > 0 else (np.inf if w > 0 else np.nan)
def cell(net):
    return dict(n=int(len(net)), pf=pf(net), win=float((net > 0).mean()) if len(net) else np.nan, mean_R=float(net.mean()) if len(net) else np.nan)
def load(path, cfg):
    d = pd.read_csv(path, parse_dates=['ts_open', 'ts_close']).sort_values('ts_open').reset_index(drop=True)
    for c in ('ts_open', 'ts_close', 'symbol', 'side', 'R_gross', 'cost_R'):
        if c not in d: raise SystemExit('Colonna mancante: ' + c)
    d['net'] = d.R_gross - cfg['costo_moltiplicatore'] * d.cost_R
    cut = d.ts_open.quantile(cfg['split_is_frazione']); d['IS'] = d.ts_open <= cut
    d['hour'] = d.ts_open.dt.hour; d['dow'] = d.ts_open.dt.dayofweek
    return d, cut
def analyze(d, cfg):
    dg = cfg['diagnosi']; r = {}
    r['baseline'] = {'tutti': cell(d.net), 'IS': cell(d.net[d.IS]), 'OOS': cell(d.net[~d.IS]),
                     'lordo_pf': pf(d.R_gross), 'costo_medio_R': float(d.cost_R.mean()), 'lordo_medio_R': float(d.R_gross.mean())}
    r['lato'] = {s: {'tutti': cell(d.net[d.side == s]), 'IS': cell(d.net[(d.side == s) & d.IS]), 'OOS': cell(d.net[(d.side == s) & ~d.IS])} for s in ('long', 'short')}
    if 'tag' in d: r['tag'] = {t: {'tutti': cell(d.net[d.tag == t]), 'IS': cell(d.net[(d.tag == t) & d.IS]), 'OOS': cell(d.net[(d.tag == t) & ~d.IS])} for t in d.tag.dropna().unique()}
    r['simbolo'] = {s: {'IS': cell(d.net[(d.symbol == s) & d.IS]), 'OOS': cell(d.net[(d.symbol == s) & ~d.IS])} for s in sorted(d.symbol.unique())}
    r['ora'] = {int(h): cell(d.net[d.hour == h]) for h in range(24) if (d.hour == h).any()}
    r['giorno'] = {int(k): cell(d.net[d.dow == k]) for k in range(7) if (d.dow == k).any()}
    r['ore_tossiche'] = [h for h, c in r['ora'].items() if c['n'] >= dg['min_trade_cella'] and c['pf'] < dg['ore_tossiche_pf_sotto']]
    if 'mae_R' in d and 'mfe_R' in d:
        q = lambda s: {k: float(s.quantile(v)) for k, v in (('p25', .25), ('p50', .5), ('p75', .75), ('p90', .9))}
        w = d.net > 0
        r['mae_mfe'] = {'mfe_vincenti': q(d.mfe_R[w]), 'mfe_perdenti': q(d.mfe_R[~w]), 'mae_vincenti': q(d.mae_R[w]), 'mae_perdenti': q(d.mae_R[~w]),
                        'perdenti_con_mfe_ge_1R': float((d.mfe_R[~w] >= 1).mean()), 'vincenti_con_mae_ge_0.7R': float((d.mae_R[w] >= .7).mean())}
    if 'atr_entry' in d and 'entry' in d:
        a = d.atr_entry / d.entry; d['terzile'] = a.groupby(d.symbol).transform(lambda s: pd.qcut(s.rank(method='first'), 3, labels=['bassa', 'media', 'alta']))
        r['volatilita'] = {t: cell(d.net[d.terzile == t]) for t in ('bassa', 'media', 'alta')}
    inv = -d.R_gross - cfg['costo_moltiplicatore'] * d.cost_R
    r['costi'] = {'lordo_medio_R': float(d.R_gross.mean()), 'costo_medio_R': float(d.cost_R.mean()), 'incidenza': float(d.cost_R.mean() / abs(d.R_gross.mean())) if d.R_gross.mean() else None,
                  'pf_lordo': pf(d.R_gross), 'pf_netto': pf(d.net), 'pf_invertito_netto': pf(inv),
                  'test_inversione_indicato': bool(pf(d.net) < dg['inversione_se_pf_sotto']),
                  'inversione_sospetta': bool(pf(inv) > dg['inversione_pf_sospetto_sopra'])}
    return r
def fmt(c): return '%d | %.2f | %.0f%% | %+.3f' % (c['n'], c['pf'], 100 * c['win'], c['mean_R']) if c['n'] else '0 | - | - | -'
def report_md(r, nome):
    L = ['# Triage STEP 1 - ' + nome, '', '| cella | n | PF | win | R medio |', '|---|---|---|---|---|']
    for k in ('tutti', 'IS', 'OOS'): L.append('| baseline %s | %s |' % (k, fmt(r['baseline'][k])))
    L.append('| lordo PF %.2f, costo medio %.3fR, lordo medio %+.3fR | | | | |' % (r['baseline']['lordo_pf'], r['baseline']['costo_medio_R'], r['baseline']['lordo_medio_R']))
    for s, v in r['lato'].items(): L.append('| %s tutti / IS / OOS | %s / %s / %s |' % (s, fmt(v['tutti']), fmt(v['IS']), fmt(v['OOS'])))
    for s, v in r.get('tag', {}).items(): L.append('| tag %s tutti / IS / OOS | %s / %s / %s |' % (s, fmt(v['tutti']), fmt(v['IS']), fmt(v['OOS'])))
    L += ['', 'Ore tossiche (PF < soglia, n sufficiente): %s' % (r['ore_tossiche'] or 'nessuna'), '', 'Costi: %s' % json.dumps(r['costi'], default=str)]
    if 'mae_mfe' in r: L += ['', 'MAE/MFE: %s' % json.dumps(r['mae_mfe'], default=lambda x: round(x, 3))]
    if 'volatilita' in r: L += ['', 'Volatilita (terzili ATR): ' + '; '.join('%s: %s' % (k, fmt(v)) for k, v in r['volatilita'].items())]
    return '\n'.join(L) + '\n'
if __name__ == '__main__':
    path, out = sys.argv[1], sys.argv[2]; cfg = json.load(open(sys.argv[3] if len(sys.argv) > 3 else os.path.join(os.path.dirname(__file__), '..', 'config', 'soglie.json')))
    d, cut = load(path, cfg); r = analyze(d, cfg); os.makedirs(out, exist_ok=True)
    json.dump(r, open(os.path.join(out, 'triage_step1.json'), 'w'), indent=1, default=lambda x: None if x != x else (str(x) if x == float('inf') else x))
    open(os.path.join(out, 'triage_step1.md'), 'w', encoding='utf-8').write(report_md(r, os.path.basename(path)))
    print('STEP 1 ok: n=%d, taglio IS/OOS=%s' % (len(d), cut.date()))
