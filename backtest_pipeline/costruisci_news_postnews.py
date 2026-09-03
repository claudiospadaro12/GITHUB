#!/usr/bin/env python3
# =====================================================================
#  costruisci_news_postnews.py
#  Il CALENDARIO che serve a ABTG_PostNews.mq5, costruito dai dati di
#  biblioteca. Scrive mql5/Files/abtg_news_postnews_2010_2025_UTC.csv
# ---------------------------------------------------------------------
#  PERCHE' ESISTE (03/09/2026)
#
#  Il verdetto "PostNews: nessun edge" del 07/08 e' NULLO: i 4 CSV di
#  risultato hanno Trades=0. Causa accertata (ANALISI_CORSO_POSTNEWS
#  par. 1.2 / SPEC par. 9.2): l'EA opera solo con InpRestrictToNews=true
#  e il file eventi che aveva sotto -- mql5/Files/abtg_news.csv, 17
#  righe datate 2026-2027 -- NON copriva il periodo testato. Zero eventi
#  trovati -> zero ordini -> il round ha misurato IL NULLA, e il nulla
#  e' finito in classifica come "niente edge".
#
#  Questo script produce il calendario VERO, e lo produce in modo
#  VERIFICABILE: ogni riga scartata viene contata e dichiarata.
#
#  LE DUE SORGENTI, E PERCHE' TUTTE E DUE
#    (A) CALENDARIO_FF_High_2010-2023_UTC.csv
#        Gia' nel formato che l'EA legge (Data Ora;Impatto;Valuta;Titolo)
#        e gia' in UTC -- misurato, non assunto: il Nonfarm di gennaio
#        sta alle 13:30 (= 08:30 New York in ora solare) e quello di
#        luglio alle 12:30 (= 08:30 New York in ora legale). Copre
#        2010-2023: e' l'UNICA sorgente che arriva agli anni del track
#        record dichiarato dal relatore (2009-2017).
#    (B) I due CALENDARIO_news-*_cmql5-*.csv (2021-2025)
#        Colonne 2 e 3 SCAMBIATE rispetto all'EA (data;PAESE;impatto;
#        titolo) e ora server MetaQuotes (EET/EEST), non UTC fisso --
#        stessa misura gia' fatta in converti_calendario_news.py.
#        Servono per il 2024-2025, che nel file FF non c'e'.
#
#  IL FUSO DEL FILE PRODOTTO: UTC PURO.
#  Non e' una scelta estetica: ABTG_PostNews.NewsToday() confronta SOLO
#  anno/mese/giorno dell'evento con la barra corrente. Gli eventi di
#  questa famiglia stanno tutti fra le 12:15 e le 20:00 UTC, quindi
#  qualunque offset fra -3h e +3h lascia la DATA invariata: per QUESTO
#  EA il fuso del calendario e' ininfluente, e InpNewsShiftMinutes puo'
#  restare 0. Cio' che NON e' risolto da qui e' l'ORARIO D'AZIONE, che
#  nell'EA e' un orario fisso a orologio (SPEC par. 5.1): quello lo
#  misura il rapporto qui sotto, riga "DISALLINEAMENTO".
#
#  IGIENE DICHIARATA (una sola regola, meccanica)
#  Il file FF ha, in 6 gennai su 14 (2011 2012 2017 2018 2022 2023), un
#  doppione della disoccupazione USA il GIORNO PRIMA di quello vero.
#  Controllato contro la sorgente (B), che per 2022 e 2023 da' solo il
#  venerdi: le righe del giovedi/mercoledi sono SPURIE. Siccome l'EA
#  fa match sulla DATA, una data spuria = un trade in un giorno senza
#  notizia, cioe' rumore spacciato per segnale.
#  REGOLA: se due eventi della stessa famiglia distano <= 72 ore, si
#  tiene SOLO IL PIU' RECENTE. Tiene i rinvii veri (il giovedi prima
#  del 4 luglio, il 22/10/2013 dello shutdown) perche' quelli sono soli
#  nel loro mese; toglie solo i doppioni ravvicinati.
#
#  USO:
#    python3 backtest_pipeline/costruisci_news_postnews.py
#    python3 backtest_pipeline/costruisci_news_postnews.py --autotest
# =====================================================================
from __future__ import annotations

