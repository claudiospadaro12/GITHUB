#!/usr/bin/env python3
# -*- coding: ascii -*-
# MARCATORE_CORRELAZIONE_PACCHETTO_v1 (17/10/2026)
"""
correlazione_pacchetto.py -- B5 (scorrelazione) e B6 (DD di portafoglio) del PACCHETTO ORO, misurati sui report .htm
del NOSTRO Strategy Tester. SOLA LETTURA: non lancia niente, non tocca MT5, non tocca parametri in forward.

Il METODO e' congelato PRIMA dei numeri in report/PACCHETTO_ORO_B5_B6_METODO_2026-10-17.md, e questo file NON lo
decide: lo esegue. Le soglie vengono da report/PACCHETTO_ORO_ATTESE_2026-10-17.md (B5 <= 0,30, smentita > 0,50;
B6 <= 1,5 x il DD del singolo peggiore).

USO
  python3 -I backtest_pipeline/correlazione_pacchetto.py GOLDREAPER=<zip|cartella> PHANTOM=<zip> ...
  python3 -I backtest_pipeline/correlazione_pacchetto.py --autotest

COSE CHE QUESTO STRUMENTO DICHIARA SEMPRE, perche' senza di esse un r non vuol dire niente:
  n (giorni della finestra comune) - giorni CO-ATTIVI - intervallo bootstrap al 95% - la variante a giorni scartati
  - la correlazione nel decile peggiore - il pavimento E il tetto del DD - e che il peso 1/4 rende B6 non falsificabile.
"""
import sys, os, re, math, random, argparse, datetime, itertools

sys.path.insert(0, os.path.dirname(os.path.abspath(__file__)))
from leggi_arena_tester import Sorgente, leggi_report, decodifica  # parser passato dal cancello il 14/10/2026

# --------------------------------------------------------------------------------------------------------------------
#  COSTANTI -- congelate nel documento di metodo, non si toccano da riga di comando
# --------------------------------------------------------------------------------------------------------------------
SOGLIA_B5_REGGE = 0.30          # Pearson <= 0,30: B5 regge
SOGLIA_B5_SMENTITA = 0.50       # Pearson > 0,50: B5 smentita
SOGLIA_B6_FATTORE = 1.5         # DD portafoglio <= 1,5 x DD del singolo peggiore
MIN_COATTIVI = 30               # sotto i 30 giorni co-attivi la coppia e' NON MISURATA
BOOT = 5000                     # ripetizioni del bootstrap sui giorni interi
SEME = 12345                    # dichiarato: il bootstrap e' riproducibile
DEPOSITO_ATTESO = 5000.0
SOGLIA_SOPRAVVIVENZA_PCT = 10.0  # il tetto di DD totale che il Guardian applica sul reale e che FTMO applica: un
                                 # portafoglio che lo sfonda e' MORTO, qualunque cosa dica B6 (che e' relativa)
DECILE = 0.10                   # frazione dei giorni peggiori del portafoglio su cui si rilegge la correlazione

RE_PERIODO = re.compile(r"\((\d{4}\.\d{2}\.\d{2})\s*-\s*(\d{4}\.\d{2}\.\d{2})\)")
RE_INGRESSI = re.compile(r"\|([A-Za-z_][A-Za-z0-9_]*)=([^|]*)(?=\|)")


# --------------------------------------------------------------------------------------------------------------------
#  LETTURA: dai report .htm alle serie giornaliere
# --------------------------------------------------------------------------------------------------------------------
def ingressi_generici(raw):
    """I parametri degli EA di TERZI: il report li scrive sotto 'Dati in ingresso:' SENZA il nostro prefisso Inp.
    leggi_report() cattura solo gli Inp*: senza questa lettura non si puo' VERIFICARE che un set imposto sia stato
    applicato, e un nome sbagliato MT5 lo ignora in silenzio (il giro misurerebbe il DEFAULT). Classe dichiarata."""
    t = decodifica(raw)
    cut = len(t)
    for et in (">Ordini<", ">Orders<"):
        i = t.find(et)
        if i >= 0:
            cut = min(cut, i)
    piatto = re.sub(r"\s*\|[\s|]*", "|", re.sub(r"<[^>]+>", "|", t[:cut]))
    fuori = {}
    for m in RE_INGRESSI.finditer(piatto):
        nome, val = m.group(1), m.group(2).strip()
        if nome in ("Expert", "Simbolo", "Symbol", "Periodo", "Period", "Ticks", "Barre", "Bars"):
            continue
        fuori.setdefault(nome, val)
    return fuori


def giorni_di_mercato(finestre, con_deal):
    """lun-ven di OGNI finestra di tranche CONFORME + ogni giorno che ha un deal.
    ATTENZIONE: Non si prende l'intervallo da min(da) a max(a): un mese senza tranche conforme entrerebbe come una fila di
    ZERI veri, e quegli zeri finti abbassano Pearson e falsificano B5 'a favore'. Classe 1486 (17/10/2026)."""
    g = set()
    for da, a in finestre:
        d = da
        while d <= a:
            if d.weekday() < 5:
                g.add(d)
            d += datetime.timedelta(days=1)
    return g | set(con_deal)


