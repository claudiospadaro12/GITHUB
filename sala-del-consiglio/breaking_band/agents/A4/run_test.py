#!/usr/bin/env python3
"""run_test.py — produce TUTTE le tabelle di disegno_test_v1.md e il verdetto di criteri_previsioni_v1.md (Parte B).

USO (lo eseguira C0 sui dati reali dopo aver congelato l'hash del codice):
    python3 -I run_test.py --dir <cartella_dei_4_CSV> --out <prefisso_output> \
        [--congelati <cartella congelati>] [--hash-dati <HASH_DATI.txt>] [--parte-a NON_VALUTATA|VERIFICATO|NON_VERIFICATO]

Scrive <prefisso>.json (tabelle + intestazione con parametri e sha256 dei file letti, SENZA timestamp:
due esecuzioni identiche danno lo stesso sha256 dei risultati) e <prefisso>.md.

NESSUN valore numerico di soglia e' definito qui: tutto viene da params.py (PARAMS, DISEGNO, SENSIBILITA).
Le opzioni --prova / --solo-h1 / --placebo-* servono SOLO ai test su dati sintetici e vengono segnate
nell'intestazione come NON CONGELATE.
"""
from __future__ import annotations

import argparse
import hashlib
import json
import math
import os
import sys
import time

sys.path.insert(0, os.path.dirname(os.path.abspath(__file__)))   # con python3 -I la cartella dello script non e' nel path

import numpy as np  # noqa: E402

import engine as E  # noqa: E402
import signals as S
from params import (ATTESE_RIGHE, DESCRITTORI_A2, DISEGNO, PARAMS, PUNTI_NOTI, SENSIBILITA, SIMBOLO_DEFAULT,
                    file_periodi, parametri, ricalcolo_barre)

TF_NOME = {60: "H1", 30: "M30"}
VARIANTI = S.VARIANTI


# =============================================================================== utilita'
def sha256_file(path: str) -> str:
    h = hashlib.sha256()
    with open(path, "rb") as f:
        for blk in iter(lambda: f.read(1 << 20), b""):
            h.update(blk)
    return h.hexdigest()


def pulisci(x):
    """Rende serializzabile (no NaN/inf, no numpy)."""
    if isinstance(x, dict):
        return {str(k): pulisci(v) for k, v in x.items()}
    if isinstance(x, (list, tuple)):
        return [pulisci(v) for v in x]
    if isinstance(x, np.bool_):
        return bool(x)
    if isinstance(x, np.integer):
        return int(x)
    if isinstance(x, (np.floating, float)):
        v = float(x)
        if math.isnan(v):
            return None
        if math.isinf(v):
            return "inf" if v > 0 else "-inf"
        return v
    return x


def canon(obj) -> str:
    return json.dumps(pulisci(obj), sort_keys=True, ensure_ascii=True, allow_nan=False, separators=(",", ":"))


def pf_di(R) -> float:
    R = np.asarray(R, dtype=np.float64)
    g = float(R[R > 0].sum())
    p = float(-R[R < 0].sum())
    if p == 0:
        return float("inf") if g > 0 else float("nan")
    return g / p


def wilson(k: int, n: int, z: float):
    if n == 0:
        return (None, None)
    ph = k / n
    den = 1 + z * z / n
    c = (ph + z * z / (2 * n)) / den
    h = z * math.sqrt(ph * (1 - ph) / n + z * z / (4 * n * n)) / den
    return (c - h, c + h)


# =============================================================================== dati
class Periodo:
    def __init__(self, idx: int, nome: str, path: str):
        self.idx, self.nome, self.path = idx, nome, path
        self.sha = sha256_file(path)
        m = E.carica(path)
        self.m1_orig_info = dict(m.info)
        self.m1 = E.sostituisci_spread_zero(m)          # specifica 6.9
        self._serie: dict = {}

    def serie(self, tf: int):
        if tf not in self._serie:
            b = E.costruisci_barre(self.m1, tf)
            self._serie[tf] = (b, E.indicatori(b))
        return self._serie[tf]


