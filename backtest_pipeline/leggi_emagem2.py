#!/usr/bin/env python3
# -*- coding: ascii -*-
"""
leggi_emagem2.py -- la PRE-LETTURA del ROUND EMAGEM2 (riga RIGA_ROUND_EMAGEM2.txt) dalla raccolta ROUND_EMAGEM2_<data>.zip estratta.

Differenze da leggi_emagem.py (round EMAGEM del 03/10, che resta com'era): etichette EMAGEM2a/b/c, magic 766901/766902 (a), 766911 (b), 766921 (c) e la
TOLLERANZA DI BANCO di T1 e G1 al posto del "al centesimo" (scritta nei file prova EMAGEM2_{a,b,c}_*.txt PRIMA di ogni numero nuovo): Trades e Equity DD %
ESATTI; Profit |diff| <= 1,00 EUR; Profit Factor e Recovery Factor |diff| <= 0,0002; Expected Payoff |diff| x Trades <= 1,00; Sharpe |diff| x |Profit| <=
|Sharpe| x 1,00. Il bordo e' DENTRO. I residui entro tolleranza si ELENCANO. I criteri di merito di b e c (T3-T6, ATTESA) sono IDENTICI a leggi_emagem.py.
Che cosa fa, e SOLO questo. Rifa' IN MODO INDIPENDENTE dalla riga (Python e Decimal, non PowerShell) il CANCELLO INCROCIATO T1 + G1 di EMAGEM2_a e,
solo se passa, mette in tabella le celle di EMAGEM2_b (D30EUR) ed EMAGEM2_c (NASUSD) con i segni MECCANICI dei criteri congelati PRIMA dei numeri nei
file prova (backtest_pipeline/prove/EMAGEM2_{a,b,c}_*.txt, sezione SOGLIE CONGELATE e ATTESA):
  T3  DD OOS <= 10,00 (colonna 'Equity DD %', rischio 1,0)
  T4  OOS n >= 300 deal (proxy di 150 posizioni: le POSIZIONI si contano da un per-trade, qui NON si puo')
  T6  H1 o H2 con OOS PF >= 1,10 E OOS n >= 300 E IS PF >= 1,00 E DD OOS <= 10 -> la cella NON e solo del Dow
  T5  (aggiunto dal cancello il 03/10): T6 manda in coda SOLO se almeno una cella ADIACENTE sull'asse TF (M30 H1 H2 H3 H4) ha OOS PF >= 1,00 e
      DD OOS <= 10 (anche se ESCLUSA PER COSTO o sotto 300 deal); senza adiacente = "T6 ISOLATA": si scrive, NON entra in coda, NON si archivia
  ATTESA  H1: OOS PF 0,70-0,95 e DD OOS (b) 9-16 / (c) 8-14; n IS/OOS (b) 180-440 / 270-660, (c) 160-320 / 240-480: dentro o fuori, SENZA giudizio
NON FA: T2 (il costo: stop contro spread, la tabella sta nel file prova e dipende da un ATR [DERIVATO]/[INFERITO]); la conta delle POSIZIONI; la
lettura per stagione (OROLOGIO: nessun PF di EMAGEM2 si legge per stagione); nessuna PROMOZIONE, NESSUNA TAGLIA (T7). Il verdetto di merito lo
scrive chi legge, con i criteri dei file prova: questo script stampa i fatti e dice "NON ANCORA MISURATO PER IL MERITO" quando nessuna cella ha
OOS n >= 300.
SOLA LETTURA: non tocca EA, preset, prove, CSV, sedie, conti, taglie.

Uso:
  python3 backtest_pipeline/leggi_emagem2.py RACCOLTA_DIR [--md OUT.md]
  python3 backtest_pipeline/leggi_emagem2.py --autotest
RACCOLTA_DIR = la cartella ROUND_EMAGEM2_<data> estratta dallo zip (ROUND_EMAGEM2a/ ROUND_EMAGEM2b/ ROUND_EMAGEM2c/ PERTRADE/ RIEPILOGO_ROUND_EMAGEM2.txt
LOG_TESTER/). Esce 0 se la lettura e' stata fatta (anche col cancello FAIL, che e' un esito), 2 se la raccolta non e' leggibile.
"""
import csv, io, operator, os, re, sys, tempfile, shutil
from decimal import Decimal, InvalidOperation

QUI = os.path.dirname(os.path.abspath(__file__))
REPO = os.path.abspath(os.path.join(QUI, ".."))
EA = "ABTG_EMA200"
TF_NOMI = [("30", "M30"), ("16385", "H1"), ("16386", "H2"), ("16387", "H3"), ("16388", "H4")]
TF_ORD = [k for k, _ in TF_NOMI]
TF_NOME = dict(TF_NOMI)
# i numeri GIA NOTI della cella della sedia 771531 sul Dow (R110 00_metro = R112 00_metro = r136a = cemad05), come stringhe CSV
T1_ATTESO = {"IS": {"Profit": "4585.40", "Profit Factor": "1.20110", "Equity DD %": "5.7325", "Trades": "237"},
             "OOS": {"Profit": "23321.47", "Profit Factor": "1.52365", "Equity DD %": "7.8323", "Trades": "517"}}
