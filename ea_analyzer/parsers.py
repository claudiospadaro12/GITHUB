"""Modulo 1: parser dei report del Strategy Tester (.htm, italiano o inglese), dei file .set e dei CSV OHLCV."""
import re, glob
import pandas as pd

_DT = re.compile(r"^\d{4}\.\d\d\.\d\d \d\d:\d\d:\d\d$")


def _read_text(path):
    b = open(path, "rb").read()
    t = b.decode("utf-16" if b[:2] in (b"\xff\xfe", b"\xfe\xff") else "utf-8", "replace")
    t = re.sub(r"<(script|style)[^>]*>.*?</\1>", "", t, flags=re.S | re.I)
    t = re.sub(r"<[^>]*>", "|", t)
    return re.sub(r"\s*\|[\s|]*", "|", t)


def _num(s):
    s = s.replace("\u00a0", "").replace(" ", "")
    try:
        return float(s)
    except ValueError:
        return float("nan")


def _rows(tokens):
    """Spezza i token in righe: una riga inizia da un orario seguito da un intero."""
    starts = [i for i in range(len(tokens) - 1) if _DT.match(tokens[i]) and tokens[i + 1].isdigit()]
    for a, b in zip(starts, starts[1:] + [len(tokens)]):
        yield tokens[a:b]


def parse_report_meta(text):
    tk = text.split("|")
    meta = {}
    for key, names in (("expert", ("Expert:",)), ("symbol", ("Simbolo:", "Symbol:")), ("period", ("Periodo:", "Period:")), ("server", ("Azienda:", "Company:"))):
        for n in names:
            if n in tk:
                meta[key] = tk[tk.index(n) + 1]
                break
    inputs = {}
    for names in (("Dati in ingresso:", "Inputs:"),):
        for n in names:
            if n in tk:
                j = tk.index(n) + 1
                while j < len(tk) and "=" in tk[j] and not tk[j].endswith(":"):
                    k, v = tk[j].split("=", 1)
                    inputs[k] = v
                    j += 1
    meta["inputs"] = inputs
    return meta


def parse_mt5_report(path):
    """Ritorna dict(meta, orders, deals, trades). trades = una riga per posizione chiusa (abbinamento FIFO per volume)."""
    t = _read_text(path)
    meta = parse_report_meta(t)
    tk = t.split("|")
    # --- ordini
    orders = []
    io = next((i for i, x in enumerate(tk) if x in ("Ordini", "Orders")), None)
    ideals = next((i for i, x in enumerate(tk) if x in ("Affari", "Deals")), None)
    if io is not None:
        end = ideals if ideals and ideals > io else len(tk)
        for r in _rows(tk[io:end]):
            if len(r) < 6:
                continue
            nums, k = [], 6
            while k < len(r) and not _DT.match(r[k]):
                nums.append(_num(r[k])); k += 1
            rest = r[k + 1:] if k < len(r) else []
            orders.append(dict(time=r[0], order=int(r[1]), symbol=r[2], type=r[3], volume=_num(r[4].split("/")[0]),
                               price=_num(r[5]) if len(r) > 5 else float("nan"), sl_tp=nums, state=(rest[0] if rest else ""), comment=(rest[1] if len(rest) > 1 else "")))
    orders = pd.DataFrame(orders)
    # --- affari
    deals = []
    if ideals is not None:
        for r in _rows(tk[ideals:]):
            if len(r) >= 3 and r[2] == "balance":
                continue
            if len(r) < 12:
                continue
            deals.append(dict(time=pd.Timestamp(r[0].replace(".", "-", 2)), deal=int(r[1]), symbol=r[2], type=r[3], direction=r[4], volume=_num(r[5]),
                              price=_num(r[6]), order=int(r[7]), commission=_num(r[8]), swap=_num(r[9]), profit=_num(r[10]), balance=_num(r[11]),
                              comment=(r[12] if len(r) > 12 else "")))
    deals = pd.DataFrame(deals)
    return dict(meta=meta, orders=orders, deals=deals, trades=_pair_trades(deals, orders))


