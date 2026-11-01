"""Test di correttezza della macchina a stati dei segnali (signals.py) su dati SINTETICI.

Esecuzione:  python3 -I test_signals.py
Contenuto:
- pattern piantati CONT e INV, long e short (specchio), che DEVONO generare il segnale esatto;
- gemelli negativi (una sola differenza) che NON devono generarlo: B1, B2, B3, B5, band riding (B6), SEQ
  (mediana -> banda impulso -> banda opposta, CONT), candela impulsiva (nel ritracciamento e sul test),
  tocco troppo precoce (MIN_RETR), T_MAX, gate sd (S50 e sd[-3]), INV: mediana non toccata, banda opposta toccata,
  banda inclinata contro, retest assente;
- sensibilita (Sa, Sb, Se20, Se50) sui casi che le distinguono;
- riferimento NAIVE (cicli Python) dei criteri B1..B6 contro la versione vettoriale;
- invarianza al troncamento e alla perturbazione del futuro, simmetria rialzo/ribasso, riproducibilita;
- scansione statica: nessun numero "sparso" in signals.py.
Gli indicatori dei pattern piantati sono scritti A MANO (array), cosi' ogni condizione e' controllata direttamente.
"""
import ast
import json
import os
import sys
import unittest

sys.path.insert(0, os.path.dirname(os.path.abspath(__file__)))

import numpy as np  # noqa: E402

import engine as E  # noqa: E402
import signals as S  # noqa: E402
from params import PARAMS, parametri  # noqa: E402

N = 330
S0 = 250          # barra s (minimo dell'impulso)


# ------------------------------------------------------------------ costruzione scenari (d=+1)
def base(n=N):
    a = dict(o=np.full(n, 100.0), h=np.full(n, 100.4), l=np.full(n, 99.6), c=np.full(n, 100.0),
             M=np.full(n, 100.0), sd=np.full(n, 0.5), s50=np.full(n, 0.6), atr=np.full(n, 1.0))
    a["U"] = a["M"] + 2 * a["sd"]
    a["L"] = a["M"] - 2 * a["sd"]
    return a


def impulso(a, nb=8, sd_imp=2.0, s50_imp=None, atr_s=None, m_vicino=False):
    """Barre S0+1 .. S0+nb: +3 a barra, bullish. Ritorna l'ultima chiusura."""
    a["l"][S0] = 99.2
    if atr_s is not None:
        a["atr"][S0] = atr_s
    c = 100.0
    for k in range(1, nb + 1):
        i = S0 + k
        o, c = c, c + 3.0
        a["o"][i], a["c"][i], a["h"][i], a["l"][i] = o, c, c + 0.2, o - 0.2
        a["M"][i] = (c - 1.0) if m_vicino else 100.5 + 0.5 * k
        a["sd"][i] = sd_imp
        a["s50"][i] = (s50_imp if s50_imp is not None else 0.6 + 0.1 * k)
        a["atr"][i] = 1.5 + 0.2 * k
        a["U"][i] = a["M"][i] + 2 * sd_imp
        a["L"][i] = a["M"][i] - 2 * sd_imp
    return c


def dopo(a, i0, M=118.0, sd=1.75, s50=2.0, atr=3.0, U=121.5, L=114.5):
    for i in range(i0, len(a["o"])):
        a["M"][i], a["sd"][i], a["s50"][i], a["atr"][i], a["U"][i], a["L"][i] = M, sd, s50, atr, U, L


def barra(a, i, o, c, h=None, l=None):
    a["o"][i], a["c"][i] = o, c
    a["h"][i] = (max(o, c) + 0.05) if h is None else h
    a["l"][i] = (min(o, c) - 0.05) if l is None else l


def riempi(a, i0, prezzo):
    """Barre i0.. piatte a `prezzo` (nessun tocco di bande/mediana)."""
    for i in range(i0, len(a["o"])):
        barra(a, i, prezzo, prezzo)