def serie_di_una_tranche(rep):
    """-> (giorno -> netto EUR), somma di (profitto + commissione + swap) di OGNI riga di Affari, 'balance' esclusa.
    Controllo: la somma deve dare il Profitto Totale Netto della testa del report."""
    per_giorno = {}
    for d in rep["deals"]:
        if d["tipo"] == "balance":
            continue
        g = d["t"].date()
        per_giorno[g] = per_giorno.get(g, 0.0) + d["profitto"] + d["comm"] + d["swap"]
    return per_giorno


def leggi_ea(etichetta, percorso):
    """Tutte le tranche di un EA -> dizionario con la serie giornaliera, le conformita' e i DD per tranche."""
    src = Sorgente(percorso)
    htm = [n for n in src.nomi() if n.lower().endswith(".htm")]
    if not htm:
        raise SystemExit("ERRORE: in %s non c'e' nessun report .htm" % percorso)
    ea = {"etichetta": etichetta, "percorso": percorso, "serie": {}, "tranche": [], "dd_tranche": [],
          "dd_tranche_eur": [], "giorni_con_deal": set(), "da": None, "a": None, "netto": 0.0, "esclusi": []}
    for n in sorted(htm):
        raw = src.leggi(n)
        rep = leggi_report(raw)
        nome = os.path.basename(n)
        if not rep["ok"]:
            ea["esclusi"].append((nome, "report illeggibile: " + rep["motivo"]))
            continue
        motivi = []
        qual = (rep["qualita"] or "")
        if "100" not in qual:
            motivi.append("qualita' storico '%s' (attesa 100%%: niente ticks reali = la tranche non conta)" % qual)
        if rep["deposito"] is None or abs(rep["deposito"] - DEPOSITO_ATTESO) > 0.01:
            motivi.append("deposito %s (atteso %.0f)" % (rep["deposito"], DEPOSITO_ATTESO))
        m = RE_PERIODO.search(rep["periodo"] or "")
        if not m:
            motivi.append("finestra non leggibile da '%s'" % rep["periodo"])
        if motivi:
            ea["esclusi"].append((nome, "; ".join(motivi)))
            continue
        da = datetime.datetime.strptime(m.group(1), "%Y.%m.%d").date()
        a = datetime.datetime.strptime(m.group(2), "%Y.%m.%d").date()
        s = serie_di_una_tranche(rep)
        somma = sum(s.values())
        if abs(somma - rep["profitto"]) > 0.05:
            ea["esclusi"].append((nome, "CONTROLLO ARITMETICO FALLITO: somma dei giorni %.2f != profitto netto del "
                                        "report %.2f (la serie e' sbagliata, la tranche si esclude)"
                                  % (somma, rep["profitto"])))
            continue
        for g, v in s.items():
            ea["serie"][g] = ea["serie"].get(g, 0.0) + v
        ea["giorni_con_deal"] |= set(s)
        ea["netto"] += somma
        ea["tranche"].append({"file": nome, "da": da, "a": a, "netto": somma, "expert": rep["expert"],
                              "simbolo": rep["simbolo"], "periodo": rep["periodo"],
                              "dd_eq_pct": rep["dd_eq_pct"], "dd_eq_abs": rep["dd_eq_abs"],
                              "trades": rep["trades"], "ingressi": ingressi_generici(raw)})
        if rep["dd_eq_pct"] is not None:
            ea["dd_tranche"].append(rep["dd_eq_pct"])
        if rep["dd_eq_abs"] is not None:
            ea["dd_tranche_eur"].append(rep["dd_eq_abs"])
        ea["da"] = da if ea["da"] is None else min(ea["da"], da)
        ea["a"] = a if ea["a"] is None else max(ea["a"], a)
    if not ea["tranche"]:
        raise SystemExit("ERRORE: per %s nessuna tranche CONFORME: %s" % (etichetta, ea["esclusi"]))
    ea["finestre"] = sorted(set((t["da"], t["a"]) for t in ea["tranche"]))
    ea["giorni"] = giorni_di_mercato(ea["finestre"], ea["giorni_con_deal"])
    return ea


# --------------------------------------------------------------------------------------------------------------------
#  MISURA
# --------------------------------------------------------------------------------------------------------------------
def pearson(x, y):
    n = len(x)
    if n < 3:
        return None
    mx, my = sum(x) / n, sum(y) / n
    sx = math.sqrt(sum((v - mx) ** 2 for v in x))
    sy = math.sqrt(sum((v - my) ** 2 for v in y))
    if sx == 0.0 or sy == 0.0:
        return None          # una serie costante: la correlazione NON esiste, non e' zero
    return sum((x[i] - mx) * (y[i] - my) for i in range(n)) / (sx * sy)


def intervallo_bootstrap(x, y, boot=BOOT, seme=SEME):
    """Ricampionamento dei GIORNI interi (conserva la correlazione dello stesso giorno, distrugge quella seriale)."""
    n = len(x)
    if n < 3:
        return (None, None)
    rnd = random.Random(seme)
    out = []
    for _ in range(boot):
        idx = [rnd.randrange(n) for _ in range(n)]
        r = pearson([x[i] for i in idx], [y[i] for i in idx])
        if r is not None:
            out.append(r)
    if len(out) < boot // 10:
        return (None, None)
    out.sort()
    return (out[int(0.025 * len(out))], out[min(len(out) - 1, int(0.975 * len(out)))])


