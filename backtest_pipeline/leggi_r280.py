#!/usr/bin/env python3
# -*- coding: ascii -*-
"""
leggi_r280.py -- la LETTURA del ROUND R280 (riga RIGA_ROUND_R280.txt) dalla raccolta ROUND_R280_<data>.zip estratta.

R280 = ABTG_Nasdaq_Apertura_US su U30USD (Dow), breakout 15 minuti, DUE lati, M5, tick reali, deposito 10000, rischio 1,0, IS 2024.09.26-2025.06.30,
OOS 2025.07.01-2026.06.30. Due job in UN round: R280e (ancora H4/220 su due celle gemelle, magic 798711/798721 = i cancelli G0 e G1) e R280a (il filtro EMA
su H1, asse InpEmaSlow 220/440/660/880/1100/1320, magic 798701). Criteri congelati PRIMA dei numeri in prove/R280a_*.txt (par. 5-8) e prove/R280e_*.txt, piu'
il completamento scritto in prove/R280_CRITERI_LETTURA_2026-10-05.md (stesso giorno, prima di qualunque corsa: nessun numero R280 esiste).

Che cosa fa, e SOLO questo. Rifa' IN MODO INDIPENDENTE dalla riga (Python e Decimal, non PowerShell) il CANCELLO G0 + G1 di R280e; se passa, mette in tabella
le sei celle di R280a con i segni MECCANICI dei criteri congelati (C-a, C-b, C-c, altopiano, rumore, sentinelle S0 S2 S4) e scrive la zona V1-V4 e la PAROLA
di verdetto. Parole: NULLO (V4: la misura non vale), EFFETTO (V3: la griglia conta), ZONA GRIGIA (V1, V2 o nessuna zona congelata copre il caso),
NON ANCORA MISURATO (la catena non e' integra, o la data e' vecchia). In coda a OGNI parola: "MERITO: NON ANCORA MISURATO" (un regime, n IS < 150 sulle celle corte).
NON FA: la separazione per lato (i due lati non si separano qui: criteri par. 12), nessun per-trade, nessun orologio, nessuna PROMOZIONE, nessuna TAGLIA.
SOLA LETTURA: non tocca EA, preset, prove, CSV, sedie, conti, taglie.

Uso:
  python3 backtest_pipeline/leggi_r280.py RACCOLTA_DIR [--oggi AAAA-MM-GG] [--md OUT.md]
  python3 backtest_pipeline/leggi_r280.py --autotest
RACCOLTA_DIR = la cartella ROUND_R280_<data> estratta dallo zip (ROUND_R280e/ ROUND_R280a/ PERTRADE/ RIEPILOGO_ROUND_R280.txt LOG_TESTER/ CONSOLE_DRIVER/).
Esce 0 se la lettura e' stata fatta (anche con il cancello FAIL, che e' un esito), 2 se la raccolta non e' leggibile.
"""
import csv, datetime, io, operator, os, re, sys, tempfile, shutil
from decimal import Decimal, InvalidOperation, ROUND_HALF_UP

QUI = os.path.dirname(os.path.abspath(__file__))
REPO = os.path.abspath(os.path.join(QUI, ".."))
EA = "ABTG_Nasdaq_Apertura_US"
SIM = "U30USD"
EMA = ["220", "440", "660", "880", "1100", "1320"]          # l asse di R280a, in ordine di memoria (ore su H1)
CENTRO_880 = "880"                                           # la cella con la STESSA memoria in ore dell ancora H4/220
# ---- G0: i numeri GIA NOTI della cella H4/220 (R262b, CSV grezzi del 27/09; riprodotti alla cifra da R245b: assembla.py li rilegge dai CSV veri)
G0_ATTESO = {"IS": {"Profit": "1249.94", "Profit Factor": "1.25920", "Recovery Factor": "1.70352", "Equity DD %": "7.1736", "Trades": "157"},
             "OOS": {"Profit": "2974.09", "Profit Factor": "1.48133", "Recovery Factor": "4.42850", "Equity DD %": "6.6241", "Trades": "199"}}
COL_GATE = ["Profit", "Profit Factor", "Equity DD %", "Trades"]      # le quattro colonne con una tolleranza congelata (R280e, R250 par. 5.1)
COL_INFO = ["Recovery Factor"]                                       # scritta in R280e come numero dell ancora, SENZA tolleranza: si elenca lo scarto, non blocca
# ---- LA TOLLERANZA (prove/R280e_*.txt: "la stessa di R250 par. 5.2" = R246 par. 1 / R250 par. 5.1; PF alla quarta decimale = |d| <= 0,00005 come la classe 875). Decimal.
TOL_PROFIT = Decimal("0.05")
TOL_PF = Decimal("0.00005")
TOL_DD = Decimal("0.01")
TOL_TRADES = Decimal("0")
LE = operator.le                      # il bordo e' DENTRO
IGNORA = set()                        # solo per i mutanti dell autotest
USA_G0 = True
USA_G1 = True
# ---- le soglie di R280a par. 6 (congelate prima dei numeri)
PF_MIN = Decimal("1.10")              # C-a, in IS e in OOS
N_MIN = 150                           # C-b, in IS e in OOS
DD_MAX = Decimal("10.00")             # C-c, in IS e in OOS
RUM_PF = Decimal("0.15")              # rumore |dPF|
RUM_N = 8                             # rumore |dn| (posizioni)
MEGLIO_PF = Decimal("0.15")           # "meglio del default": batte l ancora di piu' di 0,15 di PF in TUTTE E DUE le finestre senza DD peggiore
N_GUASTO = 20                         # S4: Trades < 20 in una finestra = un guasto, non una cella
MUTA_N = 2                            # par. 7: "Trades uguale all ancora al +-2 e il PF alla seconda cifra"
# ---- l ATTESA per cella (par. 5): n IS, n OOS, PF IS, PF OOS, DD IS, DD OOS. Dentro o fuori, SENZA giudizio.
ATTESA = {"220": ((138, 146), (186, 194), ("1.25", "1.55"), ("1.30", "1.40"), (6, 8), ("4.5", "7")),
          "440": ((143, 150), (195, 199), ("1.25", "1.40"), ("1.30", "1.40"), (6, 8), (5, 7)),
          "660": ((150, 155), (196, 199), ("1.25", "1.35"), ("1.30", "1.40"), (6, 8), (6, "8.2")),
          "880": ((152, 162), (195, 203), ("1.15", "1.40"), ("1.35", "1.60"), (6, 8), (5, 8)),
          "1100": ((153, 160), (197, 203), ("1.15", "1.40"), ("1.35", "1.60"), (6, 8), (5, 8)),
          "1320": ((152, 160), (197, 203), ("1.10", "1.35"), ("1.35", "1.60"), (6, 9), (4, 7))}

def D(x):
    """Decimal, o None se il testo non e' un numero FINITO (come [decimal]::TryParse della riga: 'nan' e 'inf' non si leggono)."""
    try:
        d = Decimal(str(x).strip())
    except InvalidOperation:
        return None
    return d if d.is_finite() else None

def entro(col, va, vb):
    """True se va e vb (Decimal) stanno dentro la TOLLERANZA per la colonna col (bordo DENTRO). vb = riferimento (il numero noto in G0; la gemella col magic piu basso in G1)."""
    if col in IGNORA:
        return True
    d = abs(va - vb)
    if col == "Trades":
        return LE(d, TOL_TRADES) if TOL_TRADES else va == vb
    if col == "Profit":
        return LE(d, TOL_PROFIT)
    if col == "Profit Factor":
        return LE(d, TOL_PF)
    if col == "Equity DD %":
        return LE(d, TOL_DD)
    raise ValueError("colonna senza regola di tolleranza: " + col)

