#!/usr/bin/env python3
# -*- coding: utf-8 -*-
# Il modello PowerShell sta in righe/_modello_controllo_14ea_oro.ps1.txt
"""Genera righe/CONTROLLO_14EA_ORO_BCM.ps1: test fuori campione dei 4 EA su oro tra i 14 'Ottimizzati' (criteri CLAU12_14_EA_..._CRITERI).
Legge i valori di DEFAULT degli input dai sorgenti (nessun valore a mano) e li scrive tutti in [TesterInputs]."""
import re, sys, hashlib, subprocess, os
REPO = os.path.abspath(os.path.join(os.path.dirname(__file__), ".."))
EAS = [  # (file, periodo del grafico)
    ("ABTG_SupertrendReversal_Multi_Ottimizzato", "H4"),
    ("ABTG_SupertrendReversal_Ottimizzato", "H4"),
    ("ABTG_EMA200_Ottimizzato", "H4"),
    ("ABTG_GoldenCross_Ottimizzato", "H1"),
]
TF = {"PERIOD_M1": 1, "PERIOD_M5": 5, "PERIOD_M15": 15, "PERIOD_M30": 30, "PERIOD_H1": 16385, "PERIOD_H2": 16386,
      "PERIOD_H4": 16388, "PERIOD_D1": 16408, "PERIOD_W1": 32769, "PERIOD_MN1": 49153, "PERIOD_CURRENT": 0}

def leggi(nome):
    p = os.path.join(REPO, "mql5", "Experts", nome + ".mq5")
    t = open(p, encoding="utf-8", errors="replace").read()
    enums = {}
    for m in re.finditer(r"^\s*enum\s+(\w+)\s*\{([^}]*)\}", t, re.M):
        v = -1
        d = {}
        for part in m.group(2).split(","):
            part = part.strip()
            if not part: continue
            mm = re.match(r"(\w+)\s*(?:=\s*(-?\d+))?", part)
            v = int(mm.group(2)) if mm.group(2) is not None else v + 1
            d[mm.group(1)] = v
        enums[m.group(1)] = d
    allenum = {k: v for d in enums.values() for k, v in d.items()}
    out = []
    for line in t.split("\n"):
        m = re.match(r"^\s*input\s+(\w+)\s+(\w+)\s*=\s*(.+?)\s*;", line)
        if not m: continue
        tipo, nome_i, val = m.groups()
        val = val.strip()
        if tipo == "string":
            sm = re.match(r'^"(.*)"$', val)
            if not sm: sys.exit("stringa non letta: %s %s" % (nome, line))
            v = sm.group(1)
        elif tipo == "bool":
            if val not in ("true", "false"): sys.exit("bool non letto: %s %s" % (nome, line))
            v = val
        elif val in TF:
            v = str(TF[val])
        elif val in allenum:
            v = str(allenum[val])
        elif re.match(r"^-?\d+(\.\d+)?$", val):
            v = val
        else:
            sys.exit("VALORE NON RICONOSCIUTO in %s: %s" % (nome, line.strip()))
        out.append((nome_i, v))
    n_att = len([l for l in t.split("\n") if re.match(r"^\s*input\s+(?!group)\w+\s+\w+\s*=", l)])
    if len(out) != n_att: sys.exit("conteggio input diverso in %s" % nome)
    return out, hashlib.sha256(open(p, "rb").read()).hexdigest().upper()

pin = subprocess.check_output(["git", "-C", REPO, "rev-parse", "HEAD"]).decode().strip()
blocchi = []
for nome, per in EAS:
    inp, sha = leggi(nome)
    righe = ",\n".join("      '%s=%s'" % (a, b.replace("'", "''")) for a, b in inp)
    blocchi.append("  @{ n='%s'; per='%s'; sha='%s'; inp=@(\n%s\n  ) }" % (nome, per, sha, righe))
    print(nome, len(inp), "input", sha[:12], file=sys.stderr)
eas_ps = ",\n".join(blocchi)
modello = open(os.path.join(os.path.dirname(__file__), "righe", "_modello_controllo_14ea_oro.ps1.txt"), encoding="utf-8").read()
s = modello.replace("@@PIN@@", pin).replace("@@EAS@@", eas_ps)
open(os.path.join(os.path.dirname(__file__), "righe", "CONTROLLO_14EA_ORO_BCM.ps1"), "w", encoding="utf-8", newline="").write(s)
print("scritto, pin sorgenti", pin, file=sys.stderr)
