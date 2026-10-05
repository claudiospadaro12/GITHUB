import sys, numpy as np
sys.path.insert(0,'/home/user/GITHUB/backtest_pipeline')
import scheda_simbolo as S
S0='/tmp/claude-0/-home-user-GITHUB/c2d73886-9ef2-5105-8937-d770bc36d6df/scratchpad/'
casi=[("D30EUR",S0+"hd_GRX","NY",{"M5":9.2679,"M15":17.0000,"H1":35.4286}),
      ("SPXUSD",S0+"hd_SPX","NY",{"M5":0.8750,"M15":1.5893,"H1":3.4643}),
      ("XAUUSD","/home/user/GITHUB/backtest_pipeline/risultati_prove/oro_m1_histdata_zip","NY",{"M5":2.0761,"M15":3.7575,"H1":7.6206})]
for sim,perc,fuso,rif in casi:
    s=S.carica_serie(sim,"x",fuso,perc)
    S.costruisci(s)
    print(sim,"M1",len(s["t"]),"giorni",len(s["d1"]["st"]))
    for nome,tfm in (("M5",5),("M15",15),("H1",60)):
        b=S.barre_tf(s,tfm)
        a=S.atr_sma(b["o"],b["h"],b["l"],b["c"],14)
        ok=np.isfinite(a)&(b["day"]>=600)
        print("  ",nome,"mio ATR mediano dal giorno 600: %.4f   casa: %.4f   scarto %.2f%%"%(np.median(a[ok]),rif[nome],100*(np.median(a[ok])/rif[nome]-1)))