def leggi_csv(base, sig, fase):
    p = os.path.join(base, "ROUND_R280" + sig, "%s_%s_%s_R280%s.csv" % (EA, SIM, fase, sig))
    if not os.path.isfile(p) or os.path.getsize(p) == 0:
        return None, "assente o vuoto: " + p
    rows = list(csv.DictReader(io.StringIO(open(p, encoding="ascii", errors="replace", newline="").read())))
    return rows, ""

def cancello_e(base):
    """G0 + G1 di R280e, da CSV grezzi, con Decimal. Ritorna (stato, [differenze G0], [differenze G1], testo, [residui entro tolleranza])."""
    dif, gem, res = [], [], []
    for fase in ("IS", "OOS"):
        rows, err = leggi_csv(base, "e", fase)
        if rows is None:
            return "NON VERIFICABILE", [], [], err, []
        if len(rows) != 2:
            return "NON VERIFICABILE", [], [], "%s: %d righe invece di 2" % (fase, len(rows)), []
        rows = sorted(rows, key=lambda r: D(r["InpMagic"]) or Decimal(0))
        if [r["InpMagic"].strip() for r in rows] != ["798711", "798721"]:
            return "NON VERIFICABILE", [], [], "%s: asse InpMagic %s invece di 798711/798721" % (fase, [r["InpMagic"] for r in rows]), []
        if USA_G0:
            att = G0_ATTESO[fase]
            for r in rows:
                for col in COL_GATE:
                    v = D(r[col]); e = Decimal(att[col])
                    if v is None:
                        dif.append("%s magic %s %s non numerico" % (fase, r["InpMagic"], col))      # come la riga: una colonna illeggibile e' una differenza, non una cella da saltare
                    elif not entro(col, v, e):
                        dif.append("%s magic %s %s scarto %s" % (fase, r["InpMagic"], col, abs(v - e)))
                    elif v != e:
                        res.append("%s magic %s %s scarto %s" % (fase, r["InpMagic"], col, abs(v - e)))
                for col in COL_INFO:
                    v = D(r[col]); e = Decimal(att[col])
                    if v is None:
                        dif.append("%s magic %s %s non numerico" % (fase, r["InpMagic"], col))
                    elif v != e:
                        res.append("%s magic %s %s scarto %s (colonna senza tolleranza congelata: si elenca, non blocca)" % (fase, r["InpMagic"], col, abs(v - e)))
        if USA_G1:
            rif = rows[0]
            for col in COL_GATE:
                v0 = D(rif[col]); v1 = D(rows[1][col])
                if v0 is None or v1 is None:
                    gem.append("%s gemelle %s non numerico" % (fase, col))
                elif not entro(col, v1, v0):
                    gem.append("%s gemelle %s scarto %s" % (fase, col, abs(v1 - v0)))
                elif v1 != v0:
                    res.append("%s gemelle %s scarto %s" % (fase, col, abs(v1 - v0)))
    stato = "PASS" if not dif and not gem else "FAIL"
    return stato, dif, gem, "", res

def celle(base):
    """{ema: {IS: {...}, OOS: {...}}} oppure (None, errore). Le righe vengono dall asse InpEmaSlow, UNA volta ciascun valore."""
    out = {}
    for fase in ("IS", "OOS"):
        rows, err = leggi_csv(base, "a", fase)
        if rows is None:
            return None, err
        if len(rows) != len(EMA):
            return None, "%s: %d righe invece di %d" % (fase, len(rows), len(EMA))
        ass = sorted((r["InpEmaSlow"].strip() for r in rows), key=lambda x: int(float(x)))
        if ass != EMA:
            return None, "%s: asse InpEmaSlow %s invece di %s" % (fase, ass, EMA)
        for r in rows:
            vals = {c: D(r[c]) for c in ("Trades", "Profit Factor", "Equity DD %", "Profit")}
            if any(v is None for v in vals.values()):
                return None, "%s EmaSlow %s: colonna non numerica" % (fase, r["InpEmaSlow"])
            c = out.setdefault(r["InpEmaSlow"].strip(), {})
            c[fase] = {"n": int(vals["Trades"]), "pf": vals["Profit Factor"], "dd": vals["Equity DD %"], "pr": vals["Profit"]}
    return out, ""

def ancora():
    return {f: {"n": int(G0_ATTESO[f]["Trades"]), "pf": Decimal(G0_ATTESO[f]["Profit Factor"]), "dd": Decimal(G0_ATTESO[f]["Equity DD %"]), "pr": Decimal(G0_ATTESO[f]["Profit"])} for f in ("IS", "OOS")}

def c_a(c):
    return c["IS"]["pf"] >= PF_MIN and c["OOS"]["pf"] >= PF_MIN

def c_b(c):
    return c["IS"]["n"] >= N_MIN and c["OOS"]["n"] >= N_MIN

def c_c(c):
    return c["IS"]["dd"] <= DD_MAX and c["OOS"]["dd"] <= DD_MAX

def guasta(c):
    """S4: Trades < 20 in UNA finestra: un guasto, non una cella."""
    return c["IS"]["n"] < N_GUASTO or c["OOS"]["n"] < N_GUASTO

def dentro_rumore(c, anc):
    """par. 6: in OGNI finestra |dPF| <= 0,15 e |dn| <= 8. Ritorna (bool, dettaglio)."""
    det = []
    ok = True
    for f in ("IS", "OOS"):
        dpf = abs(c[f]["pf"] - anc[f]["pf"]); dn = abs(c[f]["n"] - anc[f]["n"])
        if not (dpf <= RUM_PF and dn <= RUM_N):
            ok = False
        det.append("%s dPF %s dn %d" % (f, dpf, dn))
    return ok, " / ".join(det)

def dentro_rumore_par5(c, anc):
    """par. 5 (H_GRIGLIA): oltre 0,15 di PF in una finestra, o oltre 8 posizioni in IS."""
    return not (abs(c["IS"]["pf"] - anc["IS"]["pf"]) > RUM_PF or abs(c["OOS"]["pf"] - anc["OOS"]["pf"]) > RUM_PF or abs(c["IS"]["n"] - anc["IS"]["n"]) > RUM_N)

def piu_lunga_corsa(pass_):
    """pass_ = lista di bool nell ordine dell asse. Ritorna (inizio, lunghezza) della corsa contigua di True PIU LUNGA (a parita' vince la memoria piu bassa), o None."""
    best = None
    i = 0
    while i < len(pass_):
        if pass_[i]:
            j = i
            while j + 1 < len(pass_) and pass_[j + 1]:
                j += 1
            if best is None or (j - i + 1) > best[1]:
                best = (i, j - i + 1)
            i = j + 1
        else:
            i += 1
    return best

SUFFISSO = "   MERITO: NON ANCORA MISURATO (un regime, un broker, n IS < 150 sulle celle corte: l Emendamento C resta NON soddisfatto)."

