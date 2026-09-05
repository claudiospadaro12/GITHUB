#!/usr/bin/env python3
# -*- coding: utf-8 -*-
"""
misura_slippage.py - MISURA LA DISTRIBUZIONE DELLO SLIPPAGE SUGLI STOP

Proposta P7 del dossier CONFIG_PROP_SPREAD_SLIPPAGE_2026-09-05.md.

IL PRINCIPIO (canale gia' collaudato in R109_INDAGINE_DEAL_2026-08-26):
  nel report .htm dello Strategy Tester, la tabella "Affari" (Deals, il report
  e' in italiano) contiene su OGNI deal di uscita:
    - colonna "Prezzo"   -> il prezzo REALMENTE ESEGUITO
    - colonna "Commento" -> "sl <livello>" oppure "tp <livello>", cioe' il
                            LIVELLO RICHIESTO che ha fatto scattare l'uscita
  Le due cose insieme danno lo SCARTO, in punti indice, senza bisogno di
  nessun dato aggiuntivo. E' l'unico posto in casa dove il livello richiesto
  e il prezzo eseguito stanno sulla stessa riga: i CSV per-trade degli EA
  (close_time;symbol;magic;position_id;deal_type;volume;price;net_profit)
  hanno solo il prezzo ESEGUITO, quindi da soli NON bastano.

CONVENZIONE DEL SEGNO (dichiarata, perche' senza non si legge niente):
  scarto > 0  = SFAVOREVOLE  (riempito PEGGIO del livello richiesto)
  scarto < 0  = favorevole   (riempito MEGLIO: succede, va contato)
  Il deal di uscita "sell" chiude un LONG  -> sfav = livello - eseguito
  Il deal di uscita "buy"  chiude uno SHORT -> sfav = eseguito - livello

UNITA': punti INDICE (i prezzi nel report sono gia' in punti indice).
  Conversione di casa MISURATA: 1 punto indice = 100 punti MT5
  (ABTG_SpreadOrario.mq5:57, valida sui tre indici).

LIMITE DA DICHIARARE SEMPRE (non e' un dettaglio):
  questo misura lo slippage DEL TESTER a tick reali, cioe' il GAP fra il
  livello di stop e il primo tick che lo attraversa. NON contiene la coda di
  esecuzione del broker (latenza, coda, riprezzatura). E' quindi un
  PAVIMENTO della distribuzione vera, non la distribuzione vera.
  Sul reale lo slippage puo' solo essere >= a questo.

USO:
  python3 backtest_pipeline/misura_slippage.py <file_o_cartella> [...]
  python3 backtest_pipeline/misura_slippage.py --auto     # cerca in tutto il repo
Opzioni:
  --csv <path>   scrive anche il dettaglio riga per riga (un rigo per uscita)
"""

import os
import re
import sys
import glob
import math

# ---------------------------------------------------------------------------
# 1. LETTURA DEL REPORT .htm
# ---------------------------------------------------------------------------

# I report del tester MT5 sono in UTF-16. Si prova in ordine e si tiene il
# primo che produce un testo che contiene i marcatori attesi.
CODIFICHE = ("utf-16", "utf-16-le", "utf-8", "cp1252")


def leggi_htm(path):
    """Restituisce il testo del report, provando le codifiche note."""
    for enc in CODIFICHE:
        try:
            with open(path, encoding=enc, errors="strict") as fh:
                testo = fh.read()
        except (UnicodeDecodeError, UnicodeError):
            continue
        if "<table" in testo.lower() or "<tr" in testo.lower():
            return testo
    # ultima spiaggia: lettura tollerante
    with open(path, encoding="utf-16", errors="replace") as fh:
        return fh.read()


# nome del simbolo e dell'expert, per etichettare le righe
RE_SIMBOLO = re.compile(r"Simbolo:.*?<b>(.*?)</b>", re.S)
RE_SYMBOL_EN = re.compile(r"Symbol:.*?<b>(.*?)</b>", re.S)
RE_EXPERT = re.compile(r"Expert:.*?<b>(.*?)</b>", re.S)

