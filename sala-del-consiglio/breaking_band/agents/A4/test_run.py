"""Test di run_test.py su dati SINTETICI (nessun CSV reale viene letto).

Esecuzione:  python3 -I test_run.py
- pipeline end-to-end su 2 periodi sintetici (CSV generati qui con un random walk GARCH):
  tutte le tabelle presenti, imbuto riconciliato, intestazione con hash e parametri;
- riproducibilita: due esecuzioni (anche in processi diversi) -> stesso sha256 dei risultati;
- caso con N=0/piccolo (parametri congelati su dati sintetici): nessun crash, verdetto INCONCLUSIVO;
- verdetto: tabella delle condizioni (N<30, parte A, INDIZIO, NESSUN VANTAGGIO, NON DIMOSTRATO);
- martingala: ingressi arbitrari su random walk -> P&L lordo medio ~ 0 (|z| <= 3,5), motore senza bias;
- bootstrap/Wilson/baseline: proprieta di base.
"""
import hashlib
import json
import os
import subprocess
import sys
import tempfile
import unittest

HERE = os.path.dirname(os.path.abspath(__file__))
sys.path.insert(0, HERE)

import numpy as np  # noqa: E402

import engine as E  # noqa: E402
import run_test as RT  # noqa: E402
from params import DISEGNO  # noqa: E402

RILASSATO = {"B1_W": 1.3, "B4_ER": 0.3, "B5_ATR": 1.0, "B3_ATR": 1.0, "IMPULSIVA_ATR": 2.5, "BANDA_TOL_ATR": 2.0}
PROVA = json.dumps({"PARAMS": RILASSATO, "DISEGNO": {"N_ESTRAZIONI": 200, "N_BOOTSTRAP": 300}})
PROVA_DIS = json.dumps({"DISEGNO": {"N_ESTRAZIONI": 200, "N_BOOTSTRAP": 300}})


def scrivi_csv(path, seed, giorni):
    rng = np.random.default_rng(seed)
    t0 = int(np.datetime64("2019-01-01T00:00", "m").astype(np.int64))
    m = RT.genera_placebo_m1(rng, giorni * 1440, 2000.0, 25.0, t0, 4)
    sp = m.sp.copy()
    sp[::5000] = 0.0                                     # alcune righe con spread 0 (da sostituire)
    sp[1::7] += rng.integers(0, 20, size=sp[1::7].size)
    dt = np.datetime_as_string(m.t.astype("datetime64[m]"), unit="m")
    with open(path, "w") as f:
        f.write("time;open;high;low;close;tickvol;spread\n")
        for i in range(m.n):
            f.write("%s;%.2f;%.2f;%.2f;%.2f;10;%d\n" % (dt[i][:10].replace("-", ".") + " " + dt[i][11:],
                                                       m.o[i], m.h[i], m.l[i], m.c[i], sp[i]))


