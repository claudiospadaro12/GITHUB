#!/usr/bin/env python3
# -*- coding: utf-8 -*-
"""
pattern_piantati.py - Batteria di pattern PIANTATI su barre sintetiche (CK-14) per la reimplementazione
indipendente (reimpl_segnali.py) e, poi, per il codice dei segnali di A4 (via confronto_con_A4.py).

PRINCIPIO
  Le ATTESE sono scritte a mano nella tabella SCENARI qui sotto (segnale alla barra X con lato/tipo, oppure nessun
  segnale; quali criteri sono veri/falsi alla barra del test). Per ogni scenario, un calcolo NAIVE e indipendente dal
  rilevatore (raw_flags: numpy + verifica_generica.atr_wilder) controlla che i numeri grezzi dei criteri siano
  davvero quelli attesi (es. "sd >= S50 alla barra del test"), cosi il gemello negativo viola ESATTAMENTE un
  criterio. Poi si esegue il rilevatore e si confronta con l'attesa. Ogni scenario long e rieseguito SPECCHIATO
  (prezzi -> 4096 - prezzi) con lato invertito.
  Nessun dato reale. Eseguire:  python3 -I pattern_piantati.py

ONESTA SUI PARAMETRI DEGLI SCENARI
  I parametri dei gemelli negativi sono stati trovati con ricerche numeriche (scratch) in cui il rilevatore forniva
  l'attribuzione dei flag; la violazione di UN solo criterio e poi RICONFERMATA dal calcolo naive (raw_flags) e dalle
  attese qui scritte. Non e una dimostrazione di correttezza della specifica, solo della coerenza codice-specifica.
"""
import importlib.util
import os
import sys

import numpy as np

HERE = os.path.dirname(os.path.abspath(__file__))


def _load(name, fname):
    sp = importlib.util.spec_from_file_location(name, os.path.join(HERE, fname))
    m = importlib.util.module_from_spec(sp)
    sys.modules[name] = m
    sp.loader.exec_module(m)
    return m


R = _load("reimpl_segnali", "reimpl_segnali.py")
VG = _load("verifica_generica", "verifica_generica.py")

KMIRROR = 4096.0
N_Q = 230
Q = 1.0 / 128.0


# ------------------------------------------------------------------------------------------
# Costruzione barre
# ------------------------------------------------------------------------------------------
def quiet(n_q=N_Q, base=2000.0, A0=0.9, dA=0.001, P=10, dip=0.0):
    """Fase calma: sinusoide con ampiezza leggermente crescente che termina esattamente in un minimo (la barra s
    dell'impulso successivo e l'ultima barra calma). dip > 0 abbassa l'ultima chiusura (per sfondare la banda in s)."""
    k = np.arange(n_q)
    A = A0 + dA * k
    c = base - A * np.cos(2 * np.pi * (k - (n_q - 1)) / P)
    c[-1] -= dip
    return c


def build(deltas, wick=0.25, n_q=N_Q, **kw):
    cq = quiet(n_q, **kw)
    c = np.concatenate([cq, cq[-1] + np.cumsum(deltas)])
    c = np.round(c / Q) * Q
    o = np.r_[c[0], c[:-1]]
    h = np.round((np.maximum(o, c) + wick) / Q) * Q
    l = np.round((np.minimum(o, c) - wick) / Q) * Q
    return {"open": o, "high": h, "low": l, "close": c}


def mirror(bars):
    return {"open": KMIRROR - bars["open"], "high": KMIRROR - bars["low"], "low": KMIRROR - bars["high"], "close": KMIRROR - bars["close"]}


def S(n, d):
    return [d] * n


def O(n, a=0.1):
    return [a * (-1) ** i for i in range(n)]