G1_COLONNE = ["Profit", "Expected Payoff", "Profit Factor", "Recovery Factor", "Sharpe Ratio", "Equity DD %", "Trades"]
T1_COLONNE = ["Profit", "Profit Factor", "Equity DD %", "Trades"]   # le quattro che i numeri noti di R110/R112 danno
# ---- LA TOLLERANZA DI BANCO (prove/EMAGEM2_a_*.txt, sezione scritta il 03/10/2026 dopo il cancello di a e prima di ogni cella nuova). Tutto Decimal.
TOL_PROFIT = Decimal("1.00")      # EUR: R274a sez. 3; il residuo R235 (0,97) ci sta
TOL_PF = Decimal("0.0002")        # R274a sez. 3 (PF e RF)
TOL_RF = Decimal("0.0002")
TOL_EP_X_TRADES = Decimal("1.00")     # |diff EP| x Trades <= 1,00 (EP = Profit / Trades)
TOL_SHARPE_X = Decimal("1.00")        # |diff Sharpe| x |Profit| <= |Sharpe| x 1,00 (relativo = 1,00 EUR / Profit)
LE = operator.le                      # il bordo e' DENTRO (<=)
TOL_TRADES = Decimal("0")             # ESATTO
TOL_DD = Decimal("0")                 # ESATTO (4 decimali)
IGNORA = set()                        # solo per i mutanti dell'autotest
USA_T1 = True
USA_G1 = True

def entro(col, va, vb, profit_ref, trades_ref):
    """True se va e vb (Decimal) stanno dentro la TOLLERANZA DI BANCO per la colonna col. vb = riferimento (il numero noto in T1; la gemella col magic piu basso in G1).
    profit_ref e trades_ref sono quelli della cella di riferimento (servono a Expected Payoff e Sharpe)."""
    if col in IGNORA:
        return True
    d = abs(va - vb)
    if col == "Trades":
        return LE(d, TOL_TRADES) if TOL_TRADES else va == vb
    if col == "Equity DD %":
        return LE(d, TOL_DD) if TOL_DD else va == vb
    if col == "Profit":
        return LE(d, TOL_PROFIT)
    if col == "Profit Factor":
        return LE(d, TOL_PF)
    if col == "Recovery Factor":
        return LE(d, TOL_RF)
    if col == "Expected Payoff":
        return LE(d * trades_ref, TOL_EP_X_TRADES)
    if col == "Sharpe Ratio":
        return LE(d * abs(profit_ref), abs(vb) * TOL_SHARPE_X)
    raise ValueError("colonna senza regola di tolleranza: " + col)
JOBS = [("a", "U30USD"), ("b", "D30EUR"), ("c", "NASUSD")]
DD_MURO = Decimal("10.00")
N_T4 = 300
# bande ATTESA dichiarate nei file prova (H1)
ATTESA = {"b": {"pf": (Decimal("0.70"), Decimal("0.95")), "dd": (Decimal("9"), Decimal("16")), "nis": (180, 440), "noos": (270, 660)},
          "c": {"pf": (Decimal("0.70"), Decimal("0.95")), "dd": (Decimal("8"), Decimal("14")), "nis": (160, 320), "noos": (240, 480)}}

def D(x):
    try:
        return Decimal(str(x).strip())
    except InvalidOperation:
        return None

def leggi_csv(base, sig, sim, fase):
    p = os.path.join(base, "ROUND_EMAGEM2" + sig, "%s_%s_%s_EMAGEM2%s.csv" % (EA, sim, fase, sig))
    if not os.path.isfile(p) or os.path.getsize(p) == 0:
        return None, "assente o vuoto: " + p
    rows = list(csv.DictReader(io.StringIO(open(p, encoding="ascii", errors="replace", newline="").read())))
    return rows, ""

def cancello_a(base):
    """T1 + G1 di EMAGEM2_a, da CSV grezzi, con Decimal e con la TOLLERANZA DI BANCO. Ritorna (stato, [differenze T1], [differenze G1], testo, [residui entro tolleranza])."""
    dif, gem, res = [], [], []
    for fase in ("IS", "OOS"):
        rows, err = leggi_csv(base, "a", "U30USD", fase)
        if rows is None:
            return "NON VERIFICABILE", [], [], err, []
        if len(rows) != 2:
            return "NON VERIFICABILE", [], [], "%s: %d righe invece di 2" % (fase, len(rows)), []
        rows = sorted(rows, key=lambda r: D(r["InpMagic"]) or Decimal(0))
        if [r["InpMagic"].strip() for r in rows] != ["766901", "766902"]:
            return "NON VERIFICABILE", [], [], "%s: asse InpMagic %s invece di 766901/766902" % (fase, [r["InpMagic"] for r in rows]), []
        for r in rows:
            vals = {c: D(r[c]) for c in G1_COLONNE}
            if any(v is None for v in vals.values()):
                return "NON VERIFICABILE", [], [], "%s magic %s: colonna non numerica" % (fase, r["InpMagic"]), []
        if USA_T1:
            att = T1_ATTESO[fase]
            for r in rows:
                for col in T1_COLONNE:
                    v = D(r[col]); e = Decimal(att[col])
                    if not entro(col, v, e, D(att["Profit"]), D(att["Trades"])):
                        dif.append("%s magic %s %s [%s] atteso %s" % (fase, r["InpMagic"], col, r[col], att[col]))
                    elif v != e:
                        res.append("%s magic %s %s [%s] contro noto [%s] (scarto %s)" % (fase, r["InpMagic"], col, r[col], att[col], abs(v - e)))
        if USA_G1:
            rif = rows[0]
            for col in G1_COLONNE:
                v0 = D(rif[col]); v1 = D(rows[1][col])
                if not entro(col, v1, v0, D(rif["Profit"]), D(rif["Trades"])):
                    gem.append("%s %s [%s] contro [%s]" % (fase, col, rows[0][col], rows[1][col]))
                elif v1 != v0:
                    res.append("%s gemelle %s [%s] contro [%s] (scarto %s)" % (fase, col, rows[0][col], rows[1][col], abs(v1 - v0)))
    stato = "PASS" if not dif and not gem else "FAIL"
    return stato, dif, gem, "", res

