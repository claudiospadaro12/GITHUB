#!/usr/bin/env python3
# -*- coding: ascii -*-
# MARCATORE_CONFRONTO_FORWARD_TESTER_v1
"""
confronto_forward_tester.py -- le sedie FTMO rigiocate nel tester fanno le STESSE
operazioni che hanno fatto nel forward?  (RFWD, 30/09/2026)

DOMANDA UNICA. Serve a separare "campione corto / mercato" da "orari, feed o
codice FTMO diversi dal backtest". NON e' un backtest: niente PF, niente equity,
nessuna promozione, nessuna taglia, nessun verdetto sul merito di una sedia.

COSA LEGGE
  --forward  il Report Cronistorico di FTMO (xlsx: Posizioni, Ordini, Affari),
             letto SENZA librerie esterne (solo zipfile + xml della libreria standard:
             sul PC di backtest non c'e' openpyxl garantito);
  --pertrade la cartella con i file del tester  abtg_trades_<EA>_<SIMBOLO>_<magic>.csv
             (Common\\Files, scritti dall'export dell'EA, una riga per DEAL DI USCITA).

IL LIMITE CHE DETTA TUTTO IL DISEGNO (dichiarato, non aggirato)
  Il per-trade del tester ha SOLO le uscite: close_time;symbol;magic;position_id;
  deal_type;volume;price;net_profit. NON ha ora ne' prezzo d'ingresso, e un ordine
  pendente che non si riempie non lascia nessuna riga. Quindi:
    - l'abbinamento si fa sulle USCITE (ultima gamba: ora e prezzo, prezzo medio delle
      gambe), mai sugli ingressi; "stessa operazione" qui vuol dire "stessa sedia,
      stessa direzione, uscita alla stessa ora e allo stesso prezzo";
    - i pendenti scaduti/cancellati del FORWARD si elencano, ma nel tester sono
      NON OSSERVABILI: "0 vs 0" su un giorno con solo pendenti non e' una prova.

LIVELLI DI ABBINAMENTO (soglie in COSTANTI, congelate in report/RFWD_CRITERI.md)
  L1  stessa sedia + stessa direzione + ultima uscita entro TOL_TEMPO_STRETTA_MIN
      minuti + prezzo medio di uscita entro TOL_PREZZO_PT[famiglia] punti
      (un'ambiguita' si scioglie SOLO per rango di volume, altrimenti scende a L2);
  L2  stessa sedia + stessa direzione + stesso GIORNO (data BCM dell'ultima uscita),
      ma non L1. E' cieco all'orologio: mostra lo scarto orario, non lo giudica;
  F_SOLO  operazione forward senza gemello nel tester;
  T_SOLO  operazione del tester senza gemello nel forward (dentro la finestra viva
          della sedia e non oltre l'ultimo evento noto del forward + TOL_TEMPO_STRETTA_MIN:
          il margine serve perche' il tester puo' chiudere la STESSA operazione qualche
          minuto dopo il forward, e con un taglio secco sarebbe scambiata per "oltre").

USO
  python3 confronto_forward_tester.py --autotest [--forward FILE.xlsx]
  python3 confronto_forward_tester.py --forward FILE.xlsx --pertrade DIR --uscita DIR
        [--delta-ore 2] [--cutoff-forward "2026.09.30 10:03:09"] [--nullo 2000]
Uscita: 0 = eseguito (il confronto NON e' un cancello: descrive), 1 = errore
di input o autotest fallito.
"""
import argparse, csv, datetime, itertools, math, os, random, re, statistics, sys, zipfile
import xml.etree.ElementTree as ET

MARCATORE = "MARCATORE_CONFRONTO_FORWARD_TESTER_v1"

# =====================================================================
#  COSTANTI -- congelate PRIMA dei numeri, in report/RFWD_CRITERI.md (blocco
#  RFWD_COSTANTI): l'autotest confronta questo dizionario con quel blocco.
# =====================================================================
COSTANTI = {
    "TOL_TEMPO_STRETTA_MIN": 15,
    "TOL_PREZZO_DAX_PT": 10.0,
    "TOL_PREZZO_US30_PT": 25.0,
    "TOL_PREZZO_US100_PT": 15.0,
    "TOL_R": 0.25,
    "SOGLIA_STOP_R": -0.70,
    "SOGLIA_TRAIL_R": 0.30,
    "SOGLIA_ALTO_R": 1.50,
    "FINESTRA_ORARIO_MIN": 10,
    "DELTA_ORE": 2,
    "SALDO_INIZIALE": 80000.0,
    "H_FEDELI_L2_MIN": 0.70,
    "H_FEDELI_L1_MIN": 0.50,
    "H_FEDELI_TSOLO_B_MAX": 0.25,
    "H_DIVERSI_L2_MAX": 0.30,
    "H_DIVERSI_TSOLO_B_MIN": 1.00,
    "H_ORARI_L2_MIN": 0.50,
    "H_ORARI_L1_MAX": 0.20,
    "H_ORARI_MEDIANA_MIN": 45,
}
# Finestra UFFICIALE del confronto (il compito: 22-30/09). Il tester gira dal 21/09 (giorno di avvio della
# challenge, con ordini pendenti gia' nel forward): il 21/09 si RIPORTA a parte, non entra in nessun conteggio.
FINESTRA_UFFICIALE_DA = "2026.09.22"
FAMIGLIA_TOL = {"DAX": "TOL_PREZZO_DAX_PT", "US30": "TOL_PREZZO_US30_PT", "US100": "TOL_PREZZO_US100_PT"}

# Una riga per sedia in scope. 'viva_da' e' la prima data BCM in cui la sedia era
# attaccata al forward (770105: chart11 nato il 28/09, CODA_01 del 29/09 03:30 e il
# .chr del 28/09 07:43). 'chiusura_bcm' = chiusura d'orario dell'EA in ORA BCM
# (InpCloseHour/Min del preset FTMO meno 2 ore), None se la sedia non ne ha una.
SEDIE = [
    dict(id="770411", nome="MaxMin DAX short", ea="ABTG_MaxMinNotte_DAX_Short_Ottimizzato", sim_t="D30EUR",
         freq_contratto=0.051, sim_f="GER40.cash", fam="DAX", dir="S", magic=793411, twin=793461, commento=r"^MAXMIN DAX SHORT",
         chiusura_bcm=(17, 30), viva_da="2026.09.21", rischio=2.0),
    dict(id="770101", nome="DAX Apertura EU RETEST long", ea="ABTG_DAX_Apertura_EU_Pin9fca", sim_t="D30EUR",
         freq_contratto=0.699, sim_f="GER40.cash", fam="DAX", dir="L", magic=793601, twin=793651, commento=r"^DAX Apertura EU RETEST BUY",
         chiusura_bcm=(17, 30), viva_da="2026.09.21", rischio=2.0),
    dict(id="770105", nome="DAX Apertura EU RETEST short", ea="ABTG_DAX_Apertura_EU_Pin9fca", sim_t="D30EUR",
         freq_contratto=None, sim_f="GER40.cash", fam="DAX", dir="S", magic=793605, twin=793655, commento=r"^DAX Apertura EU RETEST SELL",
         chiusura_bcm=(17, 30), viva_da="2026.09.28", rischio=2.0),
    dict(id="771531", nome="EMA200 Dow H1", ea="ABTG_EMA200", sim_t="U30USD", sim_f="US30.cash", fam="US30", freq_contratto=0.931,
         dir="LS", magic=793531, twin=793581, commento=r"^EMA200", chiusura_bcm=None, viva_da="2026.09.21", rischio=2.0,
         quota_rischio=0.5),
    dict(id="770202", nome="Dow Apertura US", ea="ABTG_Dow_Apertura_US_Pin9fca", sim_t="U30USD", sim_f="US30.cash", freq_contratto=0.348,
         fam="US30", dir="L", magic=793202, twin=793252, commento=r"^Dow Apertura US", chiusura_bcm=(17, 30),
         viva_da="2026.09.21", rischio=2.0),
    dict(id="770260", nome="Nasdaq Apertura US RETEST", ea="ABTG_Nasdaq_Apertura_US_Pin9fca", sim_t="NASUSD",
         sim_f="US100.cash", fam="US100", freq_contratto=0.360, dir="LS", magic=793260, twin=793310, commento=r"^Nasdaq Apertura US",
         chiusura_bcm=(17, 30), viva_da="2026.09.21", rischio=2.0),
    dict(id="770511", nome="SuperWave DOW H1", ea="ABTG_SuperWave_DOW_H1_Ottimizzato", sim_t="U30USD",
         sim_f="US30.cash", fam="US30", freq_contratto=0.294, dir="LS", magic=793511, twin=793561, commento=r"^SUPERWAVE DOW H1",
         chiusura_bcm=None, viva_da="2026.09.21", rischio=2.0),
]
SEDIA_PER_ID = {s["id"]: s for s in SEDIE}

# 'quota_rischio': EMA200 divide InpRiskPercent fra i suoi DUE ordini (riskPct = InpRiskPercent/nOrders, EA r.361), quindi
# il rischio di UNA posizione e' meta': R nominale = netto / (2% x 0,5 x saldo). Le altre sedie: una posizione = tutto il rischio.
# (SuperWave divide la size in 1/3 mercato + 2/3 pendente: R nominale sull'intera size, dichiarato, nessuna operazione forward.)
# Ordini pendenti che scadono perdono il commento della sedia ("expired [..]"): l'attribuzione
# si INFERISCE da (simbolo FTMO, tipo). E' una regola, non un fatto: ogni riga inferita si stampa
# come INFERITA. Motivo per riga: chi altro puo' produrre quel tipo su quel simbolo.
INFERENZA_PENDENTI = {
    ("GER40.cash", "buy limit"): ("770101", "unica sedia DAX con limit BUY (770105 e' short, 770411 usa stop)"),
    ("GER40.cash", "sell limit"): ("770105", "unica sedia DAX con limit SELL (770101 e' long, 770411 usa stop)"),
    ("GER40.cash", "sell stop"): ("770411", "unica sedia DAX con stop SELL (le due Apertura usano limit)"),
    ("US30.cash", "sell limit"): ("771531", "EMA200 piazza coppie di limit S1/S2 all'apertura di ogni H1; 770202 e' long-only, SuperWave entra a mercato"),
}
TIPI_PENDENTI = ("buy limit", "sell limit", "buy stop", "sell stop")


