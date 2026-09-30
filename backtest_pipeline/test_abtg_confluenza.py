#!/usr/bin/env python3
# -*- coding: utf-8 -*-
"""
Test di IDENTITA' della logica di confluenza (ABTG_Confluenza.mqh).

Cosa fa (in Python, perche' qui non c'e' MetaEditor: NON compila nulla):
  1. Riscrive RIGA PER RIGA la struct SConfl di mql5/Include/ABTG_Confluenza.mqh
     (classe Confl qui sotto). Il .mqh e' la fonte di verita': se lo cambi,
     va cambiato anche questo specchio, altrimenti il test non dice piu' nulla.
  2. Alimenta la STESSA serie di barre per tre percorsi:
       P1  INDICATORE incrementale: barre chiuse una alla volta + anteprima
           della barra in formazione su una COPIA (tmp = e), con qualche
           ricalcolo completo (prev_calculated = 0) a caso;
       P2  BATCH: tutte le barre chiuse in un colpo solo;
       P3  DASHBOARD: per ogni barra chiusa e, ricostruisce lo stato dalle
           ultime InpBars=600 barre chiuse e legge (lastNo, lastDir).
  3. Confronta i segnali: P1 == P2 barra per barra; P3 == P1 sulle ultime
     InpMaxAgeBars+1 barre, per ogni e (=> stesso "segnale attivo entro 3
     barre" mostrato dalla dashboard).
  4. CONTRO-ESEMPI (si costruisce cio' che farebbe sbagliare il test e si
     mostra che il test se ne accorge): un parametro cambiato di poco nel
     percorso dashboard (breakLB 3 -> 2, o volFactor) DEVE produrre
     differenze; se non ne produce, il confronto non misura niente.
  5. Mappatura click -> (simbolo, TF) dopo il riordino delle righe.
  6. Coerenza dei default tra .mqh, indicatore, dashboard e pannello volumi.

Uso:  python3 backtest_pipeline/test_abtg_confluenza.py
Esce con codice 0 solo se tutti i controlli passano.
"""
import math
import os
import random
import re
import sys

RING = 128
F_EXP, F_CROSS, F_SLOPE, F_BREAK, F_VOL = 1, 2, 4, 8, 16
F_BASE, F_ALL = 15, 31


def clamp(v, lo, hi):
    return lo if v < lo else (hi if v > hi else v)


