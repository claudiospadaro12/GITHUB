#!/usr/bin/env python3
# =====================================================================
#  audit_flotta.py  --  il controllo che avrei dovuto fare da mesi
#
#  Claudio (05/08): "Non e' possibile che TU ti accorgi dei problemi che
#  ci sono. Fai piu' verifiche. Se due EA sono uguali con due nomi
#  diversi, devi saperlo."
#
#  Ha ragione. Il 05/08 ho scoperto per caso che ABTG_Apertura_Marco e
#  ABTG_DAX_Apertura_EU sono lo STESSO EA con due magic diversi - e l'ho
#  scoperto solo perche' hanno fatto lo stesso trade allo stesso secondo.
#  Non e' un modo di lavorare.
#
#  Questo script lo trova da solo, e trova anche il resto:
#    1) MAGIC DUPLICATI  -> due EA che si contendono gli stessi ordini
#    2) GEMELLI          -> stessi parametri operativi, nomi diversi
#    3) RISCHIO          -> chi gira sopra l'1% dei backtest
#    4) TIMEFRAME        -> chi dipende dal grafico su cui e' attaccato
#
#  ⚠️ Cosa NON puo' vedere: due EA con gli STESSI parametri e MOTORI
#     DIVERSI. ABTG_SuperWave e ABTG_SupertrendReversal hanno 36
#     parametri su 36 uguali (tranne uno) ma il primo entra su un
#     incrocio EMA 14/200 e il secondo su un rimbalzo del Supertrend.
#     Il confronto dei parametri NON sostituisce la lettura del codice.
#
#  Uso:  python3 backtest_pipeline/audit_flotta.py
# =====================================================================
import re, glob, os, sys
from itertools import combinations
from collections import defaultdict

RADICE = os.path.join(os.path.dirname(os.path.abspath(__file__)), "..", "mql5", "Experts")
IGNORA = {"InpMagic", "InpComment", "InpVerbose", "InpNewsFile", "InpNewsCurrencies"}
# rischio massimo su cui e' stato fatto ALMENO un backtest
RISCHIO_TESTATO = 1.0


def leggi(percorso):
    """Default EFFETTIVI: gli #define in cima vincono e vengono sostituiti negli input."""
    src = open(percorso, encoding="utf-8", errors="replace").read()
    src = re.sub(r"/\*.*?\*/", "", src, flags=re.S)
    defs = {}
    for m in re.finditer(r"^#define\s+(ABTG_DEF_\w+)\s+(\S+)", src, re.M):
        defs.setdefault(m.group(1), m.group(2))        # la PRIMA vince, come fa il compilatore
    val = {}
    for m in re.finditer(r"^input\s+\S+\s+(\w+)\s*=\s*([^;]+?)\s*;", src, re.M):
        nome = m.group(1)
        v = re.sub(r"//.*", "", m.group(2)).strip()
        v = re.sub(r"\(ENUM_\w+\)", "", v).strip()
        for k, dv in defs.items():
            v = v.replace(k, dv)
        val.setdefault(nome, v)
    return val, src


def main():
    percorsi = sorted(glob.glob(os.path.join(RADICE, "*.mq5")))
    if not percorsi:
        print("Nessun .mq5 trovato in", RADICE); return 1
    dati = {}
    for p in percorsi:
        v, src = leggi(p)
        dati[os.path.basename(p)[:-4]] = (v, src)
    print(f"=== AUDIT FLOTTA: {len(dati)} EA ===\n")

    # --- 1. magic duplicati -------------------------------------------------
    per_magic = defaultdict(list)
    for ea, (v, _) in dati.items():
        per_magic[v.get("InpMagic", "?")].append(ea)
    print("--- 1) MAGIC DUPLICATI (si contendono gli stessi ordini) ---")
    trovato = False
    for mg, g in sorted(per_magic.items()):
        if len(g) > 1 and mg != "?":
            trovato = True
            print(f"  🔴 magic {mg}: " + ", ".join(g))
    if not trovato:
        print("  nessuna collisione")

    # --- 2. gemelli comportamentali ----------------------------------------
    print("\n--- 2) GEMELLI: stessi parametri operativi, nomi diversi ---")
    trovato = False
    for a, b in combinations(sorted(dati), 2):
        va, vb = dati[a][0], dati[b][0]
        com = (set(va) & set(vb)) - IGNORA
        if len(com) < 25:
            continue
        # dev'essere una fetta grossa di ENTRAMBI, non due EA che condividono
        # solo il blocco delle news
        if len(com) < 0.7 * min(len(va), len(vb)):
            continue
        diff = [k for k in com if va[k] != vb[k]]
        perc = 100 * (len(com) - len(diff)) / len(com)
        if perc < 97:
            continue
        trovato = True
        print(f"\n  {'🔴 IDENTICI' if not diff else '🟡 quasi'}  {perc:.1f}% su {len(com)} parametri")
        print(f"      {a}\n      {b}")
        if diff:
            print(f"      differenza: {', '.join(sorted(diff))}")
    if not trovato:
        print("  nessuno")

    # --- 3. rischio sopra il testato ---------------------------------------
    print(f"\n--- 3) RISCHIO sopra il {RISCHIO_TESTATO}% dei backtest ---")
    trovato = False
    for ea in sorted(dati):
        v = dati[ea][0]
        for chiave in ("InpRiskPercent", "InpRiskPct"):
            if chiave not in v:
                continue
            try:
                r = float(v[chiave])
            except ValueError:
                continue
            if r > RISCHIO_TESTATO:
                trovato = True
                print(f"  🟡 {ea}: {chiave} = {r} (il drawdown misurato va moltiplicato x{r/RISCHIO_TESTATO:.0f})")
    if not trovato:
        print("  nessuno")

    # --- 4. dipendenza dal timeframe del grafico ---------------------------
    print("\n--- 4) DIPENDONO DAL TIMEFRAME DEL GRAFICO ---")
    trovato = False
    for ea in sorted(dati):
        src = dati[ea][1]
        motivi = []
        if re.search(r"\bPERIOD_CURRENT\b", src):
            motivi.append("PERIOD_CURRENT")
        if re.search(r"\bPeriod\(\)", src):
            motivi.append("Period()")
        if re.search(r"\b_Period\b", src):
            motivi.append("_Period")
        if motivi:
            trovato = True
            print(f"  🟡 {ea}: {', '.join(sorted(set(motivi)))} -> il grafico su cui lo attacchi CONTA")
    if not trovato:
        print("  nessuno: tutti hanno il timeframe esplicito negli input")

    print("\n=== fine. Il confronto dei parametri NON sostituisce la lettura del codice:")
    print("    due EA possono avere gli stessi input e motori d'ingresso diversi. ===")
    return 0


if __name__ == "__main__":
    sys.exit(main())
