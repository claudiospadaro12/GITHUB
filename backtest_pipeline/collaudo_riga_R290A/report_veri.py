#!/usr/bin/env python3
# -*- coding: ascii -*-
"""
report_veri.py -- il LETTORE DEL REPORT di PASSATA_STOP_SUPREV_NAS.ps1 (LeggiReport e le sue funzioni) contro REPORT VERI scritti da MT5 (non da noi):
  - risultati_archivio/R109_deal_anomali/D30EUR_00_long_report_singola.htm (passata singola, MT5 italiano, build 6140, UTF-16 LE): 818 operazioni, 1636 affari, -43 608.40 (migliaia con spazio), PF 0.91
  - risultati_archivio/ROUND_CORTI_A_2026-09-28/CCOMM_R258/CCOMM_R258.htm (passata singola GBPUSD M5): 496 operazioni, 992 affari, 16.18, Periodo "M5 (2024.07.05 - 2026.06.30)" = la .ini FromDate/ToDate
Le funzioni sono estratte dallo script con l'AST di PowerShell (nessuna copia a mano) e girate in pwsh. I valori attesi sono letti QUI con regex da Python sul testo decodificato, indipendenti dal lettore.
Controlla anche il CONTRO-ESEMPIO: nel report vero NON c'e' "Total Trades" (e' italiano), quindi il lettore deve trovare l'etichetta italiana; e che le celle degli input (|InpX=v|) siano tutte lette (non una si' e una no).
Uso: python3 report_veri.py   (esce 0 se tutto come atteso)
"""
import os, re, subprocess, sys, tempfile
QD = os.path.dirname(os.path.abspath(__file__))
REPO = os.path.abspath(os.path.join(QD, "..", ".."))
SCR = os.path.join(REPO, "backtest_pipeline", "righe", "PASSATA_STOP_SUPREV_NAS.ps1")
AR = os.path.join(REPO, "backtest_pipeline", "risultati_archivio")
FILES = [os.path.join(AR, "R109_deal_anomali", "D30EUR_00_long_report_singola.htm"), os.path.join(AR, "ROUND_CORTI_A_2026-09-28", "CCOMM_R258", "CCOMM_R258.htm")]


def attese(f):
    b = open(f, "rb").read()
    t = b.decode("utf-16") if b[:2] == b"\xff\xfe" else b.decode("utf-8", "replace")
    tx = re.sub(r"<[^>]+>", "|", t)
    tx = re.sub(r"\s*\|[\s|]*", "|", tx)
    def cella(lab):
        m = re.search(r"\|" + re.escape(lab) + r":\|([^|]*)\|", tx)
        return re.sub(r"\s", "", m.group(1)) if m else None
    inp = {}
    for m in re.finditer(r"\|(Inp\w+)=([^|]*)(?=\|)", tx):
        inp[m.group(1)] = m.group(2).strip()
    return dict(trades=int(cella("Numero di Operazioni di Trading Totali")), deals=int(cella("Affari Totali")), prof=cella("Profitto Totale Netto"), pf=cella("Fattore di Profitto"),
                simbolo=cella("Simbolo"), expert=cella("Expert"), periodo=cella("Periodo"), ninp=len(inp), inp=inp)


PS = r'''
$ErrorActionPreference = 'Stop'
$IC = [Globalization.CultureInfo]::InvariantCulture
$ast = [System.Management.Automation.Language.Parser]::ParseFile($env:SCR_PATH, [ref]$null, [ref]$null)
foreach($nome in @('Dec', 'Leggi-Condiviso', 'CercaCella', 'LeggiReport')){
  $f = $ast.FindAll({ param($a) $a -is [System.Management.Automation.Language.FunctionDefinitionAst] -and $a.Name -eq $nome }, $true) | Select-Object -First 1
  if(-not $f){ throw ('funzione non trovata nello script: ' + $nome) }
  . ([scriptblock]::Create($f.Extent.Text))
}
foreach($p in ($env:REPORTS -split '\|')){
  $r = LeggiReport $p
  'R;' + $p + ';' + $r.Ok + ';' + $r.Trades + ';' + $r.Deals + ';' + $r.Profitto.ToString($IC) + ';' + $r.PF + ';' + $r.Simbolo + ';' + $r.Expert + ';' + $r.Periodo + ';' + $r.Inputs.Count + ';' + $r.Motivo
  foreach($k in ($r.Inputs.Keys | Sort-Object)){ 'I;' + $p + ';' + $k + ';' + $r.Inputs[$k] }
}
'''


def main():
    env = dict(os.environ, SCR_PATH=SCR, REPORTS="|".join(FILES))
    p = subprocess.run(["pwsh", "-NoProfile", "-Command", PS], env=env, capture_output=True, text=True)
    bad = []
    ok = 0
    if p.returncode != 0:
        print(p.stdout, p.stderr)
        return 1
    got = {}
    ginp = {}
    for l in p.stdout.splitlines():
        if l.startswith("R;"):
            c = l.split(";")
            got[c[1]] = c
        elif l.startswith("I;"):
            c = l.split(";", 3)
            ginp.setdefault(c[1], {})[c[2]] = c[3]
    for f in FILES:
        a = attese(f)
        c = got[f]
        att = ["True", str(a["trades"]), str(a["deals"]), a["prof"], a["pf"], a["simbolo"], a["expert"], re.sub(r"\s", "", a["periodo"]), str(a["ninp"]), ""]
        vis = [c[2], c[3], c[4], c[5], c[6], c[7], c[8], re.sub(r"\s", "", c[9]), c[10], c[11]]
        # il profitto: il lettore stampa il decimale invariante, con il segno e senza migliaia
        if vis[3] != att[3]:
            try:
                eq = abs(float(vis[3]) - float(att[3])) < 1e-9
            except ValueError:
                eq = False
            if eq:
                vis[3] = att[3]
        for k, (x, y) in enumerate(zip(vis, att)):
            if x == y:
                ok += 1
            else:
                bad.append("%s campo %d: letto %r, atteso %r" % (os.path.basename(f), k, x, y))
        if ginp.get(f, {}) != a["inp"]:
            bad.append("%s: input riletti %d, attesi %d (%s)" % (os.path.basename(f), len(ginp.get(f, {})), len(a["inp"]), sorted(set(a["inp"]) ^ set(ginp.get(f, {})))[:5]))
        else:
            ok += 1
        print("  %-34s operazioni %s | affari %s | profitto %s | PF %s | %s %s %s | input %s" % (os.path.basename(f), c[3], c[4], c[5], c[6], c[7], c[8], c[9], c[10]))
    print("REPORT VERI R290A: %d controlli verdi, %d rossi" % (ok, len(bad)))
    for b in bad:
        print("   ROSSO", b)
    return 0 if not bad else 1


if __name__ == "__main__":
    sys.exit(main())