class Confl:
    """Specchio riga per riga di struct SConfl (ABTG_Confluenza.mqh)."""

    def __init__(self, emaFast=9, emaSlow=21, ema3=50, ema4=200,
                 bbPeriod=20, bbDev=2.0, bbExpandBars=3, bbExpandPct=0.0,
                 atrPeriod=10, stMult=3.0, atrWilder=True,
                 crossLB=3, slopeBars=2, breakLB=3, cooldown=5,
                 volPeriod=20, volFactor=1.0):
        self.pEmaFast = clamp(emaFast, 1, 5000)
        self.pEmaSlow = clamp(emaSlow, 1, 5000)
        self.pEma3 = clamp(ema3, 1, 5000)
        self.pEma4 = clamp(ema4, 1, 5000)
        self.pBBPeriod = clamp(bbPeriod, 2, 120)
        self.pBBExpandBars = clamp(bbExpandBars, 1, 100)
        self.pAtrPeriod = clamp(atrPeriod, 1, 120)
        self.pCrossLB = clamp(crossLB, 0, 100)
        self.pSlopeBars = clamp(slopeBars, 1, 100)
        self.pBreakLB = clamp(breakLB, 0, 100)
        self.pCooldown = clamp(cooldown, 0, 100)
        self.pVolPeriod = clamp(volPeriod, 1, 120)
        self.pBBDev = bbDev if bbDev > 0 else 2.0
        self.pBBExpandPct = bbExpandPct if bbExpandPct >= 0 else 0.0
        self.pStMult = stMult if stMult > 0 else 3.0
        self.pAtrWilder = atrWilder
        self.pVolFactor = volFactor if volFactor > 0 else 1.0
        lb = self.pBBExpandBars
        lb = max(lb, self.pCrossLB + 1, self.pSlopeBars + 1, self.pBreakLB + 1, self.pCooldown)
        w = 120
        w = max(w, 4 * self.pEmaSlow, self.pBBPeriod + lb, self.pAtrPeriod + lb, self.pVolPeriod + lb)
        self.pWarm = w + 3
        self.a1 = 2.0 / (self.pEmaFast + 1.0)
        self.a2 = 2.0 / (self.pEmaSlow + 1.0)
        self.a3 = 2.0 / (self.pEma3 + 1.0)
        self.a4 = 2.0 / (self.pEma4 + 1.0)
        self.reset()

    def reset(self):
        self.n = 0
        self.idx = -1
        self.e1 = self.e2 = self.e3 = self.e4 = 0.0
        self.atr = 0.0
        self.atrSum = 0.0
        self.prevClose = 0.0
        self.stUp = self.stDn = 0.0
        self.stDir = 0
        self.closeR = [0.0] * RING
        self.trR = [0.0] * RING
        self.volR = [0.0] * RING
        self.bbwR = [0.0] * RING
        self.e1R = [0.0] * RING
        self.e2R = [0.0] * RING
        self.dirR = [0] * RING
        self.condL = [0] * (2 * RING)
        self.condS = [0] * (2 * RING)
        self.sigR = [0] * (2 * RING)
        self.okE1 = self.okE2 = self.okE3 = self.okE4 = False
        self.okBB = self.okATR = self.okST = False
        self.bbUp = self.bbMid = self.bbLo = self.bbw = 0.0
        self.stVal = 0.0
        self.volMa = 0.0
        self.volPass = False
        self.maskL = self.maskS = 0
        self.sigA = self.sigB = 0
        self.lastNo = [-1, -1]
        self.lastDir = [0, 0]

    def copy(self):
        """Equivale a  tmp = e  (assegnazione di struct POD in MQL5)."""
        c = Confl.__new__(Confl)
        for k, v in self.__dict__.items():
            c.__dict__[k] = list(v) if isinstance(v, list) else v
        return c

    def exp_ok(self, i):
        j = i - self.pBBExpandBars
        if j < 0:
            return False
        wOld = self.bbwR[j % RING]
        if wOld <= 0.0:
            return False
        return self.bbwR[i % RING] > wOld * (1.0 + self.pBBExpandPct / 100.0)

    def cross_ok(self, i, d):
        ri = i % RING
        if d > 0 and not (self.e1R[ri] > self.e2R[ri]):
            return False
        if d < 0 and not (self.e1R[ri] < self.e2R[ri]):
            return False
        for j in range(i - self.pCrossLB, i + 1):
            if j < 1:
                continue
            rj, rp = j % RING, (j - 1) % RING
            if d > 0 and self.e1R[rp] <= self.e2R[rp] and self.e1R[rj] > self.e2R[rj]:
                return True
            if d < 0 and self.e1R[rp] >= self.e2R[rp] and self.e1R[rj] < self.e2R[rj]:
                return True
        return False

    def slope_ok(self, i, d):
        for s in range(self.pSlopeBars):
            k = i - s
            if k < 1:
                return False
            rk, rp = k % RING, (k - 1) % RING
            if d > 0 and not (self.e1R[rk] > self.e1R[rp] and self.e2R[rk] > self.e2R[rp]):
                return False
            if d < 0 and not (self.e1R[rk] < self.e1R[rp] and self.e2R[rk] < self.e2R[rp]):
                return False
        return True

    def break_ok(self, i, d):
        if self.dirR[i % RING] != d:
            return False
        for j in range(i - self.pBreakLB, i + 1):
            if j < 1:
                continue
            rj, rp = j % RING, (j - 1) % RING
            if d > 0 and self.dirR[rj] > 0 and self.dirR[rp] < 0:
                return True
            if d < 0 and self.dirR[rj] < 0 and self.dirR[rp] > 0:
                return True
        return False

    def recent(self, v, d, i):
        for k in range(1, self.pCooldown + 1):
            if i - k < 0:
                break
            if self.sigR[v * RING + ((i - k) % RING)] == d:
                return True
        return False

    def feed(self, o, h, l, c, v):
        i = self.n
        r = i % RING
        self.n = i + 1
        self.idx = i
        if i == 0:
            self.e1 = self.e2 = self.e3 = self.e4 = c
        else:
            self.e1 += self.a1 * (c - self.e1)
            self.e2 += self.a2 * (c - self.e2)
            self.e3 += self.a3 * (c - self.e3)
            self.e4 += self.a4 * (c - self.e4)
        self.okE1 = i >= self.pEmaFast - 1
        self.okE2 = i >= self.pEmaSlow - 1
        self.okE3 = i >= self.pEma3 - 1
        self.okE4 = i >= self.pEma4 - 1
        self.e1R[r] = self.e1
        self.e2R[r] = self.e2

        self.closeR[r] = c
        self.okBB = i >= self.pBBPeriod - 1
        if self.okBB:
            s = 0.0
            for k in range(self.pBBPeriod):
                s += self.closeR[(i - k) % RING]
            m = s / self.pBBPeriod
            q = 0.0
            for k in range(self.pBBPeriod):
                d = self.closeR[(i - k) % RING] - m
                q += d * d
            sd = math.sqrt(q / self.pBBPeriod)
            self.bbMid = m
            self.bbUp = m + self.pBBDev * sd
            self.bbLo = m - self.pBBDev * sd
            self.bbw = (self.bbUp - self.bbLo) / m if m > 0.0 else 0.0
        else:
            self.bbMid = self.bbUp = self.bbLo = self.bbw = 0.0
        self.bbwR[r] = self.bbw

        tr = h - l
        if i > 0:
            tr = max(tr, abs(h - self.prevClose))
            tr = max(tr, abs(l - self.prevClose))
        self.trR[r] = tr
        self.okATR = i >= self.pAtrPeriod - 1
        P = self.pAtrPeriod
        if self.pAtrWilder:
            if i < P - 1:
                self.atrSum += tr
                self.atr = 0.0
            elif i == P - 1:
                self.atrSum += tr
                self.atr = self.atrSum / P
            else:
                self.atr = (self.atr * (P - 1) + tr) / P
        else:
            self.atrSum += tr
            if i >= P:
                self.atrSum -= self.trR[(i - P) % RING]
            self.atr = self.atrSum / P if self.okATR else 0.0

        if self.okATR:
            mid = (h + l) / 2.0
            up = mid + self.pStMult * self.atr
            dn = mid - self.pStMult * self.atr
            if self.stDir == 0:
                self.stUp = up
                self.stDn = dn
                self.stDir = 1 if c >= mid else -1
            else:
                pu, pd = self.stUp, self.stDn
                self.stUp = up if (up < pu or self.prevClose > pu) else pu
                self.stDn = dn if (dn > pd or self.prevClose < pd) else pd
                if self.stDir > 0:
                    self.stDir = -1 if c < self.stDn else 1
                else:
                    self.stDir = 1 if c > self.stUp else -1
            self.stVal = self.stDn if self.stDir > 0 else self.stUp
            self.okST = True
        else:
            self.stDir = 0
            self.stVal = 0.0
            self.okST = False
        self.dirR[r] = self.stDir

        self.volR[r] = v
        if i >= self.pVolPeriod - 1:
            sv = 0.0
            for k in range(self.pVolPeriod):
                sv += self.volR[(i - k) % RING]
            self.volMa = sv / self.pVolPeriod
            self.volPass = v > self.volMa * self.pVolFactor
        else:
            self.volMa = 0.0
            self.volPass = False

        self.sigA = self.sigB = 0
        self.maskL = self.maskS = 0
        for vv in range(2):
            self.condL[vv * RING + r] = 0
            self.condS[vv * RING + r] = 0
            self.sigR[vv * RING + r] = 0
        if i >= self.pWarm and self.okBB and self.okST:
            mL = mS = 0
            if self.exp_ok(i):
                mL |= F_EXP
                mS |= F_EXP
            if self.cross_ok(i, 1):
                mL |= F_CROSS
            if self.cross_ok(i, -1):
                mS |= F_CROSS
            if self.slope_ok(i, 1):
                mL |= F_SLOPE
            if self.slope_ok(i, -1):
                mS |= F_SLOPE
            if self.break_ok(i, 1):
                mL |= F_BREAK
            if self.break_ok(i, -1):
                mS |= F_BREAK
            if self.volPass:
                mL |= F_VOL
                mS |= F_VOL
            self.maskL, self.maskS = mL, mS
            bL = (mL & F_BASE) == F_BASE
            bS = (mS & F_BASE) == F_BASE
            rp = (i - 1) % RING
            for vv in range(2):
                cl = bL and (vv == 0 or self.volPass)
                cs = bS and (vv == 0 or self.volPass)
                self.condL[vv * RING + r] = 1 if cl else 0
                self.condS[vv * RING + r] = 1 if cs else 0
                s_ = 0
                if cl and self.condL[vv * RING + rp] == 0 and not self.recent(vv, 1, i):
                    s_ = 1
                elif cs and self.condS[vv * RING + rp] == 0 and not self.recent(vv, -1, i):
                    s_ = -1
                self.sigR[vv * RING + r] = s_
                if s_ != 0:
                    self.lastNo[vv] = i
                    self.lastDir[vv] = s_
                if vv == 0:
                    self.sigA = s_
                else:
                    self.sigB = s_
        self.prevClose = c

    def state_fingerprint(self):
        return tuple((k, tuple(v) if isinstance(v, list) else v) for k, v in sorted(self.__dict__.items()))