def celle(base, sig, sim):
    """{tf: {IS: {...}, OOS: {...}}} oppure (None, errore)."""
    out = {}
    for fase in ("IS", "OOS"):
        rows, err = leggi_csv(base, sig, sim, fase)
        if rows is None:
            return None, err
        if len(rows) != 5:
            return None, "%s %s: %d righe invece di 5" % (sim, fase, len(rows))
        tfs = sorted(r["InpTF"].strip() for r in rows)
        if tfs != sorted(TF_ORD):
            return None, "%s %s: asse InpTF %s invece di %s" % (sim, fase, tfs, sorted(TF_ORD))
        for r in rows:
            c = out.setdefault(r["InpTF"].strip(), {})
            c[fase] = {"n": int(D(r["Trades"])), "pf": D(r["Profit Factor"]), "dd": D(r["Equity DD %"]), "pr": D(r["Profit"])}
    return out, ""

def sopra_cancelli(c):
    """per T5: una cella e 'sopra i cancelli' se OOS PF >= 1,00 e DD OOS <= 10 (forma, non merito)."""
    o = c["OOS"]
    return o["pf"] >= Decimal("1.00") and o["dd"] <= DD_MURO

def t6_cond(c):
    o, i = c["OOS"], c["IS"]
    return o["pf"] >= Decimal("1.10") and o["n"] >= N_T4 and i["pf"] >= Decimal("1.00") and o["dd"] <= DD_MURO

def leggi_job(base, sig, sim, righe):
    cs, err = celle(base, sig, sim)
    if cs is None:
        righe.append("   %s: NON LEGGIBILE (%s)" % (sim, err))
        return {"letto": False}
    att = ATTESA[sig]
    righe.append("   %s   [IS = 40%% 2024.09.26-2025.06.09, OOS = 60%% 2025.06.10-2026.06.30; rischio 1,0, DD x 0,65 per il confronto col campo]" % sim)
    righe.append("   TF    IS n    IS PF    IS DD    IS profit    OOS n   OOS PF   OOS DD   OOS profit   T3(DD<=10)  T4(n>=300)  attesa H1")
    for tf in TF_ORD:
        i, o = cs[tf]["IS"], cs[tf]["OOS"]
        fuori = ""
        if tf == "16385":
            fp = "PF " + ("dentro" if att["pf"][0] <= o["pf"] <= att["pf"][1] else "FUORI") + " 0,70-0,95"
            fd = "DD " + ("dentro" if att["dd"][0] <= o["dd"] <= att["dd"][1] else "FUORI")
            fn = "n IS " + ("dentro" if att["nis"][0] <= i["n"] <= att["nis"][1] else "FUORI") + " / OOS " + ("dentro" if att["noos"][0] <= o["n"] <= att["noos"][1] else "FUORI")
            fuori = fp + ", " + fd + ", " + fn
        righe.append("   %-4s %6d %8s %8s %12s %8d %8s %8s %12s   %-10s  %-10s  %s" % (TF_NOME[tf], i["n"], i["pf"], i["dd"], i["pr"], o["n"], o["pf"], o["dd"], o["pr"],
                                                                       "si" if o["dd"] <= DD_MURO else "NO (>10)", "si" if o["n"] >= N_T4 else "no (<300)", fuori))
    # T6 / T5
    cand = []
    for k, tf in enumerate(TF_ORD):
        if TF_NOME[tf] not in ("H1", "H2") or not t6_cond(cs[tf]):
            continue
        vic = [TF_ORD[x] for x in (k - 1, k + 1) if 0 <= x < len(TF_ORD)]
        adj = [TF_NOME[v] for v in vic if sopra_cancelli(cs[v])]
        cand.append((TF_NOME[tf], adj))
    nmax = max(cs[tf]["OOS"]["n"] for tf in TF_ORD)
    if cand:
        for nome, adj in cand:
            if adj:
                righe.append("   T6 SCATTA a %s e T5 regge (adiacenti sopra i cancelli: %s): la cella NON e solo del Dow -> CANDIDATA GEMELLA IN CODA (mai in campo in automatico; "
                             "contare le POSIZIONI da un per-trade; T2 dice se FRAGILE o ESCLUSA). T7: nessuna promozione, nessuna taglia." % (nome, ", ".join(adj)))
            else:
                righe.append("   T6 SCATTA a %s ma NESSUNA adiacente e sopra i cancelli: 'T6 ISOLATA' (T5): si scrive, NON entra in coda, NON si archivia, resta una domanda aperta. "
                             "T7: nessuna promozione." % nome)
    elif nmax < N_T4:
        righe.append("   Nessuna cella ha OOS n >= 300 (massimo %d): il round NON ha falsificato niente. Si scrive 'NON ANCORA MISURATO PER IL MERITO' (T4/T6). T7: nessuna promozione." % nmax)
    else:
        righe.append("   T6 NON scatta (H1 e H2 non hanno OOS PF >= 1,10 con n >= 300, IS PF >= 1,00 e DD <= 10): l'attesa REGGE per questo simbolo. T7: nessuna promozione.")
    sotto = [TF_NOME[tf] for tf in TF_ORD if cs[tf]["OOS"]["dd"] > DD_MURO]
    righe.append("   T3: celle con DD OOS sopra 10,00: %s (si scrive nel referto)" % (", ".join(sotto) if sotto else "nessuna"))
    return {"letto": True, "cand": cand, "nmax": nmax}

def stati_dal_riepilogo(base):
    p = os.path.join(base, "RIEPILOGO_ROUND_EMAGEM2.txt")
    if not os.path.isfile(p):
        return None
    m = re.search(r"^STATO: EMAGEM2a=(\S+) EMAGEM2b=(\S+) EMAGEM2c=(\S+)", open(p, encoding="ascii", errors="replace").read(), re.M)
    return None if not m else {"a": m.group(1), "b": m.group(2), "c": m.group(3)}

