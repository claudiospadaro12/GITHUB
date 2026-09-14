#!/usr/bin/env python3
# =====================================================================
#  mc_dd_cella.py -- Monte Carlo del MAX DD di UNA SINGOLA CELLA
# ---------------------------------------------------------------------
#  Criteri CONGELATI in backtest_pipeline/prove/MC_DD_CELLA_CRITERI.md
#  (commit 05efc5d, scritti PRIMA di calcolare qualunque quantile).
#
#  PERCHE' ESISTE, in una riga
#  Il cancello di funnel del dossier -- "Rischio (OOS): DD fuori campione
#  <= 7,00%" (genera_dossier_metodo.py r.132; IS <= 9,00%, r.133) -- si
#  legge oggi su UNA SOLA sequenza di trade: quella che il mercato ha
#  prodotto. Rilievo esterno del 13/09: senza una distribuzione di
#  riordino non si sa se quel numero e' una proprieta' del motore o una
#  gentilezza della sequenza. L'attrezzo per rispondere c'era gia'
#  (dd_portafoglio.py, mc_trailing.py) ma gira solo a livello di
#  PORTAFOGLIO, su 27 serie insieme. Questo lo porta sulla CELLA.
#
#  STESSA METODOLOGIA DI CASA, non una nuova
#   - unita' di ricampionamento: il GIORNO INTERO (i deal dello stesso
#     giorno restano insieme e nel loro ordine: parziale + resto);
#   - 2000 iterazioni, seed 42, deposito 100.000, scala lineare;
#   - stesso parser dei per-trade abtg_trades_*.csv (';', col.0
#     close_time, col.7 net_profit).
#  Il flusso RNG e' IDENTICO a dd_portafoglio.py (una sola shuffle per
#  iterazione, su una lista della stessa lunghezza), e lo strumento lo
#  VERIFICA a ogni corsa invece di dichiararlo: vedi CONTRO-ESEMPIO 1.
#
#  QUATTRO METRICHE PER OGNI RISEQUENZA
#    S-g  statica, % dal PICCO, equity di FINE GIORNATA   (= dd_portafoglio)
#    S-t  statica, % dal PICCO, equity dopo OGNI DEAL     (piu' severa)
#    T-A  trailing EOD,   % del capitale INIZIALE         (= mc_trailing A)
#    T-B  trailing per-deal, % del capitale INIZIALE      (= mc_trailing B)
#  Il cancello del dossier si confronta con S-t.
#
#  IL LIMITE DI GEOMETRIA, DICHIARATO E NON NASCOSTO
#  Il DD che il cancello legge e' l'Equity DD % del TESTER, che include
#  l'equity FLOTTANTE intrabar. Il per-trade contiene solo deal CHIUSI:
#  tutto cio' che esce di qui e' un MINORANTE. Con --dd-tester si passa
#  il DD storico del tester e lo strumento stampa il sovrapprezzo
#  intrabar k = DD_tester / DD_ricostruito, piu' una lettura scalata per
#  k marcata [INFERENZA] -- che NON e' una misura.
#
#  SOLA LETTURA. Apre CSV e stampa numeri. Non tocca forward, conti,
#  preset o EA.
#
#  USO
#    python3 mc_dd_cella.py --finestra OOS --etichetta "r137c OOS" \
#            --dd-tester 7.2328 abtg_trades_<...>.csv
#    python3 mc_dd_cella.py --autotest        (i quattro contro-esempi)
# =====================================================================
import sys, os, csv, argparse, random, itertools
from collections import defaultdict, Counter
from datetime import datetime

SOGLIE = {"OOS": 7.00, "IS": 9.00}      # dossier, pag.2
MC_DEF, SEED_DEF, DEP_DEF = 2000, 42, 100000.0


# --------------------------------------------------------------------
#  LETTURA -- stesso parser di dd_portafoglio.py / mc_trailing.py
# --------------------------------------------------------------------
def leggi_trades(path):
    """-> lista (close_time, giorno 'YYYY.MM.DD', netto, position_id)."""
    rows = []
    with open(path, newline="", encoding="utf-8", errors="replace") as f:
        for r in csv.reader(f, delimiter=";"):
            if len(r) < 8 or r[0] == "close_time":
                continue
            try:
                giorno = r[0].split(" ")[0]
                datetime.strptime(giorno, "%Y.%m.%d")
                netto = float(r[7])
            except (ValueError, IndexError):
                continue
            rows.append((r[0], giorno, netto, r[3] if len(r) > 3 else ""))
    return rows


