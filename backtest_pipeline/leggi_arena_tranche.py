#!/usr/bin/env python3
# -*- coding: ascii -*-
"""
leggi_arena_tranche.py -- il LETTORE delle TRE TRANCHE MENSILI dell'EA di TERZI 'Arena Nexus Grid Smart XAU MT5' nello Strategy Tester
(zip/cartella di backtest_pipeline/righe/ARENA_TESTER_TRANCHE.ps1). SOLA LETTURA. Scatola nera: nessun sorgente, nessuna decompilazione.
Non giudica il merito, non promuove, non archivia, non scrive mai 'morto'.

USO
  python3 backtest_pipeline/leggi_arena_tranche.py ARENA_TESTER_TRANCHE.zip [--csv-dir CARTELLA]
  python3 backtest_pipeline/leggi_arena_tranche.py --autotest

COSA FA: riusa le funzioni di leggi_arena_tester.py (parser del report, accoppiamento, cesti, stima d'equita': passate dal cancello il
14/10/2026) con TRE differenze, tutte dichiarate:
  1. leva attesa 1:100 (la sonda del 14/10 ha mostrato che il tester applica 1:100; la leva del conto demo e' [NON VISTA]);
  2. finestre: TRANCHE1 luglio (2026.07.01 -> 2026.08.01), TRANCHE2 agosto (08.01 -> 09.01), TRANCHE3 settembre (09.01 -> 10.01);
  3. provenienza: REFERTO_ARENA_TRANCHE.txt, marcatore v2 (ARENA_TESTER_TRANCHE.ps1) o v3 (ARENA_TESTER_TRANCHE_SELEZIONE.ps1, -Tranche),
     pin in PIN_PASSATI_TRANCHE (fail-closed se vuota) e marcatore ABBINATO al suo pin (MARCATORE_PER_PIN: un v3 col pin della v2 e' sospeso).
  5. (controllo-preventivo 15/10, classe 1455) con PIU' sorgenti (il giro v2 + il giro v3 che rifa' le tranche perse) l'impronta del .ex5
     (riga EX5: del REFERTO) dev'essere la STESSA in tutte: se cambia fra un giro e l'altro (aggiornamento dal Market) le tranche vengono da
     binari diversi e NON si sommano nelle ipotesi H1-H4; e una tranche presente in piu' sorgenti si segnala (non si conta due volte).
  6. (controllo-preventivo 15/10, ripasso strato 2) con PIU' sorgenti e --csv-dir i CSV vanno in una sottocartella PER FONTE
     (fonte1/, fonte2/, ...): una tranche presente in due giri scriveva lo STESSO TRANCHEn_*.csv e la seconda fonte sovrascriveva la
     prima in silenzio (ricorrenza della 4, fra i giri). E ogni blocco stampato porta l'intestazione FONTE n (i giornali compresi).
  4. (controllo-preventivo 14/10) i CSV di --csv-dir prendono il nome della TRANCHE (TRANCHE1_cesti.csv, ...): con il sonda_di() del
     lettore della sonda tutte e tre si chiamavano REPORT_*.csv e le prime due venivano SOVRASCRITTE in silenzio.
NESSUN verdetto (A)(B)(C): erano scritti per le sonde da 1 e 65 giorni. Le tranche si LEGGONO con le ipotesi della scheda
(report/ARENA_TESTER_TRANCHE_SCHEDA_2026-10-14.md), scritte PRIMA dei numeri; qui si stampano i numeri descrittivi e una tabella di sintesi.
Se il giro non e' quello dichiarato (input, deposito, leva, finestra, qualita', provenienza), la tabella di sintesi lo dice e i numeri
sono descrittivi di QUEL giro. ASCII puro.
"""
import argparse
import collections
import os
import re
import sys
import tempfile

sys.path.insert(0, os.path.dirname(os.path.abspath(__file__)))
import leggi_arena_tester as L  # noqa: E402