def leggi(base):
    righe = ["PRE-LETTURA DEL ROUND EMAGEM2 -- %s" % base, "(cancello T1 + G1 rifatto qui da CSV grezzi, in modo indipendente dalla riga; i criteri sono nei file prova, scritti prima dei numeri)", ""]
    st = stati_dal_riepilogo(base)
    if st is None:
        righe.append("RIEPILOGO_ROUND_EMAGEM2.txt assente o senza la riga STATO: NON SI LEGGE (la raccolta non e quella della riga).")
        return 2, righe
    righe.append("STATO dalla riga (catena): EMAGEM2a=%s EMAGEM2b=%s EMAGEM2c=%s   (si leggono solo OK e OK_RIPROVATO; il giudizio sui NV/KO/MISTO e' del referto della riga)" % (st["a"], st["b"], st["c"]))
    ok = lambda s: s in ("OK", "OK_RIPROVATO")
    stato, dif, gem, err, res = ("NON VERIFICABILE", [], [], "EMAGEM2a ha STATO %s: i suoi CSV non sono certificati dalla catena" % st["a"], []) if not ok(st["a"]) else cancello_a(base)
    righe.append("")
    righe.append("CANCELLO INCROCIATO (T1 + G1 di EMAGEM2a): %s" % stato)
    if stato == "PASS":
        righe.append("   T1 PASS: IS 4585.40 / 1.20110 / 5.7325 / 237 e OOS 23321.47 / 1.52365 / 7.8323 / 517 dentro la TOLLERANZA DI BANCO su tutte e due le gemelle (766901, 766902): Trades e DD esatti, Profit entro 1,00 EUR, PF entro 0,0002; G1 PASS: gemelle uguali dentro la tolleranza su 7 colonne.")
        if res:
            righe.append("   RESIDUI DENTRO LA TOLLERANZA (%d, si scrivono, nessun giudizio): %s" % (len(res), " ; ".join(res[:12]) + (" ; ..." if len(res) > 12 else "")))
        else:
            righe.append("   RESIDUI DENTRO LA TOLLERANZA: nessuno (tutto al centesimo).")
    elif stato == "FAIL":
        righe.append("   T1: %s" % ("PASS" if not dif else "FAIL, %d differenze: %s" % (len(dif), " ; ".join(dif[:8]))))
        righe.append("   G1: %s" % ("PASS" if not gem else "FAIL, %d differenze: %s" % (len(gem), " ; ".join(gem[:8]))))
        righe.append("   -> ROUND NULLO per a, b e c (file prova): b e c NON SI LEGGONO (la tolleranza di banco e' stata superata o un numero noto non e' riprodotto). I loro CSV restano nella raccolta per la diagnosi. Prima cosa da guardare: il deposito nel REFERTO del driver (deve dire 100000) e lo SHA256 dell'EA.")
    else:
        righe.append("   %s" % err)
        righe.append("   -> b e c NON SI LEGGONO (il cancello non ha potuto dire PASS).")
    righe.append("")
    if stato == "PASS":
        for sig, sim in JOBS[1:]:
            righe.append("EMAGEM2%s  (%s)  stato catena %s" % (sig, sim, st[sig]))
            if not ok(st[sig]):
                righe.append("   NON SI LEGGE: lo STATO della catena e %s" % st[sig])
            else:
                leggi_job(base, sig, sim, righe)
            righe.append("")
        righe.append("NON FATTO QUI: T2 (costo, tabella nel file prova), conta delle POSIZIONI (per-trade: per b e c le 5 celle TF sovrascrivono lo stesso file), lettura per stagione (OROLOGIO).")
    righe.append("NESSUNA CELLA SI PROMUOVE, NESSUNA TAGLIA SI PROPONE (T7).")
    return 0, righe

# ---------------------------------------------------------------- autotest: il banco col contro-esempio
def _scrivi(base, sig, sim, fase, rows, hdr):
    d = os.path.join(base, "ROUND_EMAGEM2" + sig)
    os.makedirs(d, exist_ok=True)
    with open(os.path.join(d, "%s_%s_%s_EMAGEM2%s.csv" % (EA, sim, fase, sig)), "w", newline="", encoding="ascii") as f:
        w = csv.writer(f, lineterminator="\r\n")
        w.writerow(hdr)
        w.writerows(rows)

def _fixture(base, stati=("OK", "OK", "OK"), a_patch=None, bc=None):
    """a: i CSV VERI di R110 (scritti da MT5 il 26/08, col solo magic portato a 766901/766902). b e c: righe a mano (bc = {sig: {tf: {IS:(n,pf,dd,pr), OOS:(..)}}})."""
    for fase in ("IS", "OOS"):
        src = os.path.join(REPO, "backtest_pipeline", "prove", "R110_CSV_EMADOW", "ABTG_EMA200_U30USD_%s_00_metro.csv" % fase)
        rows = list(csv.reader(open(src, encoding="ascii", newline="")))
        h = rows[0]
        im = h.index("InpMagic")
        out = []
        for n, r in enumerate(rows[1:3]):
            r = list(r)
            r[im] = str(766901 + n)
            out.append(r)
        for (f_, riga, col), val in (a_patch or {}).items():
            if f_ == fase:
                out[riga][h.index(col)] = val
        _scrivi(base, "a", "U30USD", fase, out, h)
    hdr = ["Pass", "Profit", "Expected Payoff", "Profit Factor", "Recovery Factor", "Sharpe Ratio", "Equity DD %", "Trades", "InpTF", "InpMagic"]
    for sig, sim in JOBS[1:]:
        dati = (bc or {}).get(sig) or {}
        for fase in ("IS", "OOS"):
            rows = []
            for k, tf in enumerate(TF_ORD):
                n, pf, dd, pr = dati.get(tf, {}).get(fase, (100, "0.9", "5.0", "-100.00"))
                rows.append([k, pr, "1", pf, "1", "1", dd, n, tf, "766911" if sig == "b" else "766921"])
            _scrivi(base, sig, sim, fase, rows, hdr)
    with open(os.path.join(base, "RIEPILOGO_ROUND_EMAGEM2.txt"), "w", encoding="ascii", newline="") as f:
        f.write("STATO: EMAGEM2a=%s EMAGEM2b=%s EMAGEM2c=%s\r\n" % stati)

