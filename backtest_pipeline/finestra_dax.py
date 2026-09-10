#!/usr/bin/env python3
# -*- coding: ascii -*-
"""
MARCATORE_FINESTRA_DAX_v2

LA CONVENZIONE ORARIA DEL DAX 2019/2024-2026: SI RIPARA COL TAGLIO?
Richiesta di Claudio, 10/09/2026: "RIPARA LA CONVENZIONE ORARIA DEL DAX".

=====================================================================
 PERCHE' ESISTE LA v2 -- la v1 MENTIVA, ed e' stato misurato
=====================================================================
 Il controllo-preventivo ha costruito un anno finto con l'orologio
 spostato di UNA SOLA ORA (nucleo 03-16 invece di 02-15) e copertura
 24h. La v1 ha stampato densita' ristretta 55,6, dentro la banda
 55,0-62,0, e ha concluso "CONFERMATA: l'orologio e' LO STESSO", rc 0.
   -> CLASSE 178: una banda di attesa va provata contro l'IPOTESI
      ALTERNATIVA, non solo contro il nulla. Il bordo basso stava
      esattamente dove l'alternativa atterra.
 Piu' altri sei difetti, tutti riprodotti sul banco:
   - la formula della densita' NON era quella del referto (v1 usava lo
     SPAN max-min+1 e tutte le barre; il referto usa il CONTEGGIO delle
     ore COPERTE e solo le barre dentro quelle ore);
   - il verdetto trascinava dentro i MARCI 2020-2023 -> falsa SMENTITA
     garantita sulla cache vera (CLASSE 180);
   - zero barre del simbolo, zip corrotto, anno senza barre nella
     finestra: sparivano in silenzio (CLASSE 177);
   - un CSV col nome non riconosciuto veniva contato come DAX.

=====================================================================
 COSA SEPARA DAVVERO LE DUE IPOTESI: L'ORA DI INIZIO DEL NUCLEO
=====================================================================
 Il DAX gira 08:00-22:00 CET. CET = NY+6 tutto l'anno (fanno DST
 entrambi). Quindi l'ora in cui comincia il blocco denso DICE
 l'orologio del file, e non serve nessuna banda:

     orologio del file      inizio nucleo atteso
     New York (l'ipotesi)   02
     UTC                    06
     CET / Berlino          08
     EST fisso              02 d'inverno, 03 d'estate

 Questo e' il test PRINCIPALE. La densita' ristretta e' il test di
 conferma, e da sola NON basta.

=====================================================================
 L'ATTESA, SCRITTA PRIMA DI VEDERE I NUMERI
=====================================================================
   A) inizio nucleo degli anni dell'ipotesi (2019, 2024, 2025, 2026)
      = 02, come i sani.                       <- SE FALLISCE, BASTA
   B) densita' ristretta alla finestra 02-15 nella banda 57,5-60,5
      (i sani stanno in 58,1-59,6: banda = sani +/- 1,5).
   C) controllo negativo: uno spostamento di 1 ora deve far fallire A.
   D) controllo indipendente: nsxusd (Nasdaq) e' 24h da SEMPRE nel
      referto, densita' 42-45. Il suo nucleo, se il file e' in ora di
      New York, deve cominciare verso le 09 (cash USA 09:30 NY).
      E' un orologio letto su un ALTRO strumento, senza assunzioni.

 Se A e B passano -> l'orologio e' lo stesso, la riparazione e' un
 TAGLIO alla finestra, e serve una firma per dichiararlo.
 Se A fallisce -> non e' copertura, e' l'OROLOGIO: si SPOSTA, non si
 taglia, e il numero da usare e' il lag misurato.

 USO:
   python finestra_dax.py --autotest
   python finestra_dax.py --cache "C:\\Users\\Master\\histdata_m1"
"""
import argparse, os, re, sys, zipfile
from collections import defaultdict

MARCATORE       = "MARCATORE_FINESTRA_DAX_v2"
FINESTRA_SANI   = (2, 15)                       # ore incluse
ANNI_SANI       = list(range(2010, 2019))
ANNI_IPOTESI    = [2019, 2024, 2025, 2026]      # CLASSE 180: elencati, non per differenza
ANNI_MARCI      = [2020, 2021, 2022, 2023]      # fuori ipotesi: misurati, non giudicati
BANDA           = (57.5, 60.5)
NUCLEO_MIN      = 40.0                          # barre/giorno per dire "ora del nucleo"
INIZIO_ATTESO   = 2                             # ora di New York
OROLOGI         = [("New York", 2), ("UTC", 6), ("CET/Berlino", 8)]