def _pair_trades(deals, orders):
    if deals is None or len(deals) == 0:
        return pd.DataFrame()
    sltp = {}
    if orders is not None and len(orders):
        for _, o in orders.iterrows():
            sltp[o["order"]] = o["sl_tp"]
    openp, out = [], []
    for _, d in deals.iterrows():
        if d["direction"] == "in":
            openp.append(dict(t=d["time"], side=d["type"], vol=d["volume"], px=d["price"], order=d["order"], com=d["comment"], bal=d["balance"] - d["commission"], cm=d["commission"]))
        elif d["direction"] in ("out", "in/out"):
            side_open = "buy" if d["type"] == "sell" else "sell"
            vol = d["volume"]
            for p in list(openp):
                if p["side"] != side_open or vol <= 1e-9:
                    continue
                take = min(vol, p["vol"]); frac = take / d["volume"]
                nums = sltp.get(p["order"], []); sl = tp = float("nan")
                for v in nums:
                    if (p["side"] == "buy" and v < p["px"]) or (p["side"] == "sell" and v > p["px"]):
                        sl = v
                    else:
                        tp = v
                out.append(dict(open_time=p["t"], close_time=d["time"], side=p["side"], volume=take, open_price=p["px"], close_price=d["price"], sl=sl, tp=tp,
                                profit=d["profit"] * frac, swap=d["swap"] * frac, commission=p["cm"] * (take / p["vol"]) + d["commission"] * frac,
                                comment_open=p["com"], comment_close=d["comment"], balance_before=p["bal"], order_open=p["order"]))
                p["vol"] -= take; vol -= take
                if p["vol"] <= 1e-9:
                    openp.remove(p)
                if vol <= 1e-9:
                    break
    return pd.DataFrame(out)


def parse_set(path):
    """Legge un .set (UTF-16 o UTF-8). Ritorna dict nome -> dict(valore, minimo, passo, massimo, ottimizza, righe_commento)."""
    b = open(path, "rb").read()
    t = b.decode("utf-16" if b[:2] in (b"\xff\xfe", b"\xfe\xff") else "utf-8", "replace").lstrip("\ufeff")
    out, comments = {}, []
    for line in t.splitlines():
        line = line.strip().lstrip("\ufeff")
        if not line:
            continue
        if line.startswith(";"):
            comments.append(line[1:].strip()); continue
        if "=" not in line:
            continue
        k, v = line.split("=", 1)
        p = v.split("||")
        out[k] = dict(valore=p[0], minimo=p[1] if len(p) > 1 else None, passo=p[2] if len(p) > 2 else None, massimo=p[3] if len(p) > 3 else None,
                      ottimizza=(p[4] == "Y") if len(p) > 4 else False)
    out["_commenti"] = comments
    return out


def diff_sets(a, b):
    """Test differenziale: elenco dei parametri con valore diverso fra due set."""
    keys = sorted((set(a) | set(b)) - {"_commenti"})
    return {k: (a.get(k, {}).get("valore"), b.get(k, {}).get("valore")) for k in keys if a.get(k, {}).get("valore") != b.get(k, {}).get("valore")}


def load_ohlcv(patterns, sep=";", drop_aggregate_row=False):
    """CSV esportati da ABTG_ExportM1 (time;open;high;low;close;tickvol;spread). drop_aggregate_row: scarta la riga 00:00 con tickvol > 2000 (oro FTMO)."""
    fr = []
    for pat in ([patterns] if isinstance(patterns, str) else patterns):
        for f in sorted(glob.glob(pat)):
            d = pd.read_csv(f, sep=sep); d.columns = [c.lower() for c in d.columns]
            if drop_aggregate_row and "tickvol" in d:
                d = d[~(d["time"].str.endswith("00:00") & (d["tickvol"] > 2000))]
            fr.append(d)
    d = pd.concat(fr)
    d["time"] = pd.to_datetime(d["time"], format="%Y.%m.%d %H:%M")
    return d.drop_duplicates("time").set_index("time").sort_index()
