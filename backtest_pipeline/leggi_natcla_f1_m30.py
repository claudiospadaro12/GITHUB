#!/usr/bin/env python3
# -*- coding: ascii -*-
"""
leggi_natcla_f1_m30.py -- LETTURA del lotto NatCla F1 M30 (EA_NatCla v1.12) secondo il file prova
backtest_pipeline/prove/NATCLA_F1_M30_2026-10-11.txt (SHA256 90d67485, PASS del cancello per il LANCIO, commit 9fec3377).

STATO: strumento NUOVO, scritto l'11/10/2026 per leggere UN lotto. NON e' passato dal cancello. Non e' il lettore leggi_natcla_f1.py
(che NON legge la v1.12): ne IMPORTA in sola lettura alcune funzioni gia' passate (Sorgente, leggi_csv, leggi_report, pf_di, dd_r,
p_media, comm_r, nullo_riga) e NON lo modifica. Nessuna soglia e' decisa qui: le soglie sono quelle del file prova, scritte prima dei numeri.

AUTOTEST (classe 1330: l'autotest deve esercitare le grandezze che DECIDONO l'esito): oltre ai numeri sopra controlla sul pilota
  le righe SETUP a rischio 0 e le righe ADOTTATO (P_003: 1 e 1, le altre 0), gli INVIO FALLITO 10018 (29 / 29 / 9 / 5), A0 di P_001 contro se
  stessa (0 righe diverse) e di P_001 contro P_002 (> 0: il confronto morde), la durata mediana esatta (70,0 / 94,85 / 19,95 min, tolleranza
  0,01 min dichiarata, NON l'intero arrotondato).

USO
  python3 backtest_pipeline/leggi_natcla_f1_m30.py <zip o cartella del lotto M30> <zip o cartella del pilota P>
  python3 backtest_pipeline/leggi_natcla_f1_m30.py --autotest <zip o cartella del pilota P>
      (CONTRO-ESEMPIO: le stesse funzioni sul pilota H1 devono ridare i numeri gia' scritti nella prova e nella lettura del pilota:
       f inclinazione 0,493/0,486/0,503/0,156, f ADX 0,356/0,362/0,306, guardia 64/64/55/70, n 144/134/110/92, PF_R 1,32/1,13/0,78,
       nullo 0,93/0,96/0,83, DD_R 6,2/3,7/8,7, durata mediana 70/95/20. Esce 1 se uno non torna.)

DEFINIZIONI (dal file prova, A2 emendata):
  f inclinazione = incl / (incl + dopo + guardia);  f ADX = ADX / (ADX + incl + dopo + guardia)
  dopo = somma degli stadi DOPO l'inclinazione nell'imbuto (confluenza, spread, timing, conferma, ritardo, apertura lontana, semaforo,
         nessun ordine valido, solo conta, ARMATO, ENTRATO); guardia = righe '[NatCla] ... guardia anti-duplicato' del giornale.
         DICHIARATO: 'solo conta' ed 'ENTRATO' entrano nel 'dopo' anche se la prova non li nomina (valgono 0 nel pilota e nel lotto M30:
         SoloConta spento, ENTRATO solo del modo PDF escluso); se un giorno non fossero 0, la scelta va riletta.
  Il campo 'occupata' dell'imbuto contiene anche la guardia: occupata prima dei filtri = occupata - guardia.
"""
import importlib.util, os, re, statistics, sys, math

QD = os.path.dirname(os.path.abspath(__file__))
_spec = importlib.util.spec_from_file_location("lettore_f1", os.path.join(QD, "leggi_natcla_f1.py"))
L = importlib.util.module_from_spec(_spec)
_spec.loader.exec_module(L)

STADI = ["valutate", "linea n/d", "flip", "occupata", "lato spento", "nessun tocco", "episodio gia' usato", "conteggio esaurito", "non vicino",
         "ADX", "inclinazione", "confluenza", "spread", "timing", "conferma", "ritardo", "apertura lontana", "semaforo", "nessun ordine valido",
         "solo conta", "ARMATO", "ENTRATO"]
SIM = {"XAUUSD": {"nome": "XAUUSD", "classe": "ORO", "u": "1.0"}, "EURUSD": {"nome": "EURUSD", "classe": "FX", "u": "0.0001"}}
RE_RIGA = re.compile(r"^(\d{4}\.\d\d\.\d\d \d\d:\d\d:\d\d)\s+(\[(?:NatCla|NATCLA-IMBUTO)\].*)$")


