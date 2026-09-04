#!/usr/bin/env python3
# =====================================================================
#  costruisci_news_blocchi_usa.py
#  I DUE CALENDARI dei candidati promossi dalla caccia del 04/09/2026:
#      A) BLOCCO ISM   -> mql5/Files/abtg_news_ism1500_2010_2023_UTC.csv
#      B) BLOCCO 13:30 -> mql5/Files/abtg_news_usd1330_2010_2023_UTC.csv
#  Sorgente: biblioteca/dati/CALENDARIO_FF_High_2010-2023_UTC.csv
# ---------------------------------------------------------------------
#  PERCHE' ESISTE (04/09/2026)
#
#  `caccia_strategie/CACCIA_POSTNEWS_ALTRE_FAMIGLIE_2026-09-04.md` ha
#  promosso due candidati per estendere il meccanismo di
#  ABTG_PostNews.mq5 (due pendenti simmetrici sul range delle due
#  candele M5 dopo la notizia) oltre le tre famiglie gia' vive
#  (NFP/USDJPY, ECB/EURJPY, FOMC/EURUSD):
#
#    A) le 15:00 server  -- ISM Manufacturing PMI, ISM Services PMI,
#       CB Consumer Confidence. Il blocco piu' PULITO del calendario di
#       casa: 441 giornate 2010-2023, contaminazione 7,0%.
#    B) le 13:30 server oltre l'NFP -- CPI m/m, Retail Sales m/m,
#       Core Retail Sales m/m, PPI m/m, Advance GDP q/q.
#
#  Questo script NON decide niente sulla strategia: costruisce i due
#  calendari e CONTA tutto quello che butta, riga per riga, perche' un
#  calendario sbagliato non produce "niente edge", produce IL NULLA
#  (lezione del round nullo del 07/08, vedi costruisci_news_postnews.py).
#
#  ---------------------------------------------------------------------
#  LE SEI DECISIONI DI COSTRUZIONE, DICHIARATE (i materiali non le
#  fissavano: sono scelte mie, ognuna con la sua ragione MISURATA)
#  ---------------------------------------------------------------------
#
#  1) UNA SOLA SORGENTE: il file Forex Factory 2010-2023.
#     I due CALENDARIO_news-*_cmql5-* coprono 2024-2025 e contengono
#     questi eventi (con altri nomi: "ISM Non-Manufacturing PMI"), MA la
#     loro ORA e' dimostrata incoerente (costruisci_news_postnews.py,
#     righe 87-97: stesso evento, un'ora di scarto). Siccome QUI l'ora e'
#     il criterio d'igiene numero uno (punto 4), una sorgente con l'ora
#     inaffidabile non e' utilizzabile senza rinunciare all'igiene.
#     ==> I CALENDARI PRODOTTI COPRONO 2010-2023 E BASTA.
#     ==> Un backtest fuori da quella finestra fa ZERO trade e VA BUTTATO
#         (non e' "niente edge": e' "non e' girata"). Sta scritto anche
#         nei due preset.
#
#  2) MATCH DEL TITOLO ESATTO, non per sottostringa.
#     "Core Retail Sales m/m" e "Retail Sales m/m" sono due eventi
#     diversi che escono nello STESSO minuto; "CPI m/m" e "Core CPI m/m"
#     pure. Un filtro per sottostringa li confonderebbe. Qui il titolo
#     della sorgente deve essere IDENTICO a quello dichiarato.
#
#  3) IGIENE / RIGHE DI FINE SETTIMANA.
#     Un dato macro USA non esce di sabato o di domenica. Nel file FF ce
#     ne sono (tutte in gennaio: e' lo stesso difetto dei doppioni di
#     gennaio gia' documentato per la disoccupazione). Sono innocue nel
#     tester (di domenica non c'e' la barra delle 15:00) ma sporcano i
#     conteggi: si buttano e si ELENCANO.
#
#  4) IGIENE / DOPPIONI RAVVICINATI: stessa regola di casa gia' scritta
#     in costruisci_news_postnews.py -- due eventi della STESSA famiglia
#     entro 72 ore: si tiene il PIU' RECENTE.
#     Verificato a mano sui 6 casi che restano dopo il punto 3, contro il
#     calendario dei giorni lavorativi (ISM Manufacturing = 1o giorno
#     lavorativo del mese, ISM Services = 3o): la regola sceglie sempre
#     la data giusta (es. 2012: il 2 gennaio era festa federale, il dato
#     vero e' il 3).
#
#  5) L'ORA CANONICA DIVENTA UN'ETICHETTA, NON UN FILTRO CIECO.
#     L'EA agisce a un'ORA FISSA a orologio (InpActionHour/Min): sulle
#     giornate in cui il DST americano ed europeo sono sfasati il dato
#     USA esce un'ora prima in ora server, e l'EA leggerebbe il range di
#     un momento qualunque un'ora DOPO la notizia. Non e' un dettaglio:
#     e' il difetto che la sedia NFP viva ha gia' oggi (dossier 04/09
#     par. 3.2).
#     Qui NON si buttano quelle righe e NON si tengono in silenzio:
#     si SCRIVONO CON UN'ETICHETTA DIVERSA nel titolo, cosi' che
#     l'ablazione "con / senza le giornate DST" si faccia cambiando UNA
#     STRINGA nel preset, senza ricostruire niente e senza toccare l'EA.
#
#  6) LE ETICHETTE (e perche' sono fatte a scatole cinesi).
#     ABTG_PostNews filtra con UNA sottostringa sola (StringFind sul
#     titolo, riga 272). Per avere piu' selezioni senza toccare il motore,
#     il titolo scritto nel CSV e':
#           <ETICHETTA> <titolo vero dell'evento>
#     e le etichette sono annidate: la piu' corta contiene le altre.
#
#       BLOCCO A (ISM, 15:00)
#         ISM1500OK   ora canonica 15:00 server           <- DEFAULT
#         ISM1500DST  giornata con DST sfasato (ora diversa)
#         ISM1500     = tutte e due  (ablazione "con le DST")
#
#       BLOCCO B (13:30)
#         USD1330OKF  ora canonica + evento NON restricted FTMO  <- DEFAULT
#         USD1330OKR  ora canonica + evento restricted FTMO (GDP)
#         USD1330OK   = OKF + OKR   (ablazione "con il GDP")
#         USD1330DSTF / USD1330DSTR  le stesse due, giornate DST
#         USD1330     = tutto
#
#     E siccome il titolo VERO resta nel campo, una singola famiglia si
#     isola da sola: InpNewsTitleMatch="ISM Services PMI" funziona.
#     ATTENZIONE: "Retail Sales m/m" e' sottostringa anche di "Core
#     Retail Sales m/m" -- per isolare il Core si usa "Core Retail".
#
#  ---------------------------------------------------------------------
#  FTMO: perche' il GDP ha un'etichetta sua
#  Claudio ha verificato dal browser (04/09/2026, ftmo.com) che per USD
#  la lista "Restricted event" contiene GDP q/q e CPI y/y, mentre CPI
#  m/m, Retail Sales e PPI NON ci sono, e che nessuno dei tre eventi del
#  blocco ISM ci compare. "Advance GDP q/q" lo tratto come RESTRICTED
#  (lettura conservativa: contiene "GDP q/q"). CPI y/y e Core CPI m/m non
#  entrano proprio nel blocco B: il mandato non li elenca.
#
#  IL FUSO DEI FILE PRODOTTI: UTC, come la sorgente e come il calendario
#  post-news gia' in casa. NewsToday() dell'EA confronta SOLO la DATA e
#  questi eventi stanno fra le 12:30 e le 15:00 UTC: nessun rischio di
#  scivolare di un giorno. InpNewsShiftMinutes resta 0.
#
#  USO:
#    python3 backtest_pipeline/costruisci_news_blocchi_usa.py
#    python3 backtest_pipeline/costruisci_news_blocchi_usa.py --autotest
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
DIR_USCITA = os.path.join(RADICE, "mql5", "Files")

