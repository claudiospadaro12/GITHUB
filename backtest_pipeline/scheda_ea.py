#!/usr/bin/env python3
# =====================================================================
#  scheda_ea.py  --  legge un EA e dice cosa sa fare e cosa ha di rotto
# ---------------------------------------------------------------------
#  PERCHE' ESISTE (07/08/2026)
#  Claudio: "puoi creare un agente che trovi i motori in autonomia degli
#  EA che ho, che analizzi tutto?". Questo e' il pezzo che si puo' fare
#  senza MT5: leggere il codice e dire, per ogni EA, cosa contiene.
#
#  Ogni cosa che questo script trova, l'avevamo trovata a mano nei giorni
#  scorsi, una alla volta e in ritardo:
#    - il RETEST che manca negli _Ottimizzato  (scoperto il 07/08, dopo
#      aver detto a Claudio di metterci una configurazione che non poteva
#      eseguire)
#    - il breakeven annidato nella parziale    (20 EA)
#    - la guardia "un trade al giorno" assente (9 EA)
#    - i magic condivisi fra EA diversi
#    - gli EA che non esportano i risultati, quindi non sono testabili
#    - gli EA che non stampano CONFIG IN USO, quindi non sono verificabili
#
#  NON dice se un EA e' buono. Dice cosa contiene. Il giudizio viene dai
#  numeri fuori campione, non dal codice.
#
#  USO:
#    python3 backtest_pipeline/scheda_ea.py                # tutta la flotta
#    python3 backtest_pipeline/scheda_ea.py ABTG_PTE       # un EA solo
#    python3 backtest_pipeline/scheda_ea.py --csv          # tabella per il repo
# =====================================================================
import re, os, sys, glob, io
from collections import defaultdict

DIR = os.path.join(os.path.dirname(os.path.abspath(__file__)), "..", "mql5", "Experts")


def leggi(f):
    return io.open(f, encoding="utf-8", errors="replace").read()


def enum_valori(src, nome_enum):
    """I membri di un enum, nell'ordine in cui sono dichiarati."""
    m = re.search(r"enum\s+" + nome_enum + r"\s*\{(.*?)\}", src, re.S)
    if not m:
        return []
    return re.findall(r"([A-Z][A-Z0-9_]*)\s*=\s*(\d+)", m.group(1))


def inputs(src):
    """Ogni input: nome, tipo, valore di default, commento."""
    out = []
    for m in re.finditer(r"^input\s+(\S+)\s+(\w+)\s*=\s*([^;]+);\s*(?://\s*(.*))?$", src, re.M):
        out.append({
            "tipo": m.group(1), "nome": m.group(2),
            "default": m.group(3).strip(), "commento": (m.group(4) or "").strip(),
        })
    return out


def difetti(src, ins):
    """I difetti gia' pagati almeno una volta. Nomi come nel DA_FARE."""
    d = []

    # E2 - breakeven annidato nel ramo della parziale riuscita
    for m in re.finditer(r"PositionClosePartial", src):
        i = m.start()
        riga = src[src.rfind("\n", 0, i) + 1: src.find("\n", i)]
        if not re.search(r"\bif\s*\(", riga):
            continue                                  # forma "bool x = (...)": gia' corretta
        j = src.find("{", src.find(")", i))
        if j < 0 or j > src.find("\n", i) + 400:
            continue
        liv, k = 0, j
        while k < len(src):
            if src[k] == "{": liv += 1
            elif src[k] == "}":
                liv -= 1
                if liv == 0: break
            k += 1
        blocco = src[j:k + 1]
        if "Breakeven" in blocco or re.search(r"\bnewSL\s*=", blocco):
            d.append("E2 breakeven annidato nella parziale")
            break

    # A4 - guardia "un trade al giorno" dichiarata ma mai chiamata
    if "PH_WAIT_OPEN" in src:
        if "InpOneTradePerDay" in src and "HaGiaOperatoOggi" not in src:
            d.append("A4 guardia un-trade-al-giorno assente")

    # A13 - etichetta che descrive il default invece del valore
    m = re.search(r"input\s+bool\s+InpAllowShort\s*=\s*(\w+);\s*//\s*(.*)", src)
    if m and "SOLO LONG" in m.group(2).upper() and "false =" not in m.group(2):
        d.append("A13 etichetta InpAllowShort fuorviante")

    # lotto: se arrotonda a zero invece che al minimo, il trade sparisce
    if re.search(r"if\s*\(\s*v\s*<\s*mn\s*\)\s*v\s*=\s*0", src) and "MathMax(minLot" not in src:
        d.append("il lotto sotto il minimo diventa 0: il trade sparisce in silenzio")

    return d


def scheda(f):
    src = leggi(f)
    nome = os.path.basename(f)[:-4]
    ins = inputs(src)
    motori = enum_valori(src, "ENUM_ABTG_ENTRY")
    # il magic puo' essere un #define: senza risolverlo, meta' della flotta
    # risulta senza magic e le collisioni non si vedono (07/08).
    #  ⚠️ vince la PRIMA definizione, non l'ultima: quelle in fondo stanno
    #  dentro un #ifndef ed e' il ripiego generico (ABTG_DEF_MAGIC 770001).
    #  Prendendo l'ultima, nove EA d'apertura risultavano con lo stesso
    #  magic e usciva un falso allarme (07/08).
    defines = {}
    for m in re.finditer(r"^\s*#define\s+(\w+)\s+(\d+)", src, re.M):
        if m.group(1) not in defines:
            defines[m.group(1)] = m.group(2)
    magic = None
    for i in ins:
        if i["nome"].lower().endswith("magic"):
            v = i["default"].strip()
            m = re.search(r"\d+", v)
            if m: magic = m.group(0)
            elif v in defines: magic = defines[v]

    head = re.search(r'string head\s*=\s*"([^"]+)"', src)
    colonne = head.group(1).split(",") if head else []

    return {
        "file": nome,
        "magic": magic,
        "n_input": len(ins),
        "motori": [m[0].replace("ABTG_", "") for m in motori],
        "esporta": bool(re.search(r"\bdouble\s+OnTester\s*\(", src)),
        "metriche_prop": "Peggior Giornata" in src,
        "n_colonne": len(colonne),
        "logga_config": "CONFIG IN USO" in src,
        "tf_da_input": bool(re.search(r"input\s+ENUM_TIMEFRAMES\s+InpTF\b", src)),
        "usa_tf_grafico": "PERIOD_CURRENT" in src,
        "difetti": difetti(src, ins),
        "inputs": ins,
    }