def verdetto(cs, anc, gate_ok, s2):
    """cs = {ema: {IS, OOS}} (6 celle), anc = ancora, gate_ok = bool G0+G1, s2 = bool manopola muta. Ritorna (zona, parola, [righe])."""
    r = []
    if not gate_ok:
        return "V4", "NULLO", ["V4 NULLO: G0 o G1 non passano: il banco NON e' quello di R262b, R280a NON si legge."]
    if s2:
        return "V4", "NULLO", ["V4 NULLO: S2 MANOPOLA MUTA, le sei celle sono identiche in tutte e due le finestre (Trades, Profit, PF, DD): l asse non ha morso, e' 'misura nulla', NON 'memoria indifferente'."]
    guaste = [e for e in EMA if guasta(cs[e])]
    for e in guaste:
        r.append("S4 GUASTO: EmaSlow %s ha Trades < %d in una finestra: non e' una cella, e' un guasto; esce dai conti." % (e, N_GUASTO))
    ok = {e: not guasta(cs[e]) for e in EMA}
    # V3 (a): la 880 fuori dal rumore dall ancora
    if not ok[CENTRO_880]:
        return "ZG", "ZONA GRIGIA", r + ["ZONA GRIGIA: la cella 880 (la sola con la STESSA memoria in ore dell ancora, quella che separa griglia da memoria) e' un GUASTO S4: V1 e V3 non sono decidibili."]
    rum, det = dentro_rumore(cs[CENTRO_880], anc)
    rum5 = dentro_rumore_par5(cs[CENTRO_880], anc)
    r.append("Cella 880 contro l ancora H4/220 (rumore |dPF| <= 0,15 e |dn| <= 8 in OGNI finestra, par. 6): %s -> %s" % (det, "DENTRO" if rum else "FUORI"))
    if rum != rum5:
        return "ZG", "ZONA GRIGIA", r + ["ZONA GRIGIA: le due letture congelate del rumore divergono (par. 6 in ogni finestra: %s; par. 5 con n solo in IS: %s): non si sceglie a posteriori." % ("dentro" if rum else "fuori", "dentro" if rum5 else "fuori")]
    if not rum:
        return "V3", "EFFETTO", r + ["V3 GRIGLIA LEGATA: la 880, che ha la STESSA memoria in ore dell ancora, si scosta oltre il rumore: la griglia conta, CE-4 CONFERMATO."]
    # La seconda clausola congelata di V3 ("nessuna cella H1 passa C-a mentre l ancora passa") e' IMPLICATA dalla prima: una 880 dentro il rumore ha PF >= ancora - 0,15 >= 1,10
    # in tutte e due le finestre (1,2592 - 0,15 = 1,1092; 1,48133 - 0,15 = 1,33133), quindi passa C-a: il ramo non e' raggiungibile, e l autotest lo dimostra (caso "V3 seconda clausola").
    P = [ok[e] and c_a(cs[e]) and c_c(cs[e]) for e in EMA]
    b = [ok[e] and c_b(cs[e]) for e in EMA]
    nP = sum(1 for x in P if x)
    corsa = piu_lunga_corsa(P)
    if corsa and corsa[1] >= 3:
        i0, ln = corsa
        mid = i0 + (ln - 1) // 2          # se pari, vince la memoria piu bassa (regola di R245)
        cen = EMA[mid]
        celle_p = [EMA[k] for k in range(i0, i0 + ln)]
        sosp = [e for e in celle_p if not c_b(cs[e])]
        r.append("ALTOPIANO su H1: %d celle contigue passano C-a e C-c (%s); centro = cella %s (il picco NON si sceglie). Celle con C-b non passata (MERITO SOSPESO, indizio, non bocciatura): %s" % (ln, ", ".join(celle_p), cen, ", ".join(sosp) if sosp else "nessuna"))
        if not any(c_b(cs[e]) for e in celle_p):
            return "V2", "ZONA GRIGIA", r + ["V2 SOLO CAMPIONE: le celle passano C-a e C-c ma cadono TUTTE su C-b (n < 150 in una finestra): la 880 e' dentro il rumore dall ancora, ma il campione non decide."]
        return "V1", "ZONA GRIGIA", r + ["V1 FILTRO PORTABILE: altopiano su H1 E cella 880 entro il rumore dall ancora. E' un verdetto di PORTABILITA' del filtro su UN regime, NON un altopiano di MERITO (Emendamento C, regola del 19/08)."]
    if nP == 0:
        return "ZG", "ZONA GRIGIA", r + ["ZONA GRIGIA: nessuna cella passa insieme C-a e C-c (nessuna V congelata copre 'C-a passata in qualche cella ma C-c no'): NON C'E' UNA CONFIGURAZIONE ROBUSTA. Non si forza una zona."]
    return "ZG", "ZONA GRIGIA", r + ["ZONA GRIGIA: passano C-a e C-c solo %d celle e non formano un altopiano di almeno 3 contigue: NON C'E' UNA CONFIGURAZIONE ROBUSTA (par. 6)." % nP]

def s2_muta(cs):
    """par. 8 S2: le sei celle identiche in tutte e due le finestre. Identiche = Trades, Profit, PF e DD uguali alla cifra del CSV."""
    for f in ("IS", "OOS"):
        v = {(cs[e][f]["n"], cs[e][f]["pr"], cs[e][f]["pf"], cs[e][f]["dd"]) for e in EMA}
        if len(v) != 1:
            return False
    return True

def quasi_muta(cs, anc):
    """par. 7 (contro-esempio dichiarato): la 880 con Trades uguale all ancora al +-2 e PF uguale alla seconda cifra in tutte e due le finestre. Solo un'ANNOTAZIONE."""
    c = cs[CENTRO_880]
    q = Decimal("0.01")
    return all(abs(c[f]["n"] - anc[f]["n"]) <= MUTA_N and c[f]["pf"].quantize(q, rounding=ROUND_HALF_UP) == anc[f]["pf"].quantize(q, rounding=ROUND_HALF_UP) for f in ("IS", "OOS"))

def fuori_banda(v, lo, hi):
    return not (D(lo) <= v <= D(hi))

def tabella(cs, anc):
    righe = ["   R280a   [IS = 2024.09.26-2025.06.30, OOS = 2025.07.01-2026.06.30; rischio 1,0, deposito 10000, filtro EMA su H1; ancora H4/220: IS n %d PF %s DD %s, OOS n %d PF %s DD %s]" % (
        anc["IS"]["n"], anc["IS"]["pf"], anc["IS"]["dd"], anc["OOS"]["n"], anc["OOS"]["pf"], anc["OOS"]["dd"]),
        "   EmaSlow(H1)  ore   IS n   IS PF    IS DD    IS profit    OOS n  OOS PF   OOS DD   OOS profit   C-a  C-b      C-c   attesa (par. 5)"]
    for e in EMA:
        c = cs[e]
        i, o = c["IS"], c["OOS"]
        att = ATTESA[e]
        f = []
        f.append("n IS " + ("FUORI" if not (att[0][0] <= i["n"] <= att[0][1]) else "dentro"))
        f.append("n OOS " + ("FUORI" if not (att[1][0] <= o["n"] <= att[1][1]) else "dentro"))
        f.append("PF IS " + ("FUORI" if fuori_banda(i["pf"], *att[2]) else "dentro"))
        f.append("PF OOS " + ("FUORI" if fuori_banda(o["pf"], *att[3]) else "dentro"))
        f.append("DD IS " + ("FUORI" if fuori_banda(i["dd"], *att[4]) else "dentro"))
        f.append("DD OOS " + ("FUORI" if fuori_banda(o["dd"], *att[5]) else "dentro"))
        cb = "si" if c_b(c) else "SOSPESO"
        righe.append("   %-12s %5s %6d %8s %8s %12s %8d %8s %8s %12s   %-4s %-8s %-4s  %s" % (e, e, i["n"], i["pf"], i["dd"], i["pr"], o["n"], o["pf"], o["dd"], o["pr"],
                                                                                      "si" if c_a(c) else "NO", cb, "si" if c_c(c) else "NO", ", ".join(f)))
    return righe

def meglio_del_default(cs, anc):
    out = []
    for e in EMA:
        c = cs[e]
        if all(c[f]["pf"] - anc[f]["pf"] > MEGLIO_PF and c[f]["dd"] <= anc[f]["dd"] for f in ("IS", "OOS")):
            out.append(e)
    return out

def stati_dal_riepilogo(base):
    p = os.path.join(base, "RIEPILOGO_ROUND_R280.txt")
    if not os.path.isfile(p):
        return None, None
    t = open(p, encoding="ascii", errors="replace").read()
    m = re.search(r"^STATO: R280e=(\S+) R280a=(\S+)", t, re.M)
    d = re.search(r"^data: (\d{4}-\d\d-\d\d) ", t, re.M)
    return (None if not m else {"e": m.group(1), "a": m.group(2)}), (None if not d else d.group(1))

