#!/usr/bin/env python3
# -*- coding: ascii -*-
"""
natura_motore_da_storico.py -- descrive la NATURA del motore degli EA "scatola nera"
(EA del Market o di terzi, senza sorgente) dal loro STORICO di operazioni.
Richiesta di Claudio, 13/10/2026: "STASERA VEDIAMO CON LA PAGELLA COME VANNO E SE
SONO VALIDI ... POTREMMO CAPIRE LA NATURA DEL MOTORE E PRENDERE SPUNTI" e
"L'IMPORTANTE E' CHE TU RIESCA A CAPIRE DAL COMMENTO".

E' uno strumento DESCRITTIVO. Non emette MAI un verdetto di merito, di promozione
o di archivio: ogni etichetta della sezione NATURA e' un'IPOTESI DA MISURARE, con
la soglia scritta qui sotto (e stampata PRIMA dei numeri) e il suo n accanto.

FORMATI LETTI (si dichiara sempre quale):
  xlsx  report storico MT5 ("Report Cronistorico dei Trade", italiano; regge anche
        i titoli inglesi): un foglio solo a sezioni Posizioni / Ordini / Affari /
        Posizioni aperte / Ordini attivi / Risultati, oppure fogli con quei nomi.
        Letto con openpyxl se c'e', altrimenti con zipfile + XML (stdlib).
        HA: S/L e T/P iniziali (ordine d'apertura) e finali, commento d'apertura,
        tipo d'ordine (market/pendente), posizioni aperte.  NON HA: il magic.
  csv   esportazione di ABTG_TradeExporter = la fonte della PAGELLA serale
        (data/statements/trades_auto.csv, separatore ';': pid;symbol;side;volume;
        open_time;open_price;close_time;close_price;commission;swap;profit;
        strategy;magic;close_reason;...). HA: magic, motivo d'uscita.
        NON HA: S/L e T/P (ne' iniziali ne' finali), posizioni aperte, ordini.
        NB: la pagella .md (report/giornata_*.md) e' solo un AGGREGATO: non basta.

IL GRUPPO E' LA FAMIGLIA DEL COMMENTO D'APERTURA (poi, nel csv, anche il magic):
  - il commento valido e' quello dell'ORDINE/DEAL DI APERTURA (id ordine = id
    posizione: verificato sul report reale del 12/10); i commenti automatici del
    broker sulle chiusure ('[sl ...]', '[tp ...]', '[so ...]', 'so:', 'expired')
    NON creano gruppi;
  - normalizzazione in FAMIGLIA: spazi compattati, simbolo -> {SIMB}, frazione di
    gamba finale ('1/3') tolta, lato finale (L/S/B/BUY/SELL/LONG/SHORT + cifre)
    tolto e tenuto come 'lato dichiarato', contatori numerici (1-4 cifre) fra '_'
    o in coda -> '*'; confronto senza maiuscole;
  - famiglia NOSTRA se (a) il primo token utile coincide col primo token di un
    commento di default dei nostri sorgenti (mql5/Experts/*.mq5, input string
    *Comment*/*Tag*/*Prefix*, letto a runtime) oppure (b) sta nell'elenco
    dichiarato FAMIGLIE_NOSTRE_CAMPO qui sotto. Altrimenti NON RICONOSCIUTA
    (terzi/Market, o nostra non censita): e' un'attribuzione, non una misura.

USO:
  python3 -I backtest_pipeline/natura_motore_da_storico.py <file.xlsx|file.csv>
          [--simbolo XAUUSD] [--dal 2026.10.11] [--al 2026.10.13]
          [--solo-non-nostre] [--formato auto|xlsx|csv]
  python3 -I backtest_pipeline/natura_motore_da_storico.py --autotest [--reale <xlsx 12/10>]

COSA NON COPRE (stampato anche in testa al referto): MAE/MFE (non stanno in nessuno
dei due formati); spread (il report non lo porta: il cancello 'stop >= 40 x spread'
NON e' verificabile da qui); chiusure parziali (non ricostruite); uno SL messo con
una modifica dopo l'ingresso si vede SOLO se a fine vita e' ancora dal lato della
perdita (allora e' contato a parte, NON come 'senza SL'); il magic nel xlsx; due EA
diversi con lo stesso commento nel xlsx (nel csv si', via magic: l'analisi si separa).

CANCELLO 13/10/2026 (controllo-preventivo): v1 -> v2 con 10 difetti corretti, ognuno
con il suo contro-esempio nell'autotest (sezione "CONTRO-ESEMPI"): deposito 'balance'
nel netto/PF degli Affari; SL messo con modifica certificato 'senza SL'; straddle nello
stesso secondo non visto come hedging; stesso commento con piu' magic fuso nell'analisi;
';' nel commento del csv; numeri '1.234,56'; commento d'EA 'Cancello...' preso per
broker; data --dal illeggibile -> crash; merito contato su chiuse+aperte; fusioni '*'
e attribuzione NOSTRA per prefisso non dichiarate. Tutto in CHECKLIST classi 1403-1408.
"""
import sys, os, re, io, csv, math, zipfile, argparse, statistics, datetime as dt
import xml.etree.ElementTree as ET

# ======================= SOGLIE (dichiarate PRIMA dei numeri) ==================
SOGLIA_N_SOTTILE   = 30     # sotto: "campione sottile: NON MISURATO per il merito"
SOGLIA_N_MERITO    = 150    # regola di casa (16/08): merito solo da n >= 150
TOLL_SEC_BARRA     = 2      # secondi di tolleranza dall'apertura della barra
SOGLIA_BARRA       = 0.80   # quota d'ingressi allineati alla barra del TF
SOGLIA_MIN_TONDI   = 0.80   # quota d'ingressi a minuto multiplo di 5
SOGLIA_ORARIO_FISSO = 0.50  # quota del HH:MM piu' frequente (con n >= 3)
SOGLIA_SENZA_SL    = 0.50   # quota di posizioni senza SL nell'ordine d'apertura
SOGLIA_SENZA_TP    = 0.50
SOGLIA_SL_MOSSO    = 0.30   # quota di posizioni con SL finale != iniziale
GRIGLIA_ORE        = 24.0   # finestra della catena di medie
GRIGLIA_MIN_INGR   = 3      # ingressi in catena (primo + 2 medie) per 'griglia'
MART_MIN_AGGIUNTE  = 2      # medie con lotto crescente per 'martingala'
RECUPERO_MIN_CASI  = 2      # lotto salito dopo una perdita, almeno
RECUPERO_FRAZ      = 0.50   # e almeno questa quota dei casi dopo perdita
HEDGE_MIN_COPPIE   = 1      # coppie buy/sell vive insieme nella stessa famiglia
RR_ASIMM           = 1.5    # SL/TP mediano >= 1,5 o <= 1/1,5
SCALP_MIN          = 60.0   # durata mediana < 60 min -> 'scalping'
LUNGH_TRONCATO     = 31     # MT5 tronca i commenti a 31 caratteri

TF_SEC = [("D1", 86400), ("H4", 14400), ("H1", 3600), ("M30", 1800),
          ("M15", 900), ("M5", 300), ("M1", 60)]

# Famiglie NOSTRE viste in campo che NON derivano dal default del sorgente
# (preset o nomi costruiti). Fonte: data/statements/trades_auto.csv e
# trades_100k.csv, coppie commento|magic con magic dei nostri sorgenti o del
# piano di schieramento (report/PIANO_SCHIERAMENTO_PICCOLO_DEMO_2026-10-11.md).
# Elenco costruito il 13/10/2026; chiave = primo token utile, MAIUSCOLO.
FAMIGLIE_NOSTRE_CAMPO = {
    "GAP": "GAP {SIMB} L/S, magic 772233 (piano schieramento 11/10)",
    "DAX": "DAX Apertura EU / DAX Live 5m / DAX M3 (770101, 770103, 770121, 770501)",
    "NASDAQ": "Nasdaq Apertura US / Nasdaq Live 5m (770201, 770203)",
    "LONDRA": "Londra BUY/SELL (770701)",
    "APERTURA": "Apertura Marco (770311)",
    "SW": "SW DOW H2 (770531)",
    "ORO": "{SIMB} ORO BUY/SELL = MaxMin oro (770402)",
}
# EA di terzi gia' NOMINATI dalle sonde del VPS (attribuzione, non misura).
TERZI_NOTI = {
    "BASKET": "Grid Scalper MA MT5 EA, magic 1234567 (CODA_09 r.63/r.67 del 12/10)",
    "SSP": "SafeScalperPro v4.00, AlgoSphere Quant, magic 202504 (CODA_09 r.34-35)",
    "MINUTE": "IPOTESI per nome: .ex5 'XAUUSD 5 minute' sul piccolo (CODA_06 11/10)",
}

LATI = {"L": "L", "S": "S", "B": "B", "BUY": "L", "SELL": "S", "LONG": "L", "SHORT": "S"}
# Commenti AUTOMATICI del broker/terminale (cancello 13/10: con parola intera, altrimenti
# un commento d'EA come "Cancello DAX L" o "SL:20 TP:40" spariva come "del broker").
RE_BROKER = re.compile(r"^\s*(\[(sl|tp|so)\b|so:\s*[0-9.]|expired\b|cancel(l?ed)?\b)", re.I)

# ================================ utilita' =====================================
def num(x):
    if x is None: return None
    if isinstance(x, bool): return None
    if isinstance(x, (int, float)): return float(x)
    s = str(x).strip().replace("\u00a0", "").replace(" ", "").replace("'", "")
    if s == "" or s.lower() == "market": return None
    if "/" in s: s = s.split("/")[0]
    # separatori: con '.' E ',' il decimale e' l'ULTIMO dei due ("1.234,56" it-IT,
    # "1,234.56" en); con la sola ',' e' il decimale (it-IT). Cancello 13/10: prima
    # "1.234,56" dava None e il profitto diventava 0 in silenzio.
    if "," in s and "." in s:
        if s.rfind(",") > s.rfind("."): s = s.replace(".", "").replace(",", ".")
        else: s = s.replace(",", "")
    else:
        s = s.replace(",", ".")
    try: return float(s)
    except ValueError:
        NUM_ILLEGGIBILI.append(str(x)); return None

NUM_ILLEGGIBILI = []   # valori numerici non vuoti che non si leggono: dichiarati nel referto

def tempo(x):
    if x is None: return None
    if isinstance(x, dt.datetime): return x
    if isinstance(x, (int, float)) and 20000 < x < 80000:
        return dt.datetime(1899, 12, 30) + dt.timedelta(days=float(x))
    s = str(x).strip()
    for f in ("%Y.%m.%d %H:%M:%S", "%Y.%m.%d %H:%M", "%Y-%m-%d %H:%M:%S", "%Y-%m-%d %H:%M",
              "%Y.%m.%d", "%Y-%m-%d"):
        try: return dt.datetime.strptime(s, f)
        except ValueError: pass
    return None

def fmt(x, d=2):
    if x is None: return "-"
    if isinstance(x, float) and math.isinf(x): return "inf"
    return ("%." + str(d) + "f") % x

def med(v):
    v = [a for a in v if a is not None]
    return statistics.median(v) if v else None

# ============================ lettura xlsx =====================================
NS = "{http://schemas.openxmlformats.org/spreadsheetml/2006/main}"
NSR = "{http://schemas.openxmlformats.org/officeDocument/2006/relationships}"

def _col(ref):
    n = 0
    for ch in ref:
        if ch.isalpha(): n = n * 26 + (ord(ch.upper()) - 64)
        else: break
    return n - 1

def leggi_xlsx_xml(path):
    """Lettore stdlib: ritorna [(nome_foglio, [righe])]."""
    z = zipfile.ZipFile(path)
    shared = []
    if "xl/sharedStrings.xml" in z.namelist():
        for si in ET.fromstring(z.read("xl/sharedStrings.xml")).iter(NS + "si"):
            shared.append("".join(t.text or "" for t in si.iter(NS + "t")))
    wb = ET.fromstring(z.read("xl/workbook.xml"))
    rels = {}
    if "xl/_rels/workbook.xml.rels" in z.namelist():
        for r in ET.fromstring(z.read("xl/_rels/workbook.xml.rels")):
            rels[r.get("Id")] = r.get("Target")
    out = []
    for sh in wb.iter(NS + "sheet"):
        tgt = rels.get(sh.get(NSR + "id"), "")
        tgt = tgt.lstrip("/")
        if not tgt.startswith("xl/"): tgt = "xl/" + tgt
        righe = []
        for row in ET.fromstring(z.read(tgt)).iter(NS + "row"):
            cells = {}
            for i, c in enumerate(row.iter(NS + "c")):
                ref = c.get("r"); k = _col(ref) if ref else i
                t = c.get("t"); v = c.find(NS + "v")
                if t == "s": val = shared[int(v.text)] if v is not None else None
                elif t == "inlineStr":
                    val = "".join(x.text or "" for x in c.iter(NS + "t"))
                elif t == "str": val = v.text if v is not None else None
                elif t == "b": val = bool(int(v.text)) if v is not None else None
                elif t == "e": val = None
                else:
                    if v is None or v.text is None: val = None
                    elif re.fullmatch(r"-?\d+", v.text): val = int(v.text)
                    else: val = float(v.text)
                cells[k] = val
            n = max(cells) + 1 if cells else 0
            righe.append([cells.get(j) for j in range(n)])
        out.append((sh.get("name"), righe))
    return out

def leggi_xlsx(path, forza_xml=False):
    if not forza_xml:
        try:
            import warnings, openpyxl
            with warnings.catch_warnings():
                warnings.simplefilter("ignore")
                wb = openpyxl.load_workbook(path, read_only=True, data_only=True)
                out = []
                for ws in wb.worksheets:
                    try: ws.reset_dimensions()
                    except Exception: pass
                    out.append((ws.title, [list(r) for r in ws.iter_rows(values_only=True)]))
                wb.close()
            return out, "openpyxl"
        except ImportError:
            pass
    return leggi_xlsx_xml(path), "zipfile+XML (stdlib)"

