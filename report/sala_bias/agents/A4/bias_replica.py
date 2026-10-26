#!/usr/bin/env python3
"""bias_replica.py (A4, SALA-BIAS-001) - replica del "MULTI TF BIAS" ESATTAMENTE come da
agents/A2/specifica_replica.md. Riutilizzabile per qualunque timeframe (W1, D1, H4, H1, M15):
la classe Motore riceve le barre OHLC+tick volume di UN timeframe e valuta lo score a ogni barra
chiusa. Solo libreria standard (Python 3.11, niente numpy).

DICHIARAZIONE: ricostruzione, NON validata contro l'indicatore originale.

Convenzione: indice i = barra chiusa k=0; k=1 e' la precedente (indice i-1), ecc. Tutte le serie
ricorsive (EMA, ATR, RSI, MACD) a indice i dipendono solo dalle barre <= i: nessun look-ahead.
Gli swing (fractal 3+3) a barra a usano a+3 ma vengono consultati solo per a <= i-3.

INTERPRETAZIONI DI DETTAGLIO (dove la specifica tace; nessuna e' un parametro ottimizzato):
 I1 ATR/RSI Wilder: seme = media semplice dei primi 14 valori (TR della prima barra = H-L).
 I2 MACD: M=EMA12-EMA26 con le EMA "grezze" (seme SMA); il segnale e' EMA9 di M seminata con la SMA
    dei primi 9 M. La regola "valida solo se >= 2n barre" (S17) e' applicata alle EMA 20/50/200 del
    Trend; per il Momentum vale la regola della specifica ">= 100 barre".
 I3 Le distanze (W^5, Hh^3 ecc.) sono divise per A = ATR14 alla barra k=0 (specifica: "A alla barra k=0,
    unita' di misura di ogni distanza").
 I4 Price action: ratio con denominatore 0 -> acc=0. Barra con R=0 -> voto 0 ma peso invariato.
 I5 Volume N/A se TUTTI i V delle ultime 20 barre sono 0 (o storico <20, o somma pesata 8 barre = 0).
 I6 Per il tetto di 5000 barre del buffer (S17) si usa tutto lo storico: l'effetto e' < 1e-12
    (verificato nell'autotest T10).
 I7 Pareggi esatti: la specifica da' HH solo se SH1>SH2 (uguale -> LH) e HL solo se SL1>SL2: su pareggi
    esatti la simmetria specchio puo' rompersi (proprieta' della specifica, non del codice).
"""
import math, sys, os, random, datetime as dt
QUI = os.path.dirname(os.path.abspath(__file__))
sys.path.insert(0, QUI)
import prepara_dati as PD

P_DEFAULT = dict(
    EMA=(20, 50, 200), RSI_N=14, MACD=(12, 26, 9), ATR_N=14, NS=5, L=150, SW=3, NP=8,
    W_COMP={'MS': 30, 'TR': 25, 'MO': 20, 'PA': 15, 'VO': 10},
    W_TF={'W1': 30, 'D1': 25, 'H4': 20, 'H1': 15, 'M15': 10},
    THETA=15.0, NB=6, DMIN=20.0, CMIN=2, NR=5, MAXBUF=5000, EMA_VALID_MULT=2, MIN_MOM=100)

TF_ORDER = ['W1', 'D1', 'H4', 'H1', 'M15']


# ---------------------------------------------------------------- utilita
def clip(x):
    return -1.0 if x < -1.0 else (1.0 if x > 1.0 else x)


def sgn(x):
    return (x > 0) - (x < 0)


def mean(xs):
    return sum(xs) / len(xs)


# ---------------------------------------------------------------- indicatori
def ema_raw(x, n):
    """EMA con seme SMA delle prime n barre: out[n-1]=SMA, poi alpha=2/(n+1)."""
    out = [None] * len(x)
    if len(x) < n:
        return out
    s = sum(x[:n]) / n
    out[n - 1] = s
    a = 2.0 / (n + 1)
    for i in range(n, len(x)):
        s = a * x[i] + (1.0 - a) * s
        out[i] = s
    return out


def atr_wilder(H, L, C, n):
    N = len(C)
    tr = [H[0] - L[0]] + [max(H[i] - L[i], abs(H[i] - C[i - 1]), abs(L[i] - C[i - 1])) for i in range(1, N)]
    out = [None] * N
    if N < n:
        return out
    a = sum(tr[:n]) / n
    out[n - 1] = a
    for i in range(n, N):
        a = (a * (n - 1) + tr[i]) / n
        out[i] = a
    return out


def rsi_wilder(C, n):
    N = len(C)
    out = [None] * N
    if N < n + 1:
        return out
    g = [max(C[i] - C[i - 1], 0.0) for i in range(1, N)]   # g[j] <-> barra j+1
    l = [max(C[i - 1] - C[i], 0.0) for i in range(1, N)]
    ag = sum(g[:n]) / n
    al = sum(l[:n]) / n

    def val(ag, al):
        if ag + al == 0:
            return 50.0
        if al == 0:
            return 100.0
        return 100.0 - 100.0 / (1.0 + ag / al)
    out[n] = val(ag, al)
    for i in range(n + 1, N):
        ag = (ag * (n - 1) + g[i - 1]) / n
        al = (al * (n - 1) + l[i - 1]) / n
        out[i] = val(ag, al)
    return out


def etichetta_forza(shown):
    if shown <= 9:
        return 'MOLTO DEBOLE'
    if shown <= 29:
        return 'DEBOLE'
    if shown <= 69:
        return 'NEUTRO'
    if shown <= 89:
        return 'FORTE'
    return 'MOLTO FORTE'


def bias_da_score(S, theta=15.0):
    if S is None:
        return None
    if abs(S) < theta:
        return 'NEUTRAL'
    return 'BULLISH' if S > 0 else 'BEARISH'


def score_mostrato(S):
    return int(math.floor(abs(S) + 0.5))


def combina(comp, W):
    num = den = 0.0
    for k, w in W.items():
        s = comp.get(k)
        if s is not None:
            num += w * s
            den += w
    return None if den == 0 else 100.0 * num / den