def manifest(src):
    righe = L.decodifica(src.leggi("MANIFEST_F1.csv")).splitlines()
    h = righe[0].split(";")
    return [dict(zip(h, r.split(";"))) for r in righe[1:] if r.strip()]


def giornale(src, tag):
    """righe (ora, messaggio) dell'EA nel log\\<tag>.txt dello zip (gia' deduplicate dal driver)."""
    out = []
    for l in L.decodifica(src.leggi("log/%s.txt" % tag)).splitlines():
        m = RE_RIGA.match(l.rstrip())
        if m:
            out.append((m.group(1), m.group(2)))
    return out


def imbuto(righe):
    tot = {s: 0 for s in STADI}
    nrig = 0
    for _t, msg in righe:
        if not msg.startswith("[NATCLA-IMBUTO]"):
            continue
        nrig += 1
        corpo = msg.split("||")[0]
        for s in STADI:
            m = re.search(r"\| " + re.escape(s) + r" (\d+)", corpo)
            if m:
                tot[s] += int(m.group(1))
    guardia = sum(1 for _t, msg in righe if msg.startswith("[NatCla]") and "guardia anti-duplicato" in msg)
    dopo = sum(tot[s] for s in STADI[STADI.index("inclinazione") + 1:])
    somma = sum(tot[s] for s in STADI[1:])
    fi = tot["inclinazione"] / float(tot["inclinazione"] + dopo + guardia) if (tot["inclinazione"] + dopo + guardia) else float("nan")
    den_a = tot["ADX"] + tot["inclinazione"] + dopo + guardia
    fa = tot["ADX"] / float(den_a) if den_a and tot["ADX"] else (0.0 if den_a else float("nan"))
    return {"tot": tot, "righe": nrig, "guardia": guardia, "dopo": dopo, "quadra": somma == tot["valutate"], "f_incl": fi, "f_adx": fa,
            "f_incl_vecchia": tot["inclinazione"] / float(tot["inclinazione"] + dopo) if (tot["inclinazione"] + dopo) else float("nan"),
            "occupata_pre": tot["occupata"] - guardia}


def eventi(righe):
    """righe ADOTTATO, AVVISO SEMAFORO SFORATO e INVIO FALLITO (per retcode e per ora server) del giornale di una passata."""
    ado = [(o, m) for o, m in righe if m.startswith("[NatCla] ADOTTATO")]
    sem = [(o, m) for o, m in righe if "SEMAFORO SFORATO" in m]
    rc, ore = {}, {}
    for o, m in righe:
        if m.startswith("[NatCla] INVIO FALLITO"):
            k = re.search(r"retcode (\d+)", m).group(1)
            rc[k] = rc.get(k, 0) + 1
            ore[o[11:13]] = ore.get(o[11:13], 0) + 1
    return {"ado": ado, "sem": sem, "rc": rc, "ore": ore, "n_invio": sum(rc.values())}


def a0_diverse(src_a, tag_a, src_b, tag_b):
    """righe 'SETUP;' diverse posizione per posizione fra due CSV (piu' la differenza di lunghezza)."""
    a = [l for l in L.decodifica(src_a.leggi("csv/%s.csv" % tag_a)).splitlines() if l.startswith("SETUP;")]
    b = [l for l in L.decodifica(src_b.leggi("csv/%s.csv" % tag_b)).splitlines() if l.startswith("SETUP;")]
    return sum(1 for x, y in zip(a, b) if x != y) + abs(len(a) - len(b)), len(a), len(b)


def setup(src, tag):
    c = L.leggi_csv(src.leggi("csv/%s.csv" % tag))
    return c