SEZIONI = {"posizioni": "POS", "positions": "POS", "ordini": "ORD", "orders": "ORD",
           "affari": "DEAL", "deals": "DEAL", "posizioni aperte": "OPEN",
           "open positions": "OPEN", "ordini attivi": "WORK", "working orders": "WORK",
           "risultati": "RES", "results": "RES"}

def sezioni_xlsx(fogli):
    sez = {k: [] for k in ("POS", "ORD", "DEAL", "OPEN", "WORK", "RES", "TESTA")}
    for nome, righe in fogli:
        cur = SEZIONI.get(str(nome).strip().lower(), "TESTA"); hdr_attesa = cur != "TESTA"
        for r in righe:
            vals = [c for c in r if c is not None and str(c).strip() != ""]
            if not vals:
                continue
            c0 = r[0]
            if isinstance(c0, str) and len(vals) == 1 and c0.strip().lower() in SEZIONI:
                cur = SEZIONI[c0.strip().lower()]; hdr_attesa = cur != "RES"; continue
            if hdr_attesa:
                hdr_attesa = False; continue
            sez[cur].append(r)
    return sez

def cella(r, i):
    return r[i] if i < len(r) else None

def posizioni_da_xlsx(path, forza_xml=False):
    del NUM_ILLEGGIBILI[:]
    fogli, lettore = leggi_xlsx(path, forza_xml)
    sez = sezioni_xlsx(fogli)
    meta = {"formato": "xlsx (report storico MT5)", "lettore": lettore, "avvisi": []}
    for r in sez["TESTA"]:
        lab = str(r[0] or "").strip().lower()
        val = next((c for c in r[1:] if c is not None), None)
        if lab.startswith("conto") or lab.startswith("account"): meta["conto"] = val
        if lab.startswith("data") or lab.startswith("date"): meta["ora_report"] = tempo(val)
    # Ordini: id -> (ora, tipo, sl, tp, commento, stato)
    ordini = {}
    for r in sez["ORD"]:
        oid = cella(r, 1)
        if tempo(cella(r, 0)) is None or oid is None: continue
        ordini[int(oid)] = dict(t=tempo(cella(r, 0)), tipo=str(cella(r, 3) or ""),
                                sl=num(cella(r, 6)) or None, tp=num(cella(r, 7)) or None,
                                stato=str(cella(r, 9) or ""), comm=cella(r, 11), sym=cella(r, 2),
                                vol=cella(r, 4), t_fine=tempo(cella(r, 8)))
    deals = []
    for r in sez["DEAL"]:
        if tempo(cella(r, 0)) is None or cella(r, 1) is None: continue
        deals.append(dict(t=tempo(cella(r, 0)), sym=cella(r, 2), tipo=str(cella(r, 3) or ""),
                          dir=str(cella(r, 4) or "").lower(), vol=num(cella(r, 5)),
                          prezzo=num(cella(r, 6)), ordine=int(cella(r, 7)) if cella(r, 7) else None,
                          comm=num(cella(r, 8)) or 0.0, fee=num(cella(r, 9)) or 0.0,
                          swap=num(cella(r, 10)) or 0.0, profit=num(cella(r, 11)) or 0.0,
                          commento=cella(r, 13)))
    deal_in = {d["ordine"]: d for d in deals if d["dir"] == "in" and d["ordine"]}
    pos = []
    scartate = 0
    for r in sez["POS"]:
        if tempo(cella(r, 0)) is None or cella(r, 1) is None:
            # riga dei totali (ne' ora ne' id) = normale; con ora O id ma illeggibile = scarto da dichiarare
            if cella(r, 0) not in (None, "") or cella(r, 1) not in (None, ""): scartate += 1
            continue
        pid = int(cella(r, 1)); o = ordini.get(pid); di = deal_in.get(pid)
        p = dict(pid=pid, sym=str(cella(r, 2)), side=str(cella(r, 3)).lower(),
                 vol=num(cella(r, 4)), t_open=tempo(cella(r, 0)), p_open=num(cella(r, 5)),
                 t_close=tempo(cella(r, 8)), p_close=num(cella(r, 9)),
                 sl1=num(cella(r, 6)) or None, tp1=num(cella(r, 7)) or None,
                 comm=num(cella(r, 10)) or 0.0, swap=num(cella(r, 11)) or 0.0,
                 profit=num(cella(r, 12)) or 0.0, aperta=False, magic=None)
        _apertura(p, o, di)
        # chiusura: deal 'out' stesso simbolo, stessa ora, stesso prezzo
        p["reason"] = "?"
        for d in deals:
            if (d["dir"] == "out" and d["sym"] == p["sym"] and d["t"] == p["t_close"]
                    and d["prezzo"] is not None and p["p_close"] is not None
                    and abs(d["prezzo"] - p["p_close"]) < 1e-9):
                c = str(d["commento"] or "")
                m = re.match(r"^\[(sl|tp|so)\s*([0-9.]*)", c, re.I)
                if m:
                    p["reason"] = m.group(1).lower()
                    if m.group(1).lower() == "sl" and m.group(2):
                        p["sl1"] = float(m.group(2))
                else:
                    p["reason"] = "altro (EA/manuale)"
                break
        pos.append(p)
    for r in sez["OPEN"]:
        if tempo(cella(r, 0)) is None or cella(r, 1) is None:
            # riga dei totali (ne' ora ne' id) = normale; con ora O id ma illeggibile = scarto da dichiarare
            if cella(r, 0) not in (None, "") or cella(r, 1) not in (None, ""): scartate += 1
            continue
        pid = int(cella(r, 1)); o = ordini.get(pid); di = deal_in.get(pid)
        p = dict(pid=pid, sym=str(cella(r, 2)), side=str(cella(r, 3)).lower(),
                 vol=num(cella(r, 4)), t_open=tempo(cella(r, 0)), p_open=num(cella(r, 5)),
                 t_close=None, p_close=num(cella(r, 8)), sl1=num(cella(r, 6)) or None,
                 tp1=num(cella(r, 7)) or None, comm=(di["comm"] if di else 0.0),
                 swap=num(cella(r, 9)) or 0.0, profit=num(cella(r, 11)) or 0.0,
                 aperta=True, magic=None, reason="(aperta)")
        _apertura(p, o, di, commento_riga=cella(r, 12))
        pos.append(p)
    if scartate:   # cancello 13/10: una riga di posizione illeggibile non sparisce in silenzio
        meta["avvisi"].append("%d righe nelle sezioni Posizioni/Posizioni aperte SCARTATE (ora o id illeggibili): "
                              "i conteggi qui sotto NON le contengono" % scartate)
    # ordini pendenti mai eseguiti (scaduti/cancellati) e attivi: solo conteggio
    meta["pendenti_non_eseguiti"] = [o for oid, o in ordini.items()
                                     if o["stato"].lower() not in ("filled", "eseguito")
                                     and o["tipo"].lower() not in ("buy", "sell")]
    meta["ordini_attivi"] = [dict(sym=cella(r, 2), tipo=cella(r, 3), comm=cella(r, 11))
                             for r in sez["WORK"] if tempo(cella(r, 0))]
    # Risultati dichiarati dal report (per il controllo di coerenza)
    for r in sez["RES"]:
        for i, c in enumerate(r):
            if not isinstance(c, str): continue
            lab = c.strip().lower()
            val = next((x for x in r[i + 1:] if x is not None), None)
            if lab.startswith("profitto totale netto") or lab.startswith("total net profit"):
                meta["res_netto"] = num(val)
            if lab.startswith("fattore di profitto") or lab.startswith("profit factor"):
                meta["res_pf"] = num(val)
    # cancello 13/10: SOLO i deal di trading (buy/sell). Prima entravano anche 'balance'
    # (deposito, saldo iniziale): sul cronistorico FTMO del 30/09 il "PF ricalcolato" usciva
    # 8,838 contro 0,248 dichiarato, perche' il saldo iniziale di 80.000 contava come profitto.
    tr = [d for d in deals if d["tipo"].strip().lower() in ("buy", "sell")]
    altri = [d for d in deals if d not in tr]
    if altri:
        meta["avvisi"].append("%d deal NON di trading (%s) esclusi da netto e PF degli Affari, importo %s"
                              % (len(altri), ", ".join(sorted({d["tipo"] for d in altri})),
                                 fmt(sum(d["profit"] for d in altri))))
    meta["deal_netto"] = sum(d["profit"] + d["comm"] + d["fee"] + d["swap"] for d in tr)
    meta["n_deal"] = len(tr)
    dn = [d["profit"] + d["comm"] + d["fee"] + d["swap"] for d in tr]
    gl_ = -sum(x for x in dn if x < 0)
    meta["deal_pf"] = (sum(x for x in dn if x > 0) / gl_) if gl_ > 0 else None
    return pos, meta

def _apertura(p, o, di, commento_riga=None):
    """Commento, ora d'ordine, tipo e SL/TP INIZIALI dall'ordine d'apertura (id = pid)."""
    comm = None; fonte = None
    if o is not None and o["comm"] not in (None, "") and not RE_BROKER.match(str(o["comm"])):
        comm, fonte = o["comm"], "ordine d'apertura"
    elif di is not None and di["commento"] not in (None, "") and not RE_BROKER.match(str(di["commento"])):
        comm, fonte = di["commento"], "deal d'ingresso"
    elif commento_riga not in (None, "") and not RE_BROKER.match(str(commento_riga)):
        comm, fonte = commento_riga, "riga posizione aperta"
    p["commento"] = comm; p["fonte_commento"] = fonte
    p["apertura_in_finestra"] = o is not None or di is not None
    p["t_ordine"] = o["t"] if o is not None else p["t_open"]
    p["tipo_ordine"] = (o["tipo"].lower() if o is not None else "?")
    p["sl0"] = o["sl"] if o is not None else None
    p["tp0"] = o["tp"] if o is not None else None
    p["sl0_noto"] = o is not None

# ============================== lettura csv ====================================
def posizioni_da_csv(path):
    del NUM_ILLEGGIBILI[:]
    with open(path, encoding="utf-8", errors="replace") as f:
        righe = list(csv.reader(f, delimiter=";"))
    if not righe:
        sys.exit("ERRORE: csv vuoto (nessuna riga, nemmeno l'intestazione): %s" % path)
    hdr = [h.strip().lower() for h in righe[0]]
    ix = {h: i for i, h in enumerate(hdr)}
    for k in ("pid", "symbol", "side", "open_time", "close_time", "profit", "strategy"):
        if k not in ix: sys.exit("ERRORE: il csv non ha la colonna '%s': non e' l'esportazione di ABTG_TradeExporter" % k)
    pos = []; corte = 0; ricucite = 0; illeggibili = 0
    for r in righe[1:]:
        if not any(c.strip() for c in r): continue
        if len(r) < len(hdr): corte += 1; continue
        if len(r) > len(hdr):
            # cancello 13/10: l'esportatore scrive con FileWrite(';') e NON quota: un ';'
            # dentro il commento sposta le colonne (magic letto dal commento). Si ricuce
            # la colonna strategy, l'unica testuale libera.
            e = len(r) - len(hdr); i = ix["strategy"]
            r = r[:i] + [";".join(r[i:i + e + 1])] + r[i + e + 1:]; ricucite += 1
        g = lambda k: r[ix[k]] if k in ix else None
        if not (g("pid") or "").strip().isdigit() or tempo(g("open_time")) is None or tempo(g("close_time")) is None:
            illeggibili += 1; continue
        comm = g("strategy") or None
        p = dict(pid=int(g("pid")), sym=g("symbol"), side=(g("side") or "").lower(),
                 vol=num(g("volume")), t_open=tempo(g("open_time")), p_open=num(g("open_price")),
                 t_close=tempo(g("close_time")), p_close=num(g("close_price")),
                 sl1=None, tp1=None, sl0=None, tp0=None, sl0_noto=False,
                 comm=num(g("commission")) or 0.0, swap=num(g("swap")) or 0.0,
                 profit=num(g("profit")) or 0.0, aperta=False, magic=g("magic"),
                 reason=g("close_reason") or "?", tipo_ordine="?",
                 commento=None if (comm and RE_BROKER.match(comm)) else comm,
                 fonte_commento="colonna strategy", apertura_in_finestra=True)
        p["t_ordine"] = p["t_open"]
        pos.append(p)
    meta = {"formato": "csv (ABTG_TradeExporter = fonte della pagella)", "lettore": "csv stdlib",
            "avvisi": ["formato csv: S/L e T/P NON DISPONIBILI (ne' iniziali ne' finali), "
                       "nessuna posizione aperta, nessun ordine pendente"],
            "pendenti_non_eseguiti": [], "ordini_attivi": []}
    if corte or illeggibili:
        meta["avvisi"].append("%d righe SCARTATE (%d con meno colonne dell'intestazione, %d con pid/ora illeggibili): "
                              "i conteggi qui sotto NON le contengono" % (corte + illeggibili, corte, illeggibili))
    if ricucite:
        meta["avvisi"].append("%d righe con ';' dentro il commento: colonna strategy RICUCITA (verificare a occhio)" % ricucite)
    if pos: meta["ora_report"] = max(p["t_close"] for p in pos if p["t_close"])
    return pos, meta

