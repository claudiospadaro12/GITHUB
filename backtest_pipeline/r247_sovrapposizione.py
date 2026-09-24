#!/usr/bin/env python3
# =====================================================================
#  r247_sovrapposizione.py -- R247: la cella centrale di R245b contro
#  la sedia viva 770202, giorno per giorno. SOLA LETTURA.
# ---------------------------------------------------------------------
#  DUE DOMANDE, criteri congelati PRIMA dei numeri in
#  backtest_pipeline/prove/R247a_pertrade_centro_R245b_IS_U30USD.txt
#  (par. 6 e 7). Questo script li ESEGUE, non li sceglie.
#
#  (a) SOVRAPPOSIZIONE con la sedia viva (per-trade 772505 = cella di
#      770202 a rischio 1%, R47c, gamba OOS 2025.06.10 -> 2026.06.30):
#      giorni in cui entrano tutte e due, stesso verso o opposto,
#      correlazione dei P/L giornalieri, DD e peggior giornata della
#      SOMMA contro quelli delle due sedie da sole.
#  (b) DD GIORNO PER GIORNO della cella nuova: P/L% di ogni giornata sul
#      saldo di inizio giornata, peggior giornata, DD massimo del saldo
#      chiuso, e la conversione LINEARE a un'altra taglia, marcata
#      [DERIVATO lineare, classe 547]. La taglia e' di Claudio: qui c'e'
#      solo il numero.
#
#  PRIMA DI TUTTO IL CANCELLO G0 (--g0): il per-trade deve essere QUELLO
#  della cella. Si confronta con la riga del CSV di ottimizzazione che
#  ha lo stesso InpMagic, e quella riga con i numeri d'ancora (R245b,
#  cella InpEmaSlow=200). Se G0 non e' VERDE lo script NON calcola (a) e
#  (b) (a meno di --forza, e allora ogni numero esce marcato NON VALIDO).
#
#  CONVENZIONI (dichiarate, non assunte in silenzio)
#   - UNITA' DEL GIORNO: la data di CHIUSURA del deal, ora server BCM.
#     Le due sedie sono intraday (chiusura forzata 17:30 server) e
#     l'ingresso cade lo stesso giorno: si CONTROLLA che ogni chiusura
#     stia dentro --sessione (default 14:30-17:31). Le chiusure fuori
#     finestra si contano e si stampano: se sono > 0 "giorno d'ingresso
#     = giorno di chiusura" diventa [INFERITO] e va detto.
#   - VERSO: dal deal_type del deal di USCITA. 1 = SELL = chiude un
#     LUNGO; 0 = BUY = chiude un CORTO.
#   - n: posizioni = position_id distinti; deal = righe. La colonna
#     Trades del CSV di ottimizzazione conta i DEAL (classe 454, misurato
#     su 772505: 130 deal, 96 posizioni, Trades 130).
#   - PF sui deal di uscita: somma netti positivi / |somma netti negativi|
#     (come MT5: su 772505 esce 1,27013 = il CSV al quinto decimale).
#   - OGNI FILE E' UNA TRANCHE: il saldo riparte dal suo deposito (il
#     driver gira ogni finestra da capo, col deposito della riga).
#   - P/L% del giorno = netto del giorno / saldo a inizio giornata.
#     (a) somma i P/L% delle due sedie: e' la lettura "due sedie a 1%
#     ciascuna sullo stesso conto", ADDITIVA (senza capitalizzazione),
#     ed e' marcata [DERIVATO]. I pesi --peso-viva/--peso-nuovo scalano
#     linearmente; default 1,0 e 1,0. NON sono una proposta di taglia.
#   - DD del per-trade = DD del SALDO CHIUSO. E' un MINORANTE dell'Equity
#     DD % del tester (che vede il flottante): con una posizione alla
#     volta ogni valore di saldo e' anche un valore di equity, quindi
#     DD_chiuso <= DD_equity. G0 lo usa come controllo di coerenza.
#
#  USO
#    python3 r247_sovrapposizione.py --autotest
#    python3 r247_sovrapposizione.py \
#       --nuovo abtg_trades_ABTG_Nasdaq_Apertura_US_U30USD_765271.csv@10000 \
#       --nuovo abtg_trades_ABTG_Nasdaq_Apertura_US_U30USD_765273.csv@10000 \
#       --viva  risultati_prove/aperture_r47/abtg_trades_ABTG_Dow_Apertura_US_U30USD_772505.csv@100000 \
#       --g0 <pertrade_765271> <CSV_IS_R247a>  154 1.25176 1180.94 \
#       --g0 <pertrade_765273> <CSV_OOS_R247b> 197 1.48894 2961.61 \
#       --gemello <pertrade_765271> <pertrade_765272> \
#       --gemello <pertrade_765273> <pertrade_765274> \
#       --giorni-csv r247_giorni.csv
#
#  Esce 0 se ha calcolato, 1 se un cancello (G0/G1) e' ROSSO, 2 se gli
#  argomenti non bastano.
# =====================================================================
import argparse
import csv
import math
import os
import sys
import random
import tempfile
from collections import OrderedDict, defaultdict
from datetime import datetime

FMT = "%Y.%m.%d %H:%M:%S"
MEZZO_CENT = 0.005

# ---------------------------------------------------------------------
#  SOGLIE (a) -- COPIA di R247a par. 6. Se cambiano li', si cambiano qui
#  NELLO STESSO COMMIT (e mai dopo aver visto i numeri).
# ---------------------------------------------------------------------
S_RADD_RHO_U = 0.50     # rho sui giorni in cui almeno una entra
S_RADD_QUOTA = 0.50     # quota dei giorni della viva in cui entra anche la nuova
S_RADD_RHO_C = 0.70     # rho sui soli giorni in comune
S_DIV_RHO_U = 0.20
S_DIV_RHO_C = 0.50
S_COP_RHO_U = -0.50
# rapp_DD, rapp_PG e P(coperd) NON hanno piu' una soglia fissa: si
# confrontano col NULLO PER PERMUTAZIONE (stessi giorni, P/L% della nuova
# rimescolati fra i SUOI giorni della finestra comune = stessa esposizione,
# P/L indipendenti). Contro-esempio che l'ha imposto (strato 2, 24/09):
# con perdite limitate a ~1R due sedie INDIPENDENTI sugli stessi giorni
# danno rapp_PG 1,77-1,84 (la copia 2,00): la soglia fissa 1,50 rendeva
# DIVERSIFICAZIONE irraggiungibile (0/400) e l'allarme 1,80 scattava sul
# nullo nell'84-88% dei casi. Il numero assoluto si STAMPA lo stesso.
N_PERM = 2000
SEME_PERM = 247
Q_NULLO = 0.95


