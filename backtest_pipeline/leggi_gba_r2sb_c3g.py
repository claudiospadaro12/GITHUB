#!/usr/bin/env python3
# -*- coding: ascii -*-
"""
leggi_gba_r2sb_c3g.py -- STRUMENTO D2-B del GBA R2S STADIO B (simboli gemelli a TICK REALI, Modello 4, tre tranche). BOZZA: NON passata dal cancello.
Finche' i due strati del cancello non danno PASS su QUESTO file (SHA256 stampato in testa a ogni lettura), nessun esito dello stadio B si scrive (file prova: le celle restano (C)).

COSA FA (e niente altro). Legge la raccolta GBA_R2S_B.zip (o i 4 zip di lotto GBA_R0_R2SBANC / R2SBNAS / R2SBD30 / R2SBU30) scritta dalla riga
backtest_pipeline/righe/RIGA_LANCIA_GBA_R2S_B.txt (pin d53493a9..., driver GBA_R0_PASSATE.ps1 v5) e, per ogni cella (simbolo, M15) e per ognuna delle TRE tranche
NOMINATE nel file prova (T1 2026.07.01-09.30, T2 2026.04.01-06.30, T3 2026.01.01-03.31; ToDate NON compreso), stampa:
  - se la tranche e' LETTA (passata OK nel driver, finestra letta, G0 del lettore leggi_gba_r0.py OK, tick reali CONFERMATI, CE2-CE6 verdi, ancora CE1 verde) e se no
    COSA MANCA; la tranche giudica il costo solo se LETTA, con >= 100 righe segnale e CE7 verde;
  - n (report), n NETTO (n meno gli ingressi a spread zero), righe segnale, righe a spread > 0 (senza le -1.0x), righe -1.0x, C3G della cella / dei lati / delle
    6 fasce (aritmetica di D2: mediana vera, -1.0x = INFINITO, mediana pari = media delle due centrali arrotondata a 9 decimali, INF se una centrale e' INF), C3G
    senza le -1.0x (CE7), righe >= 40x e >= 50x;
  - l'ESITO DI CELLA (C) / (F) / (N) / (P) ESATTAMENTE nell'ordine dei file prova GBA_R2SB_{NASUSD,D30EUR,U30USD}_2026-10-12.txt: il PRIMO che vale decide;
    nessun esito di questo stadio chiude la casella 4; il MERITO e' sempre NON MISURATO;
  - le tabelle DESCRITTIVE (non decidono nulla): R4 (mediana ATR, mediana spread a spread > 0, giorni server distinti), R5 (ingressi / scartate per spread /
    scartate per posizione aperta: n, mediana stop/spread, mediana ATR), R2 (fascia dominante), PF del report e per lato dai deal SENZA commissione aggiunta,
    DD, perdita a SL, commissioni del tester, lati, attese T1 (sensibilita') e T2/T3 NON STIMATE, C3G aggregato sulle tre tranche (DESCRIZIONE, non decide).
REGOLE (scritte nei file prova prima dei numeri; qui implementate, non reinterpretate):
  tick reali CONFERMATI = colonna 'modello' del manifest 4 E Model=4 nell'ini dello zip E colonna 'qualita' che, tolti gli spazi e in minuscolo, e' ESATTAMENTE
  '100%ticksreali' (il driver r.815 accetta qualsiasi '100%...') E nessuna riga 'ticks data begins from' DEL SIMBOLO con data DOPO l'inizio della tranche (la riga
  assente = tick in cache: il driver non mette KO, qui si scrive accanto). Altrimenti la tranche e' 'storia a tick NON confermata': (C).
  CE7: C3G con e senza le -1.0x da parti diverse di 40,0 = 'NON LEGGIBILE PER SPREAD ZERO' -> esito (N) (file prova, CE7 e (N)).
  (C) almeno una delle TRE tranche nominate non e' letta. (F) tutte lette e almeno una tranche che giudica il costo ha C3G < 40,0. (N) nessuna (F) e in almeno una
  tranche n NETTO < 30, o righe < 100, o righe a spread > 0 < 100, o CE7 rossa. (P) tutte lette, ognuna giudica il costo con C3G >= 40,0, n NETTO >= 30 e >= 100
  righe a spread > 0. Nessun C3G aggregato decide (classe 1104 b). 'Per ogni tranche' vale sulle tre NOMINATE, mai sulle sole lette (classe 1369).
  ANCORA (CE1, file prova ANCORA): la passata R2SBANC deve rifare R1A_01 al CENTESIMO (tolleranza ZERO: 128 operazioni, -6577.48, PF 0.83, qualita 100%ticksreali,
  88416 barre, 25648545 tick, XAUUSD dal 2024.07.10; C3G 21,60, righe >= 50x 280, >= 40x 651, -1.0x 0) e avere l'ini IDENTICO a quello archiviato di R1A_01 salvo
  il nome del Report; se no NESSUN numero degli indici si legge (tutte le tranche (C)). L'A3 (doppione R2SBANC/R1A nel lettore) resta del lettore.
RIFIUTO (nessun numero): pin diverso da d53493a9; SHA dell'EA diverso; RIEPILOGO assente o di un altro lotto/modello; ESITI_R2S_B.txt di un altro pin o che nomina
un lotto fuori elenco; manifest non v5 (32 colonne); lotto non in elenco; la stessa (cella, tranche) due volte; passata non dichiarata nel file prova; simbolo/TF/
modello/tranche/magic/file prova del manifest, dell'ini, dell'AVVIO, della FINESTRA o del report diversi dal file prova; input dell'ini diversi dai pin; giornale
assente; riga che il parser non legge; ora server diversa dall'ora simulata; righe segnale o d'ingresso fuori da [da, a); lettore con SHA256 diverso (ERRORE, uscita 2).
RIUSA, in due modi DIVERSI: (1) D2 leggi_gba_r2s_c3g.py v2 (14384D87...: giornale, analizza, mediana, CE2-CE4-CE6) NON si carica ne' si esegue: costanti e funzioni
sono COPIATE VERBATIM fra i marcatori COPIA_D2, impronta pinnata e verificata dall'autotest (il file D2 sul disco puo' essere un'altra versione: non cambia nulla);
(2) il lettore leggi_gba_r0.py (9CD02D2A...: report, giornale, G0 = costruisci_passata) si ESEGUE dai BYTE di cui si e' verificato lo SHA256.
NON FA: non giudica il merito, non promuove, non legge un PF come merito, non scrive la parola vietata del certificato ne' l'esito di chiusura della casella 4.

USO (sempre con -I)
  python3 -I backtest_pipeline/leggi_gba_r2sb_c3g.py GBA_R2S_B.zip [--csv-out D2B_C3G_R2S_B.csv]
  python3 -I backtest_pipeline/leggi_gba_r2sb_c3g.py GBA_R0_R2SBANC.zip GBA_R0_R2SBNAS.zip ... [--csv-out F]
  python3 -I backtest_pipeline/leggi_gba_r2sb_c3g.py --autotest
  python3 -I backtest_pipeline/leggi_gba_r2sb_c3g.py --costruisci-finto OUT.zip   (zip FINTO per il cancello: ancora = dati veri R1A_01, indici sintetici)
  uscita: 0 letto; 1 autotest fallito; 2 ERRORE / zip RIFIUTATO (nessun numero).
"""
import csv, datetime, hashlib, io, os, re, sys, types, zipfile

sys.dont_write_bytecode = True

QD = os.path.dirname(os.path.abspath(__file__))
VERSIONE = "leggi_gba_r2sb_c3g v1 BOZZA (D2-B, NON passata dal cancello)"

# ---------------------------------------------------------------------------------------------------------------------
#  MODULI RIUSATI: eseguiti dai BYTE di cui si e' verificato lo SHA256 (niente finestra fra controllo ed esecuzione)
# ---------------------------------------------------------------------------------------------------------------------
D2_FILE, D2_V2_SHA = "leggi_gba_r2s_c3g.py", "14384d874d1240217640d5d6b5cfa5a14978fb1b77a484d099943d3fe346df1f"
LG_FILE, LG_SHA = "leggi_gba_r0.py", "9cd02d2a3bd30e3df555f20fc0342cfcccab80222ad671f0bf727be1deaf862f"


def _carica_modulo(nome, file, sha):
    p = os.path.join(QD, file)
    try:
        raw = open(p, "rb").read()
    except OSError as ex:
        sys.stdout.write("ERRORE: %s non leggibile (%s): D2-B non legge niente\n" % (file, ex))
        sys.exit(2)
    h = hashlib.sha256(raw).hexdigest()
    if h != sha:
        sys.stdout.write("ERRORE: %s ha SHA256 %s, D2-B e' scritto contro %s: nessun numero (non si indovina)\n" % (file, h[:16], sha[:16]))
        sys.exit(2)
    m = types.ModuleType(nome)
    m.__file__ = p
    exec(compile(raw, p, "exec"), m.__dict__)
    return m


IMPRONTA_COPIA_D2 = "275451ec1446ca28a3608016574bf90ff0e3a97ca4dc938cac9ba2110d425317"   # SHA256 del testo fra i marcatori COPIA_D2 (costanti e funzioni della v2)
LG = _carica_modulo("lg_leggi_gba_r0", LG_FILE, LG_SHA)   # il G0 e' quello del LETTORE: si esegue il suo codice, pinnato

# ---------------------------------------------------------------------------------------------------------------------
#  COPIA VERBATIM DA D2 v2 (leggi_gba_r2s_c3g.py, SHA256 14384D87..., PASS dello strato 2 del 12/10): costanti e funzioni qui sotto fino a FINE COPIA.
#  Copiate e non importate perche' D2 sul disco puo' cambiare (v3 per l'argento in lavorazione): l'aritmetica di D2-B resta quella della v2.
#  L'autotest ne verifica l'impronta (IMPRONTA_COPIA_D2) e, se sul disco c'e' ancora la v2, l'identita' riga per riga col file.
# ---------------------------------------------------------------------------------------------------------------------
#<<COPIA_D2
FASCE = [(0, 7, "asia"), (7, 12, "europa"), (12, 14, "pausa"), (14, 17, "USA apertura"), (17, 22, "USA pomeriggio"), (22, 24, "rollover")]
RE_SEG = re.compile(r"^\[GBA\] segnale (?P<lato>BUY|SELL)(?: SALTATO \((?P<motivo>[^)]*)\))? \| close (?P<close>[0-9.]+) canale (?P<ll>[0-9.]+)-(?P<hh>[0-9.]+) EMA (?P<ema>[0-9.]+) "
                    r"ATR (?P<atr>[0-9.]+) spread (?P<spread>[0-9.]+) = (?P<pct>-?[0-9.]+)% ATR \(max (?P<max>[0-9.]+)%\) \| stop/spread (?P<rap>-?[0-9.]+)x \| ora server (?P<ora>[0-9]+)")
RE_ING = re.compile(r"^\[GBA\] (?P<lato>BUY|SELL) (?P<lotti>[0-9.]+) lotti @ (?P<prezzo>[0-9.]+) \| SL (?P<sl>[0-9.]+) \((?P<k>[0-9.]+) x ATR (?P<atr>[0-9.]+)\) \| spread (?P<spread>[0-9.]+) \| perdita a SL ~(?P<perdita>-?[0-9.]+) (?P<valuta>\w+)")
# riga del giornale: come $reGba del driver (r.552) e leggi_log del lettore (r.260)
RE_RIGA = re.compile(r"^(?P<st>\d{4}\.\d\d\.\d\d \d\d:\d\d:\d\d)\s+(?P<msg>\[GBA.*)$")
# [GBA-CONTA] FINE con TUTTI i contatori dell'EA (EA r.735; il lettore ne legge solo i primi quattro)
RE_CONTA = re.compile(r"^\[GBA-CONTA\] FINE \| segnali (?P<seg>[0-9]+) \| ingressi tentati (?P<ing>[0-9]+) \| scartati: SPREAD (?P<spr>[0-9]+) \(spread max [0-9.]+ x ATR\) \| "
                      r"posizione aperta (?P<pos>[0-9]+) \| ora (?P<ora>[0-9]+) \| perdita giornaliera (?P<giorno>[0-9]+) \| lato spento (?P<lato>[0-9]+) \| ATR non valido (?P<dati>[0-9]+) \| "
                      r"tetto giornaliero (?P<tetto>[0-9]+)")
RE_AVVIO = re.compile(r'^\[GBA\] AVVIO v[0-9.]+ \| InpSymbol="(?P<sim>[^"]*)" -> simbolo (?P<sim2>\S+) \| InpSignalTF=(?P<tf>\S+) -> PERIOD_(?P<tf2>[A-Z0-9]+)')
RE_FINESTRA = re.compile(r"^# FINESTRA (?P<sim>[^|]+)\|(?P<tf>[^|]+)\|(?P<da>[^|]+)\|(?P<ha>[^|]+)\|(?P<a>[^|]+)\|(?P<hb>[^|]+)$")
MOTIVI_EA = ("ok", "posizione gia' aperta", "fuori orario", "perdita giornaliera raggiunta", "spread oltre il limite", "ATR non valido", "lato spento",
             "tetto di operazioni del giorno")   # EA GbaMotivoTesto r.741-752
SOGLIA_V_X = 40.0            # (v) di E4: righe della cella con stop/spread >= 40,0x (frontiera di casa, inclusivo; -1.0x = INFINITO e conta)
CE3_MEDIANA_MIN, CE3_P10_MIN, CE3_SOGLIA_QUOTA = 50.0, 49.0, 40.0
FIRMA_ORO_SPREAD = (0.15, 0.30)   # CE2: spread mediano di fascia dell'oro (S0 0,17-0,25)
FIRMA_ORO_ATR_XAG = 0.60          # CE2 argento: e ATR mediana > 0,60
INF = float("inf")
ARCH = os.path.join(QD, "risultati_archivio")
ACC_S0 = {"zip": os.path.join(ARCH, "GBA_R0_S0_20261010", "GBA_R0_S0.zip"), "sha": "0cbaa6e82cd612558f0234741f0abdd54634e587ffe45a53a644d076befbbe6c",
          "log": "log/GBA_S0_01_REPL_T1_m775800.txt"}
ACC_R1A = {"zip": os.path.join(ARCH, "GBA_R0_R1A_20261010", "GBA_R0_R1A.zip"), "sha": "76837ce60c53d4806c79db2d0f3a5754b84a227c878f6f92b8e2d783d7d5014f",
           "log": "log/GBA_R1A_01_REPL_T1_m775800.txt"}


class Rifiuto(Exception):
    """Lo zip non si legge: nessun numero esce (non si indovina)."""