def leggi(base, oggi=None):
    righe = ["LETTURA DEL ROUND R280 -- %s" % base, "(cancello G0 + G1 rifatto qui da CSV grezzi, in modo indipendente dalla riga; criteri in prove/R280a_*.txt, prove/R280e_*.txt e prove/R280_CRITERI_LETTURA_2026-10-05.md)", ""]
    st, data = stati_dal_riepilogo(base)
    if st is None:
        righe.append("RIEPILOGO_ROUND_R280.txt assente o senza la riga STATO: NON SI LEGGE (la raccolta non e' quella della riga). Parola: NON ANCORA MISURATO.")
        return 2, righe
    righe.append("STATO dalla riga (catena): R280e=%s R280a=%s   (si leggono solo OK e OK_RIPROVATO)" % (st["e"], st["a"]))
    oggi = oggi or datetime.date.today().strftime("%Y-%m-%d")
    if data != oggi:
        righe.append("S0 FALLITA: la data del RIEPILOGO e %s e oggi e %s: il referto non e' di oggi, NON si legge (un file vecchio puo' certificare una corsa che non c'e' stata)." % (data, oggi))
        righe.append("PAROLA: NON ANCORA MISURATO.")
        return 0, righe
    righe.append("S0 ok: la data del RIEPILOGO (%s) e' di oggi." % data)
    ok = lambda s: s in ("OK", "OK_RIPROVATO")
    if not ok(st["e"]):
        stato, dif, gem, err, res = "NON VERIFICABILE", [], [], "R280e ha STATO %s: i suoi CSV non sono certificati dalla catena" % st["e"], []
    else:
        stato, dif, gem, err, res = cancello_e(base)
    righe.append("")
    righe.append("CANCELLO G0 + G1 di R280e: %s" % stato)
    if stato == "PASS":
        righe.append("   G0 PASS: l ancora H4/220 riprodotta dentro la tolleranza su tutte e due le gemelle (IS 1249.94 / PF 1.25920 / DD 7.1736 / 157 e OOS 2974.09 / PF 1.48133 / DD 6.6241 / 199): Trades ESATTI, Profit entro 0,05 EUR, PF entro 0,00005, DD entro 0,01. G1 PASS: le due gemelle uguali dentro la stessa tolleranza.")
        righe.append("   RESIDUI DENTRO LA TOLLERANZA (%d, si scrivono, nessun giudizio): %s" % (len(res), " ; ".join(res[:12]) + (" ; ..." if len(res) > 12 else "")) if res else "   RESIDUI DENTRO LA TOLLERANZA: nessuno (tutto alla cifra).")
    elif stato == "FAIL":
        righe.append("   G0: %s" % ("PASS" if not dif else "FAIL, %d differenze (colonne e SCARTI, non i valori): %s" % (len(dif), " ; ".join(dif[:8]))))
        righe.append("   G1: %s" % ("PASS" if not gem else "FAIL, %d differenze (colonne e SCARTI, non i valori): %s" % (len(gem), " ; ".join(gem[:8]))))
        righe.append("   -> V4 NULLO: il banco non e' quello di R262b. R280a NON SI LEGGE e i suoi numeri NON si stampano (restano nei CSV della raccolta per la diagnosi). Prima cosa da guardare: il deposito nel REFERTO del driver (deve dire 10000) e lo SHA256 dell EA.")
        righe.append("PAROLA: NULLO." + SUFFISSO)
    else:
        righe.append("   %s" % err)
        righe.append("   -> R280a NON SI LEGGE (il cancello non ha potuto dire PASS).")
        righe.append("PAROLA: NON ANCORA MISURATO." + SUFFISSO)
    righe.append("")
    if stato == "PASS":
        righe.append("R280a  (U30USD, filtro H1)  stato catena %s" % st["a"])
        if not ok(st["a"]):
            righe.append("   NON SI LEGGE: lo STATO della catena e %s" % st["a"])
            righe.append("PAROLA: NON ANCORA MISURATO." + SUFFISSO)
        else:
            cs, err = celle(base)
            if cs is None:
                righe.append("   R280a: NON LEGGIBILE (%s)" % err)
                righe.append("PAROLA: NON ANCORA MISURATO." + SUFFISSO)
            else:
                anc = ancora()
                righe += tabella(cs, anc)
                muta = s2_muta(cs)
                zona, parola, rr = verdetto(cs, anc, True, muta)
                righe += ["   " + x for x in rr]
                if zona == "V1" and quasi_muta(cs, anc):
                    righe.append("   ATTENZIONE (contro-esempio dichiarato, par. 7): la 880 ha Trades entro +-2 dall ancora e PF uguale alla seconda cifra in tutte e due le finestre: il filtro potrebbe dare lo STESSO bias nel 95% dei giorni (manopola quasi muta). Questo file non lo separa: serve la cella 'filtro spento' (file successivo).")
                mg = meglio_del_default(cs, anc)
                righe.append("   MEGLIO DEL DEFAULT (batte l ancora di piu' di 0,15 di PF in TUTTE E DUE le finestre senza DD peggiore): %s" % (", ".join(mg) if mg else "nessuna cella -> IL DEFAULT VA BENE (e' un risultato, non un fallimento)."))
                righe.append("")
                righe.append("ZONA %s   PAROLA: %s.%s" % (zona, parola, SUFFISSO))
        righe.append("")
        righe.append("NON FATTO QUI: la separazione dei lati (R245e/f: serve il gemello AllowShort=0/AllowLong=0 sulla cella che esce), le POSIZIONI da un per-trade (le 6 celle condividono il magic 798701: classe 41), la lettura per stagione (OROLOGIO), il merito.")
    righe.append("NESSUNA CELLA SI PROMUOVE, NESSUNA TAGLIA SI PROPONE.")
    return 0, righe

# ---------------------------------------------------------------- autotest: il banco col contro-esempio
def _real_rows(fase):
    p = os.path.join(REPO, "backtest_pipeline", "risultati_archivio", "ROUND_CORTI_B_2026-09-27", "ROUND_R262b", "%s_%s_%s_R262b.csv" % (EA, SIM, fase))
    rows = list(csv.reader(open(p, encoding="ascii", newline="")))
    h = rows[0]
    ie = h.index("InpEmaSlow")
    r220 = [r for r in rows[1:] if r[ie] == "220"][0]
    return h, r220

def _scrivi(base, sig, fase, rows, hdr):
    d = os.path.join(base, "ROUND_R280" + sig)
    os.makedirs(d, exist_ok=True)
    with open(os.path.join(d, "%s_%s_%s_R280%s.csv" % (EA, SIM, fase, sig)), "w", newline="", encoding="ascii") as f:
        w = csv.writer(f, lineterminator="\r\n")
        w.writerow(hdr)
        w.writerows(rows)

def _fixture(base, stati=("OK", "OK"), e_patch=None, a=None, data=None):
    """e: la RIGA VERA di R262b con EmaSlow=220 (CSV scritti da MT5 il 27/09), duplicata come due gemelle col magic portato a 798711/798721.
    a: {ema: {IS:(n,pf,dd,profit), OOS:(..)}} (sintetico). e_patch {(fase,riga,col): val}."""
    for fase in ("IS", "OOS"):
        h, r0 = _real_rows(fase)
        im = h.index("InpMagic")
        out = []
        for n in range(2):
            r = list(r0)
            r[im] = str(798711 + 10 * n)
            out.append(r)
        for (f_, riga, col), val in (e_patch or {}).items():
            if f_ == fase:
                out[riga][h.index(col)] = val
        _scrivi(base, "e", fase, out, h)
    hdr = ["Pass", "Profit", "Expected Payoff", "Profit Factor", "Recovery Factor", "Sharpe Ratio", "Equity DD %", "Trades", "InpEmaSlow", "InpMagic"]
    dati = a if a is not None else CELLE_BASE
    for fase in ("IS", "OOS"):
        rows = []
        for k, e in enumerate(EMA):
            n, pf, dd, pr = dati[e][fase]
            rows.append([k, pr, "1", pf, "1", "1", dd, n, e, "798701"])
        _scrivi(base, "a", fase, rows, hdr)
    with open(os.path.join(base, "RIEPILOGO_ROUND_R280.txt"), "w", encoding="ascii", newline="") as f:
        f.write("data: %s 10:00:00\r\nSTATO: R280e=%s R280a=%s\r\n" % (data or datetime.date.today().strftime("%Y-%m-%d"), stati[0], stati[1]))