# ---------------------------------------------------------------- motore
class Motore:
    def __init__(self, O, H, L, C, V, p=None, nome='TF'):
        self.p = dict(P_DEFAULT)
        if p:
            self.p.update(p)
        p = self.p
        self.O, self.H, self.L, self.C, self.V = O, H, L, C, V
        self.N = len(C)
        self.nome = nome
        self.ema = {n: ema_raw(C, n) for n in p['EMA']}
        self.atr = atr_wilder(H, L, C, p['ATR_N'])
        self.rsi = rsi_wilder(C, p['RSI_N'])
        f, s, g = p['MACD']
        e1, e2 = ema_raw(C, f), ema_raw(C, s)
        self.M = [None if (a is None or b is None) else a - b for a, b in zip(e1, e2)]
        self.Sg = [None] * self.N
        self.Hh = [None] * self.N
        first = next((k for k, x in enumerate(self.M) if x is not None), None)
        if first is not None and self.N - first >= g:
            sg = ema_raw(self.M[first:], g)
            for k, v in enumerate(sg):
                if v is not None:
                    self.Sg[first + k] = v
                    self.Hh[first + k] = self.M[first + k] - v
        self.shf, self.slf = self._swing_flags()
        self._cc = {}
        self._cs = {}

    # --- swing: fractal 3+3. Barra a e' swing high se H[a]>H[a-m] (lato passato, stretto) e
    #     H[a]>=H[a+m] (lato recente), m=1..SW; swing low simmetrico.
    def _swing_flags(self):
        sw, H, L, N = self.p['SW'], self.H, self.L, self.N
        shf, slf = [False] * N, [False] * N
        for a in range(sw, N - sw):
            hh, ll = H[a], L[a]
            if all(hh > H[a - m] for m in range(1, sw + 1)) and all(hh >= H[a + m] for m in range(1, sw + 1)):
                shf[a] = True
            if all(ll < L[a - m] for m in range(1, sw + 1)) and all(ll <= L[a + m] for m in range(1, sw + 1)):
                slf[a] = True
        return shf, slf

    def _last2(self, flags, e):
        sw, Lw = self.p['SW'], self.p['L']
        lo = max(sw, e - (Lw - 1 - sw))
        res = []
        for a in range(e - sw, lo - 1, -1):
            if flags[a]:
                res.append(a)
                if len(res) == 2:
                    break
        return res

    def nb(self, i):
        return min(i + 1, self.p['MAXBUF'])

    def ema_at(self, j, n):
        if j < 0:
            return None
        v = self.ema[n][j]
        if v is None:
            return None
        if min(j + 1, self.p['MAXBUF']) < self.p['EMA_VALID_MULT'] * n:
            return None
        return v

    def A(self, i):
        a = self.atr[i]
        return a if (a is not None and a > 0) else None

    # --- componenti ---------------------------------------------------------------
    def _pattern(self, e):
        """(P, SHvalore, SLvalore) alla barra e, oppure None se <2 swing per tipo."""
        sh, sl = self._last2(self.shf, e), self._last2(self.slf, e)
        if len(sh) < 2 or len(sl) < 2:
            return None
        SH1, SH2 = self.H[sh[0]], self.H[sh[1]]
        SL1, SL2 = self.L[sl[0]], self.L[sl[1]]
        hh, hl = SH1 > SH2, SL1 > SL2
        P = 1 if (hh and hl) else (-1 if ((not hh) and (not hl)) else 0)
        lab = ('HH' if hh else 'LH') + '/' + ('HL' if hl else 'LL')
        return P, SH1, SL1, lab

    def struttura(self, i):
        """Market Structure: ritorna (sMS, info) o (None, info)."""
        pat = self._pattern(i)
        info = {'label': None, 'rottura': None}
        if pat is None:
            return None, info
        P, _, _, lab = pat
        B, tipo = 0, None
        C = self.C
        for b in range(self.p['NR']):
            e = i - b
            if e - 1 < 0:
                break
            pb = self._pattern(e)
            if pb is None:
                continue
            Pb, shv, slv, _ = pb
            up = C[e] > shv and C[e - 1] <= shv
            dn = C[e] < slv and C[e - 1] >= slv
            if up or dn:
                d = 1 if up else -1
                B = d
                tipo = ('BOS' if d * Pb >= 0 else 'CHoCH') + ('▲' if d > 0 else '▼')
                break
        info['label'] = lab
        info['rottura'] = tipo
        return 0.6 * P + 0.4 * B, info

    def trend(self, i):
        A = self.A(i)
        if A is None or i - self.p['NS'] < 0:
            return None
        ns = self.p['NS']
        ns_ = self.p['EMA']
        e0 = {n: self.ema_at(i, n) for n in ns_}
        e5 = {n: self.ema_at(i - ns, n) for n in ns_}
        if any(v is None for v in e0.values()) or any(v is None for v in e5.values()):
            return None
        C = self.C[i]
        pos = mean([clip((C - e0[n]) / A) for n in ns_])
        E20, E50, E200 = e0[20], e0[50], e0[200]
        ordv = (clip((E20 - E50) / (0.25 * A)) + clip((E50 - E200) / (0.25 * A)) + clip((E20 - E200) / (0.25 * A))) / 3.0
        slope = mean([clip((e0[n] - e5[n]) / (ns * A) / 0.10) for n in ns_])
        W0 = (E20 - E200) / A
        W5 = (e5[20] - e5[200]) / A      # I3: stessa unita' A (k=0)
        ws = clip(W0 / 3.0)
        dW = W0 - W5
        e = clip(sgn(W0) * dW / 0.5)
        spread = ws * (0.5 + 0.5 * e)
        return 0.30 * pos + 0.30 * ordv + 0.25 * slope + 0.15 * spread

    def momentum(self, i):
        A = self.A(i)
        if A is None or self.nb(i) < self.p['MIN_MOM'] or i < 3:
            return None
        r0, r3 = self.rsi[i], self.rsi[i - 3]
        M, Hh0, Hh3 = self.M[i], self.Hh[i], self.Hh[i - 3]
        if r0 is None or r3 is None or M is None or Hh0 is None or Hh3 is None:
            return None
        rl = sgn(r0 - 50.0) * clip((abs(r0 - 50.0) - 5.0) / 15.0)
        rd = clip((r0 - r3) / 8.0)
        sRSI = 0.7 * rl + 0.3 * rd
        sMACD = 0.4 * clip(M / (0.5 * A)) + 0.4 * clip(Hh0 / (0.15 * A)) + 0.2 * clip((Hh0 - Hh3) / (0.10 * A))
        return 0.5 * sRSI + 0.5 * sMACD

    def price_action(self, i):
        Np = self.p['NP']
        A = self.A(i)
        if A is None or i < Np - 1:
            return None
        O, H, L, C = self.O, self.H, self.L, self.C
        num = den = 0.0
        Rs = []
        for k in range(Np):
            j = i - k
            R = H[j] - L[j]
            Rs.append(R)
            if R > 0:
                cl = 2.0 * (C[j] - L[j]) / R - 1.0
                br = (C[j] - O[j]) / R
                rj = (min(O[j], C[j]) - L[j]) / R - (H[j] - max(O[j], C[j])) / R
                bk = 0.4 * cl + 0.4 * br + 0.2 * rj
            else:
                bk = 0.0
            w = Np - k
            num += w * bk
            den += w
        base = num / den
        m_new, m_old = mean(Rs[:4]), mean(Rs[4:])
        ratio = (m_new / m_old) if m_old > 0 else 1.0
        acc = clip((ratio - 1.0) / 0.5) * clip(base / 0.2)
        D = clip((C[i] - C[i - (Np - 1)]) / (2.0 * A))
        return 0.60 * base + 0.25 * D + 0.15 * acc

    def volume(self, i):
        Np = self.p['NP']
        if i < 19 or self.nb(i) < 20:
            return None
        V = self.V
        v20 = V[i - 19:i + 1]
        if all(x == 0 for x in v20):
            return None
        num = den = 0.0
        for k in range(Np):
            j = i - k
            w = Np - k
            num += w * sgn(self.C[j] - self.O[j]) * V[j]
            den += w * V[j]
        if den == 0:
            return None
        bal = num / den
        g = min(max(mean(V[i - 3:i + 1]) / mean(v20), 0.5), 1.5) - 0.5
        return bal * g

    def componenti(self, i):
        if i in self._cc:
            return self._cc[i]
        ms, info = self.struttura(i)
        c = {'MS': ms, 'TR': self.trend(i), 'MO': self.momentum(i), 'PA': self.price_action(i), 'VO': self.volume(i)}
        c['_info'] = info
        self._cc[i] = c
        return c

    def score(self, i):
        """Score S in [-100,100] (non arrotondato) alla barra chiusa i, o None."""
        if i < 0:
            return None
        if i in self._cs:
            return self._cs[i]
        c = self.componenti(i)
        S = combina({k: c[k] for k in self.p['W_COMP']}, self.p['W_COMP'])
        self._cs[i] = S
        return S

    # --- livello dashboard del singolo TF ---------------------------------------------
    def confidenza(self, i):
        S = self.score(i)
        if S is None:
            return None
        c = self.componenti(i)
        d = 1 if S >= 0 else -1
        num = den = 0.0
        for k, w in self.p['W_COMP'].items():
            s = c[k]
            if s is None:
                continue
            if d * s >= 0.10:
                a = 1.0
            elif d * s <= -0.10:
                a = 0.0
            else:
                a = 0.5
            num += w * a
            den += w
        return 100.0 * num / den

    def alert(self, i):
        """'BIAS CHANGING', 'WEAKENING' o None (spec sez. 8)."""
        Nb, theta = self.p['NB'], self.p['THETA']
        Sb = [self.score(i - b) for b in range(Nb)]
        c = self.componenti(i)
        return alert_da_serie(Sb, c, self.p['DMIN'], theta, self.p['CMIN'])

    def analizza(self, i):
        S = self.score(i)
        if S is None:
            return dict(S=None, bias=None)
        Sp = self.score(i - 1)
        dS = None if Sp is None else S - Sp
        mostrato = score_mostrato(S)
        c = self.componenti(i)
        info = c['_info']
        struct = (info['label'] or '') + (' ' + info['rottura'] if info['rottura'] else '')
        return dict(S=S, bias=bias_da_score(S, self.p['THETA']), mostrato=mostrato, forza=etichetta_forza(mostrato),
                    delta=('▲' if (dS is not None and dS >= 1) else ('▼' if (dS is not None and dS <= -1) else '')),
                    conf=self.confidenza(i), struct=struct.strip(), alert=self.alert(i), comp=c)


