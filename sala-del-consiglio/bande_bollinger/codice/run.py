"""Esegue il test primario + baseline + placebo + esplorativi (specifica_v1 / criteri_previsioni_v1)."""
import argparse, hashlib, json, os, sys, time
import numpy as np
sys.path.insert(0, os.path.dirname(os.path.abspath(__file__)))
import bb

STRUM = {"NASUSD_EXT": 1.0, "SPXUSD_EXT": 2.2}
PERIODI = {"P2015": "2015/ABTG_M1_{s}_2015.csv", "P2020": "2020/ABTG_M1_{s}_2020.csv", "P2025": "2025_26/ABTG_M1_{s}.csv"}
SEED_BOOT = 20261102


def sha(p):
    h = hashlib.sha256()
    with open(p, "rb") as f:
        for ch in iter(lambda: f.read(1 << 20), b""):
            h.update(ch)
    return h.hexdigest()


def stats(R, sett, rng_seed=SEED_BOOT):
    R = np.asarray(R, float); n = R.size
    if n == 0:
        return dict(N=0)
    w = R > 0
    aw = float(R[w].mean()) if w.any() else 0.0
    al = float(-R[~w].mean()) if (~w).any() else 0.0
    be = al / (aw + al) if (aw + al) > 0 else float("nan")
    ws = np.unique(sett)
    sums = np.array([R[sett == k].sum() for k in ws]); cnt = np.array([(sett == k).sum() for k in ws])
    rng = np.random.default_rng(rng_seed)
    idx = rng.integers(0, ws.size, size=(10000, ws.size))
    bm = sums[idx].sum(axis=1) / cnt[idx].sum(axis=1)
    return dict(N=int(n), win_rate=float(w.mean()), R_medio=float(R.mean()), R_vinc=aw, R_perd=al, breakeven=float(be),
                ic90_lo=float(np.percentile(bm, 5)), ic90_hi=float(np.percentile(bm, 95)), n_settimane=int(ws.size))


def prepara(dati, cache):
    D = {}
    for s in STRUM:
        for p, pat in PERIODI.items():
            f = os.path.join(dati, pat.format(s=s))
            cp = os.path.join(cache, f"{s}_{p}.npz")
            if os.path.exists(cp):
                z = np.load(cp); D[(s, p)] = {k: z[k] for k in z.files}
            else:
                m = bb.carica(f); np.savez(cp, **m); D[(s, p)] = m
    return D


def gira(D, **over):
    out = []
    info = {}
    for (s, p), m in D.items():
        P = dict(bb.DEF); P["SPREAD_BP"] = STRUM[s]; P.update({k: v for k, v in over.items() if k != "seed"})
        tr, inf = bb.esegui(m, P, shifts_seed=over.get("seed"))
        for t in tr:
            t["strumento"] = s; t["periodo"] = p
        out += tr; info[f"{s}|{p}"] = inf
    return out, info


def arr(tr, key="R"):
    return np.array([t[key] for t in tr], float)


def blocco(tr):
    R = arr(tr); se = np.array([t["sett"] for t in tr], int) if tr else np.array([], int)
    d = stats(R, se)
    if not tr:
        return d
    for nome, f in (("long", lambda t: t["lato"] == 1), ("short", lambda t: t["lato"] == -1)):
        sub = [t for t in tr if f(t)]
        d[nome] = dict(N=len(sub), R_medio=float(arr(sub).mean()) if sub else None,
                       win_rate=float((arr(sub) > 0).mean()) if sub else None)
    d["per_strumento_periodo"] = {}
    for s in STRUM:
        for p in PERIODI:
            sub = [t for t in tr if t["strumento"] == s and t["periodo"] == p]
            d["per_strumento_periodo"][f"{s}|{p}"] = dict(N=len(sub), R_medio=float(arr(sub).mean()) if sub else None)
    d["motivi"] = {k: sum(1 for t in tr if t["motivo"] == k) for k in ("TP", "SL", "MKT", "TF", "FINE_DATI")}
    return d


