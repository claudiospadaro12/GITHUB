"""Test dell'aggregatore agg_conferma.py su JSON FINTI (dati sintetici con esito noto). Nessun CSV viene letto.

Esecuzione:  python3 -I test_agg_conferma.py
- ogni criterio 1-5 e il verdetto (CONFERMATO / NON DIMOSTRATO / NESSUN VANTAGGIO RILEVANTE / INCONCLUSIVO) con
  scenari costruiti a mano; statistiche ricalcolate in modo indipendente nel test;
- bootstrap identico a run_test.bootstrap_settimane (stesso metodo del run) e blocchi settimanali CONDIVISI fra le coppie;
- controlli di integrita' (sha dei JSON, codice v2, parametri di prova, coppie, anni);
- riproducibilita' (stesso processo e processi diversi);
- il formato letto e' quello reale: si ricalcola lo sha256_risultati di un JSON gia' prodotto (final/run_forex/EURUSD.json,
  vecchi anni, NON anni nuovi) e si verifica la coerenza del log con T2.
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

import agg_conferma as AG  # noqa: E402
import run_test as RT  # noqa: E402

ANNI = list(AG.AGG["ANNI"])
COPPIE = list(AG.AGG["COPPIE"])
CODICE = {"engine.py": "a" * 64, "signals.py": "b" * 64, "params.py": "c" * 64, "run_test.py": "d" * 64}


def trade(R, sett, side=1, c=0.01, D=1.0):
    return {"R": R, "settimana": sett, "side": side, "c_atr": c, "D_atr": D}


def json_finto(simbolo, per_chiave, stop=3.0, prova=False, codice=None, hash_dati=True, seme=20261101):
    """per_chiave: {'CONT_H1_2015': [trade, ...], ...}; le chiavi mancanti sono create vuote."""
    log = {}
    for var in ("CONT", "INV"):
        for tf in ("H1", "M30"):
            for a in ANNI:
                log["%s_%s_%s" % (var, tf, a)] = []
    log.update(per_chiave)
    h1 = [t for k, v in log.items() if k.split("_")[1] == "H1" for t in v]
    T2 = {"POOLED_H1": {"n": len(h1)}}
    if h1:
        T2["POOLED_H1"].update({
            "pareggio_atteso_medio_pct": 100.0 * float(np.mean([(stop + t["c_atr"]) / (stop + t["D_atr"]) for t in h1])),
            "attesa_R": float(np.mean([t["R"] for t in h1]))})
    j = {"intestazione": {"simbolo": simbolo, "parametri": {"STOP_ATR": stop},
                          "disegno": {"SEED": seme, "N_BOOTSTRAP": 10000},
                          "PARAMETRI_NON_CONGELATI_PROVA": prova,
                          "sha256_codice": codice or CODICE, "sha256_csv": {a: "0" * 64 for a in ANNI},
                          "hash_dati_coincidono": ({"x.csv": True} if hash_dati else None)},
         "tabelle": {"LOG_TRADE": log, "T2_risultati": T2}}
    j["sha256_risultati"] = AG.sha_risultati_json(j)
    return j


def riallinea(j):
    j["sha256_risultati"] = AG.sha_risultati_json(j)
    return j


def scenario(rng, n_per_coppia, gen, settimane=60, coppie=COPPIE, **kw):
    """gen(rng) -> R. Le settimane sono estratte da un insieme COMUNE alle coppie."""
    out = {}
    for nome in coppie:
        per = {}
        for i in range(n_per_coppia):
            var = "CONT" if i % 2 == 0 else "INV"
            tf_key = "%s_H1_%s" % (var, ANNI[i % 4])
            per.setdefault(tf_key, []).append(trade(gen(rng), 2000 + int(rng.integers(0, settimane)),
                                                    1 if rng.random() < 0.5 else -1))
        out[nome] = json_finto(nome, per, **kw)
    return out


def bernoulli(p, vin, per):
    return lambda rng: vin if rng.random() < p else per


def frazione(percento, vin, per):
    """Esattamente `percento` vincite ogni 100 trade (deterministico)."""
    c = [0]

    def g(rng):
        c[0] += 1
        return vin if (c[0] - 1) % 100 < percento else per
    return g


def tutti(coppie_json):
    h1 = [t for j in coppie_json.values() for t in AG.estrai_trade(j, "H1")]
    return h1


class TestScenari(unittest.TestCase):
    def calcola(self, cj, hc=None):
        return AG.calcola(cj, ANNI, hc)

    def test_inconcludente_N_basso(self):
        cj = scenario(np.random.default_rng(1), 7, bernoulli(0.9, 0.33, -1.0))        # 28 trade
        r = self.calcola(cj)
        self.assertEqual(r["VERDETTO"]["N"], 28)
        self.assertEqual(r["VERDETTO"]["esito"], "INCONCLUSIVO")
        self.assertFalse(r["VERDETTO"]["condizioni"]["1_N>=30"])
        cj = scenario(np.random.default_rng(1), 8, bernoulli(0.9, 0.33, -1.0))        # 32 trade: N>=30
        self.assertNotEqual(self.calcola(cj)["VERDETTO"]["esito"], "INCONCLUSIVO")

    def test_confermato_e_statistiche_ricalcolate_indipendentemente(self):
        cj = scenario(np.random.default_rng(2), 25, bernoulli(0.88, 0.33, -1.0))
        r = self.calcola(cj)
        V = r["VERDETTO"]
        self.assertEqual(V["esito"], "CONFERMATO", json.dumps(V["condizioni"]))
        self.assertTrue(all(V["condizioni"].values()))
        # ricalcolo indipendente dai log grezzi
        R = np.array([t["R"] for j in cj.values() for k, v in j["tabelle"]["LOG_TRADE"].items()
                      if k.split("_")[1] == "H1" for t in v])
        self.assertEqual(V["N"], R.size)
        self.assertAlmostEqual(V["media_R"], R.mean(), places=12)
        self.assertAlmostEqual(V["win_rate_pct"], 100.0 * (R > 0).mean(), places=9)
        self.assertAlmostEqual(V["pareggio_atteso_medio_pct"], 100.0 * 3.01 / 4.0, places=9)
        self.assertAlmostEqual(V["soglia_win_rate_pct"], V["pareggio_atteso_medio_pct"] + 5.0, places=9)
        self.assertAlmostEqual(V["media_R_con_costo_extra"], R.mean() - 0.05, places=12)
        for nome in COPPIE:
            resto = np.array([t["R"] for n2, j in cj.items() if n2 != nome
                              for k, v in j["tabelle"]["LOG_TRADE"].items() if k.split("_")[1] == "H1" for t in v])
            self.assertAlmostEqual(V["leave_one_pair_out_media_R"][nome], resto.mean(), places=12)
        self.assertGreater(V["ic90"]["ic90_lo"], 0)
        self.assertEqual(V["ic90"]["n_replicati"], 10000)
        self.assertTrue(V["controlli_integrita_ok"] or V["controlli_non_verificabili"])

    def test_ogni_condizione_da_sola_nega_la_conferma(self):
        # (3) win rate sotto pareggio + 5: 78% < 80,25%
        r = self.calcola(scenario(np.random.default_rng(3), 25, frazione(78, 1.0, -1.0)))["VERDETTO"]
        self.assertTrue(r["condizioni"]["2_media>0_e_IC90_inf>0"])
        self.assertFalse(r["condizioni"]["3_WR>=pareggio+5pp"])
        self.assertEqual(r["esito"], "NON DIMOSTRATO")
        # (5) costo extra: tutti i trade a +0,03 R: IC>0, WR 100%, ma 0,03-0,05 < 0
        r = self.calcola(scenario(np.random.default_rng(4), 25, lambda rng: 0.03))["VERDETTO"]
        self.assertTrue(r["condizioni"]["2_media>0_e_IC90_inf>0"] and r["condizioni"]["3_WR>=pareggio+5pp"])
        self.assertFalse(r["condizioni"]["5_costo_extra_0.05R_media>0"])
        self.assertNotEqual(r["esito"], "CONFERMATO")
        # (4) leave-one-pair-out: una coppia fa tutto il profitto
        rng = np.random.default_rng(5)
        cj = {}
        for nome in COPPIE:
            per = {}
            for i in range(40 if nome == "EURUSD" else 20):
                R = 1.0 if nome == "EURUSD" else (-0.5 if i % 2 else 0.4)
                per.setdefault("CONT_H1_%s" % ANNI[i % 4], []).append(trade(R, 2000 + int(rng.integers(0, 60))))
            cj[nome] = json_finto(nome, per)
        r = self.calcola(cj)["VERDETTO"]
        self.assertTrue(r["condizioni"]["2_media>0_e_IC90_inf>0"])
        self.assertFalse(r["condizioni"]["4_leave_one_pair_out_media>0"])
        self.assertLess(r["leave_one_pair_out_media_R"]["EURUSD"], 0)
        self.assertGreater(r["leave_one_pair_out_media_R"]["GBPUSD"], 0)
        self.assertNotEqual(r["esito"], "CONFERMATO")
        # (2) IC90 contiene 0 e limite superiore >= 0,05 -> NON DIMOSTRATO
        r = self.calcola(scenario(np.random.default_rng(6), 25, bernoulli(0.5, 1.0, -0.9)))["VERDETTO"]
        self.assertFalse(r["condizioni"]["2_media>0_e_IC90_inf>0"])
        self.assertGreaterEqual(r["ic90"]["ic90_hi"], 0.05)
        self.assertEqual(r["esito"], "NON DIMOSTRATO")

    def test_nessun_vantaggio_rilevante(self):
        # media nettamente negativa, IC90 interamente < 0 < 0,05
        r = self.calcola(scenario(np.random.default_rng(7), 25, bernoulli(0.5, 0.2, -0.8)))["VERDETTO"]
        self.assertLess(r["ic90"]["ic90_hi"], 0)
        self.assertEqual(r["esito"], "NESSUN VANTAGGIO RILEVANTE")
        self.assertEqual(r["esito_lettura_alternativa_letterale"], "NESSUN VANTAGGIO RILEVANTE")

    def test_ambiguita_precedenza_documentata(self):
        # R = +/-0,1 a coppie: media 0 esatta, IC90 ~ (-0,016; +0,016): contiene 0 E limite superiore < 0,05
        cj = {}
        rng = np.random.default_rng(8)
        for nome in COPPIE:
            per = {}
            for i in range(100):
                per.setdefault("CONT_H1_%s" % ANNI[i % 4], []).append(
                    trade(0.1 if i % 2 else -0.1, 2000 + int(rng.integers(0, 80))))
            cj[nome] = json_finto(nome, per)
        V = self.calcola(cj)["VERDETTO"]
        self.assertTrue(V["ic90"]["ic90_lo"] <= 0 <= V["ic90"]["ic90_hi"])
        self.assertLess(V["ic90"]["ic90_hi"], 0.05)
        self.assertAlmostEqual(V["media_R"], 0.0, places=12)
        self.assertEqual(V["esito"], "NESSUN VANTAGGIO RILEVANTE")                  # D010: primario
        self.assertEqual(V["esito_lettura_alternativa_letterale"], "NON DIMOSTRATO")   # ordine di scrittura: solo informativo
        self.assertTrue(V["note"])

    def test_tabella_verdetti_funzione_pura(self):
        ic = {"ic90_lo": 0.02, "ic90_hi": 0.2, "n_replicati": 10000}
        base = dict(N=60, media=0.1, ic=ic, wr_pct=90.0, pareggio_pct=75.0,
                    lopo={"a": 0.1, "b": 0.05}, media_costo_extra=0.05)
        self.assertEqual(AG.verdetto_conferma(**base)["esito"], "CONFERMATO")
        self.assertEqual(AG.verdetto_conferma(**base)["livello_N"], "N>=60")
        self.assertEqual(AG.verdetto_conferma(**dict(base, N=30))["livello_N"], "30<=N<60")
        self.assertEqual(AG.verdetto_conferma(**dict(base, N=29))["esito"], "INCONCLUSIVO")
        self.assertEqual(AG.verdetto_conferma(**dict(base, wr_pct=79.99))["esito"], "NON DIMOSTRATO")
        self.assertEqual(AG.verdetto_conferma(**dict(base, wr_pct=80.0))["esito"], "CONFERMATO")     # >= esatto
        self.assertEqual(AG.verdetto_conferma(**dict(base, lopo={"a": 0.1, "b": 0.0}))["esito"], "NON DIMOSTRATO")
        self.assertEqual(AG.verdetto_conferma(**dict(base, media_costo_extra=0.0))["esito"], "NON DIMOSTRATO")
        self.assertEqual(AG.verdetto_conferma(**dict(base, ic=dict(ic, ic90_lo=0.0)))["esito"], "NON DIMOSTRATO")
        self.assertEqual(AG.verdetto_conferma(**dict(base, media=0.0))["esito"], "NON DIMOSTRATO")
        neg = dict(ic, ic90_lo=-0.3, ic90_hi=-0.1)
        self.assertEqual(AG.verdetto_conferma(**dict(base, media=-0.2, ic=neg))["esito"], "NESSUN VANTAGGIO RILEVANTE")
        # limite superiore esattamente 0,05: NON e < 0,05
        e = AG.verdetto_conferma(**dict(base, media=-0.2, ic=dict(ic, ic90_lo=-0.3, ic90_hi=0.05)))
        self.assertEqual(e["esito"], "NON DIMOSTRATO")
        # D010: IC90 contiene 0 e hi < 0,05 -> NESSUN VANTAGGIO RILEVANTE (alternativa letterale: NON DIMOSTRATO)
        e = AG.verdetto_conferma(**dict(base, media=0.0, ic=dict(ic, ic90_lo=-0.016, ic90_hi=0.016)))
        self.assertEqual((e["esito"], e["esito_lettura_alternativa_letterale"]), ("NESSUN VANTAGGIO RILEVANTE", "NON DIMOSTRATO"))


class TestMetodo(unittest.TestCase):
    def test_bootstrap_identico_a_run_test(self):
        rng = np.random.default_rng(11)
        tr = [{"R": float(rng.normal(0.05, 0.6)), "settimana": 2000 + int(rng.integers(0, 40))} for _ in range(150)]
        a = AG.bootstrap_settimane(tr, 10000, 20261101, 0.05)
        b = RT.bootstrap_settimane(tr, 10000, 20261101, 0.05)
        self.assertEqual(a, b)

    def test_blocchi_settimanali_condivisi_fra_le_coppie(self):
        cj = {}
        for nome in COPPIE:
            per = {"CONT_H1_2015": [trade(0.1, 3000), trade(0.2, 3001)], "INV_H1_2017": [trade(-0.1, 3002 + COPPIE.index(nome))]}
            cj[nome] = json_finto(nome, per)
        r = AG.calcola(cj, ANNI)
        # settimane distinte: 3000, 3001 (comuni alle 4 coppie) + 3002..3005 = 6 blocchi, non 12
        self.assertEqual(r["H_C_pooled_H1"]["bootstrap_settimane"]["settimane"], 6)

    def test_tf_e_varianti_esplorative_separate(self):
        per = {"CONT_H1_2015": [trade(0.5, 3000)], "INV_H1_2015": [trade(-0.5, 3001)],
               "CONT_M30_2015": [trade(1.0, 3002), trade(1.0, 3003)]}
        cj = {n: json_finto(n, per) for n in COPPIE}
        r = AG.calcola(cj, ANNI)
        self.assertEqual(r["H_C_pooled_H1"]["n"], 8)
        self.assertEqual(r["esplorative"]["M30_pooled"]["n"], 8)
        self.assertEqual(r["esplorative"]["M30_pooled"]["media_R"], 1.0)
        self.assertEqual(r["esplorative"]["H1_per_variante"]["CONT"]["n"], 4)
        self.assertEqual(r["esplorative"]["H1_per_variante"]["INV"]["media_R"], -0.5)
        self.assertEqual(r["esplorative"]["H1_per_coppia"]["EURUSD"]["n"], 2)

    def test_pareggio_atteso_dai_trade(self):
        # D=1,0 c=0,01 -> (3+0,01)/(3+1) = 75,25% ; D=2,0 c=0,02 -> 3,02/5 = 60,4% ; media = 67,825%
        per = {"CONT_H1_2015": [trade(0.1, 1, D=1.0, c=0.01), trade(0.1, 2, D=2.0, c=0.02)]}
        cj = {n: json_finto(n, per) for n in COPPIE}
        self.assertAlmostEqual(AG.calcola(cj, ANNI)["H_C_pooled_H1"]["pareggio_atteso_medio_pct"], 67.825, places=9)


class TestIntegrita(unittest.TestCase):
    def cj(self):
        return scenario(np.random.default_rng(2), 25, bernoulli(0.88, 0.33, -1.0))

    def falliti(self, cj, hc=None, anni=ANNI):
        r = AG.calcola(cj, anni, hc)
        return r["VERDETTO"]["controlli_falliti"], r

    def test_input_integro(self):
        f, r = self.falliti(self.cj(), CODICE)
        self.assertEqual(f, [])
        self.assertTrue(r["VERDETTO"]["controlli_integrita_ok"])

    def test_manomissione_dei_trade_e_dello_sha(self):
        cj = self.cj()
        cj["GBPUSD"]["tabelle"]["LOG_TRADE"]["CONT_H1_2015"][0]["R"] += 1.0
        f, _ = self.falliti(cj, CODICE)
        self.assertIn("GBPUSD:sha256_risultati_ricalcolato", f)
        self.assertIn("GBPUSD:log_trade_coerente_con_T2_POOLED_H1", f)

    def test_codice_diverso_da_v2_prova_coppia_mancante_anni_sbagliati(self):
        cj = self.cj()
        hc = dict(CODICE, **{"signals.py": "e" * 64})
        f, r = self.falliti(cj, hc)
        self.assertEqual(sorted(x for x in f if x.endswith("codice_v2_congelato")),
                         sorted("%s:codice_v2_congelato" % n for n in COPPIE))
        self.assertFalse(r["VERDETTO"]["controlli_integrita_ok"])
        cj = self.cj()
        cj["EURJPY"]["intestazione"]["PARAMETRI_NON_CONGELATI_PROVA"] = True
        riallinea(cj["EURJPY"])
        self.assertIn("EURJPY:parametri_congelati_non_di_prova", self.falliti(cj, CODICE)[0])
        cj = self.cj()
        del cj["USDJPY"]
        self.assertIn("quattro_coppie_attese", self.falliti(cj, CODICE)[0])
        f, _ = self.falliti(self.cj(), CODICE, anni=["2013", "2018", "2020", "2025-26"])
        self.assertTrue(all(x.endswith("periodi_attesi") for x in f) and len(f) == 4)
        cj = self.cj()
        cj["EURUSD"]["intestazione"]["disegno"]["SEED"] = 1
        riallinea(cj["EURUSD"])
        self.assertIn("EURUSD:seme_e_replicati_coincidono", self.falliti(cj, CODICE)[0])
        cj = self.cj()
        cj["EURUSD"]["intestazione"]["hash_dati_coincidono"] = {"x.csv": False}
        riallinea(cj["EURUSD"])
        self.assertIn("EURUSD:hash_dati_csv_coincidono", self.falliti(cj, CODICE)[0])

    def test_controlli_non_verificabili_dichiarati(self):
        cj = {n: json_finto(n, {"CONT_H1_2015": [trade(0.1, 1)] * 10}, hash_dati=False) for n in COPPIE}
        r = AG.calcola(cj, ANNI, None)
        self.assertIn("EURUSD:codice_v2_congelato", r["VERDETTO"]["controlli_non_verificabili"])
        self.assertFalse(r["VERDETTO"]["controlli_integrita_ok"])        # un controllo non eseguito non e superato

    def test_formato_reale_di_un_json_di_run_test(self):
        p = os.path.join(HERE, "..", "..", "final", "run_forex", "EURUSD.json")
        if not os.path.exists(p):
            self.skipTest("final/run_forex/EURUSD.json non presente")
        with open(p) as f:
            j = json.load(f)
        self.assertEqual(AG.sha_risultati_json(j), j["sha256_risultati"])
        c = {x["nome"]: x["ok"] for x in AG.controlli_json({"EURUSD": j}, ["2013", "2018", "2020", "2025-26"], None)}
        self.assertTrue(c["EURUSD:sha256_risultati_ricalcolato"])
        self.assertTrue(c["EURUSD:log_trade_coerente_con_T2_POOLED_H1"])
        self.assertTrue(c["EURUSD:periodi_attesi"])
        self.assertTrue(len(AG.estrai_trade(j, "H1")) == j["tabelle"]["T2_risultati"]["POOLED_H1"]["n"])


class TestCLI(unittest.TestCase):
    def test_cli_riproducibile_e_processi_diversi(self):
        cj = scenario(np.random.default_rng(2), 25, bernoulli(0.88, 0.33, -1.0))
        with tempfile.TemporaryDirectory() as d:
            files = []
            for n, j in cj.items():
                p = os.path.join(d, n + ".json")
                with open(p, "w") as f:
                    json.dump(j, f, sort_keys=True)
                files.append("%s=%s" % (n, p))
            hc = os.path.join(d, "HASH_CODICE_V2.txt")
            with open(hc, "w") as f:
                f.write("".join("%s  %s\n" % (v, k) for k, v in CODICE.items()))
            crit = os.path.join(d, "criteri.md")
            with open(crit, "w") as f:
                f.write("criteri finti")
            a = AG.main(["--json"] + files + ["--out", os.path.join(d, "o1"), "--hash-codice", hc, "--criteri", crit])
            b = AG.main(["--json"] + files + ["--out", os.path.join(d, "o2"), "--hash-codice", hc, "--criteri", crit])
            self.assertEqual(a["sha256_risultati"], b["sha256_risultati"])
            self.assertEqual(a["VERDETTO"]["esito"], "CONFERMATO")
            self.assertTrue(a["VERDETTO"]["controlli_integrita_ok"])
            p = subprocess.run([sys.executable, "-I", os.path.join(HERE, "agg_conferma.py"), "--json"] + files +
                               ["--out", os.path.join(d, "o3"), "--hash-codice", hc, "--criteri", crit],
                               capture_output=True, text=True)
            self.assertEqual(p.returncode, 0, p.stderr)          # JSON integri -> codice 0
            with open(os.path.join(d, "o3.json")) as f:
                self.assertEqual(json.load(f)["sha256_risultati"], a["sha256_risultati"])
            with open(os.path.join(d, "o1.md")) as f:
                md = f.read()
            self.assertIn("VERDETTO: CONFERMATO", md)
            self.assertTrue(a["VERDETTO"]["verdetto_valido"])
            self.assertEqual(a["VERDETTO"]["etichetta"], "CONFERMATO")
            self.assertEqual(a["intestazione"]["sha256_criteri_conferma"], hashlib.sha256(b"criteri finti").hexdigest())
            with self.assertRaises(SystemExit):
                AG.main(["--json", files[0], files[0], "--out", os.path.join(d, "x")])


class TestNonValido(unittest.TestCase):
    """D011: integrita non superata -> 'VERDETTO NON VALIDO (integrita)' ovunque e codice di uscita 2."""

    def lancia(self, d, cj, extra=()):
        files = []
        for n, j in cj.items():
            p = os.path.join(d, n + ".json")
            with open(p, "w") as f:
                json.dump(j, f, sort_keys=True)
            files.append("%s=%s" % (n, p))
        hc = os.path.join(d, "HASH_CODICE_V2.txt")
        with open(hc, "w") as f:
            f.write("".join("%s  %s\n" % (v, k) for k, v in CODICE.items()))
        out = os.path.join(d, "out")
        p = subprocess.run([sys.executable, "-I", os.path.join(HERE, "agg_conferma.py"), "--json"] + files +
                           ["--out", out, "--hash-codice", hc] + list(extra), capture_output=True, text=True)
        with open(out + ".json") as f:
            j = json.load(f)
        with open(out + ".md") as f:
            md = f.read()
        return p, j, md

    def test_json_manomesso_non_valido_codice_2(self):
        cj = scenario(np.random.default_rng(2), 25, bernoulli(0.88, 0.33, -1.0))
        cj["GBPUSD"]["tabelle"]["LOG_TRADE"]["CONT_H1_2015"][0]["R"] += 1.0          # sha non riallineato
        with tempfile.TemporaryDirectory() as d:
            p, j, md = self.lancia(d, cj)
        self.assertEqual(p.returncode, 2)
        self.assertIn("VERDETTO NON VALIDO (integrita)", p.stdout)
        self.assertIn("VERDETTO NON VALIDO (integrita)", md.splitlines()[4] + md)
        self.assertFalse(j["VERDETTO"]["verdetto_valido"])
        self.assertEqual(j["VERDETTO"]["etichetta"], "VERDETTO NON VALIDO (integrita)")
        self.assertIn(j["VERDETTO"]["esito"], ("CONFERMATO", "NON DIMOSTRATO", "NESSUN VANTAGGIO RILEVANTE", "INCONCLUSIVO"))
        self.assertIn("GBPUSD:sha256_risultati_ricalcolato", j["VERDETTO"]["controlli_falliti"])

    def test_json_integro_valido_codice_0(self):
        cj = scenario(np.random.default_rng(2), 25, bernoulli(0.88, 0.33, -1.0))
        with tempfile.TemporaryDirectory() as d:
            p, j, md = self.lancia(d, cj)
        self.assertEqual(p.returncode, 0, p.stderr)
        self.assertTrue(j["VERDETTO"]["verdetto_valido"])
        self.assertEqual(j["VERDETTO"]["etichetta"], "CONFERMATO")
        self.assertNotIn("NON VALIDO", md)
        self.assertNotIn("NON VALIDO", p.stdout)

    def test_controllo_non_verificabile_rende_non_valido(self):
        cj = scenario(np.random.default_rng(2), 25, bernoulli(0.88, 0.33, -1.0), hash_dati=False)
        with tempfile.TemporaryDirectory() as d:
            p, j, _ = self.lancia(d, cj)
        self.assertEqual(p.returncode, 2)
        self.assertEqual(j["VERDETTO"]["controlli_falliti"], [])
        self.assertTrue(j["VERDETTO"]["controlli_non_verificabili"])

    def test_docstring_senza_opzioni_inesistenti(self):
        self.assertNotIn("hash-documenti-conferma", AG.__doc__)


if __name__ == "__main__":
    unittest.main(verbosity=2)
