# -*- coding: utf-8 -*-
"""
classifica_report_mt5.py -- classifica gli EA dal "Report Cronistorico dei Trade"
di MT5 (.xlsx), usando il COMMENTO dell'affare di APERTURA come firma dell'EA.

USO: python3 backtest_pipeline/classifica_report_mt5.py <report.xlsx> [out.md]

COME FUNZIONA, e perche' cosi'
  Il report ha tre sezioni. "Posizioni" ha il P/L per POSIZIONE (che e' la
  nostra unita', Emendamento A) ma NON ha ne' magic ne' commento. "Affari" ha
  il COMMENTO ma spezzato in due righe (in / out). Quindi:
    - il P/L si prende dalle POSIZIONI (profitto + swap + commissioni);
    - l'EA si prende dal commento dell'affare con Direzione = "in",
      agganciato alla posizione per (simbolo, ora di apertura, prezzo).
  Le posizioni che non trovano un aggancio finiscono in [NON ATTRIBUITE] e
  vengono CONTATE, non nascoste.

LIMITE DICHIARATO, e va letto prima dei numeri
  L'attribuzione e' per COMMENTO, non per MAGIC: due EA che scrivono lo stesso
  commento finiscono insieme, e un EA che non commenta finisce fra le non
  attribuite. Il magic nel report MT5 non c'e'.
"""
import os
import re
import sys
from collections import defaultdict

import openpyxl


def num(x):
    if x is None:
        return 0.0
    if isinstance(x, (int, float)):
        return float(x)
    s = str(x).strip().replace(" ", "").replace(" ", "")
    s = s.split("/")[0]
    s = s.replace(",", ".")
    try:
        return float(s)
    except ValueError:
        return 0.0


def famiglia(commento):
    """Raggruppa i commenti in FAMIGLIE: si toglie il verso e il suffisso."""
    c = re.sub(r"\s+", " ", (commento or "").strip())
    if not c:
        return None
    c = re.sub(r"\b(BUY|SELL|buy|sell|LONG|SHORT)\b", "", c)
    c = re.sub(r"[#\[\]]", " ", c)
    c = re.sub(r"\s+", " ", c).strip(" -_")
    return c or None


def leggi(path):
    ws = openpyxl.load_workbook(path, data_only=True, read_only=True)["Sheet1"]
    righe = list(ws.iter_rows(values_only=True))
    sez = {}
    for i, r in enumerate(righe):
        a = (str(r[0]) if r[0] is not None else "").strip()
        if a in ("Posizioni", "Ordini", "Affari", "Posizioni aperte", "Risultati"):
            sez.setdefault(a, i)
    return righe, sez


def analizza(path):
    righe, sez = leggi(path)

    # --- affari "in": la firma dell'EA
    firma = {}
    i = sez["Affari"] + 2
    fine = sez.get("Posizioni aperte", len(righe))
    n_in = 0
    while i < fine:
        r = righe[i]
        if r[0] is None or not str(r[0]).strip():
            i += 1
            continue
        ora, sym, direz, prezzo, com = r[0], r[2], r[4], r[6], r[13]
        if str(direz).strip() == "in":
            firma[(str(sym), str(ora), round(num(prezzo), 6))] = com
            n_in += 1
        i += 1

    # --- posizioni: il P/L
    pos = []
    i = sez["Posizioni"] + 2
    fine = sez["Ordini"] - 1
    while i < fine:
        r = righe[i]
        if r[0] is None or not str(r[0]).strip():
            i += 1
            continue
        apertura, sym, prezzo_ap = str(r[0]), str(r[2]), round(num(r[5]), 6)
        netto = num(r[12]) + num(r[11]) + num(r[10])   # profitto + swap + commissioni
        com = firma.get((sym, apertura, prezzo_ap))
        pos.append(dict(apertura=apertura, chiusura=str(r[8]), sym=sym,
                        tipo=str(r[3]), vol=num(r[4]), netto=netto,
                        profitto=num(r[12]), com=com, fam=famiglia(com)))
        i += 1

    # --- aggregazione
    grup = defaultdict(list)
    for p in pos:
        grup[p["fam"] or "[NON ATTRIBUITE]"].append(p)

    ris = []
    for fam, lst in grup.items():
        vinc = [p["netto"] for p in lst if p["netto"] > 0]
        perd = [p["netto"] for p in lst if p["netto"] < 0]
        lordo_v, lordo_p = sum(vinc), -sum(perd)
        pf = (lordo_v / lordo_p) if lordo_p > 0 else None
        date = sorted(p["apertura"] for p in lst)
        simb = defaultdict(float)
        for p in lst:
            simb[p["sym"]] += p["netto"]
        ris.append(dict(
            fam=fam, n=len(lst), netto=sum(p["netto"] for p in lst),
            vinte=len(vinc), perse=len(perd), pf=pf,
            wr=100.0*len(vinc)/len(lst) if lst else 0.0,
            medio=sum(p["netto"] for p in lst)/len(lst),
            best=max(p["netto"] for p in lst), worst=min(p["netto"] for p in lst),
            dal=date[0][:10], al=date[-1][:10],
            simboli=sorted(simb.items(), key=lambda kv: -kv[1]),
        ))
    ris.sort(key=lambda d: -d["netto"])
    return pos, ris, n_in