def mk(a):
    n = len(a["o"])
    b = E.Barre(60, np.arange(n, dtype=np.int64) * 60, a["o"].copy(), a["h"].copy(), a["l"].copy(), a["c"].copy(),
                np.zeros(n, dtype=np.int64), np.arange(n, dtype=np.int64), np.arange(n, dtype=np.int64) + 1)
    ind = E.Indicatori(sma20=a["M"].copy(), std20=a["sd"].copy(), bb_up=a["U"].copy(), bb_lo=a["L"].copy(),
                       std20_sma50=a["s50"].copy(), atr14=a["atr"].copy())
    return b, ind


def specchio(a):
    """Specchio esatto: prezzi -> -prezzi, High<->Low, banda alta<->bassa."""
    return dict(o=-a["o"], h=-a["l"], l=-a["h"], c=-a["c"], M=-a["M"], U=-a["L"], L=-a["U"],
                sd=a["sd"].copy(), s50=a["s50"].copy(), atr=a["atr"].copy())


def scen_cont(K=10, nb=8, **imp):
    """CONT: dal picco scende linearmente a 116 (barra p+K-1) e alla barra p+K chiude a 114,3: tocca per la PRIMA
    volta la banda bassa (114,5) alla barra p+K. Poi piatto a 118,5 (sopra mediana, sotto banda alta)."""
    a = base()
    c = impulso(a, nb, **imp)
    p = S0 + nb
    dopo(a, p + 1)
    step = (c - 116.0) / (K - 1) if K > 1 else 0.0
    for k in range(1, K):
        o, c = c, c - step
        barra(a, p + k, o, c)
    barra(a, p + K, c, 114.3)
    riempi(a, p + K + 1, 118.5)
    return a


def scen_inv(dp=15, nb=8):
    """INV: scende fino a 115 (tocca la mediana 118, non la banda bassa 114,5) poi risale e ritesta la banda
    alta (121,5) alla barra p+dp."""
    a = base()
    c = impulso(a, nb)
    p = S0 + nb
    dopo(a, p + 1)
    giu = 8
    sg = (c - 115.0) / giu
    for k in range(1, giu + 1):
        o, c = c, c - sg
        barra(a, p + k, o, c)
    su = dp - giu
    ss = (121.5 - c) / su
    for k in range(1, su + 1):
        o, c = c, c + ss
        barra(a, p + giu + k, o, c)
    riempi(a, p + dp + 1, 121.5)
    return a


def segnali(a, var, prm=None):
    b, ind = mk(a)
    return S.rileva(b, ind, var, prm or PARAMS)


def js(r):
    return [(s["j"], s["side"]) for s in r["segnali"]]


P = S0 + 8        # picco dello scenario base


