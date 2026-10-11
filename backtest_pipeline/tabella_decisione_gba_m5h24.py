#!/usr/bin/env python3
# -*- coding: ascii -*-
"""
tabella_decisione_gba_m5h24.py -- STRUMENTO DI ANALISI, NON PASSATO DAL CANCELLO.

Genera e VERIFICA la tabella decisionale del controesempio (b) del file prova backtest_pipeline/prove/GBA_R2_M5H24_2026-10-11.txt
(lotto R2M5H24, GBA M5 a 24 ore). Nata l'11/10/2026 dopo tre FAIL di fila sulla partizione scritta a mano (classe 1260 e ricorrenze).

INGRESSI (G = PF_V delle posizioni con ingresso 07:00-21:59; n_G il loro numero):
  - n_G totale >= 150: si / no
  - banda di G totale: L (G <= 1,03), M (1,03 < G < 1,3), H (G >= 1,3)
  - per ciascuna delle tre tranche: giudicabile (n_G di tranche >= 150) si/no  x  esito di tranche: VINCE (G_t > 1,3), PERDE (G_t <= 1,03), MEZZO (altrimenti)
    (VINCE e PERDE si escludono: tre esiti, non quattro)
COERENZA (combinazioni IMPOSSIBILI, escluse e contate):
  - una tranche giudicabile con n_G totale < 150 (n_G totale >= n_G di tranche);
  - il PF dell'unione sta fra il minimo e il massimo dei PF di tranche: G totale H richiede almeno una tranche che VINCE o MEZZO
    (MEZZO comprende G_t = 1,3 esatto); G totale L richiede almeno una tranche che PERDE; G totale M richiede che non tutte VINCANO e non tutte PERDANO.
RAMI (uno per combinazione, senza sovrapposizioni; verificato sotto):
  B4  n_G totale < 150                                          -> NON MISURABILE (guasto o pavimento: si legge il giornale)
  B2  n_G >= 150, G L                                           -> giorno indistinguibile dalla REPL e da 1,0 (S8): (b) NON scatta; per tranche si DESCRIVE
  B3  n_G >= 150, G M                                           -> nessun verdetto (S8 'esce dal rumore ma non basta'); numero e colonna per tranche; T0
  B1  n_G >= 150, G H, almeno 2 tranche giudicabili che VINCONO  -> 'anche il giorno vince': resta M5 + filtro di spread, NON separati; S5/S9; T0
  A   n_G >= 150, G H, ESATTAMENTE 1 tranche giudicabile che VINCE e nessun'altra tranche che VINCE -> 'regime' (controesempio (a) del piano)
  NM  n_G >= 150, G H, tutto il resto (1 giudicabile che vince + almeno 1 non giudicabile che vince; 0 giudicabili che vincono)
                                                                -> NON MISURABILE per n di tranche: si scrive il numero, T0
USO:  python3 -I backtest_pipeline/tabella_decisione_gba_m5h24.py           (stampa la tabella compatta e i controlli; rc 0 se tutto torna)
"""
import itertools, sys

ESITI = ("VINCE", "PERDE", "MEZZO")


def coerente(n_tot, banda, tranche):
    if not n_tot and any(g for g, _ in tranche):
        return False, "tranche giudicabile con n_G totale < 150"
    es = [e for _, e in tranche]
    if banda == "H" and all(e == "PERDE" for e in es):
        return False, "G totale >= 1,3 con tutte le tranche <= 1,03"
    if banda == "H" and not any(e in ("VINCE", "MEZZO") for e in es):
        return False, "G totale >= 1,3 senza tranche >= 1,03"
    if banda == "L" and not any(e == "PERDE" for e in es):
        return False, "G totale <= 1,03 senza tranche <= 1,03"
    if banda == "M" and (all(e == "VINCE" for e in es) or all(e == "PERDE" for e in es)):
        return False, "G totale fra 1,03 e 1,3 con tutte le tranche dalla stessa parte"
    return True, ""


# i predicati dei rami: ognuno guarda TUTTA la combinazione; la verifica pretende che ne scatti ESATTAMENTE uno
def rami(n_tot, banda, tranche):
    a = sum(1 for g, e in tranche if g and e == "VINCE")
    b = sum(1 for g, e in tranche if not g and e == "VINCE")
    p = {
        "B4": not n_tot,
        "B2": n_tot and banda == "L",
        "B3": n_tot and banda == "M",
        "B1": n_tot and banda == "H" and a >= 2,
        "A": n_tot and banda == "H" and a == 1 and b == 0,
        "NM": n_tot and banda == "H" and ((a == 1 and b >= 1) or a == 0),
    }
    return [k for k, v in p.items() if v], a, b


