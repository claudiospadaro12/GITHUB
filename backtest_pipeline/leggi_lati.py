#!/usr/bin/env python3
# -*- coding: ascii -*-
"""
leggi_lati.py -- la PRE-LETTURA del ROUND LATI (riga RIGA_ROUND_LATI.txt) dalla raccolta ROUND_LATI_<data>.zip estratta.

Che cosa fa, e SOLO questo. Rifa' IN MODO INDIPENDENTE dalla riga (Python e Decimal, non PowerShell) i TRE CANCELLI del round, scritti nei file prova PRIMA dei numeri
(prove/LATI_A1_*_{long,short}.txt e prove/LATI_A2_*_{long,short}.txt, sezione EMENDAMENTO DEL 04/10/2026, e SOGLIE CONGELATE):
  S1  (A2, sentinella, cella L+S di OGNI file A2): Profit 23321.47, PF 1.52365, DD 7.8323, Trades 517 (R110 00_metro, OOS 2025.06.10-2026.06.30) DENTRO LA TOLLERANZA DI BANCO:
      Trades e Equity DD % ESATTI; Profit |diff| <= 1,00 EUR; Profit Factor |diff| <= 0,0002.
  S2  (A2, sentinella, celle pure, criterio del 09/09 invariato): LONG puro n 241 / PF 1.24103, SHORT puro n 302 / PF 1.89147 (R110 01_long e 02_short): n entro 2 per cento
      (|n - n0| <= n0 x 0,02) e PF entro 0,05; Profit e DD NON sono criteri (si elenca lo scarto).
  T2  (A2) e T1 (A1), CANCELLI CROCIATI: le due celle L+S dei due file gemelli uguali dentro la tolleranza di banco su sette colonne (Profit |diff| <= 1,00; Expected Payoff
      |diff| x Trades <= 1,00; PF e Recovery Factor |diff| <= 0,0002; Sharpe |diff| x |Profit| <= |Sharpe| x 1,00; Trades e DD ESATTI), riferimento = il file long (magic piu basso).
Il bordo e' DENTRO. I residui entro tolleranza si ELENCANO. SOLO se A2 (S1, S2, T2) e A1 (T1) sono tutti PASS mette in tabella le celle di LATI_A1 con i SEGNI MECCANICI dei
criteri congelati nei file prova (T2 DD <= 10,00; T4 direzionale/simmetria; ATTESA dentro/fuori; T3 peggior giornata dal per-trade se la cella si riconosce; T5: niente
promozioni, niente spegnimenti). Per i numeri di A1 col cancello NON PASS stampa SOLO lo scarto delle colonne gemelle, mai un valore (classi 1090 e 1092).
NON FA: la conta delle POSIZIONI (n e in DEAL; le posizioni sono circa la meta); nessuna PROMOZIONE, NESSUNA TAGLIA, NESSUNO SPEGNIMENTO (T5: n sotto 150, il MERITO e' SOSPESO,
il RISCHIO si legge a qualunque n: Emendamento B). Il verdetto lo scrive chi legge, con i criteri dei file prova: questo script stampa i fatti.
T3 (peggior giornata) si calcola SOLO dal per-trade: la colonna NON esiste nel CSV (emendamento 3 dei file prova). Il per-trade e' UNO per magic con DUE celle (l'ultima passata
scritta vince): la cella si RICONOSCE dal numero di deal (= Trades di UNA sola cella) e dalla somma (somma - Profit = commissione d'ingresso: k = (somma - Profit)/lotti in
[0,00 ; 3,00], classe 844); se non si riconosce T3 e' [NON MISURATO]. Giornata = data di CHIUSURA del deal, in percento del deposito iniziale 100000 (non del saldo del giorno), senza la
commissione d'ingresso (il per-trade non la porta): dichiarato qui, non nei file prova.
SOLA LETTURA: non tocca EA, preset, prove, CSV, sedie, conti, taglie.

Uso:
  python3 backtest_pipeline/leggi_lati.py RACCOLTA_DIR [--md OUT.md]
  python3 backtest_pipeline/leggi_lati.py --autotest
RACCOLTA_DIR = la cartella ROUND_LATI_<data> estratta dallo zip (ROUND_LATIA2L/ ROUND_LATIA2S/ ROUND_LATIA1L/ ROUND_LATIA1S/ PERTRADE/ RIEPILOGO_ROUND_LATI.txt LOG_TESTER/).
Esce 0 se la lettura e' stata fatta (anche col cancello FAIL, che e' un esito), 2 se la raccolta non e' leggibile.
"""
import csv, io, operator, os, re, sys, tempfile, shutil
from decimal import Decimal, InvalidOperation

QUI = os.path.dirname(os.path.abspath(__file__))
REPO = os.path.abspath(os.path.join(QUI, ".."))
EA = "ABTG_EMA200"
SIM = "U30USD"
DEPOSITO = Decimal("100000")
# (sigla, etichetta, flag ASSE, magic)
JOBS = [("A2L", "LATIA2L", "InpAllowShort", "764102"), ("A2S", "LATIA2S", "InpAllowLong", "764103"),
        ("A1L", "LATIA1L", "InpAllowShort", "764100"), ("A1S", "LATIA1S", "InpAllowLong", "764101")]
ETI = {s: e for s, e, _, _ in JOBS}
AXN = {s: a for s, _, a, _ in JOBS}
MAG = {s: m for s, _, _, m in JOBS}
G1_COLONNE = ["Profit", "Expected Payoff", "Profit Factor", "Recovery Factor", "Sharpe Ratio", "Equity DD %", "Trades"]
S1_COLONNE = ["Profit", "Profit Factor", "Equity DD %", "Trades"]
# i numeri GIA NOTI (R110 OOS, CSV veri; R112 00_metro li ha riprodotti), come stringhe CSV
S1_ATTESO = {"Profit": "23321.47", "Profit Factor": "1.52365", "Equity DD %": "7.8323", "Trades": "517"}
S2_ATTESO = {"L": {"Trades": "241", "Profit Factor": "1.24103", "Profit": "5670.52", "Equity DD %": "8.8973"},
             "S": {"Trades": "302", "Profit Factor": "1.89147", "Profit": "16948.35", "Equity DD %": "2.6628"}}
# ---- LA TOLLERANZA DI BANCO (la stessa di EMAGEM2, riscritta nei file LATI il 04/10/2026 prima di ogni numero LATI). Tutto Decimal.
TOL_PROFIT = Decimal("1.00")      # EUR
TOL_PF = Decimal("0.0002")
TOL_RF = Decimal("0.0002")
TOL_EP_X_TRADES = Decimal("1.00")     # |diff EP| x Trades <= 1,00
TOL_SHARPE_X = Decimal("1.00")        # |diff Sharpe| x |Profit| <= |Sharpe| x 1,00
LE = operator.le                      # il bordo e' DENTRO (<=)
TOL_TRADES = Decimal("0")             # ESATTO
TOL_DD = Decimal("0")                 # ESATTO (4 decimali)
TOL_N_PURA = Decimal("0.02")          # S2: n entro 2 per cento (criterio del 09/09)
TOL_PF_PURA = Decimal("0.05")         # S2: PF entro 0,05 (criterio del 09/09)
IGNORA = set()                        # solo per i mutanti dell'autotest
USA_S1 = True
USA_S2 = True
USA_T2 = True
USA_T1A1 = True

def entro(col, va, vb, profit_ref, trades_ref):
    """True se va e vb (Decimal) stanno dentro la TOLLERANZA DI BANCO per la colonna col. vb = riferimento (il numero noto in S1; la gemella del file long nei cancelli crociati)."""
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

def D(x):
    try:
        return Decimal(str(x).strip())
    except InvalidOperation:
        return None

