#!/usr/bin/env python3
# -*- coding: ascii -*-
"""
prova_pins.py -- legge i DEFAULT compilati di mql5/Experts/EA_NatCla.mq5 e il file prova del PASSO 0 (F0), e (con --scrivi) scrive la parte "pin" del file prova.
Serve a due cose, tutte e due controllabili a macchina:
  1. i pin del file prova sono IDENTICI ai default del sorgente tranne le deviazioni DICHIARATE qui sotto (DEVIAZIONI): niente input "dimenticato", niente
     input col nome sbagliato (MT5 ignora in silenzio un nome che l'EA non ha);
  2. i blocchi leggibili a macchina in commento (# @F0-CONFIG / # @F0-SIMBOLO / # @F0-LOTTO) sono la SOLA fonte di simboli, finestre, configurazioni e lotti per il
     driver (NATCLA_F0_PASSATE.ps1) e per il lettore (leggi_natcla_f0.py): nessuna lista doppia da tenere allineata a mano.
Uso:  python3 prova_pins.py --verifica [prova.txt]      (controlla; esce 1 se trova qualcosa)
      python3 prova_pins.py --pin                       (stampa i pin dai default del sorgente, per scrivere il file prova)
"""
import os, re, sys

QD = os.path.dirname(os.path.abspath(__file__))
REPO = os.path.abspath(os.path.join(QD, "..", ".."))
EA = os.path.join(REPO, "mql5", "Experts", "EA_NatCla.mq5")
PROVA = os.path.join(REPO, "backtest_pipeline", "prove", "NATCLA_F0_conteggio_2026-10-07.txt")

PERIODI = {"PERIOD_CURRENT": 0, "PERIOD_M1": 1, "PERIOD_M5": 5, "PERIOD_M15": 15, "PERIOD_M30": 30, "PERIOD_H1": 16385, "PERIOD_H2": 16386, "PERIOD_H3": 16387,
           "PERIOD_H4": 16388, "PERIOD_H6": 16390, "PERIOD_H8": 16392, "PERIOD_H12": 16396, "PERIOD_D1": 16408, "PERIOD_W1": 32769, "PERIOD_MN1": 49153}

# Le SOLE deviazioni del file prova dai default compilati (valore da scrivere nel file prova)
DEVIAZIONI = {
    "InpSoloConta": "true",     # il passo 0 e' una SONDA: valuta tutto, scrive i setup nel CSV, NON manda ordini
    "InpTF": "16385",           # configurazione base AUDIO_H1: il driver la sostituisce a ogni passata con quella del @F0-CONFIG
    "InpModalita": "0",         # idem (0 = AUDIO)
    # InpMagic e' l'ASSE TECNICO (v||start||step||stop||Y): non e' un pin, vedi ASSE_TECNICO
}
ASSE_TECNICO = "InpMagic=0||0||1||1||Y"   # 2 celle (0 = magic automatico, 1 = fuori blocco: la 2a cella e' un rifiuto garantito dell'EA). Il driver di passata singola usa il PRIMO valore.


def enum_valori(testo):
    """nome del membro -> valore, per tutti gli enum dichiarati nel sorgente"""
    val = dict(PERIODI)
    for m in re.finditer(r"enum\s+(\w+)\s*\{(.*?)\}", testo, flags=re.S):
        corpo = re.sub(r"/\*.*?\*/", "", m.group(2), flags=re.S)
        corpo = re.sub(r"//[^\r\n]*", "", corpo)
        prossimo = 0
        for pezzo in corpo.split(","):
            p = pezzo.strip()
            if not p:
                continue
            mm = re.match(r"^(\w+)\s*=\s*(-?\d+)", p)
            if mm:
                v = int(mm.group(2)); nome = mm.group(1)
            else:
                nome = re.match(r"^(\w+)", p).group(1); v = prossimo
            prossimo = v + 1
            val[nome] = v
    return val


