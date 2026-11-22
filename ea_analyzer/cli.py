"""Uso:
  python -m ea_analyzer.cli struttura --report REPORT.htm [--tf 240]
  python -m ea_analyzer.cli fedelta --report REPORT.htm --ohlcv 'GLOB.csv' --modello goldenzoe [--oro-ftmo] [--out CARTELLA]
  python -m ea_analyzer.cli set --set A.set [--confronta B.set]"""
import argparse, json, os
import pandas as pd
from . import parsers, structure, fidelity
from .models import goldenzoe_ref


def main():
    p = argparse.ArgumentParser(); sub = p.add_subparsers(dest="cmd", required=True)
    a = sub.add_parser("struttura"); a.add_argument("--report", required=True); a.add_argument("--tf", type=int)
    f = sub.add_parser("fedelta"); f.add_argument("--report", required=True); f.add_argument("--ohlcv", required=True); f.add_argument("--modello", default="goldenzoe"); f.add_argument("--oro-ftmo", action="store_true"); f.add_argument("--out"); f.add_argument("--eurusd"); f.add_argument("--conto-eur", action="store_true")
    s = sub.add_parser("set"); s.add_argument("--set", required=True); s.add_argument("--confronta")
    x = p.parse_args()
    if x.cmd == "struttura":
        r = parsers.parse_mt5_report(x.report); print(json.dumps(r["meta"], indent=1, default=str)[:600]); print(json.dumps(structure.analyze_structure(r["trades"], x.tf), indent=1, default=str))
    elif x.cmd == "set":
        a = parsers.parse_set(x.set)
        print(json.dumps(parsers.diff_sets(a, parsers.parse_set(x.confronta)) if x.confronta else {k: v["valore"] for k, v in a.items() if k != "_commenti"}, indent=1))
    else:
        rep = parsers.parse_mt5_report(x.report); tr = rep["trades"]; m1 = parsers.load_ohlcv(x.ohlcv, drop_aggregate_row=x.oro_ftmo)
        inp = rep["meta"]["inputs"]
        ref = goldenzoe_ref.simulate(m1, N=int(inp.get("InpDonchianN", 55)), atr_period=int(inp.get("InpAtrPeriod", 14)), stop_atr=float(inp.get("InpStopAtr", 3)), trail_atr=float(inp.get("InpTrailAtr", 3)))
        per = rep["meta"].get("period", "")
        a_, b_ = tr.open_time.min(), tr.open_time.max(); ref = ref[(ref.open_time >= a_ - pd.Timedelta("1D")) & (ref.open_time <= b_ + pd.Timedelta("1D"))]
        res, d, pairs = fidelity.score(ref, tr)
        fx = None
        if x.conto_eur and x.eurusd:
            fx = parsers.load_ohlcv(x.eurusd, drop_aggregate_row=x.oro_ftmo)["close"]
        ref = fidelity.add_model_lots(ref, tr, pairs, risk_pct=float(inp.get("InpRiskPercent", 1)), fx=fx)
        res, d, pairs = fidelity.score(ref, tr)
        print(json.dumps(res, indent=1, default=str))
        extra, missed = fidelity.missing_and_extra(ref, tr, pairs, m1)
        if x.out:
            os.makedirs(x.out, exist_ok=True); d.to_csv(os.path.join(x.out, "differenze_abbinate.csv"), index=False); extra.to_csv(os.path.join(x.out, "solo_tester.csv"), index=False); missed.to_csv(os.path.join(x.out, "solo_modello.csv"), index=False)
        print("solo tester:", len(extra), "| solo modello:", len(missed))


if __name__ == "__main__":
    main()