def _celle(**kw):
    """tf nome -> (IS, OOS) con ognuno (n, pf, dd, profit)."""
    d = {}
    for nome, (i, o) in kw.items():
        tf = [k for k, v in TF_NOMI if v == nome][0]
        d[tf] = {"IS": i, "OOS": o}
    return d

def _corri(**kw):
    d = tempfile.mkdtemp()
    try:
        _fixture(d, **{k: v for k, v in kw.items() if k in ("stati", "a_patch", "bc")})
        rc, righe = leggi(d)
        return rc, "\n".join(righe)
    finally:
        shutil.rmtree(d, ignore_errors=True)

def _esito(t):
    """dal testo della lettura: ('PASS',) oppure ('FAIL', t1_ok, g1_ok) oppure ('ALTRO',)."""
    if "CANCELLO INCROCIATO (T1 + G1 di EMAGEM2a): PASS" in t:
        return ("PASS",)
    if "CANCELLO INCROCIATO (T1 + G1 di EMAGEM2a): FAIL" in t:
        return ("FAIL", "   T1: PASS" in t, "   G1: PASS" in t)
    return ("ALTRO",)

def _p(fase, riga, **cols):
    return {(fase, riga, c): v for c, v in cols.items()}

def _unisci(*ds):
    o = {}
    for d in ds:
        o.update(d)
    return o

def _casi_cancello():
    """(nome, a_patch, atteso). atteso: 'PASS' | 'T1' (fallisce solo T1) | 'G1' (solo G1) | 'T1+G1'. riga 0 = magic 766901, riga 1 = 766902.
    OOS noto: Profit 23321.47, EP 45.10923, PF 1.52365, RF 2.53681, Sharpe 8.16765, DD 7.8323, n 517. IS noto: Profit 4585.40, EP 19.34768, PF 1.20110, RF 0.78806, Sharpe 3.77377, DD 5.7325, n 237.
    Limiti DERIVATI a mano (non dal codice): EP OOS 1/517 = 0.0019342 (IS 1/237 = 0.0042194); Sharpe OOS 8.16765/23321.47 = 0.00035022 (IS 3.77377/4585.40 = 0.00082300)."""
    O = lambda **c: _p("OOS", 1, **c)
    return [
        ("CSV VERI di R110, due gemelle identiche: PASS", {}, "PASS"),
        ("IL CASO DEL 03/10 (766802: Profit 23321.46, EP 45.10921, Sharpe 8.16764): PASS", O(**{"Profit": "23321.46", "Expected Payoff": "45.10921", "Sharpe Ratio": "8.16764"}), "PASS"),
        ("Profit +1,00 su una gemella (bordo): PASS", O(Profit="23322.47"), "PASS"),
        ("Profit +1,01 su una gemella: T1 e G1", O(Profit="23322.48"), "T1+G1"),
        ("Profit -1,00 su una gemella (bordo): PASS", O(Profit="23320.47"), "PASS"),
        ("Profit -1,01 su una gemella: T1 e G1", O(Profit="23320.46"), "T1+G1"),
        ("Profit +0,60 e -0,60 sulle due gemelle: T1 ok (0,60 ciascuna), G1 no (1,20 fra loro)", _unisci(_p("OOS", 0, Profit="23322.07"), _p("OOS", 1, Profit="23320.87")), "G1"),
        ("Profit +0,97 su entrambe (il residuo R235): PASS", _unisci(_p("OOS", 0, Profit="23322.44"), _p("OOS", 1, Profit="23322.44")), "PASS"),
        ("Profit +1,01 su entrambe: solo T1 (gemelle uguali)", _unisci(_p("OOS", 0, Profit="23322.48"), _p("OOS", 1, Profit="23322.48")), "T1"),
        ("gamba IS: Profit +1,00 (bordo): PASS", _p("IS", 1, Profit="4586.40"), "PASS"),
        ("gamba IS: Profit +1,01: T1 e G1", _p("IS", 1, Profit="4586.41"), "T1+G1"),
        ("Trades 516 su una gemella: T1 e G1", O(Trades="516"), "T1+G1"),
        ("Trades 516 su entrambe: solo T1", _unisci(_p("OOS", 0, Trades="516"), _p("OOS", 1, Trades="516")), "T1"),
        ("Trades 518 su entrambe: solo T1", _unisci(_p("OOS", 0, Trades="518"), _p("OOS", 1, Trades="518")), "T1"),
        ("Equity DD % 7.8324 su una gemella: T1 e G1", O(**{"Equity DD %": "7.8324"}), "T1+G1"),
        ("Equity DD % 7.8322 su entrambe: solo T1", _unisci(_p("OOS", 0, **{"Equity DD %": "7.8322"}), _p("OOS", 1, **{"Equity DD %": "7.8322"})), "T1"),
        ("PF +0,00020 su una gemella (bordo): PASS", O(**{"Profit Factor": "1.52385"}), "PASS"),
        ("PF +0,00021 su una gemella: T1 e G1", O(**{"Profit Factor": "1.52386"}), "T1+G1"),
        ("PF -0,00020 su una gemella (bordo): PASS", O(**{"Profit Factor": "1.52345"}), "PASS"),
        ("PF -0,00021 su una gemella: T1 e G1", O(**{"Profit Factor": "1.52344"}), "T1+G1"),
        ("PF 1.52386 su entrambe: solo T1", _unisci(_p("OOS", 0, **{"Profit Factor": "1.52386"}), _p("OOS", 1, **{"Profit Factor": "1.52386"})), "T1"),
        ("Recovery Factor +0,0002 (bordo): PASS", O(**{"Recovery Factor": "2.53701"}), "PASS"),
        ("Recovery Factor +0,0003: solo G1 (T1 non lo guarda)", O(**{"Recovery Factor": "2.53711"}), "G1"),
        ("Recovery Factor -0,0002 (bordo): PASS", O(**{"Recovery Factor": "2.53661"}), "PASS"),
        ("Recovery Factor -0,00021: solo G1", O(**{"Recovery Factor": "2.53660"}), "G1"),
        ("EP OOS +0,00193 (sotto 1/517): PASS", O(**{"Expected Payoff": "45.11116"}), "PASS"),
        ("EP OOS +0,00194 (sopra 1/517): solo G1", O(**{"Expected Payoff": "45.11117"}), "G1"),
        ("EP OOS -0,00193: PASS", O(**{"Expected Payoff": "45.10730"}), "PASS"),
        ("EP OOS -0,00194: solo G1", O(**{"Expected Payoff": "45.10729"}), "G1"),
        ("EP IS +0,00421 (sotto 1/237): PASS", _p("IS", 1, **{"Expected Payoff": "19.35189"}), "PASS"),
        ("EP IS +0,00422 (sopra 1/237): solo G1", _p("IS", 1, **{"Expected Payoff": "19.35190"}), "G1"),
        ("Sharpe OOS +0,00035 (sotto 0,00035022): PASS", O(**{"Sharpe Ratio": "8.16800"}), "PASS"),
        ("Sharpe OOS +0,00036 (sopra): solo G1", O(**{"Sharpe Ratio": "8.16801"}), "G1"),
        ("Sharpe OOS -0,00035: PASS", O(**{"Sharpe Ratio": "8.16730"}), "PASS"),
        ("Sharpe OOS -0,00036: solo G1", O(**{"Sharpe Ratio": "8.16729"}), "G1"),
        ("Sharpe IS +0,00082 (sotto 0,000823): PASS", _p("IS", 1, **{"Sharpe Ratio": "3.77459"}), "PASS"),
        ("Sharpe IS +0,00083 (sopra): solo G1", _p("IS", 1, **{"Sharpe Ratio": "3.77460"}), "G1"),
        ("banco con deposito sbagliato, gemelle uguali (Profit e Trades di un altro lotto): solo T1", _unisci(
            _p("OOS", 0, Profit="2332.15", Trades="517"), _p("OOS", 1, Profit="2332.15", Trades="517"), _p("IS", 0, Profit="458.54", Trades="230"), _p("IS", 1, Profit="458.54", Trades="230")), "T1"),
    ]

