#!/usr/bin/env python3
"""agg_conferma.py — aggregatore del CICLO 2 (conferma forex H1 su anni nuovi), criteri_conferma_forex_v1.md.

Legge i JSON prodotti da run_test.py (codice v2 congelato, NESSUNA modifica) per EURUSD, GBPUSD, USDJPY, EURJPY
sugli anni 2015, 2017, 2019, 2022 e calcola i criteri 1-5 dell'ipotesi H-C sui trade pooled H1 (CONT + INV, 4 coppie):
  1. N pooled >= 30 (altrimenti INCONCLUSIVO)
  2. media R netta > 0 e limite inferiore IC90 (bootstrap a blocchi settimanali, 10.000 replicati, seme fisso) > 0
  3. win rate pooled >= pareggio atteso medio + 5 punti percentuali
  4. leave-one-pair-out: togliendo ciascuna coppia la media R resta > 0
  5. con costo extra di 0,05 R per trade la media R resta > 0
Esplorative (non decidono): M30 pooled, ogni coppia da sola, CONT e INV separati.

USO:
  python3 -I agg_conferma.py --json EURUSD=<file> GBPUSD=<file> USDJPY=<file> EURJPY=<file> --out <prefisso> \
       [--hash-codice congelati/HASH_CODICE_V2.txt] [--hash-documenti-conferma <sha256 atteso del criteri_conferma_forex_v1.md>] \
       [--criteri congelati/criteri_conferma_forex_v1.md]
Output: <prefisso>.json (senza timestamp: riproducibile) e <prefisso>.md. Legge SOLO JSON, mai CSV.
Le costanti dei criteri sono in AGG (unica fonte, dal documento congelato).
"""
from __future__ import annotations

import argparse
import hashlib
import json
import math
import os
import sys

import numpy as np

# ---- costanti dei criteri (criteri_conferma_forex_v1.md; seme e numero di replicati come in run_test.py v2)
AGG = {
    "N_MIN": 30, "PP_VINCITE": 5.0, "COSTO_EXTRA_R": 0.05, "EPS_NESSUN_VANTAGGIO_R": 0.05,
    "N_BOOTSTRAP": 10000, "SEED": 20261101, "IC_ALPHA": 0.05,
    "COPPIE": ("EURUSD", "GBPUSD", "USDJPY", "EURJPY"), "ANNI": ("2015", "2017", "2019", "2022"),
    "TF_PRIMARIO": "H1", "TF_ESPLORATIVO": "M30", "N_PIENO": 60,
}


# =============================================================================== utilita'
def sha256_file(path: str) -> str:
    h = hashlib.sha256()
    with open(path, "rb") as f:
        for blk in iter(lambda: f.read(1 << 20), b""):
            h.update(blk)
    return h.hexdigest()


def pulisci(x):
    """Stessa regola di run_test.pulisci: niente NaN/inf/numpy."""
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


def sha_risultati_json(j: dict) -> str:
    """Ricalcola lo sha256_risultati di un JSON di run_test.py (canonico del documento senza il campo stesso)."""
    corpo = {k: v for k, v in j.items() if k != "sha256_risultati"}
    return hashlib.sha256(canon(corpo).encode()).hexdigest()


def pf_di(R) -> float:
    R = np.asarray(R, dtype=np.float64)
    g = float(R[R > 0].sum())
    p = float(-R[R < 0].sum())
    if p == 0:
        return float("inf") if g > 0 else float("nan")
    return g / p


def bootstrap_settimane(trades: list, n_boot: int, seed: int, alpha: float):
    """Identico a run_test.bootstrap_settimane: blocchi = settimane (di calendario, condivise fra le coppie),
    rapporto somma R / numero di trade nelle settimane estratte."""
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


# =============================================================================== lettura dei JSON
def estrai_trade(j: dict, tf: str) -> list:
    """Trade del log (LOG_TRADE) per il timeframe `tf`, con la coppia del JSON e il pareggio atteso ricalcolato
    (STOP + c) / (STOP + D) dalla riga del trade, come in run_test.arricchisci."""
    stop = j["intestazione"]["parametri"]["STOP_ATR"]
    simbolo = j["intestazione"]["simbolo"]
    out = []
    for chiave in sorted(j["tabelle"]["LOG_TRADE"]):
        var, tf_k, periodo = chiave.split("_", 2)
        if tf_k != tf:
            continue
        for t in j["tabelle"]["LOG_TRADE"][chiave]:
            out.append({"coppia": simbolo, "variante": var, "periodo": periodo, "R": float(t["R"]),
                        "settimana": int(t["settimana"]), "side": int(t["side"]),
                        "pareggio": (stop + t["c_atr"]) / (stop + t["D_atr"])})
    out.sort(key=lambda t: (t["coppia"], t["periodo"], t["variante"], t["settimana"], t["R"]))
    return out


