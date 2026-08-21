#!/usr/bin/env python3
# =====================================================================
#  converti_calendario_news.py
#  Dai 2 CALENDARI di biblioteca al CSV che gli EA sanno leggere.
# ---------------------------------------------------------------------
#  PERCHE' ESISTE (21/08/2026, preparazione di R93 / riga D5)
#
#  I due calendari in biblioteca e il filtro news del nostro EA
#  NON PARLANO LA STESSA LINGUA. Le colonne 2 e 3 sono SCAMBIATE:
#
#    biblioteca : data ; PAESE            ; impatto 0-3 ; evento
#    EA         : data ; impatto (High..) ; VALUTA      ; titolo
#
#  Conseguenza, misurata leggendo ABTG_FiboH4_Multi.mq5 (ImpactToInt):
#  dando il file di biblioteca all'EA cosi' com'e', l'impatto viene
#  letto dalla stringa "United States" -> ImpactToInt() torna 0 -> con
#  InpNewsMinImpact=3 NESSUNA riga blocca mai niente. Il filtro NON
#  fallisce: diventa NEUTRO IN SILENZIO, e la cella "news ON" uscirebbe
#  identica alla baseline. Sarebbe un numero FALSO
#  (CHECKLIST_RIGA_DI_LANCIO.md, difetto 31-bis).
#
#  IL FUSO -- misurato qui, non copiato
#  PIANO_PROP D1 etichetta i due CSV come "UTC+2". E' VERO SOLO D'INVERNO.
#  Misura fatta sul dato (Nonfarm Payrolls, che esce alle 08:30 New York):
#     2022.01.07 15:30 nel file -> 13:30 UTC -> file = UTC+2 (inverno)
#     2022.07.08 15:30 nel file -> 12:30 UTC -> file = UTC+3 (estate)
#  Cioe' i file sono in ORA SERVER METAQUOTES (EET/EEST, Europe/Helsinki),
#  non in un UTC+2 fisso. Chi sottrae "un'ora fissa" sbaglia di un'ora
#  per meta' anno.
#
#  Percio' questo script scrive il CSV in **UTC puro**, e la conversione
#  all'ora del server la fa l'EA con InpNewsShiftMinutes (minuti da
#  sommare). Cosi' l'offset resta UN NUMERO DICHIARATO nel file prova,
#  misurabile e spazzolabile, invece di un'assunzione sepolta in un CSV.
#
#  USO:
#    python3 backtest_pipeline/converti_calendario_news.py
#    python3 backtest_pipeline/converti_calendario_news.py --autotest
#
#  Scrive: mql5/Files/abtg_news_2021_2025_UTC.csv
# =====================================================================
from __future__ import annotations

import argparse
import os
import sys
from datetime import datetime, timedelta, timezone
from zoneinfo import ZoneInfo

RADICE = os.path.dirname(os.path.dirname(os.path.abspath(__file__)))
DIR_BIBLIO = os.path.join(RADICE, "backtest_pipeline", "caccia_strategie",
                          "biblioteca", "dati")
SORGENTI = [
    "CALENDARIO_news-2021-2024_UTC+2_cmql5-31-1257_2026-08-18.csv",
    "CALENDARIO_news-2022-2025_UTC+2_cmql5-31-1421_2026-08-18.csv",
]
USCITA = os.path.join(RADICE, "mql5", "Files", "abtg_news_2021_2025_UTC.csv")

# Il fuso VERO dei file di biblioteca (misurato sul Nonfarm Payrolls,
# vedi intestazione): ora server MetaQuotes = EET d'inverno, EEST d'estate.
TZ_SORGENTE = ZoneInfo("Europe/Helsinki")

# paese -> valuta. Serve all'esclusione PER VALUTA che chiede il corso
# ("dato sul dollaro -> si escludono i cross col dollaro, come numeratore
# o denominatore", FIBOH4_CORSO_SPEC.md par. 8).
PAESE_VALUTA = {
    "Australia": "AUD",
    "Brazil": "BRL",
    "Canada": "CAD",
    "China": "CNY",
    "Euro Zone": "EUR",
    "France": "EUR",
    "Germany": "EUR",
    "Hong Kong": "HKD",
    "India": "INR",
    "Italy": "EUR",
    "Japan": "JPY",
    "New Zealand": "NZD",
    "Russia": "RUB",
    "Singapore": "SGD",
    "South Africa": "ZAR",
    "South Korea": "KRW",
    "Spain": "EUR",
    "Switzerland": "CHF",
    "United Kingdom": "GBP",
    "United States": "USD",
}