def suite_cancello():
    """Esegue i casi al bordo; ritorna [(nome, ok, dettaglio)]. Usata anche dai mutanti."""
    out = []
    for nome, patch, att in _casi_cancello():
        rc, t = _corri(a_patch=patch)
        e = _esito(t)
        if att == "PASS":
            ok = e == ("PASS",) and "EMAGEM2b  (D30EUR)" in t and "EMAGEM2c  (NASUSD)" in t
        else:
            want_t1 = att in ("G1",)       # T1 deve restare PASS solo se l'atteso e' 'G1'
            want_g1 = att in ("T1",)       # G1 deve restare PASS solo se l'atteso e' 'T1'
            ok = e == ("FAIL", want_t1, want_g1) and "EMAGEM2b  (D30EUR)" not in t and "EMAGEM2c  (NASUSD)" not in t and "NON SI LEGGONO" in t
        out.append((nome, ok, "atteso %s, letto %s | %s" % (att, e, t[:600].replace("\n", " / "))))
    # i residui entro tolleranza si ELENCANO (il 03/10: tre in G1 e uno in T1 sulla gemella 766902)
    rc, t = _corri(a_patch=_p("OOS", 1, **{"Profit": "23321.46", "Expected Payoff": "45.10921", "Sharpe Ratio": "8.16764"}))
    ok = ("RESIDUI DENTRO LA TOLLERANZA (4," in t and "OOS magic 766902 Profit [23321.46] contro noto [23321.47] (scarto 0.01)" in t and "OOS gemelle Sharpe Ratio [8.16765] contro [8.16764] (scarto 0.00001)" in t
          and "OOS gemelle Expected Payoff [45.10923] contro [45.10921] (scarto 0.00002)" in t)
    out.append(("i residui entro tolleranza del caso 03/10 si ELENCANO (4: Profit in T1, Profit/EP/Sharpe in G1)", ok, t[:900].replace("\n", " / ")))
    rc, t = _corri()
    out.append(("senza residui la riga dice 'nessuno'", "RESIDUI DENTRO LA TOLLERANZA: nessuno" in t, t[:600].replace("\n", " / ")))
    # le funzioni al bordo, scritte a mano (non passano dal lettore): il residuo di R235 (NASUSD, Profit 6587.43 contro 6586.46, PF 1.24027 contro 1.24023)
    out.append(("entro(): il residuo R235 (Profit 0,97; PF 0,00004) e' DENTRO", entro("Profit", Decimal("6587.43"), Decimal("6586.46"), Decimal("6587.43"), Decimal("261")) and entro("Profit Factor", Decimal("1.24027"), Decimal("1.24023"), Decimal("6587.43"), Decimal("261")), ""))
    out.append(("entro(): Trades +1 e DD +0,0001 sono FUORI, Profit 1,01 e PF 0,00021 sono FUORI",
                not entro("Trades", Decimal("518"), Decimal("517"), Decimal("1"), Decimal("517")) and not entro("Equity DD %", Decimal("7.8324"), Decimal("7.8323"), Decimal("1"), Decimal("517"))
                and not entro("Profit", Decimal("1.01"), Decimal("0"), Decimal("1"), Decimal("1")) and not entro("Profit Factor", Decimal("1.00021"), Decimal("1"), Decimal("1"), Decimal("1")), ""))
    return out

