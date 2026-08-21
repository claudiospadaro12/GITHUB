#!/usr/bin/env python3
# =====================================================================
#  controlla_prova.py -- i controlli del driver, fatti QUI, prima
#                        di svegliare MT5
# ---------------------------------------------------------------------
#  PERCHE' ESISTE (21/08/2026, preparazione di R93)
#  walkforward_generico.ps1 ha gia' i suoi controlli (nome sconosciuto,
#  sweep degenere, parametro doppio) -- ma girano SUL PC DI CLAUDIO, e
#  ogni errore torna indietro come un giro a vuoto e un messaggio.
#  Questi tre li si puo' fare qui, a costo zero, prima di mandare la riga.
#
#  E ne fa uno IN PIU', che il driver NON fa e che e' costato un round:
#
#    >>> IL PIN DI UNA STRINGA A VALORE VUOTO NON ARRIVA ALL'EA. <<<
#
#  Il file prova della coda fascia B (prove/ABTG_FiboH4_Multi.txt)
#  scriveva `InpSymbols=` con sopra la nota "il pin sotto e'
#  OBBLIGATORIO". MT5 lo ha ignorato e ha usato il default compilato:
#  otto passate intitolate a otto mercati hanno misurato OTTO VOLTE LO
#  STESSO BASKET di tre cross (7 CSV su 8 identici al centesimo), e da
#  li' e' uscito il verdetto "0/8 promossi".
#  La riga c'era, sembrava applicata, e non lo era.
#
#  USO:
#    python3 backtest_pipeline/controlla_prova.py \
#        --ea mql5/Experts/ABTG_FiboH4_Multi.mq5 \
#        backtest_pipeline/prove/R93a_baseline.txt ...
#
#    # o in blocco, deducendo l'EA dalla riga "#  EA: <nome>" del file:
#    python3 backtest_pipeline/controlla_prova.py backtest_pipeline/prove/R93*.txt
#
#  Esce 1 se trova qualcosa. Va lanciato PRIMA di ogni riga di lancio.
# =====================================================================
from __future__ import annotations

import argparse
import glob
import os
import re
import sys

RADICE = os.path.dirname(os.path.dirname(os.path.abspath(__file__)))


def inputs_ea(percorso: str) -> set[str]:
    s = open(percorso, encoding="utf-8", errors="replace").read()
    return set(re.findall(r"^input\s+\w+\s+(\w+)", s, flags=re.M))


def trova_ea(prova: str) -> str | None:
    """Legge la riga '#  EA: <Nome> ...' dell'intestazione del file prova."""
    for l in open(prova, encoding="utf-8", errors="replace"):
        m = re.match(r"#\s*EA:\s*([A-Za-z0-9_]+)", l)
        if m:
            p = os.path.join(RADICE, "mql5", "Experts", m.group(1) + ".mq5")
            return p if os.path.exists(p) else None
    return None


def controlla(prova: str, ea: str) -> tuple[int, int]:
    nomi_ok = inputs_ea(ea)
    problemi: list[str] = []
    righe = []
    for l in open(prova, encoding="utf-8", errors="replace"):
        s = l.strip()
        if not s or s.startswith("#") or s.startswith("@") or "=" not in s:
            continue
        righe.append(s)

    nomi = [r.split("=")[0].strip() for r in righe]

    # 1. nome che l'EA non ha: MT5 lo ignora IN SILENZIO e la passata
    #    risponde a una domanda diversa da quella che credevi di fare.
    for n in nomi:
        if n not in nomi_ok:
            problemi.append(f"input SCONOSCIUTO all'EA: {n}")

    # 2. parametro doppio in [TesterInputs]: MT5 fa zero passate.
    for n in sorted(set(nomi)):
        if nomi.count(n) > 1:
            problemi.append(f"parametro DOPPIO: {n}")

    # 3. IL CONTROLLO CHE IL DRIVER NON FA: pin di stringa vuoto.
    for r in righe:
        if r.split("=", 1)[1].strip() == "":
            problemi.append(f"PIN VUOTO (MT5 lo IGNORA e usa il default compilato): {r}")

    # 4. esattamente UN asse Y, e non degenere.
    assi = [r for r in righe if r.endswith("||Y")]
    celle = 0
    if len(assi) == 0:
        problemi.append("nessun asse Y: sarebbe un backtest singolo, il driver rifiuta di lanciare")
    elif len(assi) > 1:
        problemi.append(f"{len(assi)} assi Y: un file prova misura UNA variabile alla volta "
                        + "(" + ", ".join(a.split("=")[0] for a in assi) + ")")
    else:
        p = assi[0].split("=", 1)[1].split("||")
        if len(p) != 5:
            problemi.append(f"asse malformato (servono 5 campi v||start||step||stop||Y): {assi[0]}")
        else:
            try:
                start, step, stop = float(p[1]), float(p[2]), float(p[3])
                if start == stop or step == 0:
                    problemi.append(f"SWEEP DEGENERE su {assi[0].split('=')[0]}: start==stop oppure step==0")
                else:
                    celle = int(abs(stop - start) / step) + 1
            except ValueError:
                problemi.append(f"asse non numerico: {assi[0]}")

    # 5. la finestra dichiarata
    testo = open(prova, encoding="utf-8", errors="replace").read()
    if "@DAQUANDO" not in testo:
        problemi.append("manca @DAQUANDO: la finestra va dichiarata nel file, non ricordata")

    nome = os.path.basename(prova)
    stato = "OK" if not problemi else "!! " + str(len(problemi)) + " PROBLEMI"
    print(f"  {nome:32s} {os.path.basename(ea):26s} pin={len(nomi):2d} celle={celle:2d}  {stato}")
    for p in problemi:
        print(f"      - {p}")
    return (len(problemi), celle)


def main() -> int:
    ap = argparse.ArgumentParser()
    ap.add_argument("prove", nargs="+")
    ap.add_argument("--ea", default="", help="il .mq5; se manca si legge dalla riga '# EA:' del file prova")
    a = ap.parse_args()

    files: list[str] = []
    for p in a.prove:
        files.extend(sorted(glob.glob(p)) or [p])

    print("=== CONTROLLO FILE PROVA ===")
    tot_problemi = 0
    tot_celle = 0
    for f in files:
        ea = a.ea or trova_ea(f)
        if not ea or not os.path.exists(ea):
            print(f"  {os.path.basename(f):32s} EA NON TROVATO -> non misurabile")
            tot_problemi += 1
            continue
        n, c = controlla(f, ea)
        tot_problemi += n
        tot_celle += c

    print()
    print(f"file: {len(files)} | celle totali: {tot_celle} | "
          f"passate (celle x 2 finestre): {tot_celle * 2} | problemi: {tot_problemi}")
    if tot_problemi:
        print("ESITO: FALLITO -- non si manda nessuna riga di lancio finche' e' rosso.")
        return 1
    print("ESITO: OK")
    return 0


if __name__ == "__main__":
    sys.exit(main())