def default_ea(percorso=EA):
    """lista ordinata [(nome, tipo, default_testuale_per_il_tester)]"""
    testo = open(percorso, encoding="utf-8", errors="replace").read()
    ev = enum_valori(testo)
    out = []
    for m in re.finditer(r"^input\s+([A-Za-z_][\w:]*)\s+(\w+)\s*=\s*([^;]+);", testo, flags=re.M):
        tipo, nome, dflt = m.group(1), m.group(2), m.group(3).strip()
        if tipo == "bool":
            v = dflt
            assert v in ("true", "false"), (nome, v)
        elif tipo == "string":
            mm = re.match(r'^"(.*)"$', dflt)
            assert mm, (nome, dflt)
            v = mm.group(1)
        elif tipo in ("int", "long", "double", "uint", "ulong"):
            assert re.match(r"^-?[0-9]+(\.[0-9]+)?$", dflt), (nome, dflt)
            v = dflt
        else:   # enum
            assert dflt in ev, (nome, tipo, dflt)
            v = str(ev[dflt])
        out.append((nome, tipo, v))
    return out


def leggi_prova(percorso=PROVA):
    """pin, assi, direttive e blocchi F0 del file prova"""
    r = dict(pin=[], assi=[], direttive={}, config=[], simboli=[], lotti=[], marker_da="", righe_vive=[])
    for l in open(percorso, encoding="ascii").read().splitlines():
        t = l.strip()
        m = re.match(r"^#\s*@F0-(CONFIG|SIMBOLO|LOTTO)\s+(.*)$", t)
        if m:
            kv = {}
            for pezzo in m.group(2).split():
                a, b = pezzo.split("=", 1)
                assert a not in kv, ("chiave doppia", t)
                kv[a] = b
            r[{"CONFIG": "config", "SIMBOLO": "simboli", "LOTTO": "lotti"}[m.group(1)]].append(kv)
            continue
        m = re.match(r"^#\s*@DAQUANDO-DALLA-RIGA\s+(.+)$", t)
        if m:
            r["marker_da"] = m.group(1).strip()
            continue
        if not t or t.startswith("#"):
            continue
        r["righe_vive"].append(t)
        m = re.match(r"^@(\w+)\s+(.+)$", t)
        if m:
            r["direttive"][m.group(1).upper()] = m.group(2).strip()
            continue
        m = re.match(r"^(Inp[A-Za-z0-9_]+)=(.*)$", t)
        if m:
            if t.endswith("||Y"):
                r["assi"].append(t)
            else:
                r["pin"].append((m.group(1), m.group(2)))
            continue
        raise AssertionError("riga viva non riconosciuta nel file prova: " + t)
    return r