# ---------------------------------------------------------------------------
# Serie sintetica: regimi di trend/laterale, volatilita' a grappoli, volume tick
# correlato al range (come su un CFD).
# ---------------------------------------------------------------------------
def make_bars(n, seed):
    rnd = random.Random(seed)
    bars = []
    px = 2000.0
    drift = 0.0
    vol = 1.0
    for i in range(n):
        if i % 180 == 0:
            drift = rnd.choice([-0.35, -0.1, 0.0, 0.0, 0.1, 0.35]) * rnd.random()
        if i % 60 == 0:
            vol = rnd.choice([0.6, 1.0, 1.0, 1.6, 2.4])
        o = px
        steps = [rnd.gauss(drift, vol) for _ in range(6)]
        path = [o]
        for s in steps:
            path.append(path[-1] + s)
        c = path[-1]
        h = max(path) + abs(rnd.gauss(0, 0.3 * vol))
        l = min(path) - abs(rnd.gauss(0, 0.3 * vol))
        tv = int(60 + 40 * (h - l) / max(vol, 0.3) + rnd.random() * 80 + (150 if rnd.random() < 0.08 else 0))
        bars.append((o, h, l, c, float(tv)))
        px = c
    return bars


def run_incremental(bars, params, full_recalc_every=0, seed=1):
    """P1: come OnCalculate dell'indicatore. Ritorna lista (sigA,sigB) delle barre chiuse."""
    rnd = random.Random(seed)
    eng = Confl(**params)
    out = {}
    N = len(bars)
    forming_sigs = 0
    for total in range(2, N + 1):
        closed_total = total - 1
        reset = False
        if total == 2 or eng.n > closed_total or (full_recalc_every and rnd.random() < 1.0 / full_recalc_every):
            eng.reset()
            reset = True
        for i in range(eng.n, closed_total):
            eng.feed(*bars[i])
            out[i] = (eng.sigA, eng.sigB)
        before = eng.state_fingerprint()
        tmp = eng.copy()
        tmp.feed(*bars[total - 1])          # anteprima barra in formazione
        if tmp.sigA != 0 or tmp.sigB != 0:
            forming_sigs += 1               # esiste, ma l'indicatore la scarta (mai repaint)
        after = eng.state_fingerprint()
        assert before == after, "la anteprima ha modificato il motore committato"
    return out, forming_sigs