def stat_gamba(src, tag, simbolo):
    """come il lettore passato (calcola): R per setup meno la commissione derivata se il tester NON la addebita."""
    c = setup(src, tag)
    rep = L.leggi_report(src.leggi("report/%s.htm" % tag))
    sim = SIM[simbolo]
    tester_comm = abs(rep.get("commissioni") or 0.0) > 1e-9
    rows = c["setup"]
    seq = sorted((r["barra"], float(r["esito_R"]) - (0.0 if tester_comm else L.comm_r(r, sim)), float(r["durata_min"]), r) for r in rows)
    v = [x[1] for x in seq]
    ew = el = 0.0
    salt = 0
    for x in seq:
        nu = L.nullo_riga(x[3], sim)
        if nu is None:
            salt += 1
        else:
            ew += nu[0]; el += nu[1]
    giorni = {}
    for x in seq:
        giorni[x[0][:10]] = giorni.get(x[0][:10], 0.0) + x[1]
    pp, pn = L.p_media(v)
    r0 = [r for r in rows if not float(r["rischio_soldi"]) > 0]
    return {"n": len(rows), "riempiti": sum(int(r["n_riempiti"]) for r in rows), "soldi": sum(float(r["esito_soldi"]) for r in rows),
            "pf": L.pf_di(v), "media": statistics.mean(v) if v else float("nan"), "pp": pp, "wr": 100.0 * sum(1 for x in v if x > 0) / len(v) if v else float("nan"),
            "dd": L.dd_r(v), "peggio": min(giorni.values()) if giorni else 0.0, "dur": statistics.median([x[2] for x in seq]) if seq else float("nan"),
            "nullo": ew / el if el > 0 else float("nan"), "nullo_saltati": salt, "rischio0": r0, "tester_comm": tester_comm, "rep": rep, "csv": c}


def ffmt(x, d=3):
    return ("%." + str(d) + "f") % x if x == x else "nan"


def autotest(p_path):
    src = L.Sorgente(p_path)
    # (f incl, f ADX, guardia, n, PF_R, nullo, DD_R, durata mediana esatta, righe rischio 0, righe ADOTTATO, INVIO FALLITO 10018)
    att = {"P_001_XAUUSD_AUDIO_H1_LONG_GEOM": (0.493, 0.356, 64, 144, 1.32, 0.93, 6.2, 70.0, 0, 0, 29),
           "P_002_XAUUSD_AUDIO_H1_LONG_PIU": (0.486, 0.362, 64, 134, 1.13, 0.96, 3.7, 94.85, 0, 0, 29),
           "P_003_EURUSD_AUDIO_H1_SHORT_LINEA": (0.503, 0.306, 55, 110, None, None, None, None, 1, 1, 9),
           "P_004_EURUSD_M2_H1_SHORT_GEOM": (0.156, 0.0, 70, 92, 0.78, 0.83, 8.7, 19.95, 0, 0, 5)}
    TOL_DUR = 0.01   # minuti, dichiarata: la mediana si confronta col valore esatto, non con l'intero arrotondato
    falliti = 0
    for tag, (fi, fa, g, n, pf, nu, dd, dur, r0, ado, i18) in att.items():
        righe = giornale(src, tag)
        im = imbuto(righe)
        ev = eventi(righe)
        st = stat_gamba(src, tag, tag.split("_")[2])
        prove = [("f incl", round(im["f_incl"], 3), fi), ("f ADX", round(im["f_adx"], 3), fa), ("guardia", im["guardia"], g), ("n", st["n"], n),
                 ("rischio0", len(st["rischio0"]), r0), ("ADOTTATO", len(ev["ado"]), ado), ("10018", ev["rc"].get("10018", 0), i18)]
        if pf is not None:
            prove += [("PF_R", round(st["pf"], 2), pf), ("nullo", round(st["nullo"], 2), nu), ("DD_R", round(st["dd"], 1), dd), ("durata", st["dur"], dur)]
        for nome, val, exp in prove:
            if nome == "durata":
                ok = abs(val - exp) <= TOL_DUR
            else:
                ok = (abs(val - exp) < 1e-9) if isinstance(exp, float) else (val == exp)
            falliti += 0 if ok else 1
            print("AUTOTEST %-36s %-8s %s atteso %s  %s" % (tag, nome, val, exp, "OK" if ok else "FALLITO"))
        print("         quadratura dell'imbuto %s, righe IMBUTO %d" % ("OK" if im["quadra"] else "ROTTA", im["righe"]))
        falliti += 0 if im["quadra"] else 1
    d0 = a0_diverse(src, "P_001_XAUUSD_AUDIO_H1_LONG_GEOM", src, "P_001_XAUUSD_AUDIO_H1_LONG_GEOM")[0]
    d1 = a0_diverse(src, "P_001_XAUUSD_AUDIO_H1_LONG_GEOM", src, "P_002_XAUUSD_AUDIO_H1_LONG_PIU")[0]
    for nome, ok in (("A0 P_001 contro P_001 = 0 righe diverse (%d)" % d0, d0 == 0), ("A0 P_001 contro P_002 > 0 righe diverse (%d): il confronto morde" % d1, d1 > 0)):
        falliti += 0 if ok else 1
        print("AUTOTEST %-60s %s" % (nome, "OK" if ok else "FALLITO"))
    print("AUTOTEST: %d controlli falliti" % falliti)
    return falliti