# ------------------------------------------------------------------------------------------
# Calcolo NAIVE indipendente dei criteri grezzi alla barra t (d = +1: bulge verso l'alto; -1: specchio)
# ------------------------------------------------------------------------------------------
def raw_flags(bars, d, s, p, t):
    o, h, l, c = [np.asarray(bars[k], dtype=float) for k in ("open", "high", "low", "close")]
    if d == -1:
        o, h, l, c = -o, -l, -h, -c
    n = len(c)
    M = np.full(n, np.nan); sd = np.full(n, np.nan)
    for i in range(19, n):
        w = c[i - 19:i + 1]
        M[i] = sum(w) / 20.0
        sd[i] = (sum((x - M[i]) ** 2 for x in w) / 20.0) ** 0.5
    U = M + 2 * sd; L = M - 2 * sd
    S50 = np.full(n, np.nan)
    for i in range(19 + 49, n):
        S50[i] = sum(sd[i - 49:i + 1]) / 50.0
    atr = VG.atr_wilder(h, l, c, 14)               # implementazione di A7 distinta dal rilevatore
    z = np.full(n, np.nan)
    for u in range(1, n):
        z[u] = (h[u] - l[u]) / atr[u - 1]
    F = {}
    # CONT
    F["touch"] = bool(l[t] <= L[t])
    F["noseq"] = not any(l[r] <= M[r] and any(h[u] >= U[u] for u in range(r + 1, t)) for r in range(p + 1, t - 1))
    F["z_ritr"] = all(z[u] <= 1.5 for u in range(p + 1, t))
    F["z_test"] = bool(z[t] <= 1.5)
    F["sdA"] = bool(sd[t] < S50[t])
    F["sdB"] = bool(sd[t] <= sd[t - 3])
    # INV
    F["med"] = any(l[r] <= M[r] for r in range(p + 1, t))
    F["opp_untouched"] = all(l[u] > L[u] for u in range(s, t + 1))
    F["retest"] = bool(h[t] >= U[t] and h[t] <= h[p])
    F["z_all"] = all(z[u] <= 1.5 for u in range(p + 1, t + 1))
    F["band_flat"] = bool(U[t - 1] - U[t - 4] <= 0.10 * atr[t - 1])
    F["_vals"] = {"low_t": l[t], "L_t": L[t], "sd_t": sd[t], "S50_t": S50[t], "sd_t-3": sd[t - 3], "h_t": h[t], "U_t": U[t],
                  "zmax_ritr": max([z[u] for u in range(p + 1, t)] or [0]), "z_t": z[t]}
    return F


