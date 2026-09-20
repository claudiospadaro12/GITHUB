# -*- coding: ascii -*-
"""
analisi_prevolo_ftmo.py -- legge MQL5\\Files\\PREVOLO_FTMO_specifiche.csv e
risponde alle quattro luci del semaforo che oggi sono [INFERITO] o [NON NOTO].

PERCHE' ESISTE: il CSV del prevolo e' il cancello della serata FTMO. Finche'
non e' letto, l'AutoTrading resta spento. Leggerlo a mano sono trenta minuti e
tre occasioni di sbagliare un conto; leggerlo qui sono dieci secondi.

LE QUATTRO LUCI:
  S2  OROLOGIO  -- lo script MT5 il verdetto lo scrive gia' da solo. Qui lo si
                   ripete e lo si CONFRONTA con il +2 su cui sono stati
                   rimappati i dieci preset. Zero = non si tocca niente.
  S3  SIMBOLI   -- i nomi veri del broker contro i nomi dentro i nostri preset,
                   piu' i due numeri che fanno danno in silenzio:
                     Digits  -> InpBufferPoints cambia di un fattore 10
                     Spread  -> la frontiera di casa stop >= 40 x spread
  S4  MARGINE   -- quanto chiede una sedia, e quante ne regge il conto. Il
                   danno non e' lo stop-out (scatta a circa -54%): e' l'ORDINE
                   RIFIUTATO IN SILENZIO per "not enough money".
  S5  LOTTO     -- il blocco su 771531 (EMA200) e 770511 (SuperWave).

--------------------------------------------------------------------------
IL CONTO DI S5, ed e' il motivo per cui questo file esiste
--------------------------------------------------------------------------
Il binario IN CAMPO calcola la perdita per lotto dal tick nudo:
    A = (slDist / TickSize) * TickValue
Il sorgente che si compilerebbe con F7 la chiede invece al broker
(OrderCalcProfit), che per un CFD vale:
    B = slDist * ContractSize * FX(valuta_profitto -> valuta_conto)

Il RAPPORTO fra le due NON dipende dallo stop, perche' slDist si semplifica:
    B/A = (TickSize * ContractSize * FX) / TickValue

Quindi il divario si misura dal CSV DA SOLO, senza sapere dove sta lo stop di
nessuna sedia. Se il rapporto e' 1, le due formule coincidono e l'F7 non cambia
la taglia: S5 si scioglie. Se non e' 1, la taglia cambia di quel fattore, e
quella e' una firma di Claudio.

    FX: se valuta_profitto == valuta_conto, FX = 1 ed il conto e' ESATTO.
    Altrimenti FX si cerca fra i simboli del CSV. Se non si trova NON si
    inventa: si scrive il rapporto in unita' di FX e si dichiara.

USO:
    python3 backtest_pipeline/analisi_prevolo_ftmo.py PREVOLO_FTMO_specifiche.csv
    python3 backtest_pipeline/analisi_prevolo_ftmo.py --autotest
"""

import csv
import io
import os
import sys

# ---------------------------------------------------------------------
# LE SEI SEDIE SCHIERATE, col simbolo che il preset si aspetta.
# 770402 ORO non c'e' ed e' voluto: e' sospesa (SCHIERA_FTMO.ps1 r.217).
# I PostNews non ci sono: la corsa dello schieramento aveva -SenzaPostNews.
# ---------------------------------------------------------------------
SEDIE = [
    ("770101", "DAX Apertura EU",   "D30EUR", "M5"),
    ("770411", "MaxMin DAX Short",  "D30EUR", "M15"),
    ("770202", "Dow Apertura US",   "U30USD", "M5"),
    ("771531", "EMA200 Dow",        "U30USD", "H1"),
    ("770511", "SuperWave DOW",     "U30USD", "H1"),
    ("770260", "Nasdaq RETEST",     "NASUSD", "M5"),
]

# Le sedie il cui F7 tocca la formula del lotto (buco S5).
SEDIE_S5 = ("771531", "770511")

DELTA_ATTESO_ORE = 2      # FTMO = BCM + 2, su cui sono rimappati i 10 preset
FRONTIERA_SPREAD = 40     # regola di casa: stop >= 40 x spread


def leggi_sezioni(path):
    """Spezza il CSV nelle sue sezioni [OROLOGIO] [CONTO] [SIMBOLI] ...

    Il file e' scritto da FileWrite in ANSI con separatore ','; le sezioni
    sono righe che cominciano con '['.
    """
    with io.open(path, "r", encoding="latin-1", newline="") as fh:
        righe = list(csv.reader(fh))
    sezioni = {}
    corrente = "_TESTA"
    sezioni[corrente] = []
    for r in righe:
        if r and r[0].startswith("[") and r[0].endswith("]"):
            corrente = r[0][1:-1]
            sezioni.setdefault(corrente, [])
            continue
        sezioni[corrente].append(r)
    return sezioni