# =====================================================================
#  LETTURA
# =====================================================================
def dividi_spec(spec, dep_def):
    """'percorso@deposito' -> (percorso, deposito). Senza @ -> default."""
    if "@" in spec:
        p, d = spec.rsplit("@", 1)
        return p, float(d)
    return spec, float(dep_def)


def leggi_pertrade(percorso):
    """-> lista di dict ordinata per close_time (ordine di file a parita').
    Formato di ExportTrades(): ';', intestazione
    close_time;symbol;magic;position_id;deal_type;volume;price;net_profit"""
    righe = []
    with open(percorso, newline="", encoding="utf-8-sig", errors="replace") as f:
        rd = csv.DictReader(f, delimiter=";")
        attese = {"close_time", "magic", "position_id", "deal_type", "net_profit"}
        if rd.fieldnames is None or not attese.issubset(set(rd.fieldnames)):
            raise ValueError("%s: intestazione non e' quella di ExportTrades(): %r"
                             % (percorso, rd.fieldnames))
        for i, r in enumerate(rd):
            t = datetime.strptime(r["close_time"].strip(), FMT)
            righe.append({
                "t": t, "ord": i,
                "magic": r["magic"].strip(),
                "pid": r["position_id"].strip(),
                "tipo": r["deal_type"].strip(),
                "net": float(r["net_profit"]),
                "riga": r,
            })
    righe.sort(key=lambda x: (x["t"], x["ord"]))
    return righe


def leggi_csv_ottimizzazione(percorso):
    with open(percorso, newline="", encoding="utf-8-sig", errors="replace") as f:
        return list(csv.DictReader(f, delimiter=","))


# =====================================================================
#  STATISTICHE DI UNA TRANCHE
# =====================================================================
def pf_deal(righe):
    gp = sum(r["net"] for r in righe if r["net"] > 0)
    gl = -sum(r["net"] for r in righe if r["net"] < 0)
    nw = sum(1 for r in righe if r["net"] > 0)
    nl = sum(1 for r in righe if r["net"] < 0)
    pf = gp / gl if gl > 0 else float("inf")
    return pf, gp, gl, nw, nl


def tranche(righe, deposito):
    """Saldo chiuso deal per deal e giorno per giorno, da 'deposito'."""
    saldo, picco, dd_deal = deposito, deposito, 0.0
    giorni = OrderedDict()
    for r in righe:
        g = r["t"].strftime("%Y.%m.%d")
        if g not in giorni:
            giorni[g] = {"inizio": saldo, "net": 0.0, "versi": set(), "pids": set()}
        giorni[g]["net"] += r["net"]
        giorni[g]["versi"].add("L" if r["tipo"] == "1" else ("S" if r["tipo"] == "0" else "?"))
        giorni[g]["pids"].add(r["pid"])
        saldo += r["net"]
        picco = max(picco, saldo)
        dd_deal = max(dd_deal, 100.0 * (picco - saldo) / picco)
    # giorno per giorno: saldo di fine giornata
    s_picco = deposito
    for g, v in giorni.items():
        v["fine"] = v["inizio"] + v["net"]
        v["pct"] = 100.0 * v["net"] / v["inizio"]
        s_picco = max(s_picco, v["fine"])
        v["picco"] = s_picco
        v["dd"] = 100.0 * (s_picco - v["fine"]) / s_picco
    return {"giorni": giorni, "dd_deal": dd_deal, "saldo": saldo, "deposito": deposito}


def fuori_sessione(righe, sessione):
    a, b = sessione.split("-")
    ha, ma = (int(x) for x in a.split(":"))
    hb, mb = (int(x) for x in b.split(":"))
    lo, hi = ha * 60 + ma, hb * 60 + mb
    return [r for r in righe if not (lo <= r["t"].hour * 60 + r["t"].minute < hi)]


# =====================================================================
#  G0 e G1
# =====================================================================
def riga_per_magic(righe_csv, magic):
    trov = [r for r in righe_csv if str(r.get("InpMagic", "")).strip() == magic]
    return trov


