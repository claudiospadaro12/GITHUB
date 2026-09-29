# =====================================================================
#  MARCATORE_ANATOMIA_MOVIMENTI_M5_v1
#  anatomia_movimenti_m5.py -- FASE 1b: QUANTO RITRACCIA E QUANTO CORRE
#                              il prezzo dopo la rottura del range
#                              d'apertura (Nasdaq, DAX). 29/09/2026
# ---------------------------------------------------------------------
#  PERCHE' ESISTE (richiesta di Claudio, 29/09/2026)
#    "possiamo trovare parametri o creare due EA sul Nasdaq, uno sul
#     BREAKOUT e uno sul RETEST, sia long che short. Creiamo un agente
#     che analizzi i grafici a TF 5 min sul passato del Nasdaq e del DAX,
#     per vedere quali sono i movimenti medi, quanti punti ritracciano,
#     quanto corrono di solito, tutti i parametri che ci servono."
#    anatomia_aperture.py (FASE 1) descrive CLASSI del giorno (DRIVE/FADE/
#    RANGE/RIENTRO). NON misura quanto il prezzo ritraccia dopo la rottura
#    ne' quanto corre dopo il ritracciamento: e' esattamente quello che
#    serve per scegliere InpRetestOffsetPts, InpTP1_R, InpRangeMinutes,
#    InpBufferPoints, InpPendingExpiryMin. Questo strumento lo misura.
#
#  ###################################################################
#  #  QUELLO CHE QUESTO STRUMENTO **NON** FA:                        #
#  #  NON e' un motore. NON calcola PF, NON calcola un'EQUITY, NON   #
#  #  promuove niente. NON ha spread ne' costi ne' slippage. NON     #
#  #  tocca MT5 ne' un EA ne' un preset. Legge un CSV e conta.       #
#  #  UNA FREQUENZA NON E' UN EDGE: le "sequenze target/stop" qui    #
#  #  sono frequenze di ordine di tocco su barre M5, non risultati   #
#  #  di strategia.                                                  #
#  ###################################################################
#
#  DUE FASI, come anatomia_aperture.py
#    --addestramento (default Nasdaq 2010-2020, DAX 2010-2018): le IPOTESI
#    si scrivono SOLO qui. --cassaforte (Nasdaq 2021-2026; DAX: NESSUNA):
#    serve a VALIDARE ipotesi gia' congelate. Referti in FILE DISTINTI,
#    mai mescolati. I terzili dell'ampiezza si tarano SOLO sull'addestra-
#    mento e si APPLICANO alla cassaforte (la validazione non puo' ridefi-
#    nire le classi). Non esiste un referto "COMPLETO" apposta.
#
#  IL FUSO -- MISURATO, non assunto (il CSV e' ORA DI NEW YORK)
#    Nasdaq: apertura cash 09:30 NY, tutto l'anno.
#    DAX: apertura cash 09:00 CET = 03:00 NY per ~11 mesi su 12, ma nelle
#    settimane in cui il DST americano e' gia' cambiato e quello europeo
#    no (marzo, fine ottobre) CET = NY+5 e 09:00 CET = 04:00 NY. Lo
#    strumento DERIVA l'ipotesi dal calendario (regole DST), poi la
#    MISURA: picco dell'ampiezza media M1 per minuto-del-giorno, gruppo
#    per gruppo. Se il picco misurato NON coincide con l'ipotesi lo
#    dichiara (RILIEVO, codice 1) e usa la misura quando e' decisiva.
#
#  IL FEED E' HISTDATA, CON IL CANCELLO QUALITA' IN VERIFICA (dichiarato)
#    Giorni con copertura oraria anomala ESCLUSI e CONTATI a parte.
#    Il DAX (D30EUR) e' pulito solo 2010-2018 (referto 10/09): il file
#    contiene altri anni con un ALTRO strumento -> banda di prezzo di
#    guardia (--banda-prezzo) e periodo ristretto. USO firmato D-C =
#    SOLO_PROVA_REGIME: una descrizione non e' un'ipotesi di motore.
#
#  CONVENZIONI SULLE BARRE M5 (dichiarate, non nascoste)
#    - Le M5 si costruiscono dalle M1, esatte: O = open della prima M1,
#      C = close dell'ultima, H/L = estremi. Allineate all'apertura.
#    - Il range di N minuti = le prime N/5 barre M5 (N multiplo di 5).
#    - PRIMA ROTTURA = la prima barra M5 con offset >= N il cui estremo
#      tocca livello +/- buffer. Se UNA barra tocca tutti e due i lati:
#      AMBIGUA (non conta ne' long ne' short). Il "minuto" e' l'inizio
#      della barra (risoluzione 5 minuti).
#    - L'ORDINE DENTRO UNA BARRA M5 NON E' OSSERVABILE. Regola: la corsa
#      (MFE) conta anche la barra di rottura (il massimo viene dopo il
#      tocco); ritracciamento, escursione avversa e riempimento del limit
#      si guardano dalla barra SUCCESSIVA. Conseguenza dichiarata: un
#      ritracciamento dentro la stessa barra di rottura NON si vede (la
#      frequenza del retest e' una STIMA PER DIFETTO). Se una barra tocca
#      sia il bersaglio sia lo stop: lettera A (ambigua), mai T ne' S.
#    - Long = rottura in su, short = rottura in giu', SEMPRE separati;
#      lo short e' calcolato sui prezzi specchiati (p -> -p).
#    - R = ampiezza del range d'apertura (A). Bersagli e stop in R: stop =
#      bordo opposto -/+ buffer (come l'EA: sl = sellPx = RL - buffer).
#      Profondita' del retest: POSITIVA = dentro il livello rotto.
#
#  CODICI D'USCITA: 0 = misurato, nessun rilievo; 1 = misurato CON
#  RILIEVI (gli artefatti ci sono e vanno mandati); 2 = NON partito.
#  Numeri sempre col PUNTO decimale (float()/"%.*f", niente locale).
# =====================================================================

import argparse
import os
import sys
import tempfile
from datetime import date, timedelta

_QUI = os.path.dirname(os.path.abspath(__file__))
if _QUI not in sys.path:
    sys.path.insert(0, _QUI)
try:
    import anatomia_aperture as AA
except ImportError as _e:                      # pragma: no cover
    sys.stdout.write("!!! MANCA anatomia_aperture.py accanto a questo file (%s).\n" % _e)
    sys.exit(2)

VERSIONE = "ANATOMIA_MOVIMENTI_M5_v1"
QS = [0.10, 0.25, 0.50, 0.75, 0.90]
NOMI_GIORNI = ["lun", "mar", "mer", "gio", "ven", "sab", "dom"]
ORIZZONTI_MFE = [15, 30, 60, 120, 240]          # minuti; piu' 'F' = fine seduta
FALSO_FINESTRE = [15, 30]
GRIGLIA_PROF = [-0.5, -0.25, 0.0, 0.25, 0.5, 0.75, 1.0]   # in R, positivo = dentro
SOGLIA_N = 30                                   # sotto: la cella e' marcata *

log = AA.log


# ---------------------------------------------------------------------
#  CALENDARIO DEL FUSO (regole DST, per DERIVARE l'ipotesi d'apertura)
# ---------------------------------------------------------------------
def _domenica(anno, mese, n):
    """n-esima domenica del mese (n=1..), oppure l'ultima se n=-1."""
    if n > 0:
        d = date(anno, mese, 1)
        while d.weekday() != 6:
            d += timedelta(days=1)
        return d + timedelta(days=7 * (n - 1))
    if mese == 12:
        d = date(anno, 12, 31)
    else:
        d = date(anno, mese + 1, 1) - timedelta(days=1)
    while d.weekday() != 6:
        d -= timedelta(days=1)
    return d


def us_dst(dt):
    return _domenica(dt.year, 3, 2) <= dt < _domenica(dt.year, 11, 1)


def eu_dst(dt):
    return _domenica(dt.year, 3, -1) <= dt < _domenica(dt.year, 10, -1)


def gruppo_nasdaq(dt):
    return "NY-FISSO", 9 * 60 + 30


def gruppo_dax(dt):
    """09:00 CET nell'ora di New York del file. CET-NY = 6 ore, ma 5 nelle
    settimane in cui il DST americano e' partito e quello europeo no."""
    diff = 6 + (1 if eu_dst(dt) else 0) - (1 if us_dst(dt) else 0)
    return "CET-NY=%d" % diff, 9 * 60 - diff * 60


MERCATI = {
    "NASDAQ": {"gruppo": gruppo_nasdaq, "durata": 390, "banda": None,
               "is": "2010-2020", "cs": "2021-2026",
               "desc": "apertura cash Nasdaq 09:30 New York"},
    "DAX": {"gruppo": gruppo_dax, "durata": 510, "banda": (4500.0, 14500.0),
            "is": "2010-2018", "cs": "",
            "desc": "apertura cash DAX 09:00 CET (03:00/04:00 New York)"},
}


# ---------------------------------------------------------------------
#  CONFIGURAZIONE
# ---------------------------------------------------------------------
def _lista_int(testo, nome):
    out = []
    for p in str(testo).split(","):
        p = p.strip()
        if p:
            out.append(int(p))
    return out


def _lista_float(testo):
    out = []
    for p in str(testo).split(","):
        p = p.strip()
        if p:
            out.append(float(p))
    return out


def parse_periodo(testo, nome):
    t = (testo or "").strip()
    if t == "" or t.lower() in ("nessuna", "nessuno", "no", "-"):
        return None
    pezzi = t.split("-")
    if len(pezzi) != 2 or not pezzi[0].isdigit() or not pezzi[1].isdigit():
        raise ValueError("%s: periodo non valido '%s' (atteso AAAA-AAAA)" % (nome, testo))
    a, b = int(pezzi[0]), int(pezzi[1])
    if a > b:
        raise ValueError("%s: anno iniziale > finale ('%s')" % (nome, testo))
    return (a, b)