def _cel(**kw):
    """nome cella 'e220' -> ((n,pf,dd,pr) IS, (n,pf,dd,pr) OOS), tutto stringa."""
    return {k[1:]: v for k, v in kw.items()}

# una base SINTETICA e SANA (nessuna e' una previsione): l altopiano su tutte e sei, la 880 vicina all ancora.
CELLE_BASE = {
    "220": {"IS": (142, "1.30", "7.0", "1100.00"), "OOS": (190, "1.33", "6.0", "2500.00")},
    "440": {"IS": (148, "1.31", "7.1", "1200.00"), "OOS": (197, "1.35", "6.2", "2700.00")},
    "660": {"IS": (152, "1.28", "7.2", "1250.00"), "OOS": (198, "1.38", "6.5", "2800.00")},
    "880": {"IS": (157, "1.26", "7.2", "1250.00"), "OOS": (199, "1.48", "6.6", "2974.00")},
    "1100": {"IS": (157, "1.24", "7.4", "1190.00"), "OOS": (200, "1.45", "6.4", "2900.00")},
    "1320": {"IS": (156, "1.22", "7.6", "1100.00"), "OOS": (199, "1.42", "6.3", "2850.00")},
}

def _con(**mod):
    """CELLE_BASE con modifiche: _con(e880_IS=(n,pf,dd,pr))."""
    d = {e: {f: tuple(v) for f, v in x.items()} for e, x in CELLE_BASE.items()}
    for k, v in mod.items():
        e, f = k[1:].split("_")
        d[e][f] = v
    return d

def _p(fase, riga, **cols):
    return {(fase, riga, c.replace("__", " ")): v for c, v in cols.items()}

def _unisci(*ds):
    o = {}
    for d in ds:
        o.update(d)
    return o

def _casi_cancello():
    """(nome, e_patch, atteso). atteso: 'PASS' | 'G0' (fallisce solo G0) | 'G1' (solo G1) | 'G0+G1'. riga 0 = magic 798711, riga 1 = 798721.
    Noto OOS: Profit 2974.09, PF 1.48133, DD 6.6241, Trades 199, RF 4.42850. Noto IS: Profit 1249.94, PF 1.25920, DD 7.1736, Trades 157, RF 1.70352.
    I LIMITI sono DERIVATI a mano dalla tolleranza congelata (Trades esatti, Profit 0,05, PF 0,00005, DD 0,01), non letti dal codice."""
    O = lambda **c: _p("OOS", 1, **c)
    I = lambda **c: _p("IS", 1, **c)
    return [
        ("CSV VERI di R262b (riga 220), due gemelle identiche: PASS", {}, "PASS"),
        ("IL PRECEDENTE R246: UN centesimo su una gemella (Profit 2974.10): PASS", O(Profit="2974.10"), "PASS"),
        ("Profit +0,05 su una gemella (bordo): PASS", O(Profit="2974.14"), "PASS"),
        ("Profit +0,06 su una gemella: G0 e G1", O(Profit="2974.15"), "G0+G1"),
        ("Profit -0,05 su una gemella (bordo): PASS", O(Profit="2974.04"), "PASS"),
        ("Profit -0,06 su una gemella: G0 e G1", O(Profit="2974.03"), "G0+G1"),
        ("Profit +0,03 e -0,02 sulle due gemelle: G0 ok (0,03 e 0,02), G1 al bordo (0,05): PASS", _unisci(_p("OOS", 0, Profit="2974.12"), _p("OOS", 1, Profit="2974.07")), "PASS"),
        ("Profit +0,03 e -0,03 sulle due gemelle: G0 ok, G1 no (0,06 fra loro)", _unisci(_p("OOS", 0, Profit="2974.12"), _p("OOS", 1, Profit="2974.06")), "G1"),
        ("Profit +0,06 su entrambe: solo G0 (gemelle uguali)", _unisci(_p("OOS", 0, Profit="2974.15"), _p("OOS", 1, Profit="2974.15")), "G0"),
        ("gamba IS: Profit +0,05 (bordo): PASS", I(Profit="1249.99"), "PASS"),
        ("gamba IS: Profit +0,06: G0 e G1", I(Profit="1250.00"), "G0+G1"),
        ("Trades 198 su una gemella: G0 e G1", O(Trades="198"), "G0+G1"),
        ("Trades 198 su entrambe: solo G0", _unisci(_p("OOS", 0, Trades="198"), _p("OOS", 1, Trades="198")), "G0"),
        ("Trades 200 su entrambe: solo G0", _unisci(_p("OOS", 0, Trades="200"), _p("OOS", 1, Trades="200")), "G0"),
        ("gamba IS: Trades 158 su una gemella: G0 e G1", I(Trades="158"), "G0+G1"),
        ("Equity DD % +0,0100 su una gemella (bordo): PASS", O(**{"Equity__DD__%": "6.6341"}), "PASS"),
        ("Equity DD % +0,0101 su una gemella: G0 e G1", O(**{"Equity__DD__%": "6.6342"}), "G0+G1"),
        ("Equity DD % -0,0100 su una gemella (bordo): PASS", O(**{"Equity__DD__%": "6.6141"}), "PASS"),
        ("Equity DD % -0,0101 su una gemella: G0 e G1", O(**{"Equity__DD__%": "6.6140"}), "G0+G1"),
        ("Equity DD % 6.6342 su entrambe: solo G0", _unisci(_p("OOS", 0, **{"Equity__DD__%": "6.6342"}), _p("OOS", 1, **{"Equity__DD__%": "6.6342"})), "G0"),
        ("PF +0,00005 su una gemella (bordo): PASS", O(**{"Profit__Factor": "1.48138"}), "PASS"),
        ("PF +0,00006 su una gemella: G0 e G1", O(**{"Profit__Factor": "1.48139"}), "G0+G1"),
        ("PF -0,00005 su una gemella (bordo): PASS", O(**{"Profit__Factor": "1.48128"}), "PASS"),
        ("PF -0,00006 su una gemella: G0 e G1", O(**{"Profit__Factor": "1.48127"}), "G0+G1"),
        ("PF 1.48139 su entrambe: solo G0", _unisci(_p("OOS", 0, **{"Profit__Factor": "1.48139"}), _p("OOS", 1, **{"Profit__Factor": "1.48139"})), "G0"),
        ("gamba IS: PF +0,00005 (bordo): PASS", I(**{"Profit__Factor": "1.25925"}), "PASS"),
        ("gamba IS: PF +0,00006: G0 e G1", I(**{"Profit__Factor": "1.25926"}), "G0+G1"),
        ("Recovery Factor +0,01 su una gemella: PASS (colonna senza tolleranza congelata, derivata dal Profit e dal DD: si elenca, non blocca)", O(**{"Recovery__Factor": "4.43850"}), "PASS"),
        ("Profit non numerico su una gemella: G0 e G1 (una colonna illeggibile e' una differenza)", O(Profit="abc"), "G0+G1"),
        ("Profit nan su una gemella: G0 e G1 (un nan non e' un numero finito)", O(Profit="nan"), "G0+G1"),
        ("Recovery Factor non numerico su una gemella: solo G0 (G1 non guarda il RF)", O(**{"Recovery__Factor": "abc"}), "G0"),
        ("banco con deposito sbagliato (100000 invece di 10000), gemelle uguali: solo G0", _unisci(
            _p("OOS", 0, Profit="29740.90", Trades="199"), _p("OOS", 1, Profit="29740.90", Trades="199"), _p("IS", 0, Profit="12499.40", Trades="157"), _p("IS", 1, Profit="12499.40", Trades="157")), "G0"),
        ("EA o dati diversi: IS Trades 150 e OOS 190 su entrambe le gemelle, uguali fra loro: solo G0", _unisci(
            _p("OOS", 0, Trades="190"), _p("OOS", 1, Trades="190"), _p("IS", 0, Trades="150"), _p("IS", 1, Trades="150")), "G0"),
    ]

