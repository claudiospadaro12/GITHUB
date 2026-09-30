#!/usr/bin/env python3
# -*- coding: ascii -*-
"""
genera_prove.py -- scrive i 6 file prova della riga diagnostica R92BAB a partire da DUE file gia' nel repo e verifica a macchina
che cambi SOLO cio' che deve cambiare (classe 178: prima il controesempio, poi la consegna).
  - P (controllo positivo) da prove/RFWD_770101_DAX_RETEST_long.txt: cambiano SOLO la finestra (@DAQUANDO/@FINOA/@FRAZIONEIS) e il magic.
  - A, B, C, D, A2 da prove/R92be_cella_AMPIA.txt (la cella AMPIA del preset del piccolo): cambiano SOLO @DAQUANDO/@FINOA/@FRAZIONEIS,
    InpMagic e Symbols_List.
Uso: python3 backtest_pipeline/collaudo_riga_R92BAB/genera_prove.py [--verifica]   (--verifica: non scrive, confronta con i file in repo)
"""
import os, re, sys
QD = os.path.dirname(os.path.abspath(__file__))
REPO = os.path.abspath(os.path.join(QD, "..", ".."))
PR = os.path.join(REPO, "backtest_pipeline", "prove")
C22 = "EURUSD,GBPUSD,AUDUSD,NZDUSD,USDCAD,USDCHF,USDJPY,EURGBP,EURNZD,GBPJPY,GBPAUD,GBPCAD,GBPNZD,AUDJPY,AUDCAD,AUDNZD,NZDJPY,NZDCAD,NZDCHF,CADJPY,CADCHF,CHFJPY"
C8 = "EURUSD,GBPUSD,AUDUSD,NZDUSD,USDCAD,USDCHF,USDJPY,EURGBP"
C8L = ("," + " " * 14).join(C8.split(",")[:])          # 8 simboli, 14 spazi DOPO ogni virgola (7 virgole = 98 spazi) -> 55 + 98 = 153
assert len(C22) == 153 and len(C8) == 55 and len(C8L) == 153 and C8L.replace(" ", "") == C8 and not C8L.endswith(" ") and not C8L.startswith(" ")
JOBS = [
 # file, etichetta, magic, symbols, titolo breve
 ("R92BAB_A_cross22.txt", "R92BAB_A", (799401, 799451), C22, "A: i 22 cross completi, stringa lunga 153 caratteri"),
 ("R92BAB_B_GBPUSD.txt", "R92BAB_B", (799411, 799461), "GBPUSD", "B: UN simbolo (GBPUSD), stringa lunga 6 caratteri"),
 ("R92BAB_C_cross8.txt", "R92BAB_C", (799421, 799471), C8, "C: 8 cross, stringa lunga 55 caratteri (sotto il limite di 63)"),
 ("R92BAB_D_cross8_largo.txt", "R92BAB_D", (799431, 799481), C8L, "D: GLI STESSI 8 cross di C, ma la stringa e' lunga 153 caratteri (14 spazi dopo ogni virgola: l'EA taglia gli spazi di ogni simbolo)"),
 ("R92BAB_A2_cross22_replica.txt", "R92BAB_A2", (799441, 799491), C22, "A2: REPLICA di A (stessi input, solo il magic diverso), a fine giro: separa un guasto dell'EA da uno di avvio"),
]
W = ("2026.03.02", "2026.06.30", "0.5")   # 120 giorni, floor(120*0.5)=60 -> Meta 2026.05.01: IS 03.02-05.01, OOS 05.02-06.30 (fine esclusiva)
WP = ("2026.08.03", "2026.09.01", "0.5")  # P: 29 giorni, floor(29*0.5)=14 -> Meta 2026.08.17: IS 08.03-08.17, OOS 08.18-09.01
MAGP = (799501, 799551)

def leggi(p):
    return open(os.path.join(PR, p), encoding="ascii", newline="").read().replace("\r\n", "\n").split("\n")

def inputs(lines):
    d = {}
    for l in lines:
        t = l.strip()
        m = re.match(r"^([A-Za-z][A-Za-z0-9_]*)=(.*)$", t)
        if m and not t.startswith("#"):
            d[m.group(1)] = m.group(2)
    return d

def direttive(lines):
    d = {}
    for l in lines:
        m = re.match(r"^@(\w+)\s+(.+)$", l.strip())
        if m:
            d[m.group(1).upper()] = m.group(2).strip()
    return d

