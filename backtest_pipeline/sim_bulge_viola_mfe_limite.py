#!/usr/bin/env python3
# =====================================================================
#  sim_bulge_viola_mfe_limite.py -- SOLA LETTURA. Domanda di Claudio (08/10/2026):
#  "i trade che POI SONO ANDATI IN STOP erano prima in profitto? se si', un BE o
#   un trailing con trigger BASSO taglierebbe le perdite a frequenza invariata".
#  Il per-trade NON ha MFE/MAE. Ma trades_auto.csv ha due colonne, session_high e
#  session_low = max/min dei M5 DALL'INGRESSO A FINE GIORNO D'INGRESSO
#  (report/IL_PERTRADE_FTMO_ESISTE_2026-09-23.md, colonna 15-16). Da li' si ricava
#  un INTERVALLO, non un valore:
#   - perdita chiusa NELLO STESSO GIORNO d'ingresso: la finestra contiene tutta la vita
#     della posizione piu' le barre DOPO l'uscita -> MFE_vera <= MFE_banda
#     = LIMITE SUPERIORE di quanto la perdita era stata in profitto.
#   - perdita chiusa un giorno DOPO: la finestra e' solo il primo tratto della vita
#     -> MFE_vera >= MFE_banda = LIMITE INFERIORE; il limite superiore NON E' NOTO.
#  R = |entrata - uscita a SL| (lo SL e' a 3 ATR; slippage trascurato).
#  Il tetto "perdite salvabili" = quelle con MFE_banda >= b (stesso giorno) + TUTTE le
#  perdite multi-giorno (incognita); il pavimento = le multi-giorno con MFE_banda >= b.
#  I vincitori a rischio di essere tagliati dal BE = vincite con r >= b (il TP e' piu'
#  lontano del trigger: sotto b il TP chiude prima che il BE scatti).
#
#  Uso:  python3 backtest_pipeline/sim_bulge_viola_mfe_limite.py [--autotest]
#  ASCII puro.
#
#  ATTESA scritta PRIMA (08/10/2026; vista solo la distribuzione delle vincite del pool):
#   - il TP e' a ~0,24 R (mediana): una perdita che non ha toccato il TP non puo' essere
#     stata molto oltre 0,24 R in profitto (il TP si muove, ma verso l'entrata).
#     Attesa: fra le perdite dello stesso giorno, la quota con MFE_banda >= 0,5 R e' < 10%
#     e con >= 0,3 R e' < 25%. L'ipotesi ALTERNATIVA (le perdite erano spesso in profitto,
#     BE basso utile): quota >= 0,3 R sopra il 40%.
#   - limite superiore del guadagno da BE a 0,5 R: < +1,5 R sul campione (n VIOLA 83).
#  LIMITI: banda M5 (non tick: l'ordine dentro la barra e' ignoto); multi-giorno senza
#   limite superiore; il campione e' quello del piccolo (BCM); R92BAB e trial non hanno la banda
#   (trial: ha il TP iniziale, usato a parte); nessuna simulazione del BE reale (offset, spread,
#   STOPS_LEVEL).
# =====================================================================
import sys

import sim_bulge_viola_dati as D

SOGLIE = (0.3, 0.5, 0.75)


def mfe_banda_R(p):
    d = abs(p["o"] - p["c"])
    if d <= 0 or not p.get("hi") or not p.get("lo"):
        return None
    return ((p["hi"] - p["o"]) if p["lato"] > 0 else (p["o"] - p["lo"])) / d


def stesso_giorno(p):
    return p["apre"].date() == p["chiude"].date()