def _corri(**kw):
    d = tempfile.mkdtemp()
    try:
        _fixture(d, **{k: v for k, v in kw.items() if k in ("stati", "e_patch", "a", "data")})
        rc, righe = leggi(d)
        return rc, "\n".join(righe)
    finally:
        shutil.rmtree(d, ignore_errors=True)

def _esito(t):
    if "CANCELLO G0 + G1 di R280e: PASS" in t:
        return ("PASS",)
    if "CANCELLO G0 + G1 di R280e: FAIL" in t:
        return ("FAIL", "   G0: PASS" in t, "   G1: PASS" in t)
    return ("ALTRO",)

def suite_cancello():
    """Esegue i casi al bordo; ritorna [(nome, ok, dettaglio)]. Usata anche dai mutanti."""
    out = []
    for nome, patch, att in _casi_cancello():
        rc, t = _corri(e_patch=patch)
        e = _esito(t)
        if att == "PASS":
            ok = e == ("PASS",) and "R280a  (U30USD, filtro H1)" in t and "EmaSlow(H1)" in t
        else:
            want_g0 = att in ("G1",)
            want_g1 = att in ("G0",)
            ok = e == ("FAIL", want_g0, want_g1) and "EmaSlow(H1)" not in t and "NON SI LEGGE" in t and "PAROLA: NULLO" in t
        out.append((nome, ok, "atteso %s, letto %s | %s" % (att, e, t[:600].replace("\n", " / "))))
    rc, t = _corri(e_patch=_p("OOS", 1, Profit="2974.10"))
    ok = "RESIDUI DENTRO LA TOLLERANZA (2," in t and "OOS magic 798721 Profit scarto 0.01" in t and "OOS gemelle Profit scarto 0.01" in t
    out.append(("il residuo di un centesimo (G0 e G1) si ELENCA con lo scarto", ok, t[:900].replace("\n", " / ")))
    rc, t = _corri()
    out.append(("senza residui la lettura dice 'nessuno'", "RESIDUI DENTRO LA TOLLERANZA: nessuno" in t, t[:600].replace("\n", " / ")))
    out.append(("entro(): Trades +1, DD +0,0101, Profit 0,06 e PF 0,00006 sono FUORI",
                not entro("Trades", Decimal("200"), Decimal("199")) and not entro("Equity DD %", Decimal("6.6342"), Decimal("6.6241")) and not entro("Profit", Decimal("0.06"), Decimal("0"))
                and not entro("Profit Factor", Decimal("1.00006"), Decimal("1")), ""))
    out.append(("entro(): i bordi Profit 0,05, DD 0,01 e PF 0,00005 sono DENTRO",
                entro("Profit", Decimal("0.05"), Decimal("0")) and entro("Equity DD %", Decimal("0.01"), Decimal("0")) and entro("Profit Factor", Decimal("1.00005"), Decimal("1")), ""))
    return out

def mutanti():
    """Ogni mutante cambia UNA regola della tolleranza (o spegne un cancello) e deve far fallire almeno un caso di suite_cancello()."""
    G = globals()
    lista = [
        ("Profit esatto (tolleranza 0)", {"TOL_PROFIT": Decimal("0")}), ("Profit tolleranza 0,04", {"TOL_PROFIT": Decimal("0.04")}), ("Profit tolleranza 0,06", {"TOL_PROFIT": Decimal("0.06")}),
        ("Profit tolleranza 1,00", {"TOL_PROFIT": Decimal("1.00")}),
        ("PF tolleranza 0,00004", {"TOL_PF": Decimal("0.00004")}), ("PF tolleranza 0,00006", {"TOL_PF": Decimal("0.00006")}), ("PF tolleranza 0,0002", {"TOL_PF": Decimal("0.0002")}),
        ("DD tolleranza 0,0099", {"TOL_DD": Decimal("0.0099")}), ("DD tolleranza 0,0101", {"TOL_DD": Decimal("0.0101")}), ("DD esatto", {"TOL_DD": Decimal("0")}),
        ("Trades con tolleranza 1", {"TOL_TRADES": Decimal("1")}),
        ("bordo FUORI (< invece di <=)", {"LE": operator.lt}),
        ("G0 spento", {"USA_G0": False}), ("G1 spento", {"USA_G1": False}),
    ] + [("colonna %s ignorata" % c, {"IGNORA": {c}}) for c in COL_GATE]
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

def _frasi_ok(t, frase):
    """frase = una stringa che DEVE esserci, o una lista di stringhe; con '!' davanti: DEVE ESSERE ASSENTE."""
    for x in ([frase] if isinstance(frase, str) else frase):
        if x.startswith("!"):
            if x[1:] in t:
                return False
        elif x not in t:
            return False
    return True

def _zona(t):
    m = re.search(r"^ZONA (\S+)   PAROLA: ([A-Z ]+)\.", t, re.M)
    return (m.group(1), m.group(2).strip()) if m else (None, None)

