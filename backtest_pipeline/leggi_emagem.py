#!/usr/bin/env python3
# -*- coding: ascii -*-
"""
leggi_emagem.py -- la PRE-LETTURA del ROUND EMAGEM (riga RIGA_ROUND_EMAGEM.txt) dalla raccolta ROUND_EMAGEM_<data>.zip estratta.

Che cosa fa, e SOLO questo. Rifa' IN MODO INDIPENDENTE dalla riga (Python e Decimal, non PowerShell) il CANCELLO INCROCIATO T1 + G1 di EMAGEM_a e,
solo se passa, mette in tabella le celle di EMAGEM_b (D30EUR) ed EMAGEM_c (NASUSD) con i segni MECCANICI dei criteri congelati PRIMA dei numeri nei
file prova (backtest_pipeline/prove/EMAGEM_{a,b,c}_*.txt, sezione SOGLIE CONGELATE e ATTESA):
  T3  DD OOS <= 10,00 (colonna 'Equity DD %', rischio 1,0)
  T4  OOS n >= 300 deal (proxy di 150 posizioni: le POSIZIONI si contano da un per-trade, qui NON si puo')
  T6  H1 o H2 con OOS PF >= 1,10 E OOS n >= 300 E IS PF >= 1,00 E DD OOS <= 10 -> la cella NON e solo del Dow
  T5  (aggiunto dal cancello il 03/10): T6 manda in coda SOLO se almeno una cella ADIACENTE sull'asse TF (M30 H1 H2 H3 H4) ha OOS PF >= 1,00 e
      DD OOS <= 10 (anche se ESCLUSA PER COSTO o sotto 300 deal); senza adiacente = "T6 ISOLATA": si scrive, NON entra in coda, NON si archivia
  ATTESA  H1: OOS PF 0,70-0,95 e DD OOS (b) 9-16 / (c) 8-14; n IS/OOS (b) 180-440 / 270-660, (c) 160-320 / 240-480: dentro o fuori, SENZA giudizio
NON FA: T2 (il costo: stop contro spread, la tabella sta nel file prova e dipende da un ATR [DERIVATO]/[INFERITO]); la conta delle POSIZIONI; la
lettura per stagione (OROLOGIO: nessun PF di EMAGEM si legge per stagione); nessuna PROMOZIONE, NESSUNA TAGLIA (T7). Il verdetto di merito lo
scrive chi legge, con i criteri dei file prova: questo script stampa i fatti e dice "NON ANCORA MISURATO PER IL MERITO" quando nessuna cella ha
OOS n >= 300.
SOLA LETTURA: non tocca EA, preset, prove, CSV, sedie, conti, taglie.

Uso:
  python3 backtest_pipeline/leggi_emagem.py RACCOLTA_DIR [--md OUT.md]
  python3 backtest_pipeline/leggi_emagem.py --autotest
RACCOLTA_DIR = la cartella ROUND_EMAGEM_<data> estratta dallo zip (ROUND_EMAGEMa/ ROUND_EMAGEMb/ ROUND_EMAGEMc/ PERTRADE/ RIEPILOGO_ROUND_EMAGEM.txt
LOG_TESTER/). Esce 0 se la lettura e' stata fatta (anche col cancello FAIL, che e' un esito), 2 se la raccolta non e' leggibile.
"""
import csv, io, os, re, sys, tempfile, shutil
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
    p = os.path.join(base, "ROUND_EMAGEM" + sig, "%s_%s_%s_EMAGEM%s.csv" % (EA, sim, fase, sig))
    if not os.path.isfile(p) or os.path.getsize(p) == 0:
        return None, "assente o vuoto: " + p
    rows = list(csv.DictReader(io.StringIO(open(p, encoding="ascii", errors="replace", newline="").read())))
    return rows, ""