# --------------------------------------------------------------------
#  LE QUATTRO GEOMETRIE DI DRAWDOWN
# --------------------------------------------------------------------
def dd_statico(pl_seq, deposito):
    """Max DD in % del PICCO corrente. Il picco parte dal deposito, come
    in dd_portafoglio.max_dd() su equity_da_giorni()."""
    eq = picco = deposito
    ddp = 0.0
    for pl in pl_seq:
        eq += pl
        if eq > picco:
            picco = eq
        if picco > 0:
            d = (picco - eq) / picco * 100.0
            if d > ddp:
                ddp = d
    return ddp


def dd_trailing(pl_seq, deposito):
    """Max (HWM - eq) in % del capitale INIZIALE. HWM aggiornato DOPO la
    misura: identica a mc_trailing.max_dd_trailing()."""
    eq = hwm = deposito
    dd = 0.0
    for pl in pl_seq:
        eq += pl
        d = (hwm - eq) / deposito * 100.0
        if d > dd:
            dd = d
        if eq > hwm:
            hwm = eq
    return dd


def pctile(v_ordinato, p):
    """Stessa formula di dd_portafoglio.py / mc_trailing.py."""
    return v_ordinato[min(len(v_ordinato) - 1, int(p / 100.0 * len(v_ordinato)))]


# --------------------------------------------------------------------
#  IL MOTORE MONTE CARLO -- rimescolo dei GIORNI INTERI
# --------------------------------------------------------------------
def monte_carlo(pl_giorno, deal_giorno, deposito, mc, seed):
    """pl_giorno[i]   = P&L sommato del giorno i
       deal_giorno[i] = lista dei netti dei deal del giorno i, in ordine
       -> dict metrica -> lista ORDINATA dei max DD delle mc risequenze.
       Una sola shuffle per iterazione: stesso consumo di RNG di
       dd_portafoglio.py, che fa rng.shuffle(righe) su una lista della
       stessa lunghezza."""
    rng = random.Random(seed)
    idx0 = list(range(len(pl_giorno)))
    out = {"S-g": [], "S-t": [], "T-A": [], "T-B": []}
    for _ in range(mc):
        ordine = idx0[:]
        rng.shuffle(ordine)
        seq_g = [pl_giorno[i] for i in ordine]
        seq_t = [v for i in ordine for v in deal_giorno[i]]
        out["S-g"].append(dd_statico(seq_g, deposito))
        out["S-t"].append(dd_statico(seq_t, deposito))
        out["T-A"].append(dd_trailing(seq_g, deposito))
        out["T-B"].append(dd_trailing(seq_t, deposito))
    for k in out:
        out[k].sort()
    return out


# --------------------------------------------------------------------
#  CONTRO-ESEMPIO 1 -- identita' con dd_portafoglio.py
#  Non e' un test scritto per confermarmi: e' il confronto con codice
#  che esiste gia' e che ha prodotto i numeri di casa (5,74/9,89/12,47).
#  Se il raggruppamento per giorni o il flusso RNG divergessero, cade.
# --------------------------------------------------------------------
def controesempio_dd_portafoglio(pl_giorno, deposito, mc, seed):
    sys.path.insert(0, os.path.dirname(os.path.abspath(__file__)))
    try:
        import dd_portafoglio as dp
    except Exception as e:                                   # pragma: no cover
        return None, f"dd_portafoglio.py non importabile ({e})"
    matrice = [[pl] for pl in pl_giorno]                     # 1 sola serie
    rng = random.Random(seed)
    dds = []
    for _ in range(mc):
        righe = matrice[:]
        rng.shuffle(righe)
        c = [sum(r) for r in righe]
        _, ddp = dp.max_dd(dp.equity_da_giorni(c, deposito))
        dds.append(ddp)
    dds.sort()
    return dds, None