class TestPipeline(unittest.TestCase):
    @classmethod
    def setUpClass(cls):
        cls.tmp = tempfile.TemporaryDirectory()
        d = cls.tmp.name
        cls.a, cls.b = os.path.join(d, "per_A.csv"), os.path.join(d, "per_B.csv")
        scrivi_csv(cls.a, 1, 400)
        scrivi_csv(cls.b, 2, 400)
        cls.d = d

    @classmethod
    def tearDownClass(cls):
        cls.tmp.cleanup()

    def lancia(self, nome, extra):
        out = os.path.join(self.d, nome)
        ris = RT.main(["--periodi", "A=" + self.a, "B=" + self.b, "--out", out, "--solo-h1", "--placebo-target", "30",
                       "--placebo-max-anni", "2"] + extra)
        return ris, out

    def test_pipeline_completa_con_trade(self):
        ris, out = self.lancia("rilassato", ["--prova", PROVA, "--placebo-blocchi", "2"])
        T = ris["tabelle"]
        for k in ("T1_imbuto", "T2_risultati", "T3_fasce", "T4_linea_di_base", "T5_robustezza", "T6_sensibilita",
                  "T7_placebo", "T8_deriva", "T9_dati_esecuzione", "VERDETTO", "LOG_TRADE"):
            self.assertIn(k, T)
        # T2: celle variante x periodo, totali e pooled
        self.assertEqual(sorted(T["T2_risultati"]), sorted(
            ["%s_H1_%s" % (v, p) for v in ("CONT", "INV") for p in ("A", "B", "TOTALE")] + ["POOLED_H1"]))
        N = T["T2_risultati"]["POOLED_H1"]["n"]
        self.assertGreater(N, 30)
        self.assertEqual(N, T["T2_risultati"]["CONT_H1_TOTALE"]["n"] + T["T2_risultati"]["INV_H1_TOTALE"]["n"])
        # imbuto riconciliato (segnali = trade + scartati) in ogni cella
        for var in T["T1_imbuto"].values():
            for tab in var.values():
                self.assertTrue(tab["segnali_e_trade"]["riconciliato"])
                conti = [s["n"] for s in tab["stadi"]]
                self.assertTrue(all(x >= y for x, y in zip(conti, conti[1:])))
        # i trade eseguiti dell'imbuto = n di T2
        tot = sum(tab["TOTALE"]["segnali_e_trade"]["eseguiti"] for tab in T["T1_imbuto"].values())
        self.assertEqual(tot, N)
        # sensibilita: tutte presenti
        self.assertEqual(sorted(T["T6_sensibilita"]), sorted(["Sa", "Sb", "Sc", "Sd", "Se20", "Se50", "Sf", "Sg"]))
        # Sc: con maxhold 150 compaiono le uscite TF oppure nessuna differenza di segnali
        self.assertEqual(T["T6_sensibilita"]["Sc"]["segnali"], T["T6_sensibilita"]["Sd"]["segnali"])
        # linea di base: p in (0,1], 4 sezioni
        b1 = T["T4_linea_di_base"]["B1"]["pooled"]
        self.assertGreater(b1["p_B"], 0)
        self.assertLessEqual(b1["p_B"], 1)
        self.assertEqual(b1["n_abbinati"] + T["T4_linea_di_base"]["B1"]["mancanti_senza_abbinamento"], N)
        # intestazione: hash CSV corretti, parametri presenti
        h = ris["intestazione"]
        with open(self.a, "rb") as fa:
            self.assertEqual(h["sha256_csv"]["A"], hashlib.sha256(fa.read()).hexdigest())
        self.assertEqual(h["parametri"]["T_MAX"], 30)
        self.assertEqual(h["parametri"]["MAXHOLD"], 1000)
        self.assertTrue(h["PARAMETRI_NON_CONGELATI_PROVA"])
        for f in ("engine.py", "signals.py", "params.py", "run_test.py"):
            self.assertEqual(len(h["sha256_codice"][f]), 64)
        # log trade con schedule completa dei target: la prima voce e' il target iniziale
        log = [t for v in T["LOG_TRADE"].values() for t in v]
        self.assertEqual(len(log), N)
        for t in log:
            self.assertEqual(len(t["targets"]), t["n_agg_target"] + 1)
            self.assertEqual(t["targets"][0][0], t["entry_time"])
            self.assertEqual(t["targets"][0][1], t["target0"])
        # placebo (martingala): se concluso, |z| <= 3 (altrimenti NON_CONCLUSIVO per N basso)
        for k, v in T["T7_placebo"].items():
            if isinstance(v, dict) and v.get("esito") in ("SUPERATO", "FALLITO"):
                self.assertEqual(v["esito"], "SUPERATO", k)
        self.assertIn("media_R_media", T["T7_placebo"]["blocchi_esplorativo"])
        # file prodotti e JSON valido (niente NaN)
        with open(out + ".json") as fh:
            j = json.load(fh, parse_constant=lambda x: (_ for _ in ()).throw(ValueError(x)))
        self.assertEqual(j["sha256_risultati"], ris["sha256_risultati"])
        with open(out + ".md") as fh:
            md = fh.read()
        for sez in ("T1 Imbuto", "T2 Risultati", "T3 Fasce", "T4 Linee di base", "T5 Robustezza", "T6 Sensibilita",
                    "T7 Placebo", "T8 Deriva", "T9 Dati", "VERDETTO"):
            self.assertIn(sez, md)
        # spread 0 sostituito: contati
        self.assertGreater(T["T9_dati_esecuzione"]["spread0_sostituiti_per_periodo"]["A"], 0)

    def test_riproducibilita_stesso_processo_e_processi_diversi(self):
        r1, o1 = self.lancia("rep1", ["--prova", PROVA])
        r2, o2 = self.lancia("rep2", ["--prova", PROVA])
        self.assertEqual(r1["sha256_risultati"], r2["sha256_risultati"])
        with open(o1 + ".json") as f1, open(o2 + ".json") as f2:
            self.assertEqual(f1.read().replace("rep1", "X"), f2.read().replace("rep2", "X"))
        o3 = os.path.join(self.d, "rep3")
        p = subprocess.run([sys.executable, "-I", os.path.join(HERE, "run_test.py"), "--periodi", "A=" + self.a,
                            "B=" + self.b, "--out", o3, "--solo-h1", "--placebo-target", "30", "--placebo-max-anni", "2",
                            "--prova", PROVA], capture_output=True, text=True)
        self.assertEqual(p.returncode, 0, p.stderr)
        with open(o3 + ".json") as f3:
            self.assertEqual(json.load(f3)["sha256_risultati"], r1["sha256_risultati"])

    def test_parametri_congelati_pochi_o_zero_trade_inconcludente_senza_crash(self):
        ris, _ = self.lancia("congelati", ["--prova", PROVA_DIS])
        V = ris["tabelle"]["VERDETTO"]
        if V["N"] < 30:
            self.assertEqual(V["esito"], "INCONCLUSIVO")
        self.assertIn("clausole_Parte_C", V)
        self.assertTrue(V["condizionale_a_parte_A"])

    def test_parte_a_non_verificato_vieta_il_verdetto(self):
        ris, _ = self.lancia("parteA", ["--prova", PROVA, "--parte-a", "NON_VERIFICATO"])
        self.assertEqual(ris["tabelle"]["VERDETTO"]["esito"], "INCONCLUSIVO")


