"""Macchina a stati dei segnali Breaking Band (CONT / INV) — A4, fase 3.

Implementa ESATTAMENTE specifica_v1.md (sez. 3-5 e 7). Regole di costruzione:
- CAUSALE: il segnale alla barra tau usa solo barre <= tau (nessun center=True, nessun pivot a destra,
  nessuna statistica globale). Il picco p e' il "running extreme".
- UN SOLO percorso di codice: il caso d=-1 si ottiene dallo SPECCHIO dei prezzi (High -> -Low, Low -> -High,
  Open/Close/mediana -> segno opposto, banda alta <-> banda bassa) in `_Vista`; tutte le regole sono scritte
  una volta sola per d=+1 sugli array della vista.
- Nessun valore numerico nel codice: tutte le soglie vengono da params.py (tabella di specifica sez. 9;
  le soglie A2 dei soli descrittori da params.DESCRITTORI_A2).
- Due varianti separate (CONT, INV): `rileva(..., variante)` e' una macchina per variante. Il ciclo di vita
  dell'episodio (armamento, picco, disarmo) e' identico nelle due; cambia solo la valutazione del test.
- I descrittori (n_prev, solidita, congestione, ...) NON sono mai filtri.

Stadi dell'imbuto per EPISODIO (un episodio supera lo stadio k se esiste una barra che soddisfa le
condizioni 1..k nell'ordine): vedi STADI_CONT / STADI_INV. Imbuto per BARRA per i criteri B1..B6
(marginali e cumulativi) calcolato per direzione.
"""
from __future__ import annotations

import math

import numpy as np
from numpy.lib.stride_tricks import sliding_window_view

from params import PARAMS, DESCRITTORI_A2 as DA
import engine as E

VARIANTI = ("CONT", "INV")

STADI_CONT = ["armati", "finestra", "C0_tocco_banda_opposta", "C3_sequenza", "C1a_ritracciamento_non_impulsivo",
              "C1b_candela_test_non_impulsiva", "sd<S50", "sd<=sd[-3]", "SEGNALE"]
STADI_INV = ["armati", "finestra", "I0_mediana_toccata", "I1_banda_opposta_mai_toccata", "retest_banda_impulso",
             "I2_nessuna_impulsiva", "I3_banda_piatta", "sd<S50", "sd<=sd[-3]", "SEGNALE"]
NOMI_B = ["B1_bande_aperte", "B2_sd>S50", "B3_candela_impulsiva", "B4_ER", "B5_mediana_distante", "B6_impulso<=20"]


# ----------------------------------------------------------------------------- utilita'

def barre_da_dict(bars: dict, periodo_min: int) -> E.Barre:
    """Barre gia aggregate come dict (time, open, high, low, close[, spread]) -> E.Barre (interfaccia A7)."""
    n = len(bars["time"])
    return E.Barre(periodo=periodo_min, t=np.asarray(bars["time"], dtype=np.int64),
                   o=np.asarray(bars["open"], dtype=np.float64), h=np.asarray(bars["high"], dtype=np.float64),
                   l=np.asarray(bars["low"], dtype=np.float64), c=np.asarray(bars["close"], dtype=np.float64),
                   tv=np.zeros(n, dtype=np.int64), i0=np.arange(n, dtype=np.int64),
                   i1=np.arange(n, dtype=np.int64) + 1)


def spread_barre(m1: E.M1, barre: E.Barre, punto: float | None = None) -> np.ndarray:
    """Spread di barra in USD = MEDIANA degli spread delle M1 della barra (solo per descrittori e Sf)."""
    punto = PARAMS["PUNTO"] if punto is None else punto
    out = np.empty(barre.n)
    for k in range(barre.n):
        out[k] = np.median(m1.sp[barre.i0[k]:barre.i1[k]])
    return out * punto


def signal_fn_factory(variante: str, periodo_min: int, prm: dict | None = None):
    """Per A7: signal_fn(bars) -> dict {'signal': int8 (+1/-1/0), 'atr', 'sma20'} con valore in j dipendente
    solo dalle barre 0..j. `bars` = dict time, open, high, low, close[, spread (punti)]."""
    prm = prm or PARAMS

    def fn(bars: dict) -> dict:
        b = barre_da_dict(bars, periodo_min)
        ind = E.indicatori(b)
        sp = None
        if "spread" in bars:
            sp = np.asarray(bars["spread"], dtype=np.float64) * prm["PUNTO"]
        r = rileva(b, ind, variante, prm, sp_bar=sp)
        sig = np.zeros(b.n, dtype=np.int8)
        for s in r["segnali"]:
            sig[s["j"]] = s["side"]
        return {"signal": sig, "atr": ind.atr14, "sma20": ind.sma20}

    return fn