def leggi_csv(base, sig):
    p = os.path.join(base, "ROUND_" + ETI[sig], "%s_%s_IS_%s.csv" % (EA, SIM, ETI[sig]))
    if not os.path.isfile(p) or os.path.getsize(p) == 0:
        return None, "assente o vuoto: " + p
    rows = list(csv.DictReader(io.StringIO(open(p, encoding="ascii", errors="replace", newline="").read())))
    return rows, ""

def cella(rows, ax, val):
    """la riga con ax == val (UNA sola) oppure None."""
    r = [x for x in rows if D(x.get(ax)) == Decimal(val)]
    return r[0] if len(r) == 1 else None

def _due_file(base, s1, s2):
    """le celle (pura, L+S) dei due file gemelli, controllando asse e magic. Ritorna (dict, errore)."""
    out = {}
    for sig in (s1, s2):
        rows, err = leggi_csv(base, sig)
        if rows is None:
            return None, err
        if len(rows) != 2:
            return None, "%s: %d righe invece di 2" % (sig, len(rows))
        for r in rows:
            if (r.get("InpMagic") or "").strip() != MAG[sig]:
                return None, "%s: InpMagic %s invece di %s" % (sig, r.get("InpMagic"), MAG[sig])
        ax = AXN[sig]
        pura, ls = cella(rows, ax, "0"), cella(rows, ax, "1")
        if pura is None or ls is None:
            return None, "%s: asse %s non 0 e 1 (una volta ciascuno)" % (sig, ax)
        for r in (pura, ls):
            if any(D(r.get(c)) is None for c in G1_COLONNE):
                return None, "%s: colonna non numerica" % sig
        out[sig] = {"pura": pura, "ls": ls}
    return out, ""

def cancello_a2(base):
    """S1 + S2 + T2 di LATI-A2, da CSV grezzi. Ritorna dict(stato, s1, s2, t2, res, info, err)."""
    c, err = _due_file(base, "A2L", "A2S")
    R = {"stato": "NON VERIFICABILE", "s1": [], "s2": [], "t2": [], "res": [], "info": [], "err": err}
    if c is None:
        return R
    if USA_S1:
        pe, ne = D(S1_ATTESO["Profit"]), D(S1_ATTESO["Trades"])
        for sig in ("A2L", "A2S"):
            for col in S1_COLONNE:
                v = D(c[sig]["ls"][col]); e = D(S1_ATTESO[col])
                if not entro(col, v, e, pe, ne):
                    R["s1"].append("%s L+S %s [%s] atteso %s" % (ETI[sig], col, c[sig]["ls"][col], S1_ATTESO[col]))
                elif v != e:
                    R["res"].append("%s L+S %s [%s] contro R110 [%s] (scarto %s)" % (ETI[sig], col, c[sig]["ls"][col], S1_ATTESO[col], abs(v - e)))
    if USA_S2:
        for sig, lato, nome in (("A2L", "L", "LATIA2L pura LONG"), ("A2S", "S", "LATIA2S pura SHORT")):
            r = c[sig]["pura"]; att = S2_ATTESO[lato]
            n, nt = D(r["Trades"]), D(att["Trades"])
            pf, pft = D(r["Profit Factor"]), D(att["Profit Factor"])
            if abs(n - nt) > nt * TOL_N_PURA:
                R["s2"].append("%s Trades [%s] atteso %s +-2 per cento" % (nome, r["Trades"], att["Trades"]))
            if abs(pf - pft) > TOL_PF_PURA:
                R["s2"].append("%s Profit Factor [%s] atteso %s +-0,05" % (nome, r["Profit Factor"], att["Profit Factor"]))
            R["info"].append("%s: Trades %s PF %s (R110 %s / %s), scarto Profit %s e DD %s (informativi, non sono criteri)" % (
                nome, r["Trades"], r["Profit Factor"], att["Trades"], att["Profit Factor"], abs(D(r["Profit"]) - D(att["Profit"])), abs(D(r["Equity DD %"]) - D(att["Equity DD %"]))))
    if USA_T2:
        a, b = c["A2L"]["ls"], c["A2S"]["ls"]
        for col in G1_COLONNE:
            v0, v1 = D(a[col]), D(b[col])
            if not entro(col, v1, v0, D(a["Profit"]), D(a["Trades"])):
                R["t2"].append("%s [%s] contro [%s]" % (col, a[col], b[col]))
            elif v1 != v0:
                R["res"].append("gemelle L+S %s [%s] contro [%s] (scarto %s)" % (col, a[col], b[col], abs(v1 - v0)))
    R["stato"] = "PASS" if not R["s1"] and not R["s2"] and not R["t2"] else "FAIL"
    return R

def cancello_a1(base):
    """T1 di LATI-A1 (le due celle L+S dei due file gemelli), da CSV grezzi. NESSUN valore nelle uscite: solo gli scarti. Ritorna dict(stato, dif, res, err)."""
    c, err = _due_file(base, "A1L", "A1S")
    R = {"stato": "NON VERIFICABILE", "dif": [], "res": [], "err": err}
    if c is None:
        return R
    if USA_T1A1:
        a, b = c["A1L"]["ls"], c["A1S"]["ls"]
        for col in G1_COLONNE:
            v0, v1 = D(a[col]), D(b[col])
            if not entro(col, v1, v0, D(a["Profit"]), D(a["Trades"])):
                R["dif"].append("%s scarto %s" % (col, abs(v1 - v0)))
            elif v1 != v0:
                R["res"].append("gemelle L+S %s scarto %s" % (col, abs(v1 - v0)))
    R["stato"] = "PASS" if not R["dif"] else "FAIL"
    return R

# ---------------------------------------------------------------- A1: i SEGNI MECCANICI dei criteri congelati (solo a cancelli PASS)
DD_MURO = Decimal("10.00")
ATTESA_A1 = {"L": {"n": (32, 62), "pf": (Decimal("0.60"), Decimal("1.30")), "dd": (Decimal("3"), Decimal("14"))},
             "S": {"n": (36, 78), "pf": (Decimal("0.80"), Decimal("2.20")), "dd": (Decimal("1"), Decimal("8"))},
             "LS": {"n": (70, 135)}}
GIORNATA_ALLARME = Decimal("-3.00")

def pertrade(base, sig):
    p = os.path.join(base, "PERTRADE", "abtg_trades_%s_%s_%s.csv" % (EA, SIM, MAG[sig]))
    if not os.path.isfile(p):
        return None
    try:
        return list(csv.DictReader(io.StringIO(open(p, encoding="ascii", errors="replace", newline="").read()), delimiter=";"))
    except Exception:
        return None