# =====================================================================
#  UTILITA'
# =====================================================================
def dt_parse(s):
    return datetime.datetime.strptime(s.strip(), "%Y.%m.%d %H:%M:%S")

def d_parse(s):
    return datetime.datetime.strptime(s.strip(), "%Y.%m.%d").date()

def fmt_dt(d):
    return d.strftime("%Y.%m.%d %H:%M:%S")

def giorni_feriali(d0, d1):
    out = []
    d = d0
    while d <= d1:
        if d.weekday() < 5:
            out.append(d)
        d += datetime.timedelta(days=1)
    return out

def num(x):
    try:
        return float(str(x).replace(" ", "").replace(",", "."))
    except Exception:
        return None


# =====================================================================
#  LETTURA DELL'XLSX SENZA LIBRERIE (zipfile + ElementTree)
# =====================================================================
_NS = "{http://schemas.openxmlformats.org/spreadsheetml/2006/main}"

def _colnum(ref):
    m = re.match(r"([A-Z]+)(\d+)$", ref)
    c = 0
    for ch in m.group(1):
        c = c * 26 + ord(ch) - 64
    return c, int(m.group(2))

def leggi_xlsx(path):
    """Ritorna lista di righe (liste, indice 0 = colonna A) del primo foglio."""
    z = zipfile.ZipFile(path)
    strs = []
    if "xl/sharedStrings.xml" in z.namelist():
        ss = ET.fromstring(z.read("xl/sharedStrings.xml"))
        for si in ss.findall(_NS + "si"):
            strs.append("".join(t.text or "" for t in si.iter(_NS + "t")))
    nomi = sorted(n for n in z.namelist() if re.match(r"xl/worksheets/sheet\d+\.xml$", n))
    sh = ET.fromstring(z.read(nomi[0]))
    righe = {}
    for row in sh.iter(_NS + "row"):
        for c in row.findall(_NS + "c"):
            ci, ri = _colnum(c.get("r"))
            v = c.find(_NS + "v")
            t = c.get("t")
            if v is None:
                is_ = c.find(_NS + "is")
                val = "".join(x.text or "" for x in is_.iter(_NS + "t")) if is_ is not None else None
            elif t == "s":
                val = strs[int(v.text)]
            elif t in ("str", "inlineStr"):
                val = v.text
            else:
                val = float(v.text)
            righe.setdefault(ri, {})[ci] = val
    out = []
    for ri in sorted(righe):
        mx = max(righe[ri])
        out.append([righe[ri].get(k) for k in range(1, mx + 1)])
    return out


# =====================================================================
#  MODELLO DEL FORWARD
# =====================================================================
def _volume(s):
    """'9.11' -> 9.11 ; '24.2 / 0' -> (24.2, 0.0) ; ritorna (richiesto, riempito)."""
    if isinstance(s, (int, float)):
        return float(s), float(s)
    p = [num(x) for x in str(s).split("/")]
    if len(p) == 1:
        return p[0], p[0]
    return p[0], p[1]

def parse_forward(righe):
    """Ritorna dict(posizioni, ordini, deals, ultimo_evento)."""
    sez = None
    pos, ordini, deals = [], [], []
    for r in righe:
        a = r[0] if r else None
        if a in ("Posizioni", "Ordini", "Affari", "Ordini attivi", "Risultati"):
            sez = a
            continue
        if a in ("Ora", "Orario di Apertura"):
            continue
        if a is None or not isinstance(a, str) or not re.match(r"\d{4}\.\d{2}\.\d{2} \d{2}:\d{2}:\d{2}$", a):
            continue
        r = list(r) + [None] * (13 - len(r))
        if sez == "Posizioni":
            vol = _volume(r[4])[0]
            pos.append(dict(id=int(r[1]), sim=r[2], tipo=r[3], vol=vol, t_open=dt_parse(a), p_open=r[5], sl=r[6], tp=r[7],
                            t_close=dt_parse(r[8]), p_close=r[9], comm=r[10], swap=r[11], profit=r[12]))
        elif sez in ("Ordini", "Ordini attivi"):
            vol_r, vol_f = _volume(r[4])
            t_end = dt_parse(r[8]) if sez == "Ordini" and isinstance(r[8], str) and re.match(r"\d{4}\.", r[8]) else None
            ordini.append(dict(id=int(r[1]), sim=r[2], tipo=r[3], vol_r=vol_r, vol_f=vol_f, t_open=dt_parse(a),
                               prezzo=r[5], sl=r[6], tp=r[7], t_fine=t_end, stato=r[9], commento=(r[11] or ""),
                               attivo=(sez == "Ordini attivi")))
        elif sez == "Affari":
            if r[4] in ("in", "out"):
                deals.append(dict(id=int(r[1]), t=dt_parse(a), sim=r[2], tipo=r[3], dir=r[4], vol=_volume(r[5])[0],
                                  prezzo=r[6], ordine=int(r[7]), profit=r[11]))
    tutti = [p["t_open"] for p in pos] + [p["t_close"] for p in pos] + [o["t_open"] for o in ordini] + \
            [o["t_fine"] for o in ordini if o["t_fine"] and o["stato"] in ("filled", "canceled")] + [d["t"] for d in deals]
    return dict(posizioni=pos, ordini=ordini, deals=deals, ultimo_evento=max(tutti) if tutti else None)

def attribuisci_posizione(p, ordini):
    """Sedia di una posizione: dal commento dell'ordine con lo stesso id della posizione."""
    for o in ordini:
        if o["id"] == p["id"]:
            c = o["commento"] or ""
            for s in SEDIE:
                if re.search(s["commento"], c, flags=re.I):
                    return s["id"], c
            return None, c
    return None, ""

def assegna_gambe(pos, deals):
    """
    Gambe di uscita di ogni posizione. Fra i deal di uscita del simbolo, di tipo opposto e compresi fra
    apertura e chiusura, non ancora usati, si cerca il sottoinsieme (al massimo 4 gambe) il cui VOLUME somma
    a quello della posizione E il cui PROFITTO somma a quello della posizione (entro 0,05): due posizioni
    chiuse nello stesso secondo con volumi diversi (le coppie S1/S2 dell'EMA200) NON si separano per ordine
    di tempo, si separano cosi'. Se nessun sottoinsieme quadra su tutti e due, si ripiega sul solo volume e
    si dichiara quadra=False. Ritorna dict id -> (gambe, quadra).
    """
    usati = set()
    out = {}
    for p in sorted(pos, key=lambda x: (x["t_close"], x["t_open"])):
        opp = "buy" if p["tipo"] == "sell" else "sell"
        cand = sorted([d for d in deals if d["dir"] == "out" and d["sim"] == p["sim"] and d["tipo"] == opp and
                       d["id"] not in usati and p["t_open"] <= d["t"] <= p["t_close"]], key=lambda d: (d["t"], d["id"]))
        scelta, scelta_vol = None, None
        for n in range(1, min(4, len(cand)) + 1):
            for sub in itertools.combinations(cand, n):
                if abs(sum(d["vol"] for d in sub) - p["vol"]) > 0.005:
                    continue
                if abs(sum(d["profit"] for d in sub) - p["profit"]) <= 0.05 + 1e-9:
                    scelta = sub
                    break
                if scelta_vol is None:
                    scelta_vol = sub
            if scelta:
                break
        quadra = scelta is not None
        gambe = list(scelta or scelta_vol or [])
        for d in gambe:
            usati.add(d["id"])
        out[p["id"]] = (gambe, quadra)
    return out

def posizioni_forward(fw, delta_ore, saldo0):
    """Posizioni forward pronte al confronto, in ORA BCM. Ritorna (sedie_pos, manuali, note)."""
    dh = datetime.timedelta(hours=delta_ore)
    gambe = assegna_gambe(fw["posizioni"], fw["deals"])
    pos_ord = sorted(fw["posizioni"], key=lambda p: p["t_close"])
    res, manuali, note = [], [], []
    for p in fw["posizioni"]:
        sid, cm = attribuisci_posizione(p, fw["ordini"])
        g, quadra = gambe[p["id"]]
        if not quadra:
            note.append("forward posizione %d: gambe NON quadrano (volume o profitto)" % p["id"])
        saldo = saldo0 + sum(q["profit"] + (q["comm"] or 0) + (q["swap"] or 0) for q in pos_ord if q["t_close"] < p["t_open"])
        net = p["profit"] + (p["comm"] or 0) + (p["swap"] or 0)
        sd = SEDIA_PER_ID.get(sid)
        rk = (sd["rischio"] * sd.get("quota_rischio", 1.0) if sd else 2.0)
        legs = [dict(t=d["t"] - dh, p=d["prezzo"], v=d["vol"], net=d["profit"]) for d in g]
        if not legs:
            legs = [dict(t=p["t_close"] - dh, p=p["p_close"], v=p["vol"], net=net)]
        item = dict(id=p["id"], sedia=sid, dir=("S" if p["tipo"] == "sell" else "L"), t=p["t_close"] - dh,
                    t_open_bcm=p["t_open"] - dh, p=float(p["p_close"]), vol=p["vol"], net=net, legs=legs,
                    R=net / (rk / 100.0 * saldo), saldo=saldo, sim=p["sim"], commento=cm,
                    p_open=p["p_open"], sl=p["sl"])
        (res if sid else manuali).append(item)
    return res, manuali, note

