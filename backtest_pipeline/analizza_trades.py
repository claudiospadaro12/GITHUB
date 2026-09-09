#!/usr/bin/env python3
"""
analizza_trades.py — la pagella giornaliera dal CSV del TradeExporter.

Legge  data/statements/trades_auto.csv  (che l'EA ABTG_TradeExporter scrive
in Common\\Files e pubblica_trades.ps1 carica nel repo) e produce il report
di giornata in  report/giornata_AAAA-MM-GG.md.

Nasce dal 03/08/2026: quel giorno cinque operazioni hanno insegnato più di
una settimana di backtest, ma le ho ricostruite a mano da cinque screenshot.
Questo script fa lo stesso lavoro da solo, tutti i giorni.

Uso:
    python3 backtest_pipeline/analizza_trades.py            # ultimo giorno con trade
    python3 backtest_pipeline/analizza_trades.py 2026-08-03 # un giorno preciso
"""
import csv, sys, os, subprocess
from collections import defaultdict
from datetime import datetime

CSV_IN  = "data/statements/trades_auto.csv"
OUT_DIR = "report"

# --- pagella DOPPIA (HANDOFF 0-ter, 11/08): il secondo CSV e' il conto
#     100k del dry-run FTMO (50504263). Lo scrive il TradeExporter sul -V3
#     (InpFile=ABTG_Trades_100k.csv) e lo pubblica pubblica_trades.ps1.
CSV_100K  = "data/statements/trades_100k.csv"
DEP_100K  = 100000.0
FTMO_PAV_TOTALE = 90000.0   # pavimento statico -10%
FTMO_LIM_GIORNO = 5000.0    # perdita massima giornaliera -5%

# --- pagella TRIPLA (08/09/2026): il terzo CSV e' il CONTO REALE 10105439,
#     l'unico con soldi veri e - fino a oggi - l'unico SENZA pagella.
#     Lo scrivera' il TradeExporter sul terminale C:\BCM_Reale con
#     InpFile=ABTG_Trades_Reale.csv (nome DIVERSO dagli altri due: la
#     Common\Files e' condivisa fra i terminali dello stesso VPS, stesso
#     nome = tre conti che si sovrascrivono a vicenda).
#     Al 08/09/2026 il file NON esiste ancora: la sezione lo dichiara.
CSV_REALE     = "data/statements/trades_reale.csv"
CSV_REALE_MT5 = "ABTG_Trades_Reale.csv"   # nome in Common\Files (input InpFile)

# Colonne senza le quali la sezione del REALE non stampa NIENTE.
# Non e' pignoleria: su un conto vero un totale che salta una colonna e'
# un numero sbagliato, e un numero sbagliato costa soldi.
COLONNE_MINIME = ("open_time", "close_time", "profit", "swap", "commission",
                  "symbol", "strategy", "magic")

# soglie di lettura, dalle regole del progetto
FRAZIONE_BASSA = 0.30   # sotto il 30% del movimento catturato = la gestione taglia troppo presto
DURATA_SOSPETTA = 120   # secondi: sotto = quasi certamente trailing/BE troppo stretti

# --- FUORI DAL TOTALE: le operazioni SENZA COMMENTO del conto piccolo -------
#
# Claudio, 07/09/2026: "sul conto piccolo demo avevo iniziato a farlo manuale.
# Da quando vedi costanza nei commenti, vuol dire che siamo partiti solo con
# EA. I trade senza commenti non li calcolare nel conto piccolo."
#
# MISURATO su trades_auto.csv (30/03 -> 07/09/2026), non assunto:
#   - 661 operazioni hanno  strategy=""  e  magic=0 ;
#   - la corrispondenza e' ESATTA nei due sensi: zero righe con strategy vuota
#     e magic != 0, zero righe con strategy piena e magic 0. Quindi "senza
#     commento" e "magic 0" sono lo STESSO insieme, e il filtro non deve
#     scegliere fra i due criteri: li pretende entrambi e segnala se un giorno
#     dovessero divergere.
#   - valgono -18.706,94 EUR contro i -1.235,41 EUR di TUTTA la flotta: se
#     entrano nel totale, il netto del piccolo non e' il netto della flotta.
#   - l'ULTIMA e' del 27/07/2026. Dal 28/07 in poi il conto e' solo EA
#     (264 operazioni, tutte con commento). Il confine e' una misura, non
#     una data scelta a mano.
#
# Non si cancellano: si mostrano FUORI dal totale, come i "RESIDUI SU DISCO"
# del censimento. Un numero che mescola due cose non e' un numero.
CAMBIO_SOLO_EA = "2026-07-28"   # primo giorno senza piu' operazioni manuali


