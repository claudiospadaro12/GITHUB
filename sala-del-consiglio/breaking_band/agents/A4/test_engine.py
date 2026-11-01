"""Test di correttezza del motore (engine.py) su dati SINTETICI costruiti a mano.

Esecuzione:  python3 -I test_engine.py
(con -I la cartella dello script non e nel path: la aggiungiamo esplicitamente, e' codice nostro.)
"""
import math
import os
import statistics
import sys
import tempfile
import unittest

sys.path.insert(0, os.path.dirname(os.path.abspath(__file__)))

import numpy as np  # noqa: E402

import engine as E  # noqa: E402

T0 = 60 * 1_000_000   # minuto di partenza, multiplo di 60 e di 15
SP = 30               # spread di base: 30 punti = 0,30 USD
P = 2000.0


def flat_m1(nbars, price=P, sp=SP, per=60, t0=T0):
    """nbars barre complete da `per` minuti, prezzo piatto, spread costante."""
    n = nbars * per
    t = t0 + np.arange(n)
    a = np.full(n, price)
    return E.costruisci_m1(t, a.copy(), a.copy(), a.copy(), a.copy(), np.full(n, float(sp)))


def set_min(m1, bar, minute, o=None, h=None, l=None, c=None, sp=None, per=60):
    i = bar * per + minute
    if o is not None: m1.o[i] = o
    if h is not None: m1.h[i] = h
    if l is not None: m1.l[i] = l
    if c is not None: m1.c[i] = c
    if sp is not None: m1.sp[i] = sp
    m1.h[i] = max(m1.h[i], m1.o[i], m1.c[i])
    m1.l[i] = min(m1.l[i], m1.o[i], m1.c[i])


def ind_manuale(nb, j_atr, sma=None, atr=2.0):
    """Indicatori scritti a mano (indipendenti dal calcolo): atr dichiarato in j_atr, sma20 da dict."""
    a = np.full(nb, np.nan)
    s = np.full(nb, np.nan)
    a[j_atr] = atr
    for k, v in (sma or {}).items():
        s[k] = v
    z = np.full(nb, np.nan)
    return E.Indicatori(sma20=s, std20=z, bb_up=z, bb_lo=z, std20_sma50=z, atr14=a)


def setup(nbars=12, price=P):
    m1 = flat_m1(nbars, price)
    return m1, E.costruisci_barre(m1, 60)


class TestCarica(unittest.TestCase):
    def test_carica_csv(self):
        righe = [
            "time;open;high;low;close;tickvol;spread",
            "2013.01.01 23:05;1673.25;1673.25;1672.84;1673.13;42;72",
            "2013.01.01 23:06;1673.05;1673.55;1672.97;1673.55;34;93",
            "2013.01.01 23:06;9;9;9;9;1;1",          # duplicato -> rimosso (si tiene il primo)
            "2013.01.01 23:07;rotto;1;1;1;1;1",      # malformata -> scartata
            "2013.01.01 23:08;1673.5;1673.6;1673.4;1673.5;10;50",
        ]
        with tempfile.TemporaryDirectory() as d:
            p = os.path.join(d, "x.csv")
            with open(p, "w") as f:
                f.write("\n".join(righe) + "\n")
            m = E.carica(p)
        self.assertEqual(m.n, 3)
        self.assertEqual(m.info["righe_scartate_formato"], 1)
        self.assertEqual(m.info["duplicati_rimossi"], 1)
        self.assertEqual(float(m.sp[0]), 72.0)           # spread in punti
        self.assertAlmostEqual(float(m.c[1]), 1673.55)
        self.assertEqual(int(m.t[1] - m.t[0]), 1)        # minuti
        self.assertEqual(int(m.t[2] - m.t[1]), 2)

    def test_intestazione_errata(self):
        with tempfile.TemporaryDirectory() as d:
            p = os.path.join(d, "x.csv")
            with open(p, "w") as f:
                f.write("a;b\n1;2\n")
            with self.assertRaises(ValueError):
                E.carica(p)


class TestBarre(unittest.TestCase):
    def test_aggregazione_e_buchi(self):
        # barra A (min 0..59): 3 M1 solo; poi buco; barra B (60..119): 2 M1
        t = [T0 + 0, T0 + 1, T0 + 5, T0 + 61, T0 + 62]
        o = [10, 11, 12, 20, 21]
        h = [12, 15, 13, 25, 22]
        l = [9, 10, 8, 19, 18]
        c = [11, 12, 9, 21, 20]
        m = E.costruisci_m1(t, o, h, l, c, [10] * 5, tv=[1, 2, 3, 4, 5])
        b = E.costruisci_barre(m, 60)
        self.assertEqual(b.n, 2)
        self.assertEqual((b.o[0], b.h[0], b.l[0], b.c[0]), (10, 15, 8, 9))
        self.assertEqual((b.o[1], b.h[1], b.l[1], b.c[1]), (20, 25, 18, 20))
        self.assertEqual(list(b.i0), [0, 3])
        self.assertEqual(list(b.i1), [3, 5])
        self.assertEqual(list(b.tv), [6, 9])
        self.assertEqual(list(b.t), [T0, T0 + 60])

    def test_m15(self):
        m = flat_m1(2)
        b = E.costruisci_barre(m, 15)
        self.assertEqual(b.n, 8)
        self.assertTrue(np.all(b.i1 - b.i0 == 15))


