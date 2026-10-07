#!/usr/bin/env python3
# -*- coding: ascii -*-
"""
mutazioni_reader.py -- il COLLAUDO DEL COLLAUDO di leggi_natcla_f0.py: ogni mutante cambia UNA riga del lettore (su una COPIA in una cartella temporanea FUORI dal repo: classe 1159)
e l'autotest del lettore deve diventare ROSSO. Un mutante che passa e' una cosa che l'autotest non vede. Esce 1 se un mutante sopravvive o se la copia non mutata non e' verde.
Uso: python3 -I backtest_pipeline/collaudo_natcla_f0/mutazioni_reader.py
"""
import os, shutil, subprocess, sys, tempfile

QD = os.path.dirname(os.path.abspath(__file__))
REPO = os.path.abspath(os.path.join(QD, "..", ".."))
LETTORE = os.path.join(REPO, "backtest_pipeline", "leggi_natcla_f0.py")
PROVA = os.path.join(REPO, "backtest_pipeline", "prove", "NATCLA_F0_conteggio_2026-10-07.txt")

MUTANTI = [
    ("M01 conta le righe invece degli episodi", 'if int(r["nuovo_ep"]) != 1:\n                continue', 'if False:\n                continue'),
    ("M02 ignora il limite di tocchi", "if lim > 0 and tn > lim:", "if False and tn > lim:"),
    ("M03 contesto alla barra del tocco invece che alla barra PRIMA", 'if int(r["ctx_arm"]) != 0:\n                continue', 'if int(r["ctx_tocco"]) != 0:\n                continue'),
    ("M04 anni dalla data della riga e non dalla barra VERIFICA ADX", 'inizio = rec["adx"][0] if rec["adx"] else datetime.datetime.strptime(sim["da"], "%Y.%m.%d")',
     'inizio = datetime.datetime.strptime(sim["da"], "%Y.%m.%d")'),
    ("M05 vivo con > 70 invece di >= 70", "if n >= VIVO_E0:", "if n > VIVO_E0:"),
    ("M06 tolleranza ADX 0,05 -> 0,07", "if abs(t - e) <= 0.05:", "if abs(t - e) <= 0.07:"),
    ("M07 tolleranza ADX 0,05 -> 0,03", "if abs(t - e) <= 0.05:", "if abs(t - e) <= 0.03:"),
    ("M08 commissione forex x10", '"FX": 0.00004 * lv', '"FX": 0.0004 * lv'),
    ("M09 commissione oro a zero", '"ORO": 0.04', '"ORO": 0.0'),
    ("M10 lavoro con > 40", "if x >= LAVORO_X:", "if x > LAVORO_X:"),
    ("M11 duro con > 13,3", "if x >= DURO_X:", "if x > DURO_X:"),
    ("M12 verdetto di costo sull'ordine PIU VICINO allo stop", "dmax, rmax = max(cand, key=lambda x: x[0])", "dmax, rmax = min(cand, key=lambda x: x[0])"),
    ("M13 cambio orologio 26/12 -> 27/12", "CAMBIO_OROLOGIO_DA = datetime.date(2024, 12, 26)", "CAMBIO_OROLOGIO_DA = datetime.date(2024, 12, 27)"),
    ("M14 cambio orologio 03/02 -> 02/02", "CAMBIO_OROLOGIO_A = datetime.date(2025, 2, 3)", "CAMBIO_OROLOGIO_A = datetime.date(2025, 2, 2)"),
    ("M15 VERIFICA ADX doppia accettata", "    if len(out) != 1:\n        return None\n    return out[0]", "    if not out:\n        return None\n    return out[0]"),
    ("M16 KO del lettore mai assegnato", 'if rec["problemi"]:\n                rec["stato"] = "KO(lettore)"', 'if False:\n                rec["stato"] = "KO(lettore)"'),
    ("M17 passate attese ma assenti non elencate", "mancano = sorted(attese - set(runs))", "mancano = []"),
    ("M18 limiti di tocco del CSV non confrontati", "elif limiti != LIMITI_ATTESI:", "elif False:"),
    ("M19 incoerenza stop_ped mai contata", "if abs(sp - dist / spread) > 0.06 + 0.002 * (dist / spread):", "if False:"),
    ("M20 quantile con posizione sbagliata", "pos = q * (len(v) - 1)", "pos = q * len(v) * 0.99"),
    ("M21 zona dubbia: 26/12 conta come prima", "if dt < CAMBIO_OROLOGIO_DA:", "if dt <= CAMBIO_OROLOGIO_DA:"),
    ("M22 determinismo sempre IDENTICI", '"IDENTICI" if len(set(shas)) == 1 else', '"IDENTICI" if True else'),
    ("M23 banda coerente 0,5 -> 0,4", "BANDA_COERENTE = (0.5, 2.0)", "BANDA_COERENTE = (0.4, 2.0)"),
    ("M24 setup_tocco con ctx != 0", 'if int(r["ctx_tocco"]) == 0:\n                d["setup_tocco"] += 1', 'if int(r["ctx_tocco"]) != 0:\n                d["setup_tocco"] += 1'),
    ("M25 ADX <= 20 diventa < 20", "if adx <= 20.0:", "if adx < 20.0:"),
    ("M26 anni con 365", "return max((a - da).days, 0) / 365.25", "return max((a - da).days, 0) / 365.0"),
    ("M27 AVVIO: TF non controllato", 'if g["tf"] != cfg["periodo"]:', "if False:"),
    ("M28 AVVIO: magic non controllato", 'if g["mg"] != cfg["magic"]:', "if False:"),
    ("M29 AVVIO: linee non controllate", 'if ",".join(g["linee"].split()) != cfg["linee"]:', "if False:"),
    ("M30 AVVIO: solo conta non controllato", 'if g["sc"] != "SI":', "if False:"),
    ("M31 AVVIO: unita non controllata", 'if abs(float(g["u"]) - float(sim["u"])) > 1e-9:', "if False:"),
    ("M32 AVVIO: tipo ADX non controllato", 'if g["tipo"] != "iADX MetaQuotes":', "if False:"),
    ("M33 AVVIO: ADX max/periodo non controllati", 'if float(g["max"]) != 20.0 or int(g["per"]) != 14:', "if False:"),
    ("M34 AVVIO: versione non controllata", 'if g["v"] != VERSIONE_EA:', "if False:"),
    ("M35 VERIFICA ADX: verdetto non confrontato con i numeri", "stampato == ric or adx_al_bordo(stampato, t, e, w)", "True"),
    ("M36 VERIFICA ADX: verdetto 'Wilder' accettato", 'if ver[1] != "MetaQuotes":', "if False:"),
    ("M37 righe CONTA del MANIFEST non confrontate col CSV", 'if int(m["righe_conta"]) != len(righe):', "if False:"),
    ("M38 stato OK senza CSV accettato", 'if not s.ha(cn):\n                    rec["problemi"].append("stato OK ma CSV assente nello zip")', 'if False:\n                    rec["problemi"].append("stato OK ma CSV assente nello zip")'),
    ("M39 n_istanza = barre distinte", 'ris["n_linee"] = sum(d["setup"] for d in ris["linee"].values())', 'ris["n_linee"] = len(ris["barre"])'),
    ("M41 ADX: Wilder atteso uguale a iADX (il contro-esempio non distingue)", "ORO_WILDER_TOCCO = (40.0, 36.0, 36.0)", "ORO_WILDER_TOCCO = (16.0, 18.0, 16.0)"),
    ("M42 ADX: confronto iADX/Wilder rovesciato", 'dm <= dw else', 'dm > dw else'),
    ("M43 spread: costante dichiarato sempre", 'cost = "COSTANTE" if sp["min"] == sp["max"] else "VARIABILE"', 'cost = "COSTANTE"'),
    ("M44 spread: banda coerente 0,5 -> 0,1", "BANDA_SPREAD = (0.5, 2.0)", "BANDA_SPREAD = (0.1, 2.0)"),
    ("M45 spread: riferimento EURUSD 0,2 -> 2,0", '"EURUSD": 0.2, "GBPUSD"', '"EURUSD": 2.0, "GBPUSD"'),
    ("M40 anticipo/linea/profondo: costo con p3 al posto di p1", 'for i, col in enumerate(("p1", "p2", "p3")):', 'for i, col in enumerate(("p3", "p2", "p1")):'),
    ("M46 cartella: backslash dei nomi (Compress-Archive) NON normalizzato", '.replace(os.sep, "/").replace("\\\\", "/")', '.replace(os.sep, "/")'),
    ("M47 cartella: due file diversi con lo stesso nome normalizzato accettati in silenzio",
     'if open(self.reali[nome], "rb").read() != open(vero, "rb").read():', 'if False:'),
]