IMPATTO_TESTO = {0: "None", 1: "Low", 2: "Medium", 3: "High"}


def leggi_sorgente(percorso: str) -> list[tuple[datetime, int, str, str]]:
    """Legge un CSV di biblioteca. Ritorna righe (dt_utc, impatto, valuta, titolo).

    Le righe che non si leggono NON spariscono in silenzio: vengono contate
    e restituite dal chiamante (difetto 28-bis della checklist: un totale
    senza il numero degli scarti non e' un totale, e' un'opinione).
    """
    righe: list[tuple[datetime, int, str, str]] = []
    scarti: list[str] = []
    with open(percorso, encoding="utf-8", errors="replace") as f:
        for n, linea in enumerate(f, 1):
            linea = linea.rstrip("\n").rstrip("\r")
            if not linea.strip():
                continue
            campi = linea.split(";")
            if len(campi) < 4:
                scarti.append(f"{os.path.basename(percorso)}:{n} campi<4")
                continue
            try:
                naive = datetime.strptime(campi[0].strip(), "%Y.%m.%d %H:%M")
            except ValueError:
                scarti.append(f"{os.path.basename(percorso)}:{n} data '{campi[0]}'")
                continue
            paese = campi[1].strip()
            valuta = PAESE_VALUTA.get(paese)
            if valuta is None:
                scarti.append(f"{os.path.basename(percorso)}:{n} paese ignoto '{paese}'")
                continue
            try:
                impatto = int(campi[2].strip())
            except ValueError:
                scarti.append(f"{os.path.basename(percorso)}:{n} impatto '{campi[2]}'")
                continue
            titolo = campi[3].strip().replace(";", ",")
            # fold=0: sull'ora ripetuta del cambio d'ora si sceglie la prima.
            # E' un caso da 1 riga l'anno e va DICHIARATO, non nascosto.
            dt_utc = naive.replace(tzinfo=TZ_SORGENTE).astimezone(timezone.utc)
            righe.append((dt_utc, impatto, valuta, titolo))
    leggi_sorgente.scarti = scarti  # type: ignore[attr-defined]
    return righe


def converti(min_impatto: int = 2, valute: set[str] | None = None) -> dict:
    tutte: list[tuple[datetime, int, str, str]] = []
    scarti_tot: list[str] = []
    per_file = {}
    for nome in SORGENTI:
        p = os.path.join(DIR_BIBLIO, nome)
        if not os.path.exists(p):
            raise SystemExit(f"SORGENTE MANCANTE: {p}")
        r = leggi_sorgente(p)
        scarti_tot.extend(leggi_sorgente.scarti)  # type: ignore[attr-defined]
        per_file[nome] = len(r)
        tutte.extend(r)

    grezze = len(tutte)
    # i due file si SOVRAPPONGONO sul 2022-2024: senza dedup lo stesso
    # evento bloccherebbe due volte e il conteggio direbbe il doppio.
    uniche = sorted(set(tutte), key=lambda x: (x[0], x[2], x[3]))
    dopo_dedup = len(uniche)

    tenute = [r for r in uniche if r[1] >= min_impatto]
    if valute:
        tenute = [r for r in tenute if r[2] in valute]

    os.makedirs(os.path.dirname(USCITA), exist_ok=True)
    with open(USCITA, "w", encoding="ascii", errors="replace", newline="") as f:
        f.write("Data Ora;Impatto;Valuta;Titolo\n")
        for dt, imp, val, tit in tenute:
            tit = "".join(ch if 32 <= ord(ch) < 127 else " " for ch in tit)
            f.write(f"{dt.strftime('%Y.%m.%d %H:%M')};{IMPATTO_TESTO[imp]};{val};{tit}\n")

    return {
        "per_file": per_file,
        "grezze": grezze,
        "dopo_dedup": dopo_dedup,
        "scritte": len(tenute),
        "scarti": scarti_tot,
        "prima": tenute[0][0] if tenute else None,
        "ultima": tenute[-1][0] if tenute else None,
        "righe": tenute,
    }