def g0(percorso_pt, percorso_csv, n_att, pf_att, profit_att, deposito):
    """-> (verde: bool, testo). Tre strati:
    (i)  la riga del CSV col magic del per-trade riproduce l'ANCORA;
    (ii) il per-trade e' coerente con la riga (n, somma, PF nell'intervallo
         d'arrotondamento dei netti al centesimo);
    (iii) i due limiti di geometria: DD saldo chiuso <= Equity DD %, e
         peggior giornata chiusa >= Peggior Giornata % (quella dell'EA e'
         sull'equity, quindi piu' profonda o uguale)."""
    out, ok = [], True
    try:
        pt = leggi_pertrade(percorso_pt)
    except (OSError, ValueError) as e:
        return False, ["  G0 ROSSO: per-trade illeggibile: %s" % e]
    magici = sorted(set(r["magic"] for r in pt))
    if len(pt) == 0:
        return False, ["  G0 ROSSO: per-trade VUOTO (solo intestazione): la gamba che l'ha "
                       "scritto per ultima non e' quella della cella."]
    if len(magici) != 1:
        return False, ["  G0 ROSSO: il per-trade ha %d magic diversi: %s" % (len(magici), magici)]
    magic = magici[0]
    rc = riga_per_magic(leggi_csv_ottimizzazione(percorso_csv), magic)
    if len(rc) != 1:
        return False, ["  G0 ROSSO: nel CSV %s le righe con InpMagic=%s sono %d (attesa 1)"
                       % (os.path.basename(percorso_csv), magic, len(rc))]
    r = rc[0]
    tr, pf_r = int(float(r["Trades"])), float(r["Profit Factor"])
    pr, ddr = float(r["Profit"]), float(r["Equity DD %"])
    pg = float(r.get("Peggior Giornata %", "nan"))
    out.append("  magic %s  riga CSV: Trades %d  PF %.5f  Profit %.2f  DD %.4f  PeggiorGiornata %.4f"
               % (magic, tr, pf_r, pr, ddr, pg))
    # (i) ancora
    c1 = (tr == n_att and abs(pf_r - pf_att) <= 0.000005 and abs(pr - profit_att) <= MEZZO_CENT)
    out.append("   (i)   ancora n %d PF %.5f Profit %.2f -> %s"
               % (n_att, pf_att, profit_att, "OK" if c1 else "DIVERSA"))
    ok &= c1
    # (ii) coerenza per-trade / riga
    pf_p, gp, gl, nw, nl = pf_deal(pt)
    somma = gp - gl
    pos = len(set(x["pid"] for x in pt))
    lo = (gp - MEZZO_CENT * nw) / (gl + MEZZO_CENT * nl) - 0.000005
    hi = (gp + MEZZO_CENT * nw) / max(gl - MEZZO_CENT * nl, 1e-9) + 0.000005
    c2a = len(pt) == tr
    c2b = abs(somma - pr) <= MEZZO_CENT * len(pt) + MEZZO_CENT
    c2c = lo <= pf_r <= hi
    out.append("   (ii)  per-trade: %d deal, %d posizioni, somma %.2f, PF %.5f "
               "(intervallo d'arrotondamento %.5f-%.5f)" % (len(pt), pos, somma, pf_p, lo, hi))
    out.append("         deal == Trades: %s | somma entro +-%.2f: %s | PF riga nell'intervallo: %s"
               % ("OK" if c2a else "NO", MEZZO_CENT * len(pt) + MEZZO_CENT,
                  "OK" if c2b else "NO", "OK" if c2c else "NO"))
    ok &= c2a and c2b and c2c
    # (iii) geometria
    tt = tranche(pt, deposito)
    peg = min(v["pct"] for v in tt["giorni"].values())
    c3a = tt["dd_deal"] <= ddr + MEZZO_CENT
    c3b = (math.isnan(pg) or peg >= pg - MEZZO_CENT)
    out.append("   (iii) DD saldo chiuso %.4f <= Equity DD %.4f: %s | peggior giornata chiusa "
               "%.4f >= %.4f: %s" % (tt["dd_deal"], ddr, "OK" if c3a else "NO", peg, pg,
                                     "OK" if c3b else "NO"))
    ok &= c3a and c3b
    out.append("  G0 %s  (%s)" % ("VERDE" if ok else "ROSSO", os.path.basename(percorso_pt)))
    return ok, out


def g1(pa, pb):
    """Gemelle sul magic: identiche riga per riga TRANNE la colonna magic."""
    a, b = leggi_pertrade(pa), leggi_pertrade(pb)
    if len(a) != len(b):
        return False, "  G1 ROSSO: %d contro %d righe" % (len(a), len(b))
    if len(a) == 0:
        return False, "  G1 ROSSO: per-trade vuoti (due vuoti non sono due gemelle)"
    for x, y in zip(a, b):
        kx = {k: v for k, v in x["riga"].items() if k != "magic"}
        ky = {k: v for k, v in y["riga"].items() if k != "magic"}
        if kx != ky:
            return False, "  G1 ROSSO: prima differenza a %s" % x["riga"]["close_time"]
    if a[0]["magic"] == b[0]["magic"]:
        return False, "  G1 ROSSO: stesso magic nei due file: non sono due passate"
    return True, "  G1 VERDE: %d righe identiche tranne il magic (%s / %s)" % (
        len(a), a[0]["magic"], b[0]["magic"])


# =====================================================================
#  (a) e (b)
# =====================================================================
def pearson(xs, ys):
    n = len(xs)
    if n < 3:
        return float("nan")
    mx, my = sum(xs) / n, sum(ys) / n
    sxx = sum((x - mx) ** 2 for x in xs)
    syy = sum((y - my) ** 2 for y in ys)
    if sxx == 0 or syy == 0:
        return float("nan")
    return sum((x - mx) * (y - my) for x, y in zip(xs, ys)) / math.sqrt(sxx * syy)


def dd_additivo(serie):
    """serie: lista di P/L% giornalieri -> max DD in punti % (additivo)."""
    c, p, m = 0.0, 0.0, 0.0
    for v in serie:
        c += v
        p = max(p, c)
        m = max(m, p - c)
    return m


def unisci(tranches):
    """Piu' tranche dello stesso lato -> un dict giorno -> record.
    Un giorno presente in DUE tranche dello stesso lato e' un errore."""
    g = {}
    for t in tranches:
        for k, v in t["giorni"].items():
            if k in g:
                raise ValueError("il giorno %s compare in due tranche dello stesso lato" % k)
            g[k] = v
    return g


def verdetto_a(m):
    if any(math.isnan(m[k]) for k in ("rho_u", "rho_c")):
        return "NON LEGGIBILE (rho non calcolabile: meno di 3 giorni o varianza nulla)"
    if m["rho_u"] <= S_COP_RHO_U:
        return "COPERTURA (si annullano: pedaggio doppio per niente)"
    if m["rho_u"] >= S_RADD_RHO_U:
        return "RADDOPPIO DEL RISCHIO (rho_U >= %.2f)" % S_RADD_RHO_U
    if m["quota_viva"] >= S_RADD_QUOTA and m["rho_c"] >= S_RADD_RHO_C:
        return ("RADDOPPIO DEL RISCHIO sui giorni della viva (quota %.2f >= %.2f e rho_C >= %.2f)"
                % (m["quota_viva"], S_RADD_QUOTA, S_RADD_RHO_C))
    if (m["rho_u"] <= S_DIV_RHO_U and m["rho_c"] < S_DIV_RHO_C
            and m["rapp_dd"] <= m["q_rapp_dd"] and m["rapp_pg"] <= m["q_rapp_pg"]
            and not (m["p_coperd"] > m["q_p_coperd"])):
        return "DIVERSIFICAZIONE"
    return "PARZIALE (ne' raddoppio ne' diversificazione: si legge con la taglia)"