def esegui(lettore_dir):
    r = subprocess.run([sys.executable, "-I", os.path.join(lettore_dir, "backtest_pipeline", "leggi_natcla_f0.py"), "--autotest"], capture_output=True, text=True, timeout=300)
    return r.returncode, r.stdout[-300:]


def main():
    sorg = open(LETTORE, encoding="ascii").read()
    tmp = tempfile.mkdtemp(prefix="mut_reader_")
    try:
        def prepara(testo):
            d = tempfile.mkdtemp(dir=tmp)
            os.makedirs(os.path.join(d, "backtest_pipeline", "prove"))
            shutil.copy(PROVA, os.path.join(d, "backtest_pipeline", "prove", os.path.basename(PROVA)))
            open(os.path.join(d, "backtest_pipeline", "leggi_natcla_f0.py"), "w", encoding="ascii").write(testo)
            return d
        rc, out = esegui(prepara(sorg))
        print("copia NON mutata: rc %d %s" % (rc, "OK" if rc == 0 else "ROSSA: " + out))
        if rc != 0:
            return 1
        vivi = []
        for nome, a, b in MUTANTI:
            n = sorg.count(a)
            if n != 1:
                print("  ANCORA NON TROVATA o NON UNICA (%d): %s" % (n, nome))
                vivi.append(nome)
                continue
            rc, out = esegui(prepara(sorg.replace(a, b)))
            print("  %s %s" % ("PRESO   " if rc != 0 else "SOPRAVVISSUTO", nome))
            if rc == 0:
                vivi.append(nome)
        print("MUTANTI: %d, presi %d, sopravvissuti %d" % (len(MUTANTI), len(MUTANTI) - len(vivi), len(vivi)))
        return 1 if vivi else 0
    finally:
        shutil.rmtree(tmp, ignore_errors=True)


if __name__ == "__main__":
    sys.exit(main())
