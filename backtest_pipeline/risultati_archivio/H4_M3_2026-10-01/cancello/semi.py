# sensibilita' del verdetto della cella che decide al SEME delle 20 estrazioni del controllo B
# (e del bootstrap), con le funzioni dello strumento dell'autore, parametri primari invariati.
import sys, numpy as np
sys.path.insert(0, "/home/user/GITHUB/backtest_pipeline")
import h4_m3_confluenza as T, ema200_rimbalzo as ER
C = "/tmp/claude-0/-home-user-GITHUB/c2d73886-9ef2-5105-8937-d770bc36d6df/scratchpad/cache_m1"
K = int(sys.argv[2]) if len(sys.argv) > 2 else 40
for nome in sys.argv[1].split(","):
    m = ER.carica_dataset(nome, C, "/home/user/GITHUB")
    sp = T.leggi_spread_orario() if nome == "DAX" else None
    P = T.prepara(m, sp, T.SPREAD_FISSO[nome])
    S = T.sistema(m, P, 10, 3.5)
    res = {"long": [], "short": []}
    for s in range(K):
        boot = T.Boot(P["giorno"], seed=777 + s)
        dec = T.analizza(m, P, S, boot, 4242 + 135 + 1000 * (s + 1), "x", "x", [])
        for lato in ("long", "short"):
            d = dec[lato]
            res[lato].append((d["eff"], d["lo"], d["hi"], d["verdetto"]))
    for lato in ("long", "short"):
        e = np.array([x[0] for x in res[lato]])
        vs = [x[3] for x in res[lato]]
        print("%-6s %-5s semi %d  eff media %+.4f [min %+.4f max %+.4f]  lo min %+.3f hi max %+.3f  verdetti: %s" %
              (nome, lato, K, e.mean(), e.min(), e.max(), min(x[1] for x in res[lato]), max(x[2] for x in res[lato]),
               {v: vs.count(v) for v in set(vs)}))