def misura_a(gv, gn, comune, peso_v, peso_n, n_perm=N_PERM):
    m = _misura_base(gv, gn, comune, peso_v, peso_n)
    # NULLO: stessi giorni della nuova (quindi stessa quota e stessi C),
    # i suoi record giornalieri rimescolati fra quei giorni.
    d0, d1 = comune
    chiavi = sorted(k for k in gn if d0 <= k <= d1)
    recs = [gn[k] for k in chiavi]
    rng = random.Random(SEME_PERM)
    nul = {"rapp_dd": [], "rapp_pg": [], "p_coperd": []}
    for _ in range(n_perm):
        rng.shuffle(recs)
        mp = _misura_base(gv, dict(zip(chiavi, recs)), comune, peso_v, peso_n)
        for k in nul:
            if not math.isnan(mp[k]):
                nul[k].append(mp[k])
    for k, v in nul.items():
        v.sort()
        m["q_" + k] = v[min(len(v) - 1, int(Q_NULLO * len(v)))] if v else float("nan")
    m["verdetto"] = verdetto_a(m)
    m["coda"] = (m["rapp_pg"] > m["q_rapp_pg"]) or (m["p_coperd"] > m["q_p_coperd"])
    return m


def _misura_base(gv, gn, comune, peso_v, peso_n):
    d0, d1 = comune
    dv = {k: v for k, v in gv.items() if d0 <= k <= d1}
    dn = {k: v for k, v in gn.items() if d0 <= k <= d1}
    U = sorted(set(dv) | set(dn))
    C = sorted(set(dv) & set(dn))
    xv = [peso_v * dv[k]["pct"] if k in dv else 0.0 for k in U]
    xn = [peso_n * dn[k]["pct"] if k in dn else 0.0 for k in U]
    xs = [a + b for a, b in zip(xv, xn)]
    stesso = sum(1 for k in C if dv[k]["versi"] == dn[k]["versi"] and len(dv[k]["versi"]) == 1)
    opposto = sum(1 for k in C if len(dv[k]["versi"]) == 1 and len(dn[k]["versi"]) == 1
                  and dv[k]["versi"] != dn[k]["versi"])
    perde_v = [k for k in dv if dv[k]["net"] < 0]
    coperd = sum(1 for k in perde_v if k in dn and dn[k]["net"] < 0)
    peg_v, peg_n, peg_s = min(xv) if xv else 0.0, min(xn) if xn else 0.0, min(xs) if xs else 0.0
    ddv, ddn, dds = dd_additivo(xv), dd_additivo(xn), dd_additivo(xs)
    m = {
        "U": len(U), "C": len(C), "nv": len(dv), "nn": len(dn),
        "quota_viva": len(C) / len(dv) if dv else float("nan"),
        "quota_nuova": len(C) / len(dn) if dn else float("nan"),
        "stesso": stesso, "opposto": opposto, "misti": len(C) - stesso - opposto,
        "rho_u": pearson(xv, xn),
        "rho_c": pearson([peso_v * dv[k]["pct"] for k in C], [peso_n * dn[k]["pct"] for k in C]),
        "perde_v": len(perde_v), "coperd": coperd,
        "p_coperd": coperd / len(perde_v) if perde_v else float("nan"),
        "ddv": ddv, "ddn": ddn, "dds": dds,
        "rapp_dd": dds / (ddv + ddn) if (ddv + ddn) > 0 else float("nan"),
        "peg_v": peg_v, "peg_n": peg_n, "peg_s": peg_s,
        "rapp_pg": abs(peg_s) / max(abs(peg_v), abs(peg_n)) if max(abs(peg_v), abs(peg_n)) > 0
        else float("nan"),
        "giorni_U": U, "xv": xv, "xn": xn, "xs": xs,
    }
    return m


def stampa_a(m, comune, peso_v, peso_n, invalido):
    tag = "  [NON VALIDO: G0 non verde]" if invalido else ""
    print("\n=== (a) SOVRAPPOSIZIONE CON LA SEDIA VIVA%s ===" % tag)
    print("  finestra comune: %s -> %s  |  pesi viva %.2f nuova %.2f  (pesi = scala lineare, "
          "NON una taglia)" % (comune[0], comune[1], peso_v, peso_n))
    print("  giorni con ingresso: viva %d | nuova %d | almeno una (U) %d | TUTTE E DUE (C) %d"
          % (m["nv"], m["nn"], m["U"], m["C"]))
    print("  quota dei giorni della viva in cui entra anche la nuova: %.3f | della nuova: %.3f"
          % (m["quota_viva"], m["quota_nuova"]))
    print("  sui %d giorni in comune: STESSO verso %d | OPPOSTO %d | misti %d"
          % (m["C"], m["stesso"], m["opposto"], m["misti"]))
    print("  rho_U (P/L%% giornaliero, giorni U, 0 dove una non entra) = %.3f" % m["rho_u"])
    print("  rho_C (solo giorni in comune)                          = %.3f" % m["rho_c"])
    print("  giorni in perdita della viva %d, in cui perde anche la nuova %d  -> P = %.3f"
          "  (nullo q%.0f %.3f)" % (m["perde_v"], m["coperd"], m["p_coperd"], 100 * Q_NULLO, m["q_p_coperd"]))
    print("  DD additivo %%: viva %.3f | nuova %.3f | SOMMA %.3f  -> DD(somma)/(DDv+DDn) = %.3f"
          "  (nullo q%.0f %.3f)  [DERIVATO: stesso conto, additivo]"
          % (m["ddv"], m["ddn"], m["dds"], m["rapp_dd"], 100 * Q_NULLO, m["q_rapp_dd"]))
    print("  peggior giornata %%: viva %.3f | nuova %.3f | SOMMA %.3f  -> rapporto %.3f  (nullo q%.0f %.3f)"
          % (m["peg_v"], m["peg_n"], m["peg_s"], m["rapp_pg"], 100 * Q_NULLO, m["q_rapp_pg"]))
    print("  (nullo = %d permutazioni, seme %d: stessi giorni, P/L%% della nuova rimescolati fra i suoi giorni)"
          % (N_PERM, SEME_PERM))
    print("  VERDETTO (a): %s%s" % (m["verdetto"], tag))
    print("  ALLARME DI CODA (rapp_PG o P(perde|viva perde) SOPRA il q%.0f del nullo): %s"
          % (100 * Q_NULLO, "SCATTA" if m["coda"] else "non scatta"))


