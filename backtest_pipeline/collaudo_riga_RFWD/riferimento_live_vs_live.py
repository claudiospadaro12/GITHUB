#!/usr/bin/env python3
# -*- coding: ascii -*-
"""
riferimento_live_vs_live.py -- QUANTO SI RIPRODUCONO DUE FEED VIVI (BCM demo contro FTMO), prima di guardare il tester.

I giorni 22-24/09/2026 le stesse sedie hanno girato SIA su FTMO (xlsx) SIA sui demo BCM (data/statements/trades_100k.csv e
trades_auto.csv, export automatici del 24 e 29/09). E' l'unico dato che abbiamo del "rumore fra due feed con lo stesso codice":
NON e' tester, quindi non e' un numero dei round; serve a tarare le TOLLERANZE e a dire che cosa e' RAGIONEVOLE aspettarsi.
Limiti dichiarati: il piccolo 50503392 era spento dal 23/09 19:35 al 29/09 (misura del 29/09), il 100k ha il file fermo al 24/09;
quindi la sovrapposizione utile e' 22/09 (piccolo + 100k) e 24/09 (100k); il 23/09 non ha operazioni ne' di qua ne' di la'.

Uso: python3 backtest_pipeline/collaudo_riga_RFWD/riferimento_live_vs_live.py
"""
import csv, datetime, os, sys
QD = os.path.dirname(os.path.abspath(__file__))
REPO = os.path.abspath(os.path.join(QD, "..", ".."))
sys.path.insert(0, os.path.join(REPO, "backtest_pipeline"))
import confronto_forward_tester as CF

GIORNI = {datetime.date(2026, 9, 22), datetime.date(2026, 9, 23), datetime.date(2026, 9, 24)}
SEDIE_OK = {"770101": "DAX", "770411": "DAX", "771531": "US30"}


def bcm_live():
    viste, out = set(), []
    for fn in ("data/statements/trades_100k.csv", "data/statements/trades_auto.csv"):
        for r in csv.DictReader(open(os.path.join(REPO, fn)), delimiter=";"):
            if r["magic"] not in SEDIE_OK:
                continue
            k = (r["magic"], r["open_time"], r["side"])
            if k in viste:
                continue                       # lo stesso setup su due conti BCM: una posizione
            viste.add(k)
            t = CF.dt_parse(r["close_time"])
            if t.date() in GIORNI:
                out.append(dict(sedia=r["magic"], dir=("L" if r["side"] == "buy" else "S"), t=t, p=float(r["close_price"]),
                                vol=float(r["volume"]), aperta=CF.dt_parse(r["open_time"]), p_ap=float(r["open_price"]), file=fn))
    return out


def main():
    fw = CF.parse_forward(CF.leggi_xlsx(os.path.join(REPO, "data/statements/FTMO_541452707_cronistorico_2026-09-30.xlsx")))
    Fp, _m, _n = CF.posizioni_forward(fw, 2, CF.COSTANTI["SALDO_INIZIALE"])
    B = bcm_live()
    print("BCM live (posizioni distinte 22-24/09 delle sedie in comune): %d" % len(B))
    tot_f = l1 = l2 = 0
    dprezzi, dtempi = [], []
    per_fam = {}
    for sid, fam in SEDIE_OK.items():
        F = [f for f in Fp if f["sedia"] == sid and f["t"].date() in GIORNI]
        T = [b for b in B if b["sedia"] == sid]
        ab = CF.abbina(F, T, CF.COSTANTI["TOL_TEMPO_STRETTA_MIN"], CF.COSTANTI[CF.FAMIGLIA_TOL[fam]])
        print("sedia %s: FTMO %d posizioni, BCM live %d" % (sid, len(F), len(T)))
        for (i, j, lv, nota) in ab["coppie"]:
            f, t = F[i], T[j]
            dtempi.append(abs((f["t"] - t["t"]).total_seconds()))
            dprezzi.append(abs(f["p"] - t["p"]))
            per_fam.setdefault(fam, []).append(abs(f["p"] - t["p"]))
            print("   %s FTMO uscita %s p=%.2f | BCM live uscita %s p=%.2f | dt %+.0f s, dprezzo %+.2f  (ingresso BCM %s FTMO %s)" %
                  (lv, CF.fmt_dt(f["t"]), f["p"], CF.fmt_dt(t["t"]), t["p"], (t["t"] - f["t"]).total_seconds(), t["p"] - f["p"],
                   t["aperta"].strftime("%H:%M:%S"), f["t_open_bcm"].strftime("%H:%M:%S")))
        for i in ab["f_solo"]:
            print("   FTMO SENZA gemello BCM live: %s %s" % (CF.fmt_dt(F[i]["t"]), F[i]["dir"]))
        for j in ab["t_solo"]:
            print("   BCM live SENZA gemello FTMO: %s %s (aperta %s)" % (CF.fmt_dt(T[j]["t"]), T[j]["dir"], T[j]["aperta"].strftime("%H:%M:%S")))
        tot_f += len(F)
        l1 += sum(1 for c in ab["coppie"] if c[2] == "L1")
        l2 += len(ab["coppie"])
    print("RIFERIMENTO LIVE-VS-LIVE: posizioni FTMO confrontabili %d, L1 %d, L1+L2 %d; scarto massimo di uscita %.0f s, scarto massimo di prezzo %.2f punti" %
          (tot_f, l1, l2, max(dtempi) if dtempi else 0, max(dprezzi) if dprezzi else 0))
    for fam, v in sorted(per_fam.items()):
        print("  famiglia %s: scarti di prezzo in uscita %s punti (massimo %.2f)" % (fam, ", ".join("%.2f" % x for x in v), max(v)))


if __name__ == "__main__":
    main()
