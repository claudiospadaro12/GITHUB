#!/usr/bin/env python3
# =====================================================================
#  diff_blocco_segnale.py -- "ho toccato il segnale?" NON si risponde
#                            a memoria: si misura.
# ---------------------------------------------------------------------
#  PERCHE' ESISTE (21/08/2026, migrazione di ABTG_FiboH4_Multi)
#  La regola di casa dice: si aggiungono gli standard SENZA toccare la
#  logica del segnale. Finora quella frase era una PROMESSA scritta nel
#  changelog. Qui diventa un NUMERO che chiunque puo' rifare.
#
#  Estrae le funzioni indicate da due versioni di un .mq5 (una da git,
#  una dal disco), toglie commenti e spazi, e confronta.
#  diff = 0  -> quel blocco e' identico carattere per carattere.
#  diff = 1  -> e' cambiato: allora la riga cambiata va DICHIARATA.
#
#  ATTENZIONE (imparata subito, sbagliando il 21/08): il commit di
#  confronto va scelto guardando `#property version`, non "l'ultimo che
#  tocca il file". In un repo dove si committa spesso l'albero intero,
#  molti commit "toccano" il file senza essere la versione di prima.
#  Con --auto lo script cerca da solo l'ultimo commit con una version
#  DIVERSA da quella sul disco.
#
#  USO:
#    python3 backtest_pipeline/diff_blocco_segnale.py \
#        mql5/Experts/ABTG_FiboH4_Multi.mq5 --auto \
#        "bool BullEngulf(" "bool BearEngulf(" "void TryPlace(" \
#        "void PlaceLimit(" "void OnNewBar("
# =====================================================================
from __future__ import annotations

import argparse
import re
import subprocess
import sys


def blocco(testo: str, firma: str) -> str | None:
    """Il corpo della funzione che comincia con `firma`, graffe bilanciate.

    La firma si cerca SOLO A INIZIO RIGA. Sembra un dettaglio e non lo e':
    il 21/08 questo strumento ha dato "5 blocchi diversi su 5" su un file in
    cui ne erano cambiati due, perche' la stringa "bool BullEngulf(" compare
    anche NEL COMMENTO in testa al sorgente (l'esempio d'uso di questo stesso
    script). Cercava il commento e confrontava intestazioni.
    E' il difetto di casa "il guardiano che misura la cosa sbagliata": un
    numero preciso, tondo e falso.
    """
    m = re.search(r"^[ \t]*" + re.escape(firma), testo, flags=re.M)
    if not m:
        return None
    i = m.start()
    j = testo.find("{", i)
    if j < 0:
        return None
    liv = 0
    for k in range(j, len(testo)):
        if testo[k] == "{":
            liv += 1
        elif testo[k] == "}":
            liv -= 1
            if liv == 0:
                return testo[i:k + 1]
    return None


def norm(s: str) -> str:
    s = re.sub(r"/\*.*?\*/", "", s, flags=re.S)
    s = re.sub(r"//.*", "", s)
    return re.sub(r"\s+", "", s)


def versione(testo: str) -> str:
    m = re.search(r'#property\s+version\s+"([^"]+)"', testo)
    return m.group(1) if m else "?"


def git_show(rev: str, path: str) -> str | None:
    r = subprocess.run(["git", "show", f"{rev}:{path}"], capture_output=True, text=True)
    return r.stdout if r.returncode == 0 else None


def trova_versione_precedente(path: str, ver_disco: str) -> str | None:
    r = subprocess.run(["git", "log", "--format=%H", "-40", "--", path],
                       capture_output=True, text=True)
    for c in r.stdout.split():
        t = git_show(c, path)
        if t and versione(t) != ver_disco:
            return c
    return None


def main() -> int:
    ap = argparse.ArgumentParser()
    ap.add_argument("file")
    ap.add_argument("firme", nargs="+")
    ap.add_argument("--rev", default="", help="commit di confronto")
    ap.add_argument("--auto", action="store_true",
                    help="cerca l'ultimo commit con #property version diversa")
    a = ap.parse_args()

    nuovo = open(a.file, encoding="utf-8", errors="replace").read()
    vnew = versione(nuovo)

    rev = a.rev
    if a.auto or not rev:
        rev = trova_versione_precedente(a.file, vnew) or ""
    if not rev:
        print("NON MISURABILE: nessun commit con una versione diversa da", vnew)
        return 1

    vecchio = git_show(rev, a.file)
    if vecchio is None:
        print(f"NON MISURABILE: {rev} non contiene {a.file}")
        return 1

    print(f"confronto  {a.file}")
    print(f"  disco  : versione {vnew}")
    print(f"  git    : versione {versione(vecchio)}  ({rev[:7]})")
    print()

    diversi = 0
    mancanti = 0
    for f in a.firme:
        va, vb = blocco(vecchio, f), blocco(nuovo, f)
        if va is None or vb is None:
            print(f"  {f:26s} BLOCCO NON TROVATO ({'nel vecchio' if va is None else 'nel nuovo'})")
            mancanti += 1
            continue
        d = 0 if norm(va) == norm(vb) else 1
        diversi += d
        print(f"  {f:26s} diff normalizzato = {d}   {'IDENTICO' if d == 0 else 'DIVERSO -> va DICHIARATO'}")

    print()
    print(f"ESITO: {diversi} blocchi diversi, {mancanti} non trovati, su {len(a.firme)}.")
    # NB: uscita 0 anche con blocchi diversi. Un blocco diverso non e' un
    # errore: e' una cosa da DICHIARARE. L'errore e' non saperlo.
    return 1 if mancanti else 0


if __name__ == "__main__":
    sys.exit(main())