# ----------------------------------------------------------------------------- vista (specchio)

class _Vista:
    """Array normalizzati sul caso d=+1. Per d=-1 i prezzi sono cambiati di segno e High/Low, banda alta/bassa
    scambiati: hi=-Low, lo=-High, op=-Open, cl=-Close, M=-mediana, U=-banda bassa, L=-banda alta."""

    def __init__(self, d: int, barre: E.Barre, ind: E.Indicatori):
        self.d = d
        if d == 1:
            self.hi, self.lo, self.op, self.cl = barre.h, barre.l, barre.o, barre.c
            self.M, self.U, self.L = ind.sma20, ind.bb_up, ind.bb_lo
        else:
            self.hi, self.lo, self.op, self.cl = -barre.l, -barre.h, -barre.o, -barre.c
            self.M, self.U, self.L = -ind.sma20, -ind.bb_lo, -ind.bb_up


def _regressione(y: np.ndarray):
    """pendenza e R^2 della regressione lineare di y su 0..len-1."""
    n = y.size
    x = np.arange(n, dtype=np.float64)
    xm, ym = x.mean(), y.mean()
    sxx = float(((x - xm) ** 2).sum())
    sxy = float(((x - xm) * (y - ym)).sum())
    syy = float(((y - ym) ** 2).sum())
    slope = sxy / sxx if sxx > 0 else 0.0
    r2 = (sxy * sxy) / (sxx * syy) if sxx > 0 and syy > 0 else 0.0
    return slope, r2