def costruisci():
    out = {}
    base = leggi("R92be_cella_AMPIA.txt")
    ib = inputs(base)
    assert ib["Symbols_List"] == C22, "la lista dei 22 cross di R92be non e quella attesa"
    # il corpo: dalla prima riga dopo le direttive
    i0 = next(i for i, l in enumerate(base) if l.startswith("@SIMBOLO"))
    corpo = base[i0:]
    for (fn, lbl, mg, sy, tit) in JOBS:
        r = []
        r.append("# =====================================================================")
        r.append("#  EA: ABTG_Bulge")
        r.append("#  %s -- RIGA DIAGNOSTICA R92BAB, job %s" % (lbl, tit))
        r.append("#  Sblocca R92b: i due lanci del 30/09/2026 sono morti con 'OnTesterInit works too long / Tester cannot be initialized'.")
        r.append("#  NON misura il merito: serve a vedere se il tester PARTE. Criteri scritti PRIMA: report/R92B_DIAGNOSI_CRITERI.md.")
        r.append("#  Cella = l'AMPIA di R92be (preset mql5/Presets/sedie_piccolo/ABTG_Bulge_v520_piccolo_AMPIO.set), ABTG_Bulge v5.20 NON modificato.")
        r.append("#  Modello 1 (OHLC M1), deposito 10000 (li passa la riga). H1, GBPUSD come grafico. Gira SOLO sul PC di backtest DESKTOP-H4D7CAJ.")
        r.append("#  DIFFERENZE DA prove/R92be_cella_AMPIA.txt, TUTTE (verificate a macchina da genera_prove.py):")
        r.append("#   - finestra CORTA: @DAQUANDO %s @FINOA %s @FRAZIONEIS %s (IS %s-2026.05.01, OOS 2026.05.02-%s, fine esclusiva)" % (W[0], W[1], W[2], W[0], W[1]))
        r.append("#   - InpMagic: asse tecnico %d||%d||50||%d||Y (due celle gemelle, serve perche' con zero assi il driver non esegue passate)" % (mg[0], mg[0], mg[1]))
        r.append("#   - Symbols_List: %d caratteri, %d simboli (l'UNICA variabile del disegno A/B/C/D; R92be ne ha 22 e 153 caratteri)" % (len(sy), len(sy.replace(" ", "").split(","))))
        r.append("# =====================================================================")
        for l in corpo:
            if l.startswith("@DAQUANDO"):
                r.append("@DAQUANDO   " + W[0])
            elif l.startswith("@FINOA"):
                r.append("@FINOA      " + W[1])
            elif l.startswith("@FRAZIONEIS"):
                r.append("@FRAZIONEIS " + W[2])
            elif l.startswith("InpMagic="):
                r.append("InpMagic=%d||%d||50||%d||Y" % (mg[0], mg[0], mg[1]))
            elif l.startswith("Symbols_List="):
                r.append("Symbols_List=" + sy)
            else:
                r.append(l)
        out[fn] = "\n".join(r)
    # P: controllo positivo, dal file prova di 770101 che oggi (30/09) ha girato 2 passate x 2 gambe senza il guasto
    rf = leggi("RFWD_770101_DAX_RETEST_long.txt")
    ir = inputs(rf)
    j0 = next(i for i, l in enumerate(rf) if l.startswith("@SIMBOLO"))
    r = []
    r.append("# =====================================================================")
    r.append("#  EA: ABTG_DAX_Apertura_EU_Pin9fca")
    r.append("#  R92BAB_P -- CONTROLLO POSITIVO della riga diagnostica R92BAB: il file prova di 770101 (prove/RFWD_770101_DAX_RETEST_long.txt),")
    r.append("#  che il 30/09/2026 alle 21:03 ha girato in questo tester (2 passate x 2 gambe) senza il guasto OnTesterInit.")
    r.append("#  Serve a una cosa sola: se P non parte, il tester di questo PC e' guasto ADESSO e nessun verdetto su A/B/C/D vale.")
    r.append("#  NON e' un confronto col forward FTMO e NON misura il merito. Tick reali (Modello 4), deposito 80000 (lo passa la riga).")
    r.append("#  DIFFERENZE DA RFWD_770101_DAX_RETEST_long.txt, TUTTE (verificate da genera_prove.py): @DAQUANDO/@FINOA/@FRAZIONEIS (finestra tutta nel")
    r.append("#  passato, cosi' il tester non la taglia a 'oggi') e il magic (asse tecnico %d||%d||50||%d||Y: magic nuovi = nessuna passata ripescata" % (MAGP[0], MAGP[0], MAGP[1]))
    r.append("#  dalla cache del tester). I 82 input della foto del campo sono identici.")
    r.append("# =====================================================================")
    for l in rf[j0:]:
        if l.startswith("@DAQUANDO"):
            r.append("@DAQUANDO   " + WP[0])
        elif l.startswith("@FINOA"):
            r.append("@FINOA      " + WP[1])
        elif l.startswith("@FRAZIONEIS"):
            r.append("@FRAZIONEIS " + WP[2])
        elif l.startswith("InpMagic="):
            r.append("InpMagic=%d||%d||50||%d||Y" % (MAGP[0], MAGP[0], MAGP[1]))
        else:
            r.append(l)
    out["R92BAB_P_controllo_positivo.txt"] = "\n".join(r)
    return out