RE_RIGA = re.compile(r"<tr[^>]*>(.*?)</tr>", re.S | re.I)
RE_CELLA = re.compile(r"<t[dh][^>]*>(.*?)</t[dh]>", re.S | re.I)
RE_TAG = re.compile(r"<[^>]+>")

# il commento che MT5 mette sul deal di uscita quando scatta uno stop o un take
RE_LIVELLO = re.compile(r"^\s*(sl|tp)\s+([0-9]+(?:[.,][0-9]+)?)\s*$", re.I)

RE_ORA = re.compile(r"^\d{4}\.\d{2}\.\d{2} \d{2}:\d{2}:\d{2}$")


def _pulisci(cella):
    testo = RE_TAG.sub("", cella)
    testo = testo.replace("&nbsp;", " ").replace("&amp;", "&")
    # il report separa le migliaia con lo spazio unificatore
    testo = testo.replace(" ", " ")
    return testo.strip()


def _numero(testo):
    """'19 396.20' -> 19396.20 ; '' -> None"""
    t = testo.replace(" ", "").replace(" ", "").replace(",", ".")
    if t in ("", "-"):
        return None
    try:
        return float(t)
    except ValueError:
        return None


def estrai_uscite(path):
    """
    Estrae dalla tabella 'Affari' / 'Deals' tutte le uscite chiuse da uno
    stop o da un take, con livello richiesto e prezzo eseguito.

    Ritorna (lista_di_dict, diagnostica_dict).

    NOTA SULL'ORDINE (lezione R109_INDAGINE_DEAL): i deal si leggono
    NELL'ORDINE NATIVO DEL FILE, che e' l'ordine di ticket, cioe' cronologico
    e SENZA PARI. Qui non si ordina niente, apposta: e' esattamente il
    Sort-Object su chiave con pari che nel driver R109 aveva prodotto 34 false
    anomalie. Ogni riga e' comunque autosufficiente (livello + eseguito sulla
    stessa riga), quindi l'ordine non ci serve nemmeno.
    """
    testo = leggi_htm(path)

    m = RE_SIMBOLO.search(testo) or RE_SYMBOL_EN.search(testo)
    simbolo_report = _pulisci(m.group(1)) if m else ""
    # il campo Simbolo del report e' spesso "D30EUR (Germany 40 Index)"
    simbolo_report = simbolo_report.split("(")[0].strip()
    m = RE_EXPERT.search(testo)
    expert = _pulisci(m.group(1)) if m else ""

    uscite = []
    diag = {
        "file": path,
        "expert": expert,
        "simbolo_report": simbolo_report,
        "righe_deal": 0,
        "uscite_sl": 0,
        "uscite_tp": 0,
        "uscite_altro": 0,
        "scartate_no_livello": 0,
        "scartate_no_prezzo": 0,
    }

    for mrow in RE_RIGA.finditer(testo):
        celle = [_pulisci(c) for c in RE_CELLA.findall(mrow.group(1))]
        # la riga di un deal ha 13 colonne:
        # Ora|Affare|Simbolo|Tipo|Direzione|Volume|Prezzo|Ordine|Commissioni|
        # Swap|Profitto|Bilancio|Commento
        if len(celle) < 13:
            continue
        if not RE_ORA.match(celle[0]):
            continue
        direzione = celle[4].lower()
        if direzione not in ("out", "in", "in/out"):
            continue
        diag["righe_deal"] += 1
        if direzione != "out":
            continue

        commento = celle[12]
        mliv = RE_LIVELLO.match(commento)
        if not mliv:
            # uscita per logica dell'EA (chiusura a mercato) o chiusura
            # d'ufficio a fine test: qui NON c'e' un livello richiesto, quindi
            # non e' misurabile. Va contata, non buttata in silenzio.
            diag["uscite_altro"] += 1
            diag["scartate_no_livello"] += 1
            continue

        tipo_livello = mliv.group(1).lower()
        livello = _numero(mliv.group(2))
        eseguito = _numero(celle[6])
        if livello is None or eseguito is None:
            diag["scartate_no_prezzo"] += 1
            continue

        tipo_deal = celle[3].lower()          # buy / sell
        if tipo_deal == "sell":
            lato = "long"                      # un sell che CHIUDE = era long
            sfav = livello - eseguito
        elif tipo_deal == "buy":
            lato = "short"
            sfav = eseguito - livello
        else:
            diag["scartate_no_prezzo"] += 1
            continue

        if tipo_livello == "sl":
            diag["uscite_sl"] += 1
        else:
            diag["uscite_tp"] += 1

        data, ora = celle[0].split(" ")
        uscite.append({
            "file": os.path.basename(path),
            "expert": expert,
            "ora_piena": celle[0],
            "data": data,
            "ora": int(ora.split(":")[0]),      # ORA SERVER (il report e' in ora server)
            "simbolo": celle[2] or simbolo_report,
            "lato": lato,
            "uscita": tipo_livello,             # sl | tp
            "livello_richiesto": livello,
            "prezzo_eseguito": eseguito,
            "volume": _numero(celle[5]),
            "profitto": _numero(celle[10]),
            "scarto_sfav": sfav,                # punti INDICE, >0 = peggio
        })

    return uscite, diag


