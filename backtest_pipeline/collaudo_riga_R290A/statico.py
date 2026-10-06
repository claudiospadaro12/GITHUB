#!/usr/bin/env python3
# -*- coding: ascii -*-
"""
statico.py -- controlli SENZA PowerShell, contro numeri GIA' SCRITTI DA ALTRI (non contro valori che tornano da soli):
  S1  l'ancora dello script (geometria) coincide, input per input, con la RIGA DEL CSV VERO di r163a a buffer 2253 (IS e OOS), l'unica cella del repo gia' girata a tick con questa geometria;
  S2  il file prova R290a ha la STESSA geometria della cella r163a (le sole differenze ammesse sono elencate e giustificate: magic, commento, Verbose, LogImbuto, finestra, news file/valute, input solo-base);
  S3  G0 (172 operazioni, 4699 di profitto) = somma IS+OOS delle colonne Trades e Profit del CSV di r163a a 2253 (76+96, 1964.39+2734.64), e la tolleranza dello script e' quella del piano;
  S4  i buffer derivati dello script (3003, 3378, 4503) sono celle dell'asse di r163a, e 3378 e' il CENTRO dei sette;
  S5  le soglie dello script (44 / 36 / 34,6 / 2,40 / 2,70 / attese 65-93-188 / 75-172) compaiono nel PIANO nella stessa forma;
  S6  il magic 799810 non e' usato altrove (prove, mql5, report) e il file prova e' ASCII puro;
  S7  il CSV dello spread: 24 ore, TUTTO = somma, e i quattro numeri citati dal piano (spread 1,80 / 2,60 / 2,40 equipesato / 2,70 P95) stanno nel file.
Uso: python3 statico.py   (esce 0 se tutto come atteso)
"""
import csv, os, re, subprocess, sys
from decimal import Decimal as D

QD = os.path.dirname(os.path.abspath(__file__))
REPO = os.path.abspath(os.path.join(QD, "..", ".."))
SCR = open(os.path.join(REPO, "backtest_pipeline", "righe", "PASSATA_STOP_SUPREV_NAS.ps1"), encoding="ascii").read()
PROVA = os.path.join(REPO, "backtest_pipeline", "prove", "R290a_stop_SUPREV_NASUSD_LS_ancora970913.txt")
PIANO = open(os.path.join(REPO, "report", "PIANO_MISURE_CANDIDATI_2026-10-06.md"), encoding="utf-8").read()
DIR = os.path.join(REPO, "backtest_pipeline", "risultati_prove", "dal_vps", "ABTG_SupRev_NAS_H1_Ottimizzato")
bad = []
ok = [0]


def chk(cond, msg):
    if cond:
        ok[0] += 1
    else:
        bad.append(msg)


def num(v):
    return D({"true": "1", "false": "0"}.get(v.lower(), v))


def riga_csv(nome, buf):
    rows = list(csv.DictReader(open(os.path.join(DIR, nome))))
    r = [x for x in rows if x["InpSLBufferPips"] == str(buf)]
    assert len(r) == 1, (nome, buf, len(r))
    return r[0], rows


IS, rows_is = riga_csv("ABTG_SupRev_NAS_H1_Ottimizzato_NASUSD_IS_r163a.csv", 2253)
OOS, rows_oos = riga_csv("ABTG_SupRev_NAS_H1_Ottimizzato_NASUSD_OOS_r163a.csv", 2253)

# ---- S1
m = re.search(r"\$ANCORA\s*=\s*@\((.*?)\)\n\$AVVIO", SCR, re.S)
ancora = re.findall(r"'(Inp[A-Za-z0-9_]+)=([^']*)'", m.group(1))
chk(len(ancora) == 33, "S1 l'ancora ha %d voci invece di 33" % len(ancora))
SOLO_BASE = {"InpVerbose", "InpLogImbuto"}
for k, v in ancora:
    if k in SOLO_BASE:
        chk(k not in IS or k == "InpVerbose", "S1 %s" % k)
        continue
    chk(k in IS, "S1 %s non e' una colonna del CSV di r163a" % k)
    if k in IS:
        chk(num(v) == num(IS[k]) == num(OOS[k]), "S1 %s: script %s, CSV IS %s, OOS %s" % (k, v, IS[k], OOS[k]))
# ---- S2
prova = {}
for l in open(PROVA, encoding="ascii"):
    mm = re.match(r"^(Inp\w+)=(.*)$", l.rstrip("\n"))
    if mm:
        prova[mm.group(1)] = mm.group(2).split("||")[0]
AMMESSE = {"InpMagic", "InpComment", "InpVerbose", "InpLogImbuto", "InpNewsFile", "InpNewsCurrencies", "InpFridayClose", "InpFridayCloseHour"}
for k, v in IS.items():
    if not k.startswith("Inp") or k in AMMESSE:
        continue
    chk(k in prova, "S2 %s manca nel file prova" % k)
    if k in prova:
        try:
            eq = num(prova[k]) == num(v)
        except Exception:
            eq = prova[k] == v
        chk(eq, "S2 %s: prova %s, CSV r163a %s" % (k, prova[k], v))