class TestIndicatori(unittest.TestCase):
    def setUp(self):
        rng = np.random.default_rng(7)
        n = 200
        c = 2000 + np.cumsum(rng.normal(0, 1.5, n))
        o = np.concatenate(([c[0]], c[:-1]))
        h = np.maximum(o, c) + rng.uniform(0, 1, n)
        l = np.minimum(o, c) - rng.uniform(0, 1, n)
        self.b = E.Barre(periodo=60, t=T0 + 60 * np.arange(n), o=o, h=h, l=l, c=c,
                         tv=np.zeros(n, dtype=np.int64), i0=np.arange(n), i1=np.arange(n) + 1)

    def test_bollinger_vs_riferimento_python(self):
        ind = E.indicatori(self.b)
        c = list(self.b.c)
        for i in (19, 20, 57, 150, 199):
            w = c[i - 19:i + 1]
            self.assertAlmostEqual(ind.sma20[i], statistics.fmean(w), places=9)
            self.assertAlmostEqual(ind.std20[i], statistics.pstdev(w), places=9)   # popolazione
            self.assertAlmostEqual(ind.bb_up[i], statistics.fmean(w) + 2 * statistics.pstdev(w), places=9)
            self.assertAlmostEqual(ind.bb_lo[i], statistics.fmean(w) - 2 * statistics.pstdev(w), places=9)
        self.assertTrue(np.isnan(ind.sma20[18]) and not np.isnan(ind.sma20[19]))
        # SMA50 della std20: primo valido a 19+49 = 68
        self.assertTrue(np.isnan(ind.std20_sma50[67]) and not np.isnan(ind.std20_sma50[68]))
        sd = [statistics.pstdev(c[k - 19:k + 1]) for k in range(19, 200)]
        for i in (68, 120, 199):
            ref = statistics.fmean(sd[i - 19 - 49:i - 19 + 1])
            self.assertAlmostEqual(ind.std20_sma50[i], ref, places=9)

    def test_atr_wilder_a_mano(self):
        # 6 barre, n=3: TR = [1(h-l), 2, 4, 3, 5, 1]
        h = np.array([11.0, 12.0, 14.0, 13.0, 15.0, 11.0])
        l = np.array([10.0, 10.0, 10.0, 10.0, 10.0, 10.0])
        c = np.array([10.5, 10.0, 12.0, 10.0, 11.0, 10.5])
        n = 6
        b = E.Barre(60, T0 + 60 * np.arange(n), c.copy(), h, l, c, np.zeros(n, dtype=np.int64),
                    np.arange(n), np.arange(n) + 1)
        tr = E.true_range(b)
        # TR[1] = max(12-10, |12-10.5|, |10-10.5|) = 2 ; TR[2]= max(4, |14-10|, |10-10|) = 4 ;
        # TR[3] = max(3, |13-12|, |10-12|) = 3 ; TR[4] = max(5, |15-10|, 1) = 5 ; TR[5] = max(1, 0, 0)=1
        self.assertEqual(list(tr), [1.0, 2.0, 4.0, 3.0, 5.0, 1.0])
        a = E.atr(b, 3, "wilder")
        self.assertTrue(np.all(np.isnan(a[:3])))
        self.assertAlmostEqual(a[3], (2 + 4 + 3) / 3)                 # seme = media TR[1..3]
        self.assertAlmostEqual(a[4], (a[3] * 2 + 5) / 3)
        self.assertAlmostEqual(a[5], (a[4] * 2 + 1) / 3)
        s = E.atr(b, 3, "semplice")
        self.assertAlmostEqual(s[3], 3.0)
        self.assertAlmostEqual(s[4], (4 + 3 + 5) / 3)
        self.assertAlmostEqual(s[5], (3 + 5 + 1) / 3)

    def test_nessun_look_ahead_troncando_il_futuro(self):
        """Gli indicatori all'indice i devono essere identici se si TAGLIA o si CAMBIA il futuro."""
        rng = np.random.default_rng(11)
        n = 60 * 24 * 12   # 12 giorni di M1
        c = 2000 + np.cumsum(rng.normal(0, 0.3, n))
        o = np.concatenate(([c[0]], c[:-1]))
        h = np.maximum(o, c) + rng.uniform(0, 0.3, n)
        l = np.minimum(o, c) - rng.uniform(0, 0.3, n)
        m = E.costruisci_m1(T0 + np.arange(n), o, h, l, c, np.full(n, 30.0))
        for per in (60, 15):
            for metodo in ("wilder", "semplice"):
                b = E.costruisci_barre(m, per)
                ind = E.indicatori(b, atr_metodo=metodo)
                for i in (100, 150, 200):
                    if i >= b.n - 5:
                        continue
                    fine = int(b.i1[i])
                    # (a) troncamento del futuro a fine barra i
                    m2 = E.costruisci_m1(m.t[:fine], m.o[:fine], m.h[:fine], m.l[:fine], m.c[:fine], m.sp[:fine])
                    b2 = E.costruisci_barre(m2, per)
                    ind2 = E.indicatori(b2, atr_metodo=metodo)
                    self.assertEqual(b2.n, i + 1)
                    for nome in ("sma20", "std20", "bb_up", "bb_lo", "std20_sma50", "atr14"):
                        a1 = getattr(ind, nome)[:i + 1]
                        a2 = getattr(ind2, nome)
                        self.assertTrue(np.array_equal(a1, a2, equal_nan=True), f"{nome} per={per} {metodo} i={i}")
                    # (b) futuro rimpiazzato da rumore: gli indicatori fino a i non cambiano
                    m3 = E.costruisci_m1(m.t, m.o.copy(), m.h.copy(), m.l.copy(), m.c.copy(), m.sp)
                    m3.c[fine:] += 50.0; m3.h[fine:] += 80.0; m3.o[fine:] -= 40.0; m3.l[fine:] -= 90.0
                    ind3 = E.indicatori(E.costruisci_barre(m3, per), atr_metodo=metodo)
                    for nome in ("sma20", "std20", "bb_up", "bb_lo", "std20_sma50", "atr14"):
                        self.assertTrue(np.array_equal(getattr(ind, nome)[:i + 1],
                                                       getattr(ind3, nome)[:i + 1], equal_nan=True))
                    # (c) il valore in i differisce se si cambia il PASSATO (il test non e' vacuo)
                    m4 = E.costruisci_m1(m.t, m.o.copy(), m.h.copy(), m.l.copy(), m.c.copy(), m.sp)
                    m4.c[int(b.i0[i]):fine] += 10.0
                    ind4 = E.indicatori(E.costruisci_barre(m4, per), atr_metodo=metodo)
                    self.assertNotEqual(ind4.sma20[i], ind.sma20[i])