# ============================ famiglie del commento ===========================
def famiglia(commento, sym, contatori=True):
    """-> (chiave MAIUSCOLA, forma leggibile, lato dichiarato o None).
    contatori=False: non sostituisce i numeri con '*' (serve a DICHIARARE le fusioni)."""
    if commento is None or str(commento).strip() == "":
        return "(SENZA COMMENTO)", "(senza commento)", None
    s = " ".join(str(commento).split())
    toks = re.split(r"([ _])", s)            # token e separatori alternati
    base = re.sub(r"[^A-Z0-9]", "", str(sym).upper())
    out = []
    for t in toks:
        tu = t.upper()
        if t not in (" ", "_") and tu and (tu == str(sym).upper() or (len(base) >= 6 and tu == base)):
            out.append("{SIMB}")
        else:
            out.append(t)
    def ultimo():
        j = len(out) - 1
        while j >= 0 and out[j] in (" ", "_", ""): j -= 1
        return j
    j = ultimo()
    if j >= 0 and re.fullmatch(r"\d+/\d+", out[j]):          # gamba '1/3'
        del out[j:]; j = ultimo()
    lato = None
    if j >= 1:
        m = re.fullmatch(r"([A-Za-z]+)(\d*)", out[j])
        if m and m.group(1).upper() in LATI:
            lato = LATI[m.group(1).upper()]; del out[j - 1:]
        elif re.fullmatch(r"\d{1,4}", out[j]) and j >= 4 and out[j - 2].upper() in LATI and out[j - 1] in (" ", "_"):
            # 'SUPERWAVE SELL 1' = lato + contatore (cancello 13/10: prima restava 'SUPERWAVE SELL *',
            # famiglia diversa da 'SUPERWAVE SELL ' dello stesso EA)
            lato = LATI[out[j - 2].upper()]; del out[j - 3:]
    if not contatori:
        disp = "".join(out).strip(" _") or "(vuoto dopo normalizzazione)"
        return disp.upper(), disp, lato
    for k, t in enumerate(out):                              # contatori -> *
        if re.fullmatch(r"\d{1,4}", t):
            prima = out[k - 1] if k >= 1 else ""
            dopo = out[k + 1] if k + 1 < len(out) else ""
            if (prima == "_" and dopo in ("_", "")) or (k == len(out) - 1 and prima in (" ", "_")):
                out[k] = "*"
    disp = "".join(out).strip(" _") or "(vuoto dopo normalizzazione)"
    return disp.upper(), disp, lato

def primo_token(chiave):
    for t in re.split(r"[ _]", chiave):
        if t and t != "{SIMB}" and t != "*" and not re.fullmatch(r"\d+", t):
            return t.upper()
    return ""

def prefisso_casa(disp):
    m = re.match(r"[A-Z]{3,}", disp)
    if m: return m.group(0)
    m = re.match(r"[A-Za-z]+", disp)
    return m.group(0).upper() if m and len(m.group(0)) >= 3 else None

MAGIC_SRC = {}   # magic di default dei sorgenti -> [file] (riempito da token_nostri; piu' file = magic condiviso)

def token_nostri(radice):
    """Primo token dei commenti di default nei nostri sorgenti (letti ora).
    Raccoglie anche i MAGIC di default (riscontro incrociato nel csv, cancello 13/10)."""
    d = os.path.join(radice, "mql5", "Experts")
    tok = {}
    MAGIC_SRC.clear()
    if not os.path.isdir(d): return tok, 0
    n = 0
    pat = re.compile(r'input\s+string\s+Inp\w*(Comment|Tag|Prefix)\w*\s*=\s*"([^"]*)"')
    patm = re.compile(r'input\s+(?:long|ulong|int|uint)\s+Inp\w*Magic\w*\s*=\s*(\d+)')
    for f in sorted(os.listdir(d)):
        if not f.endswith(".mq5"): continue
        n += 1
        try: txt = open(os.path.join(d, f), encoding="utf-8", errors="replace").read()
        except OSError: continue
        for m in pat.finditer(txt):
            t = primo_token(m.group(2).upper())
            if t: tok.setdefault(t, f)
        for m in patm.finditer(txt):
            if m.group(1) != "0" and f not in MAGIC_SRC.setdefault(m.group(1), []): MAGIC_SRC[m.group(1)].append(f)
    return tok, n

def provenienza(chiave, tok_src):
    t = primo_token(chiave)
    if t in tok_src: return "NOSTRA", "per PREFISSO '%s' = default commento in %s" % (t, tok_src[t])
    if t in FAMIGLIE_NOSTRE_CAMPO: return "NOSTRA", "per PREFISSO '%s', campo: %s" % (t, FAMIGLIE_NOSTRE_CAMPO[t])
    for k, v in TERZI_NOTI.items():
        if t.startswith(k): return "NON RICONOSCIUTA", "terzi: " + v
    return "NON RICONOSCIUTA", "terzi/Market o nostra non censita"

# ================================ analisi ======================================
def vivo(p, t, ora_fine):
    fine = p["t_close"] or ora_fine
    return p["t_open"] <= t < fine

def netto(p): return p["profit"] + p["comm"] + p["swap"]

def valore_unita(pos):
    """EUR per 1,0 di prezzo per 1 lotto, stimato dai P/L chiusi del file (per simbolo)."""
    v = {}
    for p in pos:
        if p["aperta"] or not p["vol"] or p["p_close"] is None or p["p_open"] is None: continue
        dpx = (p["p_close"] - p["p_open"]) * (1 if p["side"] == "buy" else -1)
        if abs(dpx) < 1e-12 or p["profit"] == 0: continue
        v.setdefault(p["sym"], []).append(p["profit"] / (dpx * p["vol"]))
    return {k: statistics.median(a) for k, a in v.items()}

def allineamento(tempi):
    n = len(tempi)
    if n == 0: return None, {}
    quote = {}
    for nome, sec in TF_SEC:
        k = sum(1 for t in tempi
                if ((t - dt.datetime(2000, 1, 3)).total_seconds() % sec) <= TOLL_SEC_BARRA)
        quote[nome] = k
    best = next((nome for nome, _ in TF_SEC if quote[nome] / n >= SOGLIA_BARRA), None)
    return best, quote

def analizza(grp, ora_fine, vpu):
    """grp = posizioni di UNA famiglia su UN simbolo. Ritorna dizionario descrittivo."""
    g = sorted(grp, key=lambda p: p["t_open"])
    ch = [p for p in g if not p["aperta"]]; ap = [p for p in g if p["aperta"]]
    A = dict(n=len(g), n_ch=len(ch), n_ap=len(ap),
             n_L=sum(p["side"] == "buy" for p in g), n_S=sum(p["side"] == "sell" for p in g))
    A["netto_L"] = sum(netto(p) for p in ch if p["side"] == "buy")
    A["netto_S"] = sum(netto(p) for p in ch if p["side"] == "sell")
    A["lordo"] = sum(p["profit"] for p in ch); A["netto"] = sum(netto(p) for p in ch)
    gp = sum(netto(p) for p in ch if netto(p) > 0); gl = -sum(netto(p) for p in ch if netto(p) < 0)
    A["pf"] = (gp / gl) if gl > 0 else (float("inf") if gp > 0 else None)
    A["flottante"] = sum(p["profit"] for p in ap)
    best = sorted((netto(p) for p in ch), reverse=True)[:3]
    A["top3"] = sum(best) if ch else None
    A["top3_su_lordo_pos"] = (sum(b for b in best if b > 0) / gp) if gp > 0 else None
    # tempi d'ingresso: ora dell'ORDINE (per i pendenti e' il piazzamento)
    tt = [p["t_ordine"] for p in g if p["t_ordine"]]
    A["ore"] = {}
    for t in tt: A["ore"][t.hour] = A["ore"].get(t.hour, 0) + 1
    A["min_tondi"] = sum(1 for t in tt if t.minute % 5 == 0 and t.second <= TOLL_SEC_BARRA)
    A["sec0"] = sum(1 for t in tt if t.second == 0)
    hhmm = {}
    for t in tt: hhmm[t.strftime("%H:%M")] = hhmm.get(t.strftime("%H:%M"), 0) + 1
    A["hhmm_top"] = max(hhmm.items(), key=lambda kv: kv[1]) if hhmm else None
    A["barra"], A["quote_barra"] = allineamento(tt)
    A["n_tempi"] = len(tt)
    A["tipi_ordine"] = {}
    for p in g: A["tipi_ordine"][p["tipo_ordine"]] = A["tipi_ordine"].get(p["tipo_ordine"], 0) + 1
    dur = [(p["t_close"] - p["t_open"]).total_seconds() / 60 for p in ch if p["t_close"]]
    A["dur"] = (med(dur), min(dur), max(dur)) if dur else None
    A["uscite"] = {}
    for p in ch: A["uscite"][p["reason"]] = A["uscite"].get(p["reason"], 0) + 1
    A["sl_profitto"] = sum(1 for p in ch if p["reason"] == "sl" and netto(p) > 0)
    # SL/TP iniziali (solo dove l'ordine d'apertura e' nel file)
    noti = [p for p in g if p["sl0_noto"]]
    A["n_sl_noti"] = len(noti)
    # cancello 13/10: ordine SENZA SL ma SL PROTETTIVO (lato perdita) visto alla chiusura/ora =
    # SL messo con una modifica dopo l'ingresso. NON e' "senza SL": si conta a parte.
    for p in g:
        p["_prot_dopo"] = bool(p["sl0_noto"] and p["sl0"] is None and p["sl1"] is not None and p["p_open"] is not None
                               and ((p["side"] == "buy" and p["sl1"] < p["p_open"]) or (p["side"] == "sell" and p["sl1"] > p["p_open"])))
    A["sl_prot_dopo"] = sum(1 for p in noti if p["_prot_dopo"])
    A["senza_sl"] = sum(1 for p in noti if p["sl0"] is None and not p["_prot_dopo"])
    A["senza_tp"] = sum(1 for p in noti if p["tp0"] is None)
    sld = [abs(p["p_open"] - p["sl0"]) for p in noti if p["sl0"] is not None and p["p_open"]]
    tpd = [abs(p["p_open"] - p["tp0"]) for p in noti if p["tp0"] is not None and p["p_open"]]
    A["sl_dist"] = med(sld); A["tp_dist"] = med(tpd)
    A["sl_rng"] = (min(sld), max(sld)) if sld else None
    A["tp_rng"] = (min(tpd), max(tpd)) if tpd else None
    rr = [abs(p["p_open"] - p["sl0"]) / abs(p["p_open"] - p["tp0"]) for p in noti
          if p["sl0"] is not None and p["tp0"] is not None and abs(p["p_open"] - p["tp0"]) > 0]
    A["rr"] = med(rr); A["n_rr"] = len(rr)
    # SL mosso: finale (chiusura o attuale) diverso dall'iniziale
    mossi = 0; aggiunti = 0; oltre = 0; n_mv = 0
    for p in noti:
        n_mv += 1
        if p["sl0"] is None and p["sl1"] is not None:
            aggiunti += 1; mossi += 1
        elif p["sl0"] is not None and p["sl1"] is not None and abs(p["sl1"] - p["sl0"]) > 1e-9:
            mossi += 1
        if p["sl1"] is not None and p["p_open"] is not None:
            if (p["side"] == "buy" and p["sl1"] >= p["p_open"]) or (p["side"] == "sell" and p["sl1"] <= p["p_open"]):
                oltre += 1
    A["sl_mossi"], A["sl_aggiunti"], A["sl_oltre"], A["n_mv"] = mossi, aggiunti, oltre, n_mv
    # costo: commissione per lotto (andata+ritorno, solo chiuse) e stop/commissione
    cpl = [abs(p["comm"]) / p["vol"] for p in ch if p["vol"] and p["comm"]]
    A["comm_lotto"] = med(cpl)
    v = vpu.get(g[0]["sym"]) if g else None
    A["vpu"] = v
    A["stop_su_comm"] = (A["sl_dist"] * v / A["comm_lotto"]) if (A["sl_dist"] and v and A["comm_lotto"]) else None
    # rischio contemporaneo (allo SL INIZIALE)
    eventi = sorted({p["t_open"] for p in g})
    mx_n = mx_lot = 0; mx_risk = None; ist_nocap = 0; ist_ignoto = 0
    for t in eventi:
        vivi = [p for p in g if vivo(p, t, ora_fine)]
        mx_n = max(mx_n, len(vivi)); mx_lot = max(mx_lot, sum(p["vol"] or 0 for p in vivi))
        if any(not p["sl0_noto"] or p["_prot_dopo"] for p in vivi): ist_ignoto += 1
        elif any(p["sl0"] is None for p in vivi): ist_nocap += 1
        elif v:
            mx_risk = max(mx_risk or 0.0, sum(abs(p["p_open"] - p["sl0"]) * v * (p["vol"] or 0) for p in vivi))
    A["mx_n"], A["mx_lot"], A["mx_risk"], A["ist_nocap"] = mx_n, mx_lot, mx_risk, ist_nocap
    A["ist_ignoto"] = ist_ignoto
    # aggiunte nello stesso verso (media / piramide), catene, lotti
    medie = piramidi = medie_lotto_su = 0; catena_max = 1
    hedge = 0
    for i, p in enumerate(g):
        # cancello 13/10: per l'hedging conta anche il lato opposto aperto nello STESSO secondo
        # (straddle); per medie/piramidi no (gambe simultanee 1/3, 2/3 non sono aggiunte).
        vivi_prima = [q for q in g[:i] if vivo(q, p["t_open"], ora_fine)]
        hedge += sum(1 for q in vivi_prima if q["side"] != p["side"])
        prima = [q for q in vivi_prima if q["t_open"] < p["t_open"]]
        stesso = [q for q in prima if q["side"] == p["side"]]
        if not stesso: p["_catena"] = 1; continue
        q = stesso[-1]
        peggio = (p["p_open"] < q["p_open"]) if p["side"] == "buy" else (p["p_open"] > q["p_open"])
        if peggio:
            medie += 1
            if (p["vol"] or 0) > (q["vol"] or 0) + 1e-12: medie_lotto_su += 1
            ore = (p["t_open"] - q["t_open"]).total_seconds() / 3600
            p["_catena"] = q.get("_catena", 1) + 1 if ore <= GRIGLIA_ORE else 1
        else:
            piramidi += 1; p["_catena"] = 1
        catena_max = max(catena_max, p["_catena"])
    for p in g: p.pop("_catena", None)
    A["medie"], A["piramidi"], A["medie_lotto_su"], A["catena_max"] = medie, piramidi, medie_lotto_su, catena_max
    A["hedge"] = hedge
    # recupero: lotto del primo ingresso DOPO la chiusura di una perdita
    casi = su = 0
    for p in ch:
        if netto(p) >= 0: continue
        dopo = [q for q in g if q["t_open"] >= p["t_close"]]
        if not dopo: continue
        casi += 1
        if (dopo[0]["vol"] or 0) > (p["vol"] or 0) + 1e-12: su += 1
    A["rec_casi"], A["rec_su"] = casi, su
    A["lotti"] = sorted({p["vol"] for p in g if p["vol"]})
    for p in g: p.pop("_prot_dopo", None)
    return A