def limiti(pos, b):
    """Ritorna dict con conteggi e delta R (limite superiore / inferiore) per la soglia b."""
    perd = [p for p in pos if p["motivo"] == "sl" and p["netto"] < 0 and mfe_banda_R(p) is not None]
    sd = [p for p in perd if stesso_giorno(p)]
    md = [p for p in perd if not stesso_giorno(p)]
    sd_ge = [p for p in sd if mfe_banda_R(p) >= b]
    md_ge = [p for p in md if mfe_banda_R(p) >= b]
    vinc = [p for p in pos if p["r"] > 0]
    vinc_b = [p for p in vinc if p["r"] >= b]
    max_set = sd_ge + md                    # tetto: tutte le multi-giorno sono incognite
    min_set = md_ge                         # pavimento: solo quelle certamente in profitto
    best = sum(-p["r"] for p in max_set)    # nessun vincitore tagliato
    worst = sum(-p["r"] for p in min_set) - sum(p["r"] for p in vinc_b)  # tutti i vincitori con r>=b tagliati
    return {"b": b, "n_perd": len(perd), "sd": len(sd), "sd_ge": len(sd_ge), "md": len(md), "md_ge": len(md_ge),
            "max": len(max_set), "min": len(min_set), "n_vinc": len(vinc), "vinc_b": len(vinc_b),
            "somma_perd": sum(-p["r"] for p in perd), "best": best, "worst": worst}


def autotest():
    import datetime as dt
    ko = []

    def ok(c, m):
        print("  [%s] %s" % ("OK" if c else "KO", m))
        if not c:
            ko.append(m)

    def mk(lato, o, c, hi, lo, giorno_fine, r, motivo="sl"):
        a = dt.datetime(2026, 10, 1, 10)
        ch = dt.datetime(2026, 10, giorno_fine, 12)
        p = D.nuova("fin", (o, c, hi), "EURUSD", lato, a, ch, 1, r * 100.0, 100.0, motivo, "VIOLA", "x")
        p.update({"o": o, "c": c, "hi": hi, "lo": lo})
        return p
    # long, SL a 0.99 (d=0.01), banda: salita a 1.006 = 0.6 R
    L1 = mk(1, 1.0, 0.99, 1.006, 0.989, 1, -1.0)
    # short, SL a 1.01, banda: sceso a 0.9955 = 0.45 R
    S1 = mk(-1, 1.0, 1.01, 1.011, 0.9955, 1, -1.0)
    # CONTROESEMPIO: long che non e' mai stato in profitto (hi=1.0004)
    L0 = mk(1, 1.0, 0.99, 1.0004, 0.989, 1, -1.0)
    # multi-giorno, banda del 1o giorno 0.8 R -> pavimento a 0.75
    M1 = mk(1, 1.0, 0.99, 1.008, 0.995, 2, -1.0)
    # multi-giorno, banda 0.1 R: incognita (tetto si, pavimento no)
    M0 = mk(1, 1.0, 0.99, 1.001, 0.995, 2, -1.0)
    W1 = mk(1, 1.0, 1.003, 1.004, 0.999, 1, 0.3, motivo="tp")
    W2 = mk(1, 1.0, 1.001, 1.002, 0.999, 1, 0.1, motivo="tp")
    pos = [L1, S1, L0, M1, M0, W1, W2]
    ok(abs(mfe_banda_R(L1) - 0.6) < 1e-9 and abs(mfe_banda_R(S1) - 0.45) < 1e-9, "MFE di banda: long 0,6 R, short 0,45 R (risposta nota)")
    r5 = limiti(pos, 0.5)
    ok(r5["sd"] == 3 and r5["sd_ge"] == 1 and r5["md"] == 2 and r5["md_ge"] == 1, "b=0,5: stesso giorno 3 (1 sopra soglia: L1), multi-giorno 2 (1 certo: M1)")
    ok(r5["max"] == 3 and r5["min"] == 1, "tetto = 1 + tutte le multi-giorno = 3; pavimento = 1")
    ok(r5["vinc_b"] == 0 and r5["n_vinc"] == 2, "nessun vincitore con r>=0,5 (W1 0,3; W2 0,1)")
    r3 = limiti(pos, 0.3)
    ok(r3["vinc_b"] == 1 and abs(r3["worst"] - (-(-1.0) * r3["min"] - 0.3)) < 1e-9, "b=0,3: un vincitore a rischio (W1); caso peggiore = perdite certe salvate - 0,3")
    r75 = limiti(pos, 0.75)
    ok(r75["sd_ge"] == 0 and r75["md_ge"] == 1, "b=0,75: nessuna perdita del giorno oltre soglia; resta la multi-giorno M1 (0,8)")
    # CONTROESEMPIO del limite superiore: la banda include barre DOPO l'uscita, quindi puo' sovrastimare
    # (qui la salita a 1.006 poteva essere avvenuta dopo lo stop): il tetto la conta, il pavimento no.
    ok(r5["max"] > r5["min"], "il tetto e' un tetto, non una stima: sovrastima per costruzione (banda anche dopo l'uscita)")
    # il test dice 'zero' quando la banda non e' mai in profitto
    ok(limiti([L0], 0.3)["max"] == 0 and limiti([L0], 0.3)["best"] == 0.0, "controesempio: perdita mai in profitto -> nulla da salvare")
    print("AUTOTEST: %s" % ("TUTTO OK" if not ko else "FALLITI: %d" % len(ko)))
    return not ko


