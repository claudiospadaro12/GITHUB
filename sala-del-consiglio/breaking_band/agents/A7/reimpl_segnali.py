#!/usr/bin/env python3
# -*- coding: utf-8 -*-
"""
reimpl_segnali.py - Reimplementazione INDIPENDENTE del nucleo dei segnali Breaking Band (A7).

Scritta leggendo SOLO congelati/specifica_v1.md (sha256 4da8af64...995c2e... vedi piano). Non conosce ne importa il
codice di A4. Dipendenze: numpy. Un solo percorso di codice per long e short: il caso d=-1 si ottiene specchiando
i prezzi (o,h,l,c) -> (-o,-l,-h,-c) e riusando le stesse funzioni (spec sez. 3 "Simmetria").

Interfaccia:
    detect(bars, cfg=None, trace=False) -> dict
        bars: dict con 'open','high','low','close' (array 1-D, stessa lunghezza; barre del TF gia costruite).
        Restituisce:
          'signals'  : lista di dict {bar, side, tipo, d, ep, s, p, t0}  (bar = indice della barra di tocco tau,
                       side = +1 long / -1 short, tipo = 'CONT' | 'INV'). L'ingresso (fuori da questo modulo) e a tau+1.
          'counters' : dict di contatori d'imbuto (vedi sotto)
          'episodes' : lista di episodi (id, d, s, t0, p finale, motivo di chiusura, stadio massimo per variante)
          'trace'    : (solo se trace=True) valutazioni per barra: flag di ogni condizione, per attribuire le morti.

LETTURE LETTERALI ADOTTATE DOVE LA SPECIFICA E AMBIGUA: vedi domande.md (Q1..Q14). Le alternative sono
selezionabili con Cfg (opzioni 'alt_*') e servono a confronto_con_A4.py per attribuire le divergenze.
"""
import numpy as np
from numpy.lib.stride_tricks import sliding_window_view

STAGES_CONT = ["C0_tocco_banda_opposta", "C3_SEQ_assente", "C1_nessuna_impulsiva", "C2a_sd<S50", "C2b_sd<=sd[-3]"]
STAGES_INV = ["I0_mediana_toccata", "I1_banda_opposta_mai_toccata", "I0_retest_banda_impulso",
              "I2_nessuna_impulsiva", "I3_banda_piatta", "I4a_sd<S50", "I4b_sd<=sd[-3]"]
B_NAMES = ["B1_bande_aperte", "B2_sd>S50", "B3_candela_impulsiva", "B4_ER", "B5_mediana_distante", "B6_impulso<=20"]


class Cfg:
    """Parametri della tabella flat di specifica_v1.md sez. 9 (+ opzioni 'alt_*' per letture alternative)."""
    def __init__(self, **kw):
        self.bb_n = 20
        self.bb_k = 2.0
        self.s50_n = 50
        self.atr_n = 14
        self.warmup = 200          # le prime 200 barre non generano segnali
        self.win_imp = 20          # finestra del minimo [t-19, t]
        self.ref_barre = 15        # W_ref su [s-14, s]
        self.b1_w = 2.0
        self.b3_atr = 1.5
        self.b4_er = 0.50
        self.b5_atr = 2.0
        self.b6_barre = 20
        self.min_retr = 3
        self.t_max = 30
        self.impulsiva = 1.5       # CONT
        self.impulsiva_inv = 1.5   # INV (sensibilita Sb: 1.0)
        self.band_tol = 0.10
        self.sd_lag = 3
        self.sd_gate = True        # sensibilita Sa: False spegne sd<S50 (resta sd<=sd[-3])
        # --- letture alternative di punti ambigui (default = lettura piu letterale, vedi domande.md) ---
        self.alt_arm_early = False             # Q1/D008: default = si arma solo da barra >= warmup (200); True = da indicatori pronti
        self.alt_consume_reset_on_new_p = False  # Q4: il consumo CONT per tocco precoce si annulla se p riparte
        self.alt_cont_first_touch_only = False   # Q3: il primo tocco (tau-p>=3) deve soddisfare tutto, altrimenti CONT consumata
        self.alt_eval_from_arm_bar = False       # Q6: valutare il pattern gia alla barra di armamento t0
        self.alt_warmup_not_consume = False      # Q2: un segnale soppresso dal warm-up non consuma l'episodio
        for k, v in kw.items():
            if not hasattr(self, k):
                raise AttributeError("parametro sconosciuto: %s" % k)
            setattr(self, k, v)