def campi(sezione):
    """Le sezioni [OROLOGIO] e [CONTO] sono Campo,Valore,Nota."""
    fuori = {}
    for r in sezione:
        if len(r) >= 2 and r[0] and r[0] != "Campo":
            fuori[r[0]] = r[1]
    return fuori


def simboli(sezione):
    """La sezione [SIMBOLI] ha una riga di intestazione e poi le righe."""
    if not sezione:
        return []
    testa = None
    fuori = []
    for r in sezione:
        if not r or not r[0]:
            continue
        if r[0] == "Mercato" and testa is None:
            testa = r
            continue
        if testa is None:
            continue
        d = {}
        for i, nome in enumerate(testa):
            d[nome] = r[i] if i < len(r) else ""
        fuori.append(d)
    return fuori


def num(s):
    """Un numero dal CSV, o None. Il prevolo scrive 'n.d.', '-', ed errori."""
    if s is None:
        return None
    s = s.strip().replace(" ", "")
    if not s or s in ("-", "n.d."):
        return None
    s = s.split("(")[0].strip()
    # Num() del prevolo scrive col punto decimale; ma se una cultura
    # italiana si infilasse, la virgola non deve diventare un migliaio.
    if "," in s and "." not in s:
        s = s.replace(",", ".")
    try:
        return float(s)
    except ValueError:
        return None


def trova_fx(sim, da_valuta, a_valuta):
    """Il cambio da_valuta -> a_valuta cercato fra i simboli del CSV.

    Torna (fattore, spiegazione) oppure (None, perche' non si e' trovato).
    NON si inventa: se il cambio non c'e' nel CSV, torna None.
    """
    if da_valuta == a_valuta:
        return 1.0, "stessa valuta: nessuna conversione"
    for d in sim:
        nome = (d.get("Simbolo") or "").upper()
        base = nome[:3]
        quota = nome[3:6]
        prezzo = num(d.get("Bid")) or num(d.get("Ask"))
        if prezzo is None or prezzo <= 0:
            continue
        if base == da_valuta and quota == a_valuta:
            return prezzo, "da %s (diretto, prezzo %.5f)" % (nome, prezzo)
        if base == a_valuta and quota == da_valuta:
            return 1.0 / prezzo, "da %s (inverso, prezzo %.5f)" % (nome, prezzo)
    return None, "nessun simbolo nel CSV da' il cambio %s->%s" % (da_valuta, a_valuta)


def rapporto_s5(d, valuta_conto, sim):
    """B/A = (TickSize * ContractSize * FX) / TickValue.

    Torna (rapporto, nota). rapporto None = non calcolabile, e si dice perche'.
    """
    tsize = num(d.get("TickSize"))
    tval = num(d.get("TickValue"))
    csize = num(d.get("ContractSize"))
    curp = (d.get("ValutaProfitto") or "").strip().upper()
    if not tsize or not tval or not csize:
        return None, "mancano TickSize/TickValue/ContractSize nel CSV"
    fx, comefx = trova_fx(sim, curp, valuta_conto.upper())
    if fx is None:
        base = (tsize * csize) / tval
        return None, ("rapporto = %.6f x FX(%s->%s), e FX non si misura qui: %s"
                      % (base, curp, valuta_conto, comefx))
    return (tsize * csize * fx) / tval, comefx