def controlli_json(coppie: dict, anni, hash_codice: dict | None) -> list:
    """Controlli di integrita': ognuno {nome, ok, dettaglio}. ok=None = non verificabile (input mancante)."""
    c = []

    def add(nome, ok, det=""):
        c.append({"nome": nome, "ok": ok, "dettaglio": det})

    add("quattro_coppie_attese", sorted(coppie) == sorted(AGG["COPPIE"]), "trovate: %s" % sorted(coppie))
    for nome, j in sorted(coppie.items()):
        h = j["intestazione"]
        add("%s:simbolo_coincide_con_il_nome" % nome, h.get("simbolo") == nome, "simbolo nel JSON: %s" % h.get("simbolo"))
        add("%s:sha256_risultati_ricalcolato" % nome, sha_risultati_json(j) == j.get("sha256_risultati"))
        add("%s:parametri_congelati_non_di_prova" % nome, h.get("PARAMETRI_NON_CONGELATI_PROVA") is False)
        per = sorted({k.split("_", 2)[2] for k in j["tabelle"]["LOG_TRADE"]})
        add("%s:periodi_attesi" % nome, per == sorted(anni), "periodi: %s" % per)
        add("%s:seme_e_replicati_coincidono" % nome,
            h["disegno"].get("SEED") == AGG["SEED"] and h["disegno"].get("N_BOOTSTRAP") == AGG["N_BOOTSTRAP"],
            "SEED=%s N_BOOTSTRAP=%s" % (h["disegno"].get("SEED"), h["disegno"].get("N_BOOTSTRAP")))
        hd = h.get("hash_dati_coincidono")
        add("%s:hash_dati_csv_coincidono" % nome, None if hd is None else all(hd.values()),
            "run_test lanciato senza --hash-dati" if hd is None else "")
        if hash_codice is None:
            add("%s:codice_v2_congelato" % nome, None, "HASH_CODICE_V2 non fornito")
        else:
            esatto = all(h["sha256_codice"].get(f) == hash_codice.get(f) for f in
                         ("engine.py", "signals.py", "params.py", "run_test.py"))
            add("%s:codice_v2_congelato" % nome, esatto)
        # coerenza interna: pareggio ricalcolato dai trade = quello di T2 (pesato)
        T2 = j["tabelle"]["T2_risultati"].get("POOLED_H1")
        tr = estrai_trade(j, AGG["TF_PRIMARIO"])
        if T2 and T2.get("n"):
            ok = (T2["n"] == len(tr)
                  and abs(100.0 * np.mean([t["pareggio"] for t in tr]) - T2["pareggio_atteso_medio_pct"]) < 1e-6
                  and abs(np.mean([t["R"] for t in tr]) - T2["attesa_R"]) < 1e-9)
        else:
            ok = len(tr) == 0
        add("%s:log_trade_coerente_con_T2_POOLED_H1" % nome, bool(ok))
    return c


# =============================================================================== statistiche e verdetto
def stat_gruppo(trades: list, con_ic: bool = True) -> dict:
    n = len(trades)
    if n == 0:
        return {"n": 0}
    R = np.array([t["R"] for t in trades])
    wins = int((R > 0).sum())
    pare = 100.0 * float(np.mean([t["pareggio"] for t in trades]))
    r = {"n": n, "vincite": wins, "win_rate_pct": 100.0 * wins / n, "pareggio_atteso_medio_pct": pare,
         "media_R": float(R.mean()), "mediana_R": float(np.median(R)), "somma_R": float(R.sum()),
         "pf_netto": pf_di(R), "quota_long": float(np.mean([t["side"] == 1 for t in trades]))}
    if con_ic:
        r["bootstrap_settimane"] = bootstrap_settimane(trades, AGG["N_BOOTSTRAP"], AGG["SEED"], AGG["IC_ALPHA"])
    return r