# Ora server BCM = Europe/London (Passo 0 di ABTG_AllineaLondra,
# REGISTRO_TEST.md). La sorgente e' in UTC: in inverno coincidono, in
# estate Londra e' UTC+1. E' la conversione con cui il dossier del 04/09
# ha misurato la stabilita' d'orario -- qui si riusa la stessa.
TZ_SERVER = ZoneInfo("Europe/London")

# ---------------------------------------------------------------------
#  I DUE BLOCCHI. "restricted" = evento nella lista FTMO (vedi sopra).
# ---------------------------------------------------------------------
BLOCCHI = {
    "A_ISM1500": {
        "descr": "Blocco 10:00 ET / 15:00 server (USD) -- ISM + CB Consumer Confidence",
        "uscita": "abtg_news_ism1500_2010_2023_UTC.csv",
        "tag": "ISM1500",
        "ora_canonica": "15:00",
        "valuta": "USD",
        # titolo esatto nella sorgente -> restricted FTMO?
        "famiglie": {
            "ISM Manufacturing PMI": False,
            "ISM Services PMI": False,
            "CB Consumer Confidence": False,
        },
    },
    "B_USD1330": {
        "descr": "Blocco 8:30 ET / 13:30 server (USD) OLTRE l'NFP",
        "uscita": "abtg_news_usd1330_2010_2023_UTC.csv",
        "tag": "USD1330",
        "ora_canonica": "13:30",
        "valuta": "USD",
        "famiglie": {
            "CPI m/m": False,
            "Retail Sales m/m": False,
            "Core Retail Sales m/m": False,
            "PPI m/m": False,
            "Advance GDP q/q": True,      # restricted FTMO (lettura conservativa)
        },
    },
}