L.LEVA_ATTESA = "1:100"
# la riga 'ANCORA DEL FEED' del lettore della sonda confronta i tick con la finestra di TRE mesi di GBA T1 e scatta quando il report comincia
# il 2026.07.01: per la tranche di luglio (un mese) darebbe un falso 'DIVERSA'. Si spegne con una data che non compare mai.
L.ANCORA_T1 = (L.ANCORA_T1[0], L.ANCORA_T1[1], "0000.00.00")
# il pin della riga passata dai DUE cancelli (fail-closed se vuota). DA SCRIVERE: il commit che porta ARENA_TESTER_TRANCHE.ps1 v2.
# d284a709 (v1) NON si mette: la v1 lanciava le tranche dopo un .ex5 cambiato (classe 1438) e non e' passata dal cancello di giudizio.
PIN_PASSATI_TRANCHE = ("5c5d7dc0292caf885a108298c97c63c7548a8e6e", "07947bbeb0657bad49c4a918cd7ff90db5b02193")   # v2 (3 tranche) e v3 (-Tranche)   # il pin della riga passata dal cancello (fail-closed se vuota)
MARCATORI_ATTESI = ("MARCATORE_ARENA_TESTER_TRANCHE_v2", "MARCATORE_ARENA_TESTER_TRANCHE_v3")
MARCATORE_ATTESO = MARCATORI_ATTESI[0]
# (controllo-preventivo 15/10) ogni pin passato porta UN marcatore: il pin e' quello che la riga passa a -Pin, lo script non lo verifica.
# Un pin passato SENZA voce qui e' sospeso (fail-closed).
MARCATORE_PER_PIN = {"5c5d7dc0292caf885a108298c97c63c7548a8e6e": "MARCATORE_ARENA_TESTER_TRANCHE_v2",
                     "07947bbeb0657bad49c4a918cd7ff90db5b02193": "MARCATORE_ARENA_TESTER_TRANCHE_v3"}
# lo script delle tranche nasce col commit d284a709 del 14/10/2026 20:26 UTC: un REFERTO del 14/10 sera e' legittimo (un giro che va KO
# in pochi minuti la stessa sera). Con "2026-10-15" il lettore lo sospendeva scrivendo il FALSO "lo script non esisteva".
DATA_MINIMA_REFERTO = "2026-10-14"
FINESTRE_T = {"TRANCHE1": ("2026.07.01", ("2026.07.31", "2026.08.01")),
              "TRANCHE2": ("2026.08.01", ("2026.08.31", "2026.09.01")),
              "TRANCHE3": ("2026.09.01", ("2026.09.30", "2026.10.01"))}
SOGLIA_PROF = 10


def tranche_di(nome):
    b = os.path.basename(nome).upper()
    for t in ("TRANCHE1", "TRANCHE2", "TRANCHE3"):
        if t in b:
            return t
    return None


_SONDA_DI_ORIGINALE = L.sonda_di


def _sonda_di_tranche(nome):
    """il nome del giro per stampa() e per i CSV di --csv-dir: TRANCHE1/2/3, altrimenti quello del lettore della sonda."""
    return tranche_di(nome) or _SONDA_DI_ORIGINALE(nome)


L.sonda_di = _sonda_di_tranche


def condizioni_tranche(nome, rep):
    """motivi per cui il report non e' il giro dichiarato: quelli del lettore della sonda (input, deposito, leva 1:100, simbolo, Expert,
    qualita') piu' la finestra della tranche."""
    m = L.condizioni(nome, rep)
    t = tranche_di(nome)
    p = rep.get("periodo") or ""
    if t is None:
        m.append("nome del file senza TRANCHE1/2/3: finestra attesa non nota")
        return m
    da, fini = FINESTRE_T[t]
    mm = re.match(r"^M1\((\d{4}\.\d\d\.\d\d)-(\d{4}\.\d\d\.\d\d)\)", p)
    if not mm or mm.group(1) != da or mm.group(2) not in fini:
        m.append("periodo %s invece di M1(%s-%s)" % (p or "NON LETTO", da, fini[-1]))
    return m