class TestPianificati(unittest.TestCase):
    def test_cont_long_piantato(self):
        r = segnali(scen_cont(10), "CONT")
        self.assertEqual(js(r), [(P + 10, +1)])
        s = r["segnali"][0]
        self.assertEqual((s["s"], s["p"], s["dp"], s["d"]), (S0, P, 10, 1))
        self.assertEqual(s["n_prev"], 0)
        self.assertAlmostEqual(s["livello_banda"], 114.5)
        self.assertEqual(s["contatto"], "corpo/violazione")      # chiusura 114,3 <= banda 114,5
        self.assertEqual(r["imbuto_episodi"]["conteggi"], [1] * 9)          # l'episodio supera tutti gli stadi
        self.assertEqual(r["armati"], {"+1": 1, "-1": 0})
        # lo stesso percorso non e' una INVERSIONE (banda opposta toccata e nessun retest)
        self.assertEqual(js(segnali(scen_cont(10), "INV")), [])

    def test_cont_short_specchio(self):
        r = segnali(specchio(scen_cont(10)), "CONT")
        self.assertEqual(js(r), [(P + 10, -1)])
        s = r["segnali"][0]
        self.assertEqual(s["d"], -1)
        self.assertAlmostEqual(s["livello_banda"], -114.5)          # prezzi specchiati

    def test_inv_short_piantato(self):
        r = segnali(scen_inv(15), "INV")
        self.assertEqual(js(r), [(P + 15, -1)])
        s = r["segnali"][0]
        self.assertAlmostEqual(s["livello_banda"], 121.5)
        self.assertEqual(r["imbuto_episodi"]["conteggi"], [1] * 10)
        # nessuna banda opposta toccata: la CONTINUAZIONE non scatta
        self.assertEqual(js(segnali(scen_inv(15), "CONT")), [])

    def test_inv_long_specchio(self):
        r = segnali(specchio(scen_inv(15)), "INV")
        self.assertEqual(js(r), [(P + 15, +1)])
        self.assertEqual(r["segnali"][0]["d"], -1)

    def test_specchio_identico_nei_descrittori(self):
        for sc, var in ((scen_cont(10), "CONT"), (scen_inv(15), "INV")):
            r1 = segnali(sc, var)["segnali"][0]
            r2 = segnali(specchio(sc), var)["segnali"][0]
            for k in ("j", "s", "p", "dp", "n_prev", "solidita", "fascia", "congestione", "bonus", "ora",
                      "z_test", "zmax_ritracciamento", "rientro_quota_abc", "invalidazioni_A2", "contatto"):
                self.assertEqual(r1[k], r2[k], k)
            self.assertEqual(r1["side"], -r2["side"])
            self.assertAlmostEqual(r1["livello_banda"], -r2["livello_banda"])

    # ---------------- gemelli negativi del bulge
    def test_gemelli_bulge_B1_B2_B3_B5(self):
        casi = {
            "B1_bande_poco_aperte": dict(sd_imp=0.9),
            "B2_sd_non_sopra_S50": dict(s50_imp=2.1),
            "B3_nessuna_candela_impulsiva": dict(atr_s=3.0),
            "B5_mediana_vicina": dict(m_vicino=True),
        }
        for nome, kw in casi.items():
            for var, mk_ in (("CONT", lambda k: scen_cont(10, **k)), ):
                r = segnali(mk_(kw), var)
                self.assertEqual(js(r), [], nome)
                self.assertEqual(r["armati"], {"+1": 0, "-1": 0}, nome)
        # lo stesso vale per l'INV
        a = base()
        c = impulso(a, 8, sd_imp=0.9)
        self.assertEqual(segnali(a, "INV")["armati"], {"+1": 0, "-1": 0})

    def test_band_riding_disarma(self):
        # impulso di 25 barre: p - s > 20 -> bulge disarmata ("band riding"), nessun segnale
        a = scen_cont(10, nb=25)
        r = segnali(a, "CONT")
        self.assertEqual(js(r), [])
        self.assertEqual(r["fine_episodi"].get("BAND_RIDING"), 1)

    # ---------------- CONT: gemelli
    def test_cont_sequenza_mediana_banda_impulso_scartata(self):
        a = base()
        c = impulso(a, 8)
        dopo(a, P + 1)
        pr = [123.0, 122.0, 121.0, 120.0, 119.0, 118.0,          # 259-264: giu' fino alla mediana (118)
              119.5, 121.0, 122.5,                               # 265-267: risale e TOCCA la banda dell'impulso
              121.0, 119.5, 118.0, 116.5, 114.3]                 # 268-272: poi scende alla banda opposta
        o = c
        for k, cc in enumerate(pr, 1):
            barra(a, P + k, o, cc)
            o = cc
        a["h"][P + 9] = 122.55                                   # 267: High >= U (121,5)
        riempi(a, P + 15, 118.5)
        r = segnali(a, "CONT")
        self.assertEqual(js(r), [], "mediana -> banda impulso -> banda opposta DEVE essere scartata in CONT")
        e = r["extra"]
        self.assertEqual(e["episodi_seq_violata_su_barra_di_tocco"], 1)
        self.assertEqual(e["episodi_eliminati_solo_da_SEQ"], 1)
        cont = r["imbuto_episodi"]["conteggi"]
        self.assertEqual(cont[2], 1)       # tocco banda opposta raggiunto
        self.assertEqual(cont[3], 0)       # morto per SEQ
        # senza il rimbalzo sulla banda dell'impulso (gemello) il segnale esiste
        b2 = base()
        c = impulso(b2, 8)
        dopo(b2, P + 1)
        pr2 = [123.0, 122.0, 121.0, 120.0, 119.0, 118.0, 117.2, 116.4, 115.6, 114.3]
        o = c
        for k, cc in enumerate(pr2, 1):
            barra(b2, P + k, o, cc)
            o = cc
        riempi(b2, P + 11, 118.5)
        self.assertEqual(js(segnali(b2, "CONT")), [(P + 10, 1)])

    def test_cont_ritorno_alla_banda_senza_mediana_non_e_seq(self):
        # banda dell'impulso toccata PRIMA della mediana: non e' SEQ (regola stretta), ma e' contata a parte
        r = segnali(scen_cont(10), "CONT")
        self.assertEqual(len(r["segnali"]), 1)
        self.assertEqual(r["extra"]["episodi_ritorno_banda_senza_mediana_su_barra_di_tocco"], 1)

    def test_cont_candela_impulsiva(self):
        a = scen_cont(10)
        a["l"][P + 4] = a["c"][P + 4] - 5.0                                          # range ~5,1 / ATR 3 = 1,7 > 1,5
        r = segnali(a, "CONT")
        self.assertEqual(js(r), [])
        self.assertEqual(r["imbuto_episodi"]["conteggi"][4:], [0] * 5)              # muore a C1a
        # candela del TEST impulsiva
        a = scen_cont(10)
        a["l"][P + 10] = a["c"][P + 10] - 5.0                                        # range ~5,1 / 3 = 1,7
        r = segnali(a, "CONT")
        self.assertEqual(js(r), [])
        self.assertEqual(r["imbuto_episodi"]["conteggi"][4], 1)                      # C1a ok
        self.assertEqual(r["imbuto_episodi"]["conteggi"][5], 0)                      # C1b no

    def test_cont_tocco_precoce_consuma(self):
        a = scen_cont(10)
        a["l"][P + 2] = 114.0            # tocco della banda opposta a tau - p = 2 < MIN_RETR
        r = segnali(a, "CONT")
        self.assertEqual(js(r), [])
        self.assertEqual(r["extra"]["episodi_consumati_tocco_precoce"], 1)
        # il confine: K=3 e' valido, K=2 e' un tocco precoce
        self.assertEqual(js(segnali(scen_cont(3), "CONT")), [(P + 3, 1)])
        self.assertEqual(js(segnali(scen_cont(2), "CONT")), [])

    def test_cont_t_max_e_sensibilita_Se(self):
        self.assertEqual(js(segnali(scen_cont(30), "CONT")), [(P + 30, 1)])        # T_MAX incluso
        r31 = segnali(scen_cont(31), "CONT")
        self.assertEqual(js(r31), [])
        self.assertEqual(r31["fine_episodi"].get("T_MAX"), 1)
        # Se20: T_MAX=20 -> K=25 non vale; Se50: T_MAX=50 -> K=40 vale
        self.assertEqual(js(segnali(scen_cont(25), "CONT", )), [(P + 25, 1)])
        self.assertEqual(js(segnali(scen_cont(25), "CONT", parametri(T_MAX=20))), [])
        self.assertEqual(js(segnali(scen_cont(40), "CONT")), [])
        self.assertEqual(js(segnali(scen_cont(40), "CONT", parametri(T_MAX=50))), [(P + 40, 1)])

    def test_cont_gate_sd(self):
        a = scen_cont(10)
        a["s50"][P + 1:] = 1.7               # sd (1,75) >= S50 -> gate sd<S50 fallisce
        self.assertEqual(js(segnali(a, "CONT")), [])
        self.assertEqual(js(segnali(a, "CONT", parametri(SD_GATE_S50=False))), [(P + 10, 1)])      # Sa
        b = scen_cont(10)
        b["s50"][P + 1:] = 5.0
        for i in range(P + 1, N):
            b["sd"][i] = 1.0 + 0.05 * (i - P)            # sd in salita: sd > sd[-3]
        self.assertEqual(js(segnali(b, "CONT")), [])
        self.assertEqual(js(segnali(b, "CONT", parametri(SD_GATE_S50=False))), [])                 # Sa non salva sd[-3]

    # ---------------- INV: gemelli
    def test_inv_gemelli(self):
        # a) mediana non toccata
        a = base()
        c = impulso(a, 8)
        dopo(a, P + 1)
        o = c
        for k, cc in enumerate([123.0, 122.0, 121.5, 121.0, 120.5, 120.0, 119.5, 119.4], 1):   # minimo 119.4 > M=118
            barra(a, P + k, o, cc)
            o = cc
        ss = (121.5 - o) / 7
        for k in range(1, 8):
            barra(a, P + 8 + k, o, o + ss)
            o += ss
        riempi(a, P + 16, 121.5)
        r = segnali(a, "INV")
        self.assertEqual(js(r), [])
        self.assertEqual(r["imbuto_episodi"]["conteggi"][2], 0)          # I0 mai raggiunto
        # b) banda opposta toccata dopo la mediana
        a = scen_inv(15)
        a["l"][P + 7] = 114.0
        r = segnali(a, "INV")
        self.assertEqual(js(r), [])
        self.assertEqual(r["imbuto_episodi"]["conteggi"][2], 1)          # I0 si'
        self.assertEqual(r["imbuto_episodi"]["conteggi"][3], 0)          # I1 no
        # c) banda dell'impulso inclinata contro (U sale piu' di 0,10 ATR in 3 barre)
        a = scen_inv(15)
        tau = P + 15
        for i in range(tau - 6, N):
            a["U"][i] = 121.5 + 0.2 * (i - tau)        # banda in salita di 0,6 su 3 barre (> 0,10 * ATR = 0,3)
        r = segnali(a, "INV")
        self.assertEqual(js(r), [])
        self.assertEqual(r["imbuto_episodi"]["conteggi"][5], 1)          # I2 ok
        self.assertEqual(r["imbuto_episodi"]["conteggi"][6], 0)          # I3 no
        # d) candela impulsiva nel rientro
        a = scen_inv(15)
        a["l"][P + 4] = a["c"][P + 4] - 5.0
        self.assertEqual(js(segnali(a, "INV")), [])
        # e) gate sd
        a = scen_inv(15)
        a["s50"][P + 1:] = 1.7
        self.assertEqual(js(segnali(a, "INV")), [])
        self.assertEqual(js(segnali(a, "INV", parametri(SD_GATE_S50=False))), [(tau, -1)])     # Sa
        # f) retest assente (High < banda)
        a = scen_inv(15)
        a["U"][P + 9:] = 123.0
        self.assertEqual(js(segnali(a, "INV")), [])

    def test_sensibilita_Sb_impulsiva_1_0(self):
        # una barra con z = 1,2 (tra 1,0 e 1,5): CONT e INV base la accettano, INV con Sb la rifiuta
        a = scen_inv(15)
        a["l"][P + 3] = a["c"][P + 3] - 2.5          # range ~3,7 / ATR 3 = 1,2
        self.assertEqual(js(segnali(a, "INV")), [(P + 15, -1)])
        self.assertEqual(js(segnali(a, "INV", parametri(IMPULSIVA_ATR_INV=1.0))), [])
        # CONT non usa la chiave INV
        a = scen_cont(10)
        a["l"][P + 3] = a["c"][P + 3] - 2.5
        self.assertEqual(js(segnali(a, "CONT", parametri(IMPULSIVA_ATR_INV=1.0))), [(P + 10, 1)])

    def test_sensibilita_Sf_penetrazione(self):
        # il test tocca la banda per 0,05; con spread di barra 0,10 (> penetrazione) Sf lo scarta
        a = scen_cont(10)
        b, ind = mk(a)
        pen = float(ind.bb_lo[P + 10] - b.l[P + 10])
        self.assertGreater(pen, 0)
        sp = np.full(N, pen * 2.0)
        r = S.rileva(b, ind, "CONT", parametri(TOCCO_PEN_SPREAD=1.0), sp_bar=sp)
        self.assertEqual(js(r), [])
        sp = np.full(N, pen / 2.0)
        r = S.rileva(b, ind, "CONT", parametri(TOCCO_PEN_SPREAD=1.0), sp_bar=sp)
        self.assertEqual(js(r), [(P + 10, 1)])
        with self.assertRaises(ValueError):
            S.rileva(b, ind, "CONT", parametri(TOCCO_PEN_SPREAD=1.0))

    def test_warmup_e_un_segnale_per_episodio(self):
        # stesso pattern ma 100 barre prima: dentro il warm-up (200) -> nessun segnale
        a = scen_cont(10)
        sh = 100
        for k in a:
            a[k] = np.concatenate((a[k][sh:], np.repeat(a[k][-1], sh)))
        # (traslando indietro, l'impulso cade a barra 150 < WARMUP)
        self.assertEqual(js(segnali(a, "CONT")), [])
        # un solo segnale per episodio: anche se dopo il tocco ce ne sono altri
        a = scen_cont(10)
        for i in range(P + 11, P + 14):
            barra(a, i, 114.3, 114.2)
        self.assertEqual(len(segnali(a, "CONT")["segnali"]), 1)

    def test_n_prev_e_descrittori(self):
        r = segnali(scen_cont(10), "CONT")
        s = r["segnali"][0]
        for k in ("solidita", "fascia", "congestione", "bonus", "invalidazioni_A2", "checklist_stretta", "ora",
                  "n_prev_classe", "rientro_quota_abc", "contatto", "barre_gt_3atr_bulge"):
            self.assertIn(k, s)
        self.assertGreaterEqual(s["solidita"], 25.0)       # bulge sempre pieno
        self.assertLessEqual(s["solidita"], 100.0)
        json.dumps(r, default=str)                         # serializzabile