def verdetto(prim, loo, r_x2, placebo):
    N = prim["N"]
    if N < 30:
        return "INCONCLUSIVO", {"C1": False}
    C = {"C1": True}
    C["C2"] = prim["R_medio"] > 0 and prim["ic90_lo"] > 0
    C["C3"] = prim["win_rate"] >= prim["breakeven"] + 0.05
    C["C4"] = all(v is not None and v > 0 for v in loo.values())
    C["C5"] = r_x2 is not None and r_x2 > 0
    C["C6"] = placebo["p"] is not None and placebo["p"] <= 0.10
    if all(C.values()):
        return "CONFERMATO", C
    if C["C2"]:
        return "INDIZIO", C
    if prim["R_medio"] <= 0 and prim["ic90_hi"] <= 0.10:
        return "NESSUN VANTAGGIO RILEVANTE", C
    return "NON DIMOSTRATO", C


def main():
    ap = argparse.ArgumentParser()
    ap.add_argument("--dati", required=True); ap.add_argument("--out", required=True)
    ap.add_argument("--cache", required=True); ap.add_argument("--placebo-semi", type=int, default=100)
    ap.add_argument("--hash-dati", default=None); ap.add_argument("--hash-codice", default=None)
    a = ap.parse_args()
    os.makedirs(a.out, exist_ok=True); os.makedirs(a.cache, exist_ok=True)
    t0 = time.time()
    D = prepara(a.dati, a.cache)
    print("dati caricati", round(time.time() - t0, 1), "s", flush=True)
    ris = {"hash_dati_file": {f"{s}|{p}": None for (s, p) in D}}
    prim_tr, info = gira(D)
    prim = blocco(prim_tr)
    prim["info"] = info
    b1_tr, _ = gira(D, SR=False)
    ris["PRIMARIO"] = prim
    ris["B1_solo_bande"] = blocco(b1_tr)
    # robustezza
    loo = {}
    for p in PERIODI:
        sub = [t for t in prim_tr if t["periodo"] != p]
        loo[f"senza_{p}"] = float(arr(sub).mean()) if sub else None
    for s in STRUM:
        sub = [t for t in prim_tr if t["strumento"] != s]
        loo[f"senza_{s}"] = float(arr(sub).mean()) if sub else None
    x2_tr, _ = gira(D, SPREAD_MULT=2.0)
    r_x2 = float(arr(x2_tr).mean()) if x2_tr else None
    ris["leave_one_out"] = loo; ris["spread_x2"] = dict(N=len(x2_tr), R_medio=r_x2)
    # placebo
    pm = []
    for sd in range(1, a.placebo_semi + 1):
        tr, _ = gira(D, seed=sd)
        if tr:
            pm.append(float(arr(tr).mean()))
        print("placebo", sd, len(tr), flush=True) if sd % 20 == 0 else None
    pm = np.array(pm)
    plac = dict(n_semi_con_trade=int(pm.size), R_medio_mediana=float(np.median(pm)) if pm.size else None,
                p90=float(np.percentile(pm, 90)) if pm.size else None,
                p=float((pm >= prim["R_medio"]).mean()) if (pm.size and prim["N"] > 0) else None, R_medi=[round(x, 4) for x in pm])
    ris["placebo"] = plac
    v, C = verdetto(prim, loo, r_x2, plac)
    ris["VERDETTO"] = v; ris["criteri"] = C
    # esplorativi
    esp = {}
    for nome, ov in (("M15", dict(TF=15)), ("K1.0", dict(K=1.0)), ("K2.5", dict(K=2.5)), ("TOL0.25", dict(TOL=0.25)),
                     ("TOL1.0", dict(TOL=1.0)), ("senza_filtro_orario", dict(FILTRO=False))):
        tr, _ = gira(D, **ov)
        esp[nome] = blocco(tr)
        print("esplorativo", nome, esp[nome].get("N"), flush=True)
    ris["esplorativi"] = esp
    ris["trade_primari"] = prim_tr
    ris["b1_trade_n"] = len(b1_tr)
    ris["meta"] = dict(hash_codice=a.hash_codice, hash_dati=a.hash_dati, durata_s=round(time.time() - t0, 1))
    with open(os.path.join(a.out, "risultati.json"), "w") as f:
        json.dump(ris, f, indent=1, default=lambda o: o.item() if hasattr(o, "item") else str(o))
    print("VERDETTO", v, C, "N", prim["N"])


if __name__ == "__main__":
    main()