def main():
    stati = [(g, e) for g in (True, False) for e in ESITI]
    tot = imposs = 0
    errori = []
    compatta = {}
    for n_tot in (True, False):
        for banda in ("L", "M", "H"):
            for tranche in itertools.product(stati, repeat=3):
                tot += 1
                ok, _ = coerente(n_tot, banda, tranche)
                if not ok:
                    imposs += 1
                    continue
                r, a, b = rami(n_tot, banda, tranche)
                if len(r) != 1:
                    errori.append((n_tot, banda, tranche, r))
                    continue
                chiave = (n_tot, banda, min(a, 2) if banda == "H" else "-", min(b, 1) if banda == "H" else "-")
                compatta.setdefault(chiave, set()).add(r[0])
    print("combinazioni enumerate: %d (2 x 3 x 6^3); impossibili: %d; coerenti: %d" % (tot, imposs, tot - imposs))
    print("combinazioni senza ramo o con piu' rami: %d" % len(errori))
    for e in errori[:10]:
        print("   ", e)
    print()
    print("TABELLA COMPATTA (a = tranche GIUDICABILI che VINCONO, b = tranche NON giudicabili che VINCONO; '-' = non conta)")
    print("  n_G>=150  G      a     b     ramo")
    amb = 0
    for k in sorted(compatta, key=lambda k: (not k[0], k[1], str(k[2]), str(k[3]))):
        rr = sorted(compatta[k])
        if len(rr) != 1:
            amb += 1
        print("  %-8s  %-5s  %-4s  %-4s  %s" % ("si" if k[0] else "no", k[1], ">=2" if k[2] == 2 else k[2], ">=1" if k[3] == 1 else k[3], "/".join(rr)))
    # casi numerici dei controesempi del cancello (11/10, terzo giro): ingresso -> ramo atteso
    casi = [
        ("(i) T1 0,60/250 T2 1,10/240 T3 1,20/245, G tot ~0,97", True, "L", ((True, "PERDE"), (True, "MEZZO"), (True, "MEZZO")), "B2"),
        ("(ii) T1 0,40/140 T2 1,10/240 T3 1,15/245, G tot fra 1,03 e 1,3", True, "M", ((False, "PERDE"), (True, "MEZZO"), (True, "MEZZO")), "B3"),
        ("(ii-bis) stesse tranche, G tot <= 1,03", True, "L", ((False, "PERDE"), (True, "MEZZO"), (True, "MEZZO")), "B2"),
        ("(iii) n_G < 150, G >= 1,3 da una tranche sola", False, "H", ((False, "VINCE"), (False, "MEZZO"), (False, "MEZZO")), "B4"),
        ("una sola tranche vince ed e' NON giudicabile, n_G >= 150", True, "H", ((False, "VINCE"), (True, "MEZZO"), (True, "PERDE")), "NM"),
        ("due giudicabili vincono", True, "H", ((True, "VINCE"), (True, "VINCE"), (True, "PERDE")), "B1"),
        ("una giudicabile vince, le altre no", True, "H", ((True, "VINCE"), (True, "MEZZO"), (False, "PERDE")), "A"),
    ]
    print()
    print("CASI DI CONTROLLO (controesempi del cancello e casi di bordo)")
    falliti = 0
    for nome, n_tot, banda, tr, atteso in casi:
        ok, why = coerente(n_tot, banda, tr)
        r, _, _ = rami(n_tot, banda, tr)
        esito = "OK" if ok and r == [atteso] else "FALLITO"
        falliti += esito != "OK"
        print("  %-62s -> %-4s (atteso %s) %s %s" % (nome, "/".join(r), atteso, esito, "" if ok else "[incoerente: " + why + "]"))
    rc = 0 if not errori and not amb and not falliti else 1
    print()
    print("ESITO: %s" % ("TABELLA VERIFICATA: ogni combinazione coerente ha UN ramo" if rc == 0 else "TABELLA NON VERIFICATA"))
    return rc


if __name__ == "__main__":
    sys.exit(main())