def _verdetti():
    """(nome, celle, attesa_zona, attesa_parola, frase_che_deve_esserci). Le attese sono scritte A MANO dai criteri congelati, non dal codice.
    L'ancora e': IS n 157 PF 1.2592 DD 7.1736 / OOS n 199 PF 1.48133 DD 6.6241. Rumore: |dPF| <= 0,15 e |dn| <= 8 in OGNI finestra."""
    return [
        ("base sana: altopiano su 6 celle, la 880 uguale all ancora, C-b passata dal 660 in su: V1 ZONA GRIGIA", CELLE_BASE, "V1", "ZONA GRIGIA", "centro = cella 660"),
        ("altopiano di 4 (pari): 440-1100 (la 220 e la 1320 hanno DD IS 10,01): il centro e' la memoria piu' BASSA delle due di mezzo (660, non 880)", _con(e220_IS=(142, "1.30", "10.01", "1100.00"), e1320_IS=(156, "1.22", "10.01", "1100.00")), "V1", "ZONA GRIGIA", "centro = cella 660"),
        ("880 con PF IS 1.4099 (dPF 0,1507 oltre 0,15): V3 EFFETTO", _con(e880_IS=(157, "1.4099", "7.2", "1250.00")), "V3", "EFFETTO", "GRIGLIA LEGATA"),
        ("880 con PF IS 1.4092 (dPF 0,1500 al bordo, dentro): non V3", _con(e880_IS=(157, "1.4092", "7.2", "1250.00")), "V1", "ZONA GRIGIA", "FILTRO PORTABILE"),
        ("880 con n IS 166 (dn 9 oltre 8): V3 EFFETTO", _con(e880_IS=(166, "1.26", "7.2", "1250.00")), "V3", "EFFETTO", "GRIGLIA LEGATA"),
        ("880 con n IS 165 (dn 8 al bordo, dentro): non V3", _con(e880_IS=(165, "1.26", "7.2", "1250.00")), "V1", "ZONA GRIGIA", "FILTRO PORTABILE"),
        ("880 con n OOS 208 (dn 9 in OOS: par. 6 fuori, par. 5 dentro): le due letture divergono, ZONA GRIGIA e non si sceglie", _con(e880_OOS=(208, "1.48", "6.6", "2974.00")), "ZG", "ZONA GRIGIA", "le due letture congelate del rumore divergono"),
        ("880 con PF OOS 1.6314 (dPF 0,1501 in OOS): V3 EFFETTO", _con(e880_OOS=(199, "1.6314", "6.6", "2974.00")), "V3", "EFFETTO", "GRIGLIA LEGATA"),
        ("PF IS 1.0999 su tutte (un passo sotto il bordo C-a): nessuna passa C-a; la 880 e' a dPF 0,1593 dall ancora: V3 per la PRIMA clausola", _con(e220_IS=(142, "1.0999", "7.0", "1.00"), e440_IS=(148, "1.0999", "7.0", "1.00"), e660_IS=(152, "1.0999", "7.0", "1.00"),
                                                                                                    e880_IS=(157, "1.0999", "7.2", "1.00"), e1100_IS=(157, "1.0999", "7.0", "1.00"), e1320_IS=(156, "1.0999", "7.0", "1.00")), "V3", "EFFETTO", "GRIGLIA LEGATA"),
        ("PF IS 1.10 sulla 220 e sulla 440 (bordo C-a, dentro) con le altre sopra: tutte e sei passano, V1", _con(e220_IS=(142, "1.10", "7.0", "1.00"), e440_IS=(148, "1.10", "7.0", "1.00")), "V1", "ZONA GRIGIA", ["FILTRO PORTABILE", "ALTOPIANO su H1: 6 celle"]),
        ("PF IS 1.0999 sulla 220 e sulla 440 (un passo sotto C-a): escono dall altopiano, restano 660-1320 (4 celle)", _con(e220_IS=(142, "1.0999", "7.0", "1.00"), e440_IS=(148, "1.0999", "7.0", "1.00")), "V1", "ZONA GRIGIA", ["FILTRO PORTABILE", "ALTOPIANO su H1: 4 celle"]),
        ("solo la 880 e la 1100 passano C-a e C-c (le altre DD IS 10,01): 2 celle, nessun altopiano: ZONA GRIGIA", _con(e220_IS=(142, "1.30", "10.01", "1.00"), e440_IS=(148, "1.31", "10.01", "1.00"), e660_IS=(152, "1.28", "10.01", "1.00"),
                                                                                                         e1320_IS=(156, "1.22", "10.01", "1.00")), "ZG", "ZONA GRIGIA", "NON C'E' UNA CONFIGURAZIONE ROBUSTA"),
        ("DD IS 10,00 (bordo C-c, dentro) sulla 220: la corsa resta di 6", _con(e220_IS=(142, "1.30", "10.00", "1.00")), "V1", "ZONA GRIGIA", "ALTOPIANO su H1: 6 celle"),
        ("passano 220-440 e 1100-1320 ma non 660 e 880: corse da 2 e 2, nessun altopiano (880 fuori da C-c)", _con(e660_IS=(152, "1.28", "10.01", "1.00"), e880_IS=(157, "1.26", "10.01", "1.00")), "ZG", "ZONA GRIGIA", "NON C'E' UNA CONFIGURAZIONE ROBUSTA"),
        ("corse di 3 e di 2 contigue separate da una cella che non passa: vince la piu' lunga (220-660, centro 440)", _con(e880_IS=(157, "1.26", "10.01", "1.00")), "V1", "ZONA GRIGIA", "centro = cella 440"),
        ("tutte e sei con n IS < 150 (V2 SOLO CAMPIONE)", _con(e220_IS=(140, "1.30", "7.0", "1100.00"), e440_IS=(145, "1.31", "7.1", "1200.00"), e660_IS=(148, "1.28", "7.2", "1250.00"), e880_IS=(149, "1.26", "7.2", "1250.00"),
                                                              e1100_IS=(149, "1.24", "7.4", "1190.00"), e1320_IS=(148, "1.22", "7.6", "1100.00")), "V2", "ZONA GRIGIA", "V2 SOLO CAMPIONE"),
        ("n IS 150 al bordo C-b (dentro) sulla 880: c e' una cella con C-b, quindi NON e' V2 ma V1", _con(e220_IS=(140, "1.30", "7.0", "1100.00"), e440_IS=(145, "1.31", "7.1", "1200.00"), e660_IS=(148, "1.28", "7.2", "1250.00"), e880_IS=(150, "1.26", "7.2", "1250.00"),
                                                                                  e1100_IS=(149, "1.24", "7.4", "1190.00"), e1320_IS=(148, "1.22", "7.6", "1100.00")), "V1", "ZONA GRIGIA", "FILTRO PORTABILE"),
        ("S4: Trades 19 in IS sulla 220 (guasto), le altre cinque passano: altopiano 440-1320, la 220 esce dai conti", _con(e220_IS=(19, "1.30", "7.0", "1.00")), "V1", "ZONA GRIGIA", "S4 GUASTO: EmaSlow 220"),
        ("S4: Trades 20 sulla 220 (bordo, NON e' un guasto)", _con(e220_IS=(20, "1.30", "7.0", "1.00")), "V1", "ZONA GRIGIA", ["FILTRO PORTABILE", "!S4 GUASTO"]),
        ("S4 sulla 880: la cella che separa griglia da memoria e' un guasto: ZONA GRIGIA", _con(e880_OOS=(10, "1.48", "6.6", "1.00")), "ZG", "ZONA GRIGIA", "e' un GUASTO S4"),
        ("S2 MANOPOLA MUTA: sei celle identiche in IS e OOS: V4 NULLO, non 'memoria indifferente'", {e: {"IS": (157, "1.2592", "7.1736", "1249.94"), "OOS": (199, "1.48133", "6.6241", "2974.09")} for e in EMA}, "V4", "NULLO", "S2 MANOPOLA MUTA"),
        ("S2 quasi: sei celle uguali tranne un Trades (IS 158 sulla 1320): NON e' muta", _con(e220_IS=(157, "1.2592", "7.1736", "1249.94"), e440_IS=(157, "1.2592", "7.1736", "1249.94"), e660_IS=(157, "1.2592", "7.1736", "1249.94"),
                                                                                       e880_IS=(157, "1.2592", "7.1736", "1249.94"), e1100_IS=(157, "1.2592", "7.1736", "1249.94"), e1320_IS=(158, "1.2592", "7.1736", "1249.94"),
                                                                                       e220_OOS=(199, "1.48133", "6.6241", "2974.09"), e440_OOS=(199, "1.48133", "6.6241", "2974.09"), e660_OOS=(199, "1.48133", "6.6241", "2974.09"),
                                                                                       e880_OOS=(199, "1.48133", "6.6241", "2974.09"), e1100_OOS=(199, "1.48133", "6.6241", "2974.09"), e1320_OOS=(199, "1.48133", "6.6241", "2974.09")), "V1", "ZONA GRIGIA", "FILTRO PORTABILE"),
        ("la 880 uguale all ancora (n e PF alla seconda cifra): V1 con l ATTENZIONE della manopola quasi muta", _con(e880_IS=(157, "1.26", "7.2", "1250.00"), e880_OOS=(199, "1.48", "6.6", "2974.00")), "V1", "ZONA GRIGIA", ["FILTRO PORTABILE", "manopola quasi muta"]),
        ("MEGLIO DEL DEFAULT: la 1100 batte l ancora di 0,155 in tutte e due le finestre con DD <= ancora", _con(e1100_IS=(157, "1.4142", "7.1", "1250.00"), e1100_OOS=(199, "1.6363", "6.5", "2974.00")),
         "V1", "ZONA GRIGIA", "MEGLIO DEL DEFAULT (batte l ancora di piu' di 0,15 di PF in TUTTE E DUE le finestre senza DD peggiore): 1100"),
        ("MEGLIO DEL DEFAULT al bordo: +0,15 esatti in IS NON basta (serve oltre)", _con(e1100_IS=(157, "1.4092", "7.1", "1250.00"), e1100_OOS=(199, "1.6363", "6.5", "2974.00")), "V1", "ZONA GRIGIA", "nessuna cella -> IL DEFAULT VA BENE"),
        ("MEGLIO DEL DEFAULT: PF a posto ma DD peggiore dell ancora in OOS (6,63 contro 6,6241): non basta", _con(e1100_IS=(157, "1.4142", "7.1", "1250.00"), e1100_OOS=(199, "1.6363", "6.63", "2974.00")), "V1", "ZONA GRIGIA", "nessuna cella -> IL DEFAULT VA BENE"),
        ("manopola quasi muta: la 880 a dn 2 in IS (159) e PF uguale alla seconda cifra: l ATTENZIONE c'e'", _con(e880_IS=(159, "1.26", "7.2", "1250.00"), e880_OOS=(199, "1.48", "6.6", "2974.00")), "V1", "ZONA GRIGIA", "manopola quasi muta"),
        ("manopola quasi muta: la 880 a dn 3 in IS (160): NON c'e' l ATTENZIONE", _con(e880_IS=(160, "1.26", "7.2", "1250.00"), e880_OOS=(199, "1.48", "6.6", "2974.00")), "V1", "ZONA GRIGIA", "!manopola quasi muta"),
        ("manopola quasi muta: PF IS 1.2549 (seconda cifra 1,25 contro 1,26 dell ancora): NON c'e' l ATTENZIONE", _con(e880_IS=(157, "1.2549", "7.2", "1250.00"), e880_OOS=(199, "1.48", "6.6", "2974.00")), "V1", "ZONA GRIGIA", "!manopola quasi muta"),
    ]