def run_batch(bars, params):
    eng = Confl(**params)
    out = {}
    for i in range(len(bars) - 1):
        eng.feed(*bars[i])
        out[i] = (eng.sigA, eng.sigB)
    return out, eng


def dashboard_read(bars, e, params, window=600):
    """P3: come Measure(): ultime `window` barre chiuse fino a e incluso; ritorna per variante (lastNo globale, lastDir)."""
    start = max(0, e - window + 1)
    eng = Confl(**params)
    for i in range(start, e + 1):
        eng.feed(*bars[i])
    res = []
    for v in range(2):
        no = eng.lastNo[v]
        res.append((no + start if no >= 0 else -1, eng.lastDir[v]))
    return res, eng


def active_from_p1(sigs, e, v, max_age):
    """Cio' che la dashboard dovrebbe mostrare: ultimo segnale della variante v con eta' <= max_age."""
    for k in range(0, max_age + 1):
        i = e - k
        if i in sigs and sigs[i][v] != 0:
            return (k, sigs[i][v])
    return None


def compare_dashboard(bars, sigs, params, window, max_age, step=1, e_from=None):
    mism = 0
    checked = 0
    active = 0
    N = len(bars)
    e_from = e_from if e_from is not None else min(window, 800)
    for e in range(e_from, N - 1, step):
        res, eng = dashboard_read(bars, e, params, window)
        for v in range(2):
            want = active_from_p1(sigs, e, v, max_age)
            no, d = res[v]
            got = None
            if no >= 0 and (e - no) <= max_age:
                got = (e - no, d)
            checked += 1
            if want is not None:
                active += 1
            if want != got:
                mism += 1
    return checked, active, mism


# ---------------------------------------------------------------------------
# Mappatura click -> (simbolo, TF): stessa logica di DecodeClick / OnChartEvent
# ---------------------------------------------------------------------------
PFX = "ABTGC_"


def decode_click(name):
    if not name.startswith(PFX):
        return None
    rest = name[len(PFX):]
    p = rest.split("_")
    if len(p) < 2:
        return None
    kind = p[0]
    def uint(x):
        return re.fullmatch(r"[0-9]{1,6}", x) is not None
    if kind in ("S", "C"):
        if len(p) != 2 or not uint(p[1]):
            return None
        return kind, int(p[1]), -1
    if kind in ("K", "A", "G"):
        if len(p) != 3 or not uint(p[1]) or not uint(p[2]):
            return None
        return kind, int(p[1]), int(p[2])
    return None