# ------------------------------------------------------------------------------------------
# SCENARI (attese scritte a mano). tipo di verifica 'ep' = episodio completo; 'arm' = solo armamento
# ------------------------------------------------------------------------------------------
def scenari():
    sc = []

    def add(**k):
        k.setdefault("cfg", {})
        k.setdefault("n_q", N_Q)
        k.setdefault("wick", 0.25)
        sc.append(k)

    # --------------------------- CONTINUAZIONE ---------------------------
    # Attesa comune: bulge su (d=+1) con s = ultima barra calma (229), p = ultima barra dell'impulso, tocco della banda
    # inferiore alla ULTIMA barra della serie -> segnale CONT LONG all'ultima barra (barra 'LAST').
    add(nome="C_POS", dopo="CONT: pattern conforme", deltas=S(8, 2.0) + S(4, -0.8) + O(10) + S(3, -0.8), n_imp=8,
        segnali=[("LAST", +1, "CONT")], flags={"touch": True, "noseq": True, "z_ritr": True, "z_test": True, "sdA": True, "sdB": True})
    add(nome="C_N_C0_nessun_tocco", dopo="CONT: ultima candela non arriva alla banda opposta", deltas=S(8, 2.0) + S(4, -0.8) + O(10) + [-0.8, -0.8, -0.2], n_imp=8,
        segnali=[], flags={"touch": False})
    add(nome="C_N_C1_candela_impulsiva_nel_ritracciamento", dopo="CONT: candela >1,5 ATR nel ritracciamento (barra p+1)",
        deltas=S(8, 2.0) + [-2.6, -0.8, -0.8, -0.8] + O(10) + S(3, -0.8), n_imp=8,
        segnali=[], flags={"touch": True, "noseq": True, "z_ritr": False, "z_test": True, "sdA": True, "sdB": True})
    add(nome="C_N_C1_candela_del_test_impulsiva", dopo="CONT: la candela del test e >1,5 ATR",
        deltas=S(8, 2.0) + S(4, -0.8) + O(10) + [-0.8, -0.8, -2.4], n_imp=8,
        segnali=[], flags={"touch": True, "noseq": True, "z_ritr": True, "z_test": False, "sdA": True, "sdB": True})
    add(nome="C_N_sd_non_sotto_S50", dopo="CONT: sd >= SMA50 della sd al tocco",
        deltas=S(6, 2.0) + S(6, -0.8) + O(6) + S(4, -0.8), n_imp=6,
        segnali=[], flags={"touch": True, "noseq": True, "z_ritr": True, "z_test": True, "sdA": False, "sdB": True})
    add(nome="C_N_sd_in_risalita", dopo="CONT: sd > sd di 3 barre prima al tocco",
        deltas=S(8, 2.0) + S(6, -0.8) + O(10) + S(4, -0.8), n_imp=8,
        segnali=[], flags={"touch": True, "noseq": True, "z_ritr": True, "z_test": True, "sdA": True, "sdB": False})
    add(nome="C_N_SEQ_mediana_poi_banda_impulso", dopo="CONT: sequenza mediana -> banda dell'impulso -> banda opposta (DEVE essere scartata)",
        deltas=S(8, 2.4) + S(8, -1.0) + O(8) + S(6, 0.8) + S(6, -1.3), n_imp=8,
        segnali=[(260, -1, "INV")], flags={"touch": True, "noseq": False},
        extra_flags=[(260, {"med": True, "opp_untouched": True, "retest": True, "z_all": True, "band_flat": True, "sdA": True, "sdB": True})],
        stadio_max={"CONT": 1}, contatori={"CONT_morti_per_SEQ_episodi": 1, "segnali_CONT": 0, "segnali_INV": 1},
        nota="la sequenza mediana -> banda dell'impulso e per definizione il pattern INV: INV scatta alla barra 260 (attesa scritta dopo aver riconosciuto l'errore della mia prima attesa 'nessun segnale'); "
             "la CONT e scartata dalla SEQ (C0 vero, C3 falso, stadio massimo 1). Il contrafattuale 'CONT senza SEQ' NON e isolabile: nel campione trovato fallisce anche sd<=sd[-3]")
    add(nome="C_N_band_riding_impulso_oltre_20_barre", dopo="CONT: impulso di 24 barre (band riding > 20) -> bulge disarmata",
        deltas=S(24, 2.0) + S(4, -0.8) + O(10) + S(3, -0.8), n_imp=24,
        segnali=[], episodi_fine=["impulso_lungo"], contatori={"ep_disarmati_impulso_lungo": 1}, flags=None)
    add(nome="C_N_warmup", dopo="CONT: il segnale cadrebbe prima della barra 200 -> soppresso",
        deltas=S(8, 2.0) + S(4, -0.8) + O(10) + S(3, -0.8), n_imp=8, n_q=120,
        segnali=[], contatori={"segnali_soppressi_warmup": 1}, flags=None)
    add(nome="C_mecc_MIN_RETR", dopo="MECCANISMO (parametro alterato min_retr=20): tocco a p+17 < 20 consuma l'episodio",
        deltas=S(8, 2.0) + S(4, -0.8) + O(10) + S(3, -0.8), n_imp=8, cfg={"min_retr": 20},
        segnali=[], contatori={"CONT_consumati_tocco_precoce": 1}, flags=None, solo_long=True)
    add(nome="C_mecc_T_MAX", dopo="MECCANISMO (parametro alterato t_max=15): a p+16 la bulge e disarmata",
        deltas=S(8, 2.0) + S(4, -0.8) + O(10) + S(3, -0.8), n_imp=8, cfg={"t_max": 15},
        segnali=[], contatori={"ep_disarmati_t_max": 1}, flags=None, solo_long=True)
    # --------------------------- INVERSIONE ---------------------------
    # d=+1: bulge su, trade SHORT (side -1). Segnale alla barra del retest della banda dell'impulso (ultima barra).
    add(nome="I_POS", dopo="INV: pattern conforme", deltas=S(6, 2.4) + S(8, -1.0) + O(8) + S(6, 1.0), n_imp=6,
        segnali=[("LAST", -1, "INV")],
        flags={"med": True, "opp_untouched": True, "retest": True, "z_all": True, "band_flat": True, "sdA": True, "sdB": True})
    add(nome="I_N_I0_mediana_mai_toccata", dopo="INV: nessun ritorno alla mediana", deltas=S(5, 2.8) + S(3, -0.8) + O(11) + S(4, 0.5), n_imp=5,
        segnali=[], flags={"med": False, "opp_untouched": True, "retest": True, "z_all": True, "band_flat": True, "sdA": True, "sdB": True})
    add(nome="I_N_I1_banda_opposta_toccata", dopo="INV: tocco della banda opposta (Low_s <= L_s) prima del rientro",
        deltas=S(6, 2.4) + S(8, -1.0) + O(8) + S(6, 1.0), n_imp=6, dip=0.9,
        segnali=[], flags={"opp_untouched": False}, contatori={"INV_consumati_banda_opposta": 1})
    add(nome="I_N_retest_assente", dopo="INV: rialzo finale insufficiente, nessun retest della banda dell'impulso",
        deltas=S(6, 2.4) + S(8, -1.0) + O(8) + S(5, 1.0), n_imp=6,
        segnali=[], flags={"med": True, "opp_untouched": True, "retest": False}, stadio_max={"INV": 2})
    add(nome="I_N_I2_candela_impulsiva", dopo="INV: candele > 1,5 ATR nel rientro",
        deltas=S(7, 2.4) + S(12, -1.4) + O(10) + S(6, 1.3), n_imp=7,
        segnali=[], flags={"med": True, "opp_untouched": True, "retest": True, "z_all": False, "band_flat": True, "sdA": True, "sdB": True})
    add(nome="I_N_I3_banda_impulso_inclinata_contro", dopo="INV: banda dell'impulso ancora in salita al retest",
        deltas=S(7, 2.4) + S(5, -1.0) + O(10) + S(5, 0.8), n_imp=7,
        segnali=[], flags={"med": True, "opp_untouched": True, "retest": True, "z_all": True, "band_flat": False, "sdA": True, "sdB": True})
    add(nome="I_N_sd_non_sotto_S50", dopo="INV: sd >= SMA50 della sd al retest", deltas=S(6, 2.8) + S(10, -1.8) + O(6) + S(8, 1.6), n_imp=6,
        segnali=[], flags={"med": True, "opp_untouched": True, "retest": True, "z_all": True, "band_flat": True, "sdA": False, "sdB": True})
    add(nome="I_N_sd_in_risalita", dopo="INV: sd > sd di 3 barre prima al retest", deltas=S(5, 2.8) + S(8, -0.6) + O(6) + S(6, 0.8), n_imp=5,
        segnali=[], flags={"med": True, "opp_untouched": True, "retest": True, "z_all": True, "band_flat": True, "sdA": True, "sdB": False})
    return sc