def scrivi(path, out):
    pos, ris, n_in = analizza(path)
    tot = sum(p["netto"] for p in pos)
    natt = sum(1 for p in pos if p["fam"] is None)
    L = []
    A = L.append
    A(u"# \U0001F3C6 CLASSIFICA DEGLI EA SUL CAMPO — conto **50503392** (demo BCM)")
    A(u"")
    A(u"Fonte: `%s` · **%d posizioni chiuse**, dal **%s** al **%s**."
      % (os.path.basename(path), len(pos),
         min(p["apertura"] for p in pos)[:10], max(p["chiusura"] for p in pos)[:10]))
    A(u"Risultato netto complessivo: **%+.2f EUR** (profitto + swap + commissioni)." % tot)
    A(u"")
    A(u"> ⚠️ **Come sono attribuite**: per il **COMMENTO** dell'affare di apertura, non")
    A(u"> per il magic — nel report MT5 il magic non c'è. Due EA che scrivono lo stesso")
    A(u"> commento finiscono insieme; uno che non commenta finisce fra le non attribuite.")
    A(u"> **Non attribuite: %d posizioni su %d.**" % (natt, len(pos)))
    A(u"")
    A(u"| # | EA (commento) | pos. | **netto EUR** | vinte/perse | win% | PF | medio | migliore | peggiore | periodo |")
    A(u"|---:|---|---:|---:|---:|---:|---:|---:|---:|---:|---|")
    for k, d in enumerate(ris, start=1):
        pf = ("%.2f" % d["pf"]) if d["pf"] is not None else "n/d"
        A(u"| %d | %s | %d | **%+.2f** | %d/%d | %.0f%% | %s | %+.2f | %+.2f | %+.2f | %s -> %s |"
          % (k, d["fam"], d["n"], d["netto"], d["vinte"], d["perse"], d["wr"], pf,
             d["medio"], d["best"], d["worst"], d["dal"], d["al"]))
    A(u"")
    A(u"## \U0001F4CD Dettaglio per simbolo")
    A(u"")
    for d in ris:
        s = " · ".join("%s %+.2f" % (k, v) for k, v in d["simboli"])
        A(u"- **%s** (%d pos.): %s" % (d["fam"], d["n"], s))
    A(u"")
    testo = u"\n".join(L) + u"\n"
    with open(out, "wb") as f:
        f.write(testo.encode("utf-8"))
    print("scritto:", out)
    print("  posizioni: %d | affari 'in' letti: %d | non attribuite: %d"
          % (len(pos), n_in, natt))
    print("  netto totale: %+.2f" % tot)
    return ris


if __name__ == "__main__":
    if len(sys.argv) < 2:
        print(__doc__)
        sys.exit(2)
    src = sys.argv[1]
    dst = sys.argv[2] if len(sys.argv) > 2 else "CLASSIFICA_CAMPO.md"
    scrivi(src, dst)
