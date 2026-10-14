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
  3. provenienza: REFERTO_ARENA_TRANCHE.txt, marcatore MARCATORE_ARENA_TESTER_TRANCHE_v2, pin in PIN_PASSATI_TRANCHE (fail-closed se vuota).
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
PIN_PASSATI_TRANCHE = ("5c5d7dc0292caf885a108298c97c63c7548a8e6e",)   # il pin della riga passata dal cancello (fail-closed se vuota)
MARCATORE_ATTESO = "MARCATORE_ARENA_TESTER_TRANCHE_v2"
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
    if not mmar or mmar.group(0) != MARCATORE_ATTESO:
        comuni.append("marcatore %s invece di %s" % (mmar.group(0) if mmar else "ASSENTE", MARCATORE_ATTESO))
    if pin is None or pin not in PIN_PASSATI_TRANCHE:
        comuni.append("pin %s NON fra quelli passati dal cancello (%s)" % (pin or "ASSENTE", ", ".join(PIN_PASSATI_TRANCHE) if PIN_PASSATI_TRANCHE else "PIN_PASSATI_TRANCHE vuota"))
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
    print("  %-9s %-9s %6s %11s %6s %20s %7s %8s %10s %12s" % ("tranche", "giro", "oper", "netto EUR", "PF", "primo stop out", "cesti R", "R>=%d" % SOGLIA_PROF, "netto R>=10", "quota di R"))
    for s in righe:
        print("  %-9s %-9s %6s %11s %6s %20s %7d %8d %10.2f %12s" % (
            s["tranche"], "CONFORME" if s["conforme"] else "NON CONF.", s["trades"], s["netto"], s["pf"], s["stop_out"], s["cesti_R"], s["cesti_prof"],
            s["netto_prof"], ("%.1f%%" % s["quota_prof"]) if s["quota_prof"] is not None else "n/d"))
    print("  NON CONF. = il giro non e' quello dichiarato (vedi i motivi sopra): i numeri sono descrittivi di QUEL giro.")


def leggi_percorsi(percorsi, csv_dir=None):
    rc, trovati, tab = 0, 0, []
    for p in percorsi:
        src = L.Sorgente(p)
        for n in src.nomi():
            if os.path.basename(n) == "REFERTO_ARENA_TRANCHE.txt":
                print("-" * 118)
                print("REFERTO dello script (%s) -- righe chiave:" % n)
                for r in L.decodifica(src.leggi(n)).splitlines():
                    if re.search(r"MARCATORE|^data:|^EX5:|^EX5_DOPO|^esiti:|STATO|ENUM|NON LANCIATA|ATTENZIONE|^   - ", r):
                        print("  " + r.strip())
        comuni, per_t, righe_p = provenienza_tranche(src)
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
                rc = max(rc, L.stampa(n, rep, a, csv_dir, sosp))
                if motivi:
                    print("GIRO NON CONFORME a quello dichiarato -> " + "; ".join(motivi[:8]))
                if rep["ok"]:
                    tab.append(sintesi(n, rep, a, motivi))
    if trovati == 0:
        print("NESSUN report .htm nelle sorgenti date: le tranche non hanno misurato niente (guardare il REFERTO e i log).")
        return 2
    stampa_tabella(sorted(tab, key=lambda s: s["tranche"]))
    return rc


def autotest():
    esito = [0]

    def ok(cond, msg):
        print("  %s  %s" % ("OK  " if cond else "FAIL", msg))
        if not cond:
            esito[0] = 1

    print("AUTOTEST leggi_arena_tranche.py")
    global PIN_PASSATI_TRANCHE
    salva = PIN_PASSATI_TRANCHE
    try:
        pin = "b" * 40
        PIN_PASSATI_TRANCHE = (pin,)

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
        PIN_PASSATI_TRANCHE = (pin,)
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
    finally:
        PIN_PASSATI_TRANCHE = salva
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