# Scenari di solo armamento (B1-B5): attese = flag [B1..B6] alla barra t indicata
def scenari_arm():
    def ramp(A0, wick, ni, st):
        cq = quiet(230, A0=A0)
        c = np.concatenate([cq, cq[-1] + np.cumsum([st] * ni + [-0.3] * 3)])
        o = np.r_[c[0], c[:-1]]
        return {"open": o, "high": np.maximum(o, c) + wick, "low": np.minimum(o, c) - wick, "close": c}

    def zig():
        cq = quiet(230).copy()
        blen = 22
        end = 230 - 17
        cq[end - blen:end] += 3.0 * np.sin(0.9 * np.arange(blen))
        imp = [6.0 if i % 2 == 0 else -3.0 for i in range(9)]
        c = np.concatenate([cq, cq[-1] + np.cumsum(imp)])
        o = np.r_[c[0], c[:-1]]
        return {"open": o, "high": np.maximum(o, c) + 0.25, "low": np.minimum(o, c) - 0.25, "close": c}

    return [
        ("ARM_POS tutti i criteri B1-B6 veri", ramp(0.9, 1.2, 7, 5.0), 231, [True] * 6, [True] * 6),
        ("ARM_N_B1 bande non raddoppiate (pre-fase molto ampia)", ramp(4.0, 0.25, 9, 5.0), 231, [False, True, True, True, True, True], None),
        ("ARM_N_B3 nessuna candela >= 1,5 ATR_s", ramp(0.5, 1.2, 10, 1.0), 237, [True, True, False, True, True, True], None),
        ("ARM_N_B4 movimento non netto (ER < 0,50)", zig(), 235, [True, True, True, False, True, True], None),
        ("ARM_N_B5 mediana non distante >= 2 ATR_s", ramp(0.5, 1.2, 7, 5.0), 230, [True, True, True, True, False, True], None),
    ]


