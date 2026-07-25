#!/usr/bin/env python3
# -*- coding: utf-8 -*-
"""
gen_ini.py  --  genera i file .ini di configurazione dello Strategy Tester MT5
                (uno per EA) a partire da ea_config.json.

Ogni .ini avvia un'OTTIMIZZAZIONE genetica sull'EA, con i parametri e i range
definiti nel config. I risultati vengono esportati automaticamente in CSV dal
blocco OptFrame inlinato in ogni EA (MQL5\\Files\\OptResults_<EA>_<Symbol>.csv).

Uso (sul PC o sul VPS, serve solo Python):
    python gen_ini.py                 # scrive gli .ini in backtest_pipeline/ini/
    python gen_ini.py --report-dir X  # opzionale: cartella report tester

I file .ini prodotti si lanciano con:
    terminal64.exe /config:<percorso .ini>
(il launcher run_all.ps1 lo fa in sequenza per tutti).
"""
import json
import os
import argparse

HERE = os.path.dirname(os.path.abspath(__file__))


def fmt_num(v):
    """Interi senza .0, float con il minimo necessario."""
    if isinstance(v, float) and v.is_integer():
        return str(int(v))
    return str(v)


def tester_inputs(params, fixed=None):
    """Righe [TesterInputs] in formato MT5.
    - params ottimizzati:  nome=start||start||step||stop||Y
    - valori fissi (fixed): nome=val||val||0||val||N  (NON ottimizzato: es. lo
      slippage onesto, che e' un COSTO da imporre, non da ottimizzare)."""
    lines = []
    for name, v in (fixed or {}).items():
        val = fmt_num(v)
        lines.append("{}={}||{}||0||{}||N".format(name, val, val, val))
    for name, r in params.items():
        start = fmt_num(r["start"])
        step = fmt_num(r["step"])
        stop = fmt_num(r["stop"])
        # value iniziale = start; ||Y abilita l'ottimizzazione del parametro
        lines.append("{}={}||{}||{}||{}||Y".format(name, start, start, step, stop))
    return lines


def build_ini(ea, defaults, report_dir):
    d = defaults
    name = ea["file"]
    report = os.path.join(report_dir, "OptReport_" + name) if report_dir else "OptReport_" + name
    lines = [
        "[Tester]",
        "Expert=%s.ex5" % name,
        "Symbol=%s" % ea["symbol"],
        "Period=%s" % ea["period"],
        "Model=%d" % d["model"],
        "Optimization=%d" % d["optimization"],
        "OptimizationCriterion=%d" % d["optimization_criterion"],
        "FromDate=%s" % d["from_date"],
        "ToDate=%s" % d["to_date"],
        "ForwardMode=0",
        "Deposit=%d" % d["deposit"],
        "Currency=%s" % d["currency"],
        "Leverage=%d" % d["leverage"],
        "ExecutionMode=0",
        "ReplaceReport=1",
        "ShutdownTerminal=1",
        "Report=%s" % report,
        "",
        "[TesterInputs]",
    ]
    lines += tester_inputs(ea["params"], ea.get("fixed"))
    lines.append("")
    return "\n".join(lines)


def main():
    ap = argparse.ArgumentParser()
    ap.add_argument("--config", default=os.path.join(HERE, "ea_config.json"))
    ap.add_argument("--out", default=os.path.join(HERE, "ini"))
    ap.add_argument("--report-dir", default="", help="cartella report tester (opzionale)")
    args = ap.parse_args()

    with open(args.config, "r", encoding="utf-8") as f:
        cfg = json.load(f)

    defaults = cfg["defaults"]
    os.makedirs(args.out, exist_ok=True)

    written = []
    for ea in cfg["experts"]:
        ini = build_ini(ea, defaults, args.report_dir)
        path = os.path.join(args.out, ea["file"] + ".ini")
        with open(path, "w", encoding="utf-8") as f:
            f.write(ini)
        written.append((ea["file"], ea["symbol"], ea["period"], len(ea["params"])))

    print("Generati %d file .ini in %s" % (len(written), args.out))
    for name, sym, per, np_ in written:
        print("  %-32s  %-8s %-4s  %d parametri" % (name, sym, per, np_))
    print("\nRicorda: verifica che i SIMBOLI combacino con la tua Market Watch BCM.")


if __name__ == "__main__":
    main()