def pendenti_forward(fw, delta_ore):
    """Ordini pendenti del forward (non a mercato, non chiusure), con attribuzione dichiarata."""
    dh = datetime.timedelta(hours=delta_ore)
    out = []
    for o in fw["ordini"]:
        if o["tipo"] not in TIPI_PENDENTI:
            continue
        sid, base = None, ""
        for s in SEDIE:
            if re.search(s["commento"], o["commento"] or "", flags=re.I):
                sid, base = s["id"], "commento"
        if sid is None and (o["sim"], o["tipo"]) in INFERENZA_PENDENTI:
            sid, ragione = INFERENZA_PENDENTI[(o["sim"], o["tipo"])]
            base = "INFERITA: " + ragione
        st = o["stato"]
        out.append(dict(id=o["id"], sedia=sid, base=base, tipo=o["tipo"], sim=o["sim"], t_piazz=o["t_open"] - dh,
                        t_fine=(o["t_fine"] - dh) if o["t_fine"] else None, stato=("attivo" if o["attivo"] else st),
                        prezzo=o["prezzo"], vol=o["vol_r"]))
    return out


# =====================================================================
#  MODELLO DEL TESTER (per-trade: una riga per deal di USCITA)
# =====================================================================
def leggi_pertrade(path):
    """Ritorna (righe, note). Riga = dict(t, sim, magic, pid, tipo, vol, p, net). Header obbligatorio."""
    note = []
    testo = open(path, encoding="ascii", errors="replace").read().replace("\r", "").split("\n")
    testo = [l for l in testo if l.strip()]
    if not testo or not testo[0].startswith("close_time;symbol;magic;position_id;deal_type;volume;price;net_profit"):
        return None, ["header assente o diverso dall'atteso"]
    righe = []
    for l in testo[1:]:
        f = l.split(";")
        if len(f) < 8:
            note.append("riga corta ignorata: " + l[:60])
            continue
        righe.append(dict(t=dt_parse(f[0]), sim=f[1], magic=int(f[2]), pid=int(f[3]), tipo=int(f[4]),
                          vol=float(f[5]), p=float(f[6]), net=float(f[7])))
    return righe, note

def posizioni_tester(righe, sedia, saldo0):
    """Raggruppa le righe per position_id. Direzione dal tipo del deal di uscita: 1 (sell) chiude un long."""
    per = {}
    for r in righe:
        per.setdefault(r["pid"], []).append(r)
    res, note = [], []
    for pid, rg in per.items():
        rg.sort(key=lambda x: x["t"])
        tipi = set(x["tipo"] for x in rg)
        if len(tipi) != 1:
            note.append("position_id %d con deal di uscita di tipo misto" % pid)
        d = "L" if rg[0]["tipo"] == 1 else "S"
        vol = sum(x["vol"] for x in rg)
        net = sum(x["net"] for x in rg)
        vwap = sum(x["p"] * x["vol"] for x in rg) / vol if vol > 0 else rg[-1]["p"]
        res.append(dict(id=pid, sedia=sedia["id"], dir=d, t=rg[-1]["t"], t_first=rg[0]["t"], p=vwap, vol=vol, net=net,
                        legs=[dict(t=x["t"], p=x["p"], v=x["vol"], net=x["net"]) for x in rg]))
    res.sort(key=lambda x: x["t"])
    saldo = saldo0
    for x in res:
        x["saldo"] = saldo
        x["R"] = x["net"] / (sedia["rischio"] * sedia.get("quota_rischio", 1.0) / 100.0 * saldo)
        saldo += x["net"]
    return res, note

def tipo_uscita(pos, chiusura_hm, C=COSTANTI):
    """Classe di uscita, LA STESSA REGOLA per forward e tester (simmetrica, dichiarata)."""
    if chiusura_hm:
        tm = pos["t"].hour * 60 + pos["t"].minute
        cm = chiusura_hm[0] * 60 + chiusura_hm[1]
        if 0 <= tm - cm <= C["FINESTRA_ORARIO_MIN"]:
            return "ORARIO"
    n = len(pos["legs"])
    R = pos["R"]
    if n == 1:
        if R <= C["SOGLIA_STOP_R"]:
            return "STOP"
        if R < C["SOGLIA_TRAIL_R"]:
            return "TRAIL_STRETTO"
        return "TARGET_O_ALTO"
    return "PARZ+ALTO" if R >= C["SOGLIA_ALTO_R"] else "PARZ+RESTO_BASSO"


# =====================================================================
#  L'ABBINAMENTO
# =====================================================================
def abbina(F, T, tol_min, tol_pt):
    """
    F, T: liste di dict con dir, t (datetime BCM ultima uscita), p (prezzo medio uscita), vol.
    Ritorna dict(coppie=[(i,j,livello,nota)], f_solo=[i], t_solo=[j]).
    Regola dell'ambiguita': se un candidato L1 ha PIU' di un gemello possibile (o e' il gemello di piu'
    di uno), si scioglie SOLO se le due parti hanno lo stesso numero di elementi e i volumi sono tutti
    distinti da entrambe le parti (rango di volume); altrimenti il gruppo scende a L2 con nota AMBIGUA.
    """
    tol = datetime.timedelta(minutes=tol_min)

    def l1ok(f, t):
        return f["dir"] == t["dir"] and abs(f["t"] - t["t"]) <= tol and abs(f["p"] - t["p"]) <= tol_pt + 1e-9

    nF, nT = len(F), len(T)
    adj = {i: [j for j in range(nT) if l1ok(F[i], T[j])] for i in range(nF)}
    # componenti connesse
    vistoF, vistoT = set(), set()
    coppie, ambigui = [], []
    for i0 in range(nF):
        if i0 in vistoF or not adj[i0]:
            continue
        cf, ct, pila = set(), set(), [("F", i0)]
        while pila:
            k, x = pila.pop()
            if k == "F":
                if x in cf:
                    continue
                cf.add(x)
                for j in adj[x]:
                    pila.append(("T", j))
            else:
                if x in ct:
                    continue
                ct.add(x)
                for i in range(nF):
                    if x in adj[i]:
                        pila.append(("F", i))
        vistoF |= cf
        vistoT |= ct
        if len(cf) == 1 and len(ct) == 1:
            coppie.append((min(cf), min(ct), "L1", ""))
            continue
        vf = sorted(cf, key=lambda i: F[i]["vol"])
        vt = sorted(ct, key=lambda j: T[j]["vol"])
        volf = [F[i]["vol"] for i in vf]
        volt = [T[j]["vol"] for j in vt]
        if len(cf) == len(ct) and len(set(volf)) == len(volf) and len(set(volt)) == len(volt):
            for i, j in zip(vf, vt):
                coppie.append((i, j, "L1", "ambiguita' sciolta per rango di volume"))
        else:
            ambigui.append((sorted(cf), sorted(ct)))
    usF = set(c[0] for c in coppie)
    usT = set(c[1] for c in coppie)
    # L2: stesso giorno + stessa direzione, greedy per scarto orario crescente
    restF = [i for i in range(nF) if i not in usF]
    restT = [j for j in range(nT) if j not in usT]
    cand = []
    for i in restF:
        for j in restT:
            if F[i]["dir"] == T[j]["dir"] and F[i]["t"].date() == T[j]["t"].date():
                cand.append((abs((F[i]["t"] - T[j]["t"]).total_seconds()), i, j))
    cand.sort()
    inamb = {i for cf, ct in ambigui for i in cf}
    for _, i, j in cand:
        if i in usF or j in usT:
            continue
        nota = "AMBIGUA a L1 (piu' gemelli entro tolleranza, volumi non distinguono)" if i in inamb else ""
        coppie.append((i, j, "L2", nota))
        usF.add(i)
        usT.add(j)
    f_solo = [i for i in range(nF) if i not in usF]
    t_solo = [j for j in range(nT) if j not in usT]
    return dict(coppie=coppie, f_solo=f_solo, t_solo=t_solo)


# =====================================================================
#  ALTERNATIVA: "NESSUN LEGAME" (ipotesi nulla) -- ipergeometrica e permutazioni
# =====================================================================
def _comb(n, k):
    return math.comb(n, k) if 0 <= k <= n else 0

def p_sovrapposizione(D, nF, nT, m):
    """P(sovrapposizione >= m) se i nT giorni-tester fossero scelti a caso fra D, con nF giorni-forward fissi."""
    tot = _comb(D, nT)
    if tot == 0:
        return float("nan")
    s = 0
    for k in range(m, min(nF, nT) + 1):
        s += _comb(nF, k) * _comb(D - nF, nT - k)
    return s / tot