def test_click_map(rounds=200, seed=7):
    rnd = random.Random(seed)
    syms = ["EURUSD", "GBPUSD", "XAUUSD", "NASUSD", "D30EUR", "225JPY", "USDJPY", "XAGUSD"]
    tfs = ["M5", "M15", "H1", "H4"]
    bad = 0
    n_checked = 0
    for _ in range(rounds):
        order = syms[:]
        rnd.shuffle(order)                      # gIdx dopo ScoreAndSort: riga -> simbolo
        displayed = {}
        for r, s in enumerate(order):           # Render(): nome oggetto -> (simbolo, TF) mostrato
            displayed[PFX + "S_%d" % r] = (s, None)
            displayed[PFX + "C_%d" % r] = (s, None)
            for t, tf in enumerate(tfs):
                for kind in ("K", "A", "G"):
                    displayed[PFX + "%s_%d_%d" % (kind, r, t)] = (s, tf)
        # secondo riordino (dopo il quale i nomi restano ma il contenuto cambia)
        order2 = syms[:]
        rnd.shuffle(order2)
        displayed2 = {}
        for r, s in enumerate(order2):
            displayed2[PFX + "S_%d" % r] = (s, None)
            displayed2[PFX + "C_%d" % r] = (s, None)
            for t, tf in enumerate(tfs):
                for kind in ("K", "A", "G"):
                    displayed2[PFX + "%s_%d_%d" % (kind, r, t)] = (s, tf)
        for name, (s_disp, tf_disp) in displayed2.items():
            dec = decode_click(name)
            assert dec is not None, name
            kind, row, col = dec
            s_click = order2[row]               # gIdx[row] al momento del click
            tf_click = tfs[col] if col >= 0 else None
            n_checked += 1
            if s_click != s_disp or tf_click != tf_disp:
                bad += 1
        # oggetti NON cliccabili
        for name in (PFX + "BG", PFX + "T", PFX + "H_S", PFX + "H_2", PFX + "H_C", "ALTRO_S_1", PFX + "S_", PFX + "K_1", PFX + "K_1_", PFX + "A_x_1", PFX + "S_1_2"):
            if decode_click(name) is not None:
                bad += 1
    return n_checked, bad


def test_symbol_click_tf():
    """SymbolClickTf: segnale piu' recente, a parita' TF piu' alto, altrimenti TF principale."""
    def pick(cells, main):
        best, best_age = -1, 10 ** 6
        for t, (ok, d, age) in enumerate(cells):
            if not ok or d == 0:
                continue
            if age <= best_age:
                best_age, best = age, t
        return main if best < 0 else best
    assert pick([(True, 1, 2), (True, -1, 0), (True, 1, 0), (True, 0, -1)], 2) == 2      # pari eta' 0: vince il piu' alto
    assert pick([(True, 1, 3), (True, 0, -1), (False, 0, -1), (True, 0, -1)], 2) == 0
    assert pick([(True, 0, -1), (False, 0, -1), (True, 0, -1), (True, 0, -1)], 2) == 2   # nessun segnale: TF principale
    return True


# ---------------------------------------------------------------------------
# Default coerenti tra file
# ---------------------------------------------------------------------------
def read(path):
    with open(path, encoding="utf-8", errors="replace") as f:
        return f.read()