def coppia(a, b, variante="A"):
    """Una coppia di EA: r con gli zeri, r a giorni scartati, co-attivi, intervallo, verdetto B5."""
    comuni = sorted(a["giorni"] & b["giorni"])
    sa = a["serie_norm" if variante == "B" else "serie"]
    sb = b["serie_norm" if variante == "B" else "serie"]
    x = [sa.get(g, 0.0) for g in comuni]
    y = [sb.get(g, 0.0) for g in comuni]
    coatt = [g for g in comuni if g in a["giorni_con_deal"] and g in b["giorni_con_deal"]]
    r = pearson(x, y)
    lo, hi = intervallo_bootstrap(x, y)
    # variante a giorni scartati (quella che FAREBBE sembrare scorrelato cio' che non e' misurato)
    solo = [g for g in comuni if g in a["giorni_con_deal"] and g in b["giorni_con_deal"]]
    r_scart = pearson([sa.get(g, 0.0) for g in solo], [sb.get(g, 0.0) for g in solo]) if len(solo) >= 3 else None
    motivi = []
    if r is None:
        esito = "NON MISURATA"
        motivi.append("una delle due serie e' costante sulla finestra comune")
    elif len(coatt) < MIN_COATTIVI:
        esito = "NON MISURATA"
        motivi.append("giorni co-attivi %d < %d: i due EA si incontrano troppo poco" % (len(coatt), MIN_COATTIVI))
    elif lo is not None and lo <= SOGLIA_B5_SMENTITA <= hi:
        esito = "NON MISURATA"
        motivi.append("l'intervallo al 95%% [%.3f; %.3f] contiene la soglia di smentita %.2f" % (lo, hi, SOGLIA_B5_SMENTITA))
    elif r > SOGLIA_B5_SMENTITA:
        esito = "B5 SMENTITA"
    elif r <= SOGLIA_B5_REGGE:
        esito = "B5 REGGE"
    else:
        esito = "ZONA GRIGIA (fra %.2f e %.2f)" % (SOGLIA_B5_REGGE, SOGLIA_B5_SMENTITA)
    if r is not None and r_scart is not None and abs(r - r_scart) > 0.20:
        motivi.append("scartando i giorni non comuni r passa da %.3f a %.3f: le due versioni si contraddicono"
                      % (r, r_scart))
        esito = "NON MISURATA"
    return {"n": len(comuni), "coattivi": len(coatt), "r": r, "lo": lo, "hi": hi, "r_scartati": r_scart,
            "esito": esito, "motivi": motivi, "giorni": comuni, "x": x, "y": y}


def curva_dd(valori):
    """DD massimo dal picco di una curva cumulata (unita' = quella dei valori). -> (dd, picco, fondo)"""
    eq, picco, dd = 0.0, 0.0, 0.0
    for v in valori:
        eq += v
        picco = max(picco, eq)
        dd = max(dd, picco - eq)
    return dd


def portafoglio(eas, peso):
    """Curva combinata sui realizzi giornalieri, peso uguale per tutti, **UNA TRANCHE PER VOLTA**.

    ATTENZIONE: La riparazione del 17/10/2026, trovata dai dati veri (classe 1487): ogni tranche riparte da un conto VUOTO
    di 5.000, quindi incollare i mesi in una curva continua inventa un drawdown che non e' mai esistito su nessun
    conto. Misurato: con i tre mesi incollati il PAVIMENTO usciva 145,64% del deposito, **piu' del TETTO (81,35%)**,
    e un pavimento sopra il suo tetto e' una contraddizione aritmetica, non un numero da interpretare.
    Il DD di portafoglio e' quindi il **massimo fra i DD calcolati DENTRO ciascun mese comune**.
    Si usano solo i mesi in cui TUTTI gli EA hanno una tranche conforme con la STESSA finestra: i mesi in cui
    manca qualcuno sono dichiarati, non riempiti di zeri."""
    comuni = sorted(set.intersection(*[set(e["finestre"]) for e in eas]))
    fuori = sorted(set().union(*[set(e["finestre"]) for e in eas]) - set(comuni))
    per_mese, tutti = [], []
    for (da, a) in comuni:
        giorni = sorted(g for g in set().union(*[e["giorni"] for e in eas]) if da <= g <= a)
        comb = [peso * sum(e["serie"].get(g, 0.0) for e in eas) for g in giorni]
        dd = curva_dd(comb)
        # il TETTO si somma in EUR, non in percentuale: il DD% della testa del report e' calcolato sul PICCO di
        # equita', il nostro pavimento sul DEPOSITO. Sommarli come se fossero la stessa unita' e' il difetto che
        # i dati veri hanno fatto emergere il 17/10 (classe 1488): in agosto TIG ha 13.088 EUR di DD = 61,59% di un
        # picco alto, e 261,8% del deposito. Due numeri giusti, due unita' diverse, un confronto senza senso.
        tetto_eur = sum(max([t["dd_eq_abs"] for t in e["tranche"]
                             if (t["da"], t["a"]) == (da, a) and t["dd_eq_abs"] is not None] or [0.0]) for e in eas)
        per_mese.append({"da": da, "a": a, "giorni": giorni, "serie": comb, "netto": sum(comb),
                         "dd_eur": dd, "dd_pct": 100.0 * dd / DEPOSITO_ATTESO, "tetto_eur": peso * tetto_eur,
                         "tetto_pct": 100.0 * peso * tetto_eur / DEPOSITO_ATTESO})
        tutti.extend(zip(giorni, comb))
    if not per_mese:
        raise SystemExit("ERRORE: nessun mese con una tranche conforme per TUTTI gli EA: B6 non si calcola")
    peggiore = max(per_mese, key=lambda m: m["dd_pct"])
    return {"mesi": per_mese, "fuori": fuori, "dd_pct": peggiore["dd_pct"], "mese_peggiore": peggiore,
            "tetto_pct": max(m["tetto_pct"] for m in per_mese), "netto": sum(m["netto"] for m in per_mese),
            "giorni": [g for g, _v in tutti], "serie": [v for _g, v in tutti]}