def freschezza(path):
    """Quando il CONTENUTO di questo CSV e' cambiato l'ultima volta nel repo.

    NATO DA UN ERRORE PAGATO (04/09/2026): la pagella ha pubblicato
    "100k: netto di oggi +0,00" mentre il CSV del 100k era fermo al giorno
    prima. Il conto quel giorno aveva fatto **+30,78** (riga gemella della
    `DAX Apertura EU RETEST`, arrivata solo il 05/09 alle 17:32). Fino al
    07/09 la sezione controllava soltanto che il file ESISTESSE: un dato che
    non arriva e uno zero vero venivano stampati **identici**.
    Ricorrenze: 04/09, 07/09, 09/09.

    PERCHE' NON BASTA LA DATA DEL FILE: in un clone fresco tutti i file
    prendono l'ora del checkout, quindi l'mtime direbbe "arrivato adesso"
    anche per un CSV fermo da giorni. La data del commit che l'ha toccato
    per ultimo e' invece un fatto scritto una volta sola. L'mtime resta
    come rete di sicurezza se git non c'e' (e allora la fonte lo dichiara).

    ⚠️ IL LIMITE, dichiarato perche' conta: un CSV che arriva IDENTICO —
    il conto non ha chiuso niente di nuovo — **non lascia traccia in git**.
    Quindi "fermo al giorno X" vuol dire *"da X non arriva CONTENUTO
    NUOVO"*, NON *"la consegna e' rotta"*. Sono due cose diverse e da qui
    non si distinguono: per distinguerle serve un timbro scritto DENTRO il
    file dall'esportatore, che oggi non esiste.
    Ed e' esattamente per questo che il verdetto non e' "zero" ne' "guasto",
    ma **DATO NON ARRIVATO**: dice quello che sappiamo e si ferma li'.

    Torna (data 'AAAA-MM-GG' o None, fonte).
    """
    if not os.path.exists(path):
        return None, "assente"
    try:
        p = subprocess.run(["git", "log", "-1", "--format=%cs", "--", path],
                           capture_output=True, text=True, timeout=15)
        d = (p.stdout or "").strip()
        if p.returncode == 0 and len(d) == 10:
            return d, "git"
    except Exception:
        pass    # git assente o repo strano: si ripiega, dichiarandolo
    return datetime.fromtimestamp(os.path.getmtime(path)).strftime("%Y-%m-%d"), "data del file"


def giorni_fra(da, a):
    """Giorni di calendario fra due 'AAAA-MM-GG'. None se una non si legge."""
    try:
        return (datetime.strptime(a, "%Y-%m-%d") - datetime.strptime(da, "%Y-%m-%d")).days
    except Exception:
        return None


def senza_commento(r):
    """True se la riga non appartiene a nessun EA nostro (manuale di Claudio)."""
    vuoto = not (r.get("strategy") or "").strip()
    magic0 = (str(r.get("magic", "0")) or "0").strip() in ("", "0")
    return vuoto and magic0


def discordi(righe):
    """Righe in cui i due criteri NON coincidono: vanno dette, non indovinate."""
    fuori = []
    for r in righe:
        vuoto = not (r.get("strategy") or "").strip()
        magic0 = (str(r.get("magic", "0")) or "0").strip() in ("", "0")
        if vuoto != magic0:
            fuori.append(r)
    return fuori


def leggi(path):
    if not os.path.exists(path):
        sys.exit("Manca %s — lancia pubblica_trades.ps1 sul VPS (o carica il CSV a mano)." % path)
    with open(path, encoding="utf-8-sig", newline="") as f:
        # il TradeExporter usa ';' come separatore
        righe = list(csv.DictReader(f, delimiter=";"))
    if not righe:
        sys.exit("Il CSV è vuoto.")
    return righe


def num(r, k, default=0.0):
    try:
        return float(str(r.get(k, "")).replace(",", "."))
    except (TypeError, ValueError):
        return default


def leggibile(r, k):
    """True se il campo k c'e' ed e' un numero VERO.

    `num()` in caso di guaio ripiega su 0.0, e va benissimo per i due conti
    demo: una riga storta li' sposta una lettura. Sul conto REALE no — uno
    zero silenzioso al posto di una perdita e' esattamente il modo in cui un
    totale sbagliato sembra giusto. Qui il guaio si vede.
    """
    v = r.get(k, None)
    if v is None:
        return False
    v = str(v).strip()
    if v == "":
        return False
    try:
        float(v.replace(",", "."))
        return True
    except ValueError:
        return False


def tempo(s):
    for fmt in ("%Y.%m.%d %H:%M:%S", "%Y.%m.%d %H:%M", "%Y-%m-%d %H:%M:%S"):
        try:
            return datetime.strptime(s.strip(), fmt)
        except (ValueError, AttributeError):
            continue
    return None


