#!/usr/bin/env python3
# -*- coding: ascii -*-
"""
distribuzione_dd_riordino.py -- ASCII puro, rieseguibile, nessun numero incollato.

COSA FA
  Legge i file per-trade (deal-level) gia' in repo, aggrega i deal in POSIZIONI,
  ricostruisce la curva di equity della sequenza VERA, e costruisce la
  DISTRIBUZIONE del massimo drawdown per RIORDINO delle stesse operazioni.

  Risponde al punto 4 del collega Garbuglia (RISPOSTA_DOSSIER_ABTG_2026-09-13):
  "un drawdown di backtest e' UNA REALIZZAZIONE, non la distribuzione".

NON FA
  Non lancia backtest. Non tocca EA, preset, coda o terminali. Sola lettura.

MODELLO DI EQUITY DICHIARATO
  - moltiplicativo (default): r_i = pl_i / equity_prima_di_i misurato sulla
    sequenza VERA; un riordino ricompone equity *= (1 + r_perm). Per la
    sequenza vera riproduce ESATTAMENTE la curva vera (identita', non
    approssimazione), quindi e' un'estensione stretta del caso additivo.
  - additivo (--modello additivo): equity += pl_i, taglia costante.
  Il modello moltiplicativo e' quello giusto quando il sizing e' una
  percentuale dell'equity (InpRiskPercent), perche' allora l'ordine conta
  DUE volte: sul percorso e sulla taglia.

DD USATO
  DD a POSIZIONI CHIUSE: max su t di (picco - equity_t)/picco.
  NON e' l'Equity DD % del tester, che include il flottante intrabar:
  lo script misura lo scarto e lo stampa. Il rapporto P95/osservato e'
  calcolato con LA STESSA definizione al numeratore e al denominatore,
  quindi lo scarto si semplifica al prim'ordine.

PEGGIOR GIORNATA -- METODO DICHIARATO PRIMA DEI NUMERI
  Si tengono i CONTENITORI-GIORNO della sequenza vera (giorno d contiene k_d
  posizioni chiuse) e si ridistribuiscono i P/L riordinati dentro quei
  contenitori, in ordine. La percentuale e' (somma del giorno) / (equity a
  inizio giornata): convenzione VERIFICATA contro la colonna
  'Peggior Giornata %' del tester (vedi --verifica).
  NON CATTURA: il calendario vero (quali giorni cadono vicini), le
  posizioni aperte a cavallo di mezzanotte, il flottante infragiornaliero,
  e il fatto che la prop misura sull'equity live tick per tick.

USO
  python3 backtest_pipeline/distribuzione_dd_riordino.py
  python3 backtest_pipeline/distribuzione_dd_riordino.py --riordini 50000 --seed 7
"""

import argparse
import collections
import csv
import glob
import math
import os
import random
import sys

RADICE = os.path.dirname(os.path.dirname(os.path.abspath(__file__)))