def t3(base, sig, celle):
    """riconosce la cella del per-trade (n deal = Trades di UNA cella, k = (somma - Profit)/lotti in [0;3]) e calcola la peggior giornata (% del deposito). Ritorna (nome_cella|None, testo)."""
    pt = pertrade(base, sig)
    if pt is None:
        return None, "per-trade assente o illeggibile: T3 [NON MISURATO]"
    n = len(pt)
    cand = [nome for nome, r in celle.items() if D(r["Trades"]) == n]
    if len(cand) != 1:
        return None, "per-trade con %d deal: non coincide con UNA SOLA cella del CSV (%s): T3 [NON MISURATO]" % (n, ", ".join("%s=%s" % (k, r["Trades"]) for k, r in celle.items()))
    nome = cand[0]
    try:
        net = [D(x["net_profit"]) for x in pt]; vol = [D(x["volume"]) for x in pt]
    except Exception:
        return None, "per-trade non numerico: T3 [NON MISURATO]"
    if any(x is None for x in net + vol) or sum(vol) == 0:
        return None, "per-trade non numerico: T3 [NON MISURATO]"
    somma, lotti = sum(net), sum(vol)
    k = (somma - D(celle[nome]["Profit"])) / lotti
    if not (Decimal("0") <= k <= Decimal("3.00")):
        return None, "per-trade con %d deal ma la somma non torna con la cella %s (k = %s EUR/lotto fuori da [0,00 ; 3,00]): T3 [NON MISURATO]" % (n, nome, k.quantize(Decimal("0.001")))
    giorni = {}
    for x, v in zip(pt, net):
        gg = x["close_time"].strip()[:10]
        giorni[gg] = giorni.get(gg, Decimal(0)) + v
    gk = min(giorni, key=lambda g: giorni[g])
    pct_x = giorni[gk] / DEPOSITO * 100                      # NON arrotondato: il bordo -3,00 si confronta sul numero vero
    pct = pct_x.quantize(Decimal("0.0001"))
    return nome, "per-trade riconosciuto: cella %s (%d deal, k = %s EUR/lotto); peggior giornata %s %s EUR = %s%% del deposito iniziale: %s" % (
        nome, n, k.quantize(Decimal("0.001")), gk, giorni[gk].quantize(Decimal("0.01")), pct, "ALLARME (<= -3,00)" if pct_x <= GIORNATA_ALLARME else "sotto l'allarme")

def leggi_a1(base, righe):
    c, err = _due_file(base, "A1L", "A1S")
    L, S, LS = c["A1L"]["pura"], c["A1S"]["pura"], c["A1L"]["ls"]
    righe.append("LATI_A1 -- DISCESA 2025.02.01-2025.04.30, UNA tranche, rischio 1,0 (DD x 0,65 per il confronto col campo); n e in DEAL (le posizioni sono circa la meta)")
    righe.append("   cella               n      PF        DD       Profit      T2(DD<=10)   attesa")
    def riga(nome, r, att, t2):
        n, pf, dd = int(D(r["Trades"])), D(r["Profit Factor"]), D(r["Equity DD %"])
        fn = "n " + ("dentro" if att["n"][0] <= n <= att["n"][1] else "FUORI") + " %d-%d" % att["n"]
        fp = fd = ""
        if "pf" in att:
            fp = ", PF " + ("dentro" if att["pf"][0] <= pf <= att["pf"][1] else "FUORI") + " %s-%s" % att["pf"]
            fd = ", DD " + ("dentro" if att["dd"][0] <= dd <= att["dd"][1] else "FUORI") + " %s-%s" % att["dd"]
        righe.append("   %-18s %4d %9s %9s %12s   %-11s  %s" % (nome, n, pf, dd, r["Profit"], ("si" if dd <= DD_MURO else "NO (>10)") if t2 else "-", fn + fp + fd))
    riga("LONG puro (A1L)", L, ATTESA_A1["L"], True)
    riga("SHORT puro (A1S)", S, ATTESA_A1["S"], True)
    riga("L+S (sedia intera)", LS, ATTESA_A1["LS"], False)
    pfl, pfs = D(L["Profit Factor"]), D(S["Profit Factor"])
    righe.append("   T2 (rischio, a QUALUNQUE n, Emendamento B): DD LONG puro %s e DD SHORT puro %s contro 10,00 a rischio 1,0: %s" % (
        L["Equity DD %"], S["Equity DD %"], "tutti e due <= 10,00" if D(L["Equity DD %"]) <= DD_MURO and D(S["Equity DD %"]) <= DD_MURO else "ALMENO UNO > 10,00: la sedia non si schiera alla taglia prevista senza rifare i conti (dossier di schieramento)"))
    righe.append("   T4 (file long) PF(LONG, DISCESA) %s contro 0,80: %s" % (pfl, "< 0,80 con PF(LONG, TORO) = 1,24: il motore e' DIREZIONALE, va scritto nel contratto della sedia (etichetta, non bocciatura: cambia la taglia, non l'accensione)" if pfl < Decimal("0.80") else ">= 0,80: T4 non scatta"))
    if pfs >= Decimal("1.10"):
        t4s = ">= 1,10 con PF(SHORT, TORO) = 1,89: SIMMETRIA, il lato short e' meta' del motore e va dichiarato tale"
    elif pfs < Decimal("0.80"):
        t4s = "< 0,80: lo short perde proprio quando l'indice scende, il PF 1,89 del toro e' un ARTEFATTO da indagare PRIMA di schierare"
    else:
        t4s = "fra 0,80 e 1,10: nessuno dei due segni scatta"
    righe.append("   T4 (file short) PF(SHORT, DISCESA) %s: %s" % (pfs, t4s))
    for sig, celle in (("A1L", {"pura": L, "ls": LS}), ("A1S", {"pura": S, "ls": LS})):
        nome, txt = t3(base, sig, celle)
        righe.append("   T3 %s: %s%s" % (ETI[sig], txt, " -- e' la cella L+S, NON la pura: T3 della cella pura [NON MISURATO]" if nome == "ls" else ""))
    righe.append("   T5: nessuna promozione, nessuno spegnimento, nessuna taglia: n sotto 150 (in deal; ancora meno in posizioni), il MERITO e' SOSPESO; il RISCHIO si legge a qualunque n (Emendamento B).")
    righe.append("   REGIME: la finestra e' DISCESA E RIMBALZO (un solo episodio, Emendamento C non soddisfabile sugli indici BCM): il verdetto massimo e' 'il RISCHIO regge in una discesa', mai 'il regime e' provato'.")

def stati_dal_riepilogo(base):
    p = os.path.join(base, "RIEPILOGO_ROUND_LATI.txt")
    if not os.path.isfile(p):
        return None
    m = re.search(r"^STATO: LATIA2L=(\S+) LATIA2S=(\S+) LATIA1L=(\S+) LATIA1S=(\S+)", open(p, encoding="ascii", errors="replace").read(), re.M)
    return None if not m else {"A2L": m.group(1), "A2S": m.group(2), "A1L": m.group(3), "A1S": m.group(4)}