def main():
    argv = [a for a in sys.argv[1:] if not a.startswith("--")]
    solo_csv = "--csv" in sys.argv
    files = sorted(glob.glob(os.path.join(DIR, "*.mq5")))
    if argv:
        files = [f for f in files if argv[0].lower() in os.path.basename(f).lower()]
        if not files:
            print("Nessun EA con '%s' nel nome." % argv[0]); return 1

    schede = [scheda(f) for f in files]

    if solo_csv:
        print("ea;magic;input;motori;esporta;metriche_prop;logga_config;difetti")
        for s in schede:
            print("%s;%s;%d;%s;%s;%s;%s;%s" % (
                s["file"], s["magic"] or "", s["n_input"], "|".join(s["motori"]),
                "si" if s["esporta"] else "no", "si" if s["metriche_prop"] else "no",
                "si" if s["logga_config"] else "no", "|".join(s["difetti"])))
        return 0

    # --- una scheda sola: dettaglio ---
    if len(schede) == 1:
        s = schede[0]
        print("=" * 70)
        print(" %s" % s["file"])
        print("=" * 70)
        print("  magic          : %s" % (s["magic"] or "?"))
        print("  input          : %d" % s["n_input"])
        print("  motori         : %s" % (", ".join(s["motori"]) if s["motori"] else "(non usa ENUM_ABTG_ENTRY)"))
        print("  esporta i pass : %s" % ("si, %d colonne" % s["n_colonne"] if s["esporta"] else "NO -> non testabile con la pipeline"))
        print("  metriche prop  : %s" % ("si" if s["metriche_prop"] else "NO -> manca 'Peggior Giornata %'"))
        print("  CONFIG IN USO  : %s" % ("si" if s["logga_config"] else "NO -> non verificabile dal log"))
        if s["tf_da_input"]:
            print("  timeframe      : da InpTF (il TF del grafico NON conta)")
        elif s["usa_tf_grafico"]:
            print("  timeframe      : usa PERIOD_CURRENT -> il TF del GRAFICO conta")
        if s["difetti"]:
            print("\n  DIFETTI:")
            for d in s["difetti"]: print("     - %s" % d)
        else:
            print("\n  nessuno dei difetti noti")
        print("\n  input ottimizzabili (esclusi string):")
        for i in s["inputs"]:
            if i["tipo"] == "string": continue
            print("     %-22s %-22s %s" % (i["nome"], i["default"][:20], i["commento"][:40]))
        return 0

    # --- tutta la flotta: riepilogo ---
    print("=" * 92)
    print(" SCHEDA DELLA FLOTTA - %d EA" % len(schede))
    print("=" * 92)
    print("%-44s %-8s %4s %-5s %-5s %-5s %s" % ("EA", "magic", "inp", "esp", "prop", "log", "difetti"))
    for s in sorted(schede, key=lambda z: (not z["difetti"], z["file"])):
        print("%-44s %-8s %4d %-5s %-5s %-5s %s" % (
            s["file"][:44], s["magic"] or "-", s["n_input"],
            "si" if s["esporta"] else "NO", "si" if s["metriche_prop"] else "no",
            "si" if s["logga_config"] else "no",
            "; ".join(s["difetti"])[:30]))

    print("\n" + "=" * 92)
    print(" RIEPILOGO")
    print("=" * 92)
    tot = len(schede)
    def q(k): return sum(1 for s in schede if s[k])
    print("  esportano i risultati (testabili) : %3d su %d" % (q("esporta"), tot))
    print("  hanno le metriche da prop         : %3d su %d" % (q("metriche_prop"), tot))
    print("  stampano CONFIG IN USO            : %3d su %d" % (q("logga_config"), tot))
    condif = [s for s in schede if s["difetti"]]
    print("  con almeno un difetto noto        : %3d su %d" % (len(condif), tot))

    # magic condivisi: due EA con lo stesso magic non sono distinguibili nello storico
    permagic = defaultdict(list)
    for s in schede:
        if s["magic"]: permagic[s["magic"]].append(s["file"])
    doppi = {k: v for k, v in permagic.items() if len(v) > 1}
    if doppi:
        print("\n  MAGIC CONDIVISI (nello storico questi trade non si distinguono):")
        for k, v in sorted(doppi.items()):
            print("     %-10s %s" % (k, ", ".join(v)))

    # chi ha il RETEST e chi no: e' l'errore del 07/08
    conretest = [s["file"] for s in schede if "RETEST" in s["motori"]]
    senza = [s["file"] for s in schede if s["motori"] and "RETEST" not in s["motori"]]
    if senza:
        print("\n  HANNO ENUM_ABTG_ENTRY MA SENZA IL MOTORE RETEST:")
        for f in senza: print("     %s" % f)
        print("     (il 07/08 avevo detto a Claudio di mettere il candidato RETEST")
        print("      su uno di questi. Non poteva eseguirlo.)")
    return 0


if __name__ == "__main__":
    sys.exit(main())