def frazione_catturata(r):
    """Quanta parte del movimento disponibile ha preso il trade.

    ATTENZIONE al denominatore: session_high/low li misura l'EA da
    ingresso fino alle 23:59, cioe' su TUTTA la giornata. Per gli EA di
    apertura, che chiudono entro mezz'ora, e' una finestra molto piu'
    lunga della loro vita: le percentuali escono basse per costruzione e
    vanno lette come "quanto ha preso di cio' che la giornata offriva",
    non come "quanto ha preso del suo movimento".

    Si calcola SOLO sui trade in profitto. Su un perdente il
    denominatore e' l'escursione a favore, che puo' essere quasi zero:
    il 04/08 un trade dava -1679%, un numero senza significato.
    """
    if num(r, "profit") <= 0:
        return None
    hi, lo = num(r, "session_high"), num(r, "session_low")
    op, cp = num(r, "open_price"), num(r, "close_price")
    if hi <= 0 or lo <= 0 or op <= 0:
        return None
    if r.get("side", "").lower().startswith("b"):
        disponibile, preso = hi - op, cp - op
    else:
        disponibile, preso = op - lo, op - cp
    if disponibile <= 0:
        return None
    f = preso / disponibile
    return f if -0.5 <= f <= 3.0 else None   # fuori range = dato inaffidabile