# ---------------------------------------------------------------------
#  AUTOTEST -- si esegue, non si compila. Casi che devono restare veri.
# ---------------------------------------------------------------------
def autotest() -> int:
    falliti = 0

    def caso(nome, ottenuto, atteso):
        nonlocal falliti
        ok = (ottenuto == atteso)
        if not ok:
            falliti += 1
        print(f"  [{'ok ' if ok else 'NO '}] {nome}: ottenuto={ottenuto} atteso={atteso}")

    # 1-2. il fuso, misurato sul Nonfarm Payrolls (08:30 New York)
    inv = datetime(2022, 1, 7, 15, 30).replace(tzinfo=TZ_SORGENTE).astimezone(timezone.utc)
    est = datetime(2022, 7, 8, 15, 30).replace(tzinfo=TZ_SORGENTE).astimezone(timezone.utc)
    caso("NFP gennaio -> UTC", inv.strftime("%H:%M"), "13:30")
    caso("NFP luglio  -> UTC", est.strftime("%H:%M"), "12:30")
    caso("estate e inverno NON hanno lo stesso offset",
         (inv.hour == est.hour), False)

    # 3. ogni paese dei due file ha una valuta
    paesi = set()
    for nome in SORGENTI:
        p = os.path.join(DIR_BIBLIO, nome)
        if not os.path.exists(p):
            continue
        with open(p, encoding="utf-8", errors="replace") as f:
            for linea in f:
                c = linea.split(";")
                if len(c) >= 2:
                    paesi.add(c[1].strip())
    caso("paesi senza valuta in tabella", sorted(paesi - set(PAESE_VALUTA)), [])

    # 4. la colonna 3 dei file e' davvero l'IMPATTO (0..3), non il paese
    p = os.path.join(DIR_BIBLIO, SORGENTI[1])
    livelli = set()
    if os.path.exists(p):
        with open(p, encoding="utf-8", errors="replace") as f:
            for linea in f:
                c = linea.split(";")
                if len(c) >= 3:
                    livelli.add(c[2].strip())
    caso("livelli di impatto trovati", sorted(livelli), ["0", "1", "2", "3"])

    print(f"\n  AUTOTEST: {falliti} casi falliti.")
    return falliti


def main() -> int:
    ap = argparse.ArgumentParser()
    ap.add_argument("--autotest", action="store_true")
    ap.add_argument("--min-impatto", type=int, default=2)
    ap.add_argument("--valute", default="",
                    help="filtro valute, es. USD,EUR,GBP,JPY (vuoto = tutte)")
    a = ap.parse_args()

    if a.autotest:
        return 1 if autotest() else 0

    valute = {v.strip().upper() for v in a.valute.split(",") if v.strip()} or None
    r = converti(a.min_impatto, valute)

    print("=== CONVERSIONE CALENDARIO -> FORMATO EA ===")
    for k, v in r["per_file"].items():
        print(f"  letto {k}: {v} righe")
    print(f"  righe grezze          : {r['grezze']}")
    print(f"  dopo dedup (i 2 file si sovrappongono) : {r['dopo_dedup']}")
    print(f"  scritte (impatto >= {a.min_impatto}{', valute ' + ','.join(sorted(valute)) if valute else ''}) : {r['scritte']}")
    print(f"  scarti NON convertiti : {len(r['scarti'])}")
    for s in r["scarti"][:10]:
        print(f"      {s}")
    print(f"  prima  : {r['prima']}")
    print(f"  ultima : {r['ultima']}")
    print(f"  file   : {USCITA}")
    print("  FUSO DEL FILE: UTC. L'ora del server la fa InpNewsShiftMinutes.")
    if r["scritte"] == 0:
        print("  ESITO: FALLITO -- zero righe scritte.")
        return 1
    print("  ESITO: OK")
    return 0


if __name__ == "__main__":
    sys.exit(main())