# La sedia NFP VIVA (magic 771203) opera su queste date: servono solo per
# MISURARE la collisione, non entrano in nessun file prodotto.
TITOLO_NFP = "Non-Farm Employment Change"


# ---------------------------------------------------------------------
def leggi_sorgente(percorso: str) -> tuple[list, int, int]:
    """Sorgente FF: 'Data Ora;Impatto;Valuta;Titolo', gia' in UTC."""
    righe, tot, scarti = [], 0, 0
    with open(percorso, encoding="utf-8", errors="replace") as f:
        for linea in f:
            tot += 1
            c = linea.rstrip("\r\n").split(";")
            if len(c) < 4:
                scarti += 1
                continue
            try:
                dt = datetime.strptime(c[0].strip(), "%Y.%m.%d %H:%M")
            except ValueError:
                scarti += 1          # intestazione compresa
                continue
            righe.append((dt.replace(tzinfo=timezone.utc),
                          c[1].strip(), c[2].strip(), c[3].strip()))
    return righe, tot, scarti


def ora_server(dt: datetime) -> str:
    return dt.astimezone(TZ_SERVER).strftime("%H:%M")


def giorno_server(dt: datetime):
    return dt.astimezone(TZ_SERVER).date()


def etichetta(tag: str, canonica: bool, restricted: bool | None) -> str:
    """Le scatole cinesi del punto 6. `restricted=None` -> niente F/R."""
    e = tag + ("OK" if canonica else "DST")
    if restricted is not None:
        e += "R" if restricted else "F"
    return e


def igiene_ravvicinati(eventi: list, ore: int = 72) -> tuple[list, list]:
    """Due eventi della STESSA famiglia entro <= `ore`: tiene il piu'
    recente. Copiata da costruisci_news_postnews.py: stessa sorgente,
    stesso difetto di gennaio."""
    tenuti, buttati = [], []
    per_fam = collections.defaultdict(list)
    for e in eventi:
        per_fam[e["titolo"]].append(e)
    for _fam, lista in per_fam.items():
        lista.sort(key=lambda x: x["dt"])
        for i, e in enumerate(lista):
            succ = lista[i + 1]["dt"] if i + 1 < len(lista) else None
            if succ is not None and (succ - e["dt"]) <= timedelta(hours=ore):
                buttati.append(e)
            else:
                tenuti.append(e)
    tenuti.sort(key=lambda x: (x["dt"], x["titolo"]))
    buttati.sort(key=lambda x: (x["dt"], x["titolo"]))
    return tenuti, buttati