# --------------------------------------------------------------------
#  CONTRO-ESEMPI 2/3/4 -- enumerazione esatta, degeneri, determinismo
# --------------------------------------------------------------------
def autotest(mc=MC_DEF, seed=SEED_DEF):
    print("=" * 70)
    print("AUTOTEST -- i contro-esempi di MC_DD_CELLA_CRITERI.md par.5")
    print("=" * 70)
    esiti = []

    # --- 2. ENUMERAZIONE ESATTA su 7 giorni (5.040 permutazioni) -------
    #  Serie scelta PRIMA di guardarne l'esito, senza ritocchi: alterna
    #  guadagni e perdite di taglia crescente, cosi' il DD dipende
    #  davvero dall'ordine (se non dipendesse, il test non proverebbe
    #  niente -- e' il difetto del 10/09: provare contro il nulla).
    dep = 10000.0
    toy = [+100.0, -250.0, +150.0, -300.0, +200.0, -100.0, +50.0]
    esatti = sorted(dd_statico(list(p), dep) for p in itertools.permutations(toy))
    print(f"\n[2] ENUMERAZIONE ESATTA -- {len(esatti)} permutazioni di 7 giorni")
    ok2 = True
    mcres = monte_carlo(toy, [[x] for x in toy], dep, mc, seed)["S-g"]
    #  CLASSE 333 (14/09): a mc=2000 (lo stesso "mc" dell'identita' con
    #  dd_portafoglio, sotto) la mediana VERA di questa serie cade in una
    #  fascia (4,8309) larga solo 136/5040 permutazioni, il cui bordo
    #  inferiore sta a frazione 0,49524 -- a MENO di mezza deviazione
    #  standard campionaria da 0,50000 (sigma ~0,0112 a n=2000). Non e' un
    #  bug di indicizzazione (pctile() e' la STESSA funzione sui due lati,
    #  niente numpy in questo file): e' rumore Monte Carlo puro su un salto
    #  discreto della CDF proprio a cavallo del 50-esimo percentile, e MORDE
    #  ~1 volta su 3 (misurato su 200 seed, non solo 42). Il confronto con
    #  l'esatto e' un test STATISTICO sul CODICE, non la produzione reale
    #  (che resta a mc=2000/seed 42, criteri congelati): qui, e SOLO qui,
    #  si ricampiona la stessa popolazione con potenza sufficiente a
    #  distinguere 0,49524 da 0,50000 (mc_precisione), lasciando "mcres" a
    #  mc invariato per il confronto di identita' [1] piu' sotto.
    mc_precisione = max(mc, 200_000)
    mcres_precisione = monte_carlo(toy, [[x] for x in toy], dep, mc_precisione, seed)["S-g"]
    for p in (50, 95, 99):
        e, m = pctile(esatti, p), pctile(mcres_precisione, p)
        buono = abs(e - m) <= 0.25
        ok2 &= buono
        print(f"     p{p}: esatto {e:6.4f}  monte carlo {m:6.4f}  "
              f"scarto {abs(e-m):.4f}  {'OK' if buono else 'FUORI TOLLERANZA (0,25)'}")
    #  e la controprova che la serie non e' degenere: il DD dipende
    #  davvero dall'ordine, altrimenti il test [2] sarebbe vuoto.
    print(f"     (spread esatto min {esatti[0]:.4f} -> max {esatti[-1]:.4f}: "
          f"{'il DD DIPENDE dall ordine, il test ha morso' if esatti[-1]-esatti[0] > 0.5 else 'SERIE DEGENERE: test senza valore'})")
    esiti.append(("[2] enumerazione esatta", ok2 and (esatti[-1] - esatti[0]) > 0.5))

    # --- 3. DEGENERI ---------------------------------------------------
    print("\n[3] DEGENERI")
    tuttosu = [10.0, 20.0, 30.0, 40.0, 50.0]
    r = monte_carlo(tuttosu, [[x] for x in tuttosu], dep, 200, seed)
    ok3a = max(r["S-g"]) == 0.0 and max(r["T-A"]) == 0.0
    print(f"     tutta in guadagno  -> max DD su 200 risequenze: "
          f"S-g {max(r['S-g']):.4f}  T-A {max(r['T-A']):.4f}   "
          f"{'OK (zero, come deve)' if ok3a else 'FALLITO'}")
    tuttogiu = [-10.0, -20.0, -30.0, -40.0, -50.0]
    r = monte_carlo(tuttogiu, [[x] for x in tuttogiu], dep, 200, seed)
    ok3b = abs(pctile(r["S-g"], 50) - pctile(r["S-g"], 99)) < 1e-9
    print(f"     tutta in perdita   -> p50 {pctile(r['S-g'],50):.4f} = "
          f"p99 {pctile(r['S-g'],99):.4f}   "
          f"{'OK (equity monotona: l ordine non conta)' if ok3b else 'FALLITO'}")
    esiti.append(("[3] degeneri", ok3a and ok3b))

    # --- 4. DETERMINISMO ------------------------------------------------
    a = monte_carlo(toy, [[x] for x in toy], dep, 500, seed)
    b = monte_carlo(toy, [[x] for x in toy], dep, 500, seed)
    c = monte_carlo(toy, [[x] for x in toy], dep, 500, seed + 1)
    ok4 = all(a[k] == b[k] for k in a) and any(a[k] != c[k] for k in a)
    print("\n[4] DETERMINISMO")
    print(f"     stesso seme -> stessi numeri: {'SI' if all(a[k]==b[k] for k in a) else 'NO'}; "
          f"seme diverso -> numeri diversi: {'SI' if any(a[k]!=c[k] for k in a) else 'NO'}   "
          f"{'OK' if ok4 else 'FALLITO'}")
    esiti.append(("[4] determinismo", ok4))

    # --- 1. identita' con dd_portafoglio su una serie sintetica ---------
    dds, err = controesempio_dd_portafoglio(toy, dep, mc, seed)
    print("\n[1] IDENTITA' CON dd_portafoglio.py (serie giocattolo)")
    if err:
        ok1 = False
        print(f"     NON ESEGUIBILE: {err}")
    else:
        ok1 = all(abs(pctile(dds, p) - pctile(mcres, p)) < 1e-9 for p in (50, 95, 99))
        for p in (50, 95, 99):
            print(f"     p{p}: dd_portafoglio {pctile(dds,p):.4f}  "
                  f"mc_dd_cella {pctile(mcres,p):.4f}")
        print(f"     {'OK (identici, stesso flusso RNG)' if ok1 else 'DIVERGONO: il flusso RNG NON e piu quello di casa'}")
    esiti.append(("[1] identita' dd_portafoglio", ok1))

    print("\n" + "-" * 70)
    tutti = all(v for _, v in esiti)
    for n, v in esiti:
        print(f"  {n:32s} {'PASS' if v else 'FAIL'}")
    print(f"\nESITO AUTOTEST: {'PASS -- i numeri si possono leggere' if tutti else 'FAIL -- NESSUN numero si legge finche non e riparato'}")
    return 0 if tutti else 1