def etichette(A):
    """Classificazione oggettiva a soglie: lista (scatta, testo). Mai un verdetto."""
    E = []; n = A["n"]; nt = A["n_tempi"] or 0; nn = A["n_sl_noti"]
    def q(a, b): return (a / b) if b else 0.0
    if nt:
        E.append((A["barra"] is not None,
                  "A BARRA %s: ingressi entro %ds dall'apertura della barra %s su %d (soglia >= %d%%) -> EA a evento di barra"
                  % (A["barra"] or "-", TOLL_SEC_BARRA,
                     "%d" % A["quote_barra"].get(A["barra"], 0) if A["barra"] else "max M1 %d" % A["quote_barra"]["M1"],
                     nt, SOGLIA_BARRA * 100)))
        E.append((q(A["min_tondi"], nt) >= SOGLIA_MIN_TONDI,
                  "MINUTI TONDI (multipli di 5, sec<=%d): %d/%d (soglia >= %d%%)"
                  % (TOLL_SEC_BARRA, A["min_tondi"], nt, SOGLIA_MIN_TONDI * 100)))
        if A["hhmm_top"]:
            E.append((nt >= 3 and q(A["hhmm_top"][1], nt) >= SOGLIA_ORARIO_FISSO,
                      "ORARIO FISSO: %s in %d/%d (soglia >= %d%% con n>=3) -> EA a tempo"
                      % (A["hhmm_top"][0], A["hhmm_top"][1], nt, SOGLIA_ORARIO_FISSO * 100)))
    if nn:
        E.append((q(A["senza_sl"], nn) >= SOGLIA_SENZA_SL,
                  "SENZA SL INIZIALE e nessuno SL protettivo visto dopo: %d/%d (soglia >= %d%%) [BANDIERA ROSSA di casa]; "
                  "a parte %d con ordine senza SL ma SL protettivo comparso dopo (SL messo con modifica: rischio fra ingresso e modifica NON misurabile)"
                  % (A["senza_sl"], nn, SOGLIA_SENZA_SL * 100, A["sl_prot_dopo"])))
        E.append((q(A["senza_tp"], nn) >= SOGLIA_SENZA_TP,
                  "SENZA TP INIZIALE: %d/%d (soglia >= %d%%) -> uscita gestita dall'EA"
                  % (A["senza_tp"], nn, SOGLIA_SENZA_TP * 100)))
        E.append((q(A["sl_mossi"], A["n_mv"]) >= SOGLIA_SL_MOSSO,
                  "STOP GESTITO (trailing/BE/stop messo dopo): SL finale != iniziale %d/%d, di cui aggiunto dopo %d, oltre l'ingresso %d; uscite a SL in profitto %d (soglia >= %d%%)"
                  % (A["sl_mossi"], A["n_mv"], A["sl_aggiunti"], A["sl_oltre"], A["sl_profitto"], SOGLIA_SL_MOSSO * 100)))
    else:
        E.append((False, "SL/TP: NON DISPONIBILI in questo formato o ordine d'apertura fuori finestra"))
    if A["n_rr"]:
        E.append((A["rr"] >= RR_ASIMM, "STOP PIU' LARGO DEL TARGET: SL/TP mediano %.3f su %d (soglia >= %.3f)"
                  % (A["rr"], A["n_rr"], RR_ASIMM)))
        E.append((A["rr"] <= 1 / RR_ASIMM, "TARGET PIU' LARGO DELLO STOP: SL/TP mediano %.3f su %d (soglia <= %.3f)"
                  % (A["rr"], A["n_rr"], 1 / RR_ASIMM)))
    if A["dur"]:
        E.append((A["dur"][0] < SCALP_MIN, "SCALPING: durata mediana %.1f min su %d chiuse (soglia < %d min)"
                  % (A["dur"][0], A["n_ch"], SCALP_MIN)))
    E.append((A["catena_max"] >= GRIGLIA_MIN_INGR,
              "POSSIBILE GRIGLIA/MEDIA: catena piu' lunga %d ingressi stesso verso a prezzo peggiore, vivi insieme, entro %gh (soglia >= %d); medie %d, piramidi %d [BANDIERA ROSSA di casa]"
              % (A["catena_max"], GRIGLIA_ORE, GRIGLIA_MIN_INGR, A["medie"], A["piramidi"])))
    E.append((A["medie_lotto_su"] >= MART_MIN_AGGIUNTE,
              "POSSIBILE MARTINGALA: medie con lotto crescente %d (soglia >= %d) [BANDIERA ROSSA di casa]"
              % (A["medie_lotto_su"], MART_MIN_AGGIUNTE)))
    E.append((A["rec_su"] >= RECUPERO_MIN_CASI and q(A["rec_su"], A["rec_casi"]) >= RECUPERO_FRAZ,
              "POSSIBILE RECUPERO: lotto salito dopo una perdita %d/%d (soglia >= %d casi e >= %d%%) [BANDIERA ROSSA di casa]"
              % (A["rec_su"], A["rec_casi"], RECUPERO_MIN_CASI, RECUPERO_FRAZ * 100)))
    E.append((A["hedge"] >= HEDGE_MIN_COPPIE,
              "TIENE I DUE LATI (hedging nella stessa famiglia): %d ingressi con il lato opposto gia' vivo (soglia >= %d) [BANDIERA ROSSA di casa; NB: stessa FAMIGLIA di commento = stessa istanza O due istanze dello stesso EA, non separabili qui]"
              % (A["hedge"], HEDGE_MIN_COPPIE)))
    # il merito si conta sulle CHIUSE (il PF e' delle chiuse): cancello 13/10, prima n includeva le aperte
    nc = A["n_ch"]
    if nc < SOGLIA_N_SOTTILE:
        E.append((True, "n=%d chiuse: campione sottile: NON MISURATO per il merito" % nc))
    elif nc < SOGLIA_N_MERITO:
        E.append((True, "n=%d chiuse: sotto %d (regola di casa): merito NON giudicabile" % (nc, SOGLIA_N_MERITO)))
    return E