def simula_nullo(sedie_dati, n_sim, seed, tol_min):
    """
    Ipotesi nulla: il tester e' INDIPENDENTE dal forward. Per ogni sedia le posizioni del tester (stesso
    numero di quelle vere) cadono in un giorno a caso fra i feriali della finestra viva e a un'ora a caso
    fra 08:00 e 17:30 BCM (EMA200/SuperWave: 00:00-24:00). Si misura quante posizioni forward troverebbero
    un gemello L1 (solo giorno+ora, il prezzo NON si applica: il nullo e' cosi' PIU' GENEROSO del reale) e
    L2 (giorno). Ritorna (media_L1, p95_L1, media_L2, p95_L2) come frazioni del totale forward.
    """
    rng = random.Random(seed)
    tol = datetime.timedelta(minutes=tol_min)
    tot_f = sum(len(sd["F"]) for sd in sedie_dati)
    if tot_f == 0:
        return None
    l1s, l2s = [], []
    for _ in range(n_sim):
        c1 = c2 = 0
        for sd in sedie_dati:
            giorni = sd["giorni"]
            if not giorni or not sd["F"]:
                continue
            usato1, usato2 = set(), set()
            Tsim = []
            for _k in range(sd["nT"]):
                g = rng.choice(giorni)
                lo, hi = sd["orario"]
                sec = rng.randint(lo * 3600, hi * 3600 - 1)
                Tsim.append(datetime.datetime(g.year, g.month, g.day) + datetime.timedelta(seconds=sec))
            for i, f in enumerate(sd["F"]):
                for j, t in enumerate(Tsim):
                    if j in usato1:
                        continue
                    if abs(f["t"] - t) <= tol:
                        usato1.add(j)
                        c1 += 1
                        usato2.add(j)
                        c2 += 1
                        break
                else:
                    for j, t in enumerate(Tsim):
                        if j not in usato2 and t.date() == f["t"].date():
                            usato2.add(j)
                            c2 += 1
                            break
        l1s.append(c1 / tot_f)
        l2s.append(c2 / tot_f)
    l1s.sort()
    l2s.sort()
    p95 = lambda v: v[min(len(v) - 1, int(math.ceil(0.95 * len(v))) - 1)]
    return (sum(l1s) / len(l1s), p95(l1s), sum(l2s) / len(l2s), p95(l2s))


# =====================================================================
#  IL CONFRONTO COMPLETO
# =====================================================================
def esegui_confronto(fw, tester_per_sedia, delta_ore, cutoff_fw, C=COSTANTI, n_nullo=2000):
    """
    fw: dict di parse_forward. tester_per_sedia: dict id -> dict(righe, note, twin_ok, trovato).
    cutoff_fw: datetime in ORA FTMO dell'ultimo evento noto del forward.
    """
    dh = datetime.timedelta(hours=delta_ore)
    cutoff_bcm = cutoff_fw - dh
    Fpos, manuali, note_fw = posizioni_forward(fw, delta_ore, C["SALDO_INIZIALE"])
    pend = pendenti_forward(fw, delta_ore)
    prima_data = min([p["t_open"] for p in fw["posizioni"]] + [o["t_open"] for o in fw["ordini"]]) - dh
    d0 = prima_data.date()
    d1 = cutoff_bcm.date()
    giorni_tutti = giorni_feriali(d0, d1)
    risultati = []
    uff = d_parse(FINESTRA_UFFICIALE_DA)
    for s in SEDIE:
        tol_pt = C[FAMIGLIA_TOL[s["fam"]]]
        viva_sedia = d_parse(s["viva_da"])
        viva = max(viva_sedia, uff)
        giorni = [g for g in giorni_tutti if g >= viva]
        Fall = sorted([p for p in Fpos if p["sedia"] == s["id"]], key=lambda x: x["t"])
        F = [f for f in Fall if f["t"].date() >= viva]
        F_avvio = [f for f in Fall if f["t"].date() < viva]
        for f in F:
            f["tipo_u"] = tipo_uscita(f, s["chiusura_bcm"], C)
        td = tester_per_sedia.get(s["id"])
        esclusi = []
        T, note_t = [], []
        if td and td.get("righe") is not None:
            Tall, note_t = posizioni_tester(td["righe"], s, C["SALDO_INIZIALE"])
            for x in Tall:
                x["tipo_u"] = tipo_uscita(x, s["chiusura_bcm"], C)
                if x["t"].date() < d0:
                    esclusi.append((x, "prima della finestra del forward"))
                elif x["t"].date() < viva_sedia:
                    esclusi.append((x, "sedia NON ancora attaccata al forward (viva da %s)" % s["viva_da"]))
                elif x["t"].date() < uff:
                    esclusi.append((x, "GIORNO DI AVVIO (prima del %s): fuori dal confronto ufficiale, riportato e non contato" % FINESTRA_UFFICIALE_DA))
                elif x["t"] > cutoff_bcm + datetime.timedelta(minutes=C["TOL_TEMPO_STRETTA_MIN"]):
                    esclusi.append((x, "oltre l'ultimo evento noto del forward + tolleranza (%s BCM + %d min): non confrontabile" %
                                    (fmt_dt(cutoff_bcm), C["TOL_TEMPO_STRETTA_MIN"])))
                else:
                    T.append(x)
        ab = abbina(F, T, C["TOL_TEMPO_STRETTA_MIN"], tol_pt) if td and td.get("righe") is not None else None
        # pendenti forward della sedia
        P = sorted([p for p in pend if p["sedia"] == s["id"]], key=lambda x: x["t_piazz"])
        P_avvio = [p for p in P if p["t_piazz"].date() < viva]
        P = [p for p in P if p["t_piazz"].date() >= viva]
        risultati.append(dict(sedia=s, F=F, T=T, esclusi=esclusi, ab=ab, P=P, giorni=giorni, tester=td, note_t=note_t,
                              F_avvio=F_avvio, P_avvio=P_avvio))
    return dict(risultati=risultati, manuali=manuali, note_fw=note_fw, giorni_tutti=giorni_tutti, cutoff_bcm=cutoff_bcm,
                cutoff_fw=cutoff_fw, pendenti=pend, Fpos=Fpos)


def sintesi_pooled(conf, C=COSTANTI):
    """Numeri aggregati + lettura meccanica (H_FEDELI / H_DIVERSI / INCONCLUSO). Solo sedie con tester leggibile e G1 ok."""
    nF = L1 = L2 = Tb = Ta = nT = 0
    delta_min = []
    for r in conf["risultati"]:
        if r["ab"] is None or not r["tester"].get("g1_ok", True):
            continue
        nF += len(r["F"])
        nT += len(r["T"])
        gior_pend = {(p["t_piazz"].date()) for p in r["P"] if p["stato"] in ("expired", "canceled")}
        for (i, j, lv, nota) in r["ab"]["coppie"]:
            if lv == "L1":
                L1 += 1
                L2 += 1
            else:
                L2 += 1
                delta_min.append(abs((r["F"][i]["t"] - r["T"][j]["t"]).total_seconds()) / 60.0)
        for j in r["ab"]["t_solo"]:
            if r["T"][j]["t"].date() in gior_pend:
                Ta += 1
            else:
                Tb += 1
    med = statistics.median(delta_min) if delta_min else None
    fed = nF > 0 and L2 >= C["H_FEDELI_L2_MIN"] * nF and L1 >= C["H_FEDELI_L1_MIN"] * nF and Tb <= C["H_FEDELI_TSOLO_B_MAX"] * nF
    ori = nF > 0 and L2 >= C["H_ORARI_L2_MIN"] * nF and L1 <= C["H_ORARI_L1_MAX"] * nF and med is not None and med >= C["H_ORARI_MEDIANA_MIN"]
    fre = nF > 0 and (L2 <= C["H_DIVERSI_L2_MAX"] * nF or Tb >= C["H_DIVERSI_TSOLO_B_MIN"] * nF)
    return dict(nF=nF, nT=nT, L1=L1, L2=L2, T_solo_a=Ta, T_solo_b=Tb, mediana_delta_min=med, fedeli=fed, orari=ori, freq=fre)


def etichetta_sedia(nF, nT, l1, l2, t_solo_b):
    """Etichetta per sedia (RFWD_CRITERI par. 5.4). Nessun verdetto: dice che cosa e' successo, non perche'."""
    if nF == 0 and nT == 0:
        return "ZERO CONTRO ZERO: coerente, ma NON falsificabile (senza operazioni non c'e' niente da riprodurre)"
    if nF == 0:
        return "FORWARD MUTO: il tester apre %d posizioni dove FTMO non ne ha aperta nessuna -> la differenza sta nel FORWARD (feed, Guardian, filtri, orari), non nel mercato" % nT
    if nT == 0:
        return "TESTER MUTO: FTMO ha aperto %d posizioni, il tester nessuna -> la differenza sta nel TESTER (feed BCM, dati, filtro) o nella sedia che li' non scatta" % nF
    if l2 == nF and l1 >= 0.5 * nF and t_solo_b == 0:
        return "RIPRODOTTA: ogni forward ha il gemello (L1 %d su %d), nessuna operazione del tester senza ordine forward" % (l1, nF)
    if l2 == nF and l1 >= 0.5 * nF:
        return "RIPRODOTTA CON ECCEDENZA: ogni forward ha il gemello (L1 %d su %d) ma il tester ha %d posizioni in giorni senza nessun ordine forward" % (l1, nF, t_solo_b)
    if l2 >= 0.5 * nF:
        return "PARZIALE: %d forward su %d hanno un gemello (L1 %d)" % (l2, nF, l1)
    return "DIVERSA: solo %d forward su %d hanno un gemello" % (l2, nF)


def lettura_770411(k1, k2, nF):
    """Cosa significano 0,1,2,3 riproduzioni per la 770411, come scritto in RFWD_CRITERI par. 5."""
    tab = {
        0: "0 riprodotte: il tester NON rifa nessuna delle 3 posizioni forward. E' il ramo 'orari, feed o codice diversi' "
           "(H_DIVERSI), a meno che il giorno non abbia dati (guardia storico) o il file sia nullo.",
        1: "1 riprodotta: misto. Non decide: si legge giorno per giorno (quale, e perche' le altre no).",
        2: "2 riprodotte: in gran parte fedele; le 2 esatte non bastano da sole a escludere il caso (par. 5), si guarda la terza.",
        3: "3 riprodotte: il tester rifa tutte e 3 le posizioni. La frequenza forward molto sopra il contratto OOS non "
           "dipende dai dati/orari/codice FTMO ma dal mercato o dal contratto (H_FEDELI).",
    }
    return tab.get(min(k1, 3), "n/d")