class TestSimulazione(unittest.TestCase):
    def test_ingresso_alla_barra_dopo_con_spread(self):
        m, b = setup(12)
        # la barra 4 apre a 2001 (la chiusura della barra 3 e' 2000): l'ingresso deve essere a 2001+spread
        for bar in range(4, 12):
            for k in range(60):
                set_min(m, bar, k, o=2001, h=2001, l=2001, c=2001)
        b = E.costruisci_barre(m, 60)
        ind = ind_manuale(b.n, 3, {3: 2010.0})
        t = E.simula_trade(m, b, ind, 3, "long", maxhold=2)
        self.assertTrue(t["eseguito"])
        self.assertEqual(t["entry_m1"], int(b.i0[4]))            # prima M1 della barra j+1
        self.assertEqual(t["entry_time"], T0 + 4 * 60)
        self.assertAlmostEqual(t["entry"], 2001.0 + 0.30)        # open + spread (ask)
        self.assertNotAlmostEqual(t["entry"], float(b.c[3]))

    def test_spread_long_tp(self):
        m, b = setup(12)
        # j=3, ATR=2 -> D=6; entry long 2000.30; stop 1994.30; target 2003.00
        set_min(m, 4, 5, h=2003.5)        # massimo bid 2003.5 >= 2003 -> TP a 2003.00
        ind = ind_manuale(b.n, 3, {3: 2003.0})
        t = E.simula_trade(m, b, ind, 3, "long")
        self.assertEqual(t["motivo"], "TP")
        self.assertAlmostEqual(t["entry"], 2000.30)
        self.assertAlmostEqual(t["stop"], 1994.30)
        self.assertAlmostEqual(t["exit"], 2003.00)
        self.assertAlmostEqual(t["rischio"], 6.0)
        self.assertAlmostEqual(t["R"], 2.70 / 6)
        self.assertAlmostEqual(t["costo_spread_R"], 0.30 / 6)
        self.assertAlmostEqual(t["R_lordo"], 3.0 / 6)             # R lordo = R + costo spread
        self.assertEqual(t["exit_m1"], int(b.i0[4]) + 5)

    def test_spread_short_tp_paga_lo_spread_in_uscita(self):
        m, b = setup(12)
        # short: entry bid 2000.00; stop 2006; target 1997. Chiusura = ask = bid + 0,30
        set_min(m, 4, 5, l=1996.8)        # ask low = 1997.10 > 1997 -> NON deve chiudere
        set_min(m, 4, 9, l=1996.5)        # ask low = 1996.80 <= 1997 -> TP a 1997.00 (ask)
        ind = ind_manuale(b.n, 3, {3: 1997.0})
        t = E.simula_trade(m, b, ind, 3, "short")
        self.assertEqual(t["motivo"], "TP")
        self.assertAlmostEqual(t["entry"], 2000.0)                # short entra a bid
        self.assertAlmostEqual(t["stop"], 2006.0)
        self.assertEqual(t["exit_m1"], int(b.i0[4]) + 9)          # non al minuto 5
        self.assertAlmostEqual(t["exit"], 1997.0)
        self.assertAlmostEqual(t["R"], 3.0 / 6)
        self.assertAlmostEqual(t["costo_spread_R"], 0.30 / 6)
        self.assertAlmostEqual(t["R_lordo"], 3.30 / 6)

    def test_short_stop_su_ask(self):
        m, b = setup(12)
        # stop short a 2006: bid high 2005.80 + 0,30 = 2006.10 >= 2006 -> SL
        set_min(m, 4, 3, h=2005.8)
        ind = ind_manuale(b.n, 3, {3: 1990.0})
        t = E.simula_trade(m, b, ind, 3, "short")
        self.assertEqual(t["motivo"], "SL")
        self.assertAlmostEqual(t["R"], -1.0)
        self.assertEqual(t["exit_m1"], int(b.i0[4]) + 3)

    def test_sl_e_tp_stesso_minuto_vince_sl(self):
        for lato, target, kw in (("long", 2003.0, dict(h=2004.0, l=1990.0)),
                                 ("short", 1997.0, dict(h=2010.0, l=1990.0))):
            m, b = setup(12)
            set_min(m, 4, 7, **kw)           # stesso minuto tocca sia stop sia target
            ind = ind_manuale(b.n, 3, {3: target})
            t = E.simula_trade(m, b, ind, 3, lato)
            self.assertEqual(t["motivo"], "SL", lato)
            self.assertAlmostEqual(t["R"], -1.0, msg=lato)
            self.assertEqual(t["exit_m1"], int(b.i0[4]) + 7)

    def test_tp_in_minuto_precedente_allo_sl(self):
        m, b = setup(12)
        set_min(m, 4, 2, h=2004.0)           # TP al minuto 2
        set_min(m, 4, 7, l=1990.0)           # SL al minuto 7 (dopo)
        ind = ind_manuale(b.n, 3, {3: 2003.0})
        t = E.simula_trade(m, b, ind, 3, "long")
        self.assertEqual(t["motivo"], "TP")

    def test_gap_oltre_lo_stop_fill_all_apertura(self):
        m, b = setup(12)
        set_min(m, 4, 10, o=1980.0, h=1980.0, l=1980.0, c=1980.0)   # apre sotto lo stop 1994.30
        ind = ind_manuale(b.n, 3, {3: 2003.0})
        t = E.simula_trade(m, b, ind, 3, "long")
        self.assertEqual(t["motivo"], "SL")
        self.assertAlmostEqual(t["exit"], 1980.0)
        self.assertAlmostEqual(t["R"], (1980.0 - 2000.30) / 6)
        self.assertLess(t["R"], -1.0)

    def test_target_aggiornato_ogni_3_barre(self):
        # j=3; target iniziale SMA20(3)=2003; alla chiusura della barra 6 (j+3) diventa SMA20(6)=2001.
        m, b = setup(14)
        # durante la barra 6 (ancora target 2003) il massimo e' 2001.5: NON deve chiudere
        set_min(m, 6, 20, h=2001.5)
        # nella barra 7 (target ora 2001) lo stesso massimo chiude a 2001.00
        set_min(m, 7, 30, h=2001.5)
        ind = ind_manuale(b.n, 3, {3: 2003.0, 6: 2001.0, 9: 1999.0})
        t = E.simula_trade(m, b, ind, 3, "long")
        self.assertEqual(t["motivo"], "TP")
        self.assertAlmostEqual(t["exit"], 2001.0)
        self.assertEqual(t["exit_m1"], int(b.i0[7]) + 30)
        self.assertEqual(t["bar_uscita"], 7)
        self.assertEqual(t["n_agg_target"], 1)
        self.assertAlmostEqual(t["target0"], 2003.0)
        self.assertAlmostEqual(t["target_finale"], 2001.0)

    def test_target_aggiornato_secondo_ricalcolo(self):
        m, b = setup(14)
        set_min(m, 10, 5, h=1999.5)          # raggiunge solo 1999.5: serve il secondo ricalcolo (j+6=9 -> 1999)
        ind = ind_manuale(b.n, 3, {3: 2003.0, 6: 2001.0, 9: 2000.9})   # 2000.9 > 1999.5 -> nessun TP
        # entry long = 2000.30; sma(9)=2000.9 > entry ok
        t = E.simula_trade(m, b, ind, 3, "long", maxhold=8)
        self.assertEqual(t["motivo"], "TF")
        self.assertEqual(t["n_agg_target"], 2)
        # target congelato con ricalcolo_ogni=None: nessuna modifica
        t2 = E.simula_trade(m, b, ind, 3, "long", maxhold=8, ricalcolo_ogni=None)
        self.assertEqual(t2["n_agg_target"], 0)
        self.assertAlmostEqual(t2["target_finale"], 2003.0)
        # ricalcolo ogni 2 barre: aggiornamenti a j+2=5 (NaN: ignorato), j+4=7 (NaN), j+6=9
        t3 = E.simula_trade(m, b, ind, 3, "long", maxhold=8, ricalcolo_ogni=2)
        self.assertAlmostEqual(t3["target_finale"], 2000.9)

    def test_chiusura_forzata_TF(self):
        for lato in ("long", "short"):
            m, b = setup(20)
            # ultima M1 della barra 3+5=8: chiusura 2000.5, spread 50 punti
            set_min(m, 8, 59, c=2000.5, sp=50)
            tgt = 2010.0 if lato == "long" else 1990.0
            ind = ind_manuale(b.n, 3, {3: tgt})
            t = E.simula_trade(m, b, ind, 3, lato, maxhold=5)
            self.assertEqual(t["motivo"], "TF")
            self.assertEqual(t["bar_uscita"], 8)
            self.assertEqual(t["durata_barre"], 5)
            self.assertEqual(t["exit_m1"], int(b.i1[8]) - 1)
            if lato == "long":
                self.assertAlmostEqual(t["exit"], 2000.5)                 # esce a bid
                self.assertAlmostEqual(t["R"], (2000.5 - 2000.30) / 6)
            else:
                self.assertAlmostEqual(t["exit"], 2000.5 + 0.50)           # esce a ask
                self.assertAlmostEqual(t["R"], (2000.0 - 2001.0) / 6)
                self.assertAlmostEqual(t["costo_spread_R"], 0.50 / 6)

    def test_maxhold_default_1000_sensibilita_150_e_fine_dati(self):
        m, b = setup(160)
        ind = ind_manuale(b.n, 3, {3: 2010.0})
        t = E.simula_trade(m, b, ind, 3, "long")             # default params: MAXHOLD = 1000 -> mai TF qui
        self.assertEqual(t["motivo"], "FINE_DATI")
        self.assertEqual(t["bar_uscita"], 159)
        t = E.simula_trade(m, b, ind, 3, "long", maxhold=150)  # sensibilita Sc: 150 -> TF
        self.assertEqual(t["motivo"], "TF")
        self.assertEqual(t["durata_barre"], 150)
        self.assertEqual(t["bar_uscita"], 153)
        m2, b2 = setup(60)                                    # i dati finiscono prima di maxhold
        t2 = E.simula_trade(m2, b2, ind_manuale(b2.n, 3, {3: 2010.0}), 3, "long", maxhold=150)
        self.assertEqual(t2["motivo"], "FINE_DATI")           # mai etichettato TF
        self.assertEqual(t2["bar_uscita"], 59)

    def test_target_in_gap_riempito_al_livello(self):
        m, b = setup(12)
        # apertura del minuto sopra il target 2003: il fill resta 2003 (non 2010)
        set_min(m, 4, 10, o=2010.0, h=2010.5, l=2009.5, c=2010.0)
        ind = ind_manuale(b.n, 3, {3: 2003.0})
        t = E.simula_trade(m, b, ind, 3, "long")
        self.assertEqual(t["motivo"], "TP")
        self.assertAlmostEqual(t["exit"], 2003.0)
        t = E.simula_trade(m, b, ind, 3, "long", target_gap_improve=True)   # vecchio comportamento
        self.assertAlmostEqual(t["exit"], 2010.0)
        # short: apertura (ask) sotto il target 1997 -> fill 1997
        m, b = setup(12)
        set_min(m, 4, 10, o=1990.0, h=1990.5, l=1989.5, c=1990.0)
        t = E.simula_trade(m, b, ind_manuale(b.n, 3, {3: 1997.0}), 3, "short")
        self.assertEqual(t["motivo"], "TP")
        self.assertAlmostEqual(t["exit"], 1997.0)

    def test_schedule_completa_dei_target(self):
        m, b = setup(14)
        set_min(m, 8, 5, h=2001.5)           # TP con il target ricalcolato a j+6 = 9? no: barra 8 usa sma(6)
        ind = ind_manuale(b.n, 3, {3: 2003.0, 6: 2001.0, 9: 2000.9})
        t = E.simula_trade(m, b, ind, 3, "long")
        self.assertEqual(t["motivo"], "TP")
        # schedule: iniziale valido dall'ingresso (barra 4), poi dalla M1 successiva alla chiusura della barra 6
        self.assertEqual(t["targets"], [(T0 + 4 * 60, 2003.0), (T0 + 7 * 60, 2001.0)])
        self.assertEqual(t["n_agg_target"], 1)
        self.assertEqual(len(t["targets"]), t["n_agg_target"] + 1)

    def test_target_ricalcolato_gia_superato_uscita_a_mercato(self):
        m, b = setup(14)
        # prezzo sale a 2002 nella barra 5 senza toccare il target 2003; poi resta a 2002.
        for bar in range(5, 14):
            for k in range(60):
                set_min(m, bar, k, o=2002.0, h=2002.0, l=2002.0, c=2002.0)
        # a j+3 = 6 la SMA20 scende a 2001: nuovo target gia sotto il prezzo (bid 2002 >= 2001)
        ind = ind_manuale(b.n, 3, {3: 2003.0, 6: 2001.0})
        t = E.simula_trade(m, b, ind, 3, "long")
        self.assertEqual(t["motivo"], "MKT")
        self.assertEqual(t["exit_m1"], int(b.i0[7]))             # prima M1 dopo il ricalcolo
        self.assertAlmostEqual(t["exit"], 2002.0)                # a mercato, all'apertura (bid)
        self.assertAlmostEqual(t["R"], (2002.0 - 2000.30) / 6)
        # short: simmetrico, esce ad ask = open + spread
        m, b = setup(14)
        for bar in range(5, 14):
            for k in range(60):
                set_min(m, bar, k, o=1998.0, h=1998.0, l=1998.0, c=1998.0)
        ind = ind_manuale(b.n, 3, {3: 1997.0, 6: 1999.0})
        t = E.simula_trade(m, b, ind, 3, "short")
        self.assertEqual(t["motivo"], "MKT")
        self.assertAlmostEqual(t["exit"], 1998.30)
        self.assertAlmostEqual(t["R"], (2000.0 - 1998.30) / 6)
        self.assertAlmostEqual(t["costo_spread_R"], 0.30 / 6)

    def test_flag_sl_e_tp_stesso_minuto_e_spread0(self):
        m, b = setup(12)
        set_min(m, 4, 7, h=2004.0, l=1990.0)
        ind = ind_manuale(b.n, 3, {3: 2003.0})
        t = E.simula_trade(m, b, ind, 3, "long")
        self.assertTrue(t["sl_e_tp_stesso_minuto"])
        m, b = setup(12)
        set_min(m, 4, 7, l=1990.0)
        t = E.simula_trade(m, b, ind, 3, "long")
        self.assertFalse(t["sl_e_tp_stesso_minuto"])
        # spread 0 sostituito: mediana degli spread non nulli della stessa ora
        m, b = setup(12)
        ore = ((m.t // 60) % 24)
        m.sp[(ore == 3) & (np.arange(m.n) % 2 == 0)] = 0.0       # meta' delle M1 dell'ora 3 con spread 0
        m.sp[(ore == 3) & (np.arange(m.n) % 2 == 1)] = 40.0
        mm = E.sostituisci_spread_zero(m)
        self.assertTrue(np.all(mm.sp[(ore == 3)] == 40.0))        # 0 -> mediana non nulla dell'ora 3
        self.assertEqual(mm.info["spread0_sostituiti"], int(mm.sp_sost.sum()))
        self.assertTrue(np.all(m.sp[(ore == 3) & (np.arange(m.n) % 2 == 0)] == 0.0))   # originale intatto
        self.assertTrue(np.all(mm.sp[ore != 3] == 30.0))
        # la maschera arriva nel log del trade
        j = 3
        e = int(b.i0[j + 1])
        mm.sp_sost[e] = True
        t = E.simula_trade(mm, b, ind_manuale(b.n, 3, {3: 2003.0}), 3, "long")
        self.assertTrue(t["spread0_ingresso"])
        # scala_spread
        m2 = E.scala_spread(mm, 1.5)
        self.assertAlmostEqual(float(m2.sp[0]), float(mm.sp[0]) * 1.5)

    def test_target_oltre_prezzo_di_ingresso_nessun_trade(self):
        m, b = setup(12)
        # long: ingresso 2000.30; target 2000.20 (gia sotto) -> nessun trade
        t = E.simula_trade(m, b, ind_manuale(b.n, 3, {3: 2000.2}), 3, "long")
        self.assertFalse(t["eseguito"]); self.assertEqual(t["scarto"], "TARGET_OLTRE_INGRESSO")
        # target tra bid e ask (2000.2 < ask 2000.30) vale come "oltre" per il long
        # short: ingresso 2000.00; target 2000.5 (sopra) -> nessun trade
        t = E.simula_trade(m, b, ind_manuale(b.n, 3, {3: 2000.5}), 3, "short")
        self.assertFalse(t["eseguito"]); self.assertEqual(t["scarto"], "TARGET_OLTRE_INGRESSO")
        # contatore in esegui_segnali
        tr, cont = E.esegui_segnali(m, b, ind_manuale(b.n, 3, {3: 2000.2}), [(3, "long")])
        self.assertEqual(tr, [])
        self.assertEqual(cont["scartati_target_oltre_ingresso"], 1)
        self.assertEqual(cont["eseguiti"], 0)

    def test_scarti_indicatori_e_ultima_barra(self):
        m, b = setup(12)
        ind = ind_manuale(b.n, 3, {3: 2003.0})
        self.assertEqual(E.simula_trade(m, b, ind, 5, "long")["scarto"], "INDICATORI_NON_PRONTI")
        ind2 = ind_manuale(b.n, 11, {11: 2003.0})
        self.assertEqual(E.simula_trade(m, b, ind2, 11, "long")["scarto"], "NO_BARRA_SUCCESSIVA")

    def test_gap_ingresso(self):
        # buco di un'ora e mezza tra la barra 3 e la successiva
        n = 12 * 60
        t = T0 + np.arange(n)
        t = np.where(np.arange(n) >= 4 * 60, t + 120, t)
        a = np.full(n, P)
        m = E.costruisci_m1(t, a.copy(), a.copy(), a.copy(), a.copy(), np.full(n, 30.0))
        b = E.costruisci_barre(m, 60)
        ind = ind_manuale(b.n, 3, {3: 2003.0})
        tr = E.simula_trade(m, b, ind, 3, "long")
        self.assertEqual(tr["gap_ingresso_min"], 120)
        tr2 = E.simula_trade(m, b, ind, 3, "long", max_gap_ingresso_min=60)
        self.assertEqual(tr2["scarto"], "GAP_INGRESSO")

    def test_una_posizione_alla_volta(self):
        m, b = setup(30)
        set_min(m, 6, 10, h=2004.0)      # il primo trade (j=3, ingresso barra 4) chiude per TP alla barra 6
        ind = ind_manuale(b.n, 3, {3: 2003.0})
        ind.atr14[:] = 2.0
        for k in range(3, 30):
            ind.sma20[k] = 2003.0
        segnali = [(8, "long"), (3, "long"), (4, "long"), (5, "long"), (6, "long"), (7, "long")]
        trades, cont = E.esegui_segnali(m, b, ind, segnali)
        # ordinati per barra; j=3 apre e chiude per TP in barra 6; j=4,5 scartati (posizione aperta);
        # j=6: ingresso barra 7 > uscita -> accettato, ma poi resta aperto fino alla fine dei dati
        # (prezzo piatto, nessun TP/SL) quindi j=7 e j=8 sono scartati.
        self.assertEqual(cont["segnali"], 6)
        self.assertEqual(cont["scartati_posizione_aperta"], 4)
        self.assertEqual([t["j"] for t in trades], [3, 6])
        self.assertEqual(trades[1]["motivo"], "FINE_DATI")
        js = [t["j"] for t in trades]
        self.assertEqual(js[0], 3)
        self.assertEqual(trades[0]["motivo"], "TP")
        self.assertEqual(trades[0]["bar_uscita"], 6)
        self.assertEqual(js[1], 6)
        # nessuna sovrapposizione fra trade
        for a_, b_ in zip(trades, trades[1:]):
            self.assertLess(a_["exit_m1"], b_["entry_m1"])
        self.assertEqual(cont["eseguiti"], len(trades))
        self.assertEqual(cont["eseguiti"] + cont["scartati_posizione_aperta"], cont["segnali"])

    def test_simmetria_long_short(self):
        """Specchio dei prezzi (2000+x -> 2000-x) senza spread: R long = R short."""
        rng = np.random.default_rng(5)
        n = 40 * 60
        x = np.cumsum(rng.normal(0, 0.4, n))
        base = 2000.0 + x
        o = np.concatenate(([base[0]], base[:-1])); c = base
        h = np.maximum(o, c) + 0.1; l = np.minimum(o, c) - 0.1
        m_up = E.costruisci_m1(T0 + np.arange(n), o, h, l, c, np.zeros(n))
        m_dn = E.costruisci_m1(T0 + np.arange(n), 4000 - o, 4000 - l, 4000 - h, 4000 - c, np.zeros(n))
        b = E.costruisci_barre(m_up, 60); b2 = E.costruisci_barre(m_dn, 60)
        for j in (5, 9, 14):
            a = np.full(b.n, 3.0); s_up = np.full(b.n, np.nan); s_dn = np.full(b.n, np.nan)
            z = np.full(b.n, np.nan)
            s_up[j] = b.c[j] + 2.0; s_dn[j] = 4000 - (b.c[j] + 2.0)
            i1 = E.Indicatori(z, z, z, z, z, a); i1.sma20 = s_up
            i2 = E.Indicatori(z, z, z, z, z, a); i2.sma20 = s_dn
            t1 = E.simula_trade(m_up, b, i1, j, "long", maxhold=30, ricalcolo_ogni=None)
            t2 = E.simula_trade(m_dn, b2, i2, j, "short", maxhold=30, ricalcolo_ogni=None)
            if not t1["eseguito"]:
                self.assertFalse(t2["eseguito"]); continue
            self.assertEqual(t1["motivo"], t2["motivo"])
            self.assertEqual(t1["exit_m1"], t2["exit_m1"])
            self.assertAlmostEqual(t1["R"], t2["R"], places=9)

    def test_trade_non_dipende_dal_futuro_dopo_l_uscita(self):
        rng = np.random.default_rng(3)
        n = 60 * 60
        c = 2000 + np.cumsum(rng.normal(0, 0.5, n))
        o = np.concatenate(([c[0]], c[:-1]))
        h = np.maximum(o, c) + 0.2; l = np.minimum(o, c) - 0.2
        m = E.costruisci_m1(T0 + np.arange(n), o, h, l, c, np.full(n, 30.0))
        b = E.costruisci_barre(m, 60)
        ind = E.indicatori(b)
        trovato = 0
        for j in range(30, b.n - 5):
            for lato in ("long", "short"):
                t = E.simula_trade(m, b, ind, j, lato, maxhold=20)
                if not t["eseguito"]:
                    continue
                trovato += 1
                fine = int(b.i1[t["bar_uscita"]])
                m2 = E.costruisci_m1(m.t[:fine], m.o[:fine], m.h[:fine], m.l[:fine], m.c[:fine], m.sp[:fine])
                b2 = E.costruisci_barre(m2, 60)
                ind2 = E.indicatori(b2)
                t2 = E.simula_trade(m2, b2, ind2, j, lato, maxhold=20)
                for k in ("entry_m1", "entry", "exit_m1", "exit", "motivo", "R", "stop"):
                    self.assertEqual(t[k], t2[k], f"{k} j={j} {lato}")
        self.assertGreater(trovato, 20)


class TestStatistiche(unittest.TestCase):
    def test_statistiche_a_mano(self):
        def tr(i, R, costo, motivo):
            return {"entry_m1": i, "R": R, "R_lordo": R + costo, "costo_spread_R": costo, "motivo": motivo}
        trades = [tr(1, 1.0, 0.1, "TP"), tr(2, -1.0, 0.1, "SL"), tr(3, -1.0, 0.1, "SL"),
                  tr(4, 2.0, 0.2, "TP"), tr(5, -0.5, 0.0, "TF")]
        s = E.statistiche(trades)
        self.assertEqual(s["n"], 5)
        self.assertAlmostEqual(s["win_pct"], 40.0)
        self.assertAlmostEqual(s["pf_netto"], 3.0 / 2.5)
        self.assertAlmostEqual(s["netto_R"], 0.5)
        self.assertAlmostEqual(s["costo_spread_R"], 0.5)
        self.assertAlmostEqual(s["lordo_R"], 1.0)
        self.assertAlmostEqual(s["media_vincita_R"], 1.5)
        self.assertAlmostEqual(s["media_perdita_R"], -2.5 / 3)
        # equity: 0,1,0,-1,1,0.5 -> picco 1 -> minimo -1 => DD 2
        self.assertAlmostEqual(s["dd_max_R"], 2.0)
        self.assertEqual(s["per_motivo"], {"TP": 2, "SL": 2, "TF": 1})

    def test_statistiche_vuote_e_solo_vincite(self):
        self.assertEqual(E.statistiche([])["n"], 0)
        s = E.statistiche([{"entry_m1": 1, "R": 1.0, "R_lordo": 1.0, "costo_spread_R": 0.0, "motivo": "TP"}])
        self.assertTrue(math.isinf(s["pf_netto"]))
        self.assertTrue(math.isnan(s["media_perdita_R"]))


if __name__ == "__main__":
    unittest.main(verbosity=2)