# ================================= referto =====================================
def referto(pos, meta, args, radice, out=sys.stdout):
    W = lambda s="": out.write(s + "\n")
    for nome in ("dal", "al"):   # cancello 13/10: una data illeggibile crashava con TypeError
        v = getattr(args, nome)
        if v and tempo(v) is None:
            sys.exit("ERRORE: --%s %r illeggibile (usare AAAA.MM.GG o AAAA-MM-GG, eventualmente con HH:MM)" % (nome, v))
    n_file = len(pos)
    if args.dal: pos = [p for p in pos if p["t_open"] >= tempo(args.dal)]
    if args.al: pos = [p for p in pos if p["t_open"] < tempo(args.al)]
    tok_src, n_src = token_nostri(radice)
    for p in pos:
        p["fam"], p["fam_disp"], p["lato_comm"] = famiglia(p["commento"], p["sym"])
        p["fam_grezza"] = famiglia(p["commento"], p["sym"], contatori=False)[0]
        if p["fam"] == "(SENZA COMMENTO)" and p.get("magic") not in (None, "", "0"):
            p["fam"] = p["fam_disp"] = "(senza commento) magic %s" % p["magic"]
        if not p["apertura_in_finestra"] and p["commento"] is None:
            p["fam"] = p["fam_disp"] = "(ingresso FUORI FINESTRA: commento non nel file)"
    ora_fine = meta.get("ora_report") or max([p["t_close"] or p["t_open"] for p in pos] or [dt.datetime.now()])
    vpu = valore_unita(pos)
    W("=" * 78)
    W("NATURA DEL MOTORE DA STORICO -- referto DESCRITTIVO (nessun verdetto di merito)")
    W("=" * 78)
    W("fonte: %s" % args.file)
    W("formato: %s | lettore: %s" % (meta["formato"], meta["lettore"]))
    if meta.get("conto"): W("conto (dal file): %s" % meta["conto"])
    W("ora del report / fine finestra: %s (ore = ORA SERVER del broker)" % ora_fine)
    W("riconoscimento NOSTRA: %d sorgenti letti in mql5/Experts, %d prefissi di default + %d famiglie di campo dichiarate"
      % (n_src, len(tok_src), len(FAMIGLIE_NOSTRE_CAMPO)))
    W("  prefissi dai sorgenti: %s" % " ".join(sorted(tok_src)))
    W("  famiglie di campo: %s" % " ".join(sorted(FAMIGLIE_NOSTRE_CAMPO)))
    W("  ATTENZIONE: 'NOSTRA' = il PRIMO TOKEN del commento coincide con un prefisso di casa. E' un'ATTRIBUZIONE,")
    W("  non una misura: un EA di terzi che commenta con un nostro prefisso (es. ORB, BB, DAX, GAP, EZ, A1) risulta")
    W("  NOSTRA, e un nostro EA con commento da preset o scritto nel codice risulta NON RICONOSCIUTA. Nel csv si")
    W("  incrocia col magic (%d magic di default letti SOLO dagli input 'Inp*Magic*' dei sorgenti: i magic da preset" % len(MAGIC_SRC))
    W("  e quelli dichiarati come 'MagicNumber' risultano 'non riscontrato'); nel xlsx il magic non c'e'.")
    if args.dal or args.al:
        W("finestra richiesta: dal %s al %s (sull'ora d'INGRESSO) -> %d posizioni su %d del file"
          % (args.dal or "-", args.al or "-", len(pos), n_file))
    for a in meta.get("avvisi", []): W("AVVISO: " + a)
    if NUM_ILLEGGIBILI:
        W("AVVISO: %d valori numerici NON leggibili (trattati come assenti/0): %s"
          % (len(NUM_ILLEGGIBILI), ", ".join(repr(x) for x in NUM_ILLEGGIBILI[:8])))
    W("NON COPERTO: MAE/MFE (assenti nel file); spread (assente: 'stop >= 40 x spread' NON verificabile qui);")
    W("  chiusure parziali; SL messo con modifica dopo l'ingresso: visto SOLO se alla chiusura e' ancora dal lato")
    W("  della perdita (allora NON conta come 'senza SL'); se e' stato tolto o portato oltre l'ingresso non si vede;")
    W("  magic assente nel xlsx (due EA con lo stesso commento non si separano: serve il csv dell'esportatore).")
    W("")
    W("--- SOGLIE (fissate nel codice PRIMA dei numeri) ---")
    W("barra: >=%d%% ingressi entro %ds dall'apertura del TF | minuti tondi >=%d%% | orario fisso >=%d%% (n>=3)"
      % (SOGLIA_BARRA * 100, TOLL_SEC_BARRA, SOGLIA_MIN_TONDI * 100, SOGLIA_ORARIO_FISSO * 100))
    W("senza SL >=%d%% | senza TP >=%d%% | stop gestito >=%d%% | SL/TP asimmetrico >=%.1f o <=%.2f | scalping mediana <%d min"
      % (SOGLIA_SENZA_SL * 100, SOGLIA_SENZA_TP * 100, SOGLIA_SL_MOSSO * 100, RR_ASIMM, 1 / RR_ASIMM, SCALP_MIN))
    W("griglia: catena >=%d ingressi stesso verso a prezzo peggiore, vivi insieme, entro %gh | martingala: >=%d medie a lotto crescente"
      % (GRIGLIA_MIN_INGR, GRIGLIA_ORE, MART_MIN_AGGIUNTE))
    W("recupero: >=%d casi e >=%d%% di lotto salito dopo una perdita | hedging: >=%d ingresso col lato opposto vivo, stessa famiglia"
      % (RECUPERO_MIN_CASI, RECUPERO_FRAZ * 100, HEDGE_MIN_COPPIE))
    W("n < %d: 'campione sottile: NON MISURATO per il merito'; merito solo da n >= %d (regola di casa)"
      % (SOGLIA_N_SOTTILE, SOGLIA_N_MERITO))
    W("")
    # ---------------- MAPPA COMMENTO -> FAMIGLIA ----------------
    W("--- MAPPA COMMENTO (d'apertura) -> FAMIGLIA -> n posizioni (verificabile a occhio) ---")
    fams = {}
    for p in pos:
        f = fams.setdefault(p["fam"], dict(disp=p["fam_disp"], grezzi={}, magic=set(), n=0, lati=set(), varianti=set()))
        f["n"] += 1
        f["varianti"].add(p["fam_grezza"])
        f["grezzi"][p["commento"]] = f["grezzi"].get(p["commento"], 0) + 1
        if p.get("magic") not in (None, ""): f["magic"].add(p["magic"])
        if p["lato_comm"]: f["lati"].add(p["lato_comm"])
    # magic -> famiglie NOSTRE per prefisso (per il riscontro incrociato nel csv)
    mag_nostre = {}
    for p in pos:
        if p.get("magic") not in (None, "", "0") and not p["fam"].startswith("(") \
                and provenienza(p["fam"], tok_src)[0] == "NOSTRA":
            mag_nostre.setdefault(p["magic"], set()).add(fams[p["fam"]]["disp"])
    W("%-38s %-34s %4s  %s" % ("FAMIGLIA", "PROVENIENZA", "n", "commenti grezzi distinti (n)"))
    for k in sorted(fams, key=lambda k: -fams[k]["n"]):
        f = fams[k]
        if k.startswith("("): prov, perche = "NON ATTRIBUIBILE", ""
        else: prov, perche = provenienza(k, tok_src)
        f["prov"] = prov; f["perche"] = perche
        grezzi = ", ".join("%r(%d)" % (g, c) for g, c in sorted(f["grezzi"].items(), key=lambda x: str(x[0])))
        W("%-38s %-34s %4d  %s" % (f["disp"][:38], prov + (" (prefisso)" if prov == "NOSTRA" else ""), f["n"], grezzi))
        if perche: W("%38s   ^ %s" % ("", perche))
        # riscontro col MAGIC (solo csv): conferma o smentisce l'attribuzione per prefisso
        mg_ = sorted(m_ for m_ in f["magic"] if m_ != "0")
        if mg_:
            risc = []
            for m_ in mg_:
                if m_ in MAGIC_SRC: risc.append("%s = default di %s" % (m_, "/".join(MAGIC_SRC[m_])))
                elif m_ in mag_nostre and f["disp"] not in mag_nostre[m_]:
                    risc.append("%s = magic anche di %s (NOSTRA per prefisso)" % (m_, "/".join(sorted(mag_nostre[m_]))))
                elif m_.isdigit() and 770000 <= int(m_) <= 779999:
                    risc.append("%s = serie 77xxxx dei nostri default (riscontro DEBOLE, non esatto)" % m_)
                else: risc.append("%s non riscontrato" % m_)
            W("%38s   ^ riscontro magic: %s" % ("", "; ".join(risc)))
            tutti_ignoti = all(r.endswith("non riscontrato") for r in risc)
            if prov == "NOSTRA" and tutti_ignoti:
                f["dubbia"] = True
                W("%38s   ^ AVVISO: NOSTRA per prefisso ma NESSUN magic riscontrato nei sorgenti ne' in famiglie nostre:"
                  " possibile EA di terzi con lo stesso prefisso, oppure magic da preset (verificare)" % "")
            if prov != "NOSTRA" and not tutti_ignoti:
                W("%38s   ^ AVVISO: NON RICONOSCIUTA per commento ma con magic di casa: probabile NOSTRA non censita (verificare)" % "")
        if len(f["varianti"]) > 1 and not k.startswith("("):
            W("%38s   ^ AVVISO FUSIONE: %d varianti numeriche diverse fuse in '*' (%s): se sono istanze o parametri"
              " diversi, contemporaneita'/hedging/griglia di questa famiglia possono essere effetto della fusione"
              % ("", len(f["varianti"]), " | ".join(sorted(f["varianti"])[:4]) + (" | ..." if len(f["varianti"]) > 4 else "")))
        if f["lati"]: W("%38s   ^ lato dichiarato nel commento: %s" % ("", "/".join(sorted(f["lati"]))))
        lun = [g for g in f["grezzi"] if g and len(str(g)) >= LUNGH_TRONCATO]
        if lun: W("%38s   ^ AVVISO: %d commento/i lungo/i %d caratteri = POSSIBILE TRONCAMENTO MT5" % ("", len(lun), LUNGH_TRONCATO))
        if len(f["magic"]) > 1:
            W("%38s   ^ AVVISO AMBIGUITA': stesso commento, %d magic diversi (%s) = probabilmente EA/istanze diverse"
              % ("", len(f["magic"]), ",".join(sorted(f["magic"]))))
        if k.startswith("(SENZA") or k.startswith("(senza"):
            W("%38s   ^ AVVISO: senza commento = NON ATTRIBUIBILE a un EA%s" % ("", "" if not f["magic"] else " (riserva: magic)"))
    mg = {}
    for p in pos:
        if p.get("magic") not in (None, ""): mg.setdefault(p["magic"], set()).add(p["fam"])
    for m_, fs in sorted(mg.items()):
        if len(fs) > 1 and m_ != "0":
            W("AVVISO: magic %s usa %d famiglie di commento (%s): stesso EA, piu' commenti" % (m_, len(fs), "; ".join(sorted(fs))))
    casa = {}
    for k, f in fams.items():
        c = prefisso_casa(f["disp"]) if not k.startswith("(") else None
        if c: casa.setdefault(c, []).append(k)
    for c, ks in sorted(casa.items()):
        if len(ks) > 1 and any(fams[k]["prov"] != "NOSTRA" for k in ks):
            W("IPOTESI 'stessa casa' (prefisso %s): %s -- da verificare, non misurato" % (c, " | ".join(fams[k]["disp"] for k in ks)))
    W("")
    # ---------------- TABELLA per famiglia x simbolo ----------------
    sel = [p for p in pos if (not args.simbolo or p["sym"].upper() == args.simbolo.upper())]
    if args.solo_non_nostre:   # le NOSTRE per prefisso smentite dal magic restano dentro (cancello 13/10)
        sel = [p for p in sel if fams[p["fam"]]["prov"] != "NOSTRA" or fams[p["fam"]].get("dubbia")]
        W("--solo-non-nostre: escluse le famiglie NOSTRA per prefisso, TRANNE quelle col magic non riscontrato")
    gruppi = {}
    for p in sel:
        # cancello 13/10: nel csv, se lo stesso commento ha piu' magic, l'analisi si SEPARA per
        # magic (prima si avvisava ma si fondevano: hedging/griglia fra due EA diversi).
        if len(fams[p["fam"]]["magic"]) > 1: key = (p["fam"], p["sym"], p["magic"])
        else: key = (p["fam"], p["sym"])
        gruppi.setdefault(key, []).append(p)
    nome_gr = lambda key: fams[key[0]]["disp"] + (" m:%s" % key[2] if len(key) > 2 else "")
    W("--- TABELLA per FAMIGLIA x SIMBOLO (netto = profitto+commissioni+swap delle CHIUSE, valuta del conto) ---")
    W("%-28s %-7s %3s %3s %5s %8s %6s %8s %7s %5s %9s %9s %6s" % (
        "famiglia", "simbolo", "ch", "ap", "L/S", "netto", "PF", "flott.", "senzaSL", "mossi", "SLmed", "TPmed", "durMed"))
    analisi = {}
    for key in sorted(gruppi, key=lambda k: (k[1], -len(gruppi[k]))):
        A = analizza(gruppi[key], ora_fine, vpu); analisi[key] = A
        W("%-28s %-7s %3d %3d %2d/%-2d %8s %6s %8s %7s %5s %9s %9s %6s" % (
            nome_gr(key)[:28], key[1][:7], A["n_ch"], A["n_ap"], A["n_L"], A["n_S"], fmt(A["netto"]),
            fmt(A["pf"]), fmt(A["flottante"]),
            ("%d/%d" % (A["senza_sl"], A["n_sl_noti"])) if A["n_sl_noti"] else "n.d.",
            ("%d/%d" % (A["sl_mossi"], A["n_mv"])) if A["n_mv"] else "n.d.",
            fmt(A["sl_dist"], 4 if (A["sl_dist"] or 99) < 1 else 2), fmt(A["tp_dist"], 4 if (A["tp_dist"] or 99) < 1 else 2),
            fmt(A["dur"][0], 0) if A["dur"] else "-"))
    W("")
    # ---------------- DETTAGLIO ----------------
    W("--- DETTAGLIO ---")
    for key, A in analisi.items():
        f = fams[key[0]]
        W("[%s | %s] %s (%s)" % (nome_gr(key), key[1], f["prov"], f["perche"] or "-"))
        W("  n=%d (chiuse %d, aperte %d) | long %d netto %s | short %d netto %s | lordo %s | netto %s | PF %s (n=%d)"
          % (A["n"], A["n_ch"], A["n_ap"], A["n_L"], fmt(A["netto_L"]), A["n_S"], fmt(A["netto_S"]),
             fmt(A["lordo"]), fmt(A["netto"]), fmt(A["pf"]), A["n_ch"]))
        W("  ingressi (ora d'ORDINE, server) per ora: %s | sec==0: %d/%d | tipi d'ordine: %s"
          % (" ".join("%02dh:%d" % (h, c) for h, c in sorted(A["ore"].items())), A["sec0"], A["n_tempi"],
             ", ".join("%s:%d" % kv for kv in sorted(A["tipi_ordine"].items()))))
        W("  allineamento barra (ingressi entro %ds): %s" % (TOLL_SEC_BARRA,
          " ".join("%s:%d" % (k, A["quote_barra"].get(k, 0)) for k, _ in TF_SEC[::-1])))
        if A["dur"]:
            W("  durata (min) mediana %.1f min %.1f max %.1f (n=%d) | uscite: %s"
              % (A["dur"][0], A["dur"][1], A["dur"][2], A["n_ch"],
                 ", ".join("%s:%d" % kv for kv in sorted(A["uscite"].items()))))
        if A["n_sl_noti"]:
            W("  SL iniziale: assente %d/%d | distanza mediana %s (min-max %s) | TP assente %d/%d, distanza mediana %s (min-max %s) | SL/TP mediano %s (n=%d)"
              % (A["senza_sl"], A["n_sl_noti"], fmt(A["sl_dist"], 5), ("%s-%s" % (fmt(A["sl_rng"][0], 5), fmt(A["sl_rng"][1], 5)) if A["sl_rng"] else "-"),
                 A["senza_tp"], A["n_sl_noti"], fmt(A["tp_dist"], 5), ("%s-%s" % (fmt(A["tp_rng"][0], 5), fmt(A["tp_rng"][1], 5)) if A["tp_rng"] else "-"),
                 fmt(A["rr"]), A["n_rr"]))
            W("  stop gestito: SL finale != iniziale %d/%d (aggiunto dopo %d, oltre l'ingresso %d) | uscite a SL in profitto %d"
              % (A["sl_mossi"], A["n_mv"], A["sl_aggiunti"], A["sl_oltre"], A["sl_profitto"]))
        else:
            W("  SL/TP: NON DISPONIBILI (formato csv o ordine d'apertura fuori finestra)")
        W("  costo: commissione A/R per lotto %s (n=%d) | valore di 1,0 di prezzo x 1 lotto stimato dai P/L %s | stop/commissione %s | spread: NON NOTO"
          % (fmt(A["comm_lotto"]), A["n_ch"], fmt(A["vpu"]), fmt(A["stop_su_comm"], 1)))
        W("  contemporaneita': max posizioni vive %d, max lotti %s, rischio max allo SL iniziale (solo istanti tutti con SL) %s%s"
          % (A["mx_n"], fmt(A["mx_lot"]), fmt(A["mx_risk"]),
             ((" | istanti con posizioni SENZA SL: %d (rischio NON CAPPATO)" % A["ist_nocap"]) if A["ist_nocap"] else "")
             + ((" | istanti con SL IGNOTO (non nel file): %d" % A["ist_ignoto"]) if A["ist_ignoto"] else "")))
        W("  stesso verso: medie %d (lotto crescente %d), piramidi %d, catena max %d | hedging stessa famiglia %d | lotto su dopo perdita %d/%d | lotti %s"
          % (A["medie"], A["medie_lotto_su"], A["piramidi"], A["catena_max"], A["hedge"], A["rec_su"], A["rec_casi"],
             ",".join("%g" % x for x in A["lotti"])))
        if A["top3"] is not None:
            W("  concentrazione: migliori 3 = %s su netto %s; quota dei profitti lordi positivi %s"
              % (fmt(A["top3"]), fmt(A["netto"]), fmt(A["top3_su_lordo_pos"] and A["top3_su_lordo_pos"] * 100, 0) + "%"))
        W("  MAE/MFE: NON DISPONIBILI in questo formato")
    W("")
    # ---------------- sovrapposizioni fra famiglie per simbolo ----------------
    W("--- STESSO SIMBOLO, FAMIGLIE DIVERSE (non e' hedging di un motore: e' esposizione del CONTO) ---")
    per_sym = {}
    for p in sel: per_sym.setdefault(p["sym"], []).append(p)
    for s, ps in sorted(per_sym.items()):
        ps = sorted(ps, key=lambda p: p["t_open"]); opp = 0; mxv = 0
        for i, p in enumerate(ps):
            vivi = [q for q in ps[:i + 1] if vivo(q, p["t_open"], ora_fine)]
            mxv = max(mxv, len(vivi))
            opp += sum(1 for q in vivi if q is not p and q["side"] != p["side"] and q["fam"] != p["fam"])
        W("%-8s famiglie %d | max posizioni vive insieme %d | ingressi con lato opposto vivo di ALTRA famiglia %d"
          % (s, len({p["fam"] for p in ps}), mxv, opp))
    W("")
    # ---------------- NATURA ----------------
    W("--- NATURA (classificazione a soglie: ogni riga e' un'IPOTESI da misurare, mai un verdetto) ---")
    for key, A in analisi.items():
        W("[%s | %s] %s" % (nome_gr(key), key[1], fams[key[0]]["prov"]))
        poco = A["n"] < 3   # cancello 13/10: un [SI] su 1-2 posizioni si dichiara come tale
        for scatta, txt in etichette(A):
            W("  %s %s" % (("[SI, n<3]" if poco else "[SI]") if scatta else "[no]", txt))
    W("")
    # ---------------- ordini non eseguiti ----------------
    pn = meta.get("pendenti_non_eseguiti", []); oa = meta.get("ordini_attivi", [])
    if pn or oa:
        W("--- ORDINI PENDENTI: non eseguiti %d, attivi %d (commenti: %s) ---" % (
            len(pn), len(oa), "; ".join(sorted({str(o.get("comm")) for o in pn + oa}))))
    # ---------------- controlli di coerenza col report ----------------
    W("--- CONTROLLI ---")
    ch = [p for p in pos if not p["aperta"]]
    W("posizioni chiuse %d, aperte %d | netto delle chiuse %s  [TUTTI i simboli%s]"
      % (len(ch), len(pos) - len(ch), fmt(sum(netto(p) for p in ch)),
         ", dentro la finestra --dal/--al" if (args.dal or args.al) else ""))
    if "deal_netto" in meta:
        if args.dal or args.al:
            W("NB: Affari e Risultati qui sotto sono del FILE INTERO, non filtrati da --dal/--al: non confrontabili con la riga sopra")
        W("netto dagli Affari (tutti i deal, comprese commissioni d'ingresso delle aperte) %s su %d deal | dichiarato dal report %s | PF dichiarato %s"
          % (fmt(meta["deal_netto"]), meta["n_deal"], fmt(meta.get("res_netto")), fmt(meta.get("res_pf"), 3)))
        W("PF ricalcolato dagli Affari (per deal, come MT5) %s" % fmt(meta.get("deal_pf"), 3))
    return dict(pos=pos, fams=fams, analisi=analisi, meta=meta)