extra = sorted(set(prova) - set(IS) - AMMESSE)
chk(extra == [], "S2 input della prova non presenti nel CSV e non ammessi: %s" % extra)
chk(prova["InpSLBufferPips"] == "2253" and prova["InpMagic"] == "799810", "S2 buffer/magic della prova")
for k, v in ancora:
    chk(k in prova and prova[k] == v, "S2 ancora %s=%s non e' nel file prova" % (k, v))
# ---- S3
n_is, n_oos = int(IS["Trades"]), int(OOS["Trades"])
p_is, p_oos = D(IS["Profit"]), D(OOS["Profit"])
g0n = int(re.search(r"\$G0_N\s*=\s*(\d+)", SCR).group(1))
g0t = int(re.search(r"\$G0_N_TOL\s*=\s*(\d+)", SCR).group(1))
g0p = D(re.search(r"\$G0_PROF\s*=\s*\[decimal\](\d+)", SCR).group(1))
g0c = D(re.search(r"\$G0_PCT\s*=\s*\[decimal\](\d+)", SCR).group(1))
chk(n_is + n_oos == g0n == 172, "S3 n: CSV %d+%d, script %d" % (n_is, n_oos, g0n))
chk(abs((p_is + p_oos) - g0p) < D("0.05"), "S3 profitto: CSV %s, script %s" % (p_is + p_oos, g0p))
chk(g0t == 3 and g0c == 4, "S3 tolleranze %s / %s" % (g0t, g0c))
chk("172 +/- 3" in PIANO and "4699 +/- 4%" in PIANO, "S3 il piano non scrive 172 +/- 3 e 4699 +/- 4%")
# ---- S4
buf_misura = int(re.search(r"\$BUF_MISURA\s*=\s*(\d+)", SCR).group(1))
deriv = [int(x) for x in re.search(r"\$BUF_DERIV\s*=\s*@\(([^)]*)\)", SCR).group(1).split(",")]
asse = sorted(int(r["InpSLBufferPips"]) for r in rows_is)
chk(buf_misura == 2253 and all(d in asse for d in deriv) and 2253 in asse, "S4 buffer dello script %s non sull'asse di r163a %s" % (deriv, asse))
chk(len(asse) == 7 and asse[3] == 3378 and 3378 in deriv, "S4 il centro dei sette buffer e' %s, non 3378" % asse[3:4])
chk(all(int(r["Trades"]) == 76 for r in rows_is) and all(int(r["Trades"]) == 96 for r in rows_oos), "S4 n invariante lungo l'asse (76/96) non confermato nel CSV")
# ---- S5
def cost(nome):
    return D(re.search(r"\$%s\s*=\s*\[decimal\]([0-9.]+)" % nome, SCR).group(1))
chk(cost("C3_PASSA") == 44 and cost("C3_FRAGILE") == 36 and cost("PAVIMENTO") == D("34.6") and cost("ST_EQUI") == D("2.40") and cost("ST_P95") == D("2.70"), "S5 soglie C3")
for frase in ("PASSA se >= 44", "FRAGILE se 36-44", "NON PASSA se < 36", "stop >= 34,6 idx", "spread equipesato 2,40 e P95 di tutte le ore 2,70", "sotto 65", "93-188", "fra 75 e 172", "13,3 x 2,60"):
    chk(frase in PIANO, "S5 il piano non contiene %r" % frase)
chk("if($m0 -lt 65)" in SCR and "elseif($m0 -lt 93)" in SCR and "elseif($m0 -gt 188)" in SCR, "S5 attese 65/93/188 nello script")
# ---- S6
chk(len(open(PROVA, "rb").read().decode("ascii")) > 1000, "S6 prova ASCII")
r = subprocess.run(["grep", "-rIl", "799810", "--exclude-dir=.git", "--exclude-dir=worktrees", "--exclude-dir=collaudo_riga_R290A", REPO], capture_output=True, text=True).stdout.split()
usi = [p for p in r if not p.endswith("R290a_stop_SUPREV_NASUSD_LS_ancora970913.txt") and "PIANO_MISURE_CANDIDATI" not in p and "PASSATA_STOP_SUPREV_NAS.ps1" not in p and "RIGA_LANCIA_R290A" not in p and "ESITO_COLLAUDO" not in p]
chk(usi == [], "S6 il magic 799810 compare altrove: %s" % usi)
# ---- S7
sp = list(csv.DictReader(open(os.path.join(REPO, "backtest_pipeline", "risultati_archivio", "spread_flotta", "spread_orario_NASUSD.csv"))))
ore = [x for x in sp if x["ora_server"] != "TUTTO"]
tutto = [x for x in sp if x["ora_server"] == "TUTTO"][0]
chk(len(ore) == 24 and sum(int(x["tick_totali"]) for x in ore) == int(tutto["tick_totali"]), "S7 spread: 24 ore / somma")
med = sorted(D(x["mediana_idx"]) for x in ore)
chk(max(med) == D("2.6") and D(tutto["mediana_idx"]) == D("1.8") and D(tutto["p95_idx"]) == D("2.7"), "S7 spread 2,60 (ora peggiore) / 1,80 (TUTTO) / P95 2,70")
chk(abs(sum(D(x["media_idx"]) for x in ore) / 24 - D("2.0")) < D("0.5"), "S7 media oraria")
print("STATICO R290A: %d controlli verdi, %d rossi" % (ok[0], len(bad)))
for b in bad:
    print("   ROSSO", b)
sys.exit(0 if not bad else 1)