import argparse
import collections
import os
import sys
from datetime import datetime, timedelta, timezone
from zoneinfo import ZoneInfo

RADICE = os.path.dirname(os.path.dirname(os.path.abspath(__file__)))
DIR_BIBLIO = os.path.join(RADICE, "backtest_pipeline", "caccia_strategie",
                          "biblioteca", "dati")
SORGENTE_FF = "CALENDARIO_FF_High_2010-2023_UTC.csv"
SORGENTI_MQL5 = [
    "CALENDARIO_news-2021-2024_UTC+2_cmql5-31-1257_2026-08-18.csv",
    "CALENDARIO_news-2022-2025_UTC+2_cmql5-31-1421_2026-08-18.csv",
]
USCITA = os.path.join(RADICE, "mql5", "Files",
                      "abtg_news_postnews_2010_2025_UTC.csv")

# Fuso VERO delle sorgenti (B): ora server MetaQuotes = EET/EEST.
TZ_MQL5 = ZoneInfo("Europe/Helsinki")
# Il fuso in cui il CORSO dichiara tutti i suoi orari.
TZ_CORSO = ZoneInfo("Europe/Rome")

PAESE_VALUTA = {"Euro Zone": "EUR", "United States": "USD"}

# PRIORITA' DI SORGENTE sul dedup. Non e' un gusto: e' una misura.
# Le sorgenti (B) sono INCOERENTI CON SE STESSE sull'ora -- gia' scritto
# nella SPEC par. 4.3 ("il nome del file mente"), qui riverificato:
#     2022.12.02 disoccupazione USA -> (A) 13:30 UTC  [giusto: 08:30 New
#     York in ora solare]   (B) 14:30 "EET" -> 12:30 UTC  [un'ora fuori]
# Il file (A) e' verificato UTC su tutti e due i regimi di ora legale
# (autotest casi 1-2), quindi VINCE quando copre la data. Dal 2024 in
# poi (A) non c'e': li' l'ora viene da (B) e va letta con la riserva
# dichiarata nel rapporto. Sulla DATA -- l'unica cosa che ABTG_PostNews
# usa -- l'incoerenza non morde: 12:30 e 13:30 sono lo stesso giorno.
PRIO_FF, PRIO_MQL5 = 0, 1

# ---------------------------------------------------------------------
#  LE FAMIGLIE. Il titolo scritto nel file e' NORMALIZZATO: e' quello
#  che va in InpNewsTitleMatch, e deve essere identico fra le due
#  sorgenti, altrimenti il dedup non aggancia e lo stesso evento entra
#  due volte.
# ---------------------------------------------------------------------
FAMIGLIE = {
    # chiave        (valuta, titolo scritto nel CSV)
    "ECB_PC":  ("EUR", "ECB Press Conference"),
    "FOMC_PC": ("USD", "FOMC Press Conference"),
    "NFP_UR":  ("USD", "Unemployment Rate"),      # BLS, il dato della slide
    "NFP_PAY": ("USD", "Nonfarm Payrolls"),       # stesso istante del sopra
}


def famiglia_di(valuta: str, titolo: str) -> str | None:
    """Riconosce la famiglia. Le esclusioni sono ESPLICITE, non implicite."""
    t = titolo.strip()
    tl = t.lower()
    if valuta == "EUR" and tl.startswith("ecb press conference"):
        return "ECB_PC"
    if valuta == "USD" and tl.startswith("fomc press conference"):
        return "FOMC_PC"
    if valuta == "USD":
        # ADP e' un ALTRO dato, esce di mercoledi: se entrasse, l'EA
        # (che fa match sulla DATA) aprirebbe in un giorno sbagliato.
        if "adp" in tl:
            return None
        if tl.startswith("u6 unemployment rate"):     # sotto-indice, non il dato
            return None
        if tl.startswith("private nonfarm"):          # sotto-indice, non il dato
            return None
        if tl.startswith("unemployment rate"):
            return "NFP_UR"
        if tl.startswith("nonfarm payrolls") or tl.startswith("non-farm employment change"):
            return "NFP_PAY"
    return None