def stampa(nome, pos):
    print("\n--- %s: n %d, perdite a SL con banda: %d ---" % (nome, len(pos), len([p for p in pos if p["motivo"] == "sl" and p["netto"] < 0 and mfe_banda_R(p) is not None])))
    print("  %5s %9s %12s %8s %11s %9s %9s %14s %14s" % ("b (R)", "stesso gg", "con MFE>=b", "multi-gg", "multi MFE>=b", "tetto", "pavim.", "vinc. r>=b/tot", "delta R sup/inf"))
    for b in SOGLIE:
        x = limiti(pos, b)
        print("  %5.2f %9d %12d %8d %11d %9d %9d %8d/%-5d %+7.2f /%+7.2f" % (b, x["sd"], x["sd_ge"], x["md"], x["md_ge"], x["max"], x["min"], x["vinc_b"], x["n_vinc"], x["best"], x["worst"]))
    x = limiti(pos, 0.3)
    print("  somma delle perdite a SL con banda: %.2f R" % x["somma_perd"])
    if x["sd"]:
        for b in SOGLIE:
            y = limiti(pos, b)
            print("  quota delle perdite dello stesso giorno con MFE_banda >= %.2f R: %d/%d = %.0f%%" % (b, y["sd_ge"], y["sd"], 100.0 * y["sd_ge"] / y["sd"]))


def main():
    if not autotest():
        print("autotest fallito")
        return 1
    if "--autotest" in sys.argv:
        return 0
    v520, ant = D.carica_bcm()
    v_v = [p for p in v520 if p["segnale"] == "VIOLA"]
    a_v = [p for p in ant if p["segnale"] == "VIOLA"]
    stampa("v520 VIOLA (33)", v_v)
    stampa("antenato VIOLA (50)", a_v)
    stampa("VIOLA unite (83; versioni diverse)", v_v + a_v)
    stampa("STRESS: antenato TUTTI (297, BLU domina) + v520 tutti", ant + v520)
    t = D.carica_trial()
    print("\n--- TRIAL FTMO: distanza del TP INIZIALE dall'entrata, in R (l'ordine d'apertura ha il TP; SL noto) ---")
    dist = [(abs(p["tp_ini"] - p["o"]) / abs(p["o"] - p["sl"]), p) for p in t if p.get("tp_ini")]
    sl_ = [(d, p) for d, p in dist if p["motivo"] == "sl"]
    print("  tutte (n %d): mediana %.2f R, min %.2f, max %.2f" % (len(dist), sorted(d for d, _ in dist)[len(dist) // 2], min(d for d, _ in dist), max(d for d, _ in dist)))
    print("  perdite a SL (n %d): TP iniziale a %s R" % (len(sl_), ", ".join("%.2f" % d for d, _ in sl_)))
    for b in SOGLIE:
        print("  TP iniziale piu' lontano di %.2f R: %d/%d posizioni, %d/%d perdite a SL (solo queste potevano essere in profitto oltre b senza toccare il TP, salvo TP che si sposta)"
              % (b, sum(1 for d, _ in dist if d >= b), len(dist), sum(1 for d, _ in sl_ if d >= b), len(sl_)))
    print("\nNON MISURATO: MFE/MAE veri (tick); l'ordine dentro la barra M5; le perdite multi-giorno oltre il primo giorno; trial e R92BAB senza banda.")
    return 0


if __name__ == "__main__":
    sys.exit(main())