class TestVerdetto(unittest.TestCase):
    IC_OK = {"ic90_lo": 0.05, "ic90_hi": 0.20}

    def v(self, N=120, m=0.12, pf=1.3, p=0.01, ic=None, lopo=True, sd=True, a="VERIFICATO"):
        return RT.verdetto(N, m, pf, p, ic or self.IC_OK, lopo, sd, a)

    def test_tabella_dei_verdetti(self):
        self.assertEqual(self.v(N=29)["esito"], "INCONCLUSIVO")
        self.assertEqual(self.v(a="NON_VERIFICATO")["esito"], "INCONCLUSIVO")
        r = self.v()
        self.assertEqual((r["esito"], r["livello"]), ("INDIZIO DI VANTAGGIO", "PIENO"))
        self.assertEqual(self.v(N=50)["livello"], "PRELIMINARE")
        # una sola condizione dell'INDIZIO manca -> non e' piu' INDIZIO
        for kw in (dict(m=-0.01), dict(p=0.06), dict(pf=1.14), dict(lopo=False), dict(sd=False)):
            self.assertNotEqual(self.v(**kw)["esito"], "INDIZIO DI VANTAGGIO", kw)
        # NESSUN VANTAGGIO RILEVANTE: limite superiore IC90 < +0,10
        r = self.v(m=-0.02, pf=0.9, p=0.7, ic={"ic90_lo": -0.15, "ic90_hi": 0.09}, lopo=False, sd=False)
        self.assertEqual(r["esito"], "NESSUN VANTAGGIO RILEVANTE")
        # NON DIMOSTRATO: N>=30, IC largo
        r = self.v(m=0.03, pf=1.1, p=0.3, ic={"ic90_lo": -0.2, "ic90_hi": 0.3}, lopo=False, sd=True)
        self.assertEqual(r["esito"], "NON DIMOSTRATO")
        self.assertTrue(any("non attribuibile" in n for n in r["note"]))
        # p_B1 <= 0,05 ma altre condizioni no -> NON DIMOSTRATO con nota
        r = self.v(pf=1.1, ic={"ic90_lo": -0.2, "ic90_hi": 0.3})
        self.assertEqual(r["esito"], "NON DIMOSTRATO")
        self.assertTrue(any("nota 1" in n for n in r["note"]))