class _Ctx:
    def __init__(self, barre: E.Barre, ind: E.Indicatori, prm: dict, sp_bar):
        self.b, self.ind, self.prm = barre, ind, prm
        self.n = barre.n
        n = self.n
        self.sp = sp_bar
        self.R = barre.h - barre.l                       # range High-Low (K10)
        self.tr = E.true_range(barre)                    # solo per i descrittori A2
        self.atr, self.sd, self.s50 = ind.atr14, ind.std20, ind.std20_sma50
        self.W = ind.bb_up - ind.bb_lo
        self.z = np.full(n, np.nan)                      # z_t = R_t / ATR_(t-1)
        self.ztr = np.full(n, np.nan)                    # TR_t / ATR_(t-1) (descrittori A2)
        if n > 1:
            with np.errstate(invalid="ignore", divide="ignore"):
                self.z[1:] = self.R[1:] / self.atr[:-1]
                self.ztr[1:] = self.tr[1:] / self.atr[:-1]
        k = DA["K3_N"]
        self.sma50c = np.full(n, np.nan)
        if n >= k:
            self.sma50c[k - 1:] = sliding_window_view(barre.c, k).mean(axis=1)
        w = prm["WIN_IMPULSO"]
        idx = np.arange(n)
        fin = np.isfinite(self.W) & np.isfinite(self.sd) & np.isfinite(self.s50) & np.isfinite(self.atr) \
            & np.isfinite(ind.sma20)
        self.valid = fin & (idx >= max(prm["WARMUP"], w - 1))
        self.vista = {1: _Vista(1, barre, ind), -1: _Vista(-1, barre, ind)}
        self.arm = {d: self._armamento(self.vista[d]) for d in (1, -1)}
        self._cong: dict = {}
        if prm["TOCCO_PEN_SPREAD"] and sp_bar is None:
            raise ValueError("TOCCO_PEN_SPREAD != 0 richiede sp_bar (spread di barra in USD)")

    # --- criteri B1..B6 (vettoriali, causali: la riga t usa solo barre <= t)
    def _armamento(self, v: _Vista) -> dict:
        prm, n = self.prm, self.n
        w, ref = prm["WIN_IMPULSO"], prm["REF_BARRE"]
        z = np.zeros(n, dtype=bool)
        out = {"s": np.full(n, -1, dtype=np.int64), "b": [z.copy() for _ in range(6)], "cand": z.copy()}
        if n < max(w, ref):
            return out
        off = sliding_window_view(v.lo, w).argmin(axis=1)           # prima occorrenza a parita'
        s_arr = np.full(n, -1, dtype=np.int64)
        s_arr[w - 1:] = np.arange(n - w + 1) + off
        out["s"] = s_arr
        ok = (s_arr >= 0) & self.valid
        sc = np.where(s_arr >= 0, s_arr, 0)
        wref = np.full(n, np.nan)
        wref[ref - 1:] = np.median(sliding_window_view(self.W, ref), axis=1)
        rdir = np.where(v.cl > v.op, self.R, 0.0)
        mx = np.zeros(n)
        mask = np.arange(w)[None, :] > off[:, None]
        mx[w - 1:] = np.where(mask, sliding_window_view(rdir, w), 0.0).max(axis=1)
        path = np.concatenate(([0.0], np.cumsum(np.abs(np.diff(v.cl)))))
        den = path - path[sc]
        num = np.abs(v.cl - v.cl[sc])
        with np.errstate(invalid="ignore", divide="ignore"):
            er = np.where(den > 0, num / np.where(den > 0, den, 1.0), 0.0)
            b1 = self.W >= prm["B1_W"] * wref[sc]
            b2 = self.sd > self.s50
            b3 = mx >= prm["B3_ATR"] * self.atr[sc]
            b4 = (er >= prm["B4_ER"]) & (v.cl > v.cl[sc]) & (den > 0)
            b5 = (v.cl - v.M) >= prm["B5_ATR"] * self.atr[sc]
            b6 = (np.arange(n) - s_arr) <= prm["B6_BARRE"]
        out["b"] = [(b & ok) for b in (b1, b2, b3, b4, b5, b6)]
        c = ok.copy()
        for b in out["b"]:
            c &= b
        out["cand"] = c
        return out

    # --- tocchi (specchio gia' applicato dalla vista)
    def _soglia_pen(self, u: int) -> float:
        k = self.prm["TOCCO_PEN_SPREAD"]
        return float(k * self.sp[u]) if k else 0.0

    def tocco_impulso(self, v: _Vista, u: int) -> bool:        # banda dell'impulso: High >= U
        return bool(v.hi[u] - v.U[u] >= self._soglia_pen(u))

    def tocco_opposta(self, v: _Vista, u: int) -> bool:        # banda opposta: Low <= L
        return bool(v.L[u] - v.lo[u] >= self._soglia_pen(u))

    @staticmethod
    def tocco_mediana(v: _Vista, u: int) -> bool:              # Low <= M (include barra interamente oltre)
        return bool(v.lo[u] <= v.M[u])

    # --- congestione (A2 sez. 1.1), solo descrittore; direzione-invariante
    def congestione(self, s: int) -> dict:
        if s in self._cong:
            return self._cong[s]
        n_c = DA["N_CONG"]
        a, b = s - n_c + 1, s + 1                          # finestra [s-14, s]
        c, W, sd, s50, atr = self.b.c, self.W, self.sd, self.s50, self.atr
        tr, ztr = self.tr, self.ztr
        pre = tr[max(a - DA["CS2_PREC"], 0):a]
        den_er = float(np.abs(np.diff(c[a - 1:b])).sum())
        er = abs(float(c[s] - c[s - n_c])) / den_er if den_er > 0 else 0.0
        slopeW, _ = _regressione(W[a:b])
        mtr = float(tr[a:b].mean())
        cv = float(tr[a:b].std() / mtr) if mtr > 0 else math.inf
        sdw = sd[s - DA["CS5_FIN"] + 1:s + 1]
        stab = float((sdw.max() - sdw.min()) / sdw.mean()) if sdw.mean() > 0 else math.inf
        cs = [
            bool(W[s] <= DA["CS1_W"] * W[s - n_c] and slopeW < 0),
            bool(pre.size > 0 and mtr <= DA["CS2_TR"] * float(pre.mean()) and cv <= DA["CS2_CV"]),
            bool(er <= DA["CS3_ER"]),
            bool(np.nanmax(ztr[a:b]) <= DA["CS4_Z"]),
            bool(sd[s] < s50[s] and stab <= DA["CS5_STAB"]),
        ]
        cs_n = int(sum(cs))
        cs_ok = cs_n >= DA["CS_MIN"]
        cda = None
        cda_ok = False
        if not cs_ok:
            f = DA["CDA1_FIN"]
            disc = int(np.sum(sd[s - f + 1:s + 1] < sd[s - f:s]))
            slope_c, r2 = _regressione(c[a:b])
            corpo = c[a:b] - self.b.o[a:b]
            contro = (corpo < 0) if slope_c > 0 else (corpo > 0)
            forte = np.abs(corpo) >= DA["CDA5_CORPO_ATR"] * atr[a - 1:b - 1]
            cda = [
                bool(disc >= DA["CDA1_MIN"] and sd[s] < sd[s - f]),
                bool(sd[s] < s50[s]),
                bool(W[s] / W[s - n_c] <= DA["CDA3_W"]),
                bool(np.nanmax(ztr[a:b]) <= DA["CDA4_Z"]),
                bool(r2 >= DA["CDA5_R2"] and not np.any(contro & forte)),
            ]
            cda_ok = all(cda)
        res = {"valida": bool(cs_ok or cda_ok), "tipo": "CS" if cs_ok else ("CDA" if cda_ok else None),
               "cs": cs, "cs_n": cs_n, "cda": cda}
        self._cong[s] = res
        return res