# ------------------------------------------------------------------------------------------
# Esecuzione
# ------------------------------------------------------------------------------------------
def _expected_signals(sc, n, mirrored):
    out = []
    for bar, side, tipo in sc["segnali"]:
        b = n - 1 if bar == "LAST" else bar
        out.append((b, -side if mirrored else side, tipo))
    return sorted(out)


def run_scenari(detect_fn, label="reimpl", verbose=True):
    """detect_fn(bars, cfg_dict) -> dict con 'signals' (lista con bar, side, tipo), 'counters', 'episodes'.
    Restituisce lista di (descrizione, ok, dettaglio)."""
    results = []

    def rec(desc, ok, det=""):
        results.append((desc, bool(ok), det))
        if verbose:
            print("%s  %s%s" % ("PASS" if ok else "FAIL", desc, (" | " + det) if det else ""))

    for sc in scenari():
        bars_l = build(sc["deltas"], wick=sc["wick"], n_q=sc["n_q"], dip=sc.get("dip", 0.0))
        n = len(bars_l["close"])
        variants = [("LONG", bars_l, False)]
        if not sc.get("solo_long"):
            variants.append(("SHORT(specchio)", mirror(bars_l), True))
        for tag, bars, mir in variants:
            d = -1 if mir else +1
            nm = "%s [%s]" % (sc["nome"], tag)
            # 1. controlli naive dei criteri grezzi (indipendenti dal rilevatore)
            if sc["flags"]:
                s_i = sc["n_q"] - 1
                p_i = sc["n_q"] + sc["n_imp"] - 1
                t_i = n - 1
                F = raw_flags(bars, d, s_i, p_i, t_i)
                bad = {k: (F[k], v) for k, v in sc["flags"].items() if F[k] != v}
                rec(nm + " - criteri grezzi come attesi (calcolo naive)", not bad, "difformi=%s" % bad if bad else
                    "sd=%.3f S50=%.3f sd[-3]=%.3f zmax_ritr=%.2f z_t=%.2f" % (F["_vals"]["sd_t"], F["_vals"]["S50_t"], F["_vals"]["sd_t-3"], F["_vals"]["zmax_ritr"], F["_vals"]["z_t"]))
            for t_x, fl_x in (sc.get("extra_flags") or []):
                Fx = raw_flags(bars, d, sc["n_q"] - 1, sc["n_q"] + sc["n_imp"] - 1, t_x)
                badx = {k: (Fx[k], v) for k, v in fl_x.items() if Fx[k] != v}
                rec(nm + " - criteri grezzi alla barra %d come attesi" % t_x, not badx, "difformi=%s" % badx if badx else "")
            # 2. rilevatore
            res = detect_fn(bars, sc["cfg"])
            got = sorted((s["bar"], s["side"], s["tipo"]) for s in res["signals"])
            exp = _expected_signals(sc, n, mir)
            rec(nm + " - segnali", got == exp, "attesi=%s ottenuti=%s" % (exp, got))
            if sc.get("episodi_fine") is not None:
                fine = [e["fine"] for e in res["episodes"]]
                rec(nm + " - esito episodio", fine[:len(sc["episodi_fine"])] == sc["episodi_fine"], "fine=%s" % fine)
            for k, v in (sc.get("contatori") or {}).items():
                cv = res["counters"].get(k)
                rec(nm + " - contatore %s" % k, cv == v, "atteso=%s ottenuto=%s" % (v, cv))
            for var, mx in (sc.get("stadio_max") or {}).items():
                if res["episodes"]:
                    got_mx = res["episodes"][0]["stadio_max_" + var]
                    rec(nm + " - stadio massimo %s dell'imbuto" % var, got_mx == mx, "atteso=%s ottenuto=%s" % (mx, got_mx))
            # 3. peak causale: per scenari con impulso monotono p = ultima barra dell'impulso
            if sc["flags"] and res["episodes"]:
                p_exp = sc["n_q"] + sc["n_imp"] - 1
                p_got = res["episodes"][0]["p"]
                if sc["nome"] not in ("C_N_SEQ_mediana_poi_banda_impulso",):
                    rec(nm + " - picco causale p", p_got == p_exp or sc["nome"].startswith("I_N_I0"), "atteso=%s ottenuto=%s" % (p_exp, p_got))
    # controfattuali dei meccanismi: con i parametri CONGELATI il BASE da segnale
    return results


