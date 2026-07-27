#!/usr/bin/env python3
# -*- coding: utf-8 -*-
"""
analyze_scan_symbols.py
=======================
Analizza le ESPORTAZIONI DI OTTIMIZZAZIONE di MT5 (un file .csv per simbolo)
prodotte da uno "scan" multi-simbolo di un Expert Advisor, e stila una
CLASSIFICA di quali simboli si comportano meglio con la strategia.

Formato atteso di ogni file (header MT5 standard):
  Pass,Profit,Expected Payoff,Profit Factor,Recovery Factor,Sharpe Ratio,
  Equity DD %,Trades,<parametri input...>

Il simbolo viene dedotto dal nome file:  *MaxMinNotte_<SIMBOLO>.csv
(o, in generale, l'ultimo blocco dopo l'ultimo '_' prima di '.csv').

USO:
  python3 analyze_scan_symbols.py <cartella_o_files...> [--min-trades N] [--csv out.csv]

Metodo (onesto, anti-illusione):
  - Si considerano solo i "pass" con almeno --min-trades operazioni (default 20):
    poche operazioni = statistica non affidabile (possibile fortuna/overfitting).
  - Per ogni simbolo si riportano: n. pass validi, % pass in profitto,
    Profit Factor MEDIANO (robustezza, non il singolo colpo fortunato),
    e il MIGLIOR pass realistico (per Profit fra i pass validi con PF>1).
  - Verdetto:
      BUONO      -> molti pass validi, mediana PF>1.2 e >=60% pass in profitto
      MODERATO   -> mediana PF>1.0 e >=50% pass in profitto
      SCARSO     -> mediana PF<=1.0 o pochi pass in profitto
      NO-SEGNALE -> nessun pass raggiunge --min-trades (dati insufficienti)
  La classifica finale ordina per (verdetto, mediana PF, % profitto).
"""
import sys, os, glob, csv, re, statistics as st

def find_files(args):
    files = []
    for a in args:
        if os.path.isdir(a):
            files += glob.glob(os.path.join(a, "*.csv"))
        else:
            files.append(a)
    return sorted(set(files))

def symbol_from_name(path):
    b = os.path.basename(path)
    b = re.sub(r"\.csv$", "", b, flags=re.I)
    m = re.search(r"MaxMinNotte[_-](.+)$", b)
    if m:
        return m.group(1)
    # fallback: ultimo blocco dopo '_'
    return b.split("_")[-1]

def fnum(s):
    try:
        return float(str(s).replace(" ", ""))
    except Exception:
        return 0.0

def analyze_file(path, min_trades):
    rows = []
    with open(path, newline="", encoding="utf-8", errors="replace") as fh:
        rd = csv.DictReader(fh)
        for r in rd:
            rows.append(r)
    if not rows:
        return None
    # colonne (tolleranti agli spazi)
    def col(r, name):
        for k in r:
            if k and k.strip().lower() == name.lower():
                return r[k]
        return None

    traded, valid = [], []
    for r in rows:
        trades = int(fnum(col(r, "Trades")))
        if trades <= 0:
            continue
        rec = {
            "pass": col(r, "Pass"),
            "profit": fnum(col(r, "Profit")),
            "pf": fnum(col(r, "Profit Factor")),
            "dd": fnum(col(r, "Equity DD %")),
            "sharpe": fnum(col(r, "Sharpe Ratio")),
            "trades": trades,
            "long": col(r, "InpAllowLong"),
            "short": col(r, "InpAllowShort"),
            "buffer": col(r, "InpBufferPoints"),
            "tp2": col(r, "InpTP2_R"),
            "slatr": col(r, "InpSLatrMult"),
            "edge": col(r, "InpEdgeOffsetPips"),
            "tpfrac": col(r, "InpTPfrac"),
        }
        traded.append(rec)
        if trades >= min_trades:
            valid.append(rec)

    base = valid if valid else traded
    if not base:
        return {"symbol": symbol_from_name(path), "verdict": "NO-TRADE",
                "n_valid": 0, "pct_profit": 0.0, "med_pf": 0.0,
                "avg_trades": 0.0, "best": None, "low_sample": True}

    pfs = [x["pf"] for x in base if x["pf"] > 0]
    med_pf = st.median(pfs) if pfs else 0.0
    pct_profit = 100.0 * sum(1 for x in base if x["profit"] > 0) / len(base)
    avg_trades = st.mean([x["trades"] for x in base])

    # miglior pass realistico: fra i validi con PF>1, il Profit piu' alto;
    # se nessuno, il Profit piu' alto in assoluto fra i base
    cand = [x for x in base if x["pf"] > 1.0 and x["profit"] > 0]
    best = max(cand, key=lambda x: x["profit"]) if cand else max(base, key=lambda x: x["profit"])

    low_sample = not valid
    if low_sample:
        verdict = "NO-SEGNALE"
    elif med_pf > 1.2 and pct_profit >= 60:
        verdict = "BUONO"
    elif med_pf > 1.0 and pct_profit >= 50:
        verdict = "MODERATO"
    else:
        verdict = "SCARSO"

    return {"symbol": symbol_from_name(path), "verdict": verdict,
            "n_valid": len(valid), "n_traded": len(traded),
            "pct_profit": pct_profit, "med_pf": med_pf,
            "avg_trades": avg_trades, "best": best, "low_sample": low_sample}