def verifica(percorso=PROVA, ea=EA):
    """ritorna la lista dei problemi (vuota = OK)"""
    pr = []
    d = default_ea(ea)
    p = leggi_prova(percorso)
    pin = dict(p["pin"])
    if len(pin) != len(p["pin"]):
        pr.append("pin doppi nel file prova")
    nomi_ea = [x[0] for x in d]
    if len(set(nomi_ea)) != len(nomi_ea):
        pr.append("nomi di input doppi nel sorgente?")
    if p["assi"] != [ASSE_TECNICO]:
        pr.append("asse tecnico atteso %s, trovato %s" % (ASSE_TECNICO, p["assi"]))
    attesi = {}
    for nome, tipo, v in d:
        if nome == "InpMagic":
            continue
        attesi[nome] = DEVIAZIONI.get(nome, v)
    if set(pin) != set(attesi):
        pr.append("input diversi dal sorgente: mancano %s, in piu' %s" % (sorted(set(attesi) - set(pin)), sorted(set(pin) - set(attesi))))
    for k, v in attesi.items():
        if k in pin and pin[k] != v:
            pr.append("pin %s = %s ma il default compilato (con le deviazioni dichiarate) e' %s" % (k, pin[k], v))
    if len(p["pin"]) != len(d) - 1:
        pr.append("righe di pin %d invece di %d (tutti gli input del sorgente meno l'asse tecnico)" % (len(p["pin"]), len(d) - 1))
    if p["direttive"] != {"FINOA": "2026.06.30"}:
        pr.append("direttive del file prova: attese solo @FINOA 2026.06.30, trovate %s" % p["direttive"])
    if len(p["marker_da"]) < 20:
        pr.append("manca il marcatore @DAQUANDO-DALLA-RIGA con un motivo vero")
    # blocchi F0: coerenza interna
    nomi_cfg = [c["nome"] for c in p["config"]]
    if len(set(nomi_cfg)) != len(nomi_cfg) or len(nomi_cfg) != 6:
        pr.append("configurazioni F0: attese 6 diverse, trovate %s" % nomi_cfg)
    magics = [c["magic"] for c in p["config"]]
    if len(set(magics)) != len(magics) or any(not (778600 <= int(m) <= 778699) for m in magics):
        pr.append("magic delle configurazioni doppi o fuori dal blocco 778600-778699")
    for c in p["config"]:
        cifra = {"16385": 1, "16388": 4, "16396": 2, "16408": 8}.get(c["tf"])
        if cifra is None or int(c["magic"]) != 778600 + 10 * int(c["modalita"]) + cifra:
            pr.append("config %s: il magic %s non e' 7786 + 10*modalita + cifraTF come calcola l'EA (Risolvi)" % (c["nome"], c["magic"]))
        if c["modalita"] not in ("0", "2"):
            pr.append("config %s: modalita %s ammessa solo 0 (AUDIO) o 2 (EMA200): il PDF e' escluso" % (c["nome"], c["modalita"]))
    sim = [s["nome"] for s in p["simboli"]]
    if len(set(sim)) != len(sim) or len(sim) != 36:
        pr.append("simboli F0: attesi 36 diversi, trovati %d (%d unici)" % (len(sim), len(set(sim))))
    nomi_lotti = [l["nome"] for l in p["lotti"]]
    if nomi_lotti != ["PILOTA", "A", "B", "C", "D"]:
        pr.append("lotti attesi PILOTA,A,B,C,D, trovati %s" % nomi_lotti)
    visti = []
    for l in p["lotti"]:
        for s in l["simboli"].split(","):
            if s not in sim:
                pr.append("lotto %s: simbolo %s non e' fra i 36" % (l["nome"], s))
            if l["nome"] != "PILOTA":
                visti.append(s)
        for c in l["configs"].split(","):
            if c not in nomi_cfg:
                pr.append("lotto %s: configurazione %s inesistente" % (l["nome"], c))
    if sorted(visti) != sorted(sim):
        pr.append("i lotti A-D non coprono ESATTAMENTE i 36 simboli una volta sola (mancano %s, doppi %s)" % (
            sorted(set(sim) - set(visti)), sorted(set(x for x in visti if visti.count(x) > 1))))
    for s in p["simboli"]:
        if s["classe"] not in ("FX", "ORO", "ARG", "IDX"):
            pr.append("simbolo %s: classe %s sconosciuta" % (s["nome"], s["classe"]))
        if not re.match(r"^[0-9]{4}\.[0-9]{2}\.[0-9]{2}$", s["da"]):
            pr.append("simbolo %s: data %s non e' aaaa.mm.gg" % (s["nome"], s["da"]))
    return pr


if __name__ == "__main__":
    if "--pin" in sys.argv:
        for nome, tipo, v in default_ea():
            if nome == "InpMagic":
                print(ASSE_TECNICO)
            else:
                print("%s=%s" % (nome, DEVIAZIONI.get(nome, v)))
        sys.exit(0)
    argv = [a for a in sys.argv[1:] if not a.startswith("--")]
    pr = verifica(argv[0] if argv else PROVA)
    for x in pr:
        print("  PROBLEMA: " + x)
    print("prova_pins: %s" % ("OK" if not pr else "%d PROBLEMI" % len(pr)))
    sys.exit(1 if pr else 0)