def test_defaults(root):
    mqh = read(os.path.join(root, "mql5/Include/ABTG_Confluenza.mqh"))
    ind = read(os.path.join(root, "mql5/Indicators/ABTG_Segnali_EMA_BB_ST.mq5"))
    dash = read(os.path.join(root, "mql5/Indicators/ABTG_Confluenza_Dashboard.mq5"))
    vol = read(os.path.join(root, "mql5/Indicators/ABTG_Volume_Filtro.mq5"))
    macros = dict(re.findall(r"#define\s+(ABTGC_D_\w+)\s+([0-9.]+)", mqh))
    problems = []
    for name in ("ABTGC_D_EMA_FAST", "ABTGC_D_EMA_SLOW", "ABTGC_D_BB_PERIOD", "ABTGC_D_BB_DEV",
                 "ABTGC_D_BB_EXP_BARS", "ABTGC_D_ATR_PERIOD", "ABTGC_D_ST_MULT", "ABTGC_D_CROSS_LB",
                 "ABTGC_D_SLOPE_BARS", "ABTGC_D_BREAK_LB", "ABTGC_D_COOLDOWN", "ABTGC_D_VOL_PERIOD",
                 "ABTGC_D_VOL_FACTOR"):
        if name not in macros:
            problems.append("macro mancante " + name)
        if name not in ind:
            problems.append("indicatore non usa " + name)
        if name not in dash:
            problems.append("dashboard non usa " + name)
    # pannello volumi: default letterali = macro
    m = re.search(r"input\s+int\s+InpVolMaPeriod\s*=\s*([0-9]+)", vol)
    if not m or m.group(1) != macros.get("ABTGC_D_VOL_PERIOD"):
        problems.append("periodo volumi del pannello diverso dalla macro")
    m = re.search(r"input\s+double\s+InpVolFactor\s*=\s*([0-9.]+)", vol)
    if not m or float(m.group(1)) != float(macros.get("ABTGC_D_VOL_FACTOR", "nan")):
        problems.append("fattore volumi del pannello diverso dalla macro")
    # ordine degli input passati a iCustom: (periodo, fattore), presi dal MOTORE (clampati)
    if "iCustom(_Symbol, _Period, VolFilePath(), gEng.pVolPeriod, gEng.pVolFactor)" not in ind:
        problems.append("iCustom del pannello non passa (periodo, fattore) del motore")
    # il nome del pannello costruito dall'indicatore = quello che il pannello si da' (confronto per nome intero)
    fmt_vol = re.findall(r'StringFormat\("(ABTG Volume Filtro \([^"]*)"', vol)
    fmt_ind = re.findall(r'StringFormat\("(ABTG Volume Filtro \([^"]*)"', ind)
    if not fmt_vol or not fmt_ind or set(fmt_vol) != set(fmt_ind):
        problems.append("formato del nome del pannello diverso: pannello %r, indicatore %r" % (fmt_vol, fmt_ind))
    # stessa macro sullo STESSO input (non basta che la macro compaia da qualche parte)
    rx = r"input\s+\w+\s+(Inp\w+)\s*=\s*(ABTGC_D_\w+)"
    map_ind, map_dash = dict(re.findall(rx, ind)), dict(re.findall(rx, dash))
    for k in sorted(set(map_ind) | set(map_dash)):
        if k in map_ind and k in map_dash and map_ind[k] != map_dash[k]:
            problems.append("input %s: indicatore %s, dashboard %s" % (k, map_ind[k], map_dash[k]))
    # default SENZA macro che decidono il segnale: devono coincidere letteralmente
    for inp in ("InpAtrWilder",):
        rl = r"input\s+\w+\s+%s\s*=\s*([^;]+);" % inp
        a, b = re.findall(rl, ind), re.findall(rl, dash)
        if not a or not b or a[0].strip() != b[0].strip():
            problems.append("default di %s diverso: indicatore %r, dashboard %r" % (inp, a, b))
    # niente non-ASCII nei sorgenti
    for nm, txt in (("mqh", mqh), ("ind", ind), ("dash", dash), ("vol", vol)):
        bad = [c for c in txt if ord(c) > 127]
        if bad:
            problems.append("non-ASCII in %s: %r" % (nm, bad[:5]))
    return problems


# ---------------------------------------------------------------------------
# 7) Il .mqh VERO compilato come C++ (shim minimo delle funzioni MQL5 usate)
#    contro lo specchio Python, bit per bit. Senza questo passo il test prova
#    solo lo specchio: una divergenza fra .mqh e specchio passerebbe muta.
# ---------------------------------------------------------------------------
SHIM = r'''
#include <cmath>
#include <string>
#include <cstdio>
#include <cstdlib>
#include <cstddef>
typedef std::string string;
template<typename T, std::size_t N, typename V> void ArrayInitialize(T (&a)[N], V v){ for(std::size_t k=0;k<N;k++) a[k]=(T)v; }
inline double MathMax(double a,double b){ return a>b?a:b; }
inline double MathAbs(double a){ return std::fabs(a); }
inline double MathSqrt(double a){ return std::sqrt(a); }
inline int StringLen(const string &s){ return (int)s.size(); }
'''

DRIVER = r'''
#include "shim.h"
#include "conf.mqh"
int main(int argc,char**argv){
  SConfl e;
  int wild = argc>1 ? atoi(argv[1]) : 1;
  e.Init(ABTGC_D_EMA_FAST,ABTGC_D_EMA_SLOW,ABTGC_D_EMA_3,ABTGC_D_EMA_4,ABTGC_D_BB_PERIOD,ABTGC_D_BB_DEV,
         ABTGC_D_BB_EXP_BARS,ABTGC_D_BB_EXP_PCT,ABTGC_D_ATR_PERIOD,ABTGC_D_ST_MULT,wild!=0,ABTGC_D_CROSS_LB,
         ABTGC_D_SLOPE_BARS,ABTGC_D_BREAK_LB,ABTGC_D_COOLDOWN,ABTGC_D_VOL_PERIOD,ABTGC_D_VOL_FACTOR);
  double o,h,l,c,v;
  while(scanf("%lf %lf %lf %lf %lf",&o,&h,&l,&c,&v)==5){
    SConfl t = e;  t.Feed(o,h,l,c,v);          /* anteprima su COPIA: tmp = e */
    e.Feed(o,h,l,c,v);
    if(t.sigA!=e.sigA || t.sigB!=e.sigB || t.maskL!=e.maskL || t.maskS!=e.maskS || t.stVal!=e.stVal) return 3;
    printf("%d %d %d %d %a %a %a %a %a %a %d\n", e.sigA,e.sigB,e.maskL,e.maskS,e.e1,e.e2,e.bbw,e.atr,e.stVal,e.volMa,e.stDir);
  }
  return 0;
}
'''


