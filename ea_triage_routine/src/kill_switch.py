#!/usr/bin/env python3
"""STEP 2 - Kill-Switch pre-ottimizzazione. Ogni leva strutturale viene SCELTA sul solo campione IS (primo 60% nel tempo)
e VALUTATA sul campione OOS (ultimo 40%), cosi' una leva non puo' passare per overfitting sul periodo in cui e' stata scelta.
Uso: kill_switch.py <trades.csv> <cartella_out> [soglie.json]  -> scrive kill_switch.json/.md e stampa PROCEDI o SCARTA."""
import sys, json, os, numpy as np, pandas as pd
sys.path.insert(0, os.path.dirname(__file__))
from triage_analyzer import load, pf, cell
def contiguous_windows(maxlen):
    return [[(s + i) % 24 for i in range(L)] for L in range(1, maxlen + 1) for s in range(24)]
def levers(d, cfg):
    """Restituisce {nome: (maschera_applicata_a_tutto, descrizione)}, scelte con i soli dati IS."""
    dg = cfg['diagnosi']; IS = d.IS; out = {}
    out['lato:solo_long'] = (d.side == 'long', 'solo Long'); out['lato:solo_short'] = (d.side == 'short', 'solo Short')
    if 'tag' in d and d.tag.nunique() > 1:
        for t in d.tag.dropna().unique(): out['segmento:' + str(t)] = (d.tag == t, 'solo segmento ' + str(t))
    # sessione: rimuovere la finestra oraria contigua che migliora di piu' il PF IS (max N ore)
    best = None
    for w in contiguous_windows(dg['finestra_sessione_max_ore']):
        keep = ~d.hour.isin(w); a = d.net[IS & keep]
        if (IS & keep).sum() < 0.5 * IS.sum(): continue
        s = pf(a)
        if best is None or s > best[0]: best = (s, w)
    if best: out['senza_finestra_oraria'] = (~d.hour.isin(best[1]), 'togliere ore %s (server, scelta su IS)' % sorted(best[1]))
    # simboli con PF IS >= 1.0
    good = [s for s in d.symbol.unique() if pf(d.net[IS & (d.symbol == s)]) >= 1.0 and (IS & (d.symbol == s)).sum() >= dg['min_trade_cella']]
    if good and len(good) < d.symbol.nunique(): out['solo_simboli_pf_is_ge_1'] = (d.symbol.isin(good), 'solo simboli con PF IS>=1: %s' % good)
    # volatilita: togliere il terzile peggiore su IS
    if 'atr_entry' in d and 'entry' in d:
        a = d.atr_entry / d.entry; t = a.groupby(d.symbol).transform(lambda s: pd.qcut(s.rank(method='first'), 3, labels=False))
        worst = min(range(3), key=lambda k: pf(d.net[IS & (t == k)]))
        out['senza_terzile_vol_peggiore'] = (t != worst, 'togliere il terzile di volatilita %s (0=bassa,2=alta), scelto su IS' % worst)
    return out
def tp_lever(d, cfg):
    """Leva MAE/MFE: take profit a k R (k scelto su IS). Stima prudente: se nello stesso trade MAE>=1R e MFE>=k, si conta la perdita."""
    if 'mae_R' not in d or 'mfe_R' not in d: return None
    def sim(k, m):
        hit = (d.mfe_R >= k) & ~(d.mae_R >= 1.0)
        return pd.Series(np.where(hit, k - d.cost_R, d.net), index=d.index)[m]
    ks = cfg['diagnosi']['tp_griglia_R']; k = max(ks, key=lambda x: pf(sim(x, d.IS)))
    return k, sim(k, d.IS), sim(k, ~d.IS)