def correlazione_decile(eas, par):
    """La correlazione RILETTA sui giorni peggiori del portafoglio: una media bassa non protegge se i due
    crollano insieme proprio li'. Misura aggiuntiva, non sostitutiva."""
    p = portafoglio(eas, 1.0)
    coppie = sorted(zip(p["serie"], p["giorni"]))
    k = max(3, int(DECILE * len(coppie)))
    peggiori = set(g for _v, g in coppie[:k])
    out = {}
    for a, b in par:
        g = sorted((a["giorni"] & b["giorni"]) & peggiori)
        if len(g) < 3:
            out[(a["etichetta"], b["etichetta"])] = (None, len(g))
            continue
        out[(a["etichetta"], b["etichetta"])] = (
            pearson([a["serie"].get(d, 0.0) for d in g], [b["serie"].get(d, 0.0) for d in g]), len(g))
    return out, k


def normalizza(ea):
    """Variante B: netto del giorno / equita' a inizio giornata, tranche per tranche (il divisore VARIA: e' la sola
    variante in cui Pearson cambia davvero. Dividere per il deposito COSTANTE non cambia Pearson di un millesimo)."""
    ea["serie_norm"] = {}
    for tr in ea["tranche"]:
        eq = DEPOSITO_ATTESO
        g = tr["da"]
        while g <= tr["a"]:
            v = ea["serie"].get(g)
            if v is not None and eq > 0:
                ea["serie_norm"][g] = v / eq
                eq += v
            g += datetime.timedelta(days=1)
    return ea


# --------------------------------------------------------------------------------------------------------------------
#  STAMPA
# --------------------------------------------------------------------------------------------------------------------
def f(x, d=3):
    return "[n.d.]" if x is None else ("%." + str(d) + "f") % x