def cxx_identity(root, mqh_text, seeds=(11, 23, 37, 5), n=4000):
    """Ritorna (barre, segnali, differenze) oppure None se non c'e' un compilatore C++."""
    import shutil
    import subprocess
    import tempfile
    cxx = shutil.which("g++") or shutil.which("clang++")
    if not cxx:
        return None
    with tempfile.TemporaryDirectory() as d:
        for nm, txt in (("shim.h", SHIM), ("drv.cpp", DRIVER), ("conf.mqh", mqh_text)):
            with open(os.path.join(d, nm), "w") as f:
                f.write(txt)
        exe = os.path.join(d, "drv")
        subprocess.run([cxx, "-std=c++17", "-O0", "-ffp-contract=off", "-o", exe, os.path.join(d, "drv.cpp")],
                       check=True, capture_output=True, text=True)
        tot = sig = bad = 0
        for seed in seeds:
            for wild in (1, 0):
                bars = make_bars(n, seed)
                inp = "\n".join("%r %r %r %r %r" % b for b in bars)
                r = subprocess.run([exe, str(wild)], input=inp, capture_output=True, text=True)
                if r.returncode != 0:
                    return (tot, sig, -1)          # la copia di struct ha cambiato il risultato
                out = r.stdout.split("\n")
                e = Confl(atrWilder=bool(wild))
                for i, b in enumerate(bars):
                    e.feed(*b)
                    p = out[i].split()
                    got = tuple(int(x) for x in p[:4]) + tuple(float.fromhex(x) for x in p[4:10]) + (int(p[10]),)
                    want = (e.sigA, e.sigB, e.maskL, e.maskS, e.e1, e.e2, e.bbw, e.atr, e.stVal, e.volMa, e.stDir)
                    tot += 1
                    sig += 1 if e.sigA != 0 else 0
                    if got != want:
                        bad += 1
        return (tot, sig, bad)