def provenienza_tranche(src):
    """(sospesi_comuni, sospesi_per_tranche, righe) come provenienza() della sonda, per il REFERTO delle tranche."""
    comuni, per_t, righe = [], collections.defaultdict(list), []
    nomi_ref = [n for n in src.nomi() if os.path.basename(n) == "REFERTO_ARENA_TRANCHE.txt"]
    if not nomi_ref:
        comuni.append("REFERTO_ARENA_TRANCHE.txt ASSENTE (report sciolto o zip incompleto): provenienza (script, pin, data, impronta del .ex5) NON verificata")
        return comuni, per_t, righe
    if len(nomi_ref) > 1:
        comuni.append("%d REFERTO nella stessa sorgente: non so quale vale" % len(nomi_ref))
    rr = L.decodifica(src.leggi(nomi_ref[0])).splitlines()
    prima = rr[0] if rr else ""
    mpin = re.search(r"\bpin ([0-9a-fA-F]{40})\b", prima)
    mmar = re.search(r"MARCATORE_ARENA_TESTER_TRANCHE_v\d+", prima)
    mdat = None
    for r in rr[:3]:
        mdat = re.match(r"^data: (\d{4}-\d\d-\d\d) \d\d:\d\d:\d\d", r)
        if mdat:
            break
    pin = mpin.group(1).lower() if mpin else None
    righe.append("PROVENIENZA dal REFERTO: marcatore %s | pin %s | data %s | pin passati dal cancello: %s" % (
        mmar.group(0) if mmar else "ASSENTE", pin or "ASSENTE", mdat.group(1) if mdat else "ASSENTE",
        ", ".join(PIN_PASSATI_TRANCHE) if PIN_PASSATI_TRANCHE else "NESSUNO (tupla PIN_PASSATI_TRANCHE vuota)"))
    if not mmar or mmar.group(0) not in MARCATORI_ATTESI:
        comuni.append("marcatore %s invece di %s" % (mmar.group(0) if mmar else "ASSENTE", " / ".join(MARCATORI_ATTESI)))
    if pin is None or pin not in PIN_PASSATI_TRANCHE:
        comuni.append("pin %s NON fra quelli passati dal cancello (%s)" % (pin or "ASSENTE", ", ".join(PIN_PASSATI_TRANCHE) if PIN_PASSATI_TRANCHE else "PIN_PASSATI_TRANCHE vuota"))
    elif MARCATORE_PER_PIN.get(pin) != (mmar.group(0) if mmar else None):
        comuni.append("marcatore %s NON abbinato al pin %s (atteso %s)" % (mmar.group(0) if mmar else "ASSENTE", pin, MARCATORE_PER_PIN.get(pin) or "NESSUNA voce in MARCATORE_PER_PIN"))
    if not mdat or mdat.group(1) < DATA_MINIMA_REFERTO:
        comuni.append("data del REFERTO %s prima del %s (lo script delle tranche non esisteva)" % (mdat.group(1) if mdat else "ASSENTE", DATA_MINIMA_REFERTO))
    visti = set()
    for r in rr:
        me = re.match(r"^EX5_DOPO (TRANCHE[123]): (\S+) (UGUALE|DIVERSO)\s*$", r)
        if me:
            visti.add(me.group(1))
            righe.append("impronta del .ex5 dopo %s: %s" % (me.group(1), me.group(3)))
            if me.group(3) != "UGUALE":
                per_t[me.group(1)].append("il .ex5 e' CAMBIATO durante la %s (EX5_DOPO DIVERSO)" % me.group(1))
    for t in ("TRANCHE1", "TRANCHE2", "TRANCHE3"):
        if t not in visti:
            righe.append("EX5_DOPO %s: assente dal REFERTO (tranche non lanciata o REFERTO incompleto)" % t)
    return comuni, per_t, righe


def impronta_ex5(src):
    """la SHA256 del .ex5 scritta nella riga 'EX5:' del REFERTO della sorgente, oppure None (REFERTO assente o riga non letta)."""
    for n in src.nomi():
        if os.path.basename(n) == "REFERTO_ARENA_TRANCHE.txt":
            for r in L.decodifica(src.leggi(n)).splitlines():
                me = re.match(r"^EX5: .*\bSHA256 ([0-9A-Fa-f]{64})\b", r)
                if me:
                    return me.group(1).upper()
            return None
    return None