def stampa_b(nome, tt, rischio_base, rischi, invalido):
    tag = "  [NON VALIDO: G0 non verde]" if invalido else ""
    g = tt["giorni"]
    pct = [v["pct"] for v in g.values()]
    peggiori = sorted(g.items(), key=lambda kv: kv[1]["pct"])[:5]
    dd_g = max(v["dd"] for v in g.values()) if g else 0.0
    # durata massima sotto il picco (giorni di borsa con operazione)
    dur, cur = 0, 0
    for v in g.values():
        cur = cur + 1 if v["dd"] > 0 else 0
        dur = max(dur, cur)
    print("\n=== (b) DD GIORNO PER GIORNO -- %s%s ===" % (nome, tag))
    print("  deposito %.2f -> saldo finale %.2f | giorni con operazione %d | in perdita %d"
          % (tt["deposito"], tt["saldo"], len(g), sum(1 for x in pct if x < 0)))
    print("  DD MASSIMO del saldo chiuso: %.4f%% per deal | %.4f%% a fine giornata  (minorante "
          "dell'Equity DD del tester)" % (tt["dd_deal"], dd_g))
    print("  PEGGIOR GIORNATA chiusa: %.4f%%  | giornate <= -1,00%%: %d | serie piu' lunga sotto "
          "il picco: %d giornate con operazione" % (min(pct), sum(1 for x in pct if x <= -1.0), dur))
    print("  le 5 peggiori: " + "; ".join("%s %.3f%%" % (k, v["pct"]) for k, v in peggiori))
    for r in rischi:
        f = r / rischio_base
        print("  a rischio %.2f%% [DERIVATO lineare, classe 547, x%.2f]: DD ~%.2f%% | peggior giornata ~%.2f%%"
              % (r, f, f * tt["dd_deal"], f * min(pct)))


# =====================================================================
#  MAIN
# =====================================================================
def esegui(args):
    rosso = False
    for spec in args.g0 or []:
        pt, cs, n, pf, pr = spec
        # Il deposito della tranche NON si indovina: o e' scritto nel
        # --g0 (PERCORSO@DEPOSITO), o il file compare in --nuovo/--viva.
        # Un default silenzioso qui fa uscire un DD del 38% su una tranche
        # da 100.000 letta come se fosse da 10.000 (trovato collaudando
        # 772505 contro il CSV IS di r47c, 24/09).
        dep = None
        if "@" in pt:
            pt, dep = dividi_spec(pt, None)
        if dep is None:
            dep = dict(dividi_spec(s, args.deposito_nuovo) for s in (args.nuovo or [])).get(pt)
        if dep is None:
            dep = dict(dividi_spec(s, args.deposito_viva) for s in (args.viva or [])).get(pt)
        if dep is None:
            print("\n=== G0 %s ===\n  G0 NON ESEGUIBILE: deposito della tranche non dichiarato. "
                  "Scrivilo come PERTRADE@DEPOSITO, o passa lo stesso file in --nuovo/--viva."
                  % os.path.basename(pt))
            return 2
        ok, testo = g0(pt, cs, int(n), float(pf), float(pr), dep)
        print("\n=== G0 %s ===" % os.path.basename(pt))
        print("\n".join(testo))
        rosso |= not ok
    for a, b in args.gemello or []:
        ok, testo = g1(a, b)
        print("\n=== G1 ===")
        print(testo)
        rosso |= not ok
    if not args.nuovo:
        return 1 if rosso else 0
    invalido = rosso
    if rosso and not args.forza:
        print("\n>>> UN CANCELLO E' ROSSO: (a) e (b) NON si calcolano. Il per-trade non e' "
              "quello della cella (o le gemelle divergono). --forza per vederli marcati NON VALIDO.")
        return 1

    tn, sess_fuori = [], 0
    for s in args.nuovo:
        p, d = dividi_spec(s, args.deposito_nuovo)
        rr = leggi_pertrade(p)
        fs = fuori_sessione(rr, args.sessione)
        sess_fuori += len(fs)
        t = tranche(rr, d)
        t["nome"] = os.path.basename(p)
        tn.append(t)
    for t in tn:
        stampa_b(t["nome"], t, args.rischio_base, args.rischio_conv, invalido)
    if len(tn) > 1:
        g_all = unisci(tn)
        xs = [v["pct"] for k, v in sorted(g_all.items())]
        print("\n  TUTTE LE TRANCHE (additivo, [DERIVATO]): peggior giornata %.4f%% | DD additivo %.4f%%"
              % (min(xs), dd_additivo(xs)))

    if args.viva:
        tv = []
        for s in args.viva:
            p, d = dividi_spec(s, args.deposito_viva)
            rr = leggi_pertrade(p)
            sess_fuori += len(fuori_sessione(rr, args.sessione))
            t = tranche(rr, d)
            t["nome"] = os.path.basename(p)
            tv.append(t)
        gv, gn = unisci(tv), unisci(tn)
        if args.comune:
            comune = tuple(args.comune)
        else:
            comune = (max(min(gv), min(gn)), min(max(gv), max(gn)))
        fuori_v = sum(1 for k in gv if not (comune[0] <= k <= comune[1]))
        fuori_n = sum(1 for k in gn if not (comune[0] <= k <= comune[1]))
        m = misura_a(gv, gn, comune, args.peso_viva, args.peso_nuovo)
        stampa_a(m, comune, args.peso_viva, args.peso_nuovo, invalido)
        print("  giorni FUORI dalla finestra comune (esclusi da (a)): viva %d | nuova %d"
              % (fuori_v, fuori_n))
        if args.giorni_csv:
            with open(args.giorni_csv, "w", newline="") as f:
                w = csv.writer(f, delimiter=";")
                w.writerow(["giorno", "pct_viva", "pct_nuova", "pct_somma"])
                for k, a, b, c in zip(m["giorni_U"], m["xv"], m["xn"], m["xs"]):
                    w.writerow([k, "%.4f" % a, "%.4f" % b, "%.4f" % c])
            print("  serie giornaliera scritta in %s" % args.giorni_csv)
    print("\n  chiusure FUORI dalla sessione %s: %d  %s" % (
        args.sessione, sess_fuori,
        "(giorno d'ingresso = giorno di chiusura: VERIFICATO sulle chiusure)" if sess_fuori == 0
        else "-> 'giorno d'ingresso = giorno di chiusura' e' [INFERITO] per queste righe"))
    return 1 if invalido else 0