# ---------------------------------------------------------------------------------------------
# Indicatori (spec sez. 3). Valori alla CHIUSURA della barra t con sole barre <= t.
# ---------------------------------------------------------------------------------------------
class View:
    """Indicatori su una serie (d=+1). Per d=-1 si costruisce View sulla serie specchiata."""
    def __init__(self, o, h, l, c, cfg):
        n = len(c)
        self.n = n
        self.o, self.h, self.l, self.c = o, h, l, c
        N = cfg.bb_n
        self.M = np.full(n, np.nan)
        self.sd = np.full(n, np.nan)
        if n >= N:
            win = sliding_window_view(c, N)
            self.M[N - 1:] = win.mean(axis=1)
            self.sd[N - 1:] = win.std(axis=1)          # ddof = 0 (popolazione)
        self.U = self.M + cfg.bb_k * self.sd
        self.L = self.M - cfg.bb_k * self.sd
        self.W = 4.0 * self.sd
        self.S50 = np.full(n, np.nan)
        first = N - 1                                  # primo sd valido
        if n >= first + cfg.s50_n:
            w2 = sliding_window_view(self.sd[first:], cfg.s50_n)
            self.S50[first + cfg.s50_n - 1:] = w2.mean(axis=1)
        # ATR(14) di Wilder, seme = SMA dei primi 14 TR; TR[0] = H-L (nessuna chiusura precedente)
        tr = np.empty(n)
        if n:
            tr[0] = h[0] - l[0]
            pc = c[:-1]
            tr[1:] = np.maximum.reduce([h[1:] - l[1:], np.abs(h[1:] - pc), np.abs(l[1:] - pc)])
        self.tr = tr
        self.atr = np.full(n, np.nan)
        A = cfg.atr_n
        if n >= A:
            self.atr[A - 1] = tr[:A].mean()
            for i in range(A, n):
                self.atr[i] = (self.atr[i - 1] * (A - 1) + tr[i]) / A
        self.R = h - l
        self.z = np.full(n, np.nan)                    # z_t = R_t / ATR_(t-1)
        if n > 1:
            self.z[1:] = self.R[1:] / self.atr[:-1]


def _arm_check(v, t, cfg):
    """Condizioni B1-B6 per d=+1 alla chiusura di t. Restituisce (s, flags[6], pronto)."""
    lo = t - cfg.win_imp + 1
    if lo < 0:
        return None, None, False
    s = lo + int(np.argmin(v.l[lo:t + 1]))            # a parita, la prima
    a = s - (cfg.ref_barre - 1)
    if a < 0:
        return None, None, False
    wwin = v.W[a:s + 1]
    if np.isnan(wwin).any() or np.isnan(v.S50[t]) or np.isnan(v.atr[s]) or np.isnan(v.M[t]):
        return None, None, False
    wref = float(np.median(wwin))
    atr_s = v.atr[s]
    B1 = v.W[t] >= cfg.b1_w * wref
    B2 = v.sd[t] > v.S50[t]
    B3 = False
    for u in range(s + 1, t + 1):
        if v.R[u] >= cfg.b3_atr * atr_s and v.c[u] > v.o[u]:
            B3 = True
            break
    den = float(np.sum(np.abs(np.diff(v.c[s:t + 1])))) if t > s else 0.0
    B4 = bool(den > 0 and abs(v.c[t] - v.c[s]) / den >= cfg.b4_er and v.c[t] > v.c[s])
    B5 = (v.c[t] - v.M[t]) >= cfg.b5_atr * atr_s
    B6 = (t - s) <= cfg.b6_barre
    return s, [bool(B1), bool(B2), bool(B3), B4, bool(B5), bool(B6)], True