def prob_770411(r):
    """P(sovrapposizione per caso) per la 770411, con D = giorni feriali vivi e i giorni con posizione."""
    D = len(r["giorni"])
    dF = sorted({f["t"].date() for f in r["F"]})
    dT = sorted({t["t"].date() for t in r["T"]})
    ov = len(set(dF) & set(dT))
    return D, len(dF), len(dT), ov, p_sovrapposizione(D, len(dF), len(dT), ov)


# =====================================================================
#  REPORT
# =====================================================================
def _f(x, n=2):
    return ("%." + str(n) + "f") % x

def scrivi_report(conf, C, n_nullo, seed=20260930):
    L = []
    W = L.append
    W("CONFRONTO FORWARD FTMO 541452707 CONTRO TESTER BCM -- %s" % MARCATORE)
    W("Domanda: le sedie FTMO, rigiocate nel tester sui dati BCM negli stessi giorni, fanno le STESSE operazioni?")
    W("NON e' un backtest: nessun PF, nessuna promozione, nessuna taglia. Il tester non e' FTMO (feed, spread, slippage, rifiuti di modify).")
    W("Tutte le ore di questo referto sono ORA BCM (forward FTMO meno %d ore). Ultimo evento noto del forward: %s FTMO = %s BCM." %
      (C["DELTA_ORE"], fmt_dt(conf["cutoff_fw"]), fmt_dt(conf["cutoff_bcm"])))
    W("Il per-trade del tester ha SOLO uscite: gli abbinamenti sono sulle USCITE; i pendenti del tester sono NON OSSERVABILI.")
    W("Tolleranze dichiarate PRIMA dei numeri: uscita entro %d min, prezzo medio entro DAX %.0f / US30 %.0f / US100 %.0f punti, R entro %.2f." %
      (C["TOL_TEMPO_STRETTA_MIN"], C["TOL_PREZZO_DAX_PT"], C["TOL_PREZZO_US30_PT"], C["TOL_PREZZO_US100_PT"], C["TOL_R"]))
    W("Forward: %d posizioni di sedia + %d senza commento (manuali, fuori confronto). Note di parsing forward: %s" %
      (len(conf["Fpos"]), len(conf["manuali"]), "; ".join(conf["note_fw"]) or "nessuna"))
    for m in conf["manuali"]:
        W("   manuale (escluso): pos %d %s %s %.2f lotti, uscita %s BCM, netto %.2f" % (m["id"], m["sim"], m["dir"], m["vol"], fmt_dt(m["t"]), m["net"]))
    W("")
    righe_giorno = []
    righe_coppie = []
    for r in conf["risultati"]:
        s = r["sedia"]
        W("=" * 78)
        W("SEDIA %s  %s   tester: %s %s magic %d (gemello %d)   forward: %s" % (s["id"], s["nome"], s["ea"], s["sim_t"], s["magic"], s["twin"], s["sim_f"]))
        td = r["tester"]
        if not td or td.get("righe") is None:
            W("  PER-TRADE DEL TESTER: MANCANTE o illeggibile (%s). Nessun confronto per questa sedia: NON MISURATA." %
              (td.get("motivo") if td else "file non trovato"))
            W("  forward: %d posizioni, %d pendenti." % (len(r["F"]), len(r["P"])))
            continue
        W("  per-trade: %s  (%d righe di uscita, %d posizioni)  G1 gemello %d: %s" % (td["file"], len(td["righe"]), len(r["T"]) + len(r["esclusi"]),
                                                                              s["twin"], td.get("g1_txt", "n/d")))
        for n_ in r["note_t"]:
            W("  NOTA tester: " + n_)
        if not td.get("g1_ok", True):
            W("  G1 ROSSO: il gemello NON e' identico -> la sedia e' NULLA (esce da ogni conteggio di lettura).")
        W("  finestra viva: dal %s ; giorni feriali confrontati: %d (%s .. %s)" % (s["viva_da"], len(r["giorni"]),
          r["giorni"][0] if r["giorni"] else "-", r["giorni"][-1] if r["giorni"] else "-"))
        for (x, mot) in r["esclusi"]:
            W("  ESCLUSA dal confronto: tester pos %d %s uscita %s BCM netto %.2f -- %s" % (x["id"], x["dir"], fmt_dt(x["t"]), x["net"], mot))
        ab = r["ab"]
        F, T = r["F"], r["T"]
        W("  forward %d posizioni | tester %d posizioni (dentro finestra e cutoff) | tester per giorno %.2f | forward per giorno %.2f" %
          (len(F), len(T), len(T) / max(1, len(r["giorni"])), len(F) / max(1, len(r["giorni"]))))
        l1 = [c for c in ab["coppie"] if c[2] == "L1"]
        l2 = [c for c in ab["coppie"] if c[2] == "L2"]
        W("  ABBINATE: L1 (uscita stretta) %d | L2 (stesso giorno, non L1) %d | forward SENZA gemello %d | tester SENZA gemello %d" %
          (len(l1), len(l2), len(ab["f_solo"]), len(ab["t_solo"])))
        # etichetta di sedia (RFWD_CRITERI par. 5.4) e frequenza attesa dal contratto
        D = len(r["giorni"])
        fc = s.get("freq_contratto")
        etich = etichetta_sedia(len(F), len(T), len(l1), len(l1) + len(l2), sum(1 for j in ab["t_solo"] if not any(p["t_piazz"].date() == T[j]["t"].date() and p["stato"] in ("expired", "canceled") for p in r["P"])))
        W("  ETICHETTA DI SEDIA: %s" % etich)
        if fc is not None:
            W("  frequenza del contratto %.3f pos/giorno: attese su %d giorni %.1f posizioni; probabilita' di ZERO per pura sorte (Poisson) %.3f; osservate: forward %d, tester %d" %
              (fc, D, fc * D, math.exp(-fc * D), len(F), len(T)))
        # giorni e ipergeometrica
        dF = {f["t"].date() for f in F}
        dT = {t["t"].date() for t in T}
        ov = len(dF & dT)
        pch = p_sovrapposizione(D, len(dF), len(dT), ov) if D else float("nan")
        W("  GIORNI con posizione: forward %d, tester %d, in comune %d su %d feriali; probabilita' che la sovrapposizione sia >= %d per pura sorte "
          "(giorni tester a caso, ipergeometrica): %s" % (len(dF), len(dT), ov, D, ov, _f(pch, 3) if pch == pch else "n/d"))
        if len(F):
            W("  Se il tester fosse INDIPENDENTE, in media si sovrapporrebbero %.2f giorni (=%d x %d / %d)." % (len(dF) * len(dT) / max(1, D), len(dF), len(dT), D))
        # tabella per giorno
        W("  PER GIORNO (data BCM; F=forward, T=tester; pendenti forward: piazzati/scaduti/cancellati/attivi; nel tester NON OSSERVABILI):")
        W("    data        F  T  L1 L2 Fsolo Tsolo | pendenti forward")
        for g in r["giorni"]:
            nf = [i for i, f in enumerate(F) if f["t"].date() == g]
            nt = [j for j, t in enumerate(T) if t["t"].date() == g]
            n1 = sum(1 for c in l1 if F[c[0]]["t"].date() == g)
            n2 = sum(1 for c in l2 if F[c[0]]["t"].date() == g)
            fs = sum(1 for i in ab["f_solo"] if F[i]["t"].date() == g)
            ts = sum(1 for j in ab["t_solo"] if T[j]["t"].date() == g)
            pd_ = [p for p in r["P"] if p["t_piazz"].date() == g]
            desc = "; ".join("%s %s %s->%s%s" % (p["tipo"], _f(p["prezzo"], 2), p["t_piazz"].strftime("%H:%M"),
                              p["stato"], (" [" + p["base"][:9] + "]" if p["base"].startswith("INFERITA") else "")) for p in pd_) or "-"
            W("    %s  %d  %d  %d  %d  %d     %d    | %s" % (g, len(nf), len(nt), n1, n2, fs, ts, desc))
            righe_giorno.append([s["id"], str(g), len(nf), len(nt), n1, n2, fs, ts, len(pd_)])
        W("  COPPIE (forward vs tester):")
        for (i, j, lv, nota) in sorted(ab["coppie"], key=lambda c: F[c[0]]["t"]):
            f, t = F[i], T[j]
            dtm = (t["t"] - f["t"]).total_seconds() / 60.0
            dR = t["R"] - f["R"]
            W("    %s fw %s %s p=%s v=%.2f R=%s %s | ts %s p=%s v=%.2f R=%s %s | dt %+.1f min, dprezzo %+.2f, dR %+.2f, esito %s%s" %
              (lv, fmt_dt(f["t"]), f["dir"], _f(f["p"]), f["vol"], _f(f["R"]), f["tipo_u"], fmt_dt(t["t"]), _f(t["p"]), t["vol"], _f(t["R"]), t["tipo_u"],
               dtm, t["p"] - f["p"], dR, "UGUALE" if (f["tipo_u"] == t["tipo_u"] and abs(dR) <= C["TOL_R"]) else "DIVERSO",
               (" [" + nota + "]") if nota else ""))
            righe_coppie.append([s["id"], lv, fmt_dt(f["t"]), fmt_dt(t["t"]), _f(dtm, 1), _f(t["p"] - f["p"]), _f(f["R"]), _f(t["R"]), f["tipo_u"], t["tipo_u"], nota])
        for i in ab["f_solo"]:
            f = F[i]
            W("    F_SOLO fw %s %s p=%s v=%.2f R=%s %s  (nessun gemello nel tester)" % (fmt_dt(f["t"]), f["dir"], _f(f["p"]), f["vol"], _f(f["R"]), f["tipo_u"]))
            righe_coppie.append([s["id"], "F_SOLO", fmt_dt(f["t"]), "", "", "", _f(f["R"]), "", f["tipo_u"], "", ""])
        for j in ab["t_solo"]:
            t = T[j]
            W("    T_SOLO ts %s %s p=%s v=%.2f R=%s %s  (nessun gemello nel forward%s)" % (fmt_dt(t["t"]), t["dir"], _f(t["p"]), t["vol"], _f(t["R"]), t["tipo_u"],
              "; quel giorno il forward ha piazzato un pendente non riempito" if any(p["t_piazz"].date() == t["t"].date() and p["stato"] in ("expired", "canceled") for p in r["P"]) else ""))
            righe_coppie.append([s["id"], "T_SOLO", "", fmt_dt(t["t"]), "", "", "", _f(t["R"]), "", t["tipo_u"], ""])
        if r["P_avvio"] or r["F_avvio"]:
            W("  GIORNO DI AVVIO (prima del %s, fuori dal confronto): forward posizioni %d, pendenti: %s" % (FINESTRA_UFFICIALE_DA, len(r["F_avvio"]),
              "; ".join("%s %s %s->%s" % (p["tipo"], _f(p["prezzo"]), p["t_piazz"].strftime("%m.%d %H:%M"), p["stato"]) for p in r["P_avvio"]) or "nessuno"))
        if r["P"]:
            W("  PENDENTI del forward per questa sedia (nel tester NON OSSERVABILI, il per-trade non ha i pendenti):")
            for p in r["P"]:
                W("    %s %s %s prezzo %s piazzato %s BCM, %s%s   [attribuzione: %s]" % (p["id"], p["tipo"], p["sim"], _f(p["prezzo"]), fmt_dt(p["t_piazz"]), p["stato"],
                  (" " + fmt_dt(p["t_fine"])) if p["t_fine"] else "", p["base"]))
        if s["id"] == "770411":
            k1 = len(l1)
            k2 = len(l1) + len(l2)
            W("  >>> 770411, CASO GUIDA: posizioni forward %d, riprodotte a L1: %d, a L2 (stesso giorno): %d." % (len(F), k1, k2))
            W("  >>> " + lettura_770411(k1, k2, len(F)))
        W("")
    # aggregato
    S = sintesi_pooled(conf, C)
    W("=" * 78)
    W("SINTESI (solo sedie con tester leggibile e G1 ok)")
    W("  posizioni forward nel confronto: %d | tester: %d | L1 %d (%.0f%%) | L1+L2 %d (%.0f%%) | T_SOLO con pendente forward non riempito quel giorno %d | T_SOLO senza nessun ordine forward %d" %
      (S["nF"], S["nT"], S["L1"], 100.0 * S["L1"] / max(1, S["nF"]), S["L2"], 100.0 * S["L2"] / max(1, S["nF"]), S["T_solo_a"], S["T_solo_b"]))
    W("  scarto orario mediano delle coppie L2 (non L1): %s min" % ("n/d" if S["mediana_delta_min"] is None else _f(S["mediana_delta_min"], 1)))
    # esiti e R sulle coppie
    ug = di = sc = sr = 0
    for r in conf["risultati"]:
        if r["ab"] is None or not r["tester"].get("g1_ok", True):
            continue
        for (i, j, lv, nota) in r["ab"]["coppie"]:
            f, t = r["F"][i], r["T"][j]
            a = f["tipo_u"] == t["tipo_u"]
            b = abs(t["R"] - f["R"]) <= C["TOL_R"]
            sc += 1 if a else 0
            sr += 1 if b else 0
            if a and b:
                ug += 1
            else:
                di += 1
    W("  su %d coppie (L1+L2): stessa classe di uscita %d ; R entro %.2f %d ; ENTRAMBE %d ; almeno una diversa %d" % (ug + di, sc, C["TOL_R"], sr, ug, di))
    # nullo
    dati = []
    for r in conf["risultati"]:
        if r["ab"] is None or not r["tester"].get("g1_ok", True):
            continue
        dati.append(dict(F=r["F"], nT=len(r["T"]), giorni=r["giorni"], orario=((0, 24) if r["sedia"]["chiusura_bcm"] is None else (8, 17))))
    nul = simula_nullo(dati, n_nullo, seed, C["TOL_TEMPO_STRETTA_MIN"]) if dati and S["nF"] else None
    if nul:
        W("  CONTROESEMPIO (tester INDIPENDENTE dal forward, %d permutazioni, seme %d, stesso numero di posizioni tester): L1 attesa %.0f%% (p95 %.0f%%), "
          "L1+L2 attesa %.0f%% (p95 %.0f%%)." % (n_nullo, seed, 100 * nul[0], 100 * nul[1], 100 * nul[2], 100 * nul[3]))
        ok1 = C["H_FEDELI_L1_MIN"] > nul[1]
        ok2 = C["H_FEDELI_L2_MIN"] > nul[3]
        W("  Soglie H_FEDELI: L1 >= %.0f%% (%s il p95 del nullo), L1+L2 >= %.0f%% (%s il p95 del nullo)%s" %
          (100 * C["H_FEDELI_L1_MIN"], "SOPRA" if ok1 else "NON sopra", 100 * C["H_FEDELI_L2_MIN"], "SOPRA" if ok2 else "NON sopra",
           "" if (ok1 and ok2) else "  -> ATTENZIONE: BANDA CHE NON DISCRIMINA (cade uguale se il tester fosse indipendente)"))
    W("  LETTURA MECCANICA (soglie in RFWD_CRITERI, congelate prima dei numeri; e' una descrizione, non un verdetto):")
    W("    H_FEDELI  (L1+L2 >= %.0f%%, L1 >= %.0f%%, T_SOLO senza ordine forward <= %.0f%%): %s" % (100 * C["H_FEDELI_L2_MIN"], 100 * C["H_FEDELI_L1_MIN"], 100 * C["H_FEDELI_TSOLO_B_MAX"], "SI" if S["fedeli"] else "no"))
    W("    H_DIVERSI, ORARI (L1+L2 >= %.0f%%, L1 <= %.0f%%, mediana scarto >= %d min): %s" % (100 * C["H_ORARI_L2_MIN"], 100 * C["H_ORARI_L1_MAX"], C["H_ORARI_MEDIANA_MIN"], "SI" if S["orari"] else "no"))
    W("    H_DIVERSI, FREQUENZA (L1+L2 <= %.0f%% oppure T_SOLO senza ordine forward >= %.0f%% dei forward): %s" % (100 * C["H_DIVERSI_L2_MAX"], 100 * C["H_DIVERSI_TSOLO_B_MIN"], "SI" if S["freq"] else "no"))
    W("    ESITO: %s" % ("INCONCLUSO (nessuna delle tre soglie)" if not (S["fedeli"] or S["orari"] or S["freq"]) else
                       ("H_FEDELI" if S["fedeli"] and not (S["orari"] or S["freq"]) else "SEGNALI MULTIPLI: " + ", ".join(n for n, v in (("H_FEDELI", S["fedeli"]), ("H_DIVERSI_ORARI", S["orari"]), ("H_DIVERSI_FREQ", S["freq"])) if v))))
    W("")
    W("NON SI PUO' CONCLUDERE: cosa fa FTMO con i suoi feed, spread, slippage e rifiuti di modify; cosa farebbe il tester con un altro regime; niente sul merito. Campione: 13 giorni-sedia al massimo, un solo regime (estate, ora legale).")
    return "\n".join(L) + "\n", righe_giorno, righe_coppie, S