def verifica(out):
    base = leggi("R92be_cella_AMPIA.txt"); ib = inputs(base); db = direttive(base)
    for (fn, lbl, mg, sy, tit) in JOBS:
        L = out[fn].split("\n"); i = inputs(L); d = direttive(L)
        diff = sorted(k for k in set(i) | set(ib) if i.get(k) != ib.get(k))
        assert diff == ["InpMagic", "Symbols_List"] or (sy == C22 and diff == ["InpMagic"]), (fn, diff)
        assert len(i) == len(ib) == 50, (fn, len(i), len(ib))
        assert i["Symbols_List"] == sy and len(i["Symbols_List"]) == len(sy)
        assert d["SIMBOLO"] == "GBPUSD" and d["PERIODO"] == "H1" and (d["DAQUANDO"], d["FINOA"], d["FRAZIONEIS"]) == W, (fn, d)
        assert set(d) == set(db), (fn, d, db)
        assert i["InpMagic"] == "%d||%d||50||%d||Y" % (mg[0], mg[0], mg[1])
        assert i["InpVerbose"] == "0" and i["InpAutoTest"] == "0" and i["InpComment"] == "BULGE_V520A"
        for k in ib:
            if k not in ("InpMagic", "Symbols_List"):
                assert i[k] == ib[k], (fn, k)
    rf = leggi("RFWD_770101_DAX_RETEST_long.txt"); ir = inputs(rf)
    L = out["R92BAB_P_controllo_positivo.txt"].split("\n"); i = inputs(L); d = direttive(L)
    diff = sorted(k for k in set(i) | set(ir) if i.get(k) != ir.get(k))
    assert diff == ["InpMagic"], diff
    dr = direttive(rf)
    assert d["SIMBOLO"] == dr["SIMBOLO"] == "D30EUR" and d["PERIODO"] == dr["PERIODO"] == "M5" and (d["DAQUANDO"], d["FINOA"], d["FRAZIONEIS"]) == WP
    assert len(i) == len(ir) == 81, (len(i), len(ir))
    # date: Meta come la calcola il driver (Inizio + floor(giorni*frazione))
    import datetime as dt, math
    for (a, b, f) in (W, WP):
        A = dt.datetime.strptime(a, "%Y.%m.%d"); B = dt.datetime.strptime(b, "%Y.%m.%d")
        m = A + dt.timedelta(days=math.floor((B - A).days * float(f)))
        print("finestra %s -> %s frazione %s: Meta %s, IS %s-%s, OOS %s-%s" % (a, b, f, m.strftime("%Y.%m.%d"), a, m.strftime("%Y.%m.%d"),
              (m + dt.timedelta(days=1)).strftime("%Y.%m.%d"), b))
    print("VERIFICHE: A/B/C/D/A2 differiscono da R92be SOLO per InpMagic e Symbols_List (A/A2: solo InpMagic); P da RFWD_770101 SOLO per InpMagic; finestre ok")

if __name__ == "__main__":
    out = costruisci()
    verifica(out)
    for fn, t in out.items():
        t.encode("ascii")
        assert "\t" not in t
        p = os.path.join(PR, fn)
        if "--verifica" in sys.argv:
            cur = open(p, encoding="ascii", newline="").read() if os.path.exists(p) else None
            print(("IDENTICO " if cur == t + "\n" else "DIVERSO ") + fn)
        else:
            open(p, "w", encoding="ascii", newline="").write(t + "\n")
            print("scritto", fn, len(t) + 1, "byte")