# --------------------------------------------------------------------
def main():
    ap = argparse.ArgumentParser(
        description="Monte Carlo del max DD di UNA cella (rimescolo dei giorni interi).")
    ap.add_argument("files", nargs="*", help="CSV per-trade della cella (abtg_trades_*.csv)")
    ap.add_argument("--etichetta", default="", help="nome della cella nel referto (es. 'r137c OOS')")
    ap.add_argument("--finestra", choices=["OOS", "IS"], default="OOS",
                    help="quale soglia del dossier applicare (OOS 7,00%% / IS 9,00%%)")
    ap.add_argument("--soglia", type=float, default=None, help="soglia esplicita, scavalca --finestra")
    ap.add_argument("--deposito", type=float, default=DEP_DEF)
    ap.add_argument("--scala", type=float, default=1.0,
                    help="scala lineare dei P&L (es. 0.65 per la taglia di casa)")
    ap.add_argument("--dd-tester", type=float, default=None,
                    help="Equity DD %% storico del tester, per misurare il sovrapprezzo intrabar")
    ap.add_argument("--mc", type=int, default=MC_DEF)
    ap.add_argument("--seed", type=int, default=SEED_DEF)
    ap.add_argument("--autotest", action="store_true")
    args = ap.parse_args()

    if args.autotest:
        return autotest(args.mc, args.seed)
    if not args.files:
        ap.error("serve almeno un CSV per-trade, oppure --autotest")

    soglia = args.soglia if args.soglia is not None else SOGLIE[args.finestra]

    # ---- carica e raggruppa per GIORNO -------------------------------
    rows = []
    for p in args.files:
        r = leggi_trades(p)
        if not r:
            print(f"ATTENZIONE: {p} vuoto o illeggibile, saltato")
            continue
        rows.extend(r)
    if not rows:
        sys.exit("nessun dato leggibile: mi fermo invece di stampare uno zero.")
    rows.sort(key=lambda x: x[0])

    per_giorno, pos_giorno = defaultdict(list), defaultdict(set)
    for ct, g, v, pid in rows:
        per_giorno[g].append(v * args.scala)
        pos_giorno[g].add(pid)
    giorni = sorted(per_giorno)
    pl_giorno = [sum(per_giorno[g]) for g in giorni]
    deal_giorno = [per_giorno[g] for g in giorni]

    netto = sum(pl_giorno)
    vinc = sum(v for d in deal_giorno for v in d if v > 0)
    pers = sum(-v for d in deal_giorno for v in d if v < 0)
    pf = (vinc / pers) if pers > 0 else float("inf")
    posizioni = sum(len(s) for s in pos_giorno.values())

    et = args.etichetta or ", ".join(os.path.basename(f) for f in args.files)
    print("=" * 70)
    print(f"MONTE CARLO DEL DD -- CELLA: {et}")
    print("=" * 70)
    print(f"file            : {', '.join(os.path.basename(f) for f in args.files)}")
    print(f"finestra dati   : {giorni[0]} -> {giorni[-1]}")
    print(f"deal di uscita  : {len(rows)}   posizioni (position_id distinti): {posizioni}"
          f"   giorni con trade: {len(giorni)}")
    print(f"netto           : {netto:+.2f}   PF {pf:.5f}   deposito {args.deposito:.0f}"
          f"   scala {args.scala:.2f}")

    # ---- il limite dell'unita' di rimescolo, MISURATO su questa cella --
    dist = Counter(len(s) for s in pos_giorno.values())
    print(f"posizioni/giorno: {dict(sorted(dist.items()))}")
    if max(dist) <= 1:
        print("  >>> NOTA ONESTA: questa cella apre al massimo UNA posizione al giorno,")
        print("      quindi rimescolare i GIORNI e' IDENTICO a rimescolare le POSIZIONI.")
        print("      La frase 'conserva la correlazione same-day' qui e' vera ma VUOTA.")
        print("      Cio' che il rimescolo per giorni protegge davvero e' l'accoppiata")
        print("      dei deal della stessa posizione (parziale + resto), che resta unita.")
    else:
        print("  >>> il rimescolo per giorni CONSERVA la correlazione same-day fra le")
        print(f"      {max(dist)} posizioni che questa cella puo' avere aperte nello stesso giorno.")

    # ---- storico puntuale (il numero che il cancello legge oggi) -------
    st_g = dd_statico(pl_giorno, args.deposito)
    st_t = dd_statico([v for d in deal_giorno for v in d], args.deposito)
    tr_A = dd_trailing(pl_giorno, args.deposito)
    tr_B = dd_trailing([v for d in deal_giorno for v in d], args.deposito)

    print("\n-- DD STORICO (una sola sequenza: quella accaduta) --")
    print(f"  S-g  statica EOD,  %% dal picco : {st_g:6.4f}")
    print(f"  S-t  statica deal, %% dal picco : {st_t:6.4f}   <<< e' questa che si"
          " confronta col cancello")
    print(f"  T-A  trailing EOD, %% del dep.  : {tr_A:6.4f}")
    print(f"  T-B  trailing deal,%% del dep.  : {tr_B:6.4f}")
    k = None
    if args.dd_tester is not None:
        k = args.dd_tester / st_t if st_t > 0 else float("inf")
        print(f"\n  Equity DD %% del TESTER (storico) : {args.dd_tester:6.4f}")
        print(f"  sovrapprezzo intrabar k = tester / S-t = {k:.3f}")
        print("  (il per-trade ha solo deal CHIUSI: tutto cio' che esce di qui e' un MINORANTE)")

    # ---- CONTRO-ESEMPIO 1, su questi dati veri ------------------------
    print(f"\n-- CONTRO-ESEMPIO 1: identita' del flusso RNG con dd_portafoglio.py --")
    dds_dp, err = controesempio_dd_portafoglio(pl_giorno, args.deposito, args.mc, args.seed)

    # ---- MONTE CARLO ---------------------------------------------------
    res = monte_carlo(pl_giorno, deal_giorno, args.deposito, args.mc, args.seed)

    if err:
        print(f"  NON ESEGUIBILE: {err} -- i numeri sotto NON sono certificati.")
        ok1 = False
    else:
        ok1 = all(abs(pctile(dds_dp, p) - pctile(res["S-g"], p)) < 1e-9 for p in (50, 95, 99))
        print(f"  dd_portafoglio.py : p50 {pctile(dds_dp,50):.4f}  p95 {pctile(dds_dp,95):.4f}"
              f"  p99 {pctile(dds_dp,99):.4f}")
        print(f"  mc_dd_cella   S-g : p50 {pctile(res['S-g'],50):.4f}  p95 {pctile(res['S-g'],95):.4f}"
              f"  p99 {pctile(res['S-g'],99):.4f}")
        print(f"  ESITO: {'PASS -- identici, stesso rimescolo di casa' if ok1 else 'FAIL -- il rimescolo NON e quello di casa: NON leggere i numeri sotto'}")

    print(f"\n-- MONTE CARLO: {args.mc} rimescoli dei GIORNI INTERI, seed {args.seed} --")
    print("  metrica                          p50      p95      p99   |  storico")
    for sig, etich, sto in (("S-g", "statica EOD (% dal picco)", st_g),
                            ("S-t", "statica per-deal (% picco)", st_t),
                            ("T-A", "trailing EOD (% del dep.)", tr_A),
                            ("T-B", "trailing per-deal (% dep.)", tr_B)):
        v = res[sig]
        print(f"  {sig} {etich:30s} {pctile(v,50):7.4f}  {pctile(v,95):7.4f}  "
              f"{pctile(v,99):7.4f}  |  {sto:7.4f}")

    # ---- il verdetto sul cancello --------------------------------------
    v = res["S-t"]
    p50, p95, p99 = pctile(v, 50), pctile(v, 95), pctile(v, 99)
    sfonda = sum(1 for x in v if x > soglia) / float(args.mc) * 100.0
    fortuna = st_t / p50 if p50 > 0 else float("nan")

    print(f"\n-- IL CANCELLO: DD {args.finestra} <= {soglia:.2f}% (dossier pag.2) --")
    print(f"  DD storico letto dal cancello oggi (tester): "
          f"{args.dd_tester if args.dd_tester is not None else st_t:.4f}%"
          f"  -> {'PASSA' if (args.dd_tester if args.dd_tester is not None else st_t) <= soglia else 'NON PASSA'}")
    print(f"\n  [MISURA] geometria per-deal chiusa (minorante):")
    print(f"     p50 {p50:.4f}%   p95 {p95:.4f}%   p99 {p99:.4f}%")
    print(f"     P(DD ricampionato > {soglia:.2f}%) = {sfonda:.1f}% delle {args.mc} risequenze")
    print(f"     indice di fortuna = storico/p50 = {fortuna:.3f}   "
          f"({'lo storico e stato PIU GENTILE della mediana' if fortuna < 1 else 'lo storico e stato PIU CATTIVO della mediana'})")
    if p95 < soglia:
        lampada = "VERDE -- SOLIDA (p95 sotto il cancello)"
    elif p50 < soglia:
        lampada = "GIALLA -- FRAGILE (lo storico passa, una sequenza sfortunata plausibile no)"
    else:
        lampada = "ROSSA -- PASSATA PER FORTUNA (la mediana delle risequenze sfonda gia')"
    print(f"     LAMPADA (lettura proposta, NON firmata): {lampada}")

    if k is not None:
        print(f"\n  [INFERENZA -- NON E' UNA MISURA] stessi quantili x k={k:.3f}")
        print("     (ipotesi: il sovrapprezzo intrabar e' proporzionale; estrapolata")
        print("      da UN solo punto, quello storico. Va detto ogni volta che si cita.)")
        s50, s95, s99 = p50 * k, p95 * k, p99 * k
        sf = sum(1 for x in v if x * k > soglia) / float(args.mc) * 100.0
        print(f"     p50 {s50:.4f}%   p95 {s95:.4f}%   p99 {s99:.4f}%")
        print(f"     P(DD > {soglia:.2f}%) = {sf:.1f}%")
        lam = ("VERDE -- SOLIDA" if s95 < soglia else
               "GIALLA -- FRAGILE" if s50 < soglia else
               "ROSSA -- PASSATA PER FORTUNA")
        print(f"     LAMPADA inferita: {lam}")

    print("\nNOTE: il rimescolo allarga le SEQUENZE, non i REGIMI. Il DD storico resta")
    print("stampato ACCANTO ai quantili, mai al loro posto. Il DD non scala")
    print("linearmente col rischio: per un'altra taglia si ricorre con --scala.")
    return 0 if ok1 else 1


if __name__ == "__main__":
    sys.exit(main())