# =====================================================================
#  CARICAMENTO DEI FILE DEL TESTER
# =====================================================================
def carica_tester(cartella):
    """Cerca abtg_trades_<EA>_<SIM>_<magic>.csv per ogni sedia (e il suo gemello). Ritorna dict id -> dati."""
    trovati = {}
    for root, _d, files in os.walk(cartella):
        for f in files:
            trovati[f] = os.path.join(root, f)
    out = {}
    for s in SEDIE:
        nome = "abtg_trades_%s_%s_%d.csv" % (s["ea"], s["sim_t"], s["magic"])
        nome_tw = "abtg_trades_%s_%s_%d.csv" % (s["ea"], s["sim_t"], s["twin"])
        if nome not in trovati:
            out[s["id"]] = dict(righe=None, motivo="file %s non trovato in %s" % (nome, cartella))
            continue
        righe, note = leggi_pertrade(trovati[nome])
        if righe is None:
            out[s["id"]] = dict(righe=None, motivo="; ".join(note))
            continue
        d = dict(righe=righe, file=nome, note=note, g1_ok=True, g1_txt="gemello non trovato (G1 non verificato)")
        bad = [r for r in righe if r["magic"] != s["magic"] or r["sim"] != s["sim_t"]]
        if bad:
            d["g1_ok"] = False
            d["g1_txt"] = "ROSSO: %d righe con magic o simbolo diversi dal file (P0)" % len(bad)
        if nome_tw in trovati:
            rg2, _n2 = leggi_pertrade(trovati[nome_tw])
            if rg2 is None:
                d["g1_ok"] = False
                d["g1_txt"] = "ROSSO: gemello illeggibile"
            else:
                a = [(x["t"], x["pid"], x["tipo"], x["vol"], x["p"], round(x["net"], 2)) for x in righe]
                b = [(x["t"], x["pid"], x["tipo"], x["vol"], x["p"], round(x["net"], 2)) for x in rg2]
                if a == b and d["g1_ok"]:
                    d["g1_txt"] = "ok (%d righe identiche)" % len(a)
                elif a != b:
                    d["g1_ok"] = False
                    d["g1_txt"] = "ROSSO: gemello DIVERSO (%d contro %d righe)" % (len(a), len(b))
        # direzione inattesa
        if s["dir"] in ("L", "S"):
            atteso = 1 if s["dir"] == "L" else 0
            strani = [r for r in righe if r["tipo"] != atteso]
            if strani:
                d["g1_ok"] = False
                d["g1_txt"] += " ; DIREZIONE INATTESA in %d righe (sedia solo %s)" % (len(strani), "long" if s["dir"] == "L" else "short")
        out[s["id"]] = d
    return out