def stampa(eas):
    print("=" * 118)
    print("  B5 / B6 DEL PACCHETTO ORO -- metodo congelato in report/PACCHETTO_ORO_B5_B6_METODO_2026-10-17.md")
    print("  SOLA LETTURA. Soglie: B5 regge <= %.2f, smentita > %.2f | B6 <= %.1f x il DD del singolo peggiore"
          % (SOGLIA_B5_REGGE, SOGLIA_B5_SMENTITA, SOGLIA_B6_FATTORE))
    print("=" * 118)

    print("\n--- GLI EA LETTI ---")
    for e in eas:
        print("  %-14s tranche conformi %2d  finestra %s -> %s  netto %+10.2f EUR  giorni con operazioni %4d"
              % (e["etichetta"], len(e["tranche"]), e["da"], e["a"], e["netto"], len(e["giorni_con_deal"])))
        print("                 DD di equita' per tranche (%%): %s   -> peggiore %s"
              % (", ".join(f(d, 2) for d in e["dd_tranche"]) or "nessuno letto",
                 f(max(e["dd_tranche"]), 2) if e["dd_tranche"] else "[n.d.]"))
        esperti = sorted(set(t["expert"] or "?" for t in e["tranche"]))
        simboli = sorted(set(t["simbolo"] or "?" for t in e["tranche"]))
        print("                 expert %s | simbolo %s" % (", ".join(esperti), ", ".join(simboli)))
        if len(esperti) > 1:
            print("                 !! ATTENZIONE: tranche di EA DIVERSI nella stessa etichetta: non e' un EA solo")
        for nome, perche in e["esclusi"]:
            print("                 ESCLUSA %s: %s" % (nome, perche))

    par = list(itertools.combinations(eas, 2))
    if not par:
        print("\nUn solo EA: B5 e B6 non si calcolano (servono almeno due). Niente verdetto.")
        return
    print("\n--- B5: CORRELAZIONE DEI RISULTATI GIORNALIERI (variante A, netto in EUR; gli zeri CONTANO) ---")
    print("  %-28s %6s %8s %8s %-18s %9s   %s" % ("coppia", "n", "co-att.", "r", "95% bootstrap", "r senza", "esito"))
    print("  %-28s %6s %8s %8s %-18s %9s" % ("", "giorni", "giorni", "", "(giorni interi)", "zeri"))
    esiti = {}
    for a, b in par:
        c = coppia(a, b, "A")
        nome = a["etichetta"] + " / " + b["etichetta"]
        esiti[(a["etichetta"], b["etichetta"])] = c
        print("  %-28s %6d %8d %8s [%s; %s] %9s   %s"
              % (nome, c["n"], c["coattivi"], f(c["r"]), f(c["lo"]), f(c["hi"]), f(c["r_scartati"]), c["esito"]))
        for m in c["motivi"]:
            print("      -> %s" % m)

    print("\n--- B5 contro-prova (variante B: netto / equita' a inizio giornata) ---")
    for e in eas:
        normalizza(e)
    for a, b in par:
        c = coppia(a, b, "B")
        va = esiti[(a["etichetta"], b["etichetta"])]
        nota = ""
        if c["r"] is not None and va["r"] is not None and (c["esito"] != va["esito"]):
            nota = "   !! VERDETTO DIVERSO DALLA VARIANTE A -> la coppia e' NON MISURATA (non si sceglie la variante comoda)"
        print("  %-28s r %s  esito %s%s" % (a["etichetta"] + " / " + b["etichetta"], f(c["r"]), c["esito"], nota))

    dec, k = correlazione_decile(eas, par)
    print("\n--- B5 nei giorni che contano (il %d%% peggiore del portafoglio: %d giorni) ---" % (int(100 * DECILE), k))
    for (na, nb), (r, n) in sorted(dec.items()):
        avviso = ""
        if r is not None and r > SOGLIA_B5_SMENTITA:
            avviso = "   !! sopra %.2f PROPRIO nei giorni peggiori: in media 'scorrelati', quando serve no" % SOGLIA_B5_SMENTITA
        print("  %-28s r %s su %d giorni%s" % (na + " / " + nb, f(r), n, avviso))

    print("\n--- B6: DD DI PORTAFOGLIO (una tranche per volta: ogni mese riparte da un conto vuoto di 5.000) ---")
    p1 = portafoglio(eas, 1.0)
    pq = portafoglio(eas, 1.0 / len(eas))
    mesi_comuni = [(m["da"], m["a"]) for m in p1["mesi"]]
    singoli = [t["dd_eq_abs"] for e in eas for t in e["tranche"]
               if (t["da"], t["a"]) in mesi_comuni and t["dd_eq_abs"] is not None]
    peggiore = max(singoli or [0.0])
    limite = SOGLIA_B6_FATTORE * peggiore
    print("  TUTTO IN EUR, non in percentuale. Il DD% che il report scrive nella testa e' calcolato sul PICCO di")
    print("  equita', non sul deposito: mescolarlo con un DD in % di deposito confronta due unita' diverse (cl. 1488).")
    print("  mesi usati (tranche conforme per TUTTI gli EA): %d" % len(p1["mesi"]))
    for f_ in p1["fuori"]:
        print("    MESE FUORI (manca la tranche conforme di qualcuno): %s -> %s" % f_)
    print("  %-24s %14s %14s %10s" % ("mese", "pavimento EUR", "tetto EUR", "pav<=tetto"))
    for m in p1["mesi"]:
        ok_m = m["dd_eur"] <= m["tetto_eur"] + 1e-6
        print("  %-24s %14.2f %14.2f %10s" % ("%s -> %s" % (m["da"], m["a"]), m["dd_eur"], m["tetto_eur"],
                                              "OK" if ok_m else "VIOLATO"))
    viol = [m for m in p1["mesi"] if m["dd_eur"] > m["tetto_eur"] + 1e-6]
    pav = max(m["dd_eur"] for m in p1["mesi"])
    tet = max(m["tetto_eur"] for m in p1["mesi"])
    print("  DD di equita' del singolo PEGGIORE nei mesi usati (LETTO nel report, EUR): %.2f  -> limite B6 = %.2f"
          % (peggiore, limite))
    print("  PAVIMENTO (peso 1, realizzi giornalieri, NON vede l'intraday): %.2f EUR = %.2f%% del deposito (mese %s)"
          % (pav, 100.0 * pav / DEPOSITO_ATTESO, p1["mese_peggiore"]["da"]))
    print("  TETTO     (peso 1, i DD dello stesso mese tutti insieme)     : %.2f EUR = %.2f%% del deposito"
          % (tet, 100.0 * tet / DEPOSITO_ATTESO))
    print("  CONTROLLO per mese, il pavimento deve stare <= il tetto: %s"
          % ("OK su tutti i mesi" if not viol else
             "!! VIOLATO in %d mesi: c'e' un difetto nel calcolo, NON si legge nessun verdetto" % len(viol)))
    print("  (peso 1/%d, DOMINATO e NON FALSIFICABILE: %.2f EUR -- con quel peso il DD combinato non supera mai la"
          % (len(eas), max(m["dd_eur"] for m in pq["mesi"])))
    print("   media dei DD, che e' <= il peggiore, che e' < %.1f x il peggiore: l'ipotesi e' vera per costruzione)"
          % SOGLIA_B6_FATTORE)
    if viol:
        print("  ESITO B6: NESSUNO (il controllo pavimento <= tetto e' violato)")
    elif tet <= limite:
        print("  ESITO B6: REGGE  (regge persino il TETTO: non serve nessuna compensazione fra gli EA)")
    elif pav <= limite:
        print("  ESITO B6: NON MISURATA  (regge il pavimento %.2f EUR ma non il tetto %.2f EUR: il DD vero e'"
              % (pav, tet))
        print("            intraday e qui NON e' misurato. Su un pavimento non si compra: serve il replay M1 o gli")
        print("            EA su UN conto solo nel tester)")
    else:
        print("  ESITO B6: SMENTITA  (anche il pavimento %.2f EUR supera il limite %.2f EUR)" % (pav, limite))

    sop = SOGLIA_SOPRAVVIVENZA_PCT * DEPOSITO_ATTESO / 100.0
    print("\n--- SOPRAVVIVENZA (il cancello che B6 NON e') ---")
    print("  B6 e' RELATIVA: se un EA del gruppo ha un DD mostruoso, il limite 1,5 x diventa mostruoso con lui e")
    print("  l'ipotesi 'regge' pur descrivendo un conto morto. Quindi accanto va SEMPRE il cancello ASSOLUTO:")
    print("  tetto di DD totale %.1f%% del deposito = %.2f EUR (il Guardian sul reale, e FTMO)." % (SOGLIA_SOPRAVVIVENZA_PCT, sop))
    print("  pavimento del portafoglio: %.2f EUR = %.2f%% del deposito -> %s"
          % (pav, 100.0 * pav / DEPOSITO_ATTESO,
             "DENTRO" if pav <= sop else "SFONDATO: il conto sarebbe stato chiuso dal Guardian"))
    if pav > DEPOSITO_ATTESO:
        print("  !! il pavimento supera il DEPOSITO INTERO: il conto e' azzerato. Nessun verdetto di B6 conta.")
    if (not viol) and tet <= limite and pav > sop:
        print("  !! LETTURA OBBLIGATORIA: B6 'REGGE' ED E' IRRILEVANTE. Il gruppo non e' schierabile.")
    print("\n--- COSA NON DICONO QUESTI NUMERI ---")
    print("  - I quattro EA sono misurati OGNUNO sul suo conto da 5.000, non INSIEME su un conto solo: margine,")
    print("    lotto sul saldo condiviso, stop-out e Guardian non sono simulati. E' una combinazione SINTETICA.")
    print("  - Il giorno e' quello di CHIUSURA del deal: si misura la correlazione dei REALIZZI, non dell'esposizione.")
    print("  - Un feed solo (BCM), nessuno slippage del reale oltre alla commissione del tester.")