def mutanti():
    """Ogni mutante cambia UNA regola della tolleranza (o spegne un cancello) e deve far fallire almeno un caso di suite_cancello(). Ritorna [(nome, preso, dettaglio)]."""
    G = globals()
    lista = [
        ("Profit esatto (tolleranza 0)", {"TOL_PROFIT": Decimal("0")}), ("Profit tolleranza 0,50", {"TOL_PROFIT": Decimal("0.50")}), ("Profit tolleranza 1,01", {"TOL_PROFIT": Decimal("1.01")}),
        ("Profit tolleranza 2,00", {"TOL_PROFIT": Decimal("2.00")}), ("PF tolleranza 0,0001", {"TOL_PF": Decimal("0.0001")}), ("PF tolleranza 0,0003", {"TOL_PF": Decimal("0.0003")}),
        ("RF tolleranza 0,0001", {"TOL_RF": Decimal("0.0001")}), ("RF tolleranza 0,0003", {"TOL_RF": Decimal("0.0003")}),
        ("EP: 0,50 EUR per trade", {"TOL_EP_X_TRADES": Decimal("0.50")}), ("EP: 2,00 EUR per trade", {"TOL_EP_X_TRADES": Decimal("2.00")}),
        ("Sharpe: relativo meta'", {"TOL_SHARPE_X": Decimal("0.50")}), ("Sharpe: relativo doppio", {"TOL_SHARPE_X": Decimal("2.00")}),
        ("Trades con tolleranza 1", {"TOL_TRADES": Decimal("1")}), ("Equity DD % con tolleranza 0,0001", {"TOL_DD": Decimal("0.0001")}), ("Equity DD % con tolleranza 0,001", {"TOL_DD": Decimal("0.001")}),
        ("bordo FUORI (< invece di <=)", {"LE": operator.lt}),
        ("T1 spento", {"USA_T1": False}), ("G1 spento", {"USA_G1": False}),
    ] + [("colonna %s ignorata" % c, {"IGNORA": {c}}) for c in ("Profit", "Expected Payoff", "Profit Factor", "Recovery Factor", "Sharpe Ratio", "Equity DD %", "Trades")]
    orig = {k: G[k] for m in lista for k in m[1]}
    out = []
    try:
        for nome, mod in lista:
            G.update(mod)
            falliti = [n for n, ok, det in suite_cancello() if not ok]
            G.update(orig)
            out.append((nome, len(falliti) > 0, "NESSUN caso e' diventato rosso: la regola non e' collaudata" if not falliti else "rossi: %d (primo: %s)" % (len(falliti), falliti[0][:70])))
    finally:
        G.update(orig)
    return out