# ---------------------------------------------------------------------
def costruisci_blocco(chiave: str, righe: list) -> dict:
    b = BLOCCHI[chiave]
    fam = b["famiglie"]
    # 1. selezione: valuta + TITOLO ESATTO (punto 2)
    sel = [{"dt": r[0], "titolo": r[3]}
           for r in righe if r[2] == b["valuta"] and r[3] in fam]
    grezze = len(sel)

    # 2. dedup esatto (stesso istante + stesso titolo): il file FF ha
    #    righe fotocopia in gennaio.
    visti, uniche, dup_esatti = set(), [], []
    for e in sorted(sel, key=lambda x: (x["dt"], x["titolo"])):
        k = (e["dt"], e["titolo"])
        if k in visti:
            dup_esatti.append(e)
            continue
        visti.add(k)
        uniche.append(e)

    # 3. dedup per (giorno server + titolo): stesso evento due volte nella
    #    stessa giornata a ore diverse -> vince l'ora CANONICA, altrimenti
    #    la piu' presto.
    per_gt: dict = {}
    dup_giorno = []
    for e in uniche:
        k = (giorno_server(e["dt"]), e["titolo"])
        canon = (ora_server(e["dt"]) == b["ora_canonica"])
        # chiave d'ordine: canonica prima, poi ora piu' bassa
        ord_e = (0 if canon else 1, e["dt"])
        if k not in per_gt:
            per_gt[k] = (ord_e, e)
        else:
            if ord_e < per_gt[k][0]:
                dup_giorno.append(per_gt[k][1])
                per_gt[k] = (ord_e, e)
            else:
                dup_giorno.append(e)
    uniche = sorted((v[1] for v in per_gt.values()),
                    key=lambda x: (x["dt"], x["titolo"]))

    # 4. via le righe di sabato/domenica (punto 3)
    weekend = [e for e in uniche if giorno_server(e["dt"]).weekday() >= 5]
    uniche = [e for e in uniche if giorno_server(e["dt"]).weekday() < 5]

    # 5. doppioni ravvicinati <= 72h (punto 4)
    tenuti, ravvicinati = igiene_ravvicinati(uniche)

    # 6. etichette + scrittura
    for e in tenuti:
        canon = (ora_server(e["dt"]) == b["ora_canonica"])
        restr = fam[e["titolo"]]
        # nel blocco A nessun evento e' restricted -> niente lettera F/R,
        # l'etichetta resta corta e leggibile.
        usa_fr = any(fam.values())
        e["canonica"] = canon
        e["etichetta"] = etichetta(b["tag"], canon, restr if usa_fr else None)
        e["riga"] = (f"{e['dt'].strftime('%Y.%m.%d %H:%M')};High;{b['valuta']};"
                     f"{e['etichetta']} {e['titolo']}")

    percorso = os.path.join(DIR_USCITA, b["uscita"])
    os.makedirs(DIR_USCITA, exist_ok=True)
    with open(percorso, "w", encoding="ascii", errors="replace", newline="") as f:
        f.write("Data Ora;Impatto;Valuta;Titolo\n")
        for e in tenuti:
            f.write(e["riga"] + "\n")

    canoniche = [e for e in tenuti if e["canonica"]]
    gg_tutte = sorted({giorno_server(e["dt"]) for e in tenuti})
    gg_canon = sorted({giorno_server(e["dt"]) for e in canoniche})
    return {
        "blocco": b, "percorso": percorso,
        "grezze": grezze, "dup_esatti": dup_esatti, "dup_giorno": dup_giorno,
        "weekend": weekend, "ravvicinati": ravvicinati,
        "scritte": len(tenuti), "tenuti": tenuti,
        "canoniche": len(canoniche), "dst": len(tenuti) - len(canoniche),
        "gg_tutte": gg_tutte, "gg_canon": gg_canon,
        "per_fam": collections.Counter(e["titolo"] for e in tenuti),
        "per_fam_canon": collections.Counter(e["titolo"] for e in canoniche),
        "ore": collections.Counter(ora_server(e["dt"]) for e in tenuti),
    }


def simula_filtro_ea(percorso: str, match: str, valuta: str = "USD") -> tuple[int, set]:
    """Riproduce ESATTAMENTE cio' che fa ABTG_PostNews.NewsToday():
    impatto >= 3, valuta contenuta, titolo che CONTIENE `match`.
    Torna (righe utili, giornate distinte). E' l'autotest che vale:
    se questo non torna, il preset non trada quel che crediamo."""
    utili, giorni = 0, set()
    with open(percorso, encoding="ascii") as f:
        for linea in f:
            c = linea.rstrip("\r\n").split(";")
            if len(c) < 4:
                continue
            try:
                dt = datetime.strptime(c[0].strip(), "%Y.%m.%d %H:%M")
            except ValueError:
                continue                      # intestazione
            if c[2].strip() not in valuta:
                continue
            if match and match not in c[3]:
                continue
            utili += 1
            giorni.add(dt.date())
    return utili, giorni