def referto(path):
    sez = leggi_sezioni(path)
    oro = campi(sez.get("OROLOGIO", []))
    conto = campi(sez.get("CONTO", []))
    sim = simboli(sez.get("SIMBOLI", []))
    out = []

    def dillo(s=""):
        out.append(s)

    dillo("=" * 70)
    dillo("  PREVOLO FTMO -- le quattro luci del semaforo")
    dillo("=" * 70)

    testa = sez.get("_TESTA", [])
    for r in testa:
        if len(r) >= 2 and "data" in (r[0] or "").lower():
            dillo("  data del CSV : %s   <-- se non e' di ADESSO, e' un file vecchio" % r[1])

    # ---------------- S2 OROLOGIO ----------------
    dillo()
    dillo("S2  OROLOGIO")
    delta = num(oro.get("DeltaServerGMT_ore"))
    scarto = oro.get("Scarto_vs_atteso_hhmm", "")
    dillo("    server - GMT        : %s  (%s)" % (oro.get("DeltaServerGMT_hhmm", "?"),
                                                  oro.get("DeltaServerGMT_ore", "?")))
    dillo("    mercato aperto      : %s" % oro.get("MercatoAperto", "?"))
    dillo("    scarto vs atteso    : %s" % scarto)
    dillo("    verdetto dello script: %s" % oro.get("VERDETTO_OROLOGIO", "?"))
    if oro.get("MercatoAperto") == "NO":
        dillo("    ATTENZIONE: a mercato chiuso TimeCurrent e' il timestamp dell'ultimo")
        dillo("    tick. Lo script usa TimeTradeServer, che vale lo stesso -- ma la")
        dillo("    lettura piu' sicura si fa a mercato aperto (classe 479).")
    if scarto.strip() in ("00:00", "+00:00", "0:00"):
        dillo("    => I DIECI PRESET NON SI TOCCANO: il rimappaggio +%d e' giusto." % DELTA_ATTESO_ORE)
    else:
        dillo("    => SCARTO NON ZERO: i preset sono rimappati su BCM+%d. Se questo" % DELTA_ATTESO_ORE)
        dillo("       scarto non e' zero, TUTTI gli InpSessionHour sono spostati.")
        dillo("       NON si aggiusta a occhio: e' una firma di Claudio.")

    # ---------------- CONTO ----------------
    valuta = (conto.get("Valuta") or "").strip() or "?"
    saldo = num(conto.get("Saldo")) or 0.0
    leva = conto.get("Leva", "?")
    dillo()
    dillo("    conto %s  %s  saldo %.2f %s  leva %s" % (
        conto.get("Conto", "?"), conto.get("TipoConto", "?"), saldo, valuta, leva))

    # ---------------- S3 SIMBOLI ----------------
    dillo()
    dillo("S3  SIMBOLI -- i nomi veri contro quelli dentro i preset")
    per_nome = {}
    for d in sim:
        per_nome[(d.get("Simbolo") or "").upper()] = d
    attesi = sorted(set(s[2] for s in SEDIE))
    mancanti = []
    for a in attesi:
        d = per_nome.get(a.upper())
        if d and (d.get("Stato") or "").upper() == "TROVATO":
            dillo("    OK       %-8s esiste sul broker con questo nome" % a)
        else:
            mancanti.append(a)
            dillo("    DA FARE  %-8s NON esiste con questo nome: il preset va corretto" % a)
    if mancanti:
        dillo("    Candidati presenti sul broker (per aiutare la scelta):")
        for d in sim:
            st = (d.get("Stato") or "").upper()
            if st in ("TROVATO", "CANDIDATO"):
                dillo("      %-12s %s" % (d.get("Simbolo", ""), d.get("Descrizione", "")))

    dillo()
    dillo("    le due trappole silenziose:")
    for d in sim:
        if (d.get("Stato") or "").upper() not in ("TROVATO", "CANDIDATO"):
            continue
        s = d.get("Simbolo", "")
        dig = num(d.get("Digits"))
        spr = num(d.get("SpreadPts"))
        vmax = num(d.get("VolMax"))
        vmin = num(d.get("VolMin"))
        vstep = num(d.get("VolStep"))
        riga = "      %-12s Digits=%s  Spread=%spt  VolMin/Max/Step=%s/%s/%s" % (
            s,
            "?" if dig is None else int(dig),
            "?" if spr is None else int(spr),
            vmin, vmax, vstep)
        dillo(riga)
        if dig is not None and int(dig) != 2 and s.upper() in ("U30USD", "US30"):
            dillo("        ATTENZIONE Digits != 2: InpBufferPoints cambia di un fattore 10.")
        if spr:
            dillo("        frontiera di casa: lo stop deve essere >= %d x spread = %d punti"
                  % (FRONTIERA_SPREAD, int(FRONTIERA_SPREAD * spr)))

    # ---------------- S4 MARGINE ----------------
    dillo()
    dillo("S4  MARGINE -- il danno non e' lo stop-out, e' l'ordine rifiutato in silenzio")
    totale = 0.0
    noti = 0
    for magic, nome, simb, tf in SEDIE:
        d = per_nome.get(simb.upper())
        m = num(d.get("Margine1Lotto")) if d else None
        if m is None:
            dillo("    %-6s %-18s %-8s margine 1 lotto: n.d." % (magic, nome, simb))
        else:
            dillo("    %-6s %-18s %-8s margine 1 lotto: %10.2f %s" % (magic, nome, simb, m, valuta))
            totale += m
            noti += 1
    if noti:
        dillo("    somma per 1 lotto su %d sedie su %d: %.2f %s" % (noti, len(SEDIE), totale, valuta))
        if saldo > 0:
            dillo("    = %.1f%% del saldo, PER UN LOTTO A SEDIA." % (100.0 * totale / saldo))
            dillo("    NOTA: il lotto vero lo decide InpRiskPercent=2.00 e la distanza")
            dillo("    dello stop, che qui NON e' misurata. Questo numero e' il righello,")
            dillo("    non la taglia: serve a vedere se l'ordine di grandezza regge.")

    # ---------------- S5 LOTTO ----------------
    dillo()
    dillo("S5  LOTTO -- il blocco su 771531 (EMA200) e 770511 (SuperWave)")
    dillo("    rapporto fra le due formule della perdita per lotto.")
    dillo("    1.000000 = l'F7 NON cambia la taglia, il blocco si scioglie.")
    visti = set()
    for magic, nome, simb, tf in SEDIE:
        if magic not in SEDIE_S5:
            continue
        if simb in visti:
            continue
        visti.add(simb)
        d = per_nome.get(simb.upper())
        if not d:
            dillo("    %-8s simbolo non nel CSV: non calcolabile." % simb)
            continue
        r, nota = rapporto_s5(d, valuta, sim)
        if r is None:
            dillo("    %-8s NON CALCOLABILE: %s" % (simb, nota))
            continue
        dillo("    %-8s rapporto B/A = %.6f   (%s)" % (simb, r, nota))
        if abs(r - 1.0) < 0.005:
            dillo("        => le due formule coincidono entro lo 0,5%.")
            dillo("           S5 SI SCIOGLIE: l'F7 non cambia la taglia.")
        else:
            dillo("        => DIVERGONO del %.2f%%. L'F7 cambierebbe la taglia di questo" % (100.0 * (r - 1.0)))
            dillo("           fattore. NON si schiera: e' una firma di Claudio.")

    dillo()
    dillo("=" * 70)
    return "\n".join(out)