def impronte_fra_sorgenti(impronte):
    """(classe 1455) motivi comuni a TUTTE le sorgenti quando sono piu' d'una e il .ex5 non e' provato lo stesso: le tranche di giri
    diversi si sommano nelle ipotesi H1-H4 solo se vengono dallo STESSO binario."""
    if len(impronte) < 2:
        return []
    viste = sorted(set(v for v in impronte.values() if v))
    senza = [p for p, v in impronte.items() if not v]
    if senza:
        return ["%d sorgenti, impronta del .ex5 NON letta in %s: non posso dire che le tranche vengono dallo stesso binario (classe 1455)" % (len(impronte), ", ".join(senza))]
    if len(viste) > 1:
        return ["%d sorgenti con .ex5 DIVERSI (%s): le tranche vengono da binari diversi e NON si sommano nelle ipotesi H1-H4 (classe 1455)" % (len(impronte), " / ".join(v[:12] for v in viste))]
    return []


def sintesi(nome, rep, a, sospesi):
    """una riga per tranche: i numeri che le ipotesi della scheda usano. Descrittiva."""
    eps = [e for k, e in a.get("episodi", {}).items() if k[0] == "R"]
    prof = [e for e in eps if e["prof"] >= SOGLIA_PROF]
    netto_r = sum(e["netto"] for e in eps)
    netto_p = sum(e["netto"] for e in prof)
    quota = (100.0 * netto_p / netto_r) if netto_r else None
    so = a.get("t_stop_out")
    return {"tranche": tranche_di(nome) or "?", "trades": rep.get("trades"), "netto": rep.get("profitto"), "pf": rep.get("pf"),
            "dd_eq": rep.get("dd_eq_abs"), "dd_eq_pct": rep.get("dd_eq_pct"), "stop_out": so.isoformat(sep=" ") if so else "nessuno",
            "cesti_R": len(eps), "cesti_prof": len(prof), "netto_R": netto_r, "netto_prof": netto_p, "quota_prof": quota,
            "conforme": not sospesi}


def stampa_tabella(righe):
    print("=" * 118)
    print("SINTESI DELLE TRANCHE (descrittiva; nessun verdetto: le ipotesi H1-H4 stanno nella scheda, scritte prima dei numeri)")
    print("  %-11s %-9s %6s %11s %6s %20s %7s %8s %10s %12s" % ("tranche@f", "giro", "oper", "netto EUR", "PF", "primo stop out", "cesti R", "R>=%d" % SOGLIA_PROF, "netto R>=10", "quota di R"))
    for s in righe:
        print("  %-11s %-9s %6s %11s %6s %20s %7d %8d %10.2f %12s" % (
            "%s@%s" % (s["tranche"], s.get("fonte", 1)), "CONFORME" if s["conforme"] else "NON CONF.", s["trades"], s["netto"], s["pf"], s["stop_out"], s["cesti_R"], s["cesti_prof"],
            s["netto_prof"], ("%.1f%%" % s["quota_prof"]) if s["quota_prof"] is not None else "n/d"))
    print("  NON CONF. = il giro non e' quello dichiarato (vedi i motivi sopra): i numeri sono descrittivi di QUEL giro.")


