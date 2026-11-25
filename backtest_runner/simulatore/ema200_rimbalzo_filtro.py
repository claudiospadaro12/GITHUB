#!/usr/bin/env python3
"""Media 200 rimbalzo corto: barra di scatto risolta con M1. Criteri: report/EMA200_RIMBALZO_CRITERI_2026-11-25.md (+ aggiunta)
Uso: /usr/bin/python3 -I ema200_rimbalzo_m1.py <cartella_H1> <cartella_M1_ABTG_BR> [<out.md>]"""
import sys, os, glob
M1D = sys.argv[2]; OUTP = sys.argv[3] if len(sys.argv) > 3 else None
HERE = os.path.dirname(os.path.abspath(__file__))
sys.argv = [sys.argv[0], sys.argv[1]]
exec(open(os.path.join(HERE, 'fibo_ema200_fx.py')).read().split("def run_legs")[0])
PERI = [('IS 2005-2015', 2005, 2015, 150), ('OOS 2016-2021', 2016, 2021, 80), ('HO 2022-2026', 2022, 2026, 50)]
def pf(x):
    x = np.array(x)
    if len(x) == 0: return 0, 0.0, 0.0
    w = x[x > 0].sum(); l = -x[x < 0].sum(); return len(x), (w / l if l > 0 else 99.0), (x > 0).mean() * 100
M1 = {}
def m1_of(pair):
    if pair not in M1:
        fs = sorted(glob.glob(os.path.join(M1D, f'ABTG_BR_{pair}*.csv')))
        d = pd.concat([pd.read_csv(f, sep=';') for f in fs]); d['t'] = pd.to_datetime(d['time'], format='%Y.%m.%d %H:%M')
        M1[pair] = d.drop_duplicates('t').set_index('t').sort_index()
    return M1[pair]
COV = [0, 0]
def resolve(pair, hour, lv, lg, sl, tpv, pip, sp_fix, filt, atrh):
    """'sl','tp','open','skip' (filtro non passato) o None (nessun M1)."""
    m = m1_of(pair); h = pd.Timestamp(hour); b = m.loc[h:h + pd.Timedelta(minutes=59)]
    COV[1] += 1
    if len(b) < 20: return None
    COV[0] += 1
    Hh, Ll, S = b.high.values, b.low.values, b.spread.values * pip / 10; mins = b.index.minute.values
    filled = False
    for j in range(len(b)):
        spd = S[j] if S[j] > 0 else sp_fix * pip
        if not filled:
            hit = (Ll[j] + spd <= lv) if lg else (Hh[j] >= lv)
            if not hit: continue
            if filt is not None:
                st = ((Hh[:j + 1].max() - lv) if lg else (lv - Ll[:j + 1].min())) / pip
                if not filt(int(mins[j]), st, atrh / pip): return 'skip'
            filled = True
            if lg and Ll[j] <= sl: return 'sl'
            if (not lg) and Hh[j] + spd >= sl: return 'sl'
            continue
        if lg:
            if Ll[j] <= sl: return 'sl'
            if Hh[j] >= tpv: return 'tp'
        else:
            if Hh[j] + spd >= sl: return 'sl'
            if Ll[j] + spd <= tpv: return 'tp'
    return 'open' if filled else None
SK = []
def run10m(pair, H1, i0, icancel, iend, side, levels, sl, tpp, pip, sp, mode, filt=None, atrh_arr=None):
    """mode: 'm1' (risoluzione M1; senza M1 = pessimistico), 'pess', 'ott'."""
    T, O, Hh, Ll, C = H1; spd = sp * pip; lg = side == 'buy'; fl = [None, None]; res = [None, None]
    for i in range(i0, iend + 1):
        for k in range(2):
            if res[k] is not None: continue
            lv = levels[k]; tp = lv + tpp * pip if lg else lv - tpp * pip
            if fl[k] is None:
                if i >= icancel: continue
                hit = (Ll[i] + spd <= lv) if lg else (Hh[i] >= lv)
                if not hit: continue
                fl[k] = True
                if mode == 'm1' and filt is not None:
                    r0 = resolve(pair, T[i], lv, lg, sl, tp, pip, sp, filt, atrh_arr[i - 1])
                    SK.append(r0 == 'skip')
                    if r0 == 'skip': fl[k] = False; res[k] = 0.0; continue
                if lg and Ll[i] <= sl: res[k] = (sl - SLIP * pip - lv) / pip; continue
                if (not lg) and Hh[i] + spd >= sl: res[k] = (lv - (sl + SLIP * pip)) / pip; continue
                if mode == 'ott' and ((lg and Hh[i] >= tp) or ((not lg) and Ll[i] + spd <= tp)): res[k] = tpp
                elif mode == 'm1':
                    r = resolve(pair, T[i], lv, lg, sl, tp, pip, sp, None, 0)
                    if r == 'tp': res[k] = tpp
                    elif r == 'sl': res[k] = (sl - SLIP * pip - lv) / pip if lg else (lv - (sl + SLIP * pip)) / pip
                continue
            if lg:
                if Ll[i] <= sl: res[k] = (sl - SLIP * pip - lv) / pip
                elif Hh[i] >= tp: res[k] = tpp
            else:
                if Hh[i] + spd >= sl: res[k] = (lv - (sl + SLIP * pip)) / pip
                elif Ll[i] + spd <= tp: res[k] = tpp
    for k in range(2):
        if fl[k] is True and res[k] is None:
            ex = C[iend] if lg else C[iend] + spd; res[k] = ((ex - levels[k]) if lg else (levels[k] - ex)) / pip
    if not any(f is True for f in fl): return None
    R = 0.0; wins = []
    for k in range(2):
        if fl[k] is not True: continue
        R += W[k] * res[k] / (abs(levels[k] - sl) / pip); wins.append(res[k] >= tpp - 1e-9)
    return R, wins