def mediana(v):
    """Mediana VERA: n dispari = il valore centrale; n PARI = media delle due centrali (dichiarato). INF entra come valore. Vuota -> None."""
    if not v:
        return None
    s = sorted(v)
    n = len(s)
    if n % 2 == 1:
        return s[n // 2]
    a, b = s[n // 2 - 1], s[n // 2]
    if a == INF or b == INF:
        return INF
    return round((a + b) / 2.0, 9)   # niente ulp sotto la soglia: (10.2 + 16.4) / 2 = 13.299999999999999 senza round


def percentile(v, p):
    """Come il lettore (r.316): indice int(p x (n-1)) sui valori ordinati."""
    if not v:
        return None
    s = sorted(v)
    return s[min(len(s) - 1, int(p * (len(s) - 1)))]


def fx(x, d=2):
    if x is None:
        return "n.d."
    if x == INF:
        return "INF"
    return ("%." + str(d) + "f") % x


def uguale(a, b):
    return a is not None and b is not None and abs(a - b) < 0.005


def _norm(v):
    """Copiata dal lettore (r.506): '1.0' e '1.00' sono lo stesso input."""
    try:
        if re.fullmatch(r"-?[0-9]+(\.[0-9]+)?", str(v)):
            return repr(float(v))
    except ValueError:
        pass
    return str(v)


def leggi_giornale(testo, etich="giornale"):
    """Restituisce {righe, ingressi_eseguiti, conta, avvio, finestre, doppioni, ridotti}. Rifiuto su ogni riga che non si sa leggere."""
    msgs, ordine, testa = {}, [], []
    for riga in testo.splitlines():
        riga = riga.rstrip()
        if not riga:
            continue
        if riga.startswith("#"):
            testa.append(riga)
            continue
        m = RE_RIGA.match(riga)
        if not m:
            continue
        st, msg = m.group("st"), m.group("msg").rstrip()
        k = st + "|" + msg[:70]                       # chiave del driver r.719-721
        if k not in msgs:
            msgs[k] = [st, msg]
            ordine.append(k)
        else:
            if len(msg) > len(msgs[k][1]):
                msgs[k][1] = msg
            msgs[k].append(None)                    # segna il doppione
    doppioni = sum(len(msgs[k]) - 2 for k in ordine)
    out = {"righe": [], "ingressi_eseguiti": [], "conta": None, "avvio": [], "finestre": [], "doppioni": doppioni, "ridotti": 0, "conta_n": 0}
    for t in testa:
        mf = RE_FINESTRA.match(t)
        if mf:
            out["finestre"].append(mf.groupdict())
    for k in ordine:
        st, msg = msgs[k][0], msgs[k][1]
        if msg.startswith("[GBA] segnale "):
            ms = RE_SEG.match(msg)
            if not ms:
                raise Rifiuto("%s: riga segnale che il parser NON legge (non si indovina): %s" % (etich, msg[:160]))
            d = ms.groupdict()
            rap = float(d["rap"])
            if rap < 0 and rap != -1.0:
                raise Rifiuto("%s: stop/spread negativo diverso da -1.0x (%s): sentinella sconosciuta" % (etich, d["rap"]))
            ora = int(d["ora"])
            if not 0 <= ora <= 23:
                raise Rifiuto("%s: ora server %d fuori da 0-23" % (etich, ora))
            # OROLOGIO: il campo 'ora server' e' dt.hour dell'apertura della barra (EA r.695-696, r.726); l'orario della riga e' quello simulato del tester (driver
            # $reGba r.552), nella stessa barra. Sui giornali dell'oro coincidono su 6973 righe su 6973 (S0_01 e R1A T1): se differiscono, il giornale non si legge.
            if int(st[11:13]) != ora:
                raise Rifiuto("%s: ora server %d diversa dall'ora dell'orario simulato della riga (%s): orologio incoerente, non si indovina la fascia" % (etich, ora, st))
            motivo = d["motivo"] or ""
            if d["motivo"] is not None and motivo not in MOTIVI_EA:
                raise Rifiuto("%s: motivo SALTATO sconosciuto '%s'" % (etich, motivo))
            out["righe"].append({"st": st, "lato": d["lato"], "preso": d["motivo"] is None, "motivo": motivo, "atr": float(d["atr"]), "spread": float(d["spread"]),
                                 "rap": rap, "val": INF if rap == -1.0 else rap, "ora": ora})
            continue
        mi = RE_ING.match(msg)
        if mi:
            d = mi.groupdict()
            out["ingressi_eseguiti"].append({"lato": d["lato"], "lotti": float(d["lotti"]), "atr": float(d["atr"]), "spread": float(d["spread"])})
            continue
        if msg.startswith("[GBA-CONTA] FINE"):
            mc = RE_CONTA.match(msg)
            if not mc:
                raise Rifiuto("%s: riga [GBA-CONTA] FINE che il parser NON legge: %s" % (etich, msg[:160]))
            out["conta"] = {kk: int(v) for kk, v in mc.groupdict().items()}
            out["conta_n"] += 1
            continue
        if msg.startswith("[GBA] AVVIO v"):
            ma = RE_AVVIO.match(msg)
            if not ma:
                raise Rifiuto("%s: riga AVVIO che il parser NON legge: %s" % (etich, msg[:160]))
            out["avvio"].append(ma.groupdict())
            continue
        if "lotto richiesto" in msg and "ridotto" in msg:
            out["ridotti"] += 1
    return out


def analizza(righe):
    """C3G della cella, dei lati, delle fasce (e per lato dentro la fascia), righe >= 50x, ingressi e spread zero."""
    def blocco(rr):
        return {"n": len(rr), "c3g": mediana([r["val"] for r in rr])}
    ing = [r for r in righe if r["preso"]]
    A = {"n": len(righe), "c3g": mediana([r["val"] for r in righe]), "ingressi": len(ing),
         "ingressi_spread_zero": sum(1 for r in ing if r["rap"] == -1.0), "righe_spread_zero": sum(1 for r in righe if r["rap"] == -1.0),
         "ge50": sum(1 for r in righe if r["val"] >= 50.0), "ge40": sum(1 for r in righe if r["val"] >= SOGLIA_V_X), "spread_cella": mediana([r["spread"] for r in righe]),
         "lati": {l: blocco([r for r in righe if r["lato"] == l]) for l in ("BUY", "SELL")}, "fasce": [], "motivi": {}}
    for r in righe:
        A["motivi"][r["motivo"] or "ok"] = A["motivi"].get(r["motivo"] or "ok", 0) + 1
    liberi = [r for r in righe if r["preso"] or r["motivo"].startswith("spread")]
    A["liberi"] = len(liberi)
    A["scartati_spread"] = sum(1 for r in righe if (not r["preso"]) and r["motivo"].startswith("spread"))
    for lo, hi, nome in FASCE:
        rr = [r for r in righe if lo <= r["ora"] < hi]
        f = blocco(rr)
        f.update({"nome": nome, "lo": lo, "hi": hi, "ge50": sum(1 for r in rr if r["val"] >= 50.0), "ge40": sum(1 for r in rr if r["val"] >= SOGLIA_V_X), "ingressi": sum(1 for r in rr if r["preso"]),
                  "BUY": blocco([r for r in rr if r["lato"] == "BUY"]), "SELL": blocco([r for r in rr if r["lato"] == "SELL"]),
                  "atr_med": mediana([r["atr"] for r in rr]), "spread_med": mediana([r["spread"] for r in rr])})
        f["quota_ingressi"] = (f["ingressi"] / float(A["ingressi"])) if A["ingressi"] else None
        A["fasce"].append(f)
    return A


def costo_solo_spread(ingressi):
    """Come il lettore costo_ingressi (r.430), riga 'solo spread': 2,5 x ATR / spread sulle righe d'ingresso, spread 0,00 scartato."""
    v = [2.5 * e["atr"] / e["spread"] for e in ingressi if e["spread"] > 0]
    return v


def leggi_ini(testo):
    sez, out = None, {"tester": {}, "inputs": {}}
    for riga in testo.splitlines():
        riga = riga.strip()
        if not riga or riga.startswith(";"):
            continue
        if riga.startswith("[") and riga.endswith("]"):
            sez = riga[1:-1]
            continue
        if "=" in riga:
            k, v = riga.split("=", 1)
            if sez == "Tester":
                out["tester"][k.strip()] = v.strip()
            elif sez == "TesterInputs":
                out["inputs"][k.strip()] = v.strip()
    return out


def pin_della_prova(testo):
    pin = {}
    for riga in testo.splitlines():
        s = riga.strip()
        if not s or s.startswith("#") or "=" not in s:
            continue
        k, v = s.split("=", 1)
        pin[k.strip()] = v.strip()
    return pin


def controlli(P):
    """Calcola A, n, CE2-CE6 di una passata lanciata. Scrive in P (anche lo SHA256 di D2 che l'ha letta)."""
    P["sha_d2"] = sha_d2()
    G = P["giornale"]
    A = analizza(G["righe"])
    P["A"] = A
    r = P["riga"]
    tr = r.get("trades_report", "").strip()
    P["n"] = int(tr) if tr.isdigit() else None
    if P["report"] and P["report"]["trades"] is not None and P["n"] is not None and P["report"]["trades"] != P["n"]:
        P["n"] = None
        P["nota_n"] = "operazioni del report %d contro manifest %s" % (P["report"]["trades"], tr)
    c = G["conta"]
    ce = {}
    # CE2: firma dell'oro su OGNI fascia stampata (almeno una)
    stampate = [f for f in A["fasce"] if f["n"] > 0]
    if P["simbolo"] == "XAUUSD":
        ce["CE2"] = (True, "ancora: e' oro")
    else:
        def firma(f):
            s_ok = f["spread_med"] is not None and FIRMA_ORO_SPREAD[0] <= f["spread_med"] <= FIRMA_ORO_SPREAD[1]
            if P["simbolo"] == "XAGUSD":
                return s_ok and f["atr_med"] is not None and f["atr_med"] > FIRMA_ORO_ATR_XAG
            return s_ok
        rosso = bool(stampate) and all(firma(f) for f in stampate)
        ce["CE2"] = (not rosso, "firma dell'ORO su ogni fascia (letta come XAUUSD)" if rosso else "firma dell'oro assente")
    # CE3: costo 'solo spread' sugli ingressi (per costruzione >= 50x)
    v = costo_solo_spread(G["ingressi_eseguiti"])
    P["solo_spread"] = v
    if not v:
        ce["CE3"] = (True, "nessun ingresso con spread: non applicabile")
    else:
        m, p10 = mediana(v), percentile(v, 0.10)
        q40 = sum(1 for x in v if x < CE3_SOGLIA_QUOTA) / float(len(v))
        ok3 = m >= CE3_MEDIANA_MIN and p10 >= CE3_P10_MIN and q40 == 0
        ce["CE3"] = (ok3, "solo spread n=%d mediana %.1f p10 %.1f quota <40x %.0f%%" % (len(v), m, p10, 100 * q40))
    # CE4: segnali(EA) = somma dei motivi; e (D2) il giornale ha tutte le righe dell'EA
    if c is None or G["conta_n"] != 1:
        ce["CE4"] = (False, "riga [GBA-CONTA] FINE assente o ripetuta (%d)" % G["conta_n"])
        ce["CE6"] = (False, "tentati non leggibili")
    else:
        somma = c["ing"] + c["spr"] + c["pos"] + c["ora"] + c["giorno"] + c["lato"] + c["dati"] + c["tetto"]
        ok4 = c["seg"] == somma and A["n"] == c["seg"] and A["ingressi"] == c["ing"] and A["scartati_spread"] == c["spr"]
        ce["CE4"] = (ok4, "segnali(EA) %d = tentati %d + spread %d + posizione %d + altri %d (somma %d); righe del giornale %d, senza SALTATO %d, SALTATO per spread %d" % (
            c["seg"], c["ing"], c["spr"], c["pos"], c["ora"] + c["giorno"] + c["lato"] + c["dati"] + c["tetto"], somma, A["n"], A["ingressi"], A["scartati_spread"]))
        if P["n"] is None:
            ce["CE6"] = (False, "n del report non leggibile%s" % (": " + P["nota_n"] if P.get("nota_n") else ""))
        else:
            d = c["ing"] - P["n"]
            ce["CE6"] = (d in (0, 1), "tentati %d - n %d = %d (ammesso 0 o 1)" % (c["ing"], P["n"], d))
    P["ce"] = ce
    return P

#>>COPIA_D2


def sha_d2():
    """(usata da controlli() copiata da D2) SHA256 dello strumento che ha letto la passata: qui e' D2-B."""
    return hashlib.sha256(open(os.path.abspath(__file__), "rb").read()).hexdigest()

# ---------------------------------------------------------------------------------------------------------------------
#  LO STADIO B COME E' STATO LANCIATO (riga RIGA_LANCIA_GBA_R2S_B.txt: $PIN e $LOTTI = SHA256 dei 4 file prova)
# ---------------------------------------------------------------------------------------------------------------------
PIN_AMMESSI = ("d53493a92901b82c6b4c12c1d79ec3cb4ebfa5bb",)
SHA_EA = "1381E3DC9B4B4E44BCDC0319F023CB1990900CE0D1A6B6A3EC1DF5DF99E601B1"
MAGIC = "775800"
MODELLO = "4"
HEADER_V5 = ("lotto;passata;cella;spread_max_atr;tranche;da;a;modello;magic;t_avvio;durata_s;stato;trades_report;profitto_report;pf_report;qualita;barre_report;"
             "ticks_report;barre_gen;ticks_gen;ticks_inizio;righe_gba;ingressi_log;avvio_ok;autotest;finestra;motivi;asse;valore_asse;simbolo;periodo;prova")
TRANCHE = {"T1": ("2026.07.01", "2026.09.30"), "T2": ("2026.04.01", "2026.06.30"), "T3": ("2026.01.01", "2026.03.31")}
LOTTI = {
    "R2SBANC": {"prova": "GBA_R2SB_ANCORA_2026-10-12.txt", "sha": "822e3a26b23943e1cd6e657a397e50dd3862e5d6bbb4f8835e1811f9d817fb2d", "simbolo": "XAUUSD",
                "cella": "REPL", "tf": "M1", "tfval": "1", "tranche": ["T1"], "tetto": "10", "ancora": True, "nome": "oro (ANCORA)", "banda": None, "rischio": False},
    "R2SBNAS": {"prova": "GBA_R2SB_NASUSD_2026-10-12.txt", "sha": "5058bf07932f0cb85d3d775a21295fd529283af732743a9943bf986fe42e9fa9", "simbolo": "NASUSD",
                "cella": "M15", "tf": "M15", "tfval": "15", "tranche": ["T1", "T2", "T3"], "tetto": "30", "ancora": False, "nome": "Nasdaq 100",
                "banda": (48.75, 52.87), "rischio": False},
    "R2SBD30": {"prova": "GBA_R2SB_D30EUR_2026-10-12.txt", "sha": "a45b52d893117c06d8c136e18518bee5e0076b06b000da2038251c7a64afc322", "simbolo": "D30EUR",
                "cella": "M15", "tf": "M15", "tfval": "15", "tranche": ["T1", "T2", "T3"], "tetto": "30", "ancora": False, "nome": "DAX 40",
                "banda": (39.77, 44.37), "rischio": True},
    "R2SBU30": {"prova": "GBA_R2SB_U30USD_2026-10-12.txt", "sha": "347f04a753b074fd81c086be8a43fd3a6bf22a9aa4314b91509550d1bc99ea5e", "simbolo": "U30USD",
                "cella": "M15", "tf": "M15", "tfval": "15", "tranche": ["T1", "T2", "T3"], "tetto": "30", "ancora": False, "nome": "Dow Jones 30",
                "banda": (45.25, 50.61), "rischio": False},
}
ORDINE = ["R2SBANC", "R2SBNAS", "R2SBD30", "R2SBU30"]
# SOGLIE (file prova, sezione ESITI; nessuna nuova)
SOGLIA = 40.0             # C3G >= 40,0 inclusivo (S2 PASSA, frontiera di casa)
SOTTO = 13.3              # 'SOTTO 13,3x in Tx' (solo dicitura dentro (F))
N_NETTO_MIN = 30          # n NETTO >= 30
RIGHE_MIN = 100           # righe segnale >= 100 (giudica il costo)
RIGHE_POS_MIN = 100       # righe segnale a spread > 0 >= 100 (clausola di (N), classe 1386)
N_BANDA_T1 = (40, 160)    # banda di lettura LARGA degli ingressi in T1 (descrizione)
N_FASCIA_PF = 100         # PF per fascia solo con n >= 100 nella fascia (R2, descrizione)
QUOTA_LATO = 0.25         # lato sotto il 25% degli ingressi = DA GUARDARE (descrizione)
QUALITA_TICK = "100%ticksreali"
ANCORA = {"tag": "R1A_01_REPL_T1_m775800", "trades": 128, "profitto": -6577.48, "pf": 0.83, "qualita": "100%ticksreali", "barre": "88416", "ticks": "25648545",
          "tick_ini": "2024.07.10", "c3g": 21.60, "ge40": 651, "ge50": 280, "m1": 0, "righe": 6973, "conta": (6973, 128, 6614, 231)}
MARCA_FINTO = "FINTO: zip costruito dall'autotest di D2-B"
PAROLE_VIETATE = ("ESCLUS", "MORTO")


class Lettura(object):
    pass


# ---------------------------------------------------------------------------------------------------------------------
#  FILE PROVA: i blocchi @GBA del file (pinnato) devono dire ESATTAMENTE quello che D2-B crede
# ---------------------------------------------------------------------------------------------------------------------
def gba_della_prova(testo):
    tr = re.findall(r"^#\s+@GBA-TRANCHE nome=(\S+) da=(\S+) a=(\S+)\s*$", testo, re.M)
    ce = re.findall(r"^#\s+@GBA-CELLA nome=(\S+) InpSignalTF=(\S+)\s*$", testo, re.M)
    lo = re.findall(r"^#\s+@GBA-LOTTO nome=(\S+) modello=(\S+) tetto_min=(\S+) passate=(\S+)\s*$", testo, re.M)
    asse = re.findall(r"^#\s+@GBA-ASSE chiave=(\S+) tranche=(\d+) celle=(\d+) lotti=(\d+)\s*$", testo, re.M)
    return {"tranche": tr, "celle": ce, "lotti": lo, "asse": asse}


def verifica_prova(L, testo):
    """Lista dei disaccordi fra i blocchi @GBA del file prova e le costanti di D2-B (vuota = d'accordo)."""
    D = LOTTI[L]
    g = gba_della_prova(testo)
    err = []
    att_tr = [(t, TRANCHE[t][0], TRANCHE[t][1]) for t in D["tranche"]]
    if g["tranche"] != att_tr:
        err.append("@GBA-TRANCHE %s invece di %s" % (g["tranche"], att_tr))
    if g["celle"] != [(D["cella"], D["tfval"])]:
        err.append("@GBA-CELLA %s invece di %s" % (g["celle"], [(D["cella"], D["tfval"])]))
    att_lo = [(L, MODELLO, D["tetto"], ",".join("%s:%s" % (D["cella"], t) for t in D["tranche"]))]
    if g["lotti"] != att_lo:
        err.append("@GBA-LOTTO %s invece di %s" % (g["lotti"], att_lo))
    if g["asse"] != [("InpSignalTF", str(len(D["tranche"])), "1", "1")]:
        err.append("@GBA-ASSE %s" % g["asse"])
    pin = pin_della_prova(testo)
    if pin.get("InpSymbol") != D["simbolo"]:
        err.append("InpSymbol=%s invece di %s" % (pin.get("InpSymbol"), D["simbolo"]))
    return err


def pin_ordinati(testo):
    """I pin del file prova nell'ordine del file (il driver li scrive cosi' nell'ini, InpMagic escluso e messo in coda)."""
    out = []
    for riga in testo.splitlines():
        s = riga.strip()
        if not s or s.startswith("#") or "=" not in s:
            continue
        k, v = s.split("=", 1)
        out.append((k.strip(), v.strip()))
    return out


# ---------------------------------------------------------------------------------------------------------------------
#  UNA PASSATA: dal manifest, ini, giornale, report alla struttura P (con i rifiuti di provenienza, orologio e finestra)
# ---------------------------------------------------------------------------------------------------------------------
def costruisci_passata(e, riga, ini_txt, log_txt, rep_raw, simbolo, tf, tranche, da, a):
    """e = etichetta. Restituisce P (gia' valutata da valuta_passata). Rifiuto se il giornale non e' di questa passata."""
    P = {"tag": riga["passata"], "tranche": tranche, "da": da, "a": a, "simbolo": simbolo, "tf": tf, "riga": riga, "stato": riga["stato"], "ini": None,
         "giornale": None, "log_lg": None, "rep": None, "e": e}
    if riga["stato"] == "NON_LANCIATA":
        return valuta_passata(P)
    if ini_txt is None:
        raise Rifiuto("%s: ini assente: simbolo, TF, modello e finestra della passata non verificabili" % e)
    ini = leggi_ini(ini_txt)
    te = ini["tester"]
    for k, v in (("Symbol", simbolo), ("Period", tf), ("FromDate", da), ("ToDate", a), ("Expert", "ABTG_GoldBreakoutATR.ex5")):
        if te.get(k) != v:
            raise Rifiuto("%s: ini [Tester] %s=%s, il file prova dice %s" % (e, k, te.get(k), v))
    P["ini"] = ini
    if log_txt is None:
        raise Rifiuto("%s: giornale ASSENTE: il C3G non si legge e non si indovina" % e)
    G = leggi_giornale(log_txt, e)          # rifiuta: riga segnale illeggibile, sentinella sconosciuta, ora server fuori 0-23 o diversa dall'ora simulata
    if G["doppioni"]:
        raise Rifiuto("%s: la deduplica con la chiave del driver toglie %d righe: il giornale NON e' quello scritto dal driver" % (e, G["doppioni"]))
    fuori = [x["st"] for x in G["righe"] if not (da <= x["st"][:10] < a)]
    if fuori:
        raise Rifiuto("%s: %d righe segnale fuori da [%s, %s) (ToDate NON compreso, MISURATO; prima: %s): giornale di un'altra finestra" % (e, len(fuori), da, a, fuori[0]))
    lgl = LG.leggi_log(log_txt)
    fuori_i = [x["t"].strftime("%Y.%m.%d") for x in lgl["ingressi"] if not (da <= x["t"].strftime("%Y.%m.%d") < a)]
    if fuori_i:
        raise Rifiuto("%s: %d righe d'ingresso fuori da [%s, %s) (prima: %s)" % (e, len(fuori_i), da, a, fuori_i[0]))
    if len(lgl["segnali"]) != len(G["righe"]):
        raise Rifiuto("%s: il lettore legge %d righe segnale, D2 %d: parser in disaccordo" % (e, len(lgl["segnali"]), len(G["righe"])))
    if not G["avvio"]:
        if riga["stato"] == "OK":
            raise Rifiuto("%s: stato OK ma nessuna riga AVVIO dell'EA nel giornale: simbolo e TF dell'EA non verificabili" % e)
        P["note0"] = ["giornale senza riga AVVIO dell'EA (passata %s: %s): la tranche non si legge" % (riga["stato"], riga.get("motivi") or "nessun motivo")]
    for av in G["avvio"]:
        if not (av["sim"] == simbolo and av["sim2"] == simbolo and av["tf2"] == tf and av["tf"] == "PERIOD_" + tf):
            raise Rifiuto("%s: la riga AVVIO dell'EA dice %s %s (%s), il file prova dice %s %s" % (e, av["sim2"], av["tf2"], av["sim"], simbolo, tf))
    for f in G["finestre"]:
        if not (f["sim"] == simbolo and f["tf"] == tf and f["da"] == da and f["a"] == a):
            raise Rifiuto("%s: la riga FINESTRA del tester dice %s,%s %s-%s, il file prova dice %s,%s %s-%s" % (e, f["sim"], f["tf"], f["da"], f["a"], simbolo, tf, da, a))
    P["giornale"], P["log_lg"] = G, lgl
    P["finto"] = any(t.startswith("# FINTO") for t in log_txt.splitlines()[:5])   # marca dei giornali SINTETICI dell'autotest (il driver non la scrive mai)
    if rep_raw is not None:
        rep = LG.leggi_report(rep_raw)
        if rep.get("simbolo") is not None and rep["simbolo"] != simbolo:
            raise Rifiuto("%s: il report dice simbolo %s, il file prova %s" % (e, rep["simbolo"], simbolo))
        if rep.get("periodo") is not None and not rep["periodo"].startswith("%s(%s-" % (tf, da)):
            raise Rifiuto("%s: il report dice periodo '%s', il file prova %s (%s - %s)" % (e, rep["periodo"], tf, da, a))
        if rep.get("expert") is not None and rep["expert"] != "ABTG_GoldBreakoutATR":
            raise Rifiuto("%s: il report e' dell'EA %s" % (e, rep["expert"]))
        P["rep"] = rep
    return valuta_passata(P)


def storia_tick(P):
    """Cosa manca perche' la passata valga a TICK REALI (lista vuota = confermati). Regola dei file prova (DRIVER E CONTROLLI DI MODELLO 4)."""
    r = P["riga"]
    out = []
    if (r.get("modello") or "").strip() != MODELLO:
        out.append("modello del manifest %s, non 4" % r.get("modello"))
    if P["ini"] is None or P["ini"]["tester"].get("Model") != MODELLO:
        out.append("ini Model=%s, non 4" % (P["ini"]["tester"].get("Model") if P["ini"] else "n.d."))
    q = re.sub(r"\s", "", r.get("qualita") or "").lower()
    if q != QUALITA_TICK:
        out.append("qualita' dello storico del manifest '%s', non ESATTAMENTE '100%% ticks reali' (il driver r.815 accetta qualsiasi '100%%...')" % (r.get("qualita") or ""))
    if P["rep"] is not None:
        qr = re.sub(r"\s", "", P["rep"].get("qualita") or "").lower()
        if qr != QUALITA_TICK:
            out.append("qualita' dello storico del report '%s', non '100%% ticks reali'" % (P["rep"].get("qualita") or ""))
    visti = []
    for tk in (r.get("ticks_inizio") or "").split(" / "):
        tk = tk.strip()
        if not tk:
            continue
        m = re.fullmatch(r"(\S+) (\d{4}\.\d\d\.\d\d)", tk)
        if not m:
            out.append("colonna ticks_inizio illeggibile ('%s')" % tk)
            continue
        if m.group(1) == P["simbolo"]:
            visti.append(m.group(2))
            if m.group(2) > P["da"]:
                out.append("tick reali di %s solo dal %s, DOPO l'inizio della tranche %s" % (P["simbolo"], m.group(2), P["da"]))
    for m in (r.get("motivi") or "").split(" | "):
        m = m.strip()
        if m.startswith("qualita dello storico") or (m.startswith("ticks data begins from") and "DOPO" in m):
            out.append("driver: " + m)
    P["tick_visti"] = visti
    return out


def valuta_passata(P):
    """Tutti i numeri e i controlli di UNA passata; scrive P['letta'], P['manca'], P['giudica']. Non decide l'esito di cella (lo fa esito_cella)."""
    r = P["riga"]
    P.update({"letta": False, "manca": [], "giudica": False, "A": None, "n": None, "nn": None, "ce": {}, "ce7": (True, "n.d."), "c3g": None, "c3g_pos": None,
              "sp_pos": 0, "m1": 0, "g0": [], "tick": [], "pos": [], "note": list(P.get("note0", []))})
    if r["stato"] == "NON_LANCIATA":
        P["manca"].append("passata NON LANCIATA (%s)" % (r.get("motivi") or "nessun motivo"))
        return P
    G = P["giornale"]
    manca = P["manca"]
    # n e CE2 CE3 CE4 CE6: la funzione di D2 (stessa aritmetica e stessi controlli dello stadio A)
    P2 = {"giornale": G, "riga": r, "simbolo": P["simbolo"], "report": ({"trades": int(P["rep"]["trades"])} if (P["rep"] and P["rep"].get("ok")) else None)}
    controlli(P2)
    A = P2["A"]
    P["A"], P["n"], P["solo_spread"] = A, P2["n"], P2["solo_spread"]
    P["ce"] = dict(P2["ce"])
    if P2.get("nota_n"):
        manca.append(P2["nota_n"])
    # CE5: righe d'ingresso a 1,00 lotti ('lotto ridotto' si scrive accanto)
    lotti = sorted(set("%.2f" % x["lotti"] for x in G["ingressi_eseguiti"]))
    P["ce"]["CE5"] = (all(l == "1.00" for l in lotti), "lotti degli ingressi %s%s" % (", ".join(lotti) or "-", "; righe 'lotto ridotto' %d" % G["ridotti"] if G["ridotti"] else ""))
    # stato del driver, finestra, AVVIO, AUTOTEST
    if r["stato"] != "OK":
        manca.append("stato del driver %s (%s)" % (r["stato"], r.get("motivi") or "nessun motivo"))
    if (r.get("finestra") or "") != P["da"] + "-" + P["a"]:
        manca.append("finestra del tester '%s' invece di %s-%s" % (r.get("finestra"), P["da"], P["a"]))
    if r.get("avvio_ok") != "si" or r.get("autotest") != "si":
        manca.append("AVVIO %s / AUTOTEST %s nel manifest" % (r.get("avvio_ok"), r.get("autotest")))
    # G0 del lettore (costruisci_passata del lettore pinnato, sugli stessi byte)
    if P["rep"] is None:
        P["g0"] = ["report .htm della passata ASSENTE"]
    else:
        PL = LG.costruisci_passata(r, P["rep"], P["log_lg"])
        P["g0"] = list(PL["g0"])
        P["pos"] = PL["pos"]
    if P["g0"]:
        manca.append("G0 del lettore KO: " + "; ".join(P["g0"]))
    # tick reali
    P["tick"] = storia_tick(P)
    if P["tick"]:
        manca.append("storia a tick NON confermata: " + "; ".join(P["tick"]))
    elif P["simbolo"] not in [x.split(" ")[0] for x in (r.get("ticks_inizio") or "").split(" / ") if x.strip()]:
        P["note"].append("riga 'ticks data begins from' di %s assente dal giornale del tester (tick gia' in cache, driver r.785): la conferma resta modello 4 + "
                         "ini Model=4 + qualita' 100%%ticksreali (file prova)" % P["simbolo"])
    for k in ("CE2", "CE3", "CE4", "CE5", "CE6"):
        if not P["ce"][k][0]:
            manca.append("%s ROSSO (%s)" % (k, P["ce"][k][1]))
    # numeri della tranche
    P["m1"] = A["righe_spread_zero"]
    P["sp_pos"] = A["n"] - A["righe_spread_zero"]
    P["c3g"] = A["c3g"]
    P["c3g_pos"] = mediana([x["val"] for x in G["righe"] if x["rap"] != -1.0])
    if P["n"] is not None:
        P["nn"] = P["n"] - A["ingressi_spread_zero"]
    elif not manca:
        manca.append("n del report non leggibile")
    # CE7 (file prova): le due mediane da parti diverse di 40,0 = NON LEGGIBILE PER SPREAD ZERO
    if P["c3g"] is None:
        P["ce7"] = (True, "nessuna riga segnale: CE7 non applicabile (la tranche non giudica il costo: righe < 100)")
    elif P["c3g_pos"] is None:
        P["ce7"] = (False, "tutte le %d righe sono -1.0x: il C3G senza le -1.0x non esiste -> NON LEGGIBILE PER SPREAD ZERO" % A["n"])
    elif (P["c3g"] >= SOGLIA) != (P["c3g_pos"] >= SOGLIA):
        P["ce7"] = (False, "C3G con le -1.0x %s, senza %s: da parti diverse di 40,0 -> NON LEGGIBILE PER SPREAD ZERO" % (fx(P["c3g"]), fx(P["c3g_pos"])))
    else:
        P["ce7"] = (True, "C3G con le -1.0x %s, senza %s: stessa parte di 40,0" % (fx(P["c3g"]), fx(P["c3g_pos"])))
    P["letta"] = not manca
    P["giudica"] = P["letta"] and A["n"] >= RIGHE_MIN and P["ce7"][0]
    return P


# ---------------------------------------------------------------------------------------------------------------------
#  ESITO DI CELLA: (C) (F) (N) (P), il PRIMO che vale decide (file prova, sezione ESITI)
# ---------------------------------------------------------------------------------------------------------------------
def esito_cella(trs, nomi, ce1):
    """trs = {tranche: P o None}; nomi = le tranche NOMINATE nel file prova; ce1 = (ok, testo). Restituisce (lettera, frase)."""
    non_lette = []
    for t in nomi:
        P = trs.get(t)
        if P is None:
            non_lette.append("%s: passata ASSENTE (lotto non caricato, compilazione fallita o passata non nel manifest)" % t)
        elif not ce1[0]:
            non_lette.append("%s: ancora CE1 non verde (%s)" % (t, ce1[1]))
        elif not P["letta"]:
            non_lette.append("%s: %s" % (t, "; ".join(P["manca"])))
    if non_lette:
        return "C", ("NON SI LEGGE -> NON ANCORA MISURATO. Tranche non lette (su %s, le tre NOMINATE, mai le sole lette): %s. I numeri delle tranche lette sono "
                     "solo descrizione." % (", ".join(nomi), " | ".join(non_lette)))
    fra = [t for t in nomi if trs[t]["giudica"] and trs[t]["c3g"] < SOGLIA]
    if fra:
        pz = []
        for t in fra:
            c = trs[t]["c3g"]
            pz.append(("SOTTO 13,3x in %s (C3G %s)" % (t, fx(c))) if c < SOTTO else ("%s C3G %s < 40,0" % (t, fx(c))))
        altre = ["%s C3G %s (NON giudica il costo: %s)" % (t, fx(trs[t]["c3g"]), "righe %d < 100" % trs[t]["A"]["n"] if trs[t]["A"]["n"] < RIGHE_MIN else "CE7 rossa")
                 for t in nomi if (not trs[t]["giudica"]) and trs[t]["c3g"] is not None and trs[t]["c3g"] < SOGLIA]
        return "F", ("FRA IN %s -> NON PUO' DIVENTARE SEDIA (%s).%s Non chiude la casella 4, non archivia nulla; la cella si puo' misurare ancora 'per capire' (piano 5.3)."
                     % ("/".join(fra), "; ".join(pz), (" Sotto 40x ma solo descrizione: " + "; ".join(altre) + ".") if altre else ""))
    nins = []
    for t in nomi:
        P = trs[t]
        mot = []
        if P["nn"] < N_NETTO_MIN:
            mot.append("n NETTO %d < 30" % P["nn"])
        if P["A"]["n"] < RIGHE_MIN:
            mot.append("righe segnale %d < 100" % P["A"]["n"])
        if P["sp_pos"] < RIGHE_POS_MIN:
            mot.append("righe a spread > 0 %d < 100 (le -1.0x non comprano il campione)" % P["sp_pos"])
        if not P["ce7"][0]:
            mot.append("NON LEGGIBILE PER SPREAD ZERO (CE7: %s)" % P["ce7"][1])
        if mot:
            nins.append("%s: %s" % (t, ", ".join(mot)))
    if nins:
        return "N", ("NON PASSA LO STADIO B, NON ANCORA MISURATO (n insufficiente o costo non giudicato): %s. Via piu' corta al numero: piu' tranche dello storico BCM "
                     "dal 2024.09.26, oppure un TF piu' alto. Non e' un verdetto." % " | ".join(nins))
    ok = all(trs[t]["letta"] and trs[t]["giudica"] and trs[t]["c3g"] >= SOGLIA and trs[t]["nn"] >= N_NETTO_MIN and trs[t]["sp_pos"] >= RIGHE_POS_MIN
             and trs[t]["A"]["n"] >= RIGHE_MIN and trs[t]["ce7"][0] for t in nomi)
    if not ok:
        raise RuntimeError("combinazione senza esito (classe 1369): difetto dello strumento")
    return "P", ("PASSA LO STADIO B (COSTO): %s. Significa SOLO che il costo a tick reali e' alla frontiera di casa in tutti e tre i trimestri del 2026. NON e' una "
                 "promozione, NON e' una sedia, NON va in un preset." % "; ".join("%s C3G %s, n netto %d, righe a spread > 0 %d" % (
                     t, fx(trs[t]["c3g"]), trs[t]["nn"], trs[t]["sp_pos"]) for t in nomi))


MERITO = ("MERITO: NON MISURATO, qualunque sia il PF. Motivo: le tre tranche del 2026 sono UN SOLO regime (piano 5.3; emendamento D: un solo regime = non "
          "misurabile anche per il merito) e il regime degli indici non e' classificato; una tranche non e' un regime (classe 1384), qualunque sia il suo n.")


# ---------------------------------------------------------------------------------------------------------------------
#  CARICAMENTO
# ---------------------------------------------------------------------------------------------------------------------
def _nomi(z):
    out = {}
    for n in z.namelist():
        if n.endswith("/") or n.endswith("\\"):
            continue
        k = n.replace("\\", "/")
        if k in out:
            raise Rifiuto("due voci dello zip con lo stesso nome normalizzato '%s'" % k)
        out[k] = n
    return out


def leggi_lotto(nome_zip, dati):
    try:
        z = zipfile.ZipFile(io.BytesIO(dati))
    except zipfile.BadZipFile:
        raise Rifiuto("%s: non e' uno zip leggibile" % nome_zip)
    N = _nomi(z)
    if "MANIFEST_R0.csv" not in N:
        raise Rifiuto("%s: manca MANIFEST_R0.csv (non e' uno zip di lotto del driver)" % nome_zip)
    testo_man = z.read(N["MANIFEST_R0.csv"]).decode("ascii", "replace")
    righe_man = [x for x in testo_man.splitlines() if x.strip()]
    if not righe_man or righe_man[0].strip() != HEADER_V5:
        raise Rifiuto("%s: il manifest NON e' del driver v5 (intestazione a 32 colonne diversa: %s...)" % (nome_zip, (righe_man[0] if righe_man else "vuoto")[:80]))
    man = list(csv.DictReader(io.StringIO("\n".join(righe_man)), delimiter=";"))
    if not man:
        raise Rifiuto("%s: manifest senza passate" % nome_zip)
    for r in man:
        if None in r or any(v is None for v in r.values()):
            raise Rifiuto("%s: una riga del manifest non ha 32 colonne (%s)" % (nome_zip, r.get("passata")))
    lotti = set(r["lotto"] for r in man)
    if len(lotti) != 1:
        raise Rifiuto("%s: piu' lotti nello stesso manifest (%s)" % (nome_zip, ", ".join(sorted(lotti))))
    L = lotti.pop()
    if L not in LOTTI:
        raise Rifiuto("%s: lotto '%s' NON e' in elenco (stadio B: %s)" % (nome_zip, L, ", ".join(ORDINE)))
    base = os.path.basename(nome_zip.replace("\\", "/").split("!")[-1])
    if base.startswith("GBA_R0_") and base.lower().endswith(".zip") and base[7:-4] != L:
        raise Rifiuto("%s: il nome dello zip dice lotto %s, il manifest dice %s" % (nome_zip, base[7:-4], L))
    D = LOTTI[L]
    if D["prova"] not in N:
        raise Rifiuto("%s: il file prova %s NON e' nello zip" % (nome_zip, D["prova"]))
    raw_prova = z.read(N[D["prova"]])
    sha = hashlib.sha256(raw_prova).hexdigest()
    if sha != D["sha"]:
        raise Rifiuto("%s: il file prova %s ha SHA256 %s, la riga di lancio ha pinnato %s" % (nome_zip, D["prova"], sha[:12], D["sha"][:12]))
    testo_prova = raw_prova.decode("ascii", "replace")
    dis = verifica_prova(L, testo_prova)
    if dis:
        raise Rifiuto("%s: il file prova dice altro da D2-B: %s" % (nome_zip, "; ".join(dis)))
    # PROVENIENZA (classe 1381): RIEPILOGO del driver con lotto, modello, pin e SHA dell'EA
    if "RIEPILOGO_R0.txt" not in N:
        raise Rifiuto("%s: manca RIEPILOGO_R0.txt: pin e EA della passata non verificabili" % nome_zip)
    rie = z.read(N["RIEPILOGO_R0.txt"]).decode("ascii", "replace")
    prima = rie.splitlines()[0] if rie.splitlines() else ""
    if not prima.startswith("GBA R0 -- lotto %s: " % L) or ", Modello 4," not in prima:
        raise Rifiuto("%s: il RIEPILOGO dice '%s' (attesi lotto %s e Modello 4)" % (nome_zip, prima[:90], L))
    pins = set(re.findall(r"\bpin: ([0-9a-fA-F]{40})\b", rie))
    if len(pins) != 1 or next(iter(pins)).lower() not in PIN_AMMESSI:
        raise Rifiuto("%s: il RIEPILOGO dice pin %s, la riga di lancio e' al pin %s" % (nome_zip, ", ".join(sorted(pins)) or "assente", " / ".join(PIN_AMMESSI)))
    if ("ABTG_GoldBreakoutATR.mq5 SHA256 " + SHA_EA) not in rie:
        raise Rifiuto("%s: il RIEPILOGO non dice ABTG_GoldBreakoutATR.mq5 SHA256 %s...: un altro EA" % (nome_zip, SHA_EA[:12]))
    pin = pin_della_prova(testo_prova)
    chiavi = [(r["cella"], r["tranche"], r["magic"]) for r in man]
    doppie = sorted(set(c for c in chiavi if chiavi.count(c) > 1))
    if doppie:
        raise Rifiuto("%s: la stessa (cella, tranche, magic) compare PIU' volte nel manifest: %s" % (nome_zip, doppie))
    tags = [r["passata"] for r in man]
    if len(set(tags)) != len(tags):
        raise Rifiuto("%s: lo stesso nome di passata compare piu' volte nel manifest" % nome_zip)
    passate = {}
    for r in man:
        e = "%s %s" % (L, r["passata"])
        if r["cella"] != D["cella"] or r["tranche"] not in D["tranche"]:
            raise Rifiuto("%s: passata %s:%s NON dichiarata nel file prova (@GBA-LOTTO passate=%s)" % (
                e, r["cella"], r["tranche"], ",".join("%s:%s" % (D["cella"], t) for t in D["tranche"])))
        k = D["tranche"].index(r["tranche"]) + 1
        tag_att = "%s_%02d_%s_%s_m%s" % (L, k, D["cella"], r["tranche"], MAGIC)
        da, a = TRANCHE[r["tranche"]]
        att = {"passata": tag_att, "da": da, "a": a, "modello": MODELLO, "magic": MAGIC, "asse": "InpSignalTF", "valore_asse": D["tfval"], "simbolo": D["simbolo"],
               "periodo": D["tf"], "prova": D["prova"], "spread_max_atr": "0.05"}
        for kk, v in att.items():
            if (r.get(kk) or "").strip() != v:
                raise Rifiuto("%s: manifest %s='%s', il file prova dice '%s'" % (e, kk, r.get(kk), v))
        tag = r["passata"]
        ini_txt = log_txt = rep_raw = None
        if r["stato"] != "NON_LANCIATA":
            ni = "ini/gba_" + tag + ".ini"
            if ni in N:
                ini_txt = z.read(N[ni]).decode("ascii", "replace")
                inp = leggi_ini(ini_txt)["inputs"]
                attesi = dict(pin)
                attesi["InpSignalTF"] = D["tfval"]
                attesi["InpMagic"] = MAGIC
                if set(inp) != set(attesi):
                    raise Rifiuto("%s: input dell'ini diversi da quelli del file prova (in piu': %s; mancano: %s)" % (
                        e, ", ".join(sorted(set(inp) - set(attesi))) or "-", ", ".join(sorted(set(attesi) - set(inp))) or "-"))
                for kk in sorted(attesi):
                    if _norm(inp[kk]) != _norm(attesi[kk]):
                        raise Rifiuto("%s: ini %s=%s, il file prova dice %s" % (e, kk, inp[kk], attesi[kk]))
                if leggi_ini(ini_txt)["tester"].get("Report") != "GBA_R0_" + tag:
                    raise Rifiuto("%s: ini Report=%s invece di GBA_R0_%s" % (e, leggi_ini(ini_txt)["tester"].get("Report"), tag))
                atteso = _ini_driver(L, tag, D["simbolo"], D["tf"], MODELLO, da, a, testo_prova, D["tfval"])
                if _righe_ini(ini_txt, ("Model=",)) != _righe_ini(atteso, ("Model=",)):
                    raise Rifiuto("%s: l'ini NON e' quello che il driver v5 scrive per questa passata (TestoIni r.638-651: deposito, esecuzione, ordine dei pin...); "
                                  "Model a parte, che decide la conferma dei tick" % e)
            nl = "log/GBA_" + tag + ".txt"
            if nl in N:
                log_txt = z.read(N[nl]).decode("ascii", "replace")
            cand = sorted(n for n in N if n.startswith("report/GBA_R0_" + tag) and n.lower().endswith((".htm", ".html")))
            if len(cand) > 1:
                raise Rifiuto("%s: piu' report per la stessa passata (%s)" % (e, ", ".join(cand)))
            if cand:
                rep_raw = z.read(N[cand[0]])
        P = costruisci_passata(e, r, ini_txt, log_txt, rep_raw, D["simbolo"], D["tf"], r["tranche"], da, a)
        P["lotto"] = L
        P["ini_txt"] = ini_txt
        passate[r["tranche"]] = P
    return {"lotto": L, "passate": passate, "zip": nome_zip, "finto": (MARCA_FINTO in rie) or any(P.get("finto") for P in passate.values())}


def carica(percorsi):
    """Zip di lotto o raccolta GBA_R2S_B.zip. Restituisce ({lotto: lettura}, [note], finto)."""
    lotti, note, finto = {}, [], [False]

    def aggiungi(nome, dati):
        Lz = leggi_lotto(nome, dati)
        if Lz["lotto"] in lotti:
            raise Rifiuto("lotto %s caricato DUE volte (%s e %s): ogni numero sarebbe doppio" % (Lz["lotto"], lotti[Lz["lotto"]]["zip"], nome))
        lotti[Lz["lotto"]] = Lz
        finto[0] = finto[0] or Lz["finto"]
    for p in percorsi:
        try:
            dati = open(p, "rb").read()
            z = zipfile.ZipFile(io.BytesIO(dati))
        except (OSError, zipfile.BadZipFile) as ex:
            raise Rifiuto("%s: non leggibile (%s)" % (p, ex))
        N = _nomi(z)
        if "MANIFEST_R0.csv" in N:
            aggiungi(p, dati)
            note.append("%s: zip di lotto caricato da solo: ESITI_R2S_B.txt (pin della raccolta) NON letto; pin ed EA verificati dal RIEPILOGO del lotto" % p)
            continue
        interni = sorted(n for n in N if n.lower().endswith(".zip"))
        if not interni:
            raise Rifiuto("%s: ne' zip di lotto (MANIFEST_R0.csv) ne' raccolta (zip annidati)" % p)
        ammessi = set(["GBA_R0_%s.zip" % L for L in ORDINE] + ["GBA_R0_%s_COMPILAZIONE_FALLITA.zip" % L for L in ORDINE])
        for n in interni:
            if os.path.basename(n) not in ammessi or "/" in n:
                raise Rifiuto("%s: zip interno '%s' NON e' in elenco (stadio B: %s)" % (p, n, ", ".join(ORDINE)))
            if n.endswith("_COMPILAZIONE_FALLITA.zip"):
                note.append("%s: %s -> quel lotto si e' fermato alla COMPILAZIONE: nessuna passata, le sue tranche sono (C)" % (p, n))
                continue
            aggiungi(p + "!" + n, z.read(N[n]))
        if "ESITI_R2S_B.txt" not in N:
            raise Rifiuto("%s: raccolta senza ESITI_R2S_B.txt: pin del giro non verificabile" % p)
        es = z.read(N["ESITI_R2S_B.txt"]).decode("ascii", "replace")
        pe = set(re.findall(r"\bpin ([0-9a-fA-F]{40})\b", es))
        if len(pe) != 1 or next(iter(pe)).lower() not in PIN_AMMESSI:
            raise Rifiuto("%s: ESITI_R2S_B.txt dice pin %s, la riga di lancio e' al pin %s" % (p, ", ".join(sorted(pe)) or "assente", " / ".join(PIN_AMMESSI)))
        fuori = sorted(set(x for x in re.findall(r"(?<![A-Za-z0-9])(R2S[A-Z0-9]+)", es) if x not in LOTTI))
        if fuori:
            raise Rifiuto("%s: ESITI_R2S_B.txt nomina lotti fuori elenco: %s" % (p, ", ".join(fuori)))
        if MARCA_FINTO in es:
            finto[0] = True
        note.append("ESITI_R2S_B.txt: " + " / ".join(x.strip() for x in es.splitlines() if x.strip()))
    return lotti, note, finto[0]


# ---------------------------------------------------------------------------------------------------------------------
#  ANCORA (CE1) E ACCETTAZIONE SUI GIORNALI ARCHIVIATI
# ---------------------------------------------------------------------------------------------------------------------
def _archivio_r1a():
    raw = open(ACC_R1A["zip"], "rb").read()
    if hashlib.sha256(raw).hexdigest() != ACC_R1A["sha"]:
        raise Rifiuto("archivio R1A con SHA256 diverso da quello pinnato in D2")
    z = zipfile.ZipFile(io.BytesIO(raw))
    return z, _nomi(z)


def _righe_ini_senza_report(t):
    return [x.strip() for x in t.splitlines() if x.strip() and not x.strip().startswith("Report=")]


def _righe_ini(t, senza=()):
    return [x.strip() for x in t.splitlines() if x.strip() and not any(x.strip().startswith(k) for k in senza)]


def confronta_ancora(P):
    """Disaccordi dell'ancora con R1A_01 (tolleranza ZERO, file prova ANCORA A1/A2 + ini identico salvo Report). Lista vuota = identica."""
    err = []
    r = P["riga"]
    if not P["letta"]:
        err.append("ancora NON letta (%s)" % "; ".join(P["manca"]))
    try:
        n_ok = int(r["trades_report"]) == ANCORA["trades"]
        p_ok = abs(float(r["profitto_report"]) - ANCORA["profitto"]) < 0.005
        f_ok = abs(float(r["pf_report"]) - ANCORA["pf"]) < 0.005
    except ValueError:
        n_ok = p_ok = f_ok = False
    if not (n_ok and p_ok and f_ok):
        err.append("manifest %s / %s / %s invece di 128 / -6577.48 / 0.83" % (r["trades_report"], r["profitto_report"], r["pf_report"]))
    if re.sub(r"\s", "", r["qualita"]).lower() != ANCORA["qualita"]:
        err.append("qualita '%s'" % r["qualita"])
    for k, v in (("barre_report", ANCORA["barre"]), ("ticks_report", ANCORA["ticks"]), ("barre_gen", ANCORA["barre"]), ("ticks_gen", ANCORA["ticks"])):
        if r[k].strip() != v:
            err.append("%s %s invece di %s" % (k, r[k], v))
    if P.get("tick_visti") != [ANCORA["tick_ini"]]:
        err.append("ticks data begins from XAUUSD %s invece di [%s]" % (P.get("tick_visti"), ANCORA["tick_ini"]))
    A = P["A"]
    if A is None:
        err.append("giornale non letto")
    else:
        if not uguale(A["c3g"], ANCORA["c3g"]):
            err.append("C3G %s invece di 21.60" % fx(A["c3g"]))
        if (A["n"], A["ge40"], A["ge50"], A["righe_spread_zero"]) != (ANCORA["righe"], ANCORA["ge40"], ANCORA["ge50"], ANCORA["m1"]):
            err.append("righe / >=40x / >=50x / -1.0x %d / %d / %d / %d invece di 6973 / 651 / 280 / 0" % (A["n"], A["ge40"], A["ge50"], A["righe_spread_zero"]))
        c = P["giornale"]["conta"]
        if c is None or (c["seg"], c["ing"], c["spr"], c["pos"]) != ANCORA["conta"]:
            err.append("conteggi EA %s invece di %s" % ((c["seg"], c["ing"], c["spr"], c["pos"]) if c else "n.d.", ANCORA["conta"]))
    try:
        z, N = _archivio_r1a()
        ini_arch = z.read(N["ini/gba_" + ANCORA["tag"] + ".ini"]).decode("ascii", "replace")
        if P.get("ini_txt") is None or _righe_ini_senza_report(P["ini_txt"]) != _righe_ini_senza_report(ini_arch):
            err.append("ini NON identico a quello archiviato di R1A_01 (salvo Report)")
    except (OSError, KeyError, Rifiuto) as ex:
        err.append("archivio R1A non leggibile: %s" % ex)
    return err


def stato_ce1(lotti):
    if "R2SBANC" not in lotti:
        return (False, "NON LETTO: lo zip dell'ancora GBA_R0_R2SBANC.zip non e' caricato")
    P = lotti["R2SBANC"]["passate"].get("T1")
    if P is None:
        return (False, "ROSSO: passata dell'ancora assente")
    err = confronta_ancora(P)
    if err:
        return (False, "ROSSO: l'ancora NON rifa' R1A_01 al centesimo (" + "; ".join(err) + ")")
    return (True, "VERDE: 128 / -6577.48 / PF 0.83 / 100%ticksreali / 88416 barre / 25648545 tick / XAUUSD dal 2024.07.10; C3G 21.60, righe >= 40x 651, >= 50x 280, "
                  "-1.0x 0; ini identico a R1A_01 salvo Report. (L'A3, doppione R2SBANC/R1A, la verifica il lettore.)")


def accettazione():
    """Rifatta a ogni lancio sui giornali archiviati: R1A T1 (tick reali), R1A T3 (CE6 rosso vero), S0_01 (Modello 1: tick NON confermati). (ok, righe)."""
    out = []
    try:
        z, N = _archivio_r1a()
        man = list(csv.DictReader(io.StringIO(z.read(N["MANIFEST_R0.csv"]).decode("ascii")), delimiter=";"))
        res = {}
        for r in man:
            t = r["passata"]
            da, a = TRANCHE[r["tranche"]]
            res[r["tranche"]] = costruisci_passata("R1A " + t, r, z.read(N["ini/gba_%s.ini" % t]).decode("ascii"), z.read(N["log/GBA_%s.txt" % t]).decode("ascii"),
                                                   z.read(N["report/GBA_R0_%s.htm" % t]), "XAUUSD", "M1", r["tranche"], da, a)
        P1, P3 = res["T1"], res["T3"]
        P1["ini_txt"] = z.read(N["ini/gba_%s.ini" % ANCORA["tag"]]).decode("ascii")
        e1 = confronta_ancora(P1)
        ok1 = (not e1 and P1["letta"] and P1["giudica"] and P1["n"] == 128 and P1["nn"] == 128 and P1["sp_pos"] == 6973 and uguale(P1["c3g_pos"], 21.60)
               and P1["ce7"][0] and not P1["g0"])
        out.append("   R1A T1 (tick reali, i NUMERI dell'ancora): letta %s, n %s, n netto %s, righe %d, a spread > 0 %d, C3G %s (senza -1.0x %s), >= 40x %d, >= 50x %d, "
                   "G0 %s -> %s" % ("SI" if P1["letta"] else "NO", P1["n"], P1["nn"], P1["A"]["n"], P1["sp_pos"], fx(P1["c3g"]), fx(P1["c3g_pos"]), P1["A"]["ge40"],
                                    P1["A"]["ge50"], "OK" if not P1["g0"] else "KO", "IDENTICI" if ok1 else "DIVERSI: " + "; ".join(e1 or ["altro"])))
        ok3 = (not P3["letta"]) and (not P3["ce"]["CE6"][0]) and any("CE6" in m for m in P3["manca"])
        out.append("   R1A T3 (CONTRO-ESEMPIO VERO: tentati 565, n 557): CE6 %s -> %s" % ("ROSSO" if not P3["ce"]["CE6"][0] else "verde",
                                                                                            "non letta, come deve" if ok3 else "LETTA: difetto"))
        es = esito_cella(res, ["T1", "T2", "T3"], (True, "accettazione"))
        okc = es[0] == "C" and "T3:" in es[1]
        out.append("   cella oro R1A T1-T3 con le regole dello stadio B: (%s) -> %s" % (es[0], "(C) per T3, come deve" if okc else "DIFETTO"))
        zs = zipfile.ZipFile(io.BytesIO(open(ACC_S0["zip"], "rb").read()))
        Ns = _nomi(zs)
        if hashlib.sha256(open(ACC_S0["zip"], "rb").read()).hexdigest() != ACC_S0["sha"]:
            raise Rifiuto("archivio S0 con SHA256 diverso")
        rs = [r for r in csv.DictReader(io.StringIO(zs.read(Ns["MANIFEST_R0.csv"]).decode("ascii")), delimiter=";") if r["passata"] == "S0_01_REPL_T1_m775800"][0]
        P0 = costruisci_passata("S0 S0_01", rs, zs.read(Ns["ini/gba_S0_01_REPL_T1_m775800.ini"]).decode("ascii"), zs.read(Ns[ACC_S0["log"]]).decode("ascii"),
                                zs.read(Ns["report/GBA_R0_S0_01_REPL_T1_m775800.htm"]), "XAUUSD", "M1", "T1", TRANCHE["T1"][0], TRANCHE["T1"][1])
        ok0 = (not P0["letta"]) and any("100% ticks reali" in m for m in P0["tick"]) and any("ini Model=1" in m for m in P0["tick"]) and uguale(P0["c3g"], 22.80)
        out.append("   S0_01 (Modello 1, qualita' '%s', C3G %s): tick %s -> %s" % (rs["qualita"], fx(P0["c3g"]), "NON confermati" if P0["tick"] else "confermati",
                                                                                 "(C) storia a tick non confermata, come deve" if ok0 else "DIFETTO"))
        return (ok1 and ok3 and okc and ok0), out, res
    except (OSError, KeyError, IndexError, Rifiuto) as ex:
        out.append("   accettazione NON eseguita: %s" % ex)
        return False, out, None


# ---------------------------------------------------------------------------------------------------------------------
#  DESCRIZIONI (R4, R5, R2, PF, rischio): NON decidono nulla
# ---------------------------------------------------------------------------------------------------------------------
def descrizioni(P):
    A, G = P["A"], P["giornale"]
    righe = G["righe"]
    d = {}
    d["atr_med"] = mediana([x["atr"] for x in righe])
    d["spread_pos_med"] = mediana([x["spread"] for x in righe if x["rap"] != -1.0])
    d["giorni"] = len(set(x["st"][:10] for x in righe))
    gr = {"ingressi": [x for x in righe if x["preso"]], "scartate per spread": [x for x in righe if not x["preso"] and x["motivo"].startswith("spread")],
          "scartate per posizione aperta": [x for x in righe if not x["preso"] and x["motivo"].startswith("posizione")]}
    d["R5"] = [(k, len(v), mediana([x["val"] for x in v]), mediana([x["atr"] for x in v])) for k, v in gr.items()]
    d["altre"] = A["n"] - sum(len(v) for v in gr.values())
    fasce = A["fasce"]
    dom = max(fasce, key=lambda f: f["ingressi"]) if A["ingressi"] else None
    d["dom"] = dom
    pos = P["pos"]
    nets = [p["in"]["profitto"] + p["in"]["comm"] + p["in"]["swap"] + p["out"]["profitto"] + p["out"]["comm"] + p["out"]["swap"] for p in pos]
    d["comm"] = sum(p["in"]["comm"] + p["out"]["comm"] for p in pos)
    d["pf_lato"] = {}
    for lato, tipo in (("BUY", "buy"), ("SELL", "sell")):
        v = [nets[i] for i, p in enumerate(pos) if p["in"]["tipo"] == tipo]
        d["pf_lato"][lato] = (len(v), LG.pf_di(v) if v else None)
    d["pf_fascia"] = []
    for lo, hi, nome in FASCE:
        v = [nets[i] for i, p in enumerate(pos) if lo <= p["in"]["t"].hour < hi]
        d["pf_fascia"].append((nome, len(v), LG.pf_di(v) if len(v) >= N_FASCIA_PF else None))
    perd = [x["perdita"] for x in P["log_lg"]["ingressi"]]
    d["perdita"] = (mediana(perd), percentile(perd, 0.90), max(perd) if perd else None)
    d["lati_ing"] = {l: sum(1 for x in righe if x["preso"] and x["lato"] == l) for l in ("BUY", "SELL")}
    return d


def _pf(x):
    if x is None:
        return "n.d."
    if x != x:
        return "n.d."
    if x == INF:
        return "INF"
    return "%.2f" % x


# ---------------------------------------------------------------------------------------------------------------------
#  STAMPA
# ---------------------------------------------------------------------------------------------------------------------
def stampa(lotti, note, acc_ok, acc_righe, finto=False, csv_out=None):
    out = []
    W = out.append
    pre = "[ZIP FINTO -- NESSUN NUMERO VALE] " if finto else ""
    sha_me = hashlib.sha256(open(os.path.abspath(__file__), "rb").read()).hexdigest()
    W("=" * 120)
    W(" %s -- GBA R2S STADIO B (tick reali, tre tranche). SHA256 di questo file: %s" % (VERSIONE, sha_me[:16]))
    W(" Un esito vale SOLO se questo SHA256 e' quello che ha avuto il PASS dei due strati del cancello. Aritmetica copiata da D2 v2 %s; G0 dal lettore %s (pinnato)." % (D2_V2_SHA[:8], LG_SHA[:8]))
    if finto:
        W(" " + "!" * 118)
        W(" ZIP FINTO (costruito dall'autotest di D2-B): ancora con i dati veri di R1A_01, indici SINTETICI. Serve SOLO a provare lo strumento. NESSUN NUMERO VALE.")
        W(" " + "!" * 118)
    W("=" * 120)
    W("(0) ACCETTAZIONE di D2-B sui giornali archiviati (rifatta adesso): %s" % ("PASSATA" if acc_ok else "NON PASSATA -> nessun esito si legge: tutte le celle (C)"))
    for x in acc_righe:
        W(x)
    for x in note:
        W("   nota: " + x)
    ce1 = stato_ce1(lotti)
    if not acc_ok:
        ce1 = (False, "accettazione di D2-B NON passata")
    W("   CE1 ANCORA: " + ce1[1])
    righe_csv = []
    for L in ORDINE:
        D = LOTTI[L]
        if D["ancora"]:
            continue
        W("")
        W("-" * 120)
        W(" LOTTO %s  CELLA %s %s (%s)%s" % (L, D["simbolo"], D["tf"], D["nome"], "   -- CELLA DICHIARATA A RISCHIO (regola R1): un C3G di T1 sotto 40x NON e' una sorpresa" if D["rischio"] else ""))
        W("-" * 120)
        trs = lotti[L]["passate"] if L in lotti else {}
        if L not in lotti:
            W("   lotto NON CARICATO (zip assente, compilazione fallita o lotto non lanciato): tutte le tranche (C)")
        for t in D["tranche"]:
            P = trs.get(t)
            da, a = TRANCHE[t]
            W("")
            if P is None:
                W("   %s %s-%s (ToDate NON compreso): passata ASSENTE" % (t, da, a))
                righe_csv.append({"zip": "FINTO" if finto else "", "lotto": L, "simbolo": D["simbolo"], "tf": D["tf"], "tranche": t, "letta": "no", "manca": "passata assente"})
                continue
            W("   %s %s-%s (ToDate NON compreso)  passata %s  stato driver %s%s" % (t, da, a, P["tag"], P["stato"], (": " + P["riga"]["motivi"]) if P["riga"].get("motivi") else ""))
            lett = "LETTA" if (P["letta"] and ce1[0]) else "NON LETTA"
            cosa = list(P["manca"]) + ([] if ce1[0] else ["ancora CE1 non verde"])
            W("     %s%s" % (lett, (" -- manca: " + "; ".join(cosa)) if cosa else ""))
            for x in P["note"]:
                W("     nota: " + x)
            if P["A"] is None:
                righe_csv.append({"zip": "FINTO" if finto else "", "lotto": L, "simbolo": D["simbolo"], "tf": D["tf"], "tranche": t, "letta": "no", "manca": "; ".join(cosa)})
                continue
            A = P["A"]
            c = P["giornale"]["conta"]
            bordo = "  AL BORDO DI STAMPA (valore vero fra 39,95 e 40,15)" if (P["c3g"] is not None and SOGLIA <= P["c3g"] < 40.1) else ""
            W("     n %s | n NETTO %s (meno %d ingressi a spread zero) | righe segnale %d | a spread > 0 %d | -1.0x %d | giudica il costo: %s" % (
                P["n"], P["nn"], A["ingressi_spread_zero"], A["n"], P["sp_pos"], P["m1"], "SI" if (P["giudica"] and ce1[0]) else "NO"))
            W("     C3G CELLA %s%s | senza le -1.0x %s | CE7 %s: %s" % (fx(P["c3g"]), bordo, fx(P["c3g_pos"]), "verde" if P["ce7"][0] else "ROSSA", P["ce7"][1]))
            W("     BUY %s (n %d)  SELL %s (n %d)  righe >= 40x %d  >= 50x %d   [lati: DESCRIZIONE, nessun lato si promuove da solo]" % (
                fx(A["lati"]["BUY"]["c3g"]), A["lati"]["BUY"]["n"], fx(A["lati"]["SELL"]["c3g"]), A["lati"]["SELL"]["n"], A["ge40"], A["ge50"]))
            W("     EA: segnali %s, tentati %s, scartati spread %s, posizione aperta %s, ATR non valido %s" % (
                *(("n.d.",) * 5 if c is None else (c["seg"], c["ing"], c["spr"], c["pos"], c["dati"])),))
            W("     tick: modello %s, ini Model=%s, qualita '%s', ticks_inizio '%s' -> %s" % (
                P["riga"]["modello"], P["ini"]["tester"].get("Model") if P["ini"] else "n.d.", P["riga"]["qualita"], P["riga"]["ticks_inizio"],
                "CONFERMATI" if not P["tick"] else "NON confermati"))
            W("     G0 del lettore: %s | %s" % ("OK" if not P["g0"] else "KO (" + "; ".join(P["g0"]) + ")",
                                              " | ".join("%s %s" % (k, "verde" if P["ce"][k][0] else "ROSSO") for k in ("CE2", "CE3", "CE4", "CE5", "CE6"))))
            W("     %-15s %-5s %6s %8s %8s %6s %8s %6s %7s %7s %9s" % ("fascia (server)", "ore", "righe", "C3G", "BUY", "n", "SELL", "n", ">=40x", ">=50x", "ingressi"))
            for f in A["fasce"]:
                W("     %-15s %02d-%02d %6d %8s %8s %6d %8s %6d %7d %7d %9d" % (f["nome"], f["lo"], f["hi"], f["n"], fx(f["c3g"]), fx(f["BUY"]["c3g"]), f["BUY"]["n"],
                                                                         fx(f["SELL"]["c3g"]), f["SELL"]["n"], f["ge40"], f["ge50"], f["ingressi"]))
            if t == "T3":
                W("     (T3: l'apertura cash USA e' alle 15:30 server fino al 07/03 e quella del DAX alle 9:00 fino al 28/03: le fasce di T3 NON si confrontano con T1/T2)")
            ds = descrizioni(P)
            W("     DESCRITTIVE (NON decidono nulla):")
            W("       R4: mediana ATR delle righe %s | mediana spread delle righe a spread > 0 %s | giorni server distinti con righe segnale %d" % (
                fx(ds["atr_med"]), fx(ds["spread_pos_med"], 3), ds["giorni"]))
            mi_, mp_ = ds["R5"][0][2], ds["R5"][2][2]
            if mi_ is None or mp_ is None or INF in (mi_, mp_):
                r5 = "confronto posizione aperta / ingressi non calcolabile (gruppo vuoto o INF)"
            elif mp_ < 0.9 * mi_:
                r5 = "posizione aperta %s < 90%% degli ingressi %s: attesa R5 SMENTITA (si scrive, nessun esito cambia)" % (fx(mp_), fx(mi_))
            else:
                r5 = "posizione aperta %s >= 90%% degli ingressi %s: attesa R5 [INFERITO] non smentita" % (fx(mp_), fx(mi_))
            W("       R5: " + " | ".join("%s n %d, mediana stop/spread %s, mediana ATR %s" % (k, n, fx(m), fx(at)) for k, n, m, at in ds["R5"])
              + (" | altre righe %d" % ds["altre"] if ds["altre"] else "") + " | " + r5)
            if ds["dom"] is not None:
                f = ds["dom"]
                W("       R2: fascia dominante degli ingressi '%s': %d su %d ingressi (%.1f%%); righe >= 50x nella fascia %d = %.1f%% delle righe >= 50x della cella, %.1f%% "
                  "delle righe della fascia; segnali %d contro ingressi %d" % (f["nome"], f["ingressi"], A["ingressi"], 100.0 * f["ingressi"] / A["ingressi"], f["ge50"],
                                                                            (100.0 * f["ge50"] / A["ge50"]) if A["ge50"] else 0.0, (100.0 * f["ge50"] / f["n"]) if f["n"] else 0.0,
                                                                            A["n"], A["ingressi"]))
            pff = [("%s %s (n %d)" % (nm, _pf(v), k)) for nm, k, v in ds["pf_fascia"] if v is not None]
            W("       PF per fascia (solo con >= 100 operazioni nella fascia): %s" % (", ".join(pff) or "nessuna fascia con >= 100 operazioni"))
            rep = P["rep"] or {}
            W("       PF del report %s | PF per lato dai deal SENZA commissione aggiunta: BUY %s (n %d), SELL %s (n %d) | commissioni del tester %.2f (attesa ZERO%s)" % (
                P["riga"].get("pf_report") or "n.d.", _pf(ds["pf_lato"]["BUY"][1]), ds["pf_lato"]["BUY"][0], _pf(ds["pf_lato"]["SELL"][1]), ds["pf_lato"]["SELL"][0],
                ds["comm"], "" if ds["comm"] == 0 else ": DIVERSA DA ZERO, fatto del tester da scrivere"))
            W("       RISCHIO (a 1,00 lotto, EUR, NON si confronta con l'oro): perdita a SL mediana %s, p90 %s, max %s | DD equity del report %s" % (
                fx(ds["perdita"][0]), fx(ds["perdita"][1]), fx(ds["perdita"][2]), fx(rep.get("dd_eq_abs"))))
            tot = ds["lati_ing"]["BUY"] + ds["lati_ing"]["SELL"]
            if tot:
                ql = {l: ds["lati_ing"][l] / float(tot) for l in ("BUY", "SELL")}
                W("       lati degli ingressi: BUY %.0f%% SELL %.0f%%%s" % (100 * ql["BUY"], 100 * ql["SELL"], "  -> DA GUARDARE (un lato sotto il 25%)" if min(ql.values()) < QUOTA_LATO else ""))
            if t == "T1" and D["banda"]:
                b0, b1 = D["banda"]
                if P["c3g"] is None:
                    sens = "n.d."
                elif P["c3g"] < b0:
                    sens = "FUORI in BASSO: smentisce la STIMA (sensibilita'), non l'esito"
                elif P["c3g"] > b1:
                    sens = "FUORI in ALTO: smentisce la STIMA (sensibilita'), non l'esito"
                else:
                    sens = "dentro la banda"
                W("       ATTESA T1 [INFERITO, estrapolazione]: C3G %.2f-%.2f -> %s%s | n ingressi banda larga 40-160 -> %s" % (
                    b0, b1, sens, " (cella a rischio: sotto 40x gia' scritto)" if D["rischio"] else "",
                    "n.d." if P["n"] is None else ("dentro" if N_BANDA_T1[0] <= P["n"] <= N_BANDA_T1[1] else "FUORI: si legge il giornale")))
            elif t in ("T2", "T3"):
                W("       ATTESA %s: [NON STIMATO] (nessuna riga di segnale del GBA su %s in %s nel repo: il numero e' NUOVO, nessuna smentita possibile)" % (t, D["simbolo"], t))
            righe_csv.append({"zip": "FINTO" if finto else "", "lotto": L, "simbolo": D["simbolo"], "tf": D["tf"], "tranche": t, "letta": "si" if (P["letta"] and ce1[0]) else "no",
                              "manca": "; ".join(cosa), "n": P["n"], "n_netto": P["nn"], "righe": A["n"], "righe_spread_pos": P["sp_pos"], "righe_m1": P["m1"],
                              "c3g": fx(P["c3g"]), "c3g_senza_m1": fx(P["c3g_pos"]), "ce7": "verde" if P["ce7"][0] else "ROSSA", "ge40": A["ge40"], "ge50": A["ge50"],
                              "buy_c3g": fx(A["lati"]["BUY"]["c3g"]), "buy_n": A["lati"]["BUY"]["n"], "sell_c3g": fx(A["lati"]["SELL"]["c3g"]),
                              "sell_n": A["lati"]["SELL"]["n"], "giudica": "si" if (P["giudica"] and ce1[0]) else "no"})
        tutte = [trs[t]["giornale"]["righe"] for t in D["tranche"] if t in trs and trs[t]["giornale"] is not None]
        if len(tutte) == len(D["tranche"]):
            agg = mediana([x["val"] for rr in tutte for x in rr])
            W("")
            W("   C3G AGGREGATO sulle tre tranche (mediana di TUTTE le righe insieme): %s -- DESCRIZIONE, NON DECIDE (classe 1104 b)" % fx(agg))
        es = esito_cella(trs, D["tranche"], ce1 if acc_ok else (False, "accettazione di D2-B NON passata"))
        W("")
        W("   %sESITO DELLA CELLA %s %s: (%s) %s" % (pre, D["simbolo"], D["tf"], es[0], es[1]))
        W("   %s%s" % (pre, MERITO))
        righe_csv.append({"zip": "FINTO" if finto else "", "lotto": L, "simbolo": D["simbolo"], "tf": D["tf"], "tranche": "CELLA", "esito_cella": pre + "(" + es[0] + ") " + es[1], "merito": "NON MISURATO"})
    W("")
    W(" NON giudica il merito, NON promuove, NON legge un PF come merito; nessun numero va in un preset.")
    testo = "\n".join(out)
    if csv_out:
        campi = ["zip", "lotto", "simbolo", "tf", "tranche", "letta", "manca", "n", "n_netto", "righe", "righe_spread_pos", "righe_m1", "c3g", "c3g_senza_m1", "ce7", "ge40", "ge50",
                 "buy_c3g", "buy_n", "sell_c3g", "sell_n", "giudica", "esito_cella", "merito"]
        with open(csv_out, "w", newline="", encoding="ascii", errors="replace") as fh:
            w = csv.DictWriter(fh, fieldnames=campi, delimiter=";")
            w.writeheader()
            for rr in righe_csv:
                w.writerow(rr)
    return testo


# ---------------------------------------------------------------------------------------------------------------------
#  ZIP FINTO (struttura del driver v5 al pin d53493a9): ancora = file VERI di R1A_01, indici SINTETICI
# ---------------------------------------------------------------------------------------------------------------------
def _ini_driver(L, tag, simbolo, tf, model, da, a, testo_prova, tfval):
    """Come TestoIni del driver v5 (r.638-651): i pin del file prova nell'ordine del file, l'asse dalla cella, InpMagic in coda."""
    righe_in = []
    for k, v in pin_ordinati(testo_prova):
        if k == "InpMagic":
            continue
        righe_in.append("%s=%s" % (k, tfval if k == "InpSignalTF" else v))
    righe_in.append("InpMagic=" + MAGIC)
    return ("[Experts]\r\nAllowLiveTrading=false\r\nAllowDllImport=false\r\n\r\n[Tester]\r\nExpert=ABTG_GoldBreakoutATR.ex5\r\nSymbol=" + simbolo + "\r\nPeriod=" + tf
            + "\r\nModel=" + model + "\r\nOptimization=0\r\nFromDate=" + da + "\r\nToDate=" + a + "\r\nForwardMode=0\r\nDeposit=1000000\r\nCurrency=EUR\r\nLeverage=100\r\n"
            + "ExecutionMode=0\r\nReplaceReport=1\r\nShutdownTerminal=1\r\nReport=GBA_R0_" + tag + "\r\n\r\n[TesterInputs]\r\n" + "\r\n".join(righe_in) + "\r\n")


def _st(i, ora, da, a):
    d0 = datetime.datetime.strptime(da, "%Y.%m.%d")
    nd = (datetime.datetime.strptime(a, "%Y.%m.%d") - d0).days
    giorno = d0 + datetime.timedelta(days=i % nd)
    minuto = ((i // nd) % 4) * 15
    sec = (i // (nd * 4)) % 60
    return "%s %02d:%02d:%02d" % (giorno.strftime("%Y.%m.%d"), ora, minuto, sec)


def _passata_finta(simbolo, tf, da, a, righe, n_exec=None, lotti="1.00", profitti=None):
    """righe = [(lato, preso, motivo, rap, ora)]. Restituisce (testo del giornale, report bytes, n, pf_testo). Dati SINTETICI."""
    L = ["# FINTO passata sintetica (autotest D2-B): NESSUN NUMERO VALE", "# FINESTRA %s|%s|%s|00:00|%s|00:00" % (simbolo, tf, da, a),
         '%s 00:00:00   [GBA] AVVIO v1.10 | InpSymbol="%s" -> simbolo %s | InpSignalTF=PERIOD_%s -> PERIOD_%s | InpTrendTF=PERIOD_CURRENT -> PERIOD_%s | '
         'InpAtrTF=PERIOD_CURRENT -> PERIOD_%s' % (da, simbolo, simbolo, tf, tf, tf, tf)]
    presi = [i for i, x in enumerate(righe) if x[1]]
    n_exec = len(presi) if n_exec is None else n_exec
    deals, k = [], 0
    nets = []
    for i, (lato, preso, motivo, rap, ora) in enumerate(righe):
        st = _st(i, ora, da, a)
        atr = 40.0
        spread = 0.0 if rap == -1.0 else (round(2.5 * atr / rap, 2) if rap > 0 else 1.80)
        sal = "" if preso else " SALTATO (%s)" % motivo
        rs = "-1.0" if rap == -1.0 else "%.1f" % rap
        L.append("%s   [GBA] segnale %s%s | close 20100.00 canale 19900.00-20050.00 EMA 19950.00 ATR %.2f spread %.2f = %.1f%% ATR (max 5.0%%) | stop/spread %sx | ora server %d"
                 % (st, lato, sal, atr, spread, 100.0 * spread / atr, rs, ora))
        if preso and k < n_exec:
            px = 20000.0 + 1.5 * k
            L.append("%s   [GBA] %s %s lotti @ %.2f | SL %.2f (2.50 x ATR %.2f) | spread %.2f | perdita a SL ~100.00 EUR" % (st, lato, lotti, px, px - 100.0, atr, spread))
            prof = profitti[k] if profitti else (150.0 if k % 3 == 0 else -100.0)
            nets.append(prof)
            t1 = (datetime.datetime.strptime(st, "%Y.%m.%d %H:%M:%S") + datetime.timedelta(minutes=10)).strftime("%Y.%m.%d %H:%M:%S")
            tipo = "buy" if lato == "BUY" else "sell"
            deals.append([st, str(2 + 2 * k), simbolo, tipo, "in", lotti, "%.2f" % px, str(2 + 2 * k), "0.00", "0.00", "0.00", "1 000 000.00", "GBA_L"])
            deals.append([t1, str(3 + 2 * k), simbolo, "sell" if tipo == "buy" else "buy", "out", lotti, "%.2f" % (px + 1), str(3 + 2 * k), "0.00", "0.00",
                          LG._fmt(prof), "1 000 000.00", "sl"])
            k += 1
    conta = {"seg": len(righe), "ing": len(presi), "spr": sum(1 for x in righe if not x[1] and x[2].startswith("spread")),
             "pos": sum(1 for x in righe if not x[1] and x[2].startswith("posizione"))}
    fine = (datetime.datetime.strptime(a, "%Y.%m.%d") - datetime.timedelta(days=1)).strftime("%Y.%m.%d")
    L.append("%s 23:59:58   [GBA-CONTA] FINE | segnali %d | ingressi tentati %d | scartati: SPREAD %d (spread max 0.05 x ATR) | posizione aperta %d | ora 0 | "
             "perdita giornaliera 0 | lato spento 0 | ATR non valido 0 | tetto giornaliero 0 (max 0)" % (fine, conta["seg"], conta["ing"], conta["spr"], conta["pos"]))
    pf = LG.pf_di(nets) if nets else float("nan")
    pf_t = "%.2f" % pf if (nets and pf == pf and pf != INF) else ""
    tot = sum(nets)

    def row(c):
        return "<tr>" + "".join("<td>%s</td>" % x for x in c) + "</tr>\n"
    h = "<html><body><table>\n<tr><td>Expert:</td><td><b>ABTG_GoldBreakoutATR</b></td></tr>\n<tr><td>Simbolo:</td><td><b>%s</b></td></tr>\n" % simbolo
    h += "<tr><td>Periodo:</td><td><b>%s (%s - %s)</b></td></tr>\n<tr><td>Deposito Iniziale:</td><td><b>1 000 000.00</b></td></tr>\n" % (tf, da, a)
    h += "<tr><td>Qualit\u00e0 dello Storico:</td><td><b>100% ticks reali</b></td><td>Barre:</td><td><b>5949</b></td><td>Ticks:</td><td><b>22000000</b></td></tr>\n"
    h += "<tr><td>Profitto Totale Netto:</td><td><b>%s</b></td><td>Equit\u00e0 Drawdown Massima:</td><td><b>1 500.00 (0.15%%)</b></td></tr>\n" % LG._fmt(tot)
    h += "<tr><td>Fattore di Profitto:</td><td><b>%s</b></td><td>Numero di Operazioni di Trading Totali:</td><td><b>%d</b></td></tr>\n" % (pf_t, len(nets))
    h += row(["%s 00:00:00" % da, "1", "", "balance", "", "", "", "", "0.00", "0.00", "1 000 000.00", "1 000 000.00", ""])
    for dd in deals:
        h += row(dd)
    h += "</table></body></html>"
    return "\r\n".join(L), ("\ufeff" + h).encode("utf-16-le"), len(nets), pf_t, "%.2f" % tot


def _riepilogo(L, simbolo, tf, n, pin=None, sha_ea=None, finto=True, modello="4"):
    return ("GBA R0 -- lotto %s: ABTG_GoldBreakoutATR v1.10 su %s %s, Modello %s, lotto fisso 1,00, deposito 1000000 EUR, UNA variabile (InpSignalTF)\r\n"
            "data: 2026-10-12 23:00:00   pc: DESKTOP-H4D7CAJ   pin: %s\r\nABTG_GoldBreakoutATR.mq5 SHA256 %s   compilazione: 0 errori, 0 avvisi (-1 = non letto)\r\n"
            "passate del lotto %d\r\n%s\r\n") % (L, simbolo, tf, modello, pin or PIN_AMMESSI[0], sha_ea or SHA_EA, n, MARCA_FINTO if finto else "")


def zip_lotto_finto(L, spec, riepilogo=None, header=None, extra_man=None, prova_bytes=None, togli=(), muta_man=None):
    """spec = {tranche: dict(righe=..., n_exec=None, stato='OK', motivi='', qualita='100%ticksreali', ticks_inizio=..., model_ini='4', lotti='1.00',
    log=None (testo), report=None (bytes), finestra=None, profitti=None)}. Nomi con backslash come Compress-Archive."""
    D = LOTTI[L]
    pr = prova_bytes if prova_bytes is not None else open(os.path.join(QD, "prove", D["prova"]), "rb").read()
    testo_prova = open(os.path.join(QD, "prove", D["prova"]), "rb").read().decode("ascii")
    b = io.BytesIO()
    z = zipfile.ZipFile(b, "w", zipfile.ZIP_DEFLATED)
    z.writestr(D["prova"], pr)
    z.writestr("compile_gba.log", "FINTO\r\n")
    man = [header or HEADER_V5]
    for t, s in spec.items():
        da, a = TRANCHE[t]
        k = D["tranche"].index(t) + 1 if t in D["tranche"] else 9
        tag = "%s_%02d_%s_%s_m%s" % (L, k, D["cella"], t, MAGIC)
        if s.get("log") is not None:
            lg, rep, n, pf_t, tot = s["log"], s["report"], s["n"], s["pf"], s["profitto"]
        else:
            lg, rep, n, pf_t, tot = _passata_finta(D["simbolo"], D["tf"], da, a, s["righe"], s.get("n_exec"), s.get("lotti", "1.00"), s.get("profitti"))
        ti = s.get("ticks_inizio", "EURUSD 2024.07.05 / %s 2024.09.26" % D["simbolo"])
        stato = s.get("stato", "OK")
        campi = [L, tag, D["cella"], "0.05", t, da, a, s.get("modello", MODELLO), MAGIC, "2026-10-12 23:00:00", "40", stato, str(n), tot, pf_t, s.get("qualita", "100%ticksreali"),
                 s.get("barre", "5949"), s.get("ticks", "22000000"), s.get("barre", "5949"), s.get("ticks", "22000000"), ti, "700", str(n), "si", "si",
                 s.get("finestra", da + "-" + a), s.get("motivi", ""), "InpSignalTF", D["tfval"], s.get("simbolo", D["simbolo"]), s.get("periodo", D["tf"]), D["prova"]]
        if muta_man:
            muta_man(t, campi)
        man.append(";".join(campi))
        if stato == "NON_LANCIATA":
            continue
        if "ini" not in togli:
            ini = s.get("ini") or _ini_driver(L, tag, D["simbolo"], D["tf"], s.get("model_ini", MODELLO), da, a, testo_prova, D["tfval"])
            z.writestr("ini\\gba_%s.ini" % tag, ini)
        if "log" not in togli:
            z.writestr("log\\GBA_%s.txt" % tag, lg)
        if "report" not in togli and rep is not None:
            z.writestr("report\\GBA_R0_%s.htm" % tag, rep)
    if extra_man:
        man += extra_man
    z.writestr("MANIFEST_R0.csv", "\r\n".join(man))
    if "riepilogo" not in togli:
        z.writestr("RIEPILOGO_R0.txt", riepilogo if riepilogo is not None else _riepilogo(L, D["simbolo"], D["tf"], len(spec)) + "\r\n".join(man) + "\r\n")
    z.close()
    return b.getvalue()


def spec_ancora_vera():
    """La passata dell'ancora con i file VERI di R1A_01 (giornale e report), ini come lo scrive il driver v5 per R2SBANC, riga di manifest v5 coi numeri di R1A_01."""
    z, N = _archivio_r1a()
    man = [r for r in csv.DictReader(io.StringIO(z.read(N["MANIFEST_R0.csv"]).decode("ascii")), delimiter=";") if r["passata"] == ANCORA["tag"]][0]
    return {"log": z.read(N["log/GBA_%s.txt" % ANCORA["tag"]]).decode("ascii"), "report": z.read(N["report/GBA_R0_%s.htm" % ANCORA["tag"]]), "n": int(man["trades_report"]),
            "pf": man["pf_report"], "profitto": man["profitto_report"], "qualita": man["qualita"], "ticks_inizio": man["ticks_inizio"], "barre": man["barre_report"],
            "ticks": man["ticks_report"]}


def righe_tipo(c3g_x, n_ing=60, n_pos=80, n_spr=200, n_sz_ing=0, n_sz_pos=0, ore_ing=(14, 15, 16, 17, 18, 19, 20)):
    """Righe sintetiche: n_ing ingressi a 60x, n_pos a posizione aperta a 55x, n_spr scartate per spread a c3g_x (< 50), piu' righe a spread zero (-1.0x)."""
    rr = [("BUY" if i % 2 else "SELL", True, "", 60.0, ore_ing[i % len(ore_ing)]) for i in range(n_ing)]
    rr += [("BUY" if i % 2 else "SELL", True, "", -1.0, ore_ing[i % len(ore_ing)]) for i in range(n_sz_ing)]
    rr += [("BUY" if i % 2 else "SELL", False, "posizione gia' aperta", 55.0, (9 + i) % 24) for i in range(n_pos)]
    rr += [("BUY" if i % 2 else "SELL", False, "posizione gia' aperta", -1.0, (9 + i) % 24) for i in range(n_sz_pos)]
    rr += [("BUY" if i % 2 else "SELL", False, "spread oltre il limite", c3g_x, i % 24) for i in range(n_spr)]
    return rr


def raccolta_finta(path, spec_ind=None, esiti_pin=None, extra=None, esiti_extra=""):
    """Scrive la raccolta FINTA GBA_R2S_B (zip annidati + ESITI_R2S_B.txt). spec_ind = {lotto: {tranche: spec}}; default: NAS (P), D30 (F, DAX a cavallo), U30 (N)."""
    if spec_ind is None:
        spec_ind = {"R2SBNAS": {"T1": {"righe": righe_tipo(45.0)}, "T2": {"righe": righe_tipo(46.5)}, "T3": {"righe": righe_tipo(48.0)}},
                    "R2SBD30": {"T1": {"righe": righe_tipo(39.9)}, "T2": {"righe": righe_tipo(44.0)}, "T3": {"righe": righe_tipo(41.0)}},
                    "R2SBU30": {"T1": {"righe": righe_tipo(47.0)}, "T2": {"righe": righe_tipo(47.0, n_ing=29, n_sz_ing=2)}, "T3": {"righe": righe_tipo(47.0)}}}
    with zipfile.ZipFile(path, "w", zipfile.ZIP_DEFLATED) as zr:
        zr.writestr("GBA_R0_R2SBANC.zip", zip_lotto_finto("R2SBANC", {"T1": spec_ancora_vera()}))
        for L, sp in spec_ind.items():
            zr.writestr("GBA_R0_%s.zip" % L, zip_lotto_finto(L, sp))
        for nome, dati in (extra or {}).items():
            zr.writestr(nome, dati)
        zr.writestr("ESITI_R2S_B.txt", "GBA R2S B -- pin %s   pc DESKTOP-H4D7CAJ   inizio 2026-10-12 23:00:00\r\n%s\r\n%s" % (
            esiti_pin or PIN_AMMESSI[0], MARCA_FINTO, "\r\n".join("%s rc 0   minuti 1" % L for L in ORDINE) + esiti_extra))


# ---------------------------------------------------------------------------------------------------------------------
#  AUTOTEST
# ---------------------------------------------------------------------------------------------------------------------
def autotest():
    import tempfile, shutil
    ok_tot = [0, 0]

    def ck(nome, cond, extra=""):
        ok_tot[0 if cond else 1] += 1
        print("  [%s] %s%s" % ("OK " if cond else "FAIL", nome, ("   (" + str(extra)[:170] + ")") if extra else ""))

    def rifiuta(nome, fn):
        try:
            fn()
            ck(nome, False, "NON rifiutato")
        except Rifiuto as ex:
            ck(nome, True, str(ex)[:150])

    print("AUTOTEST %s" % VERSIONE)
    sha_prove = {L: hashlib.sha256(open(os.path.join(QD, "prove", D["prova"]), "rb").read()).hexdigest() for L, D in LOTTI.items()}
    sha_lg_0 = hashlib.sha256(open(os.path.join(QD, LG_FILE), "rb").read()).hexdigest()
    # --- 0. i file prova del repo dicono quello che D2-B crede (blocchi @GBA, SHA della riga)
    for L, D in LOTTI.items():
        ck("file prova %s: SHA256 = quello della riga di lancio" % D["prova"], sha_prove[L] == D["sha"], sha_prove[L][:12])
        ck("file prova %s: @GBA-TRANCHE/CELLA/LOTTO/ASSE e InpSymbol = costanti di D2-B" % D["prova"],
           not verifica_prova(L, open(os.path.join(QD, "prove", D["prova"]), "rb").read().decode("ascii")))
    me = open(os.path.abspath(__file__), "rb").read().decode("ascii")
    blocco = me[me.index("#<<COPIA_D2\n") + len("#<<COPIA_D2\n"):me.index("#>>COPIA_D2")]
    ck("copia di D2 v2: impronta del blocco COPIA_D2 = quella pinnata (calcolata dal blob git della v2 14384D87)", hashlib.sha256(blocco.encode("ascii")).hexdigest() == IMPRONTA_COPIA_D2)
    d2_disco = open(os.path.join(QD, D2_FILE), "rb").read()
    pz = re.split(r"\n(?=def |class )", blocco)
    pezzi = [x.strip() for x in pz[1:] if x.strip() and not x.startswith("class Rifiuto")] + [r.rstrip() for r in pz[0].splitlines() if r.strip()]

    def assenti(testo):
        righe_t = set(x.rstrip() for x in testo.splitlines())
        return [x.split("\n")[0][:60] for x in pezzi if ((x not in testo) if "\n" in x else (x not in righe_t))]
    if hashlib.sha256(d2_disco).hexdigest() == D2_V2_SHA:
        manca_d2 = assenti(d2_disco.decode("ascii"))
        ck("copia di D2 v2: ogni funzione (intera) e ogni riga di costante copiata e' IDENTICA nel file D2 v2 sul disco (%d pezzi)" % len(pezzi), not manca_d2, str(manca_d2[:3]))
    else:
        diversi = assenti(d2_disco.decode("ascii", "replace"))
        print("  [SALTATO] confronto riga per riga con D2 v2: sul disco c'e' D2 con SHA256 %s (non la v2); pezzi copiati assenti da quel file: %d %s"
              % (hashlib.sha256(d2_disco).hexdigest()[:12], len(diversi), diversi[:3]))
    riga_b = open(os.path.join(QD, "righe", "RIGA_LANCIA_GBA_R2S_B.txt"), "rb").read().decode("ascii", "replace")
    ck("riga di lancio: pin d53493a9 e i 4 SHA dei file prova", ("$PIN='%s'" % PIN_AMMESSI[0]) in riga_b and all(D["sha"] in riga_b for D in LOTTI.values()))
    ck("riga di lancio: -ShaEA = SHA dell'EA di D2-B", ("-ShaEA " + SHA_EA) in riga_b)
    # --- 1. aritmetica (quella di D2)
    ck("mediana pari con una centrale INF = INF", mediana([30.0] * 100 + [INF] * 100) == INF)
    ck("mediana pari al bordo: (39,9 + 40,1) / 2 = 40,0 -> >= 40 (inclusivo)", mediana([39.9] * 50 + [40.1] * 50) == 40.0 and mediana([39.9] * 50 + [40.1] * 50) >= SOGLIA)
    vb = [26.4] * 50 + [0.2] * 50
    ck("classe 1379 (S = 13,3: (0,2 + 26,4) / 2 in virgola mobile e' un ulp sotto): la mediana di D2 da' 13,3 esatto", mediana(vb) == 13.3 and (0.2 + 26.4) / 2 < 13.3)
    nulla = [(a / 10.0, b / 10.0) for a in range(0, 800) for b in range(a, 1200) if (a / 10.0 + b / 10.0) / 2 < 40.0 and round((a / 10.0 + b / 10.0) / 2, 9) == 40.0]
    ck("a 40,0 nessuna coppia di valori a 1 decimale (0-120x) cade un ulp sotto: il bordo e' sicuro anche senza arrotondamento", nulla == [], str(len(nulla)))
    # --- 2. ACCETTAZIONE sui dati veri
    acc_ok, acc_r, res_r1a = accettazione()
    for x in acc_r:
        print("     " + x.strip())
    ck("ACCETTAZIONE: R1A T1 = numeri dell'ancora (C3G 21,60, 651/280, n 128) e letta; R1A T3 CE6 rosso vero; cella oro T1-T3 (C); S0_01 Modello 1 non confermato", acc_ok)
    if res_r1a:
        P2r = res_r1a["T2"]
        ck("R1A T2 (tick reali, vero): letta, giudica il costo, C3G < 40 (oro)", P2r["letta"] and P2r["giudica"] and P2r["c3g"] < 40.0, fx(P2r["c3g"]))
        d1 = descrizioni(res_r1a["T1"])
        ck("R1A T1 vero: R4 giorni server distinti fra 1 e 91 (giorni di calendario di T1); R5 ingressi 128, scartate per spread 6614, per posizione aperta 231 (= conteggi dell'EA)",
           0 < d1["giorni"] <= 91 and [x[1] for x in d1["R5"]] == [128, 6614, 231], "giorni %d, R5 %s" % (d1["giorni"], [x[1] for x in d1["R5"]]))
    # --- 3. ESITI DI CELLA su zip finti (ancora VERA)
    td = tempfile.mkdtemp(prefix="d2b_")
    try:
        anc = leggi_lotto("GBA_R0_R2SBANC.zip", zip_lotto_finto("R2SBANC", {"T1": spec_ancora_vera()}))
        P_anc = anc["passate"]["T1"]
        ini_arch = _archivio_r1a()[0].read(_archivio_r1a()[1]["ini/gba_%s.ini" % ANCORA["tag"]]).decode("ascii")
        ck("il generatore dell'ini (copia di TestoIni del driver v5) rifa' l'ini archiviato di R1A_01 salvo Report",
           _righe_ini_senza_report(P_anc["ini_txt"]) == _righe_ini_senza_report(ini_arch))
        arch_a = os.path.join(QD, "risultati_archivio", "GBA_R2S_A_20261012", "GBA_R2S_A.zip")
        raw_a = open(arch_a, "rb").read()
        uguali_a = []
        if hashlib.sha256(raw_a).hexdigest() == "ae62e772345fa531cc7a5f6f041b248923e52f48a1f804904669368e82ce2814":
            za = zipfile.ZipFile(io.BytesIO(raw_a))
            for La, sima in (("R2SNAS", "NASUSD"), ("R2SD30", "D30EUR"), ("R2SU30", "U30USD")):
                zl = zipfile.ZipFile(io.BytesIO(za.read("GBA_R0_%s.zip" % La)))
                Nl = _nomi(zl)
                for kk, tfa, tva in (("01", "M5", "5"), ("02", "M15", "15")):
                    taga = "%s_%s_%s_T1_m775800" % (La, kk, tfa)
                    gen = _ini_driver(La, taga, sima, tfa, "1", "2026.07.01", "2026.09.30", open(os.path.join(QD, "prove", "GBA_R2S_%s_2026-10-12.txt" % sima)).read(), tva)
                    uguali_a.append(_righe_ini(zl.read(Nl["ini/gba_%s.ini" % taga]).decode("ascii")) == _righe_ini(gen))
        ck("il generatore dell'ini rifa' ANCHE i 6 ini VERI degli indici dello stadio A (NAS/D30/U30, M5 e M15, archivio pinnato): il controllo 'ini del driver' e' tarato",
           len(uguali_a) == 6 and all(uguali_a), str(uguali_a))
        ce1 = stato_ce1({"R2SBANC": anc})
        ck("CE1: ancora coi file VERI di R1A_01 -> VERDE", ce1[0], ce1[1][:100])
        sp = spec_ancora_vera()
        sp["profitto"] = "-6577.49"
        ce1x = stato_ce1({"R2SBANC": leggi_lotto("GBA_R0_R2SBANC.zip", zip_lotto_finto("R2SBANC", {"T1": sp}))})
        ck("CONTRO-ESEMPIO CE1: profitto dell'ancora diverso di UN centesimo -> ROSSO", not ce1x[0], ce1x[1][:120])
        sp = spec_ancora_vera()
        sp["ticks"] = "25648546"
        ck("CONTRO-ESEMPIO CE1: un tick in piu' -> ROSSO", not stato_ce1({"R2SBANC": leggi_lotto("x.zip", zip_lotto_finto("R2SBANC", {"T1": sp}))})[0])
        sp = spec_ancora_vera()
        sp["ticks_inizio"] = "EURUSD 2024.07.05"
        ck("CONTRO-ESEMPIO CE1: riga 'ticks data begins from' dell'oro assente (A1 la pretende) -> ROSSO",
           not stato_ce1({"R2SBANC": leggi_lotto("x.zip", zip_lotto_finto("R2SBANC", {"T1": sp}))})[0])
        sp = spec_ancora_vera()
        z1, N1 = _archivio_r1a()
        sp["log"] = z1.read(N1["log/GBA_R1A_02_REPL_T2_m775800.txt"]).decode("ascii").replace("2026.04.", "2026.07.").replace("2026.05.", "2026.08.").replace("2026.06.", "2026.09.")
        try:
            r_x = stato_ce1({"R2SBANC": leggi_lotto("x.zip", zip_lotto_finto("R2SBANC", {"T1": sp}))})
            ck("CONTRO-ESEMPIO CE1: giornale di un'altra tranche spostato di date -> ROSSO o RIFIUTO", not r_x[0], r_x[1][:100])
        except Rifiuto as ex:
            ck("CONTRO-ESEMPIO CE1: giornale di un'altra tranche spostato di date -> ROSSO o RIFIUTO", True, str(ex)[:100])
        ck("CE1 senza lo zip dell'ancora -> NON LETTO", not stato_ce1({})[0])
        ce1n = stato_ce1({"R2SBANC": leggi_lotto("x.zip", zip_lotto_finto("R2SBANC", {"T1": dict(spec_ancora_vera(), stato="NON_LANCIATA", motivi="tetto di 10 minuti")}))})
        ck("CE1: passata dell'ancora NON LANCIATA -> ROSSO, senza eccezioni", not ce1n[0], ce1n[1][:100])

        def cella(L, spec, ce=None, **kw):
            Lz = leggi_lotto("GBA_R0_%s.zip" % L, zip_lotto_finto(L, spec, **kw))
            return esito_cella(Lz["passate"], LOTTI[L]["tranche"], ce or ce1), Lz
        T = lambda x, **k: {"righe": righe_tipo(x, **k)}
        ok3 = {"T1": T(45.0), "T2": T(46.5), "T3": T(48.0)}
        es, Lz = cella("R2SBNAS", ok3)
        ck("(P): tre tranche lette a 45 / 46,5 / 48x, n netto 60, 340 righe a spread > 0 -> PASSA LO STADIO B (COSTO), NON una sedia", es[0] == "P" and "NON e' una sedia" in es[1], es[1][:90])
        ck("(P) T2 e T3 lette coi loro numeri (attese NON STIMATE)", Lz["passate"]["T2"]["letta"] and uguale(Lz["passate"]["T2"]["c3g"], 46.5) and uguale(Lz["passate"]["T3"]["c3g"], 48.0))
        es, _ = cella("R2SBNAS", ok3, ce=(False, "ROSSO"))
        ck("stesse tranche con CE1 ROSSA -> (C) su tutte", es[0] == "C" and es[1].count("ancora CE1") == 3)
        # (C) per tick: ticks_inizio dopo l'inizio della tranche
        s = dict(ok3, T2=dict(T(46.5), ticks_inizio="EURUSD 2024.07.05 / NASUSD 2026.05.01"))
        es, Lz = cella("R2SBNAS", s)
        ck("(C): T2 con tick NASUSD solo dal 2026.05.01 (dopo l'inizio di T2) -> storia a tick NON confermata", es[0] == "C" and "T2:" in es[1] and "2026.05.01" in es[1], es[1][:140])
        s = dict(ok3, T1=dict(T(45.0), qualita="100%"))
        es, _ = cella("R2SBNAS", s)
        ck("(C): T1 con qualita' '100%' e stato OK (r.815 del driver la lascia passare) -> NON confermata", es[0] == "C" and "100% ticks reali" in es[1])
        s = dict(ok3, T3=dict(T(48.0), qualita="100% ticks reali"))
        es, _ = cella("R2SBNAS", s)
        ck("qualita' '100% ticks reali' con gli spazi = '100%ticksreali' -> (P)", es[0] == "P")
        s = dict(ok3, T3=dict(T(48.0), model_ini="1"))
        es, _ = cella("R2SBNAS", s)
        ck("(C): T3 con ini Model=1 (manifest 4) -> NON confermata", es[0] == "C" and "ini Model=1" in es[1])
        s = dict(ok3, T1=dict(T(45.0), ticks_inizio="EURUSD 2024.07.05"))
        es, Lz = cella("R2SBNAS", s)
        ck("riga 'ticks data begins from' del simbolo ASSENTE (cache, il driver non mette KO) -> letta con la nota (file prova)", es[0] == "P" and Lz["passate"]["T1"]["note"])
        s = dict(ok3, T2=dict(T(46.5), stato="KO", motivi="qualita dello storico \"98%\" invece di 100% ticks reali: il verdetto a ticks reali NON vale", qualita="98%"))
        es, _ = cella("R2SBNAS", s)
        ck("(C): T2 KO nel driver per qualita' 98% -> tranche nominata non letta", es[0] == "C" and "T2:" in es[1])
        # classe 1369: T2 non letta e T1, T3 a 50x -> (C), mai (P) 'a vuoto'
        s = {"T1": T(45.0), "T2": dict(T(46.5), stato="NON_LANCIATA", motivi="tetto di 30 minuti"), "T3": T(48.0)}
        es, _ = cella("R2SBNAS", s)
        ck("classe 1369: T2 NON LANCIATA, T1 e T3 >= 40x -> (C), mai (P) sulle sole lette", es[0] == "C" and "NON LANCIATA" in es[1])
        es, _ = cella("R2SBNAS", {"T1": T(45.0), "T3": T(48.0)})
        ck("classe 1369: T2 ASSENTE dal manifest -> (C)", es[0] == "C" and "T2: passata ASSENTE" in es[1])
        # (F)
        es, _ = cella("R2SBNAS", dict(ok3, T2=T(38.0)))
        ck("(F): T2 a 38x con 340 righe a spread > 0 -> FRA IN T2, non chiude la casella", es[0] == "F" and "FRA IN T2" in es[1] and "Non chiude la casella 4" in es[1])
        es, _ = cella("R2SBNAS", dict(ok3, T1=T(12.0), T3=T(39.0)))
        ck("(F): elenca TUTTE le tranche sotto 40x e 'SOTTO 13,3x in T1'", es[0] == "F" and "T1/T3" in es[1] and "SOTTO 13,3x in T1" in es[1], es[1][:100])
        es, Lz = cella("R2SBNAS", dict(ok3, T1=T(39.9)))
        ck("bordo: 39,9 -> (F)", es[0] == "F")
        es, Lz = cella("R2SBNAS", dict(ok3, T1=T(40.0)))
        ck("bordo: 40,0 -> (P) (inclusivo) e 'AL BORDO DI STAMPA' in stampa", es[0] == "P" and uguale(Lz["passate"]["T1"]["c3g"], 40.0))
        rr = [("BUY" if i % 2 else "SELL", True, "", 60.0, 15) for i in range(60)] + [("BUY" if i % 2 else "SELL", False, "spread oltre il limite", 39.9, i % 24) for i in range(170)] \
            + [("BUY" if i % 2 else "SELL", False, "spread oltre il limite", 40.1, i % 24) for i in range(50)] + [("SELL", False, "posizione gia' aperta", 40.1, 9) for i in range(60)]
        es, Lz = cella("R2SBNAS", dict(ok3, T1={"righe": rr}))
        ck("mediana PARI al bordo dentro un giornale: 340 righe, centrali 39,9 e 40,1 -> 40,0 -> (P)", es[0] == "P" and Lz["passate"]["T1"]["c3g"] == 40.0, fx(Lz["passate"]["T1"]["c3g"]))
        # contro-esempio dell'aggregato (classe 1104 b): T1 38 su 300, T2 55 su 500, T3 60 su 500 -> (F) anche con l'aggregato ~55
        es, Lz = cella("R2SBNAS", {"T1": T(38.0, n_spr=160), "T2": {"righe": righe_tipo(45.0, n_spr=0, n_pos=440)}, "T3": {"righe": righe_tipo(45.0, n_spr=0, n_pos=440)}})
        agg = mediana([x["val"] for t in ("T1", "T2", "T3") for x in Lz["passate"][t]["giornale"]["righe"]])
        ck("classe 1104 b: T1 38x (300 righe), T2 e T3 ~55x (500 righe) -> aggregato %s >= 40 ma ESITO (F) in T1" % fx(agg), es[0] == "F" and "T1" in es[1] and agg >= 40.0)
        # (N)
        es, _ = cella("R2SBNAS", dict(ok3, T2={"righe": righe_tipo(46.5, n_ing=29)}))
        ck("(N): T2 n netto 29 (n 29) -> NON PASSA LO STADIO B, NON ANCORA MISURATO", es[0] == "N" and "T2: n NETTO 29 < 30" in es[1], es[1][:120])
        es, _ = cella("R2SBNAS", dict(ok3, T2={"righe": righe_tipo(46.5, n_ing=29, n_sz_ing=2)}))
        ck("(N): T2 n 31 di cui 2 a spread zero -> n netto 29", es[0] == "N" and "n NETTO 29" in es[1])
        es, Lz = cella("R2SBNAS", dict(ok3, T3={"righe": righe_tipo(45.0, n_ing=40, n_pos=0, n_spr=59, n_sz_pos=2)}))
        ck("(N): T3 101 righe di cui 99 a spread > 0 -> 'righe a spread > 0 99 < 100'", es[0] == "N" and "righe a spread > 0 99 < 100" in es[1] and Lz["passate"]["T3"]["A"]["n"] == 101, es[1][:150])
        rr = [("BUY" if i % 2 else "SELL", True, "", 60.0, 15) for i in range(40)] + [("BUY" if i % 2 else "SELL", False, "spread oltre il limite", 42.0, i % 24) for i in range(50)] \
            + [("BUY" if i % 2 else "SELL", False, "posizione gia' aperta", -1.0, i % 24) for i in range(210)]
        es, Lz = cella("R2SBNAS", dict(ok3, T1={"righe": rr}))
        P1 = Lz["passate"]["T1"]
        ck("classe 1386: T1 300 righe, 210 a -1.0x, 90 a spread > 0 a 42x -> C3G INF e 42 (CE7 verde) ma (N) per le 90 righe",
           es[0] == "N" and P1["c3g"] == INF and uguale(P1["c3g_pos"], 42.0) and P1["ce7"][0] and "righe a spread > 0 90 < 100" in es[1], es[1][:120])
        es, _ = cella("R2SBNAS", {"T1": {"righe": rr}, "T2": T(38.0), "T3": T(48.0)})
        ck("classe 1378: la clausola delle righe a spread > 0 sta DOPO (F): T1 come sopra e T2 a 38x -> (F), non (N)", es[0] == "F" and "T2" in es[1])
        rr = [("BUY" if i % 2 else "SELL", False, "spread oltre il limite", 30.0, i % 24) for i in range(160)] + [("BUY" if i % 2 else "SELL", True, "", 60.0, 15) for i in range(40)] \
            + [("BUY" if i % 2 else "SELL", False, "posizione gia' aperta", -1.0, i % 24) for i in range(160)]
        es, Lz = cella("R2SBNAS", dict(ok3, T2={"righe": rr}))
        P2 = Lz["passate"]["T2"]
        ck("CE7 ROSSA (360 righe: 160 a 30x, 40 a 60x, 160 a -1.0x -> C3G 60 con le -1.0x, 30 senza) -> esito (N) come nel file prova, mai (P) ne' (F)",
           es[0] == "N" and not P2["ce7"][0] and "NON LEGGIBILE PER SPREAD ZERO" in es[1] and P2["c3g"] >= 40.0 and P2["c3g_pos"] < 40.0,
           "C3G %s senza %s" % (fx(P2["c3g"]), fx(P2["c3g_pos"])))
        rr = [("BUY" if i % 2 else "SELL", False, "spread oltre il limite", 30.0, i % 24) for i in range(170)] + [("BUY" if i % 2 else "SELL", True, "", 60.0, 15) for i in range(30)] \
            + [("BUY" if i % 2 else "SELL", False, "posizione gia' aperta", -1.0, i % 24) for i in range(140)]
        P_ = leggi_lotto("x.zip", zip_lotto_finto("R2SBNAS", dict(ok3, T2={"righe": rr})))["passate"]["T2"]
        ck("mediana PARI con centrale INF: 340 righe, 170 a 30x, 30 a 60x, 140 a INF -> centrali (30, 60) = 45, non INF", uguale(P_["c3g"], 45.0), fx(P_["c3g"]))
        rr = [("BUY" if i % 2 else "SELL", False, "spread oltre il limite", 30.0, i % 24) for i in range(130)] + [("BUY" if i % 2 else "SELL", True, "", 60.0, 15) for i in range(40)] \
            + [("BUY" if i % 2 else "SELL", False, "posizione gia' aperta", -1.0, i % 24) for i in range(170)]
        P_ = leggi_lotto("x.zip", zip_lotto_finto("R2SBNAS", dict(ok3, T2={"righe": rr})))["passate"]["T2"]
        ck("mediana PARI con centrale INF: 340 righe, 130 a 30x, 40 a 60x, 170 a INF -> centrali (60, INF) = INF", P_["c3g"] == INF, fx(P_["c3g"]))
        es, _ = cella("R2SBNAS", dict(ok3, T1={"righe": righe_tipo(45.0, n_pos=10, n_spr=40)}))
        ck("bordo delle righe: T1 con 110 righe -> (P); con 90 righe -> (N) 'righe segnale 90 < 100'", es[0] == "P"
           and cella("R2SBNAS", dict(ok3, T1={"righe": righe_tipo(45.0, n_pos=10, n_spr=20)}))[0][0] == "N")
        es, Lz = cella("R2SBNAS", dict(ok3, T1={"righe": righe_tipo(30.0, n_ing=30, n_pos=0, n_spr=60)}))
        ck("righe < 100 (90) con C3G 30 < 40: NON giudica il costo -> (N), non (F) (file prova: giudica solo con >= 100 righe)",
           es[0] == "N" and uguale(Lz["passate"]["T1"]["c3g"], 30.0) and not Lz["passate"]["T1"]["giudica"])
        # DAX con banda a cavallo
        es, Lz = cella("R2SBD30", {"T1": T(39.9), "T2": T(44.0), "T3": T(41.0)})
        ck("DAX (cella a rischio) T1 39,9x dentro la banda 39,77-44,37 -> (F) in T1", es[0] == "F" and "T1" in es[1])
        es, _ = cella("R2SBD30", {"T1": T(41.0), "T2": T(44.0), "T3": T(41.0)})
        ck("DAX T1 41x -> (P)", es[0] == "P")
        # altri controlli che tolgono la lettura
        es, _ = cella("R2SBNAS", dict(ok3, T1=dict(T(45.0), lotti="0.50")))
        ck("CE5: ingressi a 0,50 lotti -> (C)", es[0] == "C" and "CE5" in es[1])
        es, _ = cella("R2SBNAS", dict(ok3, T1=dict(T(45.0), n_exec=58)))
        ck("CE6: tentati 60, n 58 -> (C)", es[0] == "C" and "CE6" in es[1])
        es, _ = cella("R2SBNAS", dict(ok3, T1=dict(T(45.0), n_exec=59)))
        ck("CE6 ammesso: tentati 60, n 59 -> letta", es[0] == "P")
        lg_to = "# passata [2/3] M15 T2 magic 775800   durata 1800 s\r\n# TESTER timeout"
        es, _ = cella("R2SBNAS", dict(ok3, T2={"log": lg_to, "report": None, "n": "", "pf": "", "profitto": "", "stato": "KO", "motivi": "timeout di 30 minuti | riga AVVIO dell EA NON trovata nei log"}),
                      togli=())
        ck("passata KO per TIMEOUT con giornale vuoto e report assente -> (C) per quella tranche, non un rifiuto dello zip", es[0] == "C" and "timeout" in es[1], es[1][:140])
        es, _ = cella("R2SBNAS", dict(ok3, T1={"righe": righe_tipo(45.0)}, T2={"righe": righe_tipo(38.0)}, T3={"righe": righe_tipo(30.0, n_ing=30, n_pos=0, n_spr=60)}))
        ck("(F) in T2, e T3 sotto 40x con 90 righe scritta accanto come SOLA descrizione (non giudica il costo)", es[0] == "F" and "FRA IN T2 " in es[1] and "T3 C3G 30.00 (NON giudica" in es[1], es[1][:200])
        es, _ = cella("R2SBNAS", dict(ok3, T2=dict(T(46.5), stato="OK_FINESTRA_NON_LETTA", finestra="non letta")))
        ck("stato OK_FINESTRA_NON_LETTA -> (C) (finestra del tester non verificata)", es[0] == "C" and "finestra" in es[1])
        lg_t, rep_t, n_t, pf_t, tot_t = _passata_finta("NASUSD", "M15", "2026.04.01", "2026.06.30", righe_tipo(46.5))
        rep_alt = rep_t.decode("utf-16-le").replace("<td><b>%s</b></td><td>Numero" % pf_t, "<td><b>9.99</b></td><td>Numero").encode("utf-16-le")
        es, _ = cella("R2SBNAS", dict(ok3, T2={"log": lg_t, "report": rep_alt, "n": n_t, "pf": "9.99", "profitto": tot_t}))
        ck("G0 del lettore KO (PF del report 9,99 contro i deal) -> (C)", es[0] == "C" and "G0 del lettore KO" in es[1], es[1][:120])
        lg_oro = lg_t.replace("spread 1.67", "spread 0.20").replace("spread 1.82", "spread 0.20").replace("spread 2.15", "spread 0.20")
        es, _ = cella("R2SBNAS", dict(ok3, T2={"log": lg_oro, "report": rep_t, "n": n_t, "pf": pf_t, "profitto": tot_t}))
        ck("CE2: spread dell'oro (0,20) in ogni fascia sotto l'etichetta NASUSD -> (C)", es[0] == "C" and "CE2" in es[1], es[1][:100])
        # --- 4. RIFIUTI (nessun numero)
        base = dict(ok3)
        rifiuta("RIFIUTO: RIEPILOGO di un altro pin (cc9bcda0, stadio A)", lambda: leggi_lotto("x.zip", zip_lotto_finto("R2SBNAS", base, riepilogo=_riepilogo(
            "R2SBNAS", "NASUSD", "M15", 3, pin="cc9bcda0b64943b1e02ae8f52af68ccff81012d4"))))
        rifiuta("RIFIUTO: RIEPILOGO con lo SHA256 di un altro EA", lambda: leggi_lotto("x.zip", zip_lotto_finto("R2SBNAS", base, riepilogo=_riepilogo("R2SBNAS", "NASUSD", "M15", 3, sha_ea="0" * 64))))
        rifiuta("RIFIUTO: RIEPILOGO a Modello 1", lambda: leggi_lotto("x.zip", zip_lotto_finto("R2SBNAS", base, riepilogo=_riepilogo("R2SBNAS", "NASUSD", "M15", 3, modello="1"))))
        rifiuta("RIFIUTO: RIEPILOGO_R0.txt ASSENTE", lambda: leggi_lotto("x.zip", zip_lotto_finto("R2SBNAS", base, togli=("riepilogo",))))
        rifiuta("RIFIUTO: manifest non v5 (27 colonne, v4)", lambda: leggi_lotto("x.zip", zip_lotto_finto("R2SBNAS", base, header=HEADER_V5.rsplit(";", 5)[0],
                                                                                                          muta_man=lambda t, c: c.__delitem__(slice(27, 32)))))
        rifiuta("RIFIUTO: la stessa (cella, tranche) due volte nel manifest", lambda: leggi_lotto("x.zip", zip_lotto_finto("R2SBNAS", {"T1": T(45.0)}, extra_man=[
            ";".join(["R2SBNAS", "R2SBNAS_02_M15_T1_m775800", "M15", "0.05", "T1", "2026.07.01", "2026.09.30", "4", "775800", "", "0", "NON_LANCIATA"] + [""] * 9
                     + ["0", "0", "no", "no", "", "x", "InpSignalTF", "15", "NASUSD", "M15", LOTTI["R2SBNAS"]["prova"]])])))
        rifiuta("RIFIUTO: manifest di un lotto NON in elenco (R2SNAS dello stadio A)", lambda: leggi_lotto("x.zip", zip_lotto_finto("R2SBNAS", base, muta_man=lambda t, c: c.__setitem__(0, "R2SNAS"))))
        rifiuta("RIFIUTO: simbolo del manifest diverso (XAUUSD nel lotto R2SBNAS)", lambda: leggi_lotto("x.zip", zip_lotto_finto("R2SBNAS", {"T1": dict(T(45.0), simbolo="XAUUSD")})))
        rifiuta("RIFIUTO: TF del manifest diverso (M5)", lambda: leggi_lotto("x.zip", zip_lotto_finto("R2SBNAS", {"T1": dict(T(45.0), periodo="M5")})))
        rifiuta("RIFIUTO: modello del manifest 1", lambda: leggi_lotto("x.zip", zip_lotto_finto("R2SBNAS", {"T1": dict(T(45.0), modello="1")})))
        rifiuta("RIFIUTO: tranche con le date di un'altra (T2 col da di T1)", lambda: leggi_lotto("x.zip", zip_lotto_finto("R2SBNAS", base, muta_man=lambda t, c: c.__setitem__(5, "2026.07.01") if t == "T2" else None)))
        rifiuta("RIFIUTO: tranche non dichiarata (T4)", lambda: leggi_lotto("x.zip", zip_lotto_finto("R2SBNAS", base, muta_man=lambda t, c: c.__setitem__(4, "T4") if t == "T3" else None)))
        rifiuta("RIFIUTO: ini con Symbol diverso", lambda: leggi_lotto("x.zip", zip_lotto_finto("R2SBNAS", {"T1": dict(T(45.0), ini=_ini_driver(
            "R2SBNAS", "R2SBNAS_01_M15_T1_m775800", "XAUUSD", "M15", "4", "2026.07.01", "2026.09.30", open(os.path.join(QD, "prove", LOTTI["R2SBNAS"]["prova"])).read(), "15"))})))
        rifiuta("RIFIUTO: ini con InpSignalTF diverso dalla cella (5)", lambda: leggi_lotto("x.zip", zip_lotto_finto("R2SBNAS", {"T1": dict(T(45.0), ini=_ini_driver(
            "R2SBNAS", "R2SBNAS_01_M15_T1_m775800", "NASUSD", "M15", "4", "2026.07.01", "2026.09.30", open(os.path.join(QD, "prove", LOTTI["R2SBNAS"]["prova"])).read(), "5"))})))
        ini_dep = _ini_driver("R2SBNAS", "R2SBNAS_01_M15_T1_m775800", "NASUSD", "M15", "4", "2026.07.01", "2026.09.30", open(os.path.join(QD, "prove", LOTTI["R2SBNAS"]["prova"])).read(), "15").replace("Deposit=1000000", "Deposit=10000")
        rifiuta("RIFIUTO: ini con Deposit=10000 (non quello del driver v5)", lambda: leggi_lotto("x.zip", zip_lotto_finto("R2SBNAS", {"T1": dict(T(45.0), ini=ini_dep)})))
        rifiuta("RIFIUTO: file prova con un byte diverso", lambda: leggi_lotto("x.zip", zip_lotto_finto("R2SBNAS", base, prova_bytes=open(os.path.join(QD, "prove", LOTTI["R2SBNAS"]["prova"]), "rb").read() + b"\n")))
        rifiuta("RIFIUTO: file prova dello stadio A nello zip dello stadio B", lambda: leggi_lotto("x.zip", zip_lotto_finto("R2SBNAS", base, prova_bytes=open(os.path.join(QD, "prove", "GBA_R2S_NASUSD_2026-10-12.txt"), "rb").read())))
        rifiuta("RIFIUTO: giornale ASSENTE", lambda: leggi_lotto("x.zip", zip_lotto_finto("R2SBNAS", base, togli=("log",))))
        rifiuta("RIFIUTO: ini ASSENTE", lambda: leggi_lotto("x.zip", zip_lotto_finto("R2SBNAS", base, togli=("ini",))))
        lg_o, rep_o, n_o, pf_o, tot_o = _passata_finta("NASUSD", "M15", "2026.07.01", "2026.09.30", righe_tipo(45.0))
        lg_ora = lg_o
        k = lg_ora.find("| ora server 15")
        lg_ora = lg_ora[:k] + "| ora server 16" + lg_ora[k + len("| ora server 15"):]
        rifiuta("RIFIUTO: OROLOGIO, ora server diversa dall'ora simulata della riga", lambda: leggi_lotto("x.zip", zip_lotto_finto("R2SBNAS", {"T1": {"log": lg_ora, "report": rep_o, "n": n_o, "pf": pf_o, "profitto": tot_o}})))
        lg_fuori = lg_o.replace("2026.07.01 14:", "2026.09.30 14:")
        rifiuta("RIFIUTO: righe datate il ToDate (NON compreso, MISURATO)", lambda: leggi_lotto("x.zip", zip_lotto_finto("R2SBNAS", {"T1": {"log": lg_fuori, "report": rep_o, "n": n_o, "pf": pf_o, "profitto": tot_o}})))
        lg_2025 = lg_o.replace("2026.07.", "2025.07.")
        rifiuta("RIFIUTO: righe di un'altra finestra (2025)", lambda: leggi_lotto("x.zip", zip_lotto_finto("R2SBNAS", {"T1": {"log": lg_2025, "report": rep_o, "n": n_o, "pf": pf_o, "profitto": tot_o}})))
        lg_av = lg_o.replace('InpSymbol="NASUSD" -> simbolo NASUSD', 'InpSymbol="U30USD" -> simbolo U30USD')
        rifiuta("RIFIUTO: AVVIO dell'EA con un altro simbolo", lambda: leggi_lotto("x.zip", zip_lotto_finto("R2SBNAS", {"T1": {"log": lg_av, "report": rep_o, "n": n_o, "pf": pf_o, "profitto": tot_o}})))
        lg_fin = lg_o.replace("# FINESTRA NASUSD|M15|", "# FINESTRA NASUSD|M5|")
        rifiuta("RIFIUTO: FINESTRA del tester con un altro TF", lambda: leggi_lotto("x.zip", zip_lotto_finto("R2SBNAS", {"T1": {"log": lg_fin, "report": rep_o, "n": n_o, "pf": pf_o, "profitto": tot_o}})))
        rep_sim = rep_o.decode("utf-16-le").replace("<b>NASUSD</b>", "<b>XAUUSD</b>", 1).encode("utf-16-le")
        rifiuta("RIFIUTO: report di un altro simbolo", lambda: leggi_lotto("x.zip", zip_lotto_finto("R2SBNAS", {"T1": {"log": lg_o, "report": rep_sim, "n": n_o, "pf": pf_o, "profitto": tot_o}})))
        righe_lg = lg_o.split("\r\n")
        lg_dup = "\r\n".join(righe_lg[:4] + [righe_lg[3]] + righe_lg[4:])
        rifiuta("RIFIUTO: giornale con una riga doppia (chiave del driver)", lambda: leggi_lotto("x.zip", zip_lotto_finto("R2SBNAS", {"T1": {"log": lg_dup, "report": rep_o, "n": n_o, "pf": pf_o, "profitto": tot_o}})))
        rifiuta("RIFIUTO: nome dello zip con un altro lotto", lambda: leggi_lotto("GBA_R0_R2SBD30.zip", zip_lotto_finto("R2SBNAS", base)))
        # --- 5. la raccolta FINTA letta fino in fondo (struttura del driver v5, backslash, 32 colonne, RIEPILOGO, ESITI)
        rac = os.path.join(td, "GBA_R2S_B_FINTO.zip")
        raccolta_finta(rac)
        with zipfile.ZipFile(rac) as zr, zipfile.ZipFile(io.BytesIO(zr.read("GBA_R0_R2SBNAS.zip"))) as zl:
            nomi = zl.namelist()
            hdr = zl.read("MANIFEST_R0.csv").decode("ascii").splitlines()[0]
        ck("zip finto: nomi con backslash, manifest a 32 colonne, RIEPILOGO, report/log/ini per 3 passate",
           any("\\" in n for n in nomi) and len(hdr.split(";")) == 32 and "RIEPILOGO_R0.txt" in nomi and sum(1 for n in nomi if n.startswith("log\\")) == 3, str(len(nomi)))
        lotti_f, note_f, finto_f = carica([rac])
        acc2, accr2, _ = accettazione()
        csvp = os.path.join(td, "d2b.csv")
        testo = stampa(lotti_f, note_f, acc2, accr2, finto_f, csvp)
        esiti = [l for l in testo.splitlines() if "ESITO DELLA CELLA" in l]
        ck("raccolta FINTA letta fino in fondo: 4 lotti, 3 esiti di cella NAS (P) / D30 (F) / U30 (N), ognuno marcato FINTO",
           set(lotti_f) == set(ORDINE) and len(esiti) == 3 and "(P)" in esiti[0] and "(F)" in esiti[1] and "(N)" in esiti[2] and all("ZIP FINTO" in l for l in esiti), " | ".join(x[:60] for x in esiti))
        ck("stampa: MERITO NON MISURATO per ogni cella; ASCII puro; mai le parole vietate (anche nel CSV); mai 'costo basso' (R2 iii)",
           testo.count("MERITO: NON MISURATO") == 3 and all(ord(ch) < 128 for ch in testo)
           and not any(p in testo.upper() for p in PAROLE_VIETATE) and not any(p in open(csvp, encoding="ascii").read().upper() for p in PAROLE_VIETATE)
           and "costo basso" not in testo.lower())
        ck("stampa: R4, R5, R2, PF per lato, RISCHIO, ATTESA T1 e T2/T3 NON STIMATE, C3G aggregato DESCRIZIONE",
           testo.count("R4:") == 9 and testo.count("R5:") == 9 and testo.count("[NON STIMATO]") == 6 and testo.count("ATTESA T1") == 3 and testo.count("NON DECIDE") == 3
           and "PF per lato dai deal SENZA commissione aggiunta" in testo)
        ck("stampa: DAX T1 39,9 dentro la banda a cavallo, 'cella a rischio'", "CELLA DICHIARATA A RISCHIO" in testo and "dentro la banda (cella a rischio" in testo)
        rows = list(csv.DictReader(open(csvp, encoding="ascii"), delimiter=";"))
        ck("CSV: 3 celle x (3 tranche + 1 riga CELLA)", len(rows) == 12 and sum(1 for x in rows if x["tranche"] == "CELLA") == 3, str(len(rows)))
        rifiuta("RIFIUTO: la stessa raccolta caricata due volte", lambda: carica([rac, rac]))
        rac2 = os.path.join(td, "altro_pin.zip")
        raccolta_finta(rac2, esiti_pin="cc9bcda0b64943b1e02ae8f52af68ccff81012d4")
        rifiuta("RIFIUTO: ESITI_R2S_B.txt di un altro pin", lambda: carica([rac2]))
        rac3 = os.path.join(td, "lotto_fuori.zip")
        raccolta_finta(rac3, extra={"GBA_R0_R2SNAS.zip": b"x"})
        rifiuta("RIFIUTO: raccolta con uno zip di un lotto non in elenco (R2SNAS)", lambda: carica([rac3]))
        rac5 = os.path.join(td, "esiti_fuori.zip")
        raccolta_finta(rac5, esiti_extra="\r\nR2SNAS rc 0   minuti 1")
        rifiuta("RIFIUTO: ESITI_R2S_B.txt che nomina un lotto fuori elenco (R2SNAS)", lambda: carica([rac5]))
        rac4 = os.path.join(td, "comp.zip")
        sp4 = {"R2SBNAS": {"T1": T(45.0), "T2": T(46.5), "T3": T(48.0)}, "R2SBU30": {"T1": T(47.0), "T2": T(47.0), "T3": T(47.0)}}
        raccolta_finta(rac4, spec_ind=sp4, extra={"GBA_R0_R2SBD30_COMPILAZIONE_FALLITA.zip": b"x"})
        l4, n4, f4 = carica([rac4])
        t4 = stampa(l4, n4, acc2, accr2, f4, None)
        e4 = [l for l in t4.splitlines() if "ESITO DELLA CELLA" in l]
        ck("lotto DAX fermo alla COMPILAZIONE: la sua cella (C), le altre (P)", "(C)" in e4[1] and "(P)" in e4[0] and "(P)" in e4[2] and any("COMPILAZIONE" in x for x in n4))
        rac6 = os.path.join(td, "timeout.zip")
        sp6 = {"R2SBNAS": {"T1": T(45.0), "T2": {"log": lg_to, "report": None, "n": "", "pf": "", "profitto": "", "stato": "KO", "motivi": "timeout di 30 minuti"},
                           "T3": dict(T(48.0), stato="NON_LANCIATA", motivi="lotto fermato")},
               "R2SBD30": {"T1": {"righe": []}, "T2": {"righe": [("BUY", False, "posizione gia' aperta", -1.0, 3)] * 1}, "T3": T(41.0)}}
        raccolta_finta(rac6, spec_ind=sp6)
        l6, n6, f6 = carica([rac6])
        t6 = stampa(l6, n6, acc2, accr2, f6, os.path.join(td, "t6.csv"))
        e6 = [l for l in t6.splitlines() if "ESITO DELLA CELLA" in l]
        ck("stampa senza crash con: tranche KO per timeout (giornale vuoto, report assente), tranche NON LANCIATA, tranche con ZERO righe, tranche con UNA riga -1.0x, lotto Dow assente",
           len(e6) == 3 and "(C)" in e6[0] and "(N)" in e6[1] and "(C)" in e6[2] and "LOTTO R2SBU30" in t6, " | ".join(x[40:100] for x in e6))
        t5 = stampa(lotti_f, note_f, False, ["   accettazione finta NON passata"], finto_f, None)
        ck("accettazione NON passata -> tutte le celle (C)", all("(C)" in l for l in t5.splitlines() if "ESITO DELLA CELLA" in l))
        # matrice esaustiva (classe 1369): ogni combinazione ha UN esito, e (P) solo quando vale tutto
        stati = {"nonletta": dict(letta=False, giudica=False, c3g=45.0, nn=60, sp=300, righe=300, ce7=True),
                 "fra": dict(letta=True, giudica=True, c3g=39.9, nn=60, sp=300, righe=300, ce7=True),
                 "ok": dict(letta=True, giudica=True, c3g=40.0, nn=30, sp=100, righe=100, ce7=True),
                 "nn29": dict(letta=True, giudica=True, c3g=45.0, nn=29, sp=300, righe=300, ce7=True),
                 "sp99": dict(letta=True, giudica=True, c3g=45.0, nn=60, sp=99, righe=300, ce7=True),
                 "r99": dict(letta=True, giudica=False, c3g=30.0, nn=60, sp=99, righe=99, ce7=True),
                 "ce7": dict(letta=True, giudica=False, c3g=INF, nn=60, sp=150, righe=300, ce7=False)}
        cattivi = []
        for a_ in stati:
            for b_ in stati:
                for c_ in stati:
                    trs = {}
                    for t, s_ in zip(("T1", "T2", "T3"), (a_, b_, c_)):
                        v = stati[s_]
                        trs[t] = {"letta": v["letta"], "giudica": v["giudica"], "c3g": v["c3g"], "nn": v["nn"], "sp_pos": v["sp"], "A": {"n": v["righe"]},
                                  "ce7": (v["ce7"], "x"), "manca": [] if v["letta"] else ["finta"]}
                    e_ = esito_cella(trs, ["T1", "T2", "T3"], (True, ""))[0]
                    k_ = (a_, b_, c_)
                    att = "C" if "nonletta" in k_ else ("F" if "fra" in k_ else ("P" if set(k_) == {"ok"} else "N"))
                    if e_ != att:
                        cattivi.append((k_, e_, att))
        ck("matrice esaustiva 7^3 = 343 combinazioni di tranche: esito = (C) se una non letta, poi (F), poi (N), (P) solo con tutte 'ok'", not cattivi, str(cattivi[:3]))
        # main su file vero
        import contextlib
        buf = io.StringIO()
        with contextlib.redirect_stdout(buf):
            rc = main([rac, "--csv-out", os.path.join(td, "m.csv")])
        ck("main() sulla raccolta finta: uscita 0, stampa completa", rc == 0 and buf.getvalue().count("ESITO DELLA CELLA") == 3)
        with contextlib.redirect_stdout(io.StringIO()):
            rc = main([rac2])
        ck("main() su raccolta di un altro pin: uscita 2 (nessun numero)", rc == 2)
    finally:
        shutil.rmtree(td, ignore_errors=True)
    ck("i 4 file prova e il lettore NON sono stati toccati",
       all(hashlib.sha256(open(os.path.join(QD, "prove", D["prova"]), "rb").read()).hexdigest() == sha_prove[L] for L, D in LOTTI.items())
       and hashlib.sha256(open(os.path.join(QD, LG_FILE), "rb").read()).hexdigest() == sha_lg_0 == LG_SHA)
    print("AUTOTEST: %d OK, %d FAIL -> %s" % (ok_tot[0], ok_tot[1], "PASS" if ok_tot[1] == 0 else "FAIL"))
    return 0 if ok_tot[1] == 0 else 1


def main(argv):
    if "--autotest" in argv:
        return autotest()
    if "--costruisci-finto" in argv:
        i = argv.index("--costruisci-finto")
        if i + 1 >= len(argv):
            print("uso: --costruisci-finto OUT.zip")
            return 2
        raccolta_finta(argv[i + 1])
        print("zip FINTO scritto: %s (ancora = file VERI di R1A_01, indici SINTETICI: NESSUN NUMERO VALE)" % os.path.abspath(argv[i + 1]))
        return 0
    csv_out = "D2B_C3G_R2S_B.csv"
    args = []
    i = 0
    while i < len(argv):
        if argv[i] == "--csv-out" and i + 1 < len(argv):
            csv_out = argv[i + 1]
            i += 2
            continue
        args.append(argv[i])
        i += 1
    if not args:
        print(__doc__)
        return 2
    try:
        lotti, note, finto = carica(args)
    except Rifiuto as ex:
        print("ERRORE -- zip RIFIUTATO, nessun numero si stampa: %s" % ex)
        return 2
    acc_ok, acc_r, _res = accettazione()
    print(stampa(lotti, note, acc_ok, acc_r, finto, csv_out))
    print(" CSV: %s" % os.path.abspath(csv_out))
    return 0


if __name__ == "__main__":
    sys.exit(main(sys.argv[1:]))