# ---------------------------------------------------------------- sorgenti
# (etichetta, percorso per-trade relativo alla radice, magic dentro il file)
# Il DD di riferimento NON e' scritto qui: lo script lo VA A CERCARE nei CSV
# di ottimizzazione facendo combaciare Profit totale e numero di Trades.
SORGENTI = [
    ("Dow_Apertura_US",   "U30USD", "770202",
     "backtest_pipeline/risultati_prove/trades_portafoglio/"
     "abtg_trades_ABTG_Dow_Apertura_US_U30USD_770206.csv", "770206"),
    ("EMA200",            "U30USD", "771531",
     "backtest_pipeline/risultati_prove/trades_candidati_r23/"
     "abtg_trades_ABTG_EMA200_U30USD_771521.csv", "771521"),
    ("DAX_Apertura_EU",   "D30EUR", "770101",
     "backtest_pipeline/risultati_prove/trades_portafoglio/"
     "abtg_trades_ABTG_DAX_Apertura_EU_D30EUR_770115.csv", "770115"),
    ("ORB_Ottimizzato",   "U30USD", "770611",
     "backtest_pipeline/risultati_prove/trades_portafoglio/"
     "abtg_trades_ABTG_ORB_Ottimizzato_U30USD_770612.csv", "770612"),
    ("SuperWave",         "U30USD", "770511",
     "backtest_pipeline/risultati_prove/trades_candidati_r23/"
     "abtg_trades_ABTG_SuperWave_U30USD_770521.csv", "770521"),
    ("MaxMinNotte_XAUUSD", "XAUUSD", "FUORI-ROSA",
     "backtest_pipeline/risultati_prove/ABTG_MaxMinNotte/"
     "abtg_trades_ABTG_MaxMinNotte_XAUUSD_770406.csv", "770406"),
    ("SupertrendReversal", "225JPY", "770901",
     "backtest_pipeline/risultati_prove/trades_portafoglio/"
     "abtg_trades_ABTG_SupertrendReversal_225JPY_770903.csv", "770903"),
    ("MaxMinNotte_DAX_Short", "D30EUR", "770411",
     "backtest_pipeline/risultati_prove/trades_portafoglio/"
     "abtg_trades_ABTG_MaxMinNotte_DAX_Short_Ottimizzato_D30EUR_770413.csv",
     "770413"),
    ("PTE",               "U30USD", "771321",
     "backtest_pipeline/risultati_prove/trades_candidati_r23/"
     "abtg_trades_ABTG_PTE_U30USD_771311.csv", "771311"),
]

DEPOSITI_CANDIDATI = [1000.0, 5000.0, 10000.0, 50000.0, 100000.0,
                      200000.0, 500000.0, 1000000.0]


# ---------------------------------------------------------------- lettura
def carica_posizioni(percorso, magic):
    """Deal-level -> POSIZIONI. Una posizione chiude al suo ultimo deal;
    il suo P/L e' la somma dei net_profit dei suoi deal."""
    pieno = os.path.join(RADICE, percorso)
    with open(pieno, encoding="utf-8", errors="replace") as fh:
        righe = [x for x in csv.DictReader(fh, delimiter=";")
                 if x.get("magic") == magic]
    if not righe:
        return [], 0
    gruppi = collections.OrderedDict()
    for x in righe:
        gruppi.setdefault(x["position_id"], []).append(x)
    posizioni = []
    for pid, xs in gruppi.items():
        chiusura = max(y["close_time"] for y in xs)
        pl = sum(float(y["net_profit"]) for y in xs)
        posizioni.append((chiusura, pid, pl))
    posizioni.sort(key=lambda t: (t[0], t[1]))
    return posizioni, len(righe)


def indicizza_ottimizzazioni():
    """Tutte le righe dei CSV di ottimizzazione che hanno 'Equity DD %'."""
    fuori = []
    for f in glob.glob(os.path.join(RADICE, "backtest_pipeline", "**", "*.csv"),
                       recursive=True):
        try:
            with open(f, encoding="utf-8", errors="replace") as fh:
                testa = fh.readline()
                if "Equity DD %" not in testa:
                    continue
                fh.seek(0)
                for x in csv.DictReader(fh):
                    fuori.append((f, x))
        except Exception:
            continue
    return fuori


def cerca_riga_tester(indice, profitto, n_deal, tol_rel):
    """Trova la riga di ottimizzazione che corrisponde a questo per-trade,
    facendo combaciare Profit totale E numero di Trades (deal).
    Il numero di Trades e' un vincolo DURO (uguaglianza); sul Profit si
    ammette una tolleranza relativa, e il residuo viene SEMPRE stampato:
    un abbinamento non esatto deve restare visibile, non essere assorbito."""
    tolleranza = max(0.01, abs(profitto) * tol_rel)
    trovate = []
    for f, x in indice:
        try:
            if abs(float(x["Profit"]) - profitto) > tolleranza:
                continue
            if int(float(x["Trades"])) != n_deal:
                continue
        except (ValueError, KeyError):
            continue
        trovate.append((f, x))
    if not trovate:
        return None
    # l'unicita' si giudica su DD e PF: la colonna 'Peggior Giornata %' non
    # esiste in tutti i CSV, e la sua assenza NON e' un disaccordo.
    chiavi = set((round(float(x["Equity DD %"]), 4),
                  round(float(x["Profit Factor"]), 5))
                 for _, x in trovate)
    # deterministico: si tiene SEMPRE la riga col residuo minimo sul Profit
    trovate.sort(key=lambda t: (abs(float(t[1]["Profit"]) - profitto), t[0]))
    residuo = float(trovate[0][1]["Profit"]) - profitto
    return {"n_file": len(set(f for f, _ in trovate)),
            "univoca": len(chiavi) == 1,
            "file": os.path.relpath(trovate[0][0], RADICE),
            "residuo": residuo,
            "n_varianti": len(chiavi),
            "residuo_rel": (residuo / profitto * 100.0) if profitto else 0.0,
            "riga": trovate[0][1]}