# ----------------------------------------------------------------------------- episodio e macchina

class _Ep:
    def __init__(self, eid, d, s, t0, p):
        self.id, self.d, self.s, self.t0, self.p = eid, d, s, t0, p
        self.n_prev = 0
        self.reset_fase()
        self.opp_toccata = False          # banda opposta toccata in [s, ...]
        self.opp_rientro = False          # banda opposta toccata da p (picco corrente) in poi (sensibilita Sg)
        self.consumato = False            # segnale gia' emesso (per questa variante)
        self.precoce = False              # CONT: tocco opposto a tau-p < MIN_RETR
        self.stadio = 0
        self.fine = None
        self.fine_idx = None
        self.finestre: list = []
        self.seq_viol_toccante = False
        self.seq_solo = False
        self.rit_senza_med_toccante = False

    def reset_fase(self):
        self.r_first = None               # prima barra r > p con tocco della mediana
        self.seq_viol = False             # mediana -> banda dell'impulso (SEQ)
        self.rit_senza_med = False        # ritorno alla banda dell'impulso SENZA mediana
        self.zmax = 0.0                   # max z su (p, u) prima dell'update della barra u


class _Macchina:
    def __init__(self, ctx: _Ctx, variante: str):
        self.c, self.var, self.prm = ctx, variante, ctx.prm
        self.ep: _Ep | None = None
        self.last_p = {1: -1, -1: -1}
        self.episodi: list = []
        self.segnali: list = []
        self.cont = {"tocchi_banda_opposta_prima_armamento": 0}
        self.n_arm_lista: list = []
        self.stadi = STADI_CONT if variante == "CONT" else STADI_INV
        self.z_imp = self.prm["IMPULSIVA_ATR"] if variante == "CONT" else \
            self.prm.get("IMPULSIVA_ATR_INV", self.prm["IMPULSIVA_ATR"])

    # ---------------------------------------------------------------- ciclo di vita
    def esegui(self) -> dict:
        c, prm = self.c, self.prm
        for t in range(prm["WARMUP"], c.n):
            if self.ep is not None:
                self._avanza(self.ep, t)
            for d in (1, -1):
                a = c.arm[d]
                if a["cand"][t]:
                    s = int(a["s"][t])
                    if s > self.last_p[d]:
                        self._arma(d, s, t)
        if self.ep is not None:
            self._chiudi(self.ep, "FINE_DATI", c.n - 1)
        return self._risultato()

    def _chiudi(self, ep: _Ep, motivo: str, t: int):
        ep.fine, ep.fine_idx = motivo, t
        if self.ep is ep:
            self.ep = None

    def _arma(self, d: int, s: int, t: int):
        c = self.c
        v = c.vista[d]
        if self.ep is not None:
            self._chiudi(self.ep, "OPPOSTO" if self.ep.d != d else "SOSTITUITO", t)
        p = s + int(np.argmax(v.hi[s:t + 1]))                     # prima occorrenza del massimo
        ep = _Ep(len(self.episodi), d, s, t, p)
        n = 0
        for q in reversed(self.n_arm_lista):
            if q.d != d:
                break
            if q.s >= s - DA["N_PREV_FINESTRA"]:
                n += 1
            else:
                break
        ep.n_prev = n
        self.n_arm_lista.append(ep)
        self.episodi.append(ep)
        self.ep = ep
        self.last_p[d] = p
        for u in range(s, t + 1):                                  # scansione retroattiva (nessun segnale)
            if c.tocco_opposta(v, u):
                ep.opp_toccata = True
                if u >= p:
                    ep.opp_rientro = True
                if u > p and u - p >= self.prm["MIN_RETR"]:
                    self.cont["tocchi_banda_opposta_prima_armamento"] += 1
            if u > p:
                dp = u - p
                if dp < self.prm["MIN_RETR"] and self.var == "CONT" and c.tocco_opposta(v, u):
                    ep.consumato = True
                    ep.precoce = True
                self._aggiorna_fase(ep, v, u)

    def _aggiorna_fase(self, ep: _Ep, v: _Vista, u: int):
        """Aggiorna i flag di fase con la barra u (u > p), usando r_first PRECEDENTE a u per la sequenza."""
        c = self.c
        if c.tocco_impulso(v, u):
            if ep.r_first is not None:
                ep.seq_viol = True
            else:
                ep.rit_senza_med = True
        if ep.r_first is None and c.tocco_mediana(v, u):
            ep.r_first = u
        ep.zmax = max(ep.zmax, float(c.z[u]))

    def _avanza(self, ep: _Ep, u: int):
        c, prm = self.c, self.prm
        v = c.vista[ep.d]
        if c.tocco_opposta(v, u):
            ep.opp_toccata = True
        if v.hi[u] > v.hi[ep.p]:                                   # nuovo estremo: la fase riparte
            ep.p = u
            self.last_p[ep.d] = u
            ep.reset_fase()
            ep.opp_rientro = False
        if c.tocco_opposta(v, u):
            ep.opp_rientro = True
        if ep.p - ep.s > prm["B6_BARRE"]:
            self._chiudi(ep, "BAND_RIDING", u)
            return
        if u - ep.p > prm["T_MAX"]:
            self._chiudi(ep, "T_MAX", u)
            return
        dp = u - ep.p
        if dp >= 1:
            if dp < prm["MIN_RETR"]:
                if self.var == "CONT" and not ep.consumato and c.tocco_opposta(v, u):
                    ep.consumato = True                            # tocco troppo rapido: consuma l'episodio
                    ep.precoce = True
            else:
                ep.finestre.append(u)
                ep.stadio = max(ep.stadio, 1)                      # finestra p+MIN_RETR raggiunta
                if not ep.consumato:
                    self._valuta(ep, v, u)
            self._aggiorna_fase(ep, v, u)

    def _opp(self, ep: _Ep) -> bool:
        """Banda opposta toccata per la condizione I1: in [s, tau] (primaria) o solo da p a tau (Sg, D007)."""
        return ep.opp_rientro if self.prm["I1_SOLO_RIENTRO"] else ep.opp_toccata

    # ---------------------------------------------------------------- valutazione del test
    def _gates(self, u: int):
        c, prm = self.c, self.prm
        g1 = True
        g2 = bool(c.sd[u] <= c.sd[u - prm["SD_LAG"]])
        return g1, g2

    def _valuta(self, ep: _Ep, v: _Vista, u: int):
        c, prm = self.c, self.prm
        g1, g2 = self._gates(u)
        zt = float(c.z[u])
        if self.var == "CONT":
            if not c.tocco_opposta(v, u):
                ep.stadio = max(ep.stadio, 1)
                return
            c3 = not ep.seq_viol
            c1a = ep.zmax <= self.z_imp
            c1b = zt <= self.z_imp
            ch = [True, c3, c1a, c1b, g1, g2]
            if ep.rit_senza_med:
                ep.rit_senza_med_toccante = True
            if not c3:
                ep.seq_viol_toccante = True
                if c1a and c1b and g1 and g2:
                    ep.seq_solo = True
        else:
            band = prm["BANDA_FINESTRA"]
            i0 = ep.r_first is not None
            i1 = not self._opp(ep)
            ret = c.tocco_impulso(v, u)
            i2 = max(ep.zmax, zt) <= self.z_imp
            pend = v.U[u - 1] - v.U[u - 1 - band]
            i3 = bool(pend <= prm["BANDA_TOL_ATR"] * c.atr[u - 1])
            ch = [i0, i1, ret, i2, i3, g1, g2]
        npass = 0
        for x in ch:
            if not x:
                break
            npass += 1
        ep.stadio = max(ep.stadio, 1 + npass)
        if npass == len(ch):
            ep.stadio = len(self.stadi) - 1
            ep.consumato = True
            self.segnali.append(self._segnale(ep, v, u))

    # ---------------------------------------------------------------- descrittori
    def _segnale(self, ep: _Ep, v: _Vista, u: int) -> dict:
        c, prm = self.c, self.prm
        inv = self.var == "INV"
        lato_n = -1 if inv else 1                                   # lato del trade nel frame normalizzato
        side = ep.d * lato_n
        s, p = ep.s, ep.p
        banda = v.U[u] if inv else v.L[u]
        pen = float(v.hi[u] - v.U[u]) if inv else float(v.L[u] - v.lo[u])
        corpo_oltre = bool(max(v.op[u], v.cl[u]) >= v.U[u]) if inv else bool(min(v.op[u], v.cl[u]) <= v.L[u])
        dentro = bool(v.cl[u] < v.U[u]) if inv else bool(v.cl[u] > v.L[u])
        R_ = slice(p + 1, u + 1)
        atr_prev = c.atr[p:u]                                       # ATR_(t-1) per t in (p, u]
        ztr = c.ztr[R_]
        zm_inc = max(ep.zmax, float(c.z[u]))
        # corpi e ombre (normalizzati)
        corpo = v.cl - v.op
        ombra_sup = v.hi - np.maximum(v.op, v.cl)
        ombra_inf = np.minimum(v.op, v.cl) - v.lo
        # ---- rientro A/B
        A1 = bool(c.tr[R_].mean() <= DA["A1_RAPP"] * c.tr[s:p + 1].mean())
        A2 = bool(np.all(ztr <= DA["A2_Z"]))
        sh = float((ombra_sup[R_] + ombra_inf[R_]).sum())
        bo = float(np.abs(corpo[R_]).sum())
        A3 = bool(sh <= DA["A3_OMBRE"] * bo)
        ombra_max = np.maximum(ombra_sup[R_], ombra_inf[R_])
        lo_b, hi_b = np.minimum(v.op, v.cl), np.maximum(v.op, v.cl)
        eng = (lo_b[R_] <= lo_b[p:u]) & (hi_b[R_] >= hi_b[p:u]) & \
            (np.abs(corpo[R_]) >= DA["A4_ENGULF_ATR"] * atr_prev)
        A4 = bool(not np.any(ombra_max >= DA["A4_OMBRA_ATR"] * atr_prev) and not np.any(eng))
        B1r = bool(not np.any((corpo[R_] > 0) & (corpo[R_] >= DA["B1_CORPO_ATR"] * atr_prev)))
        B3r = bool(A2 and B1r)
        if inv:
            B2r = bool(ep.r_first is not None and not self._opp(ep))
        else:
            den = float(np.abs(np.diff(v.cl[p:u + 1])).sum())
            B2r = bool(den > 0 and abs(float(v.cl[u] - v.cl[p])) / den >= DA["B2C_ER"])
        rientro = [A1, A2, A3, A4, B1r, B2r, B3r]
        # ---- bande C
        lag = DA["C1_LAG"]
        C1 = bool(c.W[u] < c.W[u - lag] and c.W[u] <= DA["C1_W_MAX"] * float(c.W[p:u + 1].max()))
        slU = float(v.U[u] - v.U[u - lag])
        C2i = bool(slU <= prm["BANDA_TOL_ATR"] * c.atr[u])
        tt = np.arange(p + 1, u + 1)
        C3 = bool(not np.any((c.sd[tt] >= DA["C3_SD"] * c.sd[tt - 1]) & (v.cl[tt] > v.cl[tt - 1])))
        bande = [C1, C2i, C3] if inv else [C1, C3]
        # ---- test
        if inv:
            T5 = bool(C2i or c.W[u] <= c.W[u - DA["T5_LAG"]])
            test = [True, not self._opp(ep), T5]
        else:
            test = [True, bool(c.ztr[u] < DA["T2_Z"])]
        # ---- conferme K1..K3 (K4 news esclusa)
        k1 = bool((c.sd[u] < c.sd[u - 1] and c.sd[u - 1] < c.sd[u - 2]) or c.sd[u] < c.s50[u])
        k2 = bool(c.sd[u] < c.s50[u])
        dk = c.sma50c[u] - c.sma50c[u - DA["K3_LAG"]]
        k3 = bool(np.isfinite(dk) and (dk > 0) == (side > 0) and dk != 0)
        conf = [k1, k2, k3]

        def quota(x):
            return sum(1 for y in x if y) / len(x)

        cong = c.congestione(s)
        pesi = DA["SOL_PESI"]
        sol = pesi["cong"] * (1.0 if cong["valida"] else 0.0) + pesi["bulge"] + pesi["rientro"] * quota(rientro) \
            + pesi["bande"] * quota(bande) + pesi["test"] * quota(test) + pesi["conferme"] * quota(conf)
        fasce = DA["SOL_FASCE"]
        cat = "Ottimo" if sol >= fasce["Ottimo"] else "Buono" if sol >= fasce["Buono"] else \
            "Medio" if sol >= fasce["Medio"] else "Debole"
        # ---- invalidazioni A2 (descrittore)
        inval = []
        if not inv:
            if zm_inc > DA["A2_Z"]:
                inval.append("X1")
        else:
            if zm_inc > DA["X2_Z"]:
                inval.append("X2")
            if slU > DA["X3_TOL"] * c.atr[u]:
                inval.append("X3")
            if c.sd[u] >= DA["X4_SD"] * c.sd[u - 1]:
                inval.append("X4")
            if self._opp(ep):
                inval.append("X6")
        if (not A4) or (not B1r):
            inval.append("X5")
        alta = bool(c.sd[u] > c.s50[u] and not (c.sd[u] < c.sd[u - 1] and c.sd[u - 1] < c.sd[u - 2]))
        if alta or c.sd[u] >= DA["X7_SD2"] * c.sd[u - 2]:
            inval.append("X7")
        rientro_abc = rientro + bande
        quota_abc = quota(rientro_abc)
        checklist_stretta = bool(cong["valida"] and quota_abc >= DA["RIENTRO_VALIDO"] and not inval)
        # ---- bonus (descrittore)
        bonus = self._bonus(ep, v, u, inv, lato_n, corpo, ombra_sup, ombra_inf, lo_b, hi_b, R_, ztr)
        # ---- altri descrittori
        rng_ = float(v.hi[u] - v.lo[u])
        n_gt = int(np.sum(c.R[s:p + 1] >= DA["SPIKE_NEWS_ATR"] * c.atr[s]))
        sp_u = float(c.sp[u]) if c.sp is not None else None
        return {
            "j": int(u), "side": int(side), "variante": self.var, "d": int(ep.d), "episodio": int(ep.id),
            "s": int(s), "p": int(p), "t0": int(ep.t0), "dp": int(u - p), "n_prev": int(ep.n_prev),
            "n_prev_classe": 0 if ep.n_prev == 0 else 1 if ep.n_prev == 1 else 2,
            "solidita": float(sol), "fascia": cat,
            "congestione": bool(cong["valida"]), "congestione_tipo": cong["tipo"],
            "rientro_quota_ab": float(quota(rientro)), "bande_quota": float(quota(bande)),
            "test_quota": float(quota(test)), "conferme_quota": float(quota(conf)),
            "rientro_quota_abc": float(quota_abc), "rientro_ge_80": bool(quota_abc >= DA["RIENTRO_VALIDO"]),
            "invalidazioni_A2": inval, "checklist_stretta": checklist_stretta, "bonus": int(bonus),
            "ora": int((c.b.t[u] // 60) % 24), "atr": float(c.atr[u]),
            "livello_banda": float(ep.d * banda), "mediana": float(c.ind.sma20[u]),
            "penetrazione": pen, "penetrazione_lt_spread": (None if sp_u is None else bool(pen < sp_u)),
            "contatto": ("corpo" if corpo_oltre else "spike") + "/" + ("test" if dentro else "violazione"),
            "z_test": float(c.z[u]), "zmax_ritracciamento": float(zm_inc), "barre_gt_3atr_bulge": n_gt,
            "range_test": rng_,
        }

    def _bonus(self, ep, v, u, inv, lato_n, corpo, osup, oinf, lo_b, hi_b, R_, ztr) -> int:
        c, prm = self.c, self.prm
        tol = prm["BANDA_TOL_ATR"]
        atr_u, atr_p = float(c.atr[u]), float(c.atr[u - 1])
        tr_u = float(c.tr[u])
        rng_ = float(v.hi[u] - v.lo[u])
        body = abs(float(corpo[u]))
        ombra_test = float(osup[u] if inv else oinf[u])
        pos = (float(v.cl[u] - v.lo[u]) / rng_) if rng_ > 0 else 0.5
        terzo = 1.0 / DA["BN_A1_TERZO"]
        fav_terzo = pos >= 1.0 - terzo if lato_n == 1 else pos <= terzo
        eng = bool(lo_b[u] <= lo_b[u - 1] and hi_b[u] >= hi_b[u - 1] and body <= DA["BN_A1_ENG"] * atr_p)
        n_ = 0
        n_ += bool(tr_u <= DA["BN_A1_Z"] * atr_p and (body <= DA["BN_A1_CORPO"] * tr_u or
                                                      (ombra_test >= DA["BN_A1_OMBRA"] * body and fav_terzo) or eng))
        n_ += bool(v.cl[u] < v.U[u]) if inv else bool(v.cl[u] > v.L[u])                       # A2 rigetto pulito
        n_ += bool(tr_u <= DA["BN_A3_Z"] * atr_p)                                                # A3
        meta = (pos >= 0.5) if lato_n == 1 else (pos <= 0.5)
        n_ += bool(lato_n * float(corpo[u]) > 0 and meta)                                       # B1 reazione
        band = v.U if inv else v.L
        n_ += bool(lato_n * float(band[u] - band[u - DA["C1_LAG"]]) >= -DA["BN_B2_TOL"] * atr_u)  # B2
        n_ += bool(max(osup[u - 1], oinf[u - 1]) < DA["BN_B3_OMBRA"] * float(c.atr[u - 2]))      # B3
        dc = np.abs(np.diff(c.b.c[ep.p:u + 1]))
        n_ += bool(dc.mean() > 0 and dc.std() / dc.mean() <= DA["BN_C1_CV"])                     # C1
        n_ += bool(np.all(c.ztr[u - DA["BN_C2_N"]:u] <= DA["BN_C2_Z"]))                                      # C2
        k = DA["BN_C3_N"]
        n_ += bool(np.all(c.sd[u - k + 1:u + 1] <= c.sd[u - k:u]))                               # C3
        if inv:
            n_ += bool(abs(float(v.U[u] - v.U[u - DA["C1_LAG"]])) <= DA["BN_E1_TOL"] * atr_u)    # E1
            n_ += bool((u - ep.p) >= DA["BN_E2_LUN"] and float(np.nanmax(ztr)) <= DA["BN_E2_Z"])  # E2
            n_ += bool(v.cl[u] < v.U[u] and ombra_test >= DA["BN_E3_OMBRA"] * body)              # E3
        else:
            d1 = abs(float(v.L[u] - v.L[u - DA["BN_D1"]])) < abs(float(v.L[u - DA["BN_D1"]] - v.L[u - 2 * DA["BN_D1"]]))
            n_ += bool(d1)                                                                        # D1
            f = DA["BN_D2_FIN"]
            n_ += bool(float(v.hi[u - f:u].max() - v.lo[u - f:u].min()) <= DA["BN_D2_ATR"] * atr_p)  # D2
            n_ += bool(body <= DA["BN_D3_CORPO"] * tr_u and ombra_test <= DA["BN_D3_OMBRA"] * atr_p)  # D3
        return int(n_)

    # ---------------------------------------------------------------- risultato / imbuto
    def _risultato(self) -> dict:
        c = self.c
        nst = len(self.stadi)
        conteggi = [0] * nst
        morti: dict = {}
        for ep in self.episodi:
            for k in range(min(ep.stadio, nst - 1) + 1):
                conteggi[k] += 1
            if ep.stadio < nst - 1:
                chiave = "CONSUMATO_TOCCO_PRECOCE" if ep.precoce else (ep.fine or "VIVO")
                morti.setdefault(self.stadi[ep.stadio], {})
                morti[self.stadi[ep.stadio]][chiave] = morti[self.stadi[ep.stadio]].get(chiave, 0) + 1
        fine: dict = {}
        for ep in self.episodi:
            fine[ep.fine] = fine.get(ep.fine, 0) + 1
        imb_barre = {}
        for d in (1, -1):
            a = c.arm[d]
            marg = [int(b.sum()) for b in a["b"]]
            cum, acc = [], c.valid.copy()
            for b in a["b"]:
                acc = acc & b
                cum.append(int(acc.sum()))
            imb_barre[str(d)] = {"marginali": dict(zip(NOMI_B, marg)), "cumulativi": dict(zip(NOMI_B, cum))}
        extra = {
            "episodi_seq_violata_su_barra_di_tocco": sum(1 for e in self.episodi if e.seq_viol_toccante),
            "episodi_eliminati_solo_da_SEQ": sum(1 for e in self.episodi if e.seq_solo),
            "episodi_ritorno_banda_senza_mediana_su_barra_di_tocco": sum(
                1 for e in self.episodi if e.rit_senza_med_toccante),
            "segnali_con_impulsiva_1.0_violata": sum(1 for s in self.segnali if s["zmax_ritracciamento"] > 1.0),
            "episodi_consumati_tocco_precoce": sum(1 for e in self.episodi if e.precoce),
            "tocchi_banda_opposta_prima_armamento": self.cont["tocchi_banda_opposta_prima_armamento"],
            "segnali_penetrazione_lt_spread": sum(1 for s in self.segnali if s["penetrazione_lt_spread"]),
        }
        return {
            "variante": self.var, "n_barre": int(c.n), "barre_valide": int(c.valid.sum()),
            "imbuto_barre": imb_barre,
            "imbuto_episodi": {"stadi": list(self.stadi), "conteggi": conteggi, "morti": morti},
            "armati": {"+1": sum(1 for e in self.episodi if e.d == 1), "-1": sum(1 for e in self.episodi if e.d == -1)},
            "fine_episodi": fine, "extra": extra,
            "segnali": self.segnali,
            "episodi": [{"id": e.id, "d": e.d, "s": e.s, "p": e.p, "t0": e.t0, "fine": e.fine,
                         "fine_idx": e.fine_idx, "stadio": e.stadio, "n_prev": e.n_prev,
                         "finestre": list(e.finestre)} for e in self.episodi],
        }


def rileva(barre: E.Barre, ind: E.Indicatori, variante: str, prm: dict | None = None, sp_bar=None) -> dict:
    """Esegue la macchina a stati per una variante ('CONT' | 'INV') su UNA serie (un periodo, un TF).

    sp_bar: spread di barra in USD (solo per la sensibilita Sf e per il descrittore penetrazione<spread).
    Ritorna un dict con 'segnali' (lista di dict con j, side, descrittori), 'imbuto_barre', 'imbuto_episodi',
    'armati', 'fine_episodi', 'extra', 'episodi'."""
    if variante not in VARIANTI:
        raise ValueError(f"variante sconosciuta: {variante!r}")
    prm = prm or PARAMS
    ctx = _Ctx(barre, ind, prm, sp_bar)
    return _Macchina(ctx, variante).esegui()