def cancello_a(base):
    """T1 + G1 di EMAGEM_a, da CSV grezzi, con Decimal. Ritorna (stato, [differenze T1], [differenze G1], testo)."""
    dif, gem = [], []
    for fase in ("IS", "OOS"):
        rows, err = leggi_csv(base, "a", "U30USD", fase)
        if rows is None:
            return "NON VERIFICABILE", [], [], err
        if len(rows) != 2:
            return "NON VERIFICABILE", [], [], "%s: %d righe invece di 2" % (fase, len(rows))
        rows = sorted(rows, key=lambda r: D(r["InpMagic"]) or Decimal(0))
        if [r["InpMagic"].strip() for r in rows] != ["766801", "766802"]:
            return "NON VERIFICABILE", [], [], "%s: asse InpMagic %s invece di 766801/766802" % (fase, [r["InpMagic"] for r in rows])
        for r in rows:
            for col, att in T1_ATTESO[fase].items():
                v = D(r[col])
                if v is None or v != Decimal(att):
                    dif.append("%s magic %s %s [%s] atteso %s" % (fase, r["InpMagic"], col, r[col], att))
        for col in G1_COLONNE:
            if rows[0][col].strip() != rows[1][col].strip():
                gem.append("%s %s [%s] contro [%s]" % (fase, col, rows[0][col], rows[1][col]))
    stato = "PASS" if not dif and not gem else "FAIL"
    return stato, dif, gem, ""

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
    p = os.path.join(base, "RIEPILOGO_ROUND_EMAGEM.txt")
    if not os.path.isfile(p):
        return None
    m = re.search(r"^STATO: EMAGEMa=(\S+) EMAGEMb=(\S+) EMAGEMc=(\S+)", open(p, encoding="ascii", errors="replace").read(), re.M)
    return None if not m else {"a": m.group(1), "b": m.group(2), "c": m.group(3)}

def leggi(base):
    righe = ["PRE-LETTURA DEL ROUND EMAGEM -- %s" % base, "(cancello T1 + G1 rifatto qui da CSV grezzi, in modo indipendente dalla riga; i criteri sono nei file prova, scritti prima dei numeri)", ""]
    st = stati_dal_riepilogo(base)
    if st is None:
        righe.append("RIEPILOGO_ROUND_EMAGEM.txt assente o senza la riga STATO: NON SI LEGGE (la raccolta non e quella della riga).")
        return 2, righe
    righe.append("STATO dalla riga (catena): EMAGEMa=%s EMAGEMb=%s EMAGEMc=%s   (si leggono solo OK e OK_RIPROVATO; il giudizio sui NV/KO/MISTO e' del referto della riga)" % (st["a"], st["b"], st["c"]))
    ok = lambda s: s in ("OK", "OK_RIPROVATO")
    stato, dif, gem, err = ("NON VERIFICABILE", [], [], "EMAGEMa ha STATO %s: i suoi CSV non sono certificati dalla catena" % st["a"]) if not ok(st["a"]) else cancello_a(base)
    righe.append("")
    righe.append("CANCELLO INCROCIATO (T1 + G1 di EMAGEMa): %s" % stato)
    if stato == "PASS":
        righe.append("   T1 PASS: IS 4585.40 / 1.20110 / 5.7325 / 237 e OOS 23321.47 / 1.52365 / 7.8323 / 517 al centesimo su tutte e due le gemelle (766801, 766802); G1 PASS: gemelle identiche su 7 colonne.")
    elif stato == "FAIL":
        righe.append("   T1: %s" % ("PASS" if not dif else "FAIL, %d differenze: %s" % (len(dif), " ; ".join(dif[:8]))))
        righe.append("   G1: %s" % ("PASS" if not gem else "FAIL, %d differenze: %s" % (len(gem), " ; ".join(gem[:8]))))
        righe.append("   -> ROUND NULLO per a, b e c (file prova): b e c NON SI LEGGONO. I loro CSV restano nella raccolta per la diagnosi. Prima cosa da guardare: il deposito nel REFERTO del driver (deve dire 100000) e lo SHA256 dell'EA.")
    else:
        righe.append("   %s" % err)
        righe.append("   -> b e c NON SI LEGGONO (il cancello non ha potuto dire PASS).")
    righe.append("")
    if stato == "PASS":
        for sig, sim in JOBS[1:]:
            righe.append("EMAGEM%s  (%s)  stato catena %s" % (sig, sim, st[sig]))
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
    d = os.path.join(base, "ROUND_EMAGEM" + sig)
    os.makedirs(d, exist_ok=True)
    with open(os.path.join(d, "%s_%s_%s_EMAGEM%s.csv" % (EA, sim, fase, sig)), "w", newline="", encoding="ascii") as f:
        w = csv.writer(f, lineterminator="\r\n")
        w.writerow(hdr)
        w.writerows(rows)