# =====================================================================
#  AUTOTEST -- casi sintetici e CONTROESEMPI costruiti prima di fidarsi dello strumento
# =====================================================================
def _pos(dir_, t, p, vol=1.0, net=0.0, R=0.0, legs=1):
    return dict(dir=dir_, t=dt_parse(t), p=p, vol=vol, net=net, R=R, legs=[dict()] * legs)

class _T:
    def __init__(self):
        self.n = 0
        self.ok = 0
        self.fail = []
    def check(self, cond, nome):
        self.n += 1
        if cond:
            self.ok += 1
        else:
            self.fail.append(nome)
            print("  FALLITO: " + nome)

def autotest(forward_path=None, criteri_path=None):
    T = _T()
    tol, pt = 15, 20.0
    # 1 abbinamento perfetto
    r = abbina([_pos("S", "2026.09.24 08:14:49", 25350.0)], [_pos("S", "2026.09.24 08:14:49", 25350.0)], tol, pt)
    T.check(r["coppie"] == [(0, 0, "L1", "")] and not r["f_solo"] and not r["t_solo"], "1 perfetto -> L1")
    # 2 forward senza gemello
    r = abbina([_pos("S", "2026.09.24 08:14:49", 25350.0)], [], tol, pt)
    T.check(r["f_solo"] == [0] and not r["coppie"], "2 forward senza gemello -> F_SOLO")
    # 3 tester in piu'
    r = abbina([], [_pos("S", "2026.09.24 08:14:49", 25350.0)], tol, pt)
    T.check(r["t_solo"] == [0] and not r["coppie"], "3 tester in piu' -> T_SOLO")
    # 4 bordo del tempo: 15:00 esatti dentro, 15:01 fuori (ma stesso giorno -> L2)
    r = abbina([_pos("S", "2026.09.24 08:00:00", 100.0)], [_pos("S", "2026.09.24 08:15:00", 100.0)], tol, pt)
    T.check(r["coppie"][0][2] == "L1", "4a bordo tempo 15:00 -> L1")
    r = abbina([_pos("S", "2026.09.24 08:00:00", 100.0)], [_pos("S", "2026.09.24 08:15:01", 100.0)], tol, pt)
    T.check(r["coppie"][0][2] == "L2", "4b bordo tempo 15:01 -> L2, non L1")
    # 5 bordo del prezzo: 20.00 dentro, 20.01 fuori
    r = abbina([_pos("S", "2026.09.24 08:00:00", 100.0)], [_pos("S", "2026.09.24 08:00:00", 120.0)], tol, pt)
    T.check(r["coppie"][0][2] == "L1", "5a bordo prezzo 20.00 -> L1")
    r = abbina([_pos("S", "2026.09.24 08:00:00", 100.0)], [_pos("S", "2026.09.24 08:00:00", 120.01)], tol, pt)
    T.check(r["coppie"][0][2] == "L2", "5b bordo prezzo 20.01 -> L2")
    # 6 CONTROESEMPIO DELL'ORARIO: tester con orologio sfasato +60 e +120 min NON e' L1, ma e' L2 (stesso giorno)
    for sh in (60, 120):
        t2 = (dt_parse("2026.09.24 08:14:49") + datetime.timedelta(minutes=sh)).strftime("%Y.%m.%d %H:%M:%S")
        r = abbina([_pos("S", "2026.09.24 08:14:49", 25350.0)], [_pos("S", t2, 25350.0)], tol, pt)
        T.check(r["coppie"][0][2] == "L2", "6 orologio sfasato +%d min -> L2 e non L1 (la banda vede il difetto)" % sh)
    # 7 direzione opposta: nessun abbinamento nemmeno L2
    r = abbina([_pos("S", "2026.09.24 08:00:00", 100.0)], [_pos("L", "2026.09.24 08:00:00", 100.0)], tol, pt)
    T.check(not r["coppie"] and r["f_solo"] == [0] and r["t_solo"] == [0], "7 direzione opposta -> niente")
    # 8 giorno diverso: niente L2
    r = abbina([_pos("S", "2026.09.24 08:00:00", 100.0)], [_pos("S", "2026.09.25 08:00:00", 100.0)], tol, pt)
    T.check(not r["coppie"], "8 giorno diverso -> niente")
    # 9 ambiguita': un forward, due tester entro tolleranza -> NON L1 silenzioso, L2 con nota AMBIGUA, l'altro T_SOLO
    r = abbina([_pos("S", "2026.09.24 08:10:00", 100.0, vol=1.0)], [_pos("S", "2026.09.24 08:10:00", 100.0, vol=1.0), _pos("S", "2026.09.24 08:12:00", 101.0, vol=1.0)], tol, pt)
    T.check(len(r["coppie"]) == 1 and r["coppie"][0][2] == "L2" and "AMBIGUA" in r["coppie"][0][3] and len(r["t_solo"]) == 1,
            "9 ambiguita' 1-a-2 -> L2 AMBIGUA + un T_SOLO")
    # 10 due forward + due tester (S1/S2 stessa uscita): sciolti per rango di volume, L1 con nota
    F = [_pos("S", "2026.09.22 14:45:51", 52265.0, vol=9.11), _pos("S", "2026.09.22 14:45:51", 52265.0, vol=13.67)]
    Tt = [_pos("S", "2026.09.22 14:45:51", 52270.0, vol=8.0), _pos("S", "2026.09.22 14:45:51", 52270.0, vol=12.0)]
    r = abbina(F, Tt, tol, 60.0)
    T.check(len(r["coppie"]) == 2 and all(c[2] == "L1" for c in r["coppie"]) and {(c[0], c[1]) for c in r["coppie"]} == {(0, 0), (1, 1)},
            "10 S1/S2 due-a-due sciolti per rango di volume")
    # 11 stesso caso ma volumi UGUALI sul tester -> non si scioglie: L2 AMBIGUA
    Tt = [_pos("S", "2026.09.22 14:45:51", 52270.0, vol=10.0), _pos("S", "2026.09.22 14:45:51", 52270.0, vol=10.0)]
    r = abbina(F, Tt, tol, 60.0)
    T.check(all(c[2] == "L2" for c in r["coppie"]) and len(r["coppie"]) == 2, "11 volumi tester uguali -> ambiguita' non sciolta (L2)")
    # 12 ipergeometrica contro valori fatti a mano
    T.check(abs(p_sovrapposizione(7, 3, 3, 3) - 1.0 / 35.0) < 1e-12, "12a P(3 su 3 fra 7 giorni) = 1/35")
    T.check(abs(p_sovrapposizione(7, 3, 3, 2) - 13.0 / 35.0) < 1e-12, "12b P(>=2) = 13/35")
    T.check(abs(p_sovrapposizione(7, 3, 3, 0) - 1.0) < 1e-12, "12c P(>=0) = 1")
    # 13 uscite: regola simmetrica
    C = COSTANTI
    T.check(tipo_uscita(dict(t=dt_parse("2026.09.24 08:14:49"), legs=[1], R=-1.03), (17, 30)) == "STOP", "13a stop pieno")
    T.check(tipo_uscita(dict(t=dt_parse("2026.09.24 08:14:49"), legs=[1], R=0.04), (17, 30)) == "TRAIL_STRETTO", "13b trail stretto")
    T.check(tipo_uscita(dict(t=dt_parse("2026.09.29 08:22:29"), legs=[1, 2], R=0.65), (17, 30)) == "PARZ+RESTO_BASSO", "13c parziale + resto basso")
    T.check(tipo_uscita(dict(t=dt_parse("2026.09.24 17:30:05"), legs=[1], R=0.10), (17, 30)) == "ORARIO", "13d chiusura d'orario")
    T.check(tipo_uscita(dict(t=dt_parse("2026.09.24 17:41:00"), legs=[1], R=0.10), (17, 30)) == "TRAIL_STRETTO", "13e 11 minuti dopo la chiusura non e' d'orario")
    # 14 per-trade: gruppi per position_id, direzione dal deal di uscita
    rg = [dict(t=dt_parse("2026.09.24 08:10:00"), sim="D30EUR", magic=1, pid=7, tipo=0, vol=1.0, p=100.0, net=50.0),
          dict(t=dt_parse("2026.09.24 08:20:00"), sim="D30EUR", magic=1, pid=7, tipo=0, vol=1.0, p=110.0, net=-10.0)]
    sd = dict(id="X", rischio=2.0)
    px, _n = posizioni_tester(rg, sd, 80000.0)
    T.check(len(px) == 1 and px[0]["dir"] == "S" and abs(px[0]["p"] - 105.0) < 1e-9 and abs(px[0]["net"] - 40.0) < 1e-9 and px[0]["t"] == dt_parse("2026.09.24 08:20:00"),
            "14 per-trade: 2 gambe -> 1 posizione, direzione dal deal di uscita, prezzo medio, ultima uscita")
    T.check(abs(px[0]["R"] - 40.0 / 1600.0) < 1e-12, "14b R nominale = netto / (2% x 80000)")
    # 15 controesempio DEL NULLO: con tester indipendente e stesso numero di posizioni, L1 attesa bassa, e le soglie di casa la superano
    dati = [dict(F=[_pos("S", "2026.09.%02d 08:%02d:00" % (d, m), 100.0) for d, m in ((24, 2), (29, 5), (30, 3))], nT=3,
                 giorni=giorni_feriali(datetime.date(2026, 9, 22), datetime.date(2026, 9, 30)), orario=(8, 17))]
    nul = simula_nullo(dati, 400, 1, 15)
    T.check(nul is not None and nul[1] < COSTANTI["H_FEDELI_L1_MIN"] and nul[3] < 1.0 + 1e-9, "15 nullo: p95 di L1 sotto la soglia L1 di H_FEDELI")
    # 15b etichette di sedia: ogni ramo
    T.check(etichetta_sedia(0, 0, 0, 0, 0).startswith("ZERO CONTRO ZERO"), "15b1 etichetta 0 contro 0")
    T.check(etichetta_sedia(0, 2, 0, 0, 2).startswith("FORWARD MUTO"), "15b2 etichetta forward muto")
    T.check(etichetta_sedia(3, 0, 0, 0, 0).startswith("TESTER MUTO"), "15b3 etichetta tester muto")
    T.check(etichetta_sedia(3, 3, 3, 3, 0).startswith("RIPRODOTTA:"), "15b4 etichetta riprodotta")
    T.check(etichetta_sedia(3, 4, 2, 3, 1).startswith("RIPRODOTTA CON ECCEDENZA"), "15b5 etichetta riprodotta con eccedenza")
    T.check(etichetta_sedia(4, 4, 1, 2, 0).startswith("PARZIALE"), "15b6 etichetta parziale")
    T.check(etichetta_sedia(4, 4, 0, 1, 0).startswith("DIVERSA"), "15b7 etichetta diversa")
    # 16 il xlsx vero, se dato: numeri GIA' scritti da altri (report/FTMO_PRIMI_OTTO_GIORNI_2026-09-30.md)
    if forward_path:
        fw = parse_forward(leggi_xlsx(forward_path))
        Fp, man, note = posizioni_forward(fw, COSTANTI["DELTA_ORE"], COSTANTI["SALDO_INIZIALE"])
        T.check(len(fw["posizioni"]) == 13, "16a forward: 13 posizioni chiuse (report primi otto giorni)")
        somma = sum(p["profit"] + (p["comm"] or 0) + (p["swap"] or 0) for p in fw["posizioni"])
        T.check(abs(somma - (-7002.99)) < 0.02, "16b somma netta (profitto+commissioni+swap) = -7.002,99")
        per = {}
        for p in Fp:
            per.setdefault(p["sedia"], []).append(p)
        def somma_ids(ids):
            return sum(p["net"] for i in ids for p in per.get(i, []))
        T.check(len(man) == 2, "16c due posizioni senza commento (oro manuale)")
        T.check(len(per.get("770411", [])) == 3 and abs(somma_ids(["770411"]) - (-2236.00)) < 0.02, "16d 770411: 3 posizioni, -2.236,00")
        T.check(len(per.get("770101", [])) + len(per.get("770105", [])) == 5 and abs(somma_ids(["770101", "770105"]) - (-1258.07)) < 0.02, "16e DAX Apertura: 5 posizioni, -1.258,07")
        T.check(len(per.get("771531", [])) == 3 and abs(somma_ids(["771531"]) - (-1006.86)) < 0.03, "16f EMA200: 3 posizioni, -1.006,86 (netto degli swap)")
        T.check(sum(len(v) for v in per.values()) == 11, "16g flotta: 11 posizioni")
        T.check(len(per.get("770105", [])) == 1 and per["770105"][0]["t"].date() == datetime.date(2026, 9, 28), "16h 770105: una sola posizione, il 28/09")
        T.check(all(p["legs"] for p in Fp) and not note, "16i gambe di uscita quadrano con volume e profitto (nessuna nota)")
        e2 = sorted([p for p in per["771531"]], key=lambda p: p["t"])
        T.check(all(p["tipo_u"] == "STOP" for p in e2[:2]) if all("tipo_u" in p for p in e2) else all(p["R"] <= -0.7 for p in e2[:2]),
                "16i2 EMA200 del 22/09: due stop pieni (R nominale con rischio 1%% per ordine: %s)" % ["%.2f" % p["R"] for p in e2[:2]])
        pm = [p for p in per["770411"] if p["t"].date() == datetime.date(2026, 9, 29)][0]
        T.check(len(pm["legs"]) == 2 and abs(pm["R"] - 0.65) < 0.06, "16j 770411 del 29/09: 2 gambe, R nominale ~ +0,65 (report: +0,65 R)")
        pmn = [p for p in per["770411"] if p["t"].date() == datetime.date(2026, 9, 24)][0]
        T.check(abs(pmn["R"] - (-1.03)) < 0.06, "16k 770411 del 24/09: R nominale ~ -1,03 (report: -1,03 R)")
        pd_ = pendenti_forward(fw, 2)
        canc = [p for p in pd_ if p["stato"] == "canceled"]
        T.check(len(canc) == 1 and canc[0]["sedia"] == "770411" and canc[0]["t_piazz"] == dt_parse("2026.09.25 07:59:00"), "16l 25/09: il sell stop della 770411 e' 'canceled', piazzato 07:59 BCM")
        T.check(fw["ultimo_evento"] == dt_parse("2026.09.30 10:03:09"), "16m ultimo evento del forward = 30/09 10:03:09 FTMO")
        # ordine dei controlli reali: ipotesi alternativa dell'orologio sul forward vero (sfasando il delta di un'ora le uscite cambiano data o ora)
        Fp1, _m1, _n1 = posizioni_forward(fw, 3, COSTANTI["SALDO_INIZIALE"])
        T.check([p["t"] for p in Fp] != [p["t"] for p in Fp1], "16n delta 2 contro delta 3: le ore convertite cambiano (il delta e' usato davvero)")
    # 17 le COSTANTI coincidono col blocco di RFWD_CRITERI.md, se il file e' dato
    if criteri_path and os.path.exists(criteri_path):
        blocco = {}
        dentro = False
        for l in open(criteri_path, encoding="utf-8", errors="replace"):
            if "RFWD_COSTANTI_BEGIN" in l:
                dentro = True
                continue
            if "RFWD_COSTANTI_END" in l:
                dentro = False
                continue
            if dentro and "=" in l:
                k, v = l.strip().split("=", 1)
                blocco[k.strip()] = v.strip()
        diff = [k for k in COSTANTI if k not in blocco or abs(float(blocco[k]) - float(COSTANTI[k])) > 1e-9]
        extra = [k for k in blocco if k not in COSTANTI]
        T.check(not diff and not extra, "17 le COSTANTI coincidono col blocco RFWD_COSTANTI di RFWD_CRITERI.md (diverse: %s; in piu' nel md: %s)" % (diff, extra))
    print("AUTOTEST: %d/%d" % (T.ok, T.n))
    return T.ok == T.n


