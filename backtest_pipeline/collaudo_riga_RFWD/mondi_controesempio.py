#!/usr/bin/env python3
# -*- coding: ascii -*-
"""
mondi_controesempio.py -- i CONTROESEMPI del confronto forward/tester, costruiti PRIMA di guardare un numero vero.

Regola di casa (CLAUDE.md, 10/09/2026): prima di consegnare uno strumento si costruisce il mondo che lo farebbe
sbagliare e si fa vedere che non sbaglia. Qui si fabbricano CINQUE testers finti partendo dal forward vero
(le uscite del forward convertite in ora BCM e scritte come per-trade) e si controlla che la lettura meccanica di
confronto_forward_tester.py dica la cosa giusta in ognuno:

  A  TESTER FEDELE       (uscite identiche, prezzo +3 punti)          -> H_FEDELI, L1 su tutte
  B  OROLOGIO SFASATO +60 (stesse operazioni, ore +1 ora)             -> NON H_FEDELI; H_DIVERSI_ORARI; L1 = 0, L2 = tutte
  C  TESTER VUOTO        (per-trade con la sola intestazione)         -> H_DIVERSI_FREQ (F_SOLO = tutte)
  D  TESTER INDIPENDENTE (stesso numero di posizioni, giorni/ore a caso) -> NON H_FEDELI (la banda non lo accetta)
  E  TESTER CON GEMELLO DIVERSO (G1 rosso)                             -> la sedia esce da ogni conteggio
  F  TESTER DOPPIO       (le operazioni vere + altrettante in giorni senza forward) -> T_SOLO senza ordine forward alto,
                                                                          NON H_FEDELI
Esegue anche il conteggio dei 'giorni' e verifica che le posizioni fuori finestra (770105 prima del 28/09, oltre l'ultimo
evento del forward, giorno di avvio) NON entrino nei conteggi.

Uso: python3 backtest_pipeline/collaudo_riga_RFWD/mondi_controesempio.py
Esce 0 se tutti i mondi tornano.
"""
import datetime, os, random, sys, tempfile

QD = os.path.dirname(os.path.abspath(__file__))
REPO = os.path.abspath(os.path.join(QD, "..", ".."))
sys.path.insert(0, os.path.join(REPO, "backtest_pipeline"))
import confronto_forward_tester as CF

XLSX = os.path.join(REPO, "data", "statements", "FTMO_541452707_cronistorico_2026-09-30.xlsx")
HDR = "close_time;symbol;magic;position_id;deal_type;volume;price;net_profit"
FALLITI = []


def check(cond, nome):
    print(("PASS  " if cond else "FALLITO ") + nome)
    if not cond:
        FALLITI.append(nome)


def scrivi_pertrade(cartella, sedia, righe, magic=None):
    nome = "abtg_trades_%s_%s_%d.csv" % (sedia["ea"], sedia["sim_t"], magic or sedia["magic"])
    with open(os.path.join(cartella, nome), "w", newline="") as f:
        f.write(HDR + "\r\n")
        for r in righe:
            f.write(";".join(str(x) for x in r) + "\r\n")


def righe_da_forward(Fpos, sedia, shift_min=0, dprezzo=0.0):
    """Le uscite (gambe) del forward, in ora BCM, come righe di per-trade."""
    out = []
    for k, p in enumerate(sorted(Fpos, key=lambda x: x["t"]), start=2):
        for g in p["legs"]:
            t = g["t"] + datetime.timedelta(minutes=shift_min)
            out.append([t.strftime("%Y.%m.%d %H:%M:%S"), sedia["sim_t"], sedia["magic"], k * 2, (1 if p["dir"] == "L" else 0),
                        "%.2f" % g["v"], "%.2f" % (g["p"] + dprezzo), "%.2f" % g["net"]])
    return out