def main():
    righe = leggi(CSV_IN)
    giorno = sys.argv[1] if len(sys.argv) > 1 else None

    for r in righe:
        r["_ot"] = tempo(r.get("open_time", ""))
        r["_ct"] = tempo(r.get("close_time", ""))
    righe = [r for r in righe if r["_ot"] and r["_ct"]]

    # --- FUORI DAL TOTALE: le manuali di Claudio (vedi in cima al file).
    #     Si tolgono PRIMA di scegliere la giornata: altrimenti un giorno di
    #     sole manuali diventerebbe "la giornata" e la pagella parlerebbe di
    #     un lavoro che nessun EA ha fatto.
    manuali_tutte = [r for r in righe if senza_commento(r)]
    ambigue = discordi(righe)
    righe = [r for r in righe if not senza_commento(r)]
    if not righe:
        sys.exit("Nel CSV non c'e' nessuna operazione con commento: solo manuali.")

    # La giornata si sceglie sulla CHIUSURA, non sull'apertura.
    # Il 05/08 questo filtro girava su open_time e ha buttato fuori due
    # posizioni aperte il 31/07 e chiuse quel giorno: -61,59 euro spariti
    # dal netto (-227,17 riportato contro -288,76 reale). Il P&L realizzato
    # appartiene al giorno in cui si realizza, non a quello in cui si apre.
    if not giorno:
        giorno = max(r["_ct"] for r in righe).strftime("%Y-%m-%d")
    oggi = [r for r in righe if r["_ct"].strftime("%Y-%m-%d") == giorno]
    if not oggi:
        # Distinguere i due casi: "giornata vuota" e "giornata di sole
        # manuali" sono cose diverse, e dirle uguali nasconde un fatto.
        soloman = [r for r in manuali_tutte
                   if r["_ct"].strftime("%Y-%m-%d") == giorno]
        if soloman:
            sys.exit("Il %s ha SOLO %d operazioni senza commento (manuali, "
                     "fuori dal conto della flotta): nessun EA ha operato."
                     % (giorno, len(soloman)))
        sys.exit("Nessun trade chiuso il %s." % giorno)

    # Le posizioni aperte nei giorni precedenti si segnalano: la durata media
    # e la "frazione del giorno" per loro non vogliono dire niente.
    ereditate = [r for r in oggi if r["_ot"].strftime("%Y-%m-%d") != giorno]

    out = ["# 📅 Giornata %s — pagella automatica" % giorno, "",
           "_Generato da `analizza_trades.py` sul CSV del TradeExporter. "
           "Posizioni **chiuse** in giornata._", ""]
    # ---------- TIMBRO DI FRESCHEZZA (09/09/2026) ----------
    #
    # Sta IN TESTA apposta: e' la prima cosa da sapere prima di credere a un
    # qualunque numero sotto. Un dato che non arriva non e' uno zero.
    CONTI = (("piccolo 50503392", CSV_IN),
             ("100k 50504263",    CSV_100K),
             ("reale 10105439",   CSV_REALE))
    fresco = {}
    righe_timbro, fermi = [], []
    for etichetta, percorso in CONTI:
        d, fonte = freschezza(percorso)
        fresco[percorso] = bool(d) and d >= giorno
        if d is None:
            righe_timbro.append("| %s | `%s` | — | ⚪ **CSV ASSENTE** |"
                                % (etichetta, os.path.basename(percorso)))
        elif fresco[percorso]:
            righe_timbro.append("| %s | `%s` | %s _(%s)_ | ✅ aggiornato |"
                                % (etichetta, os.path.basename(percorso), d, fonte))
        else:
            n = giorni_fra(d, giorno)
            righe_timbro.append("| %s | `%s` | %s _(%s)_ | 🔴 **FERMO%s** |"
                                % (etichetta, os.path.basename(percorso), d, fonte,
                                   "" if n is None else " da %d giorn%s" % (n, "o" if n == 1 else "i")))
            fermi.append(etichetta)
    out += ["## 🕐 Freschezza dei dati", "",
            "| Conto | File | Contenuto aggiornato al | Stato |",
            "|---|---|---|---|"] + righe_timbro + [""]
    if fermi:
        out += ["> 🔴 **%s: DATO NON ARRIVATO.** Per quest%s conto la pagella "
                "**non stampa un netto di giornata** — un CSV fermo e uno zero "
                "vero sono indistinguibili da qui, e il 04/09/2026 questa "
                "confusione ha fatto pubblicare `+0,00` su un giorno da "
                "**+30,78**." % (" · ".join(fermi), "i" if len(fermi) > 1 else "o"), ""]
    out += ["> ℹ️ La data e' quella dell'**ultimo cambiamento di contenuto nel "
            "repo**. Un CSV che arriva **identico** (nessuna posizione chiusa "
            "nuova) non lascia traccia: `FERMO` vuol dire *\"da li' non arriva "
            "contenuto nuovo\"*, **non** *\"la consegna e' rotta\"*. Per "
            "separare i due casi serve un timbro scritto **dentro** il file "
            "dall'esportatore — oggi non c'e'.", ""]

    if ereditate:
        out += ["> ⚠️ %d posizion%s aperta in giorni precedenti e chiusa oggi "
                "(%s). Per quelle la durata media e la frazione catturata non "
                "sono indicative." %
                (len(ereditate), "e" if len(ereditate) > 1 else "e",
                 ", ".join(sorted({r.get("strategy", "?") for r in ereditate}))), ""]

    # ---------- riepilogo per EA ----------
    perEA = defaultdict(list)
    for r in oggi:
        perEA[r.get("strategy") or ("magic " + str(r.get("magic", "?")))].append(r)

    out += ["## Chi ha operato", "",
            "| EA | Trade | P&L | Durata media | Come sono usciti | Frazione del giorno (solo vincenti) |",
            "|---|---|---|---|---|---|"]
    for ea, tr in sorted(perEA.items(), key=lambda x: -sum(num(r, "profit") for r in x[1])):
        pnl = sum(num(r, "profit") + num(r, "swap") + num(r, "commission") for r in tr)
        dur = [(r["_ct"] - r["_ot"]).total_seconds() for r in tr if r["_ct"]]
        dmed = sum(dur) / len(dur) if dur else 0
        motivi = defaultdict(int)
        for r in tr:
            motivi[r.get("close_reason") or "?"] += 1
        fr = [f for f in (frazione_catturata(r) for r in tr) if f is not None]
        frm = ("%.0f%%" % (100 * sum(fr) / len(fr))) if fr else "—"
        out.append("| %s | %d | **%+.2f** | %s | %s | %s |" % (
            ea, len(tr), pnl,
            ("%.0f s" % dmed) if dmed < 120 else ("%.1f min" % (dmed / 60)),
            " · ".join("%s×%d" % (k, v) for k, v in sorted(motivi.items())), frm))

    # ---------- netto per simbolo ----------
    perSym = defaultdict(float)
    for r in oggi:
        perSym[r.get("symbol", "?")] += num(r, "profit") + num(r, "swap") + num(r, "commission")
    out += ["", "## Netto per simbolo", "",
            "| Simbolo | Netto |", "|---|---|"]
    for sym, v in sorted(perSym.items(), key=lambda x: -x[1]):
        out.append("| %s | **%+.2f** |" % (sym, v))
    out.append("")
    out.append("**Totale giornata: %+.2f**" % sum(perSym.values()))
    out.append("")
    out.append("_Totale della **sola flotta**: le operazioni senza commento "
               "(manuali, magic 0) stanno fuori — vedi sotto._")

    # ---------- FUORI DAL TOTALE: le manuali ----------
    manuali_oggi = [r for r in manuali_tutte
                    if r["_ct"].strftime("%Y-%m-%d") == giorno]
    if manuali_oggi or ambigue:
        out += ["", "## 🚫 Fuori dal totale — operazioni SENZA COMMENTO", ""]
    if manuali_oggi:
        netto_man = sum(num(r, "profit") + num(r, "swap") + num(r, "commission")
                        for r in manuali_oggi)
        perSymMan = defaultdict(lambda: [0, 0.0])
        for r in manuali_oggi:
            v = perSymMan[r.get("symbol", "?")]
            v[0] += 1
            v[1] += num(r, "profit") + num(r, "swap") + num(r, "commission")
        out += ["Trading **manuale** di Claudio sul piccolo (`strategy` vuota, "
                "`magic` 0). **Non entrano nel totale della flotta** qui sopra "
                "— Claudio, 07/09/2026.", "",
                "| Simbolo | Trade | Netto |", "|---|---|---|"]
        for sym, (nn, v) in sorted(perSymMan.items(), key=lambda x: x[1][1]):
            out.append("| %s | %d | **%+.2f** |" % (sym, nn, v))
        out += ["", "**Totale manuale (fuori dal conto): %+.2f** su %d operazioni."
                % (netto_man, len(manuali_oggi)), "",
                "> ⚠️ Attese **zero** manuali dal **%s** in poi: se questo blocco "
                "compare per una data successiva, o il confine e' cambiato o "
                "qualcuno ha operato a mano. **Va guardato, non ignorato.**"
                % CAMBIO_SOLO_EA]
    if ambigue:
        out += ["", "> 🔴 **%d operazion%s con commento e magic DISCORDI** "
                "(una delle due cose dice EA e l'altra no). Il filtro pretende "
                "entrambi i criteri e queste **restano nel totale**: vanno "
                "capite prima di decidere da che parte stanno. pid: %s"
                % (len(ambigue), "i" if len(ambigue) > 1 else "e",
                   ", ".join(str(r.get("pid", "?")) for r in ambigue[:10]))]

    # ---------- segnalazioni ----------
    avvisi = []

    # 1) sovrapposizioni: stesso simbolo, FINESTRE che si sovrappongono
    #    (oppure ingressi entro 10 minuti, per continuare a vedere i whipsaw)
    #
    # ⚠️ 06/08: "DIREZIONI OPPOSTE" va detto SOLO se le due posizioni erano
    #    aperte NELLO STESSO ISTANTE. Prima bastava che gli ingressi fossero
    #    vicini, e oggi ha prodotto due falsi allarmi su NASUSD: l'`ORB` che
    #    si gira DOPO essere stato stoppato non e' una copertura, e' un
    #    whipsaw. E' lo stesso errore che avevo gia' fatto due volte a mano
    #    leggendo lo Storico invece delle posizioni aperte: qui lo chiude
    #    il codice, non la memoria.
    # ⚠️ 31/08: il filtro "ingressi entro 600 s" era un SURROGATO della
    #    sovrapposizione e falliva proprio sulle posizioni tenute per ore:
    #    GAP long 01:00 + SUPERWAVE short 06:00 = 8,5 ORE opposte sul Dow,
    #    scartate perche' gli ingressi distavano 5 ore. Stessa radice dei
    #    tre casi persi a cavallo di due giorni (19, 21, 25/08). Ora la
    #    coppia entra se le FINESTRE si toccano, a qualunque distanza
    #    d'ingresso; il criterio dei 600 s resta solo per le sequenze
    #    ravvicinate (whipsaw), che per definizione non si sovrappongono.
    persym = defaultdict(list)
    for r in oggi:
        persym[r.get("symbol", "?")].append(r)
    for sym, tr in persym.items():
        tr = sorted(tr, key=lambda r: r["_ot"])
        for i in range(len(tr)):
            for j in range(i + 1, len(tr)):
                dt = (tr[j]["_ot"] - tr[i]["_ot"]).total_seconds()
                a, b = tr[i], tr[j]
                # sovrapposizione vera: l'ultimo ad aprire lo fa prima che il primo chiuda
                sovrapposte = True
                if a["_ct"] and b["_ct"]:
                    sovrapposte = max(a["_ot"], b["_ot"]) < min(a["_ct"], b["_ct"])
                if not sovrapposte and dt > 600:
                    continue
                if a.get("side") != b.get("side"):
                    coda = (" — ⚠️ **DIREZIONI OPPOSTE, contemporanee**" if sovrapposte
                            else " — direzioni opposte ma **in sequenza**: la seconda apre "
                                 "dopo la chiusura della prima (inversione, non copertura)")
                else:
                    coda = ("" if sovrapposte
                            else " — **in sequenza**, non contemporanee")
                dist = ("%.0f s" % dt) if dt <= 600 else ("%.1f ore" % (dt / 3600.0))
                avvisi.append(
                    "🔶 **%s**: `%s` (%s) e `%s` (%s) a **%s** di distanza d'ingresso%s" % (
                        sym, a.get("strategy"), a.get("side"), b.get("strategy"),
                        b.get("side"), dist, coda))

    # 2) uscite troppo rapide o frazione bassa
    for r in oggi:
        if not r["_ct"]:
            continue
        d = (r["_ct"] - r["_ot"]).total_seconds()
        f = frazione_catturata(r)
        if num(r, "profit") > 0 and d < DURATA_SOSPETTA:
            avvisi.append("⏱️ **%s** su %s: chiuso in **%.0f s** in profitto (%s) — "
                          "gestione probabilmente troppo stretta" % (
                              r.get("strategy"), r.get("symbol"), d,
                              r.get("close_reason") or "?"))
        elif f is not None and f < FRAZIONE_BASSA:
            avvisi.append("📉 **%s** su %s: preso il **%.0f%%** di quanto la giornata offriva "
                          "dopo il suo ingresso (uscito con `%s`)" % (
                              r.get("strategy"), r.get("symbol"), 100 * f,
                              r.get("close_reason") or "?"))

    if avvisi:
        out += ["", "## ⚠️ Da guardare", ""] + ["- " + a for a in dict.fromkeys(avvisi)]
    else:
        out += ["", "_Nessuna anomalia rilevata: nessuna sovrapposizione, "
                "nessuna uscita anomala._"]

    # ---------- CONTO 100K (dry-run FTMO col Guardiano) ----------
    # Perimetro dichiarato SEMPRE: la lettura del 10/08 e' nata proprio dal
    # fatto che la pagella vedeva solo il piccolo mentre la giornata vera
    # era sul 100k.
    out += ["", "## 🛡️ Conto 100k — dry-run FTMO (50504263)", ""]
    if not os.path.exists(CSV_100K):
        out += ["_CSV del 100k non ancora sul repo: questa sezione si accende "
                "quando sul VPS gira il `pubblica_trades.ps1` aggiornato "
                "(pubblica anche `ABTG_Trades_100k.csv`)._"]
    else:
        with open(CSV_100K, encoding="utf-8-sig", newline="") as f:
            r100 = list(csv.DictReader(f, delimiter=";"))
        for r in r100:
            r["_ot"] = tempo(r.get("open_time", ""))
            r["_ct"] = tempo(r.get("close_time", ""))
        r100 = [r for r in r100 if r["_ot"] and r["_ct"]]

        def _netto(r):
            return num(r, "profit") + num(r, "swap") + num(r, "commission")

        netto_storico = sum(_netto(r) for r in r100)
        saldo = DEP_100K + netto_storico
        oggi100 = [r for r in r100 if r["_ct"].strftime("%Y-%m-%d") == giorno]
        netto_oggi = sum(_netto(r) for r in oggi100)

        perGiorno100 = defaultdict(float)
        for r in r100:
            perGiorno100[r["_ct"].strftime("%Y-%m-%d")] += _netto(r)

        if oggi100:
            perEA100 = defaultdict(list)
            for r in oggi100:
                perEA100[r.get("strategy") or ("magic " + str(r.get("magic", "?")))].append(r)
            out += ["| EA | Trade | P&L | Come sono usciti |", "|---|---|---|---|"]
            for ea, tr in sorted(perEA100.items(), key=lambda x: -sum(_netto(r) for r in x[1])):
                motivi = defaultdict(int)
                for r in tr:
                    motivi[r.get("close_reason") or "?"] += 1
                out.append("| %s | %d | **%+.2f** | %s |" % (
                    ea, len(tr), sum(_netto(r) for r in tr),
                    " · ".join("%s×%d" % (k, v) for k, v in sorted(motivi.items()))))
            out.append("")
        elif not fresco[CSV_100K]:
            # Il caso che il 04/09 e' costato un numero pubblicato sbagliato:
            # qui NON si scrive "nessuna posizione chiusa" e NON si scrive
            # "+0,00". Non lo sappiamo, e si dice.
            d100, _f100 = freschezza(CSV_100K)
            out += ["> 🔴 **DATO NON ARRIVATO.** Il CSV del 100k ha contenuto "
                    "fermo al **%s**: non posso dire ne' che il conto abbia "
                    "operato, ne' che non l'abbia fatto. **Nessun netto di "
                    "giornata per questo conto.**" % d100, "",
                    "_Cosa guardare sul VPS: terminale **100k, conto `50504263`, "
                    "cartella `... -V3`** (NON il piccolo `50503392` in "
                    "`BCM Markets MT5 Terminal`, NON il reale `10105439` in "
                    "`C:\\BCM_Reale`) — l'`ABTG_TradeExporter` gira? e "
                    "`pubblica_trades.ps1` prende `ABTG_Trades_100k.csv`?_", ""]
        else:
            out += ["_Nessuna posizione chiusa oggi sul 100k._", ""]

        margine_tot = saldo - FTMO_PAV_TOTALE
        usato_oggi = max(0.0, -netto_oggi)
        margine_giorno = FTMO_LIM_GIORNO - usato_oggi
        peggior_g = min(perGiorno100.values()) if perGiorno100 else 0.0
        if fresco[CSV_100K]:
            out += ["**Saldo realizzato: %.2f**  (netto di oggi: %+.2f · dal via: %+.2f)" % (
                        saldo, netto_oggi, netto_storico), ""]
        else:
            # Il saldo cumulato resta un fatto vero, ma va DATATO: e' fermo
            # all'ultima consegna, non a stasera. Il "netto di oggi" sparisce.
            d100, _f100 = freschezza(CSV_100K)
            out += ["**Saldo realizzato AL %s: %.2f**  (dal via: %+.2f) — "
                    "⚠️ **fermo all'ultima consegna, non a stasera; il netto di "
                    "oggi NON e' noto.**" % (d100, saldo, netto_storico), ""]
        out += ["| Regola FTMO | Pavimento | Margine attuale |", "|---|---|---|",
                "| Perdita totale (statico -10%%) | 90.000 | **%+.2f** (%.2f%% del conto)%s |" % (
                    margine_tot, 100.0 * margine_tot / DEP_100K,
                    "" if fresco[CSV_100K] else " _(all'ultima consegna)_"),
                ("| Perdita giornaliera (-5%%) | -5.000/giorno | oggi usati %.2f -> restano **%.2f** |" % (
                    usato_oggi, margine_giorno)) if fresco[CSV_100K] else
                "| Perdita giornaliera (-5%) | -5.000/giorno | 🔴 **NON CALCOLABILE**: dato non arrivato |",
                "",
                "Peggior giornata dal via: **%+.2f**. _Numeri dal solo REALIZZATO " % peggior_g +
                "(il CSV non vede il floating): l'arbitro vero dei pavimenti resta "
                "il Guardian, che legge l'equity._"]

    # ---------- CONTO REALE (10105439) ----------
    # Terza sezione, 08/09/2026, su richiesta di Claudio: "voglio che monitori
    # automaticamente il conto reale come fai con gli altri".
    #
    # 🔴 QUI SI E' PIU' PRUDENTI CHE ALTROVE, e non e' un vezzo: sugli altri due
    #    conti un numero sbagliato costa una lettura, qui costa dei soldi. Per
    #    questo la sezione, prima di stampare QUALSIASI totale:
    #      1) controlla che ci siano tutte le colonne che le servono;
    #      2) pretende che OGNI riga sia leggibile (date e importi);
    #      3) se anche una sola non lo e', DICHIARA e NON stampa il totale.
    #    Un totale a meta' su un conto vero e' peggio di nessun totale: sembra
    #    un numero, e invece e' un'opinione.
    out += ["", "## 💶 Conto REALE 10105439 — soldi veri", ""]
    if not os.path.exists(CSV_REALE):
        out += ["_CSV del conto reale **non ancora sul repo**: la sezione si accende "
                "da sola quando il file arriva._", "",
                "**Perche' non c'e' (misurato l'08/09/2026):** sul terminale del "
                "reale (`C:\\BCM_Reale`) **non gira nessun `ABTG_TradeExporter`**. "
                "Il censimento dei `.chr` di quel terminale trova tre EA "
                "(`ABTG_DAX_Apertura_EU` 770101, `ABTG_ORB_Ottimizzato` 770611, "
                "`ABTG_SlippageLogger`) e nessun esportatore. Senza esportatore "
                "non esiste `%s` in `Common\\Files`, e `pubblica_trades.ps1` non "
                "ha niente da caricare." % CSV_REALE_MT5, "",
                "> ⚠️ Il censimento legge i `.chr`, cioe' una **foto al salvataggio "
                "del profilo**: e' un indizio forte, non un fatto certo. "
                "Istruzioni per accendere l'esportatore (gesto di Claudio sul "
                "terminale reale): `report/PAGELLA_CONTO_REALE_2026-09-08.md`."]
    else:
        with open(CSV_REALE, encoding="utf-8-sig", newline="") as f:
            lettore = csv.DictReader(f, delimiter=";")
            intestazione = lettore.fieldnames or []
            rreale = list(lettore)
        mancanti = [c for c in COLONNE_MINIME if c not in intestazione]
        if mancanti:
            # 🔴 colonna mancante = niente totale. Dichiarato, non aggirato.
            out += ["> 🔴 **Il CSV del reale non ha le colonne che servono: "
                    "manca%s `%s`.** Su un conto vero non stampo un totale a "
                    "meta': la sezione si ferma qui. Colonne trovate: `%s`."
                    % ("no" if len(mancanti) > 1 else "",
                       "`, `".join(mancanti),
                       "`, `".join(intestazione) if intestazione else "(nessuna)")]
        elif not rreale:
            out += ["_Il CSV del reale c'e' ma e' **vuoto** (solo intestazione): "
                    "nessuna posizione chiusa esportata. Nessun totale da dare._"]
        else:
            # 1) leggibilita' RIGA PER RIGA: date e importi.
            illeggibili = []
            for r in rreale:
                r["_ot"] = tempo(r.get("open_time", ""))
                r["_ct"] = tempo(r.get("close_time", ""))
                r["_num_ok"] = all(leggibile(r, k)
                                   for k in ("profit", "swap", "commission"))
                if not (r["_ot"] and r["_ct"] and r["_num_ok"]):
                    illeggibili.append(r)

            if illeggibili:
                # 🔴 nessun totale finche' non si capiscono: sono soldi veri.
                out += ["> 🔴 **%d rig%s del CSV del reale non %s leggibil%s** "
                        "(data o importo non interpretabile). Su un conto vero "
                        "**non stampo un totale che le salta**: vanno capite "
                        "prima. pid: %s"
                        % (len(illeggibili),
                           "he" if len(illeggibili) > 1 else "a",
                           "sono" if len(illeggibili) > 1 else "e'",
                           "i" if len(illeggibili) > 1 else "e",
                           ", ".join(str(r.get("pid", "?")) for r in illeggibili[:10])),
                        "",
                        "_Il resto della sezione resta spento fino ad allora: "
                        "una sezione muta e' un'informazione, un totale "
                        "sbagliato no._"]
            else:
                # 2) stesso filtro del piccolo: le operazioni SENZA COMMENTO
                #    (strategy vuota E magic 0) stanno FUORI dal totale, ma si
                #    mostrano. Firma di Claudio del 07/09: non e' una regola
                #    "del piccolo", e' come si legge un conto.
                man_reale = [r for r in rreale if senza_commento(r)]
                amb_reale = discordi(rreale)
                flotta_reale = [r for r in rreale if not senza_commento(r)]

                def _netto_r(r):
                    return num(r, "profit") + num(r, "swap") + num(r, "commission")

                netto_storico_re = sum(_netto_r(r) for r in flotta_reale)
                oggi_re = [r for r in flotta_reale
                           if r["_ct"].strftime("%Y-%m-%d") == giorno]
                netto_oggi_re = sum(_netto_r(r) for r in oggi_re)

                perGiorno_re = defaultdict(float)
                for r in flotta_reale:
                    perGiorno_re[r["_ct"].strftime("%Y-%m-%d")] += _netto_r(r)
                peggior_re = min(perGiorno_re.values()) if perGiorno_re else 0.0

                if oggi_re:
                    perEA_re = defaultdict(list)
                    for r in oggi_re:
                        perEA_re[r.get("strategy") or ("magic " + str(r.get("magic", "?")))].append(r)
                    out += ["| EA | Trade | P&L | Come sono usciti |", "|---|---|---|---|"]
                    for ea, tr in sorted(perEA_re.items(),
                                         key=lambda x: -sum(_netto_r(r) for r in x[1])):
                        motivi = defaultdict(int)
                        for r in tr:
                            motivi[r.get("close_reason") or "?"] += 1
                        out.append("| %s | %d | **%+.2f** | %s |" % (
                            ea, len(tr), sum(_netto_r(r) for r in tr),
                            " · ".join("%s×%d" % (k, v) for k, v in sorted(motivi.items()))))
                    out.append("")
                else:
                    out += ["_Nessuna posizione chiusa oggi sul reale._", ""]

                out += ["**Netto REALIZZATO della flotta sul reale: "
                        "%+.2f** (oggi: %+.2f · su %d operazioni dal via)"
                        % (netto_storico_re, netto_oggi_re, len(flotta_reale)),
                        "",
                        "Peggior giornata dal via: **%+.2f**." % peggior_re]

                # 🔴 Il SALDO non si stampa: il deposito iniziale del reale non
                #    e' un dato di questo CSV. Inventarlo (come DEP_100K, che
                #    li' e' un fatto del dry-run) sarebbe un numero finto su un
                #    conto vero. Si dice, non si indovina.
                out += ["", "> ⚠️ Qui c'e' il **netto realizzato**, non il saldo: "
                        "il deposito iniziale del reale non sta in questo CSV e "
                        "**non lo invento**. E come per il 100k, il CSV **non "
                        "vede il floating**: l'arbitro dei pavimenti resta chi "
                        "legge l'equity."]

                if man_reale:
                    netto_man_re = sum(_netto_r(r) for r in man_reale)
                    ultima = max(r["_ct"] for r in man_reale).strftime("%Y-%m-%d")
                    out += ["", "### 🚫 Fuori dal totale — operazioni SENZA COMMENTO (reale)", "",
                            "`strategy` vuota **e** `magic` 0: non appartengono a "
                            "nessuna nostra sedia. **%d operazion%s, %+.2f** "
                            "(ultima il %s). **Non entrano** nel netto qui sopra "
                            "— stessa regola del piccolo, Claudio 07/09/2026."
                            % (len(man_reale), "i" if len(man_reale) > 1 else "e",
                               netto_man_re, ultima)]
                if amb_reale:
                    out += ["", "> 🔴 **%d operazion%s con commento e magic DISCORDI "
                            "sul CONTO REALE.** Restano nel totale e vanno capite: "
                            "pid %s"
                            % (len(amb_reale), "i" if len(amb_reale) > 1 else "e",
                               ", ".join(str(r.get("pid", "?")) for r in amb_reale[:10]))]

    os.makedirs(OUT_DIR, exist_ok=True)
    dest = os.path.join(OUT_DIR, "giornata_%s.md" % giorno)
    with open(dest, "w", encoding="utf-8") as f:
        f.write("\n".join(out) + "\n")
    print("\n".join(out))
    print("\n-> scritto %s" % dest)


if __name__ == "__main__":
    main()