def evaluate(d, cfg):
    ks = cfg['kill_switch']; res = []
    base_oos = pf(d.net[~d.IS]); allv = levers(d, cfg)
    # famiglie con piu varianti (lato, segmento): si sceglie UNA variante sul solo IS; le altre sono mostrate ma NON possono passare (selezione post hoc)
    fam = {}
    for name in allv:
        if ':' in name: fam.setdefault(name.split(':')[0], []).append(name)
    scelte = {}
    for f, names in fam.items():
        cand = [n for n in names if (d.IS & allv[n][0]).sum() >= cfg['diagnosi']['min_trade_cella']]
        scelte[f] = max(cand, key=lambda n: pf(d.net[d.IS & allv[n][0]])) if cand else None
    for name, (mask, desc) in allv.items():
        ammessa = (':' not in name) or scelte.get(name.split(':')[0]) == name
        a, b = d.net[d.IS & mask], d.net[~d.IS & mask]
        gl = d.R_gross[mask].mean(); cs = d.cost_R[mask].mean()
        ok = ammessa and (pf(b) >= ks['pf_minimo_dopo_leva'] and len(b) >= ks['min_trade_oos_dopo_leva'] and pf(b) - base_oos >= ks['miglioramento_oos_minimo_pf']
              and gl >= ks['movimento_lordo_vs_costi_min'] * cs)
        res.append(dict(leva=name, descrizione=desc + ('' if ammessa else ' [NON scelta su IS: solo informativa]'), n_is=len(a), pf_is=pf(a), n_oos=len(b), pf_oos=pf(b), lordo_medio_R=float(gl), costo_medio_R=float(cs), passa=bool(ok)))
    tl = tp_lever(d, cfg)
    if tl:
        k, a, b = tl; ok = pf(b) >= ks['pf_minimo_dopo_leva'] and len(b) >= ks['min_trade_oos_dopo_leva'] and pf(b) - base_oos >= ks['miglioramento_oos_minimo_pf']
        res.append(dict(leva='tp_a_%gR' % k, descrizione='take profit a %gR da MAE/MFE (scelto su IS, stima prudente)' % k, n_is=len(a), pf_is=pf(a), n_oos=len(b), pf_oos=pf(b), lordo_medio_R=None, costo_medio_R=None, passa=bool(ok)))
    return res
def decide(d, cfg, res):
    v = cfg['verdetto']; bi, bo = pf(d.net[d.IS]), pf(d.net[~d.IS])
    if bi >= v['pf_is_min'] and bo >= v['pf_oos_min'] and len(d) >= v['min_trade_totali']:
        return 'BASELINE_OK', 'PF IS %.2f >= %.2f e PF OOS %.2f >= %.2f con %d trade: l\'EA non ha bisogno di recupero. Va al verdetto (plateau, anni positivi, DD prop), non si ottimizza.' % (bi, v['pf_is_min'], bo, v['pf_oos_min'], len(d))
    base = pf(d.net); winners = [r for r in res if r['passa']]
    if winners: return 'PROCEDI', 'Leve che reggono sull\'OOS: ' + ', '.join(r['leva'] for r in winners)
    why = ['nessuna leva porta il PF OOS a >= %.2f con almeno %d trade OOS' % (cfg['kill_switch']['pf_minimo_dopo_leva'], cfg['kill_switch']['min_trade_oos_dopo_leva'])]
    if d.R_gross.mean() < d.cost_R.mean(): why.append('movimento lordo medio (%+.3fR) inferiore ai costi (%.3fR)' % (d.R_gross.mean(), d.cost_R.mean()))
    return 'SCARTA', '; '.join(why)
if __name__ == '__main__':
    path, out = sys.argv[1], sys.argv[2]; cfg = json.load(open(sys.argv[3] if len(sys.argv) > 3 else os.path.join(os.path.dirname(__file__), '..', 'config', 'soglie.json')))
    d, cut = load(path, cfg); res = evaluate(d, cfg); v, why = decide(d, cfg, res); os.makedirs(out, exist_ok=True)
    json.dump(dict(esito=v, motivo=why, baseline_pf=pf(d.net), baseline_oos_pf=pf(d.net[~d.IS]), n_leve_testate=len(res), leve=res), open(os.path.join(out, 'kill_switch.json'), 'w'), indent=1, default=lambda x: None if x != x else (str(x) if x == float('inf') else x))
    L = ['# Kill-Switch (STEP 2): ' + v, '', why, '', 'Baseline PF %.2f (OOS %.2f). Leve testate: %d (scelte su IS fino al %s, valutate su OOS).' % (pf(d.net), pf(d.net[~d.IS]), len(res), cut.date()), '', '| leva | n IS | PF IS | n OOS | PF OOS | passa |', '|---|---|---|---|---|---|']
    L += ['| %s | %d | %.2f | %d | %.2f | %s |' % (r['descrizione'], r['n_is'], r['pf_is'], r['n_oos'], r['pf_oos'], 'SI' if r['passa'] else 'no') for r in res]
    L += ['', 'Nota: con %d leve testate un passaggio isolato puo' ' essere caso; in tal caso lo STEP 3 deve confermarlo con IS/OOS e plateau.' % len(res)]
    open(os.path.join(out, 'kill_switch.md'), 'w', encoding='utf-8').write('\n'.join(L) + '\n')
    print({'SCARTA': 'STOP', 'PROCEDI': 'VAI', 'BASELINE_OK': 'OK'}[v], v, '-', why)