def log(s=""): print(s)

# ---------------------------------------------------------------- lettura
def leggi_zip(percorso, simbolo, saltati):
    """Barre (anno, mese, giorno, ora) del simbolo chiesto.
    FALLISCE CHIUSO: se il nome del CSV non e' riconoscibile, SALTA e lo
    DICE (nella v1 veniva contato come se fosse il simbolo giusto)."""
    fuori = []
    with zipfile.ZipFile(percorso) as z:
        for n in z.namelist():
            if not n.lower().endswith(".csv"):
                continue
            base = os.path.basename(n).upper()
            m = re.search(r"DAT_ASCII_([A-Z]{6})_M1_", base) or re.search(r"([A-Z]{6})", base)
            if not m:
                saltati.append("%s / %s: simbolo non riconosciuto" % (os.path.basename(percorso), n))
                continue
            pair = m.group(1).lower()
            if pair != simbolo.lower():
                continue
            for riga in z.read(n).decode("ascii", "ignore").splitlines():
                riga = riga.strip()
                if len(riga) < 15 or not riga[0:8].isdigit():
                    continue
                try:
                    aa = int(riga[0:4]); mm = int(riga[4:6])
                    gg = int(riga[6:8]); oo = int(riga[9:11])
                except ValueError:
                    continue
                if 1 <= mm <= 12 and 1 <= gg <= 31 and 0 <= oo <= 23:
                    fuori.append((aa, mm, gg, oo))
    return fuori

def inventario(cartella, simbolo):
    """Quali anni del simbolo ci sono, PRIMA di misurare (classe 177)."""
    anni = set()
    zips = sorted([f for f in os.listdir(cartella) if f.lower().endswith(".zip")])
    for nz in zips:
        m = re.search(r"([A-Za-z]{6})_M1_(\d{4})", nz)
        if m and m.group(1).lower() == simbolo.lower():
            anni.add(int(m.group(2)))
    return zips, sorted(anni)

def misura(cartella, simbolo):
    ore = defaultdict(lambda: defaultdict(int))          # anno -> ora -> barre
    ore_gg = defaultdict(lambda: defaultdict(set))       # anno -> ora -> giorni distinti
    giorni = defaultdict(set)
    rotti, saltati = [], []
    zips = sorted([f for f in os.listdir(cartella) if f.lower().endswith(".zip")])
    for nz in zips:
        try:
            barre = leggi_zip(os.path.join(cartella, nz), simbolo, saltati)
        except Exception as e:
            rotti.append("%s: %s" % (nz, e))
            continue
        for (aa, mm, gg, oo) in barre:
            ore[aa][oo] += 1
            ore_gg[aa][oo].add((mm, gg))
            giorni[aa].add((mm, gg))
    return {"ore": ore, "ore_gg": ore_gg, "giorni": giorni,
            "rotti": rotti, "saltati": saltati, "n_zip": len(zips)}

# ---------------------------------------------------------------- metriche
def coperte(d, aa):
    """Ore COPERTE = con almeno 1 barra in almeno META' dei giorni.
    E' la definizione del referto (MetricheDaGriglia), non lo span."""
    gg = len(d["giorni"][aa])
    if gg == 0:
        return []
    soglia = gg / 2.0
    return sorted([h for h, s in d["ore_gg"][aa].items() if len(s) >= soglia])

def densita_referto(d, aa, solo=None):
    """barre NELLE ORE COPERTE / (giorni x NUMERO di ore coperte).
    Con 'solo' si limita l'insieme delle ore (la finestra ristretta)."""
    cop = coperte(d, aa)
    if solo is not None:
        cop = [h for h in cop if solo[0] <= h <= solo[1]]
    gg = len(d["giorni"][aa])
    if not cop or gg == 0:
        return None, cop
    barre = sum(d["ore"][aa][h] for h in cop)
    return float(barre) / (float(gg) * float(len(cop))), cop

def nucleo(d, aa):
    """Prima e ultima ora con almeno NUCLEO_MIN barre/giorno."""
    gg = len(d["giorni"][aa])
    if gg == 0:
        return None, None
    dense = sorted([h for h, c in d["ore"][aa].items() if float(c) / gg >= NUCLEO_MIN])
    if not dense:
        return None, None
    return dense[0], dense[-1]

def profilo(d, aa):
    gg = len(d["giorni"][aa])
    if gg == 0:
        return [0.0] * 24
    return [float(d["ore"][aa].get(h, 0)) / gg for h in range(24)]