def leggi(base):
    righe = ["PRE-LETTURA DEL ROUND LATI -- %s" % base, "(cancelli rifatti qui da CSV grezzi, in modo indipendente dalla riga; i criteri sono nei file prova, scritti prima dei numeri)", ""]
    st = stati_dal_riepilogo(base)
    if st is None:
        righe.append("RIEPILOGO_ROUND_LATI.txt assente o senza la riga STATO: NON SI LEGGE (la raccolta non e' quella della riga).")
        return 2, righe
    righe.append("STATO dalla riga (catena): LATIA2L=%s LATIA2S=%s LATIA1L=%s LATIA1S=%s   (si leggono solo OK e OK_RIPROVATO; il giudizio sui NV/KO e' del referto della riga)" % (st["A2L"], st["A2S"], st["A1L"], st["A1S"]))
    ok = lambda s: s in ("OK", "OK_RIPROVATO")
    if not (ok(st["A2L"]) and ok(st["A2S"])):
        a2 = {"stato": "NON VERIFICABILE", "s1": [], "s2": [], "t2": [], "res": [], "info": [], "err": "LATIA2L ha STATO %s e LATIA2S ha STATO %s: i loro CSV non sono certificati dalla catena" % (st["A2L"], st["A2S"])}
    else:
        a2 = cancello_a2(base)
    if not (ok(st["A1L"]) and ok(st["A1S"])):
        a1 = {"stato": "NON VERIFICABILE", "dif": [], "res": [], "err": "LATIA1L ha STATO %s e LATIA1S ha STATO %s: i loro CSV non sono certificati dalla catena" % (st["A1L"], st["A1S"])}
    else:
        a1 = cancello_a1(base)
    righe.append("")
    righe.append("CANCELLO A2 (sentinella T1 + gemelle T2 di LATI-A2): %s" % a2["stato"])
    if a2["stato"] == "PASS":
        righe.append("   S1 PASS: le due celle L+S riproducono 23321.47 / 1.52365 / 7.8323 / 517 di R110 dentro la TOLLERANZA DI BANCO (Trades e DD esatti, Profit entro 1,00 EUR, PF entro 0,0002); S2 PASS: LONG puro e SHORT puro dentro 2 per cento su n e 0,05 su PF di 241 / 1,24103 e 302 / 1,89147; T2 PASS: le due celle L+S dei due file uguali dentro la tolleranza su 7 colonne.")
        righe.append("   RESIDUI DENTRO LA TOLLERANZA (%d, si scrivono, nessun giudizio): %s" % (len(a2["res"]), " ; ".join(a2["res"][:12]) + (" ; ..." if len(a2["res"]) > 12 else "")) if a2["res"] else "   RESIDUI DENTRO LA TOLLERANZA: nessuno (tutto al centesimo).")
        for x in a2["info"]:
            righe.append("   INFORMATIVO " + x)
    elif a2["stato"] == "FAIL":
        for nome, k in (("S1", "s1"), ("S2", "s2"), ("T2", "t2")):
            righe.append("   %s: %s" % (nome, "PASS" if not a2[k] else "FAIL, %d differenze: %s" % (len(a2[k]), " ; ".join(a2[k][:8]))))
        righe.append("   -> BANCO NON CONFERMATO: ROUND LATI-A1 INVALIDO secondo i file prova: i numeri di LATIA1L e LATIA1S NON SI LEGGONO. Prima cosa da guardare: il deposito nel REFERTO del driver (deve dire 100000) e lo SHA256 dell'EA.")
    else:
        righe.append("   %s" % a2["err"])
        righe.append("   -> i numeri di LATIA1L e LATIA1S NON SI LEGGONO (il cancello non ha potuto dire PASS).")
    righe.append("")
    righe.append("CANCELLO A1 (gemelle T1 di LATI-A1): %s" % a1["stato"])
    if a1["stato"] == "PASS":
        righe.append("   T1 PASS: le due celle L+S dei due file LATI_A1 uguali dentro la TOLLERANZA DI BANCO su 7 colonne.")
        righe.append("   RESIDUI DENTRO LA TOLLERANZA (%d, solo scarti): %s" % (len(a1["res"]), " ; ".join(a1["res"][:12])) if a1["res"] else "   RESIDUI DENTRO LA TOLLERANZA: nessuno (tutto al centesimo).")
    elif a1["stato"] == "FAIL":
        righe.append("   T1 FAIL, %d colonne fuori tolleranza (solo scarti): %s" % (len(a1["dif"]), " ; ".join(a1["dif"])))
        righe.append("   -> il banco non e' deterministico: NESSUN numero di LATIA1L e LATIA1S si legge.")
    else:
        righe.append("   %s" % a1["err"])
        righe.append("   -> i numeri di LATIA1L e LATIA1S NON SI LEGGONO (il cancello non ha potuto dire PASS).")
    righe.append("")
    if a2["stato"] == "PASS" and a1["stato"] == "PASS":
        righe.append("LETTURA DI LATI-A1: PERMESSA (i tre cancelli sono PASS)")
        leggi_a1(base, righe)
    else:
        righe.append("LETTURA DI LATI-A1: NON PERMESSA (cancello A2 %s, cancello A1 %s): nessun numero di A1 viene mostrato." % (a2["stato"], a1["stato"]))
    righe.append("")
    righe.append("NON FATTO QUI: la conta delle POSIZIONI (n e in DEAL), il merito (sospeso), il costo, la lettura per stagione (orologio BCM).")
    righe.append("NESSUNA CELLA SI PROMUOVE, NESSUNA TAGLIA SI PROPONE, NESSUNA SEDIA SI SPEGNE (T5).")
    return 0, righe

# ---------------------------------------------------------------- autotest: il banco col contro-esempio
R110 = os.path.join(REPO, "backtest_pipeline", "prove", "R110_CSV_EMADOW")
HDR = ["Pass", "Profit", "Expected Payoff", "Profit Factor", "Recovery Factor", "Sharpe Ratio", "Equity DD %", "Trades", "InpAllowShort", "InpAllowLong", "InpMagic"]
# A1: numeri SINTETICI (tutti distinti fra loro e da R110: servono a vedere se compaiono nelle uscite). Colonne: Profit, EP, PF, RF, Sharpe, DD, Trades
A1_NUM = {"ls": ("-2345.67", "-28.60573", "0.87654", "-0.51234", "-1.23456", "7.1234", "82"),
          "L": ("-1500.12", "-36.58829", "0.80123", "-0.33333", "-0.98765", "5.4321", "41"),
          "S": ("-300.45", "-6.98721", "0.95432", "-0.11111", "-0.22222", "4.2222", "43")}
NO_A1 = ["-2345.67", "0.87654", "7.1234", "-1500.12", "0.80123", "5.4321", "-300.45", "0.95432", "4.2222", "-28.60573", "-0.51234", "-1.23456"]

def _r110(fase_cella):
    src = os.path.join(R110, "ABTG_EMA200_U30USD_OOS_%s.csv" % fase_cella)
    rows = list(csv.DictReader(open(src, encoding="ascii", newline="")))
    r = rows[0]
    return [r["Profit"], r["Expected Payoff"], r["Profit Factor"], r["Recovery Factor"], r["Sharpe Ratio"], r["Equity DD %"], r["Trades"]]

def _scrivi(base, sig, righe_csv):
    d = os.path.join(base, "ROUND_" + ETI[sig]); os.makedirs(d, exist_ok=True)
    with open(os.path.join(d, "%s_%s_IS_%s.csv" % (EA, SIM, ETI[sig])), "w", newline="", encoding="ascii") as f:
        w = csv.writer(f, lineterminator="\r\n"); w.writerow(HDR); w.writerows(righe_csv)

def _fixture(base, stati=("OK", "OK", "OK", "OK"), patch=None, pt=True):
    """patch = {(sig, valore_asse, colonna): valore}. I CSV di A2 sono i numeri VERI di R110 (scritti da MT5 il 26/08, NON da noi)."""
    metro, lng, sht = _r110("00_metro"), _r110("01_long"), _r110("02_short")
    num = {"A2L": {"0": lng, "1": metro}, "A2S": {"0": sht, "1": metro}, "A1L": {"0": list(A1_NUM["L"]), "1": list(A1_NUM["ls"])}, "A1S": {"0": list(A1_NUM["S"]), "1": list(A1_NUM["ls"])}}
    for sig in ("A2L", "A2S", "A1L", "A1S"):
        rows = []
        for i, ax in enumerate(("1", "0")):                  # l'ordine dei Pass NON e' ordinato per asse
            v = list(num[sig][ax])
            for (s_, a_, col), val in (patch or {}).items():
                if s_ == sig and a_ == ax:
                    v[G1_COLONNE.index(col)] = val
            sh, lo = (ax, "1") if AXN[sig] == "InpAllowShort" else ("1", ax)
            rows.append([str(i)] + v + [sh, lo, MAG[sig]])
        _scrivi(base, sig, rows)
    with open(os.path.join(base, "RIEPILOGO_ROUND_LATI.txt"), "w", encoding="ascii", newline="") as f:
        f.write("STATO: LATIA2L=%s LATIA2S=%s LATIA1L=%s LATIA1S=%s\r\n" % stati)
    if pt:
        _pertrade(base)