def _fixture(base, stati=("OK", "OK", "OK"), a_patch=None, bc=None):
    """a: i CSV VERI di R110 (scritti da MT5 il 26/08, col solo magic portato a 766801/766802). b e c: righe a mano (bc = {sig: {tf: {IS:(n,pf,dd,pr), OOS:(..)}}})."""
    for fase in ("IS", "OOS"):
        src = os.path.join(REPO, "backtest_pipeline", "prove", "R110_CSV_EMADOW", "ABTG_EMA200_U30USD_%s_00_metro.csv" % fase)
        rows = list(csv.reader(open(src, encoding="ascii", newline="")))
        h = rows[0]
        im = h.index("InpMagic")
        out = []
        for n, r in enumerate(rows[1:3]):
            r = list(r)
            r[im] = str(766801 + n)
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
                rows.append([k, pr, "1", pf, "1", "1", dd, n, tf, "766811" if sig == "b" else "766821"])
            _scrivi(base, sig, sim, fase, rows, hdr)
    with open(os.path.join(base, "RIEPILOGO_ROUND_EMAGEM.txt"), "w", encoding="ascii", newline="") as f:
        f.write("STATO: EMAGEMa=%s EMAGEMb=%s EMAGEMc=%s\r\n" % stati)

def _celle(**kw):
    """tf nome -> (IS, OOS) con ognuno (n, pf, dd, profit)."""
    d = {}
    for nome, (i, o) in kw.items():
        tf = [k for k, v in TF_NOMI if v == nome][0]
        d[tf] = {"IS": i, "OOS": o}
    return d

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
    # 1. i CSV veri di R110: il cancello PASSA, e b e c entrano in tabella
    rc, t = corri()
    caso("T1+G1 PASS sui CSV VERI di R110", "CANCELLO INCROCIATO (T1 + G1 di EMAGEMa): PASS" in t and "EMAGEMb  (D30EUR)" in t and "EMAGEMc  (NASUSD)" in t, t[:400])
    caso("niente promozione, niente taglia", "NESSUNA CELLA SI PROMUOVE, NESSUNA TAGLIA SI PROPONE" in t)
    # 2. contro-esempi del cancello: UNA unita' dell'ultima cifra, in ciascuna colonna, deve rompere T1 e b/c NON si leggono
    for col, val in (("Profit Factor", "1.52366"), ("Profit", "23321.48"), ("Equity DD %", "7.8324"), ("Trades", "516")):
        rc, t = corri(a_patch={("OOS", 0, col): val, ("OOS", 1, col): val})
        caso("T1 FAIL per %s %s su entrambe le gemelle" % (col, val), "(T1 + G1 di EMAGEMa): FAIL" in t and "T1: FAIL" in t and "G1: PASS" in t and "NON SI LEGGONO" in t and "EMAGEMb  (D30EUR)" not in t, t[:500])
    rc, t = corri(a_patch={("IS", 0, "Profit"): "4585.41", ("IS", 1, "Profit"): "4585.41"})
    caso("T1 FAIL sulla gamba IS", "(T1 + G1 di EMAGEMa): FAIL" in t and "IS magic 766801 Profit [4585.41]" in t and "EMAGEMb  (D30EUR)" not in t)
    for col, val in (("Sharpe Ratio", "8.16767"), ("Expected Payoff", "45.10924"), ("Recovery Factor", "2.53682")):
        rc, t = corri(a_patch={("OOS", 1, col): val})
        caso("G1 FAIL per la sola gemella diversa su %s" % col, "T1: PASS" in t and "G1: FAIL" in t and "EMAGEMb  (D30EUR)" not in t, t[:500])
    rc, t = corri(stati=("NV", "OK", "OK"))
    caso("a NV: cancello NON VERIFICABILE, b e c non si leggono", "NON VERIFICABILE" in t and "EMAGEMb  (D30EUR)" not in t)
    rc, t = corri(stati=("OK_RIPROVATO", "OK", "OK"))
    caso("a OK_RIPROVATO: il cancello gira", "(T1 + G1 di EMAGEMa): PASS" in t)
    rc, t = corri(stati=("OK", "NV", "OK"))
    caso("b NV: b non si legge, c si", "NON SI LEGGE: lo STATO della catena e NV" in t and "EMAGEMc  (NASUSD)" in t and "NASUSD   [IS" in t)
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
        p = os.path.join(d, "ROUND_EMAGEMb", "%s_D30EUR_OOS_EMAGEMb.csv" % EA)
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