def main(m_path, p_path):
    M = L.Sorgente(m_path); P = L.Sorgente(p_path)
    man = manifest(M)
    W = print
    W("== LOTTO M30: MANIFEST ==")
    for r in man:
        W("%s stato %s op %s setup %s riempiti %s soldi %s profitto %s PF(deal) %s ticks %s barre %s durata_s %s invio_fallito %s semaforo %s imbuto_rotte %s avvio %s adx %s finestra %s" % (
            r["passata"], r["stato"], r["trades_report"], r["setup_righe"], r["riempiti_somma"], r["soldi_somma"], r["profitto_report"], r["pf_report"],
            r["ticks_report"], r["barre_gen"], r["durata_s"], r["invio_fallito"], r["semaforo"], r["imbuto_rotte"], r["avvio_ok"], r["adx_verifica"], r["finestra"]))
    tags = [r["passata"] for r in man]
    rif_h1 = {"M30_001_XAUUSD_AUDIO_H1_LONG_GEOM": "P_001_XAUUSD_AUDIO_H1_LONG_GEOM", "M30_002_XAUUSD_AUDIO_M30_LONG_GEOM": "P_001_XAUUSD_AUDIO_H1_LONG_GEOM",
              "M30_003_XAUUSD_AUDIO_M30_LONG_PIU": "P_002_XAUUSD_AUDIO_H1_LONG_PIU", "M30_004_EURUSD_M2_M30_SHORT_GEOM": "P_004_EURUSD_M2_H1_SHORT_GEOM"}
    pman = {r["passata"]: r for r in manifest(P)}
    W("\n== GIORNALE: deviazione dichiarata, ADOTTATO, semaforo, INVIO FALLITO ==")
    G = {}
    for t in tags:
        g = giornale(M, t); G[t] = g
        dev = [m for _o, m in g if m.startswith("[NatCla] CFG InpTF") or m.startswith("[NatCla] CFG InpAmmettiTFSottoH1") or m.startswith("[NatCla] AVVISO DEVIAZIONE")]
        avv = [m for _o, m in g if m.startswith("[NatCla] AVVIO v")]
        ev = eventi(g)
        ado, sem, rc, ore = ev["ado"], ev["sem"], ev["rc"], ev["ore"]
        inv = [None] * ev["n_invio"]
        W("%s: AVVIO %d (%s) | magic %s | righe deviazione: %s" % (t, len(avv), re.search(r"AVVIO v\S+", avv[0]).group(0) if avv else "-",
          re.search(r"magic (\d+)", avv[0]).group(1) if avv else "-", " || ".join(x[9:80] for x in dev)))
        W("   ADOTTATO %d %s | SEMAFORO SFORATO %d | INVIO FALLITO %d per retcode %s per ora %s" % (len(ado), [o for o, _m in ado], len(sem), len(inv), rc, dict(sorted(ore.items()))))
    W("\n== A0: controllo H1 M30_001 contro P_001 del pilota ==")
    diverse, na, nb = a0_diverse(M, "M30_001_XAUUSD_AUDIO_H1_LONG_GEOM", P, "P_001_XAUUSD_AUDIO_H1_LONG_GEOM")
    W("righe SETUP: M30_001 %d, P_001 %d, righe diverse (posizione per posizione, piu' la differenza di lunghezza) %d" % (na, nb, diverse))
    W("ticks: M30_001 %s, P_001 %s; operazioni %s / %s; barre %s / %s" % (pman and man[0]["ticks_report"], pman["P_001_XAUUSD_AUDIO_H1_LONG_GEOM"]["ticks_report"],
      man[0]["trades_report"], pman["P_001_XAUUSD_AUDIO_H1_LONG_GEOM"]["trades_report"], man[0]["barre_gen"], pman["P_001_XAUUSD_AUDIO_H1_LONG_GEOM"]["barre_gen"]))
    ga = {(o, m.replace("AVVIO v1.12", "AVVIO v1.11")) for o, m in G["M30_001_XAUUSD_AUDIO_H1_LONG_GEOM"]}
    gb = set(giornale(P, "P_001_XAUUSD_AUDIO_H1_LONG_GEOM"))
    W("giornale (ora + messaggio, con 'AVVIO v1.12'->'v1.11'): solo in M30_001 %d %s ; solo in P_001 %d %s" % (
      len(ga - gb), [x[1][:90] for x in sorted(ga - gb)][:5], len(gb - ga), [x[1][:90] for x in sorted(gb - ga)][:5]))
    W("\n== A1/A2/A3/A5/A6/A7 per passata (M30 contro la passata H1 di riferimento del pilota) ==")
    for t in tags:
        sym = t.split("_")[2]
        st = stat_gamba(M, t, sym); im = imbuto(G[t])
        ph = rif_h1[t]; sth = stat_gamba(P, ph, ph.split("_")[2]); imh = imbuto(giornale(P, ph))
        r = [x for x in man if x["passata"] == t][0]; rh = pman[ph]
        W("%s  (rif. H1 %s)" % (t, ph))
        W("   n %d (H1 %d) rapporto %.3f | riempiti %d riempiti/setup %.3f | Poisson 95%% n %.0f-%.0f" % (st["n"], sth["n"], st["n"] / float(sth["n"]), st["riempiti"],
          st["riempiti"] / float(st["n"]), st["n"] - 1.96 * math.sqrt(st["n"]), st["n"] + 1.96 * math.sqrt(st["n"])))
        W("   righe SETUP con rischio_soldi <= 0: %d %s" % (len(st["rischio0"]), [(x["barra"], x["linea"], x["esito_soldi"], x["esito_R"]) for x in st["rischio0"]]))
        W("   imbuto: righe %d quadratura %s valutate %d ADX %d incl %d dopo %d guardia %d occupata %d (prima dei filtri %d) | f incl %s (vecchia def %s, H1 %s) | f ADX %s (H1 %s)" % (
          im["righe"], "OK" if im["quadra"] else "ROTTA", im["tot"]["valutate"], im["tot"]["ADX"], im["tot"]["inclinazione"], im["dopo"], im["guardia"], im["tot"]["occupata"],
          im["occupata_pre"], ffmt(im["f_incl"]), ffmt(im["f_incl_vecchia"]), ffmt(imh["f_incl"]), ffmt(im["f_adx"]), ffmt(imh["f_adx"])))
        W("   stadi: %s" % {k: v for k, v in im["tot"].items() if v})
        if im["f_incl"] == im["f_incl"] and imh["f_incl"] < 1:
            prev = sth["n"] * 2.0 * (1.0 - im["f_incl"]) / (1.0 - imh["f_incl"])
            W("   controllo incrociato: n previsto %.1f (= %d x 2 x (1-%.3f)/(1-%.3f)), scarto %.1f%%" % (prev, sth["n"], im["f_incl"], imh["f_incl"], 100.0 * (st["n"] - prev) / prev))
        W("   PF_R %s (H1 %s) nullo %s (H1 %s, saltati %d) media R %s p(>0) %s WR %s%% DD_R %s peggior giorno %s | commissione tester %s" % (
          ffmt(st["pf"], 2), ffmt(sth["pf"], 2), ffmt(st["nullo"], 2), ffmt(sth["nullo"], 2), st["nullo_saltati"], ffmt(st["media"], 3),
          ffmt(st["pp"], 3) if st["pp"] is not None else "-", ffmt(st["wr"], 1), ffmt(st["dd"], 1), ffmt(st["peggio"], 2), st["tester_comm"]))
        W("   durata mediana %s min (H1 %s) rapporto %.2f | secondi %s (H1 %s) rapporto %.2f" % (ffmt(st["dur"], 1), ffmt(sth["dur"], 1), st["dur"] / sth["dur"],
          r["durata_s"], rh["durata_s"], float(r["durata_s"]) / float(rh["durata_s"])))
        W("   colla: operazioni %s - riempiti %d = %d | profitto %s - soldi %.2f = %.2f | report PF %s profitto %s commissioni %s" % (
          r["trades_report"], st["riempiti"], int(r["trades_report"]) - st["riempiti"], r["profitto_report"], st["soldi"], float(r["profitto_report"]) - st["soldi"],
          st["rep"]["pf"], st["rep"]["profitto"], st["rep"].get("commissioni")))
    return 0


if __name__ == "__main__":
    if len(sys.argv) == 3 and sys.argv[1] == "--autotest":
        sys.exit(1 if autotest(sys.argv[2]) else 0)
    if len(sys.argv) != 3:
        print(__doc__); sys.exit(2)
    sys.exit(main(sys.argv[1], sys.argv[2]))