def verdetto_conferma(N, media, ic, wr_pct, pareggio_pct, lopo: dict, media_costo_extra) -> dict:
    """Esattamente criteri_conferma_forex_v1.md. Ritorna anche la lettura alternativa (precedenza stile v1)."""
    A = AGG
    cond = {
        "1_N>=30": N >= A["N_MIN"],
        "2_media>0_e_IC90_inf>0": media is not None and media > 0 and ic is not None and ic["ic90_lo"] > 0,
        "3_WR>=pareggio+5pp": wr_pct is not None and wr_pct >= pareggio_pct + A["PP_VINCITE"],
        "4_leave_one_pair_out_media>0": bool(lopo) and all(v is not None and v > 0 for v in lopo.values()),
        "5_costo_extra_0.05R_media>0": media_costo_extra is not None and media_costo_extra > 0,
    }

    def esito(precedenza_v1: bool) -> str:
        if N < A["N_MIN"]:
            return "INCONCLUSIVO"
        if all(cond.values()):
            return "CONFERMATO"
        contiene_zero = ic["ic90_lo"] <= 0 <= ic["ic90_hi"]
        nessun = ic["ic90_hi"] < A["EPS_NESSUN_VANTAGGIO_R"]
        if precedenza_v1:                    # NESSUN VANTAGGIO prima di NON DIMOSTRATO (come criteri v1)
            return "NESSUN VANTAGGIO RILEVANTE" if nessun else "NON DIMOSTRATO"
        if contiene_zero:                    # ordine di scrittura del documento: IC contiene 0 -> NON DIMOSTRATO
            return "NON DIMOSTRATO"
        if nessun:
            return "NESSUN VANTAGGIO RILEVANTE"
        return "NON DIMOSTRATO"              # N>=30, IC a destra di 0 ma almeno un'altra condizione manca

    lett = esito(False)
    alt = esito(True)
    note = []
    if lett != alt:
        note.append("la precedenza tra NON DIMOSTRATO e NESSUN VANTAGGIO RILEVANTE e AMBIGUA nel documento: lettura "
                    "letterale (ordine di scrittura) = %s; lettura stile v1 = %s (vedi domande.md)" % (lett, alt))
    livello = None
    if lett == "CONFERMATO":
        livello = "N>=60" if N >= A["N_PIENO"] else "30<=N<60"
    return {"esito": lett, "esito_lettura_alternativa_v1": alt, "condizioni": cond, "N": N, "media_R": media,
            "ic90": ic, "win_rate_pct": wr_pct, "pareggio_atteso_medio_pct": pareggio_pct,
            "soglia_win_rate_pct": (pareggio_pct + A["PP_VINCITE"]) if pareggio_pct is not None else None,
            "leave_one_pair_out_media_R": lopo, "media_R_con_costo_extra": media_costo_extra,
            "costo_extra_R": A["COSTO_EXTRA_R"], "note": note, "livello_N": livello,
            "significato": "CONFERMATO = ripetuto fuori campione su forex H1 a costi realistici; NON e EA pronto, "
                           "ne lotti, ne conto reale (restano test a tick reali, news filter, altri simboli)"}


def calcola(coppie: dict, anni=None, hash_codice: dict | None = None) -> dict:
    """coppie: {simbolo: json di run_test.py}. Ritorna il dict dei risultati (senza sha)."""
    anni = anni or AGG["ANNI"]
    ctrl = controlli_json(coppie, anni, hash_codice)
    h1 = [t for nome in sorted(coppie) for t in estrai_trade(coppie[nome], AGG["TF_PRIMARIO"])]
    m30 = [t for nome in sorted(coppie) for t in estrai_trade(coppie[nome], AGG["TF_ESPLORATIVO"])]
    N = len(h1)
    st = stat_gruppo(h1)
    lopo = {}
    for nome in sorted(coppie):
        resto = [t for t in h1 if t["coppia"] != nome]
        lopo[nome] = float(np.mean([t["R"] for t in resto])) if resto else None
    media_extra = (st["media_R"] - AGG["COSTO_EXTRA_R"]) if N else None
    V = verdetto_conferma(N, st.get("media_R"), st.get("bootstrap_settimane"), st.get("win_rate_pct"),
                          st.get("pareggio_atteso_medio_pct"), lopo, media_extra)
    V["controlli_integrita_ok"] = all(c["ok"] is True for c in ctrl)
    V["controlli_non_verificabili"] = [c["nome"] for c in ctrl if c["ok"] is None]
    V["controlli_falliti"] = [c["nome"] for c in ctrl if c["ok"] is False]
    esplor = {
        "M30_pooled": stat_gruppo(m30),
        "H1_per_coppia": {nome: stat_gruppo([t for t in h1 if t["coppia"] == nome]) for nome in sorted(coppie)},
        "M30_per_coppia": {nome: stat_gruppo([t for t in m30 if t["coppia"] == nome]) for nome in sorted(coppie)},
        "H1_per_variante": {v: stat_gruppo([t for t in h1 if t["variante"] == v]) for v in ("CONT", "INV")},
        "H1_per_periodo": {a: stat_gruppo([t for t in h1 if t["periodo"] == a], con_ic=False) for a in anni},
        "H1_per_lato": {s: stat_gruppo([t for t in h1 if t["side"] == v], con_ic=False)
                        for s, v in (("long", 1), ("short", -1))},
    }
    return {
        "intestazione": {
            "costanti_criteri": {k: (list(v) if isinstance(v, tuple) else v) for k, v in AGG.items()},
            "coppie": sorted(coppie), "anni": list(anni),
            "sha256_risultati_dei_json_letti": {n: coppie[n].get("sha256_risultati") for n in sorted(coppie)},
            "sha256_codice_dei_json_letti": {n: coppie[n]["intestazione"]["sha256_codice"] for n in sorted(coppie)},
            "sha256_csv_dei_json_letti": {n: coppie[n]["intestazione"]["sha256_csv"] for n in sorted(coppie)},
            "esplorative": "M30, per coppia, per variante, per periodo, per lato: NON decidono",
        },
        "controlli": ctrl, "H_C_pooled_H1": st, "VERDETTO": V, "esplorative": esplor,
    }