# ------------------------------------------------------------------ riferimento naive B1..B6
def serie_random(n=6000, seed=3):
    rng = np.random.default_rng(seed)
    sig = np.empty(n)
    v = 1.0
    for i in range(n):
        v = 0.05 + 0.1 * (sig[i - 1] ** 2 if i else 1.0) + 0.85 * v
        sig[i] = np.sqrt(v)
    r = rng.normal(0, 1, n) * sig
    c = 2000 + np.cumsum(r)
    o = np.concatenate(([c[0]], c[:-1]))
    h = np.maximum(o, c) + np.abs(rng.normal(0, 0.4, n)) * sig
    l = np.minimum(o, c) - np.abs(rng.normal(0, 0.4, n)) * sig
    return E.Barre(60, np.arange(n, dtype=np.int64) * 60, o, h, l, c, np.zeros(n, dtype=np.int64),
                   np.arange(n, dtype=np.int64), np.arange(n, dtype=np.int64) + 1)


RILASSATO = dict(B1_W=1.3, B4_ER=0.3, B5_ATR=1.0, B3_ATR=1.0, IMPULSIVA_ATR=2.5, SD_GATE_S50=False,
                 BANDA_TOL_ATR=2.0)


def ref_B(b, ind, d, t, prm):
    w = prm["WIN_IMPULSO"]
    chiave = [(b.l[i] if d == 1 else -b.h[i]) for i in range(t - w + 1, t + 1)]
    s = t - w + 1 + chiave.index(min(chiave))
    W = ind.bb_up - ind.bb_lo
    ref = prm["REF_BARRE"]
    wref = float(np.median(W[s - ref + 1:s + 1]))
    r1 = W[t] >= prm["B1_W"] * wref
    r2 = ind.std20[t] > ind.std20_sma50[t]
    r3 = any((b.h[u] - b.l[u]) >= prm["B3_ATR"] * ind.atr14[s] and d * (b.c[u] - b.o[u]) > 0 for u in range(s + 1, t + 1))
    path = sum(abs(b.c[i] - b.c[i - 1]) for i in range(s + 1, t + 1))
    er = abs(b.c[t] - b.c[s]) / path if path > 0 else 0.0
    r4 = path > 0 and er >= prm["B4_ER"] and d * (b.c[t] - b.c[s]) > 0
    r5 = d * (b.c[t] - ind.sma20[t]) >= prm["B5_ATR"] * ind.atr14[s]
    r6 = t - s <= prm["B6_BARRE"]
    return [bool(x) for x in (r1, r2, r3, r4, r5, r6)]