# ------------------------------------------------------- misure di rischio
def dd_additivo(pl, deposito):
    eq = picco = deposito
    peggio = 0.0
    for p in pl:
        eq += p
        if eq > picco:
            picco = eq
        d = (picco - eq) / picco
        if d > peggio:
            peggio = d
    return peggio * 100.0


def dd_moltiplicativo(rendimenti):
    eq = picco = 1.0
    peggio = 0.0
    for r in rendimenti:
        eq *= (1.0 + r)
        if eq > picco:
            picco = eq
        d = (picco - eq) / picco
        if d > peggio:
            peggio = d
    return peggio * 100.0


def rendimenti_relativi(pl, deposito):
    """r_i = pl_i / equity_prima_di_i, misurato sulla sequenza VERA."""
    eq = deposito
    out = []
    for p in pl:
        out.append(p / eq)
        eq += p
    return out


def peggior_giornata_additivo(pl, taglie_giorno, deposito):
    eq = deposito
    peggio = 0.0
    i = 0
    for k in taglie_giorno:
        s = sum(pl[i:i + k])
        i += k
        pct = s / eq * 100.0
        if pct < peggio:
            peggio = pct
        eq += s
    return peggio


def peggior_giornata_moltiplicativo(rend, taglie_giorno):
    eq = 1.0
    peggio = 0.0
    i = 0
    for k in taglie_giorno:
        inizio = eq
        for r in rend[i:i + k]:
            eq *= (1.0 + r)
        i += k
        pct = (eq - inizio) / inizio * 100.0
        if pct < peggio:
            peggio = pct
    return peggio


def autocorrelazione(x, lag):
    n = len(x)
    if n <= lag + 1:
        return float("nan")
    m = sum(x) / n
    den = sum((v - m) ** 2 for v in x)
    if den == 0:
        return float("nan")
    num = sum((x[i] - m) * (x[i + lag] - m) for i in range(n - lag))
    return num / den


def perc(ordinati, q):
    if not ordinati:
        return float("nan")
    k = (len(ordinati) - 1) * q
    lo = int(math.floor(k))
    hi = int(math.ceil(k))
    if lo == hi:
        return ordinati[lo]
    return ordinati[lo] + (ordinati[hi] - ordinati[lo]) * (k - lo)


def permutazione_a_blocchi(serie, lunghezza, rng):
    """PERMUTAZIONE A BLOCCHI, non bootstrap.
    La serie viene spezzata in blocchi CONSECUTIVI di lunghezza fissa e i
    blocchi vengono rimescolati. E' un RIORDINO vero: il multinsieme delle
    operazioni resta identico (ogni operazione compare una volta e una sola),
    ma i grappoli locali dentro il blocco sono PRESERVATI.
    ATTENZIONE, ed e' il punto: un bootstrap a blocchi (ricampionamento CON
    RIPETIZIONE) NON va bene qui, perche' puo' ripetere due volte il blocco
    peggiore e quindi inventa un percorso che con QUELLE operazioni non
    esiste. Sarebbe un numero piu' grosso e piu' falso."""
    n = len(serie)
    blocchi = [serie[i:i + lunghezza] for i in range(0, n, lunghezza)]
    rng.shuffle(blocchi)
    fuori = []
    for b in blocchi:
        fuori.extend(b)
    assert len(fuori) == n
    return fuori