def lag_migliore(p_anno, p_rif):
    """Di quante ore va spostato p_anno per assomigliare a p_rif?
    0 = stesso orologio. Serve a NOMINARE lo spostamento invece di
    leggerlo come 'buchi'."""
    best, best_s = 0, -1.0
    for k in range(-6, 7):
        s = sum(p_anno[(h + k) % 24] * p_rif[h] for h in range(24))
        if s > best_s:
            best_s, best = s, k
    return best

# ---------------------------------------------------------------- stampa
def stampa_profilo(d, aa):
    p = profilo(d, aa)
    log("        ore 00-11: " + " ".join("%5.0f" % x for x in p[0:12]))
    log("        ore 12-23: " + " ".join("%5.0f" % x for x in p[12:24]))

def rapporto(d, anni_visti, mostra_profilo):
    o0, o1 = FINESTRA_SANI
    log("")
    log("anno  gruppo     barre    giorni  coperte  dens     nucleo   dens 02-15  lag")
    log("-" * 92)
    ris = {}
    p_sani = None
    sani_ok = [a for a in ANNI_SANI if a in anni_visti and len(d["giorni"][a]) > 0]
    if sani_ok:
        acc = [0.0] * 24
        for a in sani_ok:
            pa = profilo(d, a)
            for h in range(24):
                acc[h] += pa[h]
        p_sani = acc
    for aa in sorted(anni_visti):
        gg = len(d["giorni"][aa])
        tot = sum(d["ore"][aa].values())
        dt, cop = densita_referto(d, aa)
        dr, copr = densita_referto(d, aa, solo=FINESTRA_SANI)
        n0, n1 = nucleo(d, aa)
        lg = lag_migliore(profilo(d, aa), p_sani) if p_sani else None
        grp = ("SANO" if aa in ANNI_SANI else
               "IPOTESI" if aa in ANNI_IPOTESI else
               "marcio" if aa in ANNI_MARCI else "altro")
        ris[aa] = {"dens_r": dr, "nucleo": (n0, n1), "lag": lg, "gruppo": grp,
                   "giorni": gg, "barre": tot, "coperte": len(cop)}
        log("%-5d %-10s %-8d %-7d %-8d %-8s %-8s %-11s %s" % (
            aa, grp, tot, gg, len(cop),
            ("%.1f" % dt) if dt else "n/d",
            ("%02d-%02d" % (n0, n1)) if n0 is not None else "n/d",
            ("%.1f" % dr) if dr else "NON MIS.",
            ("%+d" % lg) if lg is not None else "-"))
        if mostra_profilo and (aa in ANNI_IPOTESI or aa in ANNI_SANI[-1:]):
            stampa_profilo(d, aa)
    return ris