class Config(object):
    def __init__(self, a):
        self.mercato = a.mercato
        prof = MERCATI[self.mercato]
        self.gruppo_fn = prof["gruppo"]
        self.durata = int(a.durata_seduta) if a.durata_seduta else prof["durata"]
        self.banda = prof["banda"]
        if str(a.banda_prezzo).strip().lower() == "nessuna":
            self.banda = None
        elif a.banda_prezzo:
            lo, hi = a.banda_prezzo.split(",")
            self.banda = (float(lo), float(hi))
        self.ranges = sorted(set(_lista_int(a.ranges, "--ranges")))
        self.scadenze = sorted(set(_lista_int(a.scadenze, "--scadenze")))
        self.scad_ref = int(a.scadenza_ref)
        self.offsets = sorted(set(_lista_float(a.offset_retest)))
        self.bersagli = sorted(set(_lista_float(a.bersagli)))
        self.buffer = float(a.buffer_punti)
        self.min_giorni_anno = int(a.min_giorni_anno)
        self.min_barre_ora = int(a.min_barre_ora)
        self.max_buco_min = int(a.max_buco_min)
        self.min_cop = float(a.min_cop_sessione)
        self.min_giorni_calibra = int(a.min_giorni_calibra)
        self.fin_calibra = int(a.finestra_calibrazione)
        self.calibra = not a.senza_calibrazione
        self.quota_sospetti = float(a.quota_sospetti)
        self.problemi = []
        self.per_is = None
        self.per_cs = None
        try:
            self.per_is = parse_periodo(a.addestramento if a.addestramento is not None
                                        else prof["is"], "--addestramento")
            self.per_cs = parse_periodo(a.cassaforte if a.cassaforte is not None
                                        else prof["cs"], "--cassaforte")
        except ValueError as e:
            self.problemi.append(str(e))
        if self.per_is is None and self.per_cs is None:
            self.problemi.append("nessun periodo: serve almeno --addestramento")
        if self.per_is and self.per_cs and self.per_cs[0] <= self.per_is[1]:
            self.problemi.append("la cassaforte %d-%d si sovrappone all'addestramento %d-%d: "
                                 "la validazione non puo' toccare l'addestramento"
                                 % (self.per_cs[0], self.per_cs[1], self.per_is[0], self.per_is[1]))
        if self.per_is is None and self.per_cs is not None:
            self.problemi.append("cassaforte senza addestramento: i terzili non hanno da dove nascere")
        if not self.ranges or any(n < 5 or n % 5 for n in self.ranges):
            self.problemi.append("--ranges: multipli di 5 minuti, >= 5")
        if any(n // 5 * 5 >= self.durata for n in self.ranges):
            self.problemi.append("--ranges: un range non puo' coprire tutta la seduta")
        if not self.scadenze or any(s < 5 or s % 5 for s in self.scadenze):
            self.problemi.append("--scadenze: multipli di 5 minuti")
        if self.scad_ref not in self.scadenze:
            self.problemi.append("--scadenza-ref %d non e' fra --scadenze" % self.scad_ref)
        if any(o < 0 or o >= 1 for o in self.offsets):
            self.problemi.append("--offset-retest: valori in [0,1) (in R, positivo = dentro il livello)")
        if any(t <= 0 for t in self.bersagli):
            self.problemi.append("--bersagli: valori positivi (in R)")
        if self.durata % 5 or self.durata < 60:
            self.problemi.append("--durata-seduta: multiplo di 5, >= 60")
        if self.buffer < 0:
            self.problemi.append("--buffer-punti negativo")
        self.K = self.durata // 5

    def fase_di(self, anno):
        if self.per_is and self.per_is[0] <= anno <= self.per_is[1]:
            return "IS"
        if self.per_cs and self.per_cs[0] <= anno <= self.per_cs[1]:
            return "CASSAFORTE"
        return "FUORI"


# ---------------------------------------------------------------------
#  M1 -> M5 (aggregazione esatta, allineata all'apertura)
# ---------------------------------------------------------------------
def m5_da_m1(m1, K):
    """m1: dict offset(minuti dall'apertura) -> (o,h,l,c). Torna una lista
    di K elementi (o,h,l,c,n) oppure None se la barra M5 non ha nessuna M1."""
    out = []
    for k in range(K):
        offs = [o for o in range(5 * k, 5 * k + 5) if o in m1]
        if not offs:
            out.append(None)
            continue
        offs.sort()
        o = m1[offs[0]][0]
        c = m1[offs[-1]][3]
        h = max(m1[x][1] for x in offs)
        l = min(m1[x][2] for x in offs)
        out.append((o, h, l, c, len(offs)))
    return out


# ---------------------------------------------------------------------
#  LA MISURA DI UN GIORNO PER UN RANGE
# ---------------------------------------------------------------------
def _sequenza(mb, j0, K, T, S, primo_speciale):
    """Primo tocco fra bersaglio T e stop S, da j0 in poi. 'T','S','A','N'.
    primo_speciale: nella barra j0 (barra di rottura o di riempimento) un
    tocco dello STOP e' ambiguo (puo' precedere l'ingresso)."""
    for j in range(j0, K):
        b = mb[j]
        if b is None:
            continue
        t_hit = b[0] >= T
        s_hit = b[1] <= S
        if t_hit and s_hit:
            return "A"
        if s_hit:
            return "A" if (primo_speciale and j == j0) else "S"
        if t_hit:
            return "T"
    return "N"


def analizza_range(cfg, m5, N, px):
    """Torna un dict evento per il range di N minuti (vedi convenzioni)."""
    K = cfg.K
    nb = N // 5
    ev = {"N": N}
    barre_range = m5[:nb]
    if any(b is None for b in barre_range):
        ev["lato_txt"] = "MANCANTE"
        return ev
    RH = max(b[1] for b in barre_range)
    RL = min(b[2] for b in barre_range)
    A = RH - RL
    ev["A"] = A
    ev["px"] = px
    ev["amp_pct"] = 100.0 * A / px if px else None
    ev["RH"] = RH
    ev["RL"] = RL
    if A <= 0:
        ev["lato_txt"] = "PIATTO"
        return ev
    buf = cfg.buffer
    kb = None
    lato = 0
    for k in range(nb, K):
        b = m5[k]
        if b is None:
            continue
        up = b[1] >= RH + buf
        dn = b[2] <= RL - buf
        if up and dn:
            ev["lato_txt"] = "AMBIGUA"
            ev["min_rott"] = k * 5
            return ev
        if up or dn:
            kb = k
            lato = 1 if up else -1
            break
    if kb is None:
        ev["lato_txt"] = "NESSUNA"
        return ev
    ev["lato"] = lato
    ev["lato_txt"] = "LONG" if lato == 1 else "SHORT"
    ev["min_rott"] = kb * 5
    # ---- l'altro lato, dopo (2LATI): registrato, MAI contato come "prima"
    ev["lato2_txt"] = ""
    ev["min2"] = None
    for k in range(kb + 1, K):
        b = m5[k]
        if b is None:
            continue
        if (lato == 1 and b[2] <= RL - buf) or (lato == -1 and b[1] >= RH + buf):
            ev["lato2_txt"] = "SHORT" if lato == 1 else "LONG"
            ev["min2"] = k * 5
            break
    # ---- serie specchiata: "su" e' sempre il verso favorevole
    mb = []
    for k in range(K):
        b = m5[k]
        if b is None or k < kb:
            mb.append(None)
        elif lato == 1:
            mb.append((b[1], b[2], b[3]))
        else:
            mb.append((-b[2], -b[1], -b[3]))
    if lato == 1:
        level = RH
        S = RL - buf
    else:
        level = -RL
        S = -(RH + buf)
    E = level + buf
    ev["chiude_dentro"] = mb[kb][2] <= level

    def max_hi(da, a):
        v = [mb[k][0] for k in range(da, min(a, K)) if mb[k] is not None]
        return max(v) if v else None

    def min_lo(da, a):
        v = [mb[k][1] for k in range(da, min(a, K)) if mb[k] is not None]
        return min(v) if v else None

    def min_cl(da, a):
        v = [mb[k][2] for k in range(da, min(a, K)) if mb[k] is not None]
        return min(v) if v else None

    def orizzonte_pieno(h):
        return kb * 5 + h <= K * 5

    # ---- BREAKOUT: corsa massima (la barra di rottura CONTA)
    ev["mfe"] = {}
    for h in ORIZZONTI_MFE:
        if orizzonte_pieno(h):
            m = max_hi(kb, kb + h // 5)
            ev["mfe"][h] = (m - E) if m is not None else None
        else:
            ev["mfe"][h] = None
    m = max_hi(kb, K)
    ev["mfe"]["F"] = (m - E) if m is not None else None
    # ---- escursione avversa prima di +1R (barra bersaglio inclusa: conservativo)
    T1 = E + 1.0 * A
    kt = None
    for k in range(kb, K):
        if mb[k] is not None and mb[k][0] >= T1:
            kt = k
            break
    ev["raggiunge1R"] = kt is not None
    if kt is None:
        ev["mae1"] = None
    else:
        lo = min_lo(kb + 1, kt + 1)
        ev["mae1"] = max(0.0, E - lo) if lo is not None else 0.0
    # ---- falso breakout (chiusura di ritorno dentro il livello)
    ev["falso"] = {}
    ev["falso_prof"] = {}
    for w in FALSO_FINESTRE:
        if orizzonte_pieno(w):
            mc = min_cl(kb, kb + w // 5)
            fal = (mc is not None and mc <= level)
            ev["falso"][w] = fal
            ev["falso_prof"][w] = (level - mc) if fal else None
        else:
            ev["falso"][w] = None
            ev["falso_prof"][w] = None
    # ---- sequenze del breakout (ingresso E, stop S)
    ev["seq"] = {}
    for t in cfg.bersagli:
        ev["seq"][t] = _sequenza(mb, kb, K, E + t * A, S, True)
    # ---- RETEST: profondita' del minimo dopo la rottura (positiva = dentro)
    ev["prof"] = {}
    for h in cfg.scadenze:
        if orizzonte_pieno(h):
            lo = min_lo(kb + 1, kb + h // 5)
            ev["prof"][h] = (level - lo) if lo is not None else None
        else:
            ev["prof"][h] = None
    lo = min_lo(kb + 1, K)
    ev["prof"]["F"] = (level - lo) if lo is not None else None
    # ---- RETEST: riempimento di un limit a livello - o*A, e cosa succede dopo
    ev["ref_pieno"] = orizzonte_pieno(cfg.scad_ref)
    ev["fill"] = {}
    for o in cfg.offsets:
        Fp = level - o * A
        kf = None
        for k in range(kb + 1, K):
            if mb[k] is not None and mb[k][1] <= Fp:
                kf = k
                break
        d = {"min": None, "seq": {}, "mfe": None}
        if kf is not None:
            d["min"] = (kf - kb) * 5
            if mb[kf][1] <= S:
                for t in cfg.bersagli:
                    d["seq"][t] = "A"
            else:
                for t in cfg.bersagli:
                    d["seq"][t] = _sequenza(mb, kf + 1, K, Fp + t * A, S, False)
                mh = None
                fermato = False
                for k in range(kf + 1, K):
                    if mb[k] is None:
                        continue
                    if mb[k][1] <= S:
                        fermato = True
                        break
                    if mh is None or mb[k][0] > mh:
                        mh = mb[k][0]
                if mh is not None:
                    d["mfe"] = max(0.0, mh - Fp)
                elif fermato:
                    d["mfe"] = 0.0      # stoppato alla prima barra utile: corsa nulla, NON dato mancante
        ev["fill"][o] = d
    return ev


def analizza_giorno(cfg, g):
    """g: dict con data, dt, grp, open_mm, m1 (offset->(o,h,l,c)),
    chiusura_prec (o None). Torna la riga del giorno."""
    d = g["dt"]
    r = {"data": g["data"], "anno": d.year, "mese": d.month,
         "dow": NOMI_GIORNI[d.weekday()], "fase": cfg.fase_di(d.year),
         "gruppo": g["grp"], "open_mm": g["open_mm"], "ev": {}, "motivo": ""}
    m1 = g["m1"]
    offs = sorted(m1.keys())
    ora = [o for o in offs if o < 60]
    r["barre_ora"] = len(ora)
    buco = 0
    for a, b in zip(ora, ora[1:]):
        buco = max(buco, b - a)
    r["buco_max"] = buco
    r["cop_sess"] = len(offs) / float(cfg.durata)
    motivi = []
    px = None
    if 0 in m1:
        px = m1[0][0]
    else:
        prim = [o for o in offs if 0 <= o < 5]
        if prim:
            px = m1[prim[0]][0]
            motivi.append("apertura non osservata (prima barra a +%d min)" % prim[0])
    if px is None or px <= 0:
        r["stato"] = "SENZA_APERTURA"
        r["motivo"] = "nessuna barra nei primi 5 minuti dell'apertura"
        return r
    r["px"] = px
    if len(ora) < cfg.min_barre_ora:
        motivi.append("copertura oraria %d barre su 60 attese" % len(ora))
    if buco > cfg.max_buco_min:
        motivi.append("buco di %d minuti nella prima ora" % buco)
    if r["cop_sess"] < cfg.min_cop:
        motivi.append("copertura di seduta %.0f%% sotto %.0f%%" %
                      (100 * r["cop_sess"], 100 * cfg.min_cop))
    if cfg.banda and not (cfg.banda[0] <= px <= cfg.banda[1]):
        motivi.append("prezzo %.2f fuori dalla banda di guardia %.0f-%.0f" %
                      (px, cfg.banda[0], cfg.banda[1]))
    r["stato"] = "SOSPETTO" if motivi else "OK"
    r["motivo"] = " - ".join(motivi)
    prec = g.get("chiusura_prec")
    if prec is not None and prec > 0:
        r["gap_pct"] = 100.0 * (px - prec) / prec
        r["gap_pt"] = px - prec
    else:
        r["gap_pct"] = None
        r["gap_pt"] = None
    m5 = m5_da_m1(m1, cfg.K)
    vivi = [b for b in m5 if b is not None]
    if vivi:
        r["hl_pt"] = max(b[1] for b in vivi) - min(b[2] for b in vivi)
        r["oc_pt"] = vivi[-1][3] - px
        pri = [b[1] - b[2] for b in m5[:12] if b is not None]
        res = [b[1] - b[2] for b in m5[12:] if b is not None]
        r["atr_pri"] = sum(pri) / len(pri) if pri else None
        r["atr_res"] = sum(res) / len(res) if res else None
    if r["stato"] == "OK":
        for N in cfg.ranges:
            r["ev"][N] = analizza_range(cfg, m5, N, px)
    return r
# =====================================================================
#  LETTURA DEL CSV IN STREAMING (RAM = un giorno) + CALIBRAZIONE
# =====================================================================
def _stampa_riga(riga):
    """(anno,mese,giorno,mdg,o,h,l,c) oppure None. Parsing per posizione."""
    if len(riga) < 17 or riga[0] == "T":
        return None
    try:
        anno = int(riga[0:4])
        mese = int(riga[5:7])
        gio = int(riga[8:10])
        ore = int(riga[11:13])
        minu = int(riga[14:16])
    except ValueError:
        return None
    if riga[4] != "." or riga[7] != "." or riga[13] != ":":
        return None
    return anno, mese, gio, ore * 60 + minu


def calibra_apertura(cfg, percorso):
    """PRIMA PASSATA: per ogni gruppo di fuso, l'ampiezza M1 media (in %)
    per minuto-del-giorno nella finestra attesa+/-fin_calibra; il picco
    e' l'apertura MISURATA. Torna (esito_per_gruppo, righe_testo, rilievi)."""
    acc = {}          # grp -> {mdg: [somma, n]}
    attese = {}       # grp -> minuto atteso
    giorni = {}       # grp -> set di date
    cache = {}
    w = cfg.fin_calibra
    prev_data = ""
    prev_mdg = -9999
    with open(percorso, "r", encoding="ascii", errors="replace") as fh:
        for riga in fh:
            p = _stampa_riga(riga)
            if p is None:
                continue
            anno, mese, gio, mdg = p
            testo_data = riga[0:10]
            dopo_buco = (prev_data != testo_data) or (mdg - prev_mdg >= 15)
            prev_data = testo_data
            prev_mdg = mdg
            gr = cache.get(testo_data)
            if gr is None:
                try:
                    dt = date(anno, mese, gio)
                except ValueError:
                    cache[testo_data] = ("", -1, -1)
                    continue
                if dt.weekday() >= 5 or cfg.fase_di(anno) == "FUORI":
                    gr = ("", -1, -1)
                else:
                    gname, att = cfg.gruppo_fn(dt)
                    gr = (gname, att, dt.toordinal())
                if len(cache) > 20:
                    cache.clear()
                cache[testo_data] = gr
            if gr[0] == "":
                continue
            gname, att = gr[0], gr[1]
            if not (att - w <= mdg <= att + w):
                continue
            if dopo_buco:
                continue        # il primo minuto dopo un buco e' il salto del feed, non l'apertura
            campi = riga.rstrip("\r\n").split(",")
            if len(campi) < 5:
                continue
            try:
                h = float(campi[2])
                l = float(campi[3])
                c = float(campi[4])
            except ValueError:
                continue
            if c <= 0 or h < l:
                continue
            attese[gname] = att
            acc.setdefault(gname, {})
            s = acc[gname].setdefault(mdg, [0.0, 0])
            s[0] += 100.0 * (h - l) / c
            s[1] += 1
            giorni.setdefault(gname, set()).add(testo_data)
    esito = {}
    righe = []
    rilievi = []
    righe.append("CALIBRAZIONE DELL'ORA D'APERTURA -- ipotesi dal calendario, poi MISURA")
    righe.append("  Misura: ampiezza media (H-L)/C in % di ogni minuto-del-giorno, giorni")
    righe.append("  feriali, entro +/-%d minuti dall'ipotesi; il picco su minuti multipli di 5" % w)
    righe.append("  e' l'apertura MISURATA (il primo minuto dopo un buco >= 15 min non conta: e' il salto")
    righe.append("  del feed). Decisiva se >= 1,5 volte la mediana della finestra e con >= %d giorni;" % cfg.min_giorni_calibra)
    righe.append("  usata solo se a <= 60 minuti dall'ipotesi, altrimenti si tiene l'ipotesi e si dichiara.")
    for gname in sorted(acc.keys()):
        att = attese[gname]
        medie = {}
        for mm, (s, n) in acc[gname].items():
            if n > 0:
                medie[mm] = s / n
        cand = [mm for mm in medie if mm % 5 == 0]
        ngg = len(giorni.get(gname, ()))
        info = {"attesa": att, "giorni": ngg, "misurata": None, "usata": att,
                "stato": "NON_DECISIVA"}
        if cand:
            vals = sorted(medie.values())
            mediana = AA.mediana(vals)
            picco = max(sorted(cand), key=lambda x: (medie[x], -x))
            sep = (medie[picco] / mediana) if mediana and mediana > 0 else 0.0
            ordinati = sorted(cand, key=lambda x: (-medie[x], x))[:3]
            info["misurata"] = picco
            info["sep"] = sep
            info["top3"] = [(x, medie[x]) for x in ordinati]
            if ngg >= cfg.min_giorni_calibra and sep >= 1.5:
                if picco == att:
                    info["stato"] = "CONFERMATA"
                elif abs(picco - att) <= 60:
                    info["stato"] = "SMENTITA"
                    info["usata"] = picco
                else:
                    info["stato"] = "NON_COERENTE"     # picco lontano: si tiene l'ipotesi, si dichiara
        esito[gname] = info
        righe.append("  gruppo %-10s giorni %5d  attesa %s  misurata %s  ->  %s" %
                     (gname, ngg, AA.hhmm(att),
                      AA.hhmm(info["misurata"]) if info["misurata"] is not None else "n/d",
                      info["stato"]))
        if info.get("top3"):
            righe.append("      primi tre minuti: " + "  ".join(
                "%s(%.4f%%)" % (AA.hhmm(x), v) for x, v in info["top3"]) +
                "   separazione dalla mediana x%.2f" % info.get("sep", 0.0))
        if info["stato"] == "SMENTITA":
            rilievi.append("apertura del gruppo %s MISURATA %s contro %s attesa: si usa la MISURA, "
                           "lo studio va letto con cautela" %
                           (gname, AA.hhmm(info["misurata"]), AA.hhmm(att)))
        elif info["stato"] == "NON_COERENTE":
            rilievi.append("apertura del gruppo %s: picco misurato %s a piu' di 60 minuti dall'ipotesi %s: "
                           "misura non credibile, si usa l'ipotesi del calendario" %
                           (gname, AA.hhmm(info["misurata"]), AA.hhmm(att)))
        elif info["stato"] == "NON_DECISIVA":
            rilievi.append("calibrazione NON DECISIVA per il gruppo %s (giorni %d, separazione "
                           "%.2f): si usa l'ipotesi del calendario %s" %
                           (gname, ngg, info.get("sep", 0.0), AA.hhmm(att)))
    if not acc:
        rilievi.append("calibrazione impossibile: nessun minuto letto nelle finestre attese")
        righe.append("  NESSUN DATO nelle finestre attese.")
    return esito, righe, rilievi


def scandisci(cfg, percorso, aperture, ogni=1000000):
    """Una passata. RAM: gli aggregati di UN giorno. aperture: grp -> minuto
    d'apertura da usare. Torna (righe_giorno, diag)."""
    diag = {"righe": 0, "barre": 0, "scartate": 0, "fuori_ordine": 0,
            "date_ripetute": 0, "giorni": 0, "prima": "", "ultima": "",
            "gap_sessione": {}, "apertura_sett": {}, "fuori_periodo": 0}
    out = []
    corr = None
    viste = set()
    ultima_chiusura = None
    prec_stamp = ""
    ultimo_ord = None
    ultimo_mdg = None

    def chiudi(g):
        if g is None:
            return
        diag["giorni"] += 1
        if g["n_barre"] >= 500 and g["buco_inizio"] is not None and g["buco_max"] >= 30:
            diag["gap_sessione"].setdefault((g["dt"].year, g["dt"].month), []).append(g["buco_inizio"])
        if g["dt"].weekday() >= 5:
            return
        if cfg.fase_di(g["dt"].year) == "FUORI":
            diag["fuori_periodo"] += 1
            return
        g["chiusura_prec"] = g["ch_prec"]
        out.append(analizza_giorno(cfg, g))

    with open(percorso, "r", encoding="ascii", errors="replace") as fh:
        for riga in fh:
            diag["righe"] += 1
            if ogni and diag["righe"] % ogni == 0:
                log("    ... %d milioni di righe lette" % (diag["righe"] // 1000000))
            p = _stampa_riga(riga)
            if p is None:
                if len(riga) >= 17 and riga[0] != "T":
                    diag["scartate"] += 1
                continue
            anno, mese, gio, mdg = p
            stamp = riga[0:16]
            if stamp < prec_stamp:
                diag["fuori_ordine"] += 1
            prec_stamp = stamp
            testo_data = riga[0:10]
            if corr is None or corr["data"] != testo_data:
                if corr is not None:
                    chiudi(corr)
                    if corr["ch_close"] is not None:
                        ultima_chiusura = corr["ch_close"]
                if testo_data in viste:
                    diag["date_ripetute"] += 1
                viste.add(testo_data)
                try:
                    dt = date(anno, mese, gio)
                except ValueError:
                    diag["scartate"] += 1
                    corr = None
                    continue
                gname, att = cfg.gruppo_fn(dt)
                om = aperture.get(gname, att)
                corr = {"data": testo_data, "dt": dt, "grp": gname, "open_mm": om,
                        "m1": {}, "n_barre": 0, "prec_min": None, "buco_max": 0,
                        "buco_inizio": None, "ch_prec": ultima_chiusura,
                        "ch_close": None, "ch_off": -1, "ord": dt.toordinal()}
                if not diag["prima"]:
                    diag["prima"] = stamp
            diag["barre"] += 1
            diag["ultima"] = stamp
            if ultimo_ord is not None:
                salto = (corr["ord"] - ultimo_ord) * 1440 + (mdg - ultimo_mdg)
                if salto >= 720:
                    diag["apertura_sett"].setdefault((corr["dt"].year, corr["dt"].month), []).append(mdg)
            ultimo_ord = corr["ord"]
            ultimo_mdg = mdg
            corr["n_barre"] += 1
            if corr["prec_min"] is not None:
                s = mdg - corr["prec_min"]
                if s > corr["buco_max"]:
                    corr["buco_max"] = s
                    corr["buco_inizio"] = corr["prec_min"]
            corr["prec_min"] = mdg
            off = mdg - corr["open_mm"]
            if not (0 <= off < cfg.durata):
                continue
            campi = riga.rstrip("\r\n").split(",")
            if len(campi) < 5:
                diag["scartate"] += 1
                continue
            try:
                po = float(campi[1])
                ph = float(campi[2])
                pl = float(campi[3])
                pc = float(campi[4])
            except ValueError:
                diag["scartate"] += 1
                continue
            if po <= 0 or ph <= 0 or pl <= 0 or pc <= 0 or ph < pl:
                diag["scartate"] += 1
                continue
            if off in corr["m1"]:
                diag["duplicate"] = diag.get("duplicate", 0) + 1
                continue
            corr["m1"][off] = (po, ph, pl, pc)
            if off >= corr["ch_off"]:
                corr["ch_off"] = off
                corr["ch_close"] = pc
    if corr is not None:
        chiudi(corr)
    return out, diag
# =====================================================================
#  AGGREGAZIONE E REFERTO
# =====================================================================
def conv(pt, e, unit):
    if pt is None:
        return None
    if unit == "pt":
        return pt
    if unit == "R":
        return pt / e["A"]
    return 100.0 * pt / e["px"]


def qv(vals):
    v = [x for x in vals if x is not None]
    return [AA.quantile(v, q) for q in QS] if v else [None] * len(QS)


def P(k, n):
    return AA.pct(k, n, 1)


def riga_q(etich, vals, cifre):
    v = [x for x in vals if x is not None]
    if not v:
        return "  %-24s n=%5d   n/d" % (etich, 0)
    qs = qv(v)
    return "  %-24s n=%5d%s  %s" % (etich, len(v), "*" if len(v) < SOGLIA_N else " ",
                                    " ".join("%9s" % AA.f(x, cifre) for x in qs))


def intest_q():
    return "  %-24s %7s   %s" % ("", "", " ".join("%9s" % ("q%d" % round(100 * q)) for q in QS))


def tab_q(out, titolo, voci, evs, unita=(("pt", "punti", 1), ("R", "multipli di R", 2), ("pct", "% del prezzo", 3))):
    """voci = [(etichetta, getter)]: getter(ev)->pt|None. Stampa il blocco
    per ognuna delle tre unita'."""
    out.append(titolo)
    for u, nome_u, cifre in unita:
        out.append("  [%s]" % nome_u)
        out.append(intest_q())
        for etich, gt in voci:
            out.append(riga_q(etich, [conv(gt(e), e, u) for e in evs], cifre))
    out.append("")


def fmt_pc(k, n):
    return "%s(%d)" % (P(k, n), n)


def mediana_str(vals, cifre):
    v = [x for x in vals if x is not None]
    if not v:
        return "n/d"
    return AA.f(AA.mediana(v), cifre) + ("*" if len(v) < SOGLIA_N else "")


def colonne_cond(cfg, evs):
    """Le otto colonne compatte delle tabelle condizionate."""
    n = len(evs)
    ref = cfg.scad_ref
    f15 = [e["falso"][15] for e in evs if e["falso"].get(15) is not None]
    mfeF = [conv(e["mfe"]["F"], e, "R") for e in evs]
    mfe240 = [conv(e["mfe"][240], e, "R") for e in evs]
    pr = [conv(e["prof"][ref], e, "R") for e in evs]
    fil = [e for e in evs if e["ref_pieno"] and 0.0 in e["fill"]]
    fil0 = len([e for e in fil if e["fill"][0.0]["min"] is not None and e["fill"][0.0]["min"] < ref])
    t1 = 1.0 if 1.0 in cfg.bersagli else cfg.bersagli[0]
    seq = [e["seq"][t1] for e in evs]
    return [str(n) + ("*" if n < SOGLIA_N else ""),
            P(len([x for x in f15 if x]), len(f15)),
            mediana_str(mfe240, 2), mediana_str(mfeF, 2), mediana_str(pr, 2),
            P(fil0, len(fil)),
            P(len([s for s in seq if s == "T"]), len(seq)),
            P(len([s for s in seq if s == "S"]), len(seq))]


def intest_cond(cfg):
    t1 = 1.0 if 1.0 in cfg.bersagli else cfg.bersagli[0]
    return ("  %-22s %7s %8s %9s %9s %9s %9s %9s %9s" %
            ("", "n", "falso15%", "MFE240R", "MFEfineR", "ritr%dR" % cfg.scad_ref,
             "retest0%", "T+%gR%%" % t1, "S<T%"))


def riga_cond(cfg, etich, evs, extra=""):
    c = colonne_cond(cfg, evs)
    return "  %-22s %7s %8s %9s %9s %9s %9s %9s %9s%s" % (etich, c[0], c[1], c[2], c[3], c[4], c[5], c[6], c[7], extra)


def taglio(vals, tagli):
    """terzile 0/1/2 da due soglie."""
    if vals is None or tagli is None:
        return None
    if vals <= tagli[0]:
        return 0
    if vals <= tagli[1]:
        return 1
    return 2


def calcola_tagli(cfg, righe_is):
    """Terzili dell'ampiezza % per range, SOLO dai giorni buoni
    dell'addestramento. Torna {N: (t1,t2)|None}."""
    out = {}
    for N in cfg.ranges:
        v = []
        for r in righe_is:
            e = r["ev"].get(N)
            if e and e.get("amp_pct") is not None and e["lato_txt"] not in ("MANCANTE", "PIATTO"):
                v.append(e["amp_pct"])
        out[N] = (AA.quantile(v, 1.0 / 3), AA.quantile(v, 2.0 / 3)) if len(v) >= 30 else None
    return out


def blocco_lato(cfg, out, evs, lato_nome, N):
    """Blocco BREAKOUT + RETEST per un lato (evs = eventi PRIMA ROTTURA)."""
    out.append("  ---- %s, range %d minuti: %d prime rotture ----" % (lato_nome, N, len(evs)))
    if not evs:
        out.append("  nessun evento.")
        out.append("")
        return
    ref = cfg.scad_ref
    rot = [e["min_rott"] for e in evs]
    out.append("  minuto della rottura (dall'apertura): q10/25/50/75/90 = " +
               " / ".join(AA.f(x, 0) for x in qv(rot)))
    out.append("  la barra di rottura chiude DENTRO il livello: %s%% (n=%d)" %
               (P(len([e for e in evs if e["chiude_dentro"]]), len(evs)), len(evs)))
    due = [e for e in evs if e["lato2_txt"]]
    out.append("  l'altro lato rompe DOPO (2LATI): %s%% (n=%d); minuto mediano dell'altra rottura %s" %
               (P(len(due), len(evs)), len(evs),
                AA.f(AA.mediana([e["min2"] for e in due]), 0) if due else "n/d"))
    out.append("")
    out.append("  == BREAKOUT: quanto corre dopo la rottura (MFE dal livello+buffer, barra di rottura inclusa) ==")
    voci = [("MFE %d min" % h, (lambda e, h=h: e["mfe"][h])) for h in ORIZZONTI_MFE]
    voci.append(("MFE fine seduta", lambda e: e["mfe"]["F"]))
    tab_q(out, "  (solo eventi con orizzonte completo dentro la seduta: n per riga)", voci, evs)
    out.append("  escursione avversa MASSIMA prima di toccare +1R (solo eventi che toccano +1R):")
    rg = [e for e in evs if e["raggiunge1R"]]
    out.append("  tocca +1R: %s%% (n=%d)" % (P(len(rg), len(evs)), len(evs)))
    tab_q(out, "", [("MAE prima di +1R", lambda e: e["mae1"])], rg)
    out.append("  falso breakout (una CHIUSURA M5 torna dentro il livello, barra di rottura inclusa):")
    for w in FALSO_FINESTRE:
        va = [e for e in evs if e["falso"].get(w) is not None]
        fa = [e for e in va if e["falso"][w]]
        out.append("    entro %2d min: %s%% (n=%d)" % (w, P(len(fa), len(va)), len(va)))
    tab_q(out, "  di quanto rientra (profondita' della chiusura sotto il livello, solo i falsi):",
          [("falso entro %d min" % w, (lambda e, w=w: e["falso_prof"][w])) for w in FALSO_FINESTRE], evs)
    out.append("  sequenza target/stop (ingresso al livello+buffer, stop bordo opposto; A = stessa barra):")
    out.append("  %-10s %8s %8s %8s %8s   n" % ("bersaglio", "T%", "S%", "A%", "N%"))
    for t in cfg.bersagli:
        sq = [e["seq"][t] for e in evs]
        out.append("  +%-9s %8s %8s %8s %8s   %d" % ("%gR" % t, P(sq.count("T"), len(sq)), P(sq.count("S"), len(sq)),
                                                   P(sq.count("A"), len(sq)), P(sq.count("N"), len(sq)), len(sq)))
    out.append("  (T = bersaglio prima dello stop, S = stop prima, N = nessuno dei due entro fine")
    out.append("   seduta. Frequenze di ordine di tocco, NON un PF: niente costi.)")
    out.append("")
    out.append("  == RETEST: quanto ritraccia verso il livello rotto ==")
    voci = [("ritr. minimo %d min" % h, (lambda e, h=h: e["prof"][h])) for h in cfg.scadenze]
    voci.append(("ritr. minimo fine", lambda e: e["prof"]["F"]))
    tab_q(out, "  profondita' del minimo dopo la rottura (POSITIVA = dentro il livello; negativa = il prezzo "
               "non e' tornato: min. sopra il livello). La barra di rottura e' esclusa.", voci, evs)
    hs = list(cfg.scadenze) + ["F"]
    out.append("  frequenza con cui il ritracciamento raggiunge la profondita' g (in R) = frequenza di")
    out.append("  riempimento di un LIMIT a livello - g*R, per scadenza dal momento della rottura. %(n)")
    out.append("  %8s " % "g (R)" + " ".join("%14s" % ("<%d min" % h if h != "F" else "fine seduta") for h in hs))
    for g in GRIGLIA_PROF:
        celle = []
        for h in hs:
            va = [e for e in evs if e["prof"][h] is not None]
            k = len([e for e in va if e["prof"][h] >= g * e["A"] - 1e-9])
            celle.append(fmt_pc(k, len(va)))
        out.append("  %8s " % ("%+.2f" % g) + " ".join("%14s" % c for c in celle))
    out.append("  (g=0: il livello; g=+0,50: meta' range dentro; g=+1,00: il bordo opposto = lo stop.)")
    out.append("")
    out.append("  == RETEST: LIMIT a livello - o*R (retest a offset o), scadenza di riferimento %d min, poi corsa ==" % ref)
    validi = [e for e in evs if e["ref_pieno"]]
    out.append("  eventi con scadenza di riferimento completa dentro la seduta: %d su %d" % (len(validi), len(evs)))
    for o in cfg.offsets:
        fil = [e for e in validi if e["fill"][o]["min"] is not None and e["fill"][o]["min"] < ref]
        out.append("  -- offset %.2fR: riempito %s%% (n=%d)" % (o, P(len(fil), len(validi)), len(validi)))
        if not fil:
            continue
        tm = [e["fill"][o]["min"] for e in fil]
        out.append("     minuti dalla rottura al riempimento: q25/50/75 = %s   (n=%d)" %
                   (" / ".join(AA.f(AA.quantile(tm, q), 0) for q in (0.25, 0.5, 0.75)), len(fil)))
        out.append("     dopo il riempimento (stop bordo opposto; A = stessa barra):")
        out.append("     %-10s %8s %8s %8s %8s   n" % ("bersaglio", "T%", "S%", "A%", "N%"))
        for t in cfg.bersagli:
            sq = [e["fill"][o]["seq"][t] for e in fil]
            out.append("     +%-9s %8s %8s %8s %8s   %d" % ("%gR" % t, P(sq.count("T"), len(sq)), P(sq.count("S"), len(sq)),
                                                          P(sq.count("A"), len(sq)), P(sq.count("N"), len(sq)), len(sq)))
        for u, nome_u, cifre in (("pt", "punti", 1), ("R", "R", 2)):
            v = [conv(e["fill"][o]["mfe"], e, u) for e in fil]
            out.append("     corsa massima dopo il riempimento (fino allo stop) [%s]" % nome_u)
            out.append(riga_q("MFE post-riempimento", v, cifre))
    out.append("")


def costruisci_referto(cfg, righe, tagli, diag, percorso, titolo, nota_fase, simbolo,
                       righe_fuso, righe_cal, rilievi):
    out = []
    add = out.append
    add("=" * 78)
    add(titolo)
    add("=" * 78)
    add("versione strumento : " + VERSIONE)
    add("file dati          : " + percorso)
    add("mercato            : %s (%s)" % (cfg.mercato, MERCATI[cfg.mercato]["desc"]))
    add("")
    add(nota_fase)
    add("")
    add("--- LEGGERE PRIMA DI CITARE UN NUMERO ---")
    add("  1. Sono MISURE DI ANATOMIA (una frequenza NON e' un edge): niente PF, niente")
    add("     equity, niente spread, niente costi, niente slippage. Non promuovono niente.")
    add("  2. Il feed e' HistData (non BCM), ora di NEW YORK, con il cancello qualita' del")
    add("     feed IN VERIFICA: i giorni con copertura anomala sono ESCLUSI e CONTATI sotto.")
    add("  3. Barre M5 costruite dalle M1. L'ordine dentro una barra M5 NON e' osservabile:")
    add("     ritracciamento/riempimento si guardano dalla barra SUCCESSIVA alla rottura ->")
    add("     la frequenza dei retest e' una stima PER DIFETTO. Barra con bersaglio E stop = A.")
    add("  4. R = ampiezza del range d'apertura. Long e short sempre separati. Solo la PRIMA")
    add("     rottura del giorno conta come evento; l'altro lato e' registrato come 2LATI.")
    add("  5. Ogni percentuale porta il suo n. * = n < %d: non e' una distribuzione." % SOGLIA_N)
    add("  6. Le IPOTESI si scrivono solo sull'addestramento; la cassaforte le VALIDA.")
    if cfg.buffer:
        add("  7. buffer = %g punti oltre il range (trigger e stop)." % cfg.buffer)
    add("")
    add("--- FUSO E APERTURA ---")
    for x in righe_cal:
        add(x)
    add("")
    for x in righe_fuso:
        add(x)
    add("")
    add("--- GIORNI: BUONI / SOSPETTI / SENZA APERTURA, PER ANNO (cancello G1 >= %d giorni buoni) ---"
        % cfg.min_giorni_anno)
    add("  %-6s %7s %7s %9s %9s   %s" % ("ANNO", "GIORNI", "BUONI", "SOSPETTI", "NO-APERT", "G1"))
    anni = sorted(set(r["anno"] for r in righe))
    illeggibili = []
    for a in anni:
        gg = [r for r in righe if r["anno"] == a]
        b = len([r for r in gg if r["stato"] == "OK"])
        s = len([r for r in gg if r["stato"] == "SOSPETTO"])
        z = len([r for r in gg if r["stato"] == "SENZA_APERTURA"])
        g1 = "ok" if b >= cfg.min_giorni_anno else "NON LEGGIBILE"
        if b < cfg.min_giorni_anno:
            illeggibili.append(a)
        add("  %-6d %7d %7d %9d %9d   %s" % (a, len(gg), b, s, z, g1))
    motivi = {}
    for r in righe:
        if r["stato"] == "SOSPETTO":
            for m in r["motivo"].split(" - "):
                m = "".join(ch if not ch.isdigit() else "#" for ch in m)
                motivi[m] = motivi.get(m, 0) + 1
    if motivi:
        add("  famiglie di sospetto (cifre sostituite da #):")
        for m in sorted(motivi.keys()):
            add("    %6d  %s" % (motivi[m], m))
    add("")
    buoni = [r for r in righe if r["stato"] == "OK"]
    add("--- MOVIMENTO DI SEDUTA (giorni buoni, n=%d) ---" % len(buoni))
    add(intest_q())
    add(riga_q("range di seduta H-L pt", [r.get("hl_pt") for r in buoni], 1))
    add(riga_q("range di seduta H-L %", [100.0 * r["hl_pt"] / r["px"] if r.get("hl_pt") is not None else None
                                          for r in buoni], 3))
    add(riga_q("close-open di seduta pt", [r.get("oc_pt") for r in buoni], 1))
    add(riga_q("|close-open| pt", [abs(r["oc_pt"]) if r.get("oc_pt") is not None else None for r in buoni], 1))
    add(riga_q("ampiezza media M5, 1a ora", [r.get("atr_pri") for r in buoni], 2))
    add(riga_q("ampiezza media M5, resto", [r.get("atr_res") for r in buoni], 2))
    add(riga_q("gap d'apertura %", [r.get("gap_pct") for r in buoni], 3))
    add("")
    for N in cfg.ranges:
        add("#" * 78)
        add("# RANGE D'APERTURA DI %d MINUTI (InpRangeMinutes = %d)" % (N, N))
        add("#" * 78)
        ev_giorni = [(r, r["ev"][N]) for r in buoni if N in r["ev"]]
        validi = [(r, e) for r, e in ev_giorni if e["lato_txt"] not in ("MANCANTE", "PIATTO")]
        add("giorni buoni %d; range valido %d (MANCANTE %d, PIATTO %d)" %
            (len(ev_giorni), len(validi),
             len([1 for r, e in ev_giorni if e["lato_txt"] == "MANCANTE"]),
             len([1 for r, e in ev_giorni if e["lato_txt"] == "PIATTO"])))
        conta = {}
        for r, e in validi:
            conta[e["lato_txt"]] = conta.get(e["lato_txt"], 0) + 1
        add("prima rottura: LONG %d  SHORT %d  AMBIGUA(una barra tocca i due lati) %d  NESSUNA %d" %
            (conta.get("LONG", 0), conta.get("SHORT", 0), conta.get("AMBIGUA", 0), conta.get("NESSUNA", 0)))
        two = len([1 for r, e in validi if e.get("lato2_txt")])
        add("giorni in cui ANCHE l'altro lato rompe dopo (2LATI): %d (%s%% dei giorni con rottura)" %
            (two, P(two, conta.get("LONG", 0) + conta.get("SHORT", 0))))
        add("")
        add(intest_q())
        add(riga_q("ampiezza range pt", [e["A"] for r, e in validi], 1))
        add(riga_q("ampiezza range % prezzo", [e["amp_pct"] for r, e in validi], 3))
        tg = tagli.get(N)
        if tg:
            add("  terzili dell'ampiezza %% (tarati SOLO sull'addestramento): <= %.3f | <= %.3f | oltre" % tg)
        else:
            add("  terzili dell'ampiezza: NON DISPONIBILI (addestramento < 30 giorni validi)")
        add("")
        evl = {"LONG": [], "SHORT": []}
        for r, e in validi:
            if e["lato_txt"] in evl:
                e2 = dict(e)
                e2["anno"] = r["anno"]
                e2["dow"] = r["dow"]
                e2["gap_pct"] = r.get("gap_pct")
                evl[e["lato_txt"]].append(e2)
        for lato in ("LONG", "SHORT"):
            blocco_lato(cfg, out, evl[lato], lato, N)
        add("  ==== CONDIZIONATI (colonne: falso15% = falso breakout entro 15 min; MFE in R dal livello;")
        add("       ritr%dR = mediana profondita' del retest entro %d min in R; retest0%% = il LIMIT sul" % (cfg.scad_ref, cfg.scad_ref))
        add("       livello (offset 0) si riempie entro %d min; T+1R%% e S<T%% = sequenza dopo il breakout) ====" % cfg.scad_ref)
        for lato in ("LONG", "SHORT"):
            evs = evl[lato]
            add("")
            add("  -- %s, range %d, per AMPIEZZA del range (terzili dell'addestramento) --" % (lato, N))
            add(intest_cond(cfg))
            for i, nome in enumerate(("stretto", "medio", "largo")):
                sub = [e for e in evs if tg and taglio(e["amp_pct"], tg) == i]
                add(riga_cond(cfg, nome, sub) if sub else "  %-22s %7s" % (nome, "0"))
            add("  -- %s, range %d, per GAP d'apertura --" % (lato, N))
            add(intest_cond(cfg))
            for nome, fn in (("gap < -0,25%", lambda x: x is not None and x < -0.25),
                             ("gap dentro", lambda x: x is not None and -0.25 <= x <= 0.25),
                             ("gap > +0,25%", lambda x: x is not None and x > 0.25),
                             ("gap n/d", lambda x: x is None)):
                sub = [e for e in evs if fn(e["gap_pct"])]
                add(riga_cond(cfg, nome, sub) if sub else "  %-22s %7s" % (nome, "0"))
            add("  -- %s, range %d, per GIORNO della settimana --" % (lato, N))
            add(intest_cond(cfg))
            for dn in NOMI_GIORNI[:5]:
                sub = [e for e in evs if e["dow"] == dn]
                add(riga_cond(cfg, dn, sub) if sub else "  %-22s %7s" % (dn, "0"))
            add("  -- %s, range %d, per ANNO (G1: >= %d giorni buoni nell'anno) --" % (lato, N, cfg.min_giorni_anno))
            add(intest_cond(cfg))
            for a in anni:
                gb = len([r for r in buoni if r["anno"] == a])
                sub = [e for e in evs if e["anno"] == a]
                if gb < cfg.min_giorni_anno:
                    add("  %-22s NON LEGGIBILE (giorni buoni %d < %d; eventi %d)" % (str(a), gb, cfg.min_giorni_anno, len(sub)))
                else:
                    add(riga_cond(cfg, str(a), sub) if sub else "  %-22s %7s" % (str(a), "0"))
        add("")
    add("--- DA QUESTE MISURE AI PARAMETRI (lettura, non decisione) ---")
    add("  InpRangeMinutes     : il range per cui la frequenza dei falsi breakout (falso15%) e' minore e")
    add("                        la corsa (MFE240R) maggiore, letto SOLO sull'addestramento.")
    add("  InpBufferPoints     : un buffer b filtra le rotture con MFE15 < b: leggi q25/q50 di MFE 15 min (pt).")
    add("  InpRetestOffsetPts  : la profondita' g (R) con riempimento ~X% (griglia sopra) per l'ampiezza")
    add("                        mediana del range in punti: offset_pt = g * ampiezza_pt. Meglio il g dove")
    add("                        la corsa post-riempimento resta buona (tabelle offset).")
    add("  InpTP1_R            : il bersaglio con T% massimo. ATTENZIONE: qui R = AMPIEZZA del range, nell'EA")
    add("                        InpTP1_R e' in multipli del RISCHIO (ingresso-stop) = (1-o)*ampiezza per il")
    add("                        retest -> InpTP1_R = t / (1 - o); breakout (o=0): identici.")
    add("  InpPendingExpiryMin : la scadenza in cui la griglia di riempimento smette di crescere (colonne <N min).")
    add("")
    add("--- RILIEVI DI QUESTA CORSA ---")
    if not rilievi:
        add("  nessuno")
    for x in rilievi:
        add("  - " + x)
    add("")
    add("--- QUELLO CHE QUESTO STUDIO NON PUO' DIRE ---")
    add("  Non dice se un motore guadagnerebbe: niente spread, fill, costi, posizione.")
    add("  Non vede il retest dentro la stessa barra M5 della rottura (stima per difetto).")
    add("  Non sostituisce il cancello qualita' del feed, che e' in verifica.")
    add("")
    add("ESITO: " + ("OK" if not rilievi else "MISURATO CON RILIEVI (%d)" % len(rilievi)))
    return out


# ---------------------------------------------------------------------
#  CSV PER GIORNO (una riga per giorno; colonne per range)
# ---------------------------------------------------------------------
def _v(x, cifre=4):
    if x is None:
        return ""
    if isinstance(x, bool):
        return "1" if x else "0"
    if isinstance(x, float):
        return ("%." + str(cifre) + "f") % x
    return str(x)


def colonne_csv(cfg):
    base = ["data", "anno", "mese", "giorno_sett", "fase", "stato", "motivo", "gruppo", "apertura",
            "px_apertura", "gap_pct", "hl_pt", "oc_pt", "cop_sess", "barre_ora"]
    per = ["amp_pt", "amp_pct", "lato", "min_rott", "lato2", "min2", "chiude_dentro", "mae1"]
    per += ["mfe%s" % h for h in ORIZZONTI_MFE] + ["mfeF"]
    per += ["falso%d" % w for w in FALSO_FINESTRE] + ["falsoprof%d" % w for w in FALSO_FINESTRE]
    per += ["seq_%g" % t for t in cfg.bersagli]
    per += ["prof%d" % h for h in cfg.scadenze] + ["profF"]
    for o in cfg.offsets:
        per += ["fill%g_min" % o, "fill%g_mfe" % o] + ["fill%g_seq_%g" % (o, t) for t in cfg.bersagli]
    cols = list(base)
    for N in cfg.ranges:
        cols += ["N%d_%s" % (N, c) for c in per]
    return cols


def riga_csv(cfg, r):
    v = [r["data"], r["anno"], r["mese"], r["dow"], r["fase"], r["stato"], r["motivo"].replace(",", ";"),
         r["gruppo"], AA.hhmm(r["open_mm"]), r.get("px"), r.get("gap_pct"), r.get("hl_pt"), r.get("oc_pt"),
         r.get("cop_sess"), r.get("barre_ora")]
    for N in cfg.ranges:
        e = r["ev"].get(N)
        n_cols = 8 + len(ORIZZONTI_MFE) + 1 + 2 * len(FALSO_FINESTRE) + len(cfg.bersagli) + len(cfg.scadenze) + 1 + \
            len(cfg.offsets) * (2 + len(cfg.bersagli))
        if e is None:
            v += [""] * n_cols
            continue
        if "lato" not in e:
            v += [e.get("A"), e.get("amp_pct"), e["lato_txt"], e.get("min_rott")] + [""] * (n_cols - 4)
            continue
        v += [e["A"], e["amp_pct"], e["lato_txt"], e["min_rott"], e["lato2_txt"], e["min2"],
              e["chiude_dentro"], e["mae1"]]
        v += [e["mfe"][h] for h in ORIZZONTI_MFE] + [e["mfe"]["F"]]
        v += [e["falso"][w] for w in FALSO_FINESTRE] + [e["falso_prof"][w] for w in FALSO_FINESTRE]
        v += [e["seq"][t] for t in cfg.bersagli]
        v += [e["prof"][h] for h in cfg.scadenze] + [e["prof"]["F"]]
        for o in cfg.offsets:
            d = e["fill"][o]
            v += [d["min"], d["mfe"]] + [d["seq"].get(t, "") for t in cfg.bersagli]
    return ",".join(_v(x) for x in v)
# =====================================================================
#  AUTOTEST: giorni SINTETICI con risposta nota. Nessun file vero.
# =====================================================================
def costruisci_parser():
    ap = argparse.ArgumentParser(
        description="Anatomia dei movimenti su M5 dopo la rottura del range d'apertura "
                    "(FASE 1b). NON e' un backtest: niente PF, niente equity, niente costi.")
    ap.add_argument("--file", default="", help="CSV Formato 1 (Time,Open,High,Low,Close,Volume), ora di New York")
    ap.add_argument("--simbolo", default="NASUSD", help="per i nomi dei file prodotti")
    ap.add_argument("--mercato", default="NASDAQ", choices=sorted(MERCATI.keys()))
    ap.add_argument("--uscita", default="", help="cartella dei referti e del CSV per-giorno")
    ap.add_argument("--autotest", action="store_true")
    ap.add_argument("--addestramento", default=None, help="AAAA-AAAA (default per mercato)")
    ap.add_argument("--cassaforte", default=None, help="AAAA-AAAA oppure 'nessuna' (default per mercato)")
    ap.add_argument("--ranges", default="15,30,35,45", help="minuti, multipli di 5")
    ap.add_argument("--scadenze", default="30,60,120", help="minuti per profondita'/riempimento")
    ap.add_argument("--scadenza-ref", dest="scadenza_ref", default="120")
    ap.add_argument("--offset-retest", dest="offset_retest", default="0,0.25,0.5", help="in R, positivo = dentro")
    ap.add_argument("--bersagli", default="0.5,1,1.5,2", help="in R")
    ap.add_argument("--buffer-punti", dest="buffer_punti", default="0", help="buffer oltre il range in PUNTI del prezzo")
    ap.add_argument("--durata-seduta", dest="durata_seduta", default="", help="minuti (default per mercato)")
    ap.add_argument("--banda-prezzo", dest="banda_prezzo", default="", help="LO,HI oppure 'nessuna'")
    ap.add_argument("--min-giorni-anno", dest="min_giorni_anno", default="150")
    ap.add_argument("--min-barre-ora", dest="min_barre_ora", default="55")
    ap.add_argument("--max-buco-min", dest="max_buco_min", default="3")
    ap.add_argument("--min-cop-sessione", dest="min_cop_sessione", default="0.70")
    ap.add_argument("--min-giorni-calibra", dest="min_giorni_calibra", default="30")
    ap.add_argument("--finestra-calibrazione", dest="finestra_calibrazione", default="90")
    ap.add_argument("--senza-calibrazione", dest="senza_calibrazione", action="store_true")
    ap.add_argument("--quota-sospetti", dest="quota_sospetti", default="20")
    return ap


def _cfg_test(extra=None, mercato="NASDAQ"):
    argv = ["--mercato", mercato, "--ranges", "5,15", "--min-giorni-anno", "1", "--min-giorni-calibra", "3"]
    if extra:
        argv += extra
    return Config(costruisci_parser().parse_args(argv))


def m1_da_m5(barre, K, buchi=()):
    """dict offset->(o,h,l,c) da barre M5 (k -> (o,h,l,c)); le altre sono piatte
    a 1000. L'aggregazione M5 dei cinque M1 restituisce ESATTAMENTE (o,h,l,c)."""
    m1 = {}
    for k in range(K):
        o, h, l, c = barre.get(k, (1000.0, 1000.0, 1000.0, 1000.0))
        cinque = [(o, o, o, o), (o, h, o, h), (h, h, l, l), (l, l, l, l), (l, c, l, c)]
        for i in range(5):
            m1[5 * k + i] = cinque[i]
    for b in buchi:
        m1.pop(b, None)
    return m1


def giorno_sint(cfg, data, barre, buchi=(), prec=None, grp="NY-FISSO", om=570, m1=None):
    y, m, d = [int(x) for x in data.split(".")]
    return {"data": data, "dt": date(y, m, d), "grp": grp, "open_mm": om,
            "m1": m1 if m1 is not None else m1_da_m5(barre, cfg.K, buchi), "chiusura_prec": prec}


def specchia(barre, centro=1000.0):
    out = {}
    for k, (o, h, l, c) in barre.items():
        out[k] = (2 * centro - o, 2 * centro - l, 2 * centro - h, 2 * centro - c)
    return out


class _Verifiche(object):
    def __init__(self):
        self.n = 0
        self.ok = 0
        self.falliti = []

    def check(self, nome, cond, dettaglio=""):
        self.n += 1
        if cond:
            self.ok += 1
        else:
            self.falliti.append("%s %s" % (nome, dettaglio))

    def uguale(self, nome, a, b, tol=1e-9):
        if isinstance(a, float) or isinstance(b, float):
            cond = a is not None and b is not None and abs(a - b) <= tol
        else:
            cond = (a == b)
        self.check(nome, cond, "atteso %r ottenuto %r" % (b, a))


# il giorno LONG di riferimento: range 5' = barra 0 (990-1010), rottura a 09:35
BARRE_LONG = {
    0: (1000.0, 1010.0, 990.0, 1000.0),
    1: (1000.0, 1015.0, 1000.0, 1012.0),     # rottura in su alla barra 1 = 09:35
    2: (1012.0, 1012.0, 1000.0, 1005.0),     # ritracciamento: minimo 1000 = 0,5R dentro il livello
    3: (1005.0, 1050.0, 1005.0, 1050.0),     # corsa: massimo 1050 = +2R dal livello
    30: (1050.0, 1060.0, 1050.0, 1050.0),    # massimo tardivo (offset 150): solo per orizzonti lunghi
}


def esegui_casi(cfg, v):
    """Tutti i controlli a risposta nota. Riusata dalle MUTAZIONI: con una
    soglia cambiata almeno un controllo deve fallire."""
    ev_l = None
    # -- 1. M1 -> M5 esatta, calcolata a mano
    m1 = {0: (10.0, 12.0, 9.0, 11.0), 1: (11.0, 13.0, 10.5, 12.0), 2: (12.0, 12.5, 8.0, 9.0),
          4: (9.0, 9.5, 8.5, 9.25), 5: (9.25, 20.0, 9.0, 19.0)}
    b = m5_da_m1(m1, 2)
    v.uguale("M5 barra0 open", b[0][0], 10.0)
    v.uguale("M5 barra0 high", b[0][1], 13.0)
    v.uguale("M5 barra0 low", b[0][2], 8.0)
    v.uguale("M5 barra0 close (ultima M1 presente, offset 4)", b[0][3], 9.25)
    v.uguale("M5 barra0 n M1", b[0][4], 4)
    v.uguale("M5 barra1 high", b[1][1], 20.0)
    v.check("M5 barra vuota = None", m5_da_m1({0: (1.0, 1.0, 1.0, 1.0)}, 2)[1] is None)
    # -- 2. giorno LONG di riferimento: numeri esatti
    r = analizza_giorno(cfg, giorno_sint(cfg, "2015.03.02", BARRE_LONG, prec=1000.0))
    v.uguale("giorno LONG: stato OK", r["stato"], "OK")
    e = r["ev"][5]
    ev_l = e
    v.uguale("LONG: ampiezza range 20", e["A"], 20.0)
    v.uguale("LONG: lato", e["lato_txt"], "LONG")
    v.uguale("LONG: minuto rottura 5 (09:35)", e["min_rott"], 5)
    v.uguale("LONG: barra di rottura chiude sopra il livello", e["chiude_dentro"], False)
    v.uguale("LONG: MFE 15 = 40 (2R)", e["mfe"][15], 40.0)
    v.uguale("LONG: MFE 120 = 40 (il massimo tardivo e' fuori)", e["mfe"][120], 40.0)
    v.uguale("LONG: MFE 240 = 50 (dentro il massimo tardivo)", e["mfe"][240], 50.0)
    v.uguale("LONG: MFE fine = 50", e["mfe"]["F"], 50.0)
    v.uguale("LONG: profondita' ritracciamento 30 min = 10 (0,5R)", e["prof"][30], 10.0)
    v.uguale("LONG: profondita' fine = 10", e["prof"]["F"], 10.0)
    v.uguale("LONG: MAE prima di +1R = 10 (0,5R)", e["mae1"], 10.0)
    v.uguale("LONG: tocca +1R", e["raggiunge1R"], True)
    v.uguale("LONG: falso15 (chiusura 1005 sotto il livello) ", e["falso"][15], True)
    v.uguale("LONG: profondita' del falso = 5", e["falso_prof"][15], 5.0)
    for t in (0.5, 1.0, 1.5, 2.0):
        v.uguale("LONG: sequenza +%gR = T" % t, e["seq"][t], "T")
    v.uguale("LONG: limit a 0,5R riempito dopo 5 min", e["fill"][0.5]["min"], 5)
    v.uguale("LONG: limit a 0,25R riempito dopo 5 min", e["fill"][0.25]["min"], 5)
    v.uguale("LONG: limit a 0 riempito dopo 5 min", e["fill"][0.0]["min"], 5)
    v.uguale("LONG: post-riempimento (0,5R) +1R = T", e["fill"][0.5]["seq"][1.0], "T")
    v.uguale("LONG: MFE post-riempimento (0,5R) = 60 (1060-1000)", e["fill"][0.5]["mfe"], 60.0)
    v.uguale("LONG: MFE post-riempimento (0) = 50 (1060-1010)", e["fill"][0.0]["mfe"], 50.0)
    v.uguale("LONG: nessun 2LATI", e["lato2_txt"], "")
    v.uguale("LONG: gap dello 0% (prec 1000)", r["gap_pct"], 0.0)
    # -- 3. giorno senza rottura: non conta
    tutto_dentro = {0: (1000.0, 1010.0, 990.0, 1000.0), 1: (1000.0, 1008.0, 992.0, 1000.0),
                    2: (1000.0, 1005.0, 995.0, 1000.0)}
    r0 = analizza_giorno(cfg, giorno_sint(cfg, "2015.03.03", tutto_dentro))
    v.uguale("senza rottura: lato NESSUNA", r0["ev"][5]["lato_txt"], "NESSUNA")
    v.check("senza rottura: nessun MFE calcolato", "mfe" not in r0["ev"][5])
    # -- 4. giorno sospetto: escluso e con motivo
    r1 = analizza_giorno(cfg, giorno_sint(cfg, "2015.03.04", BARRE_LONG, buchi=tuple(range(20, 45))))
    v.uguale("giorno sospetto: stato", r1["stato"], "SOSPETTO")
    v.check("giorno sospetto: nessun evento calcolato", r1["ev"] == {})
    v.check("giorno sospetto: il motivo c'e'", "copertura" in r1["motivo"] or "buco" in r1["motivo"])
    rb = analizza_giorno(cfg, giorno_sint(cfg, "2015.03.05", BARRE_LONG, buchi=(0, 1, 2, 3, 4)))
    v.uguale("senza apertura (primi 5 minuti vuoti): stato", rb["stato"], "SENZA_APERTURA")
    # -- 5. simmetria: dati specchiati -> stessi numeri, lato opposto
    rs = analizza_giorno(cfg, giorno_sint(cfg, "2015.03.06", specchia(BARRE_LONG), prec=1000.0))
    es = rs["ev"][5]
    v.uguale("specchio: lato SHORT", es["lato_txt"], "SHORT")
    v.uguale("specchio: minuto rottura", es["min_rott"], e["min_rott"])
    for h in ORIZZONTI_MFE:
        v.uguale("specchio: MFE %d" % h, es["mfe"][h], e["mfe"][h])
    v.uguale("specchio: MFE fine", es["mfe"]["F"], e["mfe"]["F"])
    v.uguale("specchio: MAE", es["mae1"], e["mae1"])
    v.uguale("specchio: profondita' 30", es["prof"][30], e["prof"][30])
    v.uguale("specchio: falso15", es["falso"][15], e["falso"][15])
    v.uguale("specchio: falso prof", es["falso_prof"][15], e["falso_prof"][15])
    for t in cfg.bersagli:
        v.uguale("specchio: sequenza %g" % t, es["seq"][t], e["seq"][t])
    for o in cfg.offsets:
        v.uguale("specchio: riempimento %g" % o, es["fill"][o]["min"], e["fill"][o]["min"])
        v.uguale("specchio: MFE post %g" % o, es["fill"][o]["mfe"], e["fill"][o]["mfe"])
    v.uguale("specchio: percentuale ampiezza", es["amp_pct"], e["amp_pct"])
    # -- 6. CONTRO-ESEMPIO 2LATI: rompe su a 09:35, poi giu' a 09:55.
    due = {0: (1000.0, 1010.0, 990.0, 1000.0), 1: (1000.0, 1012.0, 1000.0, 1010.0),
           2: (1010.0, 1011.0, 1001.0, 1002.0), 4: (1002.0, 1003.0, 985.0, 986.0)}
    rd = analizza_giorno(cfg, giorno_sint(cfg, "2015.03.09", due))
    ed = rd["ev"][5]
    v.uguale("2LATI: la PRIMA e' la LONG", ed["lato_txt"], "LONG")
    v.uguale("2LATI: minuto della prima 5", ed["min_rott"], 5)
    v.uguale("2LATI: la seconda e' registrata come SHORT", ed["lato2_txt"], "SHORT")
    v.uguale("2LATI: minuto della seconda 20", ed["min2"], 20)
    v.uguale("2LATI: sequenza +1R = S (lo stop 990 e' toccato a 985)", ed["seq"][1.0], "S")
    # una barra che tocca tutti e due i lati: AMBIGUA, ne' long ne' short
    amb = {0: (1000.0, 1010.0, 990.0, 1000.0), 1: (1000.0, 1015.0, 985.0, 1000.0)}
    ra = analizza_giorno(cfg, giorno_sint(cfg, "2015.03.10", amb))
    v.uguale("stessa barra sui due lati: AMBIGUA", ra["ev"][5]["lato_txt"], "AMBIGUA")
    # range piatto: escluso dai rapporti in R
    piatto = {0: (1000.0, 1000.0, 1000.0, 1000.0)}
    rp = analizza_giorno(cfg, giorno_sint(cfg, "2015.03.11", piatto))
    v.uguale("range piatto: PIATTO", rp["ev"][5]["lato_txt"], "PIATTO")
    # -- 7. stessa barra bersaglio+stop: A, mai T ne' S
    ab = {0: (1000.0, 1010.0, 990.0, 1000.0), 1: (1000.0, 1015.0, 1000.0, 1012.0),
          2: (1012.0, 1040.0, 988.0, 1012.0)}
    rq = analizza_giorno(cfg, giorno_sint(cfg, "2015.03.12", ab))
    v.uguale("bersaglio e stop nella stessa barra: A", rq["ev"][5]["seq"][1.0], "A")
    # -- 8. barra di rottura: il ritracciamento nella STESSA barra non si vede
    stessa = {0: (1000.0, 1010.0, 990.0, 1000.0), 1: (1000.0, 1020.0, 995.0, 1020.0)}
    for k in range(2, cfg.K):
        stessa[k] = (1020.0, 1020.0, 1020.0, 1020.0)     # il prezzo NON torna piu' sul livello
    rz = analizza_giorno(cfg, giorno_sint(cfg, "2015.03.13", stessa))
    v.check("retest nella barra di rottura non contato: nessun riempimento a 0",
            rz["ev"][5]["fill"][0.0]["min"] is None)
    # -- 8b. riempito e stoppato alla barra dopo: corsa nulla (0), non dato mancante
    stop_dopo = {0: (1000.0, 1010.0, 990.0, 1000.0), 1: (1000.0, 1015.0, 1000.0, 1012.0),
                 2: (1012.0, 1012.0, 1005.0, 1006.0), 3: (1006.0, 1006.0, 985.0, 985.0)}
    rw = analizza_giorno(cfg, giorno_sint(cfg, "2015.03.17", stop_dopo))
    v.uguale("riempito e stoppato subito: MFE post-riempimento 0", rw["ev"][5]["fill"][0.0]["mfe"], 0.0)
    v.uguale("riempito e stoppato subito: sequenza S", rw["ev"][5]["fill"][0.0]["seq"][1.0], "S")
    # -- 9. banda di prezzo di guardia (feed di un altro strumento)
    cfg_b = _cfg_test(["--banda-prezzo", "1500,2500"])
    rbnd = analizza_giorno(cfg_b, giorno_sint(cfg_b, "2015.03.16", BARRE_LONG))
    v.uguale("prezzo fuori banda: SOSPETTO", rbnd["stato"], "SOSPETTO")
    # -- 10. calendario del fuso (date note)
    v.uguale("DAX 2016-01-15 CET-NY=6", gruppo_dax(date(2016, 1, 15)), ("CET-NY=6", 180))
    v.uguale("DAX 2016-03-15 (US si', EU no) CET-NY=5", gruppo_dax(date(2016, 3, 15)), ("CET-NY=5", 240))
    v.uguale("DAX 2016-07-15 CET-NY=6", gruppo_dax(date(2016, 7, 15)), ("CET-NY=6", 180))
    v.uguale("DAX 2016-10-31 (EU no, US si') CET-NY=5", gruppo_dax(date(2016, 10, 31)), ("CET-NY=5", 240))
    v.uguale("DAX 2016-11-08 CET-NY=6", gruppo_dax(date(2016, 11, 8)), ("CET-NY=6", 180))
    v.uguale("DAX 2013-03-12 (US 10/3, EU 31/3) CET-NY=5", gruppo_dax(date(2013, 3, 12)), ("CET-NY=5", 240))
    v.uguale("Nasdaq sempre 09:30", gruppo_nasdaq(date(2016, 3, 15)), ("NY-FISSO", 570))
    return ev_l


def _scrivi_csv_sint(percorso, giorni, picco_off, om_fn, ampio=2.0, piccolo=0.1, extra_riga=None,
                     extra_prima=None):
    """File Formato 1 sintetico: per ogni data, minuti dall'apertura di om_fn(dt)
    per 60 min, range H-L piccolo salvo la barra a om+picco_off (ampio)."""
    righe = ["Time,Open,High,Low,Close,Volume"]
    for dt in giorni:
        om = om_fn(dt)
        for off in range(-30, 90):
            mm = om + off
            amp = ampio if off == picco_off else piccolo
            if extra_prima and off == extra_prima[0]:
                amp = extra_prima[1]
            righe.append("%04d.%02d.%02d %02d:%02d,%.6f,%.6f,%.6f,%.6f,0" %
                         (dt.year, dt.month, dt.day, mm // 60, mm % 60, 5000.0, 5000.0 + amp, 5000.0, 5000.0 + amp / 2))
    if extra_riga:
        righe.append(extra_riga)
    with open(percorso, "w", newline="", encoding="ascii") as fh:
        for x in righe:
            fh.write(x + "\n")


def _giorni_test():
    """Giorni feriali: 8 in inverno (NORMALE), 6 fra il 12 e il 24 marzo 2016 (SFASATO)."""
    out = []
    d = date(2016, 1, 11)
    while len(out) < 8:
        if d.weekday() < 5:
            out.append(d)
        d += timedelta(days=1)
    d = date(2016, 3, 14)
    n = 0
    while n < 6:
        if d.weekday() < 5:
            out.append(d)
            n += 1
        d += timedelta(days=1)
    return out


def autotest():
    log("=== AUTOTEST %s (offline, dati SINTETICI) ===" % VERSIONE)
    cfg = _cfg_test()
    if cfg.problemi:
        log("!!! configurazione di test incoerente: %s" % cfg.problemi)
        return 2
    v = _Verifiche()
    esegui_casi(cfg, v)
    base_n, base_ok = v.n, v.ok
    log("1. casi a risposta nota (numeri esatti a mano, simmetria, 2LATI, sospetti): %d/%d" % (base_ok, base_n))
    for x in v.falliti:
        log("   FALLITO: " + x)
    # -- 2. calibrazione + lettura file sul DAX sintetico
    tmpd = tempfile.mkdtemp(prefix="anat_m5_")
    dax = _cfg_test(["--senza-calibrazione"], mercato="DAX")
    dax_c = _cfg_test([], mercato="DAX")
    gg = _giorni_test()
    f_ok = os.path.join(tmpd, "dax_ok.csv")
    _scrivi_csv_sint(f_ok, gg, 0, lambda dt: gruppo_dax(dt)[1])
    esito, righe_cal, ril = calibra_apertura(dax_c, f_ok)
    w = _Verifiche()
    w.uguale("calibrazione: gruppo normale CONFERMATA", esito["CET-NY=6"]["stato"], "CONFERMATA")
    w.uguale("calibrazione: gruppo sfasato CONFERMATA", esito["CET-NY=5"]["stato"], "CONFERMATA")
    w.uguale("calibrazione: picco normale a 03:00", esito["CET-NY=6"]["misurata"], 180)
    w.uguale("calibrazione: picco sfasato a 04:00", esito["CET-NY=5"]["misurata"], 240)
    w.check("calibrazione: nessun rilievo", ril == [], str(ril))
    # CONTRO-ESEMPIO: orologio del feed spostato di un'ora (picco a +60 dall'ipotesi)
    f_sh = os.path.join(tmpd, "dax_shift.csv")
    _scrivi_csv_sint(f_sh, gg, 60, lambda dt: gruppo_dax(dt)[1])
    e2, _r2, ril2 = calibra_apertura(dax_c, f_sh)
    w.uguale("feed spostato +1h: SMENTITA (non 'confermata')", e2["CET-NY=6"]["stato"], "SMENTITA")
    w.uguale("feed spostato +1h: si usa la MISURA 04:00", e2["CET-NY=6"]["usata"], 240)
    w.check("feed spostato +1h: c'e' un RILIEVO", len(ril2) >= 1)
    # CONTRO-ESEMPIO 2: il PRIMO minuto del feed (salto) e' enorme, ma non e' l'apertura
    f_st = os.path.join(tmpd, "dax_start.csv")
    _scrivi_csv_sint(f_st, gg, 0, lambda dt: gruppo_dax(dt)[1], extra_prima=(-30, 50.0))
    e5, _r5, _ril5 = calibra_apertura(dax_c, f_st)
    w.uguale("salto di inizio feed ignorato: picco ancora 03:00", e5["CET-NY=6"]["misurata"], 180)
    # picco a +75 minuti: lontano dall'ipotesi, NON si usa
    f_lo = os.path.join(tmpd, "dax_lontano.csv")
    _scrivi_csv_sint(f_lo, gg, 75, lambda dt: gruppo_dax(dt)[1])
    e6, _r6, ril6 = calibra_apertura(dax_c, f_lo)
    w.uguale("picco a +75 min: NON_COERENTE", e6["CET-NY=6"]["stato"], "NON_COERENTE")
    w.uguale("picco a +75 min: si tiene l'ipotesi 03:00", e6["CET-NY=6"]["usata"], 180)
    w.check("picco a +75 min: c'e' un rilievo", len(ril6) >= 1)
    # picco non decisivo: piatto
    f_pi = os.path.join(tmpd, "dax_piatto.csv")
    _scrivi_csv_sint(f_pi, gg, 0, lambda dt: gruppo_dax(dt)[1], ampio=0.1)
    e3, _r3, ril3 = calibra_apertura(dax_c, f_pi)
    w.uguale("profilo piatto: NON_DECISIVA", e3["CET-NY=6"]["stato"], "NON_DECISIVA")
    w.uguale("profilo piatto: si tiene l'ipotesi 03:00", e3["CET-NY=6"]["usata"], 180)
    # lettura del file: il giorno SFASATO si apre alle 04:00 e ha i suoi 90 minuti di dati
    aperture = dict((k, x["usata"]) for k, x in esito.items())
    righe, diag = scandisci(dax, f_ok, aperture, ogni=0)
    w.uguale("lettura: 14 giorni feriali letti", len(righe), 14)
    sf = [r for r in righe if r["gruppo"] == "CET-NY=5"]
    w.uguale("lettura: 6 giorni nel gruppo sfasato", len(sf), 6)
    w.check("lettura: il gruppo sfasato apre alle 04:00", all(r["open_mm"] == 240 for r in sf))
    w.uguale("lettura: il primo giorno ha la barra d'apertura osservata", righe[0].get("px"), 5000.0)
    # file fuori periodo: 2020 contato e non analizzato (DAX: addestramento 2010-2018)
    f_fp = os.path.join(tmpd, "dax_fuori.csv")
    _scrivi_csv_sint(f_fp, [date(2020, 1, 13)], 0, lambda dt: 180)
    r_fp, d_fp = scandisci(dax, f_fp, {"CET-NY=6": 180}, ogni=0)
    w.uguale("fuori periodo: 0 righe analizzate", len(r_fp), 0)
    w.uguale("fuori periodo: 1 giorno contato a parte", d_fp["fuori_periodo"], 1)
    # periodi incoerenti: cassaforte che si sovrappone all'addestramento
    w.check("periodi sovrapposti: rifiutati",
            len(_cfg_test(["--addestramento", "2010-2020", "--cassaforte", "2020-2026"]).problemi) > 0)
    w.check("cassaforte senza addestramento: rifiutata",
            len(_cfg_test(["--addestramento", "nessuna", "--cassaforte", "2021-2026"]).problemi) > 0)
    # DAX: la cassaforte e' assente di default (i dati esterni finiscono nel 2018)
    w.check("DAX: nessuna cassaforte di default", dax.per_cs is None)
    log("2. calibrazione del fuso, contro-esempio dell'orologio spostato, lettura file: %d/%d" % (w.ok, w.n))
    for x in w.falliti:
        log("   FALLITO: " + x)
    # -- 3. referto: gira sui dati sintetici e non contiene PF
    ev_gg = []
    for nome, barre in (("2015.03.02", BARRE_LONG), ("2015.03.06", specchia(BARRE_LONG))):
        ev_gg.append(analizza_giorno(cfg, giorno_sint(cfg, nome, barre, prec=1000.0)))
    tagli = calcola_tagli(cfg, ev_gg)
    testo = costruisci_referto(cfg, ev_gg, tagli, {"prima": "", "ultima": ""}, "SINTETICO", "TITOLO", "NOTA",
                               "TEST", ["fuso"], ["cal"], [])
    z = _Verifiche()
    z.check("referto: nessuna riga vuota di contenuto", len(testo) > 100)
    z.check("referto: dichiara che NON e' un edge", any("NON e' un edge" in x for x in testo))
    z.check("referto: termina con ESITO", testo[-1].startswith("ESITO:"))
    z.check("referto: nessun 'profit factor' come misura", not any("PF =" in x or "profit factor =" in x.lower() for x in testo))
    z.check("referto: solo ASCII", all(all(ord(ch) < 128 for ch in x) for x in testo))
    z.check("referto: la tabella LONG e la SHORT ci sono separate",
            any("LONG, range 5" in x for x in testo) and any("SHORT, range 5" in x for x in testo))
    csv_r = riga_csv(cfg, ev_gg[0])
    z.uguale("csv: numero di campi = numero di colonne", len(csv_r.split(",")), len(colonne_csv(cfg)))
    z.check("csv: nessuna virgola nel motivo", "," not in ev_gg[0]["motivo"])
    log("3. referto e CSV sui giorni sintetici: %d/%d" % (z.ok, z.n))
    for x in z.falliti:
        log("   FALLITO: " + x)
    # -- 4. MUTAZIONI: una soglia cambiata deve far FALLIRE i casi a risposta nota
    mutazioni = [
        ("min_barre_ora 55 -> 0 (il giorno sospetto non si esclude piu')", ["--min-barre-ora", "0", "--max-buco-min", "999", "--min-cop-sessione", "0"]),
        ("buffer 0 -> 3 punti (la rottura scatta piu' tardi, i numeri cambiano)", ["--buffer-punti", "3"]),
        ("bersagli 0.5,1,1.5,2 -> 3,4 (le sequenze attese non esistono piu')", ["--bersagli", "3,4"]),
        ("offset-retest 0,0.25,0.5 -> 0.75 (i riempimenti attesi non esistono piu')", ["--offset-retest", "0.75"]),
    ]
    catturate = 0
    for nome, extra in mutazioni:
        try:
            cm = _cfg_test(extra)
            vm = _Verifiche()
            esegui_casi(cm, vm)
            fallito = len(vm.falliti) > 0
        except (KeyError, IndexError, TypeError, ValueError):
            fallito = True
        catturate += 1 if fallito else 0
        log("   mutazione: %-72s -> %s" % (nome, "CATTURATA" if fallito else "*** NON CATTURATA ***"))
    log("4. mutazioni catturate: %d/%d" % (catturate, len(mutazioni)))
    totale = base_n + w.n + z.n + len(mutazioni)
    giusti = base_ok + w.ok + z.ok + catturate
    log("")
    log("AUTOTEST: %d/%d" % (giusti, totale))
    if giusti == totale:
        log("ESITO: OK")
        return 0
    log("ESITO: FALLITO")
    return 1
# =====================================================================
#  MAIN
# =====================================================================
def main():
    args = costruisci_parser().parse_args()
    log("=====================================================================")
    log(" ANATOMIA DEI MOVIMENTI M5 -- %s (FASE 1b: DESCRITTIVA)" % VERSIONE)
    log("=====================================================================")
    log(" NON e' un backtest: niente PF, niente equity, niente costi, niente motori.")
    log("")
    if args.autotest:
        return autotest()
    try:
        cfg = Config(args)
    except (ValueError, TypeError) as e:
        log("!!! PARAMETRI NON VALIDI: %s" % e)
        return 2
    if cfg.problemi:
        log("!!! PARAMETRI INCOERENTI:")
        for p in cfg.problemi:
            log("    - " + p)
        return 2
    if not args.file:
        log("!!! MANCA --file")
        return 2
    percorso = args.file
    if not os.path.exists(percorso):
        log("!!! IL FILE NON ESISTE: " + percorso)
        return 2
    forma, prima = AA.riconosci_formato(percorso)
    if forma != "FORMATO1":
        log("!!! IL FILE C'E' MA NON E' NEL FORMATO GIUSTO: %s (formato %s, prima riga %s)" %
            (percorso, forma, str(prima)[:100]))
        log("    Atteso il Formato 1: Time,Open,High,Low,Close,Volume con 'AAAA.MM.GG HH:MM'.")
        return 2
    cartella = args.uscita or os.path.dirname(os.path.abspath(percorso))
    os.makedirs(cartella, exist_ok=True)
    log(" file      : " + percorso)
    log(" mercato   : %s (%s)" % (cfg.mercato, MERCATI[cfg.mercato]["desc"]))
    log(" periodi   : addestramento %s   cassaforte %s" %
        (cfg.per_is, cfg.per_cs if cfg.per_cs else "NESSUNA"))
    log(" range     : %s min   scadenze %s   riferimento %d   offset %s   bersagli %s" %
        (cfg.ranges, cfg.scadenze, cfg.scad_ref, cfg.offsets, cfg.bersagli))
    log(" buffer    : %g punti   banda di prezzo: %s" % (cfg.buffer, cfg.banda if cfg.banda else "nessuna"))
    log("")
    rilievi = []
    aperture = {}
    if cfg.calibra:
        log(" prima passata: calibrazione dell'ora d'apertura ...")
        esito, righe_cal, ril_cal = calibra_apertura(cfg, percorso)
        for x in righe_cal:
            log(x)
        rilievi += ril_cal
        aperture = dict((k, x["usata"]) for k, x in esito.items())
        if not aperture:
            log("!!! CALIBRAZIONE IMPOSSIBILE: nessun dato nelle finestre attese. Si ferma.")
            return 2
    else:
        righe_cal = ["  calibrazione DISATTIVATA (--senza-calibrazione): si usa l'ipotesi del calendario."]
        rilievi.append("calibrazione dell'apertura disattivata: l'ora d'apertura e' un'ipotesi, non una misura")
    log("")
    log(" seconda passata: lettura in streaming ...")
    giorni, diag = scandisci(cfg, percorso, aperture)
    if diag["barre"] == 0 or not giorni:
        log("!!! ZERO GIORNI ANALIZZABILI dentro i periodi dichiarati (barre lette %d)." % diag["barre"])
        return 2
    buoni = [r for r in giorni if r["stato"] == "OK"]
    sosp = [r for r in giorni if r["stato"] == "SOSPETTO"]
    noap = [r for r in giorni if r["stato"] == "SENZA_APERTURA"]
    log(" barre lette %d   giorni analizzati %d: BUONI %d   SOSPETTI %d   SENZA APERTURA %d   fuori periodo %d" %
        (diag["barre"], len(giorni), len(buoni), len(sosp), len(noap), diag["fuori_periodo"]))
    righe_fuso, ril_fuso = AA.canarino_fuso(diag)
    rilievi += ril_fuso
    if diag["fuori_ordine"]:
        rilievi.append("%d righe FUORI ORDINE nel file" % diag["fuori_ordine"])
    if diag.get("duplicate"):
        rilievi.append("%d barre M1 duplicate nella seduta (tenuta la prima)" % diag["duplicate"])
    if diag["date_ripetute"]:
        rilievi.append("%d date ricompaiono dopo essere state chiuse" % diag["date_ripetute"])
    for anno in sorted(set(r["anno"] for r in giorni)):
        gg = [r for r in giorni if r["anno"] == anno]
        s = len([r for r in gg if r["stato"] == "SOSPETTO"])
        m = len([r for r in gg if r["stato"] in ("OK", "SOSPETTO")])
        if m and 100.0 * s / m > cfg.quota_sospetti:
            rilievi.append("anno %d: %.1f%% di giorni sospetti (soglia %.1f%%)" % (anno, 100.0 * s / m, cfg.quota_sospetti))
    if not buoni:
        rilievi.append("NESSUN giorno buono")
    # ---- CSV per giorno
    nome_csv = "ANATOMIA_MOVIMENTI_M5_PERGIORNO_%s.csv" % args.simbolo
    percorso_csv = os.path.join(cartella, nome_csv)
    AA.scrivi_atomico(percorso_csv, [",".join(colonne_csv(cfg))] + [riga_csv(cfg, r) for r in giorni])
    log(" CSV per-giorno: %s (%d righe)" % (percorso_csv, len(giorni)))
    # ---- i terzili nascono SOLO dall'addestramento
    is_righe = [r for r in giorni if r["fase"] == "IS" and r["stato"] == "OK"]
    tagli = calcola_tagli(cfg, is_righe)
    prodotti = []
    blocchi = []
    if cfg.per_is:
        blocchi.append(("IS", cfg.per_is,
                        "QUESTO E' IL FILE DELL'ADDESTRAMENTO (%d-%d): le ipotesi di motore si scrivono QUI e SOLO QUI."
                        % cfg.per_is,
                        "ANATOMIA MOVIMENTI M5 -- %s -- ADDESTRAMENTO %d-%d" % (args.simbolo, cfg.per_is[0], cfg.per_is[1])))
    if cfg.per_cs:
        blocchi.append(("CASSAFORTE", cfg.per_cs,
                        "QUESTA E' LA CASSAFORTE (%d-%d). NON SI GUARDA per costruire ipotesi: serve a validarle "
                        "DOPO che sono state congelate. I terzili sono quelli dell'addestramento." % cfg.per_cs,
                        "ANATOMIA MOVIMENTI M5 -- %s -- CASSAFORTE %d-%d  [NON PER LE IPOTESI]" %
                        (args.simbolo, cfg.per_cs[0], cfg.per_cs[1])))
    else:
        rilievi.append("nessuna cassaforte per %s: le ipotesi non hanno un periodo di validazione in questo "
                       "file (per il DAX servono i tick BCM, nativi dal 26/09/2024)" % args.simbolo)
    for fase, per, nota, titolo in blocchi:
        sotto = [r for r in giorni if r["fase"] == fase]
        if not sotto:
            rilievi.append("nessun giorno nel periodo %s: referto non prodotto" % fase)
            continue
        testo = costruisci_referto(cfg, sotto, tagli, diag, percorso, titolo, nota, args.simbolo,
                                   righe_fuso, righe_cal, rilievi)
        nome = "ANATOMIA_MOVIMENTI_M5_%s_%s_%d_%d.txt" % (args.simbolo, fase, per[0], per[1])
        pr = os.path.join(cartella, nome)
        AA.scrivi_atomico(pr, testo)
        prodotti.append(pr)
        log(" referto: " + pr)
    picco = AA.ram_picco_mb()
    log(" RAM di picco: %s" % ("non misurabile" if picco is None else "%.0f MB" % picco))
    log("")
    log(" FILE PRODOTTI:")
    for p in [percorso_csv] + prodotti:
        log("   " + os.path.basename(p))
    if rilievi:
        log(" ESITO: MISURATO CON RILIEVI -- %d" % len(rilievi))
        for x in rilievi:
            log("   - " + x)
        return 1
    log(" ESITO: OK")
    return 0


if __name__ == "__main__":
    sys.exit(main())