def settimana(t_min: int) -> int:
    return int((t_min // 1440 + 3) // 7)


def kw_engine(prm: dict, tf: int) -> dict:
    return dict(stop_atr=prm["STOP_ATR"], maxhold=prm["MAXHOLD"], ricalcolo_ogni=ricalcolo_barre(tf, prm),
                punto=prm["PUNTO"], max_gap_ingresso_min=prm["MAX_GAP_INGRESSO_MIN"],
                target_gap_improve=prm["FILL_TARGET_MIGLIORE"])


def d_atr(t: dict) -> float:
    return abs(t["target0"] - t["entry"]) / t["atr"]


def arricchisci(t: dict, sig: dict, per: Periodo, var: str, tf: int, prm: dict) -> dict:
    t = dict(t)
    S_ = prm["STOP_ATR"]
    t["periodo"], t["variante"], t["tf"] = per.nome, var, TF_NOME[tf]
    t["ord"] = per.idx * 10 ** 10 + t["entry_time"]
    D = d_atr(t)
    c = t["spread_ingresso"] / t["atr"]
    t["D_atr"], t["c_atr"] = D, c
    t["wr0_i"] = S_ / (S_ + D)
    t["pareggio_costo_i"] = (S_ + c) / (S_ + D)
    t["dist_banda_atr"] = abs(t["entry"] - sig["livello_banda"]) / t["atr"]
    t["ora_ingresso"] = int((t["entry_time"] // 60) % 24)
    t["settimana"] = settimana(t["entry_time"])
    for k in ("n_prev_classe", "fascia", "solidita", "congestione", "checklist_stretta", "contatto", "bonus",
              "dp", "episodio", "penetrazione_lt_spread", "rientro_ge_80", "invalidazioni_A2"):
        t[k] = sig[k]
    return t


def run_scenario(periodi, tf: int, prm: dict, varianti=VARIANTI, tieni_ris=True) -> dict:
    """Segnali + simulazione, per periodo e variante. Ritorna {(nome_periodo, var): {...}}."""
    out = {}
    for per in periodi:
        m1 = per.m1 if prm["SPREAD_MOLT"] == 1 else E.scala_spread(per.m1, prm["SPREAD_MOLT"])
        barre, ind = per.serie(tf)
        sp_bar = S.spread_barre(m1, barre, prm["PUNTO"]) if prm["TOCCO_PEN_SPREAD"] else None
        for var in varianti:
            res = S.rileva(barre, ind, var, prm, sp_bar)
            mappa = {s["j"]: s for s in res["segnali"]}
            trades, cont = E.esegui_segnali(m1, barre, ind, [(s["j"], s["side"]) for s in res["segnali"]],
                                            **kw_engine(prm, tf))
            tr = [arricchisci(t, mappa[t["j"]], per, var, tf, prm) for t in trades]
            out[(per.nome, var)] = {"res": res, "trades": tr, "cont": cont}
    return out


# =============================================================================== statistiche
def stat_cella(trades: list, prm: dict) -> dict:
    n = len(trades)
    if n == 0:
        return {"n": 0, "per_motivo": {}}
    st = E.statistiche([dict(t, entry_m1=t["ord"]) for t in trades])
    R = np.array([t["R"] for t in sorted(trades, key=lambda t: t["ord"])])
    wins = int((R > 0).sum())
    wr0 = float(np.mean([t["wr0_i"] for t in trades]))
    se = math.sqrt(wr0 * (1 - wr0) / n)
    wr = wins / n
    st.update({
        "vincite": wins, "mediana_R": float(np.median(R)),
        "costo_spread_medio_R": float(np.mean([t["costo_spread_R"] for t in trades])),
        "D_medio_atr": float(np.mean([t["D_atr"] for t in trades])),
        "pareggio_atteso_medio_pct": 100.0 * float(np.mean([t["pareggio_costo_i"] for t in trades])),
        "wr0_pct": 100.0 * wr0, "wr_eccesso_punti": 100.0 * (wr - wr0), "wr_eccesso_se_punti": 100.0 * se,
        "durata_mediana_barre": float(np.median([t["durata_barre"] for t in trades])),
        "durata_max_barre": int(max(t["durata_barre"] for t in trades)),
        "quota_long": float(np.mean([t["side"] == 1 for t in trades])),
        "eventi_sl_tp_stesso_minuto": int(sum(1 for t in trades if t["sl_e_tp_stesso_minuto"])),
        "trade_spread0_ingresso_o_uscita": int(sum(1 for t in trades if t["spread0_ingresso"] or t["spread0_uscita"])),
        "ricalcoli_target": int(sum(t["n_agg_target"] for t in trades)),
        "uscite_fine_dati_o_mercato": int(sum(1 for t in trades if t["motivo"] in ("FINE_DATI", "MKT"))),
    })
    return st


def riga_gruppo(trades: list, prm: dict) -> dict:
    """Sotto-gruppi: n<10 solo n; 10<=n<30 conteggi e medie descrittive (NO IC/PF); n>=30 completo."""
    n = len(trades)
    if n == 0:
        return {"n": 0}
    R = np.array([t["R"] for t in trades])
    wins = int((R > 0).sum())
    r = {"n": n, "vincite": wins, "long": int(sum(1 for t in trades if t["side"] == 1))}
    if n < 10:
        return r
    wr0 = float(np.mean([t["wr0_i"] for t in trades]))
    r.update({"wr_pct": 100.0 * wins / n, "media_R": float(R.mean()), "wr0_pct": 100.0 * wr0})
    if n >= 30:
        lo, hi = wilson(wins, n, DISEGNO["WILSON_Z90"])
        r.update({"wilson90_lo_pct": 100.0 * lo, "wilson90_hi_pct": 100.0 * hi, "pf_netto": pf_di(R)})
    else:
        r["nota"] = "N<30: solo descrittivo"
    return r


def bootstrap_settimane(trades: list, n_boot: int, seed: int, alpha: float):
    if not trades:
        return None
    sett = sorted(set(t["settimana"] for t in trades))
    idx = {w: k for k, w in enumerate(sett)}
    somma = np.zeros(len(sett))
    cnt = np.zeros(len(sett))
    for t in trades:
        k = idx[t["settimana"]]
        somma[k] += t["R"]
        cnt[k] += 1
    rng = np.random.default_rng(seed)
    K = len(sett)
    sel = rng.integers(0, K, size=(n_boot, K))
    m = somma[sel].sum(axis=1) / cnt[sel].sum(axis=1)
    lo, hi = np.quantile(m, [alpha, 1 - alpha])
    return {"settimane": K, "media": float(somma.sum() / cnt.sum()), "ic90_lo": float(lo), "ic90_hi": float(hi),
            "n_replicati": n_boot}


# =============================================================================== linee di base
def pool_barre(per: Periodo, tf: int, prm: dict, segnali_set: set, finestre_set: set) -> dict:
    """Simula UNA volta ogni barra idonea (lato per lato) con il motore. Ritorna array per lato."""
    m1 = per.m1 if prm["SPREAD_MOLT"] == 1 else E.scala_spread(per.m1, prm["SPREAD_MOLT"])
    barre, ind = per.serie(tf)
    kw = kw_engine(prm, tf)
    sd, s50, lag = ind.std20, ind.std20_sma50, prm["SD_LAG"]
    out = {1: [], -1: []}
    for j in range(prm["WARMUP"], barre.n - 1):
        if not (math.isfinite(ind.atr14[j]) and math.isfinite(ind.sma20[j])):
            continue
        vol = bool(sd[j] < s50[j] and sd[j] <= sd[j - lag])
        for side in (1, -1):
            t = E.simula_trade(m1, barre, ind, j, side, **kw)
            if t["eseguito"]:
                out[side].append((j, t["R"], d_atr(t), vol, j in segnali_set, j in finestre_set))
    res = {}
    for side, lst in out.items():
        a = np.array(lst, dtype=np.float64).reshape(-1, 6)
        res[side] = {"j": a[:, 0].astype(np.int64), "R": a[:, 1], "D": a[:, 2], "vol": a[:, 3] > 0.5,
                     "sig": a[:, 4] > 0.5, "win": a[:, 5] > 0.5}
    return res


def baseline(trades: list, pools: dict, tipo: str, n_draw: int, seed: int) -> dict:
    """tipo B0 | B1 | B2. trades: trade primari (ordine deterministico). Ritorna matrice di estrazioni e maschere."""
    rng = np.random.default_rng(seed)
    M = np.full((n_draw, len(trades)), np.nan)
    mancanti = 0
    for i, t in enumerate(trades):
        pl = pools[t["periodo"]][t["side"]]
        m = (pl["D"] >= DISEGNO["B1_D_MIN"] * t["D_atr"]) & (pl["D"] <= DISEGNO["B1_D_MAX"] * t["D_atr"]) & ~pl["sig"]
        if tipo == "B1":
            m &= pl["vol"]
        elif tipo == "B2":
            m &= pl["win"]
        idx = np.flatnonzero(m)
        if idx.size == 0:
            mancanti += 1
            continue
        M[:, i] = pl["R"][idx[rng.integers(0, idx.size, size=n_draw)]]
    return {"M": M, "mancanti": mancanti}


def sintesi_baseline(trades: list, bl: dict, mask: np.ndarray) -> dict:
    cols = np.flatnonzero(mask)
    M = bl["M"][:, cols]
    ok = ~np.isnan(M[0]) if cols.size else np.zeros(0, dtype=bool)
    n_ok = int(ok.sum())
    if n_ok == 0:
        return {"n_trade": int(cols.size), "n_abbinati": 0}
    Mo = M[:, ok]
    sel = [trades[c] for c, o in zip(cols, ok) if o]
    obs = float(np.mean([t["R"] for t in sel]))
    nulla = Mo.mean(axis=1)
    pos = np.where(Mo > 0, Mo, 0.0).sum(axis=1)
    neg = -np.where(Mo < 0, Mo, 0.0).sum(axis=1)
    with np.errstate(divide="ignore", invalid="ignore"):
        pfn = np.where(neg > 0, pos / neg, np.inf)
        pf_p50 = float(np.quantile(pfn, 0.50))
    n_draw = M.shape[0]
    return {"n_trade": int(cols.size), "n_abbinati": n_ok, "media_osservata_R": obs,
            "media_nulla": float(nulla.mean()), "p5": float(np.quantile(nulla, 0.05)),
            "p50": float(np.quantile(nulla, 0.50)), "p95": float(np.quantile(nulla, 0.95)),
            "percentile_osservato": float((nulla < obs).mean()),
            "p_B": float((1 + int((nulla >= obs).sum())) / (n_draw + 1)),
            "pf_nullo_p50": pf_p50,
            "pf_osservato": pf_di([t["R"] for t in sel])}


def tabella_baseline(trades: list, bl: dict) -> dict:
    out = {"mancanti_senza_abbinamento": bl["mancanti"]}
    def mask(f):
        return np.array([bool(f(t)) for t in trades], dtype=bool)
    out["pooled"] = sintesi_baseline(trades, bl, np.ones(len(trades), dtype=bool))
    for v in VARIANTI:
        out["variante_" + v] = sintesi_baseline(trades, bl, mask(lambda t: t["variante"] == v))
    for nome in sorted(set(t["periodo"] for t in trades)):
        out["periodo_" + nome] = sintesi_baseline(trades, bl, mask(lambda t: t["periodo"] == nome))
    out["lato_long"] = sintesi_baseline(trades, bl, mask(lambda t: t["side"] == 1))
    out["lato_short"] = sintesi_baseline(trades, bl, mask(lambda t: t["side"] == -1))
    return out


# =============================================================================== placebo
def genera_placebo_m1(rng, n_min: int, prezzo0: float, spread_pt: float, t0: int, sott: int,
                      vol_h: float) -> E.M1:
    """M1 sintetico a deriva zero, volatilita raggruppata (GARCH(1,1) sull'ora), percorso con `sott` sotto-passi
    per minuto (high/low = estremi del percorso). Prezzi BID, spread costante (in punti). prezzo0 e vol_h (sd oraria)
    in unita di prezzo: il chiamante li ricava da costanti in PUNTI del simbolo (DISEGNO.PLACEBO_*_PUNTI * PUNTO)."""
    D = DISEGNO
    n_h = n_min // 60 + 1
    v0 = vol_h ** 2
    omega = v0 * (1.0 - D["GARCH_ALPHA"] - D["GARCH_BETA"])
    e = rng.standard_normal(n_h)
    v = np.empty(n_h)
    vk = v0
    for k in range(n_h):
        v[k] = vk
        vk = omega + D["GARCH_ALPHA"] * (e[k] ** 2) * vk + D["GARCH_BETA"] * vk
    vm = np.repeat(v, 60)[:n_min]
    sub = rng.standard_normal((n_min, sott)) * np.sqrt(vm / (60.0 * sott))[:, None]
    cum = prezzo0 + np.cumsum(sub.reshape(-1)).reshape(n_min, sott)
    start = np.concatenate(([prezzo0], cum[:-1, -1]))
    pts = np.concatenate((start[:, None], cum), axis=1)
    t = t0 + np.arange(n_min, dtype=np.int64)
    return E.costruisci_m1(t, pts[:, 0], pts.max(axis=1), pts.min(axis=1), pts[:, -1], np.full(n_min, spread_pt))


def placebo(prm: dict, tfs, target: int, max_anni: int, seed: int) -> dict:
    D = DISEGNO
    chiavi = [(v, tf) for tf in tfs for v in VARIANTI]
    acc = {k: [] for k in chiavi}
    t0 = 60 * 24 * 1000
    chunk = 0
    while chunk < max_anni and any(len(acc[k]) < target for k in chiavi):
        rng = np.random.default_rng(seed + chunk)
        m1 = genera_placebo_m1(rng, D["PLACEBO_MIN_PER_ANNO"], D["PLACEBO_PREZZO_PUNTI"] * prm["PUNTO"],
                               D["PLACEBO_SPREAD_PUNTI"], t0, D["PLACEBO_SOTTOPASSI"],
                               D["PLACEBO_VOL_H_PUNTI"] * prm["PUNTO"])
        for tf in tfs:
            barre = E.costruisci_barre(m1, tf)
            ind = E.indicatori(barre)
            for var in VARIANTI:
                if len(acc[(var, tf)]) >= target:
                    continue
                res = S.rileva(barre, ind, var, prm, None)
                tr, _ = E.esegui_segnali(m1, barre, ind, [(s["j"], s["side"]) for s in res["segnali"]],
                                         **kw_engine(prm, tf))
                acc[(var, tf)].extend(tr)
        chunk += 1
    out = {}
    for (var, tf), tr in acc.items():
        n = len(tr)
        r = {"n": n, "anni_sintetici": chunk}
        if n >= 2:
            g = np.array([t["R_lordo"] for t in tr])
            nt = np.array([t["R"] for t in tr])
            sd = float(g.std(ddof=1))
            z = float(g.mean() / (sd / math.sqrt(n))) if sd > 0 else float("nan")
            r.update({"lordo_medio_R": float(g.mean()), "z_lordo": z, "netto_medio_R": float(nt.mean()),
                      "costo_medio_R": float(np.mean([t["costo_spread_R"] for t in tr])),
                      "esito": ("NON_CONCLUSIVO_N<%d" % D["PLACEBO_N_MIN"]) if n < D["PLACEBO_N_MIN"]
                      else ("SUPERATO" if abs(z) <= D["PLACEBO_Z_MAX"] else "FALLITO")})
        else:
            r["esito"] = "NON_CONCLUSIVO_N<2"
        out["%s_%s" % (var, TF_NOME[tf])] = r
    return out


def placebo_blocchi(periodi, prm: dict, tf: int, n_riman: int, seed: int) -> dict:
    """Esplorativo: M1 reali rimescolati a blocchi (PLACEBO_BLOCCO minuti), conserva distribuzione e raggruppamento
    di volatilita', distrugge la struttura locale. Ritorna media R netta (H1 pooled CONT+INV) per rimescolamento."""
    rng = np.random.default_rng(seed)
    B = DISEGNO["PLACEBO_BLOCCO"]
    medie, ns = [], []
    for r in range(n_riman):
        tr_all = []
        for per in periodi:
            m = per.m1
            n = m.n
            gap = m.o - np.concatenate(([m.o[0]], m.c[:-1]))
            rh, rl, rc = m.h - m.o, m.l - m.o, m.c - m.o
            nb = (n + B - 1) // B
            ordine = rng.permutation(nb)
            idx = np.concatenate([np.arange(k * B, min((k + 1) * B, n)) for k in ordine])
            g = gap[idx]
            step = g + rc[idx]                       # c_new[k] - c_new[k-1] = gap_k + (close-open)_k
            step[0] = rc[idx[0]]
            c_new = m.o[0] + np.cumsum(step)
            o_new = np.empty(n)
            o_new[0] = m.o[0]
            o_new[1:] = c_new[:-1] + g[1:]
            sh = E.M1(t=m.t, o=o_new, h=o_new + rh[idx], l=o_new + rl[idx], c=o_new + rc[idx], tv=m.tv,
                      sp=m.sp[idx], info={}, sp_sost=None)
            p2 = Periodo.__new__(Periodo)
            p2.idx, p2.nome, p2.path, p2.sha, p2.m1_orig_info, p2.m1, p2._serie = per.idx, per.nome, per.path, "", {}, sh, {}
            ris = run_scenario([p2], tf, prm)
            for (_, var), v in ris.items():
                tr_all.extend(v["trades"])
        medie.append(float(np.mean([t["R"] for t in tr_all])) if tr_all else float("nan"))
        ns.append(len(tr_all))
    arr = np.array([x for x in medie if not math.isnan(x)])
    return {"n_rimescolamenti": n_riman, "n_trade_medio": float(np.mean(ns)) if ns else 0.0,
            "media_R_media": float(arr.mean()) if arr.size else None,
            "p5": float(np.quantile(arr, 0.05)) if arr.size else None,
            "p95": float(np.quantile(arr, 0.95)) if arr.size else None}


# =============================================================================== imbuto
def tabella_imbuto(ris_cella: dict, nomi_stadi: list, cont: dict) -> dict:
    ep = ris_cella["res"]["imbuto_episodi"]
    c = ep["conteggi"]
    righe = []
    flag = []
    for k, nome in enumerate(ep["stadi"]):
        pct = (100.0 * c[k] / c[k - 1]) if k > 0 and c[k - 1] > 0 else None
        morti = ep["morti"].get(nome, {})
        causa = max(sorted(morti), key=lambda x: morti[x]) if morti else None
        righe.append({"stadio": nome, "n": c[k], "pct_cond_stadio_prec": pct, "morti_qui": dict(morti),
                      "causa_principale": causa})
        if k + 1 < len(c) and c[k] > 0 and (c[k] - c[k + 1]) / c[k] > DISEGNO["DIAGNOSTICA_QUASI_AUTOCOLPENTE"]:
            flag.append({"stadio_che_elimina": ep["stadi"][k + 1], "da": c[k], "a": c[k + 1]})
    scartati = sum(v for kk, v in cont.items() if kk.startswith("scartati_"))
    return {"stadi": righe, "filtro_quasi_autocolpente": flag,
            "armati_per_direzione": ris_cella["res"]["armati"], "fine_episodi": ris_cella["res"]["fine_episodi"],
            "extra": ris_cella["res"]["extra"], "imbuto_barre_criteri_B": ris_cella["res"]["imbuto_barre"],
            "barre_valide": ris_cella["res"]["barre_valide"],
            "segnali_e_trade": dict(cont, riconciliato=bool(cont["segnali"] == cont["eseguiti"] + scartati
                                                            and cont["segnali"] == len(ris_cella["res"]["segnali"]))),
            }


def somma_imbuti(lista: list) -> dict:
    """Somma gli imbuti di piu' periodi (stessi stadi)."""
    stadi = lista[0]["res"]["imbuto_episodi"]["stadi"]
    c = np.sum([x["res"]["imbuto_episodi"]["conteggi"] for x in lista], axis=0)
    morti: dict = {}
    for x in lista:
        for st, d in x["res"]["imbuto_episodi"]["morti"].items():
            for kk, v in d.items():
                morti.setdefault(st, {})
                morti[st][kk] = morti[st].get(kk, 0) + v
    arm = {"+1": sum(x["res"]["armati"]["+1"] for x in lista), "-1": sum(x["res"]["armati"]["-1"] for x in lista)}
    fine: dict = {}
    for x in lista:
        for kk, v in x["res"]["fine_episodi"].items():
            fine[kk] = fine.get(kk, 0) + v
    extra: dict = {}
    for x in lista:
        for kk, v in x["res"]["extra"].items():
            extra[kk] = extra.get(kk, 0) + v
    cont: dict = {}
    for x in lista:
        for kk, v in x["cont"].items():
            cont[kk] = cont.get(kk, 0) + v
    nseg = sum(len(x["res"]["segnali"]) for x in lista)
    fake = {"res": {"imbuto_episodi": {"stadi": stadi, "conteggi": [int(v) for v in c], "morti": morti},
                    "armati": arm, "fine_episodi": fine, "extra": extra, "imbuto_barre": {},
                    "barre_valide": sum(x["res"]["barre_valide"] for x in lista), "segnali": [0] * nseg}}
    return tabella_imbuto(fake, stadi, cont)


# =============================================================================== verdetto
def verdetto(N, m, pf, p_b1, ic, lopo_ok, sd_ok, parte_a) -> dict:
    D = DISEGNO
    note = []
    if parte_a == "NON_VERIFICATO" or N < D["N_INCONCLUSIVO"]:
        esito = "INCONCLUSIVO"
    else:
        cond = {"m>0": m is not None and m > 0, "p_B1<=0.05": p_b1 is not None and p_b1 <= D["P_B1_MAX"],
                "PF>=1.15": pf is not None and pf >= D["PF_MIN"], "leave_one_period_out": bool(lopo_ok),
                "spread_x1.5_media>0": bool(sd_ok)}
        if all(cond.values()):
            esito = "INDIZIO DI VANTAGGIO"
        elif ic is not None and ic["ic90_hi"] < D["EPS_R"]:
            esito = "NESSUN VANTAGGIO RILEVANTE"
        else:
            esito = "NON DIMOSTRATO"
            if cond["p_B1<=0.05"]:
                note.append("p_B1<=0.05 ma le altre condizioni non valgono: NON DIMOSTRATO (nota 1)")
            if cond["m>0"] and not cond["p_B1<=0.05"]:
                note.append("redditizio ma non attribuibile al pattern (geometria/deriva) (nota 2)")
        note.append("condizioni INDIZIO: " + json.dumps(cond, sort_keys=True))
    livello = None if esito == "INCONCLUSIVO" else ("PRELIMINARE" if N < D["N_PIENO"] else "PIENO")
    return {"esito": esito, "livello": livello, "N": N, "media_R": m, "pf_netto": pf, "p_B1": p_b1,
            "ic90": ic, "eps_R": D["EPS_R"], "parte_A": parte_a,
            "condizionale_a_parte_A": parte_a == "NON_VALUTATA", "note": note}


# =============================================================================== principale
def raggruppa(trades, f):
    out: dict = {}
    for t in trades:
        out.setdefault(f(t), []).append(t)
    return out


def esegui(args):
    salvato = dict(DISEGNO)
    try:
        return _esegui(args)
    finally:
        DISEGNO.clear()
        DISEGNO.update(salvato)


def _esegui(args):
    t_start = time.time()
    prm = dict(PARAMS)
    if args.prova:
        pr = json.loads(args.prova)
        prm.update(pr.get("PARAMS", {}))
        DISEGNO.update(pr.get("DISEGNO", {}))
    simbolo = args.simbolo or SIMBOLO_DEFAULT
    if args.punto is not None:
        prm["PUNTO"] = args.punto
    elif simbolo in PUNTI_NOTI:
        prm["PUNTO"] = PUNTI_NOTI[simbolo]
    elif not (args.prova and "PUNTO" in json.loads(args.prova).get("PARAMS", {})):
        raise SystemExit("simbolo %s senza punto noto: indicare --punto" % simbolo)
    attese = ATTESE_RIGHE if simbolo == SIMBOLO_DEFAULT else {}
    prova = bool(args.prova or args.solo_h1 or args.placebo_target is not None
                 or args.placebo_max_anni is not None)
    if args.placebo_target is not None:
        DISEGNO["PLACEBO_TARGET_SEGNALI"] = args.placebo_target
    if args.placebo_max_anni is not None:
        DISEGNO["PLACEBO_MAX_ANNI"] = args.placebo_max_anni
    # ---- periodi
    mapping = {}
    if args.periodi:
        for x in args.periodi:
            k, v = x.split("=", 1)
            mapping[k] = v
    else:
        mapping = {k: os.path.join(args.dir, v) for k, v in file_periodi(simbolo).items()}
    periodi = [Periodo(i, k, v) for i, (k, v) in enumerate(mapping.items())]
    tfs = [prm["TF_PRIMARIO"]] if args.solo_h1 else [prm["TF_PRIMARIO"], prm["TF_ESPLORATIVO"]]
    # ---- intestazione
    base = os.path.dirname(os.path.abspath(__file__))
    codice = {f: sha256_file(os.path.join(base, f)) for f in ("engine.py", "signals.py", "params.py", "run_test.py")}
    docs = {}
    if args.congelati:
        for f in ("specifica_v1.md", "disegno_test_v1.md", "criteri_previsioni_v1.md"):
            p = os.path.join(args.congelati, f)
            if os.path.exists(p):
                docs[f] = sha256_file(p)
    hash_dati_ok = None
    if args.hash_dati:
        att = {}
        for ln in open(args.hash_dati):
            if ln.strip():
                h, f = ln.split()
                att[f] = h
        hash_dati_ok = {os.path.basename(p.path): att.get(os.path.basename(p.path)) == p.sha for p in periodi}
    intest = {
        "parametri": {k: prm[k] for k in sorted(prm)}, "disegno": {k: DISEGNO[k] for k in sorted(DISEGNO)},
        "sensibilita": SENSIBILITA, "tf": [TF_NOME[t] for t in tfs],
        "sha256_csv": {p.nome: p.sha for p in periodi}, "righe_csv": {p.nome: p.m1_orig_info["righe_finali"] for p in periodi},
        "simbolo": simbolo, "punto": prm["PUNTO"],
        "righe_attese_A3": {p.nome: attese.get(p.nome) for p in periodi},
        "righe_coincidono_con_A3": {p.nome: (p.m1_orig_info["righe_finali"] == attese.get(p.nome))
                                    if p.nome in attese else None for p in periodi},
        "sha256_codice": codice, "sha256_documenti_congelati": docs, "hash_dati_coincidono": hash_dati_ok,
        "python": sys.version.split()[0], "numpy": np.__version__,
        "PARAMETRI_NON_CONGELATI_PROVA": prova,
        "parte_A": args.parte_a, "baseline_su": "H1 (primaria)",
        "sensibilita_eseguite_su": "H1 pooled CONT+INV",
        "placebo_blocchi_rimescolamenti": args.placebo_blocchi,
        "convenzioni": "prezzi BID, ask=bid+spread; stop 3 ATR da fill; target SMA20 ricalcolato ogni 3 ore; "
                       "fill target AL LIVELLO, stop all'apertura se peggiore; stop prima del target; "
                       "ingresso all'apertura della barra dopo; max gap 180 min; maxhold 1000; spread0->mediana periodo/ora",
    }
    T: dict = {}
    # ---- scenario base per TF
    base_ris = {tf: run_scenario(periodi, tf, prm) for tf in tfs}
    primario = [t for per in periodi for var in VARIANTI for t in base_ris[prm["TF_PRIMARIO"]][(per.nome, var)]["trades"]]
    primario.sort(key=lambda t: (t["ord"], t["variante"]))
    # ---- T1 imbuto
    T1: dict = {}
    for tf in tfs:
        for var in VARIANTI:
            lst = [base_ris[tf][(per.nome, var)] for per in periodi]
            nome = "%s_%s" % (var, TF_NOME[tf])
            T1[nome] = {per.nome: tabella_imbuto(base_ris[tf][(per.nome, var)], None, base_ris[tf][(per.nome, var)]["cont"])
                        for per in periodi}
            T1[nome]["TOTALE"] = somma_imbuti(lst)
    T["T1_imbuto"] = T1
    # ---- T2 risultati
    T2: dict = {}
    for tf in tfs:
        for var in VARIANTI:
            for per in periodi:
                tr = base_ris[tf][(per.nome, var)]["trades"]
                T2["%s_%s_%s" % (var, TF_NOME[tf], per.nome)] = stat_cella(tr, prm)
            tr = [t for per in periodi for t in base_ris[tf][(per.nome, var)]["trades"]]
            T2["%s_%s_TOTALE" % (var, TF_NOME[tf])] = stat_cella(tr, prm)
        tr = [t for per in periodi for var in VARIANTI for t in base_ris[tf][(per.nome, var)]["trades"]]
        T2["POOLED_%s" % TF_NOME[tf]] = stat_cella(tr, prm)
    T["T2_risultati"] = T2
    # ---- T3 fasce (H1 pooled e per variante)
    T3: dict = {}
    gruppi = {
        "fascia": lambda t: t["fascia"],
        "fascia_accorpata": lambda t: ">=70" if t["solidita"] >= DISEGNO["SOLIDITA_ACCORPATA"] else "<70",
        "n_prev": lambda t: ["0", "1", ">=2"][t["n_prev_classe"]],
        "congestione_valida": lambda t: "si" if t["congestione"] else "no",
        "checklist_stretta": lambda t: "si" if t["checklist_stretta"] else "no",
        "lato": lambda t: "long" if t["side"] == 1 else "short",
        "periodo": lambda t: t["periodo"],
        "fascia_oraria_server": lambda t: next("%d-%d" % (a, b) for a, b in DISEGNO["FASCE_ORA"]
                                                if a <= t["ora_ingresso"] <= b),
    }
    for nome_set, sel in (("pooled", lambda t: True), ("CONT", lambda t: t["variante"] == "CONT"),
                          ("INV", lambda t: t["variante"] == "INV")):
        sub = [t for t in primario if sel(t)]
        T3[nome_set] = {g: {k: riga_gruppo(v, prm) for k, v in sorted(raggruppa(sub, f).items())}
                        for g, f in gruppi.items()}
    T3["prob_checklist_pct"] = {k: list(v) for k, v in DISEGNO["PROB_CHECKLIST"].items()}
    T["T3_fasce"] = T3
    # ---- T4 linee di base (H1)
    tf0 = prm["TF_PRIMARIO"]
    segnali_set = {per.nome: set() for per in periodi}
    finestre_set = {per.nome: set() for per in periodi}
    for per in periodi:
        for var in VARIANTI:
            r = base_ris[tf0][(per.nome, var)]["res"]
            segnali_set[per.nome].update(s["j"] for s in r["segnali"])
            for e in r["episodi"]:
                finestre_set[per.nome].update(e["finestre"])
    pools = {per.nome: pool_barre(per, tf0, prm, segnali_set[per.nome], finestre_set[per.nome]) for per in periodi}
    T4: dict = {"nota": "H1, trade primari CONT+INV; B1 primaria (ipotesi nulla), B0 e B2 esplorative; "
                        "estrazioni %d, seed %d" % (DISEGNO["N_ESTRAZIONI"], DISEGNO["SEED"])}
    bls = {}
    for tipo in ("B1", "B0", "B2"):
        bls[tipo] = baseline(primario, pools, tipo, DISEGNO["N_ESTRAZIONI"], DISEGNO["SEED"])
        T4[tipo] = tabella_baseline(primario, bls[tipo]) if primario else {}
    T4["pool_barre_simulate"] = {per.nome: {("long" if s == 1 else "short"): int(pools[per.nome][s]["R"].size)
                                           for s in (1, -1)} for per in periodi}
    T["T4_linea_di_base"] = T4
    # ---- T6 sensibilita (H1 pooled)
    T6: dict = {}
    sens_trades = {}
    for nome, ov in SENSIBILITA.items():
        prm_s = dict(prm)
        prm_s.update(ov)
        ris = run_scenario(periodi, tf0, prm_s)
        tr = [t for per in periodi for var in VARIANTI for t in ris[(per.nome, var)]["trades"]]
        sens_trades[nome] = tr
        T6[nome] = {"override": ov, "pooled": stat_cella(tr, prm_s),
                    "per_variante": {v: stat_cella([t for t in tr if t["variante"] == v], prm_s) for v in VARIANTI},
                    "segnali": sum(ris[(per.nome, var)]["cont"]["segnali"] for per in periodi for var in VARIANTI),
                    "episodi_armati": sum(ris[(per.nome, "CONT")]["res"]["armati"]["+1"]
                                          + ris[(per.nome, "CONT")]["res"]["armati"]["-1"] for per in periodi)}
    T["T6_sensibilita"] = T6
    # ---- T5 robustezza
    T5: dict = {}
    if primario:
        R = np.array([t["R"] for t in primario])
        T5["bootstrap_settimane"] = bootstrap_settimane(primario, DISEGNO["N_BOOTSTRAP"], DISEGNO["SEED"],
                                                        DISEGNO["IC_ALPHA"])
        top = sorted(primario, key=lambda t: -t["R"])
        resto = top[DISEGNO["TOP_TRADE_ESCLUSI"]:]
        T5["senza_i_migliori_%d" % DISEGNO["TOP_TRADE_ESCLUSI"]] = {
            "n": len(resto), "media_R": float(np.mean([t["R"] for t in resto])) if resto else None,
            "pf_netto": pf_di([t["R"] for t in resto]) if resto else None}
        T5["con_tutti"] = {"n": len(primario), "media_R": float(R.mean()), "pf_netto": pf_di(R)}
        lopo = {}
        for per in periodi:
            r_ = [t["R"] for t in primario if t["periodo"] != per.nome]
            lopo[per.nome] = {"n": len(r_), "media_R": float(np.mean(r_)) if r_ else None,
                              "pf_netto": pf_di(r_) if r_ else None}
        T5["leave_one_period_out"] = lopo
        tot = float(R.sum())
        T5["quota_profitto_per_periodo"] = {
            per.nome: (float(sum(t["R"] for t in primario if t["periodo"] == per.nome)) / tot if tot > 0 else None)
            for per in periodi}
        sdm = sens_trades["Sd"]
        T5["spread_x1.5"] = {"n": len(sdm), "media_R": float(np.mean([t["R"] for t in sdm])) if sdm else None,
                             "pf_netto": pf_di([t["R"] for t in sdm]) if sdm else None}
        T5["escluso_spread0"] = {"n": sum(1 for t in primario if not (t["spread0_ingresso"] or t["spread0_uscita"]))}
        sel = [t for t in primario if not (t["spread0_ingresso"] or t["spread0_uscita"])]
        T5["escluso_spread0"].update({"media_R": float(np.mean([t["R"] for t in sel])) if sel else None,
                                      "pf_netto": pf_di([t["R"] for t in sel]) if sel else None})
    T["T5_robustezza"] = T5
    # ---- T7 placebo
    T7 = placebo(prm, tfs, DISEGNO["PLACEBO_TARGET_SEGNALI"], DISEGNO["PLACEBO_MAX_ANNI"], DISEGNO["SEED"])
    if args.placebo_blocchi:
        T7["blocchi_esplorativo"] = placebo_blocchi(periodi, prm, tf0, args.placebo_blocchi, DISEGNO["SEED"])
    else:
        T7["blocchi_esplorativo"] = "non eseguito (opzionale, --placebo-blocchi N)"
    T["T7_placebo"] = T7
    # ---- T8 deriva
    T8: dict = {}
    for per in periodi:
        b, ind = per.serie(tf0)
        atr_med = float(np.nanmedian(ind.atr14))
        tr = [t for t in primario if t["periodo"] == per.nome]
        T8[per.nome] = {
            "buy_and_hold_in_ATR": float((b.c[-1] - b.c[0]) / atr_med), "atr_mediana_prezzo": atr_med,
            "long": {"n": sum(1 for t in tr if t["side"] == 1),
                     "media_R": float(np.mean([t["R"] for t in tr if t["side"] == 1])) if any(t["side"] == 1 for t in tr) else None},
            "short": {"n": sum(1 for t in tr if t["side"] == -1),
                      "media_R": float(np.mean([t["R"] for t in tr if t["side"] == -1])) if any(t["side"] == -1 for t in tr) else None}}
    T["T8_deriva"] = T8
    # ---- T9 dati / esecuzione
    T9: dict = {"spread0_sostituiti_per_periodo": {p.nome: p.m1.info["spread0_sostituiti"] for p in periodi},
                "righe_csv_scartate_o_incoerenti": {p.nome: {k: p.m1_orig_info[k] for k in
                                                              ("righe_scartate_formato", "duplicati_rimossi",
                                                               "salti_indietro_nel_tempo", "righe_ohlc_incoerenti")}
                                                    for p in periodi}}
    T9["primaria_H1"] = {
        "trade_spread0_ingresso": sum(1 for t in primario if t["spread0_ingresso"]),
        "trade_spread0_uscita": sum(1 for t in primario if t["spread0_uscita"]),
        "gap_ingresso_max_min": max((t["gap_ingresso_min"] for t in primario), default=None),
        "trade_con_gap_ingresso_gt_0": sum(1 for t in primario if t["gap_ingresso_min"] > 0),
        "trade_chiusi_fine_dati": sum(1 for t in primario if t["motivo"] == "FINE_DATI"),
        "uscite_a_mercato_target_superato": sum(1 for t in primario if t["motivo"] == "MKT"),
        "ricalcoli_target_totali": sum(t["n_agg_target"] for t in primario),
        "eventi_sl_tp_stesso_minuto": sum(1 for t in primario if t["sl_e_tp_stesso_minuto"]),
        "segnali_scartati": {k: sum(base_ris[tf0][(per.nome, var)]["cont"][k] for per in periodi for var in VARIANTI)
                             for k in ("scartati_posizione_aperta", "scartati_target_oltre_ingresso",
                                       "scartati_indicatori_non_pronti", "scartati_no_barra_successiva",
                                       "scartati_gap_ingresso")},
        "segnali_totali": sum(base_ris[tf0][(per.nome, var)]["cont"]["segnali"] for per in periodi for var in VARIANTI),
        "tocchi_penetrazione_lt_spread_sui_segnali": sum(base_ris[tf0][(per.nome, var)]["res"]["extra"]["segnali_penetrazione_lt_spread"]
                                                          for per in periodi for var in VARIANTI),
        "coppie_CONT_INV_stesso_episodio": sum(
            len({s["episodio"] for s in base_ris[tf0][(per.nome, "CONT")]["res"]["segnali"]}
                & {s["episodio"] for s in base_ris[tf0][(per.nome, "INV")]["res"]["segnali"]}) for per in periodi),
    }
    T["T9_dati_esecuzione"] = T9
    # ---- verdetto
    N = len(primario)
    m = float(np.mean([t["R"] for t in primario])) if N else None
    pf = pf_di([t["R"] for t in primario]) if N else None
    p_b1 = T4["B1"]["pooled"].get("p_B") if (N and "pooled" in T4.get("B1", {})) else None
    ic = T5.get("bootstrap_settimane")
    lopo_ok = bool(N) and all((v["media_R"] is not None and v["media_R"] > 0) for v in T5["leave_one_period_out"].values())
    sd_ok = bool(N) and T5["spread_x1.5"]["media_R"] is not None and T5["spread_x1.5"]["media_R"] > 0
    V = verdetto(N, m, pf, p_b1, ic, lopo_ok, sd_ok, args.parte_a)
    V["n_configurazioni_esaminate"] = {
        "primaria": 1, "M30_sottoviste": 3 if len(tfs) > 1 else 0, "sensibilita": len(SENSIBILITA),
        "nota": "le esplorative non selezionano; clausole obbligatorie di criteri_previsioni_v1.md Parte C da riportare"}
    if simbolo == SIMBOLO_DEFAULT:
        cl1 = "XAUUSD fuori dallo scopo dichiarato dalla Guida (MAJOR/MINOR, D1/H4/H1/M30); M15 non ammesso e non testato"
        cl4 = "nessun dato EURUSD; i 4 periodi sono 4 regimi; N per cella in T2"
    else:
        cl1 = ("%s: ambito dichiarato dalla Guida (MAJOR/MINOR, D1/H4/H1/M30) da verificare per il simbolo; "
               "M15 non ammesso e non testato" % simbolo)
        cl4 = "dati del solo simbolo %s; i 4 periodi sono 4 regimi; N per cella in T2" % simbolo
    V["clausole_Parte_C"] = [
        cl1,
        "Guida usata = 'versione didattica' non confermata come Guida Operativa 11 ufficiale; mancano Dichiarazione di Test e screenshot",
        "stop 3 ATR, target SMA20, ricalcolo 3 ore da Guida/Protocolli; soglie 'molto/ordinato' sono interpretazioni (specifica sez. 8); pattern testati = soprainsieme dei validi",
        cl4,
        "criteri non misurabili: news, giudizio visivo",
        "trade a FINE_DATI, SL+TP stesso minuto, target oltre ingresso, spread=0: quantificati in T2/T9",
        "configurazioni esaminate: vedi n_configurazioni_esaminate; le esplorative non selezionano",
        "probabilita della Checklist non confermate/smentite per classi con campione < 30",
        "parole vietate: 'la strategia funziona/non funziona', 'validata', 'pronta per EA'",
        "non misurati: slippage, commissioni, swap, drawdown/regole prop, spread FTMO"]
    T["VERDETTO"] = V
    # ---- log trade completo (schedule target inclusa) per H1 e M30
    LOG = {}
    for tf in tfs:
        for per in periodi:
            for var in VARIANTI:
                nome = "%s_%s_%s" % (var, TF_NOME[tf], per.nome)
                LOG[nome] = [{k: v for k, v in t.items() if k not in ("ord", "wr0_i", "pareggio_costo_i")}
                             for t in base_ris[tf][(per.nome, var)]["trades"]]
    T["LOG_TRADE"] = LOG
    risultato = {"intestazione": intest, "tabelle": T}
    risultato = pulisci(risultato)
    risultato["sha256_risultati"] = hashlib.sha256(canon(risultato).encode()).hexdigest()
    risultato_t = round(time.time() - t_start, 1)
    return risultato, risultato_t


# =============================================================================== markdown
def fmt(x):
    if x is None:
        return "-"
    if isinstance(x, float):
        return "%.4g" % x
    return str(x)


def md_tabella(righe: list, colonne: list) -> str:
    if not righe:
        return "(vuota)\n"
    out = "| " + " | ".join(colonne) + " |\n|" + "---|" * len(colonne) + "\n"
    for r in righe:
        out += "| " + " | ".join(fmt(r.get(c)) for c in colonne) + " |\n"
    return out


def md_albero(x, livello=0) -> str:
    pad = "  " * livello
    if isinstance(x, dict):
        s = ""
        for k, v in x.items():
            if isinstance(v, (dict, list)):
                s += "%s- **%s**\n%s" % (pad, k, md_albero(v, livello + 1))
            else:
                s += "%s- %s: %s\n" % (pad, k, fmt(v))
        return s
    if isinstance(x, list):
        return "".join("%s- %s\n" % (pad, fmt(v) if not isinstance(v, (dict, list)) else json.dumps(v, sort_keys=True))
                       for v in x)
    return "%s%s\n" % (pad, fmt(x))


def scrivi_md(ris: dict) -> str:
    h, T = ris["intestazione"], ris["tabelle"]
    s = "# Breaking Band su %s — risultati (generato da run_test.py)\n\n" % h.get("simbolo", SIMBOLO_DEFAULT)
    s += "sha256 dei risultati (JSON canonico): `%s`\n\n" % ris["sha256_risultati"]
    s += "## Intestazione: parametri, file letti, hash\n" + md_albero(h) + "\n"
    V = T["VERDETTO"]
    s += "## VERDETTO (criteri_previsioni_v1.md, Parte B)\n" + md_albero({k: v for k, v in V.items()}) + "\n"
    s += "## T1 Imbuto\n"
    for nome, per in T["T1_imbuto"].items():
        for pn, tab in per.items():
            s += "### %s — %s\n" % (nome, pn)
            s += md_tabella(tab["stadi"], ["stadio", "n", "pct_cond_stadio_prec", "causa_principale"])
            s += "Segnali e trade: %s\n\n" % json.dumps(tab["segnali_e_trade"], sort_keys=True)
            if tab["filtro_quasi_autocolpente"]:
                s += "Filtro quasi auto-colpente (>90%% eliminato): %s\n\n" % json.dumps(tab["filtro_quasi_autocolpente"])
            s += "Armati: %s; fine episodi: %s; extra: %s\n\n" % (json.dumps(tab["armati_per_direzione"], sort_keys=True),
                                                                  json.dumps(tab["fine_episodi"], sort_keys=True),
                                                                  json.dumps(tab["extra"], sort_keys=True))
    s += "## T2 Risultati per variante x TF x periodo\n"
    righe = [dict(cella=k, **{c: v.get(c) for c in ("n", "win_pct", "pf_lordo", "pf_netto", "attesa_R", "mediana_R",
                                                    "netto_R", "dd_max_R", "costo_spread_medio_R", "D_medio_atr",
                                                    "pareggio_atteso_medio_pct", "wr0_pct", "durata_mediana_barre",
                                                    "durata_max_barre", "quota_long")}) for k, v in T["T2_risultati"].items()]
    s += md_tabella(righe, ["cella", "n", "win_pct", "pf_lordo", "pf_netto", "attesa_R", "mediana_R", "netto_R", "dd_max_R",
                            "costo_spread_medio_R", "D_medio_atr", "pareggio_atteso_medio_pct", "wr0_pct",
                            "durata_mediana_barre", "durata_max_barre", "quota_long"])
    s += "\nUscite per motivo e altri conteggi:\n"
    for k, v in T["T2_risultati"].items():
        s += "- %s: motivi %s; SL+TP stesso minuto %s; spread0 %s; fine_dati/mkt %s\n" % (
            k, json.dumps(v.get("per_motivo", {}), sort_keys=True), fmt(v.get("eventi_sl_tp_stesso_minuto")),
            fmt(v.get("trade_spread0_ingresso_o_uscita")), fmt(v.get("uscite_fine_dati_o_mercato")))
    s += "\n## T3 Fasce (stratificazione, descrittori)\n" + md_albero(T["T3_fasce"]) + "\n"
    s += "## T4 Linee di base (B1 primaria; B0, B2 esplorative)\n" + md_albero(T["T4_linea_di_base"]) + "\n"
    s += "## T5 Robustezza della primaria\n" + md_albero(T["T5_robustezza"]) + "\n"
    s += "## T6 Sensibilita (riportate per intero, non selezionabili)\n"
    righe = [dict(sens=k, **{c: v["pooled"].get(c) for c in ("n", "win_pct", "pf_netto", "attesa_R", "netto_R", "dd_max_R")},
                  segnali=v["segnali"]) for k, v in T["T6_sensibilita"].items()]
    s += md_tabella(righe, ["sens", "segnali", "n", "win_pct", "pf_netto", "attesa_R", "netto_R", "dd_max_R"]) + "\n"
    s += "## T7 Placebo\n" + md_albero(T["T7_placebo"]) + "\n"
    s += "## T8 Deriva\n" + md_albero(T["T8_deriva"]) + "\n"
    s += "## T9 Dati / esecuzione\n" + md_albero(T["T9_dati_esecuzione"]) + "\n"
    s += "## Log dei trade\nSchedule completa dei target per ogni trade nel JSON (chiave tabelle.LOG_TRADE).\n"
    return s


def main(argv=None):
    ap = argparse.ArgumentParser(description=__doc__, formatter_class=argparse.RawDescriptionHelpFormatter)
    ap.add_argument("--dir", help="cartella con i 4 CSV (nomi ABTG_M1_<SIMBOLO>_2013/_2018/_2020.csv, ABTG_M1_<SIMBOLO>.csv)")
    ap.add_argument("--simbolo", help="simbolo (default XAUUSD): solo nomi dei file e punto noto")
    ap.add_argument("--punto", type=float, help="dimensione del punto nel prezzo (oro 0.01; EURUSD 0.00001); "
                                                "se omesso: quello noto del simbolo (params.PUNTI_NOTI)")
    ap.add_argument("--periodi", nargs="*", help="nome=percorso.csv (alternativa a --dir; solo per prove)")
    ap.add_argument("--out", required=True, help="prefisso dei file di output")
    ap.add_argument("--congelati", help="cartella con specifica_v1.md, disegno_test_v1.md, criteri_previsioni_v1.md")
    ap.add_argument("--hash-dati", help="HASH_DATI.txt (sha256  nomefile)")
    ap.add_argument("--parte-a", default="NON_VALUTATA", choices=["NON_VALUTATA", "VERIFICATO", "NON_VERIFICATO"])
    ap.add_argument("--solo-h1", action="store_true", help="PROVA: salta M30")
    ap.add_argument("--placebo-target", type=int, help="PROVA: segnali placebo target")
    ap.add_argument("--placebo-max-anni", type=int, help="PROVA/limite tempo: anni sintetici massimi")
    ap.add_argument("--placebo-blocchi", type=int, default=0, help="rimescolamenti del placebo a blocchi (opzionale)")
    ap.add_argument("--prova", help='PROVA: JSON {"PARAMS":{...},"DISEGNO":{...}} (non congelato)')
    args = ap.parse_args(argv)
    if not args.dir and not args.periodi:
        ap.error("serve --dir oppure --periodi")
    ris, secondi = esegui(args)
    with open(args.out + ".json", "w") as f:
        json.dump(ris, f, sort_keys=True, indent=1, allow_nan=False)
    with open(args.out + ".md", "w") as f:
        f.write(scrivi_md(ris))
    print("OK %s.json / .md  sha256_risultati=%s  (%.1f s)" % (args.out, ris["sha256_risultati"], secondi))
    return ris


if __name__ == "__main__":
    main()
