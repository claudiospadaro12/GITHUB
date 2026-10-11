#!/usr/bin/env python3
# -*- coding: ascii -*-
"""
tabella_decisione_gba_m5h24.py -- STRUMENTO DI ANALISI, NON PASSATO DAL CANCELLO.

Verifica per enumerazione che i TRE esiti del file prova backtest_pipeline/prove/GBA_R2_M5H24_2026-10-11.txt (lotto R2M5H24, GBA M5 a 24 ore)
coprano ogni caso senza sovrapposizioni. Riscritto l'11/10/2026 dopo il quarto giro di giudizio: la tabella a sei rami della versione precedente
(classe 1312) e' stata TOLTA dal file prova per decisione del coordinatore; restano tre esiti definiti su numeri che leggi_gba_r0.py stampa.

INGRESSI (cella H24, letti dal lettore v5): PF_V totale, n totale, e per tranche PF_V e n.
  - banda del PF_V totale: L (<= 1,03), M (fra 1,03 e 1,3), H (>= 1,3)
  - n totale >= 150: si / no
  - k = numero di tranche con PF_V di tranche > 1,3 E n di tranche >= 150 (0..3)
COERENZA: k >= 1 richiede n totale >= 150; k = 3 richiede banda H (PF dell'unione >= minimo dei PF di tranche > 1,3).
MUTANTE EQUIVALENTE dichiarato: togliere 'n_ok' da E2 non cambia niente, perche' k >= 2 implica gia' n totale >= 150.
ESITI:
  E1  PF_V totale <= 1,03                                                   -> 'H24 non rende: la notte conta o H24 e' piatta; si scrive il numero'
  E2  PF_V totale >= 1,3, n totale >= 150, k >= 2                            -> 'H24 rende anche fuori dalla notte; filtro e TF non separati; T0'
  E3  tutto il resto                                                        -> 'nessun verdetto: numero e colonna per tranche, T0'
USO:  python3 -I backtest_pipeline/tabella_decisione_gba_m5h24.py      (rc 0 se ogni combinazione coerente ha UN esito e i casi tornano)
"""
import sys


def coerente(banda, n_ok, k):
    if k >= 1 and not n_ok:
        return False
    if k == 3 and banda != "H":
        return False      # tre tranche > 1,3: il PF dell'unione e' > 1,3 (sta fra il minimo e il massimo dei PF di tranche)
    return True


def esiti(banda, n_ok, k):
    p = {
        "E1": banda == "L",
        "E2": banda == "H" and n_ok and k >= 2,
    }
    p["E3"] = not (p["E1"] or p["E2"])
    return [e for e, v in p.items() if v]


def main():
    tot = imp = 0
    err = []
    righe = []
    for banda in ("L", "M", "H"):
        for n_ok in (True, False):
            for k in range(4):
                tot += 1
                if not coerente(banda, n_ok, k):
                    imp += 1
                    continue
                e = esiti(banda, n_ok, k)
                if len(e) != 1:
                    err.append((banda, n_ok, k, e))
                righe.append((banda, n_ok, k, "/".join(e)))
    print("combinazioni %d, impossibili %d, coerenti %d, senza esito o con piu' esiti %d" % (tot, imp, tot - imp, len(err)))
    print("  banda  n>=150  k   esito")
    for b, n, k, e in righe:
        print("  %-5s  %-6s  %d   %s" % (b, "si" if n else "no", k, e))
    # casi numerici: (PF_V totale, n totale, [(PF_V tranche, n tranche) x3], esito atteso)
    def banda_di(pf):
        return "L" if pf <= 1.03 else ("H" if pf >= 1.3 else "M")
    casi = [
        ("giorno uniforme 1,29/1,28/1,35 (cancello, quarto giro)", 1.307, 720, [(1.29, 240), (1.28, 240), (1.35, 240)], "E3"),
        ("regime tipico T3 2,0, T1-T2 0,8", 1.15, 1000, [(0.8, 330), (0.8, 330), (2.0, 340)], "E3"),
        ("due tranche > 1,3 giudicabili", 1.40, 1000, [(1.45, 330), (1.35, 330), (1.10, 340)], "E2"),
        ("totale 0,97", 0.97, 1000, [(0.6, 330), (1.1, 330), (1.2, 340)], "E1"),
        ("totale 1,35 ma una sola tranche > 1,3 con n >= 150", 1.35, 1000, [(1.9, 330), (1.31, 120), (1.0, 340)], "E3"),
    ]
    fall = 0
    print()
    for nome, pf, n, tr, att in casi:
        k = sum(1 for p, nn in tr if p > 1.3 and nn >= 150)
        e = esiti(banda_di(pf), n >= 150, k)
        ok = e == [att]
        fall += not ok
        print("  %-58s -> %s (atteso %s) %s" % (nome, "/".join(e), att, "OK" if ok else "FALLITO"))
    rc = 0 if not err and not fall else 1
    print()
    print("ESITO: %s" % ("TRE ESITI VERIFICATI: ogni combinazione coerente ha UN esito" if rc == 0 else "NON VERIFICATO"))
    return rc


if __name__ == "__main__":
    sys.exit(main())