def alert_da_serie(Sb, comp, dmin=20.0, theta=15.0, cmin=2):
    """Sb = [S(0), S(1), ..., S(Nb-1)] (S(0)= barra piu' recente). comp = dict dei componenti a b=0."""
    if any(s is None for s in Sb):
        return None
    bp = max(range(len(Sb)), key=lambda b: (abs(Sb[b]), -b))
    D = sgn(Sb[bp])
    Pk = abs(Sb[bp])
    if D == 0 or Pk < theta:
        return None
    c1 = Pk - D * Sb[0] >= dmin
    c2 = len(Sb) >= 3 and D * Sb[0] < D * Sb[1] and D * Sb[1] < D * Sb[2]
    if not (c1 and c2):
        return None
    contrari = sum(1 for k in ('MS', 'TR', 'MO', 'PA') if comp.get(k) is not None and D * comp[k] <= -0.10)
    return 'BIAS CHANGING' if contrari >= cmin else 'WEAKENING'


# ---------------------------------------------------------------- quadro d'insieme (spec sez. 7)
def quadro(res, W=None, theta=15.0, on=None):
    """res: dict tf -> dict(S, bias, conf) (output di Motore.analizza). Considera solo i TF in `on`
    (default: tutti quelli con S). Ritorna dict con overall, allineamento, confidenza, contro-trend, HTF."""
    W = W or P_DEFAULT['W_TF']
    tfs = [t for t in TF_ORDER if t in res and res[t].get('S') is not None and (on is None or t in on)]
    if not tfs:
        return dict(S=None)
    sw = sum(W[t] for t in tfs)
    S_all = sum(W[t] * res[t]['S'] for t in tfs) / sw
    bias = bias_da_score(S_all, theta)
    mostrato = score_mostrato(S_all)
    nB = sum(1 for t in tfs if res[t]['bias'] == 'BULLISH')
    nS = sum(1 for t in tfs if res[t]['bias'] == 'BEARISH')
    N = len(tfs)
    parti = []
    if nB:
        parti.append('%d/%d BULLISH' % (nB, N))
    if nS:
        parti.append('%d/%d BEARISH' % (nS, N))
    allin = ' – '.join(parti) if parti else '0/%d allineati' % N

    def concorde(t):
        if res[t]['bias'] == 'NEUTRAL':
            return 0.5
        if bias == 'NEUTRAL':
            return 0.5 if False else 0.0     # Overall NEUTRAL e TF non neutrale: non concorde
        return 1.0 if res[t]['bias'] == bias else 0.0
    conf_all = 0.5 * sum(W[t] * concorde(t) for t in tfs) / sw + \
        0.5 * sum(W[t] * (res[t].get('conf') or 0.0) for t in tfs) / sw
    contro = {}
    for k, t in enumerate(tfs):
        sopra = tfs[:k]
        if not sopra or res[t]['bias'] == 'NEUTRAL':
            contro[t] = False
            continue
        ws = sum(W[u] for u in sopra)
        H = sum(W[u] * res[u]['S'] for u in sopra) / ws
        contro[t] = abs(H) >= theta and sgn(H) != sgn(res[t]['S'])
    htf = [t for t in ('W1', 'D1', 'H4') if t in tfs]
    htf_S = (sum(W[t] * res[t]['S'] for t in htf) / sum(W[t] for t in htf)) if htf else None
    return dict(S=S_all, bias=bias, mostrato=mostrato, forza=etichetta_forza(mostrato), allineamento=allin,
                conf=conf_all, contro_trend=contro, htf=(bias_da_score(htf_S, theta) if htf else None), htf_S=htf_S)