# ================================= autotest ====================================
def _xlsx_sintetico(path, righe):
    """Scrive un xlsx minimo a mano (sharedStrings + un foglio) con zipfile."""
    sst = []; idx = {}
    def si(s):
        if s not in idx: idx[s] = len(sst); sst.append(s)
        return idx[s]
    def col(i):
        s = ""; i += 1
        while i: i, r = divmod(i - 1, 26); s = chr(65 + r) + s
        return s
    rows = []
    for ri, r in enumerate(righe, 1):
        cs = []
        for ci, v in enumerate(r):
            if v is None: continue
            ref = "%s%d" % (col(ci), ri)
            if isinstance(v, (int, float)) and not isinstance(v, bool):
                cs.append('<c r="%s"><v>%r</v></c>' % (ref, v))
            else:
                cs.append('<c r="%s" t="s"><v>%d</v></c>' % (ref, si(str(v))))
        rows.append('<row r="%d">%s</row>' % (ri, "".join(cs)))
    esc = lambda s: s.replace("&", "&amp;").replace("<", "&lt;").replace(">", "&gt;")
    with zipfile.ZipFile(path, "w") as z:
        z.writestr("[Content_Types].xml",
                   '<?xml version="1.0"?><Types xmlns="http://schemas.openxmlformats.org/package/2006/content-types">'
                   '<Default Extension="rels" ContentType="application/vnd.openxmlformats-package.relationships+xml"/>'
                   '<Default Extension="xml" ContentType="application/xml"/>'
                   '<Override PartName="/xl/workbook.xml" ContentType="application/vnd.openxmlformats-officedocument.spreadsheetml.sheet.main+xml"/>'
                   '<Override PartName="/xl/worksheets/sheet1.xml" ContentType="application/vnd.openxmlformats-officedocument.spreadsheetml.worksheet+xml"/>'
                   '<Override PartName="/xl/sharedStrings.xml" ContentType="application/vnd.openxmlformats-officedocument.spreadsheetml.sharedStrings+xml"/>'
                   '</Types>')
        z.writestr("_rels/.rels", '<?xml version="1.0"?><Relationships xmlns="http://schemas.openxmlformats.org/package/2006/relationships">'
                   '<Relationship Id="rId1" Type="http://schemas.openxmlformats.org/officeDocument/2006/relationships/officeDocument" Target="xl/workbook.xml"/></Relationships>')
        z.writestr("xl/workbook.xml", '<?xml version="1.0"?><workbook xmlns="http://schemas.openxmlformats.org/spreadsheetml/2006/main" '
                   'xmlns:r="http://schemas.openxmlformats.org/officeDocument/2006/relationships"><sheets>'
                   '<sheet name="Sheet1" sheetId="1" r:id="rId1"/></sheets></workbook>')
        z.writestr("xl/_rels/workbook.xml.rels", '<?xml version="1.0"?><Relationships xmlns="http://schemas.openxmlformats.org/package/2006/relationships">'
                   '<Relationship Id="rId1" Type="http://schemas.openxmlformats.org/officeDocument/2006/relationships/worksheet" Target="worksheets/sheet1.xml"/>'
                   '<Relationship Id="rId2" Type="http://schemas.openxmlformats.org/officeDocument/2006/relationships/sharedStrings" Target="sharedStrings.xml"/></Relationships>')
        z.writestr("xl/sharedStrings.xml", '<?xml version="1.0"?><sst xmlns="http://schemas.openxmlformats.org/spreadsheetml/2006/main">%s</sst>'
                   % "".join("<si><t>%s</t></si>" % esc(s) for s in sst))
        z.writestr("xl/worksheets/sheet1.xml", '<?xml version="1.0"?><worksheet xmlns="http://schemas.openxmlformats.org/spreadsheetml/2006/main"><sheetData>%s</sheetData></worksheet>'
                   % "".join(rows))

def _dati_sintetici():
    """Posizioni con i pattern: (pid, ora_ordine, ora_in, sym, tipo, vol, prezzo, sl0, tp0, ora_out, p_out, sl1, tp1, comm, profit, motivo, commento)."""
    P = []
    def add(*a): P.append(a)
    # GRIGLIA a lotto fisso, senza SL, catena di 3 medie (buy a 100, 99, 98), chiusura insieme
    add(101, "2026.10.01 10:03:17", "2026.10.01 10:03:17", "XAUUSD", "buy", 0.01, 100.0, None, 105.0, "2026.10.01 15:00:00", 101.0, None, 105.0, -0.04, 1.0, "[tp 101.0]", "Grid_77777_1_Initial")
    add(102, "2026.10.01 11:41:09", "2026.10.01 11:41:09", "XAUUSD", "buy", 0.01, 99.0, None, 105.0, "2026.10.01 15:00:00", 101.0, None, 105.0, -0.04, 2.0, "[tp 101.0]", "Grid_77777_2_Initial")
    add(103, "2026.10.01 12:27:44", "2026.10.01 12:27:44", "XAUUSD", "buy", 0.01, 98.0, None, 105.0, "2026.10.01 15:00:00", 101.0, None, 105.0, -0.04, 3.0, "[tp 101.0]", "Grid_77777_3_Initial")
    # MARTINGALA: medie sell a 200, 201, 202 con lotti 0.01, 0.02, 0.04
    add(201, "2026.10.02 09:13:05", "2026.10.02 09:13:05", "XAUUSD", "sell", 0.01, 200.0, 210.0, 195.0, "2026.10.02 18:00:00", 199.0, 210.0, 195.0, -0.04, 1.0, "", "MART_1")
    add(202, "2026.10.02 10:22:31", "2026.10.02 10:22:31", "XAUUSD", "sell", 0.02, 201.0, 210.0, 195.0, "2026.10.02 18:00:00", 199.0, 210.0, 195.0, -0.08, 4.0, "", "MART_2")
    add(203, "2026.10.02 11:37:52", "2026.10.02 11:37:52", "XAUUSD", "sell", 0.04, 202.0, 210.0, 195.0, "2026.10.02 18:00:00", 199.0, 210.0, 195.0, -0.16, 12.0, "", "MART_3")
    # TRAILING: SL iniziale 95, chiuso a [sl 103] in profitto; secondo con BE
    add(301, "2026.10.03 08:00:00", "2026.10.03 08:00:00", "EURUSD", "buy", 0.10, 100.0, 95.0, 120.0, "2026.10.03 12:00:00", 103.0, 103.0, 120.0, -0.70, 30.0, "[sl 103.0]", "TRAILER_L")
    add(302, "2026.10.03 14:00:00", "2026.10.03 14:00:00", "EURUSD", "sell", 0.10, 100.0, 105.0, 80.0, "2026.10.03 18:00:00", 100.0, 100.0, 80.0, -0.70, 0.0, "[sl 100.0]", "TRAILER_S")
    # HEDGING nella stessa famiglia: buy e sell vivi insieme
    add(401, "2026.10.04 09:07:13", "2026.10.04 09:07:13", "GBPUSD", "buy", 0.10, 1.3000, 1.2900, 1.3100, "2026.10.04 16:00:00", 1.3050, 1.2900, 1.3100, -0.70, 50.0, "altro", "HEDGY")
    add(402, "2026.10.04 09:48:55", "2026.10.04 09:48:55", "GBPUSD", "sell", 0.10, 1.3010, 1.3110, 1.2910, "2026.10.04 16:00:00", 1.3050, 1.3110, 1.2910, -0.70, -40.0, "altro", "HEDGY")
    # A TEMPO: H1 esatto, SL e TP presenti
    for i, h in enumerate((10, 11, 12, 13)):
        add(500 + i, "2026.10.05 %02d:00:00" % h, "2026.10.05 %02d:00:00" % h, "USDJPY", "buy", 0.10, 150.0, 149.5, 150.5,
            "2026.10.05 %02d:30:00" % h, 150.5, 149.5, 150.5, -0.70, 33.0 if i % 2 else -33.0, "[tp 150.5]" if i % 2 else "[sl 149.5]", "TIMER 1 Hour")
    # RECUPERO: perdita 0.01 -> 0.02, perdita 0.02 -> 0.04
    add(601, "2026.10.06 09:11:11", "2026.10.06 09:11:11", "AUDUSD", "buy", 0.01, 0.6600, 0.6590, 0.6610, "2026.10.06 10:00:00", 0.6590, 0.6590, 0.6610, -0.07, -1.0, "[sl 0.6590]", "RECOV")
    add(602, "2026.10.06 10:23:47", "2026.10.06 10:23:47", "AUDUSD", "buy", 0.02, 0.6600, 0.6590, 0.6610, "2026.10.06 11:00:00", 0.6590, 0.6590, 0.6610, -0.14, -2.0, "[sl 0.6590]", "RECOV")
    add(603, "2026.10.06 11:39:02", "2026.10.06 11:39:02", "AUDUSD", "buy", 0.04, 0.6600, 0.6590, 0.6610, "2026.10.06 12:00:00", 0.6610, 0.6590, 0.6610, -0.28, 4.0, "[tp 0.6610]", "RECOV")
    # CONTRO-ESEMPIO PULITO: secondi sparsi, SL/TP, nessuna sovrapposizione, lotto fisso
    add(701, "2026.10.07 09:07:23", "2026.10.07 09:07:23", "EURJPY", "sell", 0.10, 170.0, 170.5, 169.0, "2026.10.07 10:00:00", 169.0, 170.5, 169.0, -0.70, 60.0, "[tp 169.0]", "PULITO_S")
    add(702, "2026.10.07 13:41:51", "2026.10.07 13:41:51", "EURJPY", "buy", 0.10, 169.0, 168.5, 170.0, "2026.10.07 15:00:00", 168.5, 168.5, 170.0, -0.70, -30.0, "[sl 168.5]", "PULITO_L")
    # PIRAMIDE (stesso verso a prezzo MIGLIORE): non deve dare griglia
    add(801, "2026.10.08 09:03:41", "2026.10.08 09:03:41", "NZDUSD", "buy", 0.10, 0.5600, 0.5550, 0.5700, "2026.10.08 20:00:00", 0.5650, 0.5550, 0.5700, -0.70, 50.0, "altro", "PIRA")
    add(802, "2026.10.08 10:17:29", "2026.10.08 10:17:29", "NZDUSD", "buy", 0.10, 0.5610, 0.5550, 0.5700, "2026.10.08 20:00:00", 0.5650, 0.5550, 0.5700, -0.70, 40.0, "altro", "PIRA")
    add(803, "2026.10.08 11:29:13", "2026.10.08 11:29:13", "NZDUSD", "buy", 0.10, 0.5620, 0.5550, 0.5700, "2026.10.08 20:00:00", 0.5650, 0.5550, 0.5700, -0.70, 30.0, "altro", "PIRA")
    # COMMENTI REALI del 12/10 e casi di bordo
    add(901, "2026.10.09 23:52:00", "2026.10.09 23:52:00", "XAUUSD", "sell", 0.01, 4185.62, None, 4075.62, "2026.10.10 10:52:11", 4171.82, 4171.82, 4075.62, -0.04, 12.34, "[sl 4171.82]", "Basket_1234567_1_Initial")
    add(902, "2026.10.10 00:11:00", "2026.10.10 00:11:00", "XAUUSD", "buy", 0.01, 4189.19, None, 4299.19, "2026.10.10 01:15:06", 4205.66, 4205.66, 4299.19, -0.04, 14.69, "[sl 4205.66]", "Basket_1234567_2_Initial")
    add(903, "2026.10.10 09:10:00", "2026.10.10 09:10:00", "XAUUSD", "buy", 0.01, 4178.14, 4173.78, 4184.26, "2026.10.10 09:50:33", 4173.78, 4173.78, 4184.26, -0.04, -3.90, "[sl 4173.78]", "SSP scalp")
    add(904, "2026.10.10 15:20:00", "2026.10.10 15:20:00", "XAUUSD", "sell", 0.01, 4164.60, 4173.27, 4151.70, "2026.10.10 16:20:00", 4151.70, 4173.27, 4151.70, -0.04, 11.0, "[tp 4151.70]", "SSPv4")
    add(905, "2026.10.10 11:15:01", "2026.10.10 11:15:01", "XAUUSD", "sell", 0.01, 4174.66, 4217.17, None, "2026.10.10 12:00:00", 4170.0, 4217.17, None, -0.04, 4.0, "altro", "XAUUSD 5 Minute")
    add(906, "2026.10.10 06:00:00", "2026.10.10 06:00:00", "GBPJPY", "sell", 0.15, 209.675, 210.091, 209.458, "2026.10.10 16:22:58", 209.669, 210.091, 209.458, -0.70, 0.51, "[tp 209.669]", "BULGE_V520_VIOLA_S")
    add(907, "2026.10.10 09:00:00", "2026.10.10 09:00:00", "NZDUSD", "buy", 0.23, 0.56039, 0.5587, 0.56093, "2026.10.10 16:41:39", 0.5587, 0.5587, 0.56093, -0.46, -34.82, "[sl 0.55870]", "BULGE_V520_VIOLA_L")
    add(908, "2026.10.10 13:13:13", "2026.10.10 13:13:13", "EURUSD", "buy", 0.10, 1.1000, 1.0950, 1.1100, "2026.10.10 14:00:00", 1.1100, 1.0950, 1.1100, -0.70, 10.0, "[tp 1.1100]", "ABCDEFGHIJKLMNOPQRSTUVWXYZ01234")  # 31 car.
    add(909, "2026.10.10 13:14:15", "2026.10.10 13:14:15", "EURUSD", "sell", 0.10, 1.1000, 1.1050, 1.0900, "2026.10.10 14:00:00", 1.0990, 1.1050, 1.0900, -0.70, 1.0, "altro", None)  # vuoto
    return P