def main():
    root = os.path.abspath(os.path.join(os.path.dirname(__file__), ".."))
    fails = []
    base = dict()

    total_sig = {0: 0, 1: 0}
    print("== 1) P1 (indicatore incrementale + anteprima) == P2 (batch) ==")
    for seed in (11, 23, 37):
        bars = make_bars(4000, seed)
        p2, _ = run_batch(bars, base)
        # P1: si simula OGNI barra (arrivo di una barra nuova = un giro di OnCalculate)
        p1, forming = run_incremental(bars[:1400], base, full_recalc_every=40, seed=seed)
        p2s, _ = run_batch(bars[:1400], base)
        diff = [i for i in p2s if p1.get(i) != p2s[i]]
        nA = sum(1 for i in p2s if p2s[i][0] != 0)
        nB = sum(1 for i in p2s if p2s[i][1] != 0)
        print("  seed %d: %d barre chiuse, segnali sigA=%d sigB=%d, barre in formazione con segnale provvisorio=%d (scartate), differenze P1-P2=%d"
              % (seed, len(p2s), nA, nB, forming, len(diff)))
        if diff:
            fails.append("P1 != P2 seed %d (%d barre)" % (seed, len(diff)))

    print("== 2) P3 (dashboard, ultime 600 barre chiuse) == P1 sugli ultimi 4 bar ==")
    tot_checked = tot_active = tot_mism = 0
    for seed in (11, 23, 37):
        bars = make_bars(3000, seed)
        p2, _ = run_batch(bars, base)
        for v in (0, 1):
            total_sig[v] += sum(1 for i in p2 if p2[i][v] != 0)
        checked, active, mism = compare_dashboard(bars, p2, base, 600, 3, step=5, e_from=700)
        print("  seed %d: confronti %d, con freccia attesa %d, DIFFERENZE %d" % (seed, checked, active, mism))
        tot_checked += checked
        tot_active += active
        tot_mism += mism
    if tot_mism:
        fails.append("P3 != P1: %d differenze su %d confronti" % (tot_mism, tot_checked))
    if tot_active < 20:
        fails.append("troppo poche frecce attese (%d): il confronto non misura abbastanza" % tot_active)
    print("  totale: %d confronti, %d frecce attese, %d differenze | segnali totali sigA=%d sigB=%d"
          % (tot_checked, tot_active, tot_mism, total_sig[0], total_sig[1]))

    print("== 3) CONTRO-ESEMPI: il confronto deve accorgersi di una logica diversa ==")
    bars = make_bars(3000, 11)
    p2, _ = run_batch(bars, base)
    for label, alt in (("breakLB 3->2 nella dashboard", dict(breakLB=2)),
                       ("crossLB 3->1 nella dashboard", dict(crossLB=1)),
                       ("bbExpandBars 3->5 nella dashboard", dict(bbExpandBars=5)),
                       ("cooldown 5->0 nella dashboard", dict(cooldown=0)),
                       ("ATR SMA invece di Wilder nella dashboard", dict(atrWilder=False))):
        checked, active, mism = compare_dashboard(bars, p2, alt, 600, 3, step=5, e_from=700)
        verdict = "RILEVATO" if mism > 0 else "NON RILEVATO (il test e' cieco a questo!)"
        print("  %-45s -> differenze %d/%d : %s" % (label, mism, checked, verdict))
        if mism == 0:
            fails.append("contro-esempio non rilevato: " + label)

    print("== 4) Convergenza: finestra corta vs lunga (limite dichiarato del Supertrend path-dipendente) ==")
    for w in (150, 250, 400, 600):
        checked, active, mism = compare_dashboard(bars, p2, base, w, 3, step=5, e_from=700)
        print("  finestra %4d barre: differenze %d/%d" % (w, mism, checked))

    print("== 5) Mappatura click -> (simbolo, TF) dopo il riordino ==")
    n, bad = test_click_map()
    print("  %d oggetti decodificati dopo riordino, errori %d" % (n, bad))
    if bad:
        fails.append("mappatura click errata (%d)" % bad)
    test_symbol_click_tf()
    print("  SymbolClickTf: ok (piu' recente / pari eta' il piu' alto / nessuno -> TF principale)")

    print("== 6) Default e sorgenti ==")
    probs = test_defaults(root)
    for p in probs:
        print("  PROBLEMA:", p)
    if not probs:
        print("  ok: macro usate da indicatore e dashboard, pannello volumi coerente, ASCII puro")
    fails += probs

    print("== 7) .mqh VERO (compilato come C++ con shim) == specchio Python, bit per bit ==")
    mqh_text = read(os.path.join(root, "mql5/Include/ABTG_Confluenza.mqh"))
    res = cxx_identity(root, mqh_text)
    if res is None:
        print("  SALTATO: nessun compilatore C++ (g++/clang++) su questa macchina -> il test prova SOLO lo specchio")
    else:
        tot, sig, bad = res
        print("  %d barre (4 serie x Wilder/SMA), %d segnali, differenze %d" % (tot, sig, bad))
        if bad != 0:
            fails.append("il .mqh compilato NON coincide con lo specchio Python (%d differenze)" % bad)
        if sig < 50:
            fails.append("troppo pochi segnali nel confronto C++ (%d)" % sig)
        # contro-esempio: una mutazione di un carattere nel .mqh deve essere vista
        # (mutazioni STRUTTURALI: un "<" -> "<=" fra double e' un mutante equivalente, i pareggi esatti non capitano)
        for label, old, new in (("banda alta ST senza riarmo (prevClose > pu)", "(up < pu || prevClose > pu) ? up : pu", "(up < pu) ? up : pu"),
                                ("finestra incrocio senza la barra i", "for(int j = i - pCrossLB; j <= i; j++)", "for(int j = i - pCrossLB; j < i; j++)")):
            if old not in mqh_text:
                fails.append("contro-esempio C++ non applicabile (testo cambiato): " + label)
                continue
            _, _, mb = cxx_identity(root, mqh_text.replace(old, new, 1))
            verdict = "RILEVATO" if mb != 0 else "NON RILEVATO (confronto cieco!)"
            print("  mutazione %-40s -> differenze %d : %s" % (label, mb, verdict))
            if mb == 0:
                fails.append("mutazione del .mqh non rilevata: " + label)

    print()
    if fails:
        print("ESITO: FALLITO")
        for f in fails:
            print("  -", f)
        return 1
    print("ESITO: TUTTO OK (specchio Python del .mqh; NON prova la compilazione MQL5)")
    return 0


if __name__ == "__main__":
    sys.exit(main())