# ---------------------------------------------------------------------------
# 2. STATISTICA
# ---------------------------------------------------------------------------

def percentile(valori_ordinati, p):
    """Percentile lineare (stesso metodo usato per lo spread il 03/09)."""
    if not valori_ordinati:
        return float("nan")
    if len(valori_ordinati) == 1:
        return valori_ordinati[0]
    k = (len(valori_ordinati) - 1) * p / 100.0
    f = math.floor(k)
    c = math.ceil(k)
    if f == c:
        return valori_ordinati[int(k)]
    return valori_ordinati[f] * (c - k) + valori_ordinati[c] * (k - f)


def statistiche(valori):
    v = sorted(valori)
    n = len(v)
    if n == 0:
        return None
    return {
        "n": n,
        "media": sum(v) / n,
        "mediana": percentile(v, 50),
        "p75": percentile(v, 75),
        "p90": percentile(v, 90),
        "p95": percentile(v, 95),
        "p99": percentile(v, 99),
        "max": v[-1],
        "min": v[0],
        # quante uscite sono state riempite PEGGIO del livello richiesto
        "quota_sfav": sum(1 for x in v if x > 1e-9) / n,
        "quota_esatte": sum(1 for x in v if abs(x) <= 1e-9) / n,
    }


def riga_tabella(etichetta, s):
    return ("| {et} | {n} | {med:.2f} | {p90:.2f} | {p95:.2f} | {p99:.2f} | "
            "{mx:.2f} | {qs:.0f}% |").format(
        et=etichetta, n=s["n"], med=s["mediana"], p90=s["p90"],
        p95=s["p95"], p99=s["p99"], mx=s["max"], qs=100 * s["quota_sfav"])


INTESTAZIONE = ("| gruppo | n | mediana | P90 | P95 | P99 | max | % sfav |\n"
                "|---|---:|---:|---:|---:|---:|---:|---:|")


# ---------------------------------------------------------------------------
# 3. MAIN
# ---------------------------------------------------------------------------

def raccogli_file(argomenti):
    file_htm = []
    for a in argomenti:
        if os.path.isdir(a):
            for est in ("htm", "html"):
                file_htm += glob.glob(os.path.join(a, "**", "*." + est),
                                      recursive=True)
        elif os.path.isfile(a):
            file_htm.append(a)
    return sorted(set(file_htm))