# ---------------------------------------------------------------- rendimenti
def rendimento_fwd(opens, closes, t, h):
    """Rendimento semplice con ingresso all'apertura t+1 e uscita alla chiusura t+h: close[t+h]/open[t+1]-1.
    None se la barra t+h non esiste (nessun NaN trattato come zero)."""
    if t + h >= len(closes) or t + 1 >= len(opens) or t < 0:
        return None
    return closes[t + h] / opens[t + 1] - 1.0


# ---------------------------------------------------------------- pipeline W1+D1
def serie_di(rows):
    return ([r['o'] for r in rows], [r['h'] for r in rows], [r['l'] for r in rows],
            [r['c'] for r in rows], [r['v'] for r in rows])


def calcola_overall(d1, only=None, params=None, pesi=None):
    """Score Overall W1+D1 (pesi 30/25 riportati a 100: W1 54,5% / D1 45,5%) per ogni barra D1 fusa.
    Regola W1 (criteri v2 punto 3): al giorno t si usano solo le settimane con ultima barra < t
    (il venerdi' t usa le settimane fino a k-1; da lunedi' usa la settimana k).
    Ritorna lista di dict(date, sW, sD, S) (S=None se nessun TF disponibile). only=lista di indici."""
    pesi = pesi or {'W1': P_DEFAULT['W_TF']['W1'], 'D1': P_DEFAULT['W_TF']['D1']}
    wk = PD.settimane(d1)
    eD = Motore(*serie_di(d1), p=params, nome='D1')
    eW = Motore(*serie_di(wk), p=params, nome='W1')
    out = []
    idx = range(len(d1)) if only is None else only
    j = 0
    for i in idx:
        t = d1[i]['date']
        if only is not None:
            j = sum(1 for w in wk if w['last_date'] < t)
        else:
            while j < len(wk) and wk[j]['last_date'] < t:
                j += 1
        sW = eW.score(j - 1) if j >= 1 else None
        sD = eD.score(i)
        num = den = 0.0
        for tf, s in (('W1', sW), ('D1', sD)):
            if s is not None:
                num += pesi[tf] * s
                den += pesi[tf]
        out.append(dict(date=t, i=i, sW=sW, sD=sD, S=(num / den if den else None)))
    return out


# ================================================================== AUTOTEST
class Esito:
    def __init__(self):
        self.righe = []
        self.ok = True

    def add(self, nome, ok, dettaglio=''):
        self.righe.append('%s  %s%s' % ('PASS' if ok else 'FAIL', nome, ('  | ' + dettaglio) if dettaglio else ''))
        if not ok:
            self.ok = False
        print(self.righe[-1], flush=True)


def _sintetico(n, seed, vol=True, nonzero_vol=True):
    rnd = random.Random(seed)
    O, H, L, C, V = [], [], [], [], []
    c = 100.0
    drift = 0.0
    for k in range(n):
        if k % 120 == 0:
            drift = rnd.gauss(0, 0.004)
        o = c * (1 + rnd.gauss(0, 0.002))
        c = o * (1 + drift + rnd.gauss(0, 0.012))
        h = max(o, c) * (1 + abs(rnd.gauss(0, 0.006)))
        l = min(o, c) * (1 - abs(rnd.gauss(0, 0.006)))
        O.append(o); H.append(h); L.append(l); C.append(c)
        V.append(rnd.randint(500, 5000) if vol else 0)
    return O, H, L, C, V