def verdetto(ris, mancanti, rotti, saltati):
    lo, hi = BANDA
    log("")
    log("=" * 72)
    log(" VERDETTO -- contro l'attesa scritta PRIMA")
    log("=" * 72)
    fermo = False
    if mancanti:
        log("  FERMATI: mancano dalla cache gli anni dell'ipotesi: %s"
            % ", ".join(str(a) for a in mancanti))
        log("           NON e' 'niente da riparare': e' CACHE INCOMPLETA.")
        log("           Gli zip 2019-2026 del DAX stanno sul PC DI BACKTEST.")
        fermo = True
    if rotti:
        log("  FERMATI: %d zip NON LETTI (corrotti):" % len(rotti))
        for r in rotti[:5]:
            log("           " + r)
        fermo = True
    if saltati:
        log("  ATTENZIONE: %d CSV saltati perche' il simbolo non e' riconoscibile:" % len(saltati))
        for s in saltati[:5]:
            log("           " + s)
    # A) il test PRINCIPALE: l'ora di inizio del nucleo
    ip = {a: v for a, v in ris.items() if v["gruppo"] == "IPOTESI"}
    sa = {a: v for a, v in ris.items() if v["gruppo"] == "SANO"}
    if not ip:
        log("  NON CONCLUSIVO: nessun anno dell'ipotesi misurato.")
        return 2
    log("")
    log("  A) TEST PRINCIPALE -- ora di inizio del NUCLEO (atteso %02d = New York)" % INIZIO_ATTESO)
    for nome, h in OROLOGI:
        log("       se il file fosse in %-13s l'inizio sarebbe %02d" % (nome, h))
    inizi = {}
    for a in sorted(ip):
        n0 = ip[a]["nucleo"][0]
        inizi[a] = n0
        log("     %d -> inizio nucleo %s   lag contro i sani %s" % (
            a, ("%02d" % n0) if n0 is not None else "NON MISURATO",
            ("%+d" % ip[a]["lag"]) if ip[a]["lag"] is not None else "-"))
    if sa:
        s0 = [v["nucleo"][0] for v in sa.values() if v["nucleo"][0] is not None]
        if s0:
            log("     controllo positivo (SANI): inizio nucleo %02d-%02d" % (min(s0), max(s0)))
            if min(s0) != INIZIO_ATTESO or max(s0) != INIZIO_ATTESO:
                log("     !! I SANI non cominciano alle %02d: il difetto e' in questo" % INIZIO_ATTESO)
                log("        script o nella soglia del nucleo, NON nei dati. Fermarsi.")
                return 2
    if any(v is None for v in inizi.values()):
        log("     ESITO A: NON MISURATO su almeno un anno -> non si conclude.")
        return 2
    fuori = {a: h for a, h in inizi.items() if h != INIZIO_ATTESO}
    if fuori:
        log("")
        log("  ESITO: SMENTITA -- NON e' (solo) copertura: e' L'OROLOGIO.")
        for a, h in sorted(fuori.items()):
            log("     %d comincia alle %02d invece che alle %02d (lag %+d)"
                % (a, h, INIZIO_ATTESO, ris[a]["lag"] or 0))
        log("     Quegli anni NON si riparano col taglio: si SPOSTANO del lag")
        log("     misurato, e poi si rimisura. Non archiviare come 'bucati'.")
        return 1
    log("     ESITO A: PASSATO -- tutti gli anni dell'ipotesi cominciano alle %02d." % INIZIO_ATTESO)
    # B) conferma sulla densita' ristretta
    log("")
    log("  B) CONFERMA -- densita' ristretta a %02d-%02d, banda %.1f - %.1f"
        % (FINESTRA_SANI[0], FINESTRA_SANI[1], lo, hi))
    nm = [a for a in ip if ip[a]["dens_r"] is None]
    if nm:
        log("     NON MISURATA su: %s -> non si conclude." % ", ".join(str(a) for a in nm))
        return 2
    for a in sorted(ip):
        d = ip[a]["dens_r"]
        log("     %d -> %.1f   %s" % (a, d, "dentro" if lo <= d <= hi else "FUORI"))
    sotto = [a for a in ip if ip[a]["dens_r"] < lo]
    sopra = [a for a in ip if ip[a]["dens_r"] > hi]
    if sopra:
        log("")
        log("  ESITO: DIFETTO DELLO SCRIPT -- sopra 60 barre/ora e' impossibile.")
        return 2
    if fermo:
        log("")
        log("  ESITO: NON CONCLUSIVO (vedi i FERMATI qui sopra).")
        return 2
    if sotto:
        log("")
        log("  ESITO: PARZIALE -- l'orologio e' lo stesso (A passato), ma gli anni")
        log("         %s hanno la seduta piu' sottile dei sani."
            % ", ".join(str(a) for a in sorted(sotto)))
        log("         Il taglio si puo' fare, ma quegli anni vanno DICHIARATI")
        log("         meno densi. Non si spacciano per uguali ai sani.")
        return 1
    log("")
    log("  ESITO: CONFERMATA. Stesso orologio, stessa seduta: la riparazione")
    log("         e' un TAGLIO alla finestra %02d:00-%02d:00." % FINESTRA_SANI)
    log("         Serve una FIRMA per dichiarare la finestra e usare quegli anni.")
    return 0

