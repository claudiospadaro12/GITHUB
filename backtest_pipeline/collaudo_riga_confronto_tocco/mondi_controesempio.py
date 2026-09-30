#!/usr/bin/env python3
# -*- coding: ascii -*-
"""
mondi_controesempio.py -- RIPRODUCE i numeri del cancello di giudizio del 30/09/2026 (classe 929) sui
quattro mondi sintetici di confronto_tocco_chiusura_m5.py: per ogni mondo, 12 semi x 2 lati = 24 celle,
1400 giorni per cella, range 15, K = 12 surrogati. Stampa, per la regola VECCHIA (pagamento sull'eccesso
sul nullo, coppie E entrate) e per la regola NUOVA (politiche, valore grezzo), quante celle dicono
PAGA / NON_PAGA / INCONCLUSIVO, e il meccanismo (eccesso del falso) vecchio.
Mondi: neg = random walk (H_NIENTE vero); pos = il mondo positivo dell'autotest (barre costruite);
filtro = l'informazione e' nella CHIUSURA (B deve risultare meglio); tocco = l'informazione e' nel
TOCCO (la chiusura non aggiunge niente: B non deve risultare meglio).
Uso: python3 backtest_pipeline/collaudo_riga_confronto_tocco/mondi_controesempio.py [semi]
Non legge nessun file di dati: e' solo sintetico.
"""
import os
import sys

QD = os.path.dirname(os.path.abspath(__file__))
sys.path.insert(0, os.path.abspath(os.path.join(QD, "..")))
import confronto_tocco_chiusura_m5 as C  # noqa: E402


def regola_vecchia(c):
    C._MUT["pagamento_su_eccesso"] = True
    C._MUT["pagamento_coppie"] = True
    try:
        return C.combina(c["vP"], c["vE"], c["obsE"])["pagamento"]
    finally:
        C._MUT.pop("pagamento_su_eccesso", None)
        C._MUT.pop("pagamento_coppie", None)


def main():
    semi = int(sys.argv[1]) if len(sys.argv) > 1 else 12
    cfg = C._cfg_test(["--ranges", "15"])
    for mondo in ("neg", "pos", "filtro", "tocco"):
        vec, nuo, mec = {}, {}, {}
        grezzoE, grezzoP, eccP = [], [], []
        for seme in range(1, semi + 1):
            out = C.simula_mondo(cfg, mondo, 1400, 12, 1000 + seme)
            for lato in (1, -1):
                c = out[lato]
                pv = regola_vecchia(c)
                pn = c["comb"]["pagamento"]
                vec[pv] = vec.get(pv, 0) + 1
                nuo[pn] = nuo.get(pn, 0) + 1
                m = c["vE"]["meccanismo"]
                mec[m] = mec.get(m, 0) + 1
                grezzoE.append(c["obsE"]["dR"])
                grezzoP.append(c["obsP"]["dR"])
                eccP.append(c["vP"]["exR"])
        n = 2 * semi
        print("MONDO %-6s (%d celle)" % (mondo, n))
        print("  B-A grezzo sulle ENTRATE: min %+.3f  max %+.3f | sulle COPPIE: min %+.3f max %+.3f | eccesso "
              "coppie: min %+.3f max %+.3f" % (min(grezzoE), max(grezzoE), min(grezzoP), max(grezzoP),
                                               min(eccP), max(eccP)))
        print("  regola VECCHIA (eccesso, coppie E entrate): %s | meccanismo vecchio: %s" %
              (sorted(vec.items()), sorted(mec.items())))
        print("  regola NUOVA   (politiche, grezzo)        : %s" % sorted(nuo.items()))
    return 0


if __name__ == "__main__":
    sys.exit(main())