# =====================================================================
#  AUTOTEST -- i contro-esempi, su dati costruiti qui
# =====================================================================
def _scrivi_pt(percorso, deals, magic):
    """deals: lista di (giorno 'YYYY.MM.DD', ora 'HH:MM:SS', pid, tipo, net)"""
    with open(percorso, "w", newline="") as f:
        w = csv.writer(f, delimiter=";")
        w.writerow(["close_time", "symbol", "magic", "position_id", "deal_type",
                    "volume", "price", "net_profit"])
        for g, h, pid, tipo, net in deals:
            w.writerow(["%s %s" % (g, h), "U30USD", magic, pid, tipo, "1.00", "40000.00",
                        "%.2f" % net])


def _scrivi_csv(percorso, righe):
    campi = ["Pass", "Profit", "Expected Payoff", "Profit Factor", "Recovery Factor",
             "Sharpe Ratio", "Equity DD %", "Trades", "Peggior Giornata %",
             "Perdite Consecutive Max", "Serie Perdente Peggiore", "InpMagic"]
    with open(percorso, "w", newline="") as f:
        w = csv.DictWriter(f, fieldnames=campi)
        w.writeheader()
        for r in righe:
            w.writerow({k: r.get(k, 0) for k in campi})


def _giorni(n, da=(2025, 7, 1)):
    from datetime import date, timedelta
    d, out = date(*da), []
    while len(out) < n:
        if d.weekday() < 5:
            out.append(d.strftime("%Y.%m.%d"))
        d += timedelta(1)
    return out