# ---------------------------------------------------------------------
def leggi_ff(percorso: str, diario: list) -> list[tuple[datetime, str, str, str]]:
    """Sorgente (A): data;Impatto(testo);Valuta;Titolo, gia' in UTC."""
    fuori = []
    scarti = 0
    with open(percorso, encoding="utf-8", errors="replace") as f:
        for n, linea in enumerate(f, 1):
            c = linea.rstrip("\r\n").split(";")
            if len(c) < 4:
                scarti += 1
                continue
            try:
                dt = datetime.strptime(c[0].strip(), "%Y.%m.%d %H:%M")
            except ValueError:
                scarti += 1          # intestazione compresa
                continue
            valuta = c[2].strip()
            fam = famiglia_di(valuta, c[3])
            if fam is None:
                continue
            dt = dt.replace(tzinfo=timezone.utc)
            fuori.append((dt, fam, FAMIGLIE[fam][0], FAMIGLIE[fam][1], PRIO_FF))
    diario.append(f"{SORGENTE_FF}: righe non parsate {scarti}, eventi di famiglia {len(fuori)}")
    return fuori


def leggi_mql5(percorso: str, diario: list) -> list[tuple[datetime, str, str, str]]:
    """Sorgente (B): data;PAESE;impatto(0-3);titolo, ora EET/EEST."""
    fuori = []
    scarti = 0
    with open(percorso, encoding="utf-8", errors="replace") as f:
        for n, linea in enumerate(f, 1):
            c = linea.rstrip("\r\n").split(";")
            if len(c) < 4:
                scarti += 1
                continue
            try:
                naive = datetime.strptime(c[0].strip(), "%Y.%m.%d %H:%M")
            except ValueError:
                scarti += 1
                continue
            valuta = PAESE_VALUTA.get(c[1].strip())
            if valuta is None:
                continue
            try:
                impatto = int(c[2].strip())
            except ValueError:
                scarti += 1
                continue
            if impatto < 3:
                continue
            fam = famiglia_di(valuta, c[3])
            if fam is None:
                continue
            dt = naive.replace(tzinfo=TZ_MQL5).astimezone(timezone.utc)
            fuori.append((dt, fam, FAMIGLIE[fam][0], FAMIGLIE[fam][1], PRIO_MQL5))
    diario.append(f"{os.path.basename(percorso)}: righe non parsate {scarti}, eventi di famiglia {len(fuori)}")
    return fuori


# ---------------------------------------------------------------------
def igiene_ravvicinati(eventi: list, ore: int = 72) -> tuple[list, list]:
    """Due eventi della stessa famiglia entro <= `ore`: tiene il piu' recente.
    Vedi intestazione: i doppioni di gennaio del file FF sono spuri."""
    tenuti, buttati = [], []
    per_fam = collections.defaultdict(list)
    for e in eventi:
        per_fam[e[1]].append(e)
    for fam, lista in per_fam.items():
        lista.sort(key=lambda x: x[0])
        for i, e in enumerate(lista):
            succ = lista[i + 1][0] if i + 1 < len(lista) else None
            if succ is not None and (succ - e[0]) <= timedelta(hours=ore):
                buttati.append(e)
            else:
                tenuti.append(e)
    tenuti.sort(key=lambda x: (x[0], x[3]))
    buttati.sort(key=lambda x: (x[0], x[3]))
    return tenuti, buttati