VERDICT_RANK = {"BUONO": 0, "MODERATO": 1, "SCARSO": 2, "NO-SEGNALE": 3, "NO-TRADE": 4}

def side(rec):
    L = str(rec.get("long")) in ("1", "1.0", "true", "True")
    S = str(rec.get("short")) in ("1", "1.0", "true", "True")
    if L and S: return "L+S"
    if L: return "solo LONG"
    if S: return "solo SHORT"
    return "-"

def params_desc(rec):
    """Descrizione dei parametri del pass, mostrando solo quelli presenti."""
    parts = [side(rec)]
    for key, lbl in (("buffer", "buf"), ("tp2", "TP2"), ("slatr", "SLatr"),
                     ("edge", "edge"), ("tpfrac", "TPfrac")):
        v = rec.get(key)
        if v not in (None, ""):
            parts.append(f"{lbl} {v}")
    return ", ".join(parts)

def main():
    min_trades = 20
    out_csv = None
    args = []
    argv = sys.argv[1:]
    skip = False
    for i, a in enumerate(argv):
        if skip:
            skip = False
            continue
        if a == "--min-trades" and i+1 < len(argv):
            min_trades = int(argv[i+1]); skip = True
        elif a == "--csv" and i+1 < len(argv):
            out_csv = argv[i+1]; skip = True
        elif a.startswith("--"):
            continue
        else:
            args.append(a)
    if not args:
        print("Uso: python3 analyze_scan_symbols.py <cartella|files...> [--min-trades N] [--csv out.csv]")
        sys.exit(1)

    files = find_files(args)
    results = [r for r in (analyze_file(f, min_trades) for f in files) if r]
    results.sort(key=lambda r: (VERDICT_RANK.get(r["verdict"], 9), -r["med_pf"], -r["pct_profit"]))

    print(f"\n== ANALISI SCAN MULTI-SIMBOLO (min operazioni per validita': {min_trades}) ==")
    print(f"   File analizzati: {len(files)}\n")
    hdr = f"{'#':>2}  {'SIMBOLO':<10} {'VERDETTO':<10} {'PF med':>7} {'%prof':>6} {'passOK':>6} {'op.medie':>8}  MIGLIOR PASS"
    print(hdr); print("-"*len(hdr))
    for i, r in enumerate(results, 1):
        b = r["best"]
        if b:
            bestdesc = f"PF {b['pf']:.2f}  P/L {b['profit']:+.0f}  {b['trades']} op  DD {b['dd']:.1f}%  [{params_desc(b)}]"
        else:
            bestdesc = "-"
        flag = " (!)" if r["low_sample"] else ""
        print(f"{i:>2}  {r['symbol']:<10} {r['verdict']:<10}{flag} {r['med_pf']:>7.2f} {r['pct_profit']:>5.0f}% {r['n_valid']:>6} {r['avg_trades']:>8.1f}  {bestdesc}")

    print("\n(!) = nessun pass raggiunge il minimo di operazioni: statistica non affidabile.")
    print("PF med = Profit Factor MEDIANO sui pass validi (robustezza). %prof = quota di pass in profitto.\n")

    if out_csv:
        with open(out_csv, "w", newline="", encoding="utf-8") as fh:
            w = csv.writer(fh)
            w.writerow(["Simbolo","Verdetto","PF_mediano","Pct_profitto","Pass_validi","Op_medie",
                        "Best_PF","Best_PL","Best_Trades","Best_DD","Best_lato","Best_buffer","Best_TP2R"])
            for r in results:
                b = r["best"] or {}
                w.writerow([r["symbol"], r["verdict"], f"{r['med_pf']:.3f}", f"{r['pct_profit']:.1f}",
                            r["n_valid"], f"{r['avg_trades']:.1f}",
                            f"{b.get('pf',0):.3f}", f"{b.get('profit',0):.2f}", b.get('trades',0),
                            f"{b.get('dd',0):.2f}", side(b) if b else "-", b.get('buffer',''), b.get('tp2','')])
        print(f"Classifica salvata in: {out_csv}\n")

if __name__ == "__main__":
    main()