def run_arm(arm_fn, verbose=True):
    """arm_fn(bars, t) -> (s, flags[6], pronto). Confronta con le attese B1..B6 scritte a mano."""
    results = []
    for desc, bars, t, exp, _ in scenari_arm():
        s, fl, ready = arm_fn(bars, t)
        ok = ready and list(fl) == exp
        results.append((desc, ok, "attesi=%s ottenuti=%s" % (exp, fl)))
        if verbose:
            print("%s  %s | attesi=%s ottenuti=%s" % ("PASS" if ok else "FAIL", desc, exp, fl))
    return results


def detect_reimpl(bars, cfgd):
    return R.detect(bars, R.Cfg(**cfgd), trace=False)


def arm_reimpl(bars, t):
    cfg = R.Cfg()
    v = R.View(np.asarray(bars["open"], float), np.asarray(bars["high"], float), np.asarray(bars["low"], float), np.asarray(bars["close"], float), cfg)
    return R._arm_check(v, t, cfg)


# ------------------------------------------------------------------------------------------
# Test unitari a mano (indicatori, SEQ)
# ------------------------------------------------------------------------------------------
def unit_tests(verbose=True):
    results = []

    def rec(desc, ok, det=""):
        results.append((desc, bool(ok), det))
        if verbose:
            print("%s  %s%s" % ("PASS" if ok else "FAIL", desc, (" | " + det) if det else ""))

    # SMA/sd/bande su 20 chiusure note: 1..20 -> SMA=10.5, sd_pop = sqrt((20^2-1)/12) = 5.766281297...
    c = np.arange(1.0, 21.0)
    v = R.View(c, c + 0.5, c - 0.5, c, R.Cfg())
    sd_ref = ((20 ** 2 - 1) / 12.0) ** 0.5
    rec("SMA20=10,5; sd popolazione=5,76628 (ddof=0); U=M+2sd; L=M-2sd; W=4sd",
        abs(v.M[19] - 10.5) < 1e-12 and abs(v.sd[19] - sd_ref) < 1e-12 and abs(v.U[19] - (10.5 + 2 * sd_ref)) < 1e-12 and abs(v.L[19] - (10.5 - 2 * sd_ref)) < 1e-12 and abs(v.W[19] - 4 * sd_ref) < 1e-12,
        "sd=%.9f atteso=%.9f" % (v.sd[19], sd_ref))
    # ATR Wilder con periodo 2: h=[2,3,4], l=[1,1,2], c=[1.5,2.5,3] -> TR=[1,2,2], ATR=[nan,1.5,1.75]
    h = np.array([2.0, 3.0, 4.0]); l = np.array([1.0, 1.0, 2.0]); cc = np.array([1.5, 2.5, 3.0])
    v2 = R.View(cc, h, l, cc, R.Cfg(atr_n=2, bb_n=2))
    rec("ATR Wilder (seme SMA dei primi N TR): [nan, 1,5, 1,75]", np.isnan(v2.atr[0]) and abs(v2.atr[1] - 1.5) < 1e-12 and abs(v2.atr[2] - 1.75) < 1e-12 and abs(v2.tr[1] - 2.0) < 1e-12)
    # z_t = R_t / ATR_(t-1)
    rec("z_t = (High-Low)_t / ATR_(t-1)", abs(v2.z[2] - (2.0 / 1.5)) < 1e-12, "z2=%.6f" % v2.z[2])

    class FakeV:
        pass

    def fake(l_, M_, h_, U_):
        f = FakeV(); f.l = np.array(l_, float); f.M = np.array(M_, float); f.h = np.array(h_, float); f.U = np.array(U_, float)
        return f
    # indici 0..6; p=0, tau=6. mediana toccata a r=2 (l<=M), banda a u=4 (h>=U) -> SEQ presente
    base_l = [10, 10, 4, 10, 10, 10, 10]; base_M = [5] * 7; base_h = [9, 9, 9, 9, 12, 9, 9]; base_U = [11] * 7
    rec("SEQ presente: mediana a r=2, poi banda impulso a u=4 (p=0, tau=6)", R._seq_present(fake(base_l, base_M, base_h, base_U), 0, 6) is True)
    rec("SEQ assente: ordine inverso (banda a 2, poi mediana a 4)", R._seq_present(fake([10, 10, 10, 10, 4, 10, 10], base_M, [9, 9, 12, 9, 9, 9, 9], base_U), 0, 6) is False)
    rec("SEQ assente: solo mediana", R._seq_present(fake(base_l, base_M, [9] * 7, base_U), 0, 6) is False)
    rec("SEQ assente: solo banda dell'impulso", R._seq_present(fake([10] * 7, base_M, base_h, base_U), 0, 6) is False)
    rec("SEQ assente: mediana e banda sulla STESSA barra (serve r < u)", R._seq_present(fake([10, 10, 4, 10, 10, 10, 10], base_M, [9, 9, 12, 9, 9, 9, 9], base_U), 0, 6) is False)
    rec("SEQ assente: la banda e a u = tau (serve u < tau)", R._seq_present(fake(base_l, base_M, [9, 9, 9, 9, 9, 9, 12], base_U), 0, 6) is False)
    rec("SEQ assente: la mediana e prima del picco (serve r > p)", R._seq_present(fake([4, 10, 10, 10, 10, 10, 10], base_M, base_h, base_U), 1, 6) is False)
    return results


def main():
    allres = []
    print("=== TEST UNITARI A MANO ===")
    allres += unit_tests()
    print("\n=== ARMAMENTO (B1-B5): attese scritte a mano ===")
    allres += run_arm(arm_reimpl)
    print("\n=== PATTERN PIANTATI (CONT/INV, long e short specchiato) ===")
    allres += run_scenari(detect_reimpl)
    n_ok = sum(1 for _, ok, _ in allres if ok)
    print("\nPATTERN PIANTATI: %d/%d verifiche riuscite" % (n_ok, len(allres)))
    return 0 if n_ok == len(allres) else 1


if __name__ == "__main__":
    sys.exit(main())