# ---------------------------------------------------------------- autotest
def autotest():
    import tempfile, io as _io
    log(MARCATORE)
    log("=== AUTOTEST (offline) ===")
    ok = []; ko = []
    def esito(nome, cond):
        (ok if cond else ko).append(nome)
        log(("  [ok ] " if cond else "  [KO ] ") + nome)

    cart = tempfile.mkdtemp(prefix="fdax_")
    def scrivi(anno, ore_barre, giorni=20, simbolo="GRXEUR", nomecsv=None):
        """ore_barre: {ora: barre_per_giorno}"""
        righe = []
        for g in range(1, giorni + 1):
            for h, n in ore_barre.items():
                for mnt in range(n):
                    righe.append("%04d%02d%02d %02d%02d00;1.0;1.0;1.0;1.0;0" % (anno, 1, g, h, mnt))
        buf = _io.BytesIO()
        with zipfile.ZipFile(buf, "w") as z:
            z.writestr(nomecsv or ("DAT_ASCII_%s_M1_%d.csv" % (simbolo, anno)), "\n".join(righe))
        open(os.path.join(cart, "%s_M1_%d.zip" % (simbolo, anno)), "wb").write(buf.getvalue())
    def pulisci():
        for f in os.listdir(cart):
            os.remove(os.path.join(cart, f))

    SEDUTA = dict((h, 59) for h in range(2, 16))
    NOTTE  = dict((h, 25) for h in list(range(0, 2)) + list(range(16, 24)))

    # 1-2. la formula riproduce i numeri VERI del referto (MAPPA_SESSIONI)
    d = {"giorni": {2018: set(range(252))},
         "ore": {2018: dict((h, 209210 // 14) for h in range(2, 16))},
         "ore_gg": {2018: dict((h, set(range(252))) for h in range(2, 16))}}
    v, _ = densita_referto(d, 2018)
    esito("formula: 2018 -> 209210 barre / (252 gg x 14 ore) = 59,3 (referto: 59,3)",
          abs(v - 59.3) < 0.15)
    d2 = {"giorni": {2024: set(range(313))},
          "ore": {2024: dict((h, 332498 // 23) for h in range(0, 23))},
          "ore_gg": {2024: dict((h, set(range(313))) for h in range(0, 23))}}
    v2, _ = densita_referto(d2, 2024)
    esito("formula: 2024 -> 332498 / (313 gg x 23 ore) = 46,2 (referto: 46,2)",
          abs(v2 - 46.2) < 0.15)

    # 3. sano + 24h stesso orologio -> CONFERMATA
    pulisci()
    scrivi(2018, SEDUTA); scrivi(2024, dict(list(SEDUTA.items()) + list(NOTTE.items())))
    dd = misura(cart, "grxeur")
    r = rapporto(dd, sorted(dd["giorni"].keys()), False)
    esito("nucleo dei SANI = 02", r[2018]["nucleo"][0] == 2)
    esito("un 24h con lo STESSO orologio: nucleo 02 e densita' ristretta in banda",
          r[2024]["nucleo"][0] == 2 and 57.5 <= r[2024]["dens_r"] <= 60.5)
    esito("  -> verdetto CONFERMATA (rc 0)", verdetto(r, [], [], []) == 0)

    # 4. IL CASO CHE FACEVA MENTIRE LA v1: orologio spostato di UNA ora
    pulisci()
    scrivi(2018, SEDUTA)
    scrivi(2024, dict(list(dict((h, 59) for h in range(3, 17)).items()) +
                      list(dict((h, 25) for h in list(range(0, 3)) + list(range(17, 24))).items())))
    dd = misura(cart, "grxeur")
    r = rapporto(dd, sorted(dd["giorni"].keys()), False)
    rc = verdetto(r, [], [], [])
    esito("orologio spostato di +1h: il nucleo comincia alle 03, non alle 02",
          r[2024]["nucleo"][0] == 3)
    esito("  -> NON dice CONFERMATA (la v1 diceva rc 0: classe 178)", rc != 0)
    esito("  -> e NOMINA lo spostamento col lag +1", r[2024]["lag"] == 1)

    # 5. anni MARCI presenti: non devono entrare nel verdetto (classe 180)
    pulisci()
    scrivi(2018, SEDUTA); scrivi(2024, dict(list(SEDUTA.items()) + list(NOTTE.items())))
    scrivi(2021, dict((h, 20) for h in range(0, 24)))
    dd = misura(cart, "grxeur")
    r = rapporto(dd, sorted(dd["giorni"].keys()), False)
    esito("un anno MARCIO non entra nel verdetto (rc resta 0)", verdetto(r, [], [], []) == 0)

    # 6. cache senza gli anni dell'ipotesi -> MANCANTI, non 'niente da riparare'
    pulisci()
    scrivi(2018, SEDUTA)
    _, anni = inventario(cart, "grxeur")
    manc = [a for a in ANNI_IPOTESI if a not in anni]
    dd = misura(cart, "grxeur")
    r = rapporto(dd, sorted(dd["giorni"].keys()), False)
    esito("cache incompleta: dichiara i MANCANTI e torna 2 (classe 177)",
          len(manc) == 4 and verdetto(r, manc, [], []) == 2)

    # 7. zip corrotto -> contato, nominato, rc 2
    pulisci()
    scrivi(2018, SEDUTA); scrivi(2024, dict(list(SEDUTA.items()) + list(NOTTE.items())))
    open(os.path.join(cart, "GRXEUR_M1_2025.zip"), "wb").write(b"non sono uno zip")
    dd = misura(cart, "grxeur")
    r = rapporto(dd, sorted(dd["giorni"].keys()), False)
    esito("zip corrotto: contato e dichiarato", len(dd["rotti"]) == 1)
    esito("  -> il verdetto si ferma (rc 2)", verdetto(r, [], dd["rotti"], []) == 2)

    # 8. CSV col nome non riconosciuto: SALTATO, non contato come DAX
    pulisci()
    scrivi(2018, SEDUTA)
    scrivi(2018, dict((h, 59) for h in range(0, 24)), simbolo="XXXXXX", nomecsv="roba.csv")
    dd = misura(cart, "grxeur")
    esito("CSV dal nome non riconosciuto: SALTATO e nominato (v1 lo contava)",
          len(dd["saltati"]) == 1 and len(dd["giorni"].get(2018, [])) == 20)

    for f in os.listdir(cart):
        os.remove(os.path.join(cart, f))
    os.rmdir(cart)
    log("")
    log("AUTOTEST: %d/%d OK" % (len(ok), len(ok) + len(ko)))
    return 0 if not ko else 2

# ---------------------------------------------------------------- main
def main():
    ap = argparse.ArgumentParser()
    ap.add_argument("--autotest", action="store_true")
    ap.add_argument("--cache", default="")
    ap.add_argument("--simbolo", default="grxeur")
    ap.add_argument("--controllo", default="nsxusd",
                    help="simbolo di controllo dell'orologio (24h da sempre)")
    a = ap.parse_args()
    if a.autotest:
        return autotest()
    cart = a.cache or os.path.join(os.path.expanduser("~"), "histdata_m1")
    log(MARCATORE)
    log("cartella cache : %s" % cart)
    log("simbolo        : %s   (controllo orologio: %s)" % (a.simbolo, a.controllo))
    log("finestra dei SANI, dichiarata prima : %02d:00-%02d:00 (ora del FILE)" % FINESTRA_SANI)
    log("anni dell'IPOTESI, elencati prima   : %s" % ", ".join(str(x) for x in ANNI_IPOTESI))
    log("inizio nucleo atteso                : %02d (New York)" % INIZIO_ATTESO)
    log("banda di conferma                   : %.1f - %.1f" % BANDA)
    if not os.path.isdir(cart):
        log("")
        log("FERMATI: la cartella cache NON esiste. Non e' uno zero: e' il posto sbagliato.")
        return 2
    zips, anni = inventario(cart, a.simbolo)
    log("")
    log("--- INVENTARIO (prima di misurare) ---")
    log("  zip nella cartella      : %d" % len(zips))
    log("  anni di %-14s : %s" % (a.simbolo, ", ".join(str(x) for x in anni) if anni else "NESSUNO"))
    mancanti = [x for x in ANNI_IPOTESI if x not in anni]
    log("  anni dell'ipotesi       : attesi %s -> MANCANTI: %s"
        % (", ".join(str(x) for x in ANNI_IPOTESI),
           ", ".join(str(x) for x in mancanti) if mancanti else "nessuno"))
    if not anni:
        log("")
        log("FERMATI: nella cartella non c'e' NESSUNO zip di %s." % a.simbolo)
        log("         NON e' 'niente da riparare': e' la macchina sbagliata.")
        return 2
    d = misura(cart, a.simbolo)
    ris = rapporto(d, sorted(d["giorni"].keys()), True)
    # controllo indipendente dell'orologio su un altro strumento
    if a.controllo:
        _, anni_c = inventario(cart, a.controllo)
        if anni_c:
            dc = misura(cart, a.controllo)
            log("")
            log("--- CONTROLLO OROLOGIO su %s (24h da sempre nel referto) ---" % a.controllo)
            for aa in sorted(dc["giorni"].keys())[:6]:
                n0, n1 = nucleo(dc, aa)
                log("  %d: nucleo %s   (cash USA 09:30 NY -> atteso ~09 se il file e' NY)"
                    % (aa, ("%02d-%02d" % (n0, n1)) if n0 is not None else "n/d"))
        else:
            log("")
            log("--- CONTROLLO OROLOGIO: nessuno zip di %s, saltato (dichiarato) ---" % a.controllo)
    return verdetto(ris, mancanti, d["rotti"], d["saltati"])

if __name__ == "__main__":
    sys.exit(main())