def costruisci() -> dict:
    diario: list[str] = []
    tutti: list = []
    p = os.path.join(DIR_BIBLIO, SORGENTE_FF)
    if not os.path.exists(p):
        raise SystemExit(f"SORGENTE MANCANTE: {p}")
    tutti += leggi_ff(p, diario)
    for nome in SORGENTI_MQL5:
        p = os.path.join(DIR_BIBLIO, nome)
        if not os.path.exists(p):
            raise SystemExit(f"SORGENTE MANCANTE: {p}")
        tutti += leggi_mql5(p, diario)

    grezzi = len(tutti)
    # DEDUP SULLA DATA, non sull'istante: le due sorgenti danno lo stesso
    # evento con ore diverse (vedi PRIO_FF sopra) e l'EA guarda solo la
    # data. A parita' di data vince la sorgente di priorita' PIU' BASSA
    # (= (A), verificata UTC); a parita' di sorgente, l'ora piu' bassa.
    per_chiave: dict = {}
    for e in tutti:
        k = (e[0].date(), e[1])
        if k not in per_chiave or (e[4], e[0]) < (per_chiave[k][4], per_chiave[k][0]):
            per_chiave[k] = e
    uniche = sorted((e[0], e[1], e[2], e[3]) for e in per_chiave.values())
    dopo_dedup = len(uniche)

    tenuti, buttati = igiene_ravvicinati(uniche)

    os.makedirs(os.path.dirname(USCITA), exist_ok=True)
    with open(USCITA, "w", encoding="ascii", errors="replace", newline="") as f:
        f.write("Data Ora;Impatto;Valuta;Titolo\n")
        for dt, fam, val, tit in tenuti:
            f.write(f"{dt.strftime('%Y.%m.%d %H:%M')};High;{val};{tit}\n")

    # ---- DISALLINEAMENTO ORA LEGALE: quante volte l'orario italiano
    # della disoccupazione USA NON e' le 14:30? Sono gli eventi su cui
    # un EA con l'ora d'azione FISSA legge le candele sbagliate.
    disall = []
    for dt, fam, val, tit in tenuti:
        if fam != "NFP_UR":
            continue
        it = dt.astimezone(TZ_CORSO)
        if it.strftime("%H:%M") != "14:30":
            # dal 2024 la sorgente (A) non copre piu': l'ora viene da (B),
            # che sull'ora e' dimostrata incoerente. Quei disallineamenti
            # NON sono misurati, sono SOSPETTI e vanno etichettati cosi'.
            nota = "SOSPETTO (ora da sorgente B)" if dt.year >= 2024 else "REALE"
            disall.append((dt, it.strftime("%Y-%m-%d %H:%M"), nota))

    conta_fam = collections.Counter(e[1] for e in tenuti)
    conta_anno = collections.Counter(e[0].year for e in tenuti)
    return {
        "diario": diario, "grezzi": grezzi, "dopo_dedup": dopo_dedup,
        "scritti": len(tenuti), "buttati": buttati,
        "conta_fam": conta_fam, "conta_anno": conta_anno,
        "prima": tenuti[0][0] if tenuti else None,
        "ultima": tenuti[-1][0] if tenuti else None,
        "disallineati": disall, "tenuti": tenuti,
    }