def leggi_percorsi(percorsi, csv_dir=None):
    rc, trovati, tab = 0, 0, []
    sorgenti = [(p, L.Sorgente(p)) for p in percorsi]
    impronte = collections.OrderedDict((p, impronta_ex5(s)) for p, s in sorgenti)
    fra = impronte_fra_sorgenti(impronte)
    if len(sorgenti) > 1:
        for p, v in impronte.items():
            print("IMPRONTA del .ex5 nel REFERTO di %s: %s" % (p, v or "NON LETTA"))
        for x in fra:
            print("SORGENTI NON SOMMABILI: " + x)
    multi = len(sorgenti) > 1
    for fonte, (p, src) in enumerate(sorgenti, 1):
        # (ripasso strato 2, 15/10) con piu' fonti i CSV vanno in csv_dir/fonteN: la stessa tranche in due giri NON si sovrascrive
        cdir = os.path.join(csv_dir, "fonte%d" % fonte) if (csv_dir and multi) else csv_dir
        if multi:
            print("=" * 118)
            print("FONTE %d = %s" % (fonte, p))
        for n in src.nomi():
            if os.path.basename(n) == "REFERTO_ARENA_TRANCHE.txt":
                print("-" * 118)
                print("REFERTO dello script (%s) -- righe chiave:" % n)
                for r in L.decodifica(src.leggi(n)).splitlines():
                    if re.search(r"MARCATORE|^data:|^EX5:|^EX5_DOPO|^esiti:|STATO|ENUM|NON LANCIATA|ATTENZIONE|^   - ", r):
                        print("  " + r.strip())
        comuni, per_t, righe_p = provenienza_tranche(src)
        comuni = comuni + fra
        for r in righe_p:
            print(r)
        for x in comuni:
            print("PROVENIENZA NON VERIFICATA: " + x)
        L.stampa_giornali(L.leggi_giornali(src))
        for n in src.nomi():
            if n.lower().endswith((".htm", ".html")):
                trovati += 1
                rep = L.leggi_report(src.leggi(n))
                a = L.analizza(rep) if rep["ok"] else {"errori": [], "avvisi": [], "giorni": {}, "episodi": {}}
                motivi = comuni + per_t.get(tranche_di(n), []) + (condizioni_tranche(n, rep) if rep["ok"] else ["report illeggibile"])
                # nessun verdetto (A)(B)(C): le tranche non le hanno; si passa SEMPRE un motivo cosi' stampa() non le giudica
                sosp = ["tranche mensile: i verdetti (A)(B)(C) erano delle sonde da 1 e 65 giorni; si leggono le ipotesi della scheda"] + motivi
                rc = max(rc, L.stampa(n, rep, a, cdir, sosp))
                if motivi:
                    print("GIRO NON CONFORME a quello dichiarato -> " + "; ".join(motivi[:8]))
                if rep["ok"]:
                    sx = sintesi(n, rep, a, motivi)
                    sx["fonte"] = fonte
                    tab.append(sx)
    if trovati == 0:
        print("NESSUN report .htm nelle sorgenti date: le tranche non hanno misurato niente (guardare il REFERTO e i log).")
        return 2
    stampa_tabella(sorted(tab, key=lambda s: (s["tranche"], s.get("fonte", 0))))
    if len(sorgenti) > 1:
        for i, (p, _s) in enumerate(sorgenti, 1):
            print("  fonte %d = %s" % (i, p))
    doppie = collections.Counter(s["tranche"] for s in tab)
    for t in sorted(k for k, v in doppie.items() if v > 1):
        print("ATTENZIONE: %s compare %d volte (fonti %s): nelle ipotesi H1-H4 si conta UNA volta; QUALE la sceglie la lettura, dichiarandolo, non il lettore." % (
            t, doppie[t], ", ".join(str(s.get("fonte")) for s in tab if s["tranche"] == t)))
    return rc