def _seq_present(v, p, tau):
    """SEQ (C3): esiste p < r < u < tau con Low_r <= M_r e High_u >= U_u."""
    for r in range(p + 1, tau - 1):
        if v.l[r] <= v.M[r]:
            for u in range(r + 1, tau):
                if v.h[u] >= v.U[u]:
                    return True
            return False        # r piu precoce che tocca la mediana: se non c'e u dopo di esso, nessun r successivo ne avra
    return False


class _Ep:
    pass


def detect(bars, cfg=None, trace=False):
    cfg = cfg or Cfg()
    def g(*names):
        for nm in names:
            if nm in bars:
                return np.asarray(bars[nm], dtype=float)
        raise KeyError(names)
    o, h, l, c = g("open", "o"), g("high", "h"), g("low", "l"), g("close", "c")
    n = len(c)
    V = {1: View(o, h, l, c, cfg), -1: View(-o, -l, -h, -c, cfg)}
    cnt = {"barre_totali": n, "barre_con_indicatori_per_armo": 0}
    for k in B_NAMES:
        cnt["marg_" + k] = 0
    for i in range(1, 7):
        cnt["cum_B1..B%d" % i] = 0
    cnt.update({"armati": 0, "armati_+1": 0, "armati_-1": 0, "armo_bloccato_s<=p_prec": 0,
                "ep_sostituiti_stessa_dir": 0, "ep_disarmati_dir_opposta": 0, "ep_disarmati_impulso_lungo": 0,
                "ep_disarmati_t_max": 0, "ep_con_barra_p+MIN_RETR": 0,
                "CONT_consumati_tocco_precoce": 0, "CONT_morti_per_SEQ_episodi": 0, "INV_consumati_banda_opposta": 0,
                "info_CONT_ritorno_banda_senza_mediana": 0, "segnali_soppressi_warmup": 0,
                "segnali_CONT": 0, "segnali_INV": 0})
    for i, nm in enumerate(STAGES_CONT):
        cnt["CONT_ep_stadio%d_%s" % (i, nm)] = 0
    for i, nm in enumerate(STAGES_INV):
        cnt["INV_ep_stadio%d_%s" % (i, nm)] = 0
    cnt["CONT_C1_morti_su_candela_del_test"] = 0
    cnt["CONT_C1_morti_nel_ritracciamento"] = 0
    signals, episodes, tr_out = [], [], []
    ep = None
    last_p = {1: -1, -1: -1}
    n_ep = 0
    arm_from = 0 if cfg.alt_arm_early else cfg.warmup     # D008: episodi armati da barra 200

    def close_ep(e, reason):
        e.end = reason
        for var, mx in (("CONT", e.max_stage["CONT"]), ("INV", e.max_stage["INV"])):
            stages = STAGES_CONT if var == "CONT" else STAGES_INV
            for k in range(1, mx + 1):
                cnt["%s_ep_stadio%d_%s" % (var, k - 1, stages[k - 1])] += 1
        episodes.append({"id": e.id, "d": e.d, "s": e.s, "t0": e.t0, "p": e.p, "fine": reason,
                         "stadio_max_CONT": e.max_stage["CONT"], "stadio_max_INV": e.max_stage["INV"],
                         "segnali": list(e.sigs)})

    for t in range(n):
        # ----- 1. episodio attivo: aggiorna p, controlla durata, valuta i pattern -----
        if ep is not None and (t > ep.t0 or cfg.alt_eval_from_arm_bar):
            v = V[ep.d]
            if t > ep.t0 and v.h[t] > v.h[ep.p]:           # nuovo estremo: la fase riparte
                ep.p = t
                if cfg.alt_consume_reset_on_new_p:
                    ep.consumed["CONT"] = False
            last_p[ep.d] = ep.p
            if ep.p - ep.s > cfg.b6_barre:
                cnt["ep_disarmati_impulso_lungo"] += 1
                close_ep(ep, "impulso_lungo")
                ep = None
            elif t - ep.p > cfg.t_max:
                cnt["ep_disarmati_t_max"] += 1
                close_ep(ep, "t_max")
                ep = None
            else:
                _evaluate(ep, V[ep.d], t, cfg, cnt, signals, tr_out if trace else None)
        # ----- 2. armamento (dopo la valutazione, stessa chiusura) -----
        if t >= arm_from:
            for d in (1, -1):
                v = V[d]
                s, fl, ready = _arm_check(v, t, cfg)
                if not ready:
                    continue
                cnt["barre_con_indicatori_per_armo"] += 1 if d == 1 else 0
                for i, f in enumerate(fl):
                    if f:
                        cnt["marg_" + B_NAMES[i]] += 1
                for i in range(1, 7):
                    if all(fl[:i]):
                        cnt["cum_B1..B%d" % i] += 1
                if not all(fl):
                    continue
                if s <= last_p[d]:
                    cnt["armo_bloccato_s<=p_prec"] += 1
                    continue
                # nuovo episodio
                if ep is not None:
                    if ep.d == d:
                        cnt["ep_sostituiti_stessa_dir"] += 1
                        close_ep(ep, "sostituito_stessa_dir")
                    else:
                        cnt["ep_disarmati_dir_opposta"] += 1
                        close_ep(ep, "disarmato_dir_opposta")
                n_ep += 1
                e = _Ep()
                e.id, e.d, e.s, e.t0 = n_ep, d, s, t
                e.p = s + int(np.argmax(v.h[s:t + 1]))      # running extreme, a parita il primo
                e.consumed = {"CONT": False, "INV": False}
                e.max_stage = {"CONT": 0, "INV": 0}
                e.reached_minretr = False
                e.seq_flag = False
                e.sigs = []
                e.end = None
                ep = e
                last_p[d] = e.p
                cnt["armati"] += 1
                cnt["armati_%+d" % d] += 1
    if ep is not None:
        close_ep(ep, "fine_dati")
    return {"signals": signals, "counters": cnt, "episodes": episodes, "trace": tr_out if trace else None, "cfg": cfg}


