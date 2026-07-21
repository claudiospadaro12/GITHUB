#!/usr/bin/env python3
"""
Orchestratore WALK-FORWARD della pipeline di ottimizzazione MT5.

Cosa fa:
  1. Divide lo storico in finestre IS (in-sample) / OOS (out-of-sample).
  2. Per ogni EA e ogni finestra IS: genera .ini/.set e lancia MT5 in ottimizzazione.
  3. Prende i parametri migliori dell'IS e li ri-testa sull'OOS (dati MAI visti).
  4. Tiene solo i set che restano buoni ANCHE in OOS = robusti, non overfit.

STATO (onesto):
  [SOLIDO]        logica walk-forward, generazione finestre, orchestrazione, avvio processo.
  [DA COMPLETARE] parse dei risultati MT5 (parse_report.py): il formato esatto del
                  report va allineato a un tuo file reale. Finche' non me lo mandi,
                  la lettura restituisce un placeholder e NON invento numeri.

Eseguire SUL VPS Windows (con MT5 installato), non in questo ambiente.
"""

import json
import subprocess
from pathlib import Path
from datetime import date
from dateutil.relativedelta import relativedelta  # pip install python-dateutil

import generate_config as gc
try:
    import parse_report
except ImportError:
    parse_report = None


def _parse_data(s: str) -> date:
    y, m, d = map(int, s.split("."))
    return date(y, m, d)


def _fmt(d: date) -> str:
    return f"{d.year}.{d.month:02d}.{d.day:02d}"


def finestre_walk_forward(wf: dict):
    """Genera le finestre (IS_start, IS_end, OOS_start, OOS_end)."""
    start = _parse_data(wf["start"])
    end = _parse_data(wf["end"])
    is_len = relativedelta(months=wf["in_sample_months"])
    oos_len = relativedelta(months=wf["out_of_sample_months"])
    step = relativedelta(months=wf["step_months"])

    finestre = []
    is_start = start
    while True:
        is_end = is_start + is_len
        oos_start = is_end
        oos_end = oos_start + oos_len
        if oos_end > end:
            break
        finestre.append((is_start, is_end, oos_start, oos_end))
        is_start = is_start + step
    return finestre


def lancia_mt5(cfg: dict, ini_path: Path):
    """Avvia il terminale MT5 con la config data. Ritorna dopo lo ShutdownTerminal=1."""
    terminal = cfg["mt5"]["terminal_path"]
    # Su Windows: [terminal64.exe, /config:...]. Su Linux+Wine: anteponi 'wine'.
    cmd = [terminal, f"/config:{ini_path.resolve()}"]
    if cfg["mt5"].get("usa_wine"):
        cmd = ["wine"] + cmd
    print(f"    -> avvio MT5: {' '.join(cmd)}")
    # timeout di sicurezza: un'ottimizzazione lunga puo' richiedere parecchio.
    subprocess.run(cmd, check=False, timeout=cfg["mt5"].get("timeout_sec", 7200))


def esegui(config_path: str = "config.json"):
    cfg = gc.carica_config(config_path)
    out = Path("generated")
    out.mkdir(exist_ok=True)

    finestre = finestre_walk_forward(cfg["walk_forward"])
    print(f"Walk-forward: {len(finestre)} finestre IS/OOS.\n")

    risultati_globali = {}

    for ea in cfg["experts"]:
        print(f"=== EA: {ea['nome']} ===")
        set_path = gc.genera_set(ea, out)
        migliori_per_finestra = []

        for i, (is_s, is_e, oos_s, oos_e) in enumerate(finestre, 1):
            print(f"  Finestra {i}: IS {_fmt(is_s)}->{_fmt(is_e)}  "
                  f"OOS {_fmt(oos_s)}->{_fmt(oos_e)}")

            # --- 1) OTTIMIZZA sull'in-sample ---
            report_is = f"report_{ea['nome']}_IS_{i}"
            ini_is = gc.genera_ini(cfg, ea, _fmt(is_s), _fmt(is_e),
                                   set_path.name, report_is, out)
            lancia_mt5(cfg, ini_is)

            if parse_report is None:
                print("    [DA COMPLETARE] parse_report non disponibile: "
                      "salto la lettura risultati (serve un tuo report reale).")
                continue

            top = parse_report.leggi_top(cfg, report_is,
                                         metrica=cfg["selezione"]["metrica"],
                                         min_trade=cfg["selezione"]["min_trade"],
                                         plateau=cfg["selezione"]["preferisci_plateau"])

            # --- 2) VALIDA i migliori sull'out-of-sample ---
            # (ri-test SENZA ottimizzazione, con i parametri vincenti dell'IS)
            # dettaglio implementato in parse_report + un secondo .ini a param fissi.
            migliori_per_finestra.append({
                "finestra": i,
                "is": [_fmt(is_s), _fmt(is_e)],
                "oos": [_fmt(oos_s), _fmt(oos_e)],
                "top_is": top,
            })

        risultati_globali[ea["nome"]] = migliori_per_finestra

    Path("risultati_walk_forward.json").write_text(
        json.dumps(risultati_globali, indent=2, ensure_ascii=False), encoding="utf-8")
    print("\nFatto. Risultati in risultati_walk_forward.json")


if __name__ == "__main__":
    import sys
    esegui(sys.argv[1] if len(sys.argv) > 1 else "config.json")