def peggior_striscia(pl):
    """La peggior somma consecutiva gia' PRESENTE nei dati (Kadane al negativo)
    e la lunghezza della piu' lunga serie di perdite consecutive."""
    cur = 0.0
    peggio = 0.0
    lung = 0
    lung_peggio = 0
    corsa = 0
    corsa_max = 0
    for p in pl:
        if cur + p < 0:
            cur += p
            lung += 1
        else:
            cur = min(0.0, p)
            lung = 1 if p < 0 else 0
        if cur < peggio:
            peggio = cur
            lung_peggio = lung
        if p < 0:
            corsa += 1
            corsa_max = max(corsa_max, corsa)
        else:
            corsa = 0
    return peggio, lung_peggio, corsa_max


def valuta(serie, deposito, moltiplicativo):
    """DD di una serie gia' espressa nella base giusta."""
    if moltiplicativo:
        return dd_moltiplicativo(serie)
    return dd_additivo(serie, deposito)


def riordino_avversario(serie, deposito, moltiplicativo, rng, n_tentativi,
                        lung_blocco):
    """CONTRO-ESEMPIO: riordini NON casuali ma PLAUSIBILI, tutti veri
    riordini (stesso multinsieme, nessuna ripetizione).
    (a) il peggior blocco consecutivo GIA' PRESENTE nei dati, traslato in
        ogni posizione possibile;
    (b) permutazioni a blocchi ripetute, tenendo la peggiore;
    (c) il TETTO NON PLAUSIBILE: tutte le perdite in fila, che e' il caso
        peggiore assoluto e serve solo come soffitto dichiarato.
    Restituisce (dd_a, dd_b, dd_tetto, descrizione_di_a)."""
    n = len(serie)
    dd_a, come_a = 0.0, "non calcolato"
    if 0 < lung_blocco <= n:
        somma = sum(serie[:lung_blocco])
        best_i, best_s = 0, somma
        for i in range(1, n - lung_blocco + 1):
            somma += serie[i + lung_blocco - 1] - serie[i - 1]
            if somma < best_s:
                best_s, best_i = somma, i
        blocco = serie[best_i:best_i + lung_blocco]
        resto = serie[:best_i] + serie[best_i + lung_blocco:]
        for pos in range(0, len(resto) + 1):
            cand = resto[:pos] + blocco + resto[pos:]
            d = valuta(cand, deposito, moltiplicativo)
            if d > dd_a:
                dd_a = d
                come_a = ("blocco perdente vero len=%d (posizioni %d..%d della"
                          " sequenza vera) spostato all'indice %d"
                          % (lung_blocco, best_i, best_i + lung_blocco - 1,
                             pos))
    dd_b = 0.0
    for _ in range(n_tentativi):
        cand = permutazione_a_blocchi(serie, max(2, lung_blocco), rng)
        d = valuta(cand, deposito, moltiplicativo)
        if d > dd_b:
            dd_b = d
    perdite = sorted([v for v in serie if v < 0])
    vincite = sorted([v for v in serie if v >= 0], reverse=True)
    dd_tetto = valuta(vincite + perdite, deposito, moltiplicativo)
    return dd_a, dd_b, dd_tetto, come_a