# =====================================================================
# AUTOTEST -- i contro-esempi, costruiti per FARLO SBAGLIARE.
# =====================================================================
def _csv_finto(righe):
    buf = io.StringIO()
    w = csv.writer(buf, lineterminator="\n")
    for r in righe:
        w.writerow(r)
    return buf.getvalue()


def autotest():
    esiti = []

    def prova(nome, ok, dettaglio=""):
        esiti.append((nome, ok, dettaglio))

    # 1. num() non deve leggere "n.d." come numero
    prova("num('n.d.') e' None", num("n.d.") is None)
    prova("num('-') e' None", num("-") is None)
    prova("num('') e' None", num("") is None)
    # 2. num() deve tollerare la nota fra parentesi che il prevolo scrive
    prova("num('3067.00 (da SYMBOL_MARGIN_INITIAL)')", num("3067.00 (da SYMBOL_MARGIN_INITIAL)") == 3067.0)
    # 3. num() non deve inciampare su 'errore 4756'
    prova("num('errore 4756') e' None", num("errore 4756") is None)

    # 4. IL CONTRO-ESEMPIO CENTRALE di S5: un simbolo SANO deve dare 1.0
    #    Dow: TickSize 0.01, ContractSize 1, TickValue 0.01, profitto USD,
    #    conto USD -> B/A = (0.01*1*1)/0.01 = 1
    sano = {"TickSize": "0.01", "ContractSize": "1", "TickValue": "0.01",
            "ValutaProfitto": "USD"}
    r, _ = rapporto_s5(sano, "USD", [])
    prova("simbolo sano -> rapporto 1.0", r is not None and abs(r - 1.0) < 1e-9,
          "ottenuto %s" % r)

    # 5. E IL CONTRO-ESEMPIO CHE CONTA: un tick value NON convertito su conto
    #    EUR. TickValue e' in USD (0.01) ma il conto e' in EUR. Con EURUSD a
    #    1.10, un euro vale 1.10 dollari, quindi FX(USD->EUR) = 1/1.10.
    #    B/A = (0.01*1*0.909091)/0.01 = 0.909091 -> DEVE divergere.
    eurusd = [{"Simbolo": "EURUSD", "Bid": "1.10000", "Ask": "1.10002"}]
    r2, nota2 = rapporto_s5(sano, "EUR", eurusd)
    prova("tick value non convertito su conto EUR -> diverge",
          r2 is not None and abs(r2 - (1.0 / 1.1)) < 1e-6,
          "ottenuto %s (%s)" % (r2, nota2))

    # 6. Se il cambio NON c'e' nel CSV, NON si inventa
    r3, nota3 = rapporto_s5(sano, "EUR", [])
    prova("cambio assente -> None e lo dice", r3 is None and "non si misura" in nota3,
          nota3)

    # 7. trova_fx sul verso inverso
    fx, _ = trova_fx([{"Simbolo": "EURUSD", "Bid": "1.25", "Ask": "1.25"}], "USD", "EUR")
    prova("trova_fx inverso USD->EUR con EURUSD 1.25 = 0.8", abs(fx - 0.8) < 1e-9)

    # 8. le sezioni si spezzano bene, e una riga ASSENTE non rompe niente
    testo = _csv_finto([
        ["ABTG_PREVOLO_FTMO_SPECIFICHE", "v1"],
        ["data", "2026.09.20 21:00:00"],
        ["[OROLOGIO]"],
        ["Campo", "Valore", "Nota"],
        ["DeltaServerGMT_hhmm", "+03:00", "x"],
        ["DeltaServerGMT_ore", "3.00", "x"],
        ["MercatoAperto", "SI", "x"],
        ["Scarto_vs_atteso_hhmm", "00:00", "x"],
        ["VERDETTO_OROLOGIO", "COMBACIA", "x"],
        ["[CONTO]"],
        ["Campo", "Valore", "Nota"],
        ["Conto", "541452707", "x"],
        ["TipoConto", "DEMO", "x"],
        ["Valuta", "USD", "x"],
        ["Saldo", "100000.00", "x"],
        ["Leva", "1:100", "x"],
        ["[SIMBOLI]"],
        ["Mercato", "Simbolo", "Stato", "Descrizione", "Digits", "Point", "TickSize",
         "TickValue", "ContractSize", "VolMin", "VolMax", "VolStep", "Margine1Lotto",
         "MargineIniziale", "ValutaMargine", "StopsLevelPts", "FreezeLevelPts",
         "SpreadPts", "SpreadTipo", "ValutaProfitto", "ModoCalcoloMargine",
         "ModoTrading", "InMarketWatch", "Bid", "Ask", "Percorso"],
        ["DOW", "U30USD", "TROVATO", "Dow Jones", "2", "0.01", "0.01", "0.01", "1",
         "0.01", "50", "0.01", "460.00", "0", "USD", "0", "0", "30", "FLOTTANTE",
         "USD", "SYMBOL_CALC_MODE_CFD", "SYMBOL_TRADE_MODE_FULL", "SI", "46000.00",
         "46000.30", "CFD\\Indici"],
        ["DAX", "D30EUR", "ASSENTE", "NESSUN CANDIDATO", "-", "-", "-", "-", "-",
         "-", "-", "-", "-", "-", "-", "-", "-", "-", "-", "-", "-", "-", "-",
         "-", "-", "-"],
        ["[FINE]", "righe simbolo: 2"],
    ])
    tmp = os.path.join(os.path.dirname(os.path.abspath(__file__)), "_autotest_prevolo.csv")
    with io.open(tmp, "w", encoding="latin-1", newline="") as fh:
        fh.write(testo)
    try:
        r = referto(tmp)
    finally:
        os.remove(tmp)
    prova("il referto gira su un CSV con una riga ASSENTE", "DA FARE  D30EUR" in r)
    prova("riconosce il simbolo trovato", "OK       U30USD" in r)
    prova("scarto 00:00 -> non si tocca niente", "NON SI TOCCANO" in r)
    prova("S5 su U30USD sano si scioglie", "S5 SI SCIOGLIE" in r)
    prova("il margine del Dow e' letto", "460.00" in r)
    # 9. il conto della frontiera di spread: 40 x 30 = 1200
    prova("frontiera spread 40 x 30 = 1200", "1200 punti" in r)

    print("=" * 62)
    print("  AUTOTEST analisi_prevolo_ftmo.py")
    print("=" * 62)
    bocciati = 0
    for nome, ok, det in esiti:
        print("  %s  %s%s" % ("OK  " if ok else "FAIL", nome, ("   -> " + det) if (det and not ok) else ""))
        if not ok:
            bocciati += 1
    print("-" * 62)
    print("  %d su %d" % (len(esiti) - bocciati, len(esiti)))
    return 0 if bocciati == 0 else 1


def main(argv):
    if len(argv) >= 2 and argv[1] == "--autotest":
        return autotest()
    if len(argv) < 2:
        print(__doc__)
        return 2
    path = argv[1]
    if not os.path.exists(path):
        print("non trovo il file: %s" % path)
        return 2
    print(referto(path))
    return 0


if __name__ == "__main__":
    sys.exit(main(sys.argv))