# --------------------------------------------------------------------------------------------------------------------
#  AUTOTEST -- i contro-esempi del documento di metodo, paragrafo 8
# --------------------------------------------------------------------------------------------------------------------
def _finto(etichetta, coppie_giorno_valore, da, a, dd=(500.0,)):   # dd in EUR
    g0 = datetime.date(*da)
    g1 = datetime.date(*a)
    e = {"etichetta": etichetta, "percorso": "(finto)", "serie": {}, "giorni_con_deal": set(),
         "tranche": [{"file": "finto", "da": g0, "a": g1, "netto": 0.0, "expert": etichetta, "simbolo": "XAUUSD",
                      "periodo": "", "dd_eq_pct": 100.0 * dd[0] / DEPOSITO_ATTESO, "dd_eq_abs": dd[0],
                      "trades": 0, "ingressi": {}}],
         "dd_tranche": [100.0 * x / DEPOSITO_ATTESO for x in dd], "dd_tranche_eur": list(dd), "da": g0, "a": g1, "netto": 0.0, "esclusi": [], "finestre": [(g0, g1)]}
    for gg, v in coppie_giorno_valore:
        e["serie"][gg] = e["serie"].get(gg, 0.0) + v
        e["giorni_con_deal"].add(gg)
        e["netto"] += v
    e["giorni"] = giorni_di_mercato(e["finestre"], e["giorni_con_deal"])
    return e


def _finto_multi(etichetta, mesi):
    """Un EA finto con PIU' tranche mensili: mesi = [(da, a, [(giorno, valore), ...], dd_pct), ...]"""
    e = {"etichetta": etichetta, "percorso": "(finto)", "serie": {}, "giorni_con_deal": set(), "tranche": [],
         "dd_tranche": [], "dd_tranche_eur": [], "netto": 0.0, "esclusi": [], "finestre": []}
    for (da, a, righe, dd) in mesi:
        g0, g1 = datetime.date(*da), datetime.date(*a)
        e["finestre"].append((g0, g1))
        e["tranche"].append({"file": "finto", "da": g0, "a": g1, "netto": sum(v for _g, v in righe),
                             "expert": etichetta, "simbolo": "XAUUSD", "periodo": "",
                             "dd_eq_pct": 100.0 * dd / DEPOSITO_ATTESO, "dd_eq_abs": dd,
                             "trades": len(righe), "ingressi": {}})
        e["dd_tranche"].append(100.0 * dd / DEPOSITO_ATTESO)
        e["dd_tranche_eur"].append(dd)
        for gg, v in righe:
            e["serie"][gg] = e["serie"].get(gg, 0.0) + v
            e["giorni_con_deal"].add(gg)
            e["netto"] += v
    e["da"], e["a"] = min(f[0] for f in e["finestre"]), max(f[1] for f in e["finestre"])
    e["giorni"] = giorni_di_mercato(e["finestre"], e["giorni_con_deal"])
    return e