def _pertrade(base, sig="A1L", n=41, profit="-1500.12", dd_giorno=None, k=Decimal("1.80")):
    """un per-trade che torna con la cella (n deal, somma = Profit + k x lotti)."""
    os.makedirs(os.path.join(base, "PERTRADE"), exist_ok=True)
    lotti = Decimal("2.00") * n
    somma = Decimal(profit) + k * lotti
    righe = []
    # una giornata cattiva: la prima, con il -3,5 per cento del deposito; il resto si distribuisce
    primo = Decimal("-3500.00") if dd_giorno is None else Decimal(dd_giorno)
    resto = ((somma - primo) / (n - 1)).quantize(Decimal("0.01"))
    valori = [primo] + [resto] * (n - 2) + [somma - primo - resto * (n - 2)]       # l'ultimo deal assorbe l'arrotondamento: la somma e' ESATTA
    for i in range(n):
        gg = "2025.03.%02d" % (3 + (i % 20)) if i else "2025.02.14"
        righe.append("%s 10:00:00;U30USD;%s;%d;1;2.00;42000.00;%s" % (gg, MAG[sig], i + 1, valori[i]))
    with open(os.path.join(base, "PERTRADE", "abtg_trades_%s_%s_%s.csv" % (EA, SIM, MAG[sig])), "w", newline="", encoding="ascii") as f:
        f.write("close_time;symbol;magic;position_id;deal_type;volume;price;net_profit\r\n" + "\r\n".join(righe) + "\r\n")

def _corri(**kw):
    d = tempfile.mkdtemp()
    try:
        _fixture(d, **kw)
        rc, righe = leggi(d)
        return rc, "\n".join(righe)
    finally:
        shutil.rmtree(d, ignore_errors=True)

def _p(sig, ax, **cols):
    return {(sig, ax, {"Equity_DD_pct": "Equity DD %"}.get(c, c.replace("_", " "))): v for c, v in cols.items()}

def _unisci(*ds):
    o = {}
    for d in ds:
        o.update(d)
    return o

def _esito(t):
    a2 = "PASS" if "CANCELLO A2 (sentinella T1 + gemelle T2 di LATI-A2): PASS" in t else ("FAIL" if "CANCELLO A2 (sentinella T1 + gemelle T2 di LATI-A2): FAIL" in t else "ALTRO")
    a1 = "PASS" if "CANCELLO A1 (gemelle T1 di LATI-A1): PASS" in t else ("FAIL" if "CANCELLO A1 (gemelle T1 di LATI-A1): FAIL" in t else "ALTRO")
    parti = tuple(x for x in ("S1", "S2", "T2") if a2 == "FAIL" and ("   %s: FAIL" % x) in t)
    return a2, a1, parti

def _casi_a2():
    """(nome, patch, parti che devono FALLIRE: tuple fra S1,S2,T2; () = PASS). Limiti DERIVATI a mano (non dal codice).
    L+S noto (R110 OOS): Profit 23321.47, EP 45.10923, PF 1.52365, RF 2.53681, Sharpe 8.16765, DD 7.8323, n 517. EP: 1/517 = 0.0019342; Sharpe: 8.16765/23321.47 = 0.00035022.
    Celle pure: 241 +-2% = +-4.82 (237..245), 302 +-2% = +-6.04 (296..308); PF +-0.05."""
    LA = lambda **c: _p("A2L", "1", **c)          # cella L+S del file long (riferimento dei gemelli)
    LB = lambda **c: _p("A2S", "1", **c)          # cella L+S del file short (la gemella)
    PL = lambda **c: _p("A2L", "0", **c)          # LONG puro
    PS = lambda **c: _p("A2S", "0", **c)          # SHORT puro
    both = lambda **c: _unisci(_p("A2L", "1", **c), _p("A2S", "1", **c))
    return [
        ("CSV VERI di R110, due gemelle identiche: PASS", {}, ()),
        ("IL CASO DEL 03/10 sulla gemella short (Profit 23321.46, EP 45.10921, Sharpe 8.16764): PASS", LB(Profit="23321.46", Expected_Payoff="45.10921", Sharpe_Ratio="8.16764"), ()),
        ("Profit +1,00 sulla gemella short (bordo): PASS", LB(Profit="23322.47"), ()),
        ("Profit +1,01 sulla gemella short: S1 e T2", LB(Profit="23322.48"), ("S1", "T2")),
        ("Profit -1,00 sulla gemella short (bordo): PASS", LB(Profit="23320.47"), ()),
        ("Profit -1,01 sulla gemella short: S1 e T2", LB(Profit="23320.46"), ("S1", "T2")),
        ("Profit +0,60 e -0,60 sulle due gemelle: S1 ok (0,60 ciascuna), T2 no (1,20 fra loro)", _unisci(LA(Profit="23322.07"), LB(Profit="23320.87")), ("T2",)),
        ("Profit +0,97 su entrambe (il residuo R235): PASS", both(Profit="23322.44"), ()),
        ("Profit +1,01 su entrambe: solo S1 (gemelle uguali)", both(Profit="23322.48"), ("S1",)),
        ("Trades 516 sulla gemella short: S1 e T2", LB(Trades="516"), ("S1", "T2")),
        ("Trades 516 su entrambe: solo S1", both(Trades="516"), ("S1",)),
        ("Trades 518 su entrambe: solo S1", both(Trades="518"), ("S1",)),
        ("Equity DD % 7.8324 sulla gemella short: S1 e T2", LB(Equity_DD_pct="7.8324"), ("S1", "T2")),
        ("Equity DD % 7.8324 su entrambe: solo S1", both(Equity_DD_pct="7.8324"), ("S1",)),
        ("Equity DD % 7.8322 su entrambe: solo S1", both(Equity_DD_pct="7.8322"), ("S1",)),
        ("PF +0,00020 sulla gemella short (bordo): PASS", LB(Profit_Factor="1.52385"), ()),
        ("PF +0,00021 sulla gemella short: S1 e T2", LB(Profit_Factor="1.52386"), ("S1", "T2")),
        ("PF -0,00020 sulla gemella short (bordo): PASS", LB(Profit_Factor="1.52345"), ()),
        ("PF -0,00021 sulla gemella short: S1 e T2", LB(Profit_Factor="1.52344"), ("S1", "T2")),
        ("PF 1.52386 su entrambe: solo S1", both(Profit_Factor="1.52386"), ("S1",)),
        ("Recovery Factor +0,0002 (bordo): PASS", LB(Recovery_Factor="2.53701"), ()),
        ("Recovery Factor +0,0003: solo T2 (S1 non lo guarda)", LB(Recovery_Factor="2.53711"), ("T2",)),
        ("Recovery Factor -0,0002 (bordo): PASS", LB(Recovery_Factor="2.53661"), ()),
        ("Recovery Factor -0,00021: solo T2", LB(Recovery_Factor="2.53660"), ("T2",)),
        ("EP +0,00193 (sotto 1/517): PASS", LB(Expected_Payoff="45.11116"), ()),
        ("EP +0,00194 (sopra 1/517): solo T2", LB(Expected_Payoff="45.11117"), ("T2",)),
        ("EP -0,00193: PASS", LB(Expected_Payoff="45.10730"), ()),
        ("EP -0,00194: solo T2", LB(Expected_Payoff="45.10729"), ("T2",)),
        ("Sharpe +0,00035 (sotto 0,00035022): PASS", LB(Sharpe_Ratio="8.16800"), ()),
        ("Sharpe +0,00036 (sopra): solo T2", LB(Sharpe_Ratio="8.16801"), ("T2",)),
        ("Sharpe -0,00035: PASS", LB(Sharpe_Ratio="8.16730"), ()),
        ("Sharpe -0,00036: solo T2", LB(Sharpe_Ratio="8.16729"), ("T2",)),
        # S2: celle pure
        ("LONG puro n 245 (bordo, 4 <= 4,82): PASS", PL(Trades="245"), ()),
        ("LONG puro n 246 (5 > 4,82): S2", PL(Trades="246"), ("S2",)),
        ("LONG puro n 237 (bordo, 4): PASS", PL(Trades="237"), ()),
        ("LONG puro n 236 (5): S2", PL(Trades="236"), ("S2",)),
        ("SHORT puro n 308 (bordo, 6 <= 6,04): PASS", PS(Trades="308"), ()),
        ("SHORT puro n 309 (7 > 6,04): S2", PS(Trades="309"), ("S2",)),
        ("SHORT puro n 296 (bordo, 6): PASS", PS(Trades="296"), ()),
        ("SHORT puro n 295 (7): S2", PS(Trades="295"), ("S2",)),
        ("LONG puro PF 1.29103 (bordo +0,05): PASS", PL(Profit_Factor="1.29103"), ()),
        ("LONG puro PF 1.29104: S2", PL(Profit_Factor="1.29104"), ("S2",)),
        ("LONG puro PF 1.19103 (bordo -0,05): PASS", PL(Profit_Factor="1.19103"), ()),
        ("LONG puro PF 1.19102: S2", PL(Profit_Factor="1.19102"), ("S2",)),
        ("SHORT puro PF 1.94147 (bordo +0,05): PASS", PS(Profit_Factor="1.94147"), ()),
        ("SHORT puro PF 1.94148: S2", PS(Profit_Factor="1.94148"), ("S2",)),
        ("SHORT puro PF 1.84147 (bordo -0,05): PASS", PS(Profit_Factor="1.84147"), ()),
        ("SHORT puro PF 1.84146: S2", PS(Profit_Factor="1.84146"), ("S2",)),
        ("celle pure: Profit e DD lontani da R110 NON sono criteri: PASS", _unisci(PL(Profit="1000.00", Equity_DD_pct="12.3456"), PS(Profit="2000.00", Equity_DD_pct="0.1234")), ()),
        ("banco con deposito sbagliato, gemelle uguali (Profit e Trades di un altro lotto): solo S1 (la simmetria e cieca)", _unisci(
            both(Profit="2332.15", Trades="444"), PL(Profit="100.00"), PS(Profit="100.00")), ("S1",)),
    ]

