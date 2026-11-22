"""Modulo 5: motore di validazione (diff e match score) fra operazioni del tester e operazioni di un modello di riferimento."""
import numpy as np, pandas as pd


def match_trades(ref, test, tol_open="10min"):
    """Abbina ogni operazione del tester a quella del modello dello stesso verso con orario di apertura piu vicino (entro tol_open)."""
    tol = pd.Timedelta(tol_open)
    ref = ref.reset_index(drop=True); test = test.reset_index(drop=True)
    used, pairs = set(), []
    for i, t in test.iterrows():
        best, bd = None, None
        for j, r in ref.iterrows():
            if j in used or r.side != t.side:
                continue
            d = abs(r.open_time - t.open_time)
            if d <= tol and (bd is None or d < bd):
                best, bd = j, d
        if best is not None:
            used.add(best); pairs.append((i, best))
    return pairs


def score(ref, test, tol_open="10min", tol_price=0.05, tol_close="2min", tol_vol_rel=0.05):
    """Percentuali di fedelta. ref e test: DataFrame con open_time, close_time, side, volume, open_price, close_price, sl.
    La fedelta globale = (accoppiate / unione) x media dei criteri sulle accoppiate."""
    pairs = match_trades(ref, test, tol_open)
    rows = []
    for i, j in pairs:
        t, r = test.iloc[i], ref.iloc[j]
        rows.append(dict(i_test=i, i_ref=j, open_time_test=t.open_time, open_time_ref=r.open_time,
                         d_open_s=(t.open_time - r.open_time).total_seconds(),
                         d_open_price=t.open_price - r.open_price,
                         d_sl=(t.sl - r.sl) if pd.notna(t.sl) and pd.notna(r.get("sl", np.nan)) else np.nan,
                         d_close_s=(t.close_time - r.close_time).total_seconds(),
                         d_close_price=t.close_price - r.close_price,
                         vol_ratio=(t.volume / r.volume) if r.get("volume", 0) else np.nan))
    d = pd.DataFrame(rows)
    nt, nr, nm = len(test), len(ref), len(pairs)
    res = dict(operazioni_tester=nt, operazioni_modello=nr, abbinate=nm,
               abbinate_su_tester_pct=round(100 * nm / nt, 1) if nt else None, abbinate_su_modello_pct=round(100 * nm / nr, 1) if nr else None)
    if nm:
        res["apertura_esatta_pct"] = round(100 * (d.d_open_s == 0).mean(), 1)
        res["prezzo_ingresso_entro_tol_pct"] = round(100 * (d.d_open_price.abs() <= tol_price).mean(), 1)
        res["sl_entro_tol_pct"] = round(100 * (d.d_sl.abs() <= tol_price).mean(), 1) if d.d_sl.notna().any() else None
        res["chiusura_entro_tol_tempo_pct"] = round(100 * (d.d_close_s.abs() <= pd.Timedelta(tol_close).total_seconds()).mean(), 1)
        res["prezzo_uscita_entro_tol_pct"] = round(100 * (d.d_close_price.abs() <= tol_price).mean(), 1)
        vr = d.vol_ratio.dropna()
        res["lotti_proporzionali_pct"] = round(100 * ((vr / vr.median() - 1).abs() <= tol_vol_rel).mean(), 1) if len(vr) else None
        res["rapporto_lotti_mediano"] = round(float(vr.median()), 4) if len(vr) else None
        comp = [res[k] for k in ("apertura_esatta_pct", "prezzo_ingresso_entro_tol_pct", "chiusura_entro_tol_tempo_pct", "prezzo_uscita_entro_tol_pct") if res.get(k) is not None]
        comp += [res[k] for k in ("sl_entro_tol_pct", "lotti_proporzionali_pct") if res.get(k) is not None]
        union = nt + nr - nm
        res["FEDELTA_GLOBALE_pct"] = round(nm / union * float(np.mean(comp)), 1)
    return res, d, pairs


def missing_and_extra(ref, test, pairs, ohlcv=None, ctx_bars=3, tf="4h"):
    """Operazioni del tester senza controparte nel modello (e viceversa), con il contesto delle ultime barre."""
    mt = {i for i, _ in pairs}; mr = {j for _, j in pairs}
    def ctx(t):
        if ohlcv is None:
            return ""
        b = ohlcv.resample(tf).agg({"open": "first", "high": "max", "low": "min", "close": "last"}).dropna()
        k = b.index.searchsorted(t, side="right") - 1
        return b.iloc[max(0, k - ctx_bars + 1):k + 1].round(2).to_dict("records")
    extra = test[[i not in mt for i in range(len(test))]].copy(); extra["contesto"] = [ctx(t) for t in extra.open_time]
    missed = ref[[j not in mr for j in range(len(ref))]].copy(); missed["contesto"] = [ctx(t) for t in missed.open_time]
    return extra, missed


def add_model_lots(ref, test, pairs, risk_pct=1.0, contract=100.0, fx=None, step=0.01, vmin=0.01, vmax=100.0):
    """Lotti del modello = floor( saldo_prima_dell_ingresso x rischio% / (distanza_SL x contratto x conversione) ) al passo del simbolo.
    saldo preso dal tester (nessuna posizione aperta all'ingresso: saldo = equity); conversione = 1 / EURUSD (serie fx = close di EURUSD) se il conto e in EUR, altrimenti 1."""
    ref = ref.copy(); ref["volume"] = np.nan
    for i, j in pairs:
        t, r = test.iloc[i], ref.iloc[j]
        dist = r.open_price - r.sl
        conv = 1.0
        if fx is not None:
            k = fx.index.searchsorted(r.open_time, side="right") - 1
            conv = 1.0 / float(fx.iloc[max(0, k)])
        lot = (t.balance_before * risk_pct / 100.0) / (dist * contract * conv)
        lot = np.floor(lot / step + 1e-9) * step
        ref.iloc[j, ref.columns.get_loc("volume")] = min(max(lot, vmin), vmax)
    return ref