def _righe_xlsx(P, fuori_finestra=True):
    R = [["Report Cronistorico dei Trade"], ["Conto:", None, None, "999 (EUR, Test, demo, Hedge)"],
         ["Data:", None, None, "2026.10.10 22:00"], ["Posizioni"],
         ["Ora", "Posizione", "Simbolo", "Tipo", "Volume ", "Prezzo", "S / L", "T / P", "Ora", "Prezzo", "Commissioni", "Swap ", "Profitto"]]
    for (pid, to, ti, s, side, v, px, sl0, tp0, tc, pc, sl1, tp1, cm, pr, mot, com) in P:
        R.append([ti, pid, s, side, "%.2f" % v, px, sl1, tp1, tc, pc, cm, 0.0, pr])
    if fuori_finestra:  # posizione aperta PRIMA della finestra: nessun ordine d'apertura
        R.append(["2026.09.30 10:00:00", 999, "CADCHF", "buy", "0.10", 0.58, 0.57, 0.59, "2026.10.01 10:00:00", 0.59, -0.7, 0.0, 9.0])
    R += [["Ordini"], ["Orario di Apertura", "Ordine", "Simbolo", "Tipo", "Volume ", "Prezzo", "S / L", "T / P", "Ora", "Stato", None, "Commento"]]
    oid = 50000
    for (pid, to, ti, s, side, v, px, sl0, tp0, tc, pc, sl1, tp1, cm, pr, mot, com) in P:
        R.append([to, pid, s, side, "%.2f / %.2f" % (v, v), "market", sl0, tp0, ti, "filled", None, com])
        oid += 1
        R.append([tc, oid, s, "sell" if side == "buy" else "buy", "%.2f / %.2f" % (v, v), pc, None, None, tc, "filled", None,
                  mot if mot != "altro" else None])
    R.append(["2026.10.10 20:00:00", 990, "XAUUSD", "sell", "0.01 / 0.01", "market", None, 4059.5, "2026.10.10 20:00:00", "filled", None, "Basket_1234567_5_Initial"])
    R += [["Affari"], ["Ora", "Affare", "Simbolo", "Tipo", "Direzione", "Volume ", "Prezzo", "Ordine", "Commissioni", "Spese", "Swap ", "Profitto", "Bilancio", "Commento"]]
    did = 1; oid = 50000
    for (pid, to, ti, s, side, v, px, sl0, tp0, tc, pc, sl1, tp1, cm, pr, mot, com) in P:
        R.append([ti, did, s, side, "in", "%.2f" % v, px, pid, cm / 2, 0.0, 0.0, 0.0, 0.0, com]); did += 1; oid += 1
        R.append([tc, did, s, "sell" if side == "buy" else "buy", "out", "%.2f" % v, pc, oid, cm / 2, 0.0, 0.0, pr, 0.0,
                  mot if mot != "altro" else None]); did += 1
    R += [["Posizioni aperte"], ["Ora", "Posizione", "Simbolo", "Tipo", "Volume ", "Prezzo", "S / L", "T / P", "Prezzo di mercato", "Swap ", None, "Profitto", "Commento"],
          ["2026.10.10 20:00:00", 990, "XAUUSD", "sell", "0.01", 4169.5, None, 4059.5, 4169.43, 0.0, None, 0.06, "Basket_1234567_5_Initial"]]
    R += [["Risultati"], ["Profitto Totale Netto:", None, None, 1.0, "Profitto Lordo:", None, None, 1.0]]
    return R