def main(argv):
    argomenti = [a for a in argv[1:] if not a.startswith("--")]
    csv_out = None
    if "--csv" in argv:
        csv_out = argv[argv.index("--csv") + 1]
        argomenti = [a for a in argomenti if a != csv_out]
    if "--auto" in argv or not argomenti:
        radice = os.path.dirname(os.path.dirname(os.path.abspath(__file__)))
        argomenti = [radice]

    file_htm = raccogli_file(argomenti)
    if not file_htm:
        print("Nessun report .htm trovato.")
        return 1

    tutte = []
    diagnostiche = []
    for f in file_htm:
        try:
            u, d = estrai_uscite(f)
        except Exception as exc:            # noqa: BLE001 - va detto, non nascosto
            print("ERRORE su %s: %s" % (f, exc))
            continue
        if d["righe_deal"] == 0:
            continue                        # non e' un report del tester
        tutte += u
        diagnostiche.append(d)

    # -------- controllo positivo: il canale risponde? --------
    print("=" * 72)
    print("CONTROLLO POSITIVO - cosa ha letto il parser")
    print("=" * 72)
    for d in diagnostiche:
        print("%-58s deal=%5d  sl=%4d  tp=%4d  altro=%4d"
              % (os.path.basename(d["file"]), d["righe_deal"], d["uscite_sl"],
                 d["uscite_tp"], d["uscite_altro"]))
    print("TOTALE uscite misurabili: %d" % len(tutte))
    if not tutte:
        print("Nessuna uscita con livello richiesto: niente da misurare.")
        return 1

    sl = [u for u in tutte if u["uscita"] == "sl"]
    tp = [u for u in tutte if u["uscita"] == "tp"]

    print()
    print("=" * 72)
    print("SLIPPAGE SUGLI STOP LOSS - punti INDICE (>0 = riempito PEGGIO)")
    print("=" * 72)
    print(INTESTAZIONE)
    s = statistiche([u["scarto_sfav"] for u in sl])
    if s:
        print(riga_tabella("TUTTI GLI SL", s))
    for sim in sorted({u["simbolo"] for u in sl}):
        for lato in ("long", "short", None):
            sel = [u["scarto_sfav"] for u in sl if u["simbolo"] == sim
                   and (lato is None or u["lato"] == lato)]
            st = statistiche(sel)
            if st:
                print(riga_tabella("%s %s" % (sim, lato or "TOT"), st))

    print()
    print("PER ORA SERVER (solo SL)")
    print(INTESTAZIONE)
    for sim in sorted({u["simbolo"] for u in sl}):
        for h in range(24):
            sel = [u["scarto_sfav"] for u in sl
                   if u["simbolo"] == sim and u["ora"] == h]
            st = statistiche(sel)
            if st:
                print(riga_tabella("%s h%02d" % (sim, h), st))

    if tp:
        print()
        print("=" * 72)
        print("SCARTO SUI TAKE PROFIT - controllo di simmetria")
        print("=" * 72)
        print(INTESTAZIONE)
        st = statistiche([u["scarto_sfav"] for u in tp])
        print(riga_tabella("TUTTI I TP", st))
        for sim in sorted({u["simbolo"] for u in tp}):
            sel = [u["scarto_sfav"] for u in tp if u["simbolo"] == sim]
            print(riga_tabella(sim, statistiche(sel)))

    # -------- le code, che sono il numero che decide --------
    print()
    print("=" * 72)
    print("LE DIECI PEGGIORI SCIVOLATE SUGLI SL")
    print("=" * 72)
    for u in sorted(sl, key=lambda x: -x["scarto_sfav"])[:10]:
        print("%s | %-7s %-5s | sl %10.2f -> eseguito %10.2f | scarto %7.2f "
              "pti indice | vol %6.1f | profitto %10.2f"
              % (u["ora_piena"], u["simbolo"], u["lato"],
                 u["livello_richiesto"], u["prezzo_eseguito"],
                 u["scarto_sfav"], u["volume"] or 0, u["profitto"] or 0))

    if csv_out:
        with open(csv_out, "w", encoding="utf-8") as fh:
            campi = ["file", "expert", "ora_piena", "data", "ora", "simbolo",
                     "lato", "uscita", "livello_richiesto", "prezzo_eseguito",
                     "volume", "profitto", "scarto_sfav"]
            fh.write(";".join(campi) + "\n")
            for u in tutte:
                fh.write(";".join(str(u[c]) for c in campi) + "\n")
        print("\nDettaglio riga per riga scritto in: %s" % csv_out)

    return 0


if __name__ == "__main__":
    sys.exit(main(sys.argv))