def _evaluate(ep, v, t, cfg, cnt, signals, tr_out):
    p, s = ep.p, ep.s
    d = ep.d
    dp = t - p
    if dp >= cfg.min_retr and not ep.reached_minretr:
        ep.reached_minretr = True
        cnt["ep_con_barra_p+MIN_RETR"] += 1
    sd_ok_a = bool(v.sd[t] < v.S50[t]) if cfg.sd_gate else True
    sd_ok_b = bool(t - cfg.sd_lag >= 0 and v.sd[t] <= v.sd[t - cfg.sd_lag])
    touch_L = bool(v.l[t] <= v.L[t])
    # ------------------ CONTINUAZIONE ------------------
    if not ep.consumed["CONT"]:
        if touch_L and dp < cfg.min_retr:
            ep.consumed["CONT"] = True
            cnt["CONT_consumati_tocco_precoce"] += 1
            if tr_out is not None:
                tr_out.append({"ep": ep.id, "t": t, "tipo": "CONT", "evento": "consumato_tocco_precoce", "d": d, "p": p})
        elif dp >= cfg.min_retr:
            C0 = touch_L
            seq = _seq_present(v, p, t) if C0 else False
            C3 = not seq
            C1_ritr = bool(np.all(v.z[p + 1:t] <= cfg.impulsiva)) if t > p + 1 else True
            C1_test = bool(v.z[t] <= cfg.impulsiva)
            C1 = C1_ritr and C1_test
            flags = [C0, C3, C1, sd_ok_a, sd_ok_b]
            k = 0
            while k < len(flags) and flags[k]:
                k += 1
            if C0 and k > ep.max_stage["CONT"]:
                ep.max_stage["CONT"] = k
            if C0:
                # contatore informativo: ritorno alla banda dell'impulso SENZA tocco di mediana
                med = any(v.l[r] <= v.M[r] for r in range(p + 1, t))
                band = any(v.h[u] >= v.U[u] for u in range(p + 1, t))
                if band and not med:
                    cnt["info_CONT_ritorno_banda_senza_mediana"] += 1
                if not C3 and not ep.seq_flag:
                    ep.seq_flag = True
                    cnt["CONT_morti_per_SEQ_episodi"] += 1
                if C3 and not C1:
                    cnt["CONT_C1_morti_nel_ritracciamento" if not C1_ritr else "CONT_C1_morti_su_candela_del_test"] += 1
            if tr_out is not None and C0:
                tr_out.append({"ep": ep.id, "t": t, "tipo": "CONT", "d": d, "p": p, "C0": C0, "C3_SEQ_assente": C3,
                               "C1_nessuna_impulsiva": C1, "C1_ritracciamento": C1_ritr, "C1_test": C1_test,
                               "sd<S50": sd_ok_a, "sd<=sd[-3]": sd_ok_b, "tutte": all(flags)})
            if all(flags):
                _emit(ep, t, "CONT", d, cfg, cnt, signals)
            elif cfg.alt_cont_first_touch_only and C0:
                ep.consumed["CONT"] = True
    # ------------------ INVERSIONE ------------------
    if not ep.consumed["INV"]:
        touched_opp = bool(np.any(v.l[s:t + 1] <= v.L[s:t + 1]))     # I1 negata: Low_u <= L_u per qualche u in [s, tau]
        med_r = any(v.l[r] <= v.M[r] for r in range(p + 1, t))        # I0: r in (p, tau) con Low_r <= M_r
        retest = bool(dp >= cfg.min_retr and v.h[t] >= v.U[t] and v.h[t] <= v.h[p])
        I2 = bool(np.all(v.z[p + 1:t + 1] <= cfg.impulsiva_inv))
        I3 = bool(t >= 4 and (v.U[t - 1] - v.U[t - 4]) <= cfg.band_tol * v.atr[t - 1])
        flags = [med_r, not touched_opp, retest, I2, I3, sd_ok_a, sd_ok_b]
        k = 0
        while k < len(flags) and flags[k]:
            k += 1
        if k > ep.max_stage["INV"]:
            ep.max_stage["INV"] = k
        if tr_out is not None and (retest or touched_opp):
            tr_out.append({"ep": ep.id, "t": t, "tipo": "INV", "d": d, "p": p, "I0_mediana": med_r,
                           "I1_banda_opposta_mai_toccata": not touched_opp, "retest": retest,
                           "I2_nessuna_impulsiva": I2, "I3_banda_piatta": I3,
                           "sd<S50": sd_ok_a, "sd<=sd[-3]": sd_ok_b, "tutte": all(flags)})
        if touched_opp:
            ep.consumed["INV"] = True
            cnt["INV_consumati_banda_opposta"] += 1
        elif all(flags):
            _emit(ep, t, "INV", d, cfg, cnt, signals)


def _emit(ep, t, tipo, d, cfg, cnt, signals):
    side = d if tipo == "CONT" else -d
    if t < cfg.warmup:
        cnt["segnali_soppressi_warmup"] += 1
        if not cfg.alt_warmup_not_consume:
            ep.consumed[tipo] = True
        return
    signals.append({"bar": t, "side": side, "tipo": tipo, "d": d, "ep": ep.id, "s": ep.s, "p": ep.p, "t0": ep.t0})
    ep.sigs.append((t, tipo))
    ep.consumed[tipo] = True
    cnt["segnali_" + tipo] += 1
    # tutti gli stadi raggiunti
    ep.max_stage[tipo] = len(STAGES_CONT) if tipo == "CONT" else len(STAGES_INV)


def segnali_tuple(res):
    """[(bar, side, tipo)] ordinato."""
    return sorted((s["bar"], s["side"], s["tipo"]) for s in res["signals"])


if __name__ == "__main__":
    print(__doc__)