def _casi_a1():
    """(nome, patch, atteso 'PASS' | 'T1'). L+S sintetico A1: Profit -2345.67, EP -28.60573, PF 0.87654, RF -0.51234, Sharpe -1.23456, DD 7.1234, n 82.
    Limiti DERIVATI a mano: EP 1/82 = 0.0121951; Sharpe 1.23456/2345.67 = 0.00052631."""
    B = lambda **c: _p("A1S", "1", **c)     # la gemella short (la long e' il riferimento)
    return [
        ("A1 gemelle uguali: PASS", {}, "PASS"),
        ("A1 Profit +1,00 (bordo): PASS", B(Profit="-2344.67"), "PASS"),
        ("A1 Profit +1,01: T1", B(Profit="-2344.66"), "T1"),
        ("A1 Profit -1,00 (bordo): PASS", B(Profit="-2346.67"), "PASS"),
        ("A1 Profit -1,01: T1", B(Profit="-2346.68"), "T1"),
        ("A1 Trades 83: T1", B(Trades="83"), "T1"),
        ("A1 Trades 81: T1", B(Trades="81"), "T1"),
        ("A1 Equity DD % +0,0001: T1", B(Equity_DD_pct="7.1235"), "T1"),
        ("A1 Equity DD % -0,0001: T1", B(Equity_DD_pct="7.1233"), "T1"),
        ("A1 PF +0,0002 (bordo): PASS", B(Profit_Factor="0.87674"), "PASS"),
        ("A1 PF +0,00021: T1", B(Profit_Factor="0.87675"), "T1"),
        ("A1 PF -0,0002 (bordo): PASS", B(Profit_Factor="0.87634"), "PASS"),
        ("A1 PF -0,00021: T1", B(Profit_Factor="0.87633"), "T1"),
        ("A1 RF +0,0002 (bordo): PASS", B(Recovery_Factor="-0.51214"), "PASS"),
        ("A1 RF +0,00021: T1", B(Recovery_Factor="-0.51213"), "T1"),
        ("A1 RF -0,0002 (bordo): PASS", B(Recovery_Factor="-0.51254"), "PASS"),
        ("A1 RF -0,00021: T1", B(Recovery_Factor="-0.51255"), "T1"),
        ("A1 EP +0,01219 (sotto 1/82): PASS", B(Expected_Payoff="-28.59354"), "PASS"),
        ("A1 EP +0,01220 (sopra 1/82): T1", B(Expected_Payoff="-28.59353"), "T1"),
        ("A1 EP -0,01219: PASS", B(Expected_Payoff="-28.61792"), "PASS"),
        ("A1 EP -0,01220: T1", B(Expected_Payoff="-28.61793"), "T1"),
        ("A1 Sharpe +0,00052 (sotto 0,00052631): PASS", B(Sharpe_Ratio="-1.23404"), "PASS"),
        ("A1 Sharpe +0,00053 (sopra): T1", B(Sharpe_Ratio="-1.23403"), "T1"),
        ("A1 Sharpe -0,00052: PASS", B(Sharpe_Ratio="-1.23508"), "PASS"),
        ("A1 Sharpe -0,00053: T1", B(Sharpe_Ratio="-1.23509"), "T1"),
    ]

def suite_cancelli():
    """Esegue i casi al bordo; ritorna [(nome, ok, dettaglio)]. Usata anche dai mutanti."""
    out = []
    for nome, patch, att in _casi_a2():
        rc, t = _corri(patch=patch)
        a2, a1, parti = _esito(t)
        if not att:
            ok = a2 == "PASS" and a1 == "PASS" and "LETTURA DI LATI-A1: PERMESSA" in t
        else:
            ok = a2 == "FAIL" and parti == att and "LETTURA DI LATI-A1: NON PERMESSA" in t and not any(x in t for x in NO_A1)
        out.append(("A2: " + nome, ok, "atteso %s, letto %s %s %s | %s" % (att or "PASS", a2, a1, parti, t[:500].replace("\n", " / "))))
    for nome, patch, att in _casi_a1():
        rc, t = _corri(patch=patch)
        a2, a1, parti = _esito(t)
        if att == "PASS":
            ok = a2 == "PASS" and a1 == "PASS" and "LETTURA DI LATI-A1: PERMESSA" in t
        else:
            ok = a2 == "PASS" and a1 == "FAIL" and "LETTURA DI LATI-A1: NON PERMESSA" in t and not any(x in t for x in NO_A1) and "scarto" in t
        out.append(("A1: " + nome, ok, "atteso %s, letto %s %s | %s" % (att, a2, a1, t[:500].replace("\n", " / "))))
    # i residui entro tolleranza si ELENCANO (A2: coi valori; A1: solo lo scarto)
    rc, t = _corri(patch=_p("A2S", "1", Profit="23321.46", Expected_Payoff="45.10921", Sharpe_Ratio="8.16764"))
    ok = ("RESIDUI DENTRO LA TOLLERANZA (4," in t and "LATIA2S L+S Profit [23321.46] contro R110 [23321.47] (scarto 0.01)" in t and "gemelle L+S Sharpe Ratio [8.16765] contro [8.16764] (scarto 0.00001)" in t
          and "gemelle L+S Expected Payoff [45.10923] contro [45.10921] (scarto 0.00002)" in t)
    out.append(("A2: i residui entro tolleranza del caso 03/10 si ELENCANO (4: Profit in S1, Profit/EP/Sharpe in T2)", ok, t[:900].replace("\n", " / ")))
    rc, t = _corri(patch=_p("A1S", "1", Profit="-2345.17", Sharpe_Ratio="-1.23430"))
    ok = "RESIDUI DENTRO LA TOLLERANZA (2, solo scarti)" in t and "gemelle L+S Profit scarto 0.50" in t and "gemelle L+S Sharpe Ratio scarto 0.00026" in t
    out.append(("A1: i residui entro tolleranza si ELENCANO come scarto (Profit 0,50)", ok, t[:900].replace("\n", " / ")))
    rc, t = _corri()
    out.append(("senza residui la lettura dice 'nessuno'", t.count("RESIDUI DENTRO LA TOLLERANZA: nessuno") == 2, t[:600].replace("\n", " / ")))
    out.append(("entro(): il residuo R235 (Profit 0,97; PF 0,00004) e' DENTRO", entro("Profit", Decimal("6587.43"), Decimal("6586.46"), Decimal("6587.43"), Decimal("261")) and entro("Profit Factor", Decimal("1.24027"), Decimal("1.24023"), Decimal("6587.43"), Decimal("261")), ""))
    out.append(("entro(): Trades +1 e DD +0,0001 sono FUORI, Profit 1,01 e PF 0,00021 sono FUORI",
                not entro("Trades", Decimal("518"), Decimal("517"), Decimal("1"), Decimal("517")) and not entro("Equity DD %", Decimal("7.8324"), Decimal("7.8323"), Decimal("1"), Decimal("517"))
                and not entro("Profit", Decimal("1.01"), Decimal("0"), Decimal("1"), Decimal("1")) and not entro("Profit Factor", Decimal("1.00021"), Decimal("1"), Decimal("1"), Decimal("1")), ""))
    return out

