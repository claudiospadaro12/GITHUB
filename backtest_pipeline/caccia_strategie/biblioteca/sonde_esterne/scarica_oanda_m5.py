#!/usr/bin/env python3
# Scarica M1 Oanda da FutureSharks/financial-data (GPL-3.0) e aggrega a M5.
# NON e' BCM: e' una MISURA DI OCCASIONI, mai un verdetto.
import os, sys, csv, io, pickle, urllib.request, datetime as dt

BASE = "https://raw.githubusercontent.com/FutureSharks/financial-data/master/pyfinancialdata/data/currencies/oanda"
OUT = os.path.join(os.path.dirname(os.path.abspath(__file__)), "cache")
os.makedirs(OUT, exist_ok=True)

def scarica(sym, anni):
    m5 = {}
    ok = miss = 0
    for y in anni:
        for m in range(1, 13):
            url = f"{BASE}/{sym}/{y}/oanda-{sym}-{y}-{m}.csv"
            cf = os.path.join(OUT, f"{sym}-{y}-{m}.csv")
            if not os.path.exists(cf):
                try:
                    with urllib.request.urlopen(url, timeout=90) as r:
                        data = r.read()
                    open(cf, "wb").write(data)
                except Exception as e:
                    open(cf, "wb").write(b"")
                    miss += 1
                    continue
            raw = open(cf, "rb").read()
            if not raw:
                miss += 1
                continue
            ok += 1
            rd = csv.DictReader(io.StringIO(raw.decode("utf-8", "replace")))
            for row in rd:
                t = dt.datetime.strptime(row["time"], "%Y-%m-%d %H:%M:%S")
                k = t.replace(minute=(t.minute // 5) * 5, second=0)
                o, h, l, c = float(row["open"]), float(row["high"]), float(row["low"]), float(row["close"])
                v = float(row.get("volume") or 0)
                if k not in m5:
                    m5[k] = [o, h, l, c, v]
                else:
                    b = m5[k]
                    b[1] = max(b[1], h); b[2] = min(b[2], l); b[3] = c; b[4] += v
    print(f"{sym}: file ok={ok} mancanti={miss}  barre M5={len(m5):,}", flush=True)
    if m5:
        print(f"   {min(m5):%Y-%m-%d} -> {max(m5):%Y-%m-%d}", flush=True)
    return m5

if __name__ == "__main__":
    anni = range(2012, 2021)
    out = {}
    for sym in ["XAU_USD", "USB10Y_USD", "EUR_USD"]:
        out[sym] = scarica(sym, anni)
    pickle.dump(out, open(os.path.join(OUT, "m5.pkl"), "wb"))
    print("salvato m5.pkl")