def autotest():
    import random
    rng = random.Random(247)
    tmp = tempfile.mkdtemp(prefix="r247_")
    esiti = []

    def chk(nome, cond, dett=""):
        esiti.append((nome, bool(cond)))
        print("  [%s] %s %s" % ("PASS" if cond else "FAIL", nome, dett))

    # --- T1: conto a mano della tranche (saldo, P/L%, DD) ------------------
    p1 = os.path.join(tmp, "t1.csv")
    _scrivi_pt(p1, [("2025.07.01", "15:00:00", "1", "1", 100.0),
                    ("2025.07.02", "16:00:00", "2", "1", -220.0),
                    ("2025.07.03", "16:00:00", "3", "0", 50.0)], "1")
    t = tranche(leggi_pertrade(p1), 1000.0)
    g = list(t["giorni"].values())
    chk("T1 P/L% giorno 2 = -220/1100 = -20,000%", abs(g[1]["pct"] + 20.0) < 1e-9,
        "(%.6f)" % g[1]["pct"])
    chk("T1 DD saldo chiuso = 220/1100 = 20,000%", abs(t["dd_deal"] - 20.0) < 1e-9,
        "(%.6f)" % t["dd_deal"])
    chk("T1 verso: deal_type 0 in uscita = CORTO", g[2]["versi"] == {"S"})

    # --- serie finte per (a) ----------------------------------------------
    G = _giorni(250)
    base = [(d, rng.gauss(0.05, 1.0)) for d in G if rng.random() < 0.40]   # la "viva"

    def a_deals(serie, dep=10000.0, specchio=False):
        out, s = [], dep
        for i, (d, pct) in enumerate(serie):
            net = round(s * pct / 100.0 * (-1 if specchio else 1), 2)
            tipo = "1"
            if specchio:
                tipo = "0"
            out.append((d, "16:00:00", str(i + 1), tipo, net))
            s += net
        return out

    pv = os.path.join(tmp, "viva.csv")
    _scrivi_pt(pv, a_deals(base), "900001")
    gv = tranche(leggi_pertrade(pv), 10000.0)["giorni"]
    comune = (G[0], G[-1])

    # T2: la stessa serie con un altro magic = LO STESSO RISCHIO
    pc = os.path.join(tmp, "copia.csv")
    _scrivi_pt(pc, a_deals(base), "900002")
    m = misura_a(gv, tranche(leggi_pertrade(pc), 10000.0)["giorni"], comune, 1.0, 1.0)
    chk("T2 copia: rho_U = 1", abs(m["rho_u"] - 1) < 1e-9, "(%.4f)" % m["rho_u"])
    chk("T2 copia: C = tutti i giorni, stesso verso 100%", m["C"] == len(base) and m["stesso"] == m["C"])
    chk("T2 copia: DD(somma)/(DDv+DDn) = 1 e peggior giornata x2",
        abs(m["rapp_dd"] - 1) < 1e-6 and abs(m["rapp_pg"] - 2) < 1e-6,
        "(%.4f, %.4f)" % (m["rapp_dd"], m["rapp_pg"]))
    chk("T2 copia: verdetto RADDOPPIO", m["verdetto"].startswith("RADDOPPIO"), m["verdetto"])
    chk("T2 copia: allarme di coda scatta", m["coda"])

    # T3: indipendenti (altri giorni scelti a caso, P/L indipendenti)
    ind = [(d, rng.gauss(0.05, 1.0)) for d in G if rng.random() < 0.80]
    pi = os.path.join(tmp, "ind.csv")
    _scrivi_pt(pi, a_deals(ind), "900003")
    m = misura_a(gv, tranche(leggi_pertrade(pi), 10000.0)["giorni"], comune, 1.0, 1.0)
    chk("T3 indipendenti: |rho_U| < 0,20", abs(m["rho_u"]) < 0.20, "(%.4f)" % m["rho_u"])
    chk("T3 indipendenti: verdetto DIVERSIFICAZIONE", m["verdetto"] == "DIVERSIFICAZIONE",
        "(%s; rapp_dd %.3f, rapp_pg %.3f, rho_C %.3f)" % (m["verdetto"], m["rapp_dd"],
                                                           m["rapp_pg"], m["rho_c"]))

    # T4: specchio (verso opposto, P/L opposto) = COPERTURA, non diversificazione
    ps = os.path.join(tmp, "specchio.csv")
    _scrivi_pt(ps, a_deals(base, specchio=True), "900004")
    m = misura_a(gv, tranche(leggi_pertrade(ps), 10000.0)["giorni"], comune, 1.0, 1.0)
    chk("T4 specchio: rho_U ~ -1, verso OPPOSTO su tutti i giorni",
        m["rho_u"] < -0.99 and m["opposto"] == m["C"], "(%.4f)" % m["rho_u"])
    chk("T4 specchio: verdetto COPERTURA", m["verdetto"].startswith("COPERTURA"), m["verdetto"])

    # T5: IL CONTRO-ESEMPIO CHE GIUSTIFICA LA SECONDA REGOLA DEL RADDOPPIO.
    #     La nuova entra in MOLTI piu' giorni, ma nei giorni della viva fa
    #     esattamente la stessa cosa. rho_U e' diluito dagli zeri e puo'
    #     cadere sotto 0,50: senza la regola (quota, rho_C) il verdetto
    #     direbbe "parziale" su una sedia che, nei giorni della viva, e' la
    #     viva raddoppiata.
    dv = dict(base)
    sup = [(d, dv[d]) if d in dv else (d, rng.gauss(0.05, 2.0)) for d in G if d in dv or rng.random() < 0.85]
    pu = os.path.join(tmp, "super.csv")
    _scrivi_pt(pu, a_deals(sup), "900005")
    m = misura_a(gv, tranche(leggi_pertrade(pu), 10000.0)["giorni"], comune, 1.0, 1.0)
    chk("T5 sovrainsieme: rho_U diluito sotto 0,50", m["rho_u"] < S_RADD_RHO_U, "(%.4f)" % m["rho_u"])
    chk("T5 sovrainsieme: quota viva = 1, rho_C ~ 1", m["quota_viva"] == 1.0 and m["rho_c"] > 0.99,
        "(rho_C %.4f)" % m["rho_c"])
    chk("T5 sovrainsieme: verdetto RADDOPPIO (per la seconda regola)",
        m["verdetto"].startswith("RADDOPPIO DEL RISCHIO sui giorni"), m["verdetto"])

    # T6: giorni DISGIUNTI -> C = 0, nessun giorno condiviso
    dis = [(d, rng.gauss(0.05, 1.0)) for d in G if d not in dv]
    pd_ = os.path.join(tmp, "disg.csv")
    _scrivi_pt(pd_, a_deals(dis), "900006")
    m = misura_a(gv, tranche(leggi_pertrade(pd_), 10000.0)["giorni"], comune, 1.0, 1.0)
    chk("T6 disgiunti: C = 0 e peggior giornata somma = la peggiore delle due",
        m["C"] == 0 and abs(m["peg_s"] - min(m["peg_v"], m["peg_n"])) < 1e-12)

    # T7: IL CONTRO-ESEMPIO DELLO STRATO 2 (24/09). Perdite LIMITATE a ~1R
    #     (come uno stop), due sedie INDIPENDENTI, la nuova entra nel 95%
    #     dei giorni della viva. Con le soglie fisse (rapp_PG < 1,50;
    #     allarme a 1,80) usciva PARZIALE + coda SCATTA per costruzione.
    def a_bin(giorni, r):
        out = []
        for d in giorni:
            out.append((d, -r.uniform(0.95, 1.20) if r.random() < 0.55 else
                        r.choice([r.uniform(1.3, 1.6), r.uniform(0.1, 1.2)])))
        return out
    rb = random.Random(7)
    vb = a_bin([d for d in G if rb.random() < 0.40], rb)
    dvb = dict(vb)
    nb = a_bin([d for d in G if rb.random() < (0.95 if d in dvb else 0.70)], rb)
    pvb, pnb = os.path.join(tmp, "vb.csv"), os.path.join(tmp, "nb.csv")
    _scrivi_pt(pvb, a_deals(vb), "900007")
    _scrivi_pt(pnb, a_deals(nb), "900008")
    gvb = tranche(leggi_pertrade(pvb), 10000.0)["giorni"]
    m = misura_a(gvb, tranche(leggi_pertrade(pnb), 10000.0)["giorni"], comune, 1.0, 1.0)
    chk("T7 perdite limitate, indipendenti, quota ~0,95: rapp_PG > 1,50 (la vecchia soglia non passava)",
        m["rapp_pg"] > 1.50, "(%.3f, nullo q95 %.3f)" % (m["rapp_pg"], m["q_rapp_pg"]))
    chk("T7 ... verdetto DIVERSIFICAZIONE e coda NON scatta", m["verdetto"] == "DIVERSIFICAZIONE"
        and not m["coda"], "(%s; coda %s; P %.3f q %.3f)" % (m["verdetto"], m["coda"], m["p_coperd"],
                                                              m["q_p_coperd"]))
    pcb = os.path.join(tmp, "cb.csv")
    _scrivi_pt(pcb, a_deals(vb), "900009")
    m = misura_a(gvb, tranche(leggi_pertrade(pcb), 10000.0)["giorni"], comune, 1.0, 1.0)
    chk("T7 copia a perdite limitate: RADDOPPIO e coda SCATTA", m["verdetto"].startswith("RADDOPPIO")
        and m["coda"], "(%s; rapp_pg %.3f q %.3f)" % (m["verdetto"], m["rapp_pg"], m["q_rapp_pg"]))

    # --- G0: contro-esempi -------------------------------------------------
    deals = a_deals(ind)
    pg0 = os.path.join(tmp, "g0.csv")
    _scrivi_pt(pg0, deals, "765271")
    tt = tranche(leggi_pertrade(pg0), 10000.0)
    pf, gp, gl, _, _ = pf_deal(leggi_pertrade(pg0))
    peg = min(v["pct"] for v in tt["giorni"].values())
    buona = {"Profit": "%.2f" % (gp - gl), "Profit Factor": "%.5f" % pf,
             "Equity DD %": "%.4f" % (tt["dd_deal"] + 0.3), "Trades": len(deals),
             "Peggior Giornata %": "%.4f" % (peg - 0.05), "InpMagic": "765271"}
    pcs = os.path.join(tmp, "opt.csv")
    _scrivi_csv(pcs, [buona, dict(buona, InpMagic="765272")])
    ok, _ = g0(pg0, pcs, len(deals), float("%.5f" % pf), float("%.2f" % (gp - gl)), 10000.0)
    chk("G0-a per-trade e riga coerenti, ancora giusta -> VERDE", ok)
    ok, _ = g0(pg0, pcs, len(deals) + 1, float("%.5f" % pf), float("%.2f" % (gp - gl)), 10000.0)
    chk("G0-b ancora con n+1 -> ROSSO", not ok)
    _scrivi_csv(pcs, [dict(buona, Trades=len(deals) - 1)])
    ok, _ = g0(pg0, pcs, len(deals) - 1, float("%.5f" % pf), float("%.2f" % (gp - gl)), 10000.0)
    chk("G0-c riga con un deal in meno del per-trade -> ROSSO (per-trade non e' la cella)", not ok)
    _scrivi_csv(pcs, [dict(buona, **{"Equity DD %": "%.4f" % (tt["dd_deal"] - 0.5)})])
    ok, _ = g0(pg0, pcs, len(deals), float("%.5f" % pf), float("%.2f" % (gp - gl)), 10000.0)
    chk("G0-d DD del tester PIU' PICCOLO del DD a saldo chiuso -> ROSSO (geometria impossibile)", not ok)
    _scrivi_csv(pcs, [dict(buona, **{"Peggior Giornata %": "%.4f" % (peg + 0.2)})])
    ok, _ = g0(pg0, pcs, len(deals), float("%.5f" % pf), float("%.2f" % (gp - gl)), 10000.0)
    chk("G0-e peggior giornata EA meno profonda di quella chiusa -> ROSSO", not ok)
    pvuoto = os.path.join(tmp, "vuoto.csv")
    _scrivi_pt(pvuoto, [], "765271")
    _scrivi_csv(pcs, [buona])
    ok, _ = g0(pvuoto, pcs, len(deals), float("%.5f" % pf), float("%.2f" % (gp - gl)), 10000.0)
    chk("G0-f per-trade da sola intestazione (gamba degenere che ha sovrascritto) -> ROSSO", not ok)
    # G1
    pg1 = os.path.join(tmp, "g1.csv")
    _scrivi_pt(pg1, deals, "765272")
    chk("G1-a gemelle identiche tranne il magic -> VERDE", g1(pg0, pg1)[0])
    d2 = list(deals)
    d2[5] = d2[5][:4] + (d2[5][4] + 0.01,)
    _scrivi_pt(pg1, d2, "765272")
    chk("G1-b un centesimo diverso in una riga -> ROSSO", not g1(pg0, pg1)[0])

    npass = sum(1 for _, e in esiti if e)
    print("\nAUTOTEST: %d/%d PASS  (cartella %s)" % (npass, len(esiti), tmp))
    return 0 if npass == len(esiti) else 1