def scan(pair, var, mode, filt=None):
    pip = 0.01 if 'JPY' in pair else 0.0001; sp = SP[pair]; h1 = load(pair); h4 = h4_of(h1)
    T = h1.index.values; H1 = (T, h1.open.values, h1.high.values, h1.low.values, h1.close.values)
    _pc = h1.close.shift(1); _tr = pd.concat([h1.high - h1.low, (h1.high - _pc).abs(), (h1.low - _pc).abs()], axis=1).max(axis=1); atrh_arr = _tr.rolling(14).mean().values
    h4i = h4.index; e200 = h4.e200.values; atr = h4.atr.values; hc = h4.close.values
    days = pd.date_range(h1.index[0].normalize() + pd.Timedelta(days=60), h1.index[-1].normalize(), freq='D'); days = [d for d in days if d.weekday() <= 3]
    rows = []; legs = []; tpp = var.get('tp', 10)
    for d in days:
        S = d + pd.Timedelta(hours=8); pos = h4i.searchsorted(S, 'left') - 1
        if pos < 210 or h4i[pos] != S - pd.Timedelta(hours=4): continue
        i0 = np.searchsorted(T, np.datetime64(S)); ic = np.searchsorted(T, np.datetime64(d + pd.Timedelta(hours=18)))
        fri = d + pd.Timedelta(days=4 - d.weekday()); ie = np.searchsorted(T, np.datetime64(fri + pd.Timedelta(hours=20))) - 1
        if i0 >= len(T) or ie <= i0 or ic >= len(T): continue
        a = atr[pos]; P0 = hc[pos]; E = e200[pos]; sl_ = e200[pos] - e200[pos - 20]
        if not np.isfinite(a) or a <= 0: continue
        sld = var['slpips'] * pip if var.get('slpips') else var.get('atrsl', 2) * a
        if P0 - E >= 50 * pip and sl_ > 0: side = 'buy'; A, B = E + 10 * pip, E - 10 * pip; sl = B - sld
        elif E - P0 >= 50 * pip and sl_ < 0: side = 'sell'; A, B = E - 10 * pip, E + 10 * pip; sl = B + sld
        else: continue
        r = run10m(pair, H1, i0, ic, ie, side, [A, B], sl, tpp, pip, sp, mode, filt, atrh_arr)
        if r is not None: rows.append((d, pair, r[0])); legs += r[1]
    return rows, legs
FILT = [('BASE senza filtro (M1)', None),
 ('FA spike prima mezz\'ora (m<30)', lambda m, S, A: m < 30),
 ('FB arrivo lento (S<=1,0 ATRh)', lambda m, S, A: S <= 1.0 * A),
 ('FC arrivo lento stretto (S<=0,5 ATRh)', lambda m, S, A: S <= 0.5 * A),
 ('FD m<30 e S<=1,0 ATRh', lambda m, S, A: m < 30 and S <= 1.0 * A)]
verd = []
P('| cella | periodo | setup | PF (R) | R medio | R/anno |'); P('|---|---|---|---|---|---|')
for nome, f in FILT:
    rows = []; legs = []; SK.clear(); COV[0] = COV[1] = 0
    for p in SP:
        r, l = scan(p, {}, 'm1', f); rows += r; legs += l
    df = pd.DataFrame(rows, columns=['d', 'p', 'R']); df['y'] = df.d.dt.year; res = {}
    for pn, y0, y1, nmin in PERI:
        x = df[(df.y >= y0) & (df.y <= y1)].R.tolist(); n, pff, w = pf(x); res[pn] = (n, pff, nmin)
        P(f'| {nome} | {pn} | {n} | {pff:.2f} | {np.mean(x) if x else 0:.3f} | {sum(x)/(y1-y0+1):.1f} |')
    i, o, h = res['IS 2005-2015'], res['OOS 2016-2021'], res['HO 2022-2026']
    ok = i[0] >= i[2] and i[1] >= 1.3 and o[0] >= o[2] and o[1] > 1.2 and h[0] >= h[2] and h[1] > 1.0
    verd.append(f'- {nome}: IS {i[1]:.2f} (n={i[0]}), OOS {o[1]:.2f} (n={o[0]}), HO {h[1]:.2f} (n={h[0]}) -> ' + ('PASSA' if ok else 'non passa') + f'; ordini entrati {len(legs)}, rimbalzo {np.mean(legs)*100:.0f}%' + (f', scartati dal filtro {sum(SK)} su {len(SK)} scatti' if f is not None else ''))
P(); P('VERDETTO:'); [P(v) for v in verd]
if OUTP: open(OUTP, 'w').write('\n'.join(out) + '\n')