class TestStatistica(unittest.TestCase):
    def test_wilson_e_pf(self):
        lo, hi = RT.wilson(50, 100, DISEGNO["WILSON_Z90"])
        self.assertAlmostEqual(lo, 0.4188, places=3)
        self.assertAlmostEqual(hi, 0.5812, places=3)
        self.assertEqual(RT.wilson(0, 0, 1.64), (None, None))
        self.assertAlmostEqual(RT.pf_di([1, 2, -1, -0.5]), 2.0)
        self.assertTrue(np.isinf(RT.pf_di([1, 2])))

    def test_bootstrap_a_blocchi_riproducibile(self):
        tr = [{"settimana": w, "R": r} for w, r in zip([1, 1, 2, 3, 3, 3, 4, 5], [1, -1, 2, -1, -1, 1.5, 0.5, -0.2])]
        a = RT.bootstrap_settimane(tr, 2000, 7, 0.05)
        b = RT.bootstrap_settimane(tr, 2000, 7, 0.05)
        self.assertEqual(a, b)
        self.assertAlmostEqual(a["media"], np.mean([t["R"] for t in tr]))
        self.assertLess(a["ic90_lo"], a["media"])
        self.assertGreater(a["ic90_hi"], a["media"])
        self.assertEqual(a["settimane"], 5)

    def test_settimana_lunedi(self):
        lun = int(np.datetime64("2019-01-07T00:00", "m").astype(np.int64))      # lunedi
        dom = lun - 1                                                           # domenica precedente
        self.assertEqual(RT.settimana(lun) - RT.settimana(dom), 1)
        self.assertEqual(RT.settimana(lun), RT.settimana(lun + 6 * 1440 + 1439))

    def test_baseline_abbinamento_e_pvalue(self):
        # pool: R tutti = 1.0 per D in [1,2] ; trade osservati con R = 1.0 -> p_B = 1 ; con R = 5 -> p minimo
        pl = {"j": np.arange(10), "R": np.ones(10), "D": np.linspace(1.0, 2.0, 10), "vol": np.ones(10, dtype=bool),
              "sig": np.zeros(10, dtype=bool), "win": np.ones(10, dtype=bool)}
        pools = {"A": {1: pl, -1: pl}}
        trades = [{"periodo": "A", "side": 1, "D_atr": 1.5, "R": 5.0, "variante": "CONT"} for _ in range(4)]
        bl = RT.baseline(trades, pools, "B1", 200, 3)
        s = RT.sintesi_baseline(trades, bl, np.ones(4, dtype=bool))
        self.assertEqual(s["n_abbinati"], 4)
        self.assertAlmostEqual(s["media_nulla"], 1.0)
        self.assertAlmostEqual(s["p_B"], 1.0 / 201)
        # nessun candidato nella finestra di D -> trade non abbinato
        trades2 = [{"periodo": "A", "side": 1, "D_atr": 9.0, "R": 0.0, "variante": "CONT"}]
        bl2 = RT.baseline(trades2, pools, "B1", 50, 3)
        self.assertEqual(bl2["mancanti"], 1)
        # la barra di segnale e' esclusa dall'estrazione
        pl["sig"][:] = True
        bl3 = RT.baseline(trades, pools, "B1", 50, 3)
        self.assertEqual(bl3["mancanti"], 4)

    def test_riga_gruppo_soglie_campione(self):
        def tr(n):
            return [{"R": 1.0 if i % 2 else -1.0, "side": 1, "wr0_i": 0.6} for i in range(n)]
        self.assertEqual(list(RT.riga_gruppo(tr(5), {}).keys()), ["n", "vincite", "long"])
        r = RT.riga_gruppo(tr(20), {})
        self.assertIn("media_R", r)
        self.assertNotIn("pf_netto", r)
        r = RT.riga_gruppo(tr(40), {})
        self.assertIn("wilson90_lo_pct", r)


class TestMartingala(unittest.TestCase):
    def test_pnl_lordo_zero_su_random_walk(self):
        """Qualunque regola di ingresso causale ha P&L lordo medio 0 su una martingala (CK-13)."""
        g = []
        for seed in range(3):
            rng = np.random.default_rng(100 + seed)
            m = RT.genera_placebo_m1(rng, 350000, 2000.0, 25.0, 60 * 24 * 1000, 4)
            b = E.costruisci_barre(m, 60)
            ind = E.indicatori(b)
            sig = [(j, 1 if (j // 3) % 2 == 0 else -1) for j in range(200, b.n - 1)]
            tr, _ = E.esegui_segnali(m, b, ind, sig)
            g += [t["R_lordo"] for t in tr]
        g = np.array(g)
        z = g.mean() / (g.std(ddof=1) / np.sqrt(g.size))
        self.assertGreater(g.size, 1500)
        self.assertLess(abs(z), 3.5, "z=%.2f media=%.4f" % (z, g.mean()))


if __name__ == "__main__":
    unittest.main(verbosity=2)