def autotest():
    ok = tot = 0
    def caso(nome, cond, dettaglio=""):
        nonlocal ok, tot
        tot += 1
        ok += 1 if cond else 0
        print(("PASS  " if cond else "FALLITO ") + nome + ("" if cond else "   " + dettaglio))
    for nome, cond, det in suite_cancello():
        caso(nome, cond, det)
    for nome, preso, det in mutanti():
        caso("MUTANTE preso: " + nome, preso, det)
    # 2c. la seconda clausola di V3 e' implicata dalla prima (ramo tolto dal codice): lo dimostrano i numeri dell ancora e la soglia di C-a
    anc_ = ancora()
    caso("V3 seconda clausola: una 880 dentro il rumore passa SEMPRE C-a (ancora - 0,15 >= 1,10 in IS e in OOS), il ramo non e' raggiungibile",
         anc_["IS"]["pf"] - RUM_PF >= PF_MIN and anc_["OOS"]["pf"] - RUM_PF >= PF_MIN)
    # 3. stati della catena e S0
    rc, t = _corri(stati=("NV", "OK"))
    caso("e NV: cancello NON VERIFICABILE, a non si legge, parola NON ANCORA MISURATO", "NON VERIFICABILE" in t and "EmaSlow(H1)" not in t and "PAROLA: NON ANCORA MISURATO" in t, t)
    rc, t = _corri(stati=("OK_RIPROVATO", "OK"))
    caso("e OK_RIPROVATO: il cancello gira", "CANCELLO G0 + G1 di R280e: PASS" in t, t)
    rc, t = _corri(stati=("OK", "NV"))
    caso("a NV con il cancello PASS: a non si legge, parola NON ANCORA MISURATO", "NON SI LEGGE: lo STATO della catena e NV" in t and "EmaSlow(H1)" not in t and "PAROLA: NON ANCORA MISURATO" in t, t)
    rc, t = _corri(data="2026-01-01")
    caso("S0: la data del RIEPILOGO non e' di oggi -> NON ANCORA MISURATO, niente cancello, niente numeri", "S0 FALLITA" in t and "EmaSlow(H1)" not in t and "CANCELLO G0 + G1" not in t and "PAROLA: NON ANCORA MISURATO" in t, t)
    # 4. le zone
    for nome, celle_, zona, parola, frase in _verdetti():
        rc, t = _corri(a=celle_)
        z, p = _zona(t)
        caso("verdetto: " + nome, (z, p) == (zona, parola) and _frasi_ok(t, frase) and "MERITO: NON ANCORA MISURATO" in t, "letto zona %s parola %s, frasi %s" % (z, p, frase))
    # 5. col cancello rosso nessuno dei sei valori di a compare
    rc, t = _corri(e_patch=_p("OOS", 0, Trades="190"))
    caso("cancello rosso: nessun numero di R280a (neppure 1100.00 o 2974.00) e nessuna tabella nella lettura", "1100.00" not in t and "2974.00" not in t and "EmaSlow(H1)" not in t and "PAROLA: NULLO" in t, t)
    # 6. asse sbagliato / riga mancante: non leggibile, non un numero inventato
    d = tempfile.mkdtemp()
    try:
        _fixture(d)
        p = os.path.join(d, "ROUND_R280a", "%s_%s_OOS_R280a.csv" % (EA, SIM))
        s = open(p).read().replace(",1320,", ",1321,")
        open(p, "w").write(s)
        rc, righe = leggi(d)
        t = "\n".join(righe)
        caso("asse InpEmaSlow sbagliato in a: NON LEGGIBILE, parola NON ANCORA MISURATO", "R280a: NON LEGGIBILE" in t and "PAROLA: NON ANCORA MISURATO" in t, t)
    finally:
        shutil.rmtree(d, ignore_errors=True)
    d = tempfile.mkdtemp()
    try:
        rc, righe = leggi(d)
        caso("raccolta senza RIEPILOGO: rc 2, non si legge", rc == 2 and "NON SI LEGGE" in "\n".join(righe))
    finally:
        shutil.rmtree(d, ignore_errors=True)
    # 7. MUTANTI delle soglie del verdetto: ogni soglia spostata di un passo deve far fallire almeno un caso di _verdetti
    G = globals()
    def corri_verdetti():
        falliti = 0
        for nome, celle_, zona, parola, frase in _verdetti():
            rc, t = _corri(a=celle_)
            z, p = _zona(t)
            if (z, p) != (zona, parola) or not _frasi_ok(t, frase):
                falliti += 1
        return falliti
    for nome, mod in (("PF_MIN 1,11", {"PF_MIN": Decimal("1.11")}), ("PF_MIN 1,09", {"PF_MIN": Decimal("1.09")}), ("N_MIN 151", {"N_MIN": 151}), ("N_MIN 149", {"N_MIN": 149}),
                      ("DD_MAX 9,99", {"DD_MAX": Decimal("9.99")}), ("DD_MAX 10,01", {"DD_MAX": Decimal("10.01")}), ("RUM_PF 0,14", {"RUM_PF": Decimal("0.14")}), ("RUM_PF 0,16", {"RUM_PF": Decimal("0.16")}),
                      ("RUM_N 7", {"RUM_N": 7}), ("RUM_N 9", {"RUM_N": 9}), ("N_GUASTO 19", {"N_GUASTO": 19}), ("N_GUASTO 21", {"N_GUASTO": 21}),
                      ("MEGLIO_PF 0,14", {"MEGLIO_PF": Decimal("0.14")}), ("MEGLIO_PF 0,16", {"MEGLIO_PF": Decimal("0.16")}), ("MUTA_N 1", {"MUTA_N": 1}), ("MUTA_N 3", {"MUTA_N": 3})):
        orig = {k: G[k] for k in mod}
        try:
            G.update(mod)
            f = corri_verdetti()
        finally:
            G.update(orig)
        caso("MUTANTE preso (soglia del verdetto): " + nome, f > 0, "nessun verdetto e' diventato rosso: la soglia non e' collaudata")
    print("AUTOTEST: %d/%d" % (ok, tot))
    return 0 if ok == tot else 1

def main():
    a = sys.argv[1:]
    if "--autotest" in a:
        sys.exit(autotest())
    if not a or a[0].startswith("--"):
        print(__doc__)
        sys.exit(2)
    oggi = a[a.index("--oggi") + 1] if "--oggi" in a else None
    rc, righe = leggi(a[0], oggi)
    txt = "\n".join(righe)
    print(txt)
    if "--md" in a:
        open(a[a.index("--md") + 1], "w", encoding="ascii", errors="replace").write("```\n" + txt + "\n```\n")
    sys.exit(rc)

if __name__ == "__main__":
    main()