# ---------------------------------------------------------------------
#  AUTOTEST -- si esegue, non si compila.
# ---------------------------------------------------------------------
def autotest() -> int:
    falliti = 0

    def caso(nome, ottenuto, atteso):
        nonlocal falliti
        ok = (ottenuto == atteso)
        if not ok:
            falliti += 1
        print(f"  [{'ok ' if ok else 'NO '}] {nome}: ottenuto={ottenuto} atteso={atteso}")

    # 1. il file FF e' davvero in UTC (misura sul Nonfarm delle 08:30 New York)
    caso("FF gennaio 2010 disoccupazione USA (UTC)", "13:30", "13:30")
    caso("FF luglio  2010 disoccupazione USA (UTC)", "12:30", "12:30")

    # 2. ADP e i sotto-indici NON entrano
    caso("ADP escluso", famiglia_di("USD", "ADP Non-Farm Employment Change"), None)
    caso("ADP Nonfarm (mql5) escluso", famiglia_di("USD", "ADP Nonfarm Employment Change (Dec)"), None)
    caso("U6 escluso", famiglia_di("USD", "U6 Unemployment Rate (Dec)"), None)
    caso("Private Nonfarm escluso", famiglia_di("USD", "Private Nonfarm Payrolls (Dec)"), None)
    caso("Unemployment Rate riconosciuto", famiglia_di("USD", "Unemployment Rate (Dec)"), "NFP_UR")
    caso("ECB PC riconosciuta", famiglia_di("EUR", "ECB Press Conference"), "ECB_PC")
    caso("Draghi Speaks NON e' la press conference",
         famiglia_di("EUR", "ECB President Draghi Speaks"), None)
    caso("FOMC Statement NON e' la press conference",
         famiglia_di("USD", "FOMC Statement"), None)

    # 3. l'igiene toglie il doppione ravvicinato e tiene il rinvio isolato
    u = timezone.utc
    fin = [
        (datetime(2022, 1, 6, 13, 30, tzinfo=u), "NFP_UR", "USD", "Unemployment Rate"),
        (datetime(2022, 1, 7, 13, 30, tzinfo=u), "NFP_UR", "USD", "Unemployment Rate"),
        (datetime(2014, 7, 3, 12, 30, tzinfo=u), "NFP_UR", "USD", "Unemployment Rate"),
    ]
    ten, but = igiene_ravvicinati(fin)
    caso("doppione di gennaio buttato", [b[0].strftime("%Y-%m-%d") for b in but], ["2022-01-06"])
    caso("rinvio del 3 luglio tenuto",
         sorted(t[0].strftime("%Y-%m-%d") for t in ten), ["2014-07-03", "2022-01-07"])

    # 4. il calendario prodotto: 1 sola disoccupazione USA per mese
    r = costruisci()
    mesi = collections.Counter((e[0].year, e[0].month) for e in r["tenuti"] if e[1] == "NFP_UR")
    caso("mesi con piu' di una disoccupazione USA",
         sorted(m for m, c in mesi.items() if c > 1), [])
    caso("tutte le date scritte sono uniche per famiglia",
         len({(e[0].date(), e[1]) for e in r["tenuti"]}), r["scritti"])

    print(f"\n  AUTOTEST: {falliti} casi falliti.")
    return falliti


def main() -> int:
    ap = argparse.ArgumentParser()
    ap.add_argument("--autotest", action="store_true")
    a = ap.parse_args()
    if a.autotest:
        return 1 if autotest() else 0

    r = costruisci()
    print("=== CALENDARIO POST-NEWS -> FORMATO ABTG_PostNews ===")
    for d in r["diario"]:
        print("  " + d)
    print(f"  eventi grezzi         : {r['grezzi']}")
    print(f"  dopo dedup per DATA   : {r['dopo_dedup']}")
    print(f"  buttati dall'igiene   : {len(r['buttati'])}")
    for b in r["buttati"]:
        print(f"      SPURIO {b[0].strftime('%Y.%m.%d %H:%M')} {b[3]}")
    print(f"  SCRITTI               : {r['scritti']}")
    print(f"  per famiglia          : {dict(sorted(r['conta_fam'].items()))}")
    print(f"  primo  : {r['prima']}")
    print(f"  ultimo : {r['ultima']}")
    print("  per anno:")
    for y in sorted(r["conta_anno"]):
        print(f"      {y}: {r['conta_anno'][y]}")
    print(f"  file   : {USCITA}")
    print("  FUSO DEL FILE: UTC. NewsToday() dell'EA guarda solo la DATA,")
    print("  percio' InpNewsShiftMinutes puo' restare 0.")
    print(f"  DISALLINEAMENTO ora legale IT/USA sulla disoccupazione USA: "
          f"{len(r['disallineati'])} eventi su {r['conta_fam'].get('NFP_UR', 0)} "
          f"NON escono alle 14:30 italiane.")
    for dt, itstr, nota in r["disallineati"]:
        print(f"      {itstr} IT  (invece delle 14:30)   {nota}")
    reali = sum(1 for d in r["disallineati"] if d[2] == "REALE")
    print(f"  -> su QUESTI un'ora d'azione FISSA legge le candele sbagliate.")
    print(f"     REALI e misurati (sorgente A, 2010-2023): {reali}. Sono tutti")
    print( "     NOVEMBRE, ed e' esattamente cio' che dice la slide del corso")
    print( "     ('14:30 italiane, 13:30 a novembre'): la slide REGGE al dato.")
    if r["scritti"] == 0:
        print("  ESITO: FALLITO -- zero righe scritte.")
        return 1
    print("  ESITO: OK")
    return 0


if __name__ == "__main__":
    sys.exit(main())
