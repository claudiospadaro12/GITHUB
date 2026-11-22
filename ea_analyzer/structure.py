"""Modulo 2: meccanica delle operazioni (descrittiva)."""
import numpy as np, pandas as pd


def analyze_structure(tr, tf_minutes=None):
    r = {}
    n = len(tr)
    r["operazioni"] = n
    if n == 0:
        return r
    ev = sorted([(t, 1, s) for t, s in zip(tr.open_time, tr.side)] + [(t, -1, s) for t, s in zip(tr.close_time, tr.side)], key=lambda x: (x[0], x[1]))
    cur = {"buy": 0, "sell": 0}; mx = 0; mxs = {"buy": 0, "sell": 0}; hedge = False
    for _, d, s in ev:
        cur[s] += d; mx = max(mx, sum(cur.values())); mxs[s] = max(mxs[s], cur[s]); hedge |= cur["buy"] > 0 and cur["sell"] > 0
    r["posizioni_contemporanee_max"] = mx
    r["tipo_gestione"] = ("hedging (long e short insieme)" if hedge else "griglia/piramidazione (piu posizioni dello stesso verso)" if max(mxs.values()) > 1 else "singola posizione")
    r["lunghi_corti"] = (int((tr.side == "buy").sum()), int((tr.side == "sell").sum()))
    hold = (tr.close_time - tr.open_time).dt.total_seconds() / 3600
    r["tenuta_ore"] = dict(media=round(hold.mean(), 1), mediana=round(hold.median(), 1), max=round(hold.max(), 1))
    r["ore_apertura"] = tr.open_time.dt.hour.value_counts().sort_index().to_dict()
    r["giorni_settimana_apertura"] = tr.open_time.dt.dayofweek.value_counts().sort_index().to_dict()
    if tf_minutes:
        on = ((tr.open_time.dt.hour * 60 + tr.open_time.dt.minute) % tf_minutes == 0) & (tr.open_time.dt.second == 0)
        r["aperture_a_inizio_candela_%"] = round(100 * on.mean(), 1)
    r["sl_presente_%"] = round(100 * tr.sl.notna().mean(), 1); r["tp_presente_%"] = round(100 * tr.tp.notna().mean(), 1)
    sld = (tr.open_price - tr.sl).abs().where(tr.sl.notna())
    if sld.notna().any():
        r["distanza_sl"] = dict(media=round(sld.mean(), 2), cv=round(sld.std() / sld.mean(), 2) if sld.mean() else None)
        r["lotti_vs_1/sl_correlazione"] = round(float(np.corrcoef(tr.volume[sld.notna()], 1 / sld.dropna())[0, 1]), 2) if sld.notna().sum() > 3 else None
    cv = tr.volume.std() / tr.volume.mean() if tr.volume.mean() else 0
    r["lotti"] = dict(min=tr.volume.min(), max=tr.volume.max(), cv=round(float(cv), 3), tipo=("fisso" if cv < 1e-3 else "variabile"))
    win = (tr.profit + tr.swap + tr.commission) > 0
    after_loss = tr.volume.shift(-1)[~win]; after_win = tr.volume.shift(-1)[win]
    if len(after_loss.dropna()) and len(after_win.dropna()) and after_win.mean() > 0:
        r["lotti_dopo_perdita/dopo_vincita"] = round(float(after_loss.mean() / after_win.mean()), 2)
    mv = (tr.close_price != tr.sl) & tr.sl.notna()
    r["uscite_diverse_dallo_sl_iniziale_%"] = round(100 * mv.mean(), 1) if tr.sl.notna().any() else None
    r["commenti_chiusura"] = tr.comment_close.str.replace(r"[\d.]+", "#", regex=True).value_counts().head(5).to_dict()
    return r