class TestRiferimentoNaive(unittest.TestCase):
    def test_criteri_B_vettoriali_uguali_al_riferimento_naive(self):
        for prm in (PARAMS, parametri(**RILASSATO)):
            b = serie_random()
            ind = E.indicatori(b)
            ctx = S._Ctx(b, ind, prm, None)
            tot = np.zeros(6, dtype=int)
            for d in (1, -1):
                for t in range(prm["WARMUP"], b.n):
                    if not ctx.valid[t]:
                        continue
                    ref = ref_B(b, ind, d, t, prm)
                    got = [bool(ctx.arm[d]["b"][k][t]) for k in range(6)]
                    self.assertEqual(ref, got, f"d={d} t={t}")
                    tot += np.array(ref, dtype=int)
            self.assertTrue(np.all(tot > 20), f"criteri mai veri: {tot}")


# ------------------------------------------------------------------ proprieta
def firma(r):
    return json.dumps([{k: v for k, v in s.items()} for s in r["segnali"]], sort_keys=True, default=str)


class TestProprieta(unittest.TestCase):
    @classmethod
    def setUpClass(cls):
        cls.prm = parametri(**RILASSATO)
        cls.b = serie_random(16000, seed=11)
        cls.ind = E.indicatori(cls.b)
        cls.full = {v: S.rileva(cls.b, cls.ind, v, cls.prm) for v in S.VARIANTI}

    def test_ci_sono_segnali(self):
        self.assertGreaterEqual(len(self.full["CONT"]["segnali"]), 10)
        self.assertGreaterEqual(len(self.full["INV"]["segnali"]), 4)
        for v in S.VARIANTI:
            self.assertTrue(any(s["side"] == 1 for s in self.full[v]["segnali"]) and
                            any(s["side"] == -1 for s in self.full[v]["segnali"]), v)

    def _sub(self, b, k):
        n = k + 1
        return E.Barre(b.periodo, b.t[:n], b.o[:n], b.h[:n], b.l[:n], b.c[:n], b.tv[:n], b.i0[:n], b.i1[:n])

    def test_invarianza_al_troncamento_del_futuro(self):
        for var in S.VARIANTI:
            full = self.full[var]["segnali"]
            scelti = full[:: max(1, len(full) // 4)][:4]
            cuts = sorted(set([x["j"] + dk for x in scelti for dk in (-1, 0, 1)]))
            cuts = [k for k in cuts if 250 < k < self.b.n - 1]
            self.assertGreater(len(cuts), 6)
            for k in cuts:
                bt = self._sub(self.b, k)
                it = E.indicatori(bt)
                tr = S.rileva(bt, it, var, self.prm)["segnali"]
                atteso = [s for s in full if s["j"] <= k]
                self.assertEqual(json.dumps(tr, sort_keys=True, default=str),
                                 json.dumps(atteso, sort_keys=True, default=str), f"{var} k={k}")

    def test_perturbazione_del_futuro(self):
        rng = np.random.default_rng(5)
        for var in S.VARIANTI:
            full = self.full[var]["segnali"]
            for s in full[:: max(1, len(full) // 5)]:
                k = s["j"]
                b2 = E.Barre(self.b.periodo, self.b.t, self.b.o.copy(), self.b.h.copy(), self.b.l.copy(),
                             self.b.c.copy(), self.b.tv, self.b.i0, self.b.i1)
                m = b2.n - k - 1
                b2.c[k + 1:] += rng.normal(0, 30, m).cumsum()
                b2.o[k + 1:] = b2.c[k + 1:] - 1.0
                b2.h[k + 1:] = b2.c[k + 1:] + 5.0
                b2.l[k + 1:] = b2.c[k + 1:] - 5.0
                i2 = E.indicatori(b2)
                r2 = S.rileva(b2, i2, var, self.prm)["segnali"]
                self.assertEqual(json.dumps([x for x in r2 if x["j"] <= k], sort_keys=True, default=str),
                                 json.dumps([x for x in full if x["j"] <= k], sort_keys=True, default=str))

    def test_simmetria_rialzo_ribasso_su_dati_casuali(self):
        b = self.b
        bm = E.Barre(b.periodo, b.t, -b.o, -b.l, -b.h, -b.c, b.tv, b.i0, b.i1)
        im = E.indicatori(bm)
        for var in S.VARIANTI:
            r1 = self.full[var]["segnali"]
            r2 = S.rileva(bm, im, var, self.prm)["segnali"]
            self.assertEqual([s["j"] for s in r1], [s["j"] for s in r2])
            self.assertEqual([s["side"] for s in r1], [-s["side"] for s in r2])
            for x, y in zip(r1, r2):
                for k in ("s", "p", "dp", "n_prev", "solidita", "fascia", "congestione", "bonus", "z_test",
                          "rientro_quota_abc", "invalidazioni_A2", "checklist_stretta", "contatto"):
                    self.assertEqual(x[k], y[k], f"{var} j={x['j']} {k}")
            e1 = self.full[var]["imbuto_episodi"]
            e2 = S.rileva(bm, im, var, self.prm)["imbuto_episodi"]
            self.assertEqual(e1["conteggi"], e2["conteggi"])

    def test_riproducibilita(self):
        for var in S.VARIANTI:
            r2 = S.rileva(self.b, self.ind, var, self.prm)
            self.assertEqual(json.dumps(r2, sort_keys=True, default=str),
                             json.dumps(self.full[var], sort_keys=True, default=str))

    def test_imbuto_riconciliato(self):
        for var in S.VARIANTI:
            r = self.full[var]
            c = r["imbuto_episodi"]["conteggi"]
            self.assertEqual(c[0], r["armati"]["+1"] + r["armati"]["-1"])
            self.assertEqual(c[-1], len(r["segnali"]))
            self.assertTrue(all(x >= y for x, y in zip(c, c[1:])), "stadi cumulativi non monotoni")
            self.assertEqual(sum(r["fine_episodi"].values()), c[0])
            # ogni episodio che si ferma allo stadio k e' contato in 'morti'
            morti = sum(sum(v.values()) for v in r["imbuto_episodi"]["morti"].values())
            self.assertEqual(morti, c[0] - c[-1])
            for d in ("1", "-1"):
                cum = list(r["imbuto_barre"][d]["cumulativi"].values())
                self.assertTrue(all(x >= y for x, y in zip(cum, cum[1:])))
            self.assertEqual(len(set(s["episodio"] for s in r["segnali"])), len(r["segnali"]))

    def test_signal_fn_per_A7(self):
        b = self.b
        bars = dict(time=b.t, open=b.o, high=b.h, low=b.l, close=b.c)
        import signals as S2
        fn = S2.signal_fn_factory("CONT", 60, self.prm)
        out = fn(bars)
        sig = out["signal"]
        self.assertEqual(sig.shape[0], b.n)
        self.assertEqual([int(j) for j in np.flatnonzero(sig)], [s["j"] for s in self.full["CONT"]["segnali"]])


class TestNessunNumeroSparso(unittest.TestCase):
    def test_signals_py_senza_soglie_nel_codice(self):
        permessi = {0, 1, 2, 0.5, 6, 24, 60}      # 0/1/2: strutturali; 0.5: meta' del range; 6: criteri B; 24/60: ora
        t = ast.parse(open(os.path.join(os.path.dirname(os.path.abspath(__file__)), "signals.py")).read())
        doc = set()
        for n in ast.walk(t):
            if isinstance(n, (ast.Module, ast.FunctionDef, ast.ClassDef)) and n.body and \
                    isinstance(n.body[0], ast.Expr) and isinstance(n.body[0].value, ast.Constant):
                doc.add(id(n.body[0].value))
        trovati = {n.value for n in ast.walk(t) if isinstance(n, ast.Constant) and
                   isinstance(n.value, (int, float)) and not isinstance(n.value, bool) and id(n) not in doc}
        self.assertTrue(trovati <= permessi, f"numeri sparsi in signals.py: {sorted(trovati - permessi)}")

    def test_params_contiene_la_tabella_sez9(self):
        for k, v in (("BB_N", 20), ("S50_N", 50), ("ATR_N", 14), ("WARMUP", 200), ("WIN_IMPULSO", 20), ("REF_BARRE", 15),
                     ("B1_W", 2.0), ("B3_ATR", 1.5), ("B4_ER", 0.5), ("B5_ATR", 2.0), ("B6_BARRE", 20),
                     ("MIN_RETR", 3), ("T_MAX", 30), ("IMPULSIVA_ATR", 1.5), ("BANDA_TOL_ATR", 0.1), ("STOP_ATR", 3.0),
                     ("MAXHOLD", 1000), ("MAX_GAP_INGRESSO_MIN", 180), ("RICALCOLO_ORE", 3)):
            self.assertEqual(PARAMS[k], v, k)


if __name__ == "__main__":
    unittest.main(verbosity=2)