def main():
    ap = argparse.ArgumentParser(description=__doc__, formatter_class=argparse.RawDescriptionHelpFormatter)
    ap.add_argument("--autotest", action="store_true")
    ap.add_argument("--forward")
    ap.add_argument("--pertrade")
    ap.add_argument("--uscita")
    ap.add_argument("--delta-ore", type=int, default=COSTANTI["DELTA_ORE"])
    ap.add_argument("--cutoff-forward", help="ultimo evento noto del forward, ORA FTMO 'AAAA.MM.GG HH:MM:SS' (default: l'ultimo evento del file)")
    ap.add_argument("--nullo", type=int, default=2000)
    ap.add_argument("--criteri", help="report/RFWD_CRITERI.md, per il controllo delle COSTANTI dentro l'autotest")
    a = ap.parse_args()
    if a.autotest:
        ok = autotest(a.forward, a.criteri)
        sys.exit(0 if ok else 1)
    if not (a.forward and a.pertrade and a.uscita):
        ap.error("servono --forward, --pertrade e --uscita (oppure --autotest)")
    C = dict(COSTANTI)
    C["DELTA_ORE"] = a.delta_ore
    fw = parse_forward(leggi_xlsx(a.forward))
    cutoff = dt_parse(a.cutoff_forward) if a.cutoff_forward else fw["ultimo_evento"]
    tester = carica_tester(a.pertrade)
    conf = esegui_confronto(fw, tester, a.delta_ore, cutoff, C, a.nullo)
    testo, gg, cp, S = scrivi_report(conf, C, a.nullo)
    os.makedirs(a.uscita, exist_ok=True)
    with open(os.path.join(a.uscita, "CONFRONTO_FORWARD_TESTER.txt"), "w", encoding="ascii", errors="replace") as f:
        f.write(testo)
    with open(os.path.join(a.uscita, "CONFRONTO_FORWARD_TESTER_PERGIORNO.csv"), "w", newline="") as f:
        w = csv.writer(f)
        w.writerow(["sedia", "giorno_bcm", "forward", "tester", "L1", "L2", "F_solo", "T_solo", "pendenti_forward"])
        w.writerows(gg)
    with open(os.path.join(a.uscita, "CONFRONTO_FORWARD_TESTER_COPPIE.csv"), "w", newline="") as f:
        w = csv.writer(f)
        w.writerow(["sedia", "livello", "uscita_forward_bcm", "uscita_tester_bcm", "dt_min", "dprezzo", "R_fw", "R_ts", "esito_fw", "esito_ts", "nota"])
        w.writerows(cp)
    print(testo)
    sys.exit(0)


if __name__ == "__main__":
    main()