# ---------------------------------------------------------------------
def costruisci() -> dict:
    p = os.path.join(DIR_BIBLIO, SORGENTE_FF)
    if not os.path.exists(p):
        raise SystemExit(f"SORGENTE MANCANTE: {p}")
    righe, tot, scarti = leggi_sorgente(p)
    out = {"sorgente": p, "righe_tot": tot, "non_parsate": scarti,
           "righe_ok": len(righe), "blocchi": {}}
    for k in BLOCCHI:
        out["blocchi"][k] = costruisci_blocco(k, righe)
    # giornate della sedia NFP viva, per misurare la collisione
    nfp = [r for r in righe if r[2] == "USD" and r[3] == TITOLO_NFP]
    out["gg_nfp"] = {giorno_server(r[0]) for r in nfp
                     if ora_server(r[0]) == "13:30"}
    return out


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

    r = costruisci()
    A = r["blocchi"]["A_ISM1500"]
    B = r["blocchi"]["B_USD1330"]

    print("  --- 1. CONTROLLO POSITIVO: la sorgente e' davvero in UTC ---")
    righe, _, _ = leggi_sorgente(r["sorgente"])
    gen = [x for x in righe if x[3] == "ISM Manufacturing PMI"
           and x[0].year == 2010 and x[0].month == 1]
    lug = [x for x in righe if x[3] == "ISM Manufacturing PMI"
           and x[0].year == 2010 and x[0].month == 7]
    # ISM esce alle 10:00 New York: 15:00 UTC in ora solare, 14:00 in legale.
    caso("ISM gen-2010 in UTC", gen[0][0].strftime("%H:%M"), "15:00")
    caso("ISM lug-2010 in UTC", lug[0][0].strftime("%H:%M"), "14:00")
    # ...e in ora SERVER (Londra) tutte e due stanno alle 15:00.
    caso("ISM gen-2010 in ora server", ora_server(gen[0][0]), "15:00")
    caso("ISM lug-2010 in ora server", ora_server(lug[0][0]), "15:00")

    print("  --- 2. il match del titolo e' ESATTO, non per sottostringa ---")
    famB = BLOCCHI["B_USD1330"]["famiglie"]
    caso("Core CPI m/m NON entra nel blocco B", "Core CPI m/m" in famB, False)
    caso("Core PPI m/m NON entra nel blocco B", "Core PPI m/m" in famB, False)
    caso("CPI y/y NON entra nel blocco B (restricted FTMO)", "CPI y/y" in famB, False)
    caso("Core Retail Sales e Retail Sales sono DUE famiglie",
         sorted(t for t in famB if "Retail" in t),
         ["Core Retail Sales m/m", "Retail Sales m/m"])
    caso("nessun titolo del blocco A finisce nel blocco B",
         sorted(set(BLOCCHI["A_ISM1500"]["famiglie"]) & set(famB)), [])

    print("  --- 3. l'igiene butta il fine settimana e i doppioni ---")
    caso("righe di sabato/domenica nel file A", len(A["weekend"]), 4)
    caso("nessuna riga di weekend SOPRAVVIVE nel file A",
         sorted({giorno_server(e["dt"]).weekday() for e in A["tenuti"] if giorno_server(e["dt"]).weekday() >= 5}), [])
    caso("nessuna riga di weekend SOPRAVVIVE nel file B",
         sorted({giorno_server(e["dt"]).weekday() for e in B["tenuti"] if giorno_server(e["dt"]).weekday() >= 5}), [])
    caso("doppioni ravvicinati <=72h buttati in A", len(A["ravvicinati"]), 6)
    caso("doppioni ravvicinati <=72h buttati in B", len(B["ravvicinati"]), 0)
    # la regola tiene la data GIUSTA: gennaio 2012, il 2 era festa federale
    # -> il 1o giorno lavorativo e' il 3, ed e' quello che deve restare.
    gg2012 = sorted(giorno_server(e["dt"]).isoformat() for e in A["tenuti"]
                    if e["titolo"] == "ISM Manufacturing PMI"
                    and giorno_server(e["dt"]).year == 2012
                    and giorno_server(e["dt"]).month == 1)
    caso("ISM Manufacturing gennaio 2012 = il 3, non il 2", gg2012, ["2012-01-03"])

    print("  --- 4. una sola riga per (giornata, famiglia) ---")
    for nome, X in (("A", A), ("B", B)):
        chiavi = {(giorno_server(e["dt"]), e["titolo"]) for e in X["tenuti"]}
        caso(f"file {nome}: righe = coppie (giorno,famiglia) uniche",
             len(chiavi), X["scritte"])

    print("  --- 5. le etichette annidate fanno quel che promettono ---")
    # (si legge il FILE SCRITTO con la stessa logica dell'EA: StringFind)
    nA, ggA = simula_filtro_ea(A["percorso"], "ISM1500OK")
    nAd, _ = simula_filtro_ea(A["percorso"], "ISM1500DST")
    nAt, _ = simula_filtro_ea(A["percorso"], "ISM1500")
    caso("A: OK + DST = tutte", nA + nAd, nAt)
    caso("A: le OK sono le canoniche", nA, A["canoniche"])
    caso("A: una riga per giornata (OK)", nA, len(ggA))
    nBf, ggBf = simula_filtro_ea(B["percorso"], "USD1330OKF")
    nBr, _ = simula_filtro_ea(B["percorso"], "USD1330OKR")
    nBok, _ = simula_filtro_ea(B["percorso"], "USD1330OK")
    nBt, _ = simula_filtro_ea(B["percorso"], "USD1330")
    caso("B: OKF + OKR = OK", nBf + nBr, nBok)
    caso("B: OK <= tutte", nBok <= nBt, True)
    caso("B: il GDP e' TUTTO e SOLO in OKR+DSTR",
         nBr, B["per_fam_canon"]["Advance GDP q/q"])
    # e una famiglia singola si isola col titolo vero
    nS, _ = simula_filtro_ea(A["percorso"], "ISM Services PMI")
    caso("A: 'ISM Services PMI' isola la famiglia",
         nS, A["per_fam"]["ISM Services PMI"])

    print("  --- 6. controllo positivo sul numero del dossier (441) ---")
    # il dossier del 04/09 conta 441 giornate ISM canoniche PRIMA
    # dell'igiene: si riproduce, cosi' si sa che stiamo guardando la
    # stessa cosa e che le differenze sono SOLO l'igiene dichiarata.
    grezze_canon = {giorno_server(x[0]) for x in righe
                    if x[2] == "USD" and x[3] in BLOCCHI["A_ISM1500"]["famiglie"]
                    and ora_server(x[0]) == "15:00"}
    caso("giornate ISM canoniche PRIMA dell'igiene (dossier: 441)",
         len(grezze_canon), 441)

    print("  --- 7. il blocco B non pesta i piedi alla sedia NFP viva ---")
    caso("giornate B canoniche in comune con l'NFP",
         len({giorno_server(e["dt"]) for e in B["tenuti"] if e["canonica"]} & r["gg_nfp"]), 0)
    caso("l'NFP NON e' nel blocco B", TITOLO_NFP in BLOCCHI["B_USD1330"]["famiglie"], False)

    print(f"\n  AUTOTEST: {falliti} casi falliti.")
    return falliti