def autotest():
    ok = True

    def esigi(cond, testo):
        nonlocal ok
        print(("  OK   " if cond else "  FAIL ") + testo)
        if not cond:
            ok = False

    print("AUTOTEST di correlazione_pacchetto.py -- i contro-esempi del paragrafo 8 del metodo")

    # 1. identiche -> 1 ; opposte -> -1
    base = [(datetime.date(2025, 1, 6) + datetime.timedelta(days=i), (-1) ** i * (10 + i)) for i in range(0, 120)]
    a = _finto("A", base, (2025, 1, 6), (2025, 5, 30))
    b = _finto("B", base, (2025, 1, 6), (2025, 5, 30))
    c = _finto("C", [(g, -v) for g, v in base], (2025, 1, 6), (2025, 5, 30))
    r_id = coppia(a, b)["r"]
    r_op = coppia(a, c)["r"]
    esigi(r_id is not None and abs(r_id - 1.0) < 1e-9, "(1) due serie identiche danno r = 1,000 (letto %s)" % f(r_id))
    esigi(r_op is not None and abs(r_op + 1.0) < 1e-9, "(1) due serie opposte danno r = -1,000 (letto %s)" % f(r_op))

    # 2. sparse e indipendenti, molti zeri in comune, QUALCHE giorno in comune ma pochi -> NON MISURATA,
    #    mai "scorrelate". E' il caso in cui r vicino a zero NON significa scorrelazione: significa pochi incontri.
    r1, r2 = random.Random(7), random.Random(8)
    gg = [datetime.date(2025, 1, 6) + datetime.timedelta(days=i) for i in range(0, 300)]
    sp1 = [(g, r1.choice([-30.0, 40.0])) for g in gg if r1.random() < 0.25]
    sp2 = [(g, r2.choice([-30.0, 40.0])) for g in gg if r2.random() < 0.25]
    s1 = _finto("S1", sp1, (2025, 1, 6), (2025, 11, 1))
    s2 = _finto("S2", sp2, (2025, 1, 6), (2025, 11, 1))
    c2 = coppia(s1, s2)
    esigi(0 < c2["coattivi"] < MIN_COATTIVI and c2["esito"] == "NON MISURATA",
          "(2) sparse con zeri in comune: co-attivi %d (fra 1 e %d) -> esito '%s' (mai 'scorrelate')"
          % (c2["coattivi"], MIN_COATTIVI - 1, c2["esito"]))

    # 3. giorni DISGIUNTI: scartando i non comuni il calcolo non esiste e lo strumento lo dice
    d1 = _finto("D1", [(g, 25.0) for g in gg[0:200:2]], (2025, 1, 6), (2025, 8, 1))
    d2 = _finto("D2", [(g, 25.0) for g in gg[1:200:2]], (2025, 1, 6), (2025, 8, 1))
    c3 = coppia(d1, d2)
    esigi(c3["coattivi"] == 0 and c3["r_scartati"] is None,
          "(3) giorni disgiunti: co-attivi 0 e r senza zeri = [n.d.], non 0 (letto %s)" % f(c3["r_scartati"]))
    esigi(c3["esito"] == "NON MISURATA", "(3) giorni disgiunti -> esito '%s'" % c3["esito"])

    # 4. r = 0,30 ESATTO su n=40 (abbastanza co-attivi da passare il filtro dei 30): l'intervallo bootstrap
    #    arriva sopra 0,50 -> NON MISURATA. Costruzione DETERMINISTICA, non un seme fortunato: x = cos, w = sin
    #    sullo stesso giro sono ortogonali e centrati con la stessa norma, quindi y = 0,3 x + sqrt(0,91) w da'
    #    esattamente r = 0,300. Senza la regola dell'intervallo, 0,300 verrebbe letto come "B5 REGGE".
    gp = [datetime.date(2025, 3, 3) + datetime.timedelta(days=i) for i in range(0, 49)
          if (datetime.date(2025, 3, 3) + datetime.timedelta(days=i)).weekday() < 5]
    nn = len(gp)
    xa = [100.0 * math.cos(2 * math.pi * i / nn) for i in range(nn)]
    xw = [100.0 * math.sin(2 * math.pi * i / nn) for i in range(nn)]
    xb = [0.30 * xa[i] + math.sqrt(0.91) * xw[i] for i in range(nn)]
    p1 = _finto("P1", list(zip(gp, xa)), (2025, 3, 3), (2025, 4, 20))
    p2 = _finto("P2", list(zip(gp, xb)), (2025, 3, 3), (2025, 4, 20))
    c4 = coppia(p1, p2)
    esigi(c4["r"] is not None and abs(c4["r"] - 0.30) < 1e-9,
          "(4) la costruzione da' r = 0,300 esatto su n=%d, co-attivi %d (letto %s)"
          % (c4["n"], c4["coattivi"], f(c4["r"])))
    esigi(c4["coattivi"] >= MIN_COATTIVI, "(4) co-attivi %d >= %d: il filtro degli incontri NON e' quello che "
                                          "decide qui" % (c4["coattivi"], MIN_COATTIVI))
    esigi(c4["lo"] is not None and c4["lo"] <= SOGLIA_B5_SMENTITA <= c4["hi"] and c4["esito"] == "NON MISURATA",
          "(4) intervallo al 95%% [%s; %s] contiene 0,50 -> '%s' (non 'B5 REGGE')"
          % (f(c4["lo"]), f(c4["hi"]), c4["esito"]))

    # 5. B6: il pavimento regge e il tetto no -> NON MISURATA (l'algebra del peso, paragrafo 6-bis)
    q1 = _finto("Q1", [(g, (-1) ** i * 200.0) for i, g in enumerate(gg[:100])], (2025, 1, 6), (2025, 4, 16), dd=(500.0,))
    q2 = _finto("Q2", [(g, (-1) ** (i + 1) * 200.0) for i, g in enumerate(gg[:100])], (2025, 1, 6), (2025, 4, 16), dd=(500.0,))
    pf5 = portafoglio([q1, q2], 1.0)
    pav = max(m["dd_eur"] for m in pf5["mesi"])
    tet = max(m["tetto_eur"] for m in pf5["mesi"])
    lim = SOGLIA_B6_FATTORE * 500.0
    esigi(pav <= lim < tet, "(5) pavimento %.2f EUR <= limite %.2f < tetto %.2f -> B6 NON MISURATA"
          % (pav, lim, tet))
    pq5 = max(m["dd_eur"] for m in portafoglio([q1, q2], 0.5)["mesi"])
    esigi(pq5 <= 500.0, "(5-bis) a peso 1/2 il DD combinato (%.2f EUR) non supera la media dei DD (500,00): B6 a "
                        "quel peso e' vera per costruzione" % pq5)

    # 6. gli input di TERZI si rileggono per nome dal report vero (non dal finto): si prova sullo zip di W1 se c'e'
    zp = os.path.join(os.path.dirname(os.path.abspath(__file__)), "risultati_archivio",
                      "PACCHETTO_ORO_W1_20261017", "GOLDREAPER_TESTER_TRANCHE.zip")
    if os.path.exists(zp):
        s = Sorgente(zp)
        h = [n for n in s.nomi() if n.lower().endswith(".htm")]
        ing = ingressi_generici(s.leggi(sorted(h)[0]))
        esigi("TradeFrequency" in ing, "(6) input di terzi riletti per nome dal report: TradeFrequency = %s"
              % ing.get("TradeFrequency"))
        esigi(len(ing) > 20, "(6) parametri di terzi letti: %d (il parser Inp* ne leggerebbe 0)" % len(ing))
    else:
        print("  ~    (6) saltato: lo zip di W1 non e' in questa copia del repo")

    # 7. serie costante: la correlazione NON esiste, non e' zero
    k1 = _finto("K1", [], (2025, 1, 6), (2025, 3, 7))
    k2 = _finto("K2", [(g, 10.0) for g in gg[:40]], (2025, 1, 6), (2025, 3, 7))
    esigi(coppia(k1, k2)["r"] is None, "(7) una serie tutta a zero -> r = [n.d.], mai 0,000")

    # 9. REGRESSIONE della classe 1487 (il difetto trovato dai dati veri di W1 il 17/10): tre tranche mensili con
    #    risultati grossi e alternati. Incollando i mesi in una curva continua il DD usciva 145,64% del deposito,
    #    SOPRA il suo tetto di 81,35%: impossibile. Misurando DENTRO ogni mese il pavimento deve stare sotto il
    #    tetto, sempre. Questo test fallisce se qualcuno rimette la curva continua.
    def _mese(y, m, tot, n=6):
        g = datetime.date(y, m, 1)
        gg = []
        while len(gg) < n:
            if g.weekday() < 5:
                gg.append(g)
            g += datetime.timedelta(days=1)
        fine = datetime.date(y + (1 if m == 12 else 0), 1 if m == 12 else m + 1, 1)
        return (y, m, 1), (fine.year, fine.month, fine.day), [(x, tot / n) for x in gg]
    mesi = []
    for (y, m, tot, dd) in ((2026, 7, -3072.56, 3800.0), (2026, 8, +3163.54, 13088.0), (2026, 9, -3815.57, 3900.0)):
        da, a, righe = _mese(y, m, tot)
        mesi.append((da, a, righe, dd))
    t3 = _finto_multi("T3", mesi)
    pf9 = portafoglio([t3], 1.0)
    esigi(len(pf9["mesi"]) == 3, "(9) tre tranche mensili lette come tre mesi distinti (letti %d)" % len(pf9["mesi"]))
    brutti = [m for m in pf9["mesi"] if m["dd_eur"] > m["tetto_eur"] + 1e-6]
    esigi(not brutti, "(9) in OGNI mese pavimento <= tetto: i mesi NON sono incollati (col vecchio calcolo il "
                      "pavimento usciva 145,64% del deposito, sopra il suo tetto)")
    pmax = max(m["dd_eur"] for m in pf9["mesi"])
    esigi(pmax < DEPOSITO_ATTESO, "(9) il DD di un conto da 5.000 resta sotto il deposito (%.2f EUR)" % pmax)

    # 8. il controllo aritmetico: la somma dei giorni deve dare il netto del report
    somma = sum(_finto("Z", base, (2025, 1, 6), (2025, 5, 30))["serie"].values())
    esigi(abs(somma - sum(v for _g, v in base)) < 1e-9, "(8) la somma per giorno coincide col netto delle operazioni")

    print("\nESITO AUTOTEST: " + ("TUTTO OK" if ok else "CI SONO FAIL: lo strumento NON si usa"))
    return 0 if ok else 2


def main():
    ap = argparse.ArgumentParser(description="B5 (scorrelazione) e B6 (DD di portafoglio) del Pacchetto Oro")
    ap.add_argument("sorgenti", nargs="*", help="ETICHETTA=<zip|cartella|.htm> per ogni EA")
    ap.add_argument("--autotest", action="store_true")
    a = ap.parse_args()
    if a.autotest:
        return autotest()
    if not a.sorgenti:
        ap.print_help()
        return 1
    eas = []
    for s in a.sorgenti:
        if "=" not in s:
            raise SystemExit("ERRORE: serve ETICHETTA=percorso, ricevuto '%s'" % s)
        et, perc = s.split("=", 1)
        eas.append(leggi_ea(et, perc))
    stampa(eas)
    return 0


if __name__ == "__main__":
    sys.exit(main())