def autotest(d1_path=None, verbose=True, n_prefisso=320, n_sporco=40, seed=20261026, solo_rapidi=False):
    es = Esito()
    d1 = PD.leggi_d1(d1_path or os.path.join(QUI, 'D1_fuso.csv'))
    wk = PD.settimane(d1)

    # ---- T1 indicatori su esempi a mano
    e = ema_raw([1.0, 2.0, 3.0, 4.0, 5.0, 6.0], 3)
    # seme SMA(1,2,3)=2 ; alpha=0.5: 4->3.0 ; 5->4.0 ; 6->5.0
    es.add('T1a EMA(3) seme SMA su 1..6 = [-,-,2,3,4,5]',
           e[:2] == [None, None] and all(abs(a - b) < 1e-12 for a, b in zip(e[2:], [2.0, 3.0, 4.0, 5.0])))
    r = rsi_wilder([float(k) for k in range(1, 40)], 14)
    es.add('T1b RSI(14) di serie strettamente crescente = 100', abs(r[-1] - 100.0) < 1e-12 and r[13] is None and r[14] == 100.0)
    c = [10.0 + (1 if k % 2 else 0) for k in range(60)]
    r = rsi_wilder(c, 14)
    es.add('T1c RSI(14) con up/down alternati di pari ampiezza e vicino a 50', abs(r[-1] - 50.0) < 4.0, 'RSI=%.3f' % r[-1])
    H_ = [11.0] * 30; L_ = [9.0] * 30; C_ = [10.0] * 30
    a = atr_wilder(H_, L_, C_, 14)
    es.add('T1d ATR(14) con range costante 2 = 2', abs(a[-1] - 2.0) < 1e-12 and a[12] is None and abs(a[13] - 2.0) < 1e-12)
    # Wilder: dopo seme, RMA. TR = [2]*14 poi un TR=16 -> (2*13+16)/14 = 3.0
    H2 = [11.0] * 14 + [26.0]; L2 = [9.0] * 14 + [10.0]; C2 = [10.0] * 14 + [25.0]
    a = atr_wilder(H2, L2, C2, 14)
    es.add('T1e ATR Wilder: (2*13+16)/14 = 3.0', abs(a[14] - 3.0) < 1e-12, 'ATR=%.6f' % a[14])

    # ---- T2 range [-1,1] / [-100,100] su dati reali (tutte le date) e sintetici
    mD = Motore(*serie_di(d1), nome='D1')
    mW = Motore(*serie_di(wk), nome='W1')
    viol = 0
    nS = {'D1': 0, 'W1': 0}
    mx = {'D1': 0.0, 'W1': 0.0}
    for nome, m in (('D1', mD), ('W1', mW)):
        for i in range(m.N):
            S = m.score(i)
            c = m.componenti(i)
            for k in ('MS', 'TR', 'MO', 'PA', 'VO'):
                if c[k] is not None and not (-1.0 - 1e-12 <= c[k] <= 1.0 + 1e-12):
                    viol += 1
            if S is not None:
                nS[nome] += 1
                mx[nome] = max(mx[nome], abs(S))
                if not (-100.0 - 1e-9 <= S <= 100.0 + 1e-9):
                    viol += 1
    es.add('T2 componenti in [-1,1] e score in [-100,100] (D1 e W1 reali, tutte le barre)', viol == 0,
           'violazioni=%d, barre con score D1=%d/%d, W1=%d/%d, max|S| D1=%.1f W1=%.1f' % (
               viol, nS['D1'], mD.N, nS['W1'], mW.N, mx['D1'], mx['W1']))
    O, H, L, C, V = _sintetico(2500, 11)
    ms = Motore(O, H, L, C, V)
    v2 = sum(1 for i in range(ms.N) if ms.score(i) is not None and abs(ms.score(i)) > 100 + 1e-9)
    es.add('T2b score in [-100,100] su 2500 barre sintetiche', v2 == 0)

    # ---- T3 simmetria (specchio): P' = K-P, H'=K-L, L'=K-H, O'=K-O, C'=K-C, V invariato => s'=-s
    K = 10000.0
    O, H, L, C, V = _sintetico(2500, 12)
    m1 = Motore(O, H, L, C, V)
    m2 = Motore([K - x for x in O], [K - x for x in L], [K - x for x in H], [K - x for x in C], V)
    md = 0.0
    n = 0
    for i in range(m1.N):
        c1, c2 = m1.componenti(i), m2.componenti(i)
        for k in ('MS', 'TR', 'MO', 'PA', 'VO'):
            if (c1[k] is None) != (c2[k] is None):
                md = max(md, 1.0)
            elif c1[k] is not None:
                md = max(md, abs(c1[k] + c2[k]))
        s1, s2 = m1.score(i), m2.score(i)
        if s1 is not None and s2 is not None:
            md = max(md, abs(s1 + s2))
            n += 1
    es.add('T3a simmetria specchio su 2500 barre sintetiche (componenti e score: s(specchio) = -s; tolleranza 1e-7 per l\'arrotondamento di K-P)', md < 1e-7,
           'max|s+s\'|=%.2e su %d score' % (md, n))
    Od, Hd, Ld, Cd, Vd = serie_di(d1)
    m2 = Motore([K - x for x in Od], [K - x for x in Ld], [K - x for x in Hd],
                [K - x for x in Cd], Vd)
    md, ndiff, n = 0.0, 0, 0
    for i in range(0, mD.N):
        s1, s2 = mD.score(i), m2.score(i)
        if s1 is not None and s2 is not None:
            n += 1
            d = abs(s1 + s2)
            md = max(md, d)
            if d > 1e-6:
                ndiff += 1
    es.add('T3b simmetria specchio su D1 reale (informativa: eventuali differenze solo da pareggi esatti, I7)',
           ndiff <= max(5, int(0.01 * n)), 'barre con |S+S\'|>1e-6: %d su %d (max %.2e)' % (ndiff, n, md))

    # ---- T4 invarianza di scala del prezzo e del volume; traslazione del prezzo
    O, H, L, C, V = _sintetico(1500, 13)
    m1 = Motore(O, H, L, C, V)
    m2 = Motore([x * 7.3 for x in O], [x * 7.3 for x in H], [x * 7.3 for x in L], [x * 7.3 for x in C], [v * 100 for v in V])
    m3 = Motore([x + 5000 for x in O], [x + 5000 for x in H], [x + 5000 for x in L], [x + 5000 for x in C], V)
    d12 = d13 = 0.0
    for i in range(m1.N):
        a, b, c3 = m1.score(i), m2.score(i), m3.score(i)
        if a is not None:
            d12 = max(d12, abs(a - b))
            d13 = max(d13, abs(a - c3))
    es.add('T4a invarianza: prezzi x7,3 e volume x100 => stesso score (volume normalizzato su media mobile corta a 20 barre)',
           d12 < 1e-9, 'max diff=%.2e' % d12)
    es.add('T4b invarianza per traslazione dei prezzi (+5000)', d13 < 1e-8, 'max diff=%.2e' % d13)

    # ---- T5 volume N/A senza tick volume; score rinormalizzato
    O, H, L, C, V = _sintetico(600, 14)
    mz = Motore(O, H, L, C, [0] * 600)
    mv = Motore(O, H, L, C, V)
    i = 500
    cz = mz.componenti(i)
    ok = cz['VO'] is None and mz.score(i) is not None
    num = sum(P_DEFAULT['W_COMP'][k] * cz[k] for k in ('MS', 'TR', 'MO', 'PA') if cz[k] is not None)
    den = sum(P_DEFAULT['W_COMP'][k] for k in ('MS', 'TR', 'MO', 'PA') if cz[k] is not None)
    es.add('T5 volumi tutti 0 -> componente VO N/A e pesi rinormalizzati a 100', ok and abs(mz.score(i) - 100 * num / den) < 1e-12)
    ms_ = Motore(O[:60], H[:60], L[:60], C[:60], V[:60])
    c = ms_.componenti(59)
    es.add('T5b storico corto (60 barre): Trend (EMA200) e Momentum (<100 barre) N/A, nessun valore inventato',
           c['TR'] is None and c['MO'] is None)

    # ---- T6 struttura su zigzag a mano (P=+1 / -1) e rottura
    def zig(pts, per=6):
        cl = []
        for a, b in zip(pts[:-1], pts[1:]):
            for k in range(per):
                cl.append(a + (b - a) * k / per)
        cl.append(pts[-1])
        O_ = [cl[0]] + cl[:-1]
        Hh = [max(o, c) + 0.05 for o, c in zip(O_, cl)]
        Ll = [min(o, c) - 0.05 for o, c in zip(O_, cl)]
        return O_, Hh, Ll, cl
    up = [100, 110, 105, 118, 112, 126, 120, 134, 128]            # HH/HL
    O_, H_, L_, C_ = zig(up)
    mz = Motore(O_, H_, L_, C_, [1000] * len(C_))
    pat = mz._pattern(len(C_) - 1)
    es.add('T6a zigzag ascendente (massimi e minimi crescenti) -> HH/HL, P=+1', pat is not None and pat[0] == 1 and pat[3] == 'HH/HL',
           str(pat and (pat[0], pat[3])))
    dn = [200, 190, 195, 182, 188, 174, 180, 166, 172]
    O_, H_, L_, C_ = zig(dn)
    mz = Motore(O_, H_, L_, C_, [1000] * len(C_))
    pat = mz._pattern(len(C_) - 1)
    es.add('T6b zigzag discendente -> LH/LL, P=-1', pat is not None and pat[0] == -1 and pat[3] == 'LH/LL')
    # rottura: zigzag ascendente che termina con un nuovo rialzo oltre l'ultimo swing high (134)
    O2, H2, L2, cl = zig(up + [136])
    mz = Motore(O2, H2, L2, cl, [1000] * len(cl))
    inf = mz.struttura(len(cl) - 1)[1]
    es.add('T6c chiusura oltre l\'ultimo swing high entro 5 barre -> BOS▲ (pattern concorde)', inf['rottura'] == 'BOS▲', str(inf))
    cond = mz.struttura(len(cl) - 1)[0]
    es.add('T6d sMS = 0.6*P + 0.4*B = 1.0 con HH/HL+BOS', cond is not None and abs(cond - 1.0) < 1e-12, str(cond))

    # ---- T7 quadro d'insieme e alert su numeri a mano
    res = {'W1': dict(S=60.0, bias='BULLISH', conf=80.0), 'D1': dict(S=40.0, bias='BULLISH', conf=60.0),
           'H4': dict(S=-30.0, bias='BEARISH', conf=50.0)}
    q = quadro(res, W={'W1': 30, 'D1': 25, 'H4': 20, 'H1': 15, 'M15': 10})
    Sx = (30 * 60 + 25 * 40 + 20 * -30) / 75.0
    ok = abs(q['S'] - Sx) < 1e-12 and q['bias'] == 'BULLISH' and q['allineamento'] == '2/3 BULLISH – 1/3 BEARISH' \
        and q['contro_trend']['H4'] is True and q['contro_trend']['D1'] is False and q['contro_trend']['W1'] is False
    es.add('T7a quadro: Overall pesato, allineamento "2/3 BULLISH – 1/3 BEARISH", H4 CONTRO-TREND', ok, str(q))
    es.add('T7b forza: 0-9 MOLTO DEBOLE, 10-29 DEBOLE, 30-69 NEUTRO, 70-89 FORTE, 90-100 MOLTO FORTE',
           [etichetta_forza(x) for x in (9, 10, 29, 30, 69, 70, 89, 90, 100)] ==
           ['MOLTO DEBOLE', 'DEBOLE', 'DEBOLE', 'NEUTRO', 'NEUTRO', 'FORTE', 'FORTE', 'MOLTO FORTE', 'MOLTO FORTE'])
    es.add('T7c bias: |S|<15 NEUTRAL, -75 -> BEARISH 75, arrotondamento half-up',
           bias_da_score(14.99) == 'NEUTRAL' and bias_da_score(-75.0) == 'BEARISH' and score_mostrato(-75.0) == 75
           and score_mostrato(74.5) == 75 and bias_da_score(15.0) == 'BULLISH')
    # alert: picco 70 poi 60, 50, 40 (due cali consecutivi, calo 30>=20)
    Sb = [40.0, 50.0, 60.0, 70.0, 65.0, 62.0]
    cc = {'MS': -0.5, 'TR': -0.3, 'MO': 0.2, 'PA': 0.1}
    es.add('T7d alert BIAS CHANGING (picco-S0>=20, 2 cali, >=2 componenti contrari)', alert_da_serie(Sb, cc) == 'BIAS CHANGING')
    cc2 = {'MS': -0.5, 'TR': 0.3, 'MO': 0.2, 'PA': 0.1}
    es.add('T7e WEAKENING se 1+2 vere ma 3 falsa; nessun alert con una sola candela contraria',
           alert_da_serie(Sb, cc2) == 'WEAKENING' and alert_da_serie([55.0, 56.0, 50.0, 49.0, 40.0, 30.0], cc) is None)

    # ---- T8 fusione domeniche
    raw = PD.leggi_raw()
    fu = PD.fondi_domeniche(raw)
    ok = all(r['date'].weekday() < 5 for r in fu) and sum(r['dom'] for r in fu) == sum(1 for r in raw if r['date'].weekday() == 6)
    raw_ok = [r for r in raw if r['date'] >= PD.INIZIO - dt.timedelta(days=1)]   # incl. la domenica che precede il primo lunedi'
    ok = ok and sum(r['v'] for r in fu) == sum(r['v'] for r in raw_ok) and sum(r['n_raw'] for r in fu) == len(raw_ok)
    es.add('T8a fusione: nessuna barra di domenica/sabato, tickvol e conteggio barre conservati', ok,
           'barre fuse=%d, domeniche fuse=%d' % (len(fu), sum(r['dom'] for r in fu)))
    # verifica puntuale a mano su una domenica reale
    rr = {r['date']: r for r in raw}
    sd, mo = dt.date(2026, 10, 18), dt.date(2026, 10, 19)
    f = next(r for r in fu if r['date'] == mo)
    ok = (f['o'] == rr[sd]['o'] and f['c'] == rr[mo]['c'] and f['h'] == max(rr[sd]['h'], rr[mo]['h'])
          and f['l'] == min(rr[sd]['l'], rr[mo]['l']) and f['v'] == rr[sd]['v'] + rr[mo]['v'])
    es.add('T8b fusione puntuale 2026-10-18(dom)+2026-10-19(lun): open dom, high/low estremi, close lun, tickvol sommato', ok)
    ok = True
    for cut_date in (dt.date(2008, 7, 2), dt.date(2015, 3, 3), dt.date(2024, 9, 5), dt.date(2026, 10, 7)):
        k = next(ix for ix, r in enumerate(raw) if r['date'] == cut_date)
        a = PD.fondi_domeniche(raw[:k + 1])
        b = [r for r in fu if r['date'] <= cut_date]
        ok = ok and len(a) == len(b) and all(x['date'] == y['date'] and x['o'] == y['o'] and x['c'] == y['c'] and x['v'] == y['v']
                                            for x, y in zip(a, b))
    es.add('T8c fusione causale: fusione del troncato = prefisso della fusione intera', ok)

    # ---- T9 regola W1 del criterio v2 punto 3 (venerdi' usa fino a k-1; lunedi' usa la settimana k)
    # prendo una settimana k completa in un periodo con W1 pienamente definito
    kk = next(ix for ix, w in enumerate(wk) if w['date'] == dt.date(2018, 3, 5))
    wk_k = wk[kk]
    ven = [i for i, r in enumerate(d1) if r['date'] == wk_k['last_date']][0]
    lun = ven + 1
    assert d1[lun]['date'] == wk[kk + 1]['first_date']
    base = calcola_overall(d1, only=[ven, lun])
    d1b = [dict(r) for r in d1]
    d1b[ven]['c'] = d1b[ven]['c'] * 0.90
    d1b[ven]['l'] = min(d1b[ven]['l'], d1b[ven]['c'])
    alt = calcola_overall(d1b, only=[ven, lun])
    ok = abs(base[0]['sW'] - alt[0]['sW']) < 1e-12 and abs(base[1]['sW'] - alt[1]['sW']) > 1e-6 and abs(base[0]['sD'] - alt[0]['sD']) > 1e-6
    es.add('T9 regola W1: il venerdi\' t non vede la settimana k (S_W1 invariato se si altera il close di venerdi\'), il lunedi\' la vede',
           ok, 'ven %s: sW %.4f->%.4f | lun %s: sW %.4f->%.4f' % (d1[ven]['date'], base[0]['sW'], alt[0]['sW'],
                                                                  d1[lun]['date'], base[1]['sW'], alt[1]['sW']))

    # ---- T10 tetto 5000 barre del buffer irrilevante (S17)
    full = calcola_overall(d1, only=[len(d1) - 1 - 40 * q_ for q_ in range(0, 6)])
    md = 0.0
    for q_ in range(0, 6):
        i = len(d1) - 1 - 40 * q_
        sub = d1[i - 4999:i + 1]
        r = calcola_overall(sub, only=[len(sub) - 1])[0]['sD']
        md = max(md, abs(r - full[q_]['sD']))
    es.add('T10 buffer limitato alle ultime 5000 barre (S17) vs storico intero: differenza S_D1 trascurabile', md < 1e-9,
           'max diff S_D1=%.2e su 6 date' % md)

    # ---- T11 esempio a mano del rendimento close[t+h]/open[t+1]-1
    Os = [10.0, 11.0, 12.0, 13.0, 14.0, 15.0, 16.0]
    Cs = [10.5, 11.5, 12.5, 13.5, 14.5, 15.5, 16.5]
    es.add('T11a rendimento sintetico: t=1,h=3: close[4]/open[2]-1 = 14.5/12-1 = 0.208333..',
           abs(rendimento_fwd(Os, Cs, 1, 3) - (14.5 / 12.0 - 1.0)) < 1e-15
           and rendimento_fwd(Os, Cs, 4, 3) is None and rendimento_fwd(Os, Cs, 3, 3) is not None)
    # esempio sui dati reali (valori letti a mano dal CSV grezzo): t=2020-03-02 (lunedi'),
    # ingresso open del 2020-03-03 (1591.91), uscita close del 2020-03-09 (1666.36; barra fusa con la domenica 03-08):
    # h=5 barre fuse = 03-03, 03-04, 03-05, 03-06, 03-09 -> r = 1666.36/1591.91 - 1 = 0.0467677 (calcolo a mano sul CSV grezzo)
    ix = {r['date']: k for k, r in enumerate(d1)}
    t = ix[dt.date(2020, 3, 2)]
    o_in = d1[t + 1]['o']
    c_out = d1[t + 5]['c']
    r_f = rendimento_fwd(*serie_di(d1)[0:1], serie_di(d1)[3], t, 5)
    es.add('T11b rendimento reale t=2020-03-02, h=5: entrata open 2020-03-03 (%.2f), uscita close %s (%.2f)' % (
        o_in, d1[t + 5]['date'], c_out),
        d1[t + 1]['date'] == dt.date(2020, 3, 3) and d1[t + 5]['date'] == dt.date(2020, 3, 9) and abs(r_f - (c_out / o_in - 1.0)) < 1e-15 \
        and abs(o_in - 1591.91) < 1e-9 and abs(c_out - 1666.36) < 1e-9 and abs(r_f - (1666.36 / 1591.91 - 1.0)) < 1e-12,
        'r=%.6f' % r_f)
    # e verifica contro il CSV grezzo
    with open(PD.RAW_DEFAULT) as f:
        righe = {l.split('\t')[0]: l.rstrip('\n').split('\t') for l in f}
    o_raw = float(righe['2020.03.03'][1])
    c_raw = float(righe['2020.03.09'][4])
    es.add('T11c stesso esempio letto dal CSV grezzo: open(2020.03.03)=%s close(2020.03.09)=%s -> %.6f' % (
        righe['2020.03.03'][1], righe['2020.03.09'][4], c_raw / o_raw - 1), abs((c_raw / o_raw - 1) - r_f) < 1e-15)
    if solo_rapidi:
        return es

    # ---- T12 CAUSALITA': prefisso su >= 300 date (tolleranza 1e-9)
    rnd = random.Random(seed)
    idx_ok = [i for i, r in enumerate(d1) if r['date'] >= dt.date(2008, 7, 1)]
    scelti = sorted(rnd.sample(idx_ok, n_prefisso))
    # garantisco la presenza di venerdi', lunedi' e ultimo giorno
    extra = [i for i in idx_ok if d1[i]['date'].weekday() == 4][:3] + [i for i in idx_ok if d1[i]['date'].weekday() == 0][:3] + [len(d1) - 1]
    scelti = sorted(set(scelti) | set(extra))
    pieno = calcola_overall(d1, only=scelti)
    md = 0.0
    nn = 0
    for r in pieno:
        i = r['i']
        tr = calcola_overall(d1[:i + 1], only=[i])[0]
        for key in ('sW', 'sD', 'S'):
            a, b = r[key], tr[key]
            if (a is None) != (b is None):
                md = max(md, 1.0)
            elif a is not None:
                md = max(md, abs(a - b))
        nn += 1
    es.add('T12 CAUSALITA\' (i) prefisso: score a t su dati troncati a t identico a quello sull\'intera serie, %d date' % nn,
           md <= 1e-9 and nn >= 300, 'max |diff|=%.3e' % md)

    # ---- T13 CAUSALITA': serie sporcata (barre future = rumore) su >= 30 date
    rnd2 = random.Random(seed + 1)
    scelti2 = sorted(rnd2.sample(idx_ok, n_sporco))
    pieno2 = calcola_overall(d1, only=scelti2)
    md = 0.0
    for r in pieno2:
        i = r['i']
        sp = [dict(x) for x in d1]
        c = sp[i]['c']
        for k in range(i + 1, len(sp)):
            o = c * (1 + rnd2.gauss(0, 0.02))
            c = o * (1 + rnd2.gauss(0, 0.03))
            sp[k].update(o=o, c=c, h=max(o, c) * (1 + abs(rnd2.gauss(0, 0.01))), l=min(o, c) * (1 - abs(rnd2.gauss(0, 0.01))),
                         v=rnd2.randint(1, 10 ** 6))
        al = calcola_overall(sp, only=[i])[0]
        for key in ('sW', 'sD', 'S'):
            a, b = r[key], al[key]
            if (a is None) != (b is None):
                md = max(md, 1.0)
            elif a is not None:
                md = max(md, abs(a - b))
    es.add('T13 CAUSALITA\' (ii) serie sporcata: barre future sostituite da rumore, %d date' % len(scelti2),
           md <= 1e-9 and len(scelti2) >= 30, 'max |diff|=%.3e' % md)
    # controllo di sensibilita' del test: se invece sporco le barre PASSATE lo score cambia (il test non e' vuoto)
    i = scelti2[len(scelti2) // 2]
    sp = [dict(x) for x in d1]
    for k in range(i - 30, i + 1):
        sp[k]['c'] = sp[k]['c'] * 1.03
        sp[k]['h'] = sp[k]['h'] * 1.03
    al = calcola_overall(sp, only=[i])[0]
    pr = calcola_overall(d1, only=[i])[0]
    es.add('T13b controllo di sensibilita\': sporcare le barre PASSATE cambia lo score (il test e\' capace di fallire)',
           abs(al['sD'] - pr['sD']) > 1e-6, 'diff=%.3f' % abs(al['sD'] - pr['sD']))
    return es


if __name__ == '__main__':
    if '--autotest' in sys.argv:
        e = autotest(solo_rapidi='--rapido' in sys.argv)
        out = '\n'.join(e.righe) + '\n\nESITO COMPLESSIVO: %s\n' % ('TUTTI PASSATI' if e.ok else 'FALLITI')
        if '--rapido' not in sys.argv:
            with open(os.path.join(QUI, 'autotest_output.txt'), 'w') as f:
                f.write(out)
        print('ESITO COMPLESSIVO:', 'TUTTI PASSATI' if e.ok else 'FALLITI')
        sys.exit(0 if e.ok else 1)
    print(__doc__)