# ---------------------------------------------------------------------
def rapporto(r: dict) -> None:
    print("=== CALENDARI BLOCCHI USA -> FORMATO ABTG_PostNews ===")
    print(f"  sorgente : {r['sorgente']}")
    print(f"  righe {r['righe_tot']} | non parsate {r['non_parsate']} "
          f"(intestazione compresa) | utilizzabili {r['righe_ok']}")
    for k, X in r["blocchi"].items():
        b = X["blocco"]
        print(f"\n--- {k} : {b['descr']}")
        print(f"    ora canonica server {b['ora_canonica']} | etichetta '{b['tag']}'")
        print(f"    righe grezze                : {X['grezze']}")
        print(f"    buttate, doppione IDENTICO  : {len(X['dup_esatti'])}")
        for e in X["dup_esatti"]:
            print(f"        {e['dt'].strftime('%Y.%m.%d %H:%M')}  {e['titolo']}")
        print(f"    buttate, stesso giorno+fam. : {len(X['dup_giorno'])}")
        for e in X["dup_giorno"]:
            print(f"        {e['dt'].strftime('%Y.%m.%d %H:%M')}  {e['titolo']}")
        print(f"    buttate, SABATO/DOMENICA    : {len(X['weekend'])}")
        for e in X["weekend"]:
            print(f"        {e['dt'].strftime('%Y.%m.%d %H:%M')}  {e['titolo']}  "
                  f"({giorno_server(e['dt']).strftime('%A')})")
        print(f"    buttate, doppione <=72h     : {len(X['ravvicinati'])}")
        for e in X["ravvicinati"]:
            print(f"        {e['dt'].strftime('%Y.%m.%d %H:%M')}  {e['titolo']}")
        print(f"    SCRITTE                     : {X['scritte']}")
        print(f"        di cui ora canonica (OK): {X['canoniche']}  "
              f"-> giornate {len(X['gg_canon'])}")
        print(f"        di cui DST sfasato      : {X['dst']}")
        print(f"    ore server presenti         : {dict(X['ore'].most_common())}")
        print("    per famiglia (tutte | canoniche):")
        for t in sorted(X["per_fam"]):
            print(f"        {t:28s} {X['per_fam'][t]:4d} | {X['per_fam_canon'][t]:4d}")
        print("    giornate CANONICHE per anno:")
        anni = collections.Counter(d.year for d in X["gg_canon"])
        print("        " + "  ".join(f"{y}:{anni.get(y,0)}" for y in range(2010, 2024)))
        print(f"    file: {X['percorso']}")
        # cosa vedra' l'EA con le stringhe dei preset
        print("    QUELLO CHE VEDRA' L'EA (simulazione di NewsToday):")
        tag = b["tag"]
        chiavi = [tag + "OKF", tag + "OKR", tag + "OK", tag + "DST", tag] \
            if any(b["famiglie"].values()) else [tag + "OK", tag + "DST", tag]
        for m in chiavi:
            n, gg = simula_filtro_ea(X["percorso"], m)
            if n == 0:
                continue
            print(f"        InpNewsTitleMatch={m:12s} -> righe utili {n:4d} | "
                  f"giornate {len(gg):4d} | {min(gg)} .. {max(gg)}")

    A = r["blocchi"]["A_ISM1500"]
    B = r["blocchi"]["B_USD1330"]
    ggA = {giorno_server(e["dt"]) for e in A["tenuti"] if e["canonica"]}
    ggB = {giorno_server(e["dt"]) for e in B["tenuti"] if e["canonica"]}
    print("\n--- COLLISIONI FRA SEDIE (giornate canoniche in comune) ---")
    print(f"    A(ISM) & B(13:30)     : {len(ggA & ggB)}")
    print(f"    A(ISM) & NFP viva     : {len(ggA & r['gg_nfp'])}")
    print(f"    B(13:30) & NFP viva   : {len(ggB & r['gg_nfp'])}")
    print("    (l'NFP NON e' dentro il blocco B: il preset nuovo misura il")
    print("     RESTO delle 13:30, la sedia viva resta l'unica sull'NFP)")
    print("\n  LIMITE DICHIARATO: i due file coprono 2010-2023 e BASTA.")
    print("  Un backtest fuori da quella finestra fa ZERO trade: quella")
    print("  passata SI BUTTA, non e' un verdetto sulla strategia.")


def main() -> int:
    ap = argparse.ArgumentParser()
    ap.add_argument("--autotest", action="store_true")
    a = ap.parse_args()
    if a.autotest:
        return 1 if autotest() else 0
    r = costruisci()
    rapporto(r)
    vuoti = [k for k, X in r["blocchi"].items() if X["scritte"] == 0]
    if vuoti:
        print(f"  ESITO: FALLITO -- blocchi vuoti: {vuoti}")
        return 1
    print("  ESITO: OK")
    return 0


if __name__ == "__main__":
    sys.exit(main())