def main():
    ap = argparse.ArgumentParser(description="R247: sovrapposizione con 770202 e DD giornaliero")
    ap.add_argument("--nuovo", action="append", help="per-trade della cella nuova, PERCORSO[@DEPOSITO]")
    ap.add_argument("--viva", action="append", help="per-trade della sedia viva, PERCORSO[@DEPOSITO]")
    ap.add_argument("--deposito-nuovo", type=float, default=10000.0)
    ap.add_argument("--deposito-viva", type=float, default=100000.0)
    ap.add_argument("--g0", nargs=5, action="append",
                    metavar=("PERTRADE", "CSV_OTTIM", "N", "PF", "PROFIT"))
    ap.add_argument("--gemello", nargs=2, action="append", metavar=("PT_A", "PT_B"))
    ap.add_argument("--comune", nargs=2, metavar=("DA", "A"), help="finestra comune YYYY.MM.DD")
    ap.add_argument("--sessione", default="14:30-17:31")
    ap.add_argument("--peso-viva", type=float, default=1.0)
    ap.add_argument("--peso-nuovo", type=float, default=1.0)
    ap.add_argument("--rischio-base", type=float, default=1.0)
    ap.add_argument("--rischio-conv", type=float, nargs="*", default=[2.0])
    ap.add_argument("--giorni-csv")
    ap.add_argument("--forza", action="store_true")
    ap.add_argument("--autotest", action="store_true")
    args = ap.parse_args()
    if args.autotest:
        return autotest()
    if not (args.nuovo or args.g0 or args.gemello):
        ap.error("serve --nuovo (o --g0 / --gemello), oppure --autotest")
    return esegui(args)


if __name__ == "__main__":
    sys.exit(main())