def mondo(nome, fw, cutoff, righe_per_sedia, twin_diverso=()):
    d = tempfile.mkdtemp(prefix="rfwd_")
    for s in CF.SEDIE:
        righe = righe_per_sedia.get(s["id"], [])
        scrivi_pertrade(d, s, righe)
        tw = [list(r) for r in righe]
        for r in tw:
            r[2] = s["twin"]
        if s["id"] in twin_diverso and tw:
            tw[0][6] = "%.2f" % (float(tw[0][6]) + 5.0)
        scrivi_pertrade(d, s, tw, magic=s["twin"])
    tester = CF.carica_tester(d)
    conf = CF.esegui_confronto(fw, tester, 2, cutoff, dict(CF.COSTANTI), 300)
    testo, gg, cp, S = CF.scrivi_report(conf, dict(CF.COSTANTI), 300)
    return conf, S, testo


def main():
    fw = CF.parse_forward(CF.leggi_xlsx(XLSX))
    cutoff = fw["ultimo_evento"]
    Fpos, _man, _note = CF.posizioni_forward(fw, 2, CF.COSTANTI["SALDO_INIZIALE"])
    per = {}
    for p in Fpos:
        per.setdefault(p["sedia"], []).append(p)
    nF = len(Fpos)
    check(nF == 11, "premessa: 11 posizioni forward di sedia")

    # A fedele
    rg = {s["id"]: righe_da_forward(per.get(s["id"], []), s, 0, 3.0) for s in CF.SEDIE}
    conf, S, _t = mondo("A", fw, cutoff, rg)
    check(S["nF"] == 11 and S["L1"] == 11 and S["L2"] == 11 and S["fedeli"] and not S["orari"] and not S["freq"],
          "A tester fedele: 11/11 L1, H_FEDELI, niente altro (L1=%d L2=%d T_solo_b=%d)" % (S["L1"], S["L2"], S["T_solo_b"]))
    # A2: R e esiti UGUALI sulle coppie (stesso netto -> stesso R nominale? il saldo tester e' per-sedia, tolleranza 0.25)
    ug = di = 0
    for r in conf["risultati"]:
        for (i, j, lv, n) in r["ab"]["coppie"]:
            f, t = r["F"][i], r["T"][j]
            if f["tipo_u"] == t["tipo_u"] and abs(t["R"] - f["R"]) <= CF.COSTANTI["TOL_R"]:
                ug += 1
            else:
                di += 1
    check(ug == 11 and di == 0, "A2 esito e R uguali su tutte le coppie (uguali=%d diverse=%d): il saldo per-sedia del tester non rompe la tolleranza" % (ug, di))

    # B orologio +60
    rg = {s["id"]: righe_da_forward(per.get(s["id"], []), s, 60, 0.0) for s in CF.SEDIE}
    conf, S, _t = mondo("B", fw, cutoff, rg)
    # attenzione: uscite spostate di +60 min possono finire dopo l'ultimo evento del forward (30/09 10:03 FTMO = 08:03 BCM): la 770411 del 30/09 esce alle 08:03 BCM
    check(S["L1"] == 0 and not S["fedeli"], "B orologio +60: nessuna L1 e NON H_FEDELI (L1=%d L2=%d)" % (S["L1"], S["L2"]))
    check(S["orari"] or S["L2"] < 0.5 * S["nF"], "B orologio +60: H_DIVERSI_ORARI oppure (uscite spostate oltre il taglio del forward) L2 bassa: orari=%s L2=%d/%d mediana=%s" %
          (S["orari"], S["L2"], S["nF"], S["mediana_delta_min"]))
    if S["mediana_delta_min"] is not None:
        check(abs(S["mediana_delta_min"] - 60.0) < 1.0, "B la mediana dello scarto L2 vale 60 minuti (%.1f)" % S["mediana_delta_min"])
    # B2: la 770411 del 30/09 esce a 08:03:09 BCM; +60 min = 09:03 > cutoff 08:03:09 -> ESCLUSA dal confronto (non e' T_solo)
    r411 = [r for r in conf["risultati"] if r["sedia"]["id"] == "770411"][0]
    check(any("oltre l'ultimo evento" in m for (_x, m) in r411["esclusi"]), "B2 un'uscita del tester oltre l'ultimo evento del forward e' ESCLUSA, non T_SOLO")

    # C vuoto
    rg = {s["id"]: [] for s in CF.SEDIE}
    conf, S, _t = mondo("C", fw, cutoff, rg)
    check(S["L2"] == 0 and S["freq"] and not S["fedeli"], "C tester vuoto: L2=0, H_DIVERSI_FREQ (L2=%d freq=%s)" % (S["L2"], S["freq"]))

    # D indipendente: stesse quantita' per sedia, giorni e ore a caso
    rng = random.Random(7)
    giorni = CF.giorni_feriali(datetime.date(2026, 9, 22), datetime.date(2026, 9, 29))
    peggiori = 0
    esiti_fedeli = 0
    for tentativo in range(40):
        rg = {}
        for s in CF.SEDIE:
            n = len(per.get(s["id"], []))
            righe = []
            for k in range(n):
                g = rng.choice(giorni)
                lo, hi = ((0, 24) if s["chiusura_bcm"] is None else (8, 17))
                t = datetime.datetime(g.year, g.month, g.day) + datetime.timedelta(seconds=rng.randint(lo * 3600, hi * 3600 - 1))
                base = per[s["id"]][k]
                righe.append([t.strftime("%Y.%m.%d %H:%M:%S"), s["sim_t"], s["magic"], 2 * (k + 2), (1 if s["dir"] == "L" or (s["dir"] == "LS" and base["dir"] == "L") else 0), "1.00", "%.2f" % base["p"], "0.00"])
            rg[s["id"]] = righe
        _c, Sx, _tx = mondo("D", fw, cutoff, rg)
        esiti_fedeli += 1 if Sx["fedeli"] else 0
    check(esiti_fedeli == 0, "D tester INDIPENDENTE (40 mondi a caso): H_FEDELI scatta %d volte su 40 (deve essere 0 per una banda che discrimina)" % esiti_fedeli)

    # E gemello diverso
    rg = {s["id"]: righe_da_forward(per.get(s["id"], []), s, 0, 0.0) for s in CF.SEDIE}
    conf, S, testo = mondo("E", fw, cutoff, rg, twin_diverso=("770411",))
    r411 = [r for r in conf["risultati"] if r["sedia"]["id"] == "770411"][0]
    check(not r411["tester"]["g1_ok"] and S["nF"] == 8, "E gemello diverso: la 770411 e' NULLA (G1 rosso) ed esce dal conto (nF=%d, attese 8)" % S["nF"])
    check("G1 ROSSO" in testo, "E il report lo dice a chiare lettere")

    # F doppio: le vere + altrettante in giorni senza forward
    rg = {}
    for s in CF.SEDIE:
        base = righe_da_forward(per.get(s["id"], []), s, 0, 0.0)
        extra = []
        for k, p in enumerate(per.get(s["id"], [])):
            # stesso orario ma un giorno feriale diverso, senza posizione forward di quella sedia
            occupati = {q["t"].date() for q in per.get(s["id"], [])}
            for g in giorni:
                if g not in occupati:
                    t = datetime.datetime(g.year, g.month, g.day, p["t"].hour, p["t"].minute)
                    extra.append([t.strftime("%Y.%m.%d %H:%M:%S"), s["sim_t"], s["magic"], 1000 + k, (1 if p["dir"] == "L" else 0), "1.00", "%.2f" % p["p"], "0.00"])
                    occupati.add(g)
                    break
        rg[s["id"]] = base + extra
    conf, S, _t = mondo("F", fw, cutoff, rg)
    check((S["T_solo_a"] + S["T_solo_b"]) >= 0.9 * S["nF"] and S["T_solo_b"] > CF.COSTANTI["H_FEDELI_TSOLO_B_MAX"] * S["nF"] and not S["fedeli"],
          "F tester doppio: T_SOLO %d (di cui %d con un pendente forward non riempito quel giorno, %d senza nessun ordine) su %d forward, NON H_FEDELI" %
          (S["T_solo_a"] + S["T_solo_b"], S["T_solo_a"], S["T_solo_b"], S["nF"]))

    # G finestra: 770105 prima del 28/09 e giorno di avvio non contano
    rg = {s["id"]: righe_da_forward(per.get(s["id"], []), s, 0, 0.0) for s in CF.SEDIE}
    rg["770105"] = rg["770105"] + [["2026.09.23 08:30:00", "D30EUR", 793605, 900, 0, "1.00", "25000.00", "1.00"]]
    rg["770101"] = rg["770101"] + [["2026.09.21 09:10:00", "D30EUR", 793601, 901, 1, "1.00", "25000.00", "1.00"]]
    conf, S, _t = mondo("G", fw, cutoff, rg)
    r105 = [r for r in conf["risultati"] if r["sedia"]["id"] == "770105"][0]
    r101 = [r for r in conf["risultati"] if r["sedia"]["id"] == "770101"][0]
    check(any("NON ancora attaccata" in m for (_x, m) in r105["esclusi"]) and S["T_solo_b"] == 0,
          "G la 770105 del tester il 23/09 (sedia non ancora viva) e' esclusa, non T_SOLO")
    check(any("GIORNO DI AVVIO" in m for (_x, m) in r101["esclusi"]), "G una posizione del tester il 21/09 e' GIORNO DI AVVIO, non contata")

    # H controesempio della BANDA sul FORWARD VERO: soglie H_FEDELI contro il nullo per nT = nF e nT = 2 nF
    dati1 = []
    dati2 = []
    conf_ref, _S, _t = mondo("A", fw, cutoff, {s["id"]: righe_da_forward(per.get(s["id"], []), s, 0, 0.0) for s in CF.SEDIE})
    for r in conf_ref["risultati"]:
        if not r["F"]:
            continue
        orario = (0, 24) if r["sedia"]["chiusura_bcm"] is None else (8, 17)
        dati1.append(dict(F=r["F"], nT=len(r["F"]), giorni=r["giorni"], orario=orario))
        dati2.append(dict(F=r["F"], nT=2 * len(r["F"]), giorni=r["giorni"], orario=orario))
    n1 = CF.simula_nullo(dati1, 4000, 20260930, 15)
    n2 = CF.simula_nullo(dati2, 4000, 20260930, 15)
    print("NULLO (tester indipendente, nT = nF):   L1 media %.3f p95 %.3f | L1+L2 media %.3f p95 %.3f" % n1)
    print("NULLO (tester indipendente, nT = 2 nF): L1 media %.3f p95 %.3f | L1+L2 media %.3f p95 %.3f" % n2)
    check(CF.COSTANTI["H_FEDELI_L1_MIN"] > n2[1], "H la soglia L1 di H_FEDELI (%.2f) sta SOPRA il p95 del nullo anche con tester doppio (%.3f)" % (CF.COSTANTI["H_FEDELI_L1_MIN"], n2[1]))
    check(CF.COSTANTI["H_FEDELI_L2_MIN"] > n1[3], "H la soglia L1+L2 di H_FEDELI (%.2f) sta SOPRA il p95 del nullo con nT = nF (%.3f)" % (CF.COSTANTI["H_FEDELI_L2_MIN"], n1[3]))
    print("NOTA: con nT = 2 nF il p95 di L1+L2 e' %.3f: se sta sopra la soglia L2 (%.2f) quel ramo NON discrimina da solo; e' per questo che H_FEDELI chiede ANCHE L1 >= %.2f e T_SOLO<=%.2f." %
          (n2[3], CF.COSTANTI["H_FEDELI_L2_MIN"], CF.COSTANTI["H_FEDELI_L1_MIN"], CF.COSTANTI["H_FEDELI_TSOLO_B_MAX"]))

    print("MONDI:", "TUTTI OK" if not FALLITI else "FALLITI: %s" % FALLITI)
    sys.exit(0 if not FALLITI else 1)


if __name__ == "__main__":
    main()