def autotest():
    ok = tot = 0
    def caso(nome, cond, dettaglio=""):
        nonlocal ok, tot
        tot += 1
        ok += 1 if cond else 0
        print(("PASS  " if cond else "FALLITO ") + nome + ("" if cond else "   " + dettaglio))
    def corri(**kw):
        d = tempfile.mkdtemp()
        try:
            _fixture(d, **{k: v for k, v in kw.items() if k in ("stati", "a_patch", "bc")})
            rc, righe = leggi(d)
            return rc, "\n".join(righe)
        finally:
            shutil.rmtree(d, ignore_errors=True)
    # 1-2. IL CANCELLO CON LA TOLLERANZA DI BANCO: casi al bordo (il numero scritto nel file prova, e UN passo oltre) sui CSV VERI di R110
    for nome, cond, det in suite_cancello():
        caso(nome, cond, det)
    # 2b. MUTANTI della tolleranza: ogni regola spenta o allargata/ristretta di un passo deve far FALLIRE almeno un caso della suite (il collaudo del collaudo)
    for nome, preso, det in mutanti():
        caso("MUTANTE preso: " + nome, preso, det)
    rc, t = corri(stati=("NV", "OK", "OK"))
    caso("a NV: cancello NON VERIFICABILE, b e c non si leggono", "NON VERIFICABILE" in t and "EMAGEM2b  (D30EUR)" not in t and "EMAGEM2c  (NASUSD)" not in t)
    rc, t = corri(stati=("OK_RIPROVATO", "OK", "OK"))
    caso("a OK_RIPROVATO: il cancello gira", "(T1 + G1 di EMAGEM2a): PASS" in t)
    rc, t = corri(stati=("OK", "NV", "OK"))
    caso("b NV: b non si legge, c si", "NON SI LEGGE: lo STATO della catena e NV" in t and "EMAGEM2c  (NASUSD)" in t and "NASUSD   [IS" in t)
    # 3. T6 / T5 / T4 e i bordi esatti (il contro-esempio e' UN passo sotto la soglia)
    base_b = dict(M30=((120, "0.95", "6.0", "-50"), (200, "0.90", "9.0", "-80")), H2=((60, "0.90", "5.0", "-10"), (150, "0.80", "7.0", "-90")),
                  H3=((30, "0.90", "5.0", "-10"), (80, "0.80", "6.0", "-90")), H4=((20, "0.90", "5.0", "-10"), (50, "0.80", "6.0", "-90")))
    def con_h1(i, o, h2=None):
        d = dict(base_b)
        d["H1"] = (i, o)
        if h2:
            d["H2"] = h2
        return {"b": _celle(**d)}
    h1_ok = ((150, "1.05", "5.0", "900"), (320, "1.15", "8.0", "1900"))
    rc, t = corri(bc=con_h1(*h1_ok, h2=((60, "0.90", "5.0", "-10"), (150, "1.02", "9.0", "100"))))
    caso("T6 + T5: H1 scatta con H2 adiacente sopra i cancelli -> CANDIDATA GEMELLA IN CODA", "T6 SCATTA a H1 e T5 regge (adiacenti sopra i cancelli: H2)" in t and "CANDIDATA GEMELLA IN CODA" in t, t)
    rc, t = corri(bc=con_h1(*h1_ok))
    caso("T6 ISOLATA: H1 scatta ma M30 e H2 sono sotto 1,00", "T6 SCATTA a H1 ma NESSUNA adiacente" in t and "T6 ISOLATA" in t and "CANDIDATA GEMELLA IN CODA" not in t.split("T6 ISOLATA")[1].split("\n")[0], t)
    # T5: l'adiacente conta solo se sta sopra TUTTI e due i cancelli (PF >= 1,00 E DD <= 10) e solo se e VICINA (a un passo sull'asse)
    rc, t = corri(bc=con_h1(*h1_ok, h2=((60, "0.90", "5.0", "-10"), (150, "1.02", "10.01", "100"))))
    caso("T5: adiacente con PF 1,02 ma DD 10,01 NON basta -> T6 ISOLATA", "T6 SCATTA a H1 ma NESSUNA adiacente" in t, t)
    d = dict(base_b); d["H1"] = h1_ok; d["H3"] = ((30, "0.90", "5.0", "-10"), (80, "1.05", "8.0", "100"))
    rc, t = corri(bc={"b": _celle(**d)})
    caso("T5: una cella sopra i cancelli a DUE passi (H3) non e adiacente di H1 -> T6 ISOLATA", "T6 SCATTA a H1 ma NESSUNA adiacente" in t, t)
    d = dict(base_b); d["H1"] = h1_ok; d["M30"] = ((120, "0.95", "6.0", "-50"), (200, "1.00", "10.00", "0"))
    rc, t = corri(bc={"b": _celle(**d)})
    caso("T5: M30 adiacente al bordo esatto (PF 1,00, DD 10,00) basta -> CANDIDATA", "adiacenti sopra i cancelli: M30" in t, t)
    for nome, i, o, scatta in (("PF 1,0999 (un passo sotto 1,10)", h1_ok[0], (320, "1.0999", "8.0", "1900"), False), ("PF 1,10 (bordo)", h1_ok[0], (320, "1.10", "8.0", "1900"), True),
                               ("n OOS 299 (un deal sotto)", h1_ok[0], (299, "1.15", "8.0", "1900"), False), ("n OOS 300 (bordo)", h1_ok[0], (300, "1.15", "8.0", "1900"), True),
                               ("DD OOS 10,01 (un passo sopra)", h1_ok[0], (320, "1.15", "10.01", "1900"), False), ("DD OOS 10,00 (bordo)", h1_ok[0], (320, "1.15", "10.00", "1900"), True),
                               ("PF IS 0,9999 (un passo sotto 1,00)", (150, "0.9999", "5.0", "900"), (320, "1.15", "8.0", "1900"), False), ("PF IS 1,00 (bordo)", (150, "1.00", "5.0", "900"), (320, "1.15", "8.0", "1900"), True)):
        rc, t = corri(bc=con_h1(i, o))
        caso("T6 al bordo: " + nome, ("T6 SCATTA a H1" in t) == scatta, t)
    # una cella che passa T6 a H3 NON conta: la regola e solo H1 o H2
    d = dict(base_b); d["H1"] = ((100, "0.90", "5.0", "-1"), (320, "0.90", "8.0", "-1")); d["H3"] = ((150, "1.05", "5.0", "900"), (320, "1.15", "8.0", "1900"))
    rc, t = corri(bc={"b": _celle(**d)})
    caso("T6 non scatta a H3 (solo H1 o H2)", "T6 SCATTA" not in t and "l'attesa REGGE" in t, t)
    # nessuna cella con n >= 300: NON ANCORA MISURATO PER IL MERITO (e non 'morto')
    rc, t = corri()
    caso("nessuna cella con OOS n >= 300: NON ANCORA MISURATO PER IL MERITO", t.count("NON ANCORA MISURATO PER IL MERITO") == 2 and "l'attesa REGGE" not in t, t)
    # T3: DD sopra il muro si scrive; il bordo 10,00 no
    d = dict(base_b); d["H1"] = ((100, "0.90", "5.0", "-1"), (320, "0.85", "10.01", "-1"))
    rc, t = corri(bc={"b": _celle(**d)})
    caso("T3: DD OOS 10,01 a H1 segnalato (NO (>10))", "NO (>10)" in t and "celle con DD OOS sopra 10,00: H1" in t, t)
    d = dict(base_b); d["H1"] = ((100, "0.90", "5.0", "-1"), (320, "0.85", "10.00", "-1"))
    rc, t = corri(bc={"b": _celle(**d)})
    caso("T3: DD OOS 10,00 a H1 NON segnalato", "NO (>10)" not in t, t)
    # asse TF sbagliato / riga mancante: non leggibile, non un numero inventato
    d = tempfile.mkdtemp()
    try:
        _fixture(d)
        p = os.path.join(d, "ROUND_EMAGEM2b", "%s_D30EUR_OOS_EMAGEM2b.csv" % EA)
        s = open(p).read().replace("16388", "16389")
        open(p, "w").write(s)
        rc, righe = leggi(d)
        t = "\n".join(righe)
        caso("asse TF sbagliato in b: b NON LEGGIBILE, c si legge", "D30EUR: NON LEGGIBILE" in t and "NASUSD   [IS" in t, t)
    finally:
        shutil.rmtree(d, ignore_errors=True)
    d = tempfile.mkdtemp()
    try:
        rc, righe = leggi(d)
        caso("raccolta senza RIEPILOGO: rc 2, non si legge", rc == 2 and "NON SI LEGGE" in "\n".join(righe))
    finally:
        shutil.rmtree(d, ignore_errors=True)
    print("AUTOTEST: %d/%d" % (ok, tot))
    return 0 if ok == tot else 1

def main():
    a = sys.argv[1:]
    if "--autotest" in a:
        sys.exit(autotest())
    if not a or a[0].startswith("--"):
        print(__doc__)
        sys.exit(2)
    rc, righe = leggi(a[0])
    txt = "\n".join(righe)
    print(txt)
    if "--md" in a:
        open(a[a.index("--md") + 1], "w", encoding="ascii", errors="replace").write("```\n" + txt + "\n```\n")
    sys.exit(rc)

if __name__ == "__main__":
    main()