# ---------------------------------------------------------------- analisi
def analizza(nome, simbolo, magic_rosa, percorso, magic_file, indice, cfg):
    esito = {"nome": nome, "simbolo": simbolo, "magic_rosa": magic_rosa,
             "magic_file": magic_file, "percorso": percorso}
    posizioni, n_deal = carica_posizioni(percorso, magic_file)
    if not posizioni:
        esito["errore"] = "nessuna riga con magic %s" % magic_file
        return esito
    pl = [p for _, _, p in posizioni]
    esito["n_pos"] = len(pl)
    esito["n_deal"] = n_deal
    esito["da"] = posizioni[0][0][:10]
    esito["a"] = posizioni[-1][0][:10]
    esito["profitto"] = sum(pl)

    riga = cerca_riga_tester(indice, esito["profitto"], n_deal,
                             cfg.tolleranza)
    esito["tester"] = riga
    if riga is None:
        esito["deposito"] = None
        esito["nota_dep"] = "riga del tester non trovata: deposito NON deducibile"
        return esito

    dd_tester = float(riga["riga"]["Equity DD %"])
    esito["dd_tester"] = dd_tester
    esito["pf_tester"] = float(riga["riga"]["Profit Factor"])
    esito["rischio_tester"] = riga["riga"].get("InpRiskPercent", "?")
    try:
        esito["pg_tester"] = float(riga["riga"].get("Peggior Giornata %", "nan"))
    except ValueError:
        esito["pg_tester"] = float("nan")

    # deposito: si SCEGLIE quello candidato che minimizza lo scarto sul DD
    scelte = [(abs(dd_additivo(pl, d) - dd_tester), d) for d in DEPOSITI_CANDIDATI]
    scelte.sort()
    deposito = scelte[0][1]
    esito["deposito"] = deposito

    dd_oss = dd_additivo(pl, deposito)
    esito["dd_osservato"] = dd_oss
    esito["scarto_pp"] = dd_oss - dd_tester
    esito["scarto_rel"] = (dd_oss - dd_tester) / dd_tester * 100.0

    # giornate della sequenza vera
    giorni = collections.OrderedDict()
    for t, _, p in posizioni:
        giorni.setdefault(t[:10], []).append(p)
    taglie = [len(v) for v in giorni.values()]
    esito["n_giorni"] = len(taglie)
    esito["pg_osservata"] = peggior_giornata_additivo(pl, taglie, deposito)

    # autocorrelazione
    esito["acf"] = [autocorrelazione(pl, k) for k in (1, 2, 3, 4, 5)]
    striscia, lung_striscia, corsa_max = peggior_striscia(pl)
    esito["striscia_eur"] = striscia
    esito["striscia_len"] = lung_striscia
    esito["corsa_perdente_max"] = corsa_max

    # taglia costante?
    with open(os.path.join(RADICE, percorso), encoding="utf-8",
              errors="replace") as fh:
        vol = [float(x["volume"]) for x in csv.DictReader(fh, delimiter=";")
               if x.get("magic") == magic_file]
    q = max(1, len(vol) // 4)
    esito["vol_primo_q"] = sum(vol[:q]) / q
    esito["vol_ultimo_q"] = sum(vol[-q:]) / q

    molt = (cfg.modello == "moltiplicativo")
    rend = rendimenti_relativi(pl, deposito)
    # coerenza: il moltiplicativo sulla sequenza vera deve dare il DD vero
    esito["dd_oss_molt"] = dd_moltiplicativo(rend)

    rng = random.Random(cfg.seed)
    base = list(rend) if molt else list(pl)
    originale = list(base)   # la sequenza VERA, che NON va mai rimescolata
    dds, pgs = [], []
    for _ in range(cfg.riordini):
        rng.shuffle(base)
        if molt:
            dds.append(dd_moltiplicativo(base))
            pgs.append(peggior_giornata_moltiplicativo(base, taglie))
        else:
            dds.append(dd_additivo(base, deposito))
            pgs.append(peggior_giornata_additivo(base, taglie, deposito))
    dds.sort()
    pgs.sort()
    esito["dd"] = {"mediana": perc(dds, 0.50), "p90": perc(dds, 0.90),
                   "p95": perc(dds, 0.95), "p99": perc(dds, 0.99),
                   "max": dds[-1], "min": dds[0]}
    esito["rapporto_p95"] = esito["dd"]["p95"] / dd_oss if dd_oss else float("nan")
    esito["rapporto_p99"] = esito["dd"]["p99"] / dd_oss if dd_oss else float("nan")
    esito["pg"] = {"mediana": perc(pgs, 0.50), "p90": perc(pgs, 0.10),
                   "p95": perc(pgs, 0.05), "p99": perc(pgs, 0.01),
                   "peggiore": pgs[0]}
    esito["pg_oltre_5pct"] = sum(1 for v in pgs if v <= -5.0) / float(len(pgs))
    esito["dd_oltre_10pct"] = sum(1 for v in dds if v >= 10.0) / float(len(dds))

    # contro-esempio: riordini a blocchi (autocorrelazione preservata)
    lung = max(2, corsa_max)
    rng2 = random.Random(cfg.seed + 1)
    bl = []
    for _ in range(cfg.blocchi):
        cand = permutazione_a_blocchi(originale, lung, rng2)
        bl.append(valuta(cand, deposito, molt))
    bl.sort()
    # coerenza: la permutazione a blocchi conserva il multinsieme
    prova = permutazione_a_blocchi(originale, lung, random.Random(1))
    assert sorted(prova) == sorted(originale), "permutazione a blocchi rotta"
    esito["blocchi_len"] = lung
    esito["blocchi"] = {"mediana": perc(bl, 0.50), "p95": perc(bl, 0.95),
                        "p99": perc(bl, 0.99), "max": bl[-1]}
    esito["blocchi_oltre_10pct"] = sum(1 for v in bl if v >= 10.0) / float(len(bl))

    dd_a, dd_b, dd_tetto, come_a = riordino_avversario(
        originale, deposito, molt, random.Random(cfg.seed + 2),
        cfg.avversari, lung)
    esito["avv_blocco_traslato"] = dd_a
    esito["avv_blocco_traslato_come"] = come_a
    esito["avv_perm_blocchi"] = dd_b
    esito["avv_tetto"] = dd_tetto
    # peggior giornata anche nel modello additivo (controprova)
    esito["pg_oss_add"] = peggior_giornata_additivo(pl, taglie, deposito)
    esito["pos_per_giorno"] = float(len(pl)) / len(taglie)
    return esito


def main():
    ap = argparse.ArgumentParser()
    ap.add_argument("--riordini", type=int, default=10000)
    ap.add_argument("--blocchi", type=int, default=10000)
    ap.add_argument("--avversari", type=int, default=2000)
    ap.add_argument("--seed", type=int, default=20260918)
    ap.add_argument("--min-posizioni", type=int, default=50)
    ap.add_argument("--modello", choices=["moltiplicativo", "additivo"],
                    default="moltiplicativo")
    ap.add_argument("--tolleranza", type=float, default=0.005,
                    help="tolleranza RELATIVA sul Profit per abbinare la riga"
                         " del tester (il residuo viene sempre stampato)")
    cfg = ap.parse_args()

    sys.stderr.write("indicizzo i CSV di ottimizzazione...\n")
    indice = indicizza_ottimizzazioni()
    sys.stderr.write("righe indicizzate: %d\n" % len(indice))

    print("=" * 78)
    print("DISTRIBUZIONE DEL DRAWDOWN PER RIORDINO")
    print("modello=%s  riordini=%d  blocchi=%d  seed=%d  soglia=%d posizioni"
          % (cfg.modello, cfg.riordini, cfg.blocchi, cfg.seed,
             cfg.min_posizioni))
    print("=" * 78)

    for nome, simbolo, magic_rosa, percorso, magic_file in SORGENTI:
        e = analizza(nome, simbolo, magic_rosa, percorso, magic_file,
                     indice, cfg)
        print("")
        print("### %s  %s  magic rosa %s  (per-trade: magic %s)"
              % (nome, simbolo, magic_rosa, magic_file))
        print("    file: %s" % e["percorso"])
        if "errore" in e:
            print("    ERRORE: %s" % e["errore"])
            continue
        print("    posizioni=%d  deal=%d  da %s a %s  profitto=%.2f"
              % (e["n_pos"], e["n_deal"], e["da"], e["a"], e["profitto"]))
        if e.get("tester") is None:
            print("    RIGA DEL TESTER NON TROVATA -> deposito non deducibile,"
                  " nessun DD in percentuale calcolabile. SALTATA.")
            continue
        print("    riga del tester: %s  (file che concordano: %d, coppie"
              " DD/PF distinte entro tolleranza: %d, univoca: %s)"
              % (e["tester"]["file"], e["tester"]["n_file"],
                 e["tester"]["n_varianti"], e["tester"]["univoca"]))
        print("    tester: Equity DD %%=%.4f  PF=%.5f  InpRiskPercent=%s"
              % (e["dd_tester"], e["pf_tester"], e["rischio_tester"]))
        print("    residuo di abbinamento sul Profit: %+.2f (%+.4f%%)  -> %s"
              % (e["tester"]["residuo"], e["tester"]["residuo_rel"],
                 "ESATTO" if abs(e["tester"]["residuo"]) < 0.02
                 else "NON ESATTO, da dichiarare"))
        print("    deposito dedotto=%.0f" % e["deposito"])
        print("    DD ricalcolato (posizioni chiuse) =%.4f%%  "
              "scarto=%+.4f pp (%+.2f%% relativo)"
              % (e["dd_osservato"], e["scarto_pp"], e["scarto_rel"]))
        print("    peggior giornata: ricalcolata=%.4f%%  tester=%.4f%%"
              % (e["pg_osservata"], e["pg_tester"]))
        print("    volume medio primo quarto=%.2f ultimo quarto=%.2f"
              % (e["vol_primo_q"], e["vol_ultimo_q"]))
        print("    ACF P/L lag1..5: " +
              " ".join("%+.4f" % v for v in e["acf"]))
        print("    peggior striscia consecutiva nei dati=%.2f su %d posizioni;"
              " corsa perdente max=%d"
              % (e["striscia_eur"], e["striscia_len"], e["corsa_perdente_max"]))
        if e["n_pos"] < cfg.min_posizioni:
            print("    SOTTO SOGLIA (%d < %d): nessuna distribuzione calcolata."
                  % (e["n_pos"], cfg.min_posizioni))
            continue
        d = e["dd"]
        print("    DD per riordino:  mediana=%.4f  p90=%.4f  p95=%.4f"
              "  p99=%.4f  max=%.4f  min=%.4f"
              % (d["mediana"], d["p90"], d["p95"], d["p99"], d["max"],
                 d["min"]))
        print("    RAPPORTO p95/osservato = %.3f      p99/osservato = %.3f"
              % (e["rapporto_p95"], e["rapporto_p99"]))
        print("    quota di riordini con DD >= 10%%: %.4f%%"
              % (e["dd_oltre_10pct"] * 100.0))
        g = e["pg"]
        print("    peggior giornata per riordino: mediana=%.4f  p90=%.4f"
              "  p95=%.4f  p99=%.4f  peggiore=%.4f"
              % (g["mediana"], g["p90"], g["p95"], g["p99"], g["peggiore"]))
        print("    quota di riordini con una giornata <= -5%%: %.4f%%"
              % (e["pg_oltre_5pct"] * 100.0))
        b = e["blocchi"]
        print("    CONTRO-ESEMPIO blocchi (len=%d, grappoli PRESERVATI):"
              " mediana=%.4f p95=%.4f p99=%.4f max=%.4f"
              % (e["blocchi_len"], b["mediana"], b["p95"], b["p99"], b["max"]))
        print("    quota di permutazioni a blocchi con DD >= 10%%: %.4f%%"
              % (e["blocchi_oltre_10pct"] * 100.0))
        print("    CONTRO-ESEMPIO A: %s -> DD=%.4f"
              % (e["avv_blocco_traslato_come"], e["avv_blocco_traslato"]))
        print("    CONTRO-ESEMPIO B: peggior permutazione a blocchi su %d"
              " tentativi -> DD=%.4f" % (cfg.avversari, e["avv_perm_blocchi"]))
        print("    TETTO NON PLAUSIBILE (tutte le vincite, poi tutte le"
              " perdite): DD=%.4f" % e["avv_tetto"])
        print("    posizioni per giornata (media)=%.2f" % e["pos_per_giorno"])
        verso = ("SOTTOSTIMA" if b["p95"] > d["p95"] else "SOVRASTIMA")
        print("    -> il riordino iid %s la coda: p95 blocchi=%.4f vs"
              " p95 iid=%.4f" % (verso, b["p95"], d["p95"]))


if __name__ == "__main__":
    main()