def autotest(reale, radice):
    import tempfile
    ok = []; ko = []
    def chk(cond, msg): (ok if cond else ko).append(msg)
    # --- famiglie del commento ---
    F = lambda c, s="XAUUSD": famiglia(c, s)
    chk(F("Basket_1234567_3_Initial")[0] == "BASKET_1234567_*_INITIAL", "fam Basket -> BASKET_1234567_*_INITIAL")
    chk(F("Basket_1234567_1_Initial")[0] == F("Basket_1234567_12_Initial")[0], "fam Basket N=1 e N=12 stessa famiglia")
    chk(F("BULGE_V520_VIOLA_L", "NZDUSD")[:3:2] == ("BULGE_V520_VIOLA", "L"), "fam BULGE_V520_VIOLA lato L")
    chk(F("BULGE_V520_VIOLA_S", "GBPJPY")[0] == F("BULGE_V520_VIOLA_L", "NZDUSD")[0], "fam VIOLA _L e _S stessa famiglia")
    chk(F("SSP scalp")[0] == "SSP SCALP" and F("SSPv4")[0] == "SSPV4", "fam SSP scalp e SSPv4 restano distinte")
    chk(prefisso_casa("SSP scalp") == prefisso_casa("SSPv4") == "SSP", "prefisso casa SSP comune (ipotesi)")
    chk(F("XAUUSD 5 Minute")[0] == "{SIMB} 5 MINUTE", "fam XAUUSD 5 Minute: il '5' NON e' un contatore")
    chk(F("GAP AUDUSD L", "AUDUSD")[:3:2] == ("GAP {SIMB}", "L"), "fam GAP {SIMB} lato L")
    chk(F("MAXMIN ORO SELL")[2] == "S" and F("EMA200 OTT L1", "AUDCHF")[0] == "EMA200 OTT", "lato SELL e L1")
    chk(F("STREV NAS H1 L 1/3", "NAS100")[0] == "STREV NAS H1", "gamba 1/3 tolta")
    chk(F("  ssp   SCALP ")[0] == F("SSP scalp")[0], "maiuscole/spazi")
    chk(F(None)[0] == "(SENZA COMMENTO)" and F("")[0] == "(SENZA COMMENTO)", "commento vuoto")
    chk(all(RE_BROKER.match(c) for c in ("[sl 4205.66]", "[tp 1.89657]", "[so 12.3%]", "so: 50%", "expired [2026.10.12 08:30]")),
        "commenti automatici del broker riconosciuti")
    # --- xlsx sintetico, due lettori ---
    _tdo = tempfile.TemporaryDirectory(prefix="natura_at_")   # cancellata a fine autotest: sola lettura
    td = _tdo.name
    fx = os.path.join(td, "sint.xlsx")
    _xlsx_sintetico(fx, _righe_xlsx(_dati_sintetici()))
    try:
        import openpyxl  # noqa
        a1, _ = leggi_xlsx(fx); a2, _ = leggi_xlsx(fx, forza_xml=True)
        norm = lambda fs: [[c for c in r if c is not None] for _, rr in fs for r in rr if any(c is not None for c in r)]
        chk(norm(a1) == norm(a2), "lettori openpyxl e XML danno le stesse righe (sintetico)")
    except ImportError:
        ok.append("openpyxl assente: provato solo il lettore XML")
    pos, meta = posizioni_da_xlsx(fx, forza_xml=True)
    class Ar: file = fx; simbolo = None; dal = None; al = None; solo_non_nostre = False
    buf = io.StringIO()
    R = referto(pos, meta, Ar, radice, out=buf)
    txt = buf.getvalue()
    fam = R["fams"]
    chk(not any(k.startswith("[") for k in fam), "nessun gruppo creato da '[sl ...]'/'[tp ...]'")
    chk("BASKET_1234567_*_INITIAL" in fam and fam["BASKET_1234567_*_INITIAL"]["n"] == 3, "Basket: 3 posizioni (2 chiuse + 1 aperta)")
    chk(fam.get("SSP SCALP", {}).get("n") == 1 and fam.get("SSPV4", {}).get("n") == 1, "SSP scalp e SSPv4 separate")
    chk("IPOTESI 'stessa casa' (prefisso SSP)" in txt, "segnalata ipotesi stessa casa SSP")
    chk("POSSIBILE TRONCAMENTO" in txt, "segnalato commento lungo 31 (troncamento)")
    chk("(SENZA COMMENTO)" in fam and "NON ATTRIBUIBILE" in txt, "commento vuoto -> non attribuibile")
    chk(any(k.startswith("(ingresso FUORI FINESTRA") for k in fam), "posizione con ingresso fuori finestra isolata")
    chk(fam["BULGE_V520_VIOLA"]["prov"] == "NOSTRA" and fam["BASKET_1234567_*_INITIAL"]["prov"] != "NOSTRA",
        "BULGE = NOSTRA, Basket = NON RICONOSCIUTA")
    A = R["analisi"]
    g = A[("GRID_77777_*_INITIAL", "XAUUSD")]
    chk(g["catena_max"] == 3 and g["senza_sl"] == 3 and g["medie_lotto_su"] == 0, "griglia: catena 3, senza SL 3, lotto fisso")
    chk(any(s and "GRIGLIA" in t for s, t in etichette(g)) and not any(s and "MARTINGALA" in t for s, t in etichette(g)),
        "etichetta griglia SI, martingala NO (lotto fisso)")
    m = A[("MART_*", "XAUUSD")]
    chk(m["medie_lotto_su"] == 2 and any(s and "MARTINGALA" in t for s, t in etichette(m)), "martingala: 2 medie a lotto crescente")
    t_ = A[("TRAILER", "EURUSD")]
    chk(t_["sl_mossi"] == 2 and t_["sl_oltre"] == 2 and t_["sl_profitto"] == 1, "trailing/BE: 2 SL mossi, 2 oltre l'ingresso, 1 SL in profitto")
    h = A[("HEDGY", "GBPUSD")]
    chk(h["hedge"] == 1 and any(s and "DUE LATI" in t for s, t in etichette(h)), "hedging nella stessa famiglia")
    ti = A[("TIMER 1 HOUR", "USDJPY")]
    chk(ti["barra"] == "H1" and ti["min_tondi"] == 4, "a tempo: barra H1, 4/4 minuti tondi")
    rc = A[("RECOV", "AUDUSD")]
    chk(rc["rec_su"] == 2 and rc["rec_casi"] == 2 and any(s and "RECUPERO" in t for s, t in etichette(rc)), "recupero 2/2")
    for k in (("PULITO", "EURJPY"), ("PIRA", "NZDUSD")):
        E = etichette(A[k])
        rosse = [t for s, t in E if s and "BANDIERA ROSSA" in t]
        chk(not rosse, "contro-esempio %s: nessuna bandiera rossa (trovate: %s)" % (k[0], rosse))
        chk(not any(s and ("A BARRA" in t or "MINUTI TONDI" in t) for s, t in E), "contro-esempio %s: non 'a tempo'" % k[0])
    chk(A[("PIRA", "NZDUSD")]["piramidi"] == 2 and A[("PIRA", "NZDUSD")]["medie"] == 0, "piramide contata come piramide, non media")
    bk = A[("BASKET_1234567_*_INITIAL", "XAUUSD")]
    chk(bk["hedge"] == 1 and bk["senza_sl"] == 3 and bk["barra"] == "M1", "Basket sintetico: hedging 1, senza SL 3/3, barra M1")
    # --- csv: due EA con lo stesso commento + stesso magic con piu' commenti ---
    fc = os.path.join(td, "t.csv")
    with open(fc, "w") as f:
        f.write("pid;symbol;side;volume;open_time;open_price;close_time;close_price;commission;swap;profit;strategy;magic;close_reason;session_high;session_low\n")
        f.write("1;XAUUSD;buy;0.01;2026.10.12 09:10:00;4178.14;2026.10.12 09:50:33;4173.78;-0.04;0;-3.90;SSP scalp;202504;sl;0;0\n")
        f.write("2;XAUUSD;buy;0.01;2026.10.12 10:40:00;4171.82;2026.10.12 11:20:45;4176.17;-0.04;0;3.89;SSP scalp;999999;tp;0;0\n")
        f.write("3;XAUUSD;sell;0.01;2026.10.12 15:20:00;4164.60;2026.10.12 15:40:00;4151.70;-0.04;0;11.0;SSPv4;202504;tp;0;0\n")
        f.write("4;EURUSD;buy;0.10;2026.10.12 11:00:00;1.1;2026.10.12 12:00:00;1.2;-0.7;0;5;;772700;tp;0;0\n")
    pc, mc = posizioni_da_csv(fc)
    class Ac(Ar): file = fc
    b2 = io.StringIO(); referto(pc, mc, Ac, radice, out=b2); t2 = b2.getvalue()
    chk("AVVISO AMBIGUITA'" in t2, "csv: stesso commento con 2 magic -> ambiguita'")
    chk("magic 202504 usa 2 famiglie" in t2, "csv: stesso magic con 2 commenti")
    chk("(senza commento) magic 772700" in t2, "csv: commento vuoto -> riserva per magic")
    chk("S/L e T/P NON DISPONIBILI" in t2, "csv: dichiarata l'assenza di SL/TP")
    chk("NON CAPPATO" not in t2 and "SL IGNOTO" in t2, "csv: SL ignoto NON scambiato per 'senza SL'")
    # --- CONTRO-ESEMPI del cancello 13/10 (ognuno rompeva la v1) ---
    chk(not RE_BROKER.match("Cancello DAX L") and not RE_BROKER.match("SL:20 TP:40 v2"),
        "CE commento d'EA 'Cancello ...'/'SL:20 ...' NON scambiato per commento del broker")
    chk(num("1.234,56") == 1234.56 and num("1,234.56") == 1234.56 and num("-35,77") == -35.77 and num("1 234.56") == 1234.56,
        "CE numeri con separatori it-IT/en letti giusti (prima '1.234,56' -> None -> profitto 0)")
    chk(famiglia("SUPERWAVE SELL 1", "US30")[0] == famiglia("SUPERWAVE SELL ", "US30")[0] == "SUPERWAVE",
        "CE 'SUPERWAVE SELL 1' e 'SUPERWAVE SELL ' stessa famiglia")
    PX = []
    for i in range(4):   # SL messo con modifica: ordine senza SL, SL protettivo alla chiusura
        PX.append((700 + i, "2026.10.07 %02d:07:23" % (9 + i), "2026.10.07 %02d:07:23" % (9 + i), "EURUSD", "buy", 0.10, 1.1000, None, 1.1100,
                   "2026.10.07 %02d:50:00" % (9 + i), 1.0950, 1.0950, 1.1100, -0.70, -50.0, "[sl 1.0950]", "MODSL_L"))
    PX.append((801, "2026.10.08 09:03:41", "2026.10.08 09:03:41", "GBPUSD", "buy", 0.10, 1.3, 1.29, 1.31, "2026.10.08 12:00:00", 1.305, 1.29, 1.31, -0.7, 50.0, "altro", "STRADDLE"))
    PX.append((802, "2026.10.08 09:03:41", "2026.10.08 09:03:41", "GBPUSD", "sell", 0.10, 1.3, 1.31, 1.29, "2026.10.08 12:00:00", 1.305, 1.31, 1.29, -0.7, -50.0, "altro", "STRADDLE"))
    PX.append((811, "2026.10.08 09:00:00", "2026.10.08 09:00:00", "US30", "buy", 0.10, 100.0, 99.0, 102.0, "2026.10.08 12:00:00", 101.0, 99.0, 102.0, -0.7, 10.0, "altro", "STREV DOW H1 L 1/3"))
    PX.append((812, "2026.10.08 09:00:00", "2026.10.08 09:00:00", "US30", "buy", 0.10, 100.0, 99.0, 104.0, "2026.10.08 12:00:00", 101.0, 99.0, 104.0, -0.7, 10.0, "altro", "STREV DOW H1 L 2/3"))
    PX.append((901, "2026.10.08 09:03:41", "2026.10.08 09:03:41", "XAUUSD", "buy", 0.01, 100.0, 99.0, 102.0, "2026.10.08 12:00:00", 101.0, 99.0, 102.0, -0.04, 1.0, "altro", "ORBX 15"))
    PX.append((902, "2026.10.08 09:13:41", "2026.10.08 09:13:41", "XAUUSD", "sell", 0.01, 100.0, 101.0, 98.0, "2026.10.08 12:00:00", 101.0, 101.0, 98.0, -0.04, -1.0, "altro", "ORBX 30"))
    RX = _righe_xlsx(PX, fuori_finestra=False)
    ia = [k for k, r in enumerate(RX) if r and r[0] == "Affari"][0]   # deposito: NON e' trading
    RX.insert(ia + 2, ["2026.10.01 08:00:00", 1, None, "balance", None, None, None, None, 0, 0, 0, 80000.0, 80000.0, "DEPOSIT"])
    fx2 = os.path.join(td, "ce.xlsx"); _xlsx_sintetico(fx2, RX)
    px, mx = posizioni_da_xlsx(fx2, forza_xml=True)
    dn_ = [netto(p) for p in px if not p["aperta"]]
    chk(abs(mx["deal_netto"] - sum(dn_)) < 0.005 and any("NON di trading (balance)" in a_ for a_ in mx["avvisi"]),
        "CE deposito 'balance' ESCLUSO da netto/PF degli Affari (netto Affari %s = netto posizioni %s)" % (fmt(mx["deal_netto"]), fmt(sum(dn_))))
    class Ax(Ar): file = fx2
    b4 = io.StringIO(); R4 = referto(px, mx, Ax, radice, out=b4); t4 = b4.getvalue(); A4 = R4["analisi"]
    ms = A4[("MODSL", "EURUSD")]
    chk(ms["senza_sl"] == 0 and ms["sl_prot_dopo"] == 4 and ms["ist_nocap"] == 0
        and not any(s and "SENZA SL INIZIALE" in t for s, t in etichette(ms)),
        "CE SL messo con modifica (protettivo alla chiusura): NON 'senza SL', NON 'rischio non cappato'")
    chk(A4[("STRADDLE", "GBPUSD")]["hedge"] == 1, "CE buy+sell nello STESSO secondo = hedging")
    sv = A4[("STREV DOW H1", "US30")]
    chk(sv["piramidi"] == 0 and sv["medie"] == 0 and sv["hedge"] == 0, "CE gambe simultanee 1/3 2/3: ne' piramide ne' media ne' hedging")
    chk("AVVISO FUSIONE: 2 varianti" in t4 and "ORBX 15 | ORBX 30" in t4, "CE 'ORBX 15'+'ORBX 30' fusi in 'ORBX *' e la fusione e' DICHIARATA")
    sm = dict(ms); sm["n"] = 30; sm["n_ap"] = 1; sm["n_ch"] = 29
    chk(any(s and "NON MISURATO" in t for s, t in etichette(sm)), "CE merito sulle CHIUSE: 29 chiuse + 1 aperta resta NON MISURATO")
    H = "pid;symbol;side;volume;open_time;open_price;close_time;close_price;commission;swap;profit;strategy;magic;close_reason;session_high;session_low\n"
    fc3 = os.path.join(td, "ce.csv")
    with open(fc3, "w") as f:
        f.write(H)
        f.write("1;XAUUSD;buy;0.01;2026.10.12 09:10:00;100;2026.10.12 11:00:00;101;-0.04;0;1;SAME;111;tp;0;0\n")
        f.write("2;XAUUSD;sell;0.01;2026.10.12 09:30:00;100;2026.10.12 11:00:00;99;-0.04;0;1;SAME;222;tp;0;0\n")
        f.write("3;XAUUSD;buy;0.01;2026.10.12 12:10:00;100;2026.10.12 13:00:00;101;-0.04;0;1;A;B;772001;tp;0;0\n")
        f.write("4;XAUUSD;buy;0.01;2026.10.12 14:10:00;100;2026.10.12 15:00:00;101;-0.04;0;1;ORB Gold Pro;31337;tp;0;0\n")
        f.write("5;XAUUSD;buy;0.01;2026.10.12 16:10:00;100;2026.10.12 17:00:00;101;-0.04;0;1;IchiCross long;250604;tp;0;0\n")
    p3, m3 = posizioni_da_csv(fc3)
    class A3(Ar): file = fc3
    b5 = io.StringIO(); R5 = referto(p3, m3, A3, radice, out=b5); t5 = b5.getvalue()
    same = [k for k in R5["analisi"] if k[0] == "SAME"]
    chk(len(same) == 2 and all(R5["analisi"][k]["hedge"] == 0 for k in same), "CE csv: stesso commento, 2 magic -> analisi SEPARATA, niente falso hedging")
    p_ab = [p for p in p3 if p["pid"] == 3][0]
    chk(p_ab["magic"] == "772001" and p_ab["commento"] == "A;B" and "RICUCITA" in t5, "CE csv: ';' nel commento -> colonna ricucita, magic giusto")
    chk("31337 non riscontrato" in t5 and "NOSTRA per prefisso ma NESSUN magic" in t5, "CE csv: 'ORB ...' di terzi (magic 31337) -> AVVISO sull'attribuzione per prefisso")
    if os.path.isfile(os.path.join(radice, "mql5", "Experts", "IchiCross_Gold_722.mq5")):
        chk("250604 = default di" in t5 and "probabile NOSTRA non censita" in t5, "CE csv: commento non censito ma magic di default dei sorgenti -> AVVISO")
    class As(Ar): file = fc3; solo_non_nostre = True
    R6 = referto(p3, m3, As, radice, out=io.StringIO())
    chk(("ORB GOLD PRO", "XAUUSD") in R6["analisi"], "CE --solo-non-nostre NON nasconde un 'ORB ...' col magic non riscontrato")
    class Ad(Ar): file = fc3; dal = "2026-10-12"
    try:
        referto(p3, m3, Ad, radice, out=io.StringIO()); chk(True, "CE --dal in formato ISO accettato")
    except (SystemExit, TypeError) as e:
        chk(False, "CE --dal in formato ISO: %r" % e)
    class Ab(Ar): file = fc3; dal = "12/10/2026"
    try:
        referto(p3, m3, Ab, radice, out=io.StringIO()); chk(False, "CE --dal illeggibile NON fermato")
    except SystemExit:
        chk(True, "CE --dal illeggibile: uscita controllata, niente TypeError")
    # --- file REALE del 12/10 ---
    if reale and os.path.isfile(reale):
        pr, mr = posizioni_da_xlsx(reale)
        class Re(Ar): file = reale
        b3 = io.StringIO(); R3 = referto(pr, mr, Re, radice, out=b3)
        ch = [p for p in pr if not p["aperta"]]
        chk(len(ch) == 21, "reale: 21 posizioni chiuse (trovate %d)" % len(ch))
        xau = [p for p in ch if p["sym"] == "XAUUSD"]
        chk(len(xau) == 7, "reale: 7 XAUUSD chiuse (trovate %d)" % len(xau))
        bk = sorted(p["profit"] for p in xau if p["fam"] == "BASKET_1234567_*_INITIAL")
        chk(bk == sorted([12.34, 14.69, 15.86]), "reale: Basket chiuse %s" % bk)
        ss = sorted(p["profit"] for p in xau if p["fam"] == "SSP SCALP")
        chk(ss == sorted([-3.90, 3.89, -4.58, 11.30]), "reale: SSP scalp chiuse %s" % ss)
        ap = [p for p in pr if p["aperta"] and p["sym"] == "XAUUSD"]
        chk(len(ap) == 7, "reale: 7 aperte XAUUSD (trovate %d)" % len(ap))
        chk(abs(mr["deal_netto"] - 41.96) < 0.005 and abs((mr.get("res_netto") or 0) - 41.96) < 0.005,
            "reale: netto 41,96 (Affari %.2f, Risultati %s)" % (mr["deal_netto"], mr.get("res_netto")))
        chk(abs((mr.get("res_pf") or 0) - 1.473) < 0.0005, "reale: PF dichiarato 1,473 (%s)" % mr.get("res_pf"))
        # id ordine d'apertura == id posizione: ogni posizione aperta nella finestra ha l'ordine
        nella = [p for p in pr if p["apertura_in_finestra"]]
        chk(all(p["fonte_commento"] == "ordine d'apertura" for p in nella),
            "reale: commento preso dall'ORDINE con id = posizione per tutte le %d posizioni nate in finestra" % len(nella))
        chk(not any(k.startswith("[") for k in R3["fams"]), "reale: nessun gruppo da commenti del broker")
        fuori = sorted(p["pid"] for p in pr if not p["apertura_in_finestra"])
        chk(fuori == [3578322, 3610955, 3613023, 3618625, 3634440],
            "reale: 5 posizioni nate prima della finestra (4 chiuse + LARRY aperta) %s" % fuori)
        chk(abs((mr.get("deal_pf") or 0) - 1.473) < 0.0005, "reale: PF RICALCOLATO dagli Affari 1,473 (%s)" % fmt(mr.get("deal_pf"), 4))
        try:
            import openpyxl  # noqa
            a1, _ = leggi_xlsx(reale); a2, _ = leggi_xlsx(reale, forza_xml=True)
            norm = lambda fs: [[c for c in r if c is not None] for _, rr in fs for r in rr if any(c is not None for c in r)]
            chk(norm(a1) == norm(a2), "reale: lettori openpyxl e XML danno le stesse righe")
        except ImportError:
            pass
    else:
        ko.append("file REALE del 12/10 non trovato (%s): controllo dei conteggi NON eseguito" % reale)
    _tdo.cleanup()
    for m_ in ok: print("PASS  " + m_)
    for m_ in ko: print("FAIL  " + m_)
    print("AUTOTEST: %d PASS, %d FAIL" % (len(ok), len(ko)))
    return 0 if not ko else 1

# =================================== main ======================================
def main():
    ap = argparse.ArgumentParser(description="Natura del motore da storico (descrittivo).")
    ap.add_argument("file", nargs="?")
    ap.add_argument("--formato", choices=("auto", "xlsx", "csv"), default="auto")
    ap.add_argument("--simbolo"); ap.add_argument("--dal"); ap.add_argument("--al")
    ap.add_argument("--solo-non-nostre", action="store_true")
    ap.add_argument("--autotest", action="store_true")
    ap.add_argument("--reale", help="xlsx reale del 12/10 per l'autotest")
    args = ap.parse_args()
    try: sys.stdout.reconfigure(errors="replace")   # commenti non ASCII su console Windows: niente crash
    except (AttributeError, ValueError): pass
    radice = os.path.dirname(os.path.dirname(os.path.abspath(__file__)))
    if args.autotest:
        reale = args.reale or os.path.join(radice, "data", "statements", "ReportHistory_50503392_2026-10-12.xlsx")
        sys.exit(autotest(reale, radice))
    if not args.file: ap.error("serve il file (xlsx o csv)")
    fm = args.formato
    if fm == "auto": fm = "csv" if args.file.lower().endswith(".csv") else "xlsx"
    pos, meta = posizioni_da_csv(args.file) if fm == "csv" else posizioni_da_xlsx(args.file)
    referto(pos, meta, args, radice)

if __name__ == "__main__":
    main()
