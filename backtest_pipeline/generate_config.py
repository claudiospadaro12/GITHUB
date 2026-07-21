#!/usr/bin/env python3
"""
Genera i file di configurazione dello Strategy Tester di MT5 (.ini + .set)
a partire dal config.json della pipeline.

STATO DEL CODICE (onesto):
  [SOLIDO]   struttura .ini, generazione .set, loop sugli EA e sulle finestre WF.
  [DA VERIFICARE] i codici numerici MT5-specifici (Model, OptimizationCriterion)
                  cambiano leggermente tra versioni. Sono raccolti in MAP_* qui sotto
                  con un commento # VERIFICA. Mandami un .ini/.set REALE esportato dal
                  tuo MT5 e li allineo esattamente, senza tirare a indovinare.
"""

import json
from pathlib import Path

# --- Mappature MT5. VERIFICA questi interi sulla TUA versione di MT5 -----------
# (MT5: si trovano generando un .ini dal Tester con "Salva" e aprendolo con un editor)
MAP_MODEL = {
    "every_tick": 0,
    "1min_ohlc": 1,
    "open_prices": 2,
    "math_calc": 3,
    "real_ticks": 4,        # "Every tick based on real ticks" - il piu' accurato
}

# ATTENZIONE: [INCERTO] i codici del criterio variano tra build MT5. Da confermare.
MAP_CRITERION = {
    "balance": 0,
    "profit_factor": 1,
    "expected_payoff": 2,
    "drawdown_min": 3,
    "recovery_factor": 4,
    "sharpe": 5,
    "custom": 6,            # OnTester() dell'EA
}

PERIOD_OK = {"M1", "M5", "M15", "M30", "H1", "H4", "D1", "W1", "MN1"}


def genera_set(expert: dict, out_dir: Path) -> Path:
    """
    Crea il file .set con i range di ottimizzazione degli input.
    Formato riga MT5:  NomeInput=valore||start||step||stop||enable(Y/N)
    """
    righe = []
    for p in expert["parametri"]:
        nome = p["input"]
        if p.get("ottimizza"):
            val = p.get("start", 0)
            riga = f"{nome}={val}||{p['start']}||{p['step']}||{p['stop']}||Y"
        else:
            # parametro fisso: enable = N, nessun range
            riga = f"{nome}={p['valore']}||{p['valore']}||0||{p['valore']}||N"
        righe.append(riga)

    set_path = out_dir / f"{expert['nome']}.set"
    set_path.write_text("\n".join(righe) + "\n", encoding="utf-8")
    return set_path


def genera_ini(cfg: dict, expert: dict, from_date: str, to_date: str,
               set_name: str, report_name: str, out_dir: Path) -> Path:
    """Crea il file .ini che avvia il terminale in modalita' ottimizzazione."""
    bt = cfg["backtest"]
    sel = cfg["selezione"]

    if bt["period"] not in PERIOD_OK:
        raise ValueError(f"Period non valido: {bt['period']}")

    model = MAP_MODEL[bt["modeling"]]
    criterio = MAP_CRITERION[sel["metrica"]]

    ini = f"""; --- Config generata dalla pipeline (EA: {expert['nome']}) ---
[Tester]
Expert={expert['file_ex5']}
Symbol={bt['symbol']}
Period={bt['period']}
Model={model}
Optimization=2
OptimizationCriterion={criterio}
FromDate={from_date}
ToDate={to_date}
Deposit={bt['deposit']}
Currency={bt['currency']}
Leverage={bt['leverage']}
ProfitInPips=0
ExecutionMode=0
Report={report_name}
ReplaceReport=1
ShutdownTerminal=1
Visual=0
"""
    ini_path = out_dir / f"{expert['nome']}_{from_date}_{to_date}.ini".replace(".", "-").replace("-ini", ".ini")
    ini_path.write_text(ini, encoding="utf-8")
    return ini_path


def carica_config(path: str = "config.json") -> dict:
    return json.loads(Path(path).read_text(encoding="utf-8"))


if __name__ == "__main__":
    import sys
    cfg = carica_config(sys.argv[1] if len(sys.argv) > 1 else "config.json")
    out = Path("generated")
    out.mkdir(exist_ok=True)
    for ea in cfg["experts"]:
        s = genera_set(ea, out)
        print(f"[OK] .set generato: {s}")
    print(f"\n{len(cfg['experts'])} EA processati. "
          f"Gli .ini per finestra vengono generati da run_pipeline.py (walk-forward).")