def mutanti():
    """Ogni mutante cambia UNA regola (o spegne un cancello) e deve far fallire almeno un caso di suite_cancelli(). Ritorna [(nome, preso, dettaglio)]."""
    G = globals()
    lista = [
        ("Profit esatto (tolleranza 0)", {"TOL_PROFIT": Decimal("0")}), ("Profit tolleranza 0,50", {"TOL_PROFIT": Decimal("0.50")}), ("Profit tolleranza 1,01", {"TOL_PROFIT": Decimal("1.01")}),
        ("Profit tolleranza 2,00", {"TOL_PROFIT": Decimal("2.00")}), ("PF tolleranza 0,0001", {"TOL_PF": Decimal("0.0001")}), ("PF tolleranza 0,0003", {"TOL_PF": Decimal("0.0003")}),
        ("RF tolleranza 0,0001", {"TOL_RF": Decimal("0.0001")}), ("RF tolleranza 0,0003", {"TOL_RF": Decimal("0.0003")}),
        ("EP: 0,50 EUR per trade", {"TOL_EP_X_TRADES": Decimal("0.50")}), ("EP: 2,00 EUR per trade", {"TOL_EP_X_TRADES": Decimal("2.00")}),
        ("Sharpe: relativo meta'", {"TOL_SHARPE_X": Decimal("0.50")}), ("Sharpe: relativo doppio", {"TOL_SHARPE_X": Decimal("2.00")}),
        ("Trades con tolleranza 1", {"TOL_TRADES": Decimal("1")}), ("Equity DD % con tolleranza 0,0001", {"TOL_DD": Decimal("0.0001")}), ("Equity DD % con tolleranza 0,001", {"TOL_DD": Decimal("0.001")}),
        ("bordo FUORI (< invece di <=)", {"LE": operator.lt}),
        ("S1 spento", {"USA_S1": False}), ("S2 spento", {"USA_S2": False}), ("T2 spento", {"USA_T2": False}), ("T1 di A1 spento", {"USA_T1A1": False}),
        ("S2: n con tolleranza 1 per cento", {"TOL_N_PURA": Decimal("0.01")}), ("S2: n con tolleranza 3 per cento", {"TOL_N_PURA": Decimal("0.03")}),
        ("S2: PF con tolleranza 0,04", {"TOL_PF_PURA": Decimal("0.04")}), ("S2: PF con tolleranza 0,06", {"TOL_PF_PURA": Decimal("0.06")}),
    ] + [("colonna %s ignorata" % c, {"IGNORA": {c}}) for c in ("Profit", "Expected Payoff", "Profit Factor", "Recovery Factor", "Sharpe Ratio", "Equity DD %", "Trades")]
    orig = {k: G[k] for m in lista for k in m[1]}
    out = []
    try:
        for nome, mod in lista:
            G.update(mod)
            falliti = [n for n, ok, det in suite_cancelli() if not ok]
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
    for nome, cond, det in suite_cancelli():
        caso(nome, cond, det)
    for nome, preso, det in mutanti():
        caso("MUTANTE preso: " + nome, preso, det)
    # stati della catena: un job non certificato fa NON VERIFICABILE e nessun numero di A1
    for stati, quale in ((("NV", "OK", "OK", "OK"), "A2L NV"), (("OK", "KO", "OK", "OK"), "A2S KO"), (("OK", "OK", "NV", "OK"), "A1L NV"), (("OK", "OK", "OK", "KO"), "A1S KO")):
        rc, t = _corri(stati=stati)
        caso("%s: cancello NON VERIFICABILE, nessun numero di A1" % quale, "NON VERIFICABILE" in t and "LETTURA DI LATI-A1: NON PERMESSA" in t and not any(x in t for x in NO_A1), t)
    rc, t = _corri(stati=("OK_RIPROVATO", "OK", "OK_RIPROVATO", "OK"))
    caso("OK_RIPROVATO: i cancelli girano", "CANCELLO A2 (sentinella T1 + gemelle T2 di LATI-A2): PASS" in t and "LETTURA DI LATI-A1: PERMESSA" in t)
    # asse sbagliato / magic sbagliato: non leggibile, mai un numero inventato
    d = tempfile.mkdtemp()
    try:
        _fixture(d)
        p = os.path.join(d, "ROUND_LATIA2S", "%s_%s_IS_LATIA2S.csv" % (EA, SIM))
        s = open(p).read().replace(",764103", ",764102")
        open(p, "w").write(s)
        rc, righe = leggi(d); t = "\n".join(righe)
        caso("magic sbagliato in A2S: NON VERIFICABILE", "InpMagic 764102 invece di 764103" in t and "CANCELLO A2 (sentinella T1 + gemelle T2 di LATI-A2): NON VERIFICABILE" in t and "NON PERMESSA" in t, t)
    finally:
        shutil.rmtree(d, ignore_errors=True)
    d = tempfile.mkdtemp()
    try:
        _fixture(d)
        p = os.path.join(d, "ROUND_LATIA1L", "%s_%s_IS_LATIA1L.csv" % (EA, SIM))
        rows = list(csv.reader(open(p, newline=""))); rows[2][8] = "1"        # due volte InpAllowShort = 1
        with open(p, "w", newline="") as f:
            csv.writer(f, lineterminator="\r\n").writerows(rows)
        rc, righe = leggi(d); t = "\n".join(righe)
        caso("asse A1L con due celle uguali (0 mancante): NON VERIFICABILE, nessun numero", "non 0 e 1" in t and "NON PERMESSA" in t and not any(x in t for x in NO_A1), t)
    finally:
        shutil.rmtree(d, ignore_errors=True)
    d = tempfile.mkdtemp()
    try:
        rc, righe = leggi(d)
        caso("raccolta senza RIEPILOGO: rc 2, non si legge", rc == 2 and "NON SI LEGGE" in "\n".join(righe))
    finally:
        shutil.rmtree(d, ignore_errors=True)
    # le letture di A1 (solo a cancelli PASS): T2, T4, ATTESA, T3
    rc, t = _corri()
    caso("A1 a cancelli PASS: tabella con le tre celle e T5", "LONG puro (A1L)" in t and "SHORT puro (A1S)" in t and "L+S (sedia intera)" in t and "T5: nessuna promozione" in t and "REGIME" in t, t)
    caso("A1: T2 dice SI' con DD 5,4321 e 4,2222", "tutti e due <= 10,00" in t, t)
    caso("A1: T4 long: PF 0,80123 NON scatta (bordo 0,80 sopra di 0,00123)", "PF(LONG, DISCESA) 0.80123 contro 0,80: >= 0,80: T4 non scatta" in t, t)
    caso("A1: T4 short: PF 0,95432 fra 0,80 e 1,10: nessun segno", "fra 0,80 e 1,10: nessuno dei due segni scatta" in t, t)
    for nome, a1, att in (("LONG puro PF 0,79999: T4 scatta (direzionale)", {"L": ("-1500.12", "-36.58829", "0.79999", "-0.33333", "-0.98765", "5.4321", "41")}, "< 0,80 con PF(LONG, TORO) = 1,24: il motore e' DIREZIONALE"),
                          ("SHORT puro PF 1,10: SIMMETRIA (bordo)", {"S": ("-300.45", "-6.98721", "1.10000", "-0.11111", "-0.22222", "4.2222", "43")}, ">= 1,10 con PF(SHORT, TORO) = 1,89: SIMMETRIA"),
                          ("SHORT puro PF 1,09999: nessun segno", {"S": ("-300.45", "-6.98721", "1.09999", "-0.11111", "-0.22222", "4.2222", "43")}, "fra 0,80 e 1,10"),
                          ("SHORT puro PF 0,79999: ARTEFATTO", {"S": ("-300.45", "-6.98721", "0.79999", "-0.11111", "-0.22222", "4.2222", "43")}, "il PF 1,89 del toro e' un ARTEFATTO"),
                          ("SHORT puro PF 0,80: bordo, nessun segno", {"S": ("-300.45", "-6.98721", "0.80000", "-0.11111", "-0.22222", "4.2222", "43")}, "fra 0,80 e 1,10")):
        d = tempfile.mkdtemp()
        try:
            _fixture(d)
            for sig, key in (("A1L", "L"), ("A1S", "S")):
                if key in a1:
                    p = os.path.join(d, "ROUND_" + ETI[sig], "%s_%s_IS_%s.csv" % (EA, SIM, ETI[sig]))
                    rows = list(csv.reader(open(p, newline="")))
                    for r in rows[1:]:
                        if r[8 if sig == "A1L" else 9] == "0":
                            r[1:8] = list(a1[key])
                    with open(p, "w", newline="") as f:
                        csv.writer(f, lineterminator="\r\n").writerows(rows)
            rc, righe = leggi(d); t = "\n".join(righe)
            caso("A1: " + nome, att in t, t)
        finally:
            shutil.rmtree(d, ignore_errors=True)
    # T2 sul bordo del 10,00 e oltre
    for nome, dd, att in (("LONG puro DD 10,00 (bordo): <= 10", "10.00", "tutti e due <= 10,00"), ("LONG puro DD 10,01: ALMENO UNO > 10", "10.01", "ALMENO UNO > 10,00")):
        d = tempfile.mkdtemp()
        try:
            _fixture(d)
            p = os.path.join(d, "ROUND_LATIA1L", "%s_%s_IS_LATIA1L.csv" % (EA, SIM))
            rows = list(csv.reader(open(p, newline="")))
            for r in rows[1:]:
                if r[8] == "0":
                    r[6] = dd
            with open(p, "w", newline="") as f:
                csv.writer(f, lineterminator="\r\n").writerows(rows)
            rc, righe = leggi(d); t = "\n".join(righe)
            caso("A1 T2: " + nome, att in t, t)
        finally:
            shutil.rmtree(d, ignore_errors=True)
    # T3: il per-trade si riconosce dal numero di deal e dalla somma
    d = tempfile.mkdtemp()
    try:
        _fixture(d, pt=False)
        _pertrade(d, "A1L", 41, "-1500.12")
        rc, righe = leggi(d); t = "\n".join(righe)
        caso("T3: per-trade con 41 deal = LONG puro (41), k 1,800 in banda: riconosciuto, peggior giornata -3,50% = ALLARME", "per-trade riconosciuto: cella pura (41 deal, k = 1.800 EUR/lotto); peggior giornata 2025.02.14 -3500.00 EUR = -3.5000% del deposito iniziale: ALLARME" in t, t)
    finally:
        shutil.rmtree(d, ignore_errors=True)
    d = tempfile.mkdtemp()
    try:
        _fixture(d, pt=False)
        _pertrade(d, "A1L", 41, "-1500.12", dd_giorno="-2999.99")
        rc, righe = leggi(d); t = "\n".join(righe)
        caso("T3: peggior giornata -2999,99 EUR = -2,99999% sotto l'allarme (bordo -3,00 non raggiunto: il confronto e' sul numero NON arrotondato)", "= -3.0000% del deposito" in t and "sotto l'allarme" in t, t)
    finally:
        shutil.rmtree(d, ignore_errors=True)
    d = tempfile.mkdtemp()
    try:
        _fixture(d, pt=False)
        _pertrade(d, "A1L", 41, "-1500.12", dd_giorno="-3000.00")
        rc, righe = leggi(d); t = "\n".join(righe)
        caso("T3: peggior giornata -3000 EUR = -3,00%: ALLARME (il bordo e' DENTRO)", "= -3.0000% del deposito iniziale: ALLARME" in t, t)
    finally:
        shutil.rmtree(d, ignore_errors=True)
    d = tempfile.mkdtemp()
    try:
        _fixture(d, pt=False)
        _pertrade(d, "A1L", 82, "-2345.67")
        rc, righe = leggi(d); t = "\n".join(righe)
        caso("T3: per-trade con 82 deal = la L+S: la cella pura NON e il per-trade, T3 del LONG puro [NON MISURATO]", "T3 LATIA1L: per-trade riconosciuto: cella ls (82 deal" in t and "e' la cella L+S, NON la pura: T3 della cella pura [NON MISURATO]" in t, t)
    finally:
        shutil.rmtree(d, ignore_errors=True)
    d = tempfile.mkdtemp()
    try:
        _fixture(d, pt=False)
        _pertrade(d, "A1L", 41, "-1500.12", k=Decimal("5.00"))
        rc, righe = leggi(d); t = "\n".join(righe)
        caso("T3: somma che non torna (k 5,00 fuori da [0;3]): NON MISURATO", "la somma non torna con la cella pura (k = 5.000 EUR/lotto fuori da [0,00 ; 3,00]): T3 [NON MISURATO]" in t, t)
    finally:
        shutil.rmtree(d, ignore_errors=True)
    d = tempfile.mkdtemp()
    try:
        _fixture(d, pt=False)
        _pertrade(d, "A1L", 50, "-1500.12")
        rc, righe = leggi(d); t = "\n".join(righe)
        caso("T3: per-trade con 50 deal (nessuna cella): NON MISURATO", "non coincide con UNA SOLA cella del CSV" in t and "T3 [NON MISURATO]" in t, t)
    finally:
        shutil.rmtree(d, ignore_errors=True)
    rc, t = _corri(pt=False)
    caso("T3: per-trade assente: NON MISURATO", "per-trade assente o illeggibile: T3 [NON MISURATO]" in t, t)
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