# =============================================================================== markdown e CLI
def fmt(x):
    if x is None:
        return "-"
    if isinstance(x, float):
        return "%.4g" % x
    return str(x)


def md_albero(x, liv=0) -> str:
    pad = "  " * liv
    if isinstance(x, dict):
        s = ""
        for k, v in x.items():
            if isinstance(v, (dict, list)):
                s += "%s- **%s**\n%s" % (pad, k, md_albero(v, liv + 1))
            else:
                s += "%s- %s: %s\n" % (pad, k, fmt(v))
        return s
    if isinstance(x, list):
        return "".join("%s- %s\n" % (pad, fmt(v) if not isinstance(v, (dict, list)) else json.dumps(v, sort_keys=True))
                       for v in x)
    return "%s%s\n" % (pad, fmt(x))


def scrivi_md(r: dict) -> str:
    V = r["VERDETTO"]
    s = "# Conferma forex H1 su anni nuovi — aggregatore (criteri_conferma_forex_v1.md)\n\n"
    s += "sha256 dei risultati (JSON canonico): `%s`\n\n" % r["sha256_risultati"]
    s += "## VERDETTO: %s\n\n" % V["esito"] + md_albero(V) + "\n"
    s += "## Statistiche pooled H1 (ipotesi H-C)\n" + md_albero(r["H_C_pooled_H1"]) + "\n"
    s += "## Controlli di integrita'\n" + "".join("- %s: %s %s\n" % (c["nome"], c["ok"], c["dettaglio"])
                                                  for c in r["controlli"]) + "\n"
    s += "## Esplorative (non decidono)\n" + md_albero(r["esplorative"]) + "\n"
    s += "## Intestazione\n" + md_albero(r["intestazione"]) + "\n"
    return s


def leggi_hash_codice(path: str) -> dict:
    out = {}
    with open(path) as fh:
        for ln in fh:
            if ln.strip():
                h, f = ln.split()
                out[f] = h
    return out


def main(argv=None):
    ap = argparse.ArgumentParser(description=__doc__, formatter_class=argparse.RawDescriptionHelpFormatter)
    ap.add_argument("--json", nargs="+", required=True, help="SIMBOLO=percorso del JSON di run_test.py (4 coppie)")
    ap.add_argument("--out", required=True)
    ap.add_argument("--hash-codice", help="HASH_CODICE_V2.txt (sha256  nomefile)")
    ap.add_argument("--criteri", help="criteri_conferma_forex_v1.md (ne registra lo sha256)")
    ap.add_argument("--anni", nargs="+", default=list(AGG["ANNI"]))
    args = ap.parse_args(argv)
    coppie, sha_file = {}, {}
    for x in args.json:
        nome, path = x.split("=", 1)
        if nome in coppie:
            raise SystemExit("coppia duplicata: %s" % nome)
        with open(path) as f:
            coppie[nome] = json.load(f)
        sha_file[nome] = sha256_file(path)
    hc = leggi_hash_codice(args.hash_codice) if args.hash_codice else None
    r = calcola(coppie, args.anni, hc)
    r["intestazione"]["sha256_file_json_letti"] = sha_file
    r["intestazione"]["sha256_criteri_conferma"] = sha256_file(args.criteri) if args.criteri else None
    r["intestazione"]["sha256_aggregatore"] = sha256_file(os.path.abspath(__file__))
    r = pulisci(r)
    r["sha256_risultati"] = hashlib.sha256(canon(r).encode()).hexdigest()
    with open(args.out + ".json", "w") as f:
        json.dump(r, f, sort_keys=True, indent=1, allow_nan=False)
    with open(args.out + ".md", "w") as f:
        f.write(scrivi_md(r))
    V = r["VERDETTO"]
    print("OK %s.json / .md  VERDETTO=%s  N=%s  sha256_risultati=%s" % (args.out, V["esito"], V["N"], r["sha256_risultati"]))
    return r


if __name__ == "__main__":
    main()