def autotest():
    esito = [0]

    def ok(cond, msg):
        print("  %s  %s" % ("OK  " if cond else "FAIL", msg))
        if not cond:
            esito[0] = 1

    print("AUTOTEST leggi_arena_tranche.py")
    global PIN_PASSATI_TRANCHE, MARCATORE_PER_PIN
    salva = PIN_PASSATI_TRANCHE
    salva_m = MARCATORE_PER_PIN
    # 3d gira sui valori VERI (prima che l'autotest li sostituisca): il pin della v2 con il marcatore della v3 si sospende
    c0, _p0, _r0 = None, None, None
    with tempfile.TemporaryDirectory() as td0:
        open(os.path.join(td0, "REFERTO_ARENA_TRANCHE.txt"), "w").write(
            "ARENA TESTER TRANCHE -- x. Script MARCATORE_ARENA_TESTER_TRANCHE_v3, pin 5c5d7dc0292caf885a108298c97c63c7548a8e6e\r\ndata: 2026-10-15 10:00:00   pc: X\r\n")
        c0, _p0, _r0 = provenienza_tranche(L.Sorgente(td0))
    ok(any("NON abbinato" in x for x in c0), "3d valori veri: marcatore v3 con il pin della v2 (5c5d7dc0): sospeso")
    try:
        pin = "b" * 40
        pin3 = "d" * 40
        PIN_PASSATI_TRANCHE = (pin, pin3)
        MARCATORE_PER_PIN = {pin: MARCATORI_ATTESI[0], pin3: MARCATORI_ATTESI[1]}

        def ref(p=pin, mar=MARCATORE_ATTESO, data="2026-10-15", ex=("UGUALE", "UGUALE", "UGUALE")):
            r = ["ARENA TESTER TRANCHE -- x. Script %s, pin %s" % (mar, p), "data: %s 10:00:00   pc: X" % data]
            for t, e in zip(("TRANCHE1", "TRANCHE2", "TRANCHE3"), ex):
                if e:
                    r.append("EX5_DOPO %s: ABC %s" % (t, e))
            return "\r\n".join(r) + "\r\n"

        def prov(testo, nome="REFERTO_ARENA_TRANCHE.txt"):
            with tempfile.TemporaryDirectory() as td:
                open(os.path.join(td, nome), "w").write(testo)
                return provenienza_tranche(L.Sorgente(td))
        c, pt, _ = prov(ref())
        ok(not c and not pt, "1 REFERTO conforme: nessun motivo")
        c, pt, _ = prov(ref(p="c" * 40))
        ok(any("NON fra quelli passati" in x for x in c), "2 pin diverso: sospeso")
        c, pt, _ = prov(ref(mar="MARCATORE_ARENA_TESTER_SONDA_v3"))
        ok(any("marcatore" in x for x in c), "3 marcatore della sonda: sospeso")
        c, pt, _ = prov(ref(p=pin3, mar="MARCATORE_ARENA_TESTER_TRANCHE_v3"))
        ok(not c and not pt, "3b marcatore v3 col SUO pin (variante -Tranche): accettato")
        c, pt, _ = prov(ref(p=pin, mar="MARCATORE_ARENA_TESTER_TRANCHE_v3"))
        ok(any("NON abbinato" in x for x in c), "3e marcatore v3 con il pin della v2: sospeso")
        c, pt, _ = prov(ref(p=pin3, mar="MARCATORE_ARENA_TESTER_TRANCHE_v2"))
        ok(any("NON abbinato" in x for x in c), "3f marcatore v2 con il pin della v3: sospeso")
        c, pt, _ = prov(ref(mar="MARCATORE_ARENA_TESTER_TRANCHE_v4"))
        ok(any("marcatore" in x for x in c), "3c marcatore v4 (mai passato dal cancello): sospeso")
        c, pt, _ = prov(ref(data="2026-10-13"))
        ok(any("data del REFERTO" in x for x in c), "4 data prima del 14/10: sospeso")
        c, pt, _ = prov(ref(data="2026-10-14"))
        ok(not c, "4b REFERTO del 14/10 sera (giro KO in pochi minuti lo stesso giorno del commit): NON sospeso per la data")
        c, pt, _ = prov(ref(ex=("UGUALE", "DIVERSO", "UGUALE")))
        ok(pt.get("TRANCHE2") and not pt.get("TRANCHE1"), "5 .ex5 cambiato nella TRANCHE2: solo quella sospesa")
        c, pt, _ = prov("", nome="ALTRO.txt")
        ok(any("ASSENTE" in x for x in c), "6 REFERTO assente: sospeso")
        PIN_PASSATI_TRANCHE = ()
        c, pt, _ = prov(ref())
        ok(any("NON fra quelli passati" in x for x in c), "7 tupla dei pin vuota: fail-closed")
        PIN_PASSATI_TRANCHE = (pin, pin3)
        MARCATORE_PER_PIN = {pin3: MARCATORI_ATTESI[1]}
        c, pt, _ = prov(ref())
        ok(any("NON abbinato" in x for x in c), "7b pin passato SENZA voce in MARCATORE_PER_PIN: fail-closed")
        MARCATORE_PER_PIN = {pin: MARCATORI_ATTESI[0], pin3: MARCATORI_ATTESI[1]}
        # report finti con la classe Finto del lettore della sonda (il Finto scrive leva 1:500: per le prove 'conformi' la si porta a 1:100)
        def rapporto(per, leva="1:100"):
            F = L.Finto(periodo=per)
            F.apri("2026.07.01 10:00:00", "buy", 0.01, 4000.00, "FinlabX BUY [CID=1] [R]")
            h = F.htm()
            if isinstance(h, str):
                h = h.encode("utf-8")
            for cod in ("utf-16-le", "utf-8"):
                if "1:500".encode(cod) in h:
                    return L.leggi_report(h.replace("1:500".encode(cod), leva.encode(cod)))
            raise AssertionError("il report finto non contiene la leva 1:500 ne' in UTF-16 ne' in UTF-8")
        for nome, per, att in (("ARENA_TRANCHE1_x.htm", "M1 (2026.07.01 - 2026.08.01)", True),
                               ("ARENA_TRANCHE2_x.htm", "M1 (2026.08.01 - 2026.09.01)", True),
                               ("ARENA_TRANCHE3_x.htm", "M1 (2026.09.01 - 2026.10.01)", True),
                               ("ARENA_TRANCHE2_x.htm", "M1 (2026.07.01 - 2026.08.01)", False),
                               ("ARENA_x.htm", "M1 (2026.07.01 - 2026.08.01)", False)):
            rep = rapporto(per)
            ok(rep["ok"], "8 report finto letto (%s %s)" % (nome, per))
            mot = condizioni_tranche(nome, rep)
            ok((not mot) if att else bool(mot), "9 %s %s: %s" % (nome, per, "conforme, nessun motivo" if att else "NON conforme -> motivo (%s)" % ("; ".join(mot)[:80] if mot else "NESSUNO")))
        mot = condizioni_tranche("ARENA_TRANCHE1_x.htm", rapporto("M1 (2026.07.01 - 2026.08.01)", leva="1:500"))
        ok(any("leva" in x for x in mot), "10 leva 1:500 nel report: motivo 'leva ... invece di 1:100'")
        mot = condizioni_tranche("ARENA_TRANCHE1_x.htm", rapporto("M1 (2026.07.01 - 2026.07.31)"))
        ok(not mot, "11 estremo finale 2026.07.31 accettato (il tester puo' scrivere l'ultimo giorno incluso)")
        # 12. CONTRO-ESEMPIO: tre report in una cartella con --csv-dir -> tre coppie di CSV distinte (prima: REPORT_*.csv sovrascritti)
        with tempfile.TemporaryDirectory() as td, tempfile.TemporaryDirectory() as cd:
            for t3, per in (("TRANCHE1", "M1 (2026.07.01 - 2026.08.01)"), ("TRANCHE2", "M1 (2026.08.01 - 2026.09.01)"), ("TRANCHE3", "M1 (2026.09.01 - 2026.10.01)")):
                F = L.Finto(periodo=per)
                pid = F.apri("2026.07.01 10:00:00", "buy", 0.01, 4000.00, "FinlabX BUY [CID=1] [R]")
                F.chiudi("2026.07.01 11:00:00", pid, 4001.00)
                h = F.htm()
                open(os.path.join(td, "ARENA_%s_x.htm" % t3), "wb").write(h if isinstance(h, bytes) else h.encode("utf-8"))
            import contextlib
            import io
            with contextlib.redirect_stdout(io.StringIO()):
                leggi_percorsi([td], cd)
            nomi = sorted(os.listdir(cd))
            ok(nomi == sorted("%s_%s.csv" % (t3, k) for t3 in ("TRANCHE1", "TRANCHE2", "TRANCHE3") for k in ("cesti", "giorni")),
               "12 --csv-dir con tre tranche: sei CSV distinti %s (nessuna tranche sovrascritta)" % nomi)
        # 13-16. CONTRO-ESEMPIO classe 1455: il giro v2 + il giro v3 che rifa' le tranche perse, letti insieme
        def giro(td, t3, per, sha, p, mar):
            os.makedirs(td)
            F = L.Finto(periodo=per)
            pid = F.apri("2026.07.01 10:00:00", "buy", 0.01, 4000.00, "FinlabX BUY [CID=1] [R]")
            F.chiudi("2026.07.01 11:00:00", pid, 4001.00)
            h = F.htm()
            h = h if isinstance(h, bytes) else h.encode("utf-8")
            for cod in ("utf-16-le", "utf-8"):
                if "1:500".encode(cod) in h:
                    h = h.replace("1:500".encode(cod), "1:100".encode(cod))
                    break
            open(os.path.join(td, "ARENA_%s_x.htm" % t3), "wb").write(h)
            riga_ex5 = ("EX5: Market\\Arena.ex5   byte 1   data file x   SHA256 %s   (binario)\r\n" % sha) if sha else ""
            open(os.path.join(td, "REFERTO_ARENA_TRANCHE.txt"), "w").write(
                "ARENA TESTER TRANCHE -- x. Script %s, pin %s\r\ndata: 2026-10-15 10:00:00   pc: X\r\n%sEX5_DOPO %s: %s UGUALE\r\n" % (mar, p, riga_ex5, t3, sha or "X"))
        import contextlib
        import io
        for caso, sha1, sha3, t3b, atteso, msg in (
                (13, "A" * 64, "B" * 64, "TRANCHE3", "binari diversi", "13 due giri con .ex5 DIVERSI: tutte NON conformi"),
                (14, "A" * 64, "a" * 64, "TRANCHE3", None, "14 due giri con lo STESSO .ex5 (maiuscole diverse): conformi"),
                (15, "A" * 64, None, "TRANCHE3", "NON letta", "15 due giri, impronta assente in uno: tutte NON conformi"),
                (16, "A" * 64, "A" * 64, "TRANCHE1", "compare 2 volte", "16 la stessa tranche in due giri: segnalata, non contata due volte")):
            with tempfile.TemporaryDirectory() as td:
                a = os.path.join(td, "g2")
                b = os.path.join(td, "g3")
                giro(a, "TRANCHE1", "M1 (2026.07.01 - 2026.08.01)", sha1, pin, MARCATORI_ATTESI[0])
                per3 = "M1 (2026.09.01 - 2026.10.01)" if t3b == "TRANCHE3" else "M1 (2026.07.01 - 2026.08.01)"
                giro(b, t3b, per3, sha3, pin3, MARCATORI_ATTESI[1])
                buf = io.StringIO()
                with contextlib.redirect_stdout(buf):
                    leggi_percorsi([a, b])
                out = buf.getvalue()
                ncf = out.count("NON CONF.") - 1
                if caso in (13, 15):
                    ok(atteso in out and ncf == 2, msg)
                elif caso == 14:
                    ok("SORGENTI NON SOMMABILI" not in out and ncf == 0, msg)
                else:
                    ok(atteso in out and "SORGENTI NON SOMMABILI" not in out, msg)
        # 17. CONTRO-ESEMPIO (ripasso strato 2): la STESSA tranche in due giri con --csv-dir -> due CSV distinti, uno per fonte
        with tempfile.TemporaryDirectory() as td, tempfile.TemporaryDirectory() as cd:
            a = os.path.join(td, "g2")
            b = os.path.join(td, "g3")
            giro(a, "TRANCHE1", "M1 (2026.07.01 - 2026.08.01)", "A" * 64, pin, MARCATORI_ATTESI[0])
            giro(b, "TRANCHE1", "M1 (2026.07.01 - 2026.08.01)", "A" * 64, pin3, MARCATORI_ATTESI[1])
            with contextlib.redirect_stdout(io.StringIO()):
                leggi_percorsi([a, b], cd)
            trovati_csv = sorted(os.path.relpath(os.path.join(r, f), cd).replace(os.sep, "/") for r, _d, fs in os.walk(cd) for f in fs)
            ok(trovati_csv == ["fonte1/TRANCHE1_cesti.csv", "fonte1/TRANCHE1_giorni.csv", "fonte2/TRANCHE1_cesti.csv", "fonte2/TRANCHE1_giorni.csv"],
               "17 la stessa tranche in due giri con --csv-dir: un CSV PER FONTE %s (nessuna fonte sovrascritta)" % trovati_csv)
    finally:
        PIN_PASSATI_TRANCHE = salva
        MARCATORE_PER_PIN = salva_m
    print("AUTOTEST: " + ("tutti i controlli OK" if not esito[0] else "ALMENO UN CONTROLLO CADUTO"))
    return esito[0]


def main():
    ap = argparse.ArgumentParser(description="lettore delle tre tranche Arena nello Strategy Tester (sola lettura)")
    ap.add_argument("percorsi", nargs="*")
    ap.add_argument("--csv-dir", default=None)
    ap.add_argument("--autotest", action="store_true")
    x = ap.parse_args()
    if x.autotest:
        return autotest()
    if not x.percorsi:
        ap.error("serve uno zip, una cartella o un report .htm (oppure --autotest)")
    return leggi_percorsi(x.percorsi, x.csv_dir)


if __name__ == "__main__":
    sys.exit(main())
